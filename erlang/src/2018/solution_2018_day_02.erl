-module(solution_2018_day_02).
-author("balaji").

%% API
-export([main/1]).


main([FileName | _]) ->
  [H | L] = string:tokens(utils:content(FileName), "\n"),
  Part1 = checksum([H | L]),
  io:format("~p~n", [Part1]),
  part2([H | L], L, [H | L]).

checksum(L) -> checksum(L, 0, 0).

checksum([], Twos, Threes) -> Twos * Threes;
checksum([H | T], Twos, Threes) ->
  ValueSet = sets:from_list(maps:values(to_map(H, maps:new()))),
  HasTwo = sets:is_element(2, ValueSet),
  HasThree = sets:is_element(3, ValueSet),
  checksum(T, if HasTwo == false -> Twos;
                true -> Twos + 1
              end,
    if HasThree == false -> Threes;
      true -> Threes + 1
    end).

to_map([], Map) -> Map;
to_map([H | T], Map) ->
  to_map(T, maps:put(H, maps:get(H, Map, 0) + 1, Map)).


part2([_], [], _) -> {};
part2([_ | [I | Ti]], [], L) -> part2([I | Ti], Ti, L);
part2([I | Tx], [J | Tj], L) ->
  Found = find(I, J),
  case Found of
    false ->
      part2([I | Tx], Tj, L);
    true ->
      io:format("found ~p, ~p~n", [I, J])
  end.

find([_], [_]) -> true;
find(I, J) ->
  Ip1 = string:slice(I, 0, floor(string:length(I) / 2)),
  Ip2 = string:slice(I, floor(string:length(I) / 2)),
  Jp1 = string:slice(J, 0, floor(string:length(J) / 2)),
  Jp2 = string:slice(J, floor(string:length(J) / 2)),
  if
    Ip1 == Jp1 -> find(Ip2, Jp2);
    Ip2 == Jp2 -> find(Ip1, Jp1);
    true -> false
  end.
