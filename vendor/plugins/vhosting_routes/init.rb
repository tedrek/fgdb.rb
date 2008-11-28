ActionController::Routing::Route.send(:include, ActionController::Routing::VhostingRoutes)
ActionController::Routing::RouteSet.send(:include, ActionController::Routing::VhostingRouteSets)
