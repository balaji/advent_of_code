-module(solution_2020_day_03).

-export([main/1]).

main([FileName | _]) ->
    L = string:tokens(utils:content(FileName), "\n"),
    io:format(
        "part 1: ~p, part 2: ~p~n",
        [
            count_trees(L, {3, 1}, 0, 0),
            lists:foldl(
                fun(X, Prod) -> X * Prod end,
                1,
                [count_trees(L, T, 0, 0) || T <- [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]]
            )
        ]
    ).

count_trees([_], _, _, Acc) ->
    Acc;
count_trees(T, {Y, X} = Slope, CurrentY, Acc) ->
    NewY = CurrentY + Y,
    Point = utils:array_fetch(T, X + 1, (NewY rem length(lists:nth(1, T))) + 1),
    count_trees(
        lists:sublist(T, X + 1, length(T)),
        Slope,
        NewY,
        Acc +
            case Point of
                $. -> 0;
                $# -> 1
            end
    ).
