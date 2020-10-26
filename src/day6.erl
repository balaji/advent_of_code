-module(day6).

-export([main/0]).


main() ->
  Content = utils:content("inputs/day6.txt"),
  OrbitMap = maps:from_list(lists:map(fun(A) ->
    [V1, V2] = string:tokens(A, ")"),
    {V2, V1} end,[Token || Token <- string:tokens(Content, "\n")])),
  count(maps:iterator(OrbitMap), 0, OrbitMap).

count(Iterator, Acc, Map) ->
  Result = maps:next(Iterator),
  case Result of
    none -> Acc;
    {_, V, I} -> count(I, Acc + path(Map, V, 1), Map)
  end.

path(Map, V, Acc) ->
  case V of
    "COM" -> Acc;
    V2 -> path(Map, maps:get(V2, Map), Acc + 1)
  end.
