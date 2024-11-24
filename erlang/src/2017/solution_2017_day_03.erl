-module(solution_2017_day_03).

-export([main/1]).

main([_]) -> io:format("~p~n", [check(265149, 1)]).

check(Number, Index) ->
  Value = spiral(Index, 1),
  if Number > Value -> check(Number, Index + 1);
    true ->
      V = check_pos(Number, Index - 1, 1),
      if (V - 1) div 2 /= 0 ->
        Number - spiral(Index - 1, V - 1) + (Index - 1);
        true -> spiral(Index - 1, V) - Number + (Index - 1)
      end
  end.

check_pos(Number, Compare, Position) ->
  Value = spiral(Compare, Position),
  if Number > Value ->
    check_pos(Number, Compare, Position + 1);
    true -> Position
  end.

spiral(0, _) -> 1;
spiral(T, I) -> spiral(T - 1, I) + (8 * (T - 1) + I).
