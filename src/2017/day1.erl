-module(day1).
-export([main/1]).

main([FileName | _]) ->
    Y = lists:nth(1, string:tokens(utils:content(FileName), "\n")),
    io:format("~p~n", [captcha(Y, floor(length(Y) / 2), Y, 0)]).


% captcha([H], F, Acc) when H == F -> Acc + list_to_integer([H]);
% captcha([_], _, Acc) -> Acc;
% captcha([H | [R | _]=Tail], F, Acc) when H == R -> captcha(Tail, F, Acc + list_to_integer([H]));
% captcha([_ | T], F, Acc) -> captcha(T, F, Acc).

captcha([], _, _, Acc) -> Acc;
captcha([H | T], Cur, L, Acc) ->
    Nth = lists:nth((Cur rem length(L)) + 1, L),
    if 
        Nth == H -> captcha(T, Cur + 1, L, Acc + list_to_integer([H]));
        true -> captcha(T, Cur + 1, L, Acc)
    end.
