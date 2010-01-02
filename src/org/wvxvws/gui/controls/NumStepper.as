package org.wvxvws.gui.controls 
{
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.layout.Invalides;
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
		public function get incrementSkin():ISkin { return this._incrementSkin; }
		
		public function set incrementSkin(value:ISkin):void 
		{
			if (this._incrementSkin === value) return;
			this._incrementSkin = value;
			if (this._incrementSkin)
			{
				this._incrementButton.states[UP_STATE] = 
					this._incrementSkin.produce(this._incrementButton, UP_STATE);
				this._incrementButton.states[DOWN_STATE] = 
					this._incrementSkin.produce(this._incrementButton, DOWN_STATE);
				this._incrementButton.states[OVER_STATE] = 
					this._incrementSkin.produce(this._incrementButton, OVER_STATE);
				this._incrementButton.states[DISABLED_STATE] = 
					this._incrementSkin.produce(_incrementButton, DISABLED_STATE);
			}
			else
			{
				delete this._incrementButton.states[UP_STATE];
				delete this._incrementButton.states[DOWN_STATE];
				delete this._incrementButton.states[OVER_STATE];
				delete this._incrementButton.states[DISABLED_STATE];
			}
			super.invalidate(Invalides.SKIN, false);
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
		public function get decrementSkin():ISkin { return this._decrementSkin; }
		
		public function set decrementSkin(value:ISkin):void 
		{
			if (this._decrementSkin === value) return;
			this._decrementSkin = value;
			if (this._decrementSkin)
			{
				this._decrementButton.states[UP_STATE] = 
					this._decrementSkin.produce(this._decrementButton, UP_STATE);
				this._decrementButton.states[DOWN_STATE] = 
					this._decrementSkin.produce(this._decrementButton, DOWN_STATE);
				this._decrementButton.states[OVER_STATE] = 
					this._decrementSkin.produce(this._decrementButton, OVER_STATE);
				this._decrementButton.states[DISABLED_STATE] = 
					this._decrementSkin.produce(this._decrementButton, DISABLED_STATE);
			}
			else
			{
				delete this._decrementButton.states[UP_STATE];
				delete this._decrementButton.states[DOWN_STATE];
				delete this._decrementButton.states[OVER_STATE];
				delete this._decrementButton.states[DISABLED_STATE];
			}
			super.invalidate(Invalides.SKIN, false);
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
		public function get buttonPlacement():int { return this._buttonPlacement; }
		
		public function set buttonPlacement(value:int):void 
		{
			value = Math.min(Math.max(value, 1), 4);
			if (this._buttonPlacement === value) return;
			this._buttonPlacement = value;
			super.invalidate(Invalides.SKIN, false);
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
		public function get formatter():Function { return this._stepper.formatter; }
		
		public function set formatter(value:Function):void 
		{
			if (this._stepper.formatter === value) return;
			this._stepper.formatter = value;
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
		public function get step():Number { return this._stepper.step; }
		
		public function set step(value:Number):void 
		{
			if (this._stepper.step === value) return;
			this._stepper.step = value;
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
		public function get min():Number { return this._stepper.min; }
		
		public function set min(value:Number):void 
		{
			if (this._stepper.min === value) return;
			this._stepper.min = value;
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
		public function get max():Number { return this._stepper.max; }
		
		public function set max(value:Number):void 
		{
			if (this._stepper.max === value) return;
			this._stepper.max = value;
			if (super.hasEventListener(EventGenerator.getEventType("max")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get skin():Vector.<ISkin>
		{
			return new <ISkin>[this._incrementSkin, this._decrementSkin];
		}
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (value && value.length)
			{
				this._incrementSkin = value[0];
				if (value.length > 1) this._decrementSkin = value[1];
			}
			else
			{
				this._incrementSkin = null;
				this._decrementSkin = null;
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
			if (!this._incrementSkin)
			{
				skins = SkinManager.getSkin(this);
				if (skins && skins.length)
				{
					this.incrementSkin = skins[0];
					this.decrementSkin = skins[0];
				}
			}
			this._incrementButton.state = UP_STATE;
			this._incrementButton.addEventListener(
				MouseEvent.MOUSE_DOWN, this.button_downHandler);
			this._incrementButton.addEventListener(
				MouseEvent.MOUSE_UP, this.button_upHandler);
			this._decrementButton.state = UP_STATE;
			this._decrementButton.addEventListener(
				MouseEvent.MOUSE_DOWN, this.button_downHandler);
			this._decrementButton.addEventListener(
				MouseEvent.MOUSE_UP, this.button_upHandler);
			this._stepper.initialized(this, "stepper");
			super._invalidProperties[Invalides.SKIN] = true;
		}
		
		protected function button_upHandler(event:MouseEvent):void
		{
			this._stepper.stop();
		}
		
		protected function button_downHandler(event:MouseEvent):void 
		{
			this._stepper.start(event.currentTarget === this._incrementButton);
		}
		
		public override function validate(properties:Dictionary):void 
		{
			var placementChanged:Boolean = (Invalides.SKIN in properties);
			var sizeChanged:Boolean = (Invalides.BOUNDS in properties);
			super.validate(properties);
			var mI:Matrix;
			var mD:Matrix;
			if (placementChanged || sizeChanged)
			{
				switch (this._buttonPlacement)
				{
					case 1:
						this._incrementButton.rotation = 0;
						this._decrementButton.rotation = 0;
						this._decrementButton.scaleX = 1;
						this._incrementButton.scaleX = 1;
						this._decrementButton.scaleY = 1;
						this._incrementButton.scaleY = 1;
						mI = new Matrix();
						mI.rotate(Math.PI * 0.5);
						mI.scale(this._buttonWidth / this._incrementButton.width, 
								this._bounds.y / this._incrementButton.height);
						this._incrementButton.transform.matrix = mI;
						mD = new Matrix();
						mD.rotate(Math.PI * -0.5);
						mD.scale(this._buttonWidth / this._decrementButton.width, 
								super._bounds.y / this._decrementButton.height);
						this._decrementButton.transform.matrix = mD;
						if (super._bounds.x - this._buttonWidth * 2 < 
							this._minTextWidth) 
							this._stepper.width = this._minTextWidth;
						else
						{
							this._stepper.width = 
								super._bounds.x - this._buttonWidth * 2;
						}
						this._stepper.height = 
							Math.max(this._textHeight, super._bounds.y);
						this._decrementButton.x = 0;
						this._decrementButton.y = this._stepper.height;
						this._incrementButton.x = 
							this._stepper.width + this._incrementButton.width * 2;
						this._incrementButton.y = 0;
						this._stepper.x = this._incrementButton.width;
						break;
					case 2:
						this._incrementButton.rotation = 0;
						this._decrementButton.rotation = 180;
						this._incrementButton.x = 0;
						this._decrementButton.width = 
							Math.max(this._buttonWidth, this._bounds.x);
						this._incrementButton.width = this._decrementButton.width;
						this._stepper.width = this._decrementButton.width;
						this._decrementButton.height = 
							Math.min(this._buttonWidth >> 1, super._bounds.y >> 1);
						this._incrementButton.height = this._decrementButton.height;
						this._decrementButton.x = this._decrementButton.width;
						this._stepper.height = 
							super._bounds.y - this._decrementButton.height * 2;
						this._decrementButton.y = super._bounds.y;
						this._stepper.x = 0;
						this._stepper.y = this._incrementButton.height;
						break;
					default:
					case 3:
						this._incrementButton.rotation = 0;
						this._decrementButton.transform.matrix = new Matrix();
						this._incrementButton.width = this._buttonWidth;
						this._decrementButton.width = this._buttonWidth;
						if (super._bounds.x - this._buttonWidth < this._minTextWidth) 
							this._stepper.width = this._minTextWidth;
						else
						{
							this._stepper.width = 
								super._bounds.x - this._buttonWidth;
						}
						this._stepper.height = 
							Math.max(this._textHeight, super._bounds.y);
						this._incrementButton.height = this._stepper.height >> 1;
						this._decrementButton.height = 
							this._stepper.height - this._incrementButton.height;
						this._incrementButton.x = this._stepper.width;
						this._decrementButton.rotation = 180;
						this._decrementButton.x = 
							this._stepper.width + this._decrementButton.width;
						this._decrementButton.y = 
							this._incrementButton.height + 
							this._decrementButton.height;
						break;
					case 4:
						this._incrementButton.rotation = 0;
						this._stepper.y = 0;
						this._decrementButton.transform.matrix = new Matrix();
						this._incrementButton.width = this._buttonWidth;
						this._decrementButton.width = this._buttonWidth;
						if (super._bounds.x - this._buttonWidth < this._minTextWidth) 
							this._stepper.width = this._minTextWidth;
						else
						{
							this._stepper.width = 
								super._bounds.x - this._buttonWidth;
						}
						this._stepper.height = 
							Math.max(this._textHeight, super._bounds.y);
						this._incrementButton.height = this._stepper.height >> 1;
						this._decrementButton.height = 
							this._stepper.height - this._incrementButton.height;
						this._incrementButton.x = 0;
						this._decrementButton.rotation = 180;
						this._decrementButton.x = this._decrementButton.width;
						this._decrementButton.y = this._decrementButton.height * 2;
						this._stepper.x = this._incrementButton.width;
						break;
				}
			}
			if (!super.contains(this._incrementButton))
			{
				this._incrementButton.initialized(this, "iButton");
				this._decrementButton.initialized(this, "dButton");
			}
		}
	}
}