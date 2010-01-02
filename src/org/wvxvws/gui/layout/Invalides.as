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

package org.wvxvws.gui.layout 
{
	//{ imports
	import org.wvxvws.utils.EnumError;
	//}
	
	/**
	 * Invalides class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class Invalides 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const AUTOSIZE:Invalides = new Invalides("autosize");
		public static const BOUNDS:Invalides = new Invalides("bounds");
		public static const CHILDREN:Invalides = new Invalides("children");
		public static const COLOR:Invalides = new Invalides("color");
		public static const DIRECTION:Invalides = new Invalides("direction");
		public static const DATAPROVIDER:Invalides = new Invalides("dataprovider");
		public static const NULL:Invalides = new Invalides("null");
		public static const SCROLL:Invalides = new Invalides("scroll");
		public static const SKIN:Invalides = new Invalides("skin");
		public static const STATE:Invalides = new Invalides("state");
		public static const STYLE:Invalides = new Invalides("style");
		public static const TARGET:Invalides = new Invalides("target");
		public static const TEXT:Invalides = new Invalides("text");
		public static const TEXTFORMAT:Invalides = new Invalides("textformat");
		public static const TRANSFORM:Invalides = new Invalides("transform");
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _num:String;
		private static var _lockUp:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * All instance of this enum are created at the application initialization time.
		 * Users should not create additional instances.
		 *  
		 * @param	num		The string key to represent this instance.
		 */
		public function Invalides(num:String)
		{
			super();
			if (_lockUp) throw new EnumError();
			this._num = num;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function lockUp():void { _lockUp = true; }
		
		/**
		 * Decorates this enumerator with the name assigned to it.
		 * 
		 * @return the name assigned to this enumerator.
		 */
		public function toString():String { return this._num; }
		
		/**
		 * We may need to compare enums to their string represenation using non-strict equality.
		 * This will allow non-strict comparison to succeed.
		 * 
		 * @return the string value wrapped by this enum instance.
		 */
		public function valueOf():Object { return this._num; }
	}
}
import org.wvxvws.gui.layout.Invalides;
Invalides.lockUp();