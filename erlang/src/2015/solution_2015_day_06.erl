-module(solution_2015_day_06).

-export([main/1]).

main([FileName | _]) ->
    X = lists:map(
        fun(S) ->
            [A, B] = string:split(S, " through "),
            [H1, H2 | T] = string:split(A, " ", all),
            case H1 of
                "toggle" -> {toggle, to_pair(H2), to_pair(B)};
                _ -> {list_to_atom(H2), to_pair(lists:nth(1, T)), to_pair(B)}
            end
        end,
        utils:lines(FileName)
    ),
    L = array:new([{size, 1000}, {default, array:new([{size, 1000}, {default, 0}])}]),
    io:format("~p~n", [check_lights_on(execute(X, L), 0, 0)]).

to_pair(L) ->
    [A, B] = string:split(L, ","),
    [list_to_integer(A), list_to_integer(B)].

execute([], Array) ->
    Array;
execute([H | T], Array) ->
    case H of
        {toggle, A, B} ->
            execute(T, entertain(Array, A, B, fun(Index, Arr) -> array:get(Index, Arr) + 2 end));
        {off, A, B} ->
            execute(
                T,
                entertain(
                    Array,
                    A,
                    B,
                    fun(Index, Arr) -> max(0, array:get(Index, Arr) - 1) end
                )
            );
        {on, A, B} ->
            execute(T, entertain(Array, A, B, fun(Index, Arr) -> array:get(Index, Arr) + 1 end))
    end.

entertain(Array, [X1, Y1], [X2, Y2], Fun) ->
    lists:foldl(
        fun(I, ArAcc) ->
            Row = array:get(I, ArAcc),
            Y = lists:foldr(
                fun(J, Acc) -> array:set(J, Fun(J, Acc), Acc) end,
                Row,
                lists:seq(X1, X2)
            ),
            array:set(I, Y, ArAcc)
        end,
        Array,
        lists:seq(Y1, Y2)
    ).

check_lights_on(_, Index, Sum) when Index == 1000 ->
    Sum;
check_lights_on(Array, Index, Sum) ->
    Row = array:get(Index, Array),
    check_lights_on(Array, Index + 1, Sum + array:foldl(fun(_, V, A) -> V + A end, 0, Row)).
