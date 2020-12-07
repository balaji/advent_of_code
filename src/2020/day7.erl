-module(day7).

-export([main/1]).

main([FileName | _]) ->
    L = [string:split(S, " contain ") || S <- utils:as_strings(FileName)],
    X = lists:map(
        fun([A, B]) -> 
            K = re:replace(A, "( bag| bags)$", "", [{return, list}]),
            Vr = string:split(re:replace(B, "( bags| bag|\\.$)", "", [global, {return, list}]), ", ", all),
            V = lists:map(fun(I) -> 
                [Num, Key] = string:split(I, " "),
                C = if Num == "no" -> 0;
                    true -> list_to_integer(Num)
                end,
                {Key, C}
            end, Vr),
            [K, V]
        end, L),
        M = make_map(X, maps:new()),
io:format("~p~n", [calculate_length("shiny gold", M, 0)]).

make_map([], M) -> M;
make_map([[A, B] | T], M) ->
    IsKey = maps:is_key(A, M),
    if 
        IsKey == true -> L = maps:get(A, M), make_map(T, maps:put(A, lists:merge(L, B), M));
        true -> make_map(T, maps:put(A, B, M))
    end.

calculate_length(Key, Map, Count) ->
    IsKey = maps:is_key(Key, Map),
    if
        IsKey == false -> Count;        
        true -> 
            L = maps:get(Key, Map),
            lists:sum(lists:map(fun({K2, C2}) ->
                C2 + (C2 * calculate_length(K2, Map, Count))
            end, L))
    end.
