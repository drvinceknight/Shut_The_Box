#Shut the box

This repo contains files relevant to the parlour game: [Shut the Box](http://en.wikipedia.org/wiki/Shut_the_Box).

The code is written in [Sage](http://sagemath.org/) which is an open source mathematics package based on Python. The code can be used to play shut the box manually or to evaluate playing strategies by passing an autoplay option.

#Instructions

##Manual Play

To play the game manually, start Sage, load the library and create an instance of the game:

    sage: load("shut_the_box.sage")
    sage: game=ShutTheBox()

To play the game apply the 'play' method:

    sage: game.play()

# License Information #

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0](http://creativecommons.org/licenses/by-sa/3.0/us/) license.  You are free to:

* Share: copy, distribute, and transmit the work,
* Remix: adapt the work

Under the following conditions:

* Attribution: You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
* Share Alike: If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.

When attributing this work, please include me.
