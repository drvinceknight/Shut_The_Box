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

This will then follow with prompts for the user. A prompt will appear when it is in the users interest to use a single dice (and when this is allowed).

##Autoplay

The game can also be played automatically by passing a string to the play method:

    sage: game.play("greedy_play")

There are 4 autoplays currently programmed:

- "random_play": A random set of tiles is picked from the available ones.
- "shortest_play": The set of tiles that uses the least total amount of tailes is picked. For example if [1,7] and [8] are available moves, [8] will be picked.

        sage: shortest_play([1,7,8],[[1,7],[8]])
        8

- "longest_play": The set of tiles that uses the most total amount of tailes is picked. For example if [1,7] and [8] are available moves, [1,7] will be picked.

        sage: longest_play([1,7,8],[[1,7],[8]])
        [1,7]

- "greedy_play": The set of tiles that gives the subsequent best chance of being able to play is picked. For example if [1,2,3] are open and 3 is rolled, there are 2 available moves: [1,2] and [3]. Picking [1,2] leaves [3] which can only be played if a 3 is rolled on a 6 sided dice (1/6). Picking [3] leaves [1,2] which can be played if 1,2 or 3 is rolled on a 6 sided dice (1/2). The best choice would be [3].

        sage: greedy_play([1,2,3],[[1,2],[3]])
        [3]

#Experiment

The experiment function collects data comparing all the above autoplays (Ctrl+C quits). This outputs by default to a csv file "Shut_the_Box.csv" but other file names can be passed:

    sage: experiment("My_file_name.csv")

The date collected for each autoplay is:

- The final score
- The tile history

# License Information #

This work is licensed under a [Creative Commons Attribution-ShareAlike 3.0](http://creativecommons.org/licenses/by-sa/3.0/us/) license.  You are free to:

* Share: copy, distribute, and transmit the work,
* Remix: adapt the work

Under the following conditions:

* Attribution: You must attribute the work in the manner specified by the author or licensor (but not in any way that suggests that they endorse you or your use of the work).
* Share Alike: If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.

When attributing this work, please include me.
