-module(holobase_queue).

-export([tr_queue/2, push/3]).

tr_queue([], _Version) ->
    [];
tr_queue([{Version, _Op}|_Tail] = Queue, Version) ->
    [Op || {_Version, Op} <- Queue];
tr_queue([{_Version, _Op}|Queue], Version) ->
    tr_queue(Queue, Version).

push(Queue, Op, Version) when length(Queue) =:= 10 ->
    [_Out|Queue2] = Queue,
    push(Queue2, Op, Version);
push(Queue, Op, Version) ->
    lists:reverse([{Version, Op}|lists:reverse(Queue)]).

