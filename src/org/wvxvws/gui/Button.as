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
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	import org.wvxvws.gui.skins.SkinManager;
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	[Exclude(type="property", name="hitTestState")]
	
	[Skin("org.wvxvws.skins.ButtonSkin")]
	
	/**
	 * Button class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Button extends SimpleButton 
						implements IMXMLObject, ILayoutClient, ISkinnable
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.skins.ISkinnable */
		
		public function get parts():Object { return null; }
		
		public function set parts(value:Object):void { }
		
		//------------------------------------
		//  Public property skin
		//------------------------------------
		
		[Bindable("skinChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>skinChanged</code> event.
		*/
		public function get skin():Vector.<ISkin> { return this._skin; }
		
		public function set skin(value:Vector.<ISkin>):void
		{
			if (this._skin === value) return;
			this._skin = value;
			if (this._skin && this._skin.length && this._skin[0])
			{
				super.upState = this._skin[0].produce(this, "upState") as DisplayObject;
				super.overState = this._skin[0].produce(this, "overState") as DisplayObject;
				super.downState = this._skin[0].produce(this, "downState") as DisplayObject;
				if (super.upState)
				{
					super.upState.addEventListener(
						Event.ADDED, this.addedHandler, false, 0, true);
				}
				if (super.overState)
				{
					super.overState.addEventListener(
						Event.ADDED, this.addedHandler, false, 0, true);
				}
				if (super.downState)
				{
					super.downState.addEventListener(
						Event.ADDED, this.addedHandler, false, 0, true);
				}
			}
			else
			{
				super.upState = null;
				super.overState = null;
				super.downState = null;
			}
			this.invalidate(Invalides.SKIN, true);
			if (super.hasEventListener(EventGenerator.getEventType("skin")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public override function get hitTestState():DisplayObject { return null; }
		
		public override function set hitTestState(value:DisplayObject):void { }
		
		public override function set upState(value:DisplayObject):void
		{
			if (value)
				value.addEventListener(
					Event.ADDED, this.addedHandler, false, 0, true);
			super.upState = value;
		}
		
		public override function set downState(value:DisplayObject):void
		{
			if (value)
				value.addEventListener(
					Event.ADDED, this.addedHandler, false, 0, true);
			super.downState = value;
		}
		
		public override function set overState(value:DisplayObject):void
		{
			if (value)
				value.addEventListener(
					Event.ADDED, this.addedHandler, false, 0, true);
			super.overState = value;
		}
		
		//------------------------------------
		//  Public property x
		//------------------------------------
		
		[Bindable("xChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>xChanged</code> event.
		*/
		public override function get x():Number { return this._transformMatrix.tx; }
		
		public override function set x(value:Number):void 
		{
			if (this._transformMatrix.tx === value) return;
			this._transformMatrix.tx = value;
			this.invalidate(Invalides.TRANSFORM, true);
			if (super.hasEventListener(EventGenerator.getEventType("x")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property y
		//------------------------------------
		
		[Bindable("yChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>yChanged</code> event.
		*/
		public override function get y():Number { return this._transformMatrix.ty; }
		
		public override function set y(value:Number):void 
		{
			if (this._transformMatrix.ty === value) return;
			this._transformMatrix.ty = value;
			this.invalidate(Invalides.TRANSFORM, true);
			if (super.hasEventListener(EventGenerator.getEventType("y")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public override function get width():Number { return this._bounds.x; }
		
		public override function set width(value:Number):void 
		{
			if (this._bounds.x === value) return;
			this._bounds.x = value;
			this.invalidate(Invalides.BOUNDS, true);
			if (super.hasEventListener(EventGenerator.getEventType("width")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public override function get height():Number { return this._bounds.y; }
		
		public override function set height(value:Number):void 
		{
			if (this._bounds.y === value) return;
			this._bounds.y = value;
			this.invalidate(Invalides.BOUNDS, true);
			if (super.hasEventListener(EventGenerator.getEventType("height")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public override function get scaleX():Number { return this._transformMatrix.a; }
		
		public override function set scaleX(value:Number):void 
		{
			if (this._transformMatrix.a === value) return;
			this._transformMatrix.a = value;
			this.invalidate(Invalides.TRANSFORM, true);
			if (super.hasEventListener(EventGenerator.getEventType("scaleX")))
				super.dispatchEvent(EventGenerator.getEvent());
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
		public override function get scaleY():Number { return this._transformMatrix.d; }
		
		public override function set scaleY(value:Number):void 
		{
			if (this._transformMatrix.d === value) return;
			this._transformMatrix.d = value;
			this.invalidate(Invalides.TRANSFORM, true);
			if (super.hasEventListener(EventGenerator.getEventType("scaleY")))
				super.dispatchEvent(EventGenerator.getEvent());
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
			return this._userTransform ? this._userTransform : super.transform;
		}
		
		public override function set transform(value:Transform):void 
		{
			this._userTransform = value;
			this.invalidate(Invalides.TRANSFORM, true);
			if (super.hasEventListener(EventGenerator.getEventType("transform")))
				super.dispatchEvent(EventGenerator.getEvent());
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
			if (this._label.text === value) return;
			this._label.text = value;
			this._label.x = -0.5 * this._label.width;
			this._label.y = -0.5 * this._label.height;
			this.invalidate(Invalides.TEXT, false);
			if (super.hasEventListener(EventGenerator.getEventType("label")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return this._validator; }
		
		public function get invalidProperties():Dictionary
		{
			return this._invalidProperties;
		}
		
		public function get layoutParent():ILayoutClient { return this._layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			if (this._layoutParent === value) return;
			this._layoutParent = value;
			if (this._layoutParent)
			{
				this._validator = this._layoutParent.validator;
				if (this._validator) this._validator.append(this, this._layoutParent);
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
		protected var _invalidProperties:Dictionary = new Dictionary();
		
		protected var _invalidLayout:Boolean;
		
		protected var _hitState:Shape = new Shape();
		protected var _hitGraphics:Graphics;
		protected var _bounds:Point = new Point();
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _userTransform:Transform;
		protected var _nativeTransform:Transform;
		protected var _lastState:DisplayObject;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11, 0, true);
		protected var _skin:Vector.<ISkin>;
		
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
			super.addEventListener(Event.ADDED, this.addedHandler);
			
			this._nativeTransform = new Transform(this);
			this._label.width = 1;
			this._label.height = 1;
			this._label.autoSize = TextFieldAutoSize.LEFT;
			this._label.defaultTextFormat = this._labelFormat;
			this._label.selectable = false;
			this._label.tabEnabled = false;
			this._labelSprite.addChild(_label);
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
			var validatorChanged:Boolean;
			this._document = document;
			if (this._document is ILayoutClient)
			{
				this._validator = (_document as ILayoutClient).validator;
				validatorChanged = Boolean(this._validator);
				if (validatorChanged)
					this._validator.append(this, this._document as ILayoutClient);
			}
			if (this._document is DisplayObjectContainer && !super.parent)
			{
				(this._document as DisplayObjectContainer).addChild(this);
			}
			this._id = id;
			if (!this._skin) this.skin = SkinManager.getSkin(this);
			if (validatorChanged) this.invalidate(Invalides.NULL, false);
		}
		
		public function validate(properties:Dictionary):void
		{
			if (!this._validator)
			{
				if (this._document is ILayoutClient)
				{
					this._validator = (this._document as ILayoutClient).validator;
					this._layoutParent = this._document as ILayoutClient;
					if ((this._document as ILayoutClient).childLayouts.indexOf(this) < 0)
					{
						(this._document as ILayoutClient).childLayouts.push(this);
					}
				}
			}
			else if (parent is ILayoutClient && !this._validator)
			{
				this._validator = (parent as ILayoutClient).validator;
				this._layoutParent = parent as ILayoutClient;
				if ((parent as ILayoutClient).childLayouts.indexOf(this) < 0)
				{
					(parent as ILayoutClient).childLayouts.push(this);
				}
			}
			if (!this._validator) this._validator = new LayoutValidator();
			this._validator.append(this, this._layoutParent);
			if (Invalides.BOUNDS in properties) this.drawHitState();
			if (Invalides.TRANSFORM in properties)
			{
				if (this._userTransform)
				{
					super.transform = this._userTransform;
					this._userTransform = null;
				}
				else _nativeTransform.matrix = this._transformMatrix;
				
			}
			if (!this._document) 
			{
				this._document = this;
				//this.initStyles();
				super.dispatchEvent(GUIEvent.INITIALIZED);
			}
			this._invalidProperties = new Dictionary();
			this._invalidLayout = false;
			super.dispatchEvent(GUIEvent.VALIDATED);
		}
		
		public function invalidate(property:Invalides, validateParent:Boolean):void
		{
			this._invalidProperties[property] = true;
			if (this._validator) this._validator.requestValidation(this, validateParent);
			this._invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function drawHitState():Shape
		{
			this._hitGraphics = this._hitState.graphics;
			this._hitGraphics.clear();
			this._hitGraphics.beginFill(0);
			this._hitGraphics.drawRect(0, 0, this._bounds.x, this._bounds.y);
			this._hitGraphics.endFill();
			return this._hitState;
		}
		
		protected function addedHandler(event:Event):void 
		{
			switch (event.target)
			{
				case super.downState:
				case super.upState:
				case super.overState:
					this._lastState = event.target as DisplayObject;
					if (this._lastState)
					{
						if (this._lastState is DisplayObjectContainer)
						{
							if (this._labelSprite.parent) 
								this._labelSprite.parent.removeChild(this._labelSprite);
							this._lastState.width = this._bounds.x;
							this._lastState.height = this._bounds.y;
							
							this._labelSprite.scaleX = 1 / this._lastState.scaleX;
							this._labelSprite.scaleY = 1 / this._lastState.scaleY;
							
							this._labelSprite.x = 
								(this._lastState.width / this._lastState.scaleX) * 0.5;
							this._labelSprite.y = 
								(this._lastState.height / this._lastState.scaleY) * 0.5;
							(this._lastState as 
								DisplayObjectContainer).addChild(this._labelSprite);
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