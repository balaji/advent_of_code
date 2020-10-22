-module(day1).

-export([main/1]).

main([FileName | _]) ->  
  calculate(utils:read(FileName), 0).

calculate([N | T], Accum) ->
  calculate(T, Accum + fuel(N));
calculate([], Accum) ->
  io:format("~p~n", [Accum]).

fuel(N) ->
  V = floor(N / 3) - 2,
  case V of
    X when X < 6 ->  V;
    Y when Y >= 6 -> V + fuel(Y);
    _ -> V
  end.
