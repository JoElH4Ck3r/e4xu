using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using System.Xml;

namespace ResourceBatchProcessor
{
    class MXMLGenerator
    {
        public static string templateStart = 
@"<?xml version=""1.0"" encoding=""utf-8""?>
<fl:Sprite 
	xmlns:mx=""http://www.adobe.com/2006/mxml""
	xmlns:fl=""flash.display.*""
	xmlns:rs=""org.wvxvws.resources.*""
	>";
        public static string embed =
@"	<rs:Resource embed=""@Embed(source='%path%')""/>
";
        public static string templateEnd = "</fl:Sprite>";

        public static Regex nonAlphaNum = new Regex(@"\W", RegexOptions.Compiled);

        public static void ProcessDirectory(string path)
        {
            DirectoryInfo di = new DirectoryInfo(path);
            FileInfo[] files = di.GetFiles("*.png");
            string filePath;
            string resultFileName = di.Parent.FullName + @"\" + 
                    nonAlphaNum.Replace(di.Name, "_") + ".mxml";
            string resultFile = (string)templateStart.Clone();
            foreach (FileInfo fi in files)
            {
                filePath = ((string)embed.Clone()).Replace("%path%", fi.FullName);
                resultFile += filePath;
            }
            resultFile += templateEnd;
            XmlTextWriter textWriter = new XmlTextWriter(resultFileName, Encoding.UTF8);
            textWriter.WriteRaw(resultFile);
            textWriter.Close();
        }

        public static void ProcessDirectory(string[] path)
        {
            //DirectoryInfo[] di = new DirectoryInfo[path.Length];
            //int i = 0;
            foreach (string pt in path)
            {
                ProcessDirectory(pt);
                //di.SetValue(new DirectoryInfo(pt), i);
            }
        }
    }
}
