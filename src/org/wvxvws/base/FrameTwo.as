package org.wvxvws.base 
{
	import flash.display.DisplayObject;
	import org.wvxvws.gui.DIV;
	
	//[SWF (width="800", height="600", scriptTimeLimit="15", frameRate="30", backgroundColor="0x3E2F1B")]
	//[Frame(factoryClass="org.wvxvws.base.FrameOne")]
	//[Frame(extraFrame="org.wvxvws.base.FrameOne")]
	//[Frame(factoryClass="TestApplication")]
	//[Frame(extraFrame="TestApplication")]
	
	/**
	* FrameTwo class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class FrameTwo extends DIV
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
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function FrameTwo() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		override public function initialized(document:Object, id:String):void 
		{
			super.initialized(document, id);
			if (document is DisplayObject)
			{
				(document as DisplayObject).scaleX = 
					(document as DisplayObject).scaleY = 1;
			}
		}
		
		public function create(...rest):Object { return { }; }
		
		public function info():Object {return { }; }
		
		//[Mixin]
		public static function init(obj:Object):void
		{
			trace("mixin", obj);
		}
		
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