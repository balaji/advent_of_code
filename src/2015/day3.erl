-module(day3).

-export([main/1]).

main([FileName | _]) ->
  L = utils:content(FileName),
  [R1, R2] = split_map(L, 0, [[], []]),
  io:format("~p~n",
    [sets:size(sets:union(find_houses(R1, 0, 0, sets:new()),
      find_houses(R2, 0, 0, sets:new())))]).

split_map([], _, Res) -> Res;
split_map([H | T], Index, [Ac1, Ac2]) when Index == 0 ->
  split_map(T, 1, [Ac1 ++ [H], Ac2]);
split_map([H | T], Index, [Ac1, Ac2]) when Index == 1 ->
  split_map(T, 0, [Ac1, Ac2 ++ [H]]).

find_houses([], _, _, S) ->
  io:format("~p~n", [sets:to_list(S)]), S;
find_houses([H | T], X, Y, S) ->
  case H of
    $^ ->
      find_houses(T, X, Y + 1,
        sets:add_element({X, Y + 1},
          sets:add_element({X, Y}, S)));
    $> ->
      find_houses(T, X + 1, Y,
        sets:add_element({X + 1, Y},
          sets:add_element({X, Y}, S)));
    $< ->
      find_houses(T, X - 1, Y,
        sets:add_element({X - 1, Y},
          sets:add_element({X, Y}, S)));
    $v ->
      find_houses(T, X, Y - 1,
        sets:add_element({X, Y - 1},
          sets:add_element({X, Y}, S)))
  end.
