-module(utils).

-export([read_as_integers/2, content/1, replace_nth_value/3, remove_dups/1, gcd/2, array_fetch/3]).

read_as_integers(FileName, SplitToken) ->
  Content = content(FileName),
  [begin {Int, _} = string:to_integer(Token), Int end || Token <- string:tokens(Content, SplitToken)].

content(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  try raw_content(Device, "")
  after file:close(Device)
  end.

raw_content(Device, Content) ->
  case io:get_line(Device, "") of
    eof -> Content;
    Line -> raw_content(Device, Line ++ Content)
  end.

replace_nth_value(List, Position, Value) ->
  {L, [_ | R]} = lists:split(Position, List),
  L ++ [Value] ++ R.

remove_dups([])    -> [];
remove_dups([H|T]) -> [H | [X || X <- remove_dups(T), X /= H]].

gcd(A, B) when B > A -> gcd(B, A);
gcd(A, 0) -> A;
gcd(A, B) when A rem B > 0 -> gcd(B, A rem B);
gcd(A, B) when A rem B == 0 -> B.

array_fetch(Array, I, J) ->
  lists:nth(J, lists:nth(I, Array)).
