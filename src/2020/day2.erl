-module(day2).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  L = string:tokens(utils:content(FileName), "\n"),
  F = lists:map(
    fun(Str) ->
      [Limits, [Char | _], Password] = string:tokens(Str, " "),
      [Lower, Upper] = [begin {N, _} = string:list_to_integer(S), N end || S <- string:tokens(Limits, "-")],
      [Lower, Upper, Char, Password]
    end, L),
  io:format("~p~n", [lists:sum([valid_password(S) || S <- F])]),
  io:format("~p~n", [lists:sum([valid_password2(S) || S <- F])]).

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
