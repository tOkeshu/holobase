PROJECT = holobase

DEPS = cowboy ot tnetstring
dep_cowboy = https://github.com/extend/cowboy.git 0.8.6
dep_ot = https://github.com/tOkeshu/ot.erl.git
dep_tnetstring = https://github.com/tOkeshu/tnetstring.erl.git

include erlang.mk

tests: app build-tests
	@erl -noshell -pa ebin -eval "eunit:test(queue_tests, [verbose])" -s init stop

