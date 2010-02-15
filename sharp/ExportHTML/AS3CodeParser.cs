using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Drawing;
using System.IO;
using System.Windows.Forms;
using ExportHTML.Resources;
using PluginCore.Helpers;

namespace ExportHTML
{

    class AS3CodeParser
    {

        private static string[] KEYWORDS =
		{
			"class", "dynamic", "extends", "implements", "import", "interface", "new", "case", "do", "while", "else", "if", "for", "in", "switch", "throw", "intrinsic",
			"private", "public", "static", "get", "set", "function", "var", "try", "catch", "finally", "while", "with", "default", "break", "continue", "delete", "return",
			"final", "each", "internal", "native", "override", "protected", "const", "namespace", "package", "include", "use", "AS3"
		};

        private static string[] SECONDARY_KEYWORDS =
		{
			"super", "this", "null", "Infinity", "NaN", "undefined", "true", "false", "is", "as", "instanceof", "typeof"
		};

        private static string[] CLASSES =
		{
			"void", "Null", "ArgumentError", "arguments", "Array", "Boolean", "Class", "Date", "DefinitionError", "Error", "EvalError", "Function", "int", "Math", "Namespace",
			"Number", "Object", "QName", "RangeError", "ReferenceError", "RegExp", "SecurityError", "String", "SyntaxError", "TypeError", "uint", "URIError",
			"VerifyError", "XML", "XMLList", "Accessibility", "AccessibilityProperties", "ActionScriptVersion", "AVM1Movie", "Bitmap", "BitmapData",
			"BitmapDataChannel", "BlendMode", "CapsStyle", "DisplayObject", "DisplayObjectContainer", "FrameLabel", "GradientType", "Graphics",
			"IBitmapDrawable", "InteractiveObject", "InterpolationMethod", "JointStyle", "LineScaleMode", "Loader", "LoaderInfo", "MorphShape", "MovieClip",
			"PixelSnapping", "Scene", "Shape", "SimpleButton", "SpreadMethod", "Sprite", "Stage", "StageAlign", "StageDisplayState", "StageQuality", "StageScaleMode",
			"SWFVersion", "EOFError", "IllegalOperationError", "InvalidSWFError", "IOError", "MemoryError", "ScriptTimeoutError", "StackOverflowError",
			"ActivityEvent", "AsyncErrorEvent", "ContextMenuEvent", "DataEvent", "ErrorEvent", "Event", "EventDispatcher", "EventPhase", "FocusEvent",
			"FullScreenEvent", "HTTPStatusEvent", "IEventDispatcher", "IMEEvent", "IOErrorEvent", "KeyboardEvent", "MouseEvent", "NetStatusEvent", "ProgressEvent",
			"SecurityErrorEvent", "StatusEvent", "SyncEvent", "TextEvent", "TimerEvent", "ExternalInterface", "BevelFilter", "BitmapFilter",
			"BitmapFilterQuality", "BitmapFilterType", "BlurFilter", "ColorMatrixFilter", "ConvolutionFilter", "DisplacementMapFilter",
			"DisplacementMapFilterMode", "DropShadowFilter", "GlowFilter", "GradientBevelFilter", "GradientGlowFilter", "ColorTransform", "Matrix",
			"Point", "Rectangle", "Transform", "Camera", "ID3Info", "Microphone", "Sound", "SoundChannel", "SoundLoaderContext", "SoundMixer", "SoundTransform",
			"Video", "FileFilter", "FileReference", "FileReferenceList", "IDynamicPropertyOutput", "IDynamicPropertyWriter", "LocalConnection",
			"NetConnection", "NetStream", "ObjectEncoding", "Responder", "SharedObject", "SharedObjectFlushStatus", "Socket", "URLLoader",
			"URLLoaderDataFormat", "URLRequest", "URLRequestHeader", "URLRequestMethod", "URLStream", "URLVariables", "XMLSocket",
			"PrintJob", "PrintJobOptions", "PrintJobOrientation", "ApplicationDomain", "Capabilities", "IME", "IMEConversionMode", "LoaderContext",
			"Security", "SecurityDomain", "SecurityPanel", "System", "AntiAliasType", "CSMSettings", "Font", "FontStyle", "FontType", "GridFitType",
			"StaticText", "StyleSheet", "TextColorType", "TextDisplayMode", "TextField", "TextFieldAutoSize", "TextFieldType", "TextFormat",
			"TextFormatAlign", "TextLineMetrics", "TextRenderer", "TextSnapshot", "ContextMenu", "ContextMenuBuiltInItems", "ContextMenuItem",
			"Keyboard", "KeyLocation", "Mouse", "ByteArray", "Dictionary", "Endian", "IDataSPAN", "IDataOutput", "IExternalizable", "Proxy", "Timer",
			"XMLDocument", "XMLNode", "XMLNodeType"
		};

