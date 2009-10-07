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
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ITrimable interface.
	 * @author wvxvw
	 */
	public interface ITrimable 
	{
		function get trimLeft():uint;
		function set trimLeft(value:uint):void;
		
		function get trimRight():uint;
		function set trimRight(value:uint):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function getBounds(where:DisplayObject):Rectangle;
		function globalToLocal(point:Point):Point;
	}
	
}