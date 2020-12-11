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
    % print_array(A),
    R = game(A, A, 0, 0, Dim),
    case are_equal(R, A) of 
        0 -> count_seats(R);
        _ -> play(R, Dim)
    end.

count_seats(A) ->
    lists:sum(
        lists:map(
            fun(E) -> 
                array:foldl(
                    fun(_, I, Acc) ->
                         if I == $# -> Acc + 1; true -> Acc + 0 end
                        end, 0, E)
                % io:format("~p~n", [Y]), Y
            end,
        array:to_list(A))).

are_equal(A, B) ->
    La = array:to_list(A),
    Lb = array:to_list(B),
    lists:sum(lists:map(fun({X, Y}) -> 
        if X == Y -> 0; true -> 1 end
        end, lists:zip(La, Lb))).

print_array(A) ->
    lists:foreach(fun(I) -> io:format("~p~n", [array:to_list(I)]) end, array:to_list(A)), io:format("~n").

game(A, Modified, I, J, {Li, Lj}) ->
    if 
        I < Li ->
        if 
            J < Lj -> 
                case array_get(A, I, J) of
                    $. -> game(A, Modified, I, J + 1, {Li, Lj});
                    $# -> 
                        case occupied(adjacents2(A, I, J, Li, Lj), 0) of
                            X when X >= 5 -> game(A, array_set(Modified, I, J, $L), I, J + 1, {Li, Lj});
                            _ -> game(A, Modified, I, J + 1, {Li, Lj})
                        end;
                    $L -> 
                        case occupied(adjacents2(A, I, J, Li, Lj), 0) of
                            X when X == 0 -> game(A, array_set(Modified, I, J, $#), I, J + 1, {Li, Lj});
                            _ -> game(A, Modified, I, J + 1, {Li, Lj})
                        end
                end;
            true -> 
                game(A, Modified, I + 1, 0, {Li, Lj})
        end;
        true -> Modified
    end.

adjacents(Arr, Pi, Pj, Li, Lj) -> 
    lists:map(fun({A, B}) -> array_get(Arr, A, B) end,
    lists:filter(fun({A, B}) -> (A < Li) and (B < Lj) and (A >= 0) and (B >= 0) end, [
        {Pi, Pj + 1},
        {Pi, Pj - 1},
        {Pi + 1, Pj},
        {Pi - 1, Pj},
        {Pi + 1, Pj + 1},
        {Pi + 1, Pj - 1},
        {Pi - 1, Pj + 1},
        {Pi - 1, Pj - 1}
    ])).

adjacents2(Arr, Pi, Pj, Li, Lj) -> 
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
    case array_get(Arr, Pi, Pj) of
        $. -> farthest(Arr, Fn(CoOrds), Li, Lj, Fn);
        X -> X
    end;
farthest(_, _, _, _, _) -> $..

occupied([], L) -> L;
occupied([H | T], L) when H == $# -> occupied(T, L + 1);
occupied([_ | T], L) -> occupied(T, L).

array_get(A, I, J) ->
    Row = array:get(I, A),
    array:get(J, Row).

array_set(A, I, J, V) ->
    Row = array:get(I, A),
    NewRow = array:set(J, V, Row),
    array:set(I, NewRow, A).
