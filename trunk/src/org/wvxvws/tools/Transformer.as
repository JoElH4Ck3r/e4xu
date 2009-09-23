package org.wvxvws.tools 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class Transformer extends Sprite implements IMXMLObject
	{
		protected var _document:Object;
		protected var _id:String;
		protected var _activeHandle:Sprite;
		protected var _handles:Vector.<Sprite>;
		protected var _directions:Vector.<String> = new <String>[
				StageAlign.TOP_LEFT, 	StageAlign.TOP, 	StageAlign.TOP_RIGHT,
				StageAlign.LEFT, 		"", 				StageAlign.RIGHT,
				StageAlign.BOTTOM_LEFT, StageAlign.BOTTOM, 	StageAlign.BOTTOM_RIGHT];
		protected var _direction:String;
		protected var _target:DisplayObject;
		protected var _edges:Shape;
		protected var _matrixTarget:Matrix;
		protected var _receiver:Sprite;
		protected var _receiverHandles:Vector.<Sprite>;
		
		public function Transformer(target:DisplayObject = null) 
		{
			super();
			super.addEventListener(Event.ADDED_TO_STAGE, adtsHandler);
			super.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			_target = target;
			if (target) draw();
		}
		
		protected function draw():void
		{
			if (!_target)
			{
				if (_document is DisplayObjectContainer)
					(_document as DisplayObjectContainer).removeChild(this);
				return;
			}
			if (_document is DisplayObjectContainer)
				(_document as DisplayObjectContainer).addChild(this);
			if (!_edges) _edges = super.addChild(new Shape()) as Shape;
			if (!_receiver)
				_receiver = new Sprite();
			if (!_receiverHandles)
			{
				_receiverHandles = 
				new <Sprite>[drawHandle(0, _receiver), drawHandle(1, _receiver),
							drawHandle(2, _receiver), drawHandle(3, _receiver), 
							drawHandle(4, _receiver), drawHandle(5, _receiver),
							drawHandle(6, _receiver), drawHandle(7, _receiver), 
							drawHandle(8, _receiver)];
			}
			_receiver.transform.matrix = _target.transform.matrix.clone();
			_edges.graphics.clear();
			var bounds:Rectangle = _target.getBounds(_target);
			_edges.graphics.lineStyle(1, 0, 1, true);
			_edges.graphics.drawRect(0, 0, bounds.width, bounds.height);
			
			if (!_handles) _handles = 
				new <Sprite>[drawHandle(0, this), drawHandle(1, this),drawHandle(2, this),
							drawHandle(3, this), drawHandle(4, this), drawHandle(5, this),
							drawHandle(6, this), drawHandle(7, this), drawHandle(8, this)];
		}
		
		protected function drawHandle(index:int, where:Sprite):Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(0);
			g.drawRect( -5, -5, 10, 10);
			g.endFill();
			s.addEventListener(MouseEvent.MOUSE_DOWN, handle_downHandler);
			var i:int;
			var j:int = 9;
			var bounds:Rectangle;
			var p:Point;
			if (where === this)
			{
				p = this.globalToLocal(_receiverHandles[index].localToGlobal(new Point()));
				s.x = p.x;
				s.y = p.y;
			}
			else
			{
				bounds = _target.getBounds(_target)
				switch (index)
				{
					case 0:
						break;
					case 1:
						s.x = bounds.width * 0.5;
						break;
					case 2:
						s.x = bounds.width;
						break;
					case 3:
						s.y = bounds.height * 0.5;
						break;
					case 4:
						s.x = bounds.width * 0.5;
						s.y = bounds.height * 0.5;
						break;
					case 5:
						s.x = bounds.width;
						s.y = bounds.height * 0.5;
						break;
					case 6:
						s.y = bounds.height;
						break;
					case 7:
						s.x = bounds.width * 0.5;
						s.y = bounds.height;
						break;
					case 8:
						s.x = bounds.width;
						s.y = bounds.height;
						break;
					default:
						throw new RangeError("\"index\" is out of range.");
						return null;
				}
			}
			
			where.addChild(s);
			return s;
		}
		
		private function handle_downHandler(event:MouseEvent):void 
		{
			_activeHandle = event.target as Sprite;
			super.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			
		}
		
		private function removedHandler(event:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function adtsHandler(event:Event):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			
		}
		
		private function mouseUpHandler(event:MouseEvent):void 
		{
			_activeHandle = null;
			super.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		//------------------------------------
		//  Public property target
		//------------------------------------
		
		[Bindable("targetChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>targetChange</code> event.
		*/
		public function get target():DisplayObject { return _target; }
		
		public function set target(value:DisplayObject):void 
		{
			if (_target === value) return;
			_target = value;
			draw();
			dispatchEvent(new Event("targetChange"));
		}
		
	}
	
}