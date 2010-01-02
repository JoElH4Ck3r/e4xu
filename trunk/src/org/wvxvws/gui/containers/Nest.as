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

// TODO: Have to use SkinProducers.

package org.wvxvws.gui.containers 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import mx.core.IMXMLObject;
	import org.wvxvws.binding.EventGenerator;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.renderers.IBranchRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.BranchRenderer;
	import org.wvxvws.gui.renderers.LeafRenderer;
	import flash.display.DisplayObject;
	
	[Exclude(name="addChild", kind="property")]
	[Exclude(name="addChildAt", kind="property")]
	[Exclude(name="removeChild", kind="property")]
	[Exclude(name="removeChildAt", kind="property")]
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * Nest class.
	 * @author wvxvw
	 */
	public class Nest extends Pane
	{
		public function get selectedItem():XML { return this._selectedItem; }
		
		public function get selectedChild():IRenderer { return this._selectedChild; }
		
		[Bindable("branchLabelFieldChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>branchLabelFieldChanged</code> event.
		*/
		public function get branchLabelField():String { return this._branchLabelField; }
		
		public function set branchLabelField(value:String):void 
		{
			if (this._branchLabelField === value) return;
			this._useBranchLabel = (value !== "" && value !== null);
			this._branchLabelField = value;
			super.invalidate("_branchLabelField", this._branchLabelField, false);
			if (super.hasEventListener(EventGenerator.getEventType("branchLabelField")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("leafLabelFieldChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leafLabelFieldChanged</code> event.
		*/
		public function get leafLabelField():String { return this._leafLabelField; }
		
		public function set leafLabelField(value:String):void 
		{
			if (this._leafLabelField === value) return;
			this._leafLabelField = value;
			this._useLeafLabel = (value !== "" && value !== null);
			super.invalidate("_leafLabelField", _leafLabelField, false);
			if (super.hasEventListener(EventGenerator.getEventType("leafLabelField")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("leafLabelFunctionChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leafLabelFunctionChanged</code> event.
		*/
		public function get leafLabelFunction():Function { return this._leafLabelFunction; }
		
		public function set leafLabelFunction(value:Function):void 
		{
			if (this._leafLabelFunction === value) return;
			this._leafLabelFunction = value;
			super.invalidate("_leafLabelFunction", _leafLabelFunction, false);
			if (super.hasEventListener(EventGenerator.getEventType("leafLabelFunction")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		[Bindable("branchLabelFunctionChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>branchLabelFunctionChanged</code> event.
		*/
		public function get branchLabelFunction():Function { return this._branchLabelFunction; }
		
		public function set branchLabelFunction(value:Function):void 
		{
			if (_branchLabelFunction === value) return;
			_branchLabelFunction = value;
			_useBrunchFunction = Boolean(value);
			super.invalidate("_branchLabelFunction", _branchLabelFunction, false);
			if (super.hasEventListener(EventGenerator.getEventType("branchLabelFunction")))
				super.dispatchEvent(EventGenerator.getEvent());
		}
		
		public function get folderIcon():Class { return _folderIcon; }
		
		public function set folderIcon(value:Class):void 
		{
			if (_folderIcon === value) return;
			_folderIcon = value;
			super.invalidate("_folderIcon", _folderIcon, false);
		}
		
		public function get closedIcon():Class { return _closedIcon; }
		
		public function set closedIcon(value:Class):void 
		{
			if (_closedIcon === value) return;
			_closedIcon = value;
			super.invalidate("_closedIcon", _closedIcon, false);
		}
		
		public function get openIcon():Class { return _openIcon; }
		
		public function set openIcon(value:Class):void 
		{
			if (_openIcon === value) return;
			_openIcon = value;
			super.invalidate("_openIcon", _openIcon, false);
		}
		
		public function get docIcon():Class { return _docIcon; }
		
		public function set docIcon(value:Class):void 
		{
			if (_docIcon === value) return;
			_docIcon = value;
			super.invalidate("_docIcon", _docIcon, false);
		}
		
		public function get docIconFactory():Function { return _docIconFactory; }
		
		public function set docIconFactory(value:Function):void 
		{
			if (_docIconFactory === value) return;
			_docIconFactory = value;
			super.invalidate("_docIconFactory", _docIconFactory, false);
		}
		
		public function get lastOpened():int { return _lastOpened; }
		
		protected var _branchRenderer:Class = BranchRenderer;
		protected var _leafRenderer:Class = LeafRenderer;
		protected var _nextY:int;
		protected var _selectedItem:XML;
		protected var _selectedChild:IRenderer;
		
		protected var _branchLabelField:String = "@label";
		protected var _leafLabelField:String = "@label";
		
		protected var _branchLabelFunction:Function;// = defaultLabelFunction;
		protected var _leafLabelFunction:Function;// = defaultLabelFunction;
		protected var _docIconFactory:Function = defaultDocFactory;
		
		protected var _folderIcon:Class;
		protected var _closedIcon:Class;
		protected var _openIcon:Class;
		protected var _docIcon:Class;
		
		protected var _cumulativeHeight:int;
		protected var _cumulativeWidth:int;
		protected var _pendingChildren:Dictionary = new Dictionary();
		protected var _lastOpened:int = -1;
		protected var _closedNodes:Dictionary = new Dictionary();
		
		protected var _selectedEvent:GUIEvent;
		protected var _useBranchLabel:Boolean;
		protected var _useLeafLabel:Boolean;
		protected var _useBrunchFunction:Boolean;
		protected var _children:Vector.<DisplayObject> = 
						new Vector.<DisplayObject>(0, false);
		
		public function Nest()
		{
			super();
			super._rendererFactory = _branchRenderer;
			addEventListener(GUIEvent.SELECTED, selectedHandler, false, int.MAX_VALUE);
			addEventListener(GUIEvent.OPENED, openedHandler, false, int.MAX_VALUE);
		}
		
		private function openedHandler(event:GUIEvent):void 
		{
			if (event.target !== this)
			{
				event.stopImmediatePropagation();
				layOutChildren();
				dispatchEvent(new GUIEvent(GUIEvent.OPENED));
			}
		}
		
		public function isRendererVisible(renderer:IRenderer):Boolean
		{
			var rParent:DisplayObject = (renderer as DisplayObject).parent;
			if (rParent === this) return true;
			if (!rParent) return false;
			while (rParent !== this)
			{
				if (rParent is IBranchRenderer && 
					!(rParent as IBranchRenderer).opened)
				{
					return false;
				}
				rParent = rParent.parent;
				if (!rParent) return false;
			}
			return true;
		}
		
		protected function selectedHandler(event:GUIEvent):void 
		{
			_selectedChild = event.target as IRenderer;
			if (!_selectedChild) return;
			event.stopImmediatePropagation();
			_selectedItem = _selectedChild.data;
			for each (var obj:DisplayObject in _children)
			{
				if (obj is BranchRenderer)
				{
					if (!(obj as BranchRenderer).unselectRecursively(
									_selectedChild as DisplayObject))
						break;
				}
				if (obj is LeafRenderer)
				{
					if ((obj as LeafRenderer).selected && obj !== _selectedChild)
					{
						(obj as LeafRenderer).selected = false;
						break;
					}
				}
			}
			dispatchEvent(new GUIEvent(GUIEvent.SELECTED));
		}
		
		protected override function layOutChildren():void 
		{
			_cumulativeHeight = 0;
			_cumulativeWidth = 0;
			_nextY = 0;
			super.layOutChildren();
			super.width = _cumulativeWidth;
			super.height = _cumulativeHeight;
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			var isbranch:Boolean;
			if (xml.hasSimpleContent())
			{
				_rendererFactory = _leafRenderer;
				_labelFunction = _leafLabelFunction;
				if (_useLeafLabel) _labelField = _leafLabelField;
			}
			else
			{
				_rendererFactory = _branchRenderer;
				_labelFunction = _branchLabelFunction;
				if (_useBranchLabel) _labelField = _branchLabelField;
				isbranch = true;
			}
			var child:DisplayObject = super.createChild(xml);
			_dispatchCreated = false;
			if (!child) return null;
			if (_children.indexOf(child) < 0)
				_children.push(child);
			var ci:int = getIndexForItem(child);
			if (isbranch)
			{
				(child as IBranchRenderer).leafLabelField = _leafLabelField;
				if (_labelFunction !== null)
					(child as IBranchRenderer).leafLabelFunction = _leafLabelFunction;
				if (_useBrunchFunction)
					(child as IBranchRenderer).labelFunction = _branchLabelFunction;
				(child as IBranchRenderer).folderIcon = _folderIcon;
				(child as IBranchRenderer).closedIcon = _closedIcon;
				(child as IBranchRenderer).openIcon = _openIcon;
				(child as IBranchRenderer).docIconFactory = _docIconFactory;
			}
			else if (child is LeafRenderer)
			{
				(child as LeafRenderer).iconClass = 
					_docIconFactory((child as LeafRenderer).data);
			}
			if (child is ILayoutClient && _childLayouts.indexOf(child as ILayoutClient) < 0)
				_childLayouts.push(child as ILayoutClient);
			if (child is IMXMLObject)
				(child as IMXMLObject).initialized(this, xml.localName());
			child.y = _nextY;
			_nextY += child.height;
			_cumulativeHeight += child.height;
			_cumulativeWidth = Math.max(_cumulativeWidth, child.width);
			return child;
		}
		
		public function positionToRenderer(position:int):DisplayObject
		{
			var list:XMLList = _dataProvider..*;
			var renderers:Array = [];
			list.(renderers.push(getItemForNode(valueOf())));
			var b:Rectangle;
			var ret:DisplayObject;
			var foundBounds:Rectangle;
			for each (var r:DisplayObject in renderers)
			{
				if (!r) continue;
				b = r.getRect(this);
				if (b.top <= position && b.bottom >= position)
				{
					if (foundBounds && foundBounds.height > b.height && r.stage)
					{
						foundBounds = b;
						ret = r;
					}
					else if (!foundBounds)
					{
						foundBounds = b;
						ret = r;
					}
				}
			}
			return ret;
		}
		
		public override function getIndexForItem(renderer:DisplayObject):int 
		{
			var index:int;
			var xml:XML = (renderer as IRenderer).data;
			var list:XMLList = _dataProvider..*;
			var arr:Array = [];
			list.(arr.push(valueOf()));
			for each (var item:XML in arr)
			{
				if (item === xml) return index;
				index++;
			}
			return -1;
		}
		
		public function nodeIsClosed(index:int):Boolean
		{
			return (index in _closedNodes);
		}
		
		override public function getIndexForNode(node:XML, position:int = -1):int 
		{
			var index:int;
			var list:XMLList = _dataProvider..*;
			var arr:Array = [];
			list.(arr.push(valueOf()));
			for each (var item:XML in arr)
			{
				if (item === node) return index;
				index++;
			}
			return -1;
		}
		
		protected function defaultDocFactory(input:String):Class { return _docIcon; }
		
		public override function getItemForNode(node:XML):DisplayObject
		{
			var ret:IRenderer;
			for each(var renderer:DisplayObject in super._removedChildren)
			{
				if (renderer is IRenderer)
				{
					if (renderer is IBranchRenderer)
					{
						if ((renderer as IBranchRenderer).data === node)
							return renderer;
						ret = (renderer as IBranchRenderer).nodeToRenderer(node);
						if (ret) return ret as DisplayObject;
					}
					else
					{
						if ((renderer as IRenderer).data === node)
							return renderer;
					}
				}
			}
			return null;
		}
		
		public function rendererToXML(renderer:IRenderer):XML
		{
			var ret:XML;
			for each(var rend:DisplayObject in super._removedChildren)
			{
				if (renderer === rend) return (rend as IRenderer).data;
				if (rend is IBranchRenderer)
				{
					ret = (rend as IBranchRenderer).rendererToXML(renderer);
					if (ret) return ret;
				}
			}
			return null;
		}
		
	}
	
}