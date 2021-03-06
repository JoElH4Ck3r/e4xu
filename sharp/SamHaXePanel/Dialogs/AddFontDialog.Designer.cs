﻿namespace SamHaXePanel.Dialogs
{
    partial class AddFontDialog
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle7 = new System.Windows.Forms.DataGridViewCellStyle();
            System.Windows.Forms.DataGridViewCellStyle dataGridViewCellStyle8 = new System.Windows.Forms.DataGridViewCellStyle();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(AddFontDialog));
            this.fontGrid = new System.Windows.Forms.DataGridView();
            this.C0 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C1 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C2 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C3 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C4 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C5 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C6 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C7 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C8 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.C9 = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CA = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CB = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CC = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CD = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CE = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.CF = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.langPlanesCBL = new System.Windows.Forms.CheckedListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.selectedRanges = new System.Windows.Forms.ListBox();
            this.okBTN = new System.Windows.Forms.Button();
            this.cancelBTN = new System.Windows.Forms.Button();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.presetsCB = new System.Windows.Forms.ToolStripDropDownButton();
            this.addPresetBTN = new System.Windows.Forms.ToolStripMenuItem();
            this.removePresetBTN = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.addBTN = new System.Windows.Forms.ToolStripButton();
            this.removeBTN = new System.Windows.Forms.ToolStripButton();
            ((System.ComponentModel.ISupportInitialize)(this.fontGrid)).BeginInit();
            this.toolStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // fontGrid
            // 
            this.fontGrid.AllowUserToAddRows = false;
            this.fontGrid.AllowUserToDeleteRows = false;
            this.fontGrid.BorderStyle = System.Windows.Forms.BorderStyle.None;
            this.fontGrid.ColumnHeadersBorderStyle = System.Windows.Forms.DataGridViewHeaderBorderStyle.None;
            this.fontGrid.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.DisableResizing;
            this.fontGrid.ColumnHeadersVisible = false;
            this.fontGrid.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.C0,
            this.C1,
            this.C2,
            this.C3,
            this.C4,
            this.C5,
            this.C6,
            this.C7,
            this.C8,
            this.C9,
            this.CA,
            this.CB,
            this.CC,
            this.CD,
            this.CE,
            this.CF});
            dataGridViewCellStyle7.Alignment = System.Windows.Forms.DataGridViewContentAlignment.MiddleCenter;
            dataGridViewCellStyle7.BackColor = System.Drawing.SystemColors.Window;
            dataGridViewCellStyle7.Font = new System.Drawing.Font("Arial", 11.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            dataGridViewCellStyle7.ForeColor = System.Drawing.SystemColors.ControlText;
            dataGridViewCellStyle7.SelectionBackColor = System.Drawing.SystemColors.Highlight;
            dataGridViewCellStyle7.SelectionForeColor = System.Drawing.SystemColors.HighlightText;
            dataGridViewCellStyle7.WrapMode = System.Windows.Forms.DataGridViewTriState.False;
            this.fontGrid.DefaultCellStyle = dataGridViewCellStyle7;
            this.fontGrid.Dock = System.Windows.Forms.DockStyle.Left;
            this.fontGrid.Location = new System.Drawing.Point(10, 10);
            this.fontGrid.Name = "fontGrid";
            this.fontGrid.ReadOnly = true;
            this.fontGrid.RowHeadersVisible = false;
            this.fontGrid.RowHeadersWidth = 20;
            this.fontGrid.RowHeadersWidthSizeMode = System.Windows.Forms.DataGridViewRowHeadersWidthSizeMode.DisableResizing;
            dataGridViewCellStyle8.SelectionBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(192)))), ((int)(((byte)(192)))), ((int)(((byte)(0)))));
            this.fontGrid.RowsDefaultCellStyle = dataGridViewCellStyle8;
            this.fontGrid.RowTemplate.Height = 30;
            this.fontGrid.Size = new System.Drawing.Size(498, 446);
            this.fontGrid.TabIndex = 0;
            // 
            // C0
            // 
            this.C0.HeaderText = "0";
            this.C0.Name = "C0";
            this.C0.ReadOnly = true;
            this.C0.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C0.Width = 30;
            // 
            // C1
            // 
            this.C1.HeaderText = "1";
            this.C1.Name = "C1";
            this.C1.ReadOnly = true;
            this.C1.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C1.Width = 30;
            // 
            // C2
            // 
            this.C2.HeaderText = "2";
            this.C2.Name = "C2";
            this.C2.ReadOnly = true;
            this.C2.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C2.Width = 30;
            // 
            // C3
            // 
            this.C3.HeaderText = "3";
            this.C3.Name = "C3";
            this.C3.ReadOnly = true;
            this.C3.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C3.Width = 30;
            // 
            // C4
            // 
            this.C4.HeaderText = "4";
            this.C4.Name = "C4";
            this.C4.ReadOnly = true;
            this.C4.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C4.Width = 30;
            // 
            // C5
            // 
            this.C5.HeaderText = "5";
            this.C5.Name = "C5";
            this.C5.ReadOnly = true;
            this.C5.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C5.Width = 30;
            // 
            // C6
            // 
            this.C6.HeaderText = "6";
            this.C6.Name = "C6";
            this.C6.ReadOnly = true;
            this.C6.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C6.Width = 30;
            // 
            // C7
            // 
            this.C7.HeaderText = "7";
            this.C7.Name = "C7";
            this.C7.ReadOnly = true;
            this.C7.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C7.Width = 30;
            // 
            // C8
            // 
            this.C8.HeaderText = "8";
            this.C8.Name = "C8";
            this.C8.ReadOnly = true;
            this.C8.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C8.Width = 30;
            // 
            // C9
            // 
            this.C9.HeaderText = "9";
            this.C9.Name = "C9";
            this.C9.ReadOnly = true;
            this.C9.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.C9.Width = 30;
            // 
            // CA
            // 
            this.CA.HeaderText = "A";
            this.CA.Name = "CA";
            this.CA.ReadOnly = true;
            this.CA.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.CA.Width = 30;
            // 
            // CB
            // 
            this.CB.HeaderText = "B";
            this.CB.Name = "CB";
            this.CB.ReadOnly = true;
            this.CB.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.CB.Width = 30;
            // 
            // CC
            // 
            this.CC.HeaderText = "C";
            this.CC.Name = "CC";
            this.CC.ReadOnly = true;
            this.CC.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.CC.Width = 30;
            // 
            // CD
            // 
            this.CD.HeaderText = "D";
            this.CD.Name = "CD";
            this.CD.ReadOnly = true;
            this.CD.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.CD.Width = 30;
            // 
            // CE
            // 
            this.CE.HeaderText = "E";
            this.CE.Name = "CE";
            this.CE.ReadOnly = true;
            this.CE.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.CE.Width = 30;
            // 
            // CF
            // 
            this.CF.HeaderText = "F";
            this.CF.Name = "CF";
            this.CF.ReadOnly = true;
            this.CF.Resizable = System.Windows.Forms.DataGridViewTriState.False;
            this.CF.Width = 30;
            // 
            // langPlanesCBL
            // 
            this.langPlanesCBL.CheckOnClick = true;
            this.langPlanesCBL.FormattingEnabled = true;
            this.langPlanesCBL.Location = new System.Drawing.Point(514, 28);
            this.langPlanesCBL.Name = "langPlanesCBL";
            this.langPlanesCBL.Size = new System.Drawing.Size(215, 214);
            this.langPlanesCBL.Sorted = true;
            this.langPlanesCBL.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(515, 10);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(118, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Select language planes";
            // 
            // selectedRanges
            // 
            this.selectedRanges.FormattingEnabled = true;
            this.selectedRanges.Location = new System.Drawing.Point(515, 267);
            this.selectedRanges.Name = "selectedRanges";
            this.selectedRanges.Size = new System.Drawing.Size(214, 160);
            this.selectedRanges.TabIndex = 4;
            // 
            // okBTN
            // 
            this.okBTN.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.okBTN.Location = new System.Drawing.Point(515, 433);
            this.okBTN.Name = "okBTN";
            this.okBTN.Size = new System.Drawing.Size(105, 23);
            this.okBTN.TabIndex = 5;
            this.okBTN.Text = "OK";
            this.okBTN.UseVisualStyleBackColor = true;
            // 
            // cancelBTN
            // 
            this.cancelBTN.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.cancelBTN.Location = new System.Drawing.Point(626, 433);
            this.cancelBTN.Name = "cancelBTN";
            this.cancelBTN.Size = new System.Drawing.Size(105, 23);
            this.cancelBTN.TabIndex = 6;
            this.cancelBTN.Text = "Cancel";
            this.cancelBTN.UseVisualStyleBackColor = true;
            // 
            // toolStrip1
            // 
            this.toolStrip1.AutoSize = false;
            this.toolStrip1.Dock = System.Windows.Forms.DockStyle.None;
            this.toolStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden;
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.presetsCB,
            this.addBTN,
            this.removeBTN});
            this.toolStrip1.Location = new System.Drawing.Point(515, 242);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(214, 25);
            this.toolStrip1.TabIndex = 12;
            this.toolStrip1.Text = "toolStrip1";
            // 
            // presetsCB
            // 
            this.presetsCB.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.addPresetBTN,
            this.removePresetBTN,
            this.toolStripSeparator1});
            this.presetsCB.Image = ((System.Drawing.Image)(resources.GetObject("presetsCB.Image")));
            this.presetsCB.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.presetsCB.Name = "presetsCB";
            this.presetsCB.Size = new System.Drawing.Size(72, 22);
            this.presetsCB.Text = "Presets";
            // 
            // addPresetBTN
            // 
            this.addPresetBTN.Name = "addPresetBTN";
            this.addPresetBTN.Size = new System.Drawing.Size(152, 22);
            this.addPresetBTN.Text = "Add preset";
            // 
            // removePresetBTN
            // 
            this.removePresetBTN.Name = "removePresetBTN";
            this.removePresetBTN.Size = new System.Drawing.Size(152, 22);
            this.removePresetBTN.Text = "Remove preset";
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(149, 6);
            // 
            // addBTN
            // 
            this.addBTN.Image = ((System.Drawing.Image)(resources.GetObject("addBTN.Image")));
            this.addBTN.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.addBTN.Name = "addBTN";
            this.addBTN.Size = new System.Drawing.Size(46, 22);
            this.addBTN.Text = "Add";
            // 
            // removeBTN
            // 
            this.removeBTN.Image = ((System.Drawing.Image)(resources.GetObject("removeBTN.Image")));
            this.removeBTN.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.removeBTN.Name = "removeBTN";
            this.removeBTN.Size = new System.Drawing.Size(66, 22);
            this.removeBTN.Text = "Remove";
            // 
            // AddFontDialog
            // 
            this.AcceptButton = this.okBTN;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.cancelBTN;
            this.ClientSize = new System.Drawing.Size(742, 466);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.cancelBTN);
            this.Controls.Add(this.okBTN);
            this.Controls.Add(this.selectedRanges);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.langPlanesCBL);
            this.Controls.Add(this.fontGrid);
            this.MaximizeBox = false;
            this.MaximumSize = new System.Drawing.Size(750, 500);
            this.MinimizeBox = false;
            this.MinimumSize = new System.Drawing.Size(750, 500);
            this.Name = "AddFontDialog";
            this.Padding = new System.Windows.Forms.Padding(10);
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "Import Font";
            ((System.ComponentModel.ISupportInitialize)(this.fontGrid)).EndInit();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataGridView fontGrid;
        private System.Windows.Forms.DataGridViewTextBoxColumn C0;
        private System.Windows.Forms.DataGridViewTextBoxColumn C1;
        private System.Windows.Forms.DataGridViewTextBoxColumn C2;
        private System.Windows.Forms.DataGridViewTextBoxColumn C3;
        private System.Windows.Forms.DataGridViewTextBoxColumn C4;
        private System.Windows.Forms.DataGridViewTextBoxColumn C5;
        private System.Windows.Forms.DataGridViewTextBoxColumn C6;
        private System.Windows.Forms.DataGridViewTextBoxColumn C7;
        private System.Windows.Forms.DataGridViewTextBoxColumn C8;
        private System.Windows.Forms.DataGridViewTextBoxColumn C9;
        private System.Windows.Forms.DataGridViewTextBoxColumn CA;
        private System.Windows.Forms.DataGridViewTextBoxColumn CB;
        private System.Windows.Forms.DataGridViewTextBoxColumn CC;
        private System.Windows.Forms.DataGridViewTextBoxColumn CD;
        private System.Windows.Forms.DataGridViewTextBoxColumn CE;
        private System.Windows.Forms.DataGridViewTextBoxColumn CF;
        private System.Windows.Forms.CheckedListBox langPlanesCBL;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.ListBox selectedRanges;
        private System.Windows.Forms.Button okBTN;
        private System.Windows.Forms.Button cancelBTN;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.ToolStripDropDownButton presetsCB;
        private System.Windows.Forms.ToolStripMenuItem addPresetBTN;
        private System.Windows.Forms.ToolStripMenuItem removePresetBTN;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripButton addBTN;
        private System.Windows.Forms.ToolStripButton removeBTN;

    }
}