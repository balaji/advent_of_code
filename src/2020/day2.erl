-module(day2).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = string:tokens(utils:content(FileName), "\n"),
  F = lists:map(
    fun(Str) ->
      [Lo, Up, C, P] = re:split(Str, "[- :]+", [{return, list}]),
      [list_to_integer(Lo), list_to_integer(Up), lists:nth(1, C), P]
    end, L),
  io:format("part 1:~p, part 2:~p~n", [lists:sum([valid_password(S) || S <- F]), lists:sum([valid_password2(S) || S <- F])]).

valid_password([Lower, Upper, Char, Password]) ->
  Count = length(lists:filter(fun(C) -> C == Char end, Password)),
  if
    Count >= Lower, Count =< Upper -> 1;
    true -> 0
  end.

valid_password2([Lower, Upper, Char, Password]) ->
  [A, B] = [lists:nth(Lower, Password), lists:nth(Upper, Password)],
  if
    A == Char, B == Char -> 0;
    A == Char; B == Char -> 1;
    true -> 0
  end.
