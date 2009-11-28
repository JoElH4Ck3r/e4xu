////////////////////////////////////////////////////////////////////////////////
//
//  ADOBE SYSTEMS INCORPORATED
//  Copyright 2005-2007 Adobe Systems Incorporated
//  All Rights Reserved.
//
//  NOTICE: Adobe permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package mx.messaging.config
{

	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ServerConfig
	{
		//--------------------------------------------------------------------------
		//
		// Static Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  xml
		//----------------------------------

		/**
		 *  The XML configuration; this value must contain the relevant portions of
		 *  the &lt;services&gt; tag from the services-config.xml file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion BlazeDS 4
		 *  @productversion LCDS 3 
		 */
		public static var xml:XML;
	}
}
