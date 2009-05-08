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

package org.wvxvws.gui.skins
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	//}
	
	[DefaultProperty("states")]
	
	/**
	 * Skin class.
	 * @author wvxvw
	 */
	public class Skin extends Sprite implements IMXMLObject, ISkin
	{
		//------------------------------------
		//  Public property state
		//------------------------------------
		
		[Bindable("stateChange")]
		
		/**
		 * ...
		 * This property can be used as the source for data binding.
		 * When this property is modified, it dispatches the <code>stateChange</code> event.
		 */
		public function get state():String { return _state; }
		
		public function set state(value:String):void 
		{
			if (_state == value) return;
			if (!_states[state]) return;
			if (!(_states[state] is DisplayObject)) return;
			_bounds = getBounds(this);
			var sc:DisplayObject;
			for each (sc in _states)
			{
				if (contains(sc))
				{
					removeChild(sc);
					if (sc is MovieClip) (sc as MovieClip).gotoAndStop(1);
				}
				else if (sc is SkinState && contains((sc as SkinState).content))
				{
					removeChild((sc as SkinState).content);
					if ((sc as SkinState).content is MovieClip)
					{
						((sc as SkinState).content as MovieClip).gotoAndStop(1);
					}
				}
			}
			sc = _states[state];
			if (sc is SkinState) sc = (sc as SkinState).content;
			sc.width = _bounds.width;
			sc.height = _bounds.height;
			sc.x = _bounds.x;
			sc.y = _bounds.y;
			addChildAt(sc, 0);
			_state = value;
			dispatchEvent(new Event("stateChange"));
		}
		
		//------------------------------------
		//  Public property states
		//------------------------------------
		
		public function get states():Object { return _states; }
		
		public function set states(value:Object):void 
		{
			if (_rawStates === value) return;
			_rawStates = value as Array;
			for each (var st:SkinState in _rawStates)
			{
				_states[st.event] = st;
				st.initialized(this, null);
			}
		}
		
		protected var _rawStates:Array;
		protected var _states:Object = {};
		protected var _state:String;
		protected var _bounds:Rectangle;
		protected var _document:Object;
		protected var _id:String;
		
		public function Skin() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
	}
	
}