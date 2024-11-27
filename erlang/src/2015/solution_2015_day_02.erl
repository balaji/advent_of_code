-module(solution_2015_day_02).

-export([main/1, run/0]).

-import(string, [to_integer/1, split/3, tokens/2]).
-import(lists, [sum/1, min/1, sort/1]).

main(FileName) ->
    find_answer(tokens(utils:content(FileName), "\n")).

find_answer(Inp) ->
    Ld = [[I || {I, _} <- [to_integer(T) || T <- split(Str, "x", all)]] || Str <- Inp],
    io:format("~p~n", [sum([wrapping_paper(L, W, H) || [L, W, H | _] <- Ld])]),
    io:format("~p", [sum([ribbon(L, W, H) || [L, W, H | _] <- Ld])]).

wrapping_paper(L, W, H) ->
    Rect = [L * W, W * H, H * L],
    sum([2 * X || X <- Rect]) + min(Rect).

ribbon(L, W, H) ->
    [L1, L2, _] = sort([L, W, H]),
    L1 + L1 + L2 + L2 + L * W * H.

run() ->
    find_answer(["1x1x10", "2x3x4"]).
