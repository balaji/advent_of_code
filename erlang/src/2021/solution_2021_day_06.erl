-module(solution_2021_day_06).
-export([run/0, main/1]).

main(FileName) ->
    {bruteforce(hd(utils:lines(FileName)), 80), algorithm(hd(utils:lines(FileName)), 80)}.

run() ->
    bruteforce("3,4,3,1,2", 18).

algorithm(Line, Days) ->
    M = maps:groups_from_list(fun(E) -> E end, [
        list_to_integer(E)
     || E <- string:split(Line, ",", all)
    ]),
    bucket_add(maps:map(fun(_, V) -> length(V) end, M), 1, Days).

bucket_add(M, D, F) when D == F ->
    maps:fold(fun(_, V, A) -> V + A end, 0, M);
bucket_add(M, Days, F) ->
    Curr_K = Days rem 9,
    Next_K = (Days + 7) rem 9,
    V1 = maps:get(Curr_K, M, 0),
    V2 = maps:get(Next_K, M, 0),
    bucket_add(maps:put(Next_K, V1 + V2, M), Days + 1, F).

bruteforce(Str, N) ->
    Fishes = [list_to_integer(F) || F <- string:split(Str, ",", all)],
    After = lists:foldl(fun(_, A) -> cycle(A) end, Fishes, lists:seq(1, N)),
    length(After).

prep([], A, C) -> lists:merge(lists:reverse(A), [9 || _ <- lists:seq(1, C)]);
prep([H | T], A, C) when H == 0 -> prep(T, [7 | A], C + 1);
prep([H | T], A, C) -> prep(T, [H | A], C).

cycle(L) -> lists:map(fun(E) -> E - 1 end, prep(L, [], 0)).