        private static string[] DOC_KEYWORDS =
		{
			"author", "copy", "default", "deprecated", "eventType", "example", "exampleText", "exception", "haxe", "inheritDoc", "internal", "link", "mtasc", "mxmlc",
			"param", "private", "return", "see", "serial", "serialData", "serialField", "since", "throws", "usage", "version"
		};

        private static string SPAN_BEGIN = "<**** class=\"xxx\">"; // 18
        private static string SPAN_END = "</****>"; // 7

        private static string JCOMMENT_RE_HELPER = "$1<**** class=\"s00\">"; // 7

        private static Regex NOT_SPAN =
            new Regex("\\<(\\*\\*\\*\\*)( class=\"...\"\\>)(.+?)(<\\/\\1>)",
            RegexOptions.Compiled);
        private static Regex TRAILING_SPACES =
            new Regex("^((\\s|\\t)+)((.+?)\\1)*", RegexOptions.Compiled);

        private static string JCOMMENT_C = "s00";
        private static string COMMENT_C = "s01";
        private static string STRING_C = "s02";
        private static string NUMBER_C = "s03";
        private static string REGEXP_C = "s04";
        private static string HTML_C = "s05";
        private static string BUILTIN_C = "s06";
        private static string TYPE_C = "s07";

        private static string JCOMMENT;
        private static string COMMENT;
        private static string STRING;
        private static string NUMBER;
        private static string REGEXP;
        private static string HTML;
        private static string BUILTIN;
        private static string TYPE;

        private static string _text;
        private static byte[] _bytes;
        private static string[] _lines;

        private static bool _isLineComment;
        private static bool _isJavaComment;

        private static bool _isString;
        private static bool _isApostropheString;

        private static bool _isEscaped;
        private static bool _isPreviousEscaped;
        private static bool _isRegExp;
        private static bool _isXML;
        private static bool _isNumber;
        private static bool _isHex;

        private static int _xmlNodeType;
        private static bool _isOpenNode;
        private static string _xmlBody;
        private const string _fakeXMLName = "a";
        private const string _fakeXMLAttribute = "a=\"\"";
        private static int _fakeNameCounter;
        private static int _fakeAttributeCounter;

        private static int _codeHeight;

        private static bool _init;

        private static string[] _curlyBrackets;
        private static string _word = "";

        private static Settings settings;
        public static Settings Settings
        {
            set { settings = value; }
        }

        #region HTML Template

        public static string GenerateHTML(string input)
        {
            string html = string.Empty;
            Exception ex = null;
            string templateLocation = settings.TemplateLocation;
            if (templateLocation == string.Empty)
            {
                templateLocation = "$(PluginFolder)/html-templates/template.html";
            }
            if (templateLocation.IndexOf("$(PluginFolder)") > -1)
            {
                templateLocation = templateLocation.Replace(
                                        "$(PluginFolder)", PathHelper.PluginDir);
            }
            try
            {
                using (StreamReader sr = new StreamReader(templateLocation))
                {
                    html = sr.ReadToEnd();
                }
            }
            catch (Exception e)
            {
                if (!File.Exists(templateLocation))
                {
                    if (!File.Exists(Path.GetDirectoryName(templateLocation)))
                    {
                        string directoryPath = Path.GetDirectoryName(templateLocation);
                        Directory.CreateDirectory(directoryPath);
                    }
                    using (FileStream fs = File.Create(templateLocation))
                    {
                        UTF8Encoding enc = new UTF8Encoding();
                        string template = LocaleHelper.GetString("HTML.Template");
                        byte[] templateBytes = enc.GetBytes(template);
                        fs.Write(templateBytes, 0, enc.GetByteCount(template));
                    }
                    return GenerateHTML(input);
                }
                ex = e;
            }
            if (ex != null)
            {
                MessageBox.Show(null, "Cannot find HTML template: " + ex.Message, "Error");
                return input;
            }
            html = html.Replace("%ForegroundColor%", ToSixPlacesHex(settings.ForegroundColor));
            html = html.Replace("%BackgroundOddColor%", ToSixPlacesHex(settings.BackgroundOddColor));
            html = html.Replace("%BackgroundEvenColor%", ToSixPlacesHex(settings.BackgroundEvenColor));
            html = html.Replace("%JavaCommentColor%", ToSixPlacesHex(settings.JavaCommentColor));
            html = html.Replace("%LineCommentColor%", ToSixPlacesHex(settings.LineCommentColor));
            html = html.Replace("%StringColor%", ToSixPlacesHex(settings.StringColor));
            html = html.Replace("%NumberColor%", ToSixPlacesHex(settings.NumberColor));
            html = html.Replace("%RegexColor%", ToSixPlacesHex(settings.RegexColor));
            html = html.Replace("%XmlColor%", ToSixPlacesHex(settings.XmlColor));
            html = html.Replace("%KeyWordColor%", ToSixPlacesHex(settings.KeyWordColor));
            html = html.Replace("%BuiltInColor%", ToSixPlacesHex(settings.BuiltInColor));
            html = html.Replace("%JdockKeywordColor%", ToSixPlacesHex(settings.JdockKeywordColor));
            html = html.Replace("%Code%", input);
            html = html.Replace("%height%", (_codeHeight * 15).ToString());
                
            return html;
        }

