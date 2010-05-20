using System;
using System.Drawing;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using System.Xml;
using FlashDevelop;
using PluginCore;
using ScintillaNet;
using SamHaXePanel.Dialogs;
using System.Reflection;
using SamHaXePanel.Resources;
using System.Collections;
using System.Collections.Generic;

namespace SamHaXePanel
{
    public partial class PluginUI : UserControl
    {
        public const int SAM_ICON = 0;
        public const int FRAME_ICON = 1;
        public const int IMAGE_ICON = 2;
        public const int FONT_ICON = 3;
        public const int SOUND_ICON = 4;
        public const int BINARY_ICON = 5;
        public const int SWF_ICON = 6;
        public const int COMPOSE_ICON = 7;
        public const int PROJECT_ICON = 8;

        public static String[] KnownNamespaces = new String[7]
        {
	        "http://mindless-labs.com/samhaxe",
	        "http://mindless-labs.com/samhaxe/modules/Binary",
	        "http://mindless-labs.com/samhaxe/modules/Compose",
	        "http://mindless-labs.com/samhaxe/modules/Font",
	        "http://mindless-labs.com/samhaxe/modules/Image",
	        "http://mindless-labs.com/samhaxe/modules/Sound",
	        "http://mindless-labs.com/samhaxe/modules/Swf"
        };

        public static String[] KnownPrefices = new String[7]
        {
	        "shx", "bin", "compose", "fnt", "img", "snd", "swf"
        };

        private String[] Templates = new String[6]
        {
            @"<${Ns}:binary import=""${Path}"" class=""${Class}Bin""/>",
            @"<${Ns}:compose/>",
            @"<${Ns}:ttf import=""${Path}"" name=""${Class}Font""/>",
            @"<${Ns}:image import=""${Path}"" class=""${Class}Image""/>",
            @"<${Ns}:sound import=""${Path}"" class=""${Class}Sound""/>",
            @"<${Ns}:swf import=""${Path}"" class=""${Class}Swf""/>"
        };

        private PluginMain pluginMain;
        private ContextMenuStrip buildFileMenu;
        private ContextMenuStrip frameMenu;
        private ContextMenuStrip resourceMenu;
        private Int32 nsAdded = 0;
        
        public PluginUI(PluginMain pluginMain)
        {
            this.pluginMain = pluginMain;
            this.InitializeComponent();
            ImageList i = new ImageList();
            i.ColorDepth = ColorDepth.Depth32Bit;
            i.Images.Add(LocaleHelper.GetImage("SamIcon"));
            i.Images.Add(PluginBase.MainForm.FindImage("60")); // down arrow
            i.Images.Add(PluginBase.MainForm.FindImage("336")); // image
            i.Images.Add(PluginBase.MainForm.FindImage("408")); // font
            i.Images.Add(PluginBase.MainForm.FindImage("389")); // sound
            i.Images.Add(PluginBase.MainForm.FindImage("288")); // binary
            i.Images.Add(PluginBase.MainForm.FindImage("300")); // swf
            i.Images.Add(PluginBase.MainForm.FindImage("203")); // compose
            i.Images.Add(PluginBase.MainForm.FindImage("274")); // project
            this.imageList = i;
            this.treeView.ImageList = this.imageList;
            this.toolStrip.Renderer = new DockPanelStripRenderer();
            this.addButton.Image = LocaleHelper.GetImage("SamIcon");
            this.runButton.Image = PluginBase.MainForm.FindImage("127");
            this.refreshButton.Image = PluginBase.MainForm.FindImage("66");

            this.CreateMenus();
            this.RefreshData();
        }

