-module(map_search).
-export([test/0, bad_map_search/2, map_search/2]).

% test
test() ->
    null = bad_map_search(#{}, fun(_, X) -> X < 0 end),
    null = bad_map_search(#{a => 1, b => 2}, fun(_, X) -> X < 0 end),
    {c, -1} = bad_map_search(#{a => 1, b => 2, c => -1}, fun(_, X) -> X < 0 end),
    null = map_search(#{}, fun(_, X) -> X < 0 end),
    null = map_search(#{a => 1, b => 2}, fun(_, X) -> X < 0 end),
    {c, -1} = map_search(#{a => 1, b => 2, c => -1}, fun(_, X) -> X < 0 end),
    tests_worked.

% bad implementation
bad_map_search(Map, Pred) ->
    L = [{K, V} || {K, V} <- maps:to_list(Map), Pred(K, V)],
    get_first(L).

get_first([H|_]) ->
    H;
get_first([]) ->
    null.

% erlang style
map_search(Map, Pred) ->
    map_search(maps:keys(Map), Map, Pred).

map_search([Key|Keys], Map, Pred) ->
    Val = maps:get(Key, Map),
    case Pred(Key, Val) of
        true  -> {Key, Val};
        false -> map_search(Keys, Map, Pred)
    end;
map_search([], _, _) ->
    null.