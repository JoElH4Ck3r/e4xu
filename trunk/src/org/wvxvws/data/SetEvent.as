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

package org.wvxvws.data
{
	import flash.events.Event;
	
	/**
	* DataChangeEvent event.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SetEvent extends Event 
	{
		public function get data():Object { return this._data; }
		
		public function get index():int { return this._index; }
		
		protected var _data:Object;
		protected var _index:int = -1;
		protected var _type:SetEventType;
		protected var _handled:Boolean;
		
		public function SetEvent(type:SetEventType, data:Object, index:int = -1) 
		{ 
			super(type.toString());
			this._data = data;
			this._index = index;
			this._type = type;
		} 
		
		public override function clone():Event
		{
			if (!this._handled)
			{
				this._handled = true;
				return this;
			}
			return new SetEvent(this._type, this._data, this._index);
		} 
		
		public override function toString():String 
		{ 
			return super.formatToString("DataChangeEvent", "type", "data"); 
		}
	}
	
}