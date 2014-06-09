@Posts = new Meteor.Collection("posts")

Posts.allow
  update: ownsDocument
  remove: ownsDocument

Posts.deny
  update: (userId, post, fieldNames) ->
    # may only edit 2 fields
    (_.without(fieldNames, 'url', 'title').length > 0)

Meteor.methods
  post: (postAttributes) ->
    user = Meteor.user()
    postWithSameLink = Posts.findOne url: postAttributes.url

    # ensure user is logged in
    unless user
      throw new Meteor.Error(401, "You need to login to post stories")

    # ensure post has title
    unless postAttributes.title
      throw new Meteor.Error(422, "Please fill in a headline")

    # check for dupe links
    if postAttributes.url and postWithSameLink
      throw new Meteor.Error(302, "Duplicate post", postWithSameLink._id)

    # pick out whitelisted keys
    post = _.extend(_.pick(postAttributes, "url", "title", "message"),
      {
        userId: user._id
        author: user.username
        submitted: new Date().getTime()
      }
    )

    postId = Posts.insert(post)

    postId