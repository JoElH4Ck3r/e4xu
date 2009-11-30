package org.wvxvws.gui.controls 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.GUIEvent;
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
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected === value) return;
			_selected = value;
			_button.state = _selected ? SELECTED_STATE : UP_STATE; 
			super.invalidate("_selected", _selected, false);
			if (super.hasEventListener(EventGenerator.getEventType("selected")))
				super.dispatchEvent(EventGenerator.getEvent());
			if (_selected) super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED));
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
		public function get disabled():Boolean { return _disabled; }
		
		public function set disabled(value:Boolean):void 
		{
			if (_disabled === value) return;
			_disabled = value;
			super.invalidate("_disabled", _disabled, false);
			if (super.hasEventListener(EventGenerator.getEventType("disabled")))
				super.dispatchEvent(EventGenerator.getEvent());
			if (_disabled) super.dispatchEvent(new GUIEvent(GUIEvent.DISABLED));
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
		public function get skin():Vector.<ISkin> { return new <ISkin>[_skin]; }
		
		public function set skin(value:Vector.<ISkin>):void 
		{
			if (value && value.length && _skin === value[0]) return;
			if (_skin === value) return;
			if (value && value.length) _skin = value[0];
			if (_skin)
			{
				_button.states[UP_STATE] = _skin.produce(_button, UP_STATE);
				_button.states[DOWN_STATE] = _skin.produce(_button, DOWN_STATE);
				_button.states[OVER_STATE] = _skin.produce(_button, OVER_STATE);
				_button.states[SELECTED_STATE] = 
					_skin.produce(_button, SELECTED_STATE);
				_button.states[DISABLED_STATE] = 
					_skin.produce(_button, DISABLED_STATE);
				_button.states[SELECTED_DISABLED_STATE] = 
					_skin.produce(_button, SELECTED_DISABLED_STATE);
			}
			else
			{
				delete _button.states[UP_STATE];
				delete _button.states[DOWN_STATE];
				delete _button.states[OVER_STATE];
				delete _button.states[SELECTED_STATE];
				delete _button.states[DISABLED_STATE];
				delete _button.states[SELECTED_DISABLED_STATE];
			}
			super.invalidate("_skin", _skin, false);
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
		public function get label():ISkin { return _label; }
		
		public function set label(value:ISkin):void 
		{
			if (_label === value) return;
			_label = value;
			super.invalidate("_label", _label, false);
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
		public function get labelPlacement():int { return _labelPlacement; }
		
		public function set labelPlacement(value:int):void 
		{
			value = Math.min(Math.max(value, 1), 5);
			if (_selected === value) return;
			_labelPlacement = value;
			super.invalidate("_labelPlacement", _labelPlacement, false);
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
				MouseEvent.CLICK, button_clickHandler, false, int.MAX_VALUE);
			super.addEventListener(
				MouseEvent.MOUSE_OVER, button_overHandler, false, int.MAX_VALUE);
			super.addEventListener(
				MouseEvent.MOUSE_OUT, button_outHandler, false, int.MAX_VALUE);
			_labelField.multiline = false;
			_labelField.wordWrap = false;
			_labelField.selectable = false;
			_labelField.mouseEnabled = false;
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			_labelField.defaultTextFormat = SkinDefaults.DARK_FORMAT;
			super.addChild(_labelField);
		}
		
		protected function button_outHandler(event:MouseEvent):void 
		{
			if (_disabled || _selected) return;
			_button.state = UP_STATE;
		}
		
		protected function button_overHandler(event:MouseEvent):void 
		{
			if (_disabled || _selected) return;
			_button.state = OVER_STATE;
		}
		
		protected function button_clickHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			this.selected = !_selected;
		}
		
		public override function validate(properties:Object):void 
		{
			if (!_skin) this.skin = SkinManager.getSkin(this);
			var placementChanged:Boolean = ("_labelPlacement" in properties);
			var labelChanged:Boolean = ("_label" in properties);
			var disabledChanged:Boolean = ("_disabled" in properties);
			super.validate(properties);
			if (!super.contains(_button))
			{
				_button.initialized(this, "button");
				_button.state = _disabled ? DISABLED_STATE : UP_STATE;
				placementChanged = true;
			}
			if (labelChanged)
			{
				if (_label)
				{
					_labelField.text = _label.produce(this) as String;
					if (!super.contains(_labelField)) super.addChild(_labelField);
				}
				else
				{
					super.removeChild(_labelField);
					_labelField.text = "";
				}
			}
			if (disabledChanged)
			{
				if (_selected)
				{
					_button.state = 
						_disabled ? SELECTED_DISABLED_STATE : SELECTED_STATE;
				}
				else
				{
					_button.state = _disabled ? DISABLED_STATE : UP_STATE;
				}
			}
			if (placementChanged || labelChanged)
			{
				switch (_labelPlacement)
				{
					case 1:
						_labelField.x = 0;
						_labelField.y = 0;
						_button.x = (_labelField.width - _button.width) >> 1;
						_button.y = _labelField.height + _gutter;
						break;
					case 2:
						_labelField.x = 0;
						if (_labelField.height > _button.height)
						{
							_labelField.y = 0;
							_button.y = (_labelField.height - _button.height) >> 1;
						}
						else
						{
							_button.y = 0;
							_labelField.y = 
								(_button.height - _labelField.height) >> 1;
						}
						_button.x = _labelField.width + _gutter;
						break;
					case 3:
						if (_labelField.height > _button.height)
						{
							_labelField.y = 0;
							_button.y = (_labelField.height - _button.height) >> 1;
						}
						else
						{
							_button.y = 0;
							_labelField.y = 
								(_button.height - _labelField.height) >> 1;
						}
						if (_labelField.width > _button.width)
						{
							_labelField.x = 0;
							_button.x = (_labelField.width - _button.width) >> 1;
						}
						else
						{
							_button.x = 0;
							_labelField.x = 
								(_button.width - _labelField.width) >> 1;
						}
						break;
					case 4:
						_button.x = 0;
						_labelField.x = _button.width + _gutter;
						if (_labelField.height > _button.height)
						{
							_labelField.y = 0;
							_button.y = (_labelField.height - _button.height) >> 1;
						}
						else
						{
							_button.y = 0;
							_labelField.y = 
								(_button.height - _labelField.height) >> 1;
						}
						break;
					case 5:
						_labelField.x = 0;
						_labelField.y = _button.height + _gutter;
						_button.x = (_labelField.width - _button.width) >> 1;
						_button.y = 0;
						break;
				}
			}
		}
	}
}