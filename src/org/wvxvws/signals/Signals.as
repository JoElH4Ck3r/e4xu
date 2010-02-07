package org.wvxvws.signals 
{
	//{ imports
	import flash.utils.Dictionary;
	//}
	
	/**
	 * Signal class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class Signals 
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _allStrong:Dictionary = new Dictionary();
		protected var _allWeak:Dictionary = new Dictionary(true);
		protected var _semaphore:ISemaphore;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Signals(scope:ISemaphore) 
		{
			super();
			this._semaphore = scope;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function add(type:SignalType, slot:Function, priority:int = -1, 
			params:Vector.<Class> = null, weak:Boolean = false):void
		{
			var sig:Vector.<Class>;
			var target:Dictionary;
			var alter:Dictionary;
			
			if (this._semaphore.signalTypes().indexOf(type) < 0)
				throw SignalError.NO_TYPE;
			sig = this._semaphore.callbackSignature(type);
			for (var i:int; ; i++)
			{
				if (sig === params) break;
				if (!sig || !params || 
					sig.length !== params.length)
				{
					trace(sig, params);
					throw SignalError.WRONG_SIGNATURE;
					break;
				}
				if (i < sig.length && sig[i] === params[i])
					continue;
				else if (i === sig.length) break;
				else
				{
					throw SignalError.WRONG_SIGNATURE;
					break;
				}
			}
			if (weak)
			{
				if (!this._allWeak[type]) this._allWeak[type] = new Dictionary(true);
				target = this._allWeak[type] as Dictionary;
				alter = this._allStrong[type] as Dictionary;
			}
			else
			{
				if (!this._allStrong[type]) this._allStrong[type] = new Dictionary();
				target = this._allStrong[type] as Dictionary;
				alter = this._allWeak[type] as Dictionary;
			}
			if (alter) delete alter[slot];
			target[slot] = priority;
		}
		
		public function rem(type:SignalType, slot:Function):void
		{
			var d:Dictionary = this._allStrong[type];
			
			if (!d) d = this._allWeak[type];
			if (d) delete d[slot];
		}
		
		public function call(type:SignalType, ...params):void
		{
			var temp:Dictionary = new Dictionary();
			var o:Object;
			var strong:Dictionary = this._allStrong[type];
			var weak:Dictionary = this._allWeak[type];
			
			// Vector requires callback for sorting
			var indices:Array/*int*/ = [];
			if (strong === weak)
			{
				throw SignalError.NO_TYPE;
				return;
			}
			for (o in strong) indices.push(temp[o] = strong[o]);
			for (o in weak) indices.push(temp[o] = weak[o]);
			indices.sort();
			var len:int = indices.length;
			for (var i:int; i < len; i++)
			{
				for (o in temp)
				{
					if (temp[o] === indices[i])
					{
						(o as Function).apply(null, params.concat());
						break;
					}
				}
				delete temp[o];
			}
		}
		
		public function all(type:SignalType = null, 
			weak:Boolean = false, strong:Boolean = true):Dictionary
		{
			var d:Dictionary;
			var td:Dictionary;
			var o:Object;
			var to:Object;
			
			if (strong)
			{
				if (type)
				{
					td = this._allStrong[type];
					if (td)
					{
						for (to in td)
						{
							if (!d) d = new Dictionary();
							d[to] = td[to];
						}
					}
				}
				else
				{
					for (o in this._allStrong)
					{
						td = o as Dictionary;
						for (to in td)
						{
							if (!d) d = new Dictionary();
							d[to] = td[to];
						}
					}
				}
			}
			if (weak)
			{
				if (type)
				{
					td = this._allWeak[type];
					if (td)
					{
						for (to in td)
						{
							if (!d) d = new Dictionary();
							d[to] = td[to];
						}
					}
				}
				else
				{
					for (o in this._allWeak)
					{
						td = o as Dictionary;
						for (to in td)
						{
							if (!d) d = new Dictionary();
							d[to] = td[to];
						}
					}
				}
			}
			return d;
		}
		
		public function has(slot:Function, type:SignalType = null,
			weak:Boolean = true, strong:Boolean = true):Boolean
		{
			var td:Dictionary;
			var o:Object;
			var to:Object;
			
			if (strong)
			{
				if (type)
				{
					td = this._allStrong[type];
					if (td)
					{
						for (to in td)
						{
							if (slot === to) return true;
						}
					}
				}
				else
				{
					for (o in this._allStrong)
					{
						td = o as Dictionary;
						for (to in td)
						{
							if (slot === to) return true;
						}
					}
				}
			}
			if (weak)
			{
				if (type)
				{
					td = this._allWeak[type];
					if (td)
					{
						for (to in td)
						{
							if (slot === to) return true;
						}
					}
				}
				else
				{
					for (o in this._allWeak)
					{
						td = o as Dictionary;
						for (to in td)
						{
							if (slot === to) return true;
						}
					}
				}
			}
			return false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
	}
}