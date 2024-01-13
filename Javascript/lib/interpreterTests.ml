(** Copyright 2023, Kuarni, AlexShmak *)

(** SPDX-License-Identifier: LGPL-3.0-or-later *)

open Javascript_lib
open Print

(**---------------Return test---------------*)

let%expect_test _ =
  print_return "return 4";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return 4; return 5;";
  [%expect {| Programm return: 4 |}]
;;

(**---------------Expressions tests---------------*)

(*number plus*)

let%expect_test _ =
  print_return "return 4+5";
  [%expect {| Programm return: 9 |}]
;;

let%expect_test _ =
  print_return "return 4+5+6";
  [%expect {| Programm return: 15 |}]
;;

let%expect_test _ =
  print_return "return 4+null";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return 4+undefined";
  [%expect {| Programm return: NaN |}]
;;

let%expect_test _ =
  print_return "return 4+true";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "return false+4.5";
  [%expect {| Programm return: 4.5 |}]
;;

(*string plus*)
let%expect_test _ =
  print_return "return 4+\"5\"";
  [%expect {| Programm return: 45 |}]
;;

let%expect_test _ =
  print_return "return \"\"+true";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return \"\"+null";
  [%expect {| Programm return: null |}]
;;

let%expect_test _ =
  print_return "return \"\"+undefined";
  [%expect {| Programm return: undefined |}]
;;

let%expect_test _ =
  print_return "return \"\"+\"str\"";
  [%expect {| Programm return: str |}]
;;

(*subtract mixed*)
let%expect_test _ =
  print_return "return 2-1";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return 1-2";
  [%expect {| Programm return: -1 |}]
;;

let%expect_test _ =
  print_return "return 2-'1'";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return '2'-1";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return 10 -true";
  [%expect {| Programm return: 9 |}]
;;

let%expect_test _ =
  print_return "return 10 - 'true'";
  [%expect {| Programm return: NaN |}]
;;

let%expect_test _ =
  print_return "return 10- false";
  [%expect {| Programm return: 10 |}]
;;

let%expect_test _ =
  print_return "return true -  11";
  [%expect {| Programm return: -10 |}]
;;

(*multiplication*)
let%expect_test _ =
  print_return "return 3*4";
  [%expect {| Programm return: 12 |}]
;;

let%expect_test _ =
  print_return "return -3*4";
  [%expect {| Programm return: -12 |}]
;;

let%expect_test _ =
  print_return "return '3' *'2'";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "return '3' * 2";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "return 3 * '2'";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "return 'string' * 'string'";
  [%expect {| Programm return: NaN |}]
;;

let%expect_test _ =
  print_return "return 2 * 'string'";
  [%expect {| Programm return: NaN |}]
;;

let%expect_test _ =
  print_return "return true * 5";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "return false * 5";
  [%expect {| Programm return: 0 |}]
;;

(*division*)
let%expect_test _ =
  print_return "return 12 / 2";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "return 3 / 2";
  [%expect {| Programm return: 1.5 |}]
;;

let%expect_test _ =
  print_return "return 6 / '3'";
  [%expect {| Programm return: 2 |}]
;;

let%expect_test _ =
  print_return "return 2 / 0";
  [%expect {| Programm return: Infinity |}]
;;

let%expect_test _ =
  print_return "return 2 / 'foo'";
  [%expect {| Programm return: NaN |}]
;;

(*equal*)
let%expect_test _ =
  print_return "return null == undefined";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 2 == 2";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 2 == 3";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return true == 1";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null == 'test'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return 1 == '1'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return +0 == -0";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 'f' == 'f'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 'f' == 'F'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "const a = 4;\n      return a == 4";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null == 0";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null == NaN";
  [%expect {| Programm return: false |}]
;;

(*not_equal*)

let%expect_test _ =
  print_return "return 2!= 3";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 2!= 2";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return true!= 1";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null!= 'test'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null != 0";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 'test'!= 'test'";
  [%expect {| Programm return: false |}]
;;

