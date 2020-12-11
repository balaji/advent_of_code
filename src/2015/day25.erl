-module(day25).

-export([main/1]).

main([_]) ->
    Row = 2978, Column = 3083,
    io:format("~p~n", [find_code(20151125, row_start(row_start(1, Row, 1), Column, Row + 1))]).

row_start(N, 1, _) -> N;
row_start(N, C, I) -> row_start(N + I, C - 1, I + 1).

find_code(S, 1) -> S;
find_code(S, L) -> find_code(S * 252533 rem 33554393, L - 1).
