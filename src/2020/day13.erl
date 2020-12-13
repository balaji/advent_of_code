-module(day13).

-export([main/1]).

main([FileName | _]) ->
  [Earliest | L] = utils:as_strings(FileName),
  [F | R] = Routes = lists:map(fun(I) ->
    if I == "x" -> -1; true -> list_to_integer(I) end end, string:split(L, ",", all)),
  DeltaPairs =
    lists:foldl(fun(I, [{_, Index} | _] = Acc) ->
      [{I, Index + 1} | Acc] end, [{F, 0}], R),
  io:format("part 1: ~p, part 2: ~p~n",
    [part1(list_to_integer(Earliest), Routes, 10000000, -1), % some large number.
      part2(DeltaPairs, [], DeltaPairs, 1)]).

part1(Target, [-1 | T], MaxMin, BusId) -> part1(Target, T, MaxMin, BusId); % skip 'x'
part1(Target, [], MaxMin, BusId) -> BusId * (MaxMin - Target);
part1(Target, [BID | R], MaxMin, BusId) ->
  V = Target rem BID,
  case Target + (BID - V) of
    X when X < MaxMin -> part1(Target, R, X, BID);
    _ -> part1(Target, R, MaxMin, BusId)
  end.

part2(_, _, [], Number) -> Number;
part2(Og, P, [{-1, _} | T], Number) -> part2(Og, P, T, Number); % skip 'x'
part2(Og, P, [{B, F} | R], Number) when (Number + F) rem B == 0 -> part2(Og, [B | P], R, Number);
part2(Og, Prev, _, Number) -> part2(Og, [], Og, Number + lcm_all(Prev)). % brute force. But skip ahead `lcm` of rest.

lcm_all(L) -> lists:foldl(fun(B, Acc) -> utils:lcm(B, Acc) end, 1, L).
