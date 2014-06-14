@Comments = new Meteor.Collection "comments"

Meteor.methods
  comment: (commentAttributes) ->
    user = Meteor.user()
    post = Posts.findOne commentAttributes.postId

    # ensure user is logged in
    unless user
      throw new Meteor.Error(401, "You need to login to make comments");

    unless commentAttributes.body
      throw new Meteor.Error(422, 'Please write some content');

    unless post
      throw new Meteor.Error(422, 'You must comment on a post');

    comment = _.extend(_.pick(commentAttributes, "postId", "body"),
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
    )

    Posts.update comment.postId,
      $inc:
        commentsCount: 1

    # create the comment, then save the id
    comment._id = Comments.insert comment

    # create a notification, informing other users that there's been a comment
    createCommentNotification(comment)

    comment._id