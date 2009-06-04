package com.ayumilove.events 
{
	import flash.events.Event;
	
	/**
	* GameEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class GameEvent extends Event 
	{
		public static const UPDATE_PLAYER_STATS:String = "updatePlayerStats";
		public static const LOAD_MONSTER_DATA:String = "loadMonsterData";
		
		public function GameEvent(type:String)
		{ 
			super(type, true, true);
		} 
		
		public override function clone():Event 
		{ 
			return new GameEvent(type);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("GameEvent", "type");
		}
	}
}