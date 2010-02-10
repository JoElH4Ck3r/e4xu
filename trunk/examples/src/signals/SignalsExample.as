package signals 
{
	//{ imports
	import flash.display.Sprite;
	import org.wvxvws.signals.ISemaphore;
	import org.wvxvws.signals.SignalError;
	import org.wvxvws.signals.Signals;
	import org.wvxvws.signals.SignalType;
	//}
	
	/**
	 * TestAsteriscNamespace class.
	 * @author wvxvw
	 * @langVersion 3.0
	 * @playerVersion 10.0.32
	 */
	public class SignalsExample extends Sprite implements ISemaphore
	{
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		public function get signals():Signals { return this._signals; }
		
		//--------------------------------------------------------------------------
		//
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _signals:Signals;
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private const SIGNAL_TYPES:Vector.<SignalType> = 
			new <SignalType>[TestGignalType.FOO, TestGignalType.BAR];
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SignalsExample() 
		{
			super();
			this._signals = new Signals(this);
			this._signals.add(TestGignalType.FOO, this.slotTest);
			this._signals.add(TestGignalType.FOO, this.slotTest2);
			this._signals.add(TestGignalType.BAR, this.slotTest);
			this._signals.call(TestGignalType.FOO, "Foo", 100);
			try
			{
				this._signals.call(TestGignalType.BAR, "Foo", 100);
			}
			catch (error:SignalError)
			{
				// Attempting to call slot with wrong signature.
				trace(error.message);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.signals.ISemaphore */
		
		public function signalTypes():Vector.<SignalType>
		{
			return SIGNAL_TYPES;
		}
		
		private function slotTest(par0:String, par1:int):void
		{
			trace("slotTest called", par0, par1);
		}
		
		private function slotTest2(par0:String, par1:int):void
		{
			trace("slotTest2 called", par0, par1);
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
	}
}
import org.wvxvws.signals.SignalType;
internal final class TestGignalType extends SignalType
{
	public static const FOO:TestGignalType = 
		new TestGignalType(0, new <Class>[String, int]);
	public static const BAR:TestGignalType = 
		new TestGignalType(1, new <Class>[int, String]);
	
	public function TestGignalType(kind:int, types:Vector.<Class>)
	{
		super(kind, types);
	}
}