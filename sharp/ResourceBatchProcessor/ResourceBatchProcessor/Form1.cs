using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace ResourceBatchProcessor
{
    public partial class Form1 : Form
    {
        private bool multipleSelected = false;

        public Form1()
        {
            InitializeComponent();
            this.buttonCreateMXML.Enabled = false;
            this.buttonSelectFolder.Click += new EventHandler(buttonSelectFolder_Click);
            this.buttonCreateMXML.Click += new EventHandler(buttonCreateMXML_Click);
            this.buttonSelectAllFolders.Click += new EventHandler(buttonSelectAllFolders_Click);
            this.textSelectedFolder.TextChanged += new EventHandler(textSelectedFolder_TextChanged);
            this.Resize += new EventHandler(Form1_Resize);
        }

        void buttonSelectAllFolders_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dialog = new FolderBrowserDialog();
            DialogResult result = dialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                this.textSelectedFolder.Text = dialog.SelectedPath;
            }
            this.multipleSelected = true;
        }

        void Form1_Resize(object sender, EventArgs e)
        {
            this.buttonCreateMXML.Width = this.Width - 30;
            this.buttonSelectFolder.Width = this.Width - 30;
            this.textSelectedFolder.Width = this.Width - 30;
            this.buttonSelectAllFolders.Width = this.Width - 30;
            this.label2.Width = this.Width;
        }

        void textSelectedFolder_TextChanged(object sender, EventArgs e)
        {
            if (this.textSelectedFolder.Text == "")
            {
                this.buttonCreateMXML.Enabled = false;
            }
            else
            {
                this.buttonCreateMXML.Enabled = true;
            }
        }

        private void buttonCreateMXML_Click(object sender, EventArgs e)
        {
            if (this.textSelectedFolder.Text == "") return;
            if (this.multipleSelected)
            {
                DirectoryInfo di = new DirectoryInfo(this.textSelectedFolder.Text);
                DirectoryInfo[] dil = di.GetDirectories();
                string[] paths = new string[dil.Length];
                int i = 0;
                foreach (DirectoryInfo d in dil)
                {
                    paths.SetValue(d.FullName, i);
                    i++;
                }
                MXMLGenerator.ProcessDirectory(paths);
            }
            else
            {
                MXMLGenerator.ProcessDirectory(this.textSelectedFolder.Text);
            }
        }

        private void buttonSelectFolder_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dialog = new FolderBrowserDialog();
            DialogResult result = dialog.ShowDialog();
            if (result == DialogResult.OK)
            {
                this.textSelectedFolder.Text = dialog.SelectedPath;
            }
            this.multipleSelected = false;
        }
    }
}
