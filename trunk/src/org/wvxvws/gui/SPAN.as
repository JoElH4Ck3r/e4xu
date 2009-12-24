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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.layout.ILayoutClient;
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
		public override function get x():Number { return _transformMatrix.tx; }
		
		public override function set x(value:Number):void 
		{
			if (_transformMatrix.tx === value) return;
			_transformMatrix.tx = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
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
		public override function get y():Number { return _transformMatrix.ty; }
		
		public override function set y(value:Number):void 
		{
			if (_transformMatrix.ty === value) return;
			_transformMatrix.ty = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
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
		public override function get width():Number { return _bounds.x; }
		
		public override function set width(value:Number):void 
		{
			if (_bounds.x === value) return;
			_bounds.x = value;
			_autoSize = TextFieldAutoSize.NONE;
			this.invalidate("_bounds", _bounds, true);
			this.invalidate("_autoSize", _autoSize, true);
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
		public override function get height():Number { return _bounds.y; }
		
		public override function set height(value:Number):void 
		{
			if (_bounds.y === value) return;
			_bounds.y = value;
			_autoSize = TextFieldAutoSize.NONE;
			this.invalidate("_bounds", _bounds, true);
			this.invalidate("_autoSize", _autoSize, true);
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
		public override function get scaleX():Number { return _transformMatrix.a; }
		
		public override function set scaleX(value:Number):void 
		{
			if (_transformMatrix.a === value) return;
			_transformMatrix.a = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
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
		public override function get scaleY():Number { return _transformMatrix.d; }
		
		public override function set scaleY(value:Number):void 
		{
			if (_transformMatrix.d === value) return;
			_transformMatrix.d = value;
			this.invalidate("_transformMatrix", _transformMatrix, true);
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
			_userTransform = value;
			this.invalidate("_userTransform", _userTransform, true);
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
		public override function get backgroundColor():uint { return _backgroundColor; }
		
		public override function set backgroundColor(value:uint):void 
		{
			if (value === _backgroundColor) return;
			_backgroundColor = value;
			this.invalidate("_backgroundColor", _backgroundColor, true);
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
		public override function get background():Boolean { return _background; }
		
		public override function set background(value:Boolean):void 
		{
			if (value === _background) return;
			_background = value;
			this.invalidate("_background", _background, true);
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
			if (value === _text) return;
			_text = value;
			this.invalidate("_text", _text, true);
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
			if (value === _autoSize) return;
			_autoSize = value;
			this.invalidate("_autoSize", _autoSize, true);
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
		public function get align():String { return _textFormat.align; }
		
		public function set align(value:String):void 
		{
			if (value == _textFormat.align) return;
			_textFormat.align = value;
			this.invalidate("_textFormat", _textFormat, true);
			if (super.hasEventListener(EventGenerator.getEventType("align")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		/* INTERFACE org.wvxvws.gui.styles.ICSSClient */
		
		public function get className():String { return _className; }
		
		public function set className(value:String):void { _className = value; }
		
		public function get style():IEventDispatcher { return _style; }
		
		public function set style(value:IEventDispatcher):void { _style = value; }
		
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
		protected var _invalidProperties:Object = { };
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
			_className = String(nm.pop());
			_nativeTransform = new Transform(this);
			super.autoSize = TextFieldAutoSize.LEFT;
			this.invalidate("", undefined, true);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			this.initStyles();
			if (_document is DisplayObjectContainer) 
				(_document as DisplayObjectContainer).addChild(this);
			_id = id;
			if (_hasPendingValidation) this.validate(_invalidProperties);
			super.dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
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
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return _validator; }
		
		public function get invalidProperties():Object { return _invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void { _layoutParent = value; }
		
		public function get childLayouts():Vector.<ILayoutClient> { return _childLayouts; }
		
		public function validate(properties:Object):void
		{
			if (!_document) _validator = new LayoutValidator();
			else if (super.parent is ILayoutClient && !_validator)
			{
				_validator = (super.parent as ILayoutClient).validator;
				_layoutParent = super.parent as ILayoutClient;
				if ((super.parent as ILayoutClient).childLayouts.indexOf(this) < 0)
				{
					(super.parent as ILayoutClient).childLayouts.push(this);
				}
			}
			if (!_validator) _validator = new LayoutValidator();
			_validator.append(this, _layoutParent);
			if (properties._background)
				super.background = _background;
			if (properties._backgroundColor) 
				super.backgroundColor = _backgroundColor;
			if (properties._autoSize) 
				super.autoSize = _autoSize;
			if (properties._textFormat)
				super.defaultTextFormat = _textFormat;
			if (properties._text)
				super.text = _text;
			if (_autoSize == TextFieldAutoSize.NONE)
			{
				super.width = _bounds.x;
				super.height = _bounds.y;
			}
			if (properties._userTransform)
			{
				if (_userTransform)
				{
					super.transform = _userTransform;
					_userTransform = null;
					_nativeTransform = _userTransform;
				}
			}
			else if (properties._transformMatrix)
			{
				_nativeTransform.matrix = _transformMatrix;
				super.transform = _nativeTransform;
			}
			_invalidProperties = { };
			super.dispatchEvent(new GUIEvent(GUIEvent.VALIDATED));
		}
		
		public function invalidate(property:String, 
						cleanValue:*, validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator) _validator.requestValidation(this, validateParent);
			else
			{
				_hasPendingValidation = true;
				_hasPendingParentValidation = 
					_hasPendingParentValidation || validateParent;
			}
		}
	}
}