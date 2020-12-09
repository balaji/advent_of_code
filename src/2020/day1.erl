-module(day1).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = utils:read_as_integers(FileName, "\n"),
  io:format("part 1: ~p, part 2: ~p~n", [two_sum(L, 2020, sets:from_list(L)), three_sum(L)]).

two_sum([], _, _) -> no_match;
two_sum([H | T], Target, Set) ->
  HasKey = sets:is_element(Target - H, Set),
  case HasKey of
    false -> two_sum(T, Target, Set);
    true -> H * (Target - H)
  end.

three_sum([]) -> error;
three_sum([H | T]) ->
  NewTarget = 2020 - H,
  R = two_sum(T, NewTarget, sets:from_list(T)),
  case R of
    no_match -> three_sum(T);
    V -> H * V
  end.
