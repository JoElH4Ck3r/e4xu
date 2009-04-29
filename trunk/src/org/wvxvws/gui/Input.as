package org.wvxvws.gui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import mx.core.IMXMLObject;
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * TextInput class.
	 * @author wvxvw
	 */
	public class Input extends TextField implements IMXMLObject
	{
		protected var _document:Object;
		protected var _id:String;
		protected var _invalidLayout:Boolean;
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _bounds:Point = new Point(100, 100);
		protected var _nativeTransform:Transform;
		protected var _userTransform:Transform;
		protected var _backgroundColor:uint = 0x999999;
		protected var _text:String = "";
		protected var _autoSize:String = TextFieldAutoSize.LEFT;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		override public function get x():Number { return super.x; }
		
		override public function set x(value:Number):void 
		{
			if (_transformMatrix.tx == value) return;
			_transformMatrix.tx = value;
			invalidLayout = true;
		}
		
		override public function get y():Number { return super.y; }
		
		override public function set y(value:Number):void 
		{
			if (_transformMatrix.ty == value) return;
			_transformMatrix.ty = value;
			invalidLayout = true;
		}
		
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void 
		{
			if (_bounds.x == value) return;
			_bounds.x = value;
			_autoSize = TextFieldAutoSize.NONE;
			invalidLayout = true;
		}
		
		override public function get height():Number { return super.height; }
		
		override public function set height(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			_autoSize = TextFieldAutoSize.NONE;
			invalidLayout = true;
		}
		
		override public function get scaleX():Number { return super.scaleX; }
		
		override public function set scaleX(value:Number):void 
		{
			if (_transformMatrix.a == value) return;
			_transformMatrix.a = value;
			invalidLayout = true;
		}
		
		override public function get scaleY():Number { return super.scaleY; }
		
		override public function set scaleY(value:Number):void 
		{
			if (_transformMatrix.d == value) return;
			_transformMatrix.d = value;
			invalidLayout = true;
		}
		
		override public function get transform():Transform { return super.transform; }
		
		override public function set transform(value:Transform):void 
		{
			_userTransform = value;
			invalidLayout = true;
		}
		
		public override function get backgroundColor():uint { return _backgroundColor; }
		
		public override function set backgroundColor(value:uint):void 
		{
			if (value == _backgroundColor) return;
			_backgroundColor = value;
			invalidLayout = true;
		}
		
		override public function get text():String { return super.text; }
		
		override public function set text(value:String):void 
		{
			if (value == _text) return;
			_text = value;
			invalidLayout = true;
		}
		
		override public function get autoSize():String { return super.autoSize; }
		
		override public function set autoSize(value:String):void 
		{
			if (value == _autoSize) return;
			_autoSize = value;
			invalidLayout = true;
		}
		
		public function Input()
		{
			super();
			_nativeTransform = new Transform(this);
			invalidLayout = true;
			super.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			if (_document is DisplayObjectContainer) 
				(_document as DisplayObjectContainer).addChild(this);
			_id = id;
			invalidLayout = true;
			dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		public function set invalidLayout(value:Boolean):void 
		{
			if (value == _invalidLayout) return;
			_invalidLayout = value;
			if (_invalidLayout) addEventListener(Event.ENTER_FRAME, validateLayout);
			else removeEventListener(Event.ENTER_FRAME, validateLayout);
		}
		
		public function get align():String { return _textFormat.align; }
		
		public function set align(value:String):void 
		{
			if (value == _textFormat.align) return;
			_textFormat.align = value;
			invalidLayout = true;
		}
		
		public function validateLayout(event:Event = null):void
		{
			super.background = true;
			super.backgroundColor = _backgroundColor;
			super.autoSize = _autoSize;
			super.defaultTextFormat = _textFormat;
			super.text = _text;
			if (_autoSize == TextFieldAutoSize.NONE)
			{
				super.width = _bounds.x;
				super.height = _bounds.y;
			}
			if (_userTransform)
			{
				super.transform = _userTransform;
				_userTransform = null;
			}
			else
			{
				_nativeTransform.matrix = _transformMatrix;
			}
			invalidLayout = false;
			dispatchEvent(new GUIEvent(GUIEvent.VALIDATED));
		}
	}
}