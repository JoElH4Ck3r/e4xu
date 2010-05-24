using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Windows.Forms;
using SamHaXePanel.Resources;
using System.IO;
using PluginCore;

namespace SamHaXePanel
{
    class SamSchemaExporter
    {
        private static Dictionary<ResourceNodeType, String> resourceTemplates = 
            new Dictionary<ResourceNodeType, String>();

        private static Dictionary<ResourceNodeType, String> embedSupers;

        static SamSchemaExporter()
        {
            embedSupers = new Dictionary<ResourceNodeType, String>();
            embedSupers[ResourceNodeType.Binary] = "flash.utils.ByteArray";
            embedSupers[ResourceNodeType.Swf] = "flash.display.MovieClip";
            embedSupers[ResourceNodeType.Sound] = "flash.media.Sound";
            embedSupers[ResourceNodeType.Font] = "flash.text.Font";
            embedSupers[ResourceNodeType.Image] = "flash.display.Bitamp";
        }

        public static void ExportHaXeClasses(String file, String toFolder)
        {
            XmlDocument xml = new XmlDocument();
            try
            {
                xml.Load(file);
            }
            catch
            {
                MessageBox.Show(LocaleHelper.GetErrorString(
                    LocaleHelper.INVALID_FILE_ERROR));
                return;
            }
            XmlNode root = xml.FirstChild;
            SamSchema sch = new SamSchema();
            XmlAttribute p = root.Attributes["package"];

            if (p != null) sch.Package = p.InnerText;
            p = root.Attributes["version"];
            if (p != null) sch.Version = p.InnerText;

            XmlNodeList nodeList = root.ChildNodes;
            Int32 nodeCount = nodeList.Count;
            XmlNode currentNode;
            SamFrame fr;
            List<SamResource> resources = new List<SamResource>();

            for (Int32 i = 0; i < nodeCount; i++)
            {
                currentNode = nodeList[i];
                if (currentNode.LocalName == "frame")
                {
                    fr = new SamFrame();
                    if (currentNode.ChildNodes.Count > 0)
                    {
                        AddResources(fr, currentNode.ChildNodes, resources);
                    }
                    sch.Frames.Add(fr);
                }
            }

            ProcessTemplates(sch.Package, resources, toFolder);
        }

        private static void AddResources(ISamResources toContainer, 
            XmlNodeList fromNodes, List<SamResource> storeIn)
        {
            Int32 count = fromNodes.Count;
            XmlNode node;
            SamResource res = null;
            XmlAttribute a;
            Boolean failed = false;

            for (Int32 i = 0; i < count; i++)
            {
                node = fromNodes[i];
                switch (node.LocalName)
                {
                    case "library":
                    case "swf":
                        res = new SamResource();
                        res.ResourceType = ResourceNodeType.Swf;
                        a = node.Attributes["import"];

                        if (a != null) res.File = a.InnerText;
                        else failed = true;
                        if (!failed) res.File = a.InnerText;

                        a = node.Attributes["class"];
                        if (!failed && a != null) res.Class = a.InnerText;
                        else if (node.LocalName == "swf") failed = true;
                        break;
                    case "ttf":
                        res = new SamFont();
                        res.ResourceType = ResourceNodeType.Font;
                        a = node.Attributes["import"];

                        if (a != null) res.File = a.InnerText;
                        else failed = true;
                        if (!failed) res.File = a.InnerText;

                        a = node.Attributes["name"];
                        if (!failed && a == null) failed = true;
                        AddFontRange((SamFont)res, node.ChildNodes);
                        a = node.Attributes["class"];
                        if (a != null) res.Class = a.InnerText;
                        break;
                    case "sound":
                        res = new SamResource();
                        res.ResourceType = ResourceNodeType.Sound;
                        a = node.Attributes["import"];

                        if (a != null) res.File = a.InnerText;
                        else failed = true;
                        if (!failed) res.File = a.InnerText;

                        a = node.Attributes["class"];
                        if (!failed && a != null) res.Class = a.InnerText;
                        else failed = true;
                        break;
                    case "image":
                        res = new SamResource();
                        res.ResourceType = ResourceNodeType.Image;
                        a = node.Attributes["import"];

                        if (a != null) res.File = a.InnerText;
                        else failed = true;
                        if (!failed) res.File = a.InnerText;

                        a = node.Attributes["class"];
                        if (!failed && a != null) res.Class = a.InnerText;
                        else failed = true;
                        break;
                    case "binary":
                        res = new SamResource();
                        res.ResourceType = ResourceNodeType.Binary;
                        a = node.Attributes["import"];

                        if (a != null) res.File = a.InnerText;
                        else failed = true;
                        if (!failed) res.File = a.InnerText;

                        a = node.Attributes["class"];
                        if (!failed && a != null) res.Class = a.InnerText;
                        else failed = true;
                        break;
                    case "composite":
                        res = new SamComposite();
                        res.ResourceType = ResourceNodeType.Compose;
                        AddResources(res as ISamResources, node.ChildNodes, storeIn);
                        break;
                }
                if (failed)
                {
                    MessageBox.Show(LocaleHelper.GetErrorString(
                        LocaleHelper.INVALID_FILE_ERROR));
                    return;
                }
                toContainer.Resources.Add(res);
                if (res.ResourceType != ResourceNodeType.Compose)
                {
                    if (res.Class != null) storeIn.Add(res);
                }
            }
        }

