package org.wvxvws.gui 
{
	
	/**
	 * ButtonSkin class.
	 * @author wvxvw
	 */
	public class ButtonSkin extends Skin
	{
		
		public function ButtonSkin() 
		{
			super();
			states[SkinnableButton.UP] = button_UP;
			states[SkinnableButton.OVER] = button_OVER;
			states[SkinnableButton.DOWN] = button_DOWN;
			states[SkinnableButton.DISABLED] = button_DISABLED;
		}
		
	}
	
}