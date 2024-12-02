-module(utils).

-export([array_fetch/3, content/1, gcd/2, groupBy/2, lcm/2, is_integer/1,
         read_as_integers/2, as_strings/1, transpose/1, read_as_strings/2, remove_dups/1, replace_nth_value/3,
         bin_to_hex/1, array_get/3, array_set/4, split_as_integers/2, remove_nth/2, diff/2]).

read_as_integers(FileName, SplitToken) ->
    Content = content(FileName),
    [Int || {Int, _} <- [ string:to_integer(Token) || Token <- string:tokens(Content, SplitToken)]].

split_as_integers(FileName, SplitToken) ->
    FileContent = as_strings(FileName),
    [[Int || {Int, _} <- [ string:to_integer(Token) || Token <- string:tokens(Content, SplitToken)]] || Content <- FileContent].

as_strings(FileName) ->
    read_as_strings(FileName, "\n").

read_as_strings(FileName, SplitToken) ->
    string:tokens(content(FileName), SplitToken).

content(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    try
        raw_content(Device, "")
    after
        file:close(Device)
    end.

raw_content(Device, Content) ->
    case io:get_line(Device, "") of
        eof ->
            Content;
        Line ->
            raw_content(Device, Content ++ Line)
    end.

replace_nth_value(List, Position, Value) ->
    {L, [_ | R]} = lists:split(Position, List),
    L ++ [Value] ++ R.

remove_dups([]) ->
    [];
remove_dups([H | T]) ->
    [H | [X || X <- remove_dups(T), X /= H]].

gcd(A, B) when B > A ->
    gcd(B, A);
gcd(A, 0) ->
    A;
gcd(A, B) ->
    gcd(B, A rem B).

lcm(A, B) ->
    A * B div gcd(A, B).

array_fetch(Array, I, J) ->
    lists:nth(J, lists:nth(I, Array)).

array_get(A, I, J) ->
    Row = array:get(I, A),
    array:get(J, Row).

array_set(A, I, J, V) ->
    Row = array:get(I, A),
    NewRow = array:set(J, V, Row),
    array:set(I, NewRow, A).

is_integer(S) ->
    try
        _ = {true, list_to_integer(S)}
    catch
        error:badarg ->
            false
    end.

bin_to_hex(Bin) when is_binary(Bin) ->
    << <<(hex(H)), (hex(L))>> || <<H:4, L:4>> <= Bin >>.

hex(C) when C < 10 ->
    $0 + C;
hex(C) ->
    $a + C - 10.

groupBy(F, L) ->
    lists:foldr(fun({K, V}, D) -> dict:append(K, V, D) end,
                dict:new(),
                [{F(X), X} || X <- L]).

transpose([[]|_]) -> [];
transpose(M) ->
  [lists:map(fun hd/1, M) | transpose(lists:map(fun tl/1, M))].

remove_nth(0, L) -> L;
remove_nth(Index, L) ->
    lists:sublist(L, Index - 1) ++ lists:sublist(L, Index + 1, length(L) - Index + 1).


diff(F, [_ | T] = L) ->
    [F(A, B) || {A, B} <- lists:zip(lists:droplast(L), T)].

