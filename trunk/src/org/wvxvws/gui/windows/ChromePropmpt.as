package org.wvxvws.gui.windows 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.containers.ChromeWindow;
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
			_userActionHandler = actionHandler;
			var tb:ChromeBar = new ChromeBar();
			tb.label = "Prompt";
			tb.height = 24;
			tb.backgroundAlpha = 1;
			tb.backgroundColor = TextFormatDefaults.defaultChromeBack;
			tb.initialized(this, "titleBar");
			super.titleBar = tb;
			_contentPane.padding = new Rectangle(10, 10, 0, 0);
			var i:int;
			var j:int;
			var label:ILabel;
			_contentPane.performLayout = true;
			_contentPane.direction = false;
			_contentPane.distribute = 1;
			_contentPane.gutterV = 4;
			if (inputs)
			{
				j = inputs.length;
				while (i < j)
				{
					trace("adding field", i);
					label = inputs[i];
					if (_fields.indexOf(label) < 0) _fields.push(label);
					if (label is IMXMLObject)
					{
						(label as IMXMLObject).initialized(_contentPane, "label" + i);
					}
					else
					{
						_contentPane.addChild(label as DisplayObject);
					}
					i++;
				}
			}
			if (submit)
			{
				_submitBTN = new Button("Submit");
				_submitBTN.width = 60;
				_submitBTN.height = 24;
				_submitBTN.initialized(_contentPane, "submit");
				_submitBTN.addEventListener(
					MouseEvent.CLICK, submit_clickHandler, false, 0, true);
			}
			super.backgroundAlpha = 1;
		}
		
		protected function submit_clickHandler(event:MouseEvent):void
		{
			if (_userActionHandler !== null)
			{
				var v:Vector.<String> = new <String>[];
				var i:int;
				var j:int = _fields.length;
				while (i < j)
				{
					trace(_fields[i].text);
					v.push(_fields[i].text);
					i++;
				}
				_userActionHandler(v);
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
		
		public override function validate(properties:Object):void 
		{
			var i:int;
			var j:int;
			var label:ILabel;
			var sizeChanged:Boolean = ("_bounds" in properties);
			super.validate(properties);
			if (sizeChanged)
			{
				j = _fields.length;
				while (i < j)
				{
					label = _fields[i];
					(label as DisplayObject).width = _contentPane.width - 
						(_contentPane.padding.left + _contentPane.padding.right);
					i++;
				}
				_contentPane.constrain();
				_submitBTN.validate(_submitBTN.invalidProperties);
			}
		}
		
	}

}