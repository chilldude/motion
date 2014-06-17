Template.header.helpers activeRouteClass: -> # route names
  args = Array::slice.call(arguments_, 0)
  args.pop()
  active = _.any(args, (name) ->
    Router.current().route.name is name
  )
  active and "active"