        private static string ToSixPlacesHex(Color input)
        {
            string s = input.ToArgb().ToString("X");
            if (s.Length > 6) s = s.Substring(s.Length - 6);
            while (s.Length < 6) s = '0' + s;
            return '#' + s;
        }

        #endregion

        #region ParseAS3Code

        public static string ParseAS3Code(string input)
        {
            if (!_init) _init = Init();
            int i = 0;
            int l;
            int s = 0;
            int sl;
            int xmlTagStartEnd;
            int xmlTagEnd;

            string st;
            string reCheck;

            char chr = ' ';

            Regex tabSpace = new Regex("^([\\t\\s]*)", RegexOptions.Compiled);
            Regex regexInside = new Regex("^[^\\\\]\\/(.*)[^\\\\]\\/", RegexOptions.Compiled);
            Regex notW = new Regex("\\W", RegexOptions.Compiled);
            Regex digit = new Regex("\\d", RegexOptions.Compiled);
            Regex hexDigit = new Regex("\\d|A|B|C|D|E|F", RegexOptions.Compiled);
            Regex w = new Regex("\\w", RegexOptions.Compiled);
            Regex lineW = new Regex("^\\w*$", RegexOptions.Compiled);
            Regex newLine = new Regex("\\n*\\r\\n*");

            bool breakLineLoop = false;

            _text = input;

            _lines = newLine.Split(_text);
            l = _lines.Length;
            _codeHeight = l + 2;
            try
            {
                while (i < l)
                {
                    s = 0;
                    st = _lines[i];
                    sl = st.Length;
                    if (_isJavaComment)
                    {
                        st = tabSpace.Replace(st, "$1<**** class=\"s00\">");
                        int commentIndex = st.IndexOf(JCOMMENT);
                        string space = st.Substring(0, commentIndex);
                        space = space.Replace(" ", "^^%%");
                        space = space.Replace("\t", "@^%%");
                        st = tabSpace.Replace(st, space);
                        s += st.IndexOf(JCOMMENT) + 18;
                        sl = st.Length;
                    }
                    else if (_isXML && _isOpenNode)
                    {
                        xmlTagEnd = LineIsXMLEnd(st, 0);
                        if (xmlTagEnd > -1)
                        {
                            _isXML = false;
                            st = st.Substring(0, xmlTagEnd + 1) +
                            SPAN_END +
                            st.Substring(xmlTagEnd + 1, st.Length - (xmlTagEnd + 1));

                            st = tabSpace.Replace(st, "$1<**** class=\"s05\">");
                            s += st.IndexOf(HTML) + 31;
                            sl = st.Length;
                        }
                        else
                        {
                            _xmlBody += st;
                            st = tabSpace.Replace(st, "$1<**** class=\"s05\">");
                            sl = st.Length;
                            s = sl;
                        }
                    }
                    if (sl == 0) st = " ";
                    while (s < st.Length)
                    {
                        breakLineLoop = false;
                        if (_isEscaped) _isPreviousEscaped = true;
                        chr = st[s];
                        switch (chr)
                        {
                            case '\"':
                                _word = "";
                                if (!_isEscaped && !_isLineComment &&
                                    !_isJavaComment && !_isString &&
                                    !_isApostropheString && !_isXML && !_isRegExp)
                                {
                                    _isString = true;
                                    _isApostropheString = false;
                                    st = st.Substring(0, s) +
                                    STRING +
                                    st.Substring(s, st.Length - s);
                                    sl += 18;
                                    s += 18;
                                }
                                else if (!_isEscaped && !_isXML &&
                                        !_isApostropheString && _isString &&
                                        !_isJavaComment && !_isRegExp)
                                {
                                    _isString = false;
                                    _isApostropheString = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 7;
                                    s += 7;
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case '\'':
                                _word = "";
                                if (!_isEscaped && !_isLineComment &&
                                    !_isXML && !_isJavaComment && !_isString &&
                                    !_isApostropheString && !_isRegExp)
                                {
                                    _isString = true;
                                    _isApostropheString = true;
                                    st = st.Substring(0, s) +
                                    STRING +
                                    st.Substring(s, st.Length - s);
                                    sl += 18;
                                    s += 18;
                                }
                                else if (!_isEscaped && !_isXML &&
                                        _isApostropheString && _isString &&
                                        !_isJavaComment && !_isRegExp)
                                {
                                    _isApostropheString = false;
                                    _isString = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 7;
                                    s += 7;
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case '\\':
                                _word = "";
                                _isEscaped = true;
                                if (_isXML) _xmlBody += chr;
                                break;
                            case '/':
                                _word = "";
                                if (!_isXML && !_isString && !_isApostropheString && 
                                    s > 0 && !_isJavaComment && st[s - 1] == '/')
                                {
                                    _isLineComment = true;
                                    string theComment = st.Substring(s - 1, st.Length - (s - 1));
                                    theComment = theComment.Replace("<", "&lt;");
                                    theComment = theComment.Replace(">", "&gt;");
                                    st = st.Substring(0, s - 1) + COMMENT + theComment;
                                    breakLineLoop = true;
                                    break;
                                }
                                else if (!_isString && !_isApostropheString && s > 0 &&
                                        !_isXML && st[s - 1] == '*')
                                {
                                    _isJavaComment = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 7;
                                    s += 7;
                                }
                                else if (!_isApostropheString && !_isString && s > 0 &&
                                        !_isXML && !_isJavaComment && !_isRegExp)
                                {
                                    reCheck = st.Substring(s - 1);
                                    if (st.Length > s + 1 && st[s + 1] != '*' && st[s + 1] != '/' &&
                                        regexInside.IsMatch(reCheck))
                                    {
                                        _isRegExp = true;
                                        st = st.Substring(0, s) +
                                        REGEXP +
                                        st.Substring(s, st.Length - s);
                                        sl += 18;
                                        s += 18;
                                    }
                                }
                                else if (!_isXML && _isRegExp && !_isEscaped)
                                {
                                    _isRegExp = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 7;
                                    s += 7;
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case '*':
                                _word = "";
                                if (!_isXML && !_isString && !_isApostropheString && !_isJavaComment
                                    && s > 0 && st[s - 1] == '/')
                                {
                                    st = st.Substring(0, s - 1) +
                                    JCOMMENT +
                                    st.Substring(s - 1, st.Length - (s - 1));
                                    sl += 18;
                                    s += 18;
                                    _isJavaComment = true;

                                    if (s + 2 < st.Length && st.IndexOf("*/", s + 2) < 0)
                                    {
                                        breakLineLoop = true;
                                        break;
                                    }
                                    else if (s + 2 < st.Length)
                                    {
                                        s = st.IndexOf("*/", s + 2);
                                        sl = st.Length;
                                    }
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case '0':
                            case '1':
                            case '2':
                            case '3':
                            case '4':
                            case '5':
                            case '6':
                            case '7':
                            case '8':
                            case '9':
                                // TODO: Exponential numbers!
                                if (!_isJavaComment && !_isLineComment &&
                                    !_isRegExp && !_isApostropheString &&
                                    !_isNumber && !_isHex && !_isXML &&
                                    !_isString && notW.IsMatch(st[s - 1].ToString()))
                                {
                                    if (s < st.Length - 1 && st[s + 1] == 'x')
                                    {
                                        _isHex = true;
                                    }
                                    else
                                    {
                                        _isNumber = true;
                                    }
                                    _word = "";
                                    st = st.Substring(0, s) +
                                    NUMBER +
                                    st.Substring(s, st.Length - s);
                                    sl += 18;
                                    s += 18;
                                }
                                else if ((!_isXML && _isNumber && !digit.IsMatch(st[s + 1].ToString())) ||
                                        (!_isXML && _isHex && !hexDigit.IsMatch(st[s + 1].ToString()) &&
                                        st[s + 1] != 'x'))
                                {
                                    _isNumber = false;
                                    _isHex = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 7;
                                    s += 7;
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case 'A':
                            case 'B':
                            case 'C':
                            case 'D':
                            case 'E':
                            case 'F':
                            case 'a':
                            case 'b':
                            case 'c':
                            case 'd':
                            case 'e':
                            case 'f':
                                if (!_isXML && _isHex &&
                                    !hexDigit.IsMatch(st[s + 1].ToString()))
                                {
                                    _word = "";
                                    _isHex = false;
                                    _isNumber = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 7;
                                    s += 7;
                                }
                                else if (_isXML)
                                {
                                    _word = "";
                                    _xmlBody += chr;
                                }
                                else if (!_isXML && !_isString && !_isJavaComment &&
                                        !_isLineComment && !_isHex && !_isRegExp)
                                {
                                    if (s < st.Length - 1 && !w.IsMatch(st[s + 1].ToString()) && IsClass(_word + chr))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        TYPE + _word + chr + SPAN_END +
                                        st.Substring(s + 1, st.Length - (s + 1));
                                        sl += 25;
                                        s += 25;
                                        _word = "";
                                    }
                                    else if (s < st.Length - 1 && !w.IsMatch(st[s + 1].ToString()) && IsKeyWord(_word + chr))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        BUILTIN + _word + chr + SPAN_END +
                                        st.Substring(s + 1, st.Length - (s + 1));
                                        sl += 25;
                                        s += 25;
                                        _word = "";
                                    }
                                    else
                                    {
                                        _word += chr;
                                    }
                                }
                                break;
                            case '<':
                                _word = "";
                                st = st.Substring(0, s) +
                                "&lt;" +
                                st.Substring(s + 1, st.Length - (s + 1));
                                sl += 3;
                                s += 3;
                                if (!_isXML && !_isJavaComment && !_isApostropheString &&
                                    !_isString && st[s - 1] != '.' &&
                                    st[s + 1] != ' ' && st[s + 1] != '\t')
                                {
                                    xmlTagStartEnd = CheckForXMLStart(st, s, i);
                                    if (xmlTagStartEnd > -1)
                                    {
                                        _isXML = true;
                                        st = st.Substring(0, s) +
                                        HTML +
                                        st.Substring(s, st.Length - s);
                                        sl += (18 + xmlTagStartEnd);
                                        s += (18 + xmlTagStartEnd);
                                    }
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case '>':
                                _word = "";
                                if (_isXML && CheckForXMLEnd(st, s, i))
                                {
                                    _isXML = false;
                                    _isOpenNode = false;
                                    st = st.Substring(0, s + 1) +
                                    SPAN_END +
                                    st.Substring(s + 1, st.Length);
                                    sl += 7;
                                    s += 7;
                                    xmlTagEnd = s;
                                }
                                else if (_isXML) _xmlBody += chr;
                                break;
                            case '+':
                            case '-':
                            case '=':
                            case '!':
                            case '&':
                            case '|':
                            case '.':
                            case ':':
                            case '[':
                            case ']':
                            case '{':
                            case '}':
                            case '(':
                            case ')':
                            case '%':
                            case '^':
                            case '~':
                                bool isAmp = chr == '&';
                                if (isAmp)
                                {
                                    st = st.Substring(0, s) + "&amp;" + 
                                        st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 4;
                                    s += 4;
                                }
                                if (!_isXML && !_isRegExp && !_isString && !_isJavaComment && !_isLineComment)
                                {
                                    if (IsClass(_word))
                                    {
                                        st = st.Substring(0, s - (_word.Length + (isAmp ? 4 : 0))) +
                                        TYPE + _word + SPAN_END +
                                        st.Substring(s, st.Length - s);
                                        sl += 25;
                                        s += 25;
                                    }
                                    else if (IsKeyWord(_word + chr))
                                    {
                                        st = st.Substring(0, s - (_word.Length + (isAmp ? 4 : 0))) +
                                        BUILTIN + _word + SPAN_END +
                                        st.Substring(s, st.Length - s);
                                        sl += 25;
                                        s += 25;
                                    }
                                }
                                _word = "";
                                break;
                            case ' ':
                                if (!_isXML && !_isRegExp && !_isString && !_isJavaComment && !_isLineComment)
                                {
                                    if (IsClass(_word))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        TYPE + _word + "^^%%" + SPAN_END +
                                        st.Substring(s, st.Length - s);
                                        sl += 25;
                                        s += 25;
                                    }
                                    else if (IsKeyWord(_word))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        BUILTIN + _word + "^^%%" + SPAN_END +
                                        st.Substring(s, st.Length - s);
                                        sl += 25;
                                        s += 25;
                                    }
                                    else
                                    {
                                        st = st.Substring(0, s) +
                                            "^^%%" +
                                            st.Substring(s + 1, st.Length - (s + 1));
                                        sl += 3;
                                        s += 3;
                                    }
                                }
                                else
                                {
                                    st = st.Substring(0, s) +
                                        "^^%%" +
                                        st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 3;
                                    s += 3;
                                }
                                _word = "";
                                break;
                            case '\t':
                                if (!_isXML && !_isRegExp && !_isString && !_isJavaComment && !_isLineComment)
                                {
                                    if (IsClass(_word))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        TYPE + _word + "@^%%" + SPAN_END +
                                        st.Substring(s, st.Length - s);
                                        sl += 25;
                                        s += 25;
                                    }
                                    else if (IsKeyWord(_word))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        BUILTIN + _word + "@^%%" + SPAN_END +
                                        st.Substring(s, st.Length - s);
                                        sl += 25;
                                        s += 25;
                                    }
                                    else
                                    {
                                        st = st.Substring(0, s) +
                                            "@^%%" +
                                            st.Substring(s + 1, st.Length - (s + 1));
                                        sl += 3;
                                        s += 3;
                                    }
                                }
                                else
                                {
                                    st = st.Substring(0, s) +
                                        "@^%%" +
                                        st.Substring(s + 1, st.Length - (s + 1));
                                    sl += 3;
                                    s += 3;
                                }
                                _word = "";
                                break;
                            default:
                                if ((_isNumber || _isHex) && chr != 'x' && !hexDigit.IsMatch(chr.ToString()))
                                {
                                    _word = "";
                                    _isHex = false;
                                    _isNumber = false;
                                    st = st.Substring(0, s) +
                                    SPAN_END +
                                    st.Substring(s, st.Length - s);
                                    sl += 7;
                                    s += 7;
                                }
                                else if (_isXML)
                                {
                                    _word = "";
                                    _xmlBody += chr;
                                }
                                else if (!_isString && !_isRegExp && !_isJavaComment && !_isHex &&
                                        !_isNumber && !_isLineComment && lineW.IsMatch(_word))
                                {
                                    if (s < st.Length - 1 && !w.IsMatch(st[s + 1].ToString()) && IsClass(_word + chr))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        TYPE + _word + chr + SPAN_END +
                                        st.Substring(s + 1, st.Length - (s + 1));
                                        sl += 25;
                                        s += 25;
                                        _word = "";
                                    }
                                    else if (s < st.Length - 1 && !w.IsMatch(st[s + 1].ToString()) && IsKeyWord(_word + chr))
                                    {
                                        st = st.Substring(0, s - _word.Length) +
                                        BUILTIN + _word + chr + SPAN_END +
                                        st.Substring(s + 1, st.Length - (s + 1));
                                        sl += 25;
                                        s += 25;
                                        _word = "";
                                    }
                                    else
                                    {
                                        _word += chr;
                                    }
                                }
                                break;
                        }
                        if (breakLineLoop) break;
                        if (_isPreviousEscaped)
                        {
                            _isEscaped = false;
                            _isPreviousEscaped = false;
                        }
                        s++;
                    }
                    // TODO: Check for last keyword / classname
                    _word = "";
                    if (_isApostropheString || _isString) st += SPAN_END;
                    if (_isLineComment) st += SPAN_END;
                    if (_isRegExp) st += SPAN_END;
                    if (_isNumber) st += SPAN_END;
                    if (_isHex) st += SPAN_END;
                    if (_isJavaComment) st += SPAN_END;
                    if (_isXML) st += SPAN_END;
                    _lines[i] = HtmlEncode(st);
                    if (_isJavaComment)
                    {
                        _lines[i] = DoJDocKeywords(_lines[i]);
                    }
                    _isLineComment = false;
                    _isApostropheString = false;
                    _isString = false;
                    _isRegExp = false;
                    _isNumber = false;
                    _isHex = false;

                    i++;
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Parsing failure at line: " + 
                    i.ToString() + ", char: " + s.ToString() + 
                    " [" + chr + "]" + "\n" + ex.Message);
            }
            l = _lines.Length;
            i = 0;
            st = "";
            while (i < l)
            {
                st += "<li class=\"c " + (((i % 2) != 0) ? "even" : "odd") +
                    "\"><span class=\"cd\">" + _lines[i] + "</li>\r";
                i++;
            }
            string ret = "<ol class=\"codeOL\">" + st + "</ol>";
            System.Xml.XmlDocument xml = new System.Xml.XmlDocument();
            try
            {
                xml.LoadXml(ret);
            }
            catch (System.Xml.XmlException exp)
            {
                //System.Console.Write(ret);
                throw new Exception("XML was malformed at line: " +
                    exp.LineNumber + " char: " + exp.LinePosition + " [" + _lines[exp.LineNumber - 1] + "]");
            }
            ReplaceWhiteSpace(xml);
            ret = xml.InnerXml.Replace("^^%%", "&nbsp;");
            ret = ret.Replace("@^%%", "&nbsp;&nbsp;&nbsp;&nbsp;");
            return GenerateHTML(ret);
        }

