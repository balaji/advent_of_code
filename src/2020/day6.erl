-module(day6).

-export([main/1]).

main([FileName | _]) ->
    L = [re:split(S, "[\n]+", [{return, list}]) || S <- string:split(utils:content(FileName), "\n\n", all)],
    io:format("part 1: ~p, ", [lists:sum([sets:size(sets:from_list(lists:merge(I))) || I <- L])]),
    io:format("part 2: ~p~n", [lists:sum([sets:size(sets:intersection(LofS)) || LofS <- [[sets:from_list(E) || E <- I] || I <- L]])]).
