Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  waitOn: ->
    [
      Meteor.subscribe("notifications")
    ]

PostsListController = RouteController.extend(
  template: "postsList"
  increment: 5
  limit: ->
    parseInt(@params.postsLimit) or @increment
  findOptions: ->
    sort:
      submitted: -1
    limit: @limit()
  waitOn: ->
    Meteor.subscribe "posts", @findOptions()
  posts: ->
    Posts.find({}, @findOptions())
  data: ->
    hasMore = @posts().fetch().length is @limit()

    posts: @posts()
    nextPath: (if hasMore then nextPath else null)
)

NewPostsListController = PostsListController.extend(
  sort:
    submitted: -1
    _id: -1
  nextPath: ->
    Router.routes.newPosts.path(
      postsLimit: @limit() + @increment
    )
)

TopPostsListController = PostsListController.extend(
  sort:
    votes: -1
    submitted: -1
    _id: -1
  nextPath: ->
    Router.routes.topPosts.path(
      postsLimit: @limit() + @increment
    )

)

Router.map ->
  @route "postPage",
    path: "/posts/:_id"
    waitOn: ->
      [
        Meteor.subscribe "singlePost", @params._id
        Meteor.subscribe "comments", @params._id
      ]
    data: ->
      Posts.findOne @params._id

  @route "postSubmit",
    path: "/submit"
    disableProgerss: true

  @route "postEdit",
    path: "/posts/:_id/edit"
    waitOn: ->
      Meteor.subscribe "singlePost", @prarams._id
    data: ->
      Posts.findOne @params._id

  @route "home",
    path: "/"
    controller: NewPostsListController

  @route "newPosts",
    path: "new/:postsLimit?"
    controller: NewPostsListController

  @route "topPosts",
    path: "top/:postsLimit?"
    controller: NewPostsListController

  return

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied"
    @pause()
  return

Router.onBeforeAction("loading")
Router.onBeforeAction requireLogin,
  only: "postSubmit"

Router.onBeforeAction ->
  clearErrors()
  return