####################
####################
# MMO: The Clickening
# version 0.1
# Copyright Evante Garza-Licudine
# github.com/thimoteus
####################
####################

# Custom errors, objects, functions, etc.

Death = (message) ->
   this.name = "DeathError"
   this.message = message or "Entity is dead."

CantEquip = (message) ->
   this.name = "EquipError"
   this.message = message or "Can't equip that!"

CantTake = (message) ->
   this.name = "InventoryError"
   this.message = message or "Not enough room!"

print = (message) -> console.log(message)

removeFirstMatchFromArray = (element, array) ->
   newArray = []
   theSwitch = on
   for item in array
      if element isnt item
         newArray.push item
      else
         if theSwitch is on
            theSwitch = off
         else
            newArray.push item
   return newArray

randomElementFromArray = (array) ->
   index = Math.floor(Math.random()*array.length)
   array[index]

handleCharacterDeath = (character) ->
   print "#{character.name} is dead."

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

# Classes

# Objects are either an "Entity" or an "Item". Monsters, bosses, heroes are all entities. Armor, weapons, special items are all items.

# Items, armor, weapons, etc.

class Ability
   constructor: (@name, @level, @value, @description) ->

class Item
   constructor: (@name, @ilvl, @color, @value) ->

class Armor extends Item
   constructor: (name, ilvl, color, @defense) ->
      super attributes for attributes in [name, ilvl, color]

class Weapon extends Item
   constructor: (name, ilvl, color, @dps) ->
      super attributes for attributes in [name, ilvl, color]

# Entities, heroes, monsters, etc.

class Entity
   constructor: (@name, @level, @hp) ->
      @def = 0
      @defModifier = 1
      @dps = 1
      @dpsModifier = 1
      @hps = 0
      @hpsModifier = 1

   attack: (target) ->
      damage = @dps*@dpsModifier
      target.takeDamage(damage)

   takeDamage: (dps) ->
      mitigated = @def*@defModifier
      damage = dps - mitigated
      if @hp - damage > 0
         @hp -= damage
      else
         throw new Death(@name + " has been slain!")

   getHealed: (hps) ->
      @hp = if @hp >= 0 then @hp + hps else throw new Death(@name + " is dead.")

class Hero extends Entity

   constructor: (name, level, hp) ->
      super name, level, hp
      @gold = 0
      @exp = 0
      @armor = []
      @inventory = []
      @inventorySpace = 10
      @abilities = []

   learnAbility: (ability) ->
      @abilities.push(ability.name)

   gainGold: (amount) -> @gold += amount

   equipArmor: (armor) ->
      if armor.name in @inventory
         @armor.push armor.name
         removeItemFromInventory(armor)
      else
         throw new EquipError("I don't have #{armor.name} in my inventory!")

   unequipArmor: (armor) ->
      if armor.name in @armor
         try
            @addItemToInventory(armor)
         catch error
            if error instanceof InventoryFull
               print error.message
            else
               throw error

   addItemToInventory: (item) ->
      if @inventory.length < @inventorySpace
         @inventory.push item.name
      else
         throw new CantTake("I don't have enough room for #{item.name}!")

   removeItemFromInventory: (item) ->
      if item.name in @inventory
         @inventory = removeFirstMatchFromArray(item.name, @inventory)
      else
         throw new CantTake("I don't have that item in my inventory!")

   buy: (thing) ->
      gold = @gold
      if thing.value <= gold
         if thing instanceof Item
            try
               addItemToInventory(thing)
               @gold -= thing.value
            catch e
               if e.name is "CantTake"
                  print e.message
                  @gold = gold
               else
                  @gold = gold
                  throw e
         else if thing instanceof Ability
            try
               learnAbility(thing)
            catch e
               print e.message
         else
            throw new Error("I'm not sure what you're trying to buy?")
      else
         throw new CantTake("I don't have enough money!")

class Warlock extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "rdps"
      @def = 1
      @defModifier = 1
      @dps = 5
      @dpsModifier = 1.1
      @hps = 0
      @hpsModifier = 1

class Paladin extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "tank"
      @def = 5
      @defModifier = 1.1
      @dps = 2
      @dpsModifier = 1
      @hps = 0
      @hpsModifier = 1

class Assassin extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "mdps"

class Druid extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "healer"

# Enemies

class Monster extends Entity
   constructor: (name, level, hp, @difficulty) ->
      super name, level, hp
      @gold = hp

class Trash extends Monster
   constructor: (name, level, hp) ->
      super name, level, hp, "easy"

# the Game

class Game
   constructor: (hash) ->
      # saved game states are stored in base-64 hashes. Games are completely determined by the data stored in the hash.
      gameDataString = window.atob(hash)
      gameData = JSON.parse(gameDataString)
      for key, value of gameData
         this[key] = value
   save: ->
      # saving the game returns a base-64 encoded JSON object that has all of the game's properties as data.
      gameData = {}
      for key, value of this
         gameData[key] = value if typeof this[key] isnt "function"
      return window.btoa(JSON.stringify(gameData))
   heroes: []
   villains: []

gold =
   "rat": 5
   "snake": 6
   "bat": 7
   "boar": 8

adjectives = ["sneaky ", "filthy ", "diseased ", "carcinogenic ", "slimy ", "tragic ", "scared ", "scary ", "Martian ", "belligerent "]

grayTrash = ["rat", "snake", "bat", "boar"]
whiteTrash = []
greenTrash = []
blueTrash = []
purpleTrash = []
orangeTrash = []

# UI stuff

updateBottomBar = (hero, monster) ->
   $(".hero-gold").text(hero.gold)
   $(".hero-name").text(hero.name)
   $(".hero-dps").text(hero.dps)
   $(".hero-hp").text(hero.hp)

   $(".monster-name").text(monster.name)
   $(".monster-difficulty").text(monster.difficulty)
   $(".monster-hp").text(monster.hp)

clickManager = ->
   hero = belligerents.hero
   monster = belligerents.monster
   try
      hero.attack(monster)
      updateBottomBar(hero, monster)
   catch error
      if error instanceof Death
         print error.message
         hero.gainGold(monster.gold)
         belligerents.monster = newTrash(hero)
         updateBottomBar(hero, monster)
         return
      else
         throw error
   try
      monster.attack(hero)
   catch error
      if error instanceof Death
         print error.message
         handleCharacterDeath(hero)
      else
         throw error

# init
$ ->
   # gameData = blahblah
   # game = new Game(gameData)

   # belligerents.hero = new Assassin("Evante", 1, 100)
   # belligerents.monster = new Trash("rat", 1, 3)
   # updateBottomBar(belligerents.hero, belligerents.monster)
   # $("#click").on("click", ->
   #    clickManager()
   # )
