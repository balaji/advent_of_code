-module(solution_2019_day_04).
-export([main/1]).

main(_) ->
    password(128392, 0).

password(643281, Acc) ->
    Acc;
password(Number, Acc) ->
    List = integer_to_list(Number),
    case List of
        [I, II, III, IV, V, VI] when I =< II, II =< III, III =< IV, IV =< V, V =< VI ->
            if
                I == II, II /= III -> password(Number + 1, Acc + 1);
                II == III, I /= II, III /= IV -> password(Number + 1, Acc + 1);
                III == IV, II /= III, IV /= V -> password(Number + 1, Acc + 1);
                IV == V, III /= IV, V /= VI -> password(Number + 1, Acc + 1);
                V == VI, IV /= V -> password(Number + 1, Acc + 1);
                true -> password(Number + 1, Acc)
            end;
        _ ->
            password(Number + 1, Acc)
    end.
