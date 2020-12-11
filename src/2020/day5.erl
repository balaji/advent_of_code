-module(day5).

-export([main/1]).

main([FileName | _]) ->
    RowNums =[row_number(L) || L <-  utils:as_strings(FileName)],
    io:format("part 1: ~p, part 2: ~p~n",
	      [lists:max(RowNums), missing_seat(lists:sort(RowNums))]).

missing_seat([F | [B | _] = R]) when F == B - 1 -> missing_seat(R);
missing_seat([_ | [B | _]]) -> B - 1.

row_number(R) ->
    list_to_integer(re:replace(re:replace(R, "[FL]", "0", [global]), "[BR]", "1", [global, {return, list}]), 2).
