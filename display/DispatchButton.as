﻿import display.DispatchMovie2;/***********************************************************\* This class extends DispatchMovie2 to enable button states	*\***********************************************************/class display.DispatchButton extends DispatchMovie2{		// Constants to link to sprite:		public static var CLASS_REF = DispatchButton;	public static var LINKAGE_ID:String = "DispatchButton";		/***************************\	* Constructor				*	\***************************/	public function DispatchButton(){		trace('DispatchButton: Constructor: '+this._name+' created');		this.onRollOver = showOver;		this.onRollOut = showOff;	}		private function showOver():Void{		trace('DispatchButton: showOver()');		this.gotoAndPlay('Over');	}		private function showOff():Void{		trace('DispatchButton: showOff()');		this.gotoAndPlay('Off');	}}