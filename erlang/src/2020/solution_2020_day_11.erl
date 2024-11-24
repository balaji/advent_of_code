-module(solution_2020_day_11).

-export([main/1]).

main([FileName | _]) ->
  A = array:from_list(lists:map(fun(I) -> array:from_list(I) end, utils:as_strings(FileName))),
  Dim = {array:size(A), array:size(array:get(0, A))},
  io:format("part 1: ~p, part 2: ~p~n", [
    play(A, Dim, {fun(Arr, Pi, Pj, Li, Lj) -> part1(Arr, Pi, Pj, Li, Lj) end, 4}),
    play(A, Dim, {fun(Arr, Pi, Pj, Li, Lj) -> part2(Arr, Pi, Pj, Li, Lj) end, 5})
  ]).

play(A, Dim, PartFn) ->
  R = game(A, A, 0, 0, Dim, PartFn),
  case R == A of
    true -> count_seats(R);
    _ -> play(R, Dim, PartFn)
  end.

count_seats(A) ->
  array:foldl(
    fun(_, V, Sum) ->
      Sum + array:foldl(
        fun(_, I, Acc) ->
          if I == $# -> Acc + 1; true -> Acc end
        end, 0, V)
    end, 0, A).

game(A, Modified, I, J, {Li, Lj}, {Fn, Limit} = PartFn) ->
  case I < Li of
    true when J < Lj ->
      case utils:array_get(A, I, J) of
        $. -> game(A, Modified, I, J + 1, {Li, Lj}, PartFn);
        Y ->
          case {Y, occupied(Fn(A, I, J, Li, Lj), 0)} of
            {$#, X} when X >= Limit -> game(A, utils:array_set(Modified, I, J, $L), I, J + 1, {Li, Lj}, PartFn);
            {$L, X} when X == 0 -> game(A, utils:array_set(Modified, I, J, $#), I, J + 1, {Li, Lj}, PartFn);
            _ -> game(A, Modified, I, J + 1, {Li, Lj}, PartFn)
          end
      end;
    true when J >= Lj -> game(A, Modified, I + 1, 0, {Li, Lj}, PartFn);
    _ -> Modified
  end.

part1(Arr, Pi, Pj, Li, Lj) ->
  lists:map(fun({A, B}) -> utils:array_get(Arr, A, B) end,
    lists:filter(fun({A, B}) -> (A < Li) and (B < Lj) and (A >= 0) and (B >= 0) end,
      [
        {Pi, Pj + 1},
        {Pi, Pj - 1},
        {Pi + 1, Pj},
        {Pi - 1, Pj},
        {Pi + 1, Pj + 1},
        {Pi + 1, Pj - 1},
        {Pi - 1, Pj + 1},
        {Pi - 1, Pj - 1}
      ])).

part2(Arr, Pi, Pj, Li, Lj) ->
  [
    farthest(Arr, {Pi, Pj + 1}, Li, Lj, fun({A, B}) -> {A, B + 1} end),
    farthest(Arr, {Pi, Pj - 1}, Li, Lj, fun({A, B}) -> {A, B - 1} end),
    farthest(Arr, {Pi + 1, Pj}, Li, Lj, fun({A, B}) -> {A + 1, B} end),
    farthest(Arr, {Pi - 1, Pj}, Li, Lj, fun({A, B}) -> {A - 1, B} end),
    farthest(Arr, {Pi + 1, Pj + 1}, Li, Lj, fun({A, B}) -> {A + 1, B + 1} end),
    farthest(Arr, {Pi + 1, Pj - 1}, Li, Lj, fun({A, B}) -> {A + 1, B - 1} end),
    farthest(Arr, {Pi - 1, Pj + 1}, Li, Lj, fun({A, B}) -> {A - 1, B + 1} end),
    farthest(Arr, {Pi - 1, Pj - 1}, Li, Lj, fun({A, B}) -> {A - 1, B - 1} end)
  ].

farthest(Arr, {Pi, Pj} = CoOrds, Li, Lj, Fn) when Pi >= 0, Pj >= 0, Pi < Li, Pj < Lj ->
  case utils:array_get(Arr, Pi, Pj) of
    $. -> farthest(Arr, Fn(CoOrds), Li, Lj, Fn);
    X -> X
  end;
farthest(_, _, _, _, _) -> $..

occupied([], L) -> L;
occupied([H | T], L) when H == $# -> occupied(T, L + 1);
occupied([_ | T], L) -> occupied(T, L).
