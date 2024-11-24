-module(solution_2019_day_01).

-export([main/1]).

main([FileName | _]) ->
  Codes = utils:read_as_integers(FileName, "\n"),
  calculate(Codes, 0).

calculate([N | T], Acc) ->
  calculate(T, Acc + fuel(N));
calculate([], Acc) ->
  io:format("~p~n", [Acc]).

fuel(N) ->
  V = floor(N / 3) - 2,
  case V of
    X when X < 6 -> V;
    Y -> V + fuel(Y)
  end.
