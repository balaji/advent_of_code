-module(solution_2019_day_08).

-export([main/1]).


main([FileName | _]) ->
  C = utils:content(FileName),
  LayersMap = make_layers(C, 25 * 6),
  [First | Layers] = LayersMap,
  Layer = min_of(Layers, First),
  io:format("~p ~p ~n", [count_element($1, Layer) * count_element($2, Layer), superimpose(Layers, First)]).

superimpose([], Result) -> Result;
superimpose([F | T], Result) ->
  superimpose(T, merge(Result, F, [])).

merge([], [], R) -> R;
merge([$2 | Ad], [B | Bd], R) -> merge(Ad, Bd, R ++ [B]);
merge([A | Ad], [_ | Bd], R) -> merge(Ad, Bd, R ++ [A]).

min_of([], Value) -> Value;
min_of([H | T], Value) ->
  [Vc, Hc] = [count_element($0, Value), count_element($0, H)],
  if Vc > Hc -> min_of(T, H);
    true -> min_of(T, Value)
  end.

make_layers(List, Split) -> make_layers(List, Split, [], []).

make_layers([], _, _, R) -> R;
make_layers(L, Split, Acc, R) when length(Acc) == Split -> make_layers(L, Split, [], R ++ [Acc]);
make_layers([H | T], Split, Acc, R) -> make_layers(T, Split, Acc ++ [H], R).

count_element(Element, List) ->
  count_element(Element, List, 0).

count_element(_, [], Acc) -> Acc;
count_element(E, [H | T], Acc) when E == H -> count_element(E, T, Acc + 1);
count_element(E, [_ | T], Acc) -> count_element(E, T, Acc).