        private static void ProcessTemplates(String package, 
            List<SamResource> resources, String inFolder)
        {
            // TODO: Move warnings into resources.
            // TODO: Put I/O in try-catch
            Int32 count = resources.Count;
            SamResource res;
            String[] parts = null;
            if (!String.IsNullOrEmpty(package))
            {
                parts = package.Split(new Char[1] { '.' });
            }
            if (Directory.Exists(inFolder))
            {
                String[] files = Directory.GetFiles(inFolder);
                String[] folders = Directory.GetDirectories(inFolder);
                if (files.Length < 1 || folders.Length < 1)
                {
                    DialogResult dr = MessageBox.Show(
                        "The folder is not empty. Would you like to proceed anyway?",
                        "Foler not empty", MessageBoxButtons.YesNo);
                    if (dr != DialogResult.Yes) return;
                }
            }
            else
            {
                DialogResult dr = MessageBox.Show(
                        "The folder doesn't exist. Would you like to create it?",
                        "Foler doesn't exist", MessageBoxButtons.YesNo);
                if (dr != DialogResult.Yes) return;
                else Directory.CreateDirectory(inFolder);
            }
            Int32 c = 0;
            if (parts != null) c = parts.Length;
            String path = inFolder;

            for (Int32 i = 0; i < c; i++)
            {
                path = Path.Combine(path, parts[i]);
                if (!Directory.Exists(path)) Directory.CreateDirectory(path);
            }

            String localPath = "";
            String template;
            String tempPackage;

            for (Int32 i = 0; i < count; i++)
            {
                res = resources[i];
                tempPackage = "";
                if (!resourceTemplates.ContainsKey(res.ResourceType))
                {
                    template = (String)PluginMain.GetTemplatePath("haxe").Clone();
                    resourceTemplates[res.ResourceType] = template;
                }
                else
                {
                    template = (String)resourceTemplates[res.ResourceType].Clone();
                }

                parts = res.Class.Split(new Char[1] { '.' });
                if (parts.Length > 1)
                {
                    Int32 k = parts.Length - 1;
                    localPath = (String)path.Clone();
                    for (Int32 j = 0; j < k; j++)
                    {
                        tempPackage += "." + parts[j];
                        localPath = Path.Combine(localPath, parts[j]);
                        if (!Directory.Exists(path)) Directory.CreateDirectory(path);
                    }
                }
                else localPath = (String)path.Clone();
                ProcessArguments(template, localPath, res, package + tempPackage);
            }
        }

        private static void ProcessArguments(String template, 
            String path, SamResource res, String package)
        {
            String cl = res.Class;
            Char[] splitter = new Char[1] { '.' };
            String[] parts = res.Class.Split(splitter);
            cl = parts[parts.Length - 1];
            parts = embedSupers[res.ResourceType].Split(splitter);
            String superClass = parts[parts.Length - 1];
            String superPackage = "import " + embedSupers[res.ResourceType] + ";";

            template = template.Replace("$(SamSuperClass)", superClass);
            template = template.Replace("$(SamSuperImport)", superPackage);
            template = template.Replace("$(SamResource)", res.File);
            template = template.Replace("$(SamPackage)", package);
            template = template.Replace("$(SamClass)", cl);

            template = PluginBase.MainForm.ProcessArgString(template);

            using (StreamWriter fs = new StreamWriter(Path.Combine(path, cl + ".hx")))
            {
                fs.Write(template);
                fs.Close();
            }
        }

        private static void AddFontRange(SamFont fontNode, XmlNodeList fromNodes)
        {

        }

        public static void ExportAS3Classes(String file)
        {

        }

        public static void ExportFlexClasses(String file)
        {

        }
    }

    interface ISamResources
    {
        List<SamResource> Resources { get; set; }
    }

    class SamSchema
    {
        public String Package;
        public String Version;
        public readonly List<SamFrame> Frames = new List<SamFrame>();

        public SamSchema() { }
    }

    class SamFrame : ISamResources
    {
        public List<SamResource> Resources  { get; set; }

        public SamFrame()
        {
            Resources = new List<SamResource>();
        }
    }

    class SamResource
    {
        public String File;
        public ResourceNodeType ResourceType;
        public String Class;

        public SamResource() { }
    }

    class SamComposite : SamResource, ISamResources
    {
        public List<SamResource> Resources { get; set; }

        public SamComposite() : base()
        {
            Resources = new List<SamResource>();
        }
    }

    class SamFont : SamResource
    {
        public String Characters;

        public SamFont() : base() { }
    }
}
