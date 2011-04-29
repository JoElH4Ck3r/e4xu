package org.wvxvws.parsers.as3
{
	public interface ISinks
	{
		function readHandler(forSink:ISink, forWord:String = null):Function;
		function get column():int;
		function get source():String;
		function advanceColumn(character:String):String;
		function appendCollectedText(text:String):void;
		function sinkStartRegExp(forSink:ISink):RegExp;
		function sinkEndRegExp(forSink:ISink):RegExp;
	}
}