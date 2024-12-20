-module(solution_2021_day_04).
-export([run/0, main/1]).

parse(Lines) ->
    D = string:split(Lines, "\n\n", all),
    {string:split(hd(D), ",", all), make_cards(tl(D), [])}.

make_cards([], Cards) ->
    Cards;
make_cards([H | T], Cards) ->
    Rows = string:split(H, "\n", all),
    M = [string:split(Row, " ", all) || Row <- Rows],
    P = [lists:enumerate(0, 0, lists:filter(fun(E) -> length(E) > 0 end, L)) || L <- M],
    make_cards(T, [P | Cards]).

solve({Numbers, Cards}) ->
    {_, Result} = lists:foldl(
        fun(Number, {Acc, Y}) ->
            case Acc of
                [] ->
                    {Acc, Y};
                _ ->
                    NextAcc = mark_cards(Acc, Number),
                    Bingoes = bingo_cards(NextAcc),
                    case Bingoes of
                        [{Cu, Bu} | T] when Bu == 5 ->
                            BingoCards = lists:map(fun({Car, _}) -> Car end, Bingoes),
                            {lists:subtract(NextAcc, BingoCards), [[{Number, Cu} | T] | Y]};
                        _ ->
                            {NextAcc, Y}
                    end
            end
        end,
        {mark_cards(Cards, hd(Numbers)), []},
        tl(Numbers)
    ),
    [{N1, C1} | _] = hd(Result),
    [{N2, C2} | _] = lists:last(Result),
    [
        {part1, sum_unmarked_cards(C2) * list_to_integer(N2)},
        {part2, sum_unmarked_cards(C1) * list_to_integer(N1)}
    ].

sum_unmarked_card(Card) ->
    lists:foldl(
        fun({N, E}, Ac) ->
            Ac +
                case N of
                    0 -> list_to_integer(E);
                    _ -> 0
                end
        end,
        0,
        Card
    ).

sum_unmarked_cards(Cards) ->
    lists:foldl(
        fun(Card, A) ->
            A + sum_unmarked_card(Card)
        end,
        0,
        Cards
    ).

bingo(Card) ->
    [lists:foldl(fun({N, _}, Acc) -> Acc + N end, 0, Row) || Row <- Card].

bingo_cards(Cards) ->
    Y = lists:map(
        fun(Card) ->
            {Card,
                max(
                    lists:max(bingo(Card)),
                    lists:max(bingo(utils:transpose(Card)))
                )}
        end,
        Cards
    ),
    max_bingoes(Y).

max_bingoes(Y) ->
    lists:foldl(
        fun({Card, CurrBingo}, [{_, NAc} | _] = Bingoes) ->
            case CurrBingo of
                CurrBingo when CurrBingo > NAc ->
                    [{Card, CurrBingo}];
                CurrBingo when CurrBingo == NAc ->
                    [{Card, CurrBingo} | Bingoes];
                _ ->
                    Bingoes
            end
        end,
        [hd(Y)],
        tl(Y)
    ).
mark_card(Card, Number) ->
    lists:map(
        fun(C) ->
            lists:map(
                fun({_, E} = El) ->
                    if
                        E == Number -> {1, E};
                        true -> El
                    end
                end,
                C
            )
        end,
        Card
    ).

mark_cards(Cards, Number) ->
    lists:map(fun(Card) -> mark_card(Card, Number) end, Cards).

run() ->
    Lines =
        "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1\n"
        "\n"
        "22 13 17 11  0\n"
        " 8  2 23  4 24\n"
        "21  9 14 16  7\n"
        " 6 10  3 18  5\n"
        " 1 12 20 15 19\n"
        "\n"
        " 3 15  0  2 22\n"
        " 9 18 13 17  5\n"
        "19  8  7 25 23\n"
        "20 11 10 24  4\n"
        "14 21 16 12  6\n"
        "\n"
        "14 21 17 24  4\n"
        "10 16 15  9 19\n"
        "18  8 23 26 20\n"
        "22 11 13  6  5\n"
        " 2  0 12  3  7",
    solve(parse(Lines)).

main(FileName) ->
    solve(parse(utils:content(FileName))).
