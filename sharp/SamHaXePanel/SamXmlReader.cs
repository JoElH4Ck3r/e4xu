using System;
using System.Xml;
using System.IO;
using System.Text;
using System.Collections.Generic;
using System.Windows.Forms;

namespace SamHaXePanel
{
    class SamXmlReader : XmlTextReader
    {
        private String source;
        private SamTreeNode currentSamNode;
        private List<SamTreeNode> samNodes;
        private Boolean nodeFound;
        private Int16 depth;

        public SamXmlReader() : base() { }

        public SamXmlReader(String src) :
            base(new MemoryStream(UTF8Encoding.Default.GetBytes(src)))
        {
            this.source = src;
            this.nodeFound = false;
        }

        public override void ReadStartElement()
        {
            bool res = false;
            switch (this.currentSamNode.ResourceType)
            {
                case ResourceNodeType.Root:
                    res = this.FindRootNode();
                    break;
                case ResourceNodeType.Compose:
                    res = this.FindComposeNode();
                    break;
                case ResourceNodeType.Frame:
                    res = this.FindFrameNode();
                    break;
                default:
                    res = this.FindResourceNode();
                    break;
            }
            if (this.depth == this.samNodes.Count - 1)
            {
                this.MoveToElement();
                this.nodeFound = true;
            }
            else
            {
                if (!res)
                {
                    this.MoveToElement();
                    this.nodeFound = true;
                }
                else
                {
                    this.depth++;
                    this.currentSamNode = this.samNodes[depth];
                }
            }
        }

        private bool FindRootNode()
        {
            bool ret = false;
            Int16 nodeCount = 0;
            if (this.currentSamNode.Parent != null)
            {
                TreeNodeCollection brothers = this.currentSamNode.Parent.Nodes;
                while (brothers[nodeCount] != this.currentSamNode)
                    nodeCount++;
            }
            if (nodeCount == 0 && base.LocalName == "resources" &&
                base.NamespaceURI == PluginUI.KnownNamespaces[0])
            {
                ret = true;
            }
            else
            {
                while (this.ReadToFollowing("resources", PluginUI.KnownNamespaces[0]))
                {
                    if (nodeCount == 0)
                    {
                        ret = true;
                        break;
                    }
                    nodeCount--;
                }
            }
            return ret;
        }

        private bool FindComposeNode()
        {
            bool ret = false;
            
            return ret;
        }

        private bool FindFrameNode()
        {
            bool ret = false;
            Int16 nodeCount = 0;
            if (this.currentSamNode.Parent != null)
            {
                TreeNodeCollection brothers = this.currentSamNode.Parent.Nodes;
                while (brothers[nodeCount] != this.currentSamNode)
                    nodeCount++;
            }
            if (nodeCount == 0 && base.LocalName == "frame" &&
                base.NamespaceURI == PluginUI.KnownNamespaces[0])
            {
                ret = true;
            }
            else
            {
                while (this.ReadToFollowing("frame", PluginUI.KnownNamespaces[0]))
                {
                    if (nodeCount == 0)
                    {
                        ret = true;
                        break;
                    }
                    nodeCount--;
                }
            }
            return ret;
        }

        private bool FindResourceNode()
        {
            Int16 nodeCount = 0;
            Stack<String> namespaces = new Stack<String>(PluginUI.KnownNamespaces);

            if (this.currentSamNode.Parent != null)
            {
                TreeNodeCollection brothers = this.currentSamNode.Parent.Nodes;
                while (brothers[nodeCount] != this.currentSamNode)
                    nodeCount++;
            }
            if (nodeCount == 0 && namespaces.Contains(base.NamespaceURI))
            {
                return true;
            }
            else
            {
                while (nodeCount > 0 && base.NodeType != XmlNodeType.EndElement)
                {
                    if (namespaces.Contains(base.NamespaceURI))
                        nodeCount--;
                    if (base.NodeType == XmlNodeType.Element && !this.IsEmptyElement)
                    {
                        base.Skip();
                    }
                    else
                    {
                        base.Read();
                    }
                }
            }
            return nodeCount == 0;
        }

        public int FindNodeStart(List<SamTreeNode> nodes)
        {
            int ret = -1;
            this.samNodes = nodes;
            this.currentSamNode = nodes[0];
            this.depth = 0;
            while (base.Read())
            {
                this.ReadStartElement();
                if (this.nodeFound)
                    return this.LineNumber;
            }

            return ret;
        }
    }
}
