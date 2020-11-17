-module(day12).

-export([main/0]).


main() ->
  C = string:tokens(utils:content("inputs/day12.txt"), "\n"),
  Moons = convert(C, []),
  Velocities = [array:to_list(array:new(3, {default, 0})),
    array:to_list(array:new(3, {default, 0})),
    array:to_list(array:new(3, {default, 0})),
    array:to_list(array:new(3, {default, 0}))],
  steps(Moons, Velocities, Moons, Velocities,lists:seq(1, 4, 1), lists:seq(1, 3, 1), 0).

steps(Moons, Velocities, OrigMoon, OrigVel, _, _, Count) when Count > 1, Moons == OrigMoon, Velocities == OrigVel ->
  Count;
steps(Moons, Velocities, Om, Ov, Index, Index3, Count) ->
  NewVelocities = new_velocities(Moons, Velocities, Index, Index3),
  NewMoons = new_moons(Moons, NewVelocities, []),
  steps(NewMoons, NewVelocities, Om, Ov, Index, Index3, Count + 1).

total_energy([], [], Acc) -> lists:sum(Acc);
total_energy([Moon | M], [Velocity | V], Acc) ->
  total_energy(M, V, [energy(Moon) * energy(Velocity) | Acc]).

energy(List) ->
  lists:foldl(fun(X, Sum) -> abs(X) + Sum end, 0, List).

new_velocities(Moons, Velocities, Index4, Index3) ->
  Flat = [new_velocity(Moons, Velocities, [], X, Y, Index4) || X <- Index4, Y <- Index3],
  to_velocity(Flat, []).

to_velocity([], Acc) -> Acc;
to_velocity([X, Y, Z | T], Acc) -> to_velocity(T, Acc ++ [[X, Y, Z]]).

new_velocity(Moons, Velocities, Acc, I, J, Index) ->
  V = utils:array_fetch(Velocities, I, J),
  A = utils:array_fetch(Moons, I, J),
  Rest = [utils:array_fetch(Moons, Seq, J) || Seq <- lists:delete(I, Index)],
  Acc ++ lists:sum([if
                      R == A -> 0;
                      R < A -> -1;
                      true -> 1
                    end || R <- Rest] ++ [V]).

new_moons([], [], Acc) -> Acc;
new_moons([Moon | Mr], [Velocity | Vr], Acc) ->
  new_moons(Mr, Vr, Acc ++ [[M + V || {M, V} <- lists:zip(Moon, Velocity)]]).

convert([], Acc) -> Acc;
convert([Str | T], Acc) ->
  convert(T, [[list_to_integer(lists:nth(2, string:split(S, "="))) || S <- string:split(Str, ", ", all)] | Acc]).
