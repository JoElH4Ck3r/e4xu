using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;

namespace SamHaXePanel.Dialogs
{
    public partial class AddFontDialog : Form
    {
        private static Dictionary<String, LanguagePlane> allPlanes =
            new Dictionary<String, LanguagePlane>();
        private Dictionary<String, LanguagePlane> activePlanes;

        #region Fill All Language Planes

        static AddFontDialog()
        {
            allPlanes["Basic Latin"] = new LanguagePlane(0x20, 0x007F);
            allPlanes["Latin-1 Supplement"] = new LanguagePlane(0x0080, 0x00FF);
            allPlanes["Latin Extended-A"] = new LanguagePlane(0x0100, 0x017F);
            allPlanes["Latin Extended-B"] = new LanguagePlane(0x0180, 0x024F);
            allPlanes["IPA Extensions"] = new LanguagePlane(0x0250, 0x02AF);
            allPlanes["Spacing Modifier Letters"] = new LanguagePlane(0x02B0, 0x02FF);
            allPlanes["Combining Diacritical Marks"] = new LanguagePlane(0x0300, 0x036F);
            allPlanes["Greek and Coptic"] = new LanguagePlane(0x0370, 0x03FF);
            allPlanes["Cyrillic"] = new LanguagePlane(0x0400, 0x04FF);
            allPlanes["Cyrillic Supplement"] = new LanguagePlane(0x0500, 0x052F);
            allPlanes["Armenian"] = new LanguagePlane(0x0530, 0x058F);
            allPlanes["Hebrew"] = new LanguagePlane(0x0590, 0x05FF);
            allPlanes["Arabic"] = new LanguagePlane(0x0600, 0x06FF);
            allPlanes["Syriac"] = new LanguagePlane(0x0700, 0x074F);
            allPlanes["Arabic Supplement"] = new LanguagePlane(0x0750, 0x077F);
            allPlanes["Thaana"] = new LanguagePlane(0x0780, 0x07BF);
            allPlanes["N'Ko (Mandenkan)"] = new LanguagePlane(0x07C0, 0x07FF);
            allPlanes["Devanagari"] = new LanguagePlane(0x0900, 0x097F);
            allPlanes["Bengali"] = new LanguagePlane(0x0980, 0x09FF);
            allPlanes["Gurmukhi"] = new LanguagePlane(0x0A00, 0x0A7F);
            allPlanes["Gujarati"] = new LanguagePlane(0x0A80, 0x0AFF);
            allPlanes["Oriya"] = new LanguagePlane(0x0B00, 0x0B7F);
            allPlanes["Tamil"] = new LanguagePlane(0x0B80, 0x0BFF);
            allPlanes["Telugu"] = new LanguagePlane(0x0C00, 0x0C7F);
            allPlanes["Kannada"] = new LanguagePlane(0x0C80, 0x0CFF);
            allPlanes["Malayalam"] = new LanguagePlane(0x0D00, 0x0D7F);
            allPlanes["Sinhala"] = new LanguagePlane(0x0D80, 0x0DFF);
            allPlanes["Thai"] = new LanguagePlane(0x0E00, 0x0E7F);
            allPlanes["Lao"] = new LanguagePlane(0x0E80, 0x0EFF);
            allPlanes["Tibetan"] = new LanguagePlane(0x0F00, 0x0FFF);
            allPlanes["Burmese (Myanmar)"] = new LanguagePlane(0x1000, 0x109F);
            allPlanes["Georgian"] = new LanguagePlane(0x10A0, 0x10FF);
            allPlanes["Hangul Jamo"] = new LanguagePlane(0x1100, 0x11FF);
            allPlanes["Ethiopic"] = new LanguagePlane(0x1200, 0x137F);
            allPlanes["Ethiopic Supplement"] = new LanguagePlane(0x1380, 0x139F);
            allPlanes["Cherokee"] = new LanguagePlane(0x13A0, 0x13FF);
            allPlanes["Unified Canadian Aboriginal Syllabics"] = new LanguagePlane(0x1400, 0x167F);
            allPlanes["Ogham"] = new LanguagePlane(0x1680, 0x169F);
            allPlanes["Runic"] = new LanguagePlane(0x16A0, 0x16FF);
            allPlanes["Tagalog"] = new LanguagePlane(0x1700, 0x171F);
            allPlanes["Hanunóo"] = new LanguagePlane(0x1720, 0x173F);
            allPlanes["Buhid"] = new LanguagePlane(0x1740, 0x175F);
            allPlanes["Tagbanwa"] = new LanguagePlane(0x1760, 0x177F);
            allPlanes["Khmer"] = new LanguagePlane(0x1780, 0x17FF);
            allPlanes["Mongolian"] = new LanguagePlane(0x1800, 0x18AF);
            allPlanes["Limbu"] = new LanguagePlane(0x1900, 0x194F);
            allPlanes["Tai Le"] = new LanguagePlane(0x1950, 0x197F);
            allPlanes["New Tai Lue"] = new LanguagePlane(0x1980, 0x19DF);
            allPlanes["Khmer Symbols"] = new LanguagePlane(0x19E0, 0x19FF);
            allPlanes["Buginese"] = new LanguagePlane(0x1A00, 0x1A1F);
            allPlanes["Balinese"] = new LanguagePlane(0x1B00, 0x1B7F);
            allPlanes["Sundanese"] = new LanguagePlane(0x1B80, 0x1BBF);
            allPlanes["Lepcha (Rong)"] = new LanguagePlane(0x1C00, 0x1C4F);
            allPlanes["Ol Chiki (Santali / Ol Cemet’)"] = new LanguagePlane(0x1C50, 0x1C7F);
            allPlanes["Phonetic Extensions"] = new LanguagePlane(0x1D00, 0x1D7F);
            allPlanes["Phonetic Extensions Supplement"] = new LanguagePlane(0x1D80, 0x1DBF);
            allPlanes["Combining Diacritical Marks Supplement"] = new LanguagePlane(0x1DC0, 0x1DFF);
            allPlanes["Latin Extended Additional"] = new LanguagePlane(0x1E00, 0x1EFF);
            allPlanes["Greek Extended"] = new LanguagePlane(0x1F00, 0x1FFF);
            allPlanes["General Punctuation"] = new LanguagePlane(0x2000, 0x206F);
            allPlanes["Superscripts and Subscripts"] = new LanguagePlane(0x2070, 0x209F);
            allPlanes["Currency Symbols"] = new LanguagePlane(0x20A0, 0x20CF);
            allPlanes["Combining Diacritical Marks for Symbols"] = new LanguagePlane(0x20D0, 0x20FF);
            allPlanes["Letterlike Symbols"] = new LanguagePlane(0x2100, 0x214F);
            allPlanes["Number Forms"] = new LanguagePlane(0x2150, 0x218F);
            allPlanes["Arrows"] = new LanguagePlane(0x2190, 0x21FF);
            allPlanes["Mathematical Operators"] = new LanguagePlane(0x2200, 0x22FF);
            allPlanes["Miscellaneous Technical"] = new LanguagePlane(0x2300, 0x23FF);
            allPlanes["Control Pictures"] = new LanguagePlane(0x2400, 0x243F);
            allPlanes["Optical Character Recognition"] = new LanguagePlane(0x2440, 0x245F);
            allPlanes["Enclosed Alphanumerics"] = new LanguagePlane(0x2460, 0x24FF);
            allPlanes["Box Drawing"] = new LanguagePlane(0x2500, 0x257F);
            allPlanes["Block Elements"] = new LanguagePlane(0x2580, 0x259F);
            allPlanes["Geometric Shapes"] = new LanguagePlane(0x25A0, 0x25FF);
            allPlanes["Miscellaneous Symbols"] = new LanguagePlane(0x2600, 0x26FF);
            allPlanes["Dingbats"] = new LanguagePlane(0x2700, 0x27BF);
            allPlanes["Miscellaneous Mathematical Symbols-A"] = new LanguagePlane(0x27C0, 0x27EF);
            allPlanes["Supplemental Arrows-A"] = new LanguagePlane(0x27F0, 0x27FF);
            allPlanes["Braille Patterns"] = new LanguagePlane(0x2800, 0x28FF);
            allPlanes["Supplemental Arrows-B"] = new LanguagePlane(0x2900, 0x297F);
            allPlanes["Miscellaneous Mathematical Symbols-B"] = new LanguagePlane(0x2980, 0x29FF);
            allPlanes["Supplemental Mathematical Operators"] = new LanguagePlane(0x2A00, 0x2AFF);
            allPlanes["Miscellaneous Symbols and Arrows"] = new LanguagePlane(0x2B00, 0x2BFF);
            allPlanes["Glagolitic"] = new LanguagePlane(0x2C00, 0x2C5F);
            allPlanes["Latin Extended-C"] = new LanguagePlane(0x2C60, 0x2C7F);
            allPlanes["Coptic"] = new LanguagePlane(0x2C80, 0x2CFF);
            allPlanes["Georgian Supplement"] = new LanguagePlane(0x2D00, 0x2D2F);
            allPlanes["Tifinagh"] = new LanguagePlane(0x2D30, 0x2D7F);
            allPlanes["Ethiopic Extended"] = new LanguagePlane(0x2D80, 0x2DDF);
            allPlanes["Cyrillic Extended-A"] = new LanguagePlane(0x2DE0, 0x2DFF);
            allPlanes["Supplemental Punctuation"] = new LanguagePlane(0x2E00, 0x2E7F);
            allPlanes["CJK Radicals Supplement"] = new LanguagePlane(0x2E80, 0x2EFF);
            allPlanes["Kangxi Radicals"] = new LanguagePlane(0x2F00, 0x2FDF);
            allPlanes["Ideographic Description Characters"] = new LanguagePlane(0x2FF0, 0x2FFF);
            allPlanes["CJK Symbols and Punctuation"] = new LanguagePlane(0x3000, 0x303F);
            allPlanes["Hiragana"] = new LanguagePlane(0x3040, 0x309F);
            allPlanes["Katakana"] = new LanguagePlane(0x30A0, 0x30FF);
            allPlanes["Bopomofo"] = new LanguagePlane(0x3100, 0x312F);
            allPlanes["Hangul Compatibility Jamo"] = new LanguagePlane(0x3130, 0x318F);
            allPlanes["Kanbun"] = new LanguagePlane(0x3190, 0x319F);
            allPlanes["Bopomofo Extended"] = new LanguagePlane(0x31A0, 0x31BF);
            allPlanes["CJK Strokes"] = new LanguagePlane(0x31C0, 0x31EF);
            allPlanes["Katakana Phonetic Extensions"] = new LanguagePlane(0x31F0, 0x31FF);
            allPlanes["Enclosed CJK Letters and Months"] = new LanguagePlane(0x3200, 0x32FF);
            allPlanes["CJK Compatibility"] = new LanguagePlane(0x3300, 0x33FF);
            allPlanes["CJK Unified Ideographs Extension A"] = new LanguagePlane(0x3400, 0x4DBF);
            allPlanes["Yijing Hexagram Symbols"] = new LanguagePlane(0x4DC0, 0x4DFF);
            allPlanes["CJK Unified Ideographs"] = new LanguagePlane(0x4E00, 0x9FFF);
            allPlanes["Yi Syllables"] = new LanguagePlane(0xA000, 0xA48F);
            allPlanes["Yi Radicals"] = new LanguagePlane(0xA490, 0xA4CF);
            allPlanes["Vai"] = new LanguagePlane(0xA500, 0xA63F);
            allPlanes["Cyrillic Extended-B"] = new LanguagePlane(0xA640, 0xA69F);
            allPlanes["Modifier Tone Letters"] = new LanguagePlane(0xA700, 0xA71F);
            allPlanes["Latin Extended-D"] = new LanguagePlane(0xA720, 0xA7FF);
            allPlanes["Syloti Nagri"] = new LanguagePlane(0xA800, 0xA82F);
            allPlanes["Phags-pa"] = new LanguagePlane(0xA840, 0xA87F);
            allPlanes["Saurashtra"] = new LanguagePlane(0xA880, 0xA8DF);
            allPlanes["Kayah Li"] = new LanguagePlane(0xA900, 0xA92F);
            allPlanes["Rejang"] = new LanguagePlane(0xA930, 0xA95F);
            allPlanes["Cham"] = new LanguagePlane(0xAA00, 0xAA5F);
            allPlanes["Hangul Syllables"] = new LanguagePlane(0xAC00, 0xD7AF);
            allPlanes["High Surrogates"] = new LanguagePlane(0xD800, 0xDB7F);
            allPlanes["High Private Use Surrogates"] = new LanguagePlane(0xDB80, 0xDBFF);
            allPlanes["Low Surrogates"] = new LanguagePlane(0xDC00, 0xDFFF);
            allPlanes["Private Use Area"] = new LanguagePlane(0xE000, 0xF8FF);
            allPlanes["CJK Compatibility Ideographs"] = new LanguagePlane(0xF900, 0xFAFF);
            allPlanes["Alphabetic Presentation Forms"] = new LanguagePlane(0xFB00, 0xFB4F);
            allPlanes["Arabic Presentation Forms-A"] = new LanguagePlane(0xFB50, 0xFDFF);
            allPlanes["Variation Selectors"] = new LanguagePlane(0xFE00, 0xFE0F);
            allPlanes["Vertical Forms"] = new LanguagePlane(0xFE10, 0xFE1F);
            allPlanes["Combining Half Marks"] = new LanguagePlane(0xFE20, 0xFE2F);
            allPlanes["CJK Compatibility Forms"] = new LanguagePlane(0xFE30, 0xFE4F);
            allPlanes["Small Form Variants"] = new LanguagePlane(0xFE50, 0xFE6F);
            allPlanes["Arabic Presentation Forms-B"] = new LanguagePlane(0xFE70, 0xFEFF);
            allPlanes["Halfwidth and Fullwidth Forms"] = new LanguagePlane(0xFF00, 0xFFEF);
            allPlanes["Specials"] = new LanguagePlane(0xFFF0, 0xFFFF);
        }

        #endregion

        public AddFontDialog()
        {
            InitializeComponent();
            this.fontGrid.AllowUserToResizeRows = false;
            this.activePlanes = new Dictionary<String, LanguagePlane>();
            this.activePlanes["Basic Latin"] = allPlanes["Basic Latin"];
            this.activePlanes["Latin-1 Supplement"] = allPlanes["Latin-1 Supplement"];
            this.activePlanes["Latin Extended-B"] = allPlanes["Latin Extended-B"];
            this.PopulateGrid();
            this.PopulateList();

            this.langPlanesCBL.ItemCheck += new ItemCheckEventHandler(langPlanesCBL_ItemCheck);
        }

        private void langPlanesCBL_ItemCheck(Object sender, ItemCheckEventArgs e)
        {
            this.activePlanes.Clear();
            foreach (String cbs in this.langPlanesCBL.CheckedItems)
            {
                if (e.NewValue == CheckState.Unchecked &&
                    cbs == (String)(this.langPlanesCBL.Items[e.Index]))
                    continue;
                this.activePlanes[cbs] = allPlanes[cbs];
            }
            if (e.NewValue == CheckState.Checked)
            {
                String cbs = (String)(this.langPlanesCBL.Items[e.Index]);
                Console.WriteLine("Missing value: " + cbs);
                this.activePlanes[cbs] = allPlanes[cbs];
            }
            this.PopulateGrid();
        }

        private void PopulateList()
        {
            foreach (String lp in allPlanes.Keys)
            {
                if (this.activePlanes.ContainsKey(lp))
                {
                    this.langPlanesCBL.Items.Add(lp, true);
                }
                else
                {
                    this.langPlanesCBL.Items.Add(lp, false);
                }
            }
        }

        private void PopulateGrid()
        {
            String[] row;
            Int32 iter = 32;

            this.fontGrid.Rows.Clear();
            foreach (LanguagePlane lp in this.activePlanes.Values)
            {
                row = new String[16];
                iter = lp.FromChar;
                while (lp.IsInRange(iter))
                {
                    for (Int32 i = 0; i < 16; i++)
                    {
                        row[i] = ((Char)iter).ToString();
                        iter++;
                        if (iter == 0x7FF) iter = 0x900;
                        else if (iter == 0x1A1F) iter = 0x1B00;
                        else if (iter == 0x1BBF) iter = 0x1C00;
                        else if (iter == 0xA95F) iter = 0xAA00;
                        else if (iter == 0xAA5F) iter = 0xAC00;
                        else if (iter == 0xD7AF) iter = 0xD800;
                        else if (iter == 0xDB80) iter = 0xF900;
                        else if (iter > lp.ToChar) break;
                    }
                    this.fontGrid.Rows.Add(row);
                }
            }
        }

        class LanguagePlane
        {
            public Int32 FromChar;
            public Int32 ToChar;

            public LanguagePlane(Int32 fChar, Int32 tChar)
            {
                this.FromChar = fChar;
                this.ToChar = tChar;
            }

            public Boolean IsInRange(Int32 character)
            {
                return character >= FromChar && character < ToChar;
            }
        }
    }
}
