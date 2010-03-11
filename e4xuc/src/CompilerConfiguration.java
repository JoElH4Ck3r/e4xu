import java.io.File;
import java.util.Hashtable;

public class CompilerConfiguration
{
	public final String									libRootPath				= System.getProperty("java.class.path").split(File.pathSeparator, 2)[0].split("\\" + File.separatorChar + "nfx\\.jar")[0];
	public File													sourceFile				= new File("ASProject/src/Main.nxml");
	public File													playerGlobalPath	= new File(libRootPath + "/../frameworks/libs/player/10/playerglobal.swc");
	public Namespace										defaultNamespace	= new Namespace("http://e4xu.googlecode.com/mxml");
	public Namespace										eventsNamespace		= new Namespace("http://e4xu.googlecode.com/mxml/events");
	public Hashtable<String, String[]>	namespaces				= new Hashtable<String, String[]>() {
																													{
																														put("http://e4xu.googlecode.com/mxml", new String[] { "Object", "Array", "flash.text.TextField" });
																													}
																												};

	public String[]											metadata					= new String[] { "Bindable", "Managed", "ChangeEvent", "NonCommittingChangeEvent", "Transient" };
}