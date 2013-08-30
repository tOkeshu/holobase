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

pust_test() ->
    Queue = [],
    NewQueue = holobase_queue:push(Queue, op, 0),
    ?assertEqual([{0, op}], NewQueue).

full_queue_push_test() ->
    Queue = [{1, op1}, {2, op2}, {3, op3}, {4, op4}, {5, op5},
             {6, op6}, {7, op7}, {8, op8}, {9, op9}, {10, op10}],
    NewQueue = holobase_queue:push(Queue, op11, 11),
    ?assertEqual([{2, op2}, {3, op3}, {4, op4}, {5, op5}, {6, op6}, {7, op7},
                  {8, op8}, {9, op9}, {10, op10}, {11, op11}], NewQueue).

