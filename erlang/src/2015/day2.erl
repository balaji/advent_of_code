-module(day2).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = string:tokens(utils:content(FileName), "\n"),
  Ld = [[begin {Int, _} = string:to_integer(T), Int end || T <- string:split(Str, "x", all)] || Str <- L],
  io:format("~p~n", [lists:sum([wrapping_paper(I) || I <- Ld])]),
  io:format("~p", [lists:sum([ribbon(I) || I <- Ld])]).

wrapping_paper([L, W, H]) ->
  Rect = [(L * W), (W * H), (H * L)],
  lists:sum([2 * X || X <- Rect]) + lists:min(Rect).

ribbon([L, W, H]) ->
  [L1, L2, _] = lists:sort([L, W, H]),
  L1 + L1 + L2 + L2 + (L * W * H).
