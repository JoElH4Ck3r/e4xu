using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.IO;
using ResourcePRJ.Enums;

namespace ResourcePRJ
{
    class TemplateGenerator
    {
        public static String ProjectSettings =
@"<?xml version=""1.0"" encoding=""utf-8"" ?>
<project>
<root><![CDATA[  Root folder of the project. ]]></root>
<specs><![CDATA[ Document class file.        ]]></specs>
<compc><![CDATA[ COMPC locarion.             ]]></compc>
</project>";

        public static String ProjectTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:Sprite 
	xmlns:mx=""http://www.adobe.com/2006/mxml""
	xmlns:img=""%PN%.*""
	xmlns:snd=""%PN%.*""
	xmlns:fnt=""%PN%.*""
	xmlns:swf=""%PN%.*""
	xmlns:fxg=""%PN%.*""
	xmlns:svg=""%PN%.*""
	xmlns:txt=""%PN%.*""
	xmlns:bin=""%PN%.*""
	xmlns:fl=""flash.display.*""
	>
	<%NS%:%CN%/>
</fl:Sprite>";

        public static String ImgTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:Bitmap xmlns:fl=""flash.display.*"" xmlns:mx=""http://www.adobe.com/2006/mxml"">
	<mx:Metadata>
		[Embed(source=""%embed%"")]
	</mx:Metadata>
</fl:Bitmap>";

        public static String SndTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:Sound xmlns:fl=""flash.media.*"" xmlns:mx=""http://www.adobe.com/2006/mxml"">
	<mx:Metadata>
		[Embed(source=""%embed%"")]
	</mx:Metadata>
</fl:Sound>";

        public static String FntTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:Font xmlns:fl=""flash.media.*"" xmlns:mx=""http://www.adobe.com/2006/mxml"">
	<mx:Metadata>
		[Embed(source=""%embed%"")]
	</mx:Metadata>
</fl:Font>";

        public static String SwfTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:Sprite xmlns:fl=""flash.display.*"" xmlns:mx=""http://www.adobe.com/2006/mxml"">
	<mx:Metadata>
		[Embed(source=""%embed%"")]
	</mx:Metadata>
</fl:Sprite>";

        public static String FxgTemplate =
@"
";
        public static String SvgTemplate =
@"
";
        public static String TxtTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:ByteArray xmlns:fl=""flash.utils.*"" xmlns:mx=""http://www.adobe.com/2006/mxml"">
	<mx:Metadata>
		[Embed(source=""%embed%"")]
	</mx:Metadata>
</fl:ByteArray>";

        public static String BinTemplate =
@"<?xml version=""1.0"" encoding=""utf-8""?>
<!-- %PN%.%FN%.mxml -->
<fl:ByteArray xmlns:fl=""flash.utils.*"" xmlns:mx=""http://www.adobe.com/2006/mxml"">
	<mx:Metadata>
		[Embed(source=""%embed%"")]
	</mx:Metadata>
</fl:ByteArray>";

        private static List<FileInfo> imgFiles = new List<FileInfo>();
        private static List<FileInfo> sndFiles = new List<FileInfo>();
        private static List<FileInfo> fntFiles = new List<FileInfo>();
        private static List<FileInfo> swfFiles = new List<FileInfo>();
        private static List<FileInfo> fxgFiles = new List<FileInfo>();
        private static List<FileInfo> svgFiles = new List<FileInfo>();
        private static List<FileInfo> txtFiles = new List<FileInfo>();
        private static List<FileInfo> binFiles = new List<FileInfo>();

        private static Regex resToClass = new Regex("\\W", RegexOptions.Compiled);

        public static string AddFile(FileInfo info, AssetTypes type, string copyTo)
        {
            List<FileInfo> fis = null;
            String template = "";
            FileInfo mxmlFile;
            String mxmlFileName = null;
            switch (type)
            {
                case AssetTypes.Img:
                    fis = imgFiles;
                    template = (String)ImgTemplate.Clone();
                    break;
                case AssetTypes.Snd:
                    fis = sndFiles;
                    template = (String)SndTemplate.Clone();
                    break;
                case AssetTypes.Fnt:
                    fis = fntFiles;
                    template = (String)FntTemplate.Clone();
                    break;
                case AssetTypes.Swf:
                    fis = swfFiles;
                    template = (String)SwfTemplate.Clone();
                    break;
                case AssetTypes.Fxg:
                    fis = fxgFiles;
                    template = (String)FxgTemplate.Clone();
                    break;
                case AssetTypes.Svg:
                    fis = svgFiles;
                    template = (String)SvgTemplate.Clone();
                    break;
                case AssetTypes.Txt:
                    fis = txtFiles;
                    template = (String)TxtTemplate.Clone();
                    break;
                default:
                    fis = binFiles;
                    template = (String)BinTemplate.Clone();
                    break;
            }
            if (fis != null)
            {
                fis.Add(info);
                template = template.Replace("%PN%", copyTo);
                template = template.Replace("%embed%", info.FullName);
                DirectoryInfo di = CreateRecursive(copyTo);
                mxmlFileName = NormalizeClassName(info.Name);
                template = template.Replace("%FN%", mxmlFileName);
                if (di != null && !di.Exists)
                {
                    try
                    {
                        di.Create();
                    }
                    catch
                    {
                        Console.WriteLine("Failed to create directory: " + di.FullName);
                        // need to display a message here
                    }
                }
                if (di != null)
                {
                    mxmlFile = new FileInfo(di.FullName +
                        Path.DirectorySeparatorChar + mxmlFileName + ".mxml");
                    FileStream fs;
                    try
                    {
                        fs = mxmlFile.Create();
                    }
                    catch
                    {
                        // Need to handle duplicating file names
                        return null;
                    }
                    UTF8Encoding encoding = new UTF8Encoding();
                    byte[] templateBytes = encoding.GetBytes(template);
                    fs.Write(templateBytes, 0, templateBytes.Length);
                    fs.Close();
                }
            }
            return mxmlFileName;
        }

        private static String NormalizeClassName(String resourceName)
        {
            String ret = resToClass.Replace(resourceName, "_");
            char[] uns = { '_' };
            String[] parts = ret.Split(uns);
            ret = "";
            String ts;
            foreach (String s in parts)
            {
                ts = s[0].ToString().ToUpper() + s.Substring(1);
                ret += ts;
            }
            Regex re = new Regex("^\\d", RegexOptions.Compiled);
            if (re.IsMatch(ret)) ret = "X" + ret;
            return ret;
        }

        private static DirectoryInfo CreateRecursive(string path)
        {
            char[] separators = { Path.DirectorySeparatorChar };
            string[] parts = path.Split(separators);
            DirectoryInfo current = null;
            DirectoryInfo[] existing = null;
            
            foreach (string s in parts)
            {
                if (current == null)
                {
                    current = new DirectoryInfo(s + Path.DirectorySeparatorChar);
                    if (!current.Exists)
                    {
                        try
                        {
                            current.Create();
                        }
                        catch
                        {
                            Console.WriteLine("Cannot create directory " + s);
                            return null;
                        }
                    }
                }
                else
                {
                    existing = current.GetDirectories(s, SearchOption.TopDirectoryOnly);
                    if (existing != null && existing.Length > 0)
                    {
                        current = existing[0];
                    }
                    else
                    {
                        try
                        {
                            current = current.CreateSubdirectory(s + Path.DirectorySeparatorChar);
                        }
                        catch
                        {
                            Console.WriteLine("Cannot create directory " + s);
                            return null;
                        }
                    }
                }
            }
            return current;
        }

        private static DirectoryInfo ResolvePackage(String path, String relativeTo)
        {
            char[] separators = { '.' };
            String[] folders = path.Split(separators);
            DirectoryInfo current = new DirectoryInfo(relativeTo);
            DirectoryInfo[] existing = null;
            bool errorCreating = false;
            foreach (String di in folders)
            {
                try
                {
                    existing = current.GetDirectories(di, SearchOption.TopDirectoryOnly);
                }
                catch
                {
                    existing = null;
                }
                if (existing == null || existing.Length == 0)
                {
                    try
                    {
                        current = current.CreateSubdirectory(di);
                    }
                    catch
                    {
                        errorCreating = true;
                        break;
                    }
                }
                else
                {
                    current = existing[0];
                }
            }
            if (!errorCreating)
            {
                return current;
            }
            else
            {
                Console.WriteLine("Failed to create folder: " + path);
                // need to display error message here
                return null;
            }
        }
    }
}
