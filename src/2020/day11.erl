-module(day11).

-export([main/1]).

main([FileName | _]) ->
    L = utils:as_strings(FileName),
    A = to_array(L, 0, array:new(length(L))),
    io:format("~p~n", [play(A, {length(L), array:size(array:get(0, A))})]).

to_array([], _, A) -> A;
to_array([H | T], I, A) ->
    to_array(T, I+ 1, array:set(I, array:from_list(H), A)).

play(A, Dim) ->
    R = game(A, A, 0, 0, Dim),
    case R == A of
        true -> count_seats(R);
        _ -> play(R, Dim)
    end.

count_seats(A) ->
    array:foldl(
        fun(_, V, Sum) ->
            Sum + array:foldl(
                fun(_, I, Acc) ->
                        if I == $# -> Acc + 1; true -> Acc + 0 end
                end, 0, V)
        end, 0, A).


game(A, Modified, I, J, {Li, Lj}) ->
    case I < Li of
        true when J < Lj ->
            case {utils:array_get(A, I, J), occupied(part2(A, I, J, Li, Lj), 0)} of
                {$#, X} when X >= 5 -> game(A, utils:array_set(Modified, I, J, $L), I, J + 1, {Li, Lj});
                {$L, X} when X == 0 -> game(A, utils:array_set(Modified, I, J, $#), I, J + 1, {Li, Lj});
                _ -> game(A, Modified, I, J + 1, {Li, Lj})
            end;
        true when J >= Lj ->  game(A, Modified, I + 1, 0, {Li, Lj});
        _ -> Modified
    end.

part1(Arr, Pi, Pj, Li, Lj) ->
    lists:map(fun({A, B}) -> utils:array_get(Arr, A, B) end,
    lists:filter(fun({A, B}) -> (A < Li) and (B < Lj) and (A >= 0) and (B >= 0) end,
    [
        {Pi, Pj + 1},
        {Pi, Pj - 1},
        {Pi + 1, Pj},
        {Pi - 1, Pj},
        {Pi + 1, Pj + 1},
        {Pi + 1, Pj - 1},
        {Pi - 1, Pj + 1},
        {Pi - 1, Pj - 1}
    ])).

part2(Arr, Pi, Pj, Li, Lj) ->
    [
        farthest(Arr, {Pi, Pj + 1}, Li, Lj, fun({A, B}) -> {A, B + 1} end),
        farthest(Arr, {Pi, Pj - 1}, Li, Lj, fun({A, B}) -> {A, B - 1} end),
        farthest(Arr, {Pi + 1, Pj}, Li, Lj, fun({A, B}) -> {A + 1, B} end),
        farthest(Arr, {Pi - 1, Pj}, Li, Lj, fun({A, B}) -> {A - 1, B} end),
        farthest(Arr, {Pi + 1, Pj + 1}, Li, Lj, fun({A, B}) -> {A + 1, B + 1} end),
        farthest(Arr, {Pi + 1, Pj - 1}, Li, Lj, fun({A, B}) -> {A + 1, B - 1} end),
        farthest(Arr, {Pi - 1, Pj + 1}, Li, Lj, fun({A, B}) -> {A - 1, B + 1} end),
        farthest(Arr, {Pi - 1, Pj - 1}, Li, Lj, fun({A, B}) -> {A - 1, B - 1} end)
    ].

farthest(Arr, {Pi, Pj}=CoOrds, Li, Lj, Fn) when Pi >= 0, Pj >= 0, Pi < Li, Pj < Lj ->
    case utils:array_get(Arr, Pi, Pj) of
        $. -> farthest(Arr, Fn(CoOrds), Li, Lj, Fn);
        X -> X
    end;
farthest(_, _, _, _, _) -> $..

occupied([], L) -> L;
occupied([H | T], L) when H == $# -> occupied(T, L + 1);
occupied([_ | T], L) -> occupied(T, L).
