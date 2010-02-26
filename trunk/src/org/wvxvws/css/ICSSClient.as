package org.wvxvws.css
{
	/**
	 * ...
	 * @author wvxvw
	 */
	public interface ICSSClient 
	{
		function className():String;
		function styleNames():Vector.<String>;
		function parentClient():ICSSClient;
		function childClients():Vector.<ICSSClient>;
		function getStyle(name:String):Object;
		function addStyle(name:String, style:Object):void;
		function pseudoClasses():Vector.<String>;
	}
}