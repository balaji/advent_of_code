-module(solution_2020_day_12).

-export([main/1]).

main([FileName | _]) ->
  L = utils:as_strings(FileName),
  io:format("part 1: ~p, part 2: ~p~n", [part1(L, $E, {0, 0}), part2(L, {10, 1}, {0, 0})]).

part1([], _, {X, Y}) -> abs(X) + abs(Y);
part1([[D | R] | T], CurrentD, CoOrds) ->
  case {D, list_to_integer(R)} of
    {$F, V} -> part1(T, CurrentD, move(CurrentD, CoOrds, V));
    {$R, V} -> part1(T, turn_ship(CurrentD, (V div 90) + 1), CoOrds);
    {$L, V} -> part1(T, turn_ship(CurrentD, abs(4 - (V div 90)) + 1), CoOrds);
    {D, V} -> part1(T, CurrentD, move(D, CoOrds, V))
  end.

move(Direction, {X, Y}, V) ->
  case Direction of
    $N -> {X, Y + V};
    $E -> {X + V, Y};
    $W -> {X - V, Y};
    $S -> {X, Y - V}
  end.

turn_ship(CurrentD, V) ->
  case CurrentD of
    $E -> lists:nth(V, [$E, $S, $W, $N]);
    $W -> lists:nth(V, [$W, $N, $E, $S]);
    $S -> lists:nth(V, [$S, $W, $N, $E]);
    $N -> lists:nth(V, [$N, $E, $S, $W])
  end.

part2([], _, {Sx, Sy}) -> abs(Sx) + abs(Sy);
part2([[D | R] | T], Waypoint, Ship) ->
  case {D, list_to_integer(R)} of
    {$F, V} -> part2(T, Waypoint, move_ship(Waypoint, Ship, V));
    {$R, V} -> part2(T, rotate_waypoint(Waypoint, V), Ship);
    {$L, V} -> part2(T, rotate_waypoint(Waypoint, abs(360 - V)), Ship);
    {D, V} -> part2(T, move(D, Waypoint, V), Ship)
  end.

move_ship({X, Y}, {Sx, Sy}, V) -> {Sx + (X * V), Sy + (Y * V)}.

rotate_waypoint({X, Y}, V) ->
  case V of
    90 -> {Y, -X};
    180 -> {-X, -Y};
    270 -> {-Y, X}
  end.
