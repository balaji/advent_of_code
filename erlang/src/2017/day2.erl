-module(day2).
-export([main/1]).

main([FileName | _]) ->
  Li = lists:map(fun(T) ->
    Tok = string:tokens(T, "\t"),
    lists:map(fun(E) -> list_to_integer(E) end, Tok)
                 end,
    string:tokens(utils:content(FileName), "\n")),
  io:format("~p~n",
    [lists:sum(lists:map(fun(I) ->
      even_division(lists:sort(I))
                         end,
      Li))]).

even_division([]) -> error;
even_division([H | T]) ->
  Result = check(H, T),
  case Result of
    {ok, V} -> V;
    no -> even_division(T)
  end.

check(_, []) -> no;
check(H, [F | Y]) ->
  V = F rem H,
  if V == 0 -> {ok, F div H};
    true -> check(H, Y)
  end.
