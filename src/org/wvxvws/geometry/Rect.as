﻿package org.wvxvws.geometry 
{
	import flash.geom.Rectangle;
	import mx.core.IMXMLObject;
	
	//{imports
	
	//}
	/**
	* Rect class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Rect extends Rectangle implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _id:String;
		protected var _document:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		public function Rect(x:Number = 0, y:Number = 0, 
											width:Number = 100, height:Number = 100) 
		{
			super(x, y, width, height);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_id = id;
			_document = document;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}