-module(solution_2021_day_05).
-export([run/0, main/1]).

run() ->
    solve([
        "0,9 -> 5,9",
        "8,0 -> 0,8",
        "9,4 -> 3,4",
        "2,2 -> 2,1",
        "7,0 -> 7,4",
        "6,4 -> 2,0",
        "0,9 -> 2,9",
        "3,4 -> 1,4",
        "0,0 -> 8,8",
        "5,5 -> 8,2"
    ]).

create(L, 0) -> L;
create(L, C) -> create([0 | L], C - 1).

solve(Lines) ->
    Points = parse(Lines),
    Grid = array:from_list([array:from_list(create([], 1000)) || _ <- lists:seq(1, 1000)]),
    NewGrid = mark(Points, Grid),
    count_intersections(NewGrid).

count_intersections(Grid) ->
    array:foldl(
        fun(_, Row, Ac) ->
            Ac +
                array:foldl(
                    fun(_, Point, Acc) ->
                        case Point of
                            Point when Point > 1 -> Acc + 1;
                            _ -> Acc
                        end
                    end,
                    0,
                    Row
                )
        end,
        0,
        Grid
    ).

mark([], Grid) ->
    Grid;
mark([[{X1, Y1}, {X2, Y2}] | T], Grid) ->
    NewGrid =
        case [{X1, Y1}, {X2, Y2}] of
            _ when X1 == X2 -> mark_lines(min(Y1, Y2), max(Y1, Y2), Grid, {x, X1});
            _ when Y1 == Y2 -> mark_lines(min(X1, X2), max(X1, X2), Grid, {y, Y1});
            _ -> diagonal({X1, Y1}, {X2, Y2}, Grid)
        end,
    mark(T, NewGrid).

mark_lines(Start, End, Grid, Direction) ->
    lists:foldl(
        fun(E, G) ->
            case Direction of
                {x, X} -> array_set(X, E, G);
                {y, Y} -> array_set(E, Y, G)
            end
        end,
        Grid,
        lists:seq(Start, End)
    ).

diagonal({X1, Y1}, {X2, Y2}, Grid) when X1 == X2 andalso Y1 == Y2 ->
    array_set(X1, Y1, Grid);
diagonal({X1, Y1}, {X2, Y2}, Grid) ->
    NG = array_set(X1, Y1, Grid),
    [A, B] =
        case [{X1, Y1}, {X2, Y2}] of
            _ when X1 > X2 andalso Y1 > Y2 -> [{X1 - 1, Y1 - 1}, {X2, Y2}];
            _ when X1 > X2 andalso Y1 < Y2 -> [{X1 - 1, Y1 + 1}, {X2, Y2}];
            _ when X1 < X2 andalso Y1 > Y2 -> [{X1 + 1, Y1 - 1}, {X2, Y2}];
            _ when X1 < X2 andalso Y1 < Y2 -> [{X1 + 1, Y1 + 1}, {X2, Y2}]
        end,
    diagonal(A, B, NG).

array_set(X, Y, G) ->
    Curr = array:get(X, array:get(Y, G)),
    utils:array_set(G, Y, X, Curr + 1).

parse(Lines) ->
    lists:map(
        fun(Line) ->
            case re:run(Line, "(\\d+),(\\d+) -> (\\d+),(\\d+)", [{capture, all, list}]) of
                {match, [_, X1, Y1, X2, Y2]} ->
                    [
                        {list_to_integer(X1), list_to_integer(Y1)},
                        {list_to_integer(X2), list_to_integer(Y2)}
                    ];
                nomatch ->
                    error
            end
        end,
        Lines
    ).

main(FileName) ->
    solve(utils:lines(FileName)).
