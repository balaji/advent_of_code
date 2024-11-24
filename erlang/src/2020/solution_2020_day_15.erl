-module(solution_2020_day_15).

-export([main/1]).

main([FileName | _]) ->
  Input = utils:read_as_integers(FileName, ","), Length = length(Input),
  Map = maps:map(fun(_, V) -> [V] end, maps:from_list(lists:zip(Input, lists:seq(1, Length)))),
  LastSpoken = lists:nth(Length, Input), Count = Length + 1,
  io:format("part 1: ~p, part 2: ~p~n", [
    find_stuff(Map, LastSpoken, Count, 2020),
    find_stuff(Map, LastSpoken, Count, 30000000)]).

find_stuff(Map, LastSpoken, Count, Length) when Count =< Length ->
  case maps:get(LastSpoken, Map, []) of
    [] -> find_stuff(put_spoken(LastSpoken, Count, Map), 0, Count + 1, Length);
    [_] -> find_stuff(put_spoken(0, Count, Map), 0, Count + 1, Length);
    [A, B] -> find_stuff(put_spoken(A - B, Count, Map), A - B, Count + 1, Length)
  end;
find_stuff(_, LastSpoken, _, _) -> LastSpoken.

put_spoken(Item, Value, Map) ->
  case maps:get(Item, Map, []) of
    [] -> maps:put(Item, [Value], Map);
    [A | _] -> maps:put(Item, [Value, A], Map)
  end.
