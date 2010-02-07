package org.wvxvws.gui.repeaters 
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.IMXMLObject;
	import org.wvxvws.gui.skins.ISkin;
	
	/**
	 * ListRepeater
	 * @author wvxvw
	 */
	public class ListRepeater extends EventDispatcher implements IMXMLObject, IRepeater
	{
		/* INTERFACE org.wvxvws.gui.repeaters.IRepeater */
		
		public function get index():int { return this._index; }
		
		public function get currentItem():Object { return this._currentItem; }
		
		protected var _id:String;
		protected var _ihost:IRepeaterHost;
		protected var _creationCallback:Function;
		protected var _factory:ISkin;
		protected var _index:int;
		protected var _currentItem:Object;
		protected var _event:RepeaterEvent;
		
		public function ListRepeater(host:IRepeaterHost = null)
		{
			super();
			if (host)
			{
				this._ihost = host;
				this._creationCallback = host.repeatCallback;
			}
			this._event = new RepeaterEvent(RepeaterEvent.REPEAT, this);
		}
		
		/* INTERFACE mx.core.IMXMLObject */
		
		public function initialized(document:Object, id:String):void
		{
			this._ihost = document as IRepeaterHost;
			if (this._ihost) this._creationCallback = this._ihost.repeatCallback;
			this._id = id;
		}
		
		public function dispose():void { }
		
		public function begin(at:int):void
		{
			this._index = at - 1;
			this._factory = this._ihost.factory;
			var pool:Vector.<Object> = this._ihost.pool;
			var dispatch:Boolean = super.hasEventListener(RepeaterEvent.REPEAT);
			do
			{
				this._index++;
				if (pool && pool.length) this._currentItem = pool.pop();
				else
				{
					this._currentItem = 
						this._factory.produce(this._ihost, this._index);
				}
				if (dispatch) super.dispatchEvent(this._event);
			}
			while (this._creationCallback(this._currentItem, this._index));
		}
	}
}