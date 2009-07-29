using System;
using System.IO;
using System.Drawing;
using System.Windows.Forms;
using System.ComponentModel;
using WeifenLuo.WinFormsUI.Docking;
using ExportHTML.Resources;
using PluginCore.Localization;
using PluginCore.Utilities;
using PluginCore.Managers;
using PluginCore.Helpers;
using PluginCore;
using System.Text.RegularExpressions;

namespace ExportHTML
{
	public class PluginMain : IPlugin
	{
        private String pluginName = "ExportHTML";
        private String pluginGuid = "36325fe8-78ea-422e-b25c-6570614a704d";
        private String pluginHelp = "www.flashdevelop.org/community/";
        private String pluginDesc = "Exports and saves AS3 code in HTML.";
        private String pluginAuth = "Oleg Sivokon";
        private String settingFilename;
        private Settings settingObject;
        //private DockContent pluginPanel;
        //private PluginUI pluginUI;
        //private Image pluginImage;

        private ToolStripMenuItem saveHTML;
        private Regex isASDocument = new Regex("\\.as$", RegexOptions.Compiled);

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
            string docName = PluginBase.MainForm.CurrentDocument.ToString();
            if (!isASDocument.IsMatch(docName)) saveHTML.Enabled = false;
            else saveHTML.Enabled = true;
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
            String dataPath = Path.Combine(PathHelper.DataDir, "ExportHTML");
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            this.settingFilename = Path.Combine(dataPath, "Settings.fdb");
            //this.pluginImage = PluginBase.MainForm.FindImage("50");
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
        }

        /// <summary>
        /// Creates a menu item for the plugin and adds a ignored key
        /// </summary>
        public void CreateMenuItem()
        {
            ToolStripMenuItem fileMenu = (ToolStripMenuItem)PluginBase.MainForm.FindMenuItem("FileMenu");
            saveHTML = new ToolStripMenuItem(LocaleHelper.GetString("Label.FileMenuItem"),
                                                            null, //this.pluginImage
                                                            new EventHandler(this.OpenFileSaveDialog),
                                                            this.settingObject.MenuShortcut);
            fileMenu.DropDownItems.Insert(8, saveHTML);
            if (PluginBase.MainForm.CurrentDocument != null)
            {
                string docName = PluginBase.MainForm.CurrentDocument.ToString();
                if (!isASDocument.IsMatch(docName)) saveHTML.Enabled = false;
            }
            else saveHTML.Enabled = true;
            PluginBase.MainForm.IgnoredKeys.Add(this.settingObject.MenuShortcut);
        }

        /// <summary>
        /// Creates a plugin panel for the plugin
        /// </summary>
        public void CreatePluginPanel()
        {
            if (saveHTML != null && saveHTML.Enabled)
            {
                string fileContents = PluginBase.MainForm.CurrentDocument.Text;
                SaveFileDialog fileDialog = new SaveFileDialog();
                fileDialog.DefaultExt = "as";
                fileDialog.FileName = PluginBase.MainForm.CurrentDocument.ToString() + ".html";
            }
            //this.pluginUI = new PluginUI(this);
            //this.pluginUI.Text = LocaleHelper.GetString("Title.PluginPanel");
            //this.pluginPanel = PluginBase.MainForm.CreateDockablePanel(this.pluginUI,
            //                                                            this.pluginGuid, 
            //                                                            this.pluginImage, 
            //                                                            DockState.DockRight);
        }

        /// <summary>
        /// Loads the plugin settings
        /// </summary>
        public void LoadSettings()
        {
            this.settingObject = new Settings();
            //this.SaveSettings();
            if (!File.Exists(this.settingFilename)) this.SaveSettings();
            else
            {
                Object obj = ObjectSerializer.Deserialize(this.settingFilename, this.settingObject);
                this.settingObject = (Settings)obj;
            }
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
            if (saveHTML != null && saveHTML.Enabled)
            {
                string fileContents = PluginBase.MainForm.CurrentDocument.SciControl.Text;
                SaveFileDialog fileDialog = new SaveFileDialog();
                fileDialog.DefaultExt = "html";
                fileDialog.Filter = "HTML Files (*.html)|*.html";
                fileDialog.FileName = isASDocument.Replace(PluginBase.MainForm.CurrentDocument.FileName, ".html");
                if (fileDialog.ShowDialog() == DialogResult.OK)
                {
                    Console.WriteLine(fileDialog.FileName);
                    string all;
                    try
                    {
                        AS3CodeParser.Settings = this.settingObject;
                        all = AS3CodeParser.ParseAS3Code(fileContents);
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(null, "ExportHTML unable to parse: " + ex.Message, "Error");
                        all = "";
                    }
                    if (fileDialog.FileName != "" && all != "")
                    {
                        FileInfo fi = new FileInfo(@fileDialog.FileName);
                        FileStream fs = fi.OpenWrite();
                        fs.WriteByte(0xEF);
                        fs.WriteByte(0xBB);
                        fs.WriteByte(0xBF);
                        System.Text.UTF8Encoding enc = new System.Text.UTF8Encoding();
                        byte[] bytes = enc.GetBytes(all);
                        fs.Write(bytes, 0, bytes.Length);
                        fs.Close();
                    }
                }
            }
        }

		#endregion

	}
	
}
