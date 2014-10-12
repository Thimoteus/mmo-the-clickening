# Custom objects, functions, etc

Death = (message) ->
   this.name = "DeathError"
   this.message = message or "Entity is dead."

CantEquip = (message) ->
   this.name = "EquipError"
   this.message = message or "Can't equip that!"

CantTake = (message) ->
   this.name = "InventoryError"
   this.message = message or "Not enough room!"

handleCharacterDeath = (character) ->
   print "#{character.name} is dead."


# Exports
##########