using System;
using System.Collections.Generic;
using System.IO;
using System.Windows.Forms;
using NFXContext.Enums;
using PluginCore;
using ProjectManager.Projects;

namespace NFXContext
{
    public class NFXProject : Project
    {
        public NFXProject(string path)
            : base(path, new NFXOptions())
        {
            movieOptions = new NFXMovieOptions();
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

        public new NFXOptions CompilerOptions { get { return (NFXOptions)base.CompilerOptions; } }

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

        private string assetsPackage = "assets";

        private string[] assetDirectories = new string[8]
        {
         "bin", "fnt", "fxg", "img", "snd", "svg", "swf", "txt"
        };

        public string GetAssetPath(AssetTypes type)
        {
            string asset;
            switch (type)
            {
                default:
                case AssetTypes.Bin:
                    asset = Path.Combine(assetsPackage, assetDirectories[0]);
                    break;
                case AssetTypes.Fnt:
                    asset = Path.Combine(assetsPackage, assetDirectories[1]);
                    break;
                case AssetTypes.Fxg:
                    asset = Path.Combine(assetsPackage, assetDirectories[2]);
                    break;
                case AssetTypes.Img:
                    asset = Path.Combine(assetsPackage, assetDirectories[3]);
                    break;
                case AssetTypes.Snd:
                    asset = Path.Combine(assetsPackage, assetDirectories[4]);
                    break;
                case AssetTypes.Svg:
                    asset = Path.Combine(assetsPackage, assetDirectories[5]);
                    break;
                case AssetTypes.Swf:
                    asset = Path.Combine(assetsPackage, assetDirectories[6]);
                    break;
                case AssetTypes.Txt:
                    asset = Path.Combine(assetsPackage, assetDirectories[7]);
                    break;
            }
            return Path.Combine(this.GetCompileTargetRoot(), asset);
        }

        public string GetCompileTargetRoot()
        {
            foreach (string s in this.SourcePaths)
            {
                if (this.CompileTargets[0].IndexOf(s) > -1)
                {
                    return this.Directory + Path.DirectorySeparatorChar + s;
                }
            }
            return this.Directory + Path.DirectorySeparatorChar + "rsx";
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

        public static NFXProject Load(string path)
        {
            Console.WriteLine("So far so good...");
            ProjectReader reader;
            reader = new NFXProjectReader(path);
            NFXProject pr;
            try
            {
                pr = reader.ReadProject() as NFXProject;
                // TODO: this is just silly...
                NFXContext.PluginMain pl =
                    (NFXContext.PluginMain)PluginBase.MainForm.FindPlugin("5ecb91e0-3e1e-4998-aaee-a46a270e5df8");
                pl.EnableProjectView(pr);
                return pr;
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
                NFXProjectWriter writer = new NFXProjectWriter(this, fileName);

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
