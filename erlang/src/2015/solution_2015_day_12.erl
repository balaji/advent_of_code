-module(solution_2015_day_12).
-export([run/0, main/1]).

main(FileName) ->
    solution(hd(utils:lines(FileName))).

run() ->
    solution("[1,{\"c\":\"red\",\"b\":2},3]").

decode(Str) ->
    parse(json:decode(list_to_binary(Str)), 0).

parse([], R) ->
    R;
parse([H | T], R) when is_integer(H) -> parse(T, R + H);
parse([H | T], R) when is_binary(H) -> parse(T, R);
parse(L, R) when is_map(L) ->
    case lists:member(<<"red">>, maps:values(L)) of
        true -> R;
        _ -> R + count(maps:iterator(L), 0)
    end;
parse([H | T], R) ->
    R + parse(H, 0) + parse(T, 0).

count(I, Acc) ->
    case maps:next(I) of
        none -> Acc;
        {_, V, It} when is_integer(V) -> count(It, Acc + V);
        {_, V, It} when is_binary(V) -> count(It, Acc);
        {_, V, It} -> parse(V, 0) + count(It, Acc)
    end.

solution(Str) ->
    decode(Str).
