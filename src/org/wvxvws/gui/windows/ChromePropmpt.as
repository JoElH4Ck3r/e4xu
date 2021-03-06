﻿package org.wvxvws.gui.windows 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.containers.ChromeWindow;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.renderers.ILabel;
	import org.wvxvws.gui.skins.TextFormatDefaults;
	import org.wvxvws.managers.WindowManager;
	
	/**
	 * ChromePropmpt class.
	 * @author wvxvw
	 */
	public class ChromePropmpt extends ChromeWindow
	{
		protected var _userActionHandler:Function;
		protected var _fields:Vector.<ILabel> = new <ILabel>[];
		protected var _submitBTN:Button;
		
		public function ChromePropmpt(inputs:Vector.<ILabel> = null, 
							actionHandler:Function = null, submit:Boolean = true) 
		{
			super();
			this._userActionHandler = actionHandler;
			var tb:ChromeBar = new ChromeBar();
			tb.label = "Prompt";
			tb.height = 24;
			tb.backgroundAlpha = 1;
			tb.backgroundColor = TextFormatDefaults.defaultChromeBack;
			tb.initialized(this, "titleBar");
			super.titleBar = tb;
			super._contentPane.padding = new Rectangle(10, 10, 0, 0);
			var i:int;
			var j:int;
			var label:ILabel;
			super._contentPane.performLayout = true;
			super._contentPane.direction = false;
			super._contentPane.distribute = 1;
			super._contentPane.gutterV = 4;
			if (inputs)
			{
				j = inputs.length;
				while (i < j)
				{
					label = inputs[i];
					if (this._fields.indexOf(label) < 0) this._fields.push(label);
					if (label is IMXMLObject)
					{
						(label as IMXMLObject).initialized(super._contentPane, "label" + i);
					}
					else super._contentPane.addChild(label as DisplayObject);
					i++;
				}
			}
			if (submit)
			{
				this._submitBTN = new Button("Submit");
				this._submitBTN.width = 60;
				this._submitBTN.height = 24;
				this._submitBTN.initialized(_contentPane, "submit");
				this._submitBTN.addEventListener(
					MouseEvent.CLICK, this.submit_clickHandler, false, 0, true);
			}
			super.backgroundAlpha = 1;
		}
		
		protected function submit_clickHandler(event:MouseEvent):void
		{
			if (this._userActionHandler !== null)
			{
				var v:Vector.<String> = new <String>[];
				var i:int;
				var j:int = this._fields.length;
				while (i < j)
				{
					v.push(this._fields[i].text);
					i++;
				}
				this._userActionHandler(v);
			}
		}
		
		public static function show(inputs:Vector.<ILabel>, 
									actionHandler:Function = null,
									context:DisplayObjectContainer = null, 
									metrics:Rectangle = null):ChromePropmpt
		{
			var p:ChromePropmpt = new ChromePropmpt(inputs, actionHandler);
			if (!metrics) metrics = new Rectangle(0, 0, 400, 200);
			return WindowManager.append(p, context, metrics) as ChromePropmpt;
		}
		
		public override function created():void 
		{
			super.x = (super.parent.width - super.width) >> 1;
			super.y = (super.parent.height - super.height) >> 1;
		}
		
		public override function validate(properties:Dictionary):void 
		{
			var i:int;
			var j:int;
			var label:ILabel;
			var sizeChanged:Boolean = (Invalides.BOUNDS in properties) || 
				(Invalides.TRANSFORM in properties);
			super.validate(properties);
			if (sizeChanged)
			{
				j = this._fields.length;
				while (i < j)
				{
					label = this._fields[i];
					(label as DisplayObject).width = 
						super._contentPane.width - 
						(super._contentPane.padding.left + 
						super._contentPane.padding.right);
					i++;
				}
				super._contentPane.constrain();
				this._submitBTN.validate(this._submitBTN.invalidProperties);
			}
		}
	}
}