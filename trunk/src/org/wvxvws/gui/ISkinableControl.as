package org.wvxvws.gui 
{
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import mx.styles.IStyleClient;
	
	/**
	 * IScinableDIV interface.
	 * @author wvxvw
	 */
	public interface ISkinableDIV extends IStyleClient
	{
		function validateLayout(event:Event = null):void;
		
		function setSkin(skin:Skin):void;
	}
	
}