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

package org.wvxvws.managers 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	/**
	* DragManager class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class DragManager 
	{
		static private var _target:Sprite;
		static private var _targetData:BitmapData;
		static private var _stage:Stage;
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
		
		public function DragManager() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public static function setDragTarget(target:DisplayObject):void
		{
			_target = new Sprite();
			if (_targetData) _targetData.dispose();
			_targetData = new BitmapData(target.width, target.height, true, 0x00FFFFFF);
			_targetData.draw(target, null, null, null, null, true);
			var matrix:Matrix = new Matrix();
			var halfWidth:int = target.width / -2;
			var halfHeight:int = target.height / -2;
			matrix.translate(halfWidth, halfHeight);
			_target.graphics.beginBitmapFill(_targetData, matrix);
			_target.graphics.drawRect(halfWidth, halfHeight, 
											target.width >> 0, target.height >> 0);
			_target.graphics.endFill();
			_stage = target.stage;
			if (!_stage) throw new Error("Cannot drag objects not on display list!");
			_target.x = _stage.mouseX;
			_target.y = _stage.mouseY;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, stage_MouseMoveHandler, 
																	false, 0, true);
			var top:int = _stage.numChildren;
			_stage.addChildAt(_target, top);
		}
		
		public static function drop():void
		{
			if (_targetData) _targetData.dispose();
			if (_target.parent) _target.parent.removeChild(_target);
		}
		
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
		
		private static function stage_MouseMoveHandler(event:MouseEvent):void 
		{
			_target.x = event.stageX;
			_target.y = event.stageY;
		}
		
	}
	
}