package org.wvxvws.jsutils.shadowbox
{
	import flash.external.ExternalInterface;
	
	/**
	* ShadowBoxInterface class.
	* @includeExample D:/projects/shadowbox/docs/examples/Main.as
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class ShadowBoxInterface 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		public static const FLV:String = "flv";
		public static const IFRAME:String = "iframe";
		public static const IMG:String = "img";
		public static const HTML:String = "html";
		public static const QT:String = "qt";
		public static const SWF:String = "swf";
		public static const WMP:String = "wmp";
		
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
		private static var _init:Boolean;
		static private var _linksContainer:XML = 
		<script>
			<![CDATA[
			function() {
				var b = document.getElementsByTagName("body")[0];
				var div = document.createElement("div");
				div.id = "SB_links_container";
				div.style.visibility = "hidden";
				b.appendChild(div);
			}]]>
		</script>;
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * All of the methods of this class are static, there's no need 
		 * to instantiate it.
		 */
		public function ShadowBoxInterface() { super();	}
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Calls the <code>Shadowbox.open()</code> from HTML page.
		 * Opens the specified object in Shadowbox. 
		 * The optional options parameter may be used here to specify the set 
		 * of options to apply on this call only.
		 * 
		 * @param	content			String. The content to display.
		 * 
		 * @param	player			String. The type of the player to use when 
		 * 							displaying the content. Valid values are:
		 * 							<code>ShadowBoxInterface.FLV | ShadowBoxInterface.IFRAME | 
		 * 							ShadowBoxInterface.IMG | ShadowBoxInterface.HTML | 
		 * 							ShadowBoxInterface.QT | ShadowBoxInterface.SWF | 
		 * 							ShadowBoxInterface.WMP</code>
		 * @param	title			String. The title for the pop-up.
		 * 
		 * @param	gallery			String. The additional tile for the gallery.
		 * @default null.
		 * 
		 * @param	windowHeight	int. The height of the pop-up window.
		 * @default 350.
		 * 
		 * @param	windowWidth		int. The width of the pop-up window.
		 * @default 350.
		 * 
		 * @param	options			ShadowOptions. The ShadowOptions object.
		 * @default	<code>null</code>
		 * 
		 * @throws	ArgumentError. If <code>player</code> argument is not recognized, 
		 * 			the error is thrown.
		 * 
		 * @example <listing version="3.0">package 
		 * 	{
		 * 		import flash.display.Sprite;
		 * 		import flash.events.Event;
		 * 		import flash.events.MouseEvent;
		 * 		
		 * 		public class Main extends Sprite 
		 * 		{
		 * 			private var _output:TextField = new TextField();
		 * 			
		 * 			public function Main():void 
		 * 			{
		 * 				if (stage) init();
		 * 				else addEventListener(Event.ADDED_TO_STAGE, init);
		 * 			}
		 * 			
		 * 			private function init(event:Event = null):void 
		 * 			{
		 * 				removeEventListener(Event.ADDED_TO_STAGE, init);
		 * 				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		 * 				_tf.width = stage.stageWidth;
		 * 				_tf.height = stage.stageHeight;
		 * 				_tf.multiline = true;
		 * 				addChild(_tf);
		 * 			}
		 * 			
		 * 			private function testHandler(...rest):void
		 * 			{
		 * 				_output.text = "testHandler " + rest;
		 * 			}
		 * 			
		 * 			private function mouseDownHandler(event:MouseEvent):void 
		 * 			{
		 * 				var options:ShadowOptions = new ShadowOptions();
		 * 				options.animate = false;
		 * 				options.animSequence = ShadowOptions.HW;
		 * 				options.overlayColor = 0xFF0;
		 * 				options.onOpen = testHandler;
		 * 				ShadowBoxInterface.open("test.jpg", ShadowBoxInterface.IMG, 
		 * 													"Testing Image", "", 150, 150, options);
		 * 			}
		 * 		}
		 * 		
		 * 	}</listing>
		 */
		public static function open(content:String, player:String, title:String, 
			gallery:String = null, windowHeight:int = 350, windowWidth:int = 350, 
			options:ShadowOptions = null):void
		{
			if (!ExternalInterface.available) return;
			ExternalInterface.call(getScriptXML.apply(ShadowBoxInterface, arguments));
		}
		
		/**
		 * Initializes the Shadowbox environment. Appends Shadowbox' HTML
		 * to the document and sets up several listeners. The optional options 
		 * parameter may be used here to set the default universal set of options.
		 * This function may not be called twice.<br/>
		 * <font color="red">Not implemented!</font>
		 * 
		 * @param	options	ShadowOptions.
		 * @default	null
		 */
		public static function init(options:ShadowOptions = null):void
		{
			
		}
		
		/**
		 * Sets up listeners on the given <code>links</code> that will trigger Shadowbox. 
		 * If no links are given, this method will set up every anchor element 
		 * on the page with the appropriate rel attribute. 
		 * Please note that because HTML area elements do not support the rel attribute, 
		 * they must be explicitly passed to this method. 
		 * The optional <code>options</code> parameter specifies a set of options that will 
		 * be applied to all links in this set by default.<br/>
		 * <font color="red">Not implemented!</font>
		 * 
		 * @param	links	Array of type ShadowLink.
		 * @default	null
		 * 
		 * @param	options	ShadowOptions.
		 * @default	null
		 */
		public static function setup(links:Array /*of type ShadowLink*/ = null, 
													options:ShadowOptions = null):void
		{
			if (!ExternalInterface.available) return;
			if (!_init) writeLinkContainer();
			if (!links) return;
			var result:String = "";
			for each (var p:ShadowLink in links) result += p.toString();
			var script:XML =
			<script>
				<![CDATA[
				function() {
					document.getElementById("SB_links_container").innerHTML = ']]>
					{ result }
					<![CDATA[';
				}]]>
			</script>;
			ExternalInterface.call(script);
			ExternalInterface.call("function(){return Shadowbox.setup();}");
		}
		
		private static function writeLinkContainer():void
		{
			if (!ExternalInterface.available) return;
			ExternalInterface.call(_linksContainer);
			_init = true;
		}
		
		/**
		 * Applies the given set of options to those currently in use.
		 * Note: Options will be reset on Shadowbox.open so this function is only
		 * useful after it has already been called (while Shadowbox is open).<br/>
		 * <font color="red">Not implemented!</font>
		 * 
		 * @param	options	ShadowOptions.
		 */
		public static function applyOptions(options:ShadowOptions):void
		{
			
		}
		
		/**
		 * Reverts Shadowbox' options to the last default set in use before 
		 * Shadowbox.applyOptions was called.
		 */
		public static function revertOptions():void
		{
			if (!ExternalInterface.available) return;
			ExternalInterface.call("function(){return Shadowbox.revertOptions();}");
		}
		
		/**
		 * Jumps to the piece in the current gallery with index n.
		 * 
		 * @param	position	int.
		 */
		public static function change(position:int):void
		{
			if (!ExternalInterface.available) return;
			ExternalInterface.call("function(){return Shadowbox.change(" + 
														position + ");}");
		}
		
		/**
		 * Jumps to the next piece in the gallery.
		 */
		public static function next():Object
		{
			if (!ExternalInterface.available) return null;
			return ExternalInterface.call("function(){return Shadowbox.next();}");
		}
		
		/**
		 * Jumps to the previous piece in the gallery.
		 */
		public static function previous():Object
		{
			if (!ExternalInterface.available) return null;
			return ExternalInterface.call("function(){return Shadowbox.previous();}");
		}
		
		/**
		 * Deactivates Shadowbox.
		 */
		public static function close():void
		{
			if (!ExternalInterface.available) return;
			ExternalInterface.call("function(){return Shadowbox.close();}");
		}
		
		/**
		 * Clears Shadowbox' cache and removes listeners and expandos 
		 * from all cached link elements. 
		 * May be used to completely reset Shadowbox in case links on a page change.
		 */
		public static function clearCache():void
		{
			if (!ExternalInterface.available) return;
			ExternalInterface.call("function(){return Shadowbox.clearCache();}");
		}
		
		/**
		 * Gets an object that lists which plugins are supported by the client. 
		 * The keys of this object will be:
		 * <ul>
		 * <li>fla—Adobe Flash Player</li>
		 * <li>qt—QuickTime Player</li>
		 * <li>wmp—Windows Media Player</li>
		 * <li>f4m—Flip4Mac QuickTime Player</li></ul>
		 */
		public static function getPlugins():Object
		{
			if (!ExternalInterface.available) return null;
			return ExternalInterface.call("function(){return Shadowbox.getPlugins();}");
		}
		
		/**
		 * Gets the current options object in use.
		 */
		public static function getOptions():Object
		{
			if (!ExternalInterface.available) return null;
			return ExternalInterface.call("function(){return Shadowbox.getOptions();}");
		}
		
		/**
		 * Gets the current gallery object.
		 */
		public static function getCurrent():Object
		{
			if (!ExternalInterface.available) return null;
			return ExternalInterface.call("function(){return Shadowbox.getCurrent();}");
		}
		
		/**
		 * Returns current version of Shadowbox.js.
		 */
		public static function getVersion():String
		{
			if (!ExternalInterface.available) return "undefined";
			return ExternalInterface.call("function(){return Shadowbox.getVersion();}");
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
		
		/**
		 * @private
		 */
		private static var getScriptXML:Function = function(content:String, 
					player:String, title:String, gallery:String = null, windowHeight:int = 350, 
					windowWidth:int = 350, options:ShadowOptions = null):String
		{
			if (gallery == null) gallery = "";
			var op:String = options ? String("}," + options).substring(0, options.toString().length + 1) : "";
			switch(player)
			{
				case FLV:
				case IFRAME:
				case IMG:
				case HTML:
				case QT:
				case SWF:
				case WMP:
					break;
				default:
					throw new ArgumentError("\"player\" must be one of the following types:" +
						FLV + " | " + IFRAME +  " | " + IMG +  " | " + HTML +  " | " + QT +
						" | " + SWF +  " | " + WMP);
					break;
			}
			return(<script>
				<![CDATA[function(){Shadowbox.open({content:"]]>
				{ content }
				<![CDATA[",player:"]]>
				{ player }
				<![CDATA[",title:"]]>
				{ title }
				<![CDATA[",gallery:"]]>
				{ gallery }
				<![CDATA[",height:]]>
				{ windowHeight }
				<![CDATA[,width:]]>
				{ windowWidth }
				{ op }
				<![CDATA[});}]]>
				</script>);
		}
	}
	
}