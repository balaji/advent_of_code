-module(solution_2024_day_01).

-export([main/1, run/0]).

-import(lists, [filter/2, sum/1, zip/2, sort/1]).

main(FileName) ->
    solution(utils:as_strings(FileName)).

run() ->
    solution(["3   4", "4   3", "2   5", "1   3", "3   9", "3   3"]).

solution(List) ->
    Numbers = [[list_to_integer(E) || E <- string:split(Elem, "   ")] || Elem <- List],
    First = [E || [E | _] <- Numbers],
    Second = [E || [_, E | _] <- Numbers],
    io:format("~p~n", [similarity_score_efficient(First, Second)]),
    io:format("part1: ~p, part2: ~p~n",
              [total_distance(First, Second), similarity_score(First, Second)]).

total_distance(L1, L2) ->
    sum([abs(X - Y) || {X, Y} <- zip(sort(L1), sort(L2))]).

similarity_score(L1, L2) ->
    sum([Elem * length(filter(fun(E) -> E == Elem end, L2)) || Elem <- L1]).

similarity_score_efficient(L1, L2) ->
    M = lists:foldl(fun(E, D) -> maps:put(E, maps:get(E, D, 0) + 1, D) end, maps:new(), L2),
    sum([Elem * maps:get(Elem, M, 0) || Elem <- L1]).
