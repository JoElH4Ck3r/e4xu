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

package org.wvxvws.gui 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.styles.ICSSClient;
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* DIV class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class DIV extends Sprite implements IMXMLObject, ICSSClient, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property x
		//------------------------------------
		
		[Bindable("xChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>xChange</code> event.
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
		* When this property is modified, it dispatches the <code>yChange</code> event.
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
			if (_transformMatrix.a === value) return;
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
			this.invalidate(Invalides.TRANSFORM, true);
			this._userTransform = value;
			if (super.hasEventListener(EventGenerator.getEventType("transform")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("styleChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>styleChanged</code> event.
		*/
		public function get style():IEventDispatcher { return this._style; }
		
		public function set style(value:IEventDispatcher):void 
		{
			if (this._style === value) return;
			this.invalidate(Invalides.STYLE, true);
			this._style = value;
			if (super.hasEventListener(EventGenerator.getEventType("style")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("backgroundColorChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundColorChanged</code> event.
		*/
		public function get backgroundColor():uint { return this._backgroundColor; }
		
		public function set backgroundColor(value:uint):void 
		{
			if (value === this._backgroundColor) return;
			this.invalidate(Invalides.COLOR, false);
			this._backgroundColor = value;
			if (super.hasEventListener(EventGenerator.getEventType("backgroundColor")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("backgroundAlphaChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundAlphaChanged</code> event.
		*/
		public function get backgroundAlpha():Number { return this._backgroundAlpha; }
		
		public function set backgroundAlpha(value:Number):void 
		{
			if (value === this._backgroundAlpha) return;
			this.invalidate(Invalides.COLOR, false);
			this._backgroundAlpha = value;
			if (super.hasEventListener(EventGenerator.getEventType("backgroundAlpha")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.styles.ICSSClient */
		
		public function get className():String { return this._className; }
		
		public function set className(value:String):void
		{
			this._className = value;
			this.initStyles();
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator
		{
			if (!this._validator)
			{
				if (parent is ILayoutClient) 
					this._validator = (parent as ILayoutClient).validator;
				if (parent is Stage)
				{
					this._validator = new LayoutValidator();
					this._validator.append(this);
				}
			}
			return this._validator;
		}
		
		public function get invalidProperties():Dictionary { return this._invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return this._layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			if (this._layoutParent === value) return;
			this._layoutParent = value;
		}
		
		public function get childLayouts():Vector.<ILayoutClient> { return this._childLayouts; }
		
		public function get id():String { return _id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
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
		protected var _style:IEventDispatcher;
		protected var _className:String;
		protected var _invalidProperties:Dictionary = new Dictionary();
		protected var _childLayouts:Vector.<ILayoutClient> = new <ILayoutClient>[];
		protected var _layoutParent:ILayoutClient;
		protected var _validator:LayoutValidator;
		protected var _hasPendingValidation:Boolean;
		protected var _hasPendingParentValidation:Boolean;
		protected var _initialized:Boolean;
		protected var _bindingEvent:Event;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function DIV()
		{
			super();
			var nm:Array = getQualifiedClassName(this).split("::");
			this._className = String(nm.pop());
			this._nativeTransform = new Transform(this);
			this.invalidate(Invalides.NULL, true);
			if (stage) super.addEventListener(Event.ENTER_FRAME, this.deferredInitialize);
			super.addEventListener(Event.REMOVED_FROM_STAGE, this.removedHandler);
			super.addEventListener(Event.ADDED_TO_STAGE, this.adtsHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			var dispatchInit:Boolean;
			if (super.parent && super.parent === this._document)
			{
				this._document = super.parent;
				return;
			}
			else
			{
				dispatchInit = true;
				this._document = document;
				if (document is DisplayObjectContainer && !super.parent)
				{
					this.initStyles();
					(document as DisplayObjectContainer).addChild(this);
				}
			}
			this._id = id;
			if (this._hasPendingValidation) this.validate(this._invalidProperties);
			if (dispatchInit && !this._initialized)
			{
				this._initialized = true;
				super.dispatchEvent(GUIEvent.INITIALIZED);
			}
		}
		
		public function dispose():void
		{
			super.removeEventListener(Event.ENTER_FRAME, this.deferredInitialize);
			super.removeEventListener(Event.REMOVED_FROM_STAGE, this.removedHandler);
			super.removeEventListener(Event.ADDED_TO_STAGE, this.adtsHandler);
			var i:int = super.numChildren;
			var c:DisplayObject;
			while (i--)
			{
				c = super.getChildAt(i);
				if (c is IMXMLObject) (c as IMXMLObject).dispose();
			}
		}
		
		public function validate(properties:Dictionary):void
		{
			if (!this._document) this._validator = new LayoutValidator();
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
			if (!this._background) this._background = graphics;
			if (Invalides.COLOR in properties || Invalides.BOUNDS in properties)
				this.drawBackground();
			if (Invalides.TRANSFORM in properties && this._userTransform)
			{
				super.transform = this._userTransform;
				this._userTransform = null;
			}
			else if (Invalides.TRANSFORM in properties)
			{
				this._nativeTransform.matrix = this._transformMatrix;
			}
			if (!_document && !_initialized) 
			{
				this._initialized = true;
				this._document = this;
				this.initStyles();
				super.dispatchEvent(GUIEvent.INITIALIZED);
			}
			this._invalidProperties = new Dictionary();
			this._invalidLayout = false;
			super.dispatchEvent(GUIEvent.VALIDATED);
		}
		
		public function invalidate(property:Invalides, 
									validateParent:Boolean):void
		{
			this._invalidProperties[property] = true;
			if (this._validator)
				this._validator.requestValidation(this, validateParent);
			else
			{
				this._hasPendingValidation = true;
				this._hasPendingParentValidation = 
							this._hasPendingParentValidation || validateParent;
			}
			this._invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function adtsHandler(event:Event):void 
		{
			var dispatchInit:Boolean;
			if (!this._validator)
			{
				if (super.parent is ILayoutClient)
				{
					this._validator = (super.parent as ILayoutClient).validator;
				}
			}
			if (super.parent && !_document)
			{
				this._document = super.parent;
				dispatchInit = true;
			}
			if (this._hasPendingValidation) this.validate(this._invalidProperties);
			if (dispatchInit) 
			{
				this._initialized = true;
				super.dispatchEvent(GUIEvent.INITIALIZED);
			}
		}
		
		protected function removedHandler(event:Event):void 
		{
			if (this._validator) this._validator.exclude(this);
		}
		
		protected function drawBackground():void
		{
			this._background.clear();
			this._background.beginFill(this._backgroundColor, this._backgroundAlpha);
			this._background.drawRect(0, 0, this._bounds.x, this._bounds.y);
			this._background.endFill();
		}
		
		protected function initStyles():void
		{
			var styleParser:Object;
			var s:String = "org.wvxvws.gui.styles.CSSParser";
			if (ApplicationDomain.currentDomain.hasDefinition(s))
			{
				styleParser = ApplicationDomain.currentDomain.getDefinition(s);
			}
			else return;
			if (styleParser.parsed) styleParser.processClient(this);
			else styleParser.addPendingClient(this);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function deferredInitialize(event:Event):void 
		{
			super.removeEventListener(Event.ENTER_FRAME, this.deferredInitialize);
			if (!this._initialized)
			{
				this._initialized = true;
				super.dispatchEvent(GUIEvent.INITIALIZED);
			}
		}
		
	}
}