####################
# MMO: The Clickening
# version 0.11
# Copyright Evante Garza-Licudine
# github.com/thimoteus
####################

# imports
##########
print = share.print

# subscriptions
##########
Meteor.subscribe("characters")

# custom functions, calls
##########
chat = (msg) -> $("#chat").append("<div>#{msg}</div>")
allChars = -> Characters.find()
currentChar = -> Characters.findOne({"loggedIn": true})
charsLeft = ->
   total = 3
   current = Characters.find().count()
   return total - current

# UI stuff
########## &#9760;

# Clicker helpers
Template.Clicker.helpers

   userHasChar: -> Characters.find().count() > 0
   currentChar: -> currentChar()

# Settings helpers
Template.Settings.helpers

   characters: -> Characters.find({"loggedIn": false})
   currentChar: -> currentChar()?['name']
   canMakeChar: -> charsLeft() > 0

Template.CharChooser.helpers

   characters: -> allChars()

Template.CharCreator.helpers

   charsLeft: -> charsLeft()

# Sidebar helpers
Template.Sidebar.helpers

   char: -> currentChar()
   # classIcon: ->

# events
Template.ClickerUI.events

   'click #clicker': (evt, cxt) ->

      Meteor.call("addClicks", 1)
      console.log "You clicked the button."

Template.Settings.events

   'click .logout': (evt, cxt) ->

      Meteor.call("logoutChar")
      chat("You have successfully logged out.")

Template.CharCreator.events
   
   'submit #char-creator': (evt, cxt) ->
      
      evt.preventDefault()
      
      name = cxt.$("input.char-name-input")[0].value
      charClass = cxt.$("option:selected")[0].value
      
      Meteor.call("createChar", name, charClass)
      
      print "#{name} is a new #{charClass}!"
      
      cxt.find("input.char-name-input").value = ""
      cxt.$("option.default").prop("selected")

Template.CharInfo.events
   
   'click button.delete': (evt, cxt) ->
      
      name = @name
      Characters.remove(@_id)
      print "#{name} has been deleted."

Template.CharChooser.events

   'click a': (evt, cxt) ->

      evt.preventDefault()
      $(evt.target).css("fontWeight", "bold")
      Meteor.call("loginChar", @_id)
      chat("Logging in as #{@name}")