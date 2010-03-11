import java.beans.Statement;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.ListIterator;

import org.antlr.runtime.tree.Tree;
import org.asdt.core.internal.antlr.AS3Lexer;
import org.asdt.core.internal.antlr.AS3Parser;
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
import uk.co.badgersinfoil.metaas.dom.ASPackage;
import uk.co.badgersinfoil.metaas.dom.ASType;
import uk.co.badgersinfoil.metaas.dom.DocComment;
import uk.co.badgersinfoil.metaas.dom.Expression;
import uk.co.badgersinfoil.metaas.dom.Visibility;
import uk.co.badgersinfoil.metaas.impl.AS3FragmentParser;
import uk.co.badgersinfoil.metaas.impl.ASQName;
import uk.co.badgersinfoil.metaas.impl.ASTASClassType;
import uk.co.badgersinfoil.metaas.impl.ASTASExpressionStatement;
import uk.co.badgersinfoil.metaas.impl.ASTASField;
import uk.co.badgersinfoil.metaas.impl.ASTASMember;
import uk.co.badgersinfoil.metaas.impl.ASTASMethod;
import uk.co.badgersinfoil.metaas.impl.ASTBuilder;
import uk.co.badgersinfoil.metaas.impl.ASTScriptElement;
import uk.co.badgersinfoil.metaas.impl.ASTUtils;
import uk.co.badgersinfoil.metaas.impl.DocCommentUtils;
import uk.co.badgersinfoil.metaas.impl.ExpressionBuilder;
import uk.co.badgersinfoil.metaas.impl.TokenBuilder;
import uk.co.badgersinfoil.metaas.impl.antlr.LinkedListToken;
import uk.co.badgersinfoil.metaas.impl.antlr.LinkedListTree;

public class MXMLWalker extends DefaultHandler
{
	public ActionScriptFactory						fact;
	public ActionScriptProject						proj;
	public ASCompilationUnit							unit;
	public ASTASClassType									clazz;
	public int														depth			= 0;
	public String													className;

	protected Hashtable<String, Integer>	nameCache	= new Hashtable<String, Integer>();

	public void startDocument()
	{
		className = Main.conf.sourceFile.getName().substring(0, Main.conf.sourceFile.getName().lastIndexOf("."));
		fact = new ActionScriptFactory();
		proj = fact.newEmptyASProject(Main.conf.sourceFile.getParent());
		proj.addClasspathEntry(Main.conf.playerGlobalPath.getAbsolutePath());
		try
		{
			unit = fact.newParser().parse(new InputStreamReader(new FileInputStream(Main.conf.sourceFile.getAbsolutePath().substring(0, Main.conf.sourceFile.getAbsolutePath().lastIndexOf(".")) + ".as")));
			proj.addCompilationUnit(unit);
			ASPackage pkg = unit.getPackage();
			ASClassType type = (ASClassType) pkg.getType();
			for (ListIterator<ASTASMethod> i = type.getMethods().listIterator(); i.hasNext();)
			{
				ASTASMethod meth = i.next();
				if (meth.getDocComment() != null && meth.getDocComment().equals("@Generated"))
				{
					LinkedListToken docComentToken = DocCommentUtils.findDocCommentToken(meth.getAST());
					docComentToken.getPrev().delete();
					docComentToken.getPrev().delete();
					docComentToken.getNext().delete();
					docComentToken.getNext().delete();
					docComentToken.delete();
					type.removeMethod(meth.getName());
				}
			}

			for (ListIterator<ASTASField> i = type.getFields().listIterator(); i.hasNext();)
			{
				ASTASField field = i.next();
				if (field.getDocComment() != null && field.getDocComment().equals("@Generated"))
				{
					LinkedListToken docComentToken = DocCommentUtils.findDocCommentToken(field.getAST());
					docComentToken.getPrev().delete();
					docComentToken.getPrev().delete();
					docComentToken.getNext().delete();
					docComentToken.getNext().delete();
					docComentToken.delete();
					type.removeField(field.getName());
				}
			}

			if (type.getMethod(className) == null)
			{
				ASMethod constructor = type.newMethod(className, Visibility.PUBLIC, null);
				constructor.newExprStmt("init()");
			}
			else
			{
				Boolean founded = false;
				for (ListIterator<ASTASExpressionStatement> i = type.getMethod(className).getStatementList().listIterator(); i.hasNext();)
				{
					if (i.next().getExpressionString().equals("init()"))
					{
						founded = true;
						break;
					}
				}
				if (!founded)
				{
					type.getMethod(className).newExprStmt("init()");
				}
			}

		} catch (FileNotFoundException e)
		{
			unit = proj.newClass(className);
			ASTASMethod constructor = (ASTASMethod) unit.getType().newMethod(className, Visibility.PUBLIC, null);
			constructor.newExprStmt("init()");
		}
	}

	public void startElement(String namespaceURI, String localName, String rawName, Attributes attrs)
	{
		ASQName qName = new ASQName(new Namespace(namespaceURI.length() == 0 ? "*" : namespaceURI).getQName(localName));
		String typeName = qName.getLocalName();
		String packageName = qName.getPackagePrefix();

		if (depth == 0)
		{
			clazz = (ASTASClassType) unit.getType();
			clazz.setSuperclass(qName.toString());

			ASMethod initializer = clazz.newMethod("init", Visibility.PROTECTED, "void");
			initializer.setDocComment("@Generated");

			if (attrs != null)
			{
				int len = attrs.getLength();
				for (int i = 0; i < len; i++)
				{
					String paramLName = attrs.getLocalName(i);
					String value = attrs.getValue(i);
					String paramNamespace = attrs.getURI(i);
					if (paramNamespace == Main.conf.eventsNamespace.uri)
					{
						ArrayList<Expression> addEventListenerParams = new ArrayList<Expression>();
						if (value.startsWith("@Handler"))
						{

							String[] options = value.substring(value.indexOf('(') + 1, value.length() - 1).split("\\,");

							addEventListenerParams.add(fact.newStringLiteral(paramLName));

							for (int j = 0; j < options.length; j++)
							{
								addEventListenerParams.add(fact.newExpression(options[j].trim()));
							}
							initializer.newExprStmt(fact.newInvocationExpression(fact.newExpression("addEventListener"), addEventListenerParams));
						}
						else
						{
							ASTASMethod handler = (ASTASMethod) clazz.newMethod(paramLName + "_" + typeName + "Handler", Visibility.PROTECTED, "void");
							handler.setDocComment("@Generated");
							handler.addParam("event", "flash.events.Event");
							handler.newExprStmt(ExpressionBuilder.build(ASTUtils.newAST(AS3Parser.METHOD_CALL, value)));

							initializer.newExprStmt(fact.newInvocationExpression(fact.newExpression("addEventListener"), Arrays.asList(new Expression[] { fact.newStringLiteral(paramLName), fact.newExpression(handler.getName()) })));
						}
					}
					else if (paramNamespace == namespaceURI || paramNamespace.length() == 0)
					{
						initializer.newExprStmt(fact.newAssignExpression(fact.newFieldAccessExpression(fact.newExpression("this"), paramLName), fact.newExpression(value)));
					}
				}
			}
		}
		else
		{
			addName(typeName);
			ASField field = clazz.newField(attrs.getValue("id") == null ? typeName.substring(0, 1).toLowerCase() + typeName.substring(1) + nameCache.get(typeName) : attrs.getValue("id"), Visibility.PROTECTED, typeName);
			field.setDocComment("@Generated");
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
