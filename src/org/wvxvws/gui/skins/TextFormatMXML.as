package org.wvxvws.gui.skins 
{
	import mx.core.IMXMLObject;
	import flash.text.TextFormat;
	
	[Bindable]
	
	/**
	 * TextFormatMXML class.
	 * @author wvxvw
	 */
	public class TextFormatMXML extends TextFormat implements IMXMLObject
	{
		public function get id():String { return _id; }
		
		protected var _id:String;
		
		public function TextFormatMXML(font:String = null, size:Object = null, 
										color:Object = null, bold:Object = null, 
										italic:Object = null, underline:Object = null, 
										url:String = null, target:String = null, 
										align:String = null, leftMargin:Object = null, 
										rightMargin:Object = null, indent:Object = null, 
										leading:Object = null) 
		{
			super(font, size, color, bold, italic, underline, url, target, 
					align, leftMargin, rightMargin, indent, leading);
			
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void { _id = id; }
		
	}

}