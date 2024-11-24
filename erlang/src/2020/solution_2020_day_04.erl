-module(solution_2020_day_04).

-export([main/1]).


main([FileName | _]) ->
  L = [re:split(S, "[\n ]+", [{return, list}]) || S <- string:split(utils:content(FileName), "\n\n", all)],
  M = [lists:map(fun(X) -> list_to_tuple(string:split(X, ":")) end, S) || S <- L],
  R = [maps:from_list(I) || I <- M],
  io:format("part 1: ~p, part 2: ~p~n",
    [length(lists:filter(fun(X) -> X == true end, [validate(I, part1) || I <- R])),
      length(lists:filter(fun(X) -> X == true end, [validate(I, part2) || I <- R]))]).

validate(M, Part) ->
  case {length(maps:keys(M)), maps:is_key("cid", M)} of
    {L, _} when L < 7 -> false;
    {L, HasCid} when L == 8; HasCid == false ->
      if Part == part2 ->
        length(lists:filter(fun(X) -> X == true end,
          [validate_year(maps:get("byr", M), 1920, 2002),
            validate_year(maps:get("iyr", M), 2010, 2020),
            validate_year(maps:get("eyr", M), 2020, 2030),
            passport_id(maps:get("pid", M)),
            eye_color(maps:get("ecl", M)),
            hair_color(maps:get("hcl", M)),
            height(maps:get("hgt", M))])) == 7;
        true -> true
      end;
    _ -> false
  end.

validate_year(K, Start, End) ->
  R = utils:is_integer(K),
  case R of
    {true, Y} when Y >= Start, Y =< End -> true;
    _ -> false
  end.

eye_color(C) ->
  sets:is_element(C, sets:from_list(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"])).

passport_id(Pid) ->
  case re:run(Pid, "^[0-9]{9}$") of
    {match, _} -> true;
    nomatch -> false
  end.

hair_color(Hc) ->
  case re:run(Hc, "^#[0-9a-f]{6}$") of
    {match, _} -> true;
    nomatch -> false
  end.

height(Height) ->
  case re:run(Height, "in$") of
    {match, _} ->
      V = list_to_integer(lists:merge(string:replace(Height, "in", ""))),
      if V >= 59, V =< 76 -> true; true -> false end;
    nomatch ->
      case re:run(Height, "cm$") of
        {match, _} ->
          V = list_to_integer(lists:merge(string:replace(Height, "cm", ""))),
          if V >= 150, V =< 193 -> true; true -> false end;
        nomatch -> false
      end
  end.
