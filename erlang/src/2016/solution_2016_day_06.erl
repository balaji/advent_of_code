-module(solution_2016_day_06).

-export([main/1]).

main([FileName | _]) ->
    L = utils:lines(FileName),
    Container = lists:map(fun(_) -> [] end, lists:nth(1, L)),
    X = lists:foldl(
        fun(E, Acc) -> lists:zipwith(fun(A, B) -> A ++ [B] end, Acc, E) end, Container, L
    ),
    R = lists:map(
        fun(I) ->
            R = array:new(26, [{default, 0}]),
            Mapped = lists:foldl(
                fun(V, Arr) ->
                    array:set(V - $a, array:get(V - $a, Arr) + 1, Arr)
                end,
                R,
                I
            ),
            {C, _} = array:foldl(
                fun(J, V, {Ind, Min}) ->
                    if
                        V > 0, V < Min -> {J + $a, V};
                        true -> {Ind, Min}
                    end
                end,
                {-1, 5000},
                Mapped
            ),
            C
        end,
        X
    ),
    io:format("~p~n", [R]).
