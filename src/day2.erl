-module(day2).

-export([main/1]).

main([FileName | _]) ->
  IntCode = utils:read(FileName, ","),
  IntCode.