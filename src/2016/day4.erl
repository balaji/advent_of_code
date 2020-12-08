-module(day4).

-export([main/1]).

main([FileName | _]) ->
    L = lists:map(fun (T) ->
                          [Ac, Order | _] = re:split(T, "[\\[\\]]+", [{return, list}]),
                          Y = string:split(Ac, "-", all),
                          {Ac, lists:merge(lists:sublist(Y, 1, length(Y) - 1)),
                           [list_to_integer(lists:nth(length(Y), Y)), Order]}
                  end,
                  utils:as_strings(FileName)),
    X = lists:map(fun({T, Str, [Num, Order]}) -> 
            Inter = [ A || {A, _} <- lists:sort(fun({_, V1}, {_, V2}) -> V1 >= V2  end, maps:to_list(make_map(Str, maps:new())))],
            Sub = lists:sublist(Inter, 1, 5),
            if Sub == Order -> {defined, {T, Num}};
                true -> undefined
            end
        end, L),
    io:format("~p~n", [lists:filter(fun({_, S}) -> string:rstr(S, "pole") /= 0 end, lists:map(fun(E) -> dechiper(E) end, X))]).

dechiper(H) ->
    case H of
        undefined -> {0, ""};
        {defined, {T, Num}} -> shift(T, Num, [])
    end. 

shift([], Num, Acc) -> {Num, Acc};
shift([H | T], Num, Acc) ->
    case H of 
        $- when Num div 2 == 0 -> shift(T, Num, Acc ++ [H]);
        $- when Num div 2 /= 0 -> shift(T, Num, Acc ++ [$ ]);
        V ->
            Y = Num rem 26,
            if V + Y =< $z -> 
                shift(T, Num, Acc ++ [V + Y]);
            true ->
                shift(T, Num, Acc ++ [V + Y - 26])
            end
    end.

make_map([], Map) -> Map;
make_map([H | T], Map) -> 
    IsKey = maps:is_key(H, Map),
    if IsKey == true -> make_map(T, maps:put(H, maps:get(H, Map) + 1, Map));
        true ->  make_map(T, maps:put(H, 1, Map))
    end.
