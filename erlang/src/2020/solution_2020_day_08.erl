-module(solution_2020_day_08).

-export([main/1]).

main([FileName | _]) ->
  L = array:map(
    fun(_, S) ->
      [Inst, Arg] = string:split(S, " "),
      {Inst, list_to_integer(Arg)}
    end, array:from_list(utils:as_strings(FileName))),
  io:format("part 1: ~p, part 2: ~p~n", [execute(L, 0, 0, sets:new()), fix(L, 0)]).

fix(OriginalSet, Pointer) ->
  {V, Arg} = array:get(Pointer, OriginalSet),
  case V of
    X when X == "acc" -> fix(OriginalSet, Pointer + 1);
    X when X == "jmp"; X == "nop" ->
      NewInst = if X == "jmp" -> "nop"; true -> "jmp" end,
      Code = array:set(Pointer, {NewInst, Arg}, OriginalSet),
      Result = execute(Code, 0, 0, sets:new()),
      case Result of
        {terminated, _} -> Result;
        {looped, _} -> fix(OriginalSet, Pointer + 1)
      end
  end.

execute(Code, Pointer, Acc, VisitedSet) ->
  case array:size(Code) - 1 of
    Pointer -> {terminated, Acc};
    _ ->
      case sets:is_element(Pointer, VisitedSet) of
        true -> {looped, Acc};
        _ ->
          {Inst, Argument} = array:get(Pointer, Code),
          NewVisit = sets:add_element(Pointer, VisitedSet),
          case Inst of
            "nop" -> execute(Code, Pointer + 1, Acc, NewVisit);
            "jmp" -> execute(Code, (Pointer + Argument) rem array:size(Code), Acc, NewVisit);
            "acc" -> execute(Code, Pointer + 1, Acc + Argument, NewVisit)
          end
      end
  end.
