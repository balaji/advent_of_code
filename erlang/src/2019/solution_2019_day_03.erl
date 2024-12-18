-module(solution_2019_day_03).
-export([main/1]).

main([FileName | _]) ->
    [C1, C2] = string:tokens(utils:content(FileName), "\n"),
    CoOrds1 = perform(string:tokens(C2, ","), [{0, 0, 0, 0, {0, 0}}]),
    CoOrds2 = perform(string:tokens(C1, ","), [{0, 0, 0, 0, {0, 0}}]),
    Intersections = multiply(CoOrds1, CoOrds2),
    io:format("closest: ~p~n steps: ~p~n", [
        manhattan(Intersections, 10000000), manhattan_steps(Intersections, 10000000)
    ]).

multiply([_ | ListA], [_ | ListB]) ->
    [
        if
            X1 == X2 ->
                {X2, K1,
                    intersection(S1, X1, Y1, X2, Y2, X2, K1) +
                        intersection(S2, J1, K1, J2, K2, X2, K1)};
            true ->
                {J1, Y2,
                    intersection(S1, X1, Y1, X2, Y2, J2, Y1) +
                        intersection(S2, J1, K1, J2, K2, J2, Y1)}
        end
     || {X1, Y1, X2, Y2, S1} <- ListA,
        {J1, K1, J2, K2, S2} <- ListB,
        if
            X1 == X2 ->
                K1 == K2 andalso is_between(X1, J1, J2) andalso is_between(K1, Y1, Y2);
            true ->
                J1 == J2 andalso is_between(Y1, K1, K2) andalso is_between(J1, X1, X2)
        end
    ].

intersection({Direction, Length}, X1, Y1, X2, Y2, P, Q) ->
    case Direction of
        r -> Length - abs(X2 - P);
        l -> Length - abs(P - X1);
        u -> Length - abs(Y2 - Q);
        _ -> Length - abs(Q - Y1)
    end.

is_between(A, X, Y) ->
    [Min, Max] = [min(X, Y), max(X, Y)],
    A >= Min andalso A =< Max.

manhattan([], Shortest) -> Shortest;
manhattan([{0, 0, _} | T], Shortest) -> manhattan(T, Shortest);
manhattan([{A, B, _} | T], Acc) -> manhattan(T, min(Acc, abs(A) + abs(B))).

manhattan_steps([], Steps) -> Steps;
manhattan_steps([{0, 0, _} | T], Shortest) -> manhattan_steps(T, Shortest);
manhattan_steps([{_, _, Steps} | T], Acc) -> manhattan_steps(T, min(Acc, Steps)).

perform([], Acc) ->
    Acc;
perform([[H | Dist] | T], Acc) ->
    {R, _} = string:list_to_integer(Dist),
    {_, _, X, Y, {_, S}} = lists:last(Acc),
    case H of
        V when V == $R -> perform(T, Acc ++ [{X, Y, X + R, Y, {r, S + R}}]);
        V when V == $L -> perform(T, Acc ++ [{X, Y, X - R, Y, {l, S + R}}]);
        V when V == $D -> perform(T, Acc ++ [{X, Y, X, Y - R, {d, S + R}}]);
        _ -> perform(T, Acc ++ [{X, Y, X, Y + R, {u, S + R}}])
    end.
