/***************************************************************************\
*																			*
*  Holds data fields for an individual player in Warhawk Widget Version 2	*
*																			*
*  Peter Hastie - 19th February 2009										*
*																			*
*  AS2.0																	*
*																			*
*  - Just a struct, has no methods											*
*  - Holds all 22 fields of XML entry as well as rank and name				*
*																			*
\***************************************************************************/

class warhawk_v2.PlayerData{
	
	public var playerName:String;
	public var rank:Number;
	/*
	public var gamePoints:Number;
	public var teamScore:Number;
	public var bonusScore:Number;
	public var globalTime:Number;
	public var kills:Number;
	public var deaths:Number;
	public var kdr:Number;
	public var globalAccuracy:Number;
	public var wins:Number;
	public var losses:Number;
	public var winLossRatio:Number;
	public var scorePerMin:Number;
	public var dmScore:Number;
	public var tdmScore:Number;
	public var ctfScore:Number;
	public var zonesScore:Number;
	public var milesWalked:Number;
	public var milesDriven:Number;
	public var milesFlown:Number;
	*/
	
	
	public var GAME_POINTS:Number;
	public var TEAM_SCORE:Number;
	public var BONUS_SCORE:Number;
	public var GLOBAL_TIME:Number;
	public var KILLS:Number;
	public var DEATHS:Number;
	public var KDR:Number;
	public var GLOBAL_ACCURACY:Number;
	public var WINS:Number;
	public var LOSSES:Number;
	public var WIN_LOSS_RATIO:Number;
	public var SCORE_PER_MIN:Number;
	public var DM_SCORE:Number;
	public var TDM_SCORE:Number;
	public var CTF_SCORE:Number;
	public var ZONES_SCORE:Number;
	public var MILES_WALKED:Number;
	public var MILES_DRIVEN:Number;
	public var MILES_FLOWN:Number;
	
	
	/***************\
	* Constructor	*
	\***************/
	public function PlayerData(input:Object){
		trace('PlayerData: Constructor: new PlayerData instance');
		// Sort through the input object and assign the data to the correct variables
		assignData(input);
	}
	
	/*******************\
	* Private functions	*
	\*******************/
	private function assignData(input:Object){
		// Sort through the input object and assign the data to the correct variables
		trace('PlayerData: assignData(): assigning data');
		// Iterate across all the fields of the object
		playerName 		= input._Name;
		rank 			= Number(input._Rank);
		/*
		gamePoints      = Number(input.GAME_POINTS);
		teamScore		= Number(input.TEAM_SCORE);
		bonusScore	 	= Number(input.BONUS_SCORE);
		globalTime	    = Number(input.GLOBAL_TIME);
		kills			= Number(input.KILLS);
		deaths			= Number(input.DEATHS);
		kdr				= Number(input.KDR);
		globalAccuracy	= Number(input.GLOBAL_ACCURACY);
		wins			= Number(input.WINS);
		losses			= Number(input.LOSSES);
		winLossRatio	= Number(input.WIN_LOSS_RATIO);
		scorePerMin		= Number(input.SCORE_PER_MIN);
		dmScore			= Number(input.DM_SCORE);
		tdmScore		= Number(input.TDM_SCORE);
		ctfScore		= Number(input.CTF_SCORE);
		zonesScore		= Number(input.ZONES_SCORE);
		milesWalked		= Number(input.MILES_WALKED);
		milesDriven		= Number(input.MILES_DRIVEN);
		milesFlown		= Number(input.MILES_FLOWN);
		*/
		
		
		GAME_POINTS      = Number(input.GAME_POINTS);
		TEAM_SCORE		= Number(input.TEAM_SCORE);
		BONUS_SCORE	 	= Number(input.BONUS_SCORE);
		GLOBAL_TIME	    = Number(input.GLOBAL_TIME);
		KILLS			= Number(input.KILLS);
		DEATHS			= Number(input.DEATHS);
		KDR				= Number(input.KDR);
		GLOBAL_ACCURACY	= Number(input.GLOBAL_ACCURACY);
		WINS			= Number(input.WINS);
		LOSSES			= Number(input.LOSSES);
		WIN_LOSS_RATIO	= Number(input.WIN_LOSS_RATIO);
		SCORE_PER_MIN	= Number(input.SCORE_PER_MIN);
		DM_SCORE		= Number(input.DM_SCORE);
		TDM_SCORE		= Number(input.TDM_SCORE);
		CTF_SCORE		= Number(input.CTF_SCORE);
		ZONES_SCORE		= Number(input.ZONES_SCORE);
		MILES_WALKED	= Number(input.MILES_WALKED);
		MILES_DRIVEN	= Number(input.MILES_DRIVEN);
		MILES_FLOWN		= Number(input.MILES_FLOWN);
		
	}
}