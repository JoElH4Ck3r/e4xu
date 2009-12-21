using System;
using System.Collections.Generic;
using System.Text;
using ProjectManager;
using ProjectManager.Projects;

namespace ResourcePRJ
{
    class RSXProjectReader : ProjectReader
    {
        RSXProject project;

        public RSXProjectReader(string path)
            : base(path, new RSXProject(path))
        {
            this.project = base.Project as RSXProject;
        }

        protected override void ProcessRootNode()
        {
            Console.WriteLine("ProcessRootNode");
        }

        // process AS3-specific stuff
        protected override void ProcessNode(string name)
        {
            Console.WriteLine("Reading " + name);
            if (NodeType == System.Xml.XmlNodeType.Element)
            {
                switch (name)
                {
                    case "build": ReadBuildOptions(); break;
                    case "library": ReadLibraryAssets(); break;
                    case "includeLibraries": ReadIncludeLibraries(); break;
                    case "libraryPaths": ReadLibrayPath(); break;
                    case "externalLibraryPaths": ReadExternalLibraryPaths(); break;
                    case "rslPaths": ReadRSLPaths(); break;
                    case "intrinsics": ReadIntrinsicPaths(); break;
                    case "output": ReadOutputOptions(); break;
                    default: base.ProcessNode(name); break;
                }
            }
        }

        // overrides
        public new void ReadOutputOptions()
        {
            ReadStartElement("output");
            while (Name == "movie" || Name == "compc")
            {
                if (Name == "compc")
                {
                    // TODO: Actually read the options :)
                    Skip();
                }
                else
                {
                    MoveToFirstAttribute();
                    switch (Name)
                    {
                        case "disabled": project.NoOutput = BoolValue; break;
                        case "path": project.OutputPath = OSPath(Value); break;
                    }
                }
                Read();
            }
            ReadEndElement();
        }


        private void ReadIntrinsicPaths()
        {
            //project.CompilerOptions.IntrinsicPaths = ReadLibrary("intrinsics", SwfAssetMode.Ignore);
        }

        private void ReadRSLPaths()
        {
            //project.CompilerOptions.RSLPaths = ReadLibrary("rslPaths", SwfAssetMode.Ignore);
        }

        private void ReadExternalLibraryPaths()
        {
            project.CompilerOptions.ExternalLibraryPaths = ReadLibrary("externalLibraryPaths", SwfAssetMode.ExternalLibrary);
        }

        private void ReadLibrayPath()
        {
            project.CompilerOptions.LibraryPaths = ReadLibrary("libraryPaths", SwfAssetMode.Library);
        }

        private void ReadIncludeLibraries()
        {
            project.CompilerOptions.IncludeLibraries = ReadLibrary("includeLibraries", SwfAssetMode.IncludedLibrary);
        }

        private string[] ReadLibrary(string name, SwfAssetMode mode)
        {
            ReadStartElement(name);
            List<string> elements = new List<string>();
            while (Name == "element")
            {
                string path = GetAttribute("path").Replace('/', '\\');
                elements.Add(path);

                if (mode != SwfAssetMode.Ignore)
                {
                    LibraryAsset asset = new LibraryAsset(project, path);
                    asset.SwfMode = mode;
                    project.SwcLibraries.Add(asset);
                }
                Read();
            }
            ReadEndElement();
            string[] result = new string[elements.Count];
            elements.CopyTo(result);
            return result;
        }

        public void ReadLibraryAssets()
        {
            ReadStartElement("library");
            while (Name == "asset")
            {
                string path = OSPath(GetAttribute("path"));

                if (path == null)
                    throw new Exception("All library assets must have a 'path' attribute.");

                LibraryAsset asset = new LibraryAsset(project, path);
                project.LibraryAssets.Add(asset);

                asset.UpdatePath = OSPath(GetAttribute("update")); // could be null
                asset.FontGlyphs = GetAttribute("glyphs"); // could be null

                Read();
            }
            ReadEndElement();
        }

        public void ReadBuildOptions()
        {
            RSXOptions options = project.CompilerOptions;

            ReadStartElement("build");
            while (Name == "option")
            {
                MoveToFirstAttribute();
                switch (Name)
                {
                    case "customSDK": options.CustomSDK = Value; break;
                }
                Read();
            }
            ReadEndElement();
        }
    }
}
