using System;
using System.Collections.Generic;
using System.Text;
using ProjectManager.Controls.TreeView;

namespace NFXContext.Mapping
{
    class NFXNode : FileNode
    {
        public NFXNode(string filePath) : base(filePath)
		{
            Console.WriteLine("NFXNode created");
			isDraggable = true;
			isRenamable = true;
		}

        public static NFXNode Create(String path)
        {
            return new NFXNode(path);
        }
    }
}
