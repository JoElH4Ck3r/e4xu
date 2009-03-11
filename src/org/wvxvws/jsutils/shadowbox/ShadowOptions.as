package org.wvxvws.jsutils.shadowbox
{
	import flash.external.ExternalInterface;
	
	/**
	* ShadowOptions class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ShadowOptions 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		public static const WH:String = "wh";
		public static const HW:String = "hw";
		public static const FLV_PLAYER:String = "flvplayer.swf";
		public static const DEFAULT:String = "default";
		public static const SKIP:String = "skip";
		public static const RESIZE:String = "resize";
		public static const NONE:String = "none";
		public static const DRAG:String = "drag";
		
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
		private static var _uid:String;
		private static var _swfID:String;
		private static var _counter:int;
		
		private var _proxy:Object = { };
		private var _callbacks:Array = [];
		
		private var _animate:Boolean;
		private var _animateFade:Boolean;
		private var _animSequence:String;
		private var _flvPlayer:String;
		private var _modal:Boolean;
		private var _overlayColor:uint;
		private var _overlayOpacity:Number;
		private var _flashBgColor:uint;
		private var _autoplayMovies:Boolean;
		private var _showMovieControls:Boolean;
		private var _slideshowDelay:int;
		private var _resizeDuration:int;
		private var _fadeDuration:int;
		private var _displayNav:Boolean;
		private var _continuous:Boolean;
		private var _displayCounter:Boolean;
		private var _counterType:String;
		private var _counterLimit:int;
		private var _viewportPadding:int;
		private var _handleOversize:String;
		private var _handleException:Function;
		private var _handleUnsupported:Function;
		private var _initialHeight:int;
		private var _initialWidth:int;
		private var _enableKeys:Boolean;
		private var _onOpen:Function;
		private var _onFinish:Function;
		private var _onChange:Function;
		private var _onClose:Function;
		private var _skipSetup:Boolean;
		private var _errors:Object;
		private var _ext:Object;

		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates new ShadowOptions.
		 */
		public function ShadowOptions()
		{
			super();
			if (!_uid) initEI();
		}
		
		/**
		 * Set this <code>false</code> to disable all fading animations. 
		 * Defaults to <code>true</code>.
		 */
		public function get animate():Boolean { return _animate; }

		public function set animate(value:Boolean):void 
		{
			if (value) delete _proxy["animate"];
			else _proxy["animate"] = value;
			_animate = value;
		}
		
		/**
		 * Set this <code>false</code> to disable all fancy animations (except fades).
		 * This can improve the overall effect on computers with poor performance.
		 * Defaults to <code>true</code>.
		 */
		public function get animateFade():Boolean { return _animateFade; }

		public function set animateFade(value:Boolean):void 
		{
			if (value) delete _proxy["animateFade"];
			else _proxy["animateFade"] = value;
			_animateFade = value;
		}

		/**
		 * The animation sequence to use when resizing Shadowbox. 
		 * May be either "wh" (width first, then height), "hw" (height first, then width),
		 * or "sync" (both simultaneously). Defaults to "wh".
		 */
		public function get animSequence():String { return _animSequence; }

		public function set animSequence(value:String):void 
		{
			if (value != WH && value != HW) return;
			if (value == WH) delete _proxy["animSequence"];
			else _proxy["animSequence"] = value;
			_animSequence = value;
		}

		/**
		 * The URL of the flash video player. 
		 * Only needed when displaying Flash video content. 
		 * Defaults to "flvplayer.swf".
		 */
		public function get flvPlayer():String { return _flvPlayer; }

		public function set flvPlayer(value:String):void 
		{
			if (value == FLV_PLAYER) delete _proxy["flvPlayer"];
			else _proxy["flvPlayer"] = value;
			_flvPlayer = value;
		}

		/**
		 * Set this <code>false</code> to disable listening for mouse clicks 
		 * on the overlay that will close Shadowbox. Defaults to <code>true</code>.
		 */
		public function get modal():Boolean { return _modal; }

		public function set modal(value:Boolean):void 
		{
			if (value) delete _proxy["modal"];
			else _proxy["modal"] = value;
			_modal = value;
		}

		/**
		 * The color to use for the modal overlay (in hex). Defaults to "#000".
		 */
		public function get overlayColor():uint { return _overlayColor; }

		public function set overlayColor(value:uint):void 
		{
			if (value == 0) delete _proxy["overlayColor"];
			else _proxy["overlayColor"] = value;
			_overlayColor = value;
		}

		/**
		 * The opacity to use for the modal overlay. Defaults to 0.8.
		 */
		public function get overlayOpacity():Number { return _overlayOpacity; }

		public function set overlayOpacity(value:Number):void 
		{
			if (value == .8) delete _proxy["overlayOpacity"];
			else _proxy["overlayOpacity"] = value;
			_overlayOpacity = value;
		}

		/**
		 * The default background color to use for Flash movies. Defaults to "#000000".
		 */
		public function get flashBgColor():uint { return _flashBgColor; }

		public function set flashBgColor(value:uint):void 
		{
			if (value == 0) delete _proxy["flashBgColor"];
			else _proxy["flashBgColor"] = value;
			_flashBgColor = value;
		}

		/**
		 * Set this <code>false</code> to disable automatically playing movies when they are loaded. 
		 * Defaults to <code>true</code>.
		 */
		public function get autoplayMovies():Boolean { return _autoplayMovies; }

		public function set autoplayMovies(value:Boolean):void 
		{
			if (value) delete _proxy["autoplayMovies"];
			else _proxy["autoplayMovies"] = value;
			_autoplayMovies = value;
		}

		/**
		 * Set this <code>false</code> to disable displaying QuickTime and Windows Media player 
		 * movie control bars. Defaults to <code>true</code>.
		 */
		public function get showMovieControls():Boolean { return _showMovieControls; }

		public function set showMovieControls(value:Boolean):void 
		{
			if (value) delete _proxy["showMovieControls"];
			else _proxy["showMovieControls"] = value;
			_showMovieControls = value;
		}

		/**
		 * A delay (in seconds) to use for slideshows. 
		 * If set to anything other than 0, this value determines an interval 
		 * at which Shadowbox will automatically proceed to the next piece in the gallery. 
		 * Defaults to 0.
		 */
		public function get slideshowDelay():int { return _slideshowDelay; }

		public function set slideshowDelay(value:int):void 
		{
			if (value == 0) delete _proxy["slideshowDelay"];
			else _proxy["slideshowDelay"] = value;
			_slideshowDelay = value;
		}

		/**
		 * The duration (in seconds) of the resizing animations. Defaults to 0.55.
		 */
		public function get resizeDuration():int { return _resizeDuration; }

		public function set resizeDuration(value:int):void 
		{
			if (value == .55) delete _proxy["resizeDuration"];
			else _proxy["resizeDuration"] = value;
			_resizeDuration = value;
		}

		/**
		 * The duration (in seconds) of the fade animations. Defaults to 0.35.
		 */
		public function get fadeDuration():int { return _fadeDuration; }

		public function set fadeDuration(value:int):void 
		{
			if (value == .35) delete _proxy["fadeDuration"];
			else _proxy["fadeDuration"] = value;
			_fadeDuration = value;
		}

		/**
		 * Set this <code>false</code> to hide the gallery navigation controls. 
		 * Defaults to <code>true</code>.
		 */
		public function get displayNav():Boolean { return _displayNav; }

		public function set displayNav(value:Boolean):void 
		{
			if (value) delete _proxy["displayNav"];
			else _proxy["displayNav"] = value;
			_displayNav = value;
		}

		/**
		 * Set this <code>true</code> to enable "continuous" galleries. 
		 * By default, the galleries will not let a user go before the first image 
		 * or after the last. Enabling this feature will let the user go directly 
		 * to the first image in a gallery from the last one by selecting "Next". 
		 * Defaults to <code>false</code>.
		 */
		public function get continuous():Boolean { return _continuous; }

		public function set continuous(value:Boolean):void 
		{
			if (!value) delete _proxy["continuous"];
			else _proxy["continuous"] = value;
			_continuous = value;
		}

		/**
		 * 	Set this <code>false</code> to hide the gallery counter. 
		 * Counters are never displayed on elements that are not part of a gallery. 
		 * Defaults to <code>true</code>.
		 */
		public function get displayCounter():Boolean { return _displayCounter; }

		public function set displayCounter(value:Boolean):void 
		{
			if (value) delete _proxy["displayCounter"];
			else _proxy["displayCounter"] = value;
			_displayCounter = value;
		}

		/**
		 * The mode to use for the gallery counter. 
		 * May be either "default" or "skip". 
		 * The default counter is a simple "1 of 5" message. 
		 * The skip counter displays a separate link to each piece 
		 * in the gallery, enabling quick navigation in large galleries. 
		 * Defaults to "default".
		 */
		public function get counterType():String { return _counterType; }

		public function set counterType(value:String):void 
		{
			if (value != DEFAULT && value != SKIP) return;
			if (value == DEFAULT) delete _proxy["counterType"];
			else _proxy["counterType"] = value;
			_counterType = value;
		}

		/**
		 * Limits the number of counter links that will be displayed 
		 * in a "skip" style counter. If the actual number of gallery elements 
		 * is greater than this value, the counter will be restrained 
		 * to the elements immediately preceding and following the current element. 
		 * Defaults to 10.
		 */
		public function get counterLimit():int { return _counterLimit; }

		public function set counterLimit(value:int):void 
		{
			if (value == 10) delete _proxy["counterLimit"];
			else _proxy["counterLimit"] = value;
			_counterLimit = value;
		}

		/**
		 * The amount of padding (in pixels) to maintain around the edge of the browser window. 
		 * Defaults to 20.
		 */
		public function get viewportPadding():int { return _viewportPadding; }

		public function set viewportPadding(value:int):void 
		{
			if (value == 20) delete _proxy["viewportPadding"];
			else _proxy["viewportPadding"] = value;
			_viewportPadding = value;
		}

		/**
		 * The mode to use for handling content that is too large for the viewport. 
		 * May be one of "none", "resize", or "drag" (for images). 
		 * The "none" setting will not alter the image dimensions, though clipping may occur. 
		 * Setting this to "resize" enables on-the-fly resizing of large content. 
		 * In this mode, the height and width of large, resizable content 
		 * will be adjusted so that it may still be viewed in its entirety while maintaining 
		 * its original aspect ratio. The "drag" mode will display an oversized image 
		 * at its original resolution, but will allow the user to drag it within 
		 * the view to see portions that may be clipped. See the demo for a demonstration 
		 * of all three modes of operation. Defaults to "resize".
		 */
		public function get handleOversize():String { return _handleOversize; }

		public function set handleOversize(value:String):void 
		{
			if (value != RESIZE && value != NONE && value != DRAG) return;
			if (value == RESIZE) delete _proxy["handleOversize"];
			else _proxy["handleOversize"] = value;
			_handleOversize = value;
		}

		/**
		 * A function to use for handling exceptions. 
		 * This function will be passed the error message (string) as its only argument. 
		 * If this value is left null, exceptions will not be caught. Defaults to null.
		 */
		public function get handleException():Function { return _handleException; }

		public function set handleException(value:Function):void 
		{
			if (value == null) delete _proxy["handleException"];
			else _proxy["handleException"] = value;
			createJSDelegate(value);
			_handleException = value;
		}
		
		/**
		 * The mode to use for handling unsupported media. 
		 * May be either "link" or "remove". Media are unsupported when the browser plugin 
		 * required to display the media properly is not installed. 
		 * The link option will display a user-friendly error message with a link 
		 * to a page where the needed plugin can be downloaded. 
		 * The remove option will simply remove any unsupported gallery elements from 
		 * the gallery before displaying it. With this option, if the element is not part 
		 * of a gallery, the link will simply be followed. Defaults to "link".
		 */
		public function get handleUnsupported():Function { return _handleUnsupported; }

		public function set handleUnsupported(value:Function):void 
		{
			if (value == null) delete _proxy["handleUnsupported"];
			else _proxy["handleUnsupported"] = value;
			createJSDelegate(value);
			_handleUnsupported = value;
		}

		/**
		 * The height of Shadowbox (in pixels) when it first appears on the screen. 
		 * Defaults to 160.
		 */
		public function get initialHeight():int { return _initialHeight; }

		public function set initialHeight(value:int):void 
		{
			if (value != 160) delete _proxy["initialHeight"];
			else _proxy["initialHeight"] = value;
			_initialHeight = value;
		}

		/**
		 * The width of Shadowbox (in pixels) when it first appears on the screen.
		 * Defaults to 320.
		 */
		public function get initialWidth():int { return _initialWidth; }

		public function set initialWidth(value:int):void 
		{
			if (value != 320) delete _proxy["initialWidth"];
			else _proxy["initialWidth"] = value;
			_initialWidth = value;
		}

		/**
		 * Set this <code>false</code> to disable keyboard navigation of galleries. 
		 * Defaults to <code>true</code>.
		 */
		public function get enableKeys():Boolean { return _enableKeys; }

		public function set enableKeys(value:Boolean):void 
		{
			if (value) delete _proxy["enableKeys"];
			else _proxy["enableKeys"] = value;
			_enableKeys = value;
		}

		/**
		 * A hook function that will be fired when Shadowbox opens.
		 * The single argument of this function will be the current gallery element.
		 */
		public function get onOpen():Function { return _onOpen; }

		public function set onOpen(value:Function):void 
		{
			if (value == null) delete _proxy["onOpen"];
			else _proxy["onOpen"] = value;
			createJSDelegate(value);
			_onOpen = value;
		}

		/**
		 * A hook function that will fire when Shadowbox finishes loading the current 
		 * gallery piece (after all animations are complete). 
		 * The single argument of this function will be the current gallery element.
		 */
		public function get onFinish():Function { return _onFinish; }

		public function set onFinish(value:Function):void 
		{
			if (value == null) delete _proxy["onFinish"];
			else _proxy["onFinish"] = value;
			createJSDelegate(value);
			_onFinish = value;
		}

		/**
		 * A hook function that will be fired when Shadowbox changes from one gallery 
		 * element to another. The single argument of this function will be the gallery 
		 * element that is about to be displayed.
		 */
		public function get onChange():Function { return _onChange; }

		public function set onChange(value:Function):void 
		{
			if (value == null) delete _proxy["onChange"];
			else _proxy["onChange"] = value;
			createJSDelegate(value);
			_onChange = value;
		}

		/**
		 * A hook function that will be fired when Shadowbox closes. 
		 * The single argument of this function will be the gallery element 
		 * that was last displayed.
		 */
		public function get onClose():Function { return _onClose; }

		public function set onClose(value:Function):void 
		{
			if (value == null) delete _proxy["onClose"];
			else _proxy["onClose"] = value;
			createJSDelegate(value);
			_onClose = value;
		}

		/**
		 * Set this <code>true</code> to skip automatically calling Shadowbox.setup 
		 * when Shadowbox initializes. Defaults to <code>true</code>. 
		 * Note: This option may only be used in Shadowbox.init.
		 */
		public function get skipSetup():Boolean { return _skipSetup; }

		public function set skipSetup(value:Boolean):void 
		{
			if (value) delete _proxy["skipSetup"];
			else _proxy["skipSetup"] = value;
			_skipSetup = value;
		}

		/**
		 * An object containing the names and URL's of plugins and their 
		 * respective download pages.
		 */
		public function get errors():Object { return _errors; }

		public function set errors(value:Object):void 
		{
			
			_errors = value;
		}

		/**
		 * A map of players to their supported extensions. 
		 * See the source for further details. 
		 * Note: This option may only be used in Shadowbox.init.
		 */
		public function get ext():Object { return _ext; }

		public function set ext(value:Object):void 
		{
			_ext = value;
		}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String
		{
			var generated:String = "{"
			for (var p:String in _proxy)
			{
				generated += p + ":" + typeVar(_proxy[p]) + ",";
			}
			return generated.substring(0, generated.length - 1) + "}";
		}
		
		private function typeVar(prop:Object):String
		{
			var genStr:String = "";
			switch (true)
			{
				case (prop is Boolean):
					return prop.toString();
				case (!isNaN(Number(prop))):
					if (Number(prop) == (Number(prop) >> 0))
					{
						genStr = Number(prop).toString(16);
						while (genStr.length < 6)
						{
							genStr = "0" + genStr;
						}
						return "\"#" + genStr + "\"";
					}
					return prop.toString();
				case (prop is String):
					return "\"" + prop + "\"";
				case (prop is Function):
					for (var i:int; i < _callbacks.length; i++)
					{
						if (_callbacks[i].externalF === prop) return _callbacks[i].jsF;
					}
					return "";
			}
			return "";
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
		
		private static function initEI():void
		{
			if (!ExternalInterface.available) return;
			_uid = "f" + new Date().time;
			ExternalInterface.addCallback(_uid, callBack);
			var script:XML =
			<script>
				<![CDATA[
				function() {
					var objects = document.getElementsByTagName("object");
					var embeds = document.getElementsByTagName("embed");
					for (var p in objects)
					{
						if (objects[p].]]>{_uid}<![CDATA[ != undefined) return objects[p].id;
					}
					for (var p in embeds)
					{
						if (embeds[p].]]>{_uid}<![CDATA[ != undefined) return embeds[p].id;
					}
					return "";
				}
				]]>
			</script>;
			_swfID = ExternalInterface.call(script);
		}
		
		public static function callBack():void { };
		
		private function createJSDelegate(func:Function):void
		{
			if (!ExternalInterface.available) return;
			_callbacks.push({internalF: "_f" + (++_counter), externalF: func, jsF: null});
			var theCallBack:String = _callbacks[_callbacks.length - 1].internalF;
			var script:XML =
			<script>
				<![CDATA[
				function() {
					document.__SB_Proxy_]]>{ (++_counter) }<![CDATA[= function() {
						document.getElementById("]]>{ _swfID }<![CDATA[").]]>{ theCallBack }<![CDATA[();
					};
				}
				]]>
			</script>;
			_callbacks[_callbacks.length - 1].jsF = "document.__SB_Proxy_" + _counter;
			ExternalInterface.call(script);
			ExternalInterface.addCallback(theCallBack, func);
		}

	}
	
}