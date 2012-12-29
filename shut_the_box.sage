#! /usr/bin/env sage
###################################################
#                                                 #
#               Shut The Box                      #
#           www.vincent-knight.com                #
#                                                 #
###################################################
"""
This file contains code that allows manual and/or autoplay of the Shut The Box Parlour game.

The main class is ShutTheBox() which creates and instance of the game. Any given instance can then be "played" using the play() method. Note that an autoplay strategy can be passed to the play method.

"""
import csv
import random

def roll_dice(number_of_dice=1,sides=6):
    """
    Returns the sum of a dice roll of any number of dice of any given number of sides.
    """
    return sum([random.randint(1,sides) for e in range(number_of_dice)])

def prob_of_rolling(value,number_of_dice,sides=6):
    """
    A function to return the probability of rolling a particular value given a number of dice.
    """
    valid_rolls=[e for e in tuples(range(1,sides+1),number_of_dice) if sum(e)==value]
    return len(valid_rolls)/(sides**number_of_dice)

def shut_tile(open_tiles,tiles):
    """
    A function that removes a set of tiles of an open set of tiles.
    """
    r=list(open_tiles)
    if Set(tiles) in Subsets(r):
        for e in tiles:
            r.remove(e)
    return r

def available_tiles(dice_roll,open_tiles=range(1,10)):
    """
    A function to return the tiles available to close for a particular dice roll.
    """
    if open_tiles==[]:#Quick check to return null list if not tiles are open
        return []
    #Following code obtains descending partitions with maximum size that are are subsets of the open tiles.
    r=Partitions(dice_roll, max_slope=-1).list()
    #Need next statement as max_slope and max_part (two sage commands) do not seem to play nice together.
    r=[e for e in r if max(e)<=max(open_tiles)]
    #Final check to ensure that partitions are subsets of open tiles.
    r=[e for e in r if Set(e) in  Subsets(open_tiles)]
    return r

def prob_of_being_able_to_play(open_tiles,number_of_dice,sides=6):
    """
    Returns the probability of turn not ending on any given go.
    """
    p=0
    for n in range(1,sides*number_of_dice+1):#Iterates over all possible outcomes of dice roll
        if len(available_tiles(n,open_tiles))>0:#Sum the probabilities of rolling a particular sum if there is a possibility of playing.
            p+=prob_of_rolling(n,number_of_dice)
    return p

class ShutTheBox():
    """
    The class for the game. This class has one main method: "play" which can be used to play the game. This automatically starts a game with prompts throughout (for example when the player could use just 1 dice and it is in their interest to do so the method prompts the player).

The instance has various attributes:
        - upper_limit: The larger number (default=9)
        - sides: Number of sides on each dice (default=6)
        - one_dice_require: Tiles that must be down to allow the use of one dice.
        - tile_history: A history of all sets of tiles that are lowered at each go.
        - last_roll: the last roll of a dice
        - potential_tiles: The tiles available to lower given the last_roll
    """
    def __init__(self,upper_limit=9,sides=6,one_dice_require={7,8,9}):
        self.sides=sides
        self.open_tiles=range(1,10)
        self.tile_history=[]
        self.one_dice_require=one_dice_require
        self.one_dice_check()
        self.potential_tiles_check(self.open_tiles)
        print 40*"*"
        print ""
        print "Let's play!:\n\n\t%s"%self.open_tiles
        print ""
        print 40*"*"

    def score(self):
        return sum(self.open_tiles)

    def shut_tile(self,number_list):
        """
        Method used to shut tiles.
        """
        if Set(number_list) in Subsets(self.open_tiles):
            for e in number_list:
                self.open_tiles.remove(e)
            self.potential_tiles_check(self.open_tiles)
            self.one_dice_check()
            number_list.sort()
            print ""
            print "Tiles %s have been shut."%number_list
            print "\nThe following tiles are still open:\n\n\t%s"%self.open_tiles
            print ""
        else:
            print "ERROR: %s are (is) not available to shut. Pick a number from: %s"%(number_list,self.open_tiles)

    def potential_tiles_check(self,dice_roll):
        self.potential_tiles=available_tiles(dice_roll,self.open_tiles)

    def one_dice_check(self):
        """
        A method to check if it is worth using 1 dice or 2.
        """
        self.one_dice=False
        if prob_of_being_able_to_play(self.open_tiles,1)>prob_of_being_able_to_play(self.open_tiles,2) and self.one_dice_require not in Subsets(self.open_tiles):
            self.one_dice=True

    def roll_dice(self,number_of_dice,autoplay=False):
        """
        A method to roll dice user to close required tiles (prompts player if tiles are already lowered, and also prompts player if number of dice chosen is not optimal.)
        """
        #Choose number of dice (prompt user unless autoplay is True):
        if autoplay:
            number_of_dice=2
            if self.one_dice:
                number_of_dice=1
        else:
            if number_of_dice==1:
                if self.one_dice_require in Subsets(self.open_tiles):
                    print ""
                    print "ERROR: You are not allowed to roll %s dice."%number_of_dice
                    print ""
                    number_of_dice=2
                elif not self.one_dice:
                    print ""
                    yn=raw_input("It is not in your interest to throw 1 dice, would you like to continue with 1 dice? (y/n)")
                    print ""
                    if yn=="n":
                        number_of_dice=2
            else:
                if self.one_dice:
                    print ""
                    yn=raw_input("It is in your interest to throw 1 dice, would you like to continue with 2 dice? (y/n):")
                    print ""
                    if yn=="n":
                        number_of_dice=1

        #Identify potential tiles to lower and prompt user for required tile or use given autoplay strategy
        if len(self.open_tiles)>0:
            self.last_roll=roll_dice(number_of_dice,sides=self.sides)

            self.potential_tiles_check(self.last_roll)
            print "\nYou rolled %s %s sided dice and obtained: %s"%(number_of_dice,self.sides,self.last_roll)
            print ""
            if len(self.potential_tiles)==0:
                print ""
                print "You have no potential moves."
            else:
                if not autoplay:
                    yn=raw_input("Would you like to list the available moves? (y/n):")
                    if yn=="y":
                        print ""
                        for e in self.potential_tiles:
                            print e

                    tile_list=input("\nList the tiles you would like to close:")
                else:
                    tile_list=eval("%s(%s,%s)"%(autoplay,self.open_tiles,self.potential_tiles))
                self.shut_tile(tile_list)
                self.tile_history.append(tile_list)


    def play(self,autoplay=False):
        """
        The play method which when runs will either use the autoplay strategy or prompt the user.
        """
        while len(self.open_tiles)>0:
            self.roll_dice(2,autoplay)
            if self.potential_tiles==[]:
                break
        self.final_score=self.score()
        string="Game over, your score is: %s."%self.score()
        print ""
        print (len(string)+6)*"-"
        print "| ",len(string)*" "," |"
        print "|  "+string+"  |"
        print "| ",len(string)*" "," |"
        print (len(string)+6)*"-"

