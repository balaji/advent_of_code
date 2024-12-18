-module(solution_2017_day_04).

-export([main/1]).

main([FileName | _]) ->
    L = [string:split(I, " ", all) || I <- utils:lines(FileName)],
    Y = lists:sum(
        lists:map(
            fun(E) ->
                SetSize = sets:size(sets:from_list([lists:sort(X) || X <- E])),
                ListSize = length(E),
                if
                    SetSize == ListSize -> 1;
                    true -> 0
                end
            end,
            L
        )
    ),
    io:format("~p~n", [Y]).
