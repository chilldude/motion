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
    nextPath = @route.path(postsLimit: @limit + @increment)

    posts: @posts()
    nextPath: (hasMore ? nextPath : null)

)

Router.map ->
  @route "postPage",
    path: "/posts/:_id"
    waitOn: ->
      Meteor.subscribe "comments", @params._id
    data: ->
      Posts.findOne @params._id

  @route "postSubmit",
    path: "/submit"

  @route "postEdit",
    path: "/posts/:_id/edit"
    data: ->
      Posts.findOne @params._id

  @route "postsList",
    path: "/:postsLimit?"
    controller: PostsListController

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