-module(holobase_queue).

-export([tr_queue/2]).

tr_queue([], _Version) ->
    [];
tr_queue([{Version, _Op}|_Tail] = Queue, Version) ->
    [Op || {_Version, Op} <- Queue];
tr_queue([{_Version, _Op}|Queue], Version) ->
    tr_queue(Queue, Version).

