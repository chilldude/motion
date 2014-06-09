# Local, client only collection for errors
Errors = new Meteor.collection null

throwError = (message) ->
  Errors.insert message: message

Template.errors.helpers
  errors: ->
    Errors.find()