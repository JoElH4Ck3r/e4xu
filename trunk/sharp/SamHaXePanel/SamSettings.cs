using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing.Design;
using System.Windows.Forms.Design;

namespace SamHaXePanel
{
    public class SwfNameEditor : FileNameEditor
    {
        /// <summary>
        /// Overrides the Filter and Title of the dialog box
        /// </summary>
        /// <param name="openFileDialog"></param>
        protected override void InitializeDialog(System.Windows.Forms.OpenFileDialog openFileDialog)
        {
            base.InitializeDialog(openFileDialog);
            openFileDialog.Filter = "SWF Files (*.swf)|*.swf|All files(*.*)|*.*";
            openFileDialog.Title = "Select SWF Output File";
            openFileDialog.CheckFileExists = false;
        }
    }

    public class XmlNameEditor : FileNameEditor
    {
        /// <summary>
        /// Overrides the Filter and Title of the dialog box
        /// </summary>
        /// <param name="openFileDialog"></param>
        protected override void InitializeDialog(System.Windows.Forms.OpenFileDialog openFileDialog)
        {
            base.InitializeDialog(openFileDialog);
            openFileDialog.Filter = "XML Files (*.xml)|*.xml|All files(*.*)|*.*";
            openFileDialog.Title = "Select XML Configuration File";
            openFileDialog.CheckFileExists = false;
        }
    }

    [Serializable]
    [DefaultPropertyAttribute("Config")]
    public class SamSettings
    {
        private String config = "";
        private String depfile = "";
        private List<String> moduleOptions = null;
        private String input = "";
        private String output = "";

        public SamSettings() { }

        /// <summary>
        /// Name and path of SamHaXe’s configuration file.
        /// </summary>
        [Description("Name and path of SamHaXe’s configuration file."), DefaultValue("")]
        [Editor(typeof(XmlNameEditor), typeof(UITypeEditor))]
        [CategoryAttribute("SamHaXe General Settings")]
        public string Config
        {
            get { return config; }
            set { config = value; }
        }

        /// <summary>
        /// Name and path of dependency file.
        /// </summary>
        [Description("Name and path of dependency file."), DefaultValue("")]
        [Editor(typeof(XmlNameEditor), typeof(UITypeEditor))]
        [CategoryAttribute("SamHaXe General Settings")]
        public string Depfile
        {
            get { return depfile; }
            set { depfile = value; }
        }

        /// <summary>
        /// Pass options to an import module from command line.
        /// </summary>
        [Description("Pass options to an import module from command line."), DefaultValue(null)]
        [CategoryAttribute("SamHaXe General Settings")]
        public List<String> ModuleOptions
        {
            get { return moduleOptions; }
            set { moduleOptions = value; }
        }

        /// <summary>
        /// Input XML file.
        /// </summary>
        [Description("Input XML file."), DefaultValue("")]
        [Editor(typeof(XmlNameEditor), typeof(UITypeEditor))]
        [CategoryAttribute("SamHaXe General Settings")]
        [ReadOnlyAttribute(true)]
        public string Input
        {
            get { return input; }
            set { input = value; }
        }

        /// <summary>
        /// Output SWF file.
        /// </summary>
        [Description("Output SWF file."), DefaultValue("")]
        [Editor(typeof(SwfNameEditor), typeof(UITypeEditor))]
        [CategoryAttribute("SamHaXe General Settings")]
        public string Output
        {
            get { return output; }
            set { output = value; }
        }
    }
}
