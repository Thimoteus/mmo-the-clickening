# Custom list of trash and stuff
##########

adjectives = ["sneaky ", "filthy ", "diseased ", "carcinogenic ", "slimy ", "tragic ", "scared ", "scary ", "Martian ", "belligerent "]

grayTrash = ["rat", "snake", "bat", "boar"]
whiteTrash = []
greenTrash = []
blueTrash = []
purpleTrash = []
orangeTrash = []

# functions
##########

newTrash = (hero) ->
   adjective = randomElementFromArray(adjectives)
   noun = switch
      when hero.level < 20 then randomElementFromArray(grayTrash)
      when hero.level < 30 then randomElementFromArray(whiteTrash)
      when hero.level < 40 then randomElementFromArray(greenTrash)
      when hero.level < 50 then randomElementFromArray(blueTrash)
      when hero.level < 60 then randomElementFromArray(purpleTrash)
      else randomElementFromArray(orangeTrash)
   print "Creating new level " + hero.level + " " + adjective + noun
   return new Trash(adjective + noun, hero.level, monsterHpFromLevel(hero.level))

# this function needs more work
monsterHpFromLevel = (level) -> Math.floor(20*level + 5*Math.pow(1.35, level))

# Enemies
##########

class @Monster extends @Entity
   constructor: (name, level, hp, @difficulty) ->
      super name, level, hp
      @gold = hp

class @Trash extends @Monster
   constructor: (name, level, hp) ->
      super name, level, hp, "easy"