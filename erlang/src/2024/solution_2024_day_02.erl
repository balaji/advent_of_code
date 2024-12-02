-module(solution_2024_day_02).

-export([main/1, run/0, diff/1]).

main(FileName) ->
    solution(utils:split_as_integers(FileName, " ")).

run() ->
    solution([[7, 6, 4, 2, 1],
              [1, 2, 7, 8, 9],
              [9, 7, 6, 2, 1],
              [1, 3, 2, 4, 5],
              [8, 6, 4, 4, 1],
              [1, 3, 6, 7, 9]]).

diff(L) ->
    diff(L, []).

diff([_], A) ->
    A;
diff([H | [N | _] = R], A) ->
    diff(R, A ++ [N - H]).

is_progressive(X, Y) when X > 0, Y > 0 ->
    true;
is_progressive(X, Y) when X < 0, Y < 0 ->
    true;
is_progressive(_, _) ->
    false.

is_adjacent(X, Y) ->
    lists:member(abs(X), [1,2,3]) and lists:member(abs(Y), [1,2,3]).

part_1(L) ->
    D = diff(L),
    {X, Y} = {lists:min(D), lists:max(D)},
    is_progressive(X, Y) and is_adjacent(X, Y).

part_2(L, N) when N =< length(L) ->
    case part_1(utils:remove_nth(N, L)) of
        true ->
            true;
        _ ->
            part_2(L, N + 1)
    end;
part_2(_, _) ->
    false.

solution(L) ->
    P1 = [part_1(Series) || Series <- L],
    P2 = [part_2(Series, 0) || Series <- L],
    io:format("part1: ~p, part2: ~p~n",
              [length(lists:filter(fun(Z) -> Z end, P)) || P <- [P1, P2]]).
