-module(utils).

-export([read/1]).

read(FileName) ->
  {ok, Device} = file:open(FileName, [read]),
  try get_all_lines(Device, [])
  after file:close(Device)
  end.

get_all_lines(Device, List) ->
  case io:get_line(Device, "") of
    eof -> List;
    Line -> get_all_lines(Device, [list_to_integer(string:trim(Line)) | List])
  end.
