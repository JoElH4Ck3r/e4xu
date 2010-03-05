import java.io.File;

import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class Main extends DefaultHandler
{
	public static void main(String[] args) throws Exception
	{
		SAXParserFactory spf = SAXParserFactory.newInstance();
		spf.setNamespaceAware(true);
		SAXParser sp = spf.newSAXParser();
		String sourcePath = "ASProject/src/Main.mxml";
		
		System.out.print("args.length " + args.length);
		
		switch (args.length)
		{
			case 0:
				break;
			case 1:
				sourcePath = args[0];
				if (sourcePath.indexOf((int)'=') > -1)
				{
					String[] parts = sourcePath.split("\\=");
					System.out.print("has = " + (parts[0] == "-source") + " " + parts[0]);
					if (parts[0].equals("-source"))
						sourcePath = parts[1];
				}
				break;
			case 2:
				if (args[0] == "-source")
					sourcePath = args[1];
				break;
		}
		try
		{
			File src = new File(sourcePath);
			sp.parse(src, new ClassBuilder(src));
		} catch (SAXException e)
		{
			System.out.print(e.getMessage());
		}
	}
}