(*strict equal*)
let%expect_test _ =
  print_return "return 4 === 4";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 'foo' === 'foo'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return true === 'true'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return true === 1";
  [%expect {| Programm return: false |}]
;;

(*strict not_equal*)
let%expect_test _ =
  print_return "return 4 !== 3";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 1 !== '1'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 'foo' !== 'foo'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return true !== false";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return true !== 'true'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return false !== 0";
  [%expect {| Programm return: true |}]
;;

(*remainder*)
let%expect_test _ =
  print_return "return 10 % 5";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return 1 % 5";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return 11 % 5";
  [%expect {| Programm return: 1 |}]
;;

(*exponentiation*)
let%expect_test _ =
  print_return "return 2 ** 2";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return 12 ** 2";
  [%expect {| Programm return: 144 |}]
;;

let%expect_test _ =
  print_return "return 25 ** 0.5";
  [%expect {| Programm return: 5 |}]
;;

(*greater*)
let%expect_test _ =
  print_return "return 4 > 3";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 4 > 4";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return 4 > '4'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return '4' > 4";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return \"aa\" > \"ab\"";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null > 0";
  [%expect {| Programm return: false |}]
;;

(*greater_equal*)
let%expect_test _ =
  print_return "return 4 >= 3";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 4 >= 4";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return 4 >= '4'";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return '4' >= 4";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return \"aa\" >= \"ab\"";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null >= 0";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null >= 'test'";
  [%expect {| Programm return: false |}]
;;

(*less*)
let%expect_test _ =
  print_return "return 4 < 3";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return 4 < 4";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return 4 < '4'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return '4' < 4";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return \"aa\" < \"ab\"";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null < 0";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return NaN < NaN";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return NaN < NaN";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null < NaN";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return NaN < 1";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return 'test' < NaN";
  [%expect {| Programm return: false |}]
;;

(*less_equal*)
let%expect_test _ =
  print_return "return 4 <= 3";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return 4 <= 4";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return \"aa\" <= \"ab\"";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null <= 0";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null <= 'test'";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null <= undefined";
  [%expect {| Programm return: false |}]
;;

(*left shift*)
let%expect_test _ =
  print_return "return 5 << 2";
  [%expect {| Programm return: 20 |}]
;;

let%expect_test _ =
  print_return "return 5 << 3";
  [%expect {| Programm return: 40 |}]
;;

let%expect_test _ =
  print_return "return 3 << 3";
  [%expect {| Programm return: 24 |}]
;;

let%expect_test _ =
  print_return "return 3 << -3";
  [%expect {| Programm return: 1610612736 |}]
;;

(*right shift*)

let%expect_test _ =
  print_return "return 5 >> 2";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return 5 >> 3";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return 3 >> 3";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return -9 >> 2";
  [%expect {| Programm return: -3 |}]
;;

(*unsigned right shift*)
let%expect_test _ =
  print_return "return 5 >>> 2";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return 5 >>> 3";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return -3 >>> 3";
  [%expect {| Programm return: 536870911 |}]
;;

let%expect_test _ =
  print_return "return -5 >>> 2";
  [%expect {| Programm return: 1073741822 |}]
;;

let%expect_test _ =
  print_return "return -10 >>> 1";
  [%expect {| Programm return: 2147483643 |}]
;;

let%expect_test _ =
  print_return "return -10 >>> -1";
  [%expect {| Programm return: 1 |}]
;;

(*bitwise AND*)
let%expect_test _ =
  print_return "return 5 & 3";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return -5 & 3";
  [%expect {| Programm return: 3 |}]
;;

let%expect_test _ =
  print_return "return 5 & -3";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "return -5 & -3";
  [%expect {| Programm return: -7 |}]
;;

let%expect_test _ =
  print_return "return 5 & 0";
  [%expect {| Programm return: 0 |}]
;;

(*bitwise OR*)
let%expect_test _ =
  print_return "return 5 | 3";
  [%expect {| Programm return: 7 |}]
;;

let%expect_test _ =
  print_return "return -5 | 3";
  [%expect {| Programm return: -5 |}]
;;

