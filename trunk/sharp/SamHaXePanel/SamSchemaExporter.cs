using System;
using System.Collections.Generic;
using System.Text;
using System.Xml;
using System.Windows.Forms;
using SamHaXePanel.Resources;

namespace SamHaXePanel
{
    class SamSchemaExporter
    {
        public static void ExportHaXeClasses(String file)
        {
            XmlDocument xml = new XmlDocument();
            try
            {
                xml.Load(file);
            }
            catch
            {
                MessageBox.Show(LocaleHelper.GetString(LocaleHelper.INVALID_FILE_ERROR));
                return;
            }
        }

        public static void ExportAS3Classes(String file)
        {

        }

        public static void ExportFlexClasses(String file)
        {

        }
    }
}
