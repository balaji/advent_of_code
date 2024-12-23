-module(solution_2021_day_06).
-export([run/0, main/1, solve/2]).

main(FileName) ->
    solve(hd(utils:lines(FileName)), 80).

run() ->
    solve("3,4,3,1,2", 24).

prep([], A, C) -> lists:merge(lists:reverse(A), [9 || _ <- lists:seq(1, C)]);
prep([H | T], A, C) when H == 0 -> prep(T, [7 | A], C + 1);
prep([H | T], A, C) -> prep(T, [H | A], C).

cycle(L) -> lists:map(fun(E) -> E - 1 end, prep(L, [], 0)).

solve(Str, N) ->
    Fishes = [list_to_integer(F) || F <- string:split(Str, ",", all)],
    After = lists:foldl(fun(_, A) -> cycle(A) end, Fishes, lists:seq(1, N)),
    length(After).
