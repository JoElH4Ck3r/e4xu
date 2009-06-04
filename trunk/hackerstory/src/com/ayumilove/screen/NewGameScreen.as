package com.ayumilove.screen
{

	import flash.display.MovieClip;
	import flash.display.SimpleButton;	
	import flash.events.MouseEvent;	
	
	public class NewGameScreen extends GameScreen
	{
		public var btn_newgame:SimpleButton;
		public var btn_loadgame:SimpleButton;		
		
		public function NewGameScreen()
		{
			super(); //to auto declare all the variables defined above. added at the start by default
			screenType[btn_newgame] = "newgameScreen";
			screenType[btn_loadgame] = "loginScreen";			

			trace(btn_newgame);

			btn_newgame.addEventListener(MouseEvent.CLICK ,setGameScreen);
			btn_loadgame.addEventListener(MouseEvent.CLICK,setGameScreen);			
		}
	}
		
}

/*
			//btn_newgame = getChildByName("btn_newgame") as SimpleButton; //required for FLEX
			//btn_loadgame = getChildByName("btn_loadgame") as SimpleButton;		
*/