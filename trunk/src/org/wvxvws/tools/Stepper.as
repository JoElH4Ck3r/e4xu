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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.gui.SPAN;
	//}
	
	/**
	 * Stepper class.
	 * @author wvxvw
	 */
	public class Stepper extends SPAN
	{
		//--------------------------------------------------------------------------
		//
		//  public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * String,Object,int->String
		 * @example
		 * <code>
		 * function theFormatter(oldValue:String, change:Object, incrementing:int):String
		 * {
		 * 		switch (incrementing)
		 * 		{
		 * 			case -1: // decrementing
		 * 				return (int(oldValue) - int(change)).toString();
		 * 			case 0: // refreshing
		 * 				return (int(oldValue) + int(change)).toString();
		 * 			case 1: // incrementing
		 * 				return (int(oldValue) + int(change)).toString();
		 * 		}
		 * 		return "Error...";
		 * }
		 * </code>
		 */
		public function get formatter():Function { return _formatter; }
		
		public function set formatter(value:Function):void 
		{
			if (_formatter === value) return;
			_formatter = value;
			if (super.hasEventListener(EventGenerator.getEventType("formatter")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property step
		//------------------------------------
		
		[Bindable("stepChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>stepChanged</code> event.
		*/
		public function get step():Number { return _step; }
		
		public function set step(value:Number):void 
		{
			if (_step === value) return;
			_step = value;
			if (super.hasEventListener(EventGenerator.getEventType("step")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property min
		//------------------------------------
		
		[Bindable("minChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>minChanged</code> event.
		*/
		public function get min():Number { return _min; }
		
		public function set min(value:Number):void 
		{
			if (_min === value) return;
			_min = value;
			if (super.hasEventListener(EventGenerator.getEventType("min")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property max
		//------------------------------------
		
		[Bindable("maxChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>maxChanged</code> event.
		*/
		public function get max():Number { return _max; }
		
		public function set max(value:Number):void 
		{
			if (_max === value) return;
			_max = value;
			if (super.hasEventListener(EventGenerator.getEventType("max")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _position:Number;
		protected var _step:Number = 1;
		protected var _max:Number = 100;
		protected var _min:Number = 0;
		protected var _hasFocus:Boolean;
		
		protected var _formatter:Function;
		protected var _incrementTimer:Timer = new Timer(100);
		protected var _stepDelay:int = 100;
		protected var _incrementing:Boolean;
		protected var _lastPressed:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Stepper() 
		{
			super();
			super.multiline = false;
			super.wordWrap = false;
			super.width = 1;
			super.height = 1;
			super.type = TextFieldType.INPUT;
			super.defaultTextFormat = SkinDefaults.DARK_FORMAT;
			super.addEventListener(TextEvent.TEXT_INPUT, textInputHandler);
			super.addEventListener(FocusEvent.FOCUS_IN, focusInHandler);
			super.addEventListener(FocusEvent.FOCUS_OUT, focusOutHandler);
			_incrementTimer.addEventListener(TimerEvent.TIMER, timerHandler);
			_invalidProperties._bounds = _bounds;
		}
		
		protected function timerHandler(event:TimerEvent):void 
		{
			if (_incrementing) this.increment();
			else this.decrement();
		}
		
		protected function focusOutHandler(event:FocusEvent):void 
		{
			super.stage.removeEventListener(
					KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			super.stage.removeEventListener(
					KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
		
		protected function focusInHandler(event:FocusEvent):void 
		{
			super.stage.addEventListener(
				KeyboardEvent.KEY_DOWN, stage_keyDownHandler);
			super.stage.addEventListener(
				KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
		
		protected function stage_keyUpHandler(event:KeyboardEvent):void 
		{
			if (event.keyCode === _lastPressed) _incrementTimer.stop();
		}
		
		protected function stage_keyDownHandler(event:KeyboardEvent):void 
		{
			if (event.keyCode === Keyboard.UP || 
				event.keyCode === Keyboard.RIGHT)
			{
				_incrementing = true;
				_incrementTimer.start();
				_lastPressed = event.keyCode;
			}
			else if (event.keyCode === Keyboard.DOWN || 
					event.keyCode === Keyboard.LEFT)
			{
				_incrementing = false;
				_incrementTimer.start();
				_lastPressed = event.keyCode;
			}
		}
		
		protected function textInputHandler(event:TextEvent):void 
		{
			if (_formatter !== null)
				super.text = _formatter(super.text, event.text, 0);
		}
		
		protected function cleanup(event:Event = null):void 
		{
			
		}
		
		public function start(increment:Boolean):void
		{
			_lastPressed = -1;
			_incrementing = increment;
			_incrementTimer.start();
		}
		
		public function stop():void { _incrementTimer.stop(); }
		
		public function increment():void
		{
			if (_formatter !== null)
			{
				super.text = _formatter(super.text, _step, 1);
			}
			else if (!isNaN(Number(super.text)) && 
					Number(super.text) + _step < _max)
			{
				super.text = (Number(super.text) + _step).toString();
			}
			else if (isNaN(Number(super.text)) && 
					super.text && super.text.length < _max)
			{
				super.appendText(_step.toString());
			}
		}
		
		public function decrement():void
		{
			if (_formatter !== null)
			{
				super.text = _formatter(super.text, _step, -1);
			}
			else if (!isNaN(Number(super.text)) && 
					Number(super.text) - _step > _min)
			{
				super.text = (Number(super.text) - _step).toString();
			}
			else if (isNaN(Number(super.text)) && 
					super.text && super.text.length > _min)
			{
				super.text = super.text.substr(0, super.text.length - 1);
			}
		}
	}
}