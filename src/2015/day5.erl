-module(day5).

-export([main/1]).

main([FileName | _]) ->
    L = utils:as_strings(FileName),
    io:format("~p~n",
              [lists:sum([part1(I, [], {false, false}) || I <- L])]).

part1([], _, {true, true}) -> 1;
part1([], _, _) -> 0;
part1([_], _, {false, _}) -> 0;
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
