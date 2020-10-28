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
  visibility(H, Asteroids, [{A, count(A, lists:delete(A, Asteroids), Asteroids, sets:new())} | Acc]).

asteroids([], Points, _) -> Points;
asteroids([H | T], Points, Y) -> asteroids(T, asteroid_row(H, [], 0, Y) ++ Points, Y - 1).

asteroid_row([], Acc, _, _) -> Acc;
asteroid_row([$. | T], Acc, X, Y) -> asteroid_row(T, Acc, X + 1, Y);
asteroid_row([$# | T], Acc, X, Y) -> asteroid_row(T, [{Y, X} | Acc], X + 1, Y).

count(_, [], Asteroids, Set) ->
  length(Asteroids) - sets:size(Set) - 1;
count(Origin, [Asteroid | T], Asteroids, Set) ->
  AsteroidsPath = trace(Origin, Asteroid),
  count(Origin, T, Asteroids, sets:union(Set, sets:from_list(merge(AsteroidsPath, Asteroids)))).

trace(PointA, PointB) ->
  lists:delete(PointA, all_points(slope(PointA, PointB), tuple_to_list(PointB), [PointA])).

all_points(_, [Xd, Yd], [{X, Y} | T]) when X == Xd, Y == Yd -> T;
all_points([XS, YS], Limits, [{X, Y} | T]) ->
  all_points([XS, YS], Limits, [{X + XS, Y + YS} | [{X, Y} | T]]).

slope({X_Origin, Y_Origin}, {X, Y}) ->
  GCD = utils:gcd(abs(Y - Y_Origin), abs(X - X_Origin)),
  [floor((X - X_Origin) / GCD), floor((Y - Y_Origin) / GCD)].

merge(ListA, ListB) ->
  [{X2, Y2} || {X1, Y1} <- ListA, {X2, Y2} <- ListB, X1 == X2, Y1 == Y2].
