Template.header.helpers activeRouteClass: (path) -> # route names
  active = Router.current() is path
  active and "active"