        private void CreateMenus()
        {
            Image remImage = PluginBase.MainForm.FindImage("153");
            this.buildFileMenu = new ContextMenuStrip();
            this.buildFileMenu.Items.Add("Compile", this.runButton.Image, this.CompileClick);
            this.buildFileMenu.Items.Add("Edit", null, this.MenuEditClick);
            this.buildFileMenu.Items.Add("Configure", null, this.ConfigClick);
            this.buildFileMenu.Items.Add("Add Frame", null, this.AddFrameClick);
            this.buildFileMenu.Items.Add(new ToolStripSeparator());
            this.buildFileMenu.Items.Add("Remove", remImage, this.MenuRemoveClick);

            this.frameMenu = new ContextMenuStrip();
            this.frameMenu.Items.Add("Add resources", null, this.AddResourceClick);
            this.frameMenu.Items.Add("Edit", null, this.MenuEditClick);
            this.frameMenu.Items.Add(new ToolStripSeparator());
            this.frameMenu.Items.Add("Remove", remImage, this.RemoveNodeClick);

            this.resourceMenu = new ContextMenuStrip();
            this.resourceMenu.Items.Add("Edit in external editor", null, this.EditExternalClick);
            this.resourceMenu.Items.Add("Edit", null, this.MenuEditClick);
            this.resourceMenu.Items.Add(new ToolStripSeparator());
            this.resourceMenu.Items.Add("Remove", remImage, this.RemoveNodeClick);
        }

        private void AddFrameClick(object sender, EventArgs e)
        {
            MessageBox.Show("Not implemented yet.");
            //TreeNodeCollection nodes = this.treeView.Nodes[0].Nodes;
            //foreach (TreeNode n in nodes)
            //{
            //    Console.WriteLine(n.Text);
            //}
        }

        private void AddResourceClick(object sender, EventArgs e)
        {
            OpenFileDialog dialog = new OpenFileDialog();
            SamTreeNode node = (SamTreeNode)this.treeView.SelectedNode;
            dialog.Filter =
                "SWF Files (*.swf)|*.swf|" +
                "Font Files (*.ttf,*.otf)|*.ttf;*.otf|" +
                "Image Files (*.gif,*.jpeg,*.jpg,*.png)|*.gif;*.jpeg;*.jpg;*.png|" +
                "Sound Files (*.mp3)|*.mp3|" +
                "All files(*.*)|*.*";
            dialog.Multiselect = true;
            if (PluginBase.CurrentProject != null)
            {
                String fullPath = Path.GetDirectoryName(
                        PluginBase.CurrentProject.ProjectPath);
                dialog.CustomPlaces.Add(fullPath);
                dialog.InitialDirectory = fullPath;
            }
            dialog.Title = "Browse for resource files";
            DialogResult res = dialog.ShowDialog();
            if (res == DialogResult.OK)
            {
                Int32 type = 1;
                switch (dialog.FilterIndex)
                {
                    case 1:
                        type = SWF_ICON;
                        break;
                    case 2:
                        type = FONT_ICON;
                        break;
                    case 3:
                        type = IMAGE_ICON;
                        break;
                    case 4:
                        type = SOUND_ICON;
                        break;
                    case 5:
                        type = BINARY_ICON;
                        break;
                }
                this.treeView.BeginUpdate();
                foreach (String fn in dialog.FileNames)
                {
                    if (!this.AddResourceNode(node, new FileInfo(fn), type))
                        break;
                }
                this.treeView.EndUpdate();
            }
        }

