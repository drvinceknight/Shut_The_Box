#! /usr/bin/env sage
###################################################
#                                                 #
#            Shut The Box Code                    #
#                                                 #
###################################################
import random

def roll_dice(number_of_dice=1,sides=6):
    return sum([random.randint(1,sides) for e in range(number_of_dice)])

def prob_of_rolling(value,number_of_dice,sides=6):
    """
    A function to return the probability of rolling a particular value given a number of dice
    """
    valid_rolls=[e for e in tuples(range(1,sides+1),number_of_dice) if sum(e)==value]
    return len(valid_rolls)/(sides**number_of_dice)


def prob_of_being_able_to_play(open_tiles,number_of_dice,sides=6):
    """
    Returns the probability of turn not ending on any given go.
    """
    p=0
    for n in range(1,sides*number_of_dice+1):
        if len(tiles(n,open_tiles))>0:
            p+=prob_of_rolling(n,number_of_dice)
    return p

def tiles(dice_roll,open_tiles=range(1,10)):
    """
    A function to return the tiles available to close for a particular dice roll.
    """
    r=Partitions(dice_roll, max_slope=-1).list()
    #Need next statement as max_slope and max_part do not seem to play nice together.
    r=[e for e in r if max(e)<=max(open_tiles)]
    #Final check to ensure that partitions are subsets of open tiles.
    r=[e for e in r if Set(e) in  Subsets(open_tiles)]
    return r

class Tile():
    def __init__(self,value):
        self.value=value


class ShutTheBox():
    """
    A class for a Shut the Box game
    """
    def __init__(self,upper_limit=9,sides=6,one_dice_require={7,8,9}):
        self.sides=sides
        self.open_tiles=range(1,10)
        self.one_dice_check()
        self.potential_tiles_check(self.open_tiles)
        self.one_dice_require=one_dice_require
        print "An instance of Shut the Box has been initiated:\n\t%s"%self.open_tiles


    def shut_tile(self,number_list):
        if Set(number_list) in Subsets(self.open_tiles):
            for e in number_list:
                self.open_tiles.remove(e)
            self.potential_tiles_check(self.open_tiles)
            self.one_dice_check()
            number_list.sort()
            print ""
            print "Tiles %s have been shut"%number_list
            print "The following tiles are still open:\n\t%s"%self.open_tiles
            print ""
        else:
            print "ERROR: %s are (is) not available to shut. Pick a number from: %s"%(number_list,self.open_tiles)

    def potential_tiles_check(self,dice_roll):
        self.potential_tile=tiles(dice_roll,self.open_tiles)

    def one_dice_check(self):
        """
        A method to check if it is worth using 1 dice or 2.
        """
        self.one_dice=False
        if prob_of_being_able_to_play(self.open_tiles,1)>prob_of_being_able_to_play(self.open_tiles,2) and self.one_dice_require not in Subsets(self.open_tiles):
            self.one_dice=True

    def roll_dice(self,number_of_dice,autoplay=False):
        """
        A method to roll dice and prompt user to close required tiles
        """
        if autoplay:
            number_of_dice=2
            if self.one_dice:
                number_of_dice=1
        else:
            if number_of_dice==1:
                if self.one_dice_require in Subsets(self.open_tiles):
                    print ""
                    print "ERROR: You are not allowed to roll %s dice"%number_of_dice
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

        self.last_roll=roll_dice(number_of_dice,sides=self.sides)
        self.potential_tiles_check(self.last_roll)
        print ""
        print "You rolled %s %s sided dice and obtained: %s"%(number_of_dice,self.sides,self.last_roll)
        print ""
        if len(self.potential_tile)==0:
            print ""
            print "You have no potential moves"
        else:
            if not autoplay:
                yn=raw_input("Would you like to list the available moves? (y/n):")
                if yn=="y":
                    print ""
                    for e in self.potential_tile:
                        print e

                tile_list=input("\nList the tiles you would like to close:")
            else:
                tile_list=eval("%s(%s,%s)"%(autoplay,self.open_tiles,self.potential_tile))
            self.shut_tile(tile_list)

    def play(self,autoplay=False):
        while len(self.open_tiles)>0:
            self.roll_dice(2,autoplay)
            if self.potential_tile==[]:
                break
        print ""
        print "The game is over, your score is: %s"%sum(self.open_tiles)

#######################
#                     #
# Autoplay Strategies #
#                     #
#######################


def random_play(open_tiles,potential_tiles):
    """
    This method chooses a random play from the potential tiles.
    """
    return random.choice(potential_tiles)


def greedy(open_tiles,potential_tiles):
    """
    This method explores all possible moves and chooses that leaves the best subsequent set of tiles.
    """
