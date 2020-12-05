-module(day5).

-export([main/1]).

main([FileName | _]) ->
    RowNums = string:tokens(utils:content(FileName), "\n"),
    io:format("~p~n",
	      [missing_seat(lists:sort([row_number(L, [{0, 127}, {0, 7}]) || L <- RowNums]))]).

missing_seat([]) -> error; %% shouldn't happen
missing_seat([F | [B | _] = R]) when F == B - 1 -> missing_seat(R);
missing_seat([F, B | _]) when F == B - 2 -> B - 1.

row_number([], [{A, B}, {X, Y}]) when A == B, X == Y -> A * 8 + Y;
row_number([], _) -> error; %%- shouldn't happen
row_number([H | T], [{A, B}, {X, Y}]) ->
    case H of
      $F -> row_number(T, [{A, A + floor((B - A) / 2)}, {X, Y}]);
      $B -> row_number(T, [{A + ceil((B - A) / 2), B}, {X, Y}]);
      $L -> row_number(T, [{A, B}, {X, X + floor((Y - X) / 2)}]);
      $R -> row_number(T, [{A, B}, {X + ceil((Y - X) / 2), Y}])
    end.
