using System;
using System.Collections.Generic;
using System.Text;
using ProjectManager;
using ProjectManager.Projects;
using System.ComponentModel;
using PluginCore.Localization;
using System.Windows.Forms.Design;
using System.Drawing.Design;

namespace NFXContext
{
    [Serializable]
    public class NFXOptions : CompilerOptions
    {

        string[] externalLibraryPaths = new string[] { };
        [DisplayName("External Libraries")]
        [LocalizedCategory("ProjectManager.Category.Advanced")]
        [LocalizedDescription("ProjectManager.Description.ExternalLibraryPaths")]
        [DefaultValue(new string[] { })]
        public string[] ExternalLibraryPaths
        {
            get { return externalLibraryPaths; }
            set { externalLibraryPaths = value; }
        }

        string[] includeLibraries = new string[] { };
        [DisplayName("SWC Include Libraries")]
        [LocalizedCategory("ProjectManager.Category.Advanced")]
        [LocalizedDescription("ProjectManager.Description.IncludeLibraries")]
        [DefaultValue(new string[] { })]
        public string[] IncludeLibraries
        {
            get { return includeLibraries; }
            set { includeLibraries = value; }
        }

        string[] libraryPaths = new string[] { };
        [DisplayName("SWC Libraries")]
        [LocalizedCategory("ProjectManager.Category.Advanced")]
        [LocalizedDescription("ProjectManager.Description.LibraryPaths")]
        [DefaultValue(new string[] { })]
        public string[] LibraryPaths
        {
            get { return libraryPaths; }
            set { libraryPaths = value; }
        }

        string customSDK = "";
        [LocalizedCategory("ProjectManager.Category.Advanced")]
        [DisplayName("Custom Path to Flex SDK")]
        [LocalizedDescription("ProjectManager.Description.CustomSDK")]
        [Editor(typeof(FolderNameEditor), typeof(UITypeEditor))]
        [DefaultValue("")]
        public string CustomSDK { get { return customSDK; } set { customSDK = value; } }

    }
}
