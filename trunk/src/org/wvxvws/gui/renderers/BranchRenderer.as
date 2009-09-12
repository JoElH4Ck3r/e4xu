package org.wvxvws.gui.renderers 
{
	//{imports
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.containers.Nest;
	import org.wvxvws.gui.GUIEvent;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.layout.LayoutValidator;
	//}
	
	/**
	* BranchRenderer class.
	* @author wvxvw
	* @langVersion 3.0
	* @playerVersion 10.0.12.36
	*/
	public class BranchRenderer extends Sprite implements ILayoutClient, IMXMLObject, IBranchRenderer
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.gui.layout.ILayoutClient */
		
		public function get validator():LayoutValidator { return _validator; }
		
		public function get invalidProperties():Object { return _invalidProperties; }
		
		public function get layoutParent():ILayoutClient { return _layoutParent; }
		
		public function set layoutParent(value:ILayoutClient):void
		{
			_layoutParent = value;
		}
		
		public function get childLayouts():Vector.<ILayoutClient>
		{
			return _childLayouts;
		}
		
		public function get id():String { return _id; }
		
		public function get closed():Boolean { return _closed; }
		
		public function get selected():Boolean { return _selected; }
		
		/* INTERFACE org.wvxvws.gui.renderers.IBranchRenderer */
		
		public function get closedHeight():int { return _closedHeight; }
		
		public function get opened():Boolean { return _opened; }
		
		public function set opened(value:Boolean):void
		{
			if (_opened === value) return;
			_opened = value;
			invalidate("_opened", _opened, true);
		}
		
		public function set leafLabelFunction(value:Function):void
		{
			if (_leafLabelFunction === value) return;
			_leafLabelFunction = value;
			invalidate("_leafLabelFunction", _leafLabelFunction, false);
		}
		
		public function set leafLabelField(value:String):void
		{
			if (_leafLabelField === value) return;
			_leafLabelField = value;
			invalidate("_leafLabelField", _leafLabelField, false);
		}
		
		public function set folderIcon(value:Class):void
		{
			if (_folderIcon === value) return;
			_folderIcon = value;
			invalidate("_folderIcon", _folderIcon, false);
		}
		
		public function set closedIcon(value:Class):void
		{
			if (_closedIcon === value) return;
			_closedIcon = value;
			invalidate("_closedIcon", _closedIcon, false);
		}
		
		public function set openIcon(value:Class):void
		{
			if (_openIcon === value) return;
			_openIcon = value;
			invalidate("_openIcon", _openIcon, false);
		}
		
		public function set docIconFactory(value:Function):void
		{
			if (_docIconFactory === value) return;
			_docIconFactory = value;
			invalidate("_docIconFactory", _docIconFactory, false);
		}
		
		public function get isValid():Boolean
		{
			if (!_data) return false;
			return _dataCopy.contains(_data);
		}
		
		public function set labelFunction(value:Function):void
		{
			if (_labelFunction === value) return;
			_labelFunction = value;
			invalidate("_labelFunction", _labelFunction, false);
		}
		
		public function set labelField(value:String):void
		{
			if (_labelField === value) return;
			_labelField = value;
			invalidate("_labelField", _labelField, false);
		}
		
		public function get data():XML
		{
			
		}
		
		public function set data(value:XML):void
		{
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _document:Object;
		protected var _id:String;
		protected var _invalidProperties:Object = { };
		protected var _childLayouts:Vector.<ILayoutClient> = new Vector.<ILayoutClient>(0, false);
		protected var _layoutParent:ILayoutClient;
		protected var _validator:LayoutValidator;
		protected var _hasPendingValidation:Boolean;
		protected var _hasPendingParentValidation:Boolean;
		
		protected var _opened:Boolean;
		protected var _selected:Boolean;
		
		protected var _openCloseIcon:InteractiveObject;
		protected var _folderIcon:InteractiveObject;
		protected var _label:TextField;
		protected var _lines:Shape;
		protected var _closedHeight:int;
		protected var _leafLabelFunction:Function;
		protected var _leafLabelField:String;
		protected var _labelField:String;
		protected var _labelFunction:Function;
		protected var _dataCopy:XML;
		
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
		
		public function BranchRenderer() { super(); }
		
		public function validate(properties:Object):void
		{
			
		}
		
		public function invalidate(property:String, cleanValue:*, validateParent:Boolean):void
		{
			_invalidProperties[property] = cleanValue;
			if (_validator) _validator.requestValidation(this, validateParent);
			else
			{
				_hasPendingValidation = true;
				_hasPendingParentValidation = _hasPendingParentValidation || validateParent;
			}
		}
		
		public function nodeToRenderer(node:XML):IRenderer
		{
			
		}
		
		public function rendererToXML(renderer:IRenderer):XML
		{
			
		}
		
		public function indexForItem(item:IRenderer):int
		{
			
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			_document = document;
			//if (_document is Nest)
			//{
				//(_document as Nest).addChild(this);
			//}
			_id = id;
			if (_hasPendingValidation) validate(_invalidProperties);
			dispatchEvent(new GUIEvent(GUIEvent.INITIALIZED));
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