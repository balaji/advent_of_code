-module(utils).

-export([read/2, replace_nth_value/3]).

read(FileName, SplitToken) ->
  {ok, Device} = file:open(FileName, [read]),
  Content = try get_content(Device, "")
            after file:close(Device)
            end,
  [begin {Int, _} = string:to_integer(Token), Int end || Token <- string:tokens(Content, SplitToken)].

get_content(Device, Content) ->
  case io:get_line(Device, "") of
    eof -> Content;
    Line -> get_content(Device, Line ++ Content)
  end.

replace_nth_value(List, Position, Value) ->
  {L, [_ | R]} = lists:split(Position, List),
  L ++ [Value] ++ R.
