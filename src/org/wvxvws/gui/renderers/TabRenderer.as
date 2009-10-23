package org.wvxvws.gui.renderers 
{
	//{ imports
	import org.wvxvws.gui.renderers.Renderer;
	//}
	
	/**
	 * TabRenderer class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class TabRenderer extends Renderer implements ILabel
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function TabRenderer() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.renderers.ILabel */
		
		public function set text(value:String):void
		{
			this.renderText();
			_field.text = value;
			this.drawBackground();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function renderText():void 
		{
			_field.defaultTextFormat = _textFormat;
		}
		
		protected override function drawBackground():void 
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}