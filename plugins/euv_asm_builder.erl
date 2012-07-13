-module(euv_asm_builder).

-export([
    pre_compile/2,
    post_compile/2
]).


src_file(Name) ->
    filename:join([rebar_utils:get_cwd(), "src", Name]).


ebin_file(Name) ->
    filename:join([rebar_utils:get_cwd(), "ebin", Name]).


src_md5() ->
    {ok, SrcBin} = file:read_file(src_file("euv.erl")),
    list_to_binary(lists:flatten(lists:map(fun(C) ->
        io_lib:format("~2.16.0b", [C])
    end, binary_to_list(erlang:md5(SrcBin))))).


asm_md5() ->
    {ok, AsmBin} = file:read_file(src_file("euv.S")),
    RegExp = <<"MD5:([^ \n\t\r]+)">>,
    Opts = [{capture, all_but_first, binary}],
    {match, [Md5]} = re:run(AsmBin, RegExp, [{capture, all_but_first, binary}]),
    Md5.


pre_compile(_, _) ->
    case src_md5() == asm_md5() of
        true -> ok;
        false -> rebar_utils:abort("euv.S out of date~n", [])
    end.


post_compile(Config, App) ->
    CompilerOpts = [asm, no_postopt, binary],
    {ok, euv, Beam} = compile:file(src_file("euv.S"), CompilerOpts),
    file:write_file(ebin_file("euv.beam"), Beam),
    ok.
