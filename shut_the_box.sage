#! /usr/bin/env sage

def prob_of_shutting(tile_list,number_of_dice):
    """
    Returns the probability of being able to shut a tile
    """
    s=Partitions(tile_list,max_part=6*number_of_dice,length=number_of_dice).cardinality()
    return s/(6**number_of_dice)

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
    A class for a game
    """
    def __init__(self,upper_limit=9):
        self.open_tiles=range(1,10)
    def potential_tiles(self,dice_roll):
        return tiles(dice_roll,self.open_tiles)
    def shut_tile(self,number_list):
        if Set(number_list) in Subsets(self.open_tiles):
            for e in number_list:
                self.open_tiles.remove(e)
        else:
            print "ERROR: %s are (is) not available to shut. Pick a number from: %s"%(number_list,self.open_tiles)
    def one_dice(self):
        """
        A method to check if it is worth using 1 dice or 2.
        """
        self.one_dice=False


game=ShutTheBox()
number_of_options=[len(game.potential_tiles(e)) for e in range(1,13)]
p=list_plot(number_of_options)
