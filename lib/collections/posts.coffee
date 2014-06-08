@Posts = new Meteor.Collection("posts")

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

    # check for dupes
    if postAttributes.url and postWithSameLink
      throw new Meteor.Error(302, "Duplicate post", postWithSameLink._id)

    # pick out whitelisted keys
    post = _.extend(_.pick(postAttributes, "url", "title", "message",
      title: postAttributes.title
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
    ))

    postId = Posts.insert(post)

    return postId