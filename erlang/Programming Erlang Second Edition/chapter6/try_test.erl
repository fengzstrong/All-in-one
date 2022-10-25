-module(try_test).
-export([demo1/1, demo2/0]).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a}; 
generate_exception(5) -> error(a).

demo1(User) ->
    [catcher(I, User) || I <- [1,2,3,4,5]].

demo2() ->
    [{I, (catch generate_exception(I))} || I <- [1,2,3,4,5]].

catcher(N, User) ->
    case User of
        user      -> catcher_user(N);
        developer -> catcher_developer(N)
    end.

catcher_developer(N) ->
    try generate_exception(N) of
        Val -> {N, normal, Val}
    catch
        throw:X:Stacktrace -> {N, caught, thrown, X, Stacktrace}; 
        exit:X:Stacktrace  -> {N, caught, exited, X, Stacktrace}; 
        error:X:Stacktrace -> {N, caught, error, X, Stacktrace}
    end.
catcher_user(N) ->
    try generate_exception(N) of
        Val -> {N, normal, Val}
    catch
        throw:X -> {N, caught, thrown, X}; 
        exit:X  -> {N, caught, exited, X}; 
        error:X -> {N, caught, error, X}
    end.