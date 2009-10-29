package org.wvxvws.rendering
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import org.wvxvws.tools.ITrimable;
	
	/**
	 * Slide class.
	 * @author wvxvw
	 */
	public class Slide extends Renderable implements ITrimable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function get width():Number { return super.width; }
		
		public override function set width(value:Number):void 
		{
			if (value === super.width) return;
			if (value < _minWidth) value = _minWidth;
			if (value > _maxWidth) value = _maxWidth;
			super.width = value;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function get clickLocation():Point { return _clickLocation; }
		
		public function get trimLeft():uint { return _trimPoint.x; }
		
		public function set trimLeft(value:uint):void 
		{
			if (value === _trimPoint.x) return;
			if (value + _trimPoint.y > _newBounds.width)
			{
				value = _newBounds.width - _trimPoint.y;
			}
			_trimPoint.x = value;
			// TODO: why?
			//if (value === _trimPoint.x) return;
			super.valid = false;
		}
		
		public function get trimRight():uint { return _trimPoint.y; }
		
		public function set trimRight(value:uint):void 
		{
			if (value === _trimPoint.y) return;
			if (value + _trimPoint.x > _newBounds.width)
			{
				value = super._newBounds.width - _trimPoint.x;
			}
			_trimPoint.y = value;
			if (value === _trimPoint.y) return;
			super.valid = false;
		}
		
		public function get node():XML { return _node; }
		
		public function set node(value:XML):void
		{
			if (_node === value) return;
			_node = value;
			super.valid = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _maxWidth:int;
		protected var _minWidth:int;
		protected var _selected:Boolean;
		protected var _clickLocation:Point;
		protected var _trimPoint:Point = new Point();
		protected var _trimBounds:Rectangle = new Rectangle();
		protected var _trimmed:Sprite = new Sprite();
		protected var _node:XML;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Slide(minWidth:int = 10, maxWidth:int = 2800)
		{
			_maxWidth = maxWidth;
			_minWidth = minWidth;
			super();
			super.addEventListener(MouseEvent.MOUSE_DOWN, 
							mouseDownHandler, false, int.MAX_VALUE, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public override function globalToLocal(point:Point):Point
		{
			if (_port)
			{
				point.x -= _port.bounds.x;
				point.y -= _port.bounds.y;
			}
			return super.globalToLocal(point);
		}
		
		public override function getBounds(where:DisplayObject):Rectangle
		{
			var points:Vector.<Point> = new <Point>[
				new Point(_newBounds.left, _newBounds.top),
				new Point(_newBounds.right, _newBounds.bottom)];
			if (_port)
			{
				points[0].x += _port.bounds.x;
				points[0].y += _port.bounds.y;
				points[1].x += _port.bounds.x;
				points[1].y += _port.bounds.y;
			}
			points[0] = super.localToGlobal(points[0]);
			points[1] = super.localToGlobal(points[1]);
			
			points[0] = where.globalToLocal(points[0]);
			points[1] = where.globalToLocal(points[1]);
			
			var r:Rectangle = new Rectangle();
			r.top = points[0].y;
			r.left = points[0].x;
			r.right = points[1].x;
			r.bottom = points[1].y;
			return r;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function addedToStageHandler(event:Event):void 
		{
			super.addedToStageHandler(event);
			if (stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, 
									stage_mouseUpHandler, false, 0, true);
			}
		}
		
		protected override function renderHandler(event:Event):void
		{
			if (!stage)
			{
				super.valid = true;
				return;
			}
			super.renderHandler(event);
			_trimBounds.height = _bounds.height;
			_trimBounds.x = _port.bounds.x + _newBounds.x + _trimPoint.x;
			_trimBounds.y = _newBounds.y + _port.bounds.y;
			_trimBounds.width = _newBounds.width - (_trimPoint.y + _trimPoint.x);
			if (_hasVisibleParts) this.drawTrimmed();
		}
		
		protected override function clear():void
		{
			super.clear();
			_trimmed.graphics.clear();
		}
		
		protected function drawTrimmed():void
		{
			var bounds:Rectangle = _port.bounds.intersection(_trimBounds);
			if (!contains(_trimmed))
			{
				_trimmed.mouseChildren = false;
				_trimmed.mouseEnabled = false;
				super.addChild(_trimmed);
			}
			var g:Graphics = _trimmed.graphics;
			g.clear();
			g.beginFill(0xFF00FF, .5);
			g.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			g.endFill();
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			_selected = false;
			super.alpha = 1;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			if (_port)
			{
				_clickLocation = new Point(super.mouseX - (super.x + _port.x), 
											super.mouseY - (super.y + _port.y));
			}
			else
			{
				_clickLocation = 
					new Point(super.mouseX - x, super.mouseY - super.y);
			}
			_selected = true;
			super.alpha = .7;
		}
		
	}
	
}