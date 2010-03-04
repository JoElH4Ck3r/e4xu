import uk.co.badgersinfoil.metaas.ActionScriptFactory;
import uk.co.badgersinfoil.metaas.ActionScriptProject;
import uk.co.badgersinfoil.metaas.dom.ASClassType;
import uk.co.badgersinfoil.metaas.dom.ASCompilationUnit;
import uk.co.badgersinfoil.metaas.dom.ASField;
import uk.co.badgersinfoil.metaas.dom.ASMethod;
import uk.co.badgersinfoil.metaas.dom.Visibility;


public class Main
{
	public static void main(String[] args) throws Exception
	{
		ActionScriptFactory fact = new ActionScriptFactory();
		ActionScriptProject proj = fact.newEmptyASProject("./generatedAS");
		ASCompilationUnit unit = proj.newClass("TestClass");
		
		ASClassType clazz = (ASClassType) unit.getType();
		
		clazz.setSuperclass("flash.display.Sprite");
		
		ASField testVar = clazz.newField("testVar", Visibility.PROTECTED, "flash.display.Sprite");
		testVar.setInitializer("new Sprite()");
		
		
		ASMethod meth = clazz.newMethod(clazz.getName(), Visibility.PUBLIC, null);
		meth.addStmt("trace('yo!')");

		proj.performAutoImport();
		proj.writeAll();

	}

}
