package org.wvxvws.gui 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import mx.core.IMXMLObject;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class StatefulButton extends Sprite implements IMXMLObject
	{
		protected var _document:Object;
		protected var _id:String;
		protected var _states:Object = { };
		protected var _cachedStates:Object = { };
		protected var _currentState:DisplayObject;
		
		public function StatefulButton() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function set state(value:String):void
		{
			var newState:DisplayObject;
			if (!_cachedStates[value])
			{
				if (_states[value] && _states[value] is Class)
					newState = new (_states[value])() as DisplayObject;
				else return;
				if (!newState) return;
				_cachedStates[value] = newState;
			}
			else newState = _cachedStates[value];
			if (_currentState && contains(_currentState))
				removeChild(_currentState);
			_currentState = addChild(newState);
		}
		
		public function get state():String
		{
			for (var p:String in _cachedStates)
			{
				if (_cachedStates[p] === _currentState && contains(_currentState))
					return p;
			}
			return null;
		}
		
		public function set states(value:Object):void { _states = value; }
		
		public function get states():Object { return _states; }
	}
	
}