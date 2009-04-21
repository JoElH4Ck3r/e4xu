package org.wvxvws.animation 
{
	
	/**
	 * easingDefault package function.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.12.36
	 * 
	 * @param	time
	 * @param	start
	 * @param	change
	 * @param	duration
	 * 
	 * @return
	 */
	public function easingDefault(time:Number, start:Number,
								change:Number, duration:Number):Number 
	{
		return change * time / duration + start;
	}
	
}