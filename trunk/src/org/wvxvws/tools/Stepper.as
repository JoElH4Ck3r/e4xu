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

package org.wvxvws.tools 
{
	//{ imports
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.wvxvws.gui.DIV;
	//}
	
	/**
	 * Stepper class.
	 * @author wvxvw
	 */
	public class Stepper extends DIV
	{
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _position:Number;
		protected var _step:Number;
		protected var _max:Number;
		protected var _min:Number;
		protected var _hasFocus:Boolean;
		
		protected var _field:TextField;
		protected var _incrementBTN:Sprite;
		protected var _decrementBTN:Sprite;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Stepper() 
		{
			super();
			super.addEventListener(Event.ADDED_TO_STAGE, adtsHandler, false, 0, true);
		}
		
		private function adtsHandler(event:Event):void 
		{
			super.addEventListener(Event.REMOVED_FROM_STAGE, cleanup, false, 0, true);
			
		}
		
		protected function cleanup(event:Event = null):void 
		{
			
		}
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
			if (!_field)
			{
				_field = new TextField();
				_field.width = super.width;
				_field.height = super.height;
			}
		}
		
		public function increment():void
		{
			
		}
		
		public function decrement():void
		{
			
		}
	}

}