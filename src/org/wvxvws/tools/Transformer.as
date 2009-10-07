////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

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
	 * Transformer class.
	 * @author wvxvw
	 */
	public class Transformer extends Sprite implements IMXMLObject, IEditor
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property target
		//------------------------------------
		
		[Bindable("targetChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>targetChange</code> event.
		*/
		public function get target():Object { return _target; }
		
		public function set target(value:Object):void 
		{
			if (_target === value || !(value is DisplayObject)) return;
			_target = value;
			_savedBounds = _target.getBounds(_target);
			draw();
			dispatchEvent(new Event("targetChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
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
		//protected var _edges:Shape;
		protected var _matrixTarget:Matrix;
		protected var _receiver:Sprite;
		protected var _receiverHandles:Vector.<Sprite>;
		protected var _savedMatrix:Matrix;
		protected var _activeMatrix:Matrix;
		protected var _savedBounds:Rectangle;
		protected var _startX:Number;
		protected var _startY:Number;
		protected var _change:Point;
		protected var _angle:Number;
		protected var _registrationPoint:Point;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Transformer(target:DisplayObject = null) 
		{
			super();
			super.addEventListener(Event.ADDED_TO_STAGE, adtsHandler);
			super.addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
			_target = target;
			if (_target) _savedBounds = _target.getBounds(_target);
			if (target) draw();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function draw():void
		{
			if (!_target)
			{
				if (_document is DisplayObjectContainer)
					(_document as DisplayObjectContainer).removeChild(this);
				return;
			}
			var i:int;
			var j:int = 9;
			if (_document is DisplayObjectContainer)
				(_document as DisplayObjectContainer).addChild(this);
			//if (!_edges) _edges = super.addChild(new Shape()) as Shape;
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
			//_edges.graphics.clear();
			//var bounds:Rectangle = _target.getBounds(_target);
			//_edges.graphics.lineStyle(1, 0, 1, true);
			//_edges.graphics.drawRect(0, 0, bounds.width, bounds.height);
			
			if (!_handles) _handles = 
				new <Sprite>[drawHandle(0, this), drawHandle(1, this),drawHandle(2, this),
							drawHandle(3, this), drawHandle(4, this), drawHandle(5, this),
							drawHandle(6, this), drawHandle(7, this), drawHandle(8, this)];
			else
			{
				while (i < j)
				{
					positionHandles(i);
					i++;
				}
			}
		}
		
		protected function positionHandles(index:int):void
		{
			var p:Point = this.globalToLocal(
						_receiverHandles[index].localToGlobal(new Point()));
			_handles[index].x = p.x;
			_handles[index].y = p.y;
		}
		
		protected function drawHandle(index:int, where:Sprite):Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(0);
			g.drawRect( -5, -5, 10, 10);
			g.endFill();
			s.addEventListener(MouseEvent.MOUSE_DOWN, handle_downHandler);
			var p:Point;
			if (where === this)
			{
				p = this.globalToLocal(_receiverHandles[index].localToGlobal(new Point()));
				s.x = p.x;
				s.y = p.y;
			}
			else
			{
				switch (index)
				{
					case 0:
						break;
					case 1:
						s.x = _savedBounds.width * 0.5;
						break;
					case 2:
						s.x = _savedBounds.width;
						break;
					case 3:
						s.y = _savedBounds.height * 0.5;
						break;
					case 4:
						s.x = _savedBounds.width * 0.5;
						s.y = _savedBounds.height * 0.5;
						break;
					case 5:
						s.x = _savedBounds.width;
						s.y = _savedBounds.height * 0.5;
						break;
					case 6:
						s.y = _savedBounds.height;
						break;
					case 7:
						s.x = _savedBounds.width * 0.5;
						s.y = _savedBounds.height;
						break;
					case 8:
						s.x = _savedBounds.width;
						s.y = _savedBounds.height;
						break;
					default:
						throw new RangeError("\"index\" is out of range.");
						return null;
				}
			}
			where.addChild(s);
			return s;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function handle_downHandler(event:MouseEvent):void 
		{
			_activeHandle = event.target as Sprite;
			_startX = _activeHandle.x;
			_startY = _activeHandle.y;
			super.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_savedMatrix = _target.transform.matrix.clone();
			_registrationPoint = new Point(_activeHandle.x, _activeHandle.y);
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			_change = new Point(_startX, _startY).subtract(
						new Point(super.mouseX, super.mouseY));
			_angle = Math.atan2(_change.x, _change.y);
			_activeMatrix = _savedMatrix.clone();
			switch (_activeHandle)
			{
				case _handles[0]: // a, d
					_activeMatrix.tx -= _change.x;
					_activeMatrix.ty -= _change.y;
					_activeMatrix.a += _change.x / _savedBounds.width;
					_activeMatrix.d += _change.y / _savedBounds.height;
					break;
				case _handles[1]:
					_activeMatrix.ty -= _change.y;
					_activeMatrix.d += _change.y / _savedBounds.height;
					break;
				case _handles[2]: // a, d
					_activeMatrix.ty -= _change.y;
					_activeMatrix.d += _change.y / _savedBounds.height;
					_activeMatrix.a -= _change.x / _savedBounds.width;
					break;
				case _handles[3]:
					_activeMatrix.tx -= _change.x;
					_activeMatrix.a += _change.x / _savedBounds.width;
					break;
				case _handles[4]: // rotate
					var point:Point = _registrationPoint.clone();
					trace("point", point);
					//point = _activeMatrix.transformPoint(point);
					_activeMatrix.tx -= point.x;
					_activeMatrix.ty -= point.y;
					_activeMatrix.rotate(_angle * -1);
					_activeMatrix.tx += point.x;
					_activeMatrix.ty += point.y;
					break;
				case _handles[5]:
					_activeMatrix.a -= _change.x / _savedBounds.width;
					break;
				case _handles[6]: // a, d
					_activeMatrix.d -= _change.y / _savedBounds.height;
					_activeMatrix.tx -= _change.x;
					_activeMatrix.a += _change.x / _savedBounds.width;
					break;
				case _handles[7]:
					_activeMatrix.d -= _change.y / _savedBounds.height;
					break;
				case _handles[8]: // a, d
					_activeMatrix.a -= _change.x / _savedBounds.width;
					_activeMatrix.d -= _change.y / _savedBounds.height;
					break;
			}
			_target.transform.matrix = _activeMatrix;
			draw();
		}
		
		private function removedHandler(event:Event):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			super.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
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
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		/* INTERFACE org.wvxvws.tools.IEditor */
		
		public function show():void { draw(); }
		
		public function hide():void
		{
			if (super.parent) super.parent.removeChild(this);
		}
		
		public function update():void { draw(); }
		
	}
	
}