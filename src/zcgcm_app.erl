-module(zcgcm_app).
-behaviour(application).

-export([start/0]).

-export([start/2,
         stop/1]).


start() ->
  case ensure([asn1, crypto, public_key, ssl, zcgcm]) of
  ok -> inets:start(), ok;
  Error -> Error
  end.


%% @hidden
start(_StartType, _StartArgs) ->
  zcgcm_sup:start_link().

%% @hidden
stop(_State) ->
  ok.


ensure(App, Apps, 0) ->
  case application:start(App) of
    ok -> ensure(Apps);
    {error, {already_started, App}} -> ensure(Apps);
    {error, {not_started, App}} -> ensure(App, Apps, 1);
    Error -> Error
  end;

ensure(App, Apps, 1) ->
  case application:start(App) of
    ok -> ensure(Apps);
    {error, {already_started, App}} -> ensure(Apps);
    Error -> Error
  end.
 

%% @spec ensure([atom()]) -> ok | {error, term()}
ensure([App | Apps]) ->
  ensure(App, Apps, 0);
ensure([]) ->
  ok.
  