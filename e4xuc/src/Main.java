import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.ListIterator;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.apache.commons.collections.primitives.IntIterator;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class Main extends DefaultHandler
{
	public enum ARGUMENTS
	{
		SOURCE, OUTPUT_DIR, ONLY_BUILD, EMPTY;
	}

	public static File	sourcePath	= new File("ASProject/src/Main.mxml");
	public static File	outputDir		= new File("ASProject/bin");

	public static void main(String[] args) throws Exception
	{
		ArrayList<String> arguments = new ArrayList<String>(Arrays.asList(args));
		SAXParserFactory spf = SAXParserFactory.newInstance();
		spf.setNamespaceAware(true);
		SAXParser sp = spf.newSAXParser();

		for (ListIterator<String> iter = arguments.listIterator(); iter.hasNext();)
		{
			String QName = getArgsQName(iter);
			try
			{
				switch (ARGUMENTS.valueOf(QName.toUpperCase().replace('-', '_')))
				{
					case SOURCE:
						sourcePath = new File(getArgsRValue(iter));
						break;
					case OUTPUT_DIR:
						outputDir = new File(getArgsRValue(iter));
						break;
					case ONLY_BUILD:
						System.out.println("Only Build");
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
			sp.parse(sourcePath, new ClassBuilder(sourcePath));
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
		String[] equalParts = ((String) i.previous()).split("\\=", 2);
		i.next();
		if (equalParts.length == 1 && !i.hasNext()) { throw new IllegalArgumentException("where is value for \"" + getArgsQName(equalParts[0]) + "\"?\n"); }

		String value = equalParts.length == 1 ? i.next() : equalParts[1];

		if (value.startsWith("-")) { throw new IllegalArgumentException("where is value for \"" + getArgsQName(equalParts[0]) + "\"?\n"); }
		return value;
	}
}