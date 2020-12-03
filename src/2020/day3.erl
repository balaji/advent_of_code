-module(day3).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = lists:reverse(string:tokens(utils:content(FileName), "\n")),
  R = [count_trees(L, Right, Down, 0, 0) || {Right, Down} <- [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]],
  io:format("~p~n", [lists:foldl(fun(X, Prod) -> X * Prod end, 1, R)]).

count_trees([_], _, _, _, Acc) -> Acc;
count_trees(T, Right, Down, CurrentY, Acc) ->
  R2 = lists:nth(1 + Down, T),
  Pos = lists:nth(((CurrentY + Right) rem length(R2)) + 1, R2),
  case Pos of
    $. -> count_trees(lists:sublist(T, 1 + Down, length(T)), Right, Down, CurrentY + Right, Acc);
    $# -> count_trees(lists:sublist(T, 1 + Down, length(T)), Right, Down, CurrentY + Right, Acc + 1)
  end.
