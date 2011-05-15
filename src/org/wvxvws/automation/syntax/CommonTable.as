package org.wvxvws.automation.syntax
{
	public class CommonTable extends StandardTable
	{
		public function CommonTable()
		{
			super();
			this.x2E = CommonHandlers.dotHandler;
			this.registerMacroCharacter(CommonHandlers.escapeHandler, "#", "\\");
			this.registerMacroCharacter(CommonHandlers.multyEscapeHandler, "#", "|");
			this.registerMacroCharacter(CommonHandlers.parenHandler, "#", "(");
			this.registerMacroCharacter(CommonHandlers.xHandler, "#", "x");
		}
	}
}