package org.wvxvws.gui.renderers 
{
	import flash.display.DisplayObject;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.ButtonS;
	
	/**
	 * ToolStripRenderer class.
	 * @author wvxvw
	 */
	public class ToolStripRenderer extends ButtonS implements IRenderer
	{
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return super._invalidLayout;
		}
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			super.invalidate("_labelFunction", _data, false);
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField === value) return;
			_labelField = value;
			super.invalidate("_labelField", _data, false);
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void
		{
			if (isValid && _data === value) return;
			_data = value;
			super.invalidate("_data", _data, false);
		}
		
		protected var _data:XML;
		protected var _labelField:String;
		protected var _labelFunction:Function;
		
		public function ToolStripRenderer() { super(); }
		
		public override function validate(properties:Object):void 
		{
			var lastLabel:String = _labelTXT.text;
			if (!_data) properties._label = "";
			else
			{
				if (_labelField && _data.hasOwnProperty(_labelField))
				{
					if (_labelFunction !== null)
						properties._label = _labelFunction(_data[_labelField]);
					else properties._label = _data[_labelField];
				}
				else
				{
					if (_labelFunction !== null)
						properties._label = _labelFunction(_data.toXMLString());
					else properties._label = _data.localName();
				}
			}
			super._label = properties._label;
			super.validate(properties);
			if (lastLabel !== _labelTXT.text)
			{
				super._bounds.x = _labelTXT.width;
				if (super._skin && super._skin is DisplayObject)
				{
					(_skin as DisplayObject).width = super._bounds.x;
				}
				super.drawBackground();
			}
		}
	}

}