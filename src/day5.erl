-module(day5).
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
    X when X == 1; X == 2 ->
      [Pos1, Pos2, Pos3] = T,
      Num1 = momo(C, Pos1, IntCode),
      Num2 = momo(B, Pos2, IntCode),
      Sum = if
              X == 1 -> Num1 + Num2;
              true -> Num1 * Num2
            end,
      calculate(replace_nth_value(IntCode, Pos3, Sum), Start + 4);
    X when X == 3; X == 4 ->
      [Param | _] = T,
      if X == 3 -> calculate(replace_nth_value(IntCode, Param, 1), Start + 2);
        true -> io:format("outputting: ~p~n", [lists:nth(Param + 1, IntCode)]), calculate(IntCode, Start + 2)
      end;
    _ -> io:format("failed.")
  end.

momo(Inst, Pos, List) ->
  if Inst == 0 -> lists:nth(Pos + 1, List);
    true -> Pos
  end.
