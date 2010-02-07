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

package org.wvxvws.tools 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.rendering.Port;
	import org.wvxvws.rendering.SlaveSlide;
	import org.wvxvws.rendering.Slide;
	
	[DefaultProperty("dataProvider")]
	
	[Event(name="moved", type="org.wvxvws.tools.ToolEvent")]
	[Event(name="resized", type="org.wvxvws.tools.ToolEvent")]
	
	/**
	 * Timeline class.
	 * @author wvxvw
	 */
	public class Timeline extends Port implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get dataProvider():XML { return _dataProvider; }
		
		public function set dataProvider(value:XML):void 
		{
			if (_dataProvider === value) return;
			_dataProvider = value;
			_dataProviderCopy = value.copy();
			_dataProvider.setNotification(providerNotifier);
			super.invalidLayout = true;
			super.dispatchEvent(GUIEvent.DATA_CHANGED);
		}
		
		public function get slideWidthFactory():Function { return _slideWidthFactory; }
		
		public function set slideWidthFactory(value:Function):void 
		{
			if (_slideWidthFactory === value) return;
			_slideWidthFactory = value;
			super.invalidLayout = true;
		}
		
		public function get slidePositionFactory():Function { return _slidePositionFactory; }
		
		public function set slidePositionFactory(value:Function):void 
		{
			if (_slidePositionFactory === value) return;
			_slidePositionFactory = value;
			super.invalidLayout = true;
		}
		
		public function get slideHeight():int { return _slideHeight; }
		
		public function set slideHeight(value:int):void 
		{
			if (_slideHeight === value) return;
			_slideHeight = value;
			if (_bgData) _bgData.dispose();
			_bgData = new BitmapData(1, Math.max(1, _slideHeight + _gutter), false, 0xD0D0D0);
			_bgData.setPixel(0, 0, 0x909090);
			_bgData.setPixel(0, _slideHeight + _gutter, 0x909090);
			super.invalidLayout = true;
		}
		
		public function get zoom():Number { return _zoom; }
		
		public function set zoom(value:Number):void 
		{
			if (_zoom === value || value < 0.1 || value > 10) return;
			_zoom = value;
			super.invalidLayout = true;
		}
		
		public function get slideVisible():Function { return _slideVisible; }
		
		public function set slideVisible(value:Function):void 
		{
			if (_slideVisible === value) return;
			_slideVisible = value;
			super.invalidLayout = true;
		}
		
		public function get selectedSlide():Slide { return _selectedSlide; }
		
		public function get slideEditor():DisplayObject { return _slideEditor; }
		
		public function set slideEditor(value:DisplayObject):void 
		{
			if (_slideEditor === value) return;
			if (_slideEditor)
				_slideEditor.removeEventListener(ToolEvent.RESIZED, tool_resizedHandler);
			_slideEditor = value;
			if (_slideEditor)
				_slideEditor.addEventListener(ToolEvent.RESIZED, tool_resizedHandler);
		}
		
		public function get gutter():int { return _gutter; }
		
		public function set gutter(value:int):void 
		{
			if (_gutter === value) return;
			_gutter = value;
			if (_bgData) _bgData.dispose();
			_bgData = new BitmapData(1, Math.max(1, _slideHeight + _gutter), false, 0xD0D0D0);
			_bgData.setPixel(0, 0, 0x909090);
			_bgData.setPixel(0, _slideHeight + _gutter, 0x909090);
			super.invalidLayout = true;
		}
		
		public function get useText():Boolean { return _useText; }
		
		public function set useText(value:Boolean):void 
		{
			if (_useText === value) return;
			_useText = value;
			super.invalidLayout = true;
		}
		
		public function get slideIsSlave():Function { return _slideIsSlave; }
		
		public function set slideIsSlave(value:Function):void 
		{
			if (_slideIsSlave === value) return;
			_slideIsSlave = value;
			super.invalidLayout = true;
		}
		
		public function get offsetY():Number { return _offset.y; }
		
		public function set offsetY(value:Number):void 
		{
			if (_offset.y === value) return;
			_offset.y = value;
			super.invalidLayout = true;
		}
		
		public function get offsetX():Number { return _offset.x; }
		
		public function set offsetX(value:Number):void 
		{
			if (_offset.x === value) return;
			_offset.x = value;
			super.invalidLayout = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _dataProvider:XML;
		protected var _dataProviderCopy:XML;
		protected var _slideWidthFactory:Function;
		protected var _slidePositionFactory:Function;
		protected var _slideVisible:Function;
		protected var _slideHeight:int = 10;
		protected var _slides:Vector.<Slide> = new <Slide>[];
		protected var _zoom:Number = 1;
		protected var _gutter:int = 1;
		protected var _selectedSlide:Slide;
		protected var _slideEditor:DisplayObject;
		protected var _useText:Boolean;
		protected var _slideIsSlave:Function;
		protected var _bgData:BitmapData;
		protected var _offset:Point = new Point();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Timeline() { super(); }
		
		public function slideForNode(xml:XML):Slide
		{
			for each (var s:Slide in _slides)
			{
				if (s.node === xml) return s;
			}
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function createEditor(from:DisplayObject = null):DisplayObject
		{
			if (_slideEditor)
			{
				_slideEditor.removeEventListener(
					ToolEvent.RESIZED, this.tool_resizedHandler);
			}
			_slideEditor = from || _slideEditor;
			if (!_slideEditor || !_selectedSlide) return null;
			_slideEditor.x = _selectedSlide.x;
			_slideEditor.y = _selectedSlide.y;
			_slideEditor.addEventListener(
				ToolEvent.RESIZED, this.tool_resizedHandler);
			return _slideEditor;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._document = document;
			this._id = id;
			if (this._document is DisplayObjectContainer)
			{
				(this._document as DisplayObjectContainer).addChild(this);
			}
			super.dispatchEvent(GUIEvent.INITIALIZED);
		}
		
		public function dispose():void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function tool_resizedHandler(event:ToolEvent):void 
		{
			super.dispatchEvent(event);
		}
		
		protected override function renderHandler(event:Event):void 
		{
			var i:int = super.numChildren;
			if (!this._bgData)
			{
				this._bgData = new BitmapData(1, 
					Math.max(1, this._slideHeight + this._gutter), false, 0xD0D0D0);
				this._bgData.setPixel(0, 0, 0x909090);
				this._bgData.setPixel(0, this._slideHeight + this._gutter, 0x909090);
			}
			var m:Matrix = new Matrix();
			m.ty = ((super._bounds.y + this._offset.y) % 
				(this._slideHeight + this._gutter)) - (this._gutter >> 1);
			graphics.clear();
			graphics.beginBitmapFill(this._bgData, m);
			graphics.drawRect(super._bounds.x,
							super._bounds.y,
							super._bounds.width, super._bounds.height);
			graphics.endFill();
			while (i--) super.getChildAt(i).dispatchEvent(super._updater);
			super.invalidLayout = false;
			this.createSlides();
		}
		
		protected function createSlides():void
		{
			var list:XMLList;
			if (this._dataProvider) 
				list = this._dataProvider..*.(nodeKind() !== "text" || this._useText);
			else list = new XMLList();
			var slideWidth:int;
			var slidePosition:int;
			var i:int;
			var j:int = list.length();
			var slide:Slide;
			var currentNode:XML;
			var slideY:int;
			var slidesCopy:Vector.<Slide> = new <Slide>[];
			var cumulativeHeight:int;
			var master:Slide;
			if (this._slideEditor) (_slideEditor as IEditor).hide();
			while (i < j)
			{
				currentNode = list[i];
				slide = this.slideForNode(currentNode);
				if (!slide)
				{
					master = this.slideMaster(currentNode);
					if (master) slide = new SlaveSlide(master);
					else slide = new Slide();
					slide.node = currentNode;
					if (!(slide is SlaveSlide))
					{
						slide.addEventListener(
							MouseEvent.MOUSE_DOWN, this.slide_mouseDownHandler);
					}
					this._slides.push(slide);
				}
				if (this._slideWidthFactory !== null)
					slide.width = this._slideWidthFactory(currentNode);
				if (this._slidePositionFactory !== null)
					slide.x = this._slidePositionFactory(currentNode);
				slide.y = cumulativeHeight + this._offset.y;
				slide.height = this._slideHeight;
				slidesCopy.push(slide);
				if (this._slideVisible !== null)
				{
					if (this._slideVisible(currentNode))
					{
						if (!super.contains(slide)) super.addChild(slide);
						cumulativeHeight += this._slideHeight + this._gutter;
					}
					else if (super.contains(slide)) super.removeChild(slide);
				}
				i++;
			}
			i = this._slides.length;
			while (i--)
			{
				slide = this._slides[i];
				if (slidesCopy.indexOf(slide) < 0)
				{
					this._slides.splice(i, 1);
					if (super.contains(slide)) super.removeChild(slide);
				}
			}
		}
		
		protected function slideMaster(xml:XML):Slide
		{
			var n:XML = xml.parent() as XML;
			var list:XMLList = xml.elements();
			var b:Boolean;
			if (!n || n === this._dataProvider) return null;
			if (this._slideIsSlave !== null)
			{
				n = this._slideIsSlave(xml);
				if (n) return this.slideForNode(n);
			}
			if (list.length()) return null;
			return this.slideForNode(n);
		}
		
		protected function providerNotifier(targetCurrent:Object, command:String, 
									target:Object, value:Object, detail:Object):void
		{
			//var renderer:IRenderer;
			switch (command)
			{
				    case "attributeAdded":
					case "attributeChanged":
					case "attributeRemoved":
						//renderer = getItemForNode(target as XML) as IRenderer;
						//if (renderer) renderer.data = target as XML;
						break;
					case "nodeAdded":
						{
							var needReplace:Boolean;
							var nodeList:Array = [];
							var firstIndex:int;
							var lastIndex:int;
							var correctNodeList:XMLList;
							(targetCurrent as XML).*.(nodeList.push(valueOf()));
							for each (var node:XML in nodeList)
							{
								if (nodeList.indexOf(node) != 
									nodeList.lastIndexOf(node))
								{
									firstIndex = nodeList.indexOf(node);
									lastIndex = nodeList.lastIndexOf(node);
									needReplace = true;
									break;
								}
							}
							if (needReplace)
							{
								if (_dataProvider.*[firstIndex].contains(
									this._dataProviderCopy.*[firstIndex]))
								{
									nodeList.splice(firstIndex, 1);
									this._dataProvider.setChildren("");
									this._dataProvider.normalize();
									while (nodeList.length)
									{
										this._dataProvider.appendChild(
											nodeList.shift());
									}
									this._dataProviderCopy = 
										this._dataProvider.copy();
									return;
								}
								else
								{
									nodeList.splice(lastIndex, 1);
									this._dataProvider.setChildren("");
									this._dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
							}
							super.invalidLayout = true;
						}
						break;
					case "textSet":
					case "nameSet":
					case "nodeChanged":
					case "nodeRemoved":
						super.invalidLayout = true;
						break;
					case "namespaceAdded":
						
						break;
					case "namespaceRemoved":
						
						break;
					case "namespaceSet":
						
						break;
			}
			this._dataProviderCopy = this._dataProvider.copy();
			super.dispatchEvent(GUIEvent.DATA_CHANGED);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function slide_mouseDownHandler(event:MouseEvent):void 
		{
			super._selectedSlide = event.target as Slide;
			super.stage.addEventListener(
				MouseEvent.MOUSE_MOVE, this.mouseMoveHandler, false, 0, true);
			super.stage.addEventListener(
				MouseEvent.MOUSE_UP, this.mouseUpHandler, false, 0, true);
			if (this._slideEditor)
			{
				(this._slideEditor as IEditor).target = this._selectedSlide;
				(this._slideEditor as IEditor).show();
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void 
		{
			super.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.mouseMoveHandler);
			super.dispatchEvent(new ToolEvent(ToolEvent.MOVED, false, false, _selectedSlide));
			_selectedSlide = null;
			//if (_slideEditor)
			//{
				//(_slideEditor as IEditor).target = null;
				//(_slideEditor as IEditor).hide();
			//}
		}
		
		private function mouseMoveHandler(event:MouseEvent):void 
		{
			_selectedSlide.x = super.mouseX - (_selectedSlide.clickLocation.x + x);
			if (_slideEditor)
			{
				(_slideEditor as IEditor).update();
			}
		}
		
	}

}