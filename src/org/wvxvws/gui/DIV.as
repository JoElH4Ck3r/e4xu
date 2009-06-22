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
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import mx.core.IMXMLObject;
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
	public class DIV extends Sprite implements IMXMLObject, ICSSClient
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
		protected var _style:IEventDispatcher;
		protected var _className:String;
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
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
			invalidLayout = true;
			dispatchEvent(new Event("xChange"));
		}
		
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
			invalidLayout = true;
			dispatchEvent(new Event("yChange"));
		}
		
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
			invalidLayout = true;
			dispatchEvent(new Event("widthChange"));
		}
		
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
			invalidLayout = true;
			dispatchEvent(new Event("heightChange"));
		}
		
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
			invalidLayout = true;
			dispatchEvent(new Event("scaleXChange"));
		}
		
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
			invalidLayout = true;
			dispatchEvent(new Event("scaleYChange"));
		}
		
		[Bindable("transformChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>transformChange</code> event.
		*/
		override public function get transform():Transform
		{
			return _userTransform ? _userTransform : super.transform;
		}
		
		override public function set transform(value:Transform):void 
		{
			_userTransform = value;
			invalidLayout = true;
			dispatchEvent(new Event("transformChange"));
		}
		
		//------------------------------------
		//  Public property style
		//------------------------------------
		
		[Bindable("styleChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>styleChange</code> event.
		*/
		public function get style():IEventDispatcher { return _style; }
		
		public function set style(value:IEventDispatcher):void 
		{
		   if (_style == value) return;
		   _style = value;
		   dispatchEvent(new Event("styleChange"));
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
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function DIV()
		{
			super();
			var nm:Array = getQualifiedClassName(this).split("::");
			_className = String(nm.pop());
			_nativeTransform = new Transform(this);
			invalidLayout = true;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			initStyles();
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
			if (!_document) 
			{
				_document = this;
				initStyles();
				dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
			}
			dispatchEvent(new GUIEvent(GUIEvent.VALIDATED));
		}
		
		/* INTERFACE org.wvxvws.gui.styles.ICSSClient */
		
		public function get className():String { return _className; }
		
		public function set className(value:String):void
		{
			_className = value;
			initStyles();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function initStyles():void
		{
			var styleParser:Class;
			try
			{
				styleParser = getDefinitionByName("org.wvxvws.gui.styles.CSSParser") as Class;
			}
			catch (refError:Error) { return; };
			if (Object(styleParser).parsed)
			{
				Object(styleParser).processClient(this);
			}
			else
			{
				Object(styleParser).addPendingClient(this);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}