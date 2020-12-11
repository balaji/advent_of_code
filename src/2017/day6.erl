-module(day6).

-export([main/1]).

main([FileName | _]) ->
    L = array:from_list(utils:read_as_integers(FileName, " ")),
    io:format("~p~n", [simulate(L, sets:new(), 0)]).

simulate(L, Set, Count) ->
    {Index, M} = array:foldl(fun(I, V, {_, A}=T) -> 
        if V > A -> {I, V}; true -> T end     
    end, {-1, -1}, L),
    NewL = update(array:set(Index, 0, L), Index + 1, M),
    Filtered = sets:filter(fun({_, S}) -> S == NewL end, Set),
    case sets:size(Filtered) of
        0 -> simulate(NewL, sets:add_element({Count + 1, NewL}, Set), Count + 1);
        _ -> [{Loop, _} | _] = sets:to_list(Filtered), {Count + 1, Count - Loop + 1}
    end.

update(Array, _, 0) -> Array;
update(Array, Index, Count) ->
    NewIndex = Index rem array:size(Array),
    update(array:set(NewIndex, array:get(NewIndex, Array) + 1, Array), NewIndex + 1, Count - 1).
