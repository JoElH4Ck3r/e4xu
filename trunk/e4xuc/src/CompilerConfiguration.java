import java.io.File;
import java.util.Hashtable;

public class CompilerConfiguration
{
	public File													sourcePath				= new File("ASProject/src/Main.mxml");
	public File													outputFile				= new File("ASProject/bin/Main.swf");
	//public File													playerGlobalPath	= new File("./../frameworks/libs/player/10/playerglobal.swc");
	public Namespace										defaultNamespace	= new Namespace("http://e4xu.googlecode.com/mxml");
	public Hashtable<String, String[]>	namespaces				= new Hashtable<String, String[]>() {
																													{
																														put("http://e4xu.googlecode.com/mxml", new String[] { "Object", "Array", "flash.text.TextField" });
																													}
																												};

	public String[]											metadata					= new String[] { "Bindable", "Managed", "ChangeEvent", "NonCommittingChangeEvent", "Transient" };
}