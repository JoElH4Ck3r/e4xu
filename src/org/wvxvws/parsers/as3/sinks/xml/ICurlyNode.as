package org.wvxvws.parsers.as3.sinks.xml
{
	import org.wvxvws.parsers.as3.ISinks;

	public interface ICurlyNode
	{
		function continueReading(from:ISinks):Boolean;
	}
}