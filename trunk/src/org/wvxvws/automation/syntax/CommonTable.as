package org.wvxvws.automation.syntax
{
	public class CommonTable extends StandardTable
	{
		public function CommonTable()
		{
			super();
			this.x2E = CommonHandlers.dotHandler;
			this.registerMacroCharacter(CommonHandlers.escapeHandler, "#", "\\");
			this.registerMacroCharacter(CommonHandlers.multiEscapeHandler, "#", "|");
			this.registerMacroCharacter(CommonHandlers.parenHandler, "#", "(");
			this.registerMacroCharacter(CommonHandlers.xHandler, "#", "x");
			this.registerMacroCharacter(CommonHandlers.asteriskHandler, "#", "*");
		}
	}
}