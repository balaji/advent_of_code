-module(day6).

-export([main/1]).

main([FileName | _]) ->
    L = [ re:split(S, "[\n]+", [{return, list}]) || S <- string:split(utils:content(FileName), "\n\n", all) ],
    io:format("~p~n", [ lists:sum([ sets:size(sets:intersection(LofS)) || LofS <- [ lists:map(fun(E) -> sets:from_list(E) end, I) || I <- L]])]).
