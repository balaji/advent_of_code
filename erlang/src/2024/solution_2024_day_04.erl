-module(solution_2024_day_04).

-export([main/1, run/0]).

-import(lists, [flatten/1, filter/2, map/2, seq/2, sort/1]).
-import(utils, [array_get/3, lines/1]).

run() ->
    solution(["MMMSXXMASM",
              "MSAMXMSMSA",
              "AMXSXMAAMM",
              "MSAMASMSMX",
              "XMASAMXAMM",
              "XXAMMXXAMA",
              "SMSMSASXSS",
              "SAXAMASAAA",
              "MAMMMXMMMM",
              "MXMXAXMASX"]).

solution(L) ->
    A = array:from_list([array:from_list(Str) || Str <- L]),
    Length = array:size(A),
    Width = array:size(array:get(0, A)),
    Points = [{X, Y} || X <- seq(0, Length - 1), Y <- seq(0, Width - 1)],
    Funs =
        [fun top_to_bottom/5,
         fun bottom_to_top/5,
         fun left_to_right/5,
         fun right_to_left/5,
         fun top_to_left/5,
         fun top_to_right/5,
         fun bottom_to_left/5,
         fun bottom_to_right/5],
    [length(filter(fun({_, X}) -> X == "XMAS" end,
                   flatten([[{P, Fun(A, X, Y, Length, Width)} || Fun <- Funs]
                            || {X, Y} = P <- Points]))),
     length(filter(fun({_, Res}) -> Res == true end,
                   [{P, x_mas(A, X, Y, Length, Width)} || {X, Y} = P <- Points]))].

x_mas(A, I, J, M, N) when I < M - 1, J < N - 1, I > 0, J > 0 ->
    case array_get(A, I, J) of
        C when C == $A ->
            X1 = sort([array_get(A, I + 1, J + 1), array_get(A, I - 1, J - 1)]),
            X2 = sort([array_get(A, I + 1, J - 1), array_get(A, I - 1, J + 1)]),
            X1 == [$M, $S] andalso X2 == [$M, $S];
        _ ->
            nomatch
    end;
x_mas(_, _, _, _, _) ->
    nomatch.

top_to_bottom(A, I, J, M, _) when I < M - 3 ->
    [array_get(A, X, Y) || {X, Y} <- [{I, J}, {I + 1, J}, {I + 2, J}, {I + 3, J}]];
top_to_bottom(_, _, _, _, _) ->
    "".

bottom_to_top(A, I, J, _, _) when I > 2 ->
    [array_get(A, X, Y) || {X, Y} <- [{I, J}, {I - 1, J}, {I - 2, J}, {I - 3, J}]];
bottom_to_top(_, _, _, _, _) ->
    "".

left_to_right(A, I, J, _, N) when J < N - 3 ->
    [array_get(A, X, Y) || {X, Y} <- [{I, J}, {I, J + 1}, {I, J + 2}, {I, J + 3}]];
left_to_right(_, _, _, _, _) ->
    "".

right_to_left(A, I, J, _, _) when J > 2 ->
    [array_get(A, X, Y) || {X, Y} <- [{I, J}, {I, J - 1}, {I, J - 2}, {I, J - 3}]];
right_to_left(_, _, _, _, _) ->
    "".

top_to_left(A, I, J, M, _) when J > 2, I < M - 3 ->
    [array_get(A, X, Y)
     || {X, Y} <- [{I, J}, {I + 1, J - 1}, {I + 2, J - 2}, {I + 3, J - 3}]];
top_to_left(_, _, _, _, _) ->
    "".

top_to_right(A, I, J, M, N) when I < M - 3, J < N - 3 ->
    [array_get(A, X, Y)
     || {X, Y} <- [{I, J}, {I + 1, J + 1}, {I + 2, J + 2}, {I + 3, J + 3}]];
top_to_right(_, _, _, _, _) ->
    "".

bottom_to_left(A, I, J, _, N) when I > 2, J < N - 3 ->
    [array_get(A, X, Y)
     || {X, Y} <- [{I, J}, {I - 1, J + 1}, {I - 2, J + 2}, {I - 3, J + 3}]];
bottom_to_left(_, _, _, _, _) ->
    "".

bottom_to_right(A, I, J, _, _) when J > 2, I > 2 ->
    [array_get(A, X, Y)
     || {X, Y} <- [{I, J}, {I - 1, J - 1}, {I - 2, J - 2}, {I - 3, J - 3}]];
bottom_to_right(_, _, _, _, _) ->
    "".

main(FileName) ->
    solution(lines(FileName)).