        private Boolean AddResourceNode(SamTreeNode node, FileInfo file, Int32 type)
        {
            this.nsAdded = 0;
            Int32 c = node.Nodes.Count;
            SamTreeNode lastNode;
            if (c == 0)
            {
                lastNode = node;
            }
            else
            {
                lastNode = (SamTreeNode)node.Nodes[c - 1];
            }
            c = this.FindNodeInFile(lastNode);
            if (c < 0)
            {
                // TODO: Put this into resources.
                MessageBox.Show("Cannot make changes. File structure is invalid.");
                return false;
            }
            SamTreeNode newNode = new SamTreeNode(file.Name, type);
            newNode.File = file.FullName;

            switch (type)
            {
                case SWF_ICON:
                    newNode.ResourceType = ResourceNodeType.Swf;
                    break;
                case IMAGE_ICON:
                    newNode.ResourceType = ResourceNodeType.Image;
                    break;
                case SOUND_ICON:
                    newNode.ResourceType = ResourceNodeType.Sound;
                    break;
                case FONT_ICON:
                    newNode.ResourceType = ResourceNodeType.Font;
                    break;
                case BINARY_ICON:
                    newNode.ResourceType = ResourceNodeType.Binary;
                    break;
            }

            node.Nodes.Add(newNode);
            ScintillaControl sci = Globals.SciControl;
            String insert;
            String insertIndent;
            Char ch;

            if (node == lastNode)
            {
                String word = "";
                Boolean nameKnown = false;
                
                while (c < sci.Length)
                {
                    ch = (Char)sci.CharAt(c);
                    if (!nameKnown && ch != ' ' &&
                        ch != '\t' && ch != '\r' && 
                        ch != '\n' && ch != '>')
                    {
                        word += ch;
                    }
                    else nameKnown = true;
                    if (ch == '>')
                    {
                        if ((Char)sci.CharAt(c - 1) == '/')
                        {
                            insert = this.NodeToXml(newNode);
                            Int32 ind = sci.LineIndentPosition(
                                sci.LineFromPosition(this.nsAdded + c));
                            insertIndent = "";
                            while (ch != '\r' && ch != '\n')
                            {
                                insertIndent += '\t';
                                ind--;
                                ch = (Char)sci.CharAt(ind);
                            }
                            insert = '\r' + insertIndent + insert + '\r';
                            insert += insertIndent.Substring(1) + "</" + word + ">";
                            sci.InsertText(this.nsAdded + c + 1, insert);
                        }
                        else
                        {
                            insert = this.NodeToXml(newNode);
                            Int32 ind = sci.LineIndentPosition(
                                sci.LineFromPosition(this.nsAdded + c));
                            insertIndent = "";
                            while (ch != '\r' && ch != '\n')
                            {
                                insertIndent += '\t';
                                ind--;
                                ch = (Char)sci.CharAt(ind);
                            }
                            insert = '\r' + insertIndent + insert + '\r';
                            sci.InsertText(this.nsAdded + c + 1, insert);
                        }
                        break;
                    }
                    c++;
                }
            }
            else
            {
                Int32 start = c - 1;
                c = this.FindNodeEnd(c);
                insert = this.NodeToXml(newNode);
                Int32 ind = sci.LineIndentPosition(
                    sci.LineFromPosition(this.nsAdded + c)) - 1;
                insertIndent = "";
                ch = (Char)sci.CharAt(ind);
                while (ch != '\r' && ch != '\n')
                {
                    insertIndent += '\t';
                    ind--;
                    ch = (Char)sci.CharAt(ind);
                }
                insert = '\r' + insertIndent + insert;
                sci.InsertText(this.nsAdded + c, insert);
            }
            return true;
        }

        private Int32 FindNodeEnd(Int32 startedAt)
        {
            startedAt--;
            Int32 start = startedAt;
            ScintillaControl sci = Globals.SciControl;
            Char ch;
            Int16 openCount = 0;
            Boolean afterOpen = false;

            while (true)
            {
                ch = (Char)sci.CharAt(startedAt);
                if (ch == '>')
                {
                    if ((Char)sci.CharAt(startedAt - 1) == '/')
                    {
                        openCount--;
                        afterOpen = false;
                    }
                }
                else if (ch == '<')
                {
                    ch = (Char)sci.CharAt(startedAt + 1);
                    if (ch == '/')
                    {
                        openCount--;
                        afterOpen = true;
                    }
                    else if (ch != '!' && ch != '?' && ch != '-')
                    {
                        openCount++;
                    }
                }
                if (openCount == 0 || sci.Length < startedAt)
                {
                    if (afterOpen)
                    {
                        while (ch != '>')
                        {
                            ch = (Char)sci.CharAt(startedAt);
                            startedAt++;
                        }
                    }
                    else startedAt++;
                    break;
                }
                startedAt++;
            }
            return startedAt;
        }

