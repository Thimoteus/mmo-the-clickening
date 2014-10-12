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

# custom functions
##########

allChars = -> Characters.find()
currentChar = -> Characters.find(Session.get("currentChar"))

# UI stuff
########## &#9760;

# Clicker helpers
Template.Clicker.userHasChar = -> Characters.find().count() > 0
Template.Clicker.currentChar = -> Session.get("currentChar")

# Settings helpers
Template.Settings.characters = -> allChars()
Template.CharChooser.characters = -> allChars()

# Sidebar helpers
Template.Sidebar.char = -> Characters.findOne(Session.get("currentChar"))
# Template.Sidebar.classIcon = -> 

# events
Template.ClickerUI.events

   'click #clicker': (evt, cxt) ->
      Meteor.call("addClicks", 1)
      console.log "You clicked the button."

Template.Settings.events

   'click .logout': (evt, cxt) ->
      Session.set("currentChar", undefined)

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
      Session.set("currentChar", this._id)