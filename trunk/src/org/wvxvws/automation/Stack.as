package org.wvxvws.automation 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Stack
	{
		protected var _stack:Vector.<Action> = new <Action>[];
		protected var _maxSteps:int;
		protected var _lastState:State;
		
		public function Stack() { super(); }
		
		public function append(action:Action, position:int = -1):Action
		{
			
		}
		
		public function remove(action:Action):Action
		{
			
		}
		
		public function exec(steps:int = -1):void
		{
			
		}
		
		public function rollback(steps:int = -1):void
		{
			
		}
		
		public function revert():void
		{
			
		}
		
		public function revertTofirstState():void
		{
			
		}
	}

}