-module(solution_2024_day_02).

-export([main/1, run/0]).

-import(lists, [all/2, any/2, droplast/1, map/2, member/2, seq/2, zip/2]).

main(FileName) ->
    solution(utils:split_as_integers(FileName, " ")).

run() ->
    solution([[7, 6, 4, 2, 1],
              [1, 2, 7, 8, 9],
              [9, 7, 6, 2, 1],
              [1, 3, 2, 4, 5],
              [8, 6, 4, 4, 1],
              [1, 3, 6, 7, 9]]).

part_1(Lx) ->
    L = utils:diff(fun(X, Y) -> Y - X end, Lx),
    all(fun(X) -> member(X, [-1, -2, -3]) end, L)
    or all(fun(X) -> member(X, [1, 2, 3]) end, L).

part_2(L) ->
    any(fun part_1/1, [utils:remove_nth(Index, L) || Index <- seq(0, length(L))]).

solution(L) ->
    P1 = length([X || X <- map(fun part_1/1, L), X =:= true]),
    P2 = length([X || X <- map(fun part_2/1, L), X =:= true]),
    io:format("part1: ~p, part2: ~p~n", [P1, P2]).
