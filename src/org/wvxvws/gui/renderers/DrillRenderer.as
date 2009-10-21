package org.wvxvws.gui.renderers 
{
	import flash.events.MouseEvent;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.renderers.Renderer;
	
	[Event(name="opened", type="org.wvxvws.gui.GUIEvent")]
	
	/**
	 * DrillRenderer class.
	 * @author wvxvw
	 */
	public class DrillRenderer extends Renderer implements IDrillRenderer
	{
		public function get closed():Boolean { return _closed; }
		
		public function set closed(value:Boolean):void 
		{
			if (_closed === value) return;
			_closed = value;
			super.dispatchEvent(new GUIEvent(GUIEvent.OPENED, true, true));
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected === value) return;
			_selected = value;
			if (!_selected) _backgroundColor = 0xFFFFFF;
			else _backgroundColor = 0xAAAAFF;
			super.drawBackground();
		}
		
		protected var _closed:Boolean;
		protected var _selected:Boolean;
		
		public function DrillRenderer()
		{
			super();
			super.mouseChildren = false;
			super.tabChildren = false;
		}
		
		protected override function renderText():void 
		{
			super.renderText();
			super.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void 
		{
			this.closed = (!_closed);
			this.selected = true;
			super.dispatchEvent(new GUIEvent(GUIEvent.SELECTED, true, true));
		}
	}

}