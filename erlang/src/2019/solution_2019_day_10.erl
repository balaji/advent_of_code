-module(solution_2019_day_10).

-export([main/1]).


main([FileName | _]) ->
  C = string:tokens(utils:content(FileName), "\n"),
  Asteroids = asteroids(C, [], length(C) - 1),
  [Max | Visibility] = visibility(Asteroids, Asteroids, []),
  {Point, AllHit} = find_max(Visibility, Max),
  ClockWiseHits = slope(Point, AllHit, []),
  {_, {X, Y}} = lists:nth(200, ClockWiseHits),
  io:format("length: ~p, base: ~p, 200th: ~p~n", [length(AllHit), Point, (X * 100) + Y]).

slope(_, [], Acc) -> lists:sort(fun({A, _}, {B, _}) -> A < B end, Acc);
slope({X1, Y1}, [{X2, Y2} | T], Acc) ->
  slope({X1, Y1}, T, [{math:fmod(270 + (math:atan2(Y1 - Y2, X1 - X2) * 180 / math:pi()), 360.0), {X2, Y2}} | Acc]).

find_max([], Max) -> Max;
find_max([{Total, Obstructions} | T], {_, Max}) when length(Obstructions) > length(Max) ->
  find_max(T, {Total, Obstructions});
find_max([_ | T], M) -> find_max(T, M).

visibility([], _, Acc) -> Acc;
visibility([A | H], Asteroids, Acc) ->
  visibility(H, Asteroids, [{A, count(A, lists:delete(A, Asteroids), Asteroids, [])} | Acc]).

asteroids([], Points, _) -> Points;
asteroids([H | T], Points, Y) -> asteroids(T, asteroid_row(H, [], 0, Y) ++ Points, Y - 1).

asteroid_row([], Acc, _, _) -> Acc;
asteroid_row([$. | T], Acc, X, Y) -> asteroid_row(T, Acc, X + 1, Y);
asteroid_row([$# | T], Acc, X, Y) -> asteroid_row(T, [{X, Y} | Acc], X + 1, Y).

count(Origin, [], Asteroids, Acc) ->
  [Rest, AllObstructions] = [lists:delete(Origin, Asteroids), utils:remove_dups(Acc)],
  lists:subtract(Rest, AllObstructions);
count(Origin, [Asteroid | T], Asteroids, Acc) ->
  Obstructions = asteroids_in_path(trace(Origin, Asteroid), Asteroids),
  case Obstructions of
    [] -> count(Origin, T, Asteroids, Acc);
    _ -> count(Origin, T, Asteroids, Acc ++ [Asteroid])
  end.

trace(PointA, PointB) ->
  lists:delete(PointA, all_points(hit_path(PointA, PointB), PointB, [PointA])).

all_points(_, {Xd, Yd}, [{X, Y} | T]) when X == Xd, Y == Yd -> T;
all_points([XS, YS], Limits, [{X, Y} | T]) ->
  all_points([XS, YS], Limits, [{X + XS, Y + YS} | [{X, Y} | T]]).

hit_path({X_Origin, Y_Origin}, {X, Y}) ->
  GCD = utils:gcd(abs(Y - Y_Origin), abs(X - X_Origin)),
  [floor((X - X_Origin) / GCD), floor((Y - Y_Origin) / GCD)].

asteroids_in_path(ListA, ListB) ->
  [{X2, Y2} || {X1, Y1} <- ListA, {X2, Y2} <- ListB, X1 == X2, Y1 == Y2].
