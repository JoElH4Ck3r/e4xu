﻿package assets.characters.pinkwizard 
{
	//{imports
	import assets.SpriteSheet;
	import flash.display.Bitmap;
	//}
	
	/**
	* PinkWizardSheet class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class PinkWizardSheet extends SpriteSheet
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
		
		[Embed(source='../../../../lib/stand.png')]
		private var _resource:Class;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PinkWizardSheet() 
		{
			super();
			_bitmapData = (new _resource() as Bitmap).bitmapData;
			super._totalFrames = _bitmapData.width / 56 - 1;
			super.setFrameSize(56, 52);
			super.showFrame(0);
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