-module(myfile).
-export([read/1]).

read(File) ->
    case file:read_file(File) of
        {ok, Bin} -> Bin;
        {error, Why} ->
            throw({"Read Failed, check the name or path", Why})
    end.