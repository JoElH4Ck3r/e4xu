package org.wvxvws.gui 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import mx.core.IMXMLObject;
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* Control class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Control extends Sprite implements IMXMLObject
	{
		protected var _document:Object;
		protected var _id:String;
		protected var _invalidLayout:Boolean;
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _bounds:Point = new Point(100, 100);
		protected var _nativeTransform:Transform;
		protected var _userTransform:Transform;
		protected var _background:Graphics;
		protected var _backgroundColor:uint = 0x999999;
		protected var _backgroundAlpha:Number = 0;
		protected var _children:Array = [];
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		override public function get x():Number { return _transformMatrix.tx; }
		
		override public function set x(value:Number):void 
		{
			if (_transformMatrix.tx == value) return;
			_transformMatrix.tx = value;
			invalidLayout = true;
		}
		
		override public function get y():Number { return _transformMatrix.ty; }
		
		override public function set y(value:Number):void 
		{
			if (_transformMatrix.ty == value) return;
			_transformMatrix.ty = value;
			invalidLayout = true;
		}
		
		override public function get width():Number { return _bounds.x; }
		
		override public function set width(value:Number):void 
		{
			if (_bounds.x == value) return;
			_bounds.x = value;
			invalidLayout = true;
		}
		
		override public function get height():Number { return _bounds.y; }
		
		override public function set height(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			invalidLayout = true;
		}
		
		override public function get scaleX():Number { return _transformMatrix.a; }
		
		override public function set scaleX(value:Number):void 
		{
			if (_transformMatrix.a == value) return;
			_transformMatrix.a = value;
			invalidLayout = true;
		}
		
		override public function get scaleY():Number { return _transformMatrix.d; }
		
		override public function set scaleY(value:Number):void 
		{
			if (_transformMatrix.d == value) return;
			_transformMatrix.d = value;
			invalidLayout = true;
		}
		
		override public function get transform():Transform
		{
			return _userTransform ? _userTransform : super.transform;
		}
		
		override public function set transform(value:Transform):void 
		{
			_userTransform = value;
			invalidLayout = true;
		}
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
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function Control()
		{
			super();
			_nativeTransform = new Transform(this);
			invalidLayout = true;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			if (_document is DisplayObjectContainer)
			{
				(_document as DisplayObjectContainer).addChild(this);
			}
			_id = id;
			invalidLayout = true;
			dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		public function get invalidLayout():Boolean { return _invalidLayout; }
		
		public function set invalidLayout(value:Boolean):void 
		{
			if (value == _invalidLayout) return;
			_invalidLayout = value;
			if (_invalidLayout) addEventListener(Event.ENTER_FRAME, validateLayout);
			else removeEventListener(Event.ENTER_FRAME, validateLayout);
		}
		
		public function get backgroundColor():uint { return _backgroundColor; }
		
		public function set backgroundColor(value:uint):void 
		{
			if (value == _backgroundColor) return;
			_backgroundColor = value;
			invalidLayout = true;
		}
		
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		
		public function set backgroundAlpha(value:Number):void 
		{
			if (value == _backgroundAlpha) return;
			_backgroundAlpha = value;
			invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		public function validateLayout(event:Event = null):void
		{
			if (!_background) _background = graphics;
			_background.clear();
			_background.beginFill(_backgroundColor, _backgroundAlpha);
			_background.drawRect(0, 0, _bounds.x, _bounds.y);
			_background.endFill();
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
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}