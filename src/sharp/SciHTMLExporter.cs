using System;
using System.Collections.Generic;
using System.Text;
using PluginCore;
using System.Xml;
using System.Text.RegularExpressions;

namespace ExportHTML
{
    class SciHTMLExporter
    {
        private static System.Text.UTF8Encoding enc = new System.Text.UTF8Encoding();
        private static Regex lineEnd = new Regex("/[\\n\\r]{1,2}/", RegexOptions.Compiled);
        
        /*
        DEFAULT = 0,
		COMMENT = 1,
		COMMENTLINE = 2,
		COMMENTDOC = 3,
		NUMBER = 4,
		WORD = 5,
		STRING = 6,
		CHARACTER = 7,
		UUID = 8,
		PREPROCESSOR = 9,
		OPERATOR = 10,
		IDENTIFIER = 11,
		STRINGEOL = 12,
		VERBATIM = 13,
		REGEX = 14,
		COMMENTLINEDOC = 15,
		WORD2 = 16,
		COMMENTDOCKEYWORD = 17,
		COMMENTDOCKEYWORDERROR = 18,
		GLOBALCLASS = 19,
        */
        private static string[] as3Styles =
        {
            "color: rgb(0, 0, 0); font-family: monospace;",     //0 normal non-printing
            "color: rgb(0, 128, 0); font-family: monospace;",   //1 comment
            "color: rgb(0, 128, 0); font-family: monospace;",   //2 line comment
            "color: rgb(0, 128, 0); font-family: monospace;",   //3 jdoc comment
            "color: rgb(0, 0, 153); font-family: monospace;",   //4 number
            "color: rgb(0, 0, 153); font-family: monospace;",   //5 top-level
            "color: rgb(163, 21, 21); font-family: monospace;", //6 string double quotes
            "color: rgb(163, 21, 21); font-family: monospace;", //7 string single quotes
            "color: rgb(0, 0, 0); font-family: monospace;",     //8
            "color: rgb(0, 0, 0); font-family: monospace;",     //9
            "color: rgb(0, 0, 0); font-family: monospace;",     //10 normal non-alphanum
            "color: rgb(0, 0, 0); font-family: monospace;",     //11 normal
            "color: rgb(0, 0, 0); font-family: monospace;",     //12
            "color: rgb(0, 0, 0); font-family: monospace;",     //13
            "color: rgb(255, 0, 255); font-family: monospace;", //14 regexp
            "color: rgb(0, 0, 0); font-family: monospace;",     //15
            "color: rgb(0, 144, 144); font-family: monospace;", //16 built-in
            "color: rgb(128, 0, 0); font-family: monospace;",   //17 jdoc keyword
            "color: rgb(0, 0, 0); font-family: monospace;",     //18
            "color: rgb(21, 24, 255); font-family: monospace;"  //19 keyword
        };
        /*
        Version:1.0
        StartHTML:000125
        EndHTML:000260
        StartFragment:000209
        EndFragment:000222
        SourceURL:file:///C:/temp/test.htm
        <HTML>
        <head>
        <title>HTML clipboard</title>
        </head>
        <body>
        <!--StartFragment--><b>Hello!</b><!--EndFragment-->
        </body>
        </html>
        */
        public static string ConvertToHTML(ITabbedDocument document)
        {
            int start = document.SciControl.SelectionStart;
            int end = document.SciControl.SelectionEnd;
            char chr = ' ';
            int sciChar;

            byte[] bytesUTF = {0, 0};

            int style = -1;
            int lastStyle = -1;
            int lexer = document.SciControl.Lexer;
            string word = "";

            XmlDocument xml = new XmlDocument();
            xml.LoadXml("<HTML><body>" +
                "<!--StartFragment--><p/><!--EndFragment--></body></HTML>");
            Dictionary<int, XmlElement> styleNodes = new Dictionary<int, XmlElement>();
            XmlElement spanNode;
            XmlText wordNode;
            XmlNode workingNode = xml.FirstChild.ChildNodes[0].ChildNodes[1];

            switch (lexer)
            {
                case 2: //Phyton
                    break;
                case 3: //AS & Text
                    break;
                case 4: //HTML
                    break;
                case 5: //XML
                    break;
                case 38: //CSS
                    break;
            }

            bool print = false;
            while (start < end)
            {
                sciChar = document.SciControl.CharAt(start);
                style = document.SciControl.BaseStyleAt(start);
                if (sciChar < 0x20 || sciChar > 0x7F)
                {
                    if (bytesUTF[0] != 0)
                    {
                        bytesUTF[1] = (byte)sciChar;
                        chr = enc.GetString(bytesUTF)[0];
                        bytesUTF[0] = 0;
                        print = true;
                    }
                    else
                    {
                        bytesUTF[0] = (byte)sciChar;
                        print = false;
                    }
                }
                else
                {
                    bytesUTF[0] = 0;
                    chr = (char)sciChar;
                    print = true;
                }
                if (style != lastStyle)
                {
                    if (lastStyle > -1)
                    {
                        if (styleNodes.ContainsKey(lastStyle))
                        {
                            spanNode = styleNodes[lastStyle];
                        }
                        else
                        {
                            spanNode = xml.CreateElement("span");
                            spanNode.SetAttribute("style", as3Styles[lastStyle]);
                        }
                        word = word.Replace(' ', '\u00A0').Replace("\t", "\u00A0\u00A0\u00A0\u00A0");
                        wordNode = xml.CreateTextNode(word);
                        spanNode.AppendChild((XmlNode)wordNode);
                        workingNode.AppendChild(spanNode);
                    }
                    word = "";
                    lastStyle = style;
                }
                if (print) word += chr;
                start++;
            }
            if (word != "")
            {
                if (styleNodes.ContainsKey(style))
                {
                    spanNode = styleNodes[style];
                }
                else
                {
                    spanNode = xml.CreateElement("span");
                    spanNode.SetAttribute("style", as3Styles[style]);
                    word = word.Replace(' ', '\u00A0').Replace("\t", "\u00A0\u00A0\u00A0\u00A0");
                    wordNode = xml.CreateTextNode(word);
                    spanNode.AppendChild((XmlNode)wordNode);
                }
                workingNode.AppendChild(spanNode);
            }
            return xml.InnerXml.Replace("\r", "\r<br/>").Replace(
                "<!--StartFragment-->", "\r<!--StartFragment-->\r").Replace(
                "<!--EndFragment-->", "\r<!--EndFragment-->\r").Replace(
                "\u00A0", "&nbsp;");
        }
    }
}
