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
	import flash.utils.Dictionary;
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.containers.ChromeWindow;
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
		protected var _userActionHandler:Function;
		protected var _field:TextField = new TextField();
		
		public function ChromeAlert(message:String = null, 
									actionHandler:Function = null,
									ok:Boolean = true, cancel:Boolean = true) 
		{
			super();
			this._field.width = 1;
			this._field.height = 1;
			var f:TextFormat = TextFormatDefaults.defaultFormat;
			f.align = TextFormatAlign.CENTER;
			this._field.defaultTextFormat = f;
			this._field.multiline = true;
			this._field.wordWrap = true;
			super._contentPane.addChild(this._field);
			if (message !== null) 
			{
				this._message = message;
				this._field.text = message;
			}
			this._userActionHandler = actionHandler;
			super._contentPane.gutterH = 10;
			super._contentPane.padding = new Rectangle(5, 5, 0, 0);
			if (ok)
			{
				this._okButton = new Button("OK");
				this._okButton.width = 100;
				this._okButton.height = 24;
				this._okButton.initialized(super._contentPane, "ok");
				this._okButton.addEventListener(MouseEvent.CLICK, 
								this.button_clickHandler, false, 0, true);
			}
			if (cancel)
			{
				this._cancelButton = new Button("Cancel");
				this._cancelButton.width = 100;
				this._cancelButton.height = 24;
				this._cancelButton.initialized(super._contentPane, "cancel");
				this._cancelButton.addEventListener(MouseEvent.CLICK, 
								this.button_clickHandler, false, 0, true);
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
		
		public override function validate(properties:Dictionary):void
		{
			super.validate(properties);
			var fieldHeight:int;
			var middle:int;
			if (this._okButton || this._cancelButton)
			{
				if (this._okButton)
				{
					fieldHeight = this._okButton.height;
					this._okButton.y = super._contentPane.height - 
						(this._okButton.height + super._contentPane.padding.bottom);
				}
				if (this._cancelButton)
				{
					fieldHeight = Math.max(fieldHeight, this._cancelButton.height);
					this._cancelButton.y = 
						super._contentPane.height - (this._cancelButton.height + 
						super._contentPane.padding.bottom);
				}
				middle = 
					(super._contentPane.width - (super._contentPane.padding.left + 
					super._contentPane.padding.right)) >> 1;
				if (this._okButton && this._cancelButton)
				{
					this._okButton.x = 
						middle - (this._okButton.width + 
						super._contentPane.gutterH * 0.5);
					this._cancelButton.x = middle + super._contentPane.gutterH * 0.5;
				}
				else if (this._okButton)
				{
					this._okButton.x = middle - (this._okButton.width >> 1);
				}
				else this._cancelButton.x = middle - (this._cancelButton.width >> 1);
				if (this._okButton) 
					this._okButton.validate(this._okButton.invalidProperties);
				if (this._cancelButton) 
					this._cancelButton.validate(this._cancelButton.invalidProperties);
				fieldHeight = super._contentPane.height - 
					(fieldHeight + super._contentPane.padding.bottom);
				this._field.height = fieldHeight;
				this._field.width = 
					super._contentPane.width - (super._contentPane.padding.left + 
					super._contentPane.padding.right);
				this._field.x = super._contentPane.padding.left;
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
			if (this._userActionHandler === null) return;
			this._userActionHandler(event.currentTarget === this._okButton);
			WindowManager.destroy(this);
		}
	}
}