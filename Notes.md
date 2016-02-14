Notes on structure of Ruby MUSH
===============================

(These were initial thoughts, and don't really represent how the code developed.)

Objects
-------

Objects in the game will be represented by a Ruby class for each type of
object. I see there being two basic classes, and several subclasses.

Base classes:

Exits: following the TinyMUSH model, an exit is a special type of object
       which when its name or aliases are typed moves other objects to
       the destination recorded on the exit.

Items: the most basic non-exit object, it can contain other items and
       exits, it itself has a location.

Both base classes can have arbitrary attributes, and can contain code
which is triggered based on events or user commands.

Subclasses of Items:

Rooms: these represent spaces in which other objects exist. While normal
       items have to have a location, rooms do not. Otherwise the same.

Players: these objects represent the users, they are their avatars.
         They're otherwise very similar to normal items, but will have a
         lot of player-specific attributes and provide the default
         context for a given player.

I think these four classes are enough to model a tinyMUSH-style game.

Persistence
-----------

MUSH-style games use BDM/GBDM-style key-value stores as a database, but
the performance of such a system isn't great and it's restricted to a
single process on a single node.

Use a modern NoSQL DB, ideally one supporting JSON blobs, since it's
easy to serialize Ruby objects to JSON.

Maybe EJDB?

Other Versions
--------------

Someone's already made https://github.com/mangled/MangledMud - learn?

New direction
-------------

So, use a 'plug in' like system where new commands are added in Ruby,
with no in-game scripting at all. This opens up easy adding of 'builder'
only commands, etc. Commands can be set as 'local' or global': local
commands are bound to an object (subclassed from Item/etc) and only work
within 'hearing range' of an instance of that object.

Also, the 'exit name by itself goes that direction' thing can be done
using the 'I don't know what that means' method just calling 'go
<command>' and saying 'I don't know...' if it fails.

We need a reasonable DB flatfile format. Raw JSON of all objects?

HAs anyone done MarkDown -> Terminal rendering before? It would be cool
to use Markdown for descriptions - Figlet for HEaders, render tables,
etc.

Can we get things like the terminal width over socket connections?

Check out how Knife handles plugins foran example - we don't wantto be
scanning gems, but it might give some Clues.
