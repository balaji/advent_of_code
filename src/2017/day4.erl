-module(day4).

-export([main/1]).

main([FileName | _]) ->
    L = [string:split(I, " ", all) || I <- utils:as_strings(FileName)],
    Y = lists:sum(lists:map(fun(E) -> 
         SetSize = sets:size(sets:from_list([ lists:sort(X) || X <- E])),
         ListSize = length(E),
         if SetSize == ListSize -> 1; true -> 0 end
        end, L)),
    io:format("~p~n", [Y]).
