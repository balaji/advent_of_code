-module(solution_2015_day_01).
-author("balaji").

%% API
-export([main/1, run/0]).


main([FileName | _]) ->
    io:format("~p", [find_floor(utils:content(FileName))]).

find_floor(L) -> find_floor(L, 0, 0).

find_floor([], Acc, I) -> {Acc, I};
find_floor(_, -1, Index) -> {-1, Index};
find_floor([$( | T], Acc, Index) -> find_floor(T, Acc + 1, Index + 1);
find_floor([$) | T], Acc, Index) -> find_floor(T, Acc - 1, Index + 1).


run() ->
    find_floor("()())").
