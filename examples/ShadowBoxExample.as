package tests 
{
	//{ imports
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import org.wvxvws.jsutils.shadowbox.ShadowBoxInterface;
	import org.wvxvws.jsutils.shadowbox.ShadowLink;
	import org.wvxvws.jsutils.shadowbox.ShadowOptions;
	//}
	
	[SWF(width="200", height="200", backgroundColor="0xC0C0C0")]
	
	/**
	 * ShadowBoxExample class.
	 * @author wvxvw
	 * @langversion 3.0
	 * @playerversion 9.0.115
	 */
	public class ShadowBoxExample extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _button:Sprite;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function ShadowBoxExample() 
		{
			super();
			if (stage) init();
			else super.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function button_clickHandler(event:MouseEvent):void 
		{
			var options:ShadowOptions = new ShadowOptions();
			options.animate = false;
			options.animSequence = ShadowOptions.HW;
			options.overlayColor = 0xFF0;
			ShadowBoxInterface.open("resources/avatar.jpg", ShadowBoxInterface.IMG, 
								"Testing Image", "", 150, 150, options);
		}
		
		private function button_mouseOutHandler(event:MouseEvent):void 
		{
			(_button.getChildAt(0) as TextField).filters = [];
		}
		
		private function button_mouseOverHandler(event:MouseEvent):void 
		{
			(_button.getChildAt(0) as TextField).filters = 
				[new DropShadowFilter(1, 90, 0, 0.2, 2, 2)];
		}
		
		private function resizeHandler(event:Event):void 
		{
			_button.x = (stage.stageWidth - _button.width) >> 1;
			_button.y = (stage.stageHeight - _button.height) >> 1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function init(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, resizeHandler);
			
			// This assumes you have resources/avatar.jpg
			// in the same folder as you HTML wrapper file.
			var link:ShadowLink = new ShadowLink("resources/avatar.jpg");
			var links:Array = [link];
			ShadowBoxInterface.setup(links);
			
			_button = drawButton("Display Shadowbox PopUp");
			_button.x = (stage.stageWidth - _button.width) >> 1;
			_button.y = (stage.stageHeight - _button.height) >> 1;
			super.addChild(_button);
			
			_button.addEventListener(MouseEvent.MOUSE_OVER, button_mouseOverHandler);
			_button.addEventListener(MouseEvent.MOUSE_OUT, button_mouseOutHandler);
			_button.addEventListener(MouseEvent.CLICK, button_clickHandler);
		}
		
		private function drawButton(label:String):Sprite
		{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			var t:TextField = new TextField();
			t.width = 1;
			t.height = 1;
			t.selectable = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			var tf:TextFormat = new TextFormat("_sans", 11, 0x606060, true);
			t.defaultTextFormat = tf;
			t.text = label;
			var w:int = t.width + 10;
			var h:int = t.height + 10;
			s.mouseChildren = false;
			t.x = 5;
			t.y = 5;
			g.lineStyle(1, 0xA0A0A0, 1, true, LineScaleMode.NONE);
			g.beginFill(0xA0A0A0, 0.5);
			g.drawRect(0, 0, w, h);
			s.addChild(t);
			s.useHandCursor = true;
			s.buttonMode = true;
			return s;
		}
		
	}
	
}