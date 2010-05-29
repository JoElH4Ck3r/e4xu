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
using System.Text;
using System.Drawing.Text;

namespace SamHaXePanel
{
    public partial class PluginUI : UserControl
    {
        #region Public static properties

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

        private static String[] Templates = new String[6]
        {
            @"<${Ns}:binary import=""${Path}"" class=""${Class}Bin""/>",
            @"<${Ns}:compose/>",
            @"<${Ns}:ttf import=""${Path}"" name=""${Class}Font""/>",
            @"<${Ns}:image import=""${Path}"" class=""${Class}Image""/>",
            @"<${Ns}:sound import=""${Path}"" class=""${Class}Sound""/>",
            @"<${Ns}:swf import=""${Path}"" class=""${Class}Swf""/>"
        };

        #endregion

        #region Private properties

        private PluginMain pluginMain;
        private ContextMenuStrip buildFileMenu;
        private ContextMenuStrip frameMenu;
        private ContextMenuStrip resourceMenu;
        private ContextMenuStrip fontMenu;
        private Int32 nsAdded = 0;
        private PrivateFontCollection fontCollection;

        #endregion

        // TODO: This should go to settings
        public String FontTestString = "Quick brown fox jumped over the lazy dog.";
        
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
            this.createNewBtn.Image = PluginBase.MainForm.FindImage("277");
            this.exportTSDB.Image = PluginBase.MainForm.FindImage("243");

            this.fontPreviewLB.Text = this.FontTestString;
            this.fontPreviewLB.Visible = false;

            this.CreateMenus();
            this.RefreshData();

            this.treeView.NodeMouseClick += new TreeNodeMouseClickEventHandler(treeView_NodeMouseClickHandler);
            this.treeView.NodeMouseDoubleClick += new TreeNodeMouseClickEventHandler(treeView_NodeMouseDoubleClickHandler);
            this.addButton.Click += new EventHandler(addButton_ClickHandler);
            this.runButton.Click += new EventHandler(runButton_ClickHandler);
            this.createNewBtn.Click += new EventHandler(createNewBtn_ClickHandler);
            this.refreshButton.Click += new EventHandler(refreshButton_ClickHandler);
        }

        private void CreateMenus()
        {
            Image remImage = PluginBase.MainForm.FindImage("153");
            this.buildFileMenu = new ContextMenuStrip();
            this.buildFileMenu.Items.Add("Compile", this.runButton.Image, this.Compile_ClickHandler);
            this.buildFileMenu.Items.Add("Edit", null, this.MenuEdit_ClickHandler);
            this.buildFileMenu.Items.Add("Configure", null, this.Config_ClickHandler);
            this.buildFileMenu.Items.Add("Add Frame", null, this.AddFrame_ClickHandler);
            this.buildFileMenu.Items.Add(new ToolStripSeparator());
            this.buildFileMenu.Items.Add("Remove", remImage, this.MenuRemove_ClickHandler);

            this.frameMenu = new ContextMenuStrip();
            this.frameMenu.Items.Add("Add resources", null, this.AddResource_ClickHandler);
            this.frameMenu.Items.Add("Edit", null, this.MenuEdit_ClickHandler);
            this.frameMenu.Items.Add(new ToolStripSeparator());
            this.frameMenu.Items.Add("Remove", remImage, this.RemoveNode_ClickHandler);

            this.resourceMenu = new ContextMenuStrip();
            this.resourceMenu.Items.Add("Edit in external editor", null, this.EditExternal_ClickHandler);
            this.resourceMenu.Items.Add("Edit", null, this.MenuEdit_ClickHandler);
            this.resourceMenu.Items.Add(new ToolStripSeparator());
            this.resourceMenu.Items.Add("Remove", remImage, this.RemoveNode_ClickHandler);

            this.fontMenu = new ContextMenuStrip();
            this.fontMenu.Items.Add("Edit in external editor", null, this.EditExternal_ClickHandler);
            this.fontMenu.Items.Add("Edit", null, this.MenuEdit_ClickHandler);
            this.fontMenu.Items.Add("Embed ranges", null, this.EmbedRanges_ClickHandler);
            this.fontMenu.Items.Add(new ToolStripSeparator());
            this.fontMenu.Items.Add("Remove", remImage, this.RemoveNode_ClickHandler);
        }

