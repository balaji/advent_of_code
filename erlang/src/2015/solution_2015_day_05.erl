-module(solution_2015_day_05).

-export([main/1]).

main([FileName | _]) ->
  L = utils:as_strings(FileName),
  io:format("~p, ~p~n",
    [lists:sum([score(part1(I, [], {false, false})) || I <- L]), lists:sum([score({rule2(I), rule1(I)}) || I <- L])]).

part1([], _, R) -> R;
part1([_], _, {false, _} = R) -> R;
part1([A], Vowels, {true, _}) ->
  VS = make_vowel(A, Vowels),
  part1([], VS, {true, length(VS) >= 3});
part1([A | [B | _] = T], Vowels, Checks) ->
  case Checks of
    {C1, _} ->
      Tx = [A, B],
      if Tx == "ab"; Tx == "cd"; Tx == "pq"; Tx == "xy" -> 0;
        true ->
          Same = if C1 == false -> A == B;
                   true -> C1
                 end,
          VowelSet = make_vowel(A, Vowels),
          part1(T, VowelSet, {Same, length(VowelSet) >= 3})
      end
  end.

make_vowel(A, Vowels) ->
  IsVowel = sets:is_element(A,
    sets:from_list([$a, $e, $i, $o, $u])),
  if IsVowel == true -> [A | Vowels];
    true -> Vowels
  end.

score({true, true}) -> 1;
score(_) -> 0.

rule1([_ | T] = L) ->
  {First, S1} = sub_rule1(L),
  {Second, S2} = sub_rule1(T),
  if First; Second -> true;
    true ->
      Repeats = sets:to_list(sets:intersection(S1, S2)),
      case length(Repeats) of
        0 -> false;
        1 -> length(string:split(L, lists:nth(1, Repeats), all)) > 2;
        _ -> true
      end
  end.

sub_rule1(L) ->
  L1 = to_list(L),
  S1 = sets:from_list(L1),
  {length(L1) > sets:size(S1), S1}.

to_list(T) ->
  lists:filter(fun(I) -> length(I) > 1 end, lists:map(fun(I) -> string:slice(T, I, 2) end, lists:seq(0, length(T), 2))).

rule2([A, _, A | _]) -> true;
rule2([_ | T]) -> rule2(T);
rule2(L) when length(L) < 3 -> false.
