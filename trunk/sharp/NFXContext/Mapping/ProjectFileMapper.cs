using System.IO;
using ProjectManager.Controls.TreeView;

namespace NFXContext.Mapping
{
    static class ProjectFileMapper
    {
        /// <summary>
        /// Fills out a mapping request from the Project Tree, to put BXML designer files and code-behind
        /// in a little subtree under the .bxml file, like VS.
        /// </summary>
        public static void Map(FileMappingRequest request)
        {
            foreach (string file in request.Files)
            {
                string directory = Path.GetDirectoryName(file);
                string name = Path.GetFileNameWithoutExtension(file);
                string extension = Path.GetExtension(file);

                if (extension == ".nxml")
                {
                    //string designerAS = Path.Combine(directory, name + "Design.as");
                    string codeBehindAS = Path.Combine(directory, name + ".as");

                    //request.Mapping.Map(designerAS, file);
                    request.Mapping.Map(codeBehindAS, file);
                }
            }
        }
    }
}
