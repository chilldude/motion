Meteor.publish "posts", (options) ->
  Posts.find {}, options

Meteor.publish "comments", (postId) ->
  Comments.find(postId: postId)

Meteor.publish "notifications", ->
  Notifications.find userId: @userId