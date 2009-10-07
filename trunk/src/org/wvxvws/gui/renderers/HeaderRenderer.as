package org.wvxvws.gui.renderers 
{
	//{ imports
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.StatefulButton;
	import org.wvxvws.tools.ToolEvent;
	//}
	
	[Event(name="resized", type="org.wvxvws.tools.ToolEvent")]
	[Event(name="resizeEnd", type="org.wvxvws.tools.ToolEvent")]
	[Event(name="resizeRequest", type="org.wvxvws.tools.ToolEvent")]
	
	/**
	 * HeaderRenderer class.
	 * @author wvxvw
	 */
	public class HeaderRenderer extends Renderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public override function get width():Number { return super.width; }
		
		public override function set width(value:Number):void 
		{
			if (value < _minWidth) value = _minWidth;
			super.width = value;
		}
		
		public function get resizable():Boolean { return _resizable; }
		
		public function set resizable(value:Boolean):void 
		{
			if (_resizable === value) return;
			_resizable = value;
			if (_data) renderText();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _minWidth:int = 30;
		protected var _sortButton:StatefulButton = new StatefulButton();
		protected var _sortUpClass:Class;
		protected var _sortDownClass:Class;
		protected var _resizable:Boolean;
		protected var _resizeHandle:Sprite = new Sprite();
		protected var _resizing:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HeaderRenderer()
		{
			super();
			_backgroundColor = 0xC0C0C0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function drawBackground():void 
		{
			super.drawBackground();
			if (_resizable)
			{
				if (!super.contains(_resizeHandle)) drawResizeHandle(false);
			}
			else drawResizeHandle(true);
		}
		
		protected function drawResizeHandle(remove:Boolean):void
		{
			var g:Graphics = _resizeHandle.graphics;
			g.clear();
			super.scaleY = 1;
			if (!remove)
			{
				g.beginFill(0xFF, 1);
				g.drawRect( -5, 0, 5, super.height >> 0);
				g.endFill();
				_resizeHandle.addEventListener(
						MouseEvent.MOUSE_OVER, resize_mouseOverHandler);
				_resizeHandle.addEventListener(
						MouseEvent.MOUSE_OUT, resize_mouseOutHandler);
				_resizeHandle.addEventListener(
						MouseEvent.MOUSE_DOWN, resize_mouseDownHandler);
				_resizeHandle.x = _width;
				super.addChild(_resizeHandle);
			}
			else
			{
				_resizeHandle.removeEventListener(
						MouseEvent.MOUSE_OVER, resize_mouseOverHandler);
				_resizeHandle.removeEventListener(
						MouseEvent.MOUSE_OUT, resize_mouseOutHandler);
				_resizeHandle.removeEventListener(
						MouseEvent.MOUSE_DOWN, resize_mouseDownHandler);
				if (super.contains(_resizeHandle)) super.removeChild(_resizeHandle);
			}
		}
		
		protected function resize_mouseDownHandler(event:MouseEvent):void 
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, 
									stage_mouseUpHandler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 
									stage_mouseMoveHandler, false, 0, false);
			_resizing = true;
		}
		
		protected function stage_mouseUpHandler(event:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, 
									stage_mouseUpHandler);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, 
									stage_mouseMoveHandler);
			_resizing = false;
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZE_END, false, true, this));
		}
		
		protected function stage_mouseMoveHandler(event:MouseEvent):void 
		{
			super.dispatchEvent(new ToolEvent(ToolEvent.RESIZED, false, true, this));
		}
		
		protected function resize_mouseOutHandler(event:MouseEvent):void 
		{
			if (_resizing) return;
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZE_END, false, true, this));
		}
		
		protected function resize_mouseOverHandler(event:MouseEvent):void 
		{
			super.dispatchEvent(
				new ToolEvent(ToolEvent.RESIZE_REQUEST, false, true, this));
		}
	}

}