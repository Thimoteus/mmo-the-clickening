# Main hero class
##########

class Hero extends @Entity

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

# Actual class ... classes ... classes class? Wutevs.
##########

class @Warlock extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "rdps"
      @def = 1
      @defModifier = 1
      @dps = 5
      @dpsModifier = 1.1
      @hps = 0
      @hpsModifier = 1

class @Paladin extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "tank"
      @def = 5
      @defModifier = 1.1
      @dps = 2
      @dpsModifier = 1
      @hps = 0
      @hpsModifier = 1

class @Assassin extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "mdps"

class @Druid extends Hero
   constructor: (name, level, hp) ->
      super name, level, hp
      @role = "healer"