        #endregion


        #region Helper Functions

        static private void ReplaceWhiteSpace(System.Xml.XmlNode xml)
        {
            System.Xml.XmlNodeList list = xml.ChildNodes;
            System.Xml.XmlNodeList grandChildren;
            foreach (System.Xml.XmlNode child in list)
            {
                if (child.NodeType == System.Xml.XmlNodeType.Text)
                {
                    child.InnerText = child.InnerText.Replace(" ", "^^%%");
                }
                else if (child.NodeType == System.Xml.XmlNodeType.Element)
                {
                    grandChildren = child.ChildNodes;
                    foreach (System.Xml.XmlNode nephew in grandChildren)
                    {
                        ReplaceWhiteSpace(nephew);
                    }
                }
            }
        }

        static private string DoJDocKeywords(string input)
        {
            Regex re;
            foreach (string s in DOC_KEYWORDS)
            {
                if (input.IndexOf("@" + s) < 0) continue;
                re = new Regex("(@)(" + s + ")(\\W)");
                input = re.Replace(input, "<span class=\"s08\">$1$2</span>$3");
                //input = input.Replace("<", "&lt;");
                //input = input.Replace(">", "&gt;");
            }
            return input;
        }

        static private string DoKeyWords(string input)
        {
            Regex re;
            foreach (string s in KEYWORDS)
            {
                if (input.IndexOf(s) < 0) continue;
                if (s == "class")
                {
                    re = new Regex("(^|\\W)(" + s + ")([^=\\w])");
                }
                else
                {
                    re = new Regex("(^|\\W)(" + s + ")(\\W)");
                }
                input = re.Replace(input, "$1<span class=\"s06\">$2</span>$3");
            }
            foreach (string s in SECONDARY_KEYWORDS)
            {
                if (input.IndexOf(s) < 0) continue;
                re = new Regex("(^|\\W)(" + s + ")(\\W)");
                input = re.Replace(input, "$1<span class=\"s06\">$2</span>$3");
            }
            foreach (string s in CLASSES)
            {
                if (input.IndexOf(s) < 0) continue;
                re = new Regex("(^|\\W)(" + s + ")(\\W)");
                input = re.Replace(input, "$1<span class=\"s07\">$2</span>$3");
            }
            return input;
        }

