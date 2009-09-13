package org.wvxvws.gui.renderers 
{
	//{imports
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.containers.Nest;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	import org.wvxvws.gui.StatefulButton;
	//}
	
	/**
	* BranchRenderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class BranchRenderer extends Sprite implements ILayoutClient, IMXMLObject, IBranchRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return _validator; }
		
		public function get invalidProperties():Object { return _invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			_layoutParent = value;
		}
		
		public function get childLayouts():Vector.<ILayoutClient>
		{
			return _childLayouts;
		}
		
		public function get id():String { return _id; }
		
		//public function get closed():Boolean { return !_opened; }
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			if (value)
			{
				dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true, true));
				_label.background = true;
				_label.backgroundColor = 0xD0D0D0;
			}
			else _label.background = false;
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IBranchRenderer */
		
		public function get closedHeight():int { return _closedHeight; }
		
		public function get opened():Boolean { return _opened; }
		
		public function set opened(value:Boolean):void
		{
			if (_opened === value) return;
			_opened = value;
			if (_opened) _openCloseIcon.state = "open";
			else _openCloseIcon.state = "closed";
			invalidate("_opened", _opened, true);
		}
		
		//{ display stuff
		public function set leafLabelFunction(value:Function):void
		{
			if (_leafLabelFunction === value) return;
			_leafLabelFunction = value;
			invalidate("_leafLabelFunction", _leafLabelFunction, false);
		}
		
		public function set leafLabelField(value:String):void
		{
			if (_leafLabelField === value) return;
			_leafLabelField = value;
			invalidate("_leafLabelField", _leafLabelField, false);
		}
		
		public function set folderIcon(value:Class):void
		{
			if (_folderIcon === value) return;
			_folderIcon = value;
			invalidate("_folderIcon", _folderIcon, false);
		}
		
		public function set closedIcon(value:Class):void
		{
			if (_closedIcon === value) return;
			_closedIcon = value;
			invalidate("_closedIcon", _closedIcon, false);
		}
		
		public function set openIcon(value:Class):void
		{
			if (_openIcon === value) return;
			_openIcon = value;
			invalidate("_openIcon", _openIcon, false);
		}
		
		public function set docIconFactory(value:Function):void
		{
			if (_docIconFactory === value) return;
			_docIconFactory = value;
			invalidate("_docIconFactory", _docIconFactory, false);
		}
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			invalidate("_labelFunction", _labelFunction, false);
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField === value) return;
			_labelField = value;
			invalidate("_labelField", _labelField, false);
		}
		
		public function set folderFactory(value:Function):void
		{
			if (_folderFactory === value) return;
			_folderFactory = value;
			invalidate("_folderFactory", _folderFactory, false);
		}
		//}
		
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
			invalidate("", undefined, true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _invalidProperties:Object = { };
		protected var _childLayouts:Vector.<ILayoutClient> = new Vector.<ILayoutClient>(0, false);
		protected var _layoutParent:ILayoutClient;
		protected var _validator:LayoutValidator;
		protected var _hasPendingValidation:Boolean;
		protected var _hasPendingParentValidation:Boolean;
		
		protected var _opened:Boolean;
		protected var _selected:Boolean;
		
		protected var _openCloseIcon:StatefulButton;
		protected var _folder:StatefulButton;
		protected var _label:TextField;
		protected var _lines:Shape;
		protected var _labelFormat:TextFormat = new TextFormat("_sans", 11);
		
		protected var _leafLabelField:String;
		
		protected var _docIconFactory:Function;
		protected var _leafLabelFunction:Function;
		
		protected var _labelField:String;
		protected var _labelFunction:Function;
		
		protected var _folderIcon:Class;
		protected var _folderFactory:Function;
		protected var _openIcon:Class;
		protected var _closedIcon:Class;
		
		protected var _closedHeight:int;
		protected var _dataCopy:XML;
		protected var _nest:Nest;
		protected var _dot:BitmapData;
		protected var _data:XML;
		
		private var _children:Dictionary = new Dictionary();
		private var _visibleChildren:Dictionary = new Dictionary();
		private var _cachedChildren:Dictionary = new Dictionary();
		
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
		
		public function BranchRenderer() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function validate(properties:Object):void
		{
			drawUI();
			createChildren();
			drawLines();
			_invalidProperties = { };
			_hasPendingValidation = false;
			if (properties.hasOwnProperty("_opened"))
				super.dispatchEvent(new GUIEvent(GUIEvent.OPENED, true, true));
		}
		
		public function invalidate(property:String, 
									cleanValue:*, validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator)
				_validator.requestValidation(this, validateParent);
			else
			{
				_hasPendingValidation = true;
				_hasPendingParentValidation = 
					_hasPendingParentValidation || validateParent;
			}
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
		
		public function indexForItem(renderer:IRenderer):int
		{
			if (renderer === this) return 0;
			var index:int = -1;
			var list:Array = [];
			_data.*.(list.push(nodeToRenderer(valueOf())));
			for (var obj:Object in _children)
			{
				if (obj === renderer)
				{
					return list.indexOf(renderer);
				}
				else if (obj is IBranchRenderer)
				{
					index = (obj as IBranchRenderer).indexForItem(renderer);
					if (index > -1) return list.indexOf(obj) + index;
				}
			}
			return -1;
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			if (_document is Nest) _nest = _document as Nest;
			if (_document is ILayoutClient)
			{
				_layoutParent = _document as ILayoutClient;
				_validator = _layoutParent.validator;
				_validator.append(this);
			}
			_id = id;
			if (_hasPendingValidation) invalidate("", undefined, true);
			addEventListener(GUIEvent.OPENED, childOpenedHandler);
			dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
		}
		
		private function childOpenedHandler(event:GUIEvent):void 
		{
			if (event.target !== this) validate(_invalidProperties);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function createChildren():void
		{
			var lastHeight:int = super.height;
			if (!_data) return;
			var obj:Object;
			for (obj in _children)
			{
				if (contains(obj as DisplayObject))
					_cachedChildren[removeChild(obj as DisplayObject)] = true;
			}
			if (_layoutParent && lastHeight !== super.height)
			{
				//_layoutParent.invalidate("", undefined, true);
				//trace("1 lastHeight, super.height", lastHeight, super.height);
			}
			if (!_opened) return;
			removeChild(_lines);
			var list:XMLList = _data.*;
			if (!list.length()) return;
			var child:IRenderer;
			for each (var xml:XML in list)
			{
				if (xml.hasComplexContent()) child = createBranch(xml);
				else child = createLeaf(xml);
				_cachedChildren[child] = true;
				_children[child] = true;
				_visibleChildren[child] = true;
				if (child is ILayoutClient)
				{
					if (_childLayouts.indexOf(child as ILayoutClient) < 0)
						_childLayouts.push(child as ILayoutClient);
					(child as ILayoutClient).layoutParent = this;
					(child as ILayoutClient).validate(
							(child as ILayoutClient).invalidProperties);
				}
				(child as DisplayObject).y = super.height;
				(child as DisplayObject).x = _folder.x;
				child.data = xml;
				if (child is ILayoutClient)
				{
					(child as ILayoutClient).validate(
						(child as ILayoutClient).invalidProperties);
				}
				if (child is IMXMLObject)
				{
					(child as IMXMLObject).initialized(this, xml.localName());
				}
				addChild(child as DisplayObject);
			}
			if (_layoutParent && lastHeight !== super.height)
			{
				//trace("2 lastHeight, super.height", lastHeight, super.height);
				//_layoutParent.invalidate("", undefined, true);
			}
		}
		
		private function createLeaf(xml:XML):IRenderer
		{
			var ibRenderer:IRenderer;
			for (var obj:Object in _cachedChildren)
			{
				if ((obj as IRenderer).data && (obj as IRenderer).data === xml)
				{
					ibRenderer = obj as IRenderer;
					break;
				}
			}
			if (!ibRenderer) ibRenderer = new LeafRenderer();
			if (_leafLabelField !== "" && _leafLabelField !== null)
				ibRenderer.labelField = _leafLabelField;
			if (_leafLabelFunction !== null)
			{
				ibRenderer.labelFunction = _leafLabelFunction;
			}
			if (ibRenderer is LeafRenderer)
			{
				(ibRenderer as LeafRenderer).iconFactory = _docIconFactory; 
			}
			return ibRenderer;
		}
		
		private function createBranch(xml:XML):IBranchRenderer
		{
			var ibRenderer:IBranchRenderer;
			for (var obj:Object in _cachedChildren)
			{
				if (!(obj is IBranchRenderer)) continue;
				if ((obj as IBranchRenderer).data === xml)
				{
					ibRenderer = obj as IBranchRenderer;
					break;
				}
			}
			if (!ibRenderer) ibRenderer = new BranchRenderer();
			ibRenderer.closedIcon = _closedIcon;
			ibRenderer.openIcon = _openIcon;
			ibRenderer.docIconFactory = _docIconFactory;
			if (_labelField !== "" && _labelField !== null)
				ibRenderer.labelField = _labelField;
			if (_leafLabelFunction !== null)
			{
				ibRenderer.leafLabelFunction = _leafLabelFunction;
			}
			ibRenderer.folderIcon = _folderIcon;
			ibRenderer.folderFactory = _folderFactory;
			if (_labelFunction !== null)
				ibRenderer.labelFunction = _labelFunction;
			return ibRenderer;
		}
		
		protected function drawUI():void
		{
			if (!_openCloseIcon)
			{
				_openCloseIcon = new StatefulButton();
				_openCloseIcon.initialized(this, "openCloseIcon");
				_openCloseIcon.addEventListener(MouseEvent.CLICK, openClose_clickHandler);
			}
			if (!_openCloseIcon.states.open && _openIcon)
			{
				_openCloseIcon.states.open = _openIcon;
			}
			if (!_openCloseIcon.states.closed && _closedIcon)
			{
				_openCloseIcon.states.closed = _closedIcon;
			}
			if (_opened) _openCloseIcon.state = "open";
			else _openCloseIcon.state = "closed";
			_openCloseIcon.y = 5;
			addChild(_openCloseIcon);
			
			if (!_folder)
			{
				_folder = new StatefulButton();
				_folder.initialized(this, "folder");
				_folder.addEventListener(MouseEvent.CLICK, folder_clickHandler);
			}
			if (!_folder.states.open && _folderIcon)
			{
				if (_folderFactory !== null && _data)
					_folderIcon = _folderFactory(_data.toXMLString()) as Class;
				_folder.states.open = _folderIcon;
			}
			if (_opened) _folder.state = "open";
			else _folder.state = "open";
			_folder.x = 17;
			_folder.y = 1;
			_openCloseIcon.x = (_folder.width - _openCloseIcon.width) >> 1;
			addChild(_folder);
			
			if (!_label) addChild(_label = new TextField()) as TextField;
			{
				_label.height = 10;
				_label.defaultTextFormat = _labelFormat;
				_label.selectable = false;
				_label.doubleClickEnabled = true;
				_label.addEventListener(MouseEvent.DOUBLE_CLICK, label_clickDoubleHandler);
				_label.addEventListener(MouseEvent.CLICK, label_clickHandler);
				_label.addEventListener(FocusEvent.FOCUS_OUT, label_focusOutHandler);
				_label.autoSize = TextFieldAutoSize.LEFT;
			}
			if (_labelFunction !== null && _data)
			{
				_label.text = _labelFunction(_data.toXMLString());
			}
			else if (_labelField && _data)
			{
				_label.text = _data[_labelField];
			}
			else if (_data)
			{
				_label.text = _data.localName();
			}
			else _label.text = "";
			_label.x = _folder.x + _folder.width + 3;
		}
		
		private function openClose_clickHandler(event:MouseEvent):void 
		{
			opened = !_opened;
		}
		
		private function label_clickHandler(event:MouseEvent):void 
		{
			selected = true;
		}
		
		private function label_focusOutHandler(event:FocusEvent):void 
		{
			_label.selectable = false;
			_label.border = false;
			_label.type = TextFieldType.DYNAMIC;
		}
		
		private function label_clickDoubleHandler(event:MouseEvent):void 
		{
			_label.selectable = true;
			_label.setSelection(0, _label.text.length);
			_label.border = true;
			_label.borderColor = 0xA0A0A0;
			_label.type = TextFieldType.INPUT;
		}
		
		private function folder_clickHandler(event:MouseEvent):void 
		{
			selected = true;
		}
		
		public function unselectRecursively(selection:DisplayObject):Boolean
		{
			var ret:Boolean;
			if (selection !== this)
			{
				if (_selected)
				{
					selected = false;
					return false;
				}
			}
			for (var dobj:Object in _children)
			{
				if ((dobj is BranchRenderer))
				{
					ret = (dobj as BranchRenderer).unselectRecursively(selection);
					if (!ret) return false;
				}
				else if ((dobj is LeafRenderer))
				{
					if ((dobj as LeafRenderer).selected && 
						selection !== (dobj as DisplayObject))
					{
						(dobj as LeafRenderer).selected = false;
						return false;
					}
				}
			}
			return true;
		}
		
		protected function drawLines():void
		{
			if (!_lines) _lines = addChildAt(new Shape(), 0) as Shape;
			if (!contains(_lines)) addChildAt(_lines, 0);
			var g:Graphics = _lines.graphics;
			var cumulativeHeight:int = _folder.height + 2;
			var child:DisplayObject;
			if (!_dot)
			{
				_dot = new BitmapData(2, 2, true, 0x00FFFFFF);
				_dot.setPixel32(0, 1, 0xFFA0A0A0);
				_dot.setPixel32(1, 0, 0xFFA0A0A0);
			}
			g.clear();
			if (_opened)
			{
				cumulativeHeight = 
					super.height - (_folder.y + ((_folder.height * 1.5) >> 0)) - 1;
				child = getBottomChild();
				if (child && child is BranchRenderer)
					cumulativeHeight -= (child.height - 14);
				g.beginBitmapFill(_dot);
				g.drawRect(_folder.x + (_folder.width >> 1) - 1, 
							_folder.y + _folder.height, 1, cumulativeHeight);
				g.endFill();
			}
			g.beginBitmapFill(_dot);
			g.drawRect(_openCloseIcon.x + _openCloseIcon.width, 
						_folder.y + (_folder.height >> 1), 
						_folder.x - (_openCloseIcon.x + _openCloseIcon.width), 1);
			g.endFill();
		}
		
		protected function getBottomChild():DisplayObject
		{
			var i:int = super.numChildren;
			if (!i) return null;
			var child:DisplayObject;
			var compareTo:DisplayObject;
			while (i--)
			{
				if (!child) child = super.getChildAt(i);
				else
				{
					compareTo = super.getChildAt(i);
					if (compareTo.y > child.y)
						child = compareTo;
				}
			}
			return child;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}