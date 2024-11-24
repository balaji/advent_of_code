-module(solution_2019_day_05).
-import('utils', [read_as_integers/2, replace_nth_value/3]).
-export([main/1]).

main([FileName | _]) ->
  IntCode = read_as_integers(FileName, ","),
  calculate(IntCode, 1).

calculate(IntCode, Start) ->
  [Head | T] = lists:sublist(IntCode, Start, 4),
  [_, {B, []}, {C, []}, {D, []}, {E, []}] = [string:to_integer(integer_to_list(N - 48)) || N <- io_lib:format("~5..0B", [Head])],
  Code = D * 10 + E,
  case Code of
    X when X == 99 -> io:format("halted~n");
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
      calculate(replace_nth_value(IntCode, Pos3, Sum), Start + 4);
    X when X == 3; X == 4 ->
      [Param | _] = T,
      Num1 = find(C, Param, IntCode),
      if
        X == 3 -> calculate(replace_nth_value(IntCode, Param, 5), Start + 2);
        X == 4 -> io:format("outputting: ~p~n", [Num1]), calculate(IntCode, Start + 2)
      end;
    X when X == 5; X == 6 ->
      [Pos1, Pos2 | _] = T,
      Num1 = find(C, Pos1, IntCode),
      Num2 = find(B, Pos2, IntCode),
      if
        X == 5, Num1 /= 0 -> calculate(IntCode, Num2 + 1);
        X == 6, Num1 == 0 -> calculate(IntCode, Num2 + 1);
        true -> calculate(IntCode, Start + 3)
      end;
    _ -> io:format("failed.")
  end.

find(Mode, Pos, List) ->
  if Mode == 0 -> lists:nth(Pos + 1, List);
    true -> Pos
  end.
