package org.wvxvws.skins 
{
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.skins.ISkin;
	import org.wvxvws.gui.skins.ISkinnable;
	
	/**
	 * ButtonSkin skin.
	 * @author wvxvw
	 */
	public class ButtonSkin implements ISkin
	{
		protected var _host:Button;
		
		public function ButtonSkin() 
		{
			super();
		}
		
		public function get host():ISkinnable
		{
			return _host; 
		}
		public function set host(value:ISkinnable):void
		{
			_host = value as Button;
		}
		
		public function produce(inContext:Object, ...args):Object
		{
			// TODO: move DefaultButtonSkinProducer logic here
			return null;
		}
	}

}