-module(day7).

-export([main/1]).

main([FileName | _]) ->
    L = [string:split(re:replace(S, "( bags| bag|\\.$)", "", [global, {return, list}]), " contain ")
         || S <- utils:as_strings(FileName)],
    X = lists:map(fun ([K, B]) ->
                          V = lists:map(fun (I) ->
                                                [Num, Key] = string:split(I, " "),
                                                {Key,
                                                 if Num == "no" -> 0; true -> list_to_integer(Num) end}
                                        end, string:split(B, ", ", all)),
                          {K, V}
                  end, L),
    M = maps:from_list(X),
    io:format("~p, ~p~n",
              [lists:sum([if E == true -> 1; true -> 0 end
                                    || E <- [part1(K, M) || K <- maps:keys(M)]]) - 1,
               part2("shiny gold", M, 0)]).

part1(Key, Map) ->
    IsShiny = Key == "shiny gold",
    if IsShiny == true -> true;
       true ->
           case maps:is_key(Key, Map) of
               false -> false;
               true ->
                   lists:any(fun (R) -> R == true end,
                             lists:map(fun ({K, _}) -> part1(K, Map) end, maps:get(Key, Map)))
           end
    end.

part2(Key, Map, Count) ->
    IsKey = maps:is_key(Key, Map),
    if IsKey == false -> Count;
       true ->
           L = maps:get(Key, Map),
           lists:sum(lists:map(fun ({K2, C2}) -> C2 + C2 * part2(K2, Map, Count) end, L))
    end.
