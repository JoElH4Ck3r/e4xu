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
		public function get factory():Class { return _factory; }
		
		public function set factory(value:Class):void 
		{
			if (_factory === value) return;
			_factory = value;
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
		public function get point():Point { return _point; }
		
		public function set point(value:Point):void 
		{
			if (_point === value) return;
			_point = value;
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
		public function get text():String { return _text; }
		
		public function set text(value:String):void 
		{
			if (_text == value) return;
			_text = value;
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
		public function get target():DisplayObject { return _target; }
		
		public function set target(value:DisplayObject):void 
		{
			if (_target == value) return;
			if (_target) _target.removeEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			_target = value;
			_target.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			_target.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
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
		public function get time():int { return _time; }
		
		public function set time(value:int):void 
		{
			if (_time == value) return;
			_time = value;
			if (_hideTimer && _hideTimer.running)
			{
				_hideTimer.stop();
				_hideTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, hideTimerCompleteHandler);
			}
			_hideTimer = new Timer(value, 1);
			_hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideTimerCompleteHandler, false, 0, true);
			if (super.hasEventListener(EventGenerator.getEventType("time")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property instance
		//------------------------------------
		
		public function get instance():DisplayObject { return _instance; }
		
		//------------------------------------
		//  Public property hasInstance
		//------------------------------------
		
		public function get hasInstance():Boolean { return _hasInstance; }
		
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
		
		private static var _instance:DisplayObject;
		private static var _timer:Timer = new Timer(100, 1);
		private static var _hideTimer:Timer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function Hint() 
		{
			super();
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerCompleteHandler, false, 0, true);
			if (!_hideTimer) _hideTimer = new Timer(_time, 1);
			_hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE, hideTimerCompleteHandler, false, 0, true);
			_defaultHintFormat.indent = 1;
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
		
		public function show(text:String = null):DisplayObject
		{
			if (!_target) return null;
			if (!_target.stage) return null;
			if (!text) text = _text;
			var bounds:Rectangle = _target.getBounds(_target.stage);
			var hp:Point;
			var p:Point = _target.localToGlobal(new Point(_target.mouseX * _target.scaleX, 
														_target.mouseY * _target.scaleY));
			if (!bounds.containsPoint(p)) return null;
			if (_instance) hide();
			var ht:DisplayObject;
			var htBase:DisplayObjectContainer = 
				_target.stage.getChildAt(_target.stage.numChildren - 1) as DisplayObjectContainer;
			if (_factory)
			{
				ht = new _factory() as DisplayObject;
				if (!ht) throw new Error("Factory must extend DisplayObject");
			}
			else
			{
				if (_point) hp = _target.localToGlobal(_point);
				else hp = p;
				ht = drawDefaultHint(htBase, hp, text);
			}
			_instance = htBase.addChild(ht);
			_hideTimer.start();
			dispatchEvent(new Event("instanceChange"));
			dispatchEvent(new Event("hasInstanceChange"));
			return ht;
		}
		
		public function hide():void
		{
			if (!_instance) return;
			if (_instance && _instance.parent) _instance.parent.removeChild(_instance);
			if (_hideTimer && _hideTimer.running) _hideTimer.stop();
			_instance = null;
			dispatchEvent(new Event("instanceChange"));
			dispatchEvent(new Event("hasInstanceChange"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function mouseOverHandler(event:MouseEvent):void 
		{
			if (_timer.running)
			{
				_timer.stop();
				_timer.reset();
			}
			hide();
			_timer.start();
		}
		
		protected function mouseOutHandler(event:MouseEvent):void 
		{
			if (_target && _target.stage)
			{
				var bounds:Rectangle = _target.getBounds(_target.stage);
				var p:Point = new Point(event.stageX, event.stageY);
				if (bounds.containsPoint(p)) return;
			}
			if (_timer.running) _timer.stop();
			hide();
		}
		
		protected function timerCompleteHandler(event:TimerEvent):void 
		{
			show();
		}
		
		protected function hideTimerCompleteHandler(event:TimerEvent):void 
		{
			hide();
		}
		
		protected function drawDefaultHint(where:DisplayObjectContainer, anchor:Point, what:String):DisplayObject
		{
			var s:Sprite = new Sprite();
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.multiline = true;
			t.wordWrap = false;
			t.selectable = false;
			t.defaultTextFormat = _defaultHintFormat;
			t.text = what;
			s.mouseChildren = false;
			s.graphics.lineStyle(1, 0x3E2F1B);
			s.graphics.beginFill(0xF4ECDF);
			s.graphics.moveTo(0, 0);
			s.graphics.lineTo(t.width, 0);
			s.graphics.lineTo(t.width, t.height);
			s.graphics.lineTo(t.width / 2 + 5, t.height);
			s.graphics.lineTo(t.width / 2, t.height + 8);
			s.graphics.lineTo(t.width / 2 - 5, t.height);
			s.graphics.lineTo(0, t.height);
			s.graphics.lineTo(0, 0);
			s.graphics.endFill();
			s.x = anchor.x - t.width / 2;
			s.y = anchor.y - (t.height + 9);
			s.filters = [new DropShadowFilter(2, 45, 0, .5)];
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