let%expect_test _ =
  print_return "return 5 | -3";
  [%expect {| Programm return: -3 |}]
;;

let%expect_test _ =
  print_return "return -5 | -3";
  [%expect {| Programm return: -1 |}]
;;

let%expect_test _ =
  print_return "return 5 | 0";
  [%expect {| Programm return: 5 |}]
;;

(*bitwise XOR*)
let%expect_test _ =
  print_return "return 5 ^ 3";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "return -5 ^ 3";
  [%expect {| Programm return: -8 |}]
;;

let%expect_test _ =
  print_return "return 5 ^ -3";
  [%expect {| Programm return: -8 |}]
;;

let%expect_test _ =
  print_return "return -5 ^ -3";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "return 5 ^ 0";
  [%expect {| Programm return: 5 |}]
;;

(*logical AND*)
let%expect_test _ =
  print_return "return false && true";
  [%expect {| Programm return: false |}]
;;

let%expect_test _ =
  print_return "return null && true";
  [%expect {| Programm return: null |}]
;;

let%expect_test _ =
  print_return "return NaN && true";
  [%expect {| Programm return: NaN |}]
;;

let%expect_test _ =
  print_return "return 0 && true ";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return \"\" && true ";
  [%expect {| Programm return: |}]
;;

let%expect_test _ =
  print_return "return '' && true ";
  [%expect {| Programm return: |}]
;;

let%expect_test _ =
  print_return "return undefined && true ";
  [%expect {| Programm return: undefined |}]
;;

let%expect_test _ =
  print_return "return 2 && 0 ";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return \"foo\" && 4 ";
  [%expect {| Programm return: 4 |}]
;;

(*logical OR*)
let%expect_test _ =
  print_return "return false || true";
  [%expect {| Programm return: true |}]
;;

let%expect_test _ =
  print_return "return null || 0";
  [%expect {| Programm return: 0 |}]
;;

let%expect_test _ =
  print_return "return 1 || true";
  [%expect {| Programm return: 1 |}]
;;

let%expect_test _ =
  print_return "return undefined || false ";
  [%expect {| Programm return: false |}]
;;

(*unary operators*)

let%expect_test _ =
  print_return "return +4";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return -4";
  [%expect {| Programm return: -4 |}]
;;

let%expect_test _ =
  print_return "return -(-4)";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return -\"j\"";
  [%expect {| Programm return: NaN |}]
;;

let%expect_test _ =
  print_return "return +\"j\"";
  [%expect {| Programm return: NaN |}]
;;

(*infinity*)
let%expect_test _ =
  print_return "return Infinity";
  [%expect {| Programm return: Infinity |}]
;;

let%expect_test _ =
  print_return "return -Infinity";
  [%expect {| Programm return: -Infinity |}]
;;

(**---------------Var tests---------------*)

let%expect_test _ =
  print_return "let a = 4; return a";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "let a = 4+5; return a";
  [%expect {| Programm return: 9 |}]
;;

let%expect_test _ =
  print_return "let a = 4; let a = 5; return a";
  [%expect
    {| Error: Interpreter error > SyntaxError: Identifier 'a' has already been declared |}]
;;

let%expect_test _ =
  print_return "return a";
  [%expect
    {| Error: Interpreter error > error in return expression > ReferenceError: Cannot access 'a' before initialization |}]
;;

let%expect_test _ =
  print_return "let a; return a";
  [%expect {| Programm return: undefined |}]
;;

(*Block tests*)

let%expect_test _ =
  print_return "{ let a; }";
  [%expect {| Programm return: undefined |}]
;;

let%expect_test _ =
  print_return "{ let a = 4; } return a";
  [%expect
    {| Error: Interpreter error > error in return expression > ReferenceError: Cannot access 'a' before initialization |}]
;;

let%expect_test _ =
  print_return "{ let a = 4; return a} ";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "let a = 4; { let a = 5; return a} ";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "let a = 4; { return a} ";
  [%expect {| Programm return: 4 |}]
;;

(*function test*)

let%expect_test _ =
  print_return "function a() {return 5;}; return a()";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "function a(b) {return b;}; return a(7)";
  [%expect {| Programm return: 7 |}]
