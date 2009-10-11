package org.wvxvws.gui 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * ChromeBar class.
	 * @author wvxvw
	 */
	public class ChromeBar extends DIV
	{
		
		public function get label():String { return _label; }
		
		public function set label(value:String):void 
		{
			if (_label === value) return;
			_label = value;
			super.invalidate("_label", _label);
			dispatchEvent(new Event("labelChanged"));
		}
		
		public function get iconFactory():Function { return _iconFactory; }
		
		public function set iconFactory(value:Function):void 
		{
			if (_iconFactory === value) return;
			_iconFactory = value;
			super.invalidate("_iconFactory", _iconFactory);
			dispatchEvent(new Event("iconFactoryChanged"));
		}
		
		protected var _label:String;
		protected var _labelTXT:TextField;
		protected var _iconClass:Class;
		protected var _iconFactory:Function;
		protected var _icon:DisplayObject;
		
		public function ChromeBar() { super(); }
		
		public override function validate(properties:Object):void 
		{
			super.validate(properties);
		}
	}
	
}