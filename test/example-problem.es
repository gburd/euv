#!/usr/bin/env escript

file_name() -> "file_test.dat".
file_size() -> 10485760. % 10MiB
chunk_size() -> 4096.


main(_) ->
    MessageCounts = [0, 10, 1000, 10000, 100000, 1000000],
    lists:foreach(fun(M) ->
        run_test(M, file_size())
    end, MessageCounts),
    ok.


run_test(Messages, Bytes) ->
    Self = self(),
    {Pid, _} = spawn_monitor(fun() -> run_loop(Self, Messages, Bytes) end),
    lists:foreach(fun(_) ->
        Pid ! ignored_message
    end, lists:seq(1, Messages)),
    Pid ! go,
    receive {'DOWN', _, _, Pid, _} -> ok end.


run_loop(_Parent, Messages, Bytes) ->
    receive go -> ok end,
    case filelib:is_file(file_name()) of
        true -> file:delete(file_name());
        _ -> ok
    end,
    {ok, Fd} = file:open(file_name(), [read, append, raw, binary]),
    Start = erlang:now(),
    try
        write_loop(Fd, Bytes),
        read_loop(Fd, Bytes, 0)
    after
        file:close(Fd)
    end,
    Length = timer:now_diff(erlang:now(), Start),
    io:format("~8b :: ~8.2fs~n", [Messages, Length / 1000000]).


write_loop(_Fd, Bytes) when Bytes =< 0 ->
    ok;
write_loop(Fd, Bytes) ->
    Bin = crypto:rand_bytes(chunk_size()),
    ok = file:write(Fd, Bin),
    write_loop(Fd, Bytes-chunk_size()).

read_loop(_Fd, Bytes, Pos) when Pos >= Bytes ->
    ok;
read_loop(Fd, Bytes, Pos) ->
    {ok, _Bin} = file:pread(Fd, Pos, chunk_size()),
    read_loop(Fd, Bytes, Pos+chunk_size()).

  
