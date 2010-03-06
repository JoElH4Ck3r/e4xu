using System;
using System.IO;
using System.Drawing;
using System.Windows.Forms;
using System.Text;
using System.ComponentModel;
using WeifenLuo.WinFormsUI.Docking;
using NFXContext.Resources;
using PluginCore.Localization;
using PluginCore.Utilities;
using PluginCore.Managers;
using PluginCore.Helpers;
using PluginCore;
using System.Text.RegularExpressions;
using ProjectManager;
using ProjectManager.Helpers;
using NFXContext.Enums;
using Associations;
using NFXContext.TemplateShell;
using System.Collections;
using NFXContext.Mapping;

namespace NFXContext
{
	public class PluginMain : IPlugin
	{
        private String pluginName = "NFXContext";
        private String pluginGuid = "5ecb91e0-3e1e-4998-aaee-a46a270e5df8";
        private String pluginHelp = "www.flashdevelop.org/community/";
        private String pluginDesc = "Creates a project for managing SWF assets.";
        private String pluginAuth = "Oleg Sivokon";

        private String settingFilename;
        private Settings settingObject;
        //private String projectRoot;
        //private String nsxRoot;
        private ASCompletion.Context.IASContext context;
        private String preprocessorLocation;
        private ProjectManager.PluginMain projectManager;

        private DockContent pluginPanel;
        private PluginUI pluginUI;
        //private Image pluginImage;

        private ToolStripMenuItem projectToolMenuItem;
        private NFXProject project;
        private ProjectManager.Projects.Project asproject;

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
        public void HandleEvent(object sender, NotifyEvent e, HandlingPriority priority)
        {
            TextEvent te = e as TextEvent;
            DataEvent de = e as DataEvent;
            ITabbedDocument document = PluginBase.MainForm.CurrentDocument;
            //BxmlDesigner designer = document != null && designers.ContainsKey(document) ? designers[document] : null;

            //if (e.Type == EventType.Command && de.Action == ProjectManagerEvents.FileMapping)
            //{
            //    ProjectFileMapper.Map((FileMappingRequest)de.Data);
            //    return;
            //}

            // our first priority is getting a non-null Project, otherwise
            // we can't do anything
            
            if (e.Type == EventType.Command && de.Action == ProjectManagerEvents.Project)
            {
                // the projectexplorer plugin is telling us what project we're working with
                this.asproject = de.Data as ProjectManager.Projects.Project;
                Console.WriteLine("We found a project " + this.asproject + " : " + de.Data + " : " + (de.Data is ProjectManager.Projects.Project));
                //return;
            }
            
            // we need a project and context to handle these events
            if (e.Type == EventType.FileOpen)
            {
                if (this.IsNfxMxml(document))
                {
                    Console.WriteLine("MXML file opened");
                //    PluginBase.MainForm.CallCommand("ChangeSyntax", "xml");

                //    var timer = new Timer { Interval = 1, Enabled = true };
                //    timer.Tick += (o, evt) =>
                //    {
                //        timer.Enabled = false;

                // create the design surface
                //if (GetProjectAndContext())
                //{
                //    if (project.AbsoluteClasspaths.GetClosestParent(document.FileName) != null)
                //    {
                //        designer = new BxmlDesigner(document, project, GetDesignerSwfPath());
                //        designers.Add(document, designer);
                //        //Compile(document, designer);
                //    }
                //    else
                //        SendErrorToResults(document.FileName, "Cannot design this file because the classpath could not be determined.");
                //}
                //else SendErrorToResults(document.FileName, "Could not start up the Bent Designer - no project loaded or AS3 completion plugin not loaded.");
                //    };
                }
            }
            else if (e.Type == EventType.FileClose)
            {
                Console.WriteLine("MXML file closed");
                // TODO: Recompile code behind here
                //if (designers.ContainsKey(document))
                //    designers.Remove(document);
            }
            else if (e.Type == EventType.Command)
            {
                switch (de.Action)
                {
                    case ProjectManagerEvents.BuildComplete:

                        // TODO: Not sure we need this
                        //if (!GetProjectAndContext()) return;
                        //if (!File.Exists(project.OutputPathAbsolute)) return;
                        //if (!CheckIsBentApplication()) return;

                        //BuildDesignerSwf();

                        //foreach (BxmlDesigner d in designers.Values)
                        //    d.SwfOutdated = true;

                        //if (designer != null)
                        //    designer.ReloadSwf();

                        break;

                    case "XMLCompletion.Element":

                        // TODO: Not yet...
                        //if (!IsBxml(document) || !GetProjectAndContext()) return;
                        //if (designer == null) return;

                        ////DateTime started = DateTime.Now;
                        //completion.HandleElement(designer, (XMLContextTag)de.Data);
                        //TraceManager.Add("Took " + (DateTime.Now - started).TotalMilliseconds + "ms.");
                        //e.Handled = true;
                        break;

                    case "XMLCompletion.CloseElement":

                        // TODO: We would try to rely on FD own autocompletion better...
                        //if (!IsBxml(document) || !GetProjectAndContext()) return;
                        //if (designer == null) return;

                        //string ending = completion.HandleCloseElement(designer, (XMLContextTag)de.Data);
                        //if (ending != null)
                        //{
                        //    if (ending != ">")
                        //    {
                        //        ScintillaNet.ScintillaControl sci = document.SciControl;
                        //        int position = sci.CurrentPos;
                        //        sci.SetSel(position - 1, position);
                        //        sci.ReplaceSel(ending);
                        //        sci.SetSel(position + 1, position + 1);
                        //    }
                        //    e.Handled = true;
                        //}

                        break;

                    case "XMLCompletion.Attribute":

                        // TODO: We would try to rely on FD own autocompletion better...
                        //if (!IsBxml(document) || !GetProjectAndContext()) return;
                        //if (designer == null) return;

                        //object[] o = de.Data as object[];
                        ////started = DateTime.Now;
                        //completion.HandleAttribute(designer, (XMLContextTag)o[0], o[1] as string);
                        ////TraceManager.Add("Took " + (DateTime.Now - started).TotalMilliseconds + "ms.");
                        //e.Handled = true;
                        break;
                }
            }
            else if (e.Type == EventType.FileSave)
            {
                Console.WriteLine("MXML file saved " + document.FileName);
                if (String.IsNullOrEmpty(this.preprocessorLocation))
                {
                    OpenFileDialog dialog = new OpenFileDialog();
                    dialog.CheckFileExists = true;
                    dialog.Filter = "JAR files (*.jar)|*.jar";
                    DialogResult dr = dialog.ShowDialog();
                    if (dr == DialogResult.OK)
                    {
                        this.preprocessorLocation =
                            this.settingObject.ParserPath = dialog.FileNames[0];
                    }
                    else return;
                }
                Hashtable ht = new Hashtable();
                ht.Add("-source", document.FileName);
                ht.Add("-output", document.FileName.Replace(".mxml", ".swf"));
                PluginCore.Managers.EventManager.DispatchEvent(
                    this, new DataEvent(EventType.Command, "ResultsPanel.ClearResults", null));
                NFXShell.Run(new FileInfo(document.FileName), this.preprocessorLocation, null, ht);
                this.context = ASCompletion.Context.ASContext.GetLanguageContext("as3");
                // TODO: we should only handle our projects
                // TODO: not really sure this will be needed as those files should be picked up by ASCompletion anyway.
                //string classpath = this.project.AbsoluteClasspaths.GetClosestParent(document.FileName);
                string classpath = this.asproject.AbsoluteClasspaths.GetClosestParent(document.FileName);
                Console.WriteLine("Our classpath: " + classpath);
                ASCompletion.Model.PathModel pathModel = 
                    context.Classpath.Find(pm => pm.Path == classpath);
                this.TellASCompletionAbout(document.FileName, pathModel);
            }
            else if (e.Type == EventType.FileSwitch)
            {
                // TODO: think we don't need this
                //if (!GetProjectAndContext()) return;

                //// if this flash is marked as "dirty" we'll need to reload it
                //if (designer != null && designer.SwfOutdated)
                //    designer.ReloadSwf();
            }
            else if (e.Type == EventType.UIStarted)
            {
                // TODO: Not sure what this does... we'll see later
                this.projectManager =
                        (ProjectManager.PluginMain)PluginBase.MainForm.FindPlugin(
                        "30018864-fadd-1122-b2a5-779832cbbf23");
                System.Reflection.MethodInfo mi = typeof(NFXNode).GetMethod("Create");
                ProjectManager.Controls.TreeView.FileNode.FileAssociations.Add(".nxml", mi);
                //Timer timer = new Timer();
                //timer.Interval = 100;
                //timer.Tick += delegate { GetProjectAndContext(); timer.Stop(); };
                //timer.Start();
            }
        }

		#endregion

        #region Custom Methods

        private void TellASCompletionAbout(string compiledFile, ASCompletion.Model.PathModel pathModel)
        {
            if (!pathModel.HasFile(compiledFile))
            {
                // force ASCompletion to parse this file and add it to the classpath's model
                pathModel.AddFile(this.context.GetFileModel(compiledFile));
            }
            else
            {
                // force ASCompletion to recheck this file it already knows about
                ASCompletion.Model.FileModel fileModel = pathModel.GetFile(compiledFile);
                fileModel.OutOfDate = true;
                fileModel.Check();
            }
        }

        /// <summary>
        /// Initializes important variables
        /// </summary>
        public void InitBasics()
        {
            String dataPath = Path.Combine(PathHelper.DataDir, "NFXContext");
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            this.settingFilename = Path.Combine(dataPath, "Settings.fdb");
            ProjectCreator.AppendProjectType("project.as3nfx", typeof(NFXProject));
        }

        public void CreateAssociation()
        {
            AF_FileAssociator assoc = new AF_FileAssociator(".as3nfx");

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
                "NFX Template Project for AS3",
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
            EventManager.AddEventHandler(this, EventType.FileOpen
                                            | EventType.FileSwitch
                                            | EventType.Command
                                            | EventType.FileSave
                                            | EventType.FileClose
                                            | EventType.UIStarted);
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
            dialog.DefaultExt = "as3nfx";
            dialog.Filter = "AS3 NFX Template Project (*.as3nfx)|*.as3nfx";
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                Console.WriteLine(dialog.FileName);
                if (dialog.FileName != "")
                {
                    //String template = (String)TemplateGenerator.ProjectSettings.Clone();
                    FileInfo fi = new FileInfo(@dialog.FileName);
                    //FileStream fs = fi.OpenWrite();
                    //fs.WriteByte(0xEF);
                    //fs.WriteByte(0xBB);
                    //fs.WriteByte(0xBF);
                    //UTF8Encoding enc = new UTF8Encoding();
                    //byte[] bytes = enc.GetBytes(template);
                    //fs.Write(bytes, 0, bytes.Length);
                    //fs.Close();
                    DirectoryInfo di = new DirectoryInfo(Path.Combine(fi.Directory.FullName, "nfx"));
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
                    //fi = new FileInfo(Path.Combine(di.FullName, "Assets.mxml"));
                    //if (!fi.Exists)
                    //{
                        //fs = fi.OpenWrite();
                        //template = (String)TemplateGenerator.ProjectTemplate.Clone();
                        //bytes = enc.GetBytes(template);
                        //fs.Write(bytes, 0, bytes.Length);
                        //fs.Close();
                    //}
                    project = new NFXProject(di.FullName);
                }
            }
        }

        public Boolean IsNfxMxml(ITabbedDocument document)
        {
            string path = document.FileName;
            // TODO: I think we should use a different extension...
            return (path != null && Path.GetExtension(path).ToLower() == ".mxml");
        }

        public void AddFiles(string[] files, AssetTypes ofType)
        {
            /*FileInfo fi;
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
            }*/
        }

        public void EnableProjectView(NFXProject pr)
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
            this.preprocessorLocation = this.settingObject.ParserPath;
            //String dataPath = Path.Combine(PathHelper.UserAppDir, this.settingObject.ParserPath);
            //if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            //this.projectRoot = dataPath;
            //dataPath = Path.Combine(PathHelper.TemplateDir, "rsx-templates");
            ////if (!Directory.Exists(dataPath)) this.InstallTemplates(dataPath);
            //this.preprocessorLocation = dataPath;
            //this.nsxRoot = Path.Combine(PathHelper.UserAppDir, "lib");
            //if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
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