        private void RemoveNodeClick(object sender, EventArgs e)
        {
            SamTreeNode node = (SamTreeNode)this.treeView.SelectedNode;

            Int32 pos = this.FindNodeInFile(node);
            if (pos < 0)
            {
                // TODO: Put this into resources.
                MessageBox.Show("Cannot make changes. File structure is invalid.");
                return;
            }

            Int32 start = pos - 1;
            pos = this.FindNodeEnd(pos);
            ScintillaControl sci = Globals.SciControl;
            sci.SetSel(start, pos);
            sci.DeleteBack();
            this.treeView.Nodes.Remove(node);
            this.RefreshData();
        }

        private String NodeToXml(SamTreeNode node)
        {
            String template = "";
            Regex re = new Regex("([^\\/\\\\\\.]+)((\\.[^\\.]+$)|$)", RegexOptions.Compiled);
            Regex nonAlpha = new Regex("\\W", RegexOptions.Compiled);
            String requiredNs = KnownNamespaces[0];
            Boolean hasRequiredNs = false;
            String knownPrefix = KnownPrefices[0];

            switch (node.ResourceType)
            {
                case ResourceNodeType.Binary:
                    template = this.Templates[0];
                    requiredNs = KnownNamespaces[1];
                    knownPrefix = KnownPrefices[1];
                    break;
                case ResourceNodeType.Compose:
                    template = this.Templates[1];
                    requiredNs = KnownNamespaces[2];
                    knownPrefix = KnownPrefices[2];
                    break;
                case ResourceNodeType.Font:
                    template = this.Templates[2];
                    requiredNs = KnownNamespaces[3];
                    knownPrefix = KnownPrefices[3];
                    break;
                case ResourceNodeType.Image:
                    template = this.Templates[3];
                    requiredNs = KnownNamespaces[4];
                    knownPrefix = KnownPrefices[4];
                    break;
                case ResourceNodeType.Sound:
                    template = this.Templates[4];
                    requiredNs = KnownNamespaces[5];
                    knownPrefix = KnownPrefices[5];
                    break;
                case ResourceNodeType.Swf:
                    template = this.Templates[5];
                    requiredNs = KnownNamespaces[6];
                    knownPrefix = KnownPrefices[6];
                    break;
            }
            String fullPath = 
                ProjectManager.Projects.ProjectPaths.GetRelativePath(
                Path.GetDirectoryName(
                    PluginBase.CurrentProject.ProjectPath), node.File);
            template = template.Replace("${Path}", fullPath);
            String fName = re.Match(node.File).Groups[1].Value;
            fName = nonAlpha.Replace(fName, "");
            fName = fName.ToCharArray()[0].ToString().ToUpper() + fName.Substring(1);
            template = template.Replace("${Class}", fName);
            ScintillaControl sci = Globals.SciControl;
            XmlDocument xml = new XmlDocument();
            xml.LoadXml(sci.Text);
            Hashtable namespaces = new Hashtable();
            XmlAttributeCollection col = xml.DocumentElement.Attributes;
            Int32 count = col.Count;

            for (Int32 i = 0; i < count; i++)
            {
                XmlAttribute at = col[i];
                if (at.Prefix == "xmlns")
                {
                    namespaces[at.InnerText] = at.LocalName;
                    if (requiredNs == at.InnerText)
                    {
                        hasRequiredNs = true;
                        knownPrefix = at.LocalName;
                        break;
                    }
                }
            }
            if (!hasRequiredNs)
            {
                SamTreeNode rootNode = node;
                while (rootNode.ResourceType != ResourceNodeType.Root)
                {
                    rootNode = (SamTreeNode)rootNode.Parent;
                }
                Int32 start = this.FindNodeInFile(rootNode);
                Char ch = (Char)sci.CharAt(start);
                while (ch != '>')
                {
                    ch = (Char)sci.CharAt(start);
                    start++;
                }
                String insertText = " xmlns:" + knownPrefix + "=\"" + requiredNs + "\"";
                this.nsAdded += insertText.Length;
                sci.InsertText(start - 1, insertText);
            }
            return template.Replace("${Ns}", knownPrefix);
        }

