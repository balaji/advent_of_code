-module(solution_2020_day_14).

-export([main/1]).

main([FileName | _]) ->
  L = utils:lines(FileName),
  io:format("~p~n", [process(L, [], array:new())]).

process([], _, Acc) -> lists:sum(array:sparse_to_list(Acc));
process([[$m, $a, $s, $k, $ , $=, $  | R] | H], _, Acc) -> process(H, R, Acc);
process([[$m, $e, $m, $[ | R] | H], Mask, Acc) ->
  [Address, Value] = string:split(R, "] = "),
  Mons2 = string:right(integer_to_list(list_to_integer(Address), 2), length(Mask), $0),
  MemAddrs = mask2(Mask, Mons2, [[]]),
  process(H, Mask, lists:foldl(fun(Addr, Array) -> array:set(Addr, list_to_integer(Value), Array) end, Acc, MemAddrs)).

mask2([$X | M], [_ | V], Result) -> mask2(M, V, [R ++ [B] || R <- Result, B <- [$0, $1]]);
mask2([$0 | M], [Y | V], Result) -> mask2(M, V, [R ++ [Y] || R <- Result]);
mask2([$1 | M], [_ | V], Result) -> mask2(M, V, [R ++ [$1] || R <- Result]);
mask2([], [], Result) -> [list_to_integer(R, 2) || R <- Result].
