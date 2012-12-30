#Some analysis of the game Shut the Box

This Christmas, [Zoe]() and I got my mother a small board game called: "Shut the Box" (also known as "Tric-Trac", "Canoga", "Klackers", "Zoltan Box", "Batten Down the Hatches", or "High Rollers" according to the wiki [page](http://en.wikipedia.org/wiki/Shut_the_Box)). It's a neat little game with all sorts of underlying mathematics.

Here are some pictures of us playing:

![]()

![]()

A good description of the game can be found on the wiki [page](http://en.wikipedia.org/wiki/Shut_the_Box) but basically the game can be described as follows:

- It is a Solitaire game that can be played in turns and scores compared (but no strategies arise due to interactions of players)
- The aim is to "shut" as many tiles (each being one of the digits from 1 to 9) as possible.
- On any given go, a player rolls two dice and/or has a choice of rolling one dice if the tiles 7,8,9 are "shut".
- The sum total of the dice roll indicates the sum total of tiles that must be "shut". If I roll 11, I could put down [2,9],[3,8],[1,2,8] etc...
- The game ends when a player can't "shut" tiles corresponding to the dice roll.

Here's a plot of a game we played with a few of my mother's friends:

![]()

You can see that myself and Jean did fairly poorly while Zoe made the difference just at the end to win :)

The game could be modelled as a Markov Decision Process but over the past few days I decided to code it in [Sage](http://sagemath.org/) and investigate whether or not I could find out anything cool with regards to strategies. If you're not aware of Sage I thoroughly recommend you taking a look, it's an awesome open source mathematics package. In this instance I used the Partition function to rapidly obtain various combinations of dice rolls and/or tile options to get the results I wanted.

The code is all on in a github [repo]() and I feel I've written an ok README file explaining how it works so if you're interested in playing with it youcan. The code basically has two parts, the first allows you to play using the program instead of a game board (with prompts telling you what your available plays are).

Here's a quick screencast of me playing the game:

The second part of the code allows for strategies to be written that play the game automatically ("autoplay"). I've considered 4 strateges:

- Random (Just randomly pick any potential tile combination)
- Shortest (Choose the tile combination that is shortest: i.e. [3] instead of [1,2] ~ in case of a tie pick randomly)
- Longest (Choose the tile combination that is longest: i.e. [1,2] instead of [3] ~ in case of a tie pick randomly)
- Greedy. This chooses the tile combination that ensures the best possible chance of the game not ending on the next go. This is calculated by summing the probabilities of obtaining a dice roll that could be obtained.

I've been leaving my computer run the code in the background for a while now so here are some early results.

First of all what does the average score look like:

- Random:
- Shortest:
- Longest:
- Greedy:

Shortest and Greedy seem to do a fair bit better. If we take a look at the distribution of the scores that seems evident:

![]()

If we also take a look at the length of the game (i.e. how many total dice rolls there were):

- Random:
- Shortest:
- Longest:
- Greedy:

We again see the same situation, games last longer when using Shortest and Greedy. If we look at the distribution we see (I'm to lazy to plot this any better so the dips just correspond to non integer lengths of games: ignore them):

![]()

Whether or not playing Shortest or Greedy is actually any different seems interesting. A simple analysis of variance (ANOVA) seems to indicate that there is a significant effect:

    Df  Sum Sq Mean Sq F value Pr(>F)
    stbaov$Method      1   11337   11337   196.3 <2e-16 ***
    Residuals     127169 7345725      58


This is all experimental of course and analysing whether or not my suggested greedy strategy is indeed the optimal strategy would require some markov decision process modelling. I might look in to this with an undegraduate project student next year.

The tricky part about using the greedy method realistically is that it requires a fair bit of calculation. Nothing that Sage can't handle in a split second but something that could keep relatives waiting a fair bit if you were to work it out with a pen and paper. Despite the significant statistical difference between the methods this analysis seems to indicate that choosing the shortest set of tiles is a pretty good strategy.

If anyone cares enough about all this to fork the code or suggest a different strategy I'd be delighted :)
