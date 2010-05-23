using System;
using System.Text;
using System.Resources;
using System.Reflection;
using System.Collections.Generic;
using PluginCore.Localization;
using PluginCore.Managers;
using PluginCore;
using System.Drawing;

namespace SamHaXePanel.Resources
{
    class LocaleHelper
    {
        public const String INVALID_FILE_ERROR = "Errors.InvalidFile";

        private static ResourceManager resources = null;

        /// <summary>
        /// Initializes the localization of the plugin
        /// </summary>
        public static void Initialize(LocaleVersion locale)
        {
            String path = "SamHaXePanel.Resources." + locale.ToString();
            resources = new ResourceManager(path, Assembly.GetExecutingAssembly());
        }

        /// <summary>
        /// Loads a string from the internal resources
        /// </summary>
        public static String GetString(String identifier)
        {
            //TraceManager.Add("InsertFile GetString " + identifier);
            return resources.GetString(identifier);
        }

        /// <summary>
        /// Loads an image from the internal resources
        /// </summary>
        public static Image GetImage(String identifier)
        {
            return (Image)(resources.GetObject(identifier));
        }

        /// <summary>
        /// Loads a file from the internal resources
        /// </summary>
        public static Byte[] GetFile(String identifier)
        {
            return (Byte[])(resources.GetObject(identifier));
        }
    }

}