        private String InsertLinesIndented(String[] lines, Int32 startPos, ref Int32 endPos)
        {
            ScintillaControl sci = Globals.SciControl;
            Int32 line = sci.LineFromPosition(startPos);
            Int32 lineIndent = sci.GetLineIndentation(line);
            String lineStr = sci.GetLine(line);
            Char indentChar = ' ';
            String indentStr = "";
            String insertIndentStr = "";

            if (lineStr[0] == '\t')
            {
                indentChar = '\t';
                lineIndent /= 4;
            }
            while (lineIndent > 0)
            {
                indentStr += indentChar;
                lineIndent--;
            }
            if (indentChar == '\t')
            {
                insertIndentStr += indentStr + indentChar;
            }
            else
            {
                insertIndentStr += indentStr + "    ";
            }
            Int32 lineCount = lines.Length;
            String total = "";
            for (Int32 i = 0; i < lineCount; i++)
            {
                total += "\r" + insertIndentStr + lines[i].Trim();
            }
            Int32 adVal = 0;
            if (startPos != endPos)
            {
                sci.SetSel(startPos, endPos);
                sci.DeleteBack();
                adVal = endPos - startPos;
            }
            adVal += total.Length;
            endPos = startPos + adVal;
            sci.InsertText(startPos, total);
            if (indentChar == '\t')
                return insertIndentStr.Substring(1);
            else return insertIndentStr.Substring(4);
        }

