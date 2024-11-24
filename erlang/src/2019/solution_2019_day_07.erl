-module(solution_2019_day_07).
-import('utils', [read_as_integers/2, replace_nth_value/3]).
-export([main/1]).

main([FileName | _]) ->
  IntCode = read_as_integers(FileName, ","),
  PhaseCodes = [5, 6, 7, 8, 9],
  Amplifiers = #{5 => {IntCode, 1, [5]}, 6 => {IntCode, 1, [6]}, 7 => {IntCode, 1, [7]}, 8 => {IntCode, 1, [8]}, 9 => {IntCode, 1, [9]}},
  Amplified = [calculate(Amplifiers, [A, B, C, D, E]) ||
    A <- PhaseCodes, B <- PhaseCodes, C <- PhaseCodes, D <- PhaseCodes, E <- PhaseCodes, all_unique([A, B, C, D, E])],
  lists:max(Amplified).

all_unique(List) ->
  length(List) == length(utils:remove_dups(List)).

calculate(Amplifiers, PhaseCodes) ->
  {IntCode, Start, Input} = maps:get(lists:nth(1, PhaseCodes), Amplifiers),
  calculate(maps:put(lists:nth(1, PhaseCodes), {IntCode, Start, Input ++ [0]}, Amplifiers), PhaseCodes, 0).

calculate(Amplifiers, PhaseCodes, Output) ->
  {IntCode, Start, Input} = maps:get(lists:nth(1, PhaseCodes), Amplifiers),
  [Head | T] = lists:sublist(IntCode, Start, 4),
  [_, {B, []}, {C, []}, {D, []}, {E, []}] = [string:to_integer(integer_to_list(N - 48)) || N <- io_lib:format("~5..0B", [Head])],
  Code = D * 10 + E,
  case Code of
    X when X == 99 -> {halted, Output};
    X when X == 1; X == 2; X == 7; X == 8 ->
      [Pos1, Pos2, Pos3] = T,
      Num1 = find(C, Pos1, IntCode),
      Num2 = find(B, Pos2, IntCode),
      Sum = if
              X == 1 -> Num1 + Num2;
              X == 2 -> Num1 * Num2;
              X == 7 -> if Num1 < Num2 -> 1; true -> 0 end;
              X == 8 -> if Num1 == Num2 -> 1; true -> 0 end
            end,
      NewIntCode = replace_nth_value(IntCode, Pos3, Sum),
      calculate(maps:put(lists:nth(1, PhaseCodes), {NewIntCode, Start + 4, Input}, Amplifiers), PhaseCodes, Output);
    X when X == 3; X == 4 ->
      [Param | _] = T,
      Num1 = find(C, Param, IntCode),
      if
        X == 3 ->
          [V | OtherInput] = if Input == [] -> [Output]; true -> Input end,
          NewIntCode = replace_nth_value(IntCode, Param, V),
          calculate(maps:put(lists:nth(1, PhaseCodes), {NewIntCode, Start + 2, OtherInput}, Amplifiers), PhaseCodes, Output);
        X == 4 ->
          [First | [Second | Tail]] = PhaseCodes,
          calculate(maps:put(lists:nth(1, PhaseCodes), {IntCode, Start + 2, Input}, Amplifiers), [Second] ++ Tail ++ [First], Num1)
      end;
    X when X == 5; X == 6 ->
      [Pos1, Pos2 | _] = T,
      Num1 = find(C, Pos1, IntCode),
      Num2 = find(B, Pos2, IntCode),
      if
        X == 5, Num1 /= 0 ->
          calculate(maps:put(lists:nth(1, PhaseCodes), {IntCode, Num2 + 1, Input}, Amplifiers), PhaseCodes, Output);
        X == 6, Num1 == 0 ->
          calculate(maps:put(lists:nth(1, PhaseCodes), {IntCode, Num2 + 1, Input}, Amplifiers), PhaseCodes, Output);
        true ->
          calculate(maps:put(lists:nth(1, PhaseCodes), {IntCode, Start + 3, Input}, Amplifiers), PhaseCodes, Output)
      end;
    _ -> io:format("failed.")
  end.

find(Mode, Pos, List) ->
  if Mode == 0 -> lists:nth(Pos + 1, List);
    true -> Pos
  end.
