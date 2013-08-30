-module(holobase_document).
-behaviour(gen_server).

-export([open/1, find/1, apply/4]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
         code_change/3]).

open(_Name) ->
    case find(document) of
        undefined ->
            {ok, Doc} = gen_server:start(?MODULE, [], []),
            register(document, Doc),
            subscribe(Doc, self()),
            {ok, Doc};
        Pid ->
            subscribe(Pid, self()),
            {ok, Pid}
    end.

find(_Name) ->
    whereis(document).

subscribe(Doc, Subscriber) ->
    gen_server:cast(Doc, {subscribe, Subscriber}).

apply(Doc, Version, Op, Hash) ->
    gen_server:cast(Doc, {apply, Version, Op, Hash}).

init(_Name) ->
    {ok, {[], [], {0, [{<<"x">>, <<"">>}]}}}.

handle_call(_Msg, _From, State) ->
    {reply, ok, State}.

handle_cast({subscribe, Subscriber}, {Subscribers, _Queue, {V, Document}}) ->
    {noreply, {[Subscriber|Subscribers], _Queue, {V, Document}}};
handle_cast({apply, Version, Op, Hash}, {Subscribers, Queue, {V, Document}}) ->
    TrQueue     = holobase_queue:tr_queue(Queue, Version, Hash),
    TrOp        = ot:transform(Op, TrQueue),
    NewDocument = ot:apply(Document, TrOp),
    NewQueue    = holobase_queue:push(Queue, TrOp, V, Hash),

    Event = {<<"wip">>, V, Op},
    [Subscriber ! {op, Event} || Subscriber <- Subscribers],

    {noreply, {Subscribers, NewQueue, {V + 1, NewDocument}}}.

handle_info(Msg, State) ->
    io:format("Unexpected message: ~p~n",[Msg]),
    {noreply, State}.

terminate(normal, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

