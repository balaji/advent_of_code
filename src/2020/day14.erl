-module(day14).

-export([main/1]).

main([FileName | _]) ->
    L = utils:as_strings(FileName),
    io:format("~p~n", [process(L, [], array:new())]).

process([], _, Acc) -> lists:sum(array:sparse_to_list(Acc));
process([[$m, $a, $s, $k, $ , $=, $  | R] | H], _, Acc) -> 
    process(H, R, Acc);
process([[$m, $e, $m, $[ | R] | H], Mask, Acc) ->
    [Address, Value] = string:split(R, "] = "),
    Mons = string:right(integer_to_list(list_to_integer(Value), 2), length(Mask), $0),
    process(H, Mask, array:set(list_to_integer(Address), mask(Mask, Mons, []), Acc)).

mask([], [], R) -> list_to_integer(R, 2);
mask([$X | M], [Y | V], Result) -> mask(M, V, Result ++ [Y]);
mask([$0 | M], [_ | V], Result) -> mask(M, V, Result ++ [$0]);
mask([$1 | M], [_ | V], Result) -> mask(M, V, Result ++ [$1]).