        private static bool IsKeyWord(string input)
        {
            foreach (string s in KEYWORDS)
            {
                if (s == input) return true;
            }
            foreach (string s in SECONDARY_KEYWORDS)
            {
                if (s == input) return true;
            }
            return false;
        }

        private static bool IsClass(string input)
        {
            foreach (string s in CLASSES)
            {
                if (s == input) return true;
            }
            return false;
        }

        static private int LineIsXMLEnd(string input, int pos)
        {
            int lastIndex = input.IndexOf(">", pos);
            System.Xml.XmlDocument xml = new System.Xml.XmlDocument();
            if (lastIndex < 0) return lastIndex;
            try
            {
                xml.LoadXml(_xmlBody + input.Substring(0, lastIndex + 1));
                return lastIndex;
            }
            catch
            {
                return LineIsXMLEnd(input, lastIndex + 1);
            }
            //return -1;
        }

        static private bool CheckForXMLEnd(string currentLine, int lineIndex,
                                                        int arrayIndex)
        {
            switch (_xmlNodeType)
            {
                case 1:
                    if (currentLine[lineIndex - 1] == '-' && currentLine[lineIndex - 2] == '-')
                    {
                        return true;
                    }
                    break;
                case 2:
                    if (currentLine[lineIndex - 1] == ']' && currentLine[lineIndex - 2] == ']')
                    {
                        return true;
                    }
                    break;
                case 3:
                    if (currentLine[lineIndex - 1] == '?')
                    {
                        return true;
                    }
                    break;
                case 4:
                    if (!_isOpenNode && currentLine[lineIndex - 1] == '/')
                    {
                        return true;
                    }
                    break;
            }
            return false;
        }

        static private int CheckForXMLStart(string currentLine, int lineIndex,
                                                        int arrayIndex)
        {
            int lastGT = currentLine.IndexOf("/>", lineIndex);
            int tagEnd;

            int subtr;

            if (lastGT < 0)
            {
                if (lastGT < lineIndex)
                {
                    lastGT = currentLine.IndexOf("-->", lineIndex);
                    subtr = 3;
                }

                if (lastGT < lineIndex)
                {
                    lastGT = currentLine.IndexOf("]]>", lineIndex);
                    subtr = 3;
                }
                if (lastGT < lineIndex)
                {
                    lastGT = currentLine.IndexOf("?>", lineIndex);
                    subtr = 2;
                }
                if (lastGT < lineIndex)
                {
                    lastGT = currentLine.IndexOf(">", lineIndex);
                    _isOpenNode = true;
                    subtr = 1;
                }

                if (lastGT < lineIndex)
                {
                    lastGT = currentLine.Length;
                    subtr = 0;
                }
                tagEnd = currentLine.Length;
                _xmlBody = currentLine.Substring(lineIndex, lastGT - lineIndex);
            }
            else
            {
                tagEnd = lastGT - 2;
                _xmlBody = currentLine.Substring(lineIndex, tagEnd);
            }
            if (CheckValidOpenTag(_xmlBody))
            {
                return tagEnd - (lineIndex + 2);
            }
            else
            {
                _xmlBody = "";
                return -1;
            }
        }

        static private bool CheckValidOpenTag(string input)
        {
            Regex re1 = new Regex("^<--", RegexOptions.Compiled);
            Regex re2 = new Regex("^<!\\[CDATA\\[", RegexOptions.Compiled);
            Regex re3 = new Regex("^<\\?\\w", RegexOptions.Compiled);
            Regex re4 = new Regex(
                "^<\\w[\\w\\.\\-\\$:_]*([\\s\\t]+?[\\w\\.\\-\\$:_]*\\s*=\\s*(\"|')[^\\2]*\\2)*$",
                RegexOptions.Compiled);

            if (re1.IsMatch(input))
            {
                _xmlNodeType = 1;
                return true;
            }
            if (re2.IsMatch(input))
            {
                _xmlNodeType = 2;
                return true;
            }
            if (re3.IsMatch(input))
            {
                _xmlNodeType = 3;
                return true;
            }
            // EXPERIMENTAL!
            //if (input.match(/^<\{/g).length && !input.match(/^<\{\w+:/g).length)
            //{
            //_xmlNodeType = 5;
            //return true;
            //}
            //if (input.match(/^<\w[\w\.\-\$:_]*[\s\t]+?\{/g).length)
            //{
            //_xmlNodeType = 6;
            //return true;
            //}
            //if (input.match(/^<\w[\w\.\-\$:_]*[\s\t]+?[\w\.\-\$:_]*\s*=\s*\{/g).length)
            //{
            //_xmlNodeType = 7;
            //return true;
            //}
            if (re4.IsMatch(input))
            {
                _xmlNodeType = 4;
                return true;
            }
            return false;
        }

