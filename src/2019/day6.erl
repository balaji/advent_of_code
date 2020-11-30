-module(day6).

-export([main/1]).


main([FileName | _]) ->
  Content = utils:content(FileName),
  OrbitMap = maps:from_list(lists:map(fun(A) ->
    [V1, V2] = string:tokens(A, ")"),
    {V2, V1} end, [Token || Token <- string:tokens(Content, "\n")])),
  P1 = full_path(OrbitMap, "YOU", []),
  P2 = full_path(OrbitMap, "SAN", []),
  io:format("~p ~p~n", [count(maps:iterator(OrbitMap), 0, OrbitMap), plot(P1, P2)]).

plot([H1 | T1], [H2 | T2]) when H1 == H2 -> plot(T1, T2);
plot(L1, L2) -> length(L1) + length(L2) - 2.

count(Iterator, Acc, Map) ->
  Result = maps:next(Iterator),
  case Result of
    none -> Acc;
    {_, V, I} -> count(I, Acc + length(full_path(Map, V, [])) + 1, Map)
  end.

full_path(Map, V, Acc) ->
  case V of
    "COM" -> Acc;
    V2 -> full_path(Map, maps:get(V2, Map), [V2 | Acc])
  end.
