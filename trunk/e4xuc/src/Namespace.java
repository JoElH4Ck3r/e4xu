import uk.co.badgersinfoil.metaas.impl.ASQName;

public class Namespace
{
	protected Boolean	isURI	= false;
	protected String	uri;
	public String			packageName;

	public Boolean getIsURI()
	{
		return isURI;
	}

	public Namespace(String value)
	{
		if (value.startsWith("http://"))
		{
			isURI = true;
			uri = value;
		}
		else if (value.endsWith("*"))
		{
			packageName = value;
		}
		else
		{
			Main.error(4, "namespace must be URI or flash package, not: \"" + value + "\"");
		}
	}

	public String valueOf()
	{
		return packageName;
	}

	public String getQName(String name)
	{
		String namespace;

		if (isURI)
		{
			String[] namespaces = Main.conf.namespaces.get(uri);

			for (int i = 0; i < namespaces.length; i++)
			{
				namespace = namespaces[i];
				if (namespace.endsWith("." + name) || namespace.equals(name)) { return namespace; }
			}
			
			Main.error(4, "component \"" + name + "\" doesn't exist in namespace : " + uri);
		}
		else
		{
			ASQName qName = new ASQName(packageName);
			qName.setLocalName(name);
			return qName.toString();
		}

		return null;
	}

}
