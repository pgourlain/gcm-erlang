-module(zcgcm_sup).
-behaviour(supervisor).

-export([start_link/0,
         start_child/3]).

-export([init/1]).

-define(CHILD(I, Type), {I, {I, start_link, []}, transient, 5000, Type, [I]}).


%% @spec start_link() -> {ok, Pid} | start_error()
%% @doc Start zcgcm supervisor.
start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% @spec start_child(atom(), env(), string()) -> {ok, Pid} | start_error()
%% @doc Create an zcgcm child process.
%%      The resulting process will be locally registered as `Name'.
start_child(Name, Env, CertFile) ->
  supervisor:start_child(?MODULE, [Name, Env, CertFile]).


%% @hidden
init([]) ->
  {ok, {{simple_one_for_one, 5, 10}, [?CHILD(zcgcm, worker)]}}.