;;

let%expect_test _ =
  print_return "function a(b, c) {return b+c;}; return a(7, 8)";
  [%expect {| Programm return: 15 |}]
;;

let%expect_test _ =
  print_return "function a() {return 4;}; return a(7, 8)";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "function a(j) {return j;}; return a()";
  [%expect {| Programm return: undefined |}]
;;

let%expect_test _ =
  print_return "return a(); function a() {return 4;}";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return a; function a() {}";
  [%expect {| Programm return: [Function: a] |}]
;;

let%expect_test _ =
  print_return "let a = 6; function b() {return a;}; return b()";
  [%expect {| Programm return: 6 |}]
;;

let%expect_test _ =
  print_return "let a = b; function b() {return 10;}; return a()";
  [%expect {| Programm return: 10 |}]
;;

let%expect_test _ =
  print_return "let a = 4; function b() {let a = 8; return a;}; return b()";
  [%expect {| Programm return: 8 |}]
;;

(*anon function*)

let%expect_test _ =
  print_return "let a = function (b){\n    return b;\n  }; return a(4)";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "let a = function (b){\n    return b;\n  }; return a";
  [%expect {| Programm return: [Function: a] |}]
;;

let%expect_test _ =
  print_return "return function (b){\n    return b;\n  }(4)";
  [%expect {| Programm return: 4 |}]
;;

(*arrow function*)

let%expect_test _ =
  print_return "return ((b) => b)(4)";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "return ((b) => {return b})(4)";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "let a = (b) => {return b}; return a(4)";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return "let a = (b) => {return b}; return a";
  [%expect {| Programm return: [Function: a] |}]
;;

(*objects*)

let%expect_test _ =
  print_return "let a = { lang : \"Ocaml\", num : 5}; return a";
  [%expect {| Programm return: { lang: 'Ocaml', num: 5 } |}]
;;

let%expect_test _ =
  print_return "let a = { lang : \"Ocaml\", num : 5}; return a.lang";
  [%expect {| Programm return: Ocaml |}]
;;

let%expect_test _ =
  print_return "let a = { lang : \"Ocaml\", num : 5}; return a[\"nu\"+\"m\"]";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "let a = { lang : \"Ocaml\", [\"nu\"+\"m\"] : 5+5}; return a.num";
  [%expect {| Programm return: 10 |}]
;;

let%expect_test _ =
  print_return "let a = { lang : \"Ocaml\", num : 5}; return a.ab";
  [%expect {| Programm return: undefined |}]
;;

let%expect_test _ =
  print_return "let a = { get_num : (b) => b}; return a.get_num(5)";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return "let a = { sayHi() {\n    return \"Hi!\"\n  }}; return a.sayHi()";
  [%expect {| Programm return: Hi! |}]
;;

(*assign*)

let%expect_test _ =
  print_return "let a = 10; a = 15; return a";
  [%expect {| Programm return: 15 |}]
;;

let%expect_test _ =
  print_return "const a = 10; a = 15; return a";
  [%expect
    {| Error: Interpreter error > error in expression statement > TypeError: Assignment to constant variable. |}]
;;

let%expect_test _ =
  print_return "let a = 10; return (a=15)";
  [%expect {| Programm return: 15 |}]
;;

let%expect_test _ =
  print_return "let a = 10; return (a=(10 + 5))";
  [%expect {| Programm return: 15 |}]
;;

let%expect_test _ =
  print_return "let a = 10; return (a=\"jk\")";
  [%expect {| Programm return: jk |}]
;;

let%expect_test _ =
  print_return "let a = 10; let b = 15; return (a=b)";
  [%expect {| Programm return: 15 |}]
;;

let%expect_test _ =
  print_return "let a = 10; let b = a; a = 7; return b";
  [%expect {| Programm return: 10 |}]
;;

let%expect_test _ =
  print_return "let a = 10; let b = 15; let c = 17; return a = b = c";
  [%expect {| Programm return: 17 |}]
;;

(*lexical env*)

