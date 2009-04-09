package org.wvxvws.gui 
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
		//  Cunstructor
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
			matrix.translate(target.width / -2, target.height / -2);
			_target.graphics.beginBitmapFill(_targetData, matrix);
			_target.graphics.drawRect(target.width / -2, target.height / -2, 
													target.width, target.height);
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