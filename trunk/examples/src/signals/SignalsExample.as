package tests 
{
	//{ imports
	import flash.display.Sprite;
	import org.wvxvws.signals.ISemaphore;
	import org.wvxvws.signals.Signals;
	import org.wvxvws.signals.SygnalType;
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
		//  Protected properties
		//
		//--------------------------------------------------------------------------
		
		protected var _signals:Signals;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SignalsExample() 
		{
			super();
			this._signals = new Signals(this);
			this._signals.add(TestGignalType.FOO, slotTest, -1, new <Class>[String, int]);
			this._signals.call(TestGignalType.FOO, "Foo", 100);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/* INTERFACE org.wvxvws.signals.ISemaphore */
		
		public function signalTypes():Vector.<SygnalType>
		{
			return new <SygnalType>[TestGignalType.FOO];
		}
		
		public function callbackSignature(type:SygnalType):Vector.<Class>
		{
			switch (type)
			{
				case TestGignalType.FOO:
					return new <Class>[String, int];
			}
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function slotTest(par0:String, par1:int):void
		{
			trace("slotTest called", par0, par1);
		}
	}
}
import org.wvxvws.signals.SygnalType;
internal final class TestGignalType extends SygnalType
{
	public static const FOO:TestGignalType = new TestGignalType();
	public function TestGignalType() { super(0); }
}