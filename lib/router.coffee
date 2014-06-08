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

  @route "postEdit",
    path: "/posts/:_id/edit"
    data: ->
      Posts.findOne @params._id

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