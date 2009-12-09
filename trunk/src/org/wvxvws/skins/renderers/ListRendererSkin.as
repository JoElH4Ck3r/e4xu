package org.wvxvws.skins.renderers 
{
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.skins.AbstractProducer;
	
	/**
	 * ListRendererSkin skin.
	 * @author wvxvw
	 */
	public class ListRendererSkin extends AbstractProducer
	{
		
		public function ListRendererSkin() { super(); }
		
		public override function produce(inContext:Object, ...args):Object
		{
			return new Renderer();
		}
	}
}