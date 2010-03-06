import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.ListIterator;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class Main extends DefaultHandler
{
	public enum ARGUMENTS
	{
		SOURCE, OUTPUT, ONLY_BUILD, EMPTY;
	}
	
	public static CompilerConfiguration conf = new CompilerConfiguration();

	public static void main(String[] args) throws Exception
	{
		ArrayList<String> arguments = new ArrayList<String>(Arrays.asList(args));
		for (ListIterator<String> iter = arguments.listIterator(); iter.hasNext();)
		{
			String QName = getArgsQName(iter);
			try
			{
				switch (ARGUMENTS.valueOf(QName.toUpperCase().replace('-', '_')))
				{
					case SOURCE:
						conf.sourcePath = new File(getArgsRValue(iter));
						if(!conf.sourcePath.exists())
						{
							System.err.println("Source file doesn't exist!");
							System.exit(4);
						}
						break;
					case OUTPUT:
						conf.outputFile = new File(getArgsRValue(iter));
						if(!conf.outputFile.exists())
						{
							System.err.println("Output file doesn't exist!");
							System.exit(4);
						}
						break;
					case ONLY_BUILD:
						conf.buildOnly = true;
						break;
				}
			} catch (IllegalArgumentException e)
			{
				System.err.println(e.getMessage());
				System.exit(4);
			}
		}
		try
		{
			SAXParserFactory spf = SAXParserFactory.newInstance();
			spf.setNamespaceAware(true);
			SAXParser sp = spf.newSAXParser();
			sp.parse(conf.sourcePath, new ClassBuilder());
		} catch (SAXException e)
		{
			System.out.print(e.getMessage());
		}
	}

	public static String getArgsQName(ListIterator<String> i)
	{
		return getArgsQName(i.next());
	}

	public static String getArgsQName(String value)
	{
		return value.substring(1).split("\\=", 2)[0].trim();
	}

	public static String getArgsRValue(ListIterator<String> i)
	{
		String value;
		String[] equalParts = ((String) i.previous()).split("\\=", 2);
		i.next();

		if (equalParts.length == 2)
		{
			value = equalParts[1];
		}
		else
		{
			if (!i.hasNext()) { throw new IllegalArgumentException("where is value for \"" + getArgsQName(equalParts[0]) + "\"?\n"); }
			value = i.next();
			if (value.startsWith("-")) { throw new IllegalArgumentException("where is value for \"" + getArgsQName(equalParts[0]) + "\"?!\n"); }
		}

		return value;
	}
}