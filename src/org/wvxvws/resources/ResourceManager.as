package org.wvxvws.resources 
{
	import flash.utils.getQualifiedClassName;
	
	/**
	* ResourceManager class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ResourceManager 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private static var _managedResources:Object;
		private static var _staticInstance:ResourceManager;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function ResourceManager() 
		{
			super();
			if (!_managedResources) _managedResources = { };
			if (!_staticInstance) _staticInstance = this;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function registerResource(resource:Class):void
		{
			_managedResources[getQualifiedClassName(resource)] = resource;
		}
		
		public function getDefinitions():Array
		{
			var ret:Array = [];
			for (var p:String in _managedResources)
			{
				ret.push(_managedResources[p]);
			}
			return ret;
		}
		
		public function getResource(name:String):Class
		{
			return _managedResources[name];
		}
		
		static public function get staticInstance():ResourceManager { return _staticInstance; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}