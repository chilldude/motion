@POST_HEIGHT  = 80
@Positions = new Meteor.Collection(null)

Template.postItem.helpers
  domain: ->
    a = document.createElement('a')
    a.href = @url
    a.hostname

  ownPost: ->
    @userId == Meteor.userId()

  upvotedClass: ->
    userId = Meteor.userId()
    if userId and not _.include(@upvoters, userId)
      'btn-primary upvotable'
    else
      'disabled'

  attributes: ->
    post = _.extend({}, Positions.findOne(postId: @_id), this)
    newPosition = post._rank * POST_HEIGHT
    attributes = {}
    unless _.isUndefined(post.position)
      delta = post.position - newPosition
      attributes.style = "top: " + delta + "px"
      attributes.class = "post animate"  if delta is 0
    Meteor.setTimeout ->
      Positions.upsert
        postId: post._id
      ,
        $set:
          position: newPosition

      return

    attributes

Template.postItem.events
  'click .upvotable': (e) ->
    e.preventDefault()
    Meteor.call('upvote', @_id)

    return