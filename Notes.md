rotes on structure of Ruby MUSH
===============================

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
