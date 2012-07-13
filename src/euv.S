{module, euv}.  %% version = 0
%% MD5:6331aa4bc0fc9c101eeecb0c56cc566c

{exports, [{call,2},
           {call,3},
           {module_info,0},
           {module_info,1},
           {submit,3},
           {submit,4}]}.

{attributes, [{on_load,[{init,0}]}]}.

{labels, 27}.


{function, call, 2, 2}.
  {label,1}.
    {func_info,{atom,euv},{atom,call},2}.
  {label,2}.
    {allocate,2,2}.
    {move,{x,1},{y,0}}.
    {move,{x,0},{y,1}}.
    {recv_mark,{f,3}}.
    {call_ext,0,{extfunc,erlang,make_ref,0}}.
    {move,{y,0},{x,2}}.
    {move,{y,1},{x,1}}.
    {move,{x,0},{y,1}}.
    {kill,{y,0}}.
    {call,3,{f,14}}.
    {test,is_eq_exact,{f,6},[{x,0},{atom,ok}]}.
    {recv_set,{f,3}}.
  {label,3}.
    {loop_rec,{f,5},{x,0}}.
    {test,is_tuple,{f,4},[{x,0}]}.
    {test,test_arity,{f,4},[{x,0},2]}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {get_tuple_element,{x,0},1,{x,2}}.
    {test,is_eq_exact,{f,4},[{x,1},{y,1}]}.
    remove_message.
    {move,{x,2},{x,0}}.
    {deallocate,2}.
    return.
  {label,4}.
    {loop_rec_end,{f,3}}.
  {label,5}.
    {wait,{f,3}}.
  {label,6}.
    {badmatch,{x,0}}.


{function, call, 3, 8}.
  {label,7}.
    {func_info,{atom,euv},{atom,call},3}.
  {label,8}.
    {allocate,3,3}.
    {move,{x,2},{y,0}}.
    {move,{x,1},{y,1}}.
    {move,{x,0},{y,2}}.
    {recv_mark,{f,9}}.
    {call_ext,0,{extfunc,erlang,make_ref,0}}.
    {move,{y,1},{x,2}}.
    {move,{y,0},{x,3}}.
    {move,{y,2},{x,1}}.
    {move,{x,0},{y,2}}.
    {kill,{y,0}}.
    {kill,{y,1}}.
    {call,4,{f,16}}.
    {test,is_eq_exact,{f,12},[{x,0},{atom,ok}]}.
    {recv_set,{f,9}}.
  {label,9}.
    {loop_rec,{f,11},{x,0}}.
    {test,is_tuple,{f,10},[{x,0}]}.
    {test,test_arity,{f,10},[{x,0},2]}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {get_tuple_element,{x,0},1,{x,2}}.
    {test,is_eq_exact,{f,10},[{x,1},{y,2}]}.
    remove_message.
    {move,{x,2},{x,0}}.
    {deallocate,3}.
    return.
  {label,10}.
    {loop_rec_end,{f,9}}.
  {label,11}.
    {wait,{f,9}}.
  {label,12}.
    {badmatch,{x,0}}.


{function, submit, 3, 14}.
  {label,13}.
    {func_info,{atom,euv},{atom,submit},3}.
  {label,14}.
    {move,{integer,31},{x,0}}.
    {call_only,1,{f,22}}.


{function, submit, 4, 16}.
  {label,15}.
    {func_info,{atom,euv},{atom,submit},4}.
  {label,16}.
    {move,{integer,35},{x,0}}.
    {call_only,1,{f,22}}.


{function, init, 0, 18}.
  {label,17}.
    {func_info,{atom,euv},{atom,init},0}.
  {label,18}.
    {allocate_zero,1,0}.
    {move,{atom,euv},{x,0}}.
    {call_ext,1,{extfunc,code,priv_dir,1}}.
    {test,is_tuple,{f,19},[{x,0}]}.
    {test,test_arity,{f,19},[{x,0},2]}.
    {get_tuple_element,{x,0},0,{x,1}}.
    {test,is_eq_exact,{f,19},[{x,1},{atom,error}]}.
    {move,{atom,euv},{x,0}}.
    {call_ext,1,{extfunc,code,which,1}}.
    {call_ext,1,{extfunc,filename,dirname,1}}.
    {call_ext,1,{extfunc,filename,dirname,1}}.
    {move,{literal,"priv"},{x,1}}.
    {call_ext,2,{extfunc,filename,join,2}}.
  {label,19}.
    {move,{x,0},{y,0}}.
    {move,{atom,euv},{x,0}}.
    {call_ext,1,{extfunc,application,get_all_env,1}}.
    {test,is_nil,{f,20},[{x,0}]}.
    {move,{literal,[{loops,[default]}]},{x,0}}.
  {label,20}.
    {move,{x,0},{x,2}}.
    {move,{literal,"euv"},{x,1}}.
    {move,{y,0},{x,0}}.
    {move,{x,2},{y,0}}.
    {call_ext,2,{extfunc,filename,join,2}}.
    {move,{y,0},{x,1}}.
    {call_ext_last,2,{extfunc,erlang,load_nif,2},1}.


{function, not_loaded, 1, 22}.
  {label,21}.
    {func_info,{atom,euv},{atom,not_loaded},1}.
  {label,22}.
    {test_heap,10,1}.
    {put_tuple,2,{x,1}}.
    {put,{atom,line}}.
    {put,{x,0}}.
    {put_list,{x,1},nil,{x,0}}.
    {put_list,{literal,{module,euv}},{x,0},{x,1}}.
    {put_tuple,2,{x,0}}.
    {put,{atom,not_loaded}}.
    {put,{x,1}}.
    {call_ext_only,1,{extfunc,erlang,nif_error,1}}.


{function, module_info, 0, 24}.
  {label,23}.
    {func_info,{atom,euv},{atom,module_info},0}.
  {label,24}.
    {move,{atom,euv},{x,0}}.
    {call_ext_only,1,{extfunc,erlang,get_module_info,1}}.


{function, module_info, 1, 26}.
  {label,25}.
    {func_info,{atom,euv},{atom,module_info},1}.
  {label,26}.
    {move,{x,0},{x,1}}.
    {move,{atom,euv},{x,0}}.
    {call_ext_only,2,{extfunc,erlang,get_module_info,2}}.
