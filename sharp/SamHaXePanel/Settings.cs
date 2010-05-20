using System;
using System.ComponentModel;
using System.Windows.Forms;
using System.Windows.Forms.Design;
using System.Drawing.Design;

namespace SamHaXePanel
{
    public class ExeNameEditor : FileNameEditor
    {
        /// <summary>
        /// Overrides the Filter and Title of the dialog box
        /// </summary>
        /// <param name="openFileDialog"></param>
        protected override void InitializeDialog(System.Windows.Forms.OpenFileDialog openFileDialog)
        {
            base.InitializeDialog(openFileDialog);
            openFileDialog.Filter = "EXE Files (*.exe)|*.exe|All files(*.*)|*.*";
            openFileDialog.Title = "Select SamHaXe Executable";
        }
    }

    [Serializable]
    public class Settings
    {
        private String samHome = "";
        
        /// <summary> 
        /// SamHaXe executable location
        /// </summary>
        [Description("SamHaXe executable location"), DefaultValue("")]
        [Editor(typeof(ExeNameEditor), typeof(UITypeEditor))]
        public String SamHome
        {
            get { return this.samHome; }
            set { this.samHome = value; }
        }
    }
}
