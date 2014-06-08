@Posts = new Meteor.Collection("posts")

Posts.allow insert: (userId, doc) ->
  # only allow posting if user is logged in
  !!userId