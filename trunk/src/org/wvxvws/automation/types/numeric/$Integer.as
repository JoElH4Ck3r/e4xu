package org.wvxvws.automation.types.numeric
{
	public class $Integer extends $Rational
	{
		public function $Integer(parseFrom:String)
		{
			super(parseFrom);
			super._value = parseInt(parseFrom, 10);
		}
	}
}