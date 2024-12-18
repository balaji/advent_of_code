-module(solution_2020_day_16).

-export([main/1]).

main([FileName | _]) ->
    {YourTicket, NearTickets, Rules, SeatMap} = parse(utils:content(FileName)),
    R = lists:sum(
        lists:flatten(
            lists:map(
                fun(X) ->
                    lists:filter(fun(Item) -> not maps:is_key(Item, SeatMap) end, X)
                end,
                NearTickets
            )
        )
    ),
    io:format("part 1: ~p, part 2: ~p~n", [R, part2(SeatMap, Rules, YourTicket, NearTickets)]).

parse(Content) ->
    [L, Y, N] = string:split(Content, "\n\n", all),
    Rules = lists:map(
        fun(S) ->
            [Label, RangeText] = string:split(S, ": "),
            Range = [
                list_to_tuple(
                    lists:map(
                        fun(X) -> list_to_integer(X) end, string:split(R, "-")
                    )
                )
             || R <- string:split(RangeText, " or ")
            ],
            [Label, Range]
        end,
        string:tokens(L, "\n")
    ),

    [YourTicket, NearTickets] = lists:map(
        fun(X) ->
            [_ | X1] = string:tokens(X, "\n"),
            lists:map(fun(Z) -> [list_to_integer(I) || I <- string:split(Z, ",", all)] end, X1)
        end,
        [Y, N]
    ),

    SeatMap = lists:foldl(
        fun([_, [{X1, Y1}, {X2, Y2}]], MapAcc) ->
            M1 = lists:foldl(fun(P, Acc) -> maps:put(P, 1, Acc) end, MapAcc, lists:seq(X1, Y1)),
            lists:foldl(fun(P, Acc) -> maps:put(P, 1, Acc) end, M1, lists:seq(X2, Y2))
        end,
        #{},
        Rules
    ),
    {array:from_list(lists:nth(1, YourTicket)), NearTickets, Rules, SeatMap}.

part2(SeatMap, Rules, YourTicket, NearTickets) ->
    ValidSeats = lists:filter(
        fun(X) ->
            lists:foldl(fun(Item, Bool) -> Bool and maps:is_key(Item, SeatMap) end, true, X)
        end,
        NearTickets
    ),

    WithApplicableRules = lists:map(
        fun(X) ->
            lists:map(
                fun(Z) ->
                    lists:map(
                        fun([Description, [{X1, Y1}, {X2, Y2}]]) ->
                            if
                                Z >= X1, Z =< Y1 -> Description;
                                Z >= X2, Z =< Y2 -> Description;
                                true -> no
                            end
                        end,
                        Rules
                    )
                end,
                X
            )
        end,
        ValidSeats
    ),

    Accumulator = lists:map(fun(X) -> sets:from_list(X) end, lists:nth(1, WithApplicableRules)),
    TicketWithAllRules = lists:zip(
        lists:seq(1, length(Accumulator)),
        lists:foldl(
            fun(X, ListOfSets) ->
                lists:map(
                    fun({Item, Set}) ->
                        sets:intersection(sets:from_list(Item), Set)
                    end,
                    lists:zip(X, ListOfSets)
                )
            end,
            Accumulator,
            WithApplicableRules
        )
    ),

    TicketWithUniqueRule = find_unique(
        lists:sort(
            fun({_, Set1}, {_, Set2}) ->
                sets:size(Set1) < sets:size(Set2)
            end,
            TicketWithAllRules
        )
    ),

    OnlyDepartures = lists:filter(
        fun({_, S}) ->
            case string:find(lists:nth(1, S), "departure") of
                nomatch -> false;
                _ -> true
            end
        end,
        TicketWithUniqueRule
    ),
    lists:foldl(
        fun(I, Acc) -> I * Acc end,
        1,
        lists:map(fun({I, _}) -> array:get(I - 1, YourTicket) end, OnlyDepartures)
    ).

find_unique([]) ->
    [];
find_unique([{J, S} | Rules]) ->
    [H | _] = L = sets:to_list(S),
    [{J, L}] ++ find_unique(lists:map(fun({I, Set}) -> {I, sets:del_element(H, Set)} end, Rules)).