        private void EditExternalClick(object sender, EventArgs e)
        {
            SamTreeNode node = this.treeView.SelectedNode as SamTreeNode;
            switch (node.ResourceType)
            {
                case ResourceNodeType.Frame:
                case ResourceNodeType.Root:
                case ResourceNodeType.Compose:
                    return;
            }
            if (PluginBase.CurrentProject == null) return;
            
            String fullPath = Path.GetDirectoryName(
                    PluginBase.CurrentProject.ProjectPath);
            fullPath = Path.Combine(fullPath, node.File);
            using (System.Diagnostics.Process prc = new System.Diagnostics.Process())
            {
                prc.StartInfo.FileName = fullPath;
                prc.Start();
            }
        }

        private void treeView_NodeMouseClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            if (e.Button == MouseButtons.Right)
            {
                SamTreeNode currentNode = this.treeView.GetNodeAt(e.Location) as SamTreeNode;
                this.treeView.SelectedNode = currentNode;
                switch (currentNode.ResourceType)
                {
                    case ResourceNodeType.Root:
                        this.buildFileMenu.Show(this.treeView, e.Location);
                        break;
                    case ResourceNodeType.Frame:
                        this.frameMenu.Show(this.treeView, e.Location);
                        break;
                    default:
                        this.resourceMenu.Show(this.treeView, e.Location);
                        break;
                }
            }
        }

        private void treeView_NodeMouseDoubleClick(object sender, TreeNodeMouseClickEventArgs e)
        {
            this.RunTarget();
        }

        private void CompileClick(object sender, EventArgs e)
        {
            this.RunTarget();
        }
        
        private void MenuEditClick(object sender, EventArgs e)
        {
            SamTreeNode node = treeView.SelectedNode as SamTreeNode;
            Int32 pos = this.FindNodeInFile(node);
            ScintillaControl sci = Globals.SciControl;

            if (pos < 0) pos = 0;
            sci.GotoPos(pos);
        }

        private Int32 FindNodeInFile(SamTreeNode node)
        {
            SamTreeNode rootNode = node;
            List<SamTreeNode> validSamNodes = new List<SamTreeNode>();
            while (rootNode != null && rootNode.ResourceType != ResourceNodeType.Root)
            {
                validSamNodes.Add(rootNode);
                rootNode = (SamTreeNode)rootNode.Parent;
            }
            validSamNodes.Add(rootNode);
            validSamNodes.Reverse();
            Globals.MainForm.OpenEditableDocument(rootNode.File, false);
            ScintillaControl sci = Globals.SciControl;
            String text = sci.Text;

            try
            {
                SamXmlReader reader = new SamXmlReader(text);
                Int32 pos = reader.FindNodeStart(validSamNodes);
                Int32 sciPos = sci.PositionFromLine(pos);
                String word = "";

                if (String.IsNullOrEmpty(reader.Name))
                {
                    while ((Char)sci.CharAt(sciPos) != '<') sciPos++;
                    sciPos++;
                }
                else
                {
                    sciPos += reader.LinePosition;
                    while (sci.CharAt(sciPos) > 32) sciPos++;
                    while (!word.StartsWith(reader.Name) && sciPos > 0)
                    {
                        sciPos--;
                        word = (Char)sci.CharAt(sciPos) + word;
                    }
                    if ((Char)sci.CharAt(sciPos - 1) == '/')
                    {
                        word = "";
                        sciPos--;
                        while (!word.StartsWith(reader.Name) && sciPos > 0)
                        {
                            sciPos--;
                            word = (Char)sci.CharAt(sciPos) + word;
                        }
                    }
                }
                return sciPos;
            }
            catch
            {
                return -1;
            }
        }

        private void MenuRemoveClick(object sender, EventArgs e)
        {
            this.pluginMain.RemoveConfigFile(
                (this.treeView.SelectedNode as SamTreeNode).File);
        }
        
        private void addButton_Click(object sender, EventArgs e)
        {
            OpenFileDialog dialog = new OpenFileDialog();
            dialog.Filter = "SamHaXe resource files (*.xml)|*.XML|" + "All files (*.*)|*.*";
            dialog.Multiselect = true;
            if (PluginBase.CurrentProject != null)
                dialog.InitialDirectory = Path.GetDirectoryName(
                    PluginBase.CurrentProject.ProjectPath);

            if (dialog.ShowDialog() == DialogResult.OK)
            {
                this.pluginMain.AddConfigFiles(dialog.FileNames);
            }
        }

        private void runButton_Click(object sender, EventArgs e)
        {
            this.RunTarget();
        }

        private void RunTarget()
        {
            SamTreeNode node = treeView.SelectedNode as SamTreeNode;
            if (node == null)
                return;
            pluginMain.RunTarget(node.File, node.Settings);
        }

        private void refreshButton_Click(object sender, EventArgs e)
        {
            this.RefreshData();
        }
        
        public void RefreshData()
        {
            Boolean projectExists = PluginBase.CurrentProject != null;
            this.Enabled = projectExists;
            if (projectExists)
            {
                this.FillTree();
            }
            else
            {
                this.treeView.Nodes.Clear();
                this.treeView.Nodes.Add(new TreeNode("No project opened"));
            }
        }

        private void FillTree()
        {
            this.treeView.BeginUpdate();
            this.treeView.Nodes.Clear();
            foreach (String file in this.pluginMain.ConfigFilesList)
            {
                if (File.Exists(file))
                {
                    this.treeView.Nodes.Add(this.GetBuildFileNode(file));
                }
            }
            this.treeView.EndUpdate();
        }

        private TreeNode GetBuildFileNode(string file)
        {
            XmlDocument xml = new XmlDocument();
            xml.Load(file);

            XmlAttribute package = xml.DocumentElement.Attributes["package"];
            String packageName = (package != null) ? package.InnerText : file;

            XmlAttribute version = xml.DocumentElement.Attributes["version"];
            String versionName = (version != null) ? version.InnerText : "";

            XmlAttribute compress = xml.DocumentElement.Attributes["compress"];
            String compressName = (compress != null) ? compress.InnerText : "";

            Hashtable namespaces = new Hashtable();

            Stack<String> kns = new Stack<String>(KnownNamespaces);

            foreach (XmlAttribute xa in xml.DocumentElement.Attributes)
            {
                if (xa.Prefix == "xmlns")
                {
                    if (kns.Contains(xa.InnerText))
                        namespaces[xa.LocalName] = xa.InnerText;
                }
            }
            String shxns = "";
            foreach (DictionaryEntry s in namespaces)
            {
                if ((String)s.Value == KnownNamespaces[0])
                {
                    shxns = (String)s.Key;
                    break;
                }
            }

            String desc = (String)packageName.Clone() + " | ";
            if (!String.IsNullOrEmpty(versionName))
                desc += "version: " + versionName + " | ";
            if (!String.IsNullOrEmpty(compressName))
                desc += "compress: " + compressName;

            SamTreeNode rootNode = new SamTreeNode(packageName, PROJECT_ICON);
            rootNode.File = file;
            rootNode.Target = packageName;
            rootNode.ToolTipText = desc;
            rootNode.ResourceType = ResourceNodeType.Root;
            rootNode.Settings = this.pluginMain.SettingsForPath(file);

            XmlNodeList nodes = xml.DocumentElement.ChildNodes;
            int nodeCount = nodes.Count;
            for (int i = 0; i < nodeCount; i++)
            {
                XmlNode child = nodes[i];
                if (child.Name == shxns + ":frame")
                {
                    SamTreeNode frameNode = new SamTreeNode("Frame #" + i, FRAME_ICON);
                    this.ConstructFrameChildren(frameNode, child);
                    frameNode.File = file;
                    frameNode.ResourceType = ResourceNodeType.Frame;
                    rootNode.Nodes.Add(frameNode);
                }
            }

            rootNode.Expand();
            return rootNode;
        }

        private void ConstructFrameChildren(SamTreeNode frameNode, XmlNode node)
        {
            XmlNodeList nodes = node.ChildNodes;
            int nodeCount = nodes.Count;
            Int16 len = (Int16)KnownNamespaces.Length;
            Regex fname = new Regex("[^\\/\\\\]+$", RegexOptions.Compiled);
            
            for (int i = 0; i < nodeCount; i++)
            {
                XmlNode child = nodes[i];
                String uri = child.NamespaceURI;
                String type = "";
                String file = "";
                Int16 icon = 0;
                ResourceNodeType resType = ResourceNodeType.Root;

                for (Int16 j = 0; j < len; j++)
                {
                    if (KnownNamespaces[j] == uri)
                    {
                        switch (j)
                        {
                            case 0://"http://mindless-labs.com/samhaxe"
                                break;
                            case 1://"http://mindless-labs.com/samhaxe/modules/Binary"
                                type = "Binary";
                                icon = BINARY_ICON;
                                resType = ResourceNodeType.Binary;
                                break;
                            case 2://"http://mindless-labs.com/samhaxe/modules/Compose"
                                type = "Compose";
                                icon = COMPOSE_ICON;
                                resType = ResourceNodeType.Compose;
                                break;
                            case 3://"http://mindless-labs.com/samhaxe/modules/Font"
                                type = "Font";
                                icon = FONT_ICON;
                                break;
                            case 4://"http://mindless-labs.com/samhaxe/modules/Image"
                                type = "Image";
                                icon = IMAGE_ICON;
                                resType = ResourceNodeType.Image;
                                break;
                            case 5://"http://mindless-labs.com/samhaxe/modules/Sound"
                                type = "Sound";
                                icon = SOUND_ICON;
                                resType = ResourceNodeType.Sound;
                                break;
                            case 6://"http://mindless-labs.com/samhaxe/modules/Swf"
                                type = "Swf";
                                icon = SWF_ICON;
                                resType = ResourceNodeType.Swf;
                                break;
                        }
                        XmlAttribute import = child.Attributes["import"];
                        SamTreeNode resNode;
                        if (import != null)
                        {
                            file = fname.Match(import.InnerText).Value;
                            resNode = new SamTreeNode(file, icon);
                            resNode.File = import.InnerText;
                        }
                        else
                        {
                            resNode = new SamTreeNode(type + " #" + j, icon);
                        }
                        resNode.ResourceType = resType;
                        frameNode.Nodes.Add(resNode);
                        break;
                    }
                }
            }
        }

        private void ConfigClick(object sender, EventArgs e)
        {
            SamTreeNode node = this.treeView.SelectedNode as SamTreeNode;
            SamProperties sp = new SamProperties();
            node.Settings = this.pluginMain.SettingsForPath(node.File);
            sp.Grid.SelectedObject = node.Settings;
            SamSettings st = new SamSettings();
            st.Config = node.Settings.Config;
            st.Depfile = node.Settings.Depfile;
            st.Input = node.Settings.Input;
            st.ModuleOptions = node.Settings.ModuleOptions;
            st.Output = node.Settings.Output;

            if (sp.ShowDialog() == DialogResult.No)
                node.Settings = st;
            this.pluginMain.UpdateSettings(node.File, node.Settings);
            this.pluginMain.SaveConfigFiles();
        }

    }

    internal class SamTreeNode : TreeNode
    {
        public String File;
        public String Target;
        public ResourceNodeType ResourceType;
        public SamSettings Settings;

        public SamTreeNode(string text, int imageIndex)
            : base(text, imageIndex, imageIndex)
        {
        }
    }
    
}


