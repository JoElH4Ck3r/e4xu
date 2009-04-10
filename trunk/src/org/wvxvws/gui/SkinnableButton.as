package org.wvxvws.gui 
{
	import org.wvxvws.gui.Skin;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	/**
	 * SkinnableButton class.
	 * @author wvxvw
	 */
	public class SkinnableButton extends SkinnableControl
	{
		public static const UP:String = "up";
		public static const OVER:String = "over";
		public static const DOWN:String = "down";
		public static const DISABLED:String = "disabled";
		
		protected var _label:String = "";
		protected var _labelField:TextField = new TextField();
		protected var _disabled:Boolean;
		
		protected var _currentState:String;
		protected var _availableStates:Object = { };
		protected var _skinContainer:DisplayObject;
		
		public function SkinnableButton(upState:DisplayObject = null,
										downState:DisplayObject = null, 
										overState:DisplayObject = null,
										disabledState:DisplayObject = null)
		{
			super();
			_availableStates[UP] = upState;
			_availableStates[OVER] = overState;
			_availableStates[DOWN] = downState;
			_availableStates[DISABLED] = disabledState;
			_currentState = UP;
			_skinContainer = upState;
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true);
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true);
			mouseChildren = false;
			buttonMode = true;
		}
		
		protected function mouseDownHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = DOWN;
		}
		
		protected function rollOverHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = OVER;
		}
		
		protected function rollOutHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			currentState = UP;
		}
		
		override public function validateLayout(event:Event = null):void 
		{
			super.validateLayout(event);
			if (_skinContainer !== _availableStates[_currentState])
			{
				if (_skinContainer && contains(_skinContainer))
					removeChild(_skinContainer);
				_skinContainer = _availableStates[_currentState] as DisplayObject;
				if (!_skinContainer) _skinContainer = _availableStates[UP] as DisplayObject;
			}
			if (_skinContainer && !contains(_skinContainer)) addChild(_skinContainer);
			if (_labelField.text != _label) _labelField.text = _label;
			if (_skinContainer) _skinContainer.transform.matrix = _transform;
		}
		
		override public function setSkin(skin:Skin):void 
		{
			if (_skin === skin) return;
			_availableStates[UP] = new (skin as ButtonSkin).states[UP]();
			_availableStates[OVER] = new (skin as ButtonSkin).states[OVER]();
			_availableStates[DOWN] = new (skin as ButtonSkin).states[DOWN]();
			_availableStates[DISABLED] = new (skin as ButtonSkin).states[DISABLED]();
			invalidLayout = true;
		}
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			if (_label == value) return;
			_label = value;
			invalidLayout = true;
		}
		
		public function get labelField():TextField { return _labelField; }
		
		public function get currentState():String { return _currentState; }
		
		public function set currentState(value:String):void 
		{
			if (_currentState == value) return;
			_currentState = value;
			invalidLayout = true;
		}
		
		public function get disabled():Boolean { return _disabled; }
		
		public function set disabled(value:Boolean):void 
		{
			if (_disabled == value) return;
			_disabled = value;
			_currentState = DISABLED;
			invalidLayout = true;
		}
	}
}