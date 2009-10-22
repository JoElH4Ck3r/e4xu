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

package org.wvxvws.base 
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import mx.core.IFlexModuleFactory;
	import mx.styles.IStyleManager2;
	import org.wvxvws.gui.DIV;
	
	//[SWF (width="800", height="600", scriptTimeLimit="15", frameRate="30", backgroundColor="0x3E2F1B")]
	//[Frame(factoryClass="org.wvxvws.base.FrameOne")]
	//[Frame(extraFrame="org.wvxvws.base.FrameOne")]
	//[Frame(factoryClass="TestApplication")]
	//[Frame(extraFrame="TestApplication")]
	
	/**
	* FrameTwo class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class FrameTwo extends DIV implements IFlexModuleFactory
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get preloadedRSLs():Dictionary { return null; };

		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
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
		
		public function FrameTwo() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			if (document is DisplayObject)
			{
				(document as DisplayObject).scaleX = 
					(document as DisplayObject).scaleY = 1;
			}
		}
		
		public function create(...rest):Object { return { }; }
		
		public function info():Object {return { }; }
		
		//[Mixin]
		public static function init(obj:Object):void
		{
			trace("mixin", obj);
		}
		
		/* INTERFACE mx.core.IFlexModuleFactory */
		
		public function registerImplementation(a:String, b:Object):void { }
		
		public function getImplementation(a:String):Object { return null; }
		
		public function allowDomain(... domains):void {  }

		public function allowInsecureDomain(... domains):void {  }

		public function callInContext(fn:Function, thisArg:Object,
							   argArray:Array, returns:Boolean = true):* { return null; }

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