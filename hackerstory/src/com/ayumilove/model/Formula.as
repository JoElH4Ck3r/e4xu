//Formula.as

package com.ayumilove.model
{
	import com.ayumilove.events.GameEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Formula extends EventDispatcher
	{
		private var _monsterData:XML;
		private static const _accuracy08:Array = [10000, 11000, 12000, 13000, 30000, 
										31000, 32000, 33000, 40000, 41000, 42000, 52000];
		private static const _accuracy06:Array = [20000, 21000, 22000, 50000, 51000];
		
		private static const levelsEXP:Array = [15, 34, 57, 92, 135, 372, 560, 840, 
												1242, 1716, 2360, 3216, 4200, 5460, 
												7050, 8840, 11040, 13716, 16680, 20216, 
												24402, 28980, 34320, 40512, 47216, 54900, 
												63666, 73080, 83720, 95700, 108480, 122760, 
												138666, 155540, 174216, 194832, 216600, 240500, 
												266682, 294216, 324240, 356916, 391160, 428280, 
												468450, 510420, 555680, 604416, 655200, 709716];
		
		public function Formula()
		{
			super();
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.load(new URLRequest("xml/monsterData.xml"));
		}
		
		public function baseAccuracyMS(tempHeroJobClass:int, tempDEX:int, tempLUK:int):int
		{
			var tempBaseAccuracy:int = 0;
			tempHeroJobClass = ((tempHeroJobClass / 1000) >> 0) * 1000;
			if (_accuracy08.indexOf(tempHeroJobClass) > -1)
			{
				return 0.8 * tempDEX + 0.5 * tempLUK;
			}
			else if (_accuracy06.indexOf(tempHeroJobClass) > -1)
			{
				return 0.6 * tempDEX + 0.3 * tempLUK;;
			}
			trace("Invalid accuracy!");
			return tempBaseAccuracy;
		}
		
		public function getEXPForLevel(level:int):int
		{
			var temp:int;
			if (level < 1) level = 1;
			if (level < 50) return levelsEXP[level - 1];
			else
			{
				temp = levelsEXP[49];
				level -= 49;
				while (--level) temp *= 1.0548;
			}
			return temp;
		}
		
		private function completeHandler(event:Event):void 
		{
			(event.target as URLLoader).removeEventListener(Event.COMPLETE, completeHandler);
			_monsterData = XML((event.target as URLLoader).data);
			dispatchEvent(new GameEvent(GameEvent.UPDATE_PLAYER_STATS));
		}
		
		public function get isMonHurt():Boolean
		{
			//this uses player accuracy against monster avoidability
			//this can be used to check
			// - whether player can hit the monster
			// - whether monster can avoid player's attack
			// if isMonHurt is true [this means player can successfully hit it and monster can't avoid]
			return false;
		}
		
		public function get isPlayerHurt():Boolean
		{
			//this uses monster accuracy against player avoidability
			//this can be used to check
			// - whether monster can hit the player
			// - whether player can avoid monster's attack
			// if isPlayerHurt is true [this means monster can successfully hit it and player can't avoid]
			return false;
		}
		
		public function get rawDamage():int
		{
			//get raw damage from player [warrior,bowman,thief,magician,pirate]
			return 0;
		}
		
		public function get netDamageWeapon():int
		{
			//player's weapon raw damage subtracts monster defense
			return 0;
		}
		
		public function get netDamageMagic():int
		{
			//player's magic raw damage subtracts monster defense
			return 0;
		}
	}
}