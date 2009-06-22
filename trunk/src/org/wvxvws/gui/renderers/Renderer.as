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

package org.wvxvws.gui.renderers
{
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	* Renderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Renderer extends Sprite implements IRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:XML;
		protected var _field:TextField = new TextField();
		protected var _document:Object;
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
		public function Renderer() 
		{
			super();
			addChild(_field);
			_field.selectable = false;
		}
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			_id = id;
		}
		
		public function set labelFunction(value:Function):void
		{
			// TODO:
		}
		
		public function set labelField(value:String):String
		{
			// TODO:
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void 
		{
			if (isValid && _data === value) return;
			_data = value;
			_field.text = _data.toXMLString();
			_field.background = true;
			_field.backgroundColor = Math.random() * 0xFFFFFF;
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _field.text == _data.toXMLString();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
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