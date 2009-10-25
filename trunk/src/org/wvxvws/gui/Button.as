package org.wvxvws.gui 
{
	//{ imports
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import mx.core.IMXMLObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.skins.SkinProducer;
	//}
	
	[Exclude(type="property", name="hitTestState")]
	[Exclude(type="property", name="upState")]
	[Exclude(type="property", name="downState")]
	[Exclude(type="property", name="overState")]
	
	/**
	 * Button class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Button extends SimpleButton implements IMXMLObject, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function get hitTestState():DisplayObject { return null; }
		
		public override function set hitTestState(value:DisplayObject):void { }
		
		public override function get upState():DisplayObject { return null; }
		
		public override function set upState(value:DisplayObject):void { }
		
		public override function get downState():DisplayObject { return null; }
		
		public override function set downState(value:DisplayObject):void { }
		
		public override function get overState():DisplayObject { return null; }
		
		public override function set overState(value:DisplayObject):void { }
		
		//------------------------------------
		//  Public property x
		//------------------------------------
		
		[Bindable("xChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>xChange</code> event.
		*/
		public override function get x():Number { return _transformMatrix.tx; }
		
		public override function set x(value:Number):void 
		{
			if (_transformMatrix.tx == value) return;
			_transformMatrix.tx = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("xChange"));
		}
		
		//------------------------------------
		//  Public property y
		//------------------------------------
		
		[Bindable("yChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>yChange</code> event.
		*/
		public override function get y():Number { return _transformMatrix.ty; }
		
		public override function set y(value:Number):void 
		{
			if (_transformMatrix.ty == value) return;
			_transformMatrix.ty = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("yChange"));
		}
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		[Bindable("widthChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>widthChanged</code> event.
		*/
		public override function get width():Number { return _bounds.x; }
		
		public override function set width(value:Number):void 
		{
			if (_bounds.x == value) return;
			_bounds.x = value;
			this.invalidate("_bounds", _bounds, true);
			super.dispatchEvent(new Event("widthChanged"));
		}
		
		//------------------------------------
		//  Public property height
		//------------------------------------
		
		[Bindable("heightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>heightChanged</code> event.
		*/
		public override function get height():Number { return _bounds.y; }
		
		public override function set height(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			this.invalidate("_bounds", _bounds, true);
			super.dispatchEvent(new Event("heightChanged"));
		}
		
		//------------------------------------
		//  Public property scaleX
		//------------------------------------
		
		[Bindable("scaleXChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>scaleXChanged</code> event.
		*/
		public override function get scaleX():Number { return _transformMatrix.a; }
		
		public override function set scaleX(value:Number):void 
		{
			if (_transformMatrix.a == value) return;
			_transformMatrix.a = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("scaleXChanged"));
		}
		
		//------------------------------------
		//  Public property scaleY
		//------------------------------------
		
		[Bindable("scaleYChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>scaleYChanged</code> event.
		*/
		public override function get scaleY():Number { return _transformMatrix.d; }
		
		public override function set scaleY(value:Number):void 
		{
			if (_transformMatrix.d == value) return;
			_transformMatrix.d = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
			super.dispatchEvent(new Event("scaleYChanged"));
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
		public function get label():String { return _label.text; }
		
		public function set label(value:String):void 
		{
			if (_label.text == value) return;
			_label.text = value;
			this.invalidate("_label", _label.text, false);
			super.dispatchEvent(new Event("labelChanged"));
		}
		
		//------------------------------------
		//  Public property upProducer
		//------------------------------------
		
		[Bindable("upProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>upProducerChanged</code> event.
		*/
		public function get upProducer():SkinProducer { return _upProducer; }
		
		public function set upProducer(value:SkinProducer):void 
		{
			if (_upProducer == value) return;
			_upProducer = value;
			if (_upProducer)
			{
				super.upState = _upProducer.produce(this);
				if (super.upState)
				{
					super.upState.addEventListener(
						Event.ADDED, addedHandler, false, 0, true);
				}
			}
			else super.upState = null;
			this.invalidate("_upProducer", _upProducer, false);
			super.dispatchEvent(new Event("upProducerChanged"));
		}
		
		//------------------------------------
		//  Public property overProducer
		//------------------------------------
		
		[Bindable("overProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>overProducerChanged</code> event.
		*/
		public function get overProducer():SkinProducer { return _overProducer; }
		
		public function set overProducer(value:SkinProducer):void 
		{
			if (_overProducer == value) return;
			_overProducer = value;
			if (_overProducer)
			{
				super.overState = _overProducer.produce(this);
				if (super.overState)
				{
					super.overState.addEventListener(
						Event.ADDED, addedHandler, false, 0, true);
				}
			}
			else super.overState = null;
			this.invalidate("_overProducer", _overProducer, false);
			super.dispatchEvent(new Event("overProducerChanged"));
		}
		
		//------------------------------------
		//  Public property downProducer
		//------------------------------------
		
		[Bindable("downProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>downProducerChanged</code> event.
		*/
		public function get downProducer():SkinProducer { return _downProducer; }
		
		public function set downProducer(value:SkinProducer):void 
		{
			if (_downProducer == value) return;
			_downProducer = value;
			if (_downProducer)
			{
				super.downState = _downProducer.produce(this);
				if (super.downState)
				{
					super.downState.addEventListener(
						Event.ADDED, addedHandler, false, 0, true);
				}
			}
			else super.downState = null;
			this.invalidate("_downProducer", _downProducer, false);
			super.dispatchEvent(new Event("downProducerChanged"));
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return _validator; }
		
		public function get invalidProperties():Object { return _invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			if (_layoutParent === value) return;
			_layoutParent = value;
			if (_layoutParent)
			{
				_validator = _layoutParent.validator;
				if (_validator) _validator.append(this, _layoutParent);
			}
		}
		
		public function get childLayouts():Vector.<ILayoutClient> { return null; }
		
		public function get currentState():DisplayObject
		{
			var cs:DisplayObject = super.upState;
			if (cs && cs.parent) return cs;
			cs = super.overState;
			if (cs && cs.parent) return cs;
			cs = super.downState;
			if (cd && cs.parent) return cs;
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _label:TextField = new TextField();
		protected var _validator:LayoutValidator;
		protected var _layoutParent:ILayoutClient;
		protected var _invalidProperties:Object = { };
		
		protected var _upProducer:SkinProducer;
		protected var _overProducer:SkinProducer;
		protected var _downProducer:SkinProducer;
		protected var _invalidLayout:Boolean;
		
		protected var _hitState:Shape = new Shape();
		protected var _hitGraphics:Graphics;
		protected var _bounds:Point = new Point();
		protected var _states:ButtonStates = new ButtonStates();
		protected var _transformMatrix:Matrix = new Matrix();
		
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
		
		public function Button() 
		{
			super(null, null, null, drawHitState());
			super.addEventListener(Event.ADDED, addedHandler);
		}
		
		protected function drawHitState():Shape
		{
			_hitGraphics = _hitState.graphics;
			_hitGraphics.clear();
			_hitGraphics.beginFill(0);
			_hitGraphics.drawRect(0, 0, _bounds.x, _bounds.y);
			_hitGraphics.endFill();
		}
		
		protected function addedHandler(event:Event):void 
		{
			trace(event.target);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function validate(properties:Object):void
		{
			
		}
		
		public function invalidate(property:String, cleanValue:*, 
														validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator) _validator.requestValidation(this, validateParent);
			_invalidLayout = true;
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
import flash.display.DisplayObject;
internal final class ButtonStates
{
	public var upState:DisplayObject;
	public var overState:DisplayObject;
	public var downState:DisplayObject;
	
	public function ButtonStates() { super(); }
}