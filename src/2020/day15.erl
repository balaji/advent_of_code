-module(day15).

-export([main/1]).

main([_]) ->
  Input = lists:map(fun(I) -> list_to_integer(I) end, string:split("8,11,0,19,1,2", ",", all)),
  Map = maps:map(fun(_, V) -> [V] end, maps:from_list(lists:zip(Input, lists:seq(1, length(Input))))),
  LastSpoken = lists:nth(length(Input), Input), Count = length(Input) + 1,
  io:format("~p~n", [find_stuff(Map, LastSpoken, Count)]).

find_stuff(Map, LastSpoken, Count) when Count =< 2020 ->
  case maps:get(LastSpoken, Map, []) of
        [] -> find_stuff(put_spoken(LastSpoken, Count, Map), 0, Count + 1);
       [_] -> find_stuff(put_spoken(0, Count, Map), 0, Count + 1);
    [A, B] -> find_stuff(put_spoken(A - B, Count, Map), A - B, Count + 1)
  end;
find_stuff(_, LastSpoken, _) -> LastSpoken.

put_spoken(Item, Value, Map) ->
  case maps:get(Item, Map, []) of
         [] -> maps:put(Item, [Value], Map);
    [A | _] -> maps:put(Item, [Value, A], Map)
  end.
