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
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.system.ApplicationDomain;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.Invalides;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.renderers.ILabel;
	import org.wvxvws.gui.styles.ICSSClient
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	[DefaultProperty("text")]
	
	/**
	 * TextSPAN class.
	 * @author wvxvw
	 */
	public class SPAN extends TextField implements IMXMLObject, ICSSClient, 
													ILayoutClient, ILabel
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
			if (_bounds.x === value) return;
			this._bounds.x = value;
			this._autoSize = TextFieldAutoSize.NONE;
			this.invalidate(Invalides.BOUNDS, true);
			this.invalidate(Invalides.AUTOSIZE, true);
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
			if (_bounds.y === value) return;
			this._bounds.y = value;
			this._autoSize = TextFieldAutoSize.NONE;
			this.invalidate(Invalides.BOUNDS, true);
			this.invalidate(Invalides.AUTOSIZE, true);
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
		public override function get transform():Transform { return super.transform; }
		
		public override function set transform(value:Transform):void 
		{
			this._userTransform = value;
			this.invalidate(Invalides.TRANSFORM, true);
			if (super.hasEventListener(EventGenerator.getEventType("transform")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property backgroundColor
		//------------------------------------
		
		[Bindable("backgroundColorChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundColorChanged</code> event.
		*/
		public override function get backgroundColor():uint { return this._backgroundColor; }
		
		public override function set backgroundColor(value:uint):void 
		{
			if (value === this._backgroundColor) return;
			this._backgroundColor = value;
			this.invalidate(Invalides.COLOR, true);
			if (super.hasEventListener(EventGenerator.getEventType("backgroundColor")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property background
		//------------------------------------
		
		[Bindable("backgroundChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundChanged</code> event.
		*/
		public override function get background():Boolean { return this._background; }
		
		public override function set background(value:Boolean):void 
		{
			if (value === _background) return;
			this._background = value;
			this.invalidate(Invalides.COLOR, true);
			if (super.hasEventListener(EventGenerator.getEventType("background")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property text
		//------------------------------------
		
		[Bindable("textChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>textChanged</code> event.
		*/
		public override function get text():String { return super.text; }
		
		public override function set text(value:String):void 
		{
			if (value === this._text) return;
			this._text = value;
			this.invalidate(Invalides.TEXT, true);
			if (super.hasEventListener(EventGenerator.getEventType("text")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property autoSize
		//------------------------------------
		
		[Bindable("autoSizeChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>autoSizeChanged</code> event.
		*/
		public override function get autoSize():String { return super.autoSize; }
		
		public override function set autoSize(value:String):void 
		{
			if (value === this._autoSize) return;
			this._autoSize = value;
			this.invalidate(Invalides.AUTOSIZE, true);
			if (super.hasEventListener(EventGenerator.getEventType("autoSize")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		//------------------------------------
		//  Public property autoSize
		//------------------------------------
		
		[Bindable("alignChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>alignChanged</code> event.
		*/
		public function get align():String { return this._textFormat.align; }
		
		public function set align(value:String):void 
		{
			if (value == this._textFormat.align) return;
			this._textFormat.align = value;
			this.invalidate(Invalides.TEXTFORMAT, true);
			if (super.hasEventListener(EventGenerator.getEventType("align")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.styles.ICSSClient */
		
		public function get className():String { return this._className; }
		
		public function set className(value:String):void { this._className = value; }
		
		public function get style():IEventDispatcher { return this._style; }
		
		public function set style(value:IEventDispatcher):void
		{
			this._style = value;
		}
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return this._validator; }
		
		public function get invalidProperties():Dictionary
		{
			return this._invalidProperties;
		}
		
		public function get layoutParent():ILayoutClient
		{
			return this._layoutParent;
		}
		
		public function set layoutParent(value:ILayoutClient):void
		{
			this._layoutParent = value;
		}
		
		public function get childLayouts():Vector.<ILayoutClient>
		{
			return this._childLayouts;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _transformMatrix:Matrix = new Matrix();
		protected var _bounds:Point = new Point(100, 100);
		protected var _nativeTransform:Transform;
		protected var _userTransform:Transform;
		protected var _backgroundColor:uint = 0x999999;
		protected var _background:Boolean;
		protected var _text:String = "";
		protected var _autoSize:String = TextFieldAutoSize.LEFT;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 12, 0xFFFFFF);
		protected var _className:String;
		protected var _style:IEventDispatcher;
		protected var _invalidProperties:Dictionary = new Dictionary();
		protected var _childLayouts:Vector.<ILayoutClient> = new <ILayoutClient>[];
		protected var _layoutParent:ILayoutClient;
		protected var _validator:LayoutValidator;
		protected var _hasPendingValidation:Boolean;
		protected var _hasPendingParentValidation:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SPAN()
		{
			super();
			var nm:Array = getQualifiedClassName(this).split("::");
			this._className = String(nm.pop());
			this._nativeTransform = new Transform(this);
			super.autoSize = TextFieldAutoSize.LEFT;
			this.invalidate(Invalides.NULL, true);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			this.initStyles();
			if (this._document is DisplayObjectContainer) 
				(this._document as DisplayObjectContainer).addChild(this);
			this._id = id;
			if (this._hasPendingValidation) this.validate(this._invalidProperties);
			super.dispatchEvent(GUIEvent.INITIALIZED);
		}
		
		public function dispose():void { }
		
		public function validate(properties:Dictionary):void
		{
			if (!this._document) this._validator = new LayoutValidator();
			else if (super.parent is ILayoutClient && !this._validator)
			{
				this._validator = (super.parent as ILayoutClient).validator;
				this._layoutParent = super.parent as ILayoutClient;
				if ((super.parent as ILayoutClient).childLayouts.indexOf(this) < 0)
				{
					(super.parent as ILayoutClient).childLayouts.push(this);
				}
			}
			if (!this._validator) this._validator = new LayoutValidator();
			this._validator.append(this, this._layoutParent);
			if (Invalides.COLOR in properties)
			{
				super.background = this._background;
				super.backgroundColor = this._backgroundColor;
			}
			if (Invalides.AUTOSIZE in properties) 
				super.autoSize = this._autoSize;
			if (Invalides.TEXTFORMAT in properties)
				super.defaultTextFormat = this._textFormat;
			if (Invalides.TEXT in properties)
				super.text = this._text;
			if (this._autoSize === TextFieldAutoSize.NONE)
			{
				super.width = this._bounds.x;
				super.height = this._bounds.y;
			}
			if (Invalides.TRANSFORM in properties)
			{
				if (this._userTransform)
				{
					super.transform = this._userTransform;
					this._nativeTransform = this._userTransform;
					this._userTransform = null;
				}
				else if (this._transformMatrix)
				{
					this._nativeTransform.matrix = this._transformMatrix;
					super.transform = this._nativeTransform;
				}
			}
			this._invalidProperties = new Dictionary();
			super.dispatchEvent(GUIEvent.VALIDATED);
		}
		
		public function invalidate(property:Invalides, validateParent:Boolean):void
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
		}
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function initStyles():void
		{
			var parserDef:String = "org.wvxvws.gui.styles.CSSParser";
			var styleParser:Object;
			if (ApplicationDomain.currentDomain.hasDefinition(parserDef))
			{
				styleParser = 
					ApplicationDomain.currentDomain.getDefinition(parserDef);
			}
			else return;
			if (styleParser.parsed) styleParser.processClient(this);
			else styleParser.addPendingClient(this);
		}
	}
}