//Player.as
//Create 1 object player and 1 object equipment.
// <Sword damage="100" dps="5" slot="th" ... />
//Create equipment.as to only store equipment stats, while screen.as renders the equipment graphics

package com.ayumilove.model
{
	public class Player extends Character
	{
		//Base Stats
		private var _str:uint = 0; 			//strength
		private var _dex:uint = 0;			//dexterity
		private var _int:uint = 0; 			//inteligence
		private var _luk:uint = 0; 			//luck
		private var _SP:int = 0; 			//skill points
		private var _AP:int = 0; 			//ability points
		private var _fame:int = 0; 		//reduces suspicious
		private var _nxCash:int = 0; 		//currency for cash shop
		private var _guildName:String = "";
		
		 
		public function Player(){} //constructor
		
		//Get Functions
		public function get strength():uint			{ return _str; }
		public function get dexterity():uint		{ return _dex; }
		public function get intelligent():uint		{ return _int; }
		public function get luck():uint				{ return _luk; }
		public function get nxCash():int			{ return _nxCash; }
		public function get skillPoints():int		{ return _SP; }
		public function get abilityPoints():int		{ return _AP; }
		public function get fame():int				{ return _fame; }
		public function get guildName():String		{ return _guildName; }
		
		//Set Functions
		public function set strength(temp:uint):void	{ _str = temp; }
		public function set dexterity(temp:uint):void	{ _dex = temp; }
		public function set intelligent(temp:uint):void	{ _int = temp; }
		public function set luck(temp:uint):void		{ _luk = temp; }
		public function set nxCash(temp:int):void		{ _nxCash = temp; }
		public function set skillPoints(temp:int):void	{ _SP = temp; }
		public function set abilityPoints(temp:int):void { _AP = temp; }
		public function set fame(temp:int):void			{ _fame = temp; }
		public function set guildName(temp:String):void { _guildName = temp; }



	}
}