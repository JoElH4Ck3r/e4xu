package org.wvxvws.gui.skins 
{
	import org.wvxvws.gui.skins.AbstractProducer;
	
	/**
	 * LabelProducer class.
	 * @author wvxvw
	 */
	public class LabelProducer extends AbstractProducer
	{
		private var _label:String;
		private var _factory:Function;
		
		public function LabelProducer(label:String, factory:Function = null) 
		{
			super();
			_label = label;
			_factory = factory;
		}
		
		public function produce(inContext:Object):String
		{
			if (_label && _label.length)
			{
				if (inContext.hasOwnProperty(_label))
					return inContext[_label].toString();
			}
			else if (_factory !== null)
			{
				return _factory(inContext);
			}
			return "Error..."
		}
	}

}