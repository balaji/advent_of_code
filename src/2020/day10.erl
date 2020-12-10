-module(day10).

-export([main/1]).

main([FileName | _]) ->
    Y = lists:sort(utils:read_as_integers(FileName, "\n")),
    {_, X} = lists:foldl(fun(I, Acc) -> 
        {Prev, Map} = Acc,
        {I, maps:put(I - Prev, maps:get(I - Prev, Map, 0) + 1, Map)} 
    end, {0, #{}}, Y),
    io:format("part 1: ~p, part2: ~p~n", [maps:get(1, X) * (1 + maps:get(3, X)), part2(Y, #{0 => 1})]).


part2([], Map) -> lists:max(maps:values(Map));
part2([H | T], Map) ->
    part2(T, maps:put(H, (maps:get(H - 1, Map, 0) + maps:get(H - 2, Map, 0) + maps:get(H - 3, Map, 0)), Map)).
