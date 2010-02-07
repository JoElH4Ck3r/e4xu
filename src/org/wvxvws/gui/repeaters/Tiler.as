////////////////////////////////////////////////////////////////////////////////
//
//  Copyright (C) Oleg Sivokon email: olegsivokon@gmail.com
//  
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//  Or visit http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
//
////////////////////////////////////////////////////////////////////////////////

package org.wvxvws.gui.repeaters
{
	//{ imports
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import mx.core.IMXMLObject;
	//}
	
	[DefaultProperty("factory")]
	
	/**
	 * Tiler class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.28
	 */
	public class Tiler extends EventDispatcher implements IMXMLObject
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//------------------------------------
		//  Public property factory
		//------------------------------------
		
		[Bindable("factoryChanged")]
		
		/**
		* Extends DisplayObject
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>factoryChanged</code> event.
		*/
		public function get factory():Class { return _factory; }
		
		public function set factory(value:Class):void 
		{
			if (this._factory === value) return;
			this._factory = value;
			super.dispatchEvent(new Event("factoryChanged"));
		}
		
		//------------------------------------
		//  Public property cellWidth
		//------------------------------------
		
		[Bindable("cellWidthChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cellWidthChanged</code> event.
		*/
		public function get cellWidth():int { return this._cellWidth; }
		
		public function set cellWidth(value:int):void 
		{
			if (this._cellWidth === value) return;
			this._cellWidth = value;
			super.dispatchEvent(new Event("cellWidthChanged"));
		}
		
		//------------------------------------
		//  Public property cellHeight
		//------------------------------------
		
		[Bindable("cellHeightChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>cellHeightChanged</code> event.
		*/
		public function get cellHeight():int { return this._cellHeight; }
		
		public function set cellHeight(value:int):void 
		{
			if (this._cellHeight === value) return;
			this._cellHeight = value;
			super.dispatchEvent(new Event("cellHeightChanged"));
		}
		
		//------------------------------------
		//  Public property hSpace
		//------------------------------------
		
		[Bindable("hSpaceChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>hSpaceChanged</code> event.
		*/
		public function get hSpace():int { return this._hSpace; }
		
		public function set hSpace(value:int):void 
		{
			if (_hSpace === value) return;
			this._hSpace = value;
			super.dispatchEvent(new Event("hSpaceChanged"));
		}
		
		//------------------------------------
		//  Public property vSpace
		//------------------------------------
		
		[Bindable("vSpaceChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>vSpaceChanged</code> event.
		*/
		public function get vSpace():int { return this._vSpace; }
		
		public function set vSpace(value:int):void 
		{
			if (this._vSpace === value) return;
			this._vSpace = value;
			super.dispatchEvent(new Event("vSpaceChanged"));
		}
		
		//------------------------------------
		//  Public property padding
		//------------------------------------
		
		[Bindable("paddingChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>paddingChanged</code> event.
		*/
		public function get padding():Rectangle { return this._padding; }
		
		public function set padding(value:Rectangle):void 
		{
			if (this._padding === value) return;
			this._padding = value;
			super.dispatchEvent(new Event("paddingChanged"));
		}
		
		//------------------------------------
		//  Public property bounds
		//------------------------------------
		
		[Bindable("boundsChanged")]
		
		/**
		* ...
		* This property can be used as the source for data binding.
		* When this property is modified, it dispatches the <code>boundsChanged</code> event.
		*/
		public function get bounds():Point { return this._bounds; }
		
		public function set bounds(value:Point):void 
		{
			if (this._bounds === value) return;
			this._bounds = value;
			super.dispatchEvent(new Event("boundsChanged"));
		}
		
		public function get index():int { return this._index; }
		
		public function get id():String { return this._id; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _factory:Class;
		protected var _cellWidth:int;
		protected var _cellHeight:int;
		protected var _hSpace:int;
		protected var _vSpace:int;
		protected var _padding:Rectangle = new Rectangle();
		protected var _creationCallback:Function;
		protected var _index:int;
		protected var _bounds:Point = new Point();
		protected var _timer:Timer = new Timer(1, 1);
		protected var _host:IRepeaterHost;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private var _id:String;
		
		//--------------------------------------------------------------------------
		//
		//  Cunstructor
		//
		//--------------------------------------------------------------------------
		
		public function Tiler(host:IRepeaterHost = null)
		{
			super();
			if (host) _creationCallback = host.repeatCallback;
			this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function begin():void
		{
			this._index = 0;
			this.createImage();
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			if (!(document is IRepeaterHost))
				throw new ArgumentError(document + " cannot host repeater.");
			this._host = host as IRepeaterHost;
			this._creationCallback = this._host.repeatCallback;
			this._id = id;
		}
		
		public function dispose():void { }
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		protected function createImage():void
		{
			var image:DisplayObject = new this._factory() as DisplayObject;
			image.width = this._cellWidth;
			image.height = this._cellHeight;
			var totalWidth:int = 
				this._bounds.x - (this._padding.left + this._padding.right);
			var cellsH:int = 
				(totalWidth + this._hSpace) / (this._cellWidth + this._hSpace);
			
			image.x = 
				this._padding.left + (this._index % cellsH) * 
				(this._cellWidth + this._hSpace)
			image.y = 
				this._padding.top + ((this._index / cellsH) >> 0) * 
				(this._cellHeight + this._vSpace);
			(this._host as DisplayObjectContainer).addChild(image);
			this._index++;
			if (this._index % 0xFF)
			{
				if (this._creationCallback(image, this._index)) this.createImage();
			}
			else 
			{
				this._timer.reset();
				this._timer.start();
			}
		}
		
		protected function timerHandler(event:TimerEvent):void { this.createImage(); }
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
	}
	
}