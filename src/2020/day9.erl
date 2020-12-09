-module(day9).

-export([main/1]).

main([FileName | _]) ->
    L = utils:read_as_integers(FileName, "\n"),
    Buff = 25,
    X = part1(L, Buff, Buff + 1),
    io:format("part1: ~p, part2: ~p~n", [X, part2(L, X, 1)]).

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

part2(L, _, Pointer) when length(L) < Pointer -> error;
part2(L, X, Pointer) ->
    {S, SubL} = make_sum(L, X, Pointer, 1),
    if S == X -> lists:min(SubL) + lists:max(SubL);
       true -> part2(L, X, Pointer + 1)
    end.

make_sum(L, Value, Index, Length) ->
    SubL = lists:sublist(L, Index, Length),
    Sum = lists:sum(SubL),
    if Sum < Value -> make_sum(L, Value, Index, Length + 1);
       true -> {Sum, SubL}
    end.