let%expect_test _ =
  print_return "let a = 10; {a=7} ; return a";
  [%expect {| Programm return: 7 |}]
;;

let%expect_test _ =
  print_return "let a = 10; {a=7} ; {a=8}; return a";
  [%expect {| Programm return: 8 |}]
;;

let%expect_test _ =
  print_return "let a = 10; {a=a+1} ; {a=a+1}; return a";
  [%expect {| Programm return: 12 |}]
;;

let%expect_test _ =
  print_return "let a = 10; function b() {return a=7} ; b();return a;";
  [%expect {| Programm return: 7 |}]
;;

let%expect_test _ =
  print_return
    "function a() {return counter = counter+1}; let counter = 0; a(); a(); return a()";
  [%expect {| Programm return: 3 |}]
;;

let%expect_test _ =
  print_return
    "let counter = 0; function a() {return counter = counter+1}; a(); a(); return \
     counter;";
  [%expect {| Programm return: 2 |}]
;;

let%expect_test _ =
  print_return
    "let counter = 0;\n\
    \ function a() {counter = 10}; \n\
    \ function b() {return counter};\n\
    \ a(); return b();";
  [%expect {| Programm return: 10 |}]
;;

let%expect_test _ =
  print_return
    "let counter = 0;\n\
    \ function a() {return counter = counter + 1}; \n\
    \ function b() {return counter = counter + 4};\n\
    \ a(); b(); return counter;";
  [%expect {| Programm return: 5 |}]
;;

let%expect_test _ =
  print_return
    "let counter = 0;\n\
    \ function a() {let counter = 10}; \n\
    \ function b() {return counter = counter + 4};\n\
    \ a(); b(); return counter;";
  [%expect {| Programm return: 4 |}]
;;

let%expect_test _ =
  print_return
    "let counter = 0;\n\
    \ function a() {counter = 10; return (() => {return counter = counter + 1})()}; \n\
    \ a(); return counter";
  [%expect {| Programm return: 11 |}]
;;

let%expect_test _ =
  print_return
    "let counter = 0; function a() {counter = counter + 1; counter = counter + 1; }; \
     a(); return counter";
  [%expect {| Programm return: 2 |}]
;;

let%expect_test _ =
  print_return
    "function a() {let counter = 0; return ()=>counter = counter+1}; \n\
    \    let b = a(); \n\
    \    b(); b();\n\
    \    return b()";
  [%expect {| Programm return: 3 |}]
;;

(**---------------Print tests---------------*)

let%expect_test _ =
  print_output "alert(1); alert(2);";
  [%expect {|
    Programm output:
    1
    2

    Programm return: undefined |}]
;;

let%expect_test _ =
  print_output "console.log(1); console.log(2)";
  [%expect {|
    Programm output:
    1
    2

    Programm return: undefined |}]
;;

let%expect_test _ =
  print_output "console.log(1+2, \"43\", console.log, alert)";
  [%expect
    {|
    Programm output:
    3 43 [Function: log] [Function: alert]

    Programm return: undefined |}]
;;

let%expect_test _ =
  print_output "console.log(1+2, \"43\")\n  console.log(1+2, \"43\")";
  [%expect {|
    Programm output:
    3 43
    3 43

    Programm return: undefined |}]
;;

(**---------------Prototypical inheritance---------------*)

let%expect_test _ =
  print_return "let a2 = {field2 : 4}; return a2.field1";
  [%expect {| Programm return: undefined |}]
;;

let%expect_test _ =
  print_output
    "let a1 = {field1 : 10}; \n\
    \    let a2 = {__proto__ : a1, field2 : 4}; \n\
    \    alert(a2.field1, a2.field2)";
  [%expect {|
    Programm output:
    10 4

    Programm return: undefined |}]
;;

let%expect_test _ =
  print_output
    "let a1 = {field1 : 10}; \n\
    \    let a2 = {__proto__ : a1, field1 : 6, field2 : 4}; \n\
    \    alert(a2.field1, a2.field2)";
  [%expect {|
    Programm output:
    6 4

    Programm return: undefined |}]
;;
