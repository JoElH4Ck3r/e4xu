package org.wvxvws.gui.controls 
{
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	import org.wvxvws.gui.StatefulButton;
	import org.wvxvws.tools.Stepper;
	
	[Skin("org.wvxvws.skins.StepperSkin")]
	
	/**
	 * NumStepper class.
	 * @author wvxvw
	 */
	public class NumStepper extends DIV implements ISkinnable
	{
		public static const UP_STATE:String = "upState";
		public static const DOWN_STATE:String = "downState";
		public static const OVER_STATE:String = "overState";
		public static const DISABLED_STATE:String = "disabledState";
		
		//------------------------------------
		//  Public property incrementSkin
		//------------------------------------
		
		[Bindable("incrementSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>incrementSkinChanged</code> event.
		*/
		public function get incrementSkin():ISkin { return _incrementSkin; }
		
		public function set incrementSkin(value:ISkin):void 
		{
			if (_incrementSkin === value) return;
			_incrementSkin = value;
			if (_incrementSkin)
			{
				_incrementButton.states[UP_STATE] = 
					_incrementSkin.produce(_incrementButton, UP_STATE);
				_incrementButton.states[DOWN_STATE] = 
					_incrementSkin.produce(_incrementButton, DOWN_STATE);
				_incrementButton.states[OVER_STATE] = 
					_incrementSkin.produce(_incrementButton, OVER_STATE);
				_incrementButton.states[DISABLED_STATE] = 
					_incrementSkin.produce(_incrementButton, DISABLED_STATE);
			}
			else
			{
				delete _incrementButton.states[UP_STATE];
				delete _incrementButton.states[DOWN_STATE];
				delete _incrementButton.states[OVER_STATE];
				delete _incrementButton.states[DISABLED_STATE];
			}
			super.invalidate("_incrementSkin", _incrementSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("incrementSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property decrementSkin
		//------------------------------------
		
		[Bindable("decrementSkinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>decrementSkinChanged</code> event.
		*/
		public function get decrementSkin():ISkin { return _decrementSkin; }
		
		public function set decrementSkin(value:ISkin):void 
		{
			if (_decrementSkin === value) return;
			_decrementSkin = value;
			if (_decrementSkin)
			{
				_decrementButton.states[UP_STATE] = 
					_decrementSkin.produce(_decrementButton, UP_STATE);
				_decrementButton.states[DOWN_STATE] = 
					_decrementSkin.produce(_decrementButton, DOWN_STATE);
				_decrementButton.states[OVER_STATE] = 
					_decrementSkin.produce(_decrementButton, OVER_STATE);
				_decrementButton.states[DISABLED_STATE] = 
					_decrementSkin.produce(_decrementButton, DISABLED_STATE);
			}
			else
			{
				delete _decrementButton.states[UP_STATE];
				delete _decrementButton.states[DOWN_STATE];
				delete _decrementButton.states[OVER_STATE];
				delete _decrementButton.states[DISABLED_STATE];
			}
			super.invalidate("_decrementSkin", _decrementSkin, false);
			if (super.hasEventListener(EventGenerator.getEventType("decrementSkin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property buttonPlacement
		//------------------------------------
		
		[Bindable("buttonPlacementChanged")]
		
		/**
		* <pre>
		* 1.  < [text] >
		* ----------------
		*         /\
		*  2.   [text]
		*         \/
		* ----------------
		*              /\
		* 3.    [text] --
		*              \/
		* ----------------
		*    /\
		* 4. -- [text]
		*    \/
		* </pre>
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
			super.invalidate("_buttonPlacement", _decrementSkin, false);
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
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin>
		{
			return new <ISkin>[_incrementSkin, _decrementSkin];
		}
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (value && value.length)
			{
				_incrementSkin = value[0];
				if (value.length > 1) _decrementSkin = value[1];
			}
			else
			{
				_incrementSkin = null;
				_decrementSkin = null;
			}
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		protected var _incrementSkin:ISkin;
		protected var _decrementSkin:ISkin;
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
			var skins:Vector.<ISkin>;
			if (!_incrementSkin)
			{
				skins = SkinManager.getSkin(this);
				if (skins && skins.length)
				{
					this.incrementSkin = skins[0];
					this.decrementSkin = skins[0];
				}
			}
			_incrementButton.state = UP_STATE;
			_incrementButton.addEventListener(MouseEvent.MOUSE_DOWN, button_downHandler);
			_incrementButton.addEventListener(MouseEvent.MOUSE_UP, button_upHandler);
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
			var mI:Matrix;
			var mD:Matrix;
			if (placementChanged || sizeChanged)
			{
				switch (_buttonPlacement)
				{
					case 1:
						_incrementButton.rotation = 0;
						_decrementButton.rotation = 0;
						_decrementButton.scaleX = 1;
						_incrementButton.scaleX = 1;
						_decrementButton.scaleY = 1;
						_incrementButton.scaleY = 1;
						mI = new Matrix();
						mI.rotate(Math.PI * 0.5);
						mI.scale(_buttonWidth / _incrementButton.width, 
								_bounds.y / _incrementButton.height);
						_incrementButton.transform.matrix = mI;
						mD = new Matrix();
						mD.rotate(Math.PI * -0.5);
						mD.scale(_buttonWidth / _decrementButton.width, 
								_bounds.y / _decrementButton.height);
						_decrementButton.transform.matrix = mD;
						if (_bounds.x - _buttonWidth * 2 < _minTextWidth) 
							_stepper.width = _minTextWidth;
						else _stepper.width = _bounds.x - _buttonWidth * 2;
						_stepper.height = Math.max(_textHeight, _bounds.y);
						_decrementButton.x = 0;
						_decrementButton.y = _stepper.height;
						_incrementButton.x = _stepper.width + _incrementButton.width * 2;
						_incrementButton.y = 0;
						_stepper.x = _incrementButton.width;
						break;
					case 2:
						_incrementButton.rotation = 0;
						_decrementButton.rotation = 180;
						_incrementButton.x = 0;
						_decrementButton.width = Math.max(_buttonWidth, _bounds.x);
						_incrementButton.width = _decrementButton.width;
						_stepper.width = _decrementButton.width;
						_decrementButton.height = Math.min(_buttonWidth >> 1, _bounds.y >> 1);
						_incrementButton.height = _decrementButton.height;
						_decrementButton.x = _decrementButton.width;
						_stepper.height = _bounds.y - _decrementButton.height * 2;
						_decrementButton.y = _bounds.y;
						_stepper.x = 0;
						_stepper.y = _incrementButton.height
						break;
					default:
					case 3:
						_incrementButton.rotation = 0;
						_decrementButton.transform.matrix = new Matrix();
						_incrementButton.width = _buttonWidth;
						_decrementButton.width = _buttonWidth;
						if (_bounds.x - _buttonWidth < _minTextWidth) 
							_stepper.width = _minTextWidth;
						else _stepper.width = _bounds.x - _buttonWidth;
						_stepper.height = Math.max(_textHeight, _bounds.y);
						_incrementButton.height = _stepper.height >> 1;
						_decrementButton.height = _stepper.height - _incrementButton.height;
						_incrementButton.x = _stepper.width;
						_decrementButton.rotation = 180;
						_decrementButton.x = _stepper.width + _decrementButton.width;
						_decrementButton.y = _incrementButton.height + _decrementButton.height;
						break;
					case 4:
						_incrementButton.rotation = 0;
						_stepper.y = 0;
						_decrementButton.transform.matrix = new Matrix();
						_incrementButton.width = _buttonWidth;
						_decrementButton.width = _buttonWidth;
						if (_bounds.x - _buttonWidth < _minTextWidth) 
							_stepper.width = _minTextWidth;
						else _stepper.width = _bounds.x - _buttonWidth;
						_stepper.height = Math.max(_textHeight, _bounds.y);
						_incrementButton.height = _stepper.height >> 1;
						_decrementButton.height = _stepper.height - _incrementButton.height;
						_incrementButton.x = 0;
						_decrementButton.rotation = 180;
						_decrementButton.x = _decrementButton.width;
						_decrementButton.y = _decrementButton.height * 2;
						_stepper.x = _incrementButton.width;
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