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
		override public function get y():Number
		{
			if (_content && _content !== this) return _content.y;
			return _y;
		}
		
		override public function set y(value:Number):void 
		{
			//trace("setting Y from setter:", value);
			if (_content && _content !== this)
			{
				_content.y = value;
			}
			_y = value;
			_wasYChange = true;
		}
		override public function get x():Number
		{
			if (_content && _content !== this) return _content.x;
			return _x;
		}
		
		override public function set x(value:Number):void 
		{
			if (_content && _content !== this)
			{
				_content.x = value;
			}
			_x = value;
			_wasXChange = true;
		}
		
		override public function get width():Number
		{
			if (_content && _content !== this) return _content.width;
			return _width;
		}
		
		override public function set width(value:Number):void 
		{
			if (_content && _content !== this)
			{
				_content.width = value;
			}
			_width = value;
			_wasWidthChange = true;
		}
		
		override public function get height():Number
		{
			if (_content && _content !== this) return _content.height;
			return _height;
		}
		
		override public function set height(value:Number):void 
		{
			if (_content && _content !== this)
			{
				_content.height = value;
			}
			_height = value;
			_wasHeightChange = true;
		}
		
		override public function get rotation():Number
		{
			if (_content && _content !== this) return _content.rotation;
			return _rotation;
		}
		
		override public function set rotation(value:Number):void 
		{
			if (_content && _content !== this)
			{
				_content.rotation = value;
			}
			_rotation = value;
			_wasRotated = true;
		}
		
		override public function get scaleX():Number
		{
			if (_content && _content !== this) return _content.scaleX;
			return _scaleX;
		}
		
		override public function set scaleX(value:Number):void 
		{
			if (_content && _content !== this)
			{
				_content.scaleX = value;
			}
			_scaleX = value;
			//_wasRotated = true;
		}
		
		override public function get scaleY():Number
		{
			if (_content && _content !== this) return _content.scaleY;
			return _scaleY;
		}
		
		override public function set scaleY(value:Number):void 
		{
			if (_content && _content !== this)
			{
				_content.scaleY = value;
			}
			_scaleY = value;
		}
		
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
			if (!_states[value]) return;
			if (!(_states[value] is DisplayObject)) return;
			//trace("Enter state: ", value);
			var sc:DisplayObject;
			//var wasNotInit:Boolean = numChildren > 0;
			//var wasStateEmpty:Boolean = true;
			//var previousBounds:Rectangle;
			var previousState:DisplayObject;
			for each (sc in _states)
			{
				if (contains(sc))
				{
					//previousBounds = getBounds(this);
					previousState = removeChild(sc);
					if (sc is MovieClip) (sc as MovieClip).gotoAndStop(1);
				}
				else if (sc is SkinState && contains((sc as SkinState).content))
				{
					//if ((sc as SkinState).content !== sc)
					//{
						//wasStateEmpty = false;
					//}
					//previousBounds = getBounds(this);
					previousState = removeChild((sc as SkinState).content);
					if ((sc as SkinState).content is MovieClip)
					{
						((sc as SkinState).content as MovieClip).gotoAndStop(1);
					}
				}
			}
			sc = _states[value];
			//var isStateEmpty:Boolean;
			if (sc is SkinState) sc = (sc as SkinState).content;
			//if (sc is SkinState) isStateEmpty = true;
			_content = sc;
			addChildAt(sc, 0);
			//trace("is same state?", sc, previousState);
			if (sc === previousState)
			{
				return;
			}
			//trace("is same state? >>>", sc.height, sc.width);
			if (previousState)
			{
				//trace("previousState", previousState, sc);
				sc.x = previousState.x;
				sc.y = previousState.y;
				sc.rotation = previousState.rotation;
				sc.width = previousState.width;
				sc.height = previousState.height;
			}
			else
			{
				//trace("new state", sc);
				if (_wasHeightChange) 
				{
					sc.height = _height;
				}
				if (_wasWidthChange) 
				{
					sc.width = _width;
				}
				if (_wasRotated) 
				{
					sc.rotation = _rotation;
				}
				if (_wasYChange)
				{
					trace("Set Y to:", _y);
					sc.y = _y;
				}
				if (_wasXChange)
				{
					sc.x = _x;
				}
			}
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
		protected var _content:DisplayObject;
		protected var _rotation:int;
		protected var _width:int;
		protected var _height:int;
		protected var _x:int;
		protected var _y:int;
		protected var _wasRotated:Boolean;
		protected var _wasWidthChange:Boolean;
		protected var _wasHeightChange:Boolean;
		protected var _wasXChange:Boolean;
		protected var _wasYChange:Boolean;
		protected var _scaleX:Number;
		protected var _scaleY:Number;
		
		public function Skin() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function clone():Skin
		{
			var clonedStates:Array = [];
			var clonedSkin:Skin = new Skin();
			var cs:DisplayObject;
			var st:SkinState;
			for (var p:String in _states)
			{
				cs = _states[p];
				if (cs is SkinState)
				{
					st = (cs as SkinState).clone();
					st.initialized(this, st.event);
				}
				else
				{
					st = new SkinState();
					st.event = p;
					st.source = (cs as Object).constructor as Class;
				}
				clonedStates.push(st);
			}
			clonedSkin.states = clonedStates as Object;
			return clonedSkin;
		}
	}
}