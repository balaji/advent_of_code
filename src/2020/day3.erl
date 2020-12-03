-module(day3).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = lists:reverse(string:tokens(utils:content(FileName), "\n")),
  R = [count_trees(L, T, 0) || T <- [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]],
  io:format("~p~n", [lists:foldl(fun(X, Prod) -> X * Prod end, 1, R)]).

count_trees(L, T, Pos) -> count_trees(L, T, Pos, 0).

count_trees([_], _, _, Acc) -> Acc;
count_trees(T, {Right, Down} = Slope, CurrentY, Acc) ->
  [Dx, Ry] = [1 + Down, CurrentY + Right],
  Row = lists:nth(Dx, T),
  Point = lists:nth((Ry rem length(Row)) + 1, Row),
  count_trees(lists:sublist(T, Dx, length(T)), Slope, Ry, Acc + case Point of
                                                                  $. -> 0;
                                                                  $# -> 1
                                                                end).
