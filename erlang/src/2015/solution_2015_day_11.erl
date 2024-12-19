-module(solution_2015_day_11).
-export([run/0]).

run() ->
    P = solution("hepxcrrq"),
    [{part1, P}, {part2, solution(password(P))}].

has_no_sequence([A, B, C | _]) when A + 1 == B andalso B + 1 == C -> false;
has_no_sequence([_, A, B, C | T]) -> has_no_sequence([A, B, C | T]);
has_no_sequence(_) -> true.

count_pairs([A, B | T], P) when A == B -> count_pairs(T, P + 1);
count_pairs([A, B | T], P) when A /= B -> count_pairs([B | T], P);
count_pairs(_, P) -> P.

omit_invalids({L1, L2}) ->
    case L2 of
        [] -> L1;
        L2 -> L1 ++ [hd(L2)] ++ [$z || _ <- tl(L2)]
    end.

password(P) ->
    P1 = omit_invalids(lists:splitwith(fun(E) -> E /= $i end, P)),
    P2 = omit_invalids(lists:splitwith(fun(E) -> E /= $o end, P1)),
    P3 = omit_invalids(lists:splitwith(fun(E) -> E /= $l end, P2)),
    string:reverse(next_password(string:reverse(P3))).

next_password([H | T]) when H == $z ->
    [$a | next_password(T)];
next_password([H | T]) when H == $i - 1 orelse H == $o - 1 orelse H == $l - 1 -> [H + 2 | T];
next_password([H | T]) ->
    [H + 1 | T].

solution(P) ->
    Has_I = lists:member($i, P),
    Has_O = lists:member($o, P),
    Has_L = lists:member($l, P),
    Pairs = count_pairs(P, 0),
    Has_No_Sequence = has_no_sequence(P),
    case P of
        P when Has_I orelse Has_O orelse Has_L orelse Pairs < 2 orelse Has_No_Sequence ->
            solution(password(P));
        _ ->
            P
    end.
