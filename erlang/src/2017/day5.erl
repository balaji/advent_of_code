-module(day5).

-export([main/1]).

main([FileName | _]) ->
  L = utils:read_as_integers(FileName, "\n"),
  io:format("~p~n", [jump(array:from_list(L), 0, 0)]).

jump(L, Pointer, Steps) ->
  Size = array:size(L),
  if Pointer >= Size; Pointer < 0 -> Steps;
    true ->
      Item = array:get(Pointer, L),
      Offset = if Item >= 3 -> Item - 1; true -> Item + 1 end,
      jump(array:set(Pointer, Offset, L), Pointer + Item, Steps + 1)
  end.
