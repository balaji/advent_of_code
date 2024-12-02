-module(solution_2024_day_01).

-export([main/1, run/0]).

-import(lists, [map/2, nth/2, filter/2, sum/1, zip/2, sort/1, nth/2]).
-import(string, [split/2]).
-import(utils, [transpose/1]).

main(FileName) ->
    solution(utils:as_strings(FileName)).

run() ->
    solution(["3   4", "4   3", "2   5", "1   3", "3   9", "3   3"]).

solution(List) ->
    [First, Second] =
        transpose([[list_to_integer(E) || E <- split(Elem, "   ")] || Elem <- List]),
    [total_distance(First, Second), similarity_score(First, Second)].

total_distance(L1, L2) ->
    sum([abs(X - Y) || {X, Y} <- zip(sort(L1), sort(L2))]).

similarity_score(L1, L2) ->
    sum([Elem * length(filter(fun(E) -> E == Elem end, L2)) || Elem <- L1]).
