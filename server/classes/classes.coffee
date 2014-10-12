# Classes

# Objects are either an "Entity" or an "Item". Monsters, bosses, heroes are all entities. Armor, weapons, special items are all items.

# Items, armor, weapons, etc.

class @Ability
   constructor: (@name, @level, @value, @description) ->

class @Item
   constructor: (@name, @ilvl, @color, @value) ->

class @Armor extends Item
   constructor: (name, ilvl, color, @defense) ->
      super attributes for attributes in [name, ilvl, color]

class @Weapon extends Item
   constructor: (name, ilvl, color, @dps) ->
      super attributes for attributes in [name, ilvl, color]

# Entity

class @Entity
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

# Exports
##########