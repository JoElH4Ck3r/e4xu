﻿using System;
using System.Collections.Generic;
using System.Text;
using ProjectManager;
using ProjectManager.Projects;

namespace ResourcePRJ
{
    class RSXProjectWriter : ProjectWriter
    {
        RSXProject project;

        public RSXProjectWriter(RSXProject project, string filename)
            : base(project, filename)
        {
            this.project = base.Project as RSXProject;
        }

        protected override void OnAfterWriteClasspaths()
        {
            WriteBuildOptions();
            WriteLibraries();
            WriteLibraryAssets();
        }

        public void WriteLibraryAssets()
        {
            WriteComment(" Assets to embed into the output SWF ");
            WriteStartElement("library");

            if (project.LibraryAssets.Count > 0)
            {
                foreach (LibraryAsset asset in project.LibraryAssets)
                {
                    WriteStartElement("asset");
                    WriteAttributeString("path", asset.Path);

                    if (asset.UpdatePath != null)
                        WriteAttributeString("update", asset.UpdatePath);

                    if (asset.FontGlyphs != null)
                        WriteAttributeString("glyphs", asset.FontGlyphs);

                    WriteEndElement();
                }
            }
            else WriteExample("asset", "path", "id", "update", "glyphs", "mode", "place", "sharepoint");

            WriteEndElement();
        }

        public void WriteLibraries()
        {
            RSXOptions options = project.CompilerOptions;

            WriteComment(" SWC Include Libraries ");
            WriteList("includeLibraries", options.IncludeLibraries);
            WriteComment(" SWC Libraries ");
            WriteList("libraryPaths", options.LibraryPaths);
            WriteComment(" External Libraries ");
            WriteList("externalLibraryPaths", options.ExternalLibraryPaths);
        }

        public void WriteBuildOptions()
        {
            WriteComment(" Build options ");
            WriteStartElement("build");

            RSXOptions options = project.CompilerOptions;

            WriteOption("customSDK", options.CustomSDK);

            WriteEndElement();
        }

        void WriteList(string name, string[] items)
        {
            WriteStartElement(name);
            WritePaths(items, "element");
            WriteEndElement();
        }
    }
}
