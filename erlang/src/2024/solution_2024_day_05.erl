-module(solution_2024_day_05).

-export([main/1]).

-import(lists, [foldl/3, filter/2, map/2, subtract/2, sum/1, sublist/3, nth/2]).
-import(string, [tokens/2, split/2, split/3]).

main(FileName) ->
    [Order, Updates] = [tokens(E, "\n") || E <- split(utils:content(FileName), "\n\n")],
    Rules =
        foldl(fun([M, N], Y) -> maps:put(M, [N] ++ maps:get(M, Y, []), Y) end,
              maps:new(),
              [split(E, "|") || E <- Order]),
    Pages = [split(Update, ",", all) || Update <- Updates],
    Corrects =
        map(fun({_, E}) -> E end,
            filter(fun({E, _}) -> E == true end, [{part1(Page, Rules), Page} || Page <- Pages])),
    Fixeds = [part2(InCorrect, Rules, []) || InCorrect <- subtract(Pages, Corrects)],

    [sum([list_to_integer(nth(round(length(E) / 2), E)) || E <- P]) || P <- [Corrects, Fixeds]].

part1([], _) ->
    true;
part1([H | T], Rules) ->
    case subtract(T, maps:get(H, Rules, [])) of
        [] ->
            part1(T, Rules);
        _ ->
            error
    end.

part2([], _, R) ->
    R;
part2([H | T] = Page, Rules, Rest) ->
    case subtract(T, maps:get(H, Rules, [])) of
        [] ->
            part2(T, Rules, [H] ++ Rest);
        _ ->
            P = find_pointer(T, [H], Rules, 2),
            part2(swap(Page, 1, P), Rules, Rest)
    end.

find_pointer([N | T], H, Rules, P2) ->
    Pot = maps:get(N, Rules, []),
    case subtract(H ++ T, Pot) of
        [] ->
            P2;
        _ ->
            find_pointer(T, [N] ++ H, Rules, P2 + 1)
    end.

swap(L, I, J) ->
    sublist(L, 1, I - 1)
    ++ [nth(J, L)]
    ++ sublist(L, I + 1, J - I - 1)
    ++ [nth(I, L)]
    ++ sublist(L, J + 1, length(L) - J).
