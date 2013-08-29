-module(holobase_events).

-export([decode/1]).
-export([encode_op/3]).

decode(Payload) ->
    {[Type|Event], <<>>} = tnetstring:decode(Payload),
    {Type, list_to_tuple(Event)}.

encode_op(Document, Version, Op) ->
    tnetstring:encode([<<"op">>, Document, Version, Op]).

