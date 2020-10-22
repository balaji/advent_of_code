-module(advent_of_code).

-export([main/1]).

main([FileName | _]) ->  
  readlines(FileName).

calculate([N | T], Accum) ->
  calculate(T, Accum + fuel(N));
calculate([], Accum) ->
  io:format("~p~n", [Accum]).

fuel(N) ->
  V = floor(N / 3) - 2,
  case V of
    X when X < 6 ->
      V;
    Y when Y >= 6 ->
      V + fuel(Y);
    _ -> V
  end.

readlines(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device, [])
  after file:close(Device)
  end.

get_all_lines(Device, List) ->
  case io:get_line(Device, "") of
    eof -> calculate(List, 0);
    Line -> get_all_lines(Device, [list_to_integer(string:trim(Line)) | List])
  end.
