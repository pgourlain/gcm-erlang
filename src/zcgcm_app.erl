-module(zcgcm_app).
-behaviour(application).

-export([start/0]).

-export([start/2,
         stop/1]).


start() ->
  ensure([crypto, public_key, ssl, zcgcm]).


%% @hidden
start(_StartType, _StartArgs) ->
  zcgcm_sup:start_link().

%% @hidden
stop(_State) ->
  ok.


%% @spec ensure([atom()]) -> ok | {error, term()}
ensure([App | Apps]) ->
  case application:start(App) of
    ok -> ensure(Apps);
    {error, {already_started, App}} -> ensure(Apps);
    Error -> Error end;
ensure([]) ->
  ok.