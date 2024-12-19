-module(solution_2015_day_10).
-export([run/0]).

solution(N) ->
    solution(N, 1, []).

solution([A], C, Acc) ->
    string:reverse(string:join([[A], integer_to_list(C) | Acc], ""));
solution([A, B | T], C, Acc) when A == B -> solution([B | T], C + 1, Acc);
solution([A, B | T], C, Acc) when A /= B ->
    solution([B | T], 1, [[A], integer_to_list(C) | Acc]).

repeat(L, N) ->
    lists:foldl(fun(_, Acc) -> solution(Acc) end, L, lists:seq(1, N)).

run() ->
    [{part1, length(repeat("1321131112", 40))}, {part2, length(repeat("1321131112", 50))}].
