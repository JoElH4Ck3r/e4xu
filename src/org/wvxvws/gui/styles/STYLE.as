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

package org.wvxvws.gui.styles 
{
	//{imports
	import flash.utils.ByteArray;
	import mx.core.IMXMLObject;
	//}
	
	[DefaultProperty("source")]
	
	/**
	* STYLE class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class STYLE implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get id():String { return _id; }
		
		public function set source(value:Object):void 
		{
			if (this._source) throw new Error("Already set.");
			switch (true)
			{
				case (value is String):
					this._source = value as String;
					break;
				case (value is Class):
					this._source = new (value as Class)().toString();
					break;
				case (value is ByteArray):
					this._source = (value as ByteArray).readUTF();
					break;
				default:
					throw new Error("Wrong source type.");
			}
			CSSParser.parse(this._source);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _id:String;
		private var _document:Object;
		private var _source:String;
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		public function STYLE() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._id = id;
			this._document = document;
		}
		
		public function dispose():void { }
	}
}