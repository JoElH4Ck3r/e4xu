package org.wvxvws.gui.containers 
{
	//{imports
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.system.ApplicationDomain;
	import org.wvxvws.gui.renderers.IMenuRenderer;
	import org.wvxvws.gui.renderers.MenuRenderer;
	//}
	
	[DefaultProperty("dataProvider")]
	
	/**
	* Menu class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class Menu extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public static const CHECK:String = "check";
		public static const CONTAINER:String = "container";
		public static const RADIO:String = "radio";
		public static const SEPARATOR:String = "separator";
		public static const NONE:String = "";
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _groups:Vector.<Vector.<IMenuRenderer>>;
		protected var _iconGenerator:Function;
		protected var _iconField:String = "@icon";
		protected var _hotkeysField:String = "@hotkeys";
		protected var _kindField:String = "@kind";
		protected var _enabledField:String = "@enabled";
		protected var _lastGroup:Vector.<IMenuRenderer>;
		protected var _cumulativeHeight:int;
		protected var _cumulativeWidth:int;
		protected var _nextY:int;
		
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
		
		public function Menu()
		{
			super();
			super._rendererFactory = MenuRenderer;
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
		
		override public function validate(properties:Object):void 
		{
			super.validate(properties);
			drawIconBG();
		}
		
		protected override function layOutChildren():void 
		{
			_cumulativeHeight = 0;
			_cumulativeWidth = 0;
			_nextY = 0;
			super.layOutChildren();
			super.width = _cumulativeWidth;
			super.height = _cumulativeHeight;
			var i:int = super.numChildren;
			var child:DisplayObject;
			while (i--)
			{
				child = super.getChildAt(i);
				child.width = _cumulativeWidth;
			}
		}
		
		protected override function createChild(xml:XML):DisplayObject 
		{
			var child:IMenuRenderer = super.createChild(xml) as IMenuRenderer;
			if (!child) return null;
			child.iconFactory = (_iconGenerator != null ? _iconGenerator(xml) : 
				ApplicationDomain.currentDomain.hasDefinition(xml[_iconField].toString()) ? 
				ApplicationDomain.currentDomain.getDefinition(xml[_iconField].toString()) as Class : null);
			if (xml[_hotkeysField].toString().length)
			{
				child.hotKeys = Vector.<int>(xml[_hotkeysField].toString().split("|"));
			}
			child.kind = xml[_kindField].toString();
			child.enabled = Boolean(xml[_enabledField]);
			if (child.kind !== SEPARATOR)
			{
				if (!_groups)
					_groups = new Vector.<Vector.<IMenuRenderer>>(0, false);
				if (!_lastGroup)
					_lastGroup = new Vector.<IMenuRenderer>(0, false);
				_lastGroup.push(child);
				_groups.push(_lastGroup);
			}
			else
			{
				_lastGroup = new Vector.<IMenuRenderer>(0, false);
				_lastGroup.push(child);
				_groups.push(_lastGroup);
			}
			(child as DisplayObject).y = _nextY;
			_nextY += (child as DisplayObject).height;
			_cumulativeHeight += (child as DisplayObject).height;
			_cumulativeWidth = Math.max(_cumulativeWidth, (child as DisplayObject).width);
			return child as DisplayObject;
		}
		
		protected function drawIconBG():void
		{
			trace("_cumulativeHeight", _cumulativeHeight)
			var g:Graphics = super.graphics;
			g.clear();
			g.beginFill(0xD0D0D0);
			g.drawRect(0, 0, 20, _cumulativeHeight);
			g.endFill();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}