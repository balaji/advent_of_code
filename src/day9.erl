-module(day9).

-export([main/0]).

main() ->
  utils:read_as_integers("inputs/day9.txt", ",").
