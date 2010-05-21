using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Windows.Forms;
using FlashDevelop.Docking;
using SamHaXePanel.Resources;
using PluginCore;
using PluginCore.Controls;
using PluginCore.Helpers;
using PluginCore.Localization;
using PluginCore.Managers;
using PluginCore.Utilities;
using ScintillaNet;
using System.Text.RegularExpressions;
using WeifenLuo.WinFormsUI.Docking;
using System.Drawing;
using FlashDevelop;
using ProjectManager.Projects;
using System.Text;

namespace SamHaXePanel
{
    public enum ResourceNodeType
    {
        Root,
        Image,
        Binary,
        Sound,
        Compose,
        Frame,
        Font,
        Swf
    }
	public class PluginMain : IPlugin
	{
        private String pluginName = "SamHaXePanel";
        private String pluginGuid = "f0ad336d-11cc-4be5-b8b0-0d6557e78816";
        private String pluginHelp = "www.flashdevelop.org/community/";
        private String pluginDesc = "GUI for the SamHaXe resource management tool";
        private String pluginAuth = "Oleg Sivokon";
        private String settingFilename;
        private Settings settingObject;

        private const String STORAGE_FILE_NAME = "samHaxePluginData.txt";
        private Regex notAllowed = new Regex("[\\x00-\\x1F\\*\\?%\"<>\\x7F]", RegexOptions.Compiled);
        private PluginUI pluginUI;
        private DockContent pluginPanel;
        private Image pluginImage;
        private List<String> configFilesList;
        private Dictionary<String, SamSettings> buildSettings;
        private String player;

        public List<String> ConfigFilesList
        {
            get { return this.configFilesList; }
        }

        public String MP3Player
        {
            get { return this.player; }
        }

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
            if (e.Type == EventType.Command)
            {
                string cmd = (e as DataEvent).Action;
                if (cmd == "ProjectManager.Project")
                {
                    if (PluginBase.CurrentProject != null)
                        this.ReadConfigFiles();
                    this.pluginUI.RefreshData();
                }
            }
		}

		#endregion

        #region Custom Methods

        /// <summary>
        /// Initializes important variables
        /// </summary>
        public void InitBasics()
        {
            String dataPath = Path.Combine(PathHelper.DataDir, "SamHaXePanel");
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            this.settingFilename = Path.Combine(dataPath, "Settings.fdb");
        }

        /// <summary>
        /// Adds the required event handlers
        /// </summary> 
        public void AddEventHandlers()
        {
            EventManager.AddEventHandler(this, EventType.Command);
        }

        /// <summary>
        /// Initializes the localization of the plugin
        /// </summary>
        public void InitLocalization()
        {
            LocaleVersion locale = PluginBase.MainForm.Settings.LocaleVersion;
            switch (locale)
            {
                default :
                    LocaleHelper.Initialize(LocaleVersion.en_US);
                    break;
            }
            this.pluginDesc = LocaleHelper.GetString("Info.Description");
            this.pluginImage = LocaleHelper.GetImage("SamIcon");
            this.InstallTemplates();
        }

        /// <summary>
        /// Creates a menu item for the plugin and adds a ignored key
        /// </summary>
        public void CreateMenuItem()
        {
            ToolStripMenuItem menu = (ToolStripMenuItem)PluginBase.MainForm.FindMenuItem("ViewMenu");
            ToolStripMenuItem menuItem = new ToolStripMenuItem("SamHaXe Panel",
                this.pluginImage, new EventHandler(ShowSamPanel));
            menu.DropDownItems.Add(menuItem);
        }

        /// <summary>
        /// Creates a plugin panel for the plugin
        /// </summary>
        public void CreatePluginPanel()
        {
            this.pluginUI = new PluginUI(this);
            this.pluginUI.Text = "SamHaXe";
            this.pluginUI.StartDragHandling();
            this.pluginUI.StartDragHandling();
            this.pluginPanel = PluginBase.MainForm.CreateDockablePanel(
                this.pluginUI, this.pluginGuid, this.pluginImage, DockState.DockRight);
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

        private void InstallTemplates()
        {
            Byte[] b = LocaleHelper.GetFile("SamTemplate0");
            String templatePath = Path.Combine(
                Path.Combine(ProjectPaths.FileTemplatesDirectory, "HaxeProject"), "Resources.xml.fdt");
            String template = UTF8Encoding.Default.GetString(b);
            if (!File.Exists(templatePath))
            {
                using (StreamWriter file = new StreamWriter(templatePath))
                {
                    file.Write(template);
                    file.Close();
                }
            }
            templatePath = Path.Combine(
                Path.Combine(ProjectPaths.FileTemplatesDirectory, "AS3Project"), "Resources.xml.fdt");
            if (!File.Exists(templatePath))
            {
                using (StreamWriter file = new StreamWriter(templatePath))
                {
                    file.Write(template);
                    file.Close();
                }
            }
            String dataPath = Path.Combine(PathHelper.DataDir, "SamHaXePanel");
            if (Directory.Exists(dataPath))
            {
                Directory.CreateDirectory(dataPath);
            }
            this.player = Path.Combine(dataPath, "player.swf");
            b = LocaleHelper.GetFile("MP3Player");
            if (!File.Exists(this.player))
            {
                using (BinaryWriter binWriter =
                    new BinaryWriter(File.Open(this.player, FileMode.Create)))
                {
                    binWriter.Write(b);
                    binWriter.Close();
                }
            }
        }

        public void RunTarget(String file, SamSettings settings)
        {
            String command = this.settingObject.SamHome;
            // TODO: Put this into resources
            if (String.IsNullOrEmpty(command) || !File.Exists(command))
            {
                MessageBox.Show("Please set path to SamHaXe executable (F10 > SamHaXePanel > SamHome)");
                return;
            }
            if (settings == null || String.IsNullOrEmpty(settings.Output))
            {
                MessageBox.Show("Please specify output SWF (right click on the project icon > Configure > Output)");
                return;
            }
            String arguments = "";
            //Usage: SamHaXe [options] <resources.xml> <assets.swf>
            //options:
            //-c <config file name>, --config <config file name>
            //       If given, config is read from the specified file.
            //-d <file name>, --depfile <file name>
            //       If given, resource dependecies will be written into the specified file.
            //-h, --help
            //       Display this help message.
            //-l, --module-list
            //       List all import modules with a short description.
            //-m module:key=value[:key=value:...], --module-options module:key=value[:key=value:...]
            //       The specified options are passed to the specified import module. (Exaple: Binary:myopt=somevalue)
            //--module-help module[=interface_version[;flash_version]][:module[=interface_version[;flash_version]]...]
            //       Prints help message of listed modules.
            if (!String.IsNullOrEmpty(settings.Config))
                arguments += "-c \"" + settings.Config + "\" ";
            if (!String.IsNullOrEmpty(settings.Depfile))
                arguments += "-d \"" + settings.Depfile + "\" ";
            arguments += settings.Input + " \"" + settings.Output + "\"";

            Globals.MainForm.CallCommand("RunProcessCaptured", command + ";" + arguments);
        }

        private void ReadConfigFiles()
        {
            if (this.configFilesList == null)
                this.configFilesList = new List<String>();
            else this.configFilesList.Clear();
            String folder = GetConfigFilesStorageFolder();
            String fullName = Path.Combine(folder, STORAGE_FILE_NAME);
            this.buildSettings = new Dictionary<String, SamSettings>();
            Char argsSeparator = '?';
            String[] parts;

            if (File.Exists(fullName))
            {
                using (StreamReader file = new StreamReader(fullName))
                {
                    String line;
                    String argsLine = null;
                    while ((line = file.ReadLine()) != null)
                    {
                        if (line.IndexOf(argsSeparator) > -1)
                        {
                            parts = line.Split(new Char[1] { argsSeparator });
                            line = parts[0];
                            argsLine = parts[1];
                        }
                        if (line.Length > 0 && !this.configFilesList.Contains(line))
                        {
                            this.configFilesList.Add(line);
                            if (!String.IsNullOrEmpty(argsLine))
                            {
                                SamSettings s = this.BuildSamSettings(argsLine);
                                s.Input = line;
                                this.buildSettings[line] = s;
                            }
                        }
                    }
                    file.Close();
                }
            }
        }

        private SamSettings BuildSamSettings(String serialized)
        {
            Regex argsRe = new Regex("([^&=]+)=([^&]+)", RegexOptions.Compiled);
            MatchCollection mc = argsRe.Matches(serialized);
            int c = mc.Count;
            Match m;
            SamSettings settings = new SamSettings();
            GroupCollection gc;
            for (int i = 0; i < c; i++)
            {
                m = mc[i];
                gc = m.Groups;
                switch (gc[1].Value)
                {
                    case "-c":
                    case "--config":
                        settings.Config = gc[2].Value;
                        break;
                    case "-d":
                    case "--depfile":
                        settings.Depfile = gc[2].Value;
                        break;
                    case "output":
                        settings.Output = gc[2].Value;
                        break;
                }
            }
            return settings;
        }

        private void ShowSamPanel(object sender, EventArgs e)
        {
            this.pluginPanel.Show();
        }

        public void AddConfigFiles(String[] files)
        {
            foreach (String file in files)
            {
                if (!this.configFilesList.Contains(file))
                    this.configFilesList.Add(file);
            }
            this.SaveConfigFiles();
            this.pluginUI.RefreshData();
        }

        public void RemoveConfigFile(String file)
        {
            if (this.configFilesList.Contains(file))
                this.configFilesList.Remove(file);
            this.SaveConfigFiles();
            this.pluginUI.RefreshData();
        }

        public SamSettings SettingsForPath(String path)
        {
            if (this.buildSettings.ContainsKey(path))
                return this.buildSettings[path];
            SamSettings s = new SamSettings();
            s.Input = path;
            this.buildSettings[path] = s;
            return s;
        }

        public void UpdateSettings(String path, SamSettings setting)
        {
            this.buildSettings[path] = setting;
        }

        private String GetConfigFilesStorageFolder()
        {
            String projectFolder = Path.GetDirectoryName(
                PluginBase.CurrentProject.ProjectPath);
            return Path.Combine(projectFolder, "obj");
        }

        public void SaveConfigFiles()
        {
            String folder = this.GetConfigFilesStorageFolder();
            String fullName = Path.Combine(folder, STORAGE_FILE_NAME);
            if (!Directory.Exists(folder))
                Directory.CreateDirectory(folder);
            using (StreamWriter file = new StreamWriter(fullName))
            {
                foreach (String line in this.configFilesList)
                {
                    if (this.buildSettings.ContainsKey(line))
                    {
                        SamSettings s = this.buildSettings[line];
                        String fullLine = line;
                        fullLine += '?';
                        if (!String.IsNullOrEmpty(s.Config))
                            fullLine += "-c=" + s.Config;
                        if (!String.IsNullOrEmpty(s.Depfile))
                        {
                            if (fullLine.EndsWith("?")) fullLine += "-d=" + s.Config;
                            else fullLine += "&-d=" + s.Config;
                        }
                        if (!String.IsNullOrEmpty(s.Output))
                        {
                            if (fullLine.EndsWith("?")) fullLine += "output=" + s.Output;
                            else fullLine += "&output=" + s.Output;
                        }
                        if (fullLine.EndsWith("?")) fullLine = fullLine.Substring(0, fullLine.Length - 1);
                        file.WriteLine(fullLine);
                    }
                }
                file.Close();
            }
        }

		#endregion

	}
}