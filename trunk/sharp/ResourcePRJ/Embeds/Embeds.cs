using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace ResourcePRJ.Embeds
{
    #region embed image
    class EmbedImg
    {
        private FileInfo file;
        private string className;
        private string packageName;

        public EmbedImg() { }

        public EmbedImg(string file, string className, string packageName)
        {
            this.FileName = file;
            this.className = className;
            this.packageName = packageName;
        }

        public string ClassName
        {
            get { return className; }
            set { className = value; }
        }

        public string PackageName
        {
            get { return packageName; }
            set { packageName = value; }
        }
        public string FileName
        {
            get
            {
                if (file != null) return file.FullName;
                return "";
            }
            set
            {
                try
                {
                    file = new FileInfo(value);
                }
                catch
                {
                    // display warning here
                    Console.WriteLine("Couldn't open file: " + value);
                }
            }
        }
    }

    #endregion
}
