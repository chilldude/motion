Router.configure
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  waitOn: ->
    Meteor.subscribe "posts"

Router.map ->
  @route "postsList",
    path: "/"

  @route "postPage",
    path: "/posts/:_id"
    data: ->
      Posts.findOne @params._id

  @route "postSubmit",
    path: "/submit"

  return

requireLogin = ->
  unless Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      @render "accessDenied"
    @stop()
  return

Router.onBeforeAction requireLogin,
  only: "postSubmit"