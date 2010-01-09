package org.wvxvws.skins 
{
	import org.wvxvws.gui.renderers.Renderer;
	import org.wvxvws.gui.skins.AbstractProducer;
	
	/**
	 * ListSkin skin.
	 * @author wvxvw
	 */
	public class ListSkin extends AbstractProducer
	{
		
		public function ListSkin() { super(); }
		
		public override function produce(inContext:Object, ...args):Object
		{
			return new Renderer();
		}
	}

}