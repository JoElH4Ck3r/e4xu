import java.io.File;
import java.io.FileInputStream;
import java.util.Arrays;
import java.util.Hashtable;

import com.sun.xml.internal.ws.util.StringUtils;

public class CompilerConfiguration
{
	public final String									libRootPath				= System.getProperty("java.class.path").split(File.pathSeparator, 2)[0].split("\\" + File.separatorChar + "nfx\\.jar")[0];
	public File													sourceFile				= new File("ASProject/src/Main.mxml");
	public File													outputFile				= new File("ASProject/bin/Main.swf");
	public File													playerGlobalPath	= new File(libRootPath + "/../frameworks/libs/player/10/playerglobal.swc");
	public Namespace										defaultNamespace	= new Namespace("http://e4xu.googlecode.com/mxml");
	public Hashtable<String, String[]>	namespaces				= new Hashtable<String, String[]>() {
																													{
																														put("http://e4xu.googlecode.com/mxml", new String[] { "Object", "Array", "flash.text.TextField" });
																													}
																												};

	public String[]											metadata					= new String[] { "Bindable", "Managed", "ChangeEvent", "NonCommittingChangeEvent", "Transient" };
}