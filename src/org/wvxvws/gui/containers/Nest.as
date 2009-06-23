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

package org.wvxvws.gui.containers 
{
	import flash.events.Event;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.IBranchRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.NestBranchRenderer;
	import org.wvxvws.gui.renderers.NestLeafRenderer;
	import flash.display.DisplayObject;
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * Nest class.
	 * @author wvxvw
	 */
	public class Nest extends Pane
	{
		protected var _branchRenderer:Class = NestBranchRenderer;
		protected var _leafRenderer:Class = NestLeafRenderer;
		protected var _nextY:int;
		protected var _selectedItem:XML;
		protected var _selectedChild:IRenderer;
		
		protected var _branchLabelField:String = "@label";
		protected var _leafLabelField:String = "@label";
		
		protected var _branchLabelFunction:Function = defaultLabelFunction;
		protected var _leafLabelFunction:Function = defaultLabelFunction;
		
		protected var _folderIcon:Class;
		protected var _closedIcon:Class;
		protected var _openIcon:Class;
		protected var _docIcon:Class;
		
		public function Nest()
		{
			super();
			_rendererFactory = _branchRenderer;
			addEventListener(GUIEvent.SELECTED, selectedHandler);
		}
		
		protected function selectedHandler(event:GUIEvent):void 
		{
			_selectedChild = event.target as IRenderer;
			if (!_selectedChild) return;
			_selectedItem = _selectedChild.data;
			if (event.target === this || !(event.target is _branchRenderer)) return;
			_nextY = 0;
			layOutChildren();
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			var isbranch:Boolean;
			if (xml.hasSimpleContent())
			{
				_rendererFactory = _leafRenderer;
				_labelFunction = _leafLabelFunction;
				_labelField = _leafLabelField;
			}
			else
			{
				_rendererFactory = _branchRenderer;
				_labelFunction = _branchLabelFunction;
				_labelField = _branchLabelField;
				isbranch = true;
			}
			var child:DisplayObject = super.createChild(xml);
			if (!child) return null;
			if (isbranch)
			{
				(child as IBranchRenderer).leafLabelField = _leafLabelField;
				(child as IBranchRenderer).leafLabelFunction = _leafLabelFunction;
				(child as IBranchRenderer).folderIcon = _folderIcon;
				(child as IBranchRenderer).closedIcon = _closedIcon;
				(child as IBranchRenderer).openIcon = _openIcon;
				(child as IBranchRenderer).docIcon = _docIcon;
			}
			else if (child is NestLeafRenderer)
			{
				(child as NestLeafRenderer).iconClass = _docIcon;
			}
			child.y = _nextY;
			_nextY += child.height;
			return child;
		}
		
		protected function defaultLabelFunction(input:String):String { return input; }
		
		public function get selectedItem():XML { return _selectedItem; }
		
		public function get selectedChild():IRenderer { return _selectedChild; }
		
		[Bindable("branchLabelFieldChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>branchLabelFieldChange</code> event.
		*/
		public function get branchLabelField():String { return _branchLabelField; }
		
		public function set branchLabelField(value:String):void 
		{
			if (_branchLabelField === value) return;
			_branchLabelField = value;
			invalidLayout = true;
			dispatchEvent(new Event("branchLabelFieldChange"));
		}
		
		[Bindable("leafLabelFieldChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leafLabelFieldChange</code> event.
		*/
		public function get leafLabelField():String { return _leafLabelField; }
		
		public function set leafLabelField(value:String):void 
		{
			if (_leafLabelField === value) return;
			_leafLabelField = value;
			invalidLayout = true;
			dispatchEvent(new Event("leafLabelFieldChange"));
		}
		
		[Bindable("leafLabelFunctionChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>leafLabelFunctionChange</code> event.
		*/
		public function get leafLabelFunction():Function { return _leafLabelFunction; }
		
		public function set leafLabelFunction(value:Function):void 
		{
			if (_leafLabelFunction === value) return;
			_leafLabelFunction = value;
			invalidLayout = true;
			dispatchEvent(new Event("leafLabelFunctionChange"));
		}
		
		[Bindable("branchLabelFunctionChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>branchLabelFunctionChange</code> event.
		*/
		public function get branchLabelFunction():Function { return _branchLabelFunction; }
		
		public function set branchLabelFunction(value:Function):void 
		{
			if (_branchLabelFunction === value) return;
			_branchLabelFunction = value;
			invalidLayout = true;
			dispatchEvent(new Event("branchLabelFunctionChange"));
		}
		
		public function get folderIcon():Class { return _folderIcon; }
		
		public function set folderIcon(value:Class):void 
		{
			if (_folderIcon === value) return;
			_folderIcon = value;
			invalidLayout = true;
		}
		
		public function get closedIcon():Class { return _closedIcon; }
		
		public function set closedIcon(value:Class):void 
		{
			if (_closedIcon === value) return;
			_closedIcon = value;
			invalidLayout = true;
		}
		
		public function get openIcon():Class { return _openIcon; }
		
		public function set openIcon(value:Class):void 
		{
			if (_openIcon === value) return;
			_openIcon = value;
			invalidLayout = true;
		}
		
		public function get docIcon():Class { return _docIcon; }
		
		public function set docIcon(value:Class):void 
		{
			if (_docIcon === value) return;
			_docIcon = value;
			invalidLayout = true;
		}
	}
	
}