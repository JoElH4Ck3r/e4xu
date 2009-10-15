package org.wvxvws.gui.windows 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import org.wvxvws.gui.containers.Column;
	import org.wvxvws.gui.containers.Menu;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.renderers.ToolStripRenderer;
	
	/**
	 * ToolStripChrome class.
	 * @author wvxvw
	 */
	public class ChromeToolStrip extends Column
	{
		protected var _menu:Menu = new Menu();
		protected var _groups:Vector.<IRenderer> = new <IRenderer>[];
		
		public function ChromeToolStrip()
		{
			super();
			super._rendererFactory = ToolStripRenderer;
		}
		
		protected override function layOutChildren():void
		{
			var hadMenu:Boolean;
			if (super.contains(_menu))
			{
				super.removeChild(_menu);
				hadMenu = true;
			}
			super.layOutChildren();
			if (hadMenu) super.addChild(_menu);
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			_currentRenderer = super.$createChild(xml);
			if (!_currentRenderer) return null;
			_currentRenderer.addEventListener(MouseEvent.MOUSE_DOWN, 
									renderer_mouseDownHandler, false, 0, true);
			_currentRenderer.height = super.height - (_padding.top + _padding.bottom);
			if (_cellHeight !== int.MIN_VALUE) _currentRenderer.width = _cellHeight;
			_currentRenderer.y = _padding.top;
			_currentRenderer.height = super._bounds.y;
			super.addChild(_currentRenderer);
			if (_currentRenderer is IRenderer)
			{
				if (_filter !== "")
				{
					(_currentRenderer as IRenderer).labelField = _filter;
				}
			}
			if (_currentRenderer is ToolStripRenderer)
			{
				(_currentRenderer as ToolStripRenderer).validate(
					(_currentRenderer as ToolStripRenderer).invalidProperties);
			}
			_currentRenderer.x = _cumulativeHeight;
			_cumulativeHeight += _currentRenderer.width + _gutter;
			return _currentRenderer;
		}
		
		protected override function drawBackground():void
		{
			_background.clear();
			_background.beginFill(_backgroundColor, _backgroundAlpha);
			_background.drawRect(0, 0, _cumulativeHeight, _bounds.y);
			_background.endFill();
		}
		
		protected function renderer_mouseDownHandler(event:MouseEvent):void
		{
			var dos:DisplayObject = event.currentTarget as DisplayObject;
			var ir:IRenderer = event.currentTarget as IRenderer;
			if (!ir || !ir.data.*.length())
			{
				if (super.contains(_menu)) super.removeChild(_menu);
				return;
			}
			_menu.x = dos.x;
			_menu.y = super._bounds.y;
			_menu.dataProvider = ir.data;
			_menu.backgroundAlpha = 1;
			_menu.backgroundColor = 0xFF0000;
			super.addChild(_menu);
			_menu.initialized(this, "menu");
			super.scrollRect = null;
		}
		
	}

}