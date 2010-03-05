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
		
		try
		{
			File src = new File("ASProject/src/Main.mxml");
			sp.parse(src, new ClassBuilder(src));
		} catch (SAXException e)
		{
			System.out.print(e.getMessage());
		}
	}
}