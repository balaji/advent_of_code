-module(day2).
-import('utils', [read_as_integers/2, replace_nth_value/3]).
-export([main/1]).

main([FileName | _]) ->
  IntCode = read_as_integers(FileName, ","),
  extension(IntCode, 1, 1).

extension(List, X, Y) ->
  {Output, IntCode} = calculate(List, X, Y),
  case Output of
    V when V == 19690720 -> io:format("~p~p", [lists:nth(2, IntCode), lists:nth(3, IntCode)]);
    V when V > 19690720 -> extension(List, 1, Y + 1);
    _ when X < 100, Y < 100 -> extension(List, X + 1, Y);
    _ -> io:format("failed.")
  end.

calculate(List, X, Y) ->
  calculate(replace_nth_value(replace_nth_value(List, 1, X), 2, Y), 1).

calculate(IntCode, Start) ->
  [Code | T] = lists:sublist(IntCode, Start, 4),
  case Code of
    X when X == 99 -> {lists:nth(1, IntCode), IntCode};
    X when X == 1;X == 2 ->
      [Pos1, Pos2, Pos3] = T,
      Sum = if
              X == 1 ->
                lists:nth(Pos1 + 1, IntCode) + lists:nth(Pos2 + 1, IntCode);
              true ->
                lists:nth(Pos1 + 1, IntCode) * lists:nth(Pos2 + 1, IntCode)
            end,
      calculate(replace_nth_value(IntCode, Pos3, Sum), Start + 4);
    _ -> io:format("failed.")
  end.
