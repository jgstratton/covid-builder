component{

	/**
	* index
	*/
	function index( event, rc, prc ){
		prc.welcomeMessage = "Welcome to ColdBox!";
		event.setView( "main/index" );
	}

	function previewSite( event, rc, prc ){
		event.setLayout( "blank" );
	}

	function buildSite( event, rc, prc ){
		event.setView( "main/buildSite" );
	}
}
