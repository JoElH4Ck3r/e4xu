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

/**
 * AVM1Protocol class.
 * @author wvxvw
 * @langVersion 2.0
 * @playerVersion 10.0.12.36
 */
class org.wvxvws.lcbridge.AVM1Protocol 
{
	//------------------------------------------------------------------------------
	//
	//  Public properties
	//
	//------------------------------------------------------------------------------
	
	/**
	 * Refers to <code>_root</code>. Note that depending on your _lockroot settings
	 * the methods of the loaded clip may or may not be accessible though <code>_root</code>
	 */
	public static var ROOT:String = "_root";
	
	/**
	 * Refers to <code>_global</code>. Use this if you want to refer to global variables
	 * or classes, which are also stored in <code>_global</code> object.
	 */
	public static var GLOBAL:String = "_global";
	
	/**
	 * Refers to the AVM1 LocalConnection client.
	 */
	public static var THIS:String = "this";
	
	/**
	 * Refers to the content loaded inside the AVM1 LocalConnection client.
	 */
	public static var CONTENT:String = "content";
	
	/**
	 * A null-scope, use this when calling static methods or methods that do not
	 * require context.
	 */
	public static var NULL:String = "";
	
	//------------------------------------------------------------------------------
	//
	//  Private properties
	//
	//------------------------------------------------------------------------------
	
	//------------------------------------------------------------------------------
	//
	//  Constructor
	//
	//------------------------------------------------------------------------------
	
	public function AVM1Protocol() { super(); }
	
	//------------------------------------------------------------------------------
	//
	//  Public methods
	//
	//------------------------------------------------------------------------------
	
	//------------------------------------------------------------------------------
	//
	//  Private methods
	//
	//------------------------------------------------------------------------------
}