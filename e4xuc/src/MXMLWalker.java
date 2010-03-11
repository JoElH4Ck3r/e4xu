import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Hashtable;

import org.xml.sax.Attributes;
import org.xml.sax.helpers.DefaultHandler;

import uk.co.badgersinfoil.metaas.ActionScriptFactory;
import uk.co.badgersinfoil.metaas.ActionScriptParser;
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
import uk.co.badgersinfoil.metaas.impl.ASQName;

public class MXMLWalker extends DefaultHandler
{
	public ActionScriptFactory						fact;
	public ActionScriptProject						proj;
	public ASCompilationUnit							unit;
	public ASClassType										clazz;
	public int														depth			= 0;
	public String													className;

	protected Hashtable<String, Integer>	nameCache	= new Hashtable<String, Integer>();

	public void startDocument()
	{
		className = Main.conf.sourcePath.getName().substring(0, Main.conf.sourcePath.getName().lastIndexOf("."));
		fact = new ActionScriptFactory();
		proj = fact.newEmptyASProject(Main.conf.sourcePath.getParent());
		//proj.addClasspathEntry(Main.conf.playerGlobalPath.getAbsolutePath());
	}

	public void startElement(String namespaceURI, String localName, String rawName, Attributes attrs)
	{
		ASQName qName = new ASQName(new Namespace(namespaceURI.length() == 0 ? "*" : namespaceURI).getQName(localName));
		String typeName = qName.getLocalName();
		String packageName = qName.getPackagePrefix();

		if (depth == 0)
		{
			unit = proj.newClass(className);

			clazz = (ASClassType) unit.getType();
			clazz.setSuperclass(qName.toString());

			ASMethod constructor = clazz.newMethod(className, Visibility.PUBLIC, null);
			constructor.newSuper(new ArrayList<String>());

			if (attrs != null)
			{
				int len = attrs.getLength();
				for (int i = 0; i < len; i++)
				{
					if (attrs.getURI(i) != namespaceURI && attrs.getURI(i).length() > 0)
						continue;
					constructor.newExprStmt(fact.newAssignExpression(fact.newFieldAccessExpression(fact.newExpression("this"), attrs.getLocalName(i)), fact.newExpression(attrs.getValue(i))));
				}
			}
		}
		else
		{
			addName(typeName);
			ASField field = clazz.newField(attrs.getValue("id") == null ? typeName.substring(0, 1).toLowerCase() + typeName.substring(1) + nameCache.get(typeName) : attrs.getValue("id"), Visibility.PROTECTED, typeName);

			if (typeName.equals("Object"))
			{
				field.setInitializer(generateObjectInitializer(typeName, attrs));
			}
			else if (typeName.equals("Array"))
			{
				field.setInitializer(generateArrayInitializer(typeName, attrs));
			}
			else
			{
				field.setInitializer(generateInitializer(typeName, attrs));
			}

		}

		if (packageName != null && !unit.getPackage().findImports().contains(packageName + ".*"))
		{
			unit.getPackage().addImport(packageName + ".*");
		}
		depth++;
	}

	protected Expression generateInitializer(String localName, Attributes attrs)
	{
		ArrayList<Expression> constructorParams = new ArrayList<Expression>();
		if (attrs.getValue(Main.conf.defaultNamespace.uri, "new") != null && attrs.getValue(Main.conf.defaultNamespace.uri, "new").length() > 0)
		{
			for (String param : attrs.getValue(Main.conf.defaultNamespace.uri, "new").split(","))
			{
				constructorParams.add(fact.newExpression(param.trim()));
			}
		}

		ASNewExpression newExp = fact.newNewExpression(fact.newExpression(localName), null);
		newExp.setArguments(constructorParams);

		return newExp;
	}

	protected Expression generateObjectInitializer(String localName, Attributes attrs)
	{
		ASObjectLiteral obj = fact.newObjectLiteral();

		for (int i = 0; i < attrs.getLength(); i++)
		{
			obj.newField(attrs.getQName(i), fact.newExpression(attrs.getValue(i).trim()));
		}

		return obj;
	}

	protected Expression generateArrayInitializer(String localName, Attributes attrs)
	{
		ASArrayLiteral arr = fact.newArrayLiteral();

		if (attrs.getValue(Main.conf.defaultNamespace.uri, "new") != null && attrs.getValue(Main.conf.defaultNamespace.uri, "new").length() > 0)
		{
			for (String param : attrs.getValue(Main.conf.defaultNamespace.uri, "new").split(","))
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

	protected void intrinsicScan(File folder) throws Exception
	{
		String[] intrinsicClasses = folder.list();

		for (int i = 0; i < intrinsicClasses.length; i++)
		{
			File pathItem = new File(folder.getAbsolutePath() + "/" + intrinsicClasses[i]);

			if (pathItem.isFile())
			{
				try
				{
					System.out.println(pathItem.getAbsolutePath());
					ActionScriptParser parser = fact.newParser();
					ASCompilationUnit unit = parser.parse(new FileReader(pathItem.getAbsolutePath()));
					proj.addCompilationUnit(unit);

				} catch (Exception e)
				{
					Main.error(4, "Something wrong!\n" + e.getMessage());
				}
			}
			else if (pathItem.isDirectory())
			{
				intrinsicScan(pathItem);
			}
		}
	}

	public void endDocument()
	{
		try
		{
			// intrinsicScan(new File("frameworks/intrinsic/FP10"));

			proj.performAutoImport();
			proj.writeAll();
		} catch (Exception e)
		{
			Main.error(4, e.getMessage());
		}
	}
}
