package org.wvxvws.gui.controls 
{
	import flash.events.MouseEvent;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	import org.wvxvws.gui.skins.DefaultStepperProducer;
	import org.wvxvws.gui.StatefulButton;
	import org.wvxvws.tools.Stepper;
	
	/**
	 * NumStepper class.
	 * @author wvxvw
	 */
	public class NumStepper extends DIV
	{
		public static const UP_STATE:String = "upState";
		public static const DOWN_STATE:String = "downState";
		public static const OVER_STATE:String = "overState";
		public static const DISABLED_STATE:String = "disabledState";
		
		//------------------------------------
		//  Public property incrementProducer
		//------------------------------------
		
		[Bindable("incrementProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>incrementProducerChanged</code> event.
		*/
		public function get incrementProducer():ButtonSkinProducer { return _incrementProducer; }
		
		public function set incrementProducer(value:ButtonSkinProducer):void 
		{
			if (_incrementProducer === value) return;
			_incrementProducer = value;
			if (_incrementProducer)
			{
				_incrementButton.states[UP_STATE] = 
					_incrementProducer.produce(_incrementButton, UP_STATE);
				_incrementButton.states[DOWN_STATE] = 
					_incrementProducer.produce(_incrementButton, DOWN_STATE);
				_incrementButton.states[OVER_STATE] = 
					_incrementProducer.produce(_incrementButton, OVER_STATE);
				_incrementButton.states[DISABLED_STATE] = 
					_incrementProducer.produce(_incrementButton, DISABLED_STATE);
			}
			else
			{
				delete _incrementButton.states[UP_STATE];
				delete _incrementButton.states[DOWN_STATE];
				delete _incrementButton.states[OVER_STATE];
				delete _incrementButton.states[DISABLED_STATE];
			}
			super.invalidate("_incrementProducer", _incrementProducer, false);
			if (super.hasEventListener(EventGenerator.getEventType("incrementProducer")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property decrementProducer
		//------------------------------------
		
		[Bindable("decrementProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>decrementProducerChanged</code> event.
		*/
		public function get decrementProducer():ButtonSkinProducer { return _decrementProducer; }
		
		public function set decrementProducer(value:ButtonSkinProducer):void 
		{
			
			if (_decrementProducer === value) return;
			_decrementProducer = value;
			if (_decrementProducer)
			{
				_decrementButton.states[UP_STATE] = 
					_decrementProducer.produce(_decrementButton, UP_STATE);
				_decrementButton.states[DOWN_STATE] = 
					_decrementProducer.produce(_decrementButton, DOWN_STATE);
				_decrementButton.states[OVER_STATE] = 
					_decrementProducer.produce(_decrementButton, OVER_STATE);
				_decrementButton.states[DISABLED_STATE] = 
					_decrementProducer.produce(_decrementButton, DISABLED_STATE);
			}
			else
			{
				delete _decrementButton.states[UP_STATE];
				delete _decrementButton.states[DOWN_STATE];
				delete _decrementButton.states[OVER_STATE];
				delete _decrementButton.states[DISABLED_STATE];
			}
			super.invalidate("_decrementProducer", _decrementProducer, false);
			if (super.hasEventListener(EventGenerator.getEventType("decrementProducer")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property buttonPlacement
		//------------------------------------
		
		[Bindable("buttonPlacementChanged")]
		
		/**
		* <pre>
		* X 1 X
		* 2 X 3
		* X 4 X</pre>
		* @default	3.
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>buttonPlacementChanged</code> event.
		*/
		public function get buttonPlacement():int { return _buttonPlacement; }
		
		public function set buttonPlacement(value:int):void 
		{
			value = Math.min(Math.max(value, 1), 4);
			if (_buttonPlacement === value) return;
			_buttonPlacement = value;
			super.invalidate("_buttonPlacement", _decrementProducer, false);
			if (super.hasEventListener(EventGenerator.getEventType("buttonPlacement")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property formatter
		//------------------------------------
		
		[Bindable("formatterChanged")]
		
		/**
		* @copy org/wvxvws/gui/tools/Stepper#formatter
		*/
		public function get formatter():Function { return _stepper.formatter; }
		
		public function set formatter(value:Function):void 
		{
			if (_stepper.formatter === value) return;
			_stepper.formatter = value;
			if (super.hasEventListener(EventGenerator.getEventType("formatter")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property step
		//------------------------------------
		
		[Bindable("stepChanged")]
		
		/**
		* @copy org/wvxvws/gui/tools/Stepper#step
		*/
		public function get step():Number { return _stepper.step; }
		
		public function set step(value:Number):void 
		{
			if (_stepper.step === value) return;
			_stepper.step = value;
			if (super.hasEventListener(EventGenerator.getEventType("step")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property min
		//------------------------------------
		
		[Bindable("minChanged")]
		
		/**
		* @copy org/wvxvws/gui/tools/Stepper#min
		*/
		public function get min():Number { return _stepper.min; }
		
		public function set min(value:Number):void 
		{
			if (_stepper.min === value) return;
			_stepper.min = value;
			if (super.hasEventListener(EventGenerator.getEventType("min")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property max
		//------------------------------------
		
		[Bindable("maxChanged")]
		
		/**
		* @copy org/wvxvws/gui/tools/Stepper#max
		*/
		public function get max():Number { return _stepper.max; }
		
		public function set max(value:Number):void 
		{
			if (_stepper.max === value) return;
			_stepper.max = value;
			if (super.hasEventListener(EventGenerator.getEventType("max")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		protected var _incrementProducer:ButtonSkinProducer;
		protected var _decrementProducer:ButtonSkinProducer;
		protected var _incrementButton:StatefulButton = new StatefulButton();
		protected var _decrementButton:StatefulButton = new StatefulButton();
		protected var _stepper:Stepper = new Stepper();
		protected var _buttonPlacement:int = 3;
		protected var _minTextWidth:int = 8;
		protected var _buttonWidth:int = 20;
		protected var _textHeight:int = 20;
		
		public function NumStepper() 
		{
			super();
			this.incrementProducer = new DefaultStepperProducer();
			_incrementButton.state = UP_STATE;
			_incrementButton.addEventListener(MouseEvent.MOUSE_DOWN, button_downHandler);
			_incrementButton.addEventListener(MouseEvent.MOUSE_UP, button_upHandler);
			this.decrementProducer = new DefaultStepperProducer();
			_decrementButton.state = UP_STATE;
			_decrementButton.addEventListener(MouseEvent.MOUSE_DOWN, button_downHandler);
			_decrementButton.addEventListener(MouseEvent.MOUSE_UP, button_upHandler);
			_stepper.initialized(this, "stepper");
			_invalidProperties._buttonPlacement = _buttonPlacement;
		}
		
		protected function button_upHandler(event:MouseEvent):void { _stepper.stop(); }
		
		protected function button_downHandler(event:MouseEvent):void 
		{
			_stepper.start(event.currentTarget === _incrementButton);
		}
		
		public override function validate(properties:Object):void 
		{
			var placementChanged:Boolean = ("_buttonPlacement" in properties);
			var sizeChanged:Boolean = ("_bounds" in properties);
			super.validate(properties);
			if (placementChanged || sizeChanged)
			{
				switch (_buttonPlacement)
				{
					case 1:
						
						break;
					case 2:
						
						break;
					default:
					case 3:
						_incrementButton.width = _buttonWidth;
						_decrementButton.width = _buttonWidth;
						if (_bounds.x - _buttonWidth < _minTextWidth) 
							_stepper.width = _minTextWidth;
						else _stepper.width = _bounds.x - _buttonWidth;
						_stepper.height = Math.max(_textHeight, _bounds.y);
						_incrementButton.height = _stepper.height >> 1;
						_decrementButton.height = _stepper.height - _incrementButton.height;
						_incrementButton.x = _stepper.width;
						_decrementButton.x = _stepper.width;
						_decrementButton.y = _incrementButton.height;
						break;
					case 4:
						
						break;
				}
			}
			if (!super.contains(_incrementButton))
			{
				_incrementButton.initialized(this, "iButton");
				_decrementButton.initialized(this, "dButton");
			}
		}
	}

}