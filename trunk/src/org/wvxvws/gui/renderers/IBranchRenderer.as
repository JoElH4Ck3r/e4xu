package org.wvxvws.gui.renderers 
{
	/**
	 * IBranchRenderer interface.
	 * @author wvxvw
	 */
	public interface IBranchRenderer extends IRenderer
	{
		function get closedHeight():int;
		
		function set leafLabelFunction(value:Function):void;
		
		function set leafLabelField(value:String):void;
		
		function set folderIcon(value:Class):void;
		
		function set closedIcon(value:Class):void;
		
		function set openIcon(value:Class):void;
		
		function set docIconFactory(value:Function):void;
		
		function nodeToRenderer(node:XML):IRenderer;
		
		function rendererToXML(renderer:IRenderer):XML;
	}
	
}