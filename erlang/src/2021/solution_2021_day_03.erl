-module(solution_2021_day_03).

-export([main/1, run/0]).

main(FileName) ->
    solution(utils:as_strings(FileName)).

run() ->
    solution(["00100",
              "11110",
              "10110",
              "10111",
              "10101",
              "01111",
              "00111",
              "11100",
              "10000",
              "11001",
              "00010",
              "01010"]).

hack(A) ->
    if A == 48 ->
           -1;
       true ->
           1
    end.

rehack(A) ->
    if A > 0 ->
           49;
       true ->
           48
    end.

solution(L) ->
    Ha = lists:foldl(fun(E, A) -> [hack(Jd) + J || {Jd, J} <- lists:zip(E, A)] end,
                     [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                     L),
    Gamma = list_to_integer([rehack(Elem) || Elem <- Ha], 2),
    Gamma * (Gamma bxor 2#111111111111).
