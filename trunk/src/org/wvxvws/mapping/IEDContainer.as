package org.wvxvws.mapping 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * IEDContainer interface.
	 * @author wvxvw
	 */
	public interface IEDContainer extends IEventDispatcher
	{
		function get children():Vector.<IEventDispatcher>;
		function get parent():IEventDispatcher;
		
		function addChild(child:IEventDispatcher):IEventDispatcher;
		function addChildAt(child:IEventDispatcher, index:uint):IEventDispatcher;
		function removeChild(child:IEventDispatcher):IEventDispatcher;
		function removeChildAt(index:uint):IEventDispatcher;
		function childIndex(child:IEventDispatcher):uint;
		function childAt(index:uint):IEventDispatcher;
		function contains(child:IEventDispatcher):Boolean;
	}
	
}