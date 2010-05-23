﻿using System.Windows.Forms;
using System;
using System.Collections.Generic;
using SamHaXePanel.Resources;
using PluginCore;

namespace SamHaXePanel
{
    partial class PluginUI
    {
        /// <summary> 
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        private String[] dropFiles = null;
        private bool preventExpand = false;
        private DateTime lastMouseDown = DateTime.Now;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary> 
        /// Required method for Designer support - do not modify 
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(PluginUI));
            this.imageList = new System.Windows.Forms.ImageList(this.components);
            this.splitContainer1 = new System.Windows.Forms.SplitContainer();
            this.treeView = new System.Windows.Forms.TreeView();
            this.toolStrip = new System.Windows.Forms.ToolStrip();
            this.addButton = new System.Windows.Forms.ToolStripButton();
            this.refreshButton = new System.Windows.Forms.ToolStripButton();
            this.runButton = new System.Windows.Forms.ToolStripButton();
            this.createNewBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.exportTSDB = new System.Windows.Forms.ToolStripDropDownButton();
            this.exportHaXe = new System.Windows.Forms.ToolStripMenuItem();
            this.exportAS3All = new System.Windows.Forms.ToolStripMenuItem();
            this.exportAS3Each = new System.Windows.Forms.ToolStripMenuItem();
            this.fontPreviewLB = new System.Windows.Forms.Label();
            this.flashMovie = new AxShockwaveFlashObjects.AxShockwaveFlash();
            this.imageDisplay = new System.Windows.Forms.PictureBox();
            this.splitContainer1.Panel1.SuspendLayout();
            this.splitContainer1.Panel2.SuspendLayout();
            this.splitContainer1.SuspendLayout();
            this.toolStrip.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.flashMovie)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageDisplay)).BeginInit();
            this.SuspendLayout();
            // 
            // imageList
            // 
            this.imageList.ColorDepth = System.Windows.Forms.ColorDepth.Depth32Bit;
            this.imageList.ImageSize = new System.Drawing.Size(16, 16);
            this.imageList.TransparentColor = System.Drawing.Color.Transparent;
            // 
            // splitContainer1
            // 
            this.splitContainer1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.splitContainer1.Location = new System.Drawing.Point(0, 0);
            this.splitContainer1.Name = "splitContainer1";
            this.splitContainer1.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // splitContainer1.Panel1
            // 
            this.splitContainer1.Panel1.Controls.Add(this.treeView);
            this.splitContainer1.Panel1.Controls.Add(this.toolStrip);
            // 
            // splitContainer1.Panel2
            // 
            this.splitContainer1.Panel2.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Stretch;
            this.splitContainer1.Panel2.Controls.Add(this.fontPreviewLB);
            this.splitContainer1.Panel2.Controls.Add(this.flashMovie);
            this.splitContainer1.Panel2.Controls.Add(this.imageDisplay);
            this.splitContainer1.Panel2.Resize += new System.EventHandler(this.Panel2_ResizeHandler);
            this.splitContainer1.Size = new System.Drawing.Size(279, 310);
            this.splitContainer1.SplitterDistance = 178;
            this.splitContainer1.TabIndex = 3;
            // 
            // treeView
            // 
            this.treeView.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.treeView.Dock = System.Windows.Forms.DockStyle.Fill;
            this.treeView.HideSelection = false;
            this.treeView.Location = new System.Drawing.Point(0, 25);
            this.treeView.Name = "treeView";
            this.treeView.ShowNodeToolTips = true;
            this.treeView.Size = new System.Drawing.Size(279, 153);
            this.treeView.TabIndex = 3;
            // 
            // toolStrip
            // 
            this.toolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden;
            this.toolStrip.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.addButton,
            this.refreshButton,
            this.runButton,
            this.createNewBtn,
            this.toolStripSeparator1,
            this.exportTSDB});
            this.toolStrip.Location = new System.Drawing.Point(0, 0);
            this.toolStrip.Name = "toolStrip";
            this.toolStrip.Size = new System.Drawing.Size(279, 25);
            this.toolStrip.TabIndex = 2;
            this.toolStrip.Text = "toolStrip1";
            // 
            // addButton
            // 
            this.addButton.Image = ((System.Drawing.Image)(resources.GetObject("addButton.Image")));
            this.addButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.addButton.Name = "addButton";
            this.addButton.Size = new System.Drawing.Size(46, 22);
            this.addButton.Text = "Add";
            this.addButton.ToolTipText = "Add build file";
            // 
            // refreshButton
            // 
            this.refreshButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right;
            this.refreshButton.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.refreshButton.Image = ((System.Drawing.Image)(resources.GetObject("refreshButton.Image")));
            this.refreshButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.refreshButton.Name = "refreshButton";
            this.refreshButton.Size = new System.Drawing.Size(23, 22);
            this.refreshButton.Text = "toolStripButton2";
            this.refreshButton.ToolTipText = "Refresh";
            // 
            // runButton
            // 
            this.runButton.Image = ((System.Drawing.Image)(resources.GetObject("runButton.Image")));
            this.runButton.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.runButton.Name = "runButton";
            this.runButton.Size = new System.Drawing.Size(49, 22);
            this.runButton.Text = "Build";
            // 
            // createNewBtn
            // 
            this.createNewBtn.Image = ((System.Drawing.Image)(resources.GetObject("createNewBtn.Image")));
            this.createNewBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.createNewBtn.Name = "createNewBtn";
            this.createNewBtn.Size = new System.Drawing.Size(48, 22);
            this.createNewBtn.Text = "New";
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // exportTSDB
            // 
            this.exportTSDB.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.exportHaXe,
            this.exportAS3All,
            this.exportAS3Each});
            this.exportTSDB.Image = ((System.Drawing.Image)(resources.GetObject("exportTSDB.Image")));
            this.exportTSDB.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.exportTSDB.Name = "exportTSDB";
            this.exportTSDB.Size = new System.Drawing.Size(68, 22);
            this.exportTSDB.Text = "Export";
            // 
            // exportHaXe
            // 
            this.exportHaXe.Name = "exportHaXe";
            this.exportHaXe.Size = new System.Drawing.Size(152, 22);
            this.exportHaXe.Text = "HaXe classes";
            this.exportHaXe.Click += new System.EventHandler(this.ExportHaXe_ClickHandler);
            // 
            // exportAS3All
            // 
            this.exportAS3All.Name = "exportAS3All";
            this.exportAS3All.Size = new System.Drawing.Size(152, 22);
            this.exportAS3All.Text = "AS3 classes";
            this.exportAS3All.Click += new System.EventHandler(this.ExportAs3_ClickHandler);
            // 
            // exportAS3Each
            // 
            this.exportAS3Each.Name = "exportAS3Each";
            this.exportAS3Each.Size = new System.Drawing.Size(152, 22);
            this.exportAS3Each.Text = "Flex [embed]";
            this.exportAS3Each.Click += new System.EventHandler(this.ExportFlex_ClickHandler);
            // 
            // fontPreviewLB
            // 
            this.fontPreviewLB.BackColor = System.Drawing.Color.White;
            this.fontPreviewLB.Font = new System.Drawing.Font("Microsoft Sans Serif", 18F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.fontPreviewLB.Location = new System.Drawing.Point(3, 0);
            this.fontPreviewLB.Name = "fontPreviewLB";
            this.fontPreviewLB.Size = new System.Drawing.Size(273, 128);
            this.fontPreviewLB.TabIndex = 2;
            this.fontPreviewLB.Text = "label1";
            // 
            // flashMovie
            // 
            this.flashMovie.Dock = System.Windows.Forms.DockStyle.Fill;
            this.flashMovie.Enabled = true;
            this.flashMovie.Location = new System.Drawing.Point(0, 0);
            this.flashMovie.Name = "flashMovie";
            this.flashMovie.OcxState = ((System.Windows.Forms.AxHost.State)(resources.GetObject("flashMovie.OcxState")));
            this.flashMovie.Size = new System.Drawing.Size(279, 128);
            this.flashMovie.TabIndex = 1;
            this.flashMovie.Visible = false;
            // 
            // imageDisplay
            // 
            this.imageDisplay.Dock = System.Windows.Forms.DockStyle.Fill;
            this.imageDisplay.Location = new System.Drawing.Point(0, 0);
            this.imageDisplay.Name = "imageDisplay";
            this.imageDisplay.Size = new System.Drawing.Size(279, 128);
            this.imageDisplay.SizeMode = System.Windows.Forms.PictureBoxSizeMode.CenterImage;
            this.imageDisplay.TabIndex = 0;
            this.imageDisplay.TabStop = false;
            // 
            // PluginUI
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.Controls.Add(this.splitContainer1);
            this.Name = "PluginUI";
            this.Size = new System.Drawing.Size(279, 310);
            this.splitContainer1.Panel1.ResumeLayout(false);
            this.splitContainer1.Panel1.PerformLayout();
            this.splitContainer1.Panel2.ResumeLayout(false);
            this.splitContainer1.ResumeLayout(false);
            this.toolStrip.ResumeLayout(false);
            this.toolStrip.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.flashMovie)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imageDisplay)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ImageList imageList;

        #region DargDop

        private void treeView_MouseDown(object sender, MouseEventArgs e)
        {
            int delta = (int)DateTime.Now.Subtract(lastMouseDown).TotalMilliseconds;
            preventExpand = (delta < SystemInformation.DoubleClickTime);
            lastMouseDown = DateTime.Now;
        }

        private void treeView_BeforeExpand(object sender, TreeViewCancelEventArgs e)
        {
            e.Cancel = preventExpand;
            preventExpand = false;
        }

        private void treeView_BeforeCollapse(object sender, TreeViewCancelEventArgs e)
        {
            e.Cancel = preventExpand;
            preventExpand = false;
        }

        internal void StartDragHandling()
        {
            this.treeView.AllowDrop = true;
            this.treeView.DragEnter += new DragEventHandler(treeView_DragEnter);
            this.treeView.DragDrop += new DragEventHandler(treeView_DragDrop);
            this.treeView.DragOver += new DragEventHandler(treeView_DragOver);
        }

        void treeView_DragEnter(object sender, DragEventArgs e)
        {
            String[] s = (String[])e.Data.GetData(DataFormats.FileDrop);
            List<String> xmls = new List<String>();
            for (Int32 i = 0; i < s.Length; i++)
            {
                if (s[i].EndsWith(".xml", true, null))
                {
                    xmls.Add(s[i]);
                }
            }
            if (xmls.Count > 0)
            {
                e.Effect = DragDropEffects.Copy;
                this.dropFiles = xmls.ToArray();
            }
            else this.dropFiles = null;
        }

        void treeView_DragOver(object sender, DragEventArgs e)
        {
            if (this.dropFiles != null)
            {
                e.Effect = DragDropEffects.Copy;
            }
        }

        void treeView_DragDrop(object sender, DragEventArgs e)
        {
            if (this.dropFiles != null)
            {
                this.pluginMain.AddConfigFiles(this.dropFiles);
            }
        }

        #endregion

        private SplitContainer splitContainer1;
        private TreeView treeView;
        private ToolStrip toolStrip;
        private ToolStripButton addButton;
        private ToolStripButton refreshButton;
        private ToolStripButton runButton;
        private PictureBox imageDisplay;
        private AxShockwaveFlashObjects.AxShockwaveFlash flashMovie;
        private ToolStripButton createNewBtn;
        private Label fontPreviewLB;
        private ToolStripSeparator toolStripSeparator1;
        private ToolStripDropDownButton exportTSDB;
        private ToolStripMenuItem exportHaXe;
        private ToolStripMenuItem exportAS3All;
        private ToolStripMenuItem exportAS3Each;



    }
}
