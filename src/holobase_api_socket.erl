-module(holobase_api_socket).
-behaviour(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
    {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
    {ok, _Doc} = holobase_document:open("wip"),
    {ok, Req, token(10)}.

websocket_handle({text, Payload}, Req, State) ->
    {Type, Event} = holobase_events:decode(Payload),
    handle(Type, Event, State),
    {ok, Req, State}.

websocket_info({op, {Document, Version, Op}}, Req, State) ->
    Payload = holobase_events:encode_op(Document, Version, Op),
    {reply, {text, Payload}, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
    ok.

handle(<<"op">>, {_Document, Version, Op}, Hash) ->
    Doc = holobase_document:find(<<"wip">>),
    holobase_document:apply(Doc, Version, Op, Hash).

token(N) ->
    Token = [io_lib:format("~2.16.0b",[Byte])
             || <<Byte>> <= crypto:strong_rand_bytes(N)],
    iolist_to_binary(Token).

