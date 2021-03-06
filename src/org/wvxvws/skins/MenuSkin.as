﻿package org.wvxvws.skins 
{
	import org.wvxvws.gui.renderers.MenuRenderer;
	import org.wvxvws.gui.skins.AbstractProducer;
	
	// TODO: Remake MenuRenderer so we use only it instead of this skin.
	
	/**
	 * MenuSkin skin.
	 * @author wvxvw
	 */
	public class MenuSkin extends AbstractProducer
	{
		public function MenuSkin() { super(); }
		
		public override function produce(inContext:Object, ...args):Object
		{
			return new MenuRenderer();
		}
	}

}