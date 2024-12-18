-module(solution_2019_day_13).
-import('utils', [read_as_integers/2, replace_nth_value/3]).

-export([main/1]).

main([FileName | _]) ->
    IntCode = read_as_integers(FileName, ","),
    calculate(
        lists:append(IntCode, array:to_list(array:new([{size, 50000}, {default, 0}]))), 0, 1, 0, 0
    ).

calculate(IntCode, RelativeBase, Start, Step, Index) ->
    [Head | T] = lists:sublist(IntCode, Start, 4),
    [A, B, C, D, E] = [
        list_to_integer(integer_to_list(N - 48))
     || N <- io_lib:format("~5..0B", [Head])
    ],
    Code = D * 10 + E,
    case Code of
        X when X == 99 -> io:format("halted~n");
        X when X == 1; X == 2; X == 7; X == 8 ->
            [Pos1, Pos2, Pos3] = T,
            Num1 = interpreted_find(C, RelativeBase, Pos1, IntCode),
            Num2 = interpreted_find(B, RelativeBase, Pos2, IntCode),
            Sum =
                if
                    X == 1 ->
                        Num1 + Num2;
                    X == 2 ->
                        Num1 * Num2;
                    X == 7 ->
                        if
                            Num1 < Num2 -> 1;
                            true -> 0
                        end;
                    X == 8 ->
                        if
                            Num1 == Num2 -> 1;
                            true -> 0
                        end
                end,
            calculate(
                replace_nth_value(IntCode, literal_find(A, RelativeBase, Pos3), Sum),
                RelativeBase,
                Start + 4,
                Step,
                Index
            );
        X when X == 3; X == 4; X == 9 ->
            [Param | _] = T,
            Num1 = interpreted_find(C, RelativeBase, Param, IntCode),
            if
                X == 3 ->
                    calculate(
                        replace_nth_value(IntCode, literal_find(C, RelativeBase, Param), 2),
                        RelativeBase,
                        Start + 2,
                        Step,
                        Index
                    );
                X == 4 ->
                    TileId = (Step + 1) rem 3,
                    if
                        TileId == 0, Num1 == 2 ->
                            io:format("Its a block ~p~n", [Index + 1]),
                            calculate(IntCode, RelativeBase, Start + 2, Step + 1, Index + 1);
                        true ->
                            calculate(IntCode, RelativeBase, Start + 2, Step + 1, Index)
                    end;
                X == 9 ->
                    calculate(IntCode, RelativeBase + Num1, Start + 2, Step, Index)
            end;
        X when X == 5; X == 6 ->
            [Pos1, Pos2 | _] = T,
            Num1 = interpreted_find(C, RelativeBase, Pos1, IntCode),
            Num2 = interpreted_find(B, RelativeBase, Pos2, IntCode),
            if
                X == 5, Num1 /= 0 -> calculate(IntCode, RelativeBase, Num2 + 1, Step, Index);
                X == 6, Num1 == 0 -> calculate(IntCode, RelativeBase, Num2 + 1, Step, Index);
                true -> calculate(IntCode, RelativeBase, Start + 3, Step, Index)
            end;
        _ ->
            io:format("failed.")
    end.

literal_find(Mode, RelativeBase, Pos) ->
    case Mode of
        2 -> RelativeBase + Pos;
        _ -> Pos
    end.

interpreted_find(Mode, RelativeBase, Pos, List) ->
    case Mode of
        0 -> lists:nth(Pos + 1, List);
        2 -> lists:nth(RelativeBase + Pos + 1, List);
        _ -> Pos
    end.
