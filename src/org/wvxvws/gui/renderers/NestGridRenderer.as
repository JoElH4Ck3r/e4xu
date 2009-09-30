package org.wvxvws.gui.renderers 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author wvxvw
	 */
	public class NestGridRenderer extends Sprite implements IRenderer
	{
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.renderers.IRenderer */
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _dataCopy.contains(_data);
		}
		
		public function get data():XML { return _data; }
		
		public function set data(value:XML):void
		{
			if (isValid && _data === value) return;
			_data = value;
			_dataCopy = value.copy();
			render();
		}
		
		public function set labelFunction(value:Function):void
		{
			_labelFunction = value;
			if (_data) rendrerText();
		}
		
		public function get labelField():String { return _labelField; }
		
		public function set labelField(value:String):void 
		{
			if (_data) rendrerText();
			_labelField = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _data:XML;
		protected var _field:TextField = new TextField();
		protected var _document:Object;
		protected var _id:String;
		protected var _hasChildren:Boolean;
		protected var _nestingLevel:int;
		protected var _closed:Boolean;
		
		protected var _icon:InteractiveObject;
		protected var _iconClass:Class;
		protected var _iconFactory:Function;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		public function NestGridRenderer() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function initialized(document:Object, id:String):void
		{
			_id = id;
			_document = document;
		}
		
	}

}