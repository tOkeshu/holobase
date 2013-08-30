-module(holobase_queue).

-export([tr_queue/3, push/4]).

tr_queue([], _Version, _Hash) ->
    [];
tr_queue([{Version, _Op, _Hash}|_Tail] = Queue, Version, Hash) ->
    [Op || {_Version, Op, H} <- Queue, H =/= Hash];
tr_queue([{_Version, _Op, _Hash}|Queue], Version, Hash) ->
    tr_queue(Queue, Version, Hash).

push(Queue, Op, Version, Hash) when length(Queue) =:= 10 ->
    [_Out|Queue2] = Queue,
    push(Queue2, Op, Version, Hash);
push(Queue, Op, Version, Hash) ->
    lists:reverse([{Version, Op, Hash}|lists:reverse(Queue)]).

