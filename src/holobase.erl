-module(holobase).
-behaviour(application).

-export([start/0, start/2, stop/1]).

-define(ROUTES, [{<<"/s">>,           holobase_api_socket,   []},
                 {<<"/d/:document">>, holobase_api_document, []}]).

start() ->
    ok = application:start(crypto),
    ok = application:start(ranch),
    ok = application:start(cowboy),
    ok = application:start(holobase).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([{'_', ?ROUTES}]),
    {ok, _}  = cowboy:start_http(holobase_http_listener, 100, [{port, 4656}],
                                 [{env, [{dispatch, Dispatch}]}]),
    holobase_sup:start_link().

stop(_State) ->
    ok.
