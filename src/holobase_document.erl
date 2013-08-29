-module(holobase_document).
-behaviour(gen_server).

-export([open/1, apply/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

open(_Name) ->
    case whereis(document) of
        undefined ->
            {ok, Doc} = gen_server:start(?MODULE, [], []),
            register(document, Doc),
            subscribe(Doc, self()),
            {ok, Doc};
        Pid ->
            subscribe(Pid, self()),
            {ok, Pid}
    end.

subscribe(Doc, Subscriber) ->
    gen_server:cast(Doc, {subscribe, Subscriber}).

apply(Doc, Version, Op) ->
    gen_server:cast(Doc, {apply, Version, Op}).

init(_Name) ->
    {ok, []}.

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

handle_cast({subscribe, Subscriber}, Subscribers) ->
    {noreply, [Subscriber|Subscribers]};
handle_cast({apply, Version, Op}, Subscribers) ->
    Event = {<<"wip">>, Version, Op},
    [Subscriber ! {op, Event} || Subscriber <- Subscribers],
    {noreply, Subscribers}.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

