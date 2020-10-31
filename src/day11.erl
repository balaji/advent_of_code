-module(day11).
-import('utils', [read_as_integers/2, replace_nth_value/3]).

-export([main/0]).

main() ->
  IntCode = read_as_integers("inputs/day11.txt", ","),
  ZeroPaddedList = array:to_list(array:new([{size, 1000}, {default, 0}])),
  calculate(lists:append(IntCode, ZeroPaddedList), 0, 1, [], [{north, 1, {0, 0}}]).

calculate(IntCode, RelativeBase, Pointer, InputOutput, Panel) ->
  [Head | T] = lists:sublist(IntCode, Pointer, 4),
  [{A, []}, {B, []}, {C, []}, {D, []}, {E, []}] = [string:to_integer(integer_to_list(N - 48)) || N <- io_lib:format("~5..0B", [Head])],
  Code = D * 10 + E,
  case Code of
    X when X == 99 -> io:format("~p~n", [Panel]);
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
      calculate(replace_nth_value(IntCode, literal_find(A, RelativeBase, Pos3), Sum), RelativeBase, Pointer + 4, InputOutput, Panel);
    X when X == 3; X == 4; X == 9 ->
      [Param | _] = T,
      Num1 = interpreted_find(C, RelativeBase, Param, IntCode),
      if
        X == 3 ->
          if InputOutput == [] -> Input = 1, NewPanel = Panel;
            true ->
              [_, Move] = InputOutput,
              [{Direction, _, Point} | _] = Panel,
              [NewDirection, NewPoint] = change_direction(Move, Direction, Point),
              NewPanel = make_panel(Panel, {NewDirection, 0, NewPoint}),
              [{_, Input, _} | _] = NewPanel
          end,
          calculate(replace_nth_value(IntCode, literal_find(C, RelativeBase, Param), Input), RelativeBase, Pointer + 2, [], NewPanel);
        X == 4 ->
          PaintedPanel = if
                           InputOutput == [] ->
                             [{Direction, _, Point} | Tp] = Panel,
                             [{Direction, Num1, Point} | Tp];
                           true -> Panel
                         end,
          calculate(IntCode, RelativeBase, Pointer + 2, InputOutput ++ [Num1], PaintedPanel);
        X == 9 -> calculate(IntCode, RelativeBase + Num1, Pointer + 2, InputOutput, Panel)
      end;
    X when X == 5; X == 6 ->
      [Pos1, Pos2 | _] = T,
      Num1 = interpreted_find(C, RelativeBase, Pos1, IntCode),
      Num2 = interpreted_find(B, RelativeBase, Pos2, IntCode),
      if
        X == 5, Num1 /= 0 -> calculate(IntCode, RelativeBase, Num2 + 1, InputOutput, Panel);
        X == 6, Num1 == 0 -> calculate(IntCode, RelativeBase, Num2 + 1, InputOutput, Panel);
        true -> calculate(IntCode, RelativeBase, Pointer + 3, InputOutput, Panel)
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

make_panel(Panel, {D, C, {X, Y}}) ->
  Search = [{Direction, Color, {X1, Y1}} || {Direction, Color, {X1, Y1}} <- Panel, X == X1, Y == Y1],
  if
    length(Search) == 1 ->
      [{_, Cx, _} | _] = Search,
      [{D, Cx, {X, Y}}] ++ Panel;
    length(Search) > 1 -> io:format("unexpected fail~n");
    true -> [{D, C, {X, Y}} | Panel]
  end.

change_direction(Number, Direction, {X, Y}) when Number == 0, Direction == north -> [west, {X - 1, Y}];
change_direction(Number, Direction, {X, Y}) when Number == 0, Direction == east -> [north, {X, Y + 1}];
change_direction(Number, Direction, {X, Y}) when Number == 0, Direction == west -> [south, {X, Y - 1}];
change_direction(Number, Direction, {X, Y}) when Number == 0, Direction == south -> [east, {X + 1, Y}];
change_direction(Number, Direction, {X, Y}) when Number == 1, Direction == north -> [east, {X + 1, Y}];
change_direction(Number, Direction, {X, Y}) when Number == 1, Direction == east -> [south, {X, Y - 1}];
change_direction(Number, Direction, {X, Y}) when Number == 1, Direction == west -> [north, {X, Y + 1}];
change_direction(Number, Direction, {X, Y}) when Number == 1, Direction == south -> [west, {X - 1, Y}].
