-module(day5).

-export([main/1]).

main([_]) ->
    io:format("~p~n", [generate("cxdnnyjw")]).

generate(String) ->    
    find(String, 1, array:new([{size, 8}, {default, 0}]), sets:new()).

find(String, Index, Array, Set) ->
    <<A, B, C, D, E, F, G, _/binary>> =
        utils:bin_to_hex(erlang:md5(String ++ integer_to_list(Index))),
    if A == $0, B == $0, C == $0, D == $0, E == $0 ->
            R = utils:is_integer([F]),
            case R of
                {true, Number} when Number < 8 -> 
                    IsDone = sets:is_element(Number, Set),
                    if 
                        IsDone == false -> 
                            S = sets:add_element(Number, Set),
                            Ar = array:set(Number, [G], Array),
                            Size = sets:size(S),
                            if Size == 8 -> array:to_list(Ar); true -> find(String, Index + 1, Ar, S) end;
                        true -> find(String, Index + 1, Array, Set)
                    end;
                 _ -> find(String, Index + 1, Array, Set)
            end;
       true -> find(String, Index + 1, Array, Set)
    end.
