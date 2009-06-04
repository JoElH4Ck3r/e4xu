package com.ayumilove.screen
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.display.DisplayObject;
	
	public class GameScreen extends MovieClip
	{
		public var screenType:Dictionary = new Dictionary();

		public function GameScreen()
		{
			super();
		
		}
		
		public function setGameScreen(event:MouseEvent):void
		{
			trace(Game.openScreen, Game.screenList);				
			trace((event.currentTarget as DisplayObject).name);			
			Game.openScreen(Game.screenList[screenType[event.currentTarget]]);
		}		
		
	}
}

/*
21 May 2009
1046: Type was not found or was not a compile-time constant: Dictionary.
public var screenType:Dictionary = new Dictionary();
Solution: You need to add this : import flash.utils.Dictionary;

			screenType[btn_login] = "LoginScreen";
			screenType[btn_town] = "TownScreen";
			screenType[btn_ship] = "ShipScreen";					
			screenType[btn_battle] = "BattleScreen";	
			screenType[btn_cashshop] = "CashshopScreen";	
			screenType[btn_freemarket] = "FreemarketScreen";	
			screenType[btn_newgame] = "NewGameScreen";
			screenType[btn_loadgame] = "LoadScreen";
			screenType[btn_savegame] = "SaveScreen";	
		public var btn_login:SimpleButton;
		public var btn_town:SimpleButton;
		public var btn_ship:SimpleButton;
		public var btn_battle:SimpleButton;
		public var btn_cashshop:SimpleButton;	
		public var btn_freemarket:SimpleButton;
		public var btn_newgame:SimpleButton;
		public var btn_loadgame:SimpleButton;	
		public var btn_savegame:SimpleButton;					
*/