﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace SamHaXePanel.Dialogs
{
    public partial class CreateResourcesFile : Form
    {
        #region Public properties

        public String ResourceFilePath
        {
            get { return this.locationTXT.Text; }
        }

        public String Version
        {
            get { return this.versionDD.Text; }
        }

        public Boolean Compressed
        {
            get { return this.compressedCB.Checked; }
        }

        public String Package
        {
            get { return this.packageTXT.Text; }
        }

        public Boolean Recursive
        {
            get { return this.recursiveCB.Checked; }
        }

        public Boolean GenerateComposites
        {
            get { return this.generateCompositeCB.Checked; }
        }

        public String Filer
        {
            get { return this.fileFilerTXT.Text; }
        }

        public String ResourceFolder
        {
            get { return this.selectedFolderTXT.Text; }
        }

        #endregion

        public CreateResourcesFile()
        {
            InitializeComponent();
            this.okBTN.DialogResult = DialogResult.OK;
            this.browseBTN.Click += new EventHandler(browseBTN_ClickHandler);
            this.FormClosing += new FormClosingEventHandler(CreateResourcesFile_FormClosingHandler);
            this.fromFolderBTN.Click += new EventHandler(fromFolderBTN_Click);
            this.versionDD.Text = "10";
        }

        void fromFolderBTN_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog dialog = new FolderBrowserDialog();
            dialog.Description = "Select folder containing resources";
            dialog.RootFolder = Environment.SpecialFolder.MyComputer;
            if (dialog.ShowDialog() == DialogResult.OK)
            {
                this.selectedFolderTXT.Text = dialog.SelectedPath;
            }
        }

        private void CreateResourcesFile_FormClosingHandler(Object sender, FormClosingEventArgs e)
        {
            if (e.CloseReason != CloseReason.UserClosing)
            {
                if (this.DialogResult == DialogResult.OK)
                {
                    if (String.IsNullOrEmpty(this.locationTXT.Text) ||
                        !Directory.Exists(Path.GetDirectoryName(this.locationTXT.Text)))
                    {
                        e.Cancel = true;
                        // TODO: Put this into resources
                        MessageBox.Show("You must enter valid path.");
                    }
                }
            }
        }

        private void browseBTN_ClickHandler(Object sender, EventArgs e)
        {
            SaveFileDialog dialog = new SaveFileDialog();
            dialog.Filter = "";
            // TODO: Put this into resources
            dialog.Title = "Create New Resources File";
            dialog.CheckPathExists = true;
            dialog.DefaultExt = ".xml";
            DialogResult res = dialog.ShowDialog();
            if (res == DialogResult.OK)
            {
                this.locationTXT.Text = dialog.FileName;
            }
        }
    }
}
