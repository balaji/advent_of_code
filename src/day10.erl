-module(day10).

-export([main/0]).


main() ->
  C = string:tokens(utils:content("inputs/day10.txt"), "\n"),
  Asteroids = asteroids(C, [], length(C) - 1),
  [Max | Visibility] = visibility(Asteroids, Asteroids, []),
  find_max(Visibility, Max).

find_max([], Max) -> Max;
find_max([{A, Count} | T], {_, Max}) when Count > Max -> find_max(T, {A, Count});
find_max([_ | T], M) -> find_max(T, M).

visibility([], _, Acc) -> Acc;
visibility([A | H], Asteroids, Acc) ->
  visibility(H, Asteroids, [{A, count(A, lists:delete(A, Asteroids), Asteroids, [])} | Acc]).

asteroids([], Points, _) -> Points;
asteroids([H | T], Points, Y) -> asteroids(T, asteroid_row(H, [], 0, Y) ++ Points, Y - 1).

asteroid_row([], Acc, _, _) -> Acc;
asteroid_row([$. | T], Acc, X, Y) -> asteroid_row(T, Acc, X + 1, Y);
asteroid_row([$# | T], Acc, X, Y) -> asteroid_row(T, [{X, Y} | Acc], X + 1, Y).

count(_, [], Asteroids, Acc) -> length(Asteroids) - length(utils:remove_dups(Acc)) - 1;
count(Origin, [Asteroid | T], Asteroids, Acc) ->
  count(Origin, T, Asteroids, Acc ++ asteroids_in_path(trace(Origin, Asteroid), Asteroids)).

trace(PointA, PointB) ->
  lists:delete(PointA, all_points(slope(PointA, PointB), PointB, [PointA])).

all_points(_, {Xd, Yd}, [{X, Y} | T]) when X == Xd, Y == Yd -> T;
all_points([XS, YS], Limits, [{X, Y} | T]) ->
  all_points([XS, YS], Limits, [{X + XS, Y + YS} | [{X, Y} | T]]).

slope({X_Origin, Y_Origin}, {X, Y}) ->
  GCD = utils:gcd(abs(Y - Y_Origin), abs(X - X_Origin)),
  [floor((X - X_Origin) / GCD), floor((Y - Y_Origin) / GCD)].

asteroids_in_path(ListA, ListB) ->
  [{X2, Y2} || {X1, Y1} <- ListA, {X2, Y2} <- ListB, X1 == X2, Y1 == Y2].
