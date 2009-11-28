package mx.core 
{
	import flash.utils.Dictionary;
	
	[ExcludeClass]
	
	/**
	 * IFlexModuleFactory interface. 
	 * We need this to cut off framework dependencies.
	 * @author wvxvw
	 */
	public interface IFlexModuleFactory
	{
		
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------
    
    function get preloadedRSLs():Dictionary;
    
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    function allowDomain(...domains):void;
    
    function allowInsecureDomain(...domains):void;
    
    function callInContext(fn:Function, thisArg:Object,
						   argArray:Array, returns:Boolean = true):*;

    function create(...parameters):Object;

    function getImplementation(interfaceName:String):Object;
    
    function info():Object;
    
    function registerImplementation(interfaceName:String,
                                    impl:Object):void;
	}

}