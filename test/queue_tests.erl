-module(queue_tests).
-include_lib("eunit/include/eunit.hrl").

tr_queue_test() ->
    H = hash,
    Queue = [{1, op1, H}, {2, op2, H}, {3, op3, H}, {4, op4, H}],
    TrQueue = holobase_queue:tr_queue(Queue, 3, 'not-hash'),
    ?assertEqual([op3, op4], TrQueue).

no_tr_queue_test() ->
    H = 'not-h',
    Queue = [{1, op1, H}, {2, op2, H}, {3, op3, H}, {4, op4, H}],
    TrQueue = holobase_queue:tr_queue(Queue, 5, hash),
    ?assertEqual([], TrQueue).

tr_queue_exclude_mine_test() ->
    H = hash,
    MyH = 'my-hash',
    Queue = [{1, op1, H}, {2, op2, H}, {3, op3, MyH}, {4, op4, H}],
    TrQueue = holobase_queue:tr_queue(Queue, 3, MyH),
    ?assertEqual([op4], TrQueue).

pust_test() ->
    Queue = [],
    NewQueue = holobase_queue:push(Queue, op, 0, hash),
    ?assertEqual([{0, op, hash}], NewQueue).

full_queue_push_test() ->
    H = hash,
    Queue = [{1, op1, H}, {2, op2, H}, {3, op3, H},
             {4, op4, H}, {5, op5, H}, {6, op6, H},
             {7, op7, H}, {8, op8, H}, {9, op9, H},{10, op10, H}],
    NewQueue = holobase_queue:push(Queue, op11, 11, H),
    ?assertEqual([{2, op2, H}, {3, op3, H}, {4, op4, H}, {5, op5, H},
                  {6, op6, H}, {7, op7, H}, {8, op8, H}, {9, op9, H},
                  {10, op10, H}, {11, op11, H}],
                 NewQueue).