#######################
#                     #
# Autoplay Strategies #
#                     #
#######################
"""
This section contains functions for autoplay, the take as inputs:
- open_tiles: a list containing the current open tiles.
- potential_tiles: a list of potential moves.

The output must be a list of tiles to close.
"""

def random_play(open_tiles,potential_tiles):
    """
    This method chooses a random play from the potential tiles.
    """
    return random.choice(potential_tiles)

def shortest_play(open_tiles,potential_tiles):
    """
    This method chooses the shortest available set of tiles (if multiple, it choose randomly).
    """
    min_length=min([len(e) for e in potential_tiles])
    return random.choice([e for e in potential_tiles if len(e)==min_length])

def longest_play(open_tiles,potential_tiles):
    """
    This method chooses the longest available set of tiles (if multiple, it choose randomly).
    """
    max_length=max([len(e) for e in potential_tiles])
    return random.choice([e for e in potential_tiles if len(e)==max_length])

def greedy_play(open_tiles,potential_tiles):
    """
    This method explores all possible moves and chooses that leaves the best subsequent set of tiles.
    """
    best_move=potential_tiles[0]
    best_prob=prob_of_being_able_to_play(shut_tile(open_tiles,best_move),2)
    if {7,8,9} in Subsets(open_tiles):
        best_prob=max(best_prob,prob_of_being_able_to_play(shut_tile(open_tiles,best_move),1))
    for e in potential_tiles[1:]:
        temp_prob=prob_of_being_able_to_play(shut_tile(open_tiles,e),2)
        if {7,8,9} in Subsets(open_tiles):
            temp_prob=max(temp_prob,prob_of_being_able_to_play(shut_tile(open_tiles,e),1))
        if temp_prob>best_prob:
            best_move=e
            best_prob=temp_prob
    return best_move



def experiment(output_file="Shut_the_Box.csv"):
    while True:
        temp_greedy=ShutTheBox()
        temp_greedy.play("greedy_play")
        temp_random=ShutTheBox()
        temp_random.play("random_play")
        temp_max=ShutTheBox()
        temp_max.play("longest_play")
        temp_min=ShutTheBox()
        temp_min.play("shortest_play")
        row=[temp_greedy.score(),temp_greedy.tile_history,temp_random.score(),temp_random.tile_history,temp_max.score(),temp_max.tile_history,temp_min.score(),temp_min.tile_history]

        file=open(output_file,"ab")
        outfile=csv.writer(file)
        outfile.writerow(row)
        file.close()

