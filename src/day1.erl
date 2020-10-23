-module(day1).

-export([main/1]).

main([FileName | _]) ->
  Codes = utils:read(FileName, "\n"),
  calculate(Codes, 0).

calculate([N | T], Acc) ->
  calculate(T, Acc + fuel(N));
calculate([], Acc) ->
  io:format("~p~n", [Acc]).

fuel(N) ->
  V = floor(N / 3) - 2,
  case V of
    X when X < 6 ->  V;
    Y when Y >= 6 -> V + fuel(Y);
    _ -> V
  end.
