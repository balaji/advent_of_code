-module(solution_2021_day_03).

-export([main/1, run/0]).

main(FileName) ->
    solve(utils:lines(FileName)).

solve(L) ->
    [{part1, part1(L), {part2, part2(L)}}].

run() ->
    solve([
        "00100",
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
        "01010"
    ]).

groups(L) ->
    M = maps:groups_from_list(
        fun(X) ->
            case X of
                $1 -> one;
                $0 -> zero;
                _ -> error
            end
        end,
        L
    ),
    #{one => length(maps:get(one, M, [])), zero => length(maps:get(zero, M, []))}.

most_common(#{one := O, zero := Z}) when O == Z -> $1;
most_common(#{one := O, zero := Z}) when O > Z -> $1;
most_common(#{one := _, zero := _}) -> $0.

least_common(#{one := O, zero := Z}) when O == Z -> $0;
least_common(#{one := O, zero := Z}) when O > Z -> $0;
least_common(#{one := _, zero := _}) -> $1.

group_bits(List) ->
    [groups(L) || L <- utils:transpose(List)].

part1(List) ->
    Gamma = list_to_integer([most_common(E) || E <- group_bits(List)], 2),
    Gamma * (Gamma bxor 2#111111111111).

part2(List) ->
    find_the_one(List, fun most_common/1) *
        find_the_one(List, fun least_common/1).

find_the_one(List, F) ->
    Length = length(hd(List)),
    list_to_integer(
        hd(
            lists:foldl(
                fun(Index, A) ->
                    case length(A) of
                        1 -> A;
                        _ -> filter(A, Index, F(lists:nth(Index, group_bits(A))))
                    end
                end,
                List,
                lists:seq(1, Length)
            )
        ),
        2
    ).

filter(List, Index, C) ->
    lists:filter(fun(E) -> lists:nth(Index, E) == C end, List).
