package org.wvxvws.text 
{
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class HTMLCursor 
	{
		protected var _htmlPosition:int;
		protected var _textPosition:int;
		protected var _currentNode:XML;
		protected var _content:XMLList;
		
		public function HTMLCursor(content:XMLList)
		{
			super();
			_content = content;
		}
		
		public function next():void
		{
			
		}
		
		public function back():void
		{
			
		}
		
		public function get currentNode():XML { return _currentNode; }
		
		public function get htmlPosition():int { return _htmlPosition; }
		
		public function get textPosition():int { return _textPosition; }
	}
	
}