# Local, client only collection for errors
@Errors = new Meteor.Collection null

@throwError = (message) ->
  Errors.insert
    message: message
    seen: false

@clearErrors = ->
  Errors.remove seen: true

Template.errors.helpers
  errors: ->
    Errors.find()

Template.errors.rendered = ->
  error = @data
  Meteor.defer ->
    Errors.update error._id,
      $set: {seen: true}