package org.wvxvws.skins 
{
	import org.wvxvws.gui.skins.AbstractProducer;
	
	/**
	 * LabelSkin skin.
	 * @author wvxvw
	 */
	public class LabelSkin extends AbstractProducer
	{
		protected var _label:String;
		protected var _factory:Function;
		
		public function LabelSkin(label:String = null, factory:Function = null) 
		{
			super();
			_label = label === null ? "@label" : label;
			_factory = factory;
		}
		
		public override function produce(inContext:Object, ...rest):Object
		{
			if (_label !== "" && _label !== null && _label.length)
			{
				if (inContext.hasOwnProperty(_label))
					return inContext[_label].toString();
				else if (_factory !== null)
					return _factory(inContext);
				else 
					return _label;
			}
			else if (_factory !== null)
			{
				return _factory(inContext);
			}
			return "Error..."
		}
	}
}