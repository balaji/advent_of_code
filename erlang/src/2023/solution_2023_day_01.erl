-module(solution_2023_day_01).
-export([main/1]).
-compile({inline, [number_map/0, forward_regex/0, backward_regex/0]}).
-import(string, [reverse/1]).

number_map() ->
    #{
      "one" => "1", 
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9",
      "zero" => "0"
     }.

forward_regex() ->
    lists:join("|", maps:keys(number_map())).

backward_regex() ->
    lists:join("|", lists:map(fun string:reverse/1, maps:keys(number_map()))).

main([FileName| _]) ->
    L = utils:as_strings(FileName),
    [{part1, lists:sum(lists:map(fun part1/1, L))},
     {part2, lists:sum(lists:map(fun part2/1, L))}].

part1(L) ->
    list_to_integer(find_first(L, "\\d") ++ find_first(reverse(L), "\\d")).

part2(R) ->
    L = replace_nums(R),
    First = find_first(L, forward_regex()),
    Last = reverse(find_first(reverse(L), backward_regex())),
    list_to_integer(maps:get(First, number_map(), "") ++ maps:get(Last, number_map(), "")).

find_first(L, R) ->
    case re:run(L, R) of
	{match, [{A, K}|_]} ->
	    string:substr(L, A+1, K)
    end.

replace_nums(H) ->
    replace_nums(H, maps:next(maps:iterator(number_map()))).
replace_nums(H, Next) when Next == none -> H;
replace_nums(H, {K, V, I}) ->
    replace_nums(string:join(string:replace(H, V, K, all), ""), maps:next(I)).
