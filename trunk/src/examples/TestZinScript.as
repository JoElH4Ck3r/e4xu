package examples
{
	import flash.display.Sprite;
	
	import org.wvxvws.automation.ParensParser;
	
	public class TestZinScript extends Sprite
	{
		private var _parser:ParensParser = new ParensParser();
		
		public function TestZinScript()
		{
			super();
			this.test();
		}
		
		private function test():void
		{
			// Makes all public methods accessible by names so
			// we don't need to user utils:slot-value all the time.
			this._parser.pushContext(this, "test-runner");
			this._parser.read(
<![CDATA[
				(test-runner:testMethod)
				(test-runner:testMethodWithParameters 100 "Hello from outer space")
				
				(utils:print "Running ZinScript, highly experimental version...")
				
				(lang:defvar "test-var" 42)
				
				(utils:dotimes (math:- 2 1) 
					(lang:getvar "time:interval") ; This is not ideal, will need to pass a list instead
					(lang:getvar "test-runner:testMethodWithParameters") 1000 
						(lang:setvar "test-var" (math:++ (lang:getvar "test-var"))) "Hello...")
				
				(utils:dotimes (math:+ 0 2 -10 9) 
					(lang:getvar "time:timeout") ; Just same as above, need body form for loops and functions
					(lang:getvar "test-runner:testMethod") 1000 5)
				
				(bool:if (math:> (math:random 10) 5)
					(utils:print "Executing true condition")
					(utils:print "Executing false condition"))
				
				; This is line comment
				
				(utils:print (string:+ "foo" "|" "bar"))
				
				(lang:defun "test-function" (lang:arguments "param1" "param2")
					(lang:body-form '(utils:print param1)
						'(utils:print param2)))
				
				(utils:print (lang:getvar "test-function"))
				
				(test-function "hello" "world")
				
				(lang:defpackage "tests")
				(lang:inpackage "tests")
				(lang:defvar "test-sprite" (lang:new (utils:resolve-class "flash.display.Sprite")))
				(lang:defvar "graphics" (utils:slot-value (lang:getvar "test-sprite") "graphics"))
				(utils:funcall (utils:slot-value (lang:getvar "graphics") "beginFill") 255)
				(utils:funcall (utils:slot-value (lang:getvar "graphics") "drawRect") 0 0 100 200)
				(utils:funcall (utils:slot-value (lang:getvar "graphics") "endFill"))
				(test-runner:addChild (lang:getvar "test-sprite"))
				(utils:print "debugging..." (lang:package) (utils:slot-value (lang:package) "name"))
				(utils:print "moar..." (lang:getvar "test-sprite") (lang:getvar "tests:test-sprite"))
				(lang:extern "test-sprite")
				
				(lang:defun "test-handler" (lang:arguments "event")
					(lang:body-form '(utils:print "I am an enterFrame handler" event)
						'(utils:set-slot (lang:getvar "tests:test-sprite") "x" 
							(math:++ (utils:slot-value (lang:getvar "tests:test-sprite") "x")))))
				(test-runner:addEventListener "enterFrame" (lang:getvar "test-handler"))
]]>.toString());
		}
		
		public function testMethod():void
		{
			trace("I am testMethod");
		}
		
		public function testMethodWithParameters(foo:int, bar:String):void
		{
			trace("I am testMethodWithParameters", foo, bar);
		}
	}
}