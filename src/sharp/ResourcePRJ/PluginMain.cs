using System;
using System.IO;
using System.Drawing;
using System.Windows.Forms;
using System.Text;
using System.ComponentModel;
using WeifenLuo.WinFormsUI.Docking;
using ResourcePRJ.Resources;
using PluginCore.Localization;
using PluginCore.Utilities;
using PluginCore.Managers;
using PluginCore.Helpers;
using PluginCore;
using System.Text.RegularExpressions;
using ProjectManager;
using ProjectManager.Helpers;
using ResourcePRJ.Enums;
using Associations;

namespace ResourcePRJ
{
	public class PluginMain : IPlugin
	{
        private String pluginName = "ResourcePRJ";
        private String pluginGuid = "8e2e47fb-eb2f-4544-9aa2-efee0fb13393";
        private String pluginHelp = "www.flashdevelop.org/community/";
        private String pluginDesc = "Creates a project for managing SWF assets.";
        private String pluginAuth = "Oleg Sivokon";

        private String settingFilename;
        private Settings settingObject;
        private String projectRoot;
        private String rsxRoot;
        private String templatesRoot;

        private DockContent pluginPanel;
        private PluginUI pluginUI;
        //private Image pluginImage;

        private ToolStripMenuItem projectToolMenuItem;
        private RSXProject project;

	    #region Required Properties

        /// <summary>
        /// Name of the plugin
        /// </summary> 
        public String Name
		{
			get { return this.pluginName; }
		}

        /// <summary>
        /// GUID of the plugin
        /// </summary>
        public String Guid
		{
			get { return this.pluginGuid; }
		}

        /// <summary>
        /// Author of the plugin
        /// </summary> 
        public String Author
		{
			get { return this.pluginAuth; }
		}

        /// <summary>
        /// Description of the plugin
        /// </summary> 
        public String Description
		{
			get { return this.pluginDesc; }
		}

        /// <summary>
        /// Web address for help
        /// </summary> 
        public String Help
		{
			get { return this.pluginHelp; }
		}

        /// <summary>
        /// Object that contains the settings
        /// </summary>
        [Browsable(false)]
        public Object Settings
        {
            get { return this.settingObject; }
        }
		
		#endregion
		
		#region Required Methods
		
		/// <summary>
		/// Initializes the plugin
		/// </summary>
		public void Initialize()
		{
            this.InitBasics();
            this.LoadSettings();
            this.AddEventHandlers();
            this.InitLocalization();
            this.CreatePluginPanel();
            this.CreateMenuItem();
        }
		
		/// <summary>
		/// Disposes the plugin
		/// </summary>
		public void Dispose()
		{
            this.SaveSettings();
		}
		
		/// <summary>
		/// Handles the incoming events
		/// </summary>
		public void HandleEvent(Object sender, NotifyEvent e, HandlingPriority prority)
		{
            //string docName = PluginBase.MainForm.CurrentDocument.ToString();
            //if (!isASDocument.IsMatch(docName)) saveHTML.Enabled = false;
            //else saveHTML.Enabled = true;
            //TabbedDocument document = (TabbedDocument)PluginBase.MainForm.CurrentDocument;
            //if (PluginBase.MainForm.EditorMenu == null) return;
            //if (this.copyHTMLItem == null)
            //{
            //    this.copyHTMLItem = new ToolStripMenuItem("Copy as HTML", 
            //                               null, 
            //                               new EventHandler(this.CopyAsHTML),
            //                               this.settingObject.CopyHTMLShortcut);
            //    PluginBase.MainForm.EditorMenu.Items.Add(this.copyHTMLItem);
            //    PluginBase.MainForm.IgnoredKeys.Add(this.settingObject.CopyHTMLShortcut);
            //}
            //switch (e.Type)
            //{
            //    case EventType.FileClose:
            //        break;
            //    case EventType.FileNew:
            //        break;
            //    case EventType.FileOpen:
            //        break;
            //    case EventType.FileSwitch:
            //        break;
            //}
		}

		#endregion

        #region Custom Methods

        /// <summary>
        /// Initializes important variables
        /// </summary>
        public void InitBasics()
        {
            String dataPath = Path.Combine(PathHelper.DataDir, "ResourcePRJ");
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            this.settingFilename = Path.Combine(dataPath, "Settings.fdb");
            ProjectCreator.AppendProjectType("project.as3rsx", typeof(RSXProject));
            
        }

        public void InstallTemplates(String where)
        {
            Directory.CreateDirectory(where);
            StreamWriter sw = File.CreateText(Path.Combine(where, "img.mxml"));
            sw.Write(TemplateGenerator.ImgTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "snd.mxml"));
            sw.Write(TemplateGenerator.SndTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "fnt.mxml"));
            sw.Write(TemplateGenerator.FntTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "swf.mxml"));
            sw.Write(TemplateGenerator.SwfTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "svg.mxml"));
            sw.Write(TemplateGenerator.SvgTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "fxg.mxml"));
            sw.Write(TemplateGenerator.FxgTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "txt.mxml"));
            sw.Write(TemplateGenerator.TxtTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "bin.mxml"));
            sw.Write(TemplateGenerator.BinTemplate);
            sw.Close();
            sw = File.CreateText(Path.Combine(where, "snd.mxml"));
            sw.Write(TemplateGenerator.SndTemplate);
            sw.Close();

            sw = File.CreateText(Path.Combine(where, "assets.mxml"));
            sw.Write(TemplateGenerator.ProjectTemplate);
            sw.Close();
        }

        public void CreateAssociation()
        {
            AF_FileAssociator assoc = new AF_FileAssociator(".as3rsx");

            FileInfo icon = new FileInfo(Path.Combine(PathHelper.AppDir, "rsx.ico"));
            Console.WriteLine("CreateAssociation " + icon.FullName);
            if (!icon.Exists)
            {
                object ico = LocaleHelper.GetResource("RSXPluginIcon");
                Console.WriteLine("Trying to find an icon " + ico);
                Icon pluginIcon = (Icon)LocaleHelper.GetResource("RSXPluginIcon");
                Console.WriteLine("Icon file found " + pluginIcon);
                pluginIcon.Save(File.Open(icon.FullName, FileMode.Create));
            }
            assoc.Create("FlashDevelop",
                "Resource Project for AS3",
                new ProgramIcon(icon.FullName),
                new ExecApplication(Path.Combine(PathHelper.AppDir, "FlashDevelop.exe")),
                new OpenWithList(new string[] { "FlashDevelop" }));
        }

        /// <summary>
        /// Adds the required event handlers
        /// </summary> 
        public void AddEventHandlers()
        {
            // Set events you want to listen (combine as flags)
            EventManager.AddEventHandler(this, EventType.FileClose | 
                                                EventType.FileNew | 
                                                EventType.FileOpen |
                                                EventType.FileSwitch);
        }

        /// <summary>
        /// Initializes the localization of the plugin
        /// </summary>
        public void InitLocalization()
        {
            LocaleVersion locale = PluginBase.MainForm.Settings.LocaleVersion;
            switch (locale)
            {
                /*
                case LocaleVersion.fi_FI : 
                    // We have Finnish available... or not. :)
                    LocaleHelper.Initialize(LocaleVersion.fi_FI);
                    break;
                */
                default : 
                    // Plugins should default to English...
                    LocaleHelper.Initialize(LocaleVersion.en_US);
                    break;
            }
            this.pluginDesc = LocaleHelper.GetString("Info.Description");
            // TODO: test
            try
            {
                this.CreateAssociation();
            }
            catch (Exception e)
            {
                Console.Write(e.Message);
            }
        }

        /// <summary>
        /// Creates a menu item for the plugin and adds a ignored key
        /// </summary>
        public void CreateMenuItem()
        {
            ToolStripMenuItem fileMenu = (ToolStripMenuItem)PluginBase.MainForm.FindMenuItem("FileMenu");
            this.projectToolMenuItem = new ToolStripMenuItem(LocaleHelper.GetString("Label.FileMenuItem"),
                                                            null, //this.pluginImage
                                                            new EventHandler(this.CreateNewProject));
            fileMenu.DropDownItems.Insert(3, this.projectToolMenuItem);
        }

        /// <summary>
        /// Creates a plugin panel for the plugin
        /// </summary>
        public void CreateNewProject(Object sender, System.EventArgs e)
        {
            SaveFileDialog dialog = new SaveFileDialog();
            dialog.DefaultExt = "as3rsx";
            dialog.Filter = "AS3 Resource Project (*.as3rsx)|*.as3rsx";
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                Console.WriteLine(dialog.FileName);
                if (dialog.FileName != "")
                {
                    String template = (String)TemplateGenerator.ProjectSettings.Clone();
                    FileInfo fi = new FileInfo(@dialog.FileName);
                    FileStream fs = fi.OpenWrite();
                    fs.WriteByte(0xEF);
                    fs.WriteByte(0xBB);
                    fs.WriteByte(0xBF);
                    UTF8Encoding enc = new UTF8Encoding();
                    byte[] bytes = enc.GetBytes(template);
                    fs.Write(bytes, 0, bytes.Length);
                    fs.Close();
                    DirectoryInfo di = new DirectoryInfo(Path.Combine(fi.Directory.FullName, "rsx"));
                    if (!di.Exists)
                    {
                        try
                        {
                            di.Create();
                        }
                        catch
                        {
                            Console.WriteLine("Failed to create project folder");
                            // TODO: Need an alert here
                            return;
                        }
                    }
                    fi = new FileInfo(Path.Combine(di.FullName, "Assets.mxml"));
                    if (!fi.Exists)
                    {
                        fs = fi.OpenWrite();
                        template = (String)TemplateGenerator.ProjectTemplate.Clone();
                        bytes = enc.GetBytes(template);
                        fs.Write(bytes, 0, bytes.Length);
                        fs.Close();
                    }
                    project = new RSXProject(di.FullName);
                    ProjectManager.PluginMain pm = (ProjectManager.PluginMain)PluginBase.MainForm.FindPlugin("30018864-fadd-1122-b2a5-779832cbbf23");
                    //ProjectManager.Projects.AS3.AS3Project
                }
            }
        }

        public void AddFiles(string[] files, AssetTypes ofType)
        {
            FileInfo fi;
            string generatedName;
            foreach (string n in files)
            {
                try
                {
                    fi = new FileInfo(n);
                    Console.WriteLine("fi " + fi);
                    generatedName = TemplateGenerator.AddFile(new FileInfo(n),
                        AssetTypes.Img, this.project.GetAssetPath(ofType));
                    TemplateGenerator.AddEntry(generatedName,
                        TemplateGenerator.GetDefaultPrefix(ofType),
                        TemplateGenerator.GetDefaultURI(ofType),
                        new FileInfo(this.project.Directory + 
                            Path.DirectorySeparatorChar + 
                            this.project.CompileTargets[0]), 0);
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.StackTrace);
                }
            }
        }

        public void EnableProjectView(RSXProject pr)
        {
            if (this.pluginUI == null) CreatePluginPanel();
            this.project = pr;
            this.pluginUI.Project = pr;
        }

        public void CreatePluginPanel()
        {
            this.pluginUI = new PluginUI(this);
            this.pluginUI.Text = LocaleHelper.GetString("Title.PluginPanel");
            this.pluginPanel = PluginBase.MainForm.CreateDockablePanel(this.pluginUI,
                                                                        this.pluginGuid,
                                                                        null, //this.pluginImage,
                                                                        DockState.DockRight);
        }

        /// <summary>
        /// Loads the plugin settings
        /// </summary>
        public void LoadSettings()
        {
            this.settingObject = new Settings();
            this.SaveSettings();
            if (!File.Exists(this.settingFilename)) this.SaveSettings();
            else
            {
                object obj = ObjectSerializer.Deserialize(this.settingFilename, this.settingObject);
                this.settingObject = (Settings)obj;
            }
            String dataPath = Path.Combine(PathHelper.UserAppDir, this.settingObject.ProjectRoot);
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            this.projectRoot = dataPath;
            dataPath = Path.Combine(PathHelper.TemplateDir, "rsx-templates");
            if (!Directory.Exists(dataPath)) this.InstallTemplates(dataPath);
            this.templatesRoot = dataPath;
            this.rsxRoot = Path.Combine(PathHelper.UserAppDir, "lib");
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
        }

        /// <summary>
        /// Saves the plugin settings
        /// </summary>
        public void SaveSettings()
        {
            ObjectSerializer.Serialize(this.settingFilename, this.settingObject);
        }

        /// <summary>
        /// Opens the plugin panel if closed
        /// </summary>
        public void OpenFileSaveDialog(Object sender, System.EventArgs e)
        {
            //if (saveHTML != null && saveHTML.Enabled)
            //{
            //    string fileContents = PluginBase.MainForm.CurrentDocument.SciControl.Text;
            //    SaveFileDialog fileDialog = new SaveFileDialog();
            //    fileDialog.DefaultExt = "html";
            //    fileDialog.Filter = "HTML Files (*.html)|*.html";
            //    fileDialog.FileName = isASDocument.Replace(PluginBase.MainForm.CurrentDocument.FileName, ".html");
            //    if (fileDialog.ShowDialog() == DialogResult.OK)
            //    {
            //        Console.WriteLine(fileDialog.FileName);
            //        string all;
            //        try
            //        {
            //            AS3CodeParser.Settings = this.settingObject;
            //            all = AS3CodeParser.ParseAS3Code(fileContents);
            //        }
            //        catch (Exception ex)
            //        {
            //            MessageBox.Show(null, "ExportHTML unable to parse: " + ex.Message, "Error");
            //            all = "";
            //        }
            //        if (fileDialog.FileName != "" && all != "")
            //        {
            //            FileInfo fi = new FileInfo(@fileDialog.FileName);
            //            FileStream fs = fi.OpenWrite();
            //            fs.WriteByte(0xEF);
            //            fs.WriteByte(0xBB);
            //            fs.WriteByte(0xBF);
            //            System.Text.UTF8Encoding enc = new System.Text.UTF8Encoding();
            //            byte[] bytes = enc.GetBytes(all);
            //            fs.Write(bytes, 0, bytes.Length);
            //            fs.Close();
            //        }
            //    }
            //}
        }

		#endregion

	}

}
