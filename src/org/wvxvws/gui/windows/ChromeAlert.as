package org.wvxvws.gui.windows 
{
	import org.wvxvws.gui.Button;
	import org.wvxvws.gui.containers.ChromeWindow;
	import org.wvxvws.gui.skins.ButtonSkinProducer;
	
	/**
	 * ChromeAlert class.
	 * @author wvxvw
	 */
	public class ChromeAlert extends ChromeWindow
	{
		
		protected var _message:String;
		protected var _okButton:Button;
		protected var _cancelButton:Button;
		protected var _producer:ButtonSkinProducer;
		protected var _userActionHandler:Function;
		
		public function ChromeAlert() 
		{
			super();
			
		}
		
	}

}