# Imports, etc
##########

users = Meteor.users
settings = Meteor.settings
print = share.print

# Publications
##########

Meteor.publish("characters", ->
      return Characters.find({'owner': @userId})
   )

# Startup
##########

Meteor.startup ->
   # code
   ServiceConfiguration.configurations.remove
      service: "facebook"

   ServiceConfiguration.configurations.insert
      service: "facebook"
      appId: Meteor.settings.app_id
      secret: Meteor.settings.app_secret

# Database write permissions for client
##########

Characters.allow

   remove: (userId, doc) -> yes

users.deny
   
   update: (userId, docs, fields, modifier) ->
      
      restrictedMods = [
         "$currentDate", "$inc", "$max",
         "$min", "$mul", "$rename",
         "$setOnInsert", "$unset"
      ]
      
      if "profile" in fields
         for mods in restrictedMods
            return true if mods of modifier
         if "$set" of modifier
            return "profile.character.class" of modifier["$set"]

# Methods
##########

Meteor.methods
   
   "addClicks": (amount) ->
      
      try
         check(amount, Number)
         users.update(@userId, {$inc: {"totalClicks": amount}})
      
      catch error
         console.log error

   "createChar": (name, charClass) ->

      isActuallyAClass = Match.Where (charClass) ->
         
         check charClass, String
         return charClass in ["warlock", "paladin", "assassin", "druid"]

      check(name, String)
      check(charClass, isActuallyAClass)
      print "Attempting to create a new #{charClass}"
      Characters.insert
         'owner': @userId
         'class': charClass
         'name': name
         'level': 1
         'hp': 20


      return

# the Game
##########

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