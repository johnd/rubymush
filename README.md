RubyMUSH
========

Concept
-------

Making a [TinyMUSH](http://www.tinymush.net/index.php/Main_Page) in Ruby, starting from scratch without any reference to the existing C/C++ codebases.

Reason
------

I used to play MUSHes and enjoyed building them - my first 'proper' code was TinyMUSH softcode - and I thought it would be fun to build a server in a language I understand. It's nice to have a side-project with no clients or deadlines or standards, something just for fun. This is mine.

Bootstrap a server
------------------

`ruby bin/bootstrap` will build a minimal viable world, with two rooms linked by exits, a player called 'Wizard' with the password 'testing', and an item in the second room.

`ruby bin/server` will start up the server process, listening on port 2000. Connect using old-fashioned telnet: `telnet localhost 2000`.
