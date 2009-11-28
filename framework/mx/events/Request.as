package mx.events 
{
	import flash.events.Event;
	import mx.core.IFlexModuleFactory;
	
	[ExcludeClass]
	
	/**
	 * Request event.
	 * We need this to cut off framework dependencies.
	 * @author wvxvw
	 */
	public class Request extends Event 
	{
		public static const GET_PARENT_FLEX_MODULE_FACTORY_REQUEST:String = "gpfmfr";
		
		public var value:IFlexModuleFactory;
		
		public function Request(type:String, 
							bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new Request(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Request"); 
		}
		
	}
	
}