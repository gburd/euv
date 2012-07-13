euv
===

These are Erlang bindings to libuv. There goals for this project are to
create a stable binding to libuv's file handling and demonstrate how that
affects file IO for processes with large mailboxes.

If that work goes quickly enough I'll add wrappers to the networking parts
of libuv and lastly if time I'll add the HTTP parser from node and compare
that against Erlang's builtin HTTP packet parsing.

Current Status
--------------

I've managed to resurect the hopes for this project by doing a bit of
work hacking in Erlang assembly. The caveat is that this is a bit of a
hack though it should work well enough for our purposes.

If you have to edit euv.erl then you'll also have to regenerate the euv.S
file and manually edit it by hand to reintroduce the selective receive
optimizations. I've written a rebar plugin that automatically checks that
`euv.S` is tagged with the MD5 of `euv.erl` so that we don't accidentally
lose this condition. It also builds `euv.beam` from `euv.S` so that we
aren't including a `.beam` directly in Git.

BIG ASS WARNING
---------------

This is definitely playing with fire. The Erlang assembly format is
undocumented and subject to change. While this will serve us well enough
for the time being and seems to work, basing large projects on this code
at present is ill advised as the OTP team may decide to change things out
from under us (which they have big warnings about).

That said, who doesn't like living on the edge every now and again?

Building and Testing
--------------------

Theoretically you should be able to build this on OS X by just running
`make` in the top directory.

The tests I was using are:

    $ ./test/example-problem.es
    $ ERL_FLAGS="-pa ebin" ./test/example-using-euv.es

You should notice that the increase in times for the tests are now
drastically different. On my late 2010 MacBook Air (SSD) I'm getting
nearly 90s for the builtin file module and between 9 and 10s using
`euv`. Although on the small queue end I'm running slower by nearly
half a second (1.2 vs 1.65s). To be a viable replacement I'll have to
track that down and at least be on parity.
