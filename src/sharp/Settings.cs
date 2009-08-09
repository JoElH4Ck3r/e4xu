using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Windows.Forms;
using System.Text;
using System.Drawing;

namespace ExportHTML
{
    [Serializable]
    public class Settings
    {
        private Color lineCommentColor = Color.FromArgb(0x00, 0x60, 0x00);
        private Color javaCommentColor = Color.FromArgb(0x00, 0x80, 0x00);
        private Color stringColor = Color.FromArgb(0xA3, 0x15, 0x15);
        private Color numberColor = Color.FromArgb(0x00, 0x00, 0xFF);
        private Color builtInColor = Color.FromArgb(0x00, 0x90, 0x90);
        private Color keywordColor = Color.FromArgb(0x00, 0x00, 0x99);
        private Color regexColor = Color.FromArgb(0xFF, 0x00, 0xFF);
        private Color xmlColor = Color.FromArgb(0x80, 0x60, 0x60);
        private Color jdokKeywordColor = Color.FromArgb(0x00, 0x00, 0xFF);
        private Color bacgroundOddColor = Color.FromArgb(0xFF, 0xFF, 0xFF);
        private Color bacgroundEvenColor = Color.FromArgb(0xFF, 0xFF, 0xFF);
        private Color foregroundColor = Color.FromArgb(0x00, 0x00, 0x00);

        private Keys menuShortcut = Keys.Control | Keys.Alt | Keys.Shift | Keys.S;
        private Keys copyHTMLShortcut = Keys.Control | Keys.Alt | Keys.Shift | Keys.C;

        /// <summary> 
        /// Defines the color of line comments
        /// </summary>
        [Description("Defines the color of line comments."), DefaultValue(typeof(Color), "#006000")]
        public Color LineCommentColor
        {
            get { return this.lineCommentColor; }
            set { this.lineCommentColor = value; }
        }

        /// <summary> 
        /// Defines the color of JavaDoc style comments
        /// </summary>
        [Description("Defines the color of JavaDoc style comments."), DefaultValue(typeof(Color), "#008000")]
        public Color JavaCommentColor
        {
            get { return this.javaCommentColor; }
            set { this.javaCommentColor = value; }
        }

        /// <summary> 
        /// Defines the color of built-in classes
        /// </summary>
        [Description("Defines the color of built-in classes."), DefaultValue(typeof(Color), "#A31515")]
        public Color BuiltInColor
        {
            get { return this.builtInColor; }
            set { this.builtInColor = value; }
        }

        /// <summary> 
        /// Defines the color of keywords
        /// </summary>
        [Description("Defines the color of keywords."), DefaultValue(typeof(Color), "#0000FF")]
        public Color KeyWordColor
        {
            get { return this.keywordColor; }
            set { this.keywordColor = value; }
        }

        /// <summary> 
        /// Defines the color of strings
        /// </summary>
        [Description("Defines the color of strings."), DefaultValue(typeof(Color), "#009090")]
        public Color StringColor
        {
            get { return this.stringColor; }
            set { this.stringColor = value; }
        }

        /// <summary> 
        /// Defines the color of numbers
        /// </summary>
        [Description("Defines the color of numbers."), DefaultValue(typeof(Color), "#000099")]
        public Color NumberColor
        {
            get { return this.numberColor; }
            set { this.numberColor = value; }
        }

        /// <summary> 
        /// Defines the color of regular expressions
        /// </summary>
        [Description("Defines the color of regular expressions."), DefaultValue(typeof(Color), "#FF00FF")]
        public Color RegexColor
        {
            get { return this.regexColor; }
            set { this.regexColor = value; }
        }

        /// <summary> 
        /// Defines the color of inline XML
        /// </summary>
        [Description("Defines the color of inline XML."), DefaultValue(typeof(Color), "#806060")]
        public Color XmlColor
        {
            get { return this.xmlColor; }
            set { this.xmlColor = value; }
        }

        /// <summary> 
        /// Defines the color of JavaDoc keywords
        /// </summary>
        [Description("Defines the color of JavaDoc keywords."), DefaultValue(typeof(Color), "#0000FF")]
        public Color JdockKeywordColor
        {
            get { return this.jdokKeywordColor; }
            set { this.jdokKeywordColor = value; }
        }

        /// <summary> 
        /// Defines the color of background odd lines
        /// </summary>
        [Description("Defines the color of background odd lines."), DefaultValue(typeof(Color), "#FFFFFF")]
        public Color BackgroundOddColor
        {
            get { return this.bacgroundOddColor; }
            set { this.bacgroundOddColor = value; }
        }

        /// <summary> 
        /// Defines the color of background even lines
        /// </summary>
        [Description("Defines the color of background even lines."), DefaultValue(typeof(Color), "#FFFFFF")]
        public Color BackgroundEvenColor
        {
            get { return this.bacgroundEvenColor; }
            set { this.bacgroundEvenColor = value; }
        }

        /// <summary> 
        /// Defines the foreground text color
        /// </summary>
        [Description("Defines the foreground text color."), DefaultValue(typeof(Color), "#000000")]
        public Color ForegroundColor
        {
            get { return this.foregroundColor; }
            set { this.foregroundColor = value; }
        }

        /// <summary> 
        /// Get and sets the menuShortcut
        /// </summary>
        [Description("Save as HTML shortcut."), DefaultValue(Keys.Control | Keys.Alt | Keys.Shift | Keys.S)]
        public Keys MenuShortcut
        {
            get { return this.menuShortcut; }
            set { this.menuShortcut = value; }
        }

        /// <summary> 
        /// Get and sets the copyHTMLShortcut
        /// </summary>
        [Description("Copy as HTML shortcut."), DefaultValue(Keys.Control | Keys.Alt | Keys.Shift | Keys.C)]
        public Keys CopyHTMLShortcut
        {
            get { return this.copyHTMLShortcut; }
            set { this.copyHTMLShortcut = value; }
        }

    }

}
