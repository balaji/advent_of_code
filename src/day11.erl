-module(day11).
-import('utils', [read_as_integers/2, replace_nth_value/3]).

-export([main/0]).

main() ->
  IntCode = read_as_integers("inputs/day11.txt", ","),
  ZeroPaddedList = array:to_list(array:new([{size, 1000}, {default, 0}])),
  calculate(lists:append(IntCode, ZeroPaddedList), 0, 1, [], north).

calculate(IntCode, RelativeBase, Pointer, InputOutput, Direction) ->
  [Head | T] = lists:sublist(IntCode, Pointer, 4),
  [{A, []}, {B, []}, {C, []}, {D, []}, {E, []}] = [string:to_integer(integer_to_list(N - 48)) || N <- io_lib:format("~5..0B", [Head])],
  Code = D * 10 + E,
  case Code of
    X when X == 99 -> io:format("halted~n");
    X when X == 1; X == 2; X == 7; X == 8 ->
      [Pos1, Pos2, Pos3] = T,
      Num1 = interpreted_find(C, RelativeBase, Pos1, IntCode),
      Num2 = interpreted_find(B, RelativeBase, Pos2, IntCode),
      Sum = if
              X == 1 -> Num1 + Num2;
              X == 2 -> Num1 * Num2;
              X == 7 -> if Num1 < Num2 -> 1; true -> 0 end;
              X == 8 -> if Num1 == Num2 -> 1; true -> 0 end
            end,
      calculate(replace_nth_value(IntCode, literal_find(A, RelativeBase, Pos3), Sum), RelativeBase, Pointer + 4, InputOutput, Direction);
    X when X == 3; X == 4; X == 9 ->
      [Param | _] = T,
      Num1 = interpreted_find(C, RelativeBase, Param, IntCode),
      if
        X == 3 ->
          io:format("io: ~p ", [InputOutput]),
          C = case InputOutput of
                [] -> io:format("entry~n"), 0;
                [Color | _] -> Color
              end,
          calculate(replace_nth_value(IntCode, literal_find(C, RelativeBase, Param), C), RelativeBase, Pointer + 2, [], Direction);
        X == 4 -> io:format("outputting: ~p~n", [Num1]),
          calculate(IntCode, RelativeBase, Pointer + 2, InputOutput ++ [Num1], Direction);
        X == 9 -> calculate(IntCode, RelativeBase + Num1, Pointer + 2, InputOutput, Direction)
      end;
    X when X == 5; X == 6 ->
      [Pos1, Pos2 | _] = T,
      Num1 = interpreted_find(C, RelativeBase, Pos1, IntCode),
      Num2 = interpreted_find(B, RelativeBase, Pos2, IntCode),
      if
        X == 5, Num1 /= 0 -> calculate(IntCode, RelativeBase, Num2 + 1, InputOutput, Direction);
        X == 6, Num1 == 0 -> calculate(IntCode, RelativeBase, Num2 + 1, InputOutput, Direction);
        true -> calculate(IntCode, RelativeBase, Pointer + 3, InputOutput, Direction)
      end;
    _ -> io:format("failed.")
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

change_direction(Number, Direction) when Direction == north, Number == 0 -> west;
change_direction(Number, Direction) when Direction == north, Number == 1 -> east;
change_direction(Number, Direction) when Direction == east, Number == 0 -> north;
change_direction(Number, Direction) when Direction == east, Number == 1 -> south;
change_direction(Number, Direction) when Direction == west, Number == 0 -> south;
change_direction(Number, Direction) when Direction == west, Number == 1 -> north;
change_direction(Number, Direction) when Direction == south, Number == 0 -> east;
change_direction(Number, Direction) when Direction == south, Number == 1 -> west.