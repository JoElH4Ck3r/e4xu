package org.wvxvws.automation.types.numeric
{
	public class $Float extends $Real
	{
		public function $Float(parseFrom:String)
		{
			super(parseFrom);
			super._value = parseFloat(parseFrom);
			super._type = $Float;
		}
	}
}