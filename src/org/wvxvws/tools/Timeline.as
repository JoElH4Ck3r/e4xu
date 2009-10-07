package org.wvxvws.tools 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.rendering.Port;
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
		
		public function get dataProvider():XML { return _dataProvider; }
		
		public function set dataProvider(value:XML):void 
		{
			if (_dataProvider === value) return;
			_dataProvider = value;
			_dataProviderCopy = value.copy();
			_dataProvider.setNotification(providerNotifier);
			invalidLayout = true;
			dispatchEvent(new GUIEvent(GUIEvent.DATA_CHANGED));
		}
		
		public function get slideWidthFactory():Function { return _slideWidthFactory; }
		
		public function set slideWidthFactory(value:Function):void 
		{
			if (_slideWidthFactory === value) return;
			_slideWidthFactory = value;
			invalidLayout = true;
		}
		
		public function get slidePositionFactory():Function { return _slidePositionFactory; }
		
		public function set slidePositionFactory(value:Function):void 
		{
			if (_slidePositionFactory === value) return;
			_slidePositionFactory = value;
			invalidLayout = true;
		}
		
		public function get slideHeight():int { return _slideHeight; }
		
		public function set slideHeight(value:int):void 
		{
			if (_slideHeight === value) return;
			_slideHeight = value;
			invalidLayout = true;
		}
		
		public function get zoom():Number { return _zoom; }
		
		public function set zoom(value:Number):void 
		{
			if (_zoom === value || value < 0.1 || value > 10) return;
			_zoom = value;
			invalidLayout = true;
		}
		
		public function get slideVisible():Function { return _slideVisible; }
		
		public function set slideVisible(value:Function):void 
		{
			if (_slideVisible === value) return;
			_slideVisible = value;
			invalidLayout = true;
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
			invalidLayout = true;
		}
		
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
		
		public function Timeline() { super(); }
		
		public function slideForNode(xml:XML):Slide
		{
			for each (var s:Slide in _slides)
			{
				if (s.node === xml) return s;
			}
			return null;
		}
		
		public function createEditor(from:DisplayObject = null):DisplayObject
		{
			if (_slideEditor)
				_slideEditor.removeEventListener(ToolEvent.RESIZED, tool_resizedHandler);
			_slideEditor = from || _slideEditor;
			if (!_slideEditor || !_selectedSlide) return null;
			_slideEditor.x = _selectedSlide.x;
			_slideEditor.y = _selectedSlide.y;
			_slideEditor.addEventListener(ToolEvent.RESIZED, tool_resizedHandler);
			return _slideEditor;
		}
		
		protected function tool_resizedHandler(event:ToolEvent):void 
		{
			super.dispatchEvent(event);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
			if (_document is DisplayObjectContainer)
			{
				(_document as DisplayObjectContainer).addChild(this);
			}
			super.dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		protected override function renderHandler(event:Event):void 
		{
			super.renderHandler(event);
			createSlides();
		}
		
		protected function createSlides():void
		{
			var list:XMLList = _dataProvider..*;
			var slideWidth:int;
			var slidePosition:int;
			var i:int;
			var j:int = list.length();
			var slide:Slide;
			var currentNode:XML;
			var slideY:int;
			var slidesCopy:Vector.<Slide> = new <Slide>[];
			var cumulativeHeight:int;
			if (_slideEditor) (_slideEditor as IEditor).hide();
			while (i < j)
			{
				currentNode = list[i];
				slide = slideForNode(currentNode);
				if (!slide)
				{
					slide = new Slide();
					slide.node = currentNode;
					slide.addEventListener(MouseEvent.MOUSE_DOWN, slide_mouseDownHandler);
					_slides.push(slide);
				}
				if (_slideWidthFactory !== null)
					slide.width = _slideWidthFactory(currentNode);
				if (_slidePositionFactory !== null)
					slide.x = _slidePositionFactory(currentNode);
				slide.y = cumulativeHeight;
				slide.height = _slideHeight;
				slidesCopy.push(slide);
				if (_slideVisible !== null)
				{
					if (_slideVisible(currentNode))
					{
						if (!super.contains(slide)) super.addChild(slide);
						cumulativeHeight += _slideHeight + _gutter;
					}
					else if (super.contains(slide)) super.removeChild(slide);
				}
				i++;
			}
			i = _slides.length;
			while (i--)
			{
				slide = _slides[i];
				if (slidesCopy.indexOf(slide) < 0)
				{
					_slides.splice(i, 1);
					if (super.contains(slide)) super.removeChild(slide);
				}
			}
		}
		
		private function slide_mouseDownHandler(event:MouseEvent):void 
		{
			_selectedSlide = event.target as Slide;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true);
			if (_slideEditor)
			{
				(_slideEditor as IEditor).target = _selectedSlide;
				(_slideEditor as IEditor).show();
			}
		}
		
		private function mouseUpHandler(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
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
								if (nodeList.indexOf(node) != nodeList.lastIndexOf(node))
								{
									firstIndex = nodeList.indexOf(node);
									lastIndex = nodeList.lastIndexOf(node);
									needReplace = true;
									break;
								}
							}
							if (needReplace)
							{
								if (_dataProvider.*[firstIndex].contains(_dataProviderCopy.*[firstIndex]))
								{
									nodeList.splice(firstIndex, 1);
									_dataProvider.setChildren("");
									_dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
								else
								{
									nodeList.splice(lastIndex, 1);
									_dataProvider.setChildren("");
									_dataProvider.normalize();
									while (nodeList.length)
									{
										_dataProvider.appendChild(nodeList.shift());
									}
									_dataProviderCopy = _dataProvider.copy();
									return;
								}
							}
							invalidLayout = true;
						}
						break;
					case "textSet":
					case "nameSet":
					case "nodeChanged":
					case "nodeRemoved":
						invalidLayout = true;
						break;
					case "namespaceAdded":
						
						break;
					case "namespaceRemoved":
						
						break;
					case "namespaceSet":
						
						break;
			}
			_dataProviderCopy = _dataProvider.copy();
			super.dispatchEvent(new GUIEvent(GUIEvent.DATA_CHANGED));
		}
		
	}

}