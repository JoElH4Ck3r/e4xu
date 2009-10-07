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
	//{ imports
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	//}
	
	/**
	 * Selector class.
	 * @author wvxvw
	 */
	public class Selector extends Sprite implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get target():DisplayObjectContainer { return _target; }
		
		public function set target(value:DisplayObjectContainer):void 
		{
			if (_target === value) return;
			_target = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _target:DisplayObjectContainer;
		protected var _downLocation:Point;
		protected var _selection:Rectangle = new Rectangle();
		protected var _lineMatrixH:Matrix;
		protected var _lineMatrixV:Matrix;
		protected var _visibleBounds:Rectangle = new Rectangle();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Selector() { super(); }
		
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
			if (_document is DisplayObjectContainer)
				_target = _document as DisplayObjectContainer;
		}
		
		public function start(point:Point):void
		{
			if (!_target.stage) return;
			var s:Stage = _target.stage;
			var r:DisplayObjectContainer = _target.root as DisplayObjectContainer;
			if (!r) return;
			_downLocation = r.localToGlobal(point);
			if (parent !== r)
			{
				if (parent) parent.removeChild(this);
				r.addChild(this);
			}
			super.graphics.clear();
			var targBounds:Rectangle = _target.getBounds(this);
			var topLeft:Point = new Point(targBounds.left, targBounds.top);
			var bottomRight:Point = new Point(targBounds.right, targBounds.bottom);
			topLeft = _target.localToGlobal(topLeft);
			bottomRight = _target.localToGlobal(bottomRight);
			_visibleBounds.left = topLeft.x;
			_visibleBounds.top = topLeft.y;
			_visibleBounds.right = bottomRight.x;
			_visibleBounds.bottom = bottomRight.y;
			s.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, 0, true);
			s.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, 0, true);
			s.addEventListener(Event.MOUSE_LEAVE, leaveHandler, false, 0, true);
			s.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 0, true);
			s.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, false, 0, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function keyUpHandler(event:KeyboardEvent):void 
		{
			
		}
		
		private function keyDownHandler(event:KeyboardEvent):void 
		{
			
		}
		
		private function leaveHandler(event:Event):void 
		{
			
		}
		
		private function upHandler(event:MouseEvent):void 
		{
			var s:Stage = event.currentTarget as Stage;
			if (s)
			{
				s.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
				s.removeEventListener(Event.MOUSE_LEAVE, leaveHandler);
				s.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				s.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				s.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				if (parent) parent.removeChild(this);
			}
		}
		
		private function moveHandler(event:MouseEvent):void 
		{
			var g:Graphics = super.graphics;
			if (!_lineMatrixH)
			{
				_lineMatrixH = new Matrix();
				_lineMatrixH.createGradientBox(10, 10, 0, 0, 0);
				_lineMatrixV = new Matrix();
				_lineMatrixV.createGradientBox(10, 10, Math.PI / 4, 0, 0);
			}
			var realX:Number;
			var realY:Number;
			if (_downLocation.x < event.stageX)
			{
				realX = Math.min(_visibleBounds.right, event.stageX);
			}
			else
			{
				realX = Math.max(_visibleBounds.left, event.stageX);
			}
			if (_downLocation.y < event.stageY)
			{
				realY = Math.min(_visibleBounds.bottom, event.stageY);
			}
			else
			{
				realY = Math.max(_visibleBounds.top, event.stageY);
			}
			g.clear();
			g.lineStyle(1, 0, 1, true);
			g.lineGradientStyle(GradientType.LINEAR, [0, 0, 0, 0], [1, 1, 0, 0], [0, 127, 128, 255], _lineMatrixH, SpreadMethod.REPEAT);
			g.beginFill(0, 0);
			g.moveTo(_downLocation.x, _downLocation.y)
			g.lineTo(realX, _downLocation.y);
			g.lineGradientStyle(GradientType.LINEAR, [0, 0, 0, 0], [1, 1, 0, 0], [0, 127, 128, 255], _lineMatrixV, SpreadMethod.REPEAT);
			g.lineTo(realX, realY);
			g.lineGradientStyle(GradientType.LINEAR, [0, 0, 0, 0], [1, 1, 0, 0], [0, 127, 128, 255], _lineMatrixH, SpreadMethod.REPEAT);
			g.lineTo(_downLocation.x, realY);
			g.lineGradientStyle(GradientType.LINEAR, [0, 0, 0, 0], [1, 1, 0, 0], [0, 127, 128, 255], _lineMatrixV, SpreadMethod.REPEAT);
			g.lineTo(_downLocation.x, _downLocation.y);
			g.endFill();
			super.blendMode = BlendMode.INVERT;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function selectTo(point:Point):void
		{
			
		}
		
		public function stop():void
		{
			
		}
		
		protected function draw():void
		{
			
		}
		
		public function getSelected():Vector.<DisplayObject>
		{
			if (!_target) return null;
			var v:Vector.<DisplayObject> = new <DisplayObject>[];
			var i:int = _target.numChildren;
			var b:Rectangle = super.getBounds(this);
			var d:DisplayObject;
			while (i--)
			{
				d = _target.getChildAt(i);
				if (d.getBounds(this).intersects(b))
				{
					v.push(d);
					if (d is DisplayObjectContainer)
					{
						getSelectedRecursive(d as DisplayObjectContainer, b, v);
					}
				}
			}
			return v;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function getSelectedRecursive(container:DisplayObjectContainer, 
								bounds:Rectangle, to:Vector.<DisplayObject>):void
		{
			var i:int = container.numChildren;
			var c:DisplayObject;
			while (i--)
			{
				c = container.getChildAt(i);
				if (c.getBounds(this).intersects(bounds))
				{
					to.push(c);
					if (c is DisplayObjectContainer)
					{
						getSelectedRecursive(c as DisplayObjectContainer, bounds, to);
					}
				}
			}
		}
		
	}
	
}