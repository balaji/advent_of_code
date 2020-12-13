-module(day13).

-export([main/1]).

main([FileName | _]) ->
  [T | L] = utils:as_strings(FileName),
  [F | R] = string:split(L, ",", all),
  Y = lists:reverse(
    lists:filter(fun({Str, _}) -> Str /= -1 end,
      lists:foldl(
        fun(I, [{_, Index} | _] = Acc) -> [{if I == "x" -> -1; true -> list_to_integer(I) end, Index + 1} | Acc] end,
        [{list_to_integer(F), 0}], R))),

  io:format("part 1: ~p, part 2: ~p~n", [part1(list_to_integer(T),
    lists:map(
      fun(I) -> list_to_integer(I) end,
      lists:filter(
        fun(I) -> I /= "x" end, [F | R])), 10000000, -1), part2(Y, [], Y, 100000000000000)]).

part1(Target, [], MaxMin, BusId) -> BusId * (MaxMin - Target);
part1(Target, [BID | R], MaxMin, BusId) ->
  V = Target rem BID,
  case Target + (BID - V) of
    X when X < MaxMin -> part1(Target, R, X, BID);
    _ -> part1(Target, R, MaxMin, BusId)
  end.

part2(_, _, [], Number) -> Number;
part2(Og, P, [{B, F} = Done | R], Number) when (Number + F) rem B == 0 -> part2(Og, [Done | P], R, Number);
part2(Og, Prev, _, Number) -> part2(Og, Prev, Og, lcm(Prev, Number)).

lcm([], N) -> N + 1;
lcm([{B, _} | T], N) -> lcm_all(T, B) + N.

lcm_all([], V) -> V;
lcm_all([{B, _} | R], V) -> lcm_all(R, utils:lcm(B, V)).