        private static bool IsUTF(byte[] bytes)
        {
            if (bytes[0] != 0xEF) return false;
            if (bytes[1] != 0xBB) return false;
            if (bytes[2] != 0xBF) return false;
            return true;
        }

        private static bool Init()
        {
            Regex re = new Regex("xxx", RegexOptions.Compiled);
            JCOMMENT = re.Replace(SPAN_BEGIN, JCOMMENT_C);
            COMMENT = re.Replace(SPAN_BEGIN, COMMENT_C);
            STRING = re.Replace(SPAN_BEGIN, STRING_C);
            NUMBER = re.Replace(SPAN_BEGIN, NUMBER_C);
            REGEXP = re.Replace(SPAN_BEGIN, REGEXP_C);
            HTML = re.Replace(SPAN_BEGIN, HTML_C);
            BUILTIN = re.Replace(SPAN_BEGIN, BUILTIN_C);
            TYPE = re.Replace(SPAN_BEGIN, TYPE_C);
            return true;
        }

        // TODO: Replace spaces and tabs
        private static string HtmlEncode(string input)
        {
            Regex re0 = new Regex("<\\*\\*\\*\\*", RegexOptions.Compiled);
            Regex re1 = new Regex("<\\/\\*\\*\\*\\*", RegexOptions.Compiled);
            input = re0.Replace(input, "<span");
            //input = input.Replace(" ", "&nbsp;");
            //input = input.Replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");
            return re1.Replace(input, "</span") + "</span>";
        }

        #endregion
    }
}