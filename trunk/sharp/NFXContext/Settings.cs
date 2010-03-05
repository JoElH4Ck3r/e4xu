using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;
using System.Drawing;

namespace NFXContext
{
    [Serializable]
    public class Settings
    {
        private String parserPath = "nfx.jar";

        /// <summary> 
        /// Defines the color of line comments
        /// </summary>
        [Description("Defines the templates generator location."), DefaultValue("nfx.jar")]
        public String ParserPath
        {
            get { return this.parserPath; }
            set { this.parserPath = value; }
        }

    }

}
