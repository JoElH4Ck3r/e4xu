using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using PluginCore;
using ProjectManager;
using ProjectManager.Projects;
using System.IO;
using System.Windows;
using System.Windows.Forms;

namespace ResourcePRJ
{
    class RSXProject : Project
    {
        public RSXProject(string path)
            : base(path, new RSXOptions())
        {
            movieOptions = new RSXMovieOptions();
        }
        
        public override string Name 
        { 
            get 
            {
                if (FileInspector.IsFlexBuilderProject(ProjectPath))
                    return Path.GetFileName(Path.GetDirectoryName(ProjectPath));
                else
                    return Path.GetFileNameWithoutExtension(ProjectPath); 
            } 
        }

        public override string Language { get { return "as3"; } }
        public override bool HasLibraries { get { return !NoOutput; } }
        public override int MaxTargetsCount { get { return 1; } }

        public new RSXOptions CompilerOptions { get { return (RSXOptions)base.CompilerOptions; } }

        //internal override ProjectManager.Controls.PropertiesDialog CreatePropertiesDialog()
        //{
        //    return new ProjectManager.Controls.AS3.AS3PropertiesDialog();
        //}

        public override void ValidateBuild(out string error)
        {
            if (CompileTargets.Count == 0)
                error = "Description.MissingEntryPoint";
            else
                error = null;
        }

        public override string GetInsertFileText(string inFile, string path, string export, string nodeType)
        {
            if (nodeType == "ProjectManager.Controls.TreeView.ClassExportNode")
                return export;

            string ext = Path.GetExtension(inFile).ToLower();
            string pre = "";
            string post = "";
            if (ext == ".as") { pre = "["; post = "]"; }

            string relPath = ProjectPaths.GetRelativePath(Path.GetDirectoryName(inFile), path).Replace('\\', '/');
            if (export != null)
                return String.Format("{0}Embed(source='{1}', symbol='{2}'){3}", pre, relPath, export, post);
            else 
                return String.Format("{0}Embed(source='{1}'){2}", pre, relPath, post);
        }

        #region SWC assets management

        public AssetCollection SwcLibraries;

        public override bool IsLibraryAsset(string path)
        {
            if (!FileInspector.IsSwc(path)) return base.IsLibraryAsset(path);
            else return SwcLibraries.Contains(GetRelativePath(path));
        }

        public override LibraryAsset GetAsset(string path)
        {
            if (!FileInspector.IsSwc(path)) return base.GetAsset(path);
            else return SwcLibraries[GetRelativePath(path)];
        }

        public override void ChangeAssetPath(string fromPath, string toPath)
        {
            if (!FileInspector.IsSwc(fromPath)) base.ChangeAssetPath(fromPath, toPath);
            else
            {
                LibraryAsset asset = SwcLibraries[GetRelativePath(fromPath)];
                SwcLibraries.Remove(asset);
                asset.Path = GetRelativePath(toPath);
                SwcLibraries.Add(asset);
            }
        }

        public override void SetLibraryAsset(string path, bool isLibraryAsset)
        {
            if (!FileInspector.IsSwc(path)) base.SetLibraryAsset(path, isLibraryAsset);
            else
            {
                string relPath = GetRelativePath(path);
                if (isLibraryAsset)
                {
                    LibraryAsset asset = new LibraryAsset(this, relPath);
                    asset.SwfMode = SwfAssetMode.Library;
                    SwcLibraries.Add(asset);
                }
                else SwcLibraries.Remove(relPath);
                RebuildCompilerOptions();
                OnClasspathChanged();
            }
        }
        #endregion

        #region Load/Save

        public override void PropertiesChanged()
        {
            // rebuild Swc assets list
            SwcLibraries.Clear();
            LibraryAsset asset;
            foreach (string path in CompilerOptions.LibraryPaths)
            {
                asset = new LibraryAsset(this, path);
                asset.SwfMode = SwfAssetMode.Library;
                SwcLibraries.Add(asset);
            }
            foreach (string path in CompilerOptions.IncludeLibraries)
            {
                asset = new LibraryAsset(this, path);
                asset.SwfMode = SwfAssetMode.IncludedLibrary;
                SwcLibraries.Add(asset);
            }
            foreach (string path in CompilerOptions.ExternalLibraryPaths)
            {
                asset = new LibraryAsset(this, path);
                asset.SwfMode = SwfAssetMode.ExternalLibrary;
                SwcLibraries.Add(asset);
            }
            OnClasspathChanged();
        }

        public static RSXProject Load(string path)
        {
            Console.WriteLine("So far so good...");
            ProjectReader reader;
            reader = new RSXProjectReader(path);
            try
            {
                return reader.ReadProject() as RSXProject;
            }
            catch (System.Xml.XmlException exception)
            {
                Console.WriteLine("No good...");
                string format = string.Format("Error in XML Document line {0}, position {1}.",
                    exception.LineNumber, exception.LinePosition);
                throw new Exception(format, exception);
            }
            finally { reader.Close(); }
        }

        public override void Save()
        {
            RebuildCompilerOptions();
            SaveAs(ProjectPath);
        }

        public override void SaveAs(string fileName)
        {
            try
            {
                RSXProjectWriter writer = new RSXProjectWriter(this, fileName);

                writer.WriteProject();
                writer.Flush();
                writer.Close();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "IO Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        internal void RebuildCompilerOptions()
        {
            // rebuild Swc libraries lists
            CompilerOptions.LibraryPaths = GetLibraryPaths(SwfAssetMode.Library);
            CompilerOptions.IncludeLibraries = GetLibraryPaths(SwfAssetMode.IncludedLibrary);
            CompilerOptions.ExternalLibraryPaths = GetLibraryPaths(SwfAssetMode.ExternalLibrary);
        }

        private string[] GetLibraryPaths(SwfAssetMode mode)
        {
            List<string> paths = new List<string>();
            foreach (LibraryAsset asset in SwcLibraries)
                if (asset.SwfMode == mode)
                {
                    asset.Path = asset.Path.Replace("/", "\\");
                    paths.Add(asset.Path);
                }
            string[] newList = new string[paths.Count];
            paths.CopyTo(newList);
            return newList;
        }

        #endregion
    }
}
