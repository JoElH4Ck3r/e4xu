package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import org.wvxvws.gui.Border;
	import org.wvxvws.gui.ChromeBar;
	import org.wvxvws.gui.DIV;
	import org.wvxvws.gui.windows.IPane;
	
	/**
	 * ChromeWindow class.
	 * @author wvxvw
	 */
	public class ChromeWindow extends DIV implements IPane
	{
		public function get modal():Boolean
		{
			
		}
		
		public function set modal(value:Boolean):void
		{
			
		}
		
		public function get resizable():Boolean
		{
			
		}
		
		public function set resizable(value:Boolean):void
		{
			
		}
		
		protected var _titleBar:ChromeBar;
		protected var _statusBar:DisplayObject;
		
		protected var _closeBTN:InteractiveObject;
		protected var _dockBTN:InteractiveObject;
		protected var _expandBTN:InteractiveObject;
		
		protected var _border:Border;
		protected var _contentPane:Rack;
		
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
		
		/* INTERFACE org.wvxvws.gui.windows.IPane */
		
		public function created():void
		{
			
		}
		
		public function destroyed():void
		{
			
		}
		
		public function expanded():void
		{
			
		}
		
		public function collapsed():void
		{
			
		}
		
		public function choosen():void
		{
			
		}
		
		public function deselected():void
		{
			
		}
		
		public function get contentPane():Rack { return _contentPane; }
	}
	
}