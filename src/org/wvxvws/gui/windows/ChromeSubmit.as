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
	import org.wvxvws.gui.layout.Invalides;
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
		public function get defaultKey():uint { return this._defaultKey; }
		
		public function set defaultKey(value:uint):void 
		{
			if (this._defaultKey === value) return;
			this._defaultKey = value;
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
		public function get format():TextFormat { return this._field.defaultTextFormat; }
		
		public function set format(value:TextFormat):void 
		{
			if (this._field.defaultTextFormat === value) return;
			this._field.defaultTextFormat = value;
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
		public function get skin():Vector.<ISkin> { return this._submit.skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (this._submit.skin === value) return;
			this._submit.skin = value;
			if (super.hasEventListener(EventGenerator.getEventType("skin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		/* INTERFACE org.wvxvws.gui.renderers.ILabel */
		
		public function get text():String { return this._field.text; }
		
		public function set text(value:String):void { this._field.text = value; }
		
		//------------------------------------
		//  Public property userActionHandler
		//------------------------------------
		
		[Bindable("userActionHandlerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>userActionHandlerChanged</code> event.
		*/
		public function get userActionHandler():Function
		{
			return this._userActionHandler;
		}
		
		public function set userActionHandler(value:Function):void 
		{
			if (this._userActionHandler === value) return;
			this._userActionHandler = value;
			if (super.hasEventListener(EventGenerator.getEventType("userActionHandler")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get field():SPAN { return this._field; }
		
		public function get submit():Button { return this._submit; }
		
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
			this._userActionHandler = actionHandler;
			this._field.type = TextFieldType.INPUT;
		}
		
		public override function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			if (!this._skin) this.skin = SkinManager.getSkin(this);
		}
		
		public override function validate(properties:Dictionary):void 
		{
			var sizeChanged:Boolean = (Invalides.BOUNDS in properties);
			super.validate(properties);
			var bw:int = this._buttonWidth;
			var tw:int = this._bounds.x - (bw + _gutter);
			if (sizeChanged || !super.contains(_field) || !super.contains(this._submit))
			{
				if (this._minSpanWidth + this._minButtonWidth + this._gutter > 
					super._bounds.x)
				{
					super._bounds.x = 
						this._minSpanWidth + this._minButtonWidth + this._gutter;
					super.drawBackground();
					bw = this._minButtonWidth;
					tw = this._minSpanWidth;
				}
				else if (this._buttonWidth + this._minSpanWidth + this._gutter > 
					super._bounds.x)
				{
					bw = super._bounds.x - (this._gutter + this._minSpanWidth);
					tw = super._bounds.x - bw;
				}
				this._field.y = 1;
				this._field.width = tw;
				this._field.height = super._bounds.y - 3;
				this._field.addEventListener(
					FocusEvent.FOCUS_IN, this.field_focusInHandler);
				this._field.addEventListener(
					FocusEvent.FOCUS_OUT, this.field_focusOutHandler);
				var f:TextFormat = TextFormatDefaults.defaultFormat;
				f.leftMargin = 5;
				f.rightMargin = 5;
				this._field.defaultTextFormat = f;
				this._field.border = true;
				this._field.borderColor = TextFormatDefaults.defaultBorderColor;
				if (!super.contains(this._field))
				{
					// TODO: don't set it after default is not null
					this._field.defaultTextFormat = TextFormatDefaults.defaultFormat;
					this._field.initialized(this, "input");
				}
				
				this._submit.width = bw;
				this._submit.height = super._bounds.y;
				this._submit.x = tw + this._gutter;
				this._submit.addEventListener(
					MouseEvent.CLICK, this.subimt_clickHandler);
				if (!super.contains(this._submit))
					this._submit.initialized(this, "submit");
			}
		}
		
		protected function field_focusOutHandler(event:FocusEvent):void 
		{
			super.stage.removeEventListener(
				KeyboardEvent.KEY_UP, this.stage_keyUpHandler);
		}
		
		protected function stage_keyUpHandler(event:KeyboardEvent):void 
		{
			if (event.keyCode === _defaultKey) this.subimt_clickHandler();
		}
		
		protected function field_focusInHandler(event:FocusEvent):void 
		{
			super.stage.addEventListener(
				KeyboardEvent.KEY_UP, this.stage_keyUpHandler, false, 0, true);
		}
		
		protected function subimt_clickHandler(event:MouseEvent = null):void 
		{
			if (this._userActionHandler !== null)
				this._userActionHandler(this._field.text);
		}
	}
}