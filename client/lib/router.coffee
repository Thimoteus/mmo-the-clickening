Router.configure
	layoutTemplate: "Main"
	loadingTemplate: "Loading"
	notFoundTemplate: "NotFound"

Router.map ->
	
	@route "Clicker",
		path: '/'

	@route "Upgrades",
		path: '/upgrades'

	@route "Export",
		path: '/export'

	@route "Settings",
		path: '/settings'