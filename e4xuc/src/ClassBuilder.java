import java.io.File;
import java.util.ArrayList;
import java.util.Hashtable;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import flex2.tools.oem.Application;

import uk.co.badgersinfoil.metaas.ActionScriptFactory;
import uk.co.badgersinfoil.metaas.ActionScriptProject;
import uk.co.badgersinfoil.metaas.dom.ASArrayLiteral;
import uk.co.badgersinfoil.metaas.dom.ASAssignmentExpression;
import uk.co.badgersinfoil.metaas.dom.ASClassType;
import uk.co.badgersinfoil.metaas.dom.ASCompilationUnit;
import uk.co.badgersinfoil.metaas.dom.ASField;
import uk.co.badgersinfoil.metaas.dom.ASMethod;
import uk.co.badgersinfoil.metaas.dom.ASObjectLiteral;
import uk.co.badgersinfoil.metaas.dom.Expression;
import uk.co.badgersinfoil.metaas.dom.Visibility;

public class ClassBuilder extends DefaultHandler
{
	public ActionScriptFactory						fact;
	public ActionScriptProject						proj;
	public ASCompilationUnit							unit;
	public ASClassType										clazz;
	public int														depth			= 0;

	protected Hashtable<String, Integer>	nameCache	= new Hashtable<String, Integer>();

	public void startDocument()
	{
		fact = new ActionScriptFactory();
		proj = fact.newEmptyASProject("./ASProject/src");
	}

	public void startElement(String namespaceURI, String localName, String rawName, Attributes attrs)
	{
		if (depth == 0)
		{
			unit = proj.newClass("Main");

			clazz = (ASClassType) unit.getType();

			clazz.setSuperclass(localName);

			ASMethod constructor = clazz.newMethod("Main", Visibility.PUBLIC, null);

			constructor.newSuper(new ArrayList<String>());

			if (attrs != null)
			{
				int len = attrs.getLength();
				for (int i = 0; i < len; i++)
				{
					constructor.newExprStmt(fact.newAssignExpression(fact.newFieldAccessExpression(fact
							.newExpression("this"), attrs.getQName(i)), fact.newExpression(attrs.getValue(i))));
				}
			}
		} else
		{
			addName(localName);
			ASField field = clazz.newField(attrs.getValue("id") == null ? localName
					+ nameCache.get(localName) : attrs.getValue("id"), Visibility.PROTECTED, localName);

			if (localName == "Object")
			{
				field.setInitializer(generateObjectInitializer(attrs));
			} else if (localName == "Array")
			{
				field.setInitializer(generateArrayInitializer(attrs));
			} else
			{
				field.setInitializer(generateInitializer(localName, attrs));
			}

		}

		if (namespaceURI != "*") unit.getPackage().addImport(namespaceURI);

		depth++;
	}

	protected Expression generateInitializer(String localName, Attributes attrs)
	{
		ArrayList<Expression> constructorParams = new ArrayList<Expression>();
		if (attrs.getValue("new") != null)
		{
			for (String param : attrs.getValue("new").split(","))
			{
				constructorParams.add(fact.newExpression(param));
			}
		}

		return fact
				.newNewExpression(fact.newExpression(localName), attrs.getValue("new") != null ? constructorParams
						: null);
	}

	protected Expression generateObjectInitializer(Attributes attrs)
	{
		ASObjectLiteral obj = fact.newObjectLiteral();
		for (int i = 0; i < attrs.getLength(); i++)
		{
			obj.newField(attrs.getQName(i), fact.newExpression(attrs.getValue(i)));
		}
		return obj;
	}

	protected Expression generateArrayInitializer(Attributes attrs)
	{
		ASArrayLiteral arr = fact.newArrayLiteral();

		if (attrs.getValue("new") != null)
		{
			for (String param : attrs.getValue("new").split(","))
			{
				arr.add(fact.newExpression(param));
			}
		}

		return arr;
	}

	protected void addName(String type)
	{
		nameCache.put(type, nameCache.get(type) == null ? 0 : nameCache.get(type) + 1);
	}

	public void endElement(String namespaceURI, String localName, String rawName)
	{
		depth--;
	}

	public void endDocument()
	{
		try
		{
			proj.writeAll();
			Application app = new Application(new File("./ASProject/src/Main.as"));
			app.setOutput(new File("./ASProject/bin/Main.swf"));
			app.build(true);
		} catch (Exception e)
		{
			System.out.print(e.getMessage());
		}
	}
}
