using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.IO;
using System.Windows.Forms;
using FlashDevelop.Docking;
using InsertFile.Resources;
using PluginCore;
using PluginCore.Controls;
using PluginCore.Helpers;
using PluginCore.Localization;
using PluginCore.Managers;
using PluginCore.Utilities;
using ScintillaNet;

namespace InsertFile
{
	public class PluginMain : IPlugin
	{
        private String pluginName = "InsertFile";
        private String pluginGuid = "0fde58ed-ee12-4988-97b4-3ac1afb1dc23";
        private String pluginHelp = "www.flashdevelop.org/community/";
        private String pluginDesc = "Inserts file path at cursor.";
        private String pluginAuth = "Oleg Sivokon";
        private String settingFilename;
        private Settings settingObject;

        private System.Windows.Forms.ToolStripMenuItem insertFileMenuItem;

        private String[] files;
        private String pathSoFar;
        private String word;
        private List<ICompletionListItem> completionList;
        private Boolean completing = false;

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
            if (this.insertFileMenuItem != null)
                PluginBase.MainForm.EditorMenu.Items.Remove(this.insertFileMenuItem);
            if (this.settingObject != null)
                PluginBase.MainForm.IgnoredKeys.Remove(this.settingObject.InsertShortcut);
            this.FinishFileCompletion(null, null);
		}
		
		/// <summary>
		/// Handles the incoming events
		/// </summary>
		public void HandleEvent(Object sender, NotifyEvent e, HandlingPriority prority)
		{
            TabbedDocument document = (TabbedDocument)PluginBase.MainForm.CurrentDocument;
            if (PluginBase.MainForm.EditorMenu == null) return;
            if (this.insertFileMenuItem == null)
            {
                this.insertFileMenuItem = new ToolStripMenuItem("Insert File Path", 
                                           null,
                                           new EventHandler(this.StartFileCompletion),
                                           this.settingObject.InsertShortcut);
                PluginBase.MainForm.EditorMenu.Items.Add(this.insertFileMenuItem);
                PluginBase.MainForm.IgnoredKeys.Add(this.settingObject.InsertShortcut);
            }
		}

		#endregion

        #region Custom Methods

        /// <summary>
        /// Initializes important variables
        /// </summary>
        public void InitBasics()
        {
            String dataPath = Path.Combine(PathHelper.DataDir, "InsertFile");
            if (!Directory.Exists(dataPath)) Directory.CreateDirectory(dataPath);
            this.settingFilename = Path.Combine(dataPath, "Settings.fdb");
        }

        /// <summary>
        /// Adds the required event handlers
        /// </summary> 
        public void AddEventHandlers()
        {
            EventType eventType = EventType.Keys | EventType.Command | EventType.UIStarted;
            EventManager.AddEventHandler(this, eventType);
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
        }

        /// <summary>
        /// Creates a menu item for the plugin and adds a ignored key
        /// </summary>
        public void CreateMenuItem()
        {
            // We don't need a menu item
        }

        /// <summary>
        /// Creates a plugin panel for the plugin
        /// </summary>
        public void CreatePluginPanel()
        {
            // We don't require UI
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

        private void OnChar(ScintillaControl sci, Int32 value)
        {
            Char ch = (Char)value;
            FileInfo fi;
            DirectoryInfo di;
            String desc;
            FileInfo[] foundFiles;
            DirectoryInfo[] foundDirectories;
            List<String> fileList;
            Int32 pathEnd = 1;
            String[] parts;

            sci.PreviewKeyDown += new PreviewKeyDownEventHandler(sci_PreviewKeyDown);

            if (ch == '/' || ch == '\\')
            {
                if (this.pathSoFar.Length == 1)
                {
                    this.files = Environment.GetLogicalDrives();
                    this.word = "";
                }
                else
                {
                    di = new DirectoryInfo(this.pathSoFar.Substring(0, this.pathSoFar.Length));
                    parts = this.pathSoFar.Split(new char[2] { '/', '\\' });
                    this.word = parts[parts.Length - 1];
                    
                    if (di.Exists)
                    {
                        foundFiles = di.GetFiles();
                        foundDirectories = di.GetDirectories();
                        fileList = new List<String>();
                        foreach (FileInfo ff in foundFiles)
                        {
                            fileList.Add(ff.Name);
                        }
                        foreach (DirectoryInfo fd in foundDirectories)
                        {
                            fileList.Add(fd.Name);
                        }
                        this.files = fileList.ToArray();
                    }
                    else this.files = Environment.GetLogicalDrives();
                }
            }
            else 
            {
                if (this.pathSoFar.IndexOf('/') > -1)
                    pathEnd = this.pathSoFar.LastIndexOf('/');
                if (this.pathSoFar.IndexOf('\\') > -1)
                    pathEnd = Math.Max(pathEnd, this.pathSoFar.LastIndexOf('\\'));
                pathEnd = Math.Min(pathEnd, this.pathSoFar.Length - 1);
                di = new DirectoryInfo(this.pathSoFar.Substring(0, pathEnd + 1));
                this.word = this.pathSoFar.Substring(pathEnd + 1);
                if (String.IsNullOrEmpty(this.word)) this.word = (String)this.pathSoFar.Clone();
                if (di.Exists)
                {
                    foundFiles = di.GetFiles();
                    foundDirectories = di.GetDirectories();
                    fileList = new List<String>();
                    foreach (FileInfo ff in foundFiles)
                    {
                        fileList.Add(ff.Name);
                    }
                    foreach (DirectoryInfo fd in foundDirectories)
                    {
                        fileList.Add(fd.Name);
                    }
                    this.files = fileList.ToArray();
                }
                else this.files = Environment.GetLogicalDrives();
            }
            this.completionList = new List<ICompletionListItem>();
            if (String.IsNullOrEmpty(this.word))
            {
                foreach (String s in this.files)
                {
                    fi = new FileInfo(s);
                    if (!fi.Exists) desc = "Hard Drive";
                    else
                    {
                        di = new DirectoryInfo(s);
                        if (!di.Exists)
                        {
                            desc = "File";
                        }
                        else desc = "Folder";
                    }
                    this.completionList.Add(new FileCompletionItem(s, s, desc));
                }
            }
            else
            {
                foreach (String s in this.files)
                {
                    if (!s.ToLower().StartsWith(this.word.ToLower()))
                        continue;
                    fi = new FileInfo(s);
                    if (!fi.Exists) desc = "Hard Drive";
                    else
                    {
                        di = new DirectoryInfo(s);
                        if (!di.Exists)
                        {
                            desc = "File";
                        }
                        else desc = "Folder";
                    }
                    this.completionList.Add(new FileCompletionItem(s, s.Substring(word.Length), desc));
                }
            }
            CompletionList.Show(this.completionList, true);
        }

        void sci_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.FinishFileCompletion(sender, e);
        }

        private void StartFileCompletion(Object sender, System.EventArgs e)
        {
            this.completing = true;
            UITools.Manager.OnCharAdded += new UITools.CharAddedHandler(OnChar);
            UITools.Manager.OnTextChanged += new UITools.TextChangedHandler(OnTextChanged);
        }

        void OnTextChanged(ScintillaControl sender, int position, int length, int linesAdded)
        {
            String added = "";
            Int32 start = position;
            if (String.IsNullOrEmpty(this.pathSoFar))
                this.pathSoFar = "";
            while (start < position + length)
            {
                added += (Char)(sender.CharAt(start));
                start++;
            }
            if (length > 0)
            {
                this.pathSoFar += added;
            }
            else
            {
                this.pathSoFar = this.pathSoFar.Substring(0, Math.Max(0, this.pathSoFar.Length + length));
            }
        }

        private void FinishFileCompletion(Object sender, System.EventArgs e)
        {
            this.completing = false;
            this.pathSoFar = "";
            this.word = "";
            this.files = null;
            ((ScintillaControl)sender).PreviewKeyDown -= new PreviewKeyDownEventHandler(sci_PreviewKeyDown);
            UITools.Manager.OnCharAdded -= new UITools.CharAddedHandler(OnChar);
            UITools.Manager.OnTextChanged -= new UITools.TextChangedHandler(OnTextChanged);
        }

		#endregion

	}

    class FileCompletionItem : ICompletionListItem
    {
        #region ICompletionListItem Members

        public string Label
        {
            get { return this.label; }
        }

        public string Value
        {
            get { return this.value; }
        }

        public string Description
        {
            get { return this.desc; }
        }

        public System.Drawing.Bitmap Icon
        {
            get { return this.icon; }
        }

        #endregion

        private String label;
        private String value;
        private String desc;
        private System.Drawing.Bitmap icon;

        public FileCompletionItem(String label, String value, String desc, System.Drawing.Bitmap icon)
        {
            this.label = label;
            this.value = value;
            this.desc = desc;
            this.icon = icon;
            if (this.icon == null)
                this.icon = new System.Drawing.Bitmap(PluginBase.MainForm.FindImage("417"));
        }

        public FileCompletionItem(String label, String value, String desc)
            : this(label, value, desc, null) {  }
    }

}
