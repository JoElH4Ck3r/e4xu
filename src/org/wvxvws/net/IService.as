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

package org.wvxvws.net 
{
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	
	/**
	* IService interface.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public interface IService extends IEventDispatcher, IMXMLObject
	{
		function send(method:String = null, parameters:ServiceArguments = null):void;
		function cancel(method:String = null):void;
		
		function get sending():Boolean;
		
		function get resultCallBack():Function;
		function set resultCallBack(value:Function):void;
		
		function get faultCallBack():Function;
		function set faultCallBack(value:Function):void;
		
		function get baseURL():String;
		function set baseURL(value:String):void;
		
		function get methods():Array;
		function set methods(value:Array):void;
		
		function get parameters():ServiceArguments;
		function set parameters(value:ServiceArguments):void;
	}
	
}