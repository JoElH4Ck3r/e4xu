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
		protected var _skinFactory:Function;
		
		public function SkinProducer(skinClass:Class, skinFactory:Function = null) 
		{
			super();
			_skinClass = skinClass;
			_skinFactory = skinFactory;
		}
		
		public function produce(inContext:Object):DisplayObject
		{
			if (_skinClass) return new _skinClass();
			if (_skinFactory !== null) return _skinFactory(inContext);
			return null;
		}
	}

}