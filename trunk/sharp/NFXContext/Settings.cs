using System;
using System.ComponentModel;
using System.Drawing.Design;
using System.Windows.Forms.Design;

namespace NFXContext
{
    [Serializable]
    public class Settings
    {
        private String parserPath = "";

        /// <summary> 
        /// Defines the templates generator location.
        /// </summary>
        [DisplayName("nfx.jar location.")]
        [Description("Defines the templates generator location.")]
        [DefaultValue("")]
        [Editor(typeof(FolderNameEditor), typeof(UITypeEditor))]
        public String ParserPath
        {
            get { return this.parserPath; }
            set { this.parserPath = value; }
        }

    }

}
