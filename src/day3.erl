-module(day3).
-export([main/1]).

main([FileName | _]) ->
  [C1, C2] = string:tokens(utils:content(FileName), "\n"),
  CoOrds1 = perform(string:tokens(C2, ","), [{0, 0, 0, 0, 0}]),
  CoOrds2 = perform(string:tokens(C1, ","), [{0, 0, 0, 0, 0}]),
  Intersections = multiply(CoOrds1, CoOrds2),
  io:format("~p~n~p~n~p~n", [CoOrds1, CoOrds2, Intersections]),
  manhattan(Intersections, 10000000).

multiply([_ | ListA], [_ | ListB]) ->
  [if
     X1 == X2 ->
       {Jmin, Jmax, Ymin, Ymax} = {min(J1, J2), max(J1, J2), min(Y1, Y2), max(Y1, Y2)},
       if Jmin =< X1, Jmax >= X1, Ymin =< K1, Ymax >= K1 ->
         {X2, K1, (S1 - abs(Ymax - K1)) + (S2 - abs(Jmax - X1))};
         true -> {}
       end;
     true ->
       {Kmin, Kmax, Xmin, Xmax} = {min(K1, K2), max(K1, K2), min(X1, X2), max(X1, X2)},
       if Kmin =< Y1, Kmax >= Y2, Xmin =< J1, Xmax >= J2 ->
         {J1, Y2, (S1 - abs(Xmax - J1)) + (S2 - abs(Kmax - Y1))};
         true -> {}
       end
   end || {X1, Y1, X2, Y2, S1} <- ListA, {J1, K1, J2, K2, S2} <- ListB, if
                                                                  X1 == X2 -> K1 == K2;
                                                                  true -> J1 == J2
                                                                end].

manhattan([], Shortest) -> Shortest;
manhattan([{} | T], Shortest) -> manhattan(T, Shortest);
manhattan([{0, 0, _} | T], Shortest) -> manhattan(T, Shortest);
manhattan([{A, B, _} | T], Acc) -> manhattan(T, min(Acc, abs(A) + abs(B))).

perform([], Acc) -> Acc;
perform([[H | Dist] | T], Acc) ->
  {R, _} = string:list_to_integer(Dist),
  {_, _, X, Y, S} = lists:last(Acc),
  case H of
    V when V == $R -> perform(T, Acc ++ [{X, Y, X + R, Y, S + R}]);
    V when V == $L -> perform(T, Acc ++ [{X, Y, X - R, Y, S + R}]);
    V when V == $D -> perform(T, Acc ++ [{X, Y, X, Y - R, S + R}]);
    _ -> perform(T, Acc ++ [{X, Y, X, Y + R, S + R}])
  end.