        private void PreviewFontContent(SamTreeNode node)
        {
            if (File.Exists(node.File))
            {
                if (!this.flashMovie.Visible)
                    this.flashMovie.Visible = false;
                this.fontPreviewLB.Visible = true;
                this.fontCollection = new PrivateFontCollection();
                this.fontCollection.AddFontFile(node.File);
                this.fontPreviewLB.Width = this.splitContainer1.Width;

                FontFamily ff = this.fontCollection.Families[0];
                FontStyle fs = FontStyle.Regular;
                Boolean hasStyle = false;

                if (ff.IsStyleAvailable(FontStyle.Regular))
                {
                    fs = FontStyle.Regular;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Italic))
                {
                    fs = FontStyle.Italic;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Bold))
                {
                    fs = FontStyle.Bold;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Strikeout))
                {
                    fs = FontStyle.Strikeout;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Underline))
                {
                    fs = FontStyle.Underline;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Bold | FontStyle.Italic))
                {
                    fs = FontStyle.Bold | FontStyle.Italic;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Bold | FontStyle.Underline))
                {
                    fs = FontStyle.Bold | FontStyle.Underline;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Italic | FontStyle.Underline))
                {
                    fs = FontStyle.Italic | FontStyle.Underline;
                    hasStyle = true;
                }
                else if (ff.IsStyleAvailable(FontStyle.Bold | FontStyle.Italic | FontStyle.Underline))
                {
                    fs = FontStyle.Bold | FontStyle.Italic | FontStyle.Underline;
                    hasStyle = true;
                }
                if (hasStyle)
                {
                    this.fontPreviewLB.Font =
                        new Font(this.fontCollection.Families[0], 24,
                        fs, GraphicsUnit.Pixel);
                }
            }
        }

        private void PreviewMp3Content(SamTreeNode node)
        {
            if (File.Exists(node.File))
            {
                if (!this.flashMovie.Visible)
                    this.flashMovie.Visible = true;
                if (this.fontPreviewLB.Visible)
                    this.fontPreviewLB.Visible = false;
                this.flashMovie.Width = this.splitContainer1.Width;
                this.flashMovie.FlashVars = "sound=" + node.File;
                this.flashMovie.LoadMovie(0, this.pluginMain.MP3Player);
            }
        }

        private void PreviewSWFContent(SamTreeNode node)
        {
            if (File.Exists(node.File))
            {
                if (!this.flashMovie.Visible)
                    this.flashMovie.Visible = true;
                if (this.fontPreviewLB.Visible)
                    this.fontPreviewLB.Visible = false;
                this.flashMovie.Width = this.splitContainer1.Width;
                this.flashMovie.LoadMovie(0, node.File);
            }
        }

        private void PreviewImageContent(SamTreeNode node)
        {
            if (File.Exists(node.File))
            {
                if (this.flashMovie.Visible)
                    this.flashMovie.Visible = false;
                if (this.fontPreviewLB.Visible)
                    this.fontPreviewLB.Visible = false;
                this.imageDisplay.Load(node.File);
            }
        }

        private void RunTarget()
        {
            SamTreeNode node = treeView.SelectedNode as SamTreeNode;
            if (node == null)
            {
                // TODO: Move this to resources.
                MessageBox.Show("Nothing to run. Please select a valid target.");
                return;
            }
            if (node.ResourceType != ResourceNodeType.Root)
            {
                while (node.ResourceType != ResourceNodeType.Root)
                {
                    node = (SamTreeNode)node.Parent;
                }
            }
            pluginMain.RunTarget(node.File, node.Settings);
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

        private TreeNode GetBuildFileNode(String file)
        {
            XmlDocument xml = new XmlDocument();
            try
            {
                xml.Load(file);
            }
            catch
            {
                MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
                return new SamTreeNode("Not a valid resource file", PROJECT_ICON);
            }

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
                    this.ConstructFrameChildren(frameNode, child, Path.GetDirectoryName(file));
                    frameNode.File = file;
                    frameNode.ResourceType = ResourceNodeType.Frame;
                    rootNode.Nodes.Add(frameNode);
                }
            }

            rootNode.Expand();
            return rootNode;
        }

        #region Building tree

        private Boolean AddResourceNode(SamTreeNode node, FileInfo file, Int32 type)
        {
            this.nsAdded = 0;
            Int32 c = node.Nodes.Count;
            SamTreeNode lastNode;
            SamTreeNode rootNode = node;
            if (c == 0)
            {
                lastNode = node;
            }
            else
            {
                lastNode = (SamTreeNode)node.Nodes[c - 1];
            }
            while (rootNode.ResourceType != ResourceNodeType.Root)
            {
                rootNode = (SamTreeNode)rootNode.Parent;
            }
            String relativeTo = Path.GetDirectoryName(rootNode.File);
            c = this.FindNodeInFile(lastNode);
            if (c < 0)
            {
                MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
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
                            insert = this.NodeToXml(newNode, relativeTo);
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
                            insert = this.NodeToXml(newNode, relativeTo);
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
                insert = this.NodeToXml(newNode, relativeTo);
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

        private void ConstructFrameChildren(SamTreeNode frameNode, XmlNode node, String fileLocation)
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
                                resType = ResourceNodeType.Font;
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
                            if (Path.IsPathRooted(import.InnerText))
                                resNode.File = import.InnerText;
                            else resNode.File = Path.Combine(fileLocation, import.InnerText);
                        }
                        else
                        {
                            resNode = new SamTreeNode(type + " #" + i, icon);
                        }
                        resNode.ResourceType = resType;
                        frameNode.Nodes.Add(resNode);
                        if (resType == ResourceNodeType.Compose)
                        {
                            this.ConstructFrameChildren(resNode, child, fileLocation);
                        }
                        break;
                    }
                }
            }
        }

        #endregion

        #region Xml parsing

        private String NodeToXml(SamTreeNode node, String relativeTo)
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
                    template = Templates[0];
                    requiredNs = KnownNamespaces[1];
                    knownPrefix = KnownPrefices[1];
                    break;
                case ResourceNodeType.Compose:
                    template = Templates[1];
                    requiredNs = KnownNamespaces[2];
                    knownPrefix = KnownPrefices[2];
                    break;
                case ResourceNodeType.Font:
                    template = Templates[2];
                    requiredNs = KnownNamespaces[3];
                    knownPrefix = KnownPrefices[3];
                    break;
                case ResourceNodeType.Image:
                    template = Templates[3];
                    requiredNs = KnownNamespaces[4];
                    knownPrefix = KnownPrefices[4];
                    break;
                case ResourceNodeType.Sound:
                    template = Templates[4];
                    requiredNs = KnownNamespaces[5];
                    knownPrefix = KnownPrefices[5];
                    break;
                case ResourceNodeType.Swf:
                    template = Templates[5];
                    requiredNs = KnownNamespaces[6];
                    knownPrefix = KnownPrefices[6];
                    break;
            }
            String fullPath =
                ProjectManager.Projects.ProjectPaths.GetRelativePath(relativeTo, node.File);
            template = template.Replace("${Path}", fullPath);
            String fName = re.Match(node.File).Groups[1].Value;
            fName = nonAlpha.Replace(fName, "");
            fName = fName.ToCharArray()[0].ToString().ToUpper() + fName.Substring(1);
            template = template.Replace("${Class}", fName);
            ScintillaControl sci = Globals.SciControl;
            XmlDocument xml = new XmlDocument();
            try
            {
                xml.LoadXml(sci.Text);
            }
            catch
            {
                MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
                return "";
            }
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

        private String NodeContentFromXml(SamTreeNode node)
        {
            Int32 pos = this.FindNodeInFile(node);
            if (pos < 0)
            {
                MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
                return "";
            }
            Int32 end = this.FindNodeEnd(pos);
            if (end < 0)
            {
                MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
                return "";
            }
            Char ch;
            StringBuilder content = new StringBuilder();
            ScintillaControl sci = Globals.SciControl;

            while (pos < end)
            {
                ch = (Char)sci.CharAt(pos);
                if (ch == '>')
                {
                    if ((Char)sci.CharAt(pos - 1) == '/')
                        return "";
                    else break;
                }
                pos++;
            }
            pos++;
            while (pos < end)
            {
                ch = (Char)sci.CharAt(end);
                if (ch == '<') break;
                end--;
            }
            while (pos < end)
            {
                content.Append((Char)sci.CharAt(pos));
                pos++;
            }
            return content.ToString();
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

        private String GenerateFromFolder(SamTreeNode frameNode, String path, String filter, 
            Boolean recursive, Boolean generateComposites, String rootFolder)
        {
            StringBuilder sb = new StringBuilder();
            if (Directory.Exists(path))
            {
                String[] files = Directory.GetFiles(path);
                String[] directories = Directory.GetDirectories(path);
                Regex re = null;

                if (!String.IsNullOrEmpty(filter))
                    re = new Regex(filter, RegexOptions.IgnoreCase);

                if (recursive)
                {
                    foreach (String subPath in directories)
                    {
                        sb.AppendLine(
                            this.GenerateFromFolder(subPath, re, frameNode, generateComposites, rootFolder, 0));
                    }
                }
                foreach (String file in files)
                {
                    if (re == null || re.IsMatch(file))
                    {
                        sb.AppendLine(this.NodeToXml(this.NodeFromFile(file), rootFolder));
                    }
                }
            }

            return sb.ToString();
        }

        private SamTreeNode NodeFromFile(String file)
        {
            Regex ext = new Regex("[^\\.]+$", RegexOptions.Compiled);
            String extension = ext.Match(file).Value.ToLower();
            SamTreeNode resourceNode = null;

            switch (extension)
            {
                case "jpeg":
                case "jpg":
                case "gif":
                case "png":
                    resourceNode = new SamTreeNode(new FileInfo(file).Name, IMAGE_ICON);
                    resourceNode.ResourceType = ResourceNodeType.Image;
                    break;
                case "swf":
                    resourceNode = new SamTreeNode(new FileInfo(file).Name, SWF_ICON);
                    resourceNode.ResourceType = ResourceNodeType.Swf;
                    break;
                case "mp3":
                case "wav":
                    resourceNode = new SamTreeNode(new FileInfo(file).Name, SOUND_ICON);
                    resourceNode.ResourceType = ResourceNodeType.Sound;
                    break;
                case "ttf":
                    resourceNode = new SamTreeNode(new FileInfo(file).Name, FONT_ICON);
                    resourceNode.ResourceType = ResourceNodeType.Font;
                    break;
                default:
                    resourceNode = new SamTreeNode(new FileInfo(file).Name, BINARY_ICON);
                    resourceNode.ResourceType = ResourceNodeType.Binary;
                    break;
            }
            resourceNode.File = file;
            return resourceNode;
        }

        private String GenerateFromFolder(String path, Regex filter,
            SamTreeNode toNode, Boolean generateComposites, String rootFolder, Int16 depth)
        {
            StringBuilder sb = new StringBuilder();
            String[] files = Directory.GetFiles(path);
            String[] directories = Directory.GetDirectories(path);
            String indent = "";
            Int16 localDepth = depth;

            if (generateComposites)
            {
                indent = "\t";
                while (localDepth-- > 0)
                {
                    indent += '\t';
                }
                //TODO: Have get the compose prefix from template
                if (files.Length > 0 || directories.Length > 0)
                {
                    sb.AppendLine(indent.Substring(1) + "<comp:compose>");
                }
            }

            foreach (String subPath in directories)
            {
                sb.AppendLine(
                    this.GenerateFromFolder(subPath, filter,
                    toNode, generateComposites, rootFolder, (Int16)(depth + 1)));
            }

            foreach (String file in files)
            {
                if (filter == null || filter.IsMatch(file))
                {
                    sb.AppendLine(indent + this.NodeToXml(this.NodeFromFile(file), rootFolder));
                }
            }
            if (generateComposites)
            {
                if (files.Length > 0 || directories.Length > 0)
                {
                    sb.AppendLine(indent.Substring(1) + "</comp:compose>");
                }
            }
            return sb.ToString();
        }

        #endregion

        #region Event handlers

        private void AddFrame_ClickHandler(Object sender, EventArgs e)
        {
            MessageBox.Show("Not implemented yet.");
            //TreeNodeCollection nodes = this.treeView.Nodes[0].Nodes;
            //foreach (TreeNode n in nodes)
            //{
            //    Console.WriteLine(n.Text);
            //}
        }

        private void EmbedRanges_ClickHandler(Object sender, EventArgs e)
        {
            AddFontDialog dialog = new AddFontDialog();
            SamTreeNode node = (SamTreeNode)this.treeView.SelectedNode;

            String nodeContent = this.NodeContentFromXml(node);
            String ns = "";
            Char ch;

            ScintillaControl sci = Globals.SciControl;
            Int32 pos = -1;
            Int32 colonPos;
            Int32 ltPos;

            if (!String.IsNullOrEmpty(nodeContent.Trim()))
            {
                colonPos = nodeContent.IndexOf(':');
                if (colonPos > -1)
                {
                    ltPos = nodeContent.IndexOf('<') + 1;
                    if (ltPos < colonPos)
                        ns = nodeContent.Substring(ltPos, colonPos - ltPos);
                }
            }
            else
            {
                pos = this.FindNodeInFile(node);
                ltPos = pos;
                while (ltPos < sci.Length)
                {
                    ch = (Char)sci.CharAt(ltPos);
                    if (ch == ':') break;
                    ns += ch;
                    ltPos++;
                }
            }
            
            dialog.SetFontPath(node.File);
            dialog.ParseRanges(nodeContent);
            DialogResult dr = dialog.ShowDialog();

            if (dr == DialogResult.OK)
            {
                String insertStr = dialog.ExportXmlString().Replace("\n", "").Trim();
                insertStr = insertStr.Replace("$(ns)", ns);
                if (pos < 0) pos = this.FindNodeInFile(node);
                Boolean wordCompleted = false;
                Boolean inserted = false;
                String nodeBody = "";
                String word = "";
                Int32 startedAt = pos;
                String indentStr;

                while (pos < sci.Length)
                {
                    ch = (Char)sci.CharAt(pos);
                    if (!wordCompleted && ch != ' ' &&
                        ch != '\t' && ch != '\r' && ch != '\n')
                    {
                        word += ch;
                    }
                    else wordCompleted = true;
                    nodeBody += ch;

                    if (ch == '>')
                    {
                        if ((Char)sci.CharAt(pos - 1) == '/')
                        {
                            sci.SetSel(pos - 1, pos);
                            sci.DeleteBack();
                            indentStr = this.InsertLinesIndented(
                                insertStr.Split(new Char[] { '\r' }), pos, ref pos);
                            sci.InsertText(pos, "\r" + indentStr + "</" + word + ">");
                            inserted = true;
                        }
                        else
                        {
                            pos = this.FindNodeEnd(startedAt);
                            if (pos < 0) break;
                            while (pos > 0)
                            {
                                ch = (Char)sci.CharAt(pos);
                                pos--;
                                if (ch == '<')
                                {
                                    pos -= 2;
                                    indentStr = this.InsertLinesIndented(
                                        insertStr.Split(new Char[] { '\r' }),
                                        startedAt + nodeBody.Length, ref pos);
                                    inserted = true;
                                    break;
                                }
                            }
                        }
                        break;
                    }
                    pos++;
                }
                if (!inserted)
                {
                    MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
                }
            }
        }

        private void AddResource_ClickHandler(Object sender, EventArgs e)
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

        private void RemoveNode_ClickHandler(Object sender, EventArgs e)
        {
            SamTreeNode node = (SamTreeNode)this.treeView.SelectedNode;

            Int32 pos = this.FindNodeInFile(node);
            if (pos < 0)
            {
                MessageBox.Show(LocaleHelper.GetErrorString(LocaleHelper.INVALID_FILE_ERROR));
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

        private void EditExternal_ClickHandler(Object sender, EventArgs e)
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

        private void Compile_ClickHandler(Object sender, EventArgs e)
        {
            this.RunTarget();
        }
        
        private void MenuEdit_ClickHandler(Object sender, EventArgs e)
        {
            SamTreeNode node = treeView.SelectedNode as SamTreeNode;
            Int32 pos = this.FindNodeInFile(node);
            ScintillaControl sci = Globals.SciControl;

            if (pos < 0) pos = 0;
            sci.GotoPos(pos);
        }

        private void Config_ClickHandler(Object sender, EventArgs e)
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

        private void Panel2_ResizeHandler(Object sender, EventArgs e)
        {
            this.fontPreviewLB.Width = this.splitContainer1.Width;
            this.fontPreviewLB.Height = this.splitContainer1.Height;
        }

        private void ExportHaXe_ClickHandler(Object sender, EventArgs e)
        {
            SamTreeNode rootNode = this.treeView.SelectedNode as SamTreeNode;
            if (rootNode == null)
            {
                MessageBox.Show("Nothing selected. Please select a resource file and try again.");
                return;
            }
            while (rootNode.ResourceType != ResourceNodeType.Root)
            {
                rootNode = (SamTreeNode)rootNode.Parent;
            }
            FolderBrowserDialog dialog = new FolderBrowserDialog();
            dialog.Description = "Select folder to create HaXe extern classes";
            dialog.ShowNewFolderButton = true;
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                SamSchemaExporter.ExportHaXeClasses(rootNode.File, dialog.SelectedPath);
            }
        }

        private void ExportAs3_ClickHandler(Object sender, EventArgs e)
        {

        }

        private void ExportFlex_ClickHandler(Object sender, EventArgs e)
        {

        }

        private void MenuRemove_ClickHandler(Object sender, EventArgs e)
        {
            this.pluginMain.RemoveConfigFile(
                (this.treeView.SelectedNode as SamTreeNode).File);
        }

        private void addButton_ClickHandler(Object sender, EventArgs e)
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

        private void runButton_ClickHandler(Object sender, EventArgs e)
        {
            this.RunTarget();
        }

        private void createNewBtn_ClickHandler(Object sender, EventArgs e)
        {
            CreateResourcesFile dialog = new CreateResourcesFile();
            DialogResult res = dialog.ShowDialog();
            if (res == DialogResult.OK || res == DialogResult.Yes)
            {
                Byte[] b = LocaleHelper.GetFile("SamTemplate0");
                String template = UTF8Encoding.Default.GetString(b);
                template = template.Replace("$(Package)", dialog.Package);
                template = template.Replace("version=\"9\"", "version=\"" + dialog.Version + "\"");
                template = template.Replace("compress=\"true\"", "compress=\"" +
                    dialog.Compressed.ToString().ToLower() + "\"");
                if (!String.IsNullOrEmpty(dialog.ResourceFolder))
                {
                    String package = "resources";
                    if (!String.IsNullOrEmpty(dialog.Package)) package = dialog.Package;
                    SamTreeNode rootNode = new SamTreeNode(package, PROJECT_ICON);
                    SamTreeNode frameNode = new SamTreeNode("Frame #0", FRAME_ICON);
                    rootNode.Nodes.Add(frameNode);
                    rootNode.File = dialog.ResourceFilePath;
                    //SamTreeNode, String, String, Boolean, Boolean, String
                    String generated = this.GenerateFromFolder(frameNode, dialog.ResourceFolder,
                        dialog.Filer, dialog.Recursive, dialog.GenerateComposites, 
                        Path.GetDirectoryName(dialog.ResourceFilePath));
                    Int32 index = template.IndexOf("$(EntryPoint)");
                    Int32 indexOfNL = index - 1;
                    String pad = "\n";
                    if (index > -1)
                    {
                        while (template[indexOfNL] != '\r' && template[indexOfNL] != '\n')
                        {
                            indexOfNL--;
                            pad += '\t';
                        }
                    }
                    generated = generated.Replace("\n", pad);
                    template = template.Replace("$(EntryPoint)", generated);
                }
                else template = template.Replace("$(EntryPoint)", "");
                using (StreamWriter file = new StreamWriter(dialog.ResourceFilePath))
                {
                    file.Write(template);
                    file.Close();
                }
                Globals.MainForm.OpenEditableDocument(dialog.ResourceFilePath, false);
                this.pluginMain.AddConfigFiles(new String[] { dialog.ResourceFilePath });
                
            }
        }

        private void refreshButton_ClickHandler(Object sender, EventArgs e)
        {
            this.RefreshData();
        }

        private void treeView_NodeMouseClickHandler(Object sender, TreeNodeMouseClickEventArgs e)
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
                    case ResourceNodeType.Font:
                        this.fontMenu.Show(this.treeView, e.Location);
                        break;
                    default:
                        this.resourceMenu.Show(this.treeView, e.Location);
                        break;
                }
            }
            else
            {
                SamTreeNode currentNode = this.treeView.GetNodeAt(e.Location) as SamTreeNode;
                this.treeView.SelectedNode = currentNode;
                switch (currentNode.ResourceType)
                {
                    case ResourceNodeType.Root:
                        break;
                    case ResourceNodeType.Frame:
                        break;
                    case ResourceNodeType.Compose:
                        break;
                    case ResourceNodeType.Binary:
                        break;
                    case ResourceNodeType.Font:
                        this.PreviewFontContent(currentNode);
                        break;
                    case ResourceNodeType.Sound:
                        this.PreviewMp3Content(currentNode);
                        break;
                    case ResourceNodeType.Swf:
                        this.PreviewSWFContent(currentNode);
                        break;
                    case ResourceNodeType.Image:
                        this.PreviewImageContent(currentNode);
                        break;
                }
            }
        }

        private void treeView_NodeMouseDoubleClickHandler(Object sender, TreeNodeMouseClickEventArgs e)
        {
            this.RunTarget();
        }

        #endregion
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


