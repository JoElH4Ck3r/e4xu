package org.wvxvws.skins 
{
	import org.wvxvws.gui.skins.AbstractProducer;
	
	/**
	 * Skin skin.
	 * @author wvxvw
	 */
	public class Skin extends AbstractProducer
	{
		protected var _classFactory:Class;
		protected var _functionFactory:Function;
		
		public function Skin(classFactory:Class, functionFactory:Function = null) 
		{
			super();
			_classFactory = classFactory;
			_functionFactory = functionFactory;
		}
		
		public override function produce(inContext:Object, ...args):Object
		{
			if (_classFactory) return new _classFactory();
			else if (_functionFactory !== null)
				return _functionFactory(inContext, args);
			return null;
		}
	}
}