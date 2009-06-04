package com.ayumilove.screen
{

	import com.ayumilove.events.GameEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;	
	import flash.events.MouseEvent;	
	
	public class LoginScreen extends GameScreen
	{
		public var btn_newgame:SimpleButton;
		public var btn_loadgame:SimpleButton;		
		
		public function LoginScreen()
		{
			trace("LoginScreen");
			super(); //to auto declare all the variables defined above. added at the start by default
			screenType[btn_newgame] = "newgameScreen";
			screenType[btn_loadgame] = "loadScreen";		
			//btn_newgame = getChildByName("btn_newgame") as SimpleButton; //required for FLEX
			//btn_loadgame = getChildByName("btn_loadgame") as SimpleButton;			
			trace(btn_newgame);

			btn_loadgame.addEventListener(MouseEvent.CLICK, setGameScreen);
			btn_newgame.addEventListener(MouseEvent.CLICK, newgame_clickHandler);
		}
		
		private function newgame_clickHandler(event:MouseEvent):void
		{
			dispatchEvent(new GameEvent(GameEvent.LOAD_MONSTER_DATA));
		}
	}
}