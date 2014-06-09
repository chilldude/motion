Template.postItem.helpers
  domain: ->
    a = document.createElement('a')
    a.href = @url
    a.hostname

  ownPost: ->
    @userId == Meteor.userId()