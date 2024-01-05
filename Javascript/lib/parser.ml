(** Copyright 2023, Kuarni, AlexShmak *)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Angstrom
open Ast

type error = [ `ParsingError of string ]

let chars2string chars = List.fold_left (fun a b -> a ^ Char.escaped b) "" chars
let nothing = return ()

let is_space = function
  | ' ' | '\t' -> true
  | _ -> false
;;

let is_line_break = function
  | '\n' | '\r' -> true
  | _ -> false
;;

let is_empty ch = is_space ch || is_line_break ch

let is_lower = function
  | 'a' .. 'z' -> true
  | _ -> false
;;

let is_upper = function
  | 'A' .. 'Z' -> true
  | _ -> false
;;

let is_letter ch = is_lower ch || is_upper ch

let is_digit = function
  | '0' .. '9' -> true
  | _ -> false
;;

let is_end = function
  | ';' -> true
  | _ -> false
;;

let keywords =
  [ "let"; "var"; "const"; "function"; "if"; "return"; "else"; "while"; "for" ]
;;

let is_string_sign = function
  | '\"' | '\'' -> true
  | _ -> false
;;

let is_keyword ch = List.mem ch keywords

let rec return_eq_element el_for_comp trans = function
  | a :: tail ->
    if el_for_comp = trans a then Some a else return_eq_element el_for_comp trans tail
  | _ -> None
;;

let is_spec_symbol = function
  | '$' | '_' -> true
  | _ -> false
;;

let is_valid_first_identifier_ch ch = is_letter ch || is_spec_symbol ch
let is_valid_identifier_ch ch = is_valid_first_identifier_ch ch || is_digit ch
let read_word = take_while is_valid_identifier_ch
let empty = skip_while is_empty
let empty1 = take_while1 is_empty *> return ()
let spaces = skip_while is_space
let token_space p = spaces *> p
let token p = empty *> p
let token1 p = empty1 *> p
let token_ch ch = token @@ (char ch *> return ())
let token_str s = token @@ string s
let between p l r = l *> p <* r
let lp = token_ch '('
let rp = token_ch ')'
let lc = token_ch '{'
let rc = token_ch '}'
let ls = token_ch '['
let rs = token_ch ']'
let parens p = between p lp rp
let cur_parens p = between p lc rc
let sq_parens p = between p ls rs
let empty_stm = empty *> end_of_input <|> skip is_end
let to_end_of_stm = empty_stm <|> empty
let space_both_sides p = spaces *> p <* spaces
let some n = Some n
let number n = Number n
let const c = Const c
let var v = Var v
let expression e = Expression e
let array_list array = Array_list array

let parse_number =
  lift3 (fun a b c -> a ^ b ^ c) (take_while is_digit) (string ".") (take_while is_digit)
  <|> take_while1 is_digit
  >>= (function
         | "." -> fail "incorrect number"
         | _ as num -> return num)
  >>| fun n -> number @@ float_of_string n
;;

(*TODO: -,NaN..., BigINT*)

let parse_str =
  satisfy is_string_sign
  *> scan_string false (fun state ch ->
    if state
    then Some false
    else if is_string_sign ch
    then None
    else (
      match ch with
      | '\\' -> Some true
      | _ -> Some false))
  >>| (fun s -> String s)
  <* satisfy is_string_sign
;;

let valid_identifier =
  token
  @@ lift2
       ( ^ )
       (satisfy is_valid_first_identifier_ch
        >>| Char.escaped
        <?> "invalid first char of var name")
       (fix (fun self ->
          lift2 ( ^ ) (satisfy is_valid_identifier_ch >>| Char.escaped) self <|> return "")
        <?> "invalid chars of var name")
  >>= fun name ->
  if is_keyword name
  then fail "name of identifier shouldn't be a keyword"
  else return name
;;

let parse_empty_stms = many empty_stm

let parse_args_names =
  parens (sep_by (token_str ",") valid_identifier) <?> "incorrect function arguments"
;;

(*----------unary operators----------*)

let pre_un_op = [ "+", Plus; "-", Minus ] (*precedence 14*)

(*----------bin operators----------*)

let mul_div_rem_op = [ "*", Mul; "/", Div ] (*precedence 12*)
let add_sub_op = [ "+", Add; "-", Sub ] (*precedence 11*)
let equality_op = [ "==", Equal; "!=", NotEqual ] (*precedence 8*)
let list_of_bops = [ equality_op; add_sub_op; mul_div_rem_op ]
(*from lower to greater precedence*)

let parse_op ops = choice (List.map (fun (js_op, op) -> string js_op *> return op) ops)

let chainl1 parser op =
  let rec go acc =
    token op
    >>| (fun op -> Some op)
    <|> return None
    >>= function
    | Some f -> parser >>| (fun x -> BinOp (f, acc, x)) >>= go
    | _ -> return acc
  in
  parser >>= fun init -> go init
;;

(*----------expression parsers----------*)

let rec parse_arguments () =
  parens (sep_by (token_str ",") (start_parse_expression ()))
  <?> "incorrect function arguments"

and parse_arrow_func () =
  token parse_args_names
  >>= fun args ->
  token_str "=>"
  *> token
       (cur_parens (many @@ parse_stm ())
        >>| (fun stms -> Block stms)
        <|> (start_parse_expression () >>| fun exp -> Block [ Return exp ]))
  >>| fun body -> AnonFunction (args, body)

and parse_anon_func () =
  token_str "function" *> token parse_args_names
  >>= fun args ->
  parse_block_or_stm () <* to_end_of_stm >>| fun body -> AnonFunction (args, body)

and parse_func_call () =
  lift2
    (fun f args -> FunctionCall (f, args))
    (choice
       [ valid_identifier >>| var
       ; parse_anon_func ()
       ; parens @@ start_parse_expression ()
       ])
    (parse_arguments ())

and parse_bop = function
  | a :: b -> chainl1 (parse_bop b) (parse_op a)
  | _ -> parse_pre_uop ()

and parse_pre_uop () =
  token @@ parse_op pre_un_op
  >>| (fun op -> Some op)
  <|> return None
  >>= function
  | Some op -> parse_pre_uop () >>| fun ex -> UnOp (op, ex)
  | _ -> parse_mini_expression ()

and array_parser () =
  token @@ sq_parens (sep_by (char ',') (space_both_sides (start_parse_expression ())))
  <?> "incorrect array expression"

and parse_mini_expression () =
  token
    (choice
       [ parse_arrow_func ()
       ; parse_func_call ()
       ; parens @@ start_parse_expression ()
       ; parse_anon_func ()
       ; parse_number >>| const
       ; parse_str >>| const
       ; valid_identifier >>| var
       ; array_parser () >>| array_list
       ])
  <?> "invalid part of expression"

and start_parse_expression () =
  fix (fun _ -> parse_bop list_of_bops <* empty) <?> "incorrect expression"

(*----------statement parsers----------*)

and parse_return () = start_parse_expression () >>| (fun c -> Return c) <* to_end_of_stm

and parse_func () =
  valid_identifier
  >>= fun name ->
  token parse_args_names
  >>= fun arguments ->
  parse_block_or_stm ()
  <* to_end_of_stm
  >>| fun body -> FunDeck { fun_identifier = name; arguments; body }

and parse_var (init_word : string) =
  valid_identifier
  >>= fun identifier ->
  option false (token_str "=" *> return true)
  >>= (function
         | true -> start_parse_expression () >>| some
         | _ -> return None)
  <* to_end_of_stm
  >>| fun expr ->
  VarDeck { var_identifier = identifier; is_const = init_word = "const"; value = expr }

and parse_block_or_stm () =
  cur_parens (many @@ parse_stm ())
  <|> (parse_stm () >>| fun stm -> [ stm ])
  >>| fun stms -> Block stms

and parse_if () =
  parens (start_parse_expression ())
  >>= fun condition ->
  parse_block_or_stm ()
  <?> "invalid then statement"
  >>= fun then_stm ->
  token_str "else" *> token1 (parse_block_or_stm ())
  <?> "invalid else statement"
  <|> return (Block [])
  >>| fun else_stm -> If (condition, then_stm, else_stm)

and parse_while () =
  token @@ parens (start_parse_expression ())
  <?> "invalid while loop condition"
  >>= fun condition ->
  parse_block_or_stm ()
  <?> "invalid while loop body"
  >>| fun body -> While (condition, body)

and parse_for () =
  let parse_for_loop_condition () =
    parens (sep_by (char ';') (space_both_sides (start_parse_expression ())))
    <?> "invalid for loop condition"
  in
  let parse_for_loop_body () = parse_block_or_stm () <?> "invalid for loop body" in
  parse_for_loop_condition ()
  >>= fun condition -> parse_for_loop_body () >>| fun body -> For (condition, body)

and parse_stm () =
  parse_empty_stms
  *> token
       (start_parse_expression ()
        >>| expression
        <|> (read_word
             >>= fun word ->
             match word with
             | "let" | "const" | "var" ->
               token1 @@ parse_var word <?> "wrong var statement"
             | "function" -> token1 @@ parse_func () <?> "wrong function statement"
             | "if" -> token1 @@ parse_if () <?> "wrong if statement"
             | "return" -> token (parse_return ()) <?> "wrong return statement"
             | "while" -> token1 @@ parse_while () <?> "wrong while statement"
             | "for" -> token1 @@ parse_for () <?> "wrong for statement"
             | "" ->
               peek_char_fail
               >>= fun ch ->
               fail @@ "there is unexpected symbol: '" ^ Char.escaped ch ^ "'"
             | _ -> fail @@ "there is an invalid keyword: \"" ^ word ^ "\""))
  <* empty
  <?> "incorrect statement"

and parse_statements stopper = many_till (parse_stm ()) stopper

let parse_programm = parse_statements end_of_input >>| fun c -> Programm c

let parse_str ?(parser = parse_programm) str =
  match Angstrom.parse_string parser ~consume:Angstrom.Consume.All str with
  | Result.Ok x -> Result.Ok x
  | Error er -> Result.Error (`ParsingError er)
;;

let parse str = parse_str ~parser:parse_programm str

let parse_expression str =
  parse_str ~parser:(start_parse_expression () >>| fun e -> Expression e) str
;;
