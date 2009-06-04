package com.ayumilove.model
{
	import flash.display.MovieClip;
	public class Character extends MovieClip
	{
		//For Player.as and Monster.as to inherit the variables and functions.
		protected var _objName:String = "";
		protected var _objLevel:int;
		protected var _objType:String = "";		
		protected var _curHP:int; 
		protected var _curMP:int; 
		protected var _maxHP:int; 
		protected var _maxMP:int; 
		protected var _curEXP:int; 
		protected var _maxEXP:int;
		protected var _accuracy:int; 
		protected var _avoid:int; 
		protected var _meso:int;
		protected var _wDef:int;
		protected var _mDef:int;
		protected var _wAtk:int;
		protected var _mAtk:int;
	
		public function get objName():String	{ return _objName; }
		public function get objLevel():int	{ return _objLevel; }
		public function get objType():String	{ return _objType; }
		public function get curHP():int		{ return _curHP; }
		public function get curMP():int		{ return _curMP; }
		public function get maxHP():int		{ return _maxHP; }
		public function get maxMP():int		{ return _maxMP; }
		public function get curEXP():int		{ return _curEXP; }
		public function get maxEXP():int	{ return _maxEXP; }
		public function get accuracy():int	{ return _accuracy; }
		public function get avoid():int		{ return _avoid; }
		public function get meso():int		{ return _meso; }
		
		public function set objName(temp:String):void	{ _objName = temp; }
		public function set objLevel(temp:int):void		{ _objLevel = temp; }
		public function set objType(temp:String):void	{ _objType = temp; }
		public function set curHP(temp:int):void		{ _curHP = temp; }
		public function set curMP(temp:int):void		{ _curMP = temp; }
		public function set maxHP(temp:int):void		{ _maxHP = temp; }
		public function set maxMP(temp:int):void		{ _maxMP = temp; }
		public function set curEXP(temp:int):void		{ _curEXP = temp; }
		public function set maxEXP(temp:int):void		{ _maxEXP = temp; }
		public function set accuracy(temp:int):void		{ _accuracy = temp; }
		public function set avoid(temp:int):void		{ _avoid = temp; }
		public function set meso(temp:int):void		{ _meso = temp; }
		
	}
}

/*
Ayumilove's Notes for Character Object
_objName = identity for player [player's name] and monster [monster's name] i.e. Ayumilove AND Zakum
_objLevel = player's character level and monster level [Note: used for defense formula]
_objType = player's occupation AND monster type. i.e. Spearman AND Undead
_curHP = current hit points [life/health]
_curMP = current mana points [magic]
_maxHP = player's and monster's max hit points [health]
_maxMP = player's and monster's max magic points [mana]
_curEXP = player's current exp 
_maxEXP = player's max exp AND monster exp reward per kill.
_accuracy = player's and monster's accuracy to hit each other.
_avoid = player's and monster's ability to avoid being hit.
_meso = player's current meso AND monster meso reward per kill.

*/