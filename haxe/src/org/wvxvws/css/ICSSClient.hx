/**
 * ...
 * @author wvxvw
 */

package org.wvxvws.css;

interface ICSSClient 
{
	function className():String;
	function styleNames():List<String>;
	function parentClient():ICSSClient;
	function childClients():List<ICSSClient>;
	function getStyle(name:String);
	function addStyle(name:String, style:CSSRule):Void;
	function pseudoClasses():List<String>;
}