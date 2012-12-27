#! /usr/bin/env sage
import random

def roll_dice(number_of_dice):
    return sum([random.randint(1,6) for e in range(number_of_dice)])

def prob_of_rolling(value,number_of_dice):
    """
    A function to return the probability of rolling a particular value given a number of dice
    """
    valid_rolls=[e for e in tuples(range(1,7),number_of_dice) if sum(e)==value]
    return len(valid_rolls)/(6**number_of_dice)


def prob_of_being_able_to_play(open_tiles,number_of_dice):
    """
    Returns the probability of turn not ending on any given go.
    """
    p=0
    for n in range(1,6*number_of_dice+1):
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
    def __init__(self,upper_limit=9):
        self.open_tiles=range(1,10)
        self.one_dice_check()
        self.potential_tiles_check()

    def potential_tiles_check(self,dice_roll):
        self.potential_tile=tiles(dice_roll,self.open_tiles)

    def shut_tile(self,number_list):
        if Set(number_list) in Subsets(self.open_tiles):
            for e in number_list:
                self.open_tiles.remove(e)
        else:
            print "ERROR: %s are (is) not available to shut. Pick a number from: %s"%(number_list,self.open_tiles)

    def one_dice_check(self):
        """
        A method to check if it is worth using 1 dice or 2.
        """
        self.one_dice=False
        if prob_of_being_able_to_play(self.open_tiles,1)>prob_of_being_able_to_play(self.open_tiles,2) and {7,8,9} not in Subsets(self.open_tiles):
            self.one_dice=True


game=ShutTheBox()
print game.open_tiles
game.one_dice()
print game.one_dice
