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
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get leftOut():InteractiveObject { return this._leftOut; }
		
		public function set leftOut(value:InteractiveObject):void 
		{
			if (this._leftOut === value) return;
			if (this._leftOut && super.contains(this._leftOut))
				super.removeChild(this._leftOut);
			this._leftOut = value;
			this.render();
		}
		
		public function get leftIn():InteractiveObject { return this._leftIn; }
		
		public function set leftIn(value:InteractiveObject):void 
		{
			if (this._leftIn === value) return;
			if (this._leftIn && super.contains(this._leftIn))
				super.removeChild(this._leftIn);
			this._leftIn = value;
			this.render();
		}
		
		public function get rightIn():InteractiveObject { return this._rightIn; }
		
		public function set rightIn(value:InteractiveObject):void 
		{
			if (this._rightIn === value) return;
			if (this._rightIn && super.contains(this._rightIn))
				super.removeChild(this._rightIn);
			this._rightIn = value;
			this.render();
		}
		
		public function get rightOut():InteractiveObject { return this._rightOut; }
		
		public function set rightOut(value:InteractiveObject):void 
		{
			if (this._rightOut === value) return;
			if (this._rightOut && super.contains(this._rightOut))
				super.removeChild(this._rightOut);
			this._rightOut = value;
			this.render();
		}
		
		public function get target():Object { return this._target; }
		
		public function set target(value:Object):void 
		{
			this._target = value as ITrimable;
			if (this._target is DisplayObject && 
				(this._target as DisplayObject).stage)
			{
				if (super.parent && super.parent !== super.root)
				{
					super.parent.removeChild(this);
					(super.root as DisplayObjectContainer).addChildAt(
						this, (super.root as DisplayObjectContainer).numChildren);
				}
				else if (_target is DisplayObjectContainer)
				{
					((this._target as DisplayObject).root as 
						DisplayObjectContainer).addChildAt(
						this, ((this._target as DisplayObjectContainer).root as 
						DisplayObjectContainer).numChildren);
				}
			}
			if (this._target) this.render();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
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
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function TrimStratcher()
		{
			super();
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.removedHandler);
			this._leftOut = this.drawHandle(false);
			this._leftIn = this.drawHandle(true);
			this._rightIn = this.drawHandle(false);
			this._rightOut = this.drawHandle(true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function removedHandler(event:Event):void 
		{
			super.stage.removeEventListener(
				MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
			super.stage.removeEventListener(
				MouseEvent.MOUSE_UP, this.stage_mouseUpHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			this._currentTarget = event.target as InteractiveObject;
			this._clickLocation = this._currentTarget.x;
			super.stage.addEventListener(
				MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler, false, 0, true);
			super.stage.addEventListener(
				MouseEvent.MOUSE_UP, this.stage_mouseUpHandler, false, 0, true);
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			super.stage.removeEventListener(
				MouseEvent.MOUSE_MOVE, this.stage_mouseMoveHandler);
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			var shift:int = super.mouseX - this._clickLocation;
			switch (this._currentTarget)
			{
				case this._leftOut:
					this._leftOut.x = Math.min(this._leftIn.x, super.mouseX);
					break;
				case this._leftIn:
					this._leftIn.x = 
						Math.max(Math.min(this._rightIn.x, super.mouseX), 
						this._leftOut.x);
					break;
				case this._rightIn:
					this._rightIn.x = 
						Math.max(Math.min(_rightOut.x, super.mouseX), _leftIn.x);
					break;
				case this._rightOut:
					this._rightOut.x = Math.max(this._rightIn.x, super.mouseX);
					break;
			}
			var p:Point;
			this._globalPoints[0] = 
				this._target.globalToLocal(new Point(this._leftOut.x, 0));
			this._globalPoints[1] = 
				this._target.globalToLocal(new Point(this._leftIn.x, 0));
			this._globalPoints[2] = 
				this._target.globalToLocal(new Point(this._rightIn.x, 0));
			this._globalPoints[3] = 
				this._target.globalToLocal(new Point(this._rightOut.x, 0));
			this._target.x = this._globalPoints[0].x;
			this._target.trimLeft = 
				this._globalPoints[1].x - this._globalPoints[0].x;
			this._target.trimRight = 
				this._globalPoints[3].x - this._globalPoints[2].x;
			this._target.width = this._globalPoints[3].x - this._globalPoints[0].x;
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZED, false, false, this._target));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function render():void
		{
			if (!this._target) return;
			if (!super.root) return;
			if (this._leftOut && !super.contains(this._leftOut))
			{
				this._leftOut.addEventListener(
					MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				super.addChild(this._leftOut);
			}
			if (this._leftIn && !super.contains(this._leftIn))
			{
				this._leftIn.addEventListener(
					MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				super.addChild(this._leftIn);
			}
			if (this._rightIn && !super.contains(this._rightIn))
			{
				this._rightIn.addEventListener(
					MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				super.addChild(this._rightIn);
			}
			if (this._rightOut && !super.contains(this._rightOut))
			{
				this._rightOut.addEventListener(
					MouseEvent.MOUSE_DOWN, this.mouseDownHandler);
				super.addChild(this._rightOut);
			}
			if (super.parent && super.parent !== super.root)
			{
				super.parent.removeChild(this);
				((this._target as DisplayObject).root as 
					DisplayObjectContainer).addChildAt(
					this, ((this._target as DisplayObject).root as 
					DisplayObjectContainer).numChildren);
			}
			this.update();
		}
		
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
		
		public function show():void { this.render(); }
		
		public function hide():void { if (super.stage) super.parent.removeChild(this); }
		
		public function update():void
		{
			if (!this._target) return;
			var bounds:Rectangle = this._target.getBounds(super.root);
			this._leftOut.x = bounds.left;
			this._leftIn.x = bounds.left + this._target.trimLeft;
			this._rightIn.x = bounds.right - this._target.trimRight;
			this._rightOut.x = bounds.right;
			super.y = bounds.y;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
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
	}
}