-module(day8).

-export([main/0]).


main() ->
  [C | _] = utils:read_as_integers("inputs/day8.txt", ""),
  Layers = make_layers(integer_to_list(C), 25 * 6),
  {Key, _} = max_of([{Key, count_element($0, maps:get(Key, Layers))} || Key <- maps:keys(Layers)]),
  Layer = maps:get(Key, Layers),
  count_element($1, Layer) * count_element($2, Layer).

max_of([H | T]) -> max_of(T, H).
max_of([], Value) -> Value;
max_of([{K, V} | T], {_, MaxValue}) when V =< MaxValue -> max_of(T, {K, V});
max_of([_ | T], Value) -> max_of(T, Value).

make_layers(List, Split) ->
  make_layers(List, Split, maps:new(), 0).

make_layers(List, Split, Layers, Count) ->
  SubList = lists:sublist(List, (Split * Count) + 1, Split),
  case SubList of
    [] -> Layers;
    _ -> make_layers(List, Split, maps:put(Count + 1, SubList, Layers), Count + 1)
  end.

count_element(Element, List) ->
  count_element(Element, List, 0).

count_element(_, [], Acc) -> Acc;
count_element(E, [H | T], Acc) when E == H -> count_element(E, T, Acc + 1);
count_element(E, [_ | T], Acc) -> count_element(E, T, Acc).