package org.wvxvws.rendering
{
	//{ imports
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	//}
	
	/**
	 * Renderable class.
	 * @author wvxvw
	 */
	public class Renderable extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const CHANGE_PROPERTY:String = "changeCroperty";
		
		public override function get x():Number { return _newBounds.x; }
		
		public override function set x(value:Number):void 
		{
			_newBounds.x = value;
			this.valid = false;
		}
		
		public override function get y():Number { return _newBounds.y; }
		
		public override function set y(value:Number):void 
		{
			_newBounds.y = value;
			this.valid = false;
		}
		
		public override function get width():Number { return _newBounds.width; }
		
		public override function set width(value:Number):void 
		{
			_newBounds.width = value;
			this.valid = false;
		}
		
		public override function get height():Number { return _newBounds.height; }
		
		public override function set height(value:Number):void 
		{
			_newBounds.height = value;
			this.valid = false;
		}
		
		public function get valid():Boolean { return _valid; }
		
		public function set valid(value:Boolean):void 
		{
			if (value === _valid) return;
			super.dispatchEvent(_changeEvent);
			if (value) super.removeEventListener(Event.ENTER_FRAME, renderHandler);
			else if (stage) super.addEventListener(Event.ENTER_FRAME, renderHandler);
			_valid = value;
		}
		
		public function get visibleWidth():int { return _visibleBounds.width; }
		
		public function get visibleHeight():int { return _visibleBounds.height; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _bounds:Rectangle = new Rectangle();
		protected var _hasVisibleParts:Boolean;
		protected var _valid:Boolean;
		protected var _color:uint = 0xFF;
		protected var _alpha:Number = 1;
		protected var _port:Port;
		protected var _newBounds:Rectangle = new Rectangle();
		protected var _visibleBounds:Rectangle = new Rectangle();
		protected var _changeEvent:Event = new Event(CHANGE_PROPERTY);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Renderable()
		{
			super();
			//addEventListener(Event.ADDED_TO_STAGE, 
								//addedToStageHandler, false, 0, true);
			super.addEventListener(Event.ADDED, addedToStageHandler, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function drawIn(port:Rectangle):void
		{
			//trace("drawIn", stage);
			var cPort:Rectangle = port.clone();
			var dRect:Rectangle = 
				new Rectangle(port.x, port.y, _bounds.width, _bounds.height);
			var iRect:Rectangle;
			cPort.x = 0;
			cPort.y = 0;
			iRect = cPort.intersection(_bounds);
			if (!iRect.isEmpty())
			{
				dRect.width = iRect.width;
				dRect.height = iRect.height;
				dRect.x += iRect.x;
				dRect.y += iRect.y;
				this.drawInBounds(dRect);
			}
			else if (cPort.containsRect(_bounds))
			{
				dRect.x += _bounds.x;
				dRect.y += _bounds.y;
				this.drawInBounds(dRect);
			}
			else this.clear();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function addedToStageHandler(event:Event):void 
		{
			if (parent is Port)
			{
				_port = parent as Port;
				this.drawIn((parent as Port).bounds);
				super.addEventListener(Event.REMOVED, removedHandler);
				super.addEventListener(Event.RENDER, renderHandler);
				if (stage && !_valid) 
					super.addEventListener(Event.ENTER_FRAME, renderHandler);
			}
		}
		
		protected function renderHandler(event:Event):void 
		{
			if (!(parent is Port) || !stage) return; //_bounds.equals(_newBounds) || 
			_bounds = _newBounds.clone();
			this.drawIn((parent as Port).bounds);
			_valid = true;
		}
		
		protected function removedHandler(event:Event):void 
		{
			if (parent is Port) this.clear();
			super.removeEventListener(Event.RENDER, renderHandler);
			this.valid = false;
		}
		
		protected function clear():void
		{
			super.graphics.clear();
			_visibleBounds.x = 0;
			_visibleBounds.y = 0;
			_visibleBounds.width = 0;
			_visibleBounds.height = 0;
			_hasVisibleParts = false;
		}
		
		protected function drawInBounds(rect:Rectangle):void
		{
			_hasVisibleParts = true;
			_visibleBounds.x = rect.x;
			_visibleBounds.y = rect.y;
			_visibleBounds.width = rect.width;
			_visibleBounds.height = rect.height;
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(_color, _alpha);
			g.drawRect(rect.x, rect.y, rect.width, rect.height);
			g.endFill();
		}
	}
	
}