package org.wvxvws.gui.containers 
{
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import org.wvxvws.gui.renderers.IMenuRenderer;
	import org.wvxvws.gui.renderers.MenuRenderer;
	
	//{imports
	
	//}
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
		
		override protected function createChild(xml:XML):DisplayObject 
		{
			var child:IMenuRenderer = super.createChild(xml) as IMenuRenderer;
			if (!child) return null;
			child.iconFactory = (_iconGenerator != null ? _iconGenerator(xml) : 
				ApplicationDomain.currentDomain.hasDefinition(xml[_iconField].toString()) ? 
				ApplicationDomain.currentDomain.getDefinition(xml[_iconField].toString()) : null);
			child.hotKeys = Vector.<int>(xml[_hotkeysField].toString().split("|"));
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
			return child as DisplayObject;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}