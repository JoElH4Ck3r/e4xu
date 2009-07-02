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
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import org.wvxvws.gui.containers.Nest;
	import org.wvxvws.gui.GUIEvent;
	
	[Event(name="childrenCreated", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * NestbranchRenderer class.
	 * @author wvxvw
	 */
	public class NestBranchRenderer extends Sprite implements IBranchRenderer
	{
		public static const DEFAULT_INDENT:int = 10;
		
		protected var _document:Object;
		protected var _id:String;
		protected var _data:XML;
		protected var _dataCopy:XML;
		protected var _opened:Boolean = true;
		protected var _children:Dictionary = new Dictionary();
		protected var _branchRenderer:Class = NestBranchRenderer;
		protected var _leafRenderer:Class = NestLeafRenderer;
		protected var _indent:int;
		protected var _nestLevel:uint;
		protected var _icon:DisplayObject;
		protected var _openCloseIcon:DisplayObject;
		protected var _field:TextField;
		protected var _labelField:String = "@label";
		protected var _labelFunction:Function;
		protected var _leafLabelFunction:Function;
		protected var _leafLabelField:String;
		protected var _textFormat:TextFormat = new TextFormat("_sans", 11);
		protected var _gutter:int = 6;
		protected var _padding:int = 2;
		protected var _bitmapLines:Sprite;
		protected var _lineBitmap:BitmapData = new BitmapData(2, 2, true, 0x00FFFFFF);
		
		protected var _folderIcon:Class;
		protected var _closedIcon:Class;
		protected var _openIcon:Class;
		protected var _docIconFactory:Function;
		
		protected var _invalid:Boolean;
		
		private var _childIDGenerator:uint;
		
		public function NestBranchRenderer()
		{
			super();
			addEventListener(GUIEvent.SELECTED, selectedHandler);
			addEventListener(GUIEvent.CHILDREN_CREATED, childrenCreatedHandler);
		}
		
		protected function childrenCreatedHandler(event:GUIEvent):void 
		{
			if (event.target === this) return;
			invalid = true;
		}
		
		protected function enterFrameHandler(event:Event):void 
		{
			hideChildren();
			if (_opened) displayChildren();
			invalid = false;
		}
		
		protected function selectedHandler(event:GUIEvent):void 
		{
			if (event.target === this || !(event.target is _branchRenderer)) return;
			hideChildren();
			if (!_opened) return;
			var pt:DisplayObjectContainer = parent;
			while (pt && !(pt is Nest))
			{
				pt = pt.parent;
				if ((pt is IBranchRenderer) && !(pt as IBranchRenderer).opened)
					return;
			}
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
			if (!value) hideChildren();
			invalid = true;
			dispatchEvent(new Event("openedChange"));
		}
		
		protected function displayChildren():void
		{
			if (!_opened) return;
			if (_bitmapLines && contains(_bitmapLines))
			{
				removeChild(_bitmapLines);
			}
			if (!_data) return;
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
			if (_bitmapLines) addChild(_bitmapLines);
			drawLines();
			dispatchEvent(new GUIEvent(GUIEvent.CHILDREN_CREATED, true));
		}
		
		protected function drawLines():void
		{
			if (!_openCloseIcon) return;
			var openedHeight:int;
			if (!_bitmapLines)
			{
				_bitmapLines = new Sprite();
				addChild(_bitmapLines);
				_lineBitmap.setPixel32(0, 0, 0xFF999999);
				_lineBitmap.setPixel32(1, 1, 0xFF999999);
			}
			_bitmapLines.graphics.clear();
			_bitmapLines.graphics.beginBitmapFill(_lineBitmap);
			_bitmapLines.graphics.drawRect((_openCloseIcon.x + 
								_openCloseIcon.width / 2) >> 0,
								_openCloseIcon.y + _openCloseIcon.height, 1, height - 
								(_openCloseIcon.y + _openCloseIcon.height));
			_bitmapLines.graphics.drawRect(_openCloseIcon.x + _openCloseIcon.width,
					(_openCloseIcon.y + _openCloseIcon.height / 2) >> 0, _gutter, 1);
			if (_opened)
			{
				for (var obj:Object in _children)
				{
					openedHeight = Math.max(openedHeight, 
							(obj as DisplayObject).y + 
							(obj as DisplayObject).height / 2);
					if (obj is NestBranchRenderer)
					{
						_bitmapLines.graphics.drawRect(((_icon.x + 
									_icon.width / 2) >> 0) + 1,
									((obj as DisplayObject).y + _openCloseIcon.y + 
									_openCloseIcon.height / 2) >> 0,
									_field.x - (_icon.x + _icon.width / 2) >> 0, 1);
					}
					else
					{
						_bitmapLines.graphics.drawRect(((_icon.x + 
									_icon.width / 2) >> 0) + 1,
									((obj as DisplayObject).y + 
									(obj as DisplayObject).height / 2) >> 0,
									_field.x - (_icon.x + _icon.width / 2) >> 0, 1);
					}
				}
				openedHeight = openedHeight - (_icon.y + _icon.height);
				_bitmapLines.graphics.drawRect((_icon.x + _icon.width / 2) >> 0, 
											_icon.y + _icon.height, 1, openedHeight);
			}
			_bitmapLines.graphics.endFill();
		}
		
		protected function addRenderer(xml:XML, index:uint):void
		{
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
					renderer = new _branchRenderer() as DisplayObject;
				}
				func = _labelFunction;
				field = _labelField;
			}
			(renderer as IRenderer).labelField = field;
			(renderer as IRenderer).labelFunction = func;
			if (renderer is IBranchRenderer)
			{
				(renderer as IBranchRenderer).leafLabelField = _leafLabelField;
				(renderer as IBranchRenderer).leafLabelFunction = _leafLabelFunction;
				(renderer as IBranchRenderer).folderIcon = _folderIcon;
				(renderer as IBranchRenderer).openIcon = _openIcon;
				(renderer as IBranchRenderer).closedIcon = _closedIcon;
				(renderer as IBranchRenderer).docIconFactory = _docIconFactory;
			}
			else if (renderer is NestLeafRenderer && _docIconFactory !== null)
			{
				(renderer as NestLeafRenderer).iconClass = 
												_docIconFactory(xml) as Class;
			}
			(renderer as IRenderer).data = xml;
			_children[renderer] = childIDGenerator();
			renderer.y = super.height + _padding;
			renderer.x = _field.x;
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
				if (contains(child as DisplayObject))
					removeChild(child as DisplayObject);
			}
			drawLines();
		}
		
		protected function drawIcon():DisplayObject
		{
			var c:Class = _folderIcon ? _folderIcon : Sprite;
			var s:DisplayObject = new c();
			var u:Sprite;
			if (c === Sprite)
			{
				(s as Sprite).graphics.beginFill(0);
				(s as Sprite).graphics.drawRect(0, 0, 20, 20);
				(s as Sprite).graphics.endFill();
			}
			if (!(s is InteractiveObject))
			{
				u = new Sprite();
				u.addChild(s);
				s = u;
			}
			return s;
		}
		
		protected function drawOpenCloseIcon():DisplayObject
		{
			if ((_opened && !_openIcon) ||
				(!_opened && !_closedIcon)) return new Sprite();
			var s:DisplayObject;
			if (_opened) s = new _openIcon();
			else s = new _closedIcon();
			if (!(s is InteractiveObject))
			{
				var u:Sprite = new Sprite();
				u.addChild(s);
				s = u;
			}
			return s;
		}
		
		protected function drawField():TextField
		{
			var t:TextField = new TextField();
			t.defaultTextFormat = _textFormat;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.height = 10;
			return t;
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function nodeToRenderer(node:XML):IRenderer
		{
			if (_data === node) return this;
			var ret:IRenderer;
			for (var obj:Object in _children)
			{
				if (obj is IBranchRenderer)
				{
					if ((obj as IBranchRenderer).data === node)
						return obj as IRenderer;
					ret = (obj as IBranchRenderer).nodeToRenderer(node);
					if (ret) return ret;
				}
				else if (obj is IRenderer)
				{
					if ((obj as IRenderer).data === node)
					{
						return obj as IRenderer;
					}
				}
			}
			return null;
		}
		
		public function rendererToXML(renderer:IRenderer):XML
		{
			if (renderer === this) return _data;
			var ret:XML;
			for (var obj:Object in _children)
			{
				if (obj === renderer) return (obj as IRenderer).data;
				else if (obj is IBranchRenderer)
				{
					ret = (obj as IBranchRenderer).rendererToXML(renderer);
					if (ret) return ret;
				}
			}
			return null;
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
			draw();
			invalid = true;
		}
		
		protected function rendrerText():void
		{
			if (!_data) return;
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
		
		protected function draw():void
		{
			if (_openCloseIcon && super.contains(_openCloseIcon))
			{
				_openCloseIcon.removeEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
				super.removeChild(_openCloseIcon);
			}
			_openCloseIcon = drawOpenCloseIcon();
			_openCloseIcon.addEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
			
			if (_icon && super.contains(_icon))
			{
				_icon.removeEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
				super.removeChild(_icon);
			}
			_icon = drawIcon();
			_icon.y = 20 - _icon.height >> 1;
			_icon.addEventListener(MouseEvent.CLICK, icon_mouseClickHandler);
			super.addChild(_icon);
			
			_icon.x = _openCloseIcon.width + _gutter;
			_openCloseIcon.y = _icon.y + (_icon.width - _openCloseIcon.width) >> 1;
			super.addChild(_openCloseIcon);
			if (_field && super.contains(_field))
			{
				super.removeChild(_field);
			}
			_field = drawField();
			_field.x = _icon.width + _icon.x + _gutter;
			rendrerText();
			_field.scrollRect = new Rectangle(0, 0, _field.width, 20);
			super.addChild(_field);
		}
		
		protected function icon_mouseClickHandler(event:MouseEvent):void 
		{
			opened = !_opened;
			draw();
			dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true));
		}
		
		[Bindable("branchRendererChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>branchRendererChange</code> event.
		*/
		public function get branchRenderer():Class { return _branchRenderer; }
		
		public function set branchRenderer(value:Class):void 
		{
			if (_branchRenderer === value) return;
			_branchRenderer = value;
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
			if (_branchRenderer === value) return;
			_leafRenderer = value;
		}
		
		private function childIDGenerator():uint { return ++_childIDGenerator; }
		
		/* INTERFACE org.wvxvws.gui.renderers.IBranchRenderer */
		
		public function get folderIcon():Class { return _folderIcon; }
		
		public function set folderIcon(value:Class):void
		{
			if (_folderIcon === value) return;
			_folderIcon = value;
			draw();
			for (var obj:Object in _children)
			{
				if ((obj as DisplayObject).parent)
				{
					invalid = true;
					break;
				}
			}
		}
		
		public function get closedIcon():Class { return _closedIcon; }
		
		public function set closedIcon(value:Class):void
		{
			if (_closedIcon === value) return;
			_closedIcon = value;
			draw();
			for (var obj:Object in _children)
			{
				if ((obj as DisplayObject).parent)
				{
					invalid = true;
					break;
				}
			}
		}
		
		public function get openIcon():Class { return _openIcon; }
		
		public function set openIcon(value:Class):void
		{
			if (_openIcon === value) return;
			_openIcon = value;
			draw();
			for (var obj:Object in _children)
			{
				if ((obj as DisplayObject).parent)
				{
					invalid = true;
					break;
				}
			}
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
			invalid = true;
		}
		
		public function set leafLabelField(value:String):void 
		{
			if (_leafLabelField === value) return;
			_leafLabelField = value;
			invalid = true;
		}
		
		public function get docIconFactory():Function { return _docIconFactory; }
		
		public function set docIconFactory(value:Function):void 
		{
			if (_docIconFactory === value) return;
			_docIconFactory = value;
			invalid = true;
		}
		
		public function get closedHeight():int
		{
			return Math.max(_icon.y + _icon.height, 
							_openCloseIcon.y + _openCloseIcon.height) + 3;
		}
		
		public function get invalid():Boolean { return _invalid; }
		
		public function set invalid(value:Boolean):void 
		{
			if (_invalid === value) return;
			if (value) addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			else removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			_invalid = value;
		}
	}
	
}