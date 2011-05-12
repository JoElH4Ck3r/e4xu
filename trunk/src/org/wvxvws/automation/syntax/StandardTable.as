package org.wvxvws.automation.syntax
{
	public class StandardTable extends DispatchTable
	{
		public function StandardTable()
		{
			super();
			this.x28 = StandardHandlers.openParenHandler;
			this.x29 = StandardHandlers.closingParenHandler;
			this.x22 = StandardHandlers.quoteHandler;
			this.x23 = StandardHandlers.sharpHandler;
			this.x27 = StandardHandlers.apostropheHandler;
			this.x2C = StandardHandlers.commaHandler;
			this.x3B = StandardHandlers.semicolonHandler;
		}
	}
}