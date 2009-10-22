package org.wvxvws.gui.windows 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import org.wvxvws.gui.containers.Pane;
	import org.wvxvws.gui.layout.ILayoutClient;
	import org.wvxvws.gui.renderers.IRenderer;
	import org.wvxvws.gui.skins.SkinProducer;
	
	/**
	 * ChromeIconStrip class.
	 * @author wvxvw
	 */
	public class ChromeIconStrip extends Pane
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property dragHandle
		//------------------------------------
		
		[Bindable("dragHandleChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>dragHandleChanged</code> event.
		*/
		public function get dragHandle():Sprite { return _dragHandle; }
		
		public function set dragHandle(value:Sprite):void 
		{
			if (_dragHandle === value) return;
			if (_dragHandle && super.contains(_dragHandle)) 
				super.removeChild(_dragHandle);
			_dragHandle = value;
			if (_dragHandle)
			{
				_dragHandle.addEventListener(
					MouseEvent.MOUSE_DOWN, handle_mouseDownHandler);
			}
			super.invalidate("_dragHandle", _dragHandle, false);
			super.invalidate("_dataProvider", _dataProvider, false);
			super.dispatchEvent(new Event("dragHandleChanged"));
		}
		
		//------------------------------------
		//  Public property rendererProducer
		//------------------------------------
		
		[Bindable("rendererProducerChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>rendererProducerChanged</code> event.
		*/
		public function get rendererProducer():SkinProducer { return _rendererProducer; }
		
		public function set rendererProducer(value:SkinProducer):void 
		{
			if (_rendererProducer === value) return;
			_rendererProducer = value;
			super.invalidate("_rendererProducer", _rendererProducer, false);
			super.invalidate("_dataProvider", _dataProvider, false);
			super.dispatchEvent(new Event("rendererProducerChanged"));
		}
		
		public function get currentNode():XML { return _currentNode; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _rendererProducer:SkinProducer;
		protected var _dragHandle:Sprite;
		protected var _croups:Vector.<Vector.<DisplayObject>> = 
								new <Vector.<DisplayObject>>[];
		protected var _currentGroup:Vector.<DisplayObject>;
		protected var _cumulativeWidth:int;
		protected var _cellWidth:int = int.MIN_VALUE;
		protected var _gutter:int;
		protected var _padding:Rectangle = new Rectangle();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ChromeIconStrip() { super(); }
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function generateSeparator():DisplayObject
		{
			// TODO:
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected override function layOutChildren():void
		{
			if (_dragHandle && super.contains(_dragHandle))
			{
				super.removeChild(_dragHandle);
			}
			if (_dragHandle) _cumulativeWidth = _padding.top + _dragHandle.width;
			super.layOutChildren();
			if (!super.contains(_dragHandle)) super.addChild(_dragHandle);
		}
		
		protected override function createChild(xml:XML):DisplayObject
		{
			if (_rendererProducer)
			{
				_currentNode = xml;
				_currentRenderer = _rendererProducer.produce(this);
			}
			else return null;
			_currentRenderer.addEventListener(MouseEvent.MOUSE_DOWN, 
									renderer_mouseDownHandler, false, 0, true);
			_currentRenderer.height = super.height - (_padding.top + _padding.bottom);
			if (_cellWidth !== int.MIN_VALUE) _currentRenderer.width = _cellWidth;
			_currentRenderer.y = _padding.top;
			_currentRenderer.height = super._bounds.y;
			super.addChild(_currentRenderer);
			if (_currentRenderer is IRenderer)
			{
				if (_filter !== "")
				{
					(_currentRenderer as IRenderer).labelField = _filter;
				}
			}
			if (_currentRenderer is ILayoutClient)
			{
				(_currentRenderer as ILayoutClient).validate(
					(_currentRenderer as ILayoutClient).invalidProperties);
			}
			_currentRenderer.x = _cumulativeWidth;
			_cumulativeWidth += _currentRenderer.width + _gutter;
			return _currentRenderer;
		}
		
		protected override function drawBackground():void
		{
			_background.clear();
			_background.beginFill(_backgroundColor, _backgroundAlpha);
			_background.drawRect(0, 0, 
				Math.max(_cumulativeWidth, super._bounds.x), _bounds.y);
			_background.endFill();
		}
		
	}

}