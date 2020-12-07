-module(day7).

-export([main/1]).

main([FileName | _]) ->
    L = [string:split(S, " contain ") || S <- utils:as_strings(FileName)],
    X = lists:map(
        fun([A, B]) -> 
            K = re:replace(A, "( bag| bags)$", "", [{return, list}]),
            Vr = string:split(re:replace(B, "( bags| bag|\\.$)", "", [global, {return, list}]), ", ", all),
            V = [lists:nth(2, string:split(I, " "))|| I <- Vr],    
            [[I, K] || I <- V]
        end, L),
        M = make_map(lists:merge(X), maps:new()),
    io:format("~p~n", [sets:size(calculate_length("shiny gold", M, sets:new()))]).

make_map([], M) -> M;
make_map([[A, B] | T], M) ->
    IsKey = maps:is_key(A, M),
    if 
        IsKey == true -> L = maps:get(A, M), make_map(T, maps:put(A, L ++ [B], M));
        true -> make_map(T, maps:put(A, [B], M))
    end.

calculate_length(Key, Map, Set) ->
    IsKey = maps:is_key(Key, Map),
    if
        IsKey == false -> Set;        
        true -> 
            L = maps:get(Key, Map),
            sets:union(lists:map(fun(E)-> calculate_length(E, Map, sets:add_element(E, Set)) end, L))
    end.
