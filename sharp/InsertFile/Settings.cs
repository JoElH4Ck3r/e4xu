using System;
using System.ComponentModel;
using System.Windows.Forms;

namespace InsertFile
{
    [Serializable]
    public class Settings
    {
        private Keys insertShortcut = Keys.Control | Keys.OemPeriod;
        
        /// <summary> 
        /// Invoke File Insertion completion
        /// </summary>
        [Description("Invoke File Insertion completion"), DefaultValue(Keys.Control | Keys.OemPeriod)]
        public Keys InsertShortcut
        {
            get { return this.insertShortcut; }
            set { this.insertShortcut = value; }
        }
    }
}
