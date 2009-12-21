using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;
using System.Drawing;

namespace ResourcePRJ
{
    [Serializable]
    public class Settings
    {
        private String projectRoot = "";

        /// <summary> 
        /// Defines the color of line comments
        /// </summary>
        [Description("Defines the templates folder location."), DefaultValue("./rsx")]
        public String ProjectRoot
        {
            get { return this.projectRoot; }
            set { this.projectRoot = value; }
        }

    }

}
