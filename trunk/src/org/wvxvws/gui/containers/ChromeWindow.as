package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import org.wvxvws.gui.Border;
	import org.wvxvws.gui.ChromeBar;
	import org.wvxvws.gui.DIV;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class ChromeWindow extends DIV
	{
		protected var _titleBar:ChromeBar;
		protected var _statusBar:DisplayObject;
		protected var _closeBTN:InteractiveObject;
		protected var _dockBTN:InteractiveObject;
		protected var _expandBTN:InteractiveObject;
		protected var _border:Border;
		protected var _contentPane:DisplayObjectContainer;
		
		protected var _floating:Boolean;
		protected var _resizable:Boolean;
		protected var _expandable:Boolean;
		protected var _closable:Boolean;
		protected var _modal:Boolean;
		
		protected var _status:String;
		protected var _title:String;
		protected var _iconFactory:Function;
		
		protected var _minWidth:int;
		protected var _minHeight:int;
		
		public function ChromeWindow() { super(); }
		
		public function collapse():void
		{
			
		}
		
		public function expand():void
		{
			
		}
		
		public function close(gc:Boolean = true):void
		{
			
		}
		
		public function get contentPane():Pane { return _contentPane; }
	}
	
}