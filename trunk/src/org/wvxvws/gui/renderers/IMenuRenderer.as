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
	import org.wvxvws.gui.skins.ISkin;
	
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	* IMenuRenderer interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IMenuRenderer extends IRenderer
	{
		
		function set iconProducer(value:ISkin):void;
		
		function set hotKeys(value:Vector.<int>):void;
		
		function set kind(value:String):void;
		function get kind():String;
		
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
		
		function get clickHandler():Function;
		function set clickHandler(value:Function):void;
		
		function get desiredWidth():int;
		function set desiredWidth(value:int):void;
	}
}