package org.wvxvws.gui 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import mx.core.IMXMLObject;
	
	[DefaultProperty("states")]
	
	/**
	 * StatefulButton class.
	 * @author wvxvw
	 */
	public class StatefulButton extends Sprite implements IMXMLObject
	{
		public override function set width(value:Number):void 
		{
			if (this._currentState) this._currentState.width = value;
			this._stateDimensions.x = value;
		}
		
		public override function set height(value:Number):void 
		{
			if (this._currentState) this._currentState.height = value;
			this._stateDimensions.y = value;
		}
		
		public function get state():String
		{
			for (var p:String in this._cachedStates)
			{
				if (this._cachedStates[p] === this._currentState && 
					contains(this._currentState))
					return p;
			}
			return null;
		}
		
		public function set state(value:String):void
		{
			var newState:DisplayObject;
			if (!this._cachedStates[value])
			{
				if (this._states[value] && this._states[value] is Class)
					newState = new (this._states[value])() as DisplayObject;
				else if (this._states[value] && this._states[value] is DisplayObject)
				{
					newState = this._states[value] as DisplayObject;
					if (newState.parent) newState.parent.removeChild(newState);
				}
				else return;
				if (!newState) return;
				this._cachedStates[value] = newState;
			}
			else newState = this._cachedStates[value];
			if (this._currentState && super.contains(this._currentState))
				super.removeChild(this._currentState);
			if (this._stateDimensions.x) newState.width = this._stateDimensions.x;
			if (this._stateDimensions.y) newState.height = this._stateDimensions.y;
			this._currentState = super.addChildAt(newState, 0);
		}
		
		public function set states(value:Object):void { this._states = value; }
		
		public function get states():Object { return this._states; }
		
		protected var _document:Object;
		protected var _id:String;
		protected var _states:Object = { };
		protected var _cachedStates:Object = { };
		protected var _currentState:DisplayObject;
		protected var _stateDimensions:Point = new Point();
		
		public function StatefulButton() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			if (super.parent && super.parent !== this._document && 
				(this._document is DisplayObjectContainer))
			{
				super.parent.removeChild(this);
				(this._document as DisplayObjectContainer).addChild(this);
			}
			else if (!super.parent && 
				(this._document is DisplayObjectContainer))
			{
				(this._document as DisplayObjectContainer).addChild(this);
			}
			this._id = id;
		}
		
		public function dispose():void { }
	}
}