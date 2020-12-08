-module(day8).

-export([main/1]).

main([FileName | _]) ->
    L = lists:map(fun(S) -> 
        [Inst, Arg] = string:split(S, " "),
        {Inst, list_to_integer(Arg)}
        end, utils:as_strings(FileName)),
    io:format("part1: ~p, part2: ~p~n", [execute(L, 1, 0, sets:new()), fix(L, 1)]).

fix(OriginalSet, Pointer) ->
    {V, Arg} = lists:nth(Pointer, OriginalSet),
    case V of
        X when X == "acc" -> fix(OriginalSet, Pointer + 1);
        X when X == "jmp"; X == "nop" -> 
            NewInst = if X == "jmp" ->  "nop"; true -> "jmp" end,
            Code = lists:sublist(OriginalSet, 1, Pointer - 1) ++ [{NewInst, Arg}] ++ lists:sublist(OriginalSet, Pointer + 1, length(OriginalSet) - Pointer),
            Result = execute(Code, 1, 0, sets:new()),
            case Result of
                {terminated, _} -> Result;
                {looped, _} -> fix(OriginalSet, Pointer + 1)
            end
    end.

execute(Code, Pointer, Acc, _) when length(Code) == Pointer -> {terminated, Acc};
execute(Code, Pointer, Acc, VisitedSet) ->
    Visited = sets:is_element(Pointer, VisitedSet),
    if 
        Visited == true -> {looped, Acc};
        true ->
            {Inst, Argument} = lists:nth(Pointer, Code),
            NewVisit = sets:add_element(Pointer, VisitedSet),
            case Inst of
                "nop" -> execute(Code, Pointer + 1, Acc, NewVisit);
                "jmp" -> execute(Code, (Pointer + Argument) rem length(Code), Acc, NewVisit);
                "acc" -> execute(Code, Pointer + 1, Acc + Argument, NewVisit)
            end
    end.
