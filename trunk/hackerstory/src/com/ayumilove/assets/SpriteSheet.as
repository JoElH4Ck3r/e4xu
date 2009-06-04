package com.ayumilove.assets 
{
	//{imports
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	//}
	
	[Event(name="ready", type="assets.SpriteSheetEvent")]
	
	/**
	* SpriteSheet class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class SpriteSheet extends Shape
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get totalFrames():int { return _totalFrames; }
		
		public function get animationType():String { return _animationType; }
		
		public function get currentFrame():int { return _currentFrame; }
		
		public function get isReady():Boolean { return _isReady; }
		
		public function get startFrame():uint { return _startFrame; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _startFrame:uint = uint.MAX_VALUE;
		protected var _animationType:String;
		protected var _totalFrames:int;
		protected var _currentFrame:int;
		protected var _bitmapData:BitmapData;
		protected var _frameRect:Range = new Range([], 0, 0, 100, 100);
		protected var _positionMatrix:Matrix = new Matrix();
		
		/**
		 * Example:
		 * <pre>
		 * <d src="img/pink-wizard.png" monster="PinkWizard">
		 *		<attack range="6-9" frameSize="56:52"/>
		 *		<stand range="0-5" frameSize="56:52"/>
		 *		<walk range="10-15" frameSize="56:52"/>
		 *	</d>
		 * </pre>
		 */
		protected var _descriptor:XML;
		protected var _modes:Dictionary = new Dictionary();
		protected var _isReady:Boolean;
		protected var _loader:SpriteSheetLoader = new SpriteSheetLoader();
		
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
		
		/**
		 * Creates new SpriteSheet.
		 * Specify either <code>descriptor</code> or <code>data</code> parameters.
		 * If you specify both parameters SpriteSheet will use the bitmapdata passed 
		 * in the argument instead of loading a new copy.
		 * 
		 * @param	descriptor	See the example for <a href="#_descriptor">_descriptor</a>
		 * 			property.
		 * 
		 * @param	data		The source for animation.
		 * 
		 * @see 	#_descriptor
		 */
		public function SpriteSheet(descriptor:XML = null, data:BitmapData = null)
		{
			super();
			if (data)
			{
				_bitmapData = data;
				_isReady = true;
			}
			if (descriptor)
			{
				_descriptor = descriptor;
				_animationType = _descriptor.@monster;
				if (!data)
				{
					_loader.addEventListener(Event.COMPLETE, loader_completeHandler, false, 0, true);
					_loader.load(new URLRequest(_descriptor.@src));
					_descriptor.*.(addRange(@range, @frameSize, name()));
				}
				else
				{
					_descriptor.*.(addRange(@range, @frameSize, name()));
					calculateTotalFrames();
					_isReady = true;
					dispatchEvent(new SpriteSheetEvent(SpriteSheetEvent.READY));
				}
			}
			else
			{
				_animationType = getQualifiedClassName(this);
				_modes[_frameRect] = "@";
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Places the playhead on the <code>frame</code> frame.
		 * 
		 * @param	frame	The frame to play.
		 * 
		 * @throws	RangeError <code>No such frame.</code>
		 * 			If you try to play frame that doesn't exist.
		 * @throws	Error <code>Must load image first.</code>
		 * 			If the bitmap data for this sheet wasn't loaded yet.
		 */
		public function showFrame(frame:int):void
		{
			if (frame < 0 || frame > _totalFrames) throw new RangeError("No such frame:" + frame);
			if (!_bitmapData) throw new Error("Must load image first.");
			_currentFrame = frame;
			for (var r:Object in _modes)
			{
				if ((r as Range).isInFrame(_currentFrame + _startFrame)) _frameRect = r as Range;
			}
			frame = frame + _startFrame;
			_frameRect.y = ((frame / (_bitmapData.width / _frameRect.width) >> 0)) * _frameRect.height >> 0;
			_frameRect.x = ((frame % (_bitmapData.width / _frameRect.width) >> 0)) * _frameRect.width >> 0;
			//trace(_frameRect);
			_positionMatrix.tx = _frameRect.x * -1;
			graphics.clear();
			graphics.beginBitmapFill(_bitmapData, _positionMatrix, false);
			graphics.drawRect(0, 0, _frameRect.width, _frameRect.height);
			graphics.endFill();
		}
		
		/**
		 * Sets the dimensions of a single frame. The bitmap will be displayed in portions
		 * using these parameters for a single portion width and height.
		 * Note, this function would be usually called internally in constructor. Though it 
		 * is possible that you will be required to call it, if the bitmap data will be loaded
		 * from external source.
		 * 
		 * @param	frameWidth	The width of desired frame.
		 * 
		 * @param	frameHeight	The height of desired frame.
		 * 
		 * @param	mode		The alias for sequence of frames for a single whole animation.
		 * @default	<code>null</code>.
		 */
		public function setFrameSize(frameWidth:uint, frameHeight:uint, mode:String = null):void
		{
			var theRange:Range;
			for (var r:Object in _modes)
			{
				if (mode)
				{
					if (_modes[r] == mode)
					{
						theRange = r as Range;
						theRange.width = frameWidth;
						theRange.height = frameHeight;
						break;
					}
				}
				else
				{
					theRange = r as Range;
					theRange.width = frameWidth;
					theRange.height = frameHeight;
				}
			}
		}
		
		/**
		 * Call this method to enable garbage collecting the bitmapdata associated
		 * with this sheet.
		 * Note, don't call it if you are going to reuse this object at a later time, 
		 * because the bitmapdata associated with it will be irreversibly lost.
		 */
		public function dispose():void
		{
			if (_bitmapData) _bitmapData.dispose();
		}
		
		/**
		 * Adds new sequence of equaly high and wide rectangle frames.
		 * 
		 * @param	frames		String delimited by dash symbol. The left side should be the 
		 * 			first frame, the right side should be the last frame.
		 * 
		 * @param	frameSize	String delimited by colon symbol. The left side is the frame 
		 * 			width, the right side is frame heigh.
		 * 
		 * @param	moode		String identifier for the added sequence. 
		 * 			Note, identifiers should be unique. If you add identical identifiers
		 * 			the latter overwrites the former.
		 * 
		 * @example	<code>mySpriteSheet.addRange("0-5", "56:52", "move")</code>
		 */
		public function addRange(frames:String, frameSize:String, moode:String):void
		{
			var arr:Array = [];
			var temp:Array = frames.split("-");
			var i:int = temp[0];
			var il:int = temp[1];
			while (i <= il)
			{
				arr.push(i);
				i++;
			}
			temp = frameSize.split(":");
			i = temp[0];
			il = temp[1];
			var range:Range = new Range(arr, 0, 0, i, il);
			_modes[range] = moode;
			trace("mode added", moode, _modes[range], range);
			var rng:Range;
			var nrng:Range;
			for (var r:Object in _modes)
			{
				if ((r as Range).isOnlyRange)
				{
					rng = r as Range;
					nrng = new Range(rng.framesArray, rng.x, rng.y, rng.width, rng.height);
					_modes[nrng] = _modes[r];
				}
			}
		}
		
		public function clone(duplicateBitmapdata:Boolean = false, ...moodsRest):SpriteSheet
		{
			var bData:BitmapData = duplicateBitmapdata ? _bitmapData.clone() : _bitmapData;
			var moodsXML:XML = <d/>;
			_descriptor.*.(moodsRest.indexOf(String(name())) > -1 ? moodsXML.appendChild(copy()) : false);
			trace(moodsXML.toXMLString());
			return new SpriteSheet(moodsXML, bData);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Is called when bitmapdata is loaded.
		 * 
		 * @param	event	Event.COMPLETE event.
		 */
		protected function loader_completeHandler(event:Event):void 
		{
			_bitmapData = _loader.bitmapData.clone();
			calculateTotalFrames();
			_isReady = true;
			dispatchEvent(new SpriteSheetEvent(SpriteSheetEvent.READY));
		}
		
		/**
		 * Call this to recalculate frame size after modifying other SpriteSheet parameters.
		 * 
		 * @return	Calculated total number of frames.
		 */
		protected function calculateTotalFrames():uint
		{
			var rng:Range;
			_totalFrames = 0;
			for (var r:Object in _modes)
			{
				rng = r as Range;
				trace(rng.framesArray);
				_startFrame = Math.min.apply(Math, [_startFrame].concat(rng.framesArray));
				_totalFrames += rng.framesArray.length;
			}
			trace("calculateTotalFrames", _totalFrames, _startFrame);
			return _totalFrames;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
}
import flash.geom.Rectangle;

internal final class Range extends Rectangle
{
	public var frames:Object = { };
	public var isOnlyRange:Boolean;
	public var framesArray:Array /* of int */;
	
	public function Range(frames:Array, x:Number = 0, y:Number = 0, 
							width:Number = 100, height:Number = 100)
	{
		super(x, y, width, height);
		framesArray = frames.slice();
		if (!frames.length) isOnlyRange = true;
		else
		{
			for each (var i:int in frames) { this.frames[i] = true; }
		}
	}
	
	public function isInFrame(frame:int):Boolean { return (frame in frames) || isOnlyRange; }
}