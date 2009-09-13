﻿////////////////////////////////////////////////////////////////////////////////
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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.styles.ICSSClient
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	[DefaultProperty("text")]
	
	/**
	 * TextSPAN class.
	 * @author wvxvw
	 */
	public class SPAN extends TextField implements IMXMLObject, ICSSClient, ILayoutClient
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property x
		//------------------------------------
		
		[Bindable("xChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>xChange</code> event.
		*/
		override public function get x():Number { return _transformMatrix.tx; }
		
		override public function set x(value:Number):void 
		{
			if (_transformMatrix.tx == value) return;
			_transformMatrix.tx = value;
			invalidate("_transformMatrix", _transformMatrix, true);
			dispatchEvent(new Event("xChange"));
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
		override public function get y():Number { return _transformMatrix.ty; }
		
		override public function set y(value:Number):void 
		{
			if (_transformMatrix.ty == value) return;
			_transformMatrix.ty = value;
			invalidate("_transformMatrix", _transformMatrix, true);
			dispatchEvent(new Event("yChange"));
		}
		
		//------------------------------------
		//  Public property width
		//------------------------------------
		
		[Bindable("widthChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>widthChange</code> event.
		*/
		override public function get width():Number { return _bounds.x; }
		
		override public function set width(value:Number):void 
		{
			if (_bounds.x == value) return;
			_bounds.x = value;
			_autoSize = TextFieldAutoSize.NONE;
			invalidate("_bounds", _bounds, true);
			invalidate("_autoSize", _autoSize, true);
			dispatchEvent(new Event("widthChange"));
		}
		
		//------------------------------------
		//  Public property height
		//------------------------------------
		
		[Bindable("heightChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>heightChange</code> event.
		*/
		override public function get height():Number { return _bounds.y; }
		
		override public function set height(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			_autoSize = TextFieldAutoSize.NONE;
			invalidate("_bounds", _bounds, true);
			invalidate("_autoSize", _autoSize, true);
			dispatchEvent(new Event("heightChange"));
		}
		
		//------------------------------------
		//  Public property scaleX
		//------------------------------------
		
		[Bindable("scaleXChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>scaleXChange</code> event.
		*/
		override public function get scaleX():Number { return _transformMatrix.a; }
		
		override public function set scaleX(value:Number):void 
		{
			if (_transformMatrix.a == value) return;
			_transformMatrix.a = value;
			invalidate("_transformMatrix", _transformMatrix, true);
			dispatchEvent(new Event("scaleXChange"));
		}
		
		//------------------------------------
		//  Public property scaleY
		//------------------------------------
		
		[Bindable("scaleYChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>scaleYChange</code> event.
		*/
		override public function get scaleY():Number { return _transformMatrix.d; }
		
		override public function set scaleY(value:Number):void 
		{
			if (_transformMatrix.d == value) return;
			_transformMatrix.d = value;
			invalidate("_transformMatrix", _transformMatrix, true);
			dispatchEvent(new Event("scaleYChange"));
		}
		
		//------------------------------------
		//  Public property transform
		//------------------------------------
		
		[Bindable("transformChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>transformChange</code> event.
		*/
		override public function get transform():Transform { return super.transform; }
		
		override public function set transform(value:Transform):void 
		{
			_userTransform = value;
			invalidate("_userTransform", _userTransform, true);
			dispatchEvent(new Event("transformChange"));
		}
		
		//------------------------------------
		//  Public property backgroundColor
		//------------------------------------
		
		[Bindable("backgroundColorChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundColorChange</code> event.
		*/
		public override function get backgroundColor():uint { return _backgroundColor; }
		
		public override function set backgroundColor(value:uint):void 
		{
			if (value == _backgroundColor) return;
			_backgroundColor = value;
			invalidate("_backgroundColor", _backgroundColor, true);
			dispatchEvent(new Event("backgroundColorChange"));
		}
		
		//------------------------------------
		//  Public property background
		//------------------------------------
		
		[Bindable("backgroundChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>backgroundChange</code> event.
		*/
		public override function get background():Boolean { return _background; }
		
		public override function set background(value:Boolean):void 
		{
			if (value == _background) return;
			_background = value;
			invalidate("_background", _background, true);
			dispatchEvent(new Event("backgroundChange"));
		}
		
		//------------------------------------
		//  Public property text
		//------------------------------------
		
		[Bindable("textChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>textChange</code> event.
		*/
		override public function get text():String { return super.text; }
		
		override public function set text(value:String):void 
		{
			if (value == _text) return;
			_text = value;
			invalidate("_text", _text, true);
			dispatchEvent(new Event("textChange"));
		}
		
		//------------------------------------
		//  Public property autoSize
		//------------------------------------
		
		[Bindable("autoSizeChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>autoSizeChange</code> event.
		*/
		override public function get autoSize():String { return super.autoSize; }
		
		override public function set autoSize(value:String):void 
		{
			if (value == _autoSize) return;
			_autoSize = value;
			invalidate("_autoSize", _autoSize, true);
			dispatchEvent(new Event("autoSizeChange"));
		}
		
		//------------------------------------
		//  Public property autoSize
		//------------------------------------
		
		[Bindable("alignChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>alignChange</code> event.
		*/
		public function get align():String { return _textFormat.align; }
		
		public function set align(value:String):void 
		{
			if (value == _textFormat.align) return;
			_textFormat.align = value;
			invalidate("_textFormat", _textFormat, true);
			dispatchEvent(new Event("alignChange"));
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
		protected var _childLayouts:Vector.<ILayoutClient> = new Vector.<ILayoutClient>(0, false);
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
			invalidate("", undefined, true);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			initStyles();
			if (_document is DisplayObjectContainer) 
				(_document as DisplayObjectContainer).addChild(this);
			_id = id;
			if (_hasPendingValidation) validate(_invalidProperties);
			dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		protected function initStyles():void
		{
			var styleParser:Object;
			try
			{
				styleParser = getDefinitionByName("org.wvxvws.gui.styles.CSSParser");
			}
			catch (error:Error) { return; };
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
			trace("span validate");
			if (!_document) _validator = new LayoutValidator();
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
			dispatchEvent(new GUIEvent(GUIEvent.VALIDATED));
		}
		
		public function invalidate(property:String, cleanValue:*, validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator) _validator.requestValidation(this, validateParent);
			else
			{
				_hasPendingValidation = true;
				_hasPendingParentValidation = _hasPendingParentValidation || validateParent;
			}
		}
	}
}