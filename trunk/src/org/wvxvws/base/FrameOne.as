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
	//{imports
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.IPreloader;
	//}
	
	/**
	* FrameOne class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class FrameOne extends MovieClip
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
		
		protected var _ipreloader:IPreloader;
		protected var _frameTwoClass:Class;
		protected var _flexInit:Class;
		protected var _frameTwoAlias:String = "org.wvxvws.base::FrameTwo";
		
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
		public function FrameOne()
		{
			super();
			stop();
			if (stage) stageConfig();
			else addEventListener(Event.ADDED_TO_STAGE, stageConfig);
		}
		
		protected function stageConfig(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, stageConfig);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		public function get preloader():IPreloader { return _ipreloader; }
		
		public function set preloader(value:IPreloader):void 
		{
			_ipreloader = value;
			_ipreloader.target = loaderInfo;
			if (_frameTwoAlias) _ipreloader.classAlias = _frameTwoAlias;
			(_ipreloader as IEventDispatcher).addEventListener(Event.COMPLETE, completeHandler);
			addChild(_ipreloader as DisplayObject);
		}
		
		protected function completeHandler(event:Event):void 
		{
			if (framesLoaded < 2) return;
			(_ipreloader as IEventDispatcher).removeEventListener(
									Event.COMPLETE, completeHandler);
			gotoAndStop(2);
			_frameTwoClass = getDefinitionByName(_frameTwoAlias) as Class;
			_flexInit = getDefinitionByName("FlexInit") as Class;
			removeChild(_ipreloader as DisplayObject);
			_ipreloader = null;
			var app:DisplayObject = new _frameTwoClass() as DisplayObject;
			if (_flexInit) Object(_flexInit).init(app);
			addChild(app);
			(app as IMXMLObject).initialized(this, "frameTwo");
		}
		
		public function get frameTwoClass():Class { return _frameTwoClass; }
		
		public function get frameTwoAlias():String { return _frameTwoAlias; }
		
		public function set frameTwoAlias(value:String):void 
		{
			_frameTwoAlias = value;
			if (_ipreloader) _ipreloader.classAlias = _frameTwoAlias;
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