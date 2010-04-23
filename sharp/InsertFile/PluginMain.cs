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
using System.Text.RegularExpressions;

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
        private Regex notAllowed = new Regex("[\\x00-\\x1F\\*\\?%\"<>\\x7F]", RegexOptions.Compiled);
        private DirectoryInfo currentFolder;

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
            String match;
            String[] parts;
            DirectoryInfo di = this.FindRoot();
            String remainder;

            if (di == null)
            {
                if (this.completing)
                    CompletionList.Show(this.FormatCompletionList(this.pathSoFar), true);
            }
            else
            {
                parts = this.pathSoFar.Split(new Char[2] { '/', '\\' });
                match = parts[parts.Length - 1];
                if (this.currentFolder == null)
                {
                    this.currentFolder = di;
                    CompletionList.Show(this.FormatCompletionList(match), true);
                }
                else
                {
                    Queue<String> q = new Queue<String>(parts);
                    q.Dequeue();
                    remainder = "";
                    foreach (String s in q)
                    {
                        remainder += "\\" + s;
                    }
                    remainder = remainder.Substring(1);
                    this.currentFolder = new DirectoryInfo(Path.Combine(di.FullName, remainder));
                    CompletionList.Show(this.FormatCompletionList(match), true);
                }
            }
        }

        private DirectoryInfo FindRoot()
        {
            String[] parts;
            FileInfo fi;
            if (String.IsNullOrEmpty(this.pathSoFar) || 
                this.pathSoFar.StartsWith("\\") || 
                this.pathSoFar.StartsWith("/"))
            {
                return null;
            }
            else if (this.pathSoFar.StartsWith(".."))
            {
                fi = new FileInfo(PluginBase.MainForm.CurrentDocument.FileName);
                if (fi.Exists && fi.Directory != null && fi.Directory.Parent != null)
                    return fi.Directory.Parent;
                else
                {
                    this.FinishFileCompletion(
                        PluginBase.MainForm.CurrentDocument.SciControl, null);
                }
            }
            else if (this.pathSoFar.StartsWith("."))
            {
                fi = new FileInfo(PluginBase.MainForm.CurrentDocument.FileName);
                if (fi.Exists && fi.Directory != null)
                    return fi.Directory;
                else
                {
                    this.FinishFileCompletion(
                        PluginBase.MainForm.CurrentDocument.SciControl, null);
                }
            }
            else if (this.pathSoFar.IndexOf('\\') > -1 ||
                this.pathSoFar.IndexOf('/') > -1)
            {
                parts = this.pathSoFar.Split(new Char[2] { '/', '\\' });
                return new DirectoryInfo(parts[0] + "\\");
            }
            else if (this.pathSoFar.EndsWith(":"))
            {
                return new DirectoryInfo(this.pathSoFar + "\\");
            }
            return null;
        }

        void sci_PreviewKeyDown(object sender, PreviewKeyDownEventArgs e)
        {
            if (e.KeyCode == Keys.Escape) this.FinishFileCompletion(sender, e);
        }

        private List<ICompletionListItem> FormatCompletionList(String match)
        {
            String[] entries;
            DirectoryInfo sdi = null;
            String desc;
            FileInfo[] foundFiles;
            DirectoryInfo[] foundDirectories;
            List<String> fileList;
            List<String> dirList;
            this.completionList = new List<ICompletionListItem>();

            if (this.currentFolder == null)
            {
                entries = Environment.GetLogicalDrives();
                if (String.IsNullOrEmpty(match))
                {
                    this.completionList.Add(new FileCompletionItem("<Current Document>", ".", "Current Document"));
                }
            }
            else
            {
                foundFiles = this.currentFolder.GetFiles();
                foundDirectories = this.currentFolder.GetDirectories();
                fileList = new List<String>();
                dirList = new List<String>();
                foreach (DirectoryInfo fd in foundDirectories)
                {
                    dirList.Add(fd.Name);
                }
                dirList.Sort();
                foreach (FileInfo ff in foundFiles)
                {
                    fileList.Add(ff.Name);
                }
                fileList.Sort();
                dirList.AddRange(fileList);
                entries = dirList.ToArray();
            }
            
            foreach (String s in entries)
            {
                if (this.currentFolder == null)
                {
                    if (String.IsNullOrEmpty(match))
                    {
                        this.completionList.Add(new FileCompletionItem(s, s, "Disc"));
                    }
                    else if (!s.ToLower().StartsWith(match.ToLower()))
                    {
                        this.completionList.Add(new FileCompletionItem(s, s.Substring(match.Length), "Disc"));
                    }
                    continue;
                }
                else if (String.IsNullOrEmpty(match))
                {
                    sdi = new DirectoryInfo(Path.Combine(this.currentFolder.FullName, s));
                }
                else if (!s.ToLower().StartsWith(match.ToLower()))
                {
                    continue;
                }
                else
                {
                    sdi = new DirectoryInfo(Path.Combine(this.currentFolder.FullName, s));
                }
                if (sdi.Exists)
                {
                    if (s.IndexOf(':') > -1) desc = "Disc";
                    else desc = "Directory";
                }
                else desc = "File";
                this.completionList.Add(new FileCompletionItem(s, s.Substring(match.Length), desc));
            }
            return this.completionList;
        }

        private void StartFileCompletion(Object sender, System.EventArgs e)
        {
            this.completing = true;
            ScintillaControl sci = PluginBase.MainForm.CurrentDocument.SciControl;
            sci.PreviewKeyDown += new PreviewKeyDownEventHandler(sci_PreviewKeyDown);
            UITools.Manager.OnCharAdded += new UITools.CharAddedHandler(OnChar);
            UITools.Manager.OnTextChanged += new UITools.TextChangedHandler(OnTextChanged);
            CompletionList.OnInsert += new InsertedTextHandler(CompletionList_OnInsert);
            CompletionList.Show(this.FormatCompletionList(null), true);
        }

        void CompletionList_OnInsert(ScintillaControl sender, int position, string text, char trigger, ICompletionListItem item)
        {
            if (item.Description == "File")
                this.FinishFileCompletion(sender, null);
            else if (item.Description == "Current Document")
            {
                FileInfo fi = new FileInfo(PluginBase.MainForm.CurrentDocument.FileName);
                if (!fi.Exists) this.FinishFileCompletion(sender, null);
                else this.currentFolder = fi.Directory;
            }
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
                if (this.notAllowed.IsMatch(added))
                {
                    this.FinishFileCompletion(sender, null);
                    return;
                }
                this.pathSoFar += added;
            }
            else
            {
                this.pathSoFar = this.pathSoFar.Substring(0, Math.Max(0, this.pathSoFar.Length + length));
            }
        }

        private void FinishFileCompletion(Object sender, System.EventArgs e)
        {
            Console.WriteLine("FinishFileCompletion");
            this.completing = false;
            this.pathSoFar = "";
            this.word = "";
            this.files = null;
            this.currentFolder = null;
            if ((sender as ScintillaControl) != null)
                ((ScintillaControl)sender).PreviewKeyDown -= new PreviewKeyDownEventHandler(sci_PreviewKeyDown);
            UITools.Manager.OnCharAdded -= new UITools.CharAddedHandler(OnChar);
            UITools.Manager.OnTextChanged -= new UITools.TextChangedHandler(OnTextChanged);
            CompletionList.OnInsert -= new InsertedTextHandler(CompletionList_OnInsert);
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