-module(solution_2023_day_02).

-export([main/1, run/0]).

-import(string, [substr/3, split/2, split/3]).
-import(lists, [map/2, flatmap/2, foldl/3]).

run() ->
    guess_game([
        "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
        "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
        "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
        "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
        "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
    ]).

main([FileName | _]) ->
    guess_game(utils:lines(FileName)).

guess_game(L) ->
    Summary = map(fun guess_one_game/1, L),
    [
        {part1, foldl(fun({GameId, Map}, Acc) -> Acc + part1(Map, GameId) end, 0, Summary)},
        {part2, foldl(fun({_, Map}, Acc) -> Acc + part2(Map) end, 0, Summary)}
    ].

part1(#{red := Red, green := Green, blue := Blue}, GameId) ->
    if
        Red =< 12, Green =< 13, Blue =< 14 -> GameId;
        true -> 0
    end.

part2(#{red := Red, green := Green, blue := Blue}) ->
    Red * Green * Blue.

guess_one_game(Row) ->
    case re:run(Row, "^Game (\\d+): (.*)") of
        {match, [_, {Idp, Idl}, {Resp, Resl} | _]} ->
            {
                list_to_integer(substr(Row, Idp + 1, Idl)),
                foldl(
                    fun({K, V}, Map) ->
                        OldV = maps:get(K, Map, 0),
                        if
                            V > OldV -> maps:put(K, V, Map);
                            true -> Map
                        end
                    end,
                    maps:new(),
                    flatmap(
                        fun(X) ->
                            map(
                                fun(Y) ->
                                    [Num, Color | _] = split(Y, " "),
                                    {list_to_atom(Color), list_to_integer(Num)}
                                end,
                                split(X, ", ", all)
                            )
                        end,
                        split(substr(Row, Resp + 1, Resl), "; ", all)
                    )
                )
            }
    end.
