# Models
##########

@Characters = new Mongo.Collection("characters")

# Custom functions
##########

print = (message) ->
   if Meteor.isServer
      console.log(message) if Meteor.settings.verbose
   if Meteor.isClient
      console.log(message)

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

# Exports
##########

share.print = print