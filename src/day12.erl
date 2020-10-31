-module(day12).

-export([main/0]).


main() ->
  C = string:tokens(utils:content("inputs/day12.txt"), "\n"),
  C.
