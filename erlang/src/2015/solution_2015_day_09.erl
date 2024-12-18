-module(solution_2015_day_09).

-export([run/0, main/1]).

main(FileName) ->
    solution(utils:lines(FileName)).

parse(S) ->
    lists:foldl(
        fun(E, {M_acc, L_acc}) ->
            [M, L] =
                case re:run(E, "(\\w+) to (\\w+) = (\\d+)", [{capture, all, list}]) of
                    {match, [_, A, B, C]} ->
                        Distance = list_to_integer(C),
                        [#{A ++ B => Distance, B ++ A => Distance}, [A, B]];
                    _ ->
                        error
                end,
            {maps:merge(M, M_acc), L_acc ++ L}
        end,
        {maps:new(), []},
        S
    ).

distance(K, M) ->
    lists:map(
        fun(Keys) ->
            lists:foldl(fun(Key, Acc) -> maps:get(Key, M) + Acc end, 0, Keys)
        end,
        [lists:zipwith(fun(X, Y) -> X ++ Y end, tl(L), lists:droplast(L)) || L <- K]
    ).

solution(Inp) ->
    {M, L} = parse(Inp),
    Distances = distance(utils:permutations(lists:uniq(L)), M),
    [{part1, lists:min(Distances)}, {part2, lists:max(Distances)}].

run() ->
    solution([
        "London to Dublin = 464",
        "London to Belfast = 518",
        "Dublin to Belfast = 141"
    ]).
