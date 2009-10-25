package org.wvxvws.resources 
{
	import mx.core.IMXMLObject;
	import org.wvxvws.managers.ResourceManager;
	
	[DefaultProperty("resources")]
	
	/**
	 * ResourcesRepository class.
	 * @author wvxvw
	 */
	public class ResourcesRepository implements IMXMLObject
	{
		
		public function set resources(value:Vector.<Resource>):void 
		{
			trace("we should have ResourceManager");
			_resources.length = 0;
			for each (var r:Resource in value)
			{
				if (_resources.indexOf(r) < 0) _resources.push(r);
			}
			_resources = value;
		}
		
		private var _resources:Vector.<Resource> = new <Resource>[];
		
		public function ResourcesRepository() { super(); }
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			ResourceManager;
		}
		
	}

}