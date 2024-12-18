-module(solution_2024_day_03).

-export([main/1, run/0]).

run() ->
    solution(
        "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul("
        "8,5))"
    ).

solution(Str) ->
    io:format(
        "~p~n",
        [
            [
                case re:run(Str, Regex, [global]) of
                    {match, L} ->
                        solve(L, Str, true, 0);
                    nomatch ->
                        error
                end
             || Regex <- ["mul\\(\\d+,\\d+\\)", "mul\\(\\d+,\\d+\\)|don't\\(\\)|do\\(\\)"]
            ]
        ]
    ).

solve([], _, _, Prod) ->
    Prod;
solve([[{_, Length}] | T], Str, _, Prod) when Length == 4 ->
    % do()
    solve(T, Str, true, Prod);
solve([[{_, Length}] | T], Str, _, Prod) when Length == 7 ->
    % don't()
    solve(T, Str, false, Prod);
solve([_ | T], Str, false, Prod) ->
    solve(T, Str, false, Prod);
solve([[{Start, Length}] | T], Str, true, Prod) ->
    [N1, N2] =
        string:split(
            string:sub_string(Str, Start + 5, Start - 1 + Length), ","
        ),
    solve(T, Str, true, Prod + list_to_integer(N1) * list_to_integer(N2)).

main(FileName) ->
    solution(utils:content(FileName)).
