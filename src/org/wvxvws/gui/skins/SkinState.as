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
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.core.IMXMLObject;
	//}
	
	/**
	* State class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SkinState extends Sprite implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property event
		//------------------------------------
		
		[Bindable("eventChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>eventChange</code> event.
		*/
		public function get event():String { return _event; }
		
		public function set event(value:String):void 
		{
			if (_event == value) return;
			_event = value;
			dispatchEvent(new Event("eventChange"));
		}
		
		//------------------------------------
		//  Public property content
		//------------------------------------
		
		[Bindable("contentChange")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>contentChange</code> event.
		*/
		public function get content():DisplayObject
		{
			if (!_content) _content = this;
			return _content;
		}
		
		public function set content(value:DisplayObject):void 
		{
			if (_content == value) return;
			_content = value;
			dispatchEvent(new Event("contentChange"));
		}
		
		public function get source():Class { return _source; }
		
		public function set source(value:Class):void 
		{
			_content = new (value as Class)() as DisplayObject;
			if (!_content) _content = this;
			_source = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _event:String;
		protected var _content:DisplayObject;
		protected var _source:Class;
		protected var _document:Skin;
		protected var _id:String;
		
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
		
		public function SkinState() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			if (document is Skin) _document = document as Skin;
			_id = id;
		}
		
		public function clone():SkinState
		{
			var st:SkinState = new SkinState();
			st.event = _event;
			if (!_content || _content == this) return st;
			st.source = _source;
			return st;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}