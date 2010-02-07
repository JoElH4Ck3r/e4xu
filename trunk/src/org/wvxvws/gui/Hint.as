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

package org.wvxvws.gui 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	//}
	
	/**
	* Hint class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Hint extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property factory
		//------------------------------------
		
		[Bindable("factoryChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>factoryChanged</code> event.
		*/
		public function get factory():Class { return this._factory; }
		
		public function set factory(value:Class):void 
		{
			if (this._factory === value) return;
			this._factory = value;
			if (super.hasEventListener(EventGenerator.getEventType("factory")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property point
		//------------------------------------
		
		[Bindable("pointChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>pointChanged</code> event.
		*/
		public function get point():Point { return this._point; }
		
		public function set point(value:Point):void 
		{
			if (this._point === value) return;
			this._point = value;
			if (super.hasEventListener(EventGenerator.getEventType("point")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property text
		//------------------------------------
		
		[Bindable("textChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>textChanged</code> event.
		*/
		public function get text():String { return this._text; }
		
		public function set text(value:String):void 
		{
			if (this._text === value) return;
			this._text = value;
			if (super.hasEventListener(EventGenerator.getEventType("text")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property target
		//------------------------------------
		
		[Bindable("targetChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>targetChanged</code> event.
		*/
		public function get target():DisplayObject { return this._target; }
		
		public function set target(value:DisplayObject):void 
		{
			if (this._target === value) return;
			if (this._target)
			{
				this._target.removeEventListener(
					MouseEvent.MOUSE_OVER, this.mouseOverHandler);
			}
			this._target = value;
			this._target.addEventListener(
				MouseEvent.MOUSE_OVER, this.mouseOverHandler, false, 0, true);
			this._target.addEventListener(
				MouseEvent.MOUSE_OUT, this.mouseOutHandler, false, 0, true);
			if (super.hasEventListener(EventGenerator.getEventType("target")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property time
		//------------------------------------
		
		[Bindable("timeChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>timeChanged</code> event.
		*/
		public function get time():int { return this._time; }
		
		public function set time(value:int):void 
		{
			if (this._time === value) return;
			this._time = value;
			if (_HIDE_TIMER && _HIDE_TIMER.running)
			{
				_HIDE_TIMER.stop();
				_HIDE_TIMER.removeEventListener(
					TimerEvent.TIMER_COMPLETE, this.hideTimerCompleteHandler);
			}
			_HIDE_TIMER = new Timer(value, 1);
			_HIDE_TIMER.addEventListener(
				TimerEvent.TIMER_COMPLETE, 
				this.hideTimerCompleteHandler, false, 0, true);
			if (super.hasEventListener(EventGenerator.getEventType("time")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property instance
		//------------------------------------
		
		public function get instance():DisplayObject { return _INSTANCE; }
		
		//------------------------------------
		//  Public property hasInstance
		//------------------------------------
		
		public function get hasInstance():Boolean { return this._hasInstance; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _target:DisplayObject;
		protected var _point:Point;
		protected var _hasInstance:Boolean;
		protected var _factory:Class;
		protected var _text:String;
		protected var _defaultHintFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _document:Object;
		protected var _id:String;
		protected var _time:int = 2000;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _INSTANCE:DisplayObject;
		private static var _TIMER:Timer = new Timer(100, 1);
		private static var _HIDE_TIMER:Timer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Hint() 
		{
			super();
			_TIMER.addEventListener(
				TimerEvent.TIMER_COMPLETE, 
				this.timerCompleteHandler, false, 0, true);
			if (!_HIDE_TIMER) _HIDE_TIMER = new Timer(_time, 1);
			_HIDE_TIMER.addEventListener(
				TimerEvent.TIMER_COMPLETE, 
				this.hideTimerCompleteHandler, false, 0, true);
			this._defaultHintFormat.indent = 1;
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
		
		public function dispose():void { }
		
		public function show(text:String = null):DisplayObject
		{
			if (!this._target) return null;
			if (!this._target.stage) return null;
			if (!text) text = this._text;
			var bounds:Rectangle = this._target.getBounds(this._target.stage);
			var hp:Point;
			var p:Point = this._target.localToGlobal(
				new Point(this._target.mouseX * this._target.scaleX, 
				this._target.mouseY * this._target.scaleY));
			if (!bounds.containsPoint(p)) return null;
			if (_INSTANCE) this.hide();
			var ht:DisplayObject;
			var htBase:DisplayObjectContainer = 
				this._target.stage.getChildAt(
				this._target.stage.numChildren - 1) as DisplayObjectContainer;
			if (this._factory)
			{
				ht = new this._factory() as DisplayObject;
				if (!ht) throw new Error("Factory must extend DisplayObject");
			}
			else
			{
				if (this._point) hp = this._target.localToGlobal(this._point);
				else hp = p;
				ht = drawDefaultHint(htBase, hp, text);
			}
			_INSTANCE = htBase.addChild(ht);
			_HIDE_TIMER.start();
			super.dispatchEvent(new Event("instanceChange"));
			super.dispatchEvent(new Event("hasInstanceChange"));
			return ht;
		}
		
		public function hide():void
		{
			if (!_INSTANCE) return;
			if (_INSTANCE && _INSTANCE.parent)
				_INSTANCE.parent.removeChild(_INSTANCE);
			if (_HIDE_TIMER && _HIDE_TIMER.running)
				_HIDE_TIMER.stop();
			_INSTANCE = null;
			super.dispatchEvent(new Event("instanceChange"));
			super.dispatchEvent(new Event("hasInstanceChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function mouseOverHandler(event:MouseEvent):void 
		{
			if (_TIMER.running)
			{
				_TIMER.stop();
				_TIMER.reset();
			}
			this.hide();
			_TIMER.start();
		}
		
		protected function mouseOutHandler(event:MouseEvent):void 
		{
			if (this._target && this._target.stage)
			{
				var bounds:Rectangle = this._target.getBounds(this._target.stage);
				var p:Point = new Point(event.stageX, event.stageY);
				if (bounds.containsPoint(p)) return;
			}
			if (_TIMER.running) _TIMER.stop();
			this.hide();
		}
		
		protected function timerCompleteHandler(event:TimerEvent):void 
		{
			this.show();
		}
		
		protected function hideTimerCompleteHandler(event:TimerEvent):void 
		{
			this.hide();
		}
		
		protected function drawDefaultHint(where:DisplayObjectContainer, 
							anchor:Point, what:String):DisplayObject
		{
			var s:Sprite = new Sprite();
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.multiline = true;
			t.wordWrap = false;
			t.selectable = false;
			t.defaultTextFormat = this._defaultHintFormat;
			t.text = what;
			s.mouseChildren = false;
			s.graphics.lineStyle(1, 0x3E2F1B);
			s.graphics.beginFill(0xF4ECDF);
			s.graphics.moveTo(0, 0);
			s.graphics.lineTo(t.width, 0);
			s.graphics.lineTo(t.width, t.height);
			s.graphics.lineTo(t.width * 0.5 + 5, t.height);
			s.graphics.lineTo(t.width * 0.5, t.height + 8);
			s.graphics.lineTo(t.width * 0.5 - 5, t.height);
			s.graphics.lineTo(0, t.height);
			s.graphics.lineTo(0, 0);
			s.graphics.endFill();
			s.x = anchor.x - t.width * 0.5;
			s.y = anchor.y - (t.height + 9);
			s.filters = [new DropShadowFilter(2, 45, 0, 0.5)];
			s.addChild(t);
			return s;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}