-module(solution_2015_day_04).

-export([main/1]).

-import(erlang, [md5/1]).

main([_]) ->
    io:format("~p~n", [find("yzbqklnj", 1)]).

find(String, Index) ->
    <<A, B, C, D, E, F, _/binary>> = utils:bin_to_hex(md5(String ++ integer_to_list(Index))),
    if A == $0, B == $0, C == $0, D == $0, E == $0, F == $0 ->
           Index;
       true ->
           find(String, Index + 1)
    end.
