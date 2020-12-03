-module(day1).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = utils:read_as_integers(FileName, "\n"),
  Part1 = frequency(L, 0),
  Part2 = find_twice(L, L, sets:new(), 0),
  io:format("~p ~p~n", [Part1, Part2]).

frequency([], Acc) -> Acc;
frequency([H | T], Acc) ->
  frequency(T, H + Acc).

find_twice([], L, Set, Acc) -> find_twice(L, L, Set, Acc);
find_twice([H | T], L, Set, Acc) ->
  V = H + Acc,
  R = sets:is_element(V, Set),
  case R of
    false ->
      find_twice(T, L, sets:add_element(V, Set), V);
    true -> V
  end.
