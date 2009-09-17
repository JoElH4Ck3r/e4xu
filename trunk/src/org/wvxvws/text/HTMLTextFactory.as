package org.wvxvws.text 
{
	import flash.text.engine.ContentElement;
	import flash.text.engine.TextLine;
	import org.wvxvws.gui.styles.CSSTable;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class HTMLTextFactory 
	{
		protected var _source:XMLList;
		protected var _cursor:HTMLCursor;
		protected var _style:CSSTable;
		
		public function HTMLTextFactory(source:XMLList, style:CSSTable) 
		{
			super();
			if (source) _source = source.copy();
		}
		
		public function write(source:XMLList, at:HTMLCursor = null):void
		{
			
		}
		
		public function read(from:HTMLCursor = null):XMLList
		{
			return null;
		}
		
		public function nextLine():TextLine
		{
			return null;
		}
		
		public function previousLine():TextLine
		{
			return null;
		}
		
		public function nextElement():ContentElement
		{
			return null;
		}
		
		public function previousElement():ContentElement
		{
			return null;
		}
	}
	
}