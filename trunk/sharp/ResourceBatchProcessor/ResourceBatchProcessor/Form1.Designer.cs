namespace ResourceBatchProcessor
{
    partial class Form1
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
            this.buttonSelectFolder = new System.Windows.Forms.Button();
            this.textSelectedFolder = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.buttonCreateMXML = new System.Windows.Forms.Button();
            this.buttonSelectAllFolders = new System.Windows.Forms.Button();
            this.label2 = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // buttonSelectFolder
            // 
            this.buttonSelectFolder.Location = new System.Drawing.Point(12, 56);
            this.buttonSelectFolder.Name = "buttonSelectFolder";
            this.buttonSelectFolder.Size = new System.Drawing.Size(733, 23);
            this.buttonSelectFolder.TabIndex = 0;
            this.buttonSelectFolder.Text = "Select images folder";
            this.buttonSelectFolder.UseVisualStyleBackColor = true;
            // 
            // textSelectedFolder
            // 
            this.textSelectedFolder.Location = new System.Drawing.Point(12, 25);
            this.textSelectedFolder.Name = "textSelectedFolder";
            this.textSelectedFolder.Size = new System.Drawing.Size(733, 20);
            this.textSelectedFolder.TabIndex = 1;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(102, 13);
            this.label1.TabIndex = 2;
            this.label1.Text = "Select images folder";
            // 
            // buttonCreateMXML
            // 
            this.buttonCreateMXML.Location = new System.Drawing.Point(12, 134);
            this.buttonCreateMXML.Name = "buttonCreateMXML";
            this.buttonCreateMXML.Size = new System.Drawing.Size(730, 23);
            this.buttonCreateMXML.TabIndex = 3;
            this.buttonCreateMXML.Text = "Create MXML file";
            this.buttonCreateMXML.UseVisualStyleBackColor = true;
            // 
            // buttonSelectAllFolders
            // 
            this.buttonSelectAllFolders.Location = new System.Drawing.Point(12, 85);
            this.buttonSelectAllFolders.Name = "buttonSelectAllFolders";
            this.buttonSelectAllFolders.Size = new System.Drawing.Size(733, 23);
            this.buttonSelectAllFolders.TabIndex = 4;
            this.buttonSelectAllFolders.Text = "Select all image folders in...";
            this.buttonSelectAllFolders.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D;
            this.label2.Location = new System.Drawing.Point(-2, 119);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(760, 2);
            this.label2.TabIndex = 5;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.AutoSize = true;
            this.AutoSizeMode = System.Windows.Forms.AutoSizeMode.GrowAndShrink;
            this.ClientSize = new System.Drawing.Size(757, 190);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.buttonSelectAllFolders);
            this.Controls.Add(this.buttonCreateMXML);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textSelectedFolder);
            this.Controls.Add(this.buttonSelectFolder);
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Padding = new System.Windows.Forms.Padding(0, 0, 0, 10);
            this.ShowInTaskbar = false;
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "Images batch compiler";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button buttonSelectFolder;
        private System.Windows.Forms.TextBox textSelectedFolder;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button buttonCreateMXML;
        private System.Windows.Forms.Button buttonSelectAllFolders;
        private System.Windows.Forms.Label label2;
    }
}

