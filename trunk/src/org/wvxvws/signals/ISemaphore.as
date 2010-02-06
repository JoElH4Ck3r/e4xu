﻿package org.wvxvws.signals 
{
	
	/**
	 * ISemaphore interface.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public interface ISemaphore 
	{
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		function signalTypes():Vector.<SygnalType>;
		function callbackSignature(type:SygnalType):Vector.<Class>;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
	}
}