package org.wvxvws.gui.windows 
{
	//{ imports
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.containers.ChromeWindow;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	import org.wvxvws.gui.skins.TextFormatDefaults;
	import org.wvxvws.managers.WindowManager;
	//}
	
	/**
	 * ChromeAlert class.
	 * @author wvxvw
	 */
	public class ChromeAlert extends ChromeWindow
	{
		
		protected var _message:String;
		protected var _okButton:Button;
		protected var _cancelButton:Button;
		protected var _producer:ButtonSkinProducer;
		protected var _userActionHandler:Function;
		protected var _field:TextField = new TextField();
		
		public function ChromeAlert(message:String = null, 
									actionHandler:Function = null,
									ok:Boolean = true, cancel:Boolean = true) 
		{
			super();
			_field.width = 1;
			_field.height = 1;
			var f:TextFormat = TextFormatDefaults.defaultFormat;
			f.align = TextFormatAlign.CENTER;
			_field.defaultTextFormat = f;
			_field.multiline = true;
			_field.wordWrap = true;
			_contentPane.addChild(_field);
			if (message !== null) 
			{
				_message = message;
				_field.text = message;
			}
			_userActionHandler = actionHandler;
			_contentPane.gutterH = 10;
			_contentPane.padding = new Rectangle(5, 5, 0, 0);
			if (ok)
			{
				_okButton = new Button("OK");
				_okButton.width = 100;
				_okButton.height = 24;
				_okButton.initialized(_contentPane, "ok");
				_okButton.addEventListener(MouseEvent.CLICK, 
								button_clickHandler, false, 0, true);
			}
			if (cancel)
			{
				_cancelButton = new Button("Cancel");
				_cancelButton.width = 100;
				_cancelButton.height = 24;
				_cancelButton.initialized(_contentPane, "cancel");
				_cancelButton.addEventListener(MouseEvent.CLICK, 
								button_clickHandler, false, 0, true);
			}
			var tb:ChromeBar = new ChromeBar();
			tb.label = "Alert";
			tb.height = 24;
			tb.backgroundAlpha = 1;
			tb.backgroundColor = TextFormatDefaults.defaultChromeBack;
			tb.initialized(this, "titleBar");
			super.titleBar = tb;
			super.backgroundAlpha = 1;
		}
		
		public override function validate(properties:Object):void
		{
			super.validate(properties);
			var fieldHeight:int;
			var middle:int;
			if (_okButton || _cancelButton)
			{
				if (_okButton)
				{
					fieldHeight = _okButton.height;
					_okButton.y = _contentPane.height - 
						(_okButton.height + _contentPane.padding.bottom);
				}
				if (_cancelButton)
				{
					fieldHeight = Math.max(fieldHeight, _cancelButton.height);
					_cancelButton.y = _contentPane.height - 
						(_cancelButton.height + _contentPane.padding.bottom);
				}
				middle = (_contentPane.width - 
						(_contentPane.padding.left + _contentPane.padding.right)) >> 1;
				if (_okButton && _cancelButton)
				{
					_okButton.x = middle - (_okButton.width + _contentPane.gutterH * 0.5);
					_cancelButton.x = middle + _contentPane.gutterH * 0.5;
				}
				else if (_okButton)
				{
					_okButton.x = middle - (_okButton.width >> 1);
				}
				else _cancelButton.x = middle - (_cancelButton.width >> 1);
				if (_okButton) 
					_okButton.validate(_okButton.invalidProperties);
				if (_cancelButton) 
					_cancelButton.validate(_cancelButton.invalidProperties);
				fieldHeight = _contentPane.height - 
					(fieldHeight + _contentPane.padding.bottom);
				_field.height = fieldHeight;
				_field.width = _contentPane.width -  (_contentPane.padding.left + 
					_contentPane.padding.right);
				_field.x = _contentPane.padding.left;
			}
		}
		
		public override function created():void 
		{
			super.x = (super.parent.width - super.width) >> 1;
			super.y = (super.parent.height - super.height) >> 1;
		}
		
		public static function show(message:String = null, 
									actionHandler:Function = null,
									ok:Boolean = true, cancel:Boolean = true, 
									context:DisplayObjectContainer = null, 
									metrics:Rectangle = null):ChromeAlert
		{
			var a:ChromeAlert = new ChromeAlert(message, actionHandler, ok, cancel);
			if (!metrics) metrics = new Rectangle(0, 0, 400, 200);
			return WindowManager.append(a, context, metrics) as ChromeAlert;
		}
		
		protected function button_clickHandler(event:MouseEvent):void 
		{
			if (_userActionHandler === null) return;
			if (event.currentTarget === _okButton)
				_userActionHandler(true);
			else _userActionHandler(false);
			WindowManager.destroy(this);
		}
		
	}

}