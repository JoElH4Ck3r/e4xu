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
	import org.wvxvws.gui.renderers.IBrunchRenderer;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.NestBrunchRenderer;
	import org.wvxvws.gui.renderers.NestLeafRenderer;
	import flash.display.DisplayObject;
	
	[Event(name="selected", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * Nest class.
	 * @author wvxvw
	 */
	public class Nest extends Pane
	{
		protected var _brunchRenderer:Class = NestBrunchRenderer;
		protected var _leafRenderer:Class = NestLeafRenderer;
		protected var _nextY:int;
		protected var _selectedItem:XML;
		protected var _selectedChild:IRenderer;
		
		protected var _brunchLabelField:String = "@label";
		protected var _leafLabelField:String = "@label";
		
		protected var _brunchLabelFunction:Function = defaultLabelFunction;
		protected var _leafLabelFunction:Function = defaultLabelFunction;
		
		public function Nest()
		{
			super();
			_rendererFactory = _brunchRenderer;
			addEventListener(GUIEvent.SELECTED, selectedHandler);
		}
		
		protected function selectedHandler(event:GUIEvent):void 
		{
			_selectedChild = event.target as IRenderer;
			if (!_selectedChild) return;
			_selectedItem = _selectedChild.data;
			if (event.target === this || !(event.target is _brunchRenderer)) return;
			_nextY = 0;
			layOutChildren();
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			var isBrunch:Boolean;
			if (xml.hasSimpleContent())
			{
				_rendererFactory = _leafRenderer;
				_labelFunction = _leafLabelFunction;
				_labelField = _leafLabelField;
			}
			else
			{
				_rendererFactory = _brunchRenderer;
				_labelFunction = _brunchLabelFunction;
				_labelField = _brunchLabelField;
				isBrunch = true;
			}
			var child:DisplayObject = super.createChild(xml);
			if (!child) return null;
			if (isBrunch)
			{
				(child as IBrunchRenderer).leafLabelField = _leafLabelField;
				(child as IBrunchRenderer).leafLabelFunction = _leafLabelFunction;
			}
			child.y = _nextY;
			_nextY += child.height;
			return child;
		}
		
		protected function defaultLabelFunction(input:String):String { return input; }
		
		public function get selectedItem():XML { return _selectedItem; }
		
		public function get selectedChild():IRenderer { return _selectedChild; }
		
		[Bindable("brunchLabelFieldChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>brunchLabelFieldChange</code> event.
		*/
		public function get brunchLabelField():String { return _brunchLabelField; }
		
		public function set brunchLabelField(value:String):void 
		{
			if (_brunchLabelField === value) return;
			_brunchLabelField = value;
			invalidLayout = true;
			dispatchEvent(new Event("brunchLabelFieldChange"));
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
		
		[Bindable("brunchLabelFunctionChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>brunchLabelFunctionChange</code> event.
		*/
		public function get brunchLabelFunction():Function { return _brunchLabelFunction; }
		
		public function set brunchLabelFunction(value:Function):void 
		{
			if (_brunchLabelFunction === value) return;
			_brunchLabelFunction = value;
			invalidLayout = true;
			dispatchEvent(new Event("brunchLabelFunctionChange"));
		}
	}
	
}