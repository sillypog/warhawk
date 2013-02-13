import warhawk_v2.LeaderboardModel;
import mvc.AbstractView;
import warhawk_v2.views.*;
import warhawk_v2.AnimationCentre;

/***************************************************************************\
*																			*
*  The document class for Warhawk Widget Version 2							*
*																			*
*  Peter Hastie - 18th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Responsible for initialising the widget								*
*  - Instantiates Model, and Views (which instantiate their own controllers)*
*  - Draws basic assets on the stage										*
*																			*
\***************************************************************************/

class warhawk_v2.Leaderboard{
	
	private var model:LeaderboardModel; 				// Stores reference to the model which deals with data loading and parsing
	private var animationCentre:AnimationCentre;		// Reference to the object that controls sprite animation
	private var theStage:MovieClip; 					// Stores a reference to the stage on to which movieclips are drawn
	private var depth:Number;							// The next layer to add movieclips to
	
	// References to views
	private var errorsView:AbstractView;				// Handles display of error boxes on the screen when error messages are sent from model
	private var logosView:AbstractView;					// Displays the cycling logos
	private var headerView:AbstractView	;				// This is the mode header and progress bar at the top of the screen
	private var navView:AbstractView;					// The navigation and menu buttons
	private var valuesTextView:AbstractView;			// The player data as text
	private var valuesGraphView:AbstractView;			// The player data as bars
	private var rankBarView:AbstractView;				// Displays the current ranks of players on screen and the sort field
	private var fieldControlsView:AbstractView;			// Shows and allows user to change current field
	private var tvGlowView:AbstractView;				// Controls the glow/mask effect that reveals data after initialisation
	
	
	/***************************************\
	* Constructor							*
	*										*
	* @params:								*
	*	- target: Reference to the stage	*
	\***************************************/
	public function Leaderboard(target:MovieClip){
		trace('Leaderboard: Consructor');
		
		//Save params
		theStage = target;
		
		//Set up security parameters
		System.security.allowDomain("http://stats.us.playstation.com");
		System.security.allowDomain("http://qa.stats.us.playstation.com");
		
		//Set up the model
		model = new LeaderboardModel();
		
		//And the animation centre
		animationCentre = new AnimationCentre(model);
		
		//Draw the basic stuff on the stage
		drawWidget(theStage);

		
		//For now at least, load the XML from here
		//model.loadXML("http://qa.stats.us.playstation.com/Warhawk/LeaderboardsXML.aspx?start=1&end=20&sort=GAME_POINTS");
		//model.loadXML("bad.xml");
		//model.loadXML("http://qa.stats.us.playstation.com/Warhawk/");
		model.loadXML("http://stats.us.playstation.com/Warhawk/");
	}
	
	
	
	/*******************\
	* Private functions	*
	\*******************/
	private function drawWidget(theStage){
		trace('Leaderboard: drawWidget()');
		
		//Set depth before anything is drawn
		depth=1;
		
		//Add static clips to the stage
		theStage.attachMovie("WidgetBackground","widget_background_mc",depth++);					// Main black casing
		var gradientBack = theStage.attachMovie("GradientBack","gradient_background_mc",depth++);	// Blue gradient border
		gradientBack._x = 2;
		gradientBack._y = 74.5;
		var mainPanel = theStage.attachMovie("MainPanel","main_panel_mc",depth++);
		mainPanel._x = 5;
		mainPanel._y = 92;
		
		/* - This is just a test to get dimensions correct
		var lowerNavBar = theStage.attachMovie("LowerNavBar","lower_nav_mc",depth++);
		lowerNavBar._x = 2;
		lowerNavBar._y = 103;
		*/
		
		
		//Attach views
		logosView = new Logo(model, undefined, theStage,  depth++);
		headerView = new HeaderBar(model, undefined, theStage,  depth++);
		valuesGraphView = new ValuesGraph(model, undefined, theStage,  depth++, animationCentre);
		navView = new Navigation(model, undefined, theStage,  depth++);
		valuesTextView = new ValuesText(model, undefined, theStage, depth++);
		rankBarView = new RankDisplay(model, undefined, theStage, depth++);
		fieldControlsView = new FieldSelect(model, undefined, theStage, depth++, animationCentre);
		tvGlowView = new TVGlowEffect(model, undefined, theStage,depth++, animationCentre);
		errorsView = new ErrorBox(model, undefined, theStage, depth++, animationCentre);

		
		//Initialise values in views
		model.setMode('Leaderboard');
		
		
		//Finished initialising!
	}
}
		

