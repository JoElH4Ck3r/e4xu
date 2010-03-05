import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import flex2.tools.oem.Application;
import flex2.tools.oem.Configuration;

import uk.co.badgersinfoil.metaas.ActionScriptFactory;
import uk.co.badgersinfoil.metaas.ActionScriptProject;
import uk.co.badgersinfoil.metaas.dom.ASArrayLiteral;
import uk.co.badgersinfoil.metaas.dom.ASClassType;
import uk.co.badgersinfoil.metaas.dom.ASCompilationUnit;
import uk.co.badgersinfoil.metaas.dom.ASField;
import uk.co.badgersinfoil.metaas.dom.ASMethod;
import uk.co.badgersinfoil.metaas.dom.ASNewExpression;
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
	public File														file;
	public String													className;
	public ActionScriptFactory fact;
	public ActionScriptProject proj;
	public ASCompilationUnit unit;
	public ASClassType clazz;
	public int depth = 0;
	public File file;
	public String className;
	public File directory;

	protected Hashtable<String, Integer>	nameCache	= new Hashtable<String, Integer>();

	public ClassBuilder(File file)
	{
		this.file = file;
		this.directory = new File(file.getParent());
		className = file.getName().substring(0, file.getName().lastIndexOf("."));
	}

	public void startDocument()
	{
		fact = new ActionScriptFactory();
		proj = fact.newEmptyASProject(this.directory.getAbsolutePath() + "/src");
	}

	public void startElement(String namespaceURI, String localName, String rawName, Attributes attrs)
	{
		ArrayList<String> packageParts = new ArrayList<String>(Arrays.asList(localName.split("\\.")));
		String varName = packageParts.remove(packageParts.size() - 1);
		
		namespaceURI = namespaceURI.length() > 0 ? namespaceURI : "*";

		for (String part : packageParts)
		{
			namespaceURI = namespaceURI.replace("*", part + ".*");
		}

		if (depth == 0)
		{
			unit = proj.newClass(className);
			
			clazz = (ASClassType) unit.getType();
			clazz.setSuperclass(varName);

			ASMethod constructor = clazz.newMethod(className, Visibility.PUBLIC, null);
			constructor.newSuper(new ArrayList<String>());

			if (attrs != null)
			{
				int len = attrs.getLength();
				for (int i = 0; i < len; i++)
				{
					if (attrs.getURI(i) != namespaceURI && attrs.getURI(i).length() > 0) continue;
					constructor.newExprStmt(fact.newAssignExpression(fact.newFieldAccessExpression(
							fact.newExpression("this"), attrs.getLocalName(i)),
							fact.newExpression(attrs.getValue(i))));
				}
			}
		} else
		{
			addName(localName);
			ASField field = clazz.newField(attrs.getValue("id") == null ? varName
					+ nameCache.get(localName) : attrs.getValue("id"), Visibility.PROTECTED, varName);

			if (localName.equals("Object"))
			{
				field.setInitializer(generateObjectInitializer(attrs));
			} else if (localName.equals("Array"))
			{
				field.setInitializer(generateArrayInitializer(attrs));
			} else
			{
				field.setInitializer(generateInitializer(varName, attrs));
			}

		}

		if (namespaceURI.length() > 0 && !namespaceURI.equals("*") && !unit.getPackage().findImports().contains(namespaceURI))
		{
			unit.getPackage().addImport(namespaceURI);
		}

		depth++;
	}

	protected Expression generateInitializer(String localName, Attributes attrs)
	{
		ArrayList<Expression> constructorParams = new ArrayList<Expression>();
		if (attrs.getValue("mx", "new") != null && attrs.getValue("mx", "new").length() > 0)
		{
			for (String param : attrs.getValue("mx", "new").split(","))
			{
				constructorParams.add(fact.newExpression(param.trim()));
			}
		}

		ASNewExpression newExp = fact.newNewExpression(fact.newExpression(localName), null);
		newExp.setArguments(constructorParams);

		return newExp;
	}

	protected Expression generateObjectInitializer(Attributes attrs)
	{
		ASObjectLiteral obj = fact.newObjectLiteral();
		for (int i = 0; i < attrs.getLength(); i++)
		{
			obj.newField(attrs.getQName(i), fact.newExpression(attrs.getValue(i).trim()));
		}

		return obj;
	}

	protected Expression generateArrayInitializer(Attributes attrs)
	{
		ASArrayLiteral arr = fact.newArrayLiteral();

		if (attrs.getValue("mx", "new") != null && attrs.getValue("mx", "new").length() > 0)
		{
			for (String param : attrs.getValue("mx", "new").split(","))
			{
				arr.add(fact.newExpression(param.trim()));
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
			proj.performAutoImport();
			proj.writeAll();
			Application app = new Application(this.file);
			app.setOutput(new File(this.directory.getAbsolutePath() + 
					"/bin/" + className + ".swf"));
			Configuration conf = app.getDefaultConfiguration();
			conf.setDefaultSize(400, 300);
			app.setConfiguration(conf);
			app.build(false);
		} catch (Exception e)
		{
			System.out.print(e.getMessage());
		}
	}
}
