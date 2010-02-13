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
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _allStrong:Dictionary/*Vector.<Class>*/ = new Dictionary();
		protected var _allWeak:Dictionary/*Vector.<Class>*/ = new Dictionary(true);
		protected var _semaphore:ISemaphore;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * You should initialize the <code>Signals</code> class by passing it an 
		 * instance of <code>ISemaphore</code>. The functionality is dividet 
		 * between the two like so:
		 * The <code>ISemaphore</code> defines the signal types, but the <code>Signals</code>
		 * calls the slots (handlers), adds and removes them.
		 * 
		 * @param	scope	The object defining the signal types. Note that even 
		 * though multiple objects may technically share the same <code>Signals</code>
		 * instance, it is not recommended.
		 */
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
		
		/**
		 * Adds a slot (handler) for the later call.
		 * Note that if the arguments taken by the slot do not match with those
		 * defined in the signal type, the runtime error is thrown once the method is
		 * called. This, however, cannot be checked at compile time, or not even 
		 * before the slot will be actually called.
		 * 
		 * @param	type		The <code>SignalType</code> is an empty class. 
		 * When implementing <code>ISemaphore</code> you should extend it and define 
		 * the signal types specific to that <code>ISemaphore</code>. 
		 * One <code>ISemaphore</code> may define several signal types.
		 * 
		 * @param	slot		The function to call back once the <code>call()</code>
		 * method for this signal type will run.
		 * Note, you can register the same slot for different signal types, however, 
		 * the same slot cannot be registered twice for the same signal type.
		 * 
		 * @param	priority	This argument allows you to manage slots invoke order.
		 * Values less then 0 are all treated as same and are added to the end of the 
		 * invoke list.
		 * @default	<code>-1</code>
		 * 
		 * @param	weak		If <code>true</code>, the reference to the slot will
		 * be marked for garbage collection once all other references to it are removed.
		 * @default	<code>false</code>
		 * 
		 * @throws <code>SignalError.NO_TYPE</code>
		 */
		public function add(type:Vector.<Class>, slot:Function, priority:int = -1, 
			weak:Boolean = false):void
		{
			var sig:Vector.<Class>;
			var target:Dictionary;
			var alter:Dictionary;
			
			if (this._semaphore.signalTypes().indexOf(type) < 0)
				throw SignalError.NO_TYPE;
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
		
		/**
		 * Removes the slot from the invoke list. Note that if the slot was previously
		 * added for a different signal type it will not be removed.
		 * 
		 * @param	type	The type of the sginal for which you want 
		 * to unregister the slot.
		 * 
		 * @param	slot	The handler you want to unregister.
		 */
		public function rem(type:SignalType, slot:Function):void
		{
			var d:Dictionary = this._allStrong[type];
			
			if (!d) d = this._allWeak[type];
			if (d) delete d[slot];
		}
		
		/**
		 * Calls all the slots (handlers) registered for this signal type.
		 * If the arguments types specified int the signal type do not match
		 * the arguments provided to this method, the error is thrown.
		 * 
		 * @param	type		The signal type for which you want to call the slots.
		 * 
		 * @param	...params	The parameters to pass to the slots. 
		 * Note, you can modify the arguments of the slot when it is being called. 
		 * Each new slot is invoked with a copy of the arguments array.
		 * Note, the types of parameters should match exactly to those defined in 
		 * signal type. However it is not possible to verify this at compile time.
		 * 
		 * @throws <code>SignalError.NO_TYPE</code>
		 * @throws <code>SignalError.WRONG_SIGNATURE</code>
		 */
		public function call(types:Vector.<Class>, ...params):void
		{
			var temp:Dictionary = new Dictionary();
			var o:Object;
			var strong:Dictionary = this._allStrong[types];
			var weak:Dictionary = this._allWeak[types];
			var c:Class;
			var len:int;
			if ((params as Object) !== (types as Object))
			{
				if (!params || !types || params.length !== types.length)
					throw SignalError.WRONG_SIGNATURE;
				else
				{
					len = types.length;
					for (var i:int; i < len; i++)
					{
						c = types[i];
						if (!(params[i] is c))
						{
							throw SignalError.WRONG_SIGNATURE;
							break;
						}
					}
				}
			}
			// Vector requires callback for sorting
			var indices:Array/*int*/ = [];
			if (strong === weak) return;
			for (o in strong) indices.push(temp[o] = strong[o]);
			for (o in weak) indices.push(temp[o] = weak[o]);
			indices.sort();
			len = indices.length;
			for (i = 0; i < len; i++)
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
		
		/**
		 * Filters and returns the references to all the registered slots.
		 * 
		 * @param	type	The signal type to filter. If none given, all types
		 * will be considered.
		 * @default <code>null</code>
		 * 
		 * @param	weak	If <code>true</code>, will include all slots added 
		 * with <code>weak</code> parameter being <code>true</code>.
		 * @default	<code>false</code>.
		 * 
		 * @param	strong	If <code>true</code>, will include all slots added 
		 * with <code>weak</code> parameter being <code>false</code>.
		 * @default	<code>true</code>.
		 * 
		 * @return	The dictionary containing references to all the slots 
		 * of the following structure:
		 * <pre>
		 * { Vector.<Class> =>
		 * 		{ Dictionary 
		 * 			{ Key = Slot0, Value = Priority }
		 * 			{ Key = Slot1, Value = Priority }
		 * 			. . .
		 * 			{ Key = SlotN, Value = Priority }
		 * 		},
		 *   Vector.<Class> =>
		 * 		{ Dictionary 
		 * 			{ Key = Slot0, Value = Priority }
		 * 			{ Key = Slot1, Value = Priority }
		 * 			. . .
		 * 			{ Key = SlotN, Value = Priority }
		 * 		}
		 * }</pre>
		 */
		public function all(type:Vector.<Class> = null, 
			weak:Boolean = false, strong:Boolean = true):Dictionary
		{
			var d:Dictionary;
			var td:Dictionary;
			var o:Object;
			var to:Object;
			
			// TODO: the returned dictionary isn't formatted correctly.
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
		
		/**
		 * Returns <code>true</code> if the slot was registered with this <code>Signals</code>
		 * applying filtering based on other parameters provided.
		 * 
		 * @param	slot	The handler to search for.
		 * 
		 * @param	type	The signal type to filter on. If none specified, all types
		 * are considered.
		 * @default	<code>null</code>.
		 * 
		 * @param	weak	If <code>true</code> will look into slots previously added
		 * using <code>weak = true</code>.
		 * @default	<code>true</code>.
		 * 
		 * @param	strong	If <code>true</code> will look into slots previously added
		 * using <code>weak = false</code>.
		 * @default	<code>true</code>.
		 * 
		 * @return	<code>true</code> if the slot was registered.
		 */
		public function has(slot:Function, type:Vector.<Class> = null,
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