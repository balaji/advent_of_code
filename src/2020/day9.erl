-module(day9).

-export([main/1]).

main([FileName | _]) ->
    L = utils:read_as_integers(FileName, "\n"),
    Buff = 25,
    X = part1(L, Buff, Buff + 1),
    io:format("part1: ~p, part2: ~p~n", [X, part2(L, 1, 1, lists:nth(1, L), X)]).

part1(L, _, Pointer) when length(L) < Pointer -> error;
part1(L, Buff, Pointer) ->
    V = lists:nth(Pointer, L),
    ToMap = lists:sublist(L, Pointer - Buff, Buff),
    Mapped = lists:map(fun (E) -> V - E end, ToMap),
    Count = sets:size(sets:intersection(sets:from_list(ToMap),
                                        sets:from_list(Mapped))),
    if Count =< 1 -> V;
       true -> part1(L, Buff, Pointer + 1)
    end.

part2(List, Low, High, Sum, Value) when Sum < Value -> part2(List, Low, High + 1, Sum + lists:nth(High + 1, List), Value);
part2(List, Low, High, Sum, Value) when Sum > Value -> part2(List, Low + 1, High, Sum - lists:nth(Low, List), Value);
part2(List, Low, High, _, _) ->
    SubL = lists:sublist(List, Low, High - Low),
    lists:min(SubL) + lists:max(SubL).
