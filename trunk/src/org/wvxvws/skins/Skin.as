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
			this._classFactory = classFactory;
			this._functionFactory = functionFactory;
		}
		
		public override function produce(inContext:Object, ...args):Object
		{
			if (this._classFactory) return new this._classFactory();
			else if (this._functionFactory !== null)
				return this._functionFactory(inContext, args);
			return null;
		}
	}
}