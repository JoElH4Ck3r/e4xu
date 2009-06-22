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

package org.wvxvws.gui.renderers 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.GUIEvent;
	
	[Event(name="childrenCreated", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * NestBrunchRenderer class.
	 * @author wvxvw
	 */
	public class NestBrunchRenderer extends Sprite implements IBrunchRenderer
	{
		public static const DEFAULT_INDENT:int = 10;
		
		protected var _document:Object;
		protected var _id:String;
		protected var _data:XML;
		protected var _dataCopy:XML;
		protected var _opened:Boolean = true;
		protected var _children:Dictionary = new Dictionary();
		protected var _brunchRenderer:Class = NestBrunchRenderer;
		protected var _leafRenderer:Class = NestLeafRenderer;
		protected var _indent:int;
		protected var _nestLevel:uint;
		protected var _icon:Sprite;
		protected var _field:TextField;
		protected var _labelField:String = "@label";
		protected var _labelFunction:Function;
		protected var _leafLabelFunction:Function;
		protected var _leafLabelField:String;
		
		private var _childIDGenerator:uint;
		
		public function NestBrunchRenderer()
		{
			super();
			addEventListener(GUIEvent.SELECTED, selectedHandler);
		}
		
		protected function selectedHandler(event:GUIEvent):void 
		{
			if (event.target === this || !(event.target is _brunchRenderer)) return;
			hideChildren();
			displayChildren();
		}
		
		[Bindable("openedChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>openedChange</code> event.
		*/
		public function get opened():Boolean { return _opened; }
		
		public function set opened(value:Boolean):void
		{
			if (_opened === value) return;
			_opened = value;
			if (value) displayChildren();
			else hideChildren();
			dispatchEvent(new Event("openedChange"));
		}
		
		protected function displayChildren():void
		{
			_data.*.(addRenderer(valueOf(), childIndex()));
			var unused:Dictionary = new Dictionary();
			var renderer:Object;
			for (renderer in _children)
			{
				if (!(renderer as DisplayObject).parent)
				{
					unused[renderer] = _children[renderer];
				}
			}
			for (renderer in unused) delete _children[renderer];
			dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, true));
		}
		
		protected function addRenderer(xml:XML, index:uint):void
		{
			//trace("adding renderer", index);
			var renderer:DisplayObject;
			var func:Function;
			var field:String;
			if (xml.hasSimpleContent())
			{
				renderer = unusedRenderer(xml);
				if (!renderer)
				{
					renderer = new _leafRenderer() as DisplayObject;
				}
				func = _leafLabelFunction;
				field = _leafLabelField;
			}
			else
			{
				renderer = unusedRenderer(xml);
				if (!renderer)
				{
					renderer = new _brunchRenderer() as DisplayObject;
				}
				func = _labelFunction;
				field = _labelField;
			}
			(renderer as IRenderer).labelField = field;
			(renderer as IRenderer).labelFunction = func;
			if (renderer is IBrunchRenderer)
			{
				(renderer as IBrunchRenderer).leafLabelField = _leafLabelField;
				(renderer as IBrunchRenderer).leafLabelFunction = _leafLabelFunction;
			}
			(renderer as IRenderer).data = xml;
			_children[renderer] = childIDGenerator();
			renderer.y = super.height;
			renderer.x = DEFAULT_INDENT;
			super.addChildAt(renderer, index);
		}
		
		protected function unusedRenderer(xml:XML):DisplayObject
		{
			for (var renderer:Object in _children)
			{
				if ((renderer as IRenderer).data.contains(xml) && 
					!(renderer as DisplayObject).parent)
				{
					return renderer as DisplayObject;
				}
			}
			return null;
		}
		
		protected function hideChildren():void
		{
			for (var child:Object in _children)
			{
				removeChild(child as DisplayObject);
			}
		}
		
		protected function drawIcon():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0);
			s.graphics.drawRect(0, 0, 10, 10);
			s.graphics.endFill();
			return s;
		}
		
		protected function drawField():TextField
		{
			var t:TextField = new TextField();
			t.autoSize = TextFieldAutoSize.LEFT;
			t.height = 10;
			t.border = true;
			return t;
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _dataCopy.contains(_data);
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void
		{
			if (isValid && _data === value) return;
			_data = value;
			_dataCopy = value.copy();
			var p:XML = _data.parent() as XML;
			_nestLevel = 0;
			while (p)
			{
				p = p.parent() as XML;
				_nestLevel++;
			}
			_indent = _nestLevel * DEFAULT_INDENT;
			if (_icon && super.contains(_icon))
			{
				_icon.removeEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
				super.removeChild(_icon);
			}
			_icon = drawIcon();
			_icon.addEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
			super.addChild(_icon);
			if (_field && super.contains(_field))
			{
				super.removeChild(_field);
			}
			_field = drawField();
			_field.x = _icon.width + 5;
			rendrerText();
			super.addChild(_field);
			displayChildren();
		}
		
		protected function rendrerText():void
		{
			if (_labelField && _data.hasOwnProperty(_labelField))
			{
				if (_labelFunction !== null)
				{
					_field.text = _labelFunction(_data[_labelField]);
				}
				else
				{
					_field.text = _data[_labelField];
				}
			}
			else
			{
				if (_labelFunction !== null)
				{
					_field.text = 
						_labelFunction(_data.toXMLString().replace(/[\r\n]+/g, " "));
				}
				else
				{
					_field.text = _data.toXMLString().replace(/[\r\n]+/g, " ");
				}
			}
		}
		
		protected function icon_mouseClickHandler(event:MouseEvent):void 
		{
			opened = !opened;
			dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true));
		}
		
		[Bindable("brunchRendererChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>brunchRendererChange</code> event.
		*/
		public function get brunchRenderer():Class { return _brunchRenderer; }
		
		public function set brunchRenderer(value:Class):void 
		{
			if (_brunchRenderer === value) return;
			_brunchRenderer = value;
		}
		
		[Bindable("leafRendererChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leafRendererChange</code> event.
		*/
		public function get leafRenderer():Class { return _leafRenderer; }
		
		public function set leafRenderer(value:Class):void 
		{
			if (_brunchRenderer === value) return;
			_leafRenderer = value;
		}
		
		public function get indent():int { return _indent; }
		
		public function get nestLevel():uint { return _nestLevel; }
		
		public function set nestLevel(value:uint):void 
		{
			_nestLevel = value;
		}
		
		private function childIDGenerator():uint
		{
			return ++_childIDGenerator;
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function get labelField():String { return _labelField; }
		
		public function set labelField(value:String):void 
		{
			_labelField = value;
			if (_data) rendrerText();
		}
		
		public function set labelFunction(value:Function):void 
		{
			_labelFunction = value;
			if (_data) rendrerText();
		}
		
		public function set leafLabelFunction(value:Function):void 
		{
			if (_leafLabelFunction === value) return;
			_leafLabelFunction = value;
			hideChildren();
			displayChildren();
		}
		
		
		public function set leafLabelField(value:String):void 
		{
			if (_leafLabelField === value) return;
			trace("leafLabelField", _leafLabelField);
			_leafLabelField = value;
			hideChildren();
			displayChildren();
		}
	}
	
}