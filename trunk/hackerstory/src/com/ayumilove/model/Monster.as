//Monster.as

package com.ayumilove.model
{
	public class Monster extends Character
	{
		private var _leftover:Array = [];
		private var _etcDrop:Array = []; 
		private var _useableDrop:Array = [];
		private var _oreDrop:Array = []; 	
		private var _equipDrop:Array = []; 	
		
		private var _mostEffectiveElement:Array = [];
		private var _lessEffectiveElement:Array = [];
		
		private var _knockback:int = 0;
		private var _effectiveStatus:Array = []; //Poison/Freeze/Heal
		private var _nonEffectiveStatus:Array = []; //Poison/Freeze/Heal
		
		public function Monster()
		{
		} //constructor
		

		public function get dropItems():Array
		{
			var _dropItems:Array = [];
			var p1:int = Math.random() * _etcDrop.length;
			var p2:int = Math.random() * _useableDrop.length;
			var p3:int = Math.random() * _oreDrop.length;
			var p4:int = Math.random() * _equipDrop.length;
			if(p1 <= 0.16){dropItems.push(new EtcDrop);}
			if(p2 <= 0.12){dropItems.push(new UseableDrop);}
			if(p3 <= 0.08){dropItems.push(new OreDrop);}
			if(p4 <= 0.04){dropItems.push(new EquipDrop);}			
			return _dropItems;
		}

	}
}

/*
Inventory System
etcDrop - raw/refine ore , quest items
*/