﻿package org.wvxvws.gui.controls 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	import org.wvxvws.gui.skins.DefaultOptionProducer;
	import org.wvxvws.gui.skins.LabelProducer;
	import org.wvxvws.gui.skins.SkinDefaults;
	import org.wvxvws.gui.StatefulButton;
	
	/**
	 * Option class.
	 * @author wvxvw
	 */
	public class Option extends DIV
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
			super.dispatchEvent(new Event("selectedChanged"));
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
			super.dispatchEvent(new Event("disabledChanged"));
		}
		
		//------------------------------------
		//  Public property producer
		//------------------------------------
		
		[Bindable("producerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>producerChanged</code> event.
		*/
		public function get producer():ButtonSkinProducer { return _producer; }
		
		public function set producer(value:ButtonSkinProducer):void 
		{
			if (_producer === value) return;
			_producer = value;
			if (_producer)
			{
				_button.states[UP_STATE] = _producer.produce(_button, UP_STATE);
				_button.states[DOWN_STATE] = _producer.produce(_button, DOWN_STATE);
				_button.states[OVER_STATE] = _producer.produce(_button, OVER_STATE);
				_button.states[SELECTED_STATE] = 
					_producer.produce(_button, SELECTED_STATE);
				_button.states[DISABLED_STATE] = 
					_producer.produce(_button, DISABLED_STATE);
				_button.states[SELECTED_DISABLED_STATE] = 
					_producer.produce(_button, SELECTED_DISABLED_STATE);
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
			super.invalidate("_producer", _producer, false);
			super.dispatchEvent(new Event("producerChanged"));
		}
		
		//------------------------------------
		//  Public property label
		//------------------------------------
		
		[Bindable("labelChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>labelChanged</code> event.
		*/
		public function get label():LabelProducer { return _label; }
		
		public function set label(value:LabelProducer):void 
		{
			if (_label === value) return;
			_label = value;
			super.invalidate("_label", _label, false);
			super.dispatchEvent(new Event("labelChanged"));
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
			super.dispatchEvent(new Event("labelPlacementChanged"));
		}
		
		protected var _selected:Boolean;
		protected var _disabled:Boolean;
		
		protected var _label:LabelProducer;
		protected var _labelPlacement:int = 4;
		protected var _labelField:TextField = new TextField();
		protected var _gutter:int = 5;
		
		protected var _button:StatefulButton = new StatefulButton();
		protected var _producer:ButtonSkinProducer;
		
		public function Option() 
		{
			super();
			this.producer = new DefaultOptionProducer();
			_button.addEventListener(
				MouseEvent.CLICK, button_clickHandler, false, int.MAX_VALUE);
			_labelField.multiline = false;
			_labelField.wordWrap = false;
			_labelField.selectable = false;
			_labelField.mouseEnabled = false;
			_labelField.autoSize = TextFieldAutoSize.LEFT;
			_labelField.defaultTextFormat = SkinDefaults.DARK_FORMAT;
			super.addChild(_labelField);
		}
		
		protected function button_clickHandler(event:MouseEvent):void 
		{
			if (_disabled) return;
			this.selected = !_selected;
		}
		
		public override function validate(properties:Object):void 
		{
			var placementChanged:Boolean = ("_labelPlacement" in properties);
			super.validate(properties);
			if (!super.contains(_button))
			{
				_button.initialized(this, "button");
				_button.state = _disabled ? DISABLED_STATE : UP_STATE;
				placementChanged = true;
			}
			if (placementChanged)
			{
				switch (_labelPlacement)
				{
					case 1:
						_labelField.x = 0;
						_labelField.y = 0;
						_button.x = _labelField.width >> 1;
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
						_button.x = _labelField.width >> 1;
						_button.y = 0;
						break;
				}
			}
		}
	}

}