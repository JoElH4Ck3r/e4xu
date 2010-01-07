package org.wvxvws.gui.windows 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.renderers.ILabel;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	import org.wvxvws.gui.skins.TextFormatDefaults;
	import org.wvxvws.gui.SPAN;
	
	[DefaultProperty("userActionHandler")]
	
	[Skin("org.wvxvws.skins.ButtonSkin")]
	
	/**
	 * ChromeSubmit class.
	 * @author wvxvw
	 */
	public class ChromeSubmit extends DIV implements ILabel, ISkinnable
	{
		//------------------------------------
		//  Public property defaultKey
		//------------------------------------
		
		[Bindable("defaultKeyChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>defaultKeyChanged</code> event.
		*/
		public function get defaultKey():uint { return _defaultKey; }
		
		public function set defaultKey(value:uint):void 
		{
			if (_defaultKey == value) return;
			_defaultKey = value;
			if (super.hasEventListener(EventGenerator.getEventType("defaultKey")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		//------------------------------------
		//  Public property format
		//------------------------------------
		
		[Bindable("formatChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>formatChanged</code> event.
		*/
		public function get format():TextFormat { return _field.defaultTextFormat; }
		
		public function set format(value:TextFormat):void 
		{
			if (_field.defaultTextFormat == value) return;
			_field.defaultTextFormat = value;
			if (super.hasEventListener(EventGenerator.getEventType("format")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		//------------------------------------
		//  Public property producer
		//------------------------------------
		
		[Bindable("skinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>skinChanged</code> event.
		*/
		public function get skin():Vector.<ISkin> { return _submit.skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (_submit.skin === value) return;
			_submit.skin = value;
			if (super.hasEventListener(EventGenerator.getEventType("skin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		/* INTERFACE org.wvxvws.gui.renderers.ILabel */
		
		public function get text():String { return _field.text; }
		
		public function set text(value:String):void { _field.text = value; }
		
		//------------------------------------
		//  Public property userActionHandler
		//------------------------------------
		
		[Bindable("userActionHandlerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>userActionHandlerChanged</code> event.
		*/
		public function get userActionHandler():Function { return _userActionHandler; }
		
		public function set userActionHandler(value:Function):void 
		{
			if (_userActionHandler == value) return;
			_userActionHandler = value;
			if (super.hasEventListener(EventGenerator.getEventType("userActionHandler")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get field():SPAN { return _field; }
		
		public function get submit():Button { return _submit; }
		
		protected var _field:SPAN = new SPAN();
		protected var _submit:Button = new Button("Submit");
		protected var _userActionHandler:Function;
		protected var _minButtonWidth:uint = 20;
		protected var _buttonWidth:uint = 50;
		protected var _minSpanWidth:uint = 10;
		protected var _gutter:int = 4;
		protected var _defaultKey:uint = Keyboard.ENTER;
		protected var _skin:ISkin;
		
		public function ChromeSubmit(actionHandler:Function = null) 
		{
			super();
			_userActionHandler = actionHandler;
			_field.type = TextFieldType.INPUT;
		}
		
		public override function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			if (!_skin) this.skin = SkinManager.getSkin(this);
		}
		
		public override function validate(properties:Dictionary):void 
		{
			var sizeChanged:Boolean = ("_bounds" in properties);
			super.validate(properties);
			var bw:int = _buttonWidth;
			var tw:int = _bounds.x - (bw + _gutter);
			if (sizeChanged || !super.contains(_field) || !super.contains(_submit))
			{
				if (_minSpanWidth + _minButtonWidth + _gutter > _bounds.x)
				{
					_bounds.x = _minSpanWidth + _minButtonWidth + _gutter;
					super.drawBackground();
					bw = _minButtonWidth;
					tw = _minSpanWidth;
				}
				else if (_buttonWidth + _minSpanWidth + _gutter > _bounds.x)
				{
					bw = _bounds.x - (_gutter + _minSpanWidth);
					tw = _bounds.x - bw;
				}
				_field.y = 1;
				_field.width = tw;
				_field.height = _bounds.y - 3;
				_field.addEventListener(FocusEvent.FOCUS_IN, field_focusInHandler);
				_field.addEventListener(FocusEvent.FOCUS_OUT, field_focusOutHandler);
				var f:TextFormat = TextFormatDefaults.defaultFormat;
				f.leftMargin = 5;
				f.rightMargin = 5;
				_field.defaultTextFormat = f;
				_field.border = true;
				_field.borderColor = TextFormatDefaults.defaultBorderColor;
				if (!super.contains(_field))
				{
					// TODO: don't set it after default is not null
					_field.defaultTextFormat = TextFormatDefaults.defaultFormat;
					_field.initialized(this, "input");
				}
				
				_submit.width = bw;
				_submit.height = _bounds.y;
				_submit.x = tw + _gutter;
				_submit.addEventListener(MouseEvent.CLICK, subimt_clickHandler);
				if (!super.contains(_submit)) _submit.initialized(this, "submit");
			}
		}
		
		protected function field_focusOutHandler(event:FocusEvent):void 
		{
			super.stage.removeEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}
		
		protected function stage_keyUpHandler(event:KeyboardEvent):void 
		{
			if (event.keyCode === _defaultKey) this.subimt_clickHandler();
		}
		
		protected function field_focusInHandler(event:FocusEvent):void 
		{
			super.stage.addEventListener(
				KeyboardEvent.KEY_UP, stage_keyUpHandler, false, 0, true);
		}
		
		protected function subimt_clickHandler(event:MouseEvent = null):void 
		{
			if (_userActionHandler !== null)
				_userActionHandler(_field.text);
		}
	}
}