package org.wvxvws.tools 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	import flash.display.Sprite;
	
	/**
	 * TrimStratcher class.
	 * @author wvxvw
	 */
	public class TrimStratcher extends Sprite implements IMXMLObject, IEditor
	{
		
		public function get leftOut():InteractiveObject { return _leftOut; }
		
		public function set leftOut(value:InteractiveObject):void 
		{
			if (_leftOut === value) return;
			if (_leftOut && super.contains(_leftOut))
				super.removeChild(_leftOut);
			_leftOut = value;
			render();
		}
		
		public function get leftIn():InteractiveObject { return _leftIn; }
		
		public function set leftIn(value:InteractiveObject):void 
		{
			if (_leftIn === value) return;
			if (_leftIn && super.contains(_leftIn))
				super.removeChild(_leftIn);
			_leftIn = value;
			render();
		}
		
		public function get rightIn():InteractiveObject { return _rightIn; }
		
		public function set rightIn(value:InteractiveObject):void 
		{
			if (_rightIn === value) return;
			if (_rightIn && super.contains(_rightIn))
				super.removeChild(_rightIn);
			_rightIn = value;
			render();
		}
		
		public function get rightOut():InteractiveObject { return _rightOut; }
		
		public function set rightOut(value:InteractiveObject):void 
		{
			if (_rightOut === value) return;
			if (_rightOut && super.contains(_rightOut))
				super.removeChild(_rightOut);
			_rightOut = value;
			render();
		}
		
		public function get target():Object { return _target; }
		
		public function set target(value:Object):void 
		{
			_target = value as ITrimable;
			if (_target is DisplayObject && (_target as DisplayObject).stage)
			{
				if (super.parent && super.parent !== super.root)
				{
					super.parent.removeChild(this);
					(super.root as DisplayObjectContainer).addChildAt(
						this, (super.root as DisplayObjectContainer).numChildren);
				}
				else if (_target is DisplayObjectContainer)
				{
					((_target as DisplayObject).root as DisplayObjectContainer).addChildAt(
						this, ((_target as DisplayObjectContainer).root as 
							DisplayObjectContainer).numChildren);
				}
			}
			if (_target) render();
		}
		
		protected var _document:Object;
		protected var _id:String;
		
		protected var _leftOut:InteractiveObject;
		protected var _leftIn:InteractiveObject;
		protected var _rightIn:InteractiveObject;
		protected var _rightOut:InteractiveObject;
		
		protected var _target:ITrimable;
		
		protected var _currentTarget:InteractiveObject;
		protected var _clickLocation:int;
		protected var _globalPoints:Vector.<Point> = 
			new <Point>[new Point(), new Point(), new Point(), new Point()];
		
		public function TrimStratcher()
		{
			super();
			super.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			_leftOut = drawHandle(false);
			_leftIn = drawHandle(true);
			_rightIn = drawHandle(false);
			_rightOut = drawHandle(true);
		}
		
		protected function removedHandler(event:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stage_mouseUpHandler);
		}
		
		public function render():void
		{
			if (!_target) return;
			if (!super.root) return;
			if (_leftOut && !super.contains(_leftOut))
			{
				_leftOut.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				super.addChild(_leftOut);
			}
			if (_leftIn && !super.contains(_leftIn))
			{
				_leftIn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				super.addChild(_leftIn);
			}
			if (_rightIn && !super.contains(_rightIn))
			{
				_rightIn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				super.addChild(_rightIn);
			}
			if (_rightOut && !super.contains(_rightOut))
			{
				_rightOut.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				super.addChild(_rightOut);
			}
			if (super.parent && super.parent !== super.root)
			{
				super.parent.removeChild(this);
				((_target as DisplayObject).root as DisplayObjectContainer).addChildAt(
					this, ((_target as DisplayObject).root as 
						DisplayObjectContainer).numChildren);
			}
			update();
		}
		
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			_currentTarget = event.target as InteractiveObject;
			_clickLocation = _currentTarget.x;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 
									stage_mouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, 
									stage_mouseUpHandler, false, 0, true);
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler);
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			var shift:int = super.mouseX - _clickLocation;
			switch (_currentTarget)
			{
				case _leftOut:
					_leftOut.x = Math.min(_leftIn.x, super.mouseX);
					break;
				case _leftIn:
					_leftIn.x = Math.max(Math.min(_rightIn.x, super.mouseX), _leftOut.x);
					break;
				case _rightIn:
					_rightIn.x = Math.max(Math.min(_rightOut.x, super.mouseX), _leftIn.x);
					break;
				case _rightOut:
					_rightOut.x = Math.max(_rightIn.x, super.mouseX);
					break;
			}
			var p:Point;
			_globalPoints[0] = _target.globalToLocal(new Point(_leftOut.x, 0));
			_globalPoints[1] = _target.globalToLocal(new Point(_leftIn.x, 0));
			_globalPoints[2] = _target.globalToLocal(new Point(_rightIn.x, 0));
			_globalPoints[3] = _target.globalToLocal(new Point(_rightOut.x, 0));
			_target.x = _globalPoints[0].x;
			_target.trimLeft = _globalPoints[1].x - _globalPoints[0].x;
			_target.trimRight = _globalPoints[3].x - _globalPoints[2].x;
			_target.width = _globalPoints[3].x - _globalPoints[0].x;
			super.dispatchEvent(new ToolEvent(ToolEvent.RESIZED, false, false, _target));
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		private function drawHandle(dir:Boolean):Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(0);
			g.lineTo(0, 16);
			if (dir) g.lineTo(8, 16);
			else g.lineTo( -8, 16);
			g.lineTo(0, 0);
			g.endFill();
			//s.blendMode = BlendMode.INVERT;
			s.buttonMode = true;
			return s;
		}
		
		/* INTERFACE org.wvxvws.tools.IEditor */
		
		public function show():void { render(); }
		
		public function hide():void { if (stage) parent.removeChild(this); }
		
		public function update():void
		{
			if (!_target) return;
			var bounds:Rectangle = _target.getBounds(super.root);
			_leftOut.x = bounds.left;
			_leftIn.x = bounds.left + _target.trimLeft;
			_rightIn.x = bounds.right - _target.trimRight;
			_rightOut.x = bounds.right;
			super.y = bounds.y;
		}
	}

}