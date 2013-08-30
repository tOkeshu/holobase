-module(queue_tests).
-include_lib("eunit/include/eunit.hrl").

tr_queue_test() ->
    Queue = [{1, op1}, {2, op2}, {3, op3}, {4, op4}],
    TrQueue = holobase_queue:tr_queue(Queue, 3),
    ?assertEqual([op3, op4], TrQueue).

no_tr_queue_test() ->
    Queue = [{1, op1}, {2, op2}, {3, op3}, {4, op4}],
    TrQueue = holobase_queue:tr_queue(Queue, 5),
    ?assertEqual([], TrQueue).

