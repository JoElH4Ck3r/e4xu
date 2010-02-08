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
		public function get target():Object { return this._target; }
		
		public function set target(value:Object):void 
		{
			if (this._target === value || !(value is DisplayObject)) return;
			this._target = value as DisplayObject;
			this._savedBounds = this._target.getBounds(this._target);
			this.draw();
			super.dispatchEvent(new Event("targetChange"));
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
			super.addEventListener(Event.ADDED_TO_STAGE, this.adtsHandler);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.removedHandler);
			this._target = target;
			if (this._target) this._savedBounds = this._target.getBounds(this._target);
			if (target) this.draw();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function draw():void
		{
			if (!this._target)
			{
				if (this._document is DisplayObjectContainer)
					(this._document as DisplayObjectContainer).removeChild(this);
				return;
			}
			var i:int;
			var j:int = 9;
			if (this._document is DisplayObjectContainer)
				(this._document as DisplayObjectContainer).addChild(this);
			//if (!_edges) _edges = super.addChild(new Shape()) as Shape;
			if (!this._receiver) this._receiver = new Sprite();
			if (!this._receiverHandles)
			{
				this._receiverHandles = 
				new <Sprite>[this.drawHandle(0, this._receiver), 
							this.drawHandle(1, this._receiver),
							this.drawHandle(2, this._receiver), 
							this.drawHandle(3, this._receiver), 
							this.drawHandle(4, this._receiver), 
							this.drawHandle(5, this._receiver),
							this.drawHandle(6, this._receiver), 
							this.drawHandle(7, this._receiver), 
							this.drawHandle(8, this._receiver)];
			}
			this._receiver.transform.matrix = this._target.transform.matrix.clone();
			//_edges.graphics.clear();
			//var bounds:Rectangle = _target.getBounds(_target);
			//_edges.graphics.lineStyle(1, 0, 1, true);
			//_edges.graphics.drawRect(0, 0, bounds.width, bounds.height);
			
			if (!this._handles) this._handles = 
				new <Sprite>[this.drawHandle(0, this), this.drawHandle(1, this), 
							this.drawHandle(2, this), this.drawHandle(3, this), 
							this.drawHandle(4, this), this.drawHandle(5, this),
							this.drawHandle(6, this), this.drawHandle(7, this), 
							this.drawHandle(8, this)];
			else
			{
				while (i < j)
				{
					this.positionHandles(i);
					i++;
				}
			}
		}
		
		protected function positionHandles(index:int):void
		{
			var p:Point = this.globalToLocal(
						this._receiverHandles[index].localToGlobal(new Point()));
			this._handles[index].x = p.x;
			this._handles[index].y = p.y;
		}
		
		protected function drawHandle(index:int, where:Sprite):Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill(0);
			g.drawRect( -5, -5, 10, 10);
			g.endFill();
			s.addEventListener(MouseEvent.MOUSE_DOWN, this.handle_downHandler);
			var p:Point;
			if (where === this)
			{
				p = this.globalToLocal(
					this._receiverHandles[index].localToGlobal(new Point()));
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
						s.x = this._savedBounds.width * 0.5;
						break;
					case 2:
						s.x = this._savedBounds.width;
						break;
					case 3:
						s.y = this._savedBounds.height * 0.5;
						break;
					case 4:
						s.x = this._savedBounds.width * 0.5;
						s.y = this._savedBounds.height * 0.5;
						break;
					case 5:
						s.x = this._savedBounds.width;
						s.y = this._savedBounds.height * 0.5;
						break;
					case 6:
						s.y = this._savedBounds.height;
						break;
					case 7:
						s.x = this._savedBounds.width * 0.5;
						s.y = this._savedBounds.height;
						break;
					case 8:
						s.x = this._savedBounds.width;
						s.y = this._savedBounds.height;
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
			this._activeHandle = event.target as Sprite;
			this._startX = this._activeHandle.x;
			this._startY = this._activeHandle.y;
			super.addEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
			this._savedMatrix = this._target.transform.matrix.clone();
			this._registrationPoint = 
				new Point(this._activeHandle.x, this._activeHandle.y);
		}
		
		private function enterFrameHandler(event:Event):void 
		{
			this._change = new Point(this._startX, this._startY).subtract(
						new Point(super.mouseX, super.mouseY));
			this._angle = Math.atan2(this._change.x, this._change.y);
			this._activeMatrix = this._savedMatrix.clone();
			switch (this._activeHandle)
			{
				case this._handles[0]: // a, d
					this._activeMatrix.tx -= this._change.x;
					this._activeMatrix.ty -= this._change.y;
					this._activeMatrix.a += this._change.x / this._savedBounds.width;
					this._activeMatrix.d += this._change.y / this._savedBounds.height;
					break;
				case this._handles[1]:
					this._activeMatrix.ty -= this._change.y;
					this._activeMatrix.d += this._change.y / this._savedBounds.height;
					break;
				case this._handles[2]: // a, d
					this._activeMatrix.ty -= this._change.y;
					this._activeMatrix.d += this._change.y / this._savedBounds.height;
					this._activeMatrix.a -= this._change.x / this._savedBounds.width;
					break;
				case this._handles[3]:
					this._activeMatrix.tx -= this._change.x;
					this._activeMatrix.a += this._change.x / this._savedBounds.width;
					break;
				case this._handles[4]: // rotate
					var point:Point = this._registrationPoint.clone();
					//trace("point", point);
					//point = _activeMatrix.transformPoint(point);
					this._activeMatrix.tx -= point.x;
					this._activeMatrix.ty -= point.y;
					this._activeMatrix.rotate(this._angle * -1);
					this._activeMatrix.tx += point.x;
					this._activeMatrix.ty += point.y;
					break;
				case this._handles[5]:
					this._activeMatrix.a -= this._change.x / this._savedBounds.width;
					break;
				case this._handles[6]: // a, d
					this._activeMatrix.d -= this._change.y / this._savedBounds.height;
					this._activeMatrix.tx -= this._change.x;
					this._activeMatrix.a += this._change.x / this._savedBounds.width;
					break;
				case this._handles[7]:
					this._activeMatrix.d -= this._change.y / this._savedBounds.height;
					break;
				case this._handles[8]: // a, d
					this._activeMatrix.a -= this._change.x / this._savedBounds.width;
					this._activeMatrix.d -= this._change.y / this._savedBounds.height;
					break;
			}
			this._target.transform.matrix = this._activeMatrix;
			this.draw();
		}
		
		private function removedHandler(event:Event):void 
		{
			super.stage.removeEventListener(
				MouseEvent.MOUSE_UP, this.mouseUpHandler);
			super.stage.removeEventListener(
				MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			super.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		}
		
		private function adtsHandler(event:Event):void 
		{
			super.stage.addEventListener(
				MouseEvent.MOUSE_UP, this.mouseUpHandler, false, 0, true);
		}
		
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			
		}
		
		private function mouseUpHandler(event:MouseEvent):void 
		{
			this._activeHandle = null;
			super.removeEventListener(Event.ENTER_FRAME, this.enterFrameHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			this._id = id;
		}
		
		public function dispose():void
		{
			
		}
		
		/* INTERFACE org.wvxvws.tools.IEditor */
		
		public function show():void { this.draw(); }
		
		public function hide():void
		{
			if (super.parent) super.parent.removeChild(this);
		}
		
		public function update():void { this.draw(); }
	}
}