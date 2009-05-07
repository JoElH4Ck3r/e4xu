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
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.styles.ICSSClient
	//}
	
	[Event(name="initialized", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="validated", type="org.wvxvws.gui.GUIEvent")]
	
	[DefaultProperty("text")]
	
	/**
	 * TextSPAN class.
	 * @author wvxvw
	 */
	public class SPAN extends TextField implements IMXMLObject, ICSSClient
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
		protected var _className:String;
		protected var _style:IEventDispatcher;
		
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
			_autoSize = TextFieldAutoSize.NONE;
			invalidLayout = true;
		}
		
		override public function get height():Number { return _bounds.y; }
		
		override public function set height(value:Number):void 
		{
			if (_bounds.y == value) return;
			_bounds.y = value;
			_autoSize = TextFieldAutoSize.NONE;
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
		
		public function SPAN()
		{
			super();
			var nm:Array = getQualifiedClassName(this).split("::");
			_className = String(nm.pop());
			_nativeTransform = new Transform(this);
			invalidLayout = true;
			super.autoSize = TextFieldAutoSize.LEFT;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			initStyles();
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
		
		/* INTERFACE org.wvxvws.gui.styles.ICSSClient */
		
		public function get className():String { return _className; }
		
		public function set className(value:String):void
		{
			_className = value;
		}
		
		public function get style():IEventDispatcher { return _style; }
		
		public function set style(value:IEventDispatcher):void
		{
			_style = value;
		}
		
		public function refreshStyles(event:Event = null):void
		{
			
		}
		
		
		protected function initStyles():void
		{
			try
			{
				var styleParser:Class = getDefinitionByName("org.wvxvws.gui.styles.CSSParser") as Class;
				if (Object(styleParser).parsed)
				{
					Object(styleParser).processClient(this);
				}
				else
				{
					Object(styleParser).addPendingClient(this);
				}
			}
			catch (error:Error) { trace("eror applying styles", error.getStackTrace()) };
		}
		
	}
}