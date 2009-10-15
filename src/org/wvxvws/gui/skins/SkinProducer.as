package org.wvxvws.gui.skins 
{
	import flash.display.DisplayObject;
	
	/**
	 * SkinProducer class.
	 * @author wvxvw
	 */
	public class SkinProducer extends AbstractProducer
	{
		protected var _skinClass:Class;
		protected var _factory:Function;
		
		public function SkinProducer(skinClass:Class, factory:Function = null) 
		{
			super();
			_skinClass = skinClass;
			_factory = factory;
		}
		
		public function produce(inContext:Object):DisplayObject
		{
			if (_skinClass) return new _skinClass();
			if (_factory !== null) return _factory(inContext);
			return null;
		}
	}

}