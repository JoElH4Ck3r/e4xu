﻿package org.wvxvws.gui 
{
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.styles.IStyleClient;
	
	/**
	 * IScinableControl interface.
	 * @author wvxvw
	 */
	public interface ISkinableControl extends IStyleClient
	{
		function validateLayout(event:Event = null):void;
		
		function setSkin(skin:Skin):void;
	}
	
}