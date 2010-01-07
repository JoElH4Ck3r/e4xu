package org.wvxvws.gui.controls 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.gui.skins.SkinManager;
	import org.wvxvws.gui.StatefulButton;
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="disabled", type="org.wvxvws.gui.GUIEvent")]
	
	[Skin("org.wvxvws.skins.OptionSkin")]
	[Skin(part="label", type="org.wvxvws.skins.LabelSkin")]
	
	/**
	 * Option class.
	 * @author wvxvw
	 */
	public class Option extends DIV implements ISkinnable
	{
		public static const UP_STATE:String = "upState";
		public static const OVER_STATE:String = "overState";
		public static const DOWN_STATE:String = "downState";
		public static const DISABLED_STATE:String = "disabledState";
		public static const SELECTED_STATE:String = "selectedState";
		public static const SELECTED_DISABLED_STATE:String = "selectedDisabledState";
		
		//------------------------------------
		//  Public property selected
		//------------------------------------
		
		[Bindable("selectedChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>selectedChanged</code> event.
		*/
		public function get selected():Boolean { return this._selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (this._selected === value) return;
			this._selected = value;
			this._button.state = this._selected ? SELECTED_STATE : UP_STATE; 
			super.invalidate(Invalides.STATE, false);
			if (super.hasEventListener(EventGenerator.getEventType("selected")))
				super.dispatchEvent(EventGenerator.getEvent());
			if (_selected) super.dispatchEvent(GUIEvent.SELECTED);
		}
		
		//------------------------------------
		//  Public property disabled
		//------------------------------------
		
		[Bindable("disabledChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>disabledChanged</code> event.
		*/
		public function get disabled():Boolean { return this._disabled; }
		
		public function set disabled(value:Boolean):void 
		{
			if (this._disabled === value) return;
			this._disabled = value;
			super.invalidate(Invalides.STATE, false);
			if (super.hasEventListener(EventGenerator.getEventType("disabled")))
				super.dispatchEvent(EventGenerator.getEvent());
			if (this._disabled) super.dispatchEvent(GUIEvent.DISABLED);
		}
		
		//------------------------------------
		//  Public property skin
		//------------------------------------
		
		[Bindable("skinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>skinChanged</code> event.
		*/
		public function get skin():Vector.<ISkin> { return new <ISkin>[this._skin]; }
		
		public function set skin(value:Vector.<ISkin>):void 
		{
			if (value && value.length && this._skin === value[0]) return;
			if (this._skin === value) return;
			if (value && value.length) this._skin = value[0];
			if (this._skin)
			{
				this._button.states[UP_STATE] = 
					this._skin.produce(this._button, UP_STATE);
				this._button.states[DOWN_STATE] = 
					this._skin.produce(this._button, DOWN_STATE);
				this._button.states[OVER_STATE] = 
					this._skin.produce(this._button, OVER_STATE);
				this._button.states[SELECTED_STATE] = 
					this._skin.produce(this._button, SELECTED_STATE);
				this._button.states[DISABLED_STATE] = 
					this._skin.produce(this._button, DISABLED_STATE);
				this._button.states[SELECTED_DISABLED_STATE] = 
					this._skin.produce(this._button, SELECTED_DISABLED_STATE);
			}
			else
			{
				delete this._button.states[UP_STATE];
				delete this._button.states[DOWN_STATE];
				delete this._button.states[OVER_STATE];
				delete this._button.states[SELECTED_STATE];
				delete this._button.states[DISABLED_STATE];
				delete this._button.states[SELECTED_DISABLED_STATE];
			}
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("skin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		//------------------------------------
		//  Public property label
		//------------------------------------
		
		[Bindable("labelChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelChanged</code> event.
		*/
		public function get label():ISkin { return this._label; }
		
		public function set label(value:ISkin):void 
		{
			if (this._label === value) return;
			this._label = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("label")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property labelPlacement
		//------------------------------------
		
		[Bindable("labelPlacementChanged")]
		
		/**
		* <pre>
		* X 1 X
		* 2 3 4
		* X 5 X</pre>
		* @default	4.
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelPlacementChanged</code> event.
		*/
		public function get labelPlacement():int { return this._labelPlacement; }
		
		public function set labelPlacement(value:int):void 
		{
			value = Math.min(Math.max(value, 1), 5);
			if (this._selected === value) return;
			this._labelPlacement = value;
			super.invalidate(Invalides.SKIN, false);
			if (super.hasEventListener(EventGenerator.getEventType("labelPlacement")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		protected var _selected:Boolean;
		protected var _disabled:Boolean;
		
		protected var _label:ISkin;
		protected var _labelPlacement:int = 4;
		protected var _labelField:TextField = new TextField();
		protected var _gutter:int = 5;
		
		protected var _button:StatefulButton = new StatefulButton();
		protected var _skin:ISkin;
		
		public function Option() 
		{
			super();
			super.addEventListener(
				MouseEvent.CLICK, this.button_clickHandler, false, int.MAX_VALUE);
			super.addEventListener(
				MouseEvent.MOUSE_OVER, this.button_overHandler, false, int.MAX_VALUE);
			super.addEventListener(
				MouseEvent.MOUSE_OUT, this.button_outHandler, false, int.MAX_VALUE);
			this._labelField.multiline = false;
			this._labelField.wordWrap = false;
			this._labelField.selectable = false;
			this._labelField.mouseEnabled = false;
			this._labelField.autoSize = TextFieldAutoSize.LEFT;
			this._labelField.defaultTextFormat = SkinDefaults.DARK_FORMAT;
			super.addChild(this._labelField);
		}
		
		protected function button_outHandler(event:MouseEvent):void 
		{
			if (this._disabled || this._selected) return;
			this._button.state = UP_STATE;
		}
		
		protected function button_overHandler(event:MouseEvent):void 
		{
			if (this._disabled || this._selected) return;
			this._button.state = OVER_STATE;
		}
		
		protected function button_clickHandler(event:MouseEvent):void 
		{
			if (this._disabled) return;
			this.selected = !this._selected;
		}
		
		public override function validate(properties:Dictionary):void 
		{
			if (!this._skin) this.skin = SkinManager.getSkin(this);
			var skinChanged:Boolean = (Invalides.SKIN in properties);
			var stateChanged:Boolean = (Invalides.STATE in properties);
			super.validate(properties);
			if (!super.contains(this._button))
			{
				this._button.initialized(this, "button");
				this._button.state = this._disabled ? DISABLED_STATE : UP_STATE;
				stateChanged = true;
			}
			if (skinChanged)
			{
				if (this._label)
				{
					this._labelField.text = this._label.produce(this) as String;
					if (!super.contains(this._labelField))
						super.addChild(this._labelField);
				}
				else
				{
					super.removeChild(this._labelField);
					this._labelField.text = "";
				}
			}
			if (stateChanged)
			{
				if (this._selected)
				{
					this._button.state = 
						this._disabled ? SELECTED_DISABLED_STATE : SELECTED_STATE;
				}
				else
				{
					this._button.state = this._disabled ? DISABLED_STATE : UP_STATE;
				}
			}
			if (skinChanged)
			{
				switch (this._labelPlacement)
				{
					case 1:
						this._labelField.x = 0;
						this._labelField.y = 0;
						this._button.x = 
							(this._labelField.width - this._button.width) >> 1;
						this._button.y = this._labelField.height + this._gutter;
						break;
					case 2:
						this._labelField.x = 0;
						if (this._labelField.height > this._button.height)
						{
							this._labelField.y = 0;
							this._button.y = 
								(this._labelField.height - this._button.height) >> 1;
						}
						else
						{
							this._button.y = 0;
							this._labelField.y = 
								(this._button.height - this._labelField.height) >> 1;
						}
						this._button.x = this._labelField.width + this._gutter;
						break;
					case 3:
						if (this._labelField.height > this._button.height)
						{
							this._labelField.y = 0;
							this._button.y = 
								(this._labelField.height - this._button.height) >> 1;
						}
						else
						{
							this._button.y = 0;
							this._labelField.y = 
								(this._button.height - this._labelField.height) >> 1;
						}
						if (this._labelField.width > this._button.width)
						{
							this._labelField.x = 0;
							this._button.x = 
								(this._labelField.width - this._button.width) >> 1;
						}
						else
						{
							this._button.x = 0;
							this._labelField.x = 
								(this._button.width - this._labelField.width) >> 1;
						}
						break;
					case 4:
						this._button.x = 0;
						this._labelField.x = this._button.width + this._gutter;
						if (this._labelField.height > this._button.height)
						{
							this._labelField.y = 0;
							this._button.y = 
								(this._labelField.height - this._button.height) >> 1;
						}
						else
						{
							this._button.y = 0;
							this._labelField.y = 
								(this._button.height - this._labelField.height) >> 1;
						}
						break;
					case 5:
						this._labelField.x = 0;
						this._labelField.y = this._button.height + this._gutter;
						this._button.x = 
							(this._labelField.width - this._button.width) >> 1;
						this._button.y = 0;
						break;
				}
			}
		}
	}
}