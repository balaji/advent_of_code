-module(day7).
-import('utils', [read_as_integers/2, replace_nth_value/3]).
-export([main/0]).

main() ->
  IntCode = read_as_integers("inputs/day7.txt", ","),
  PhaseCodes = [0, 1, 2, 3, 4],
  Amplified = [amplify([A, B, C, D, E], IntCode, []) ||
    A <- PhaseCodes,B <- PhaseCodes, C <- PhaseCodes, D <- PhaseCodes, E <- PhaseCodes, all_unique([A, B, C, D, E])],
  lists:max(Amplified).

all_unique(List) ->
  length(List) == length(utils:remove_dups(List)).

amplify([], _, Output) -> Output;
amplify([P | Setting], IntCode, Output) ->
  case Output of
    [] -> amplify(Setting, IntCode, calculate(IntCode, [P, 0]));
    [O] -> amplify(Setting, IntCode, calculate(IntCode, [P, O]));
    _ -> io:format("invalid")
  end.

calculate(IntCode, Input) ->
  calculate(IntCode, 1, Input, []).

calculate(IntCode, Start, Input, Output) ->
  [Head | T] = lists:sublist(IntCode, Start, 4),
  [_, {B, []}, {C, []}, {D, []}, {E, []}] = [string:to_integer(integer_to_list(N - 48)) || N <- io_lib:format("~5..0B", [Head])],
  Code = D * 10 + E,
  case Code of
    X when X == 99 -> Output;
    X when X == 1; X == 2; X == 7; X == 8 ->
      [Pos1, Pos2, Pos3] = T,
      Num1 = find(C, Pos1, IntCode),
      Num2 = find(B, Pos2, IntCode),
      Sum = if
              X == 1 -> Num1 + Num2;
              X == 2 -> Num1 * Num2;
              X == 7 -> if Num1 < Num2 -> 1; true -> 0 end;
              X == 8 -> if Num1 == Num2 -> 1; true -> 0 end
            end,
      calculate(replace_nth_value(IntCode, Pos3, Sum), Start + 4, Input, Output);
    X when X == 3; X == 4 ->
      [Param | _] = T,
      Num1 = find(C, Param, IntCode),
      if
        X == 3 ->
          [A | Tail] = Input,
          calculate(replace_nth_value(IntCode, Param, A), Start + 2, Tail, Output);
        X == 4 -> calculate(IntCode, Start + 2, Input, [Num1 | Output])
      end;
    X when X == 5; X == 6 ->
      [Pos1, Pos2 | _] = T,
      Num1 = find(C, Pos1, IntCode),
      Num2 = find(B, Pos2, IntCode),
      if
        X == 5, Num1 /= 0 -> calculate(IntCode, Num2 + 1, Input, Output);
        X == 6, Num1 == 0 -> calculate(IntCode, Num2 + 1, Input, Output);
        true -> calculate(IntCode, Start + 3, Input, Output)
      end;
    _ -> io:format("failed.")
  end.

find(Mode, Pos, List) ->
  if Mode == 0 -> lists:nth(Pos + 1, List);
    true -> Pos
  end.
