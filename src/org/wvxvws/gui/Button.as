package org.wvxvws.gui 
{
	//{ imports
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import mx.core.IMXMLObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	import org.wvxvws.gui.skins.DefaultButonProducer;
	import org.wvxvws.gui.skins.SkinProducer;
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	[Exclude(type="property", name="hitTestState")]
	
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
		
		public override function set upState(value:DisplayObject):void
		{
			if (value) value.addEventListener(Event.ADDED, addedHandler, false, 0, true);
			super.upState = value;
		}
		
		public override function set downState(value:DisplayObject):void
		{
			if (value) value.addEventListener(Event.ADDED, addedHandler, false, 0, true);
			super.downState = value;
		}
		
		public override function set overState(value:DisplayObject):void
		{
			if (value) value.addEventListener(Event.ADDED, addedHandler, false, 0, true);
			super.overState = value;
		}
		
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
		//  Public property transform
		//------------------------------------
		
		[Bindable("transformChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>transformChanged</code> event.
		*/
		public override function get transform():Transform
		{
			return _userTransform ? _userTransform : super.transform;
		}
		
		public override function set transform(value:Transform):void 
		{
			invalidate("_userTransform", _userTransform, true);
			_userTransform = value;
			super.dispatchEvent(new Event("transformChanged"));
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
			_label.x = -0.5 * _label.width;
			_label.y = -0.5 * _label.height;
			this.invalidate("_label", _label.text, false);
			super.dispatchEvent(new Event("labelChanged"));
		}
		
		//------------------------------------
		//  Public property producer
		//------------------------------------
		
		[Bindable("producerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>producerChanged</code> event.
		*/
		public function get producer():ButtonSkinProducer { return _producer; }
		
		public function set producer(value:ButtonSkinProducer):void 
		{
			if (_producer == value) return;
			_producer = value;
			if (_producer)
			{
				super.upState = _producer.produce(this, "upState");
				super.overState = _producer.produce(this, "overState");
				super.downState = _producer.produce(this, "downState");
				if (super.upState)
				{
					super.upState.addEventListener(
						Event.ADDED, addedHandler, false, 0, true);
				}
				if (super.overState)
				{
					super.overState.addEventListener(
						Event.ADDED, addedHandler, false, 0, true);
				}
				if (super.downState)
				{
					super.downState.addEventListener(
						Event.ADDED, addedHandler, false, 0, true);
				}
			}
			else
			{
				super.upState = null;
				super.overState = null;
				super.downState = null;
			}
			this.invalidate("_producer", _producer, false);
			super.dispatchEvent(new Event("producerChanged"));
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
			if (cs && cs.parent) return cs;
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
		protected var _labelSprite:Sprite = new Sprite();
		protected var _validator:LayoutValidator;
		protected var _layoutParent:ILayoutClient;
		protected var _invalidProperties:Object = { };
		
		protected var _producer:ButtonSkinProducer;
		protected var _invalidLayout:Boolean;
		
		protected var _hitState:Shape = new Shape();
		protected var _hitGraphics:Graphics;
		protected var _bounds:Point = new Point();
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _userTransform:Transform;
		protected var _nativeTransform:Transform;
		protected var _lastState:DisplayObject;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11, 0, true);
		
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
		
		public function Button(label:String = null) 
		{
			super();
			super.hitTestState = this.drawHitState();
			super.addEventListener(Event.ADDED, addedHandler);
			_nativeTransform = new Transform(this);
			_label.width = 1;
			_label.height = 1;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.defaultTextFormat = _labelFormat;
			_label.selectable = false;
			_label.tabEnabled = false;
			_labelSprite.addChild(_label);
			if (label) this.label = label;
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
			if (_document is ILayoutClient)
			{
				_validator = (_document as ILayoutClient).validator;
				if (_validator)
					_validator.append(this, _document as ILayoutClient);
			}
			if (_document is DisplayObjectContainer)
			{
				(_document as DisplayObjectContainer).addChild(this);
			}
			_id = id;
			if (!_producer) this.producer = new DefaultButonProducer();
		}
		
		public function validate(properties:Object):void
		{
			if (!_validator)
			{
				if (_document is ILayoutClient)
				{
					_validator = (_document as ILayoutClient).validator;
					_layoutParent = _document as ILayoutClient;
					if ((_document as ILayoutClient).childLayouts.indexOf(this) < 0)
					{
						(_document as ILayoutClient).childLayouts.push(this);
					}
				}
			}
			else if (parent is ILayoutClient && !_validator)
			{
				_validator = (parent as ILayoutClient).validator;
				_layoutParent = parent as ILayoutClient;
				if ((parent as ILayoutClient).childLayouts.indexOf(this) < 0)
				{
					(parent as ILayoutClient).childLayouts.push(this);
				}
			}
			if (!_validator) _validator = new LayoutValidator();
			_validator.append(this, _layoutParent);
			if (properties._bounds !== undefined) this.drawHitState();
			if (properties._userTransform) super.transform = _userTransform;
			else if (properties._transformMatrix)
			{
				_nativeTransform.matrix = _transformMatrix;
			}
			if (!_document) 
			{
				_document = this;
				//this.initStyles();
				super.dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
			}
			_invalidProperties = { };
			_invalidLayout = false;
			super.dispatchEvent(new GUIEvent(GUIEvent.VALIDATED));
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
		
		protected function drawHitState():Shape
		{
			_hitGraphics = _hitState.graphics;
			_hitGraphics.clear();
			_hitGraphics.beginFill(0);
			_hitGraphics.drawRect(0, 0, _bounds.x, _bounds.y);
			_hitGraphics.endFill();
			return _hitState;
		}
		
		protected function addedHandler(event:Event):void 
		{
			switch (event.target)
			{
				case super.downState:
				case super.upState:
				case super.overState:
					_lastState = event.target as DisplayObject;
					if (_lastState)
					{
						if (_lastState is DisplayObjectContainer)
						{
							if (_labelSprite.parent) 
								_labelSprite.parent.removeChild(_labelSprite);
							_lastState.width = _bounds.x;
							_lastState.height = _bounds.y;
							
							_labelSprite.scaleX = 1 / _lastState.scaleX;
							_labelSprite.scaleY = 1 / _lastState.scaleY;
							
							_labelSprite.x = 
								(_lastState.width / _lastState.scaleX) * 0.5;
							_labelSprite.y = 
								(_lastState.height / _lastState.scaleY) * 0.5;
							(_lastState as 
								DisplayObjectContainer).addChild(_labelSprite);
						}
					}
					break;
			}
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}