namespace SamHaXePanel.Dialogs
{
    partial class CreateResourcesFile
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
            this.cancelBTN = new System.Windows.Forms.Button();
            this.okBTN = new System.Windows.Forms.Button();
            this.browseBTN = new System.Windows.Forms.Button();
            this.locationTXT = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.fromFolderBTN = new System.Windows.Forms.Button();
            this.recursiveCB = new System.Windows.Forms.CheckBox();
            this.generateCompositeCB = new System.Windows.Forms.CheckBox();
            this.versionDD = new System.Windows.Forms.ComboBox();
            this.compressedCB = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.packageTXT = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.fileFilerTXT = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.selectedFolderTXT = new System.Windows.Forms.TextBox();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // cancelBTN
            // 
            this.cancelBTN.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.cancelBTN.Location = new System.Drawing.Point(257, 261);
            this.cancelBTN.Name = "cancelBTN";
            this.cancelBTN.Size = new System.Drawing.Size(225, 23);
            this.cancelBTN.TabIndex = 3;
            this.cancelBTN.Text = "Cancel";
            this.cancelBTN.UseVisualStyleBackColor = true;
            // 
            // okBTN
            // 
            this.okBTN.Location = new System.Drawing.Point(13, 261);
            this.okBTN.Name = "okBTN";
            this.okBTN.Size = new System.Drawing.Size(225, 23);
            this.okBTN.TabIndex = 4;
            this.okBTN.Text = "OK";
            this.okBTN.UseVisualStyleBackColor = true;
            // 
            // browseBTN
            // 
            this.browseBTN.Location = new System.Drawing.Point(370, 29);
            this.browseBTN.Name = "browseBTN";
            this.browseBTN.Size = new System.Drawing.Size(106, 23);
            this.browseBTN.TabIndex = 6;
            this.browseBTN.Text = "Browse";
            this.browseBTN.UseVisualStyleBackColor = true;
            // 
            // locationTXT
            // 
            this.locationTXT.Location = new System.Drawing.Point(19, 30);
            this.locationTXT.Name = "locationTXT";
            this.locationTXT.Size = new System.Drawing.Size(334, 20);
            this.locationTXT.TabIndex = 7;
            this.locationTXT.WordWrap = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(16, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(129, 13);
            this.label1.TabIndex = 8;
            this.label1.Text = "New resource file location";
            // 
            // fromFolderBTN
            // 
            this.fromFolderBTN.Location = new System.Drawing.Point(370, 58);
            this.fromFolderBTN.Name = "fromFolderBTN";
            this.fromFolderBTN.Size = new System.Drawing.Size(106, 23);
            this.fromFolderBTN.TabIndex = 10;
            this.fromFolderBTN.Text = "Create from folder";
            this.fromFolderBTN.UseVisualStyleBackColor = true;
            // 
            // recursiveCB
            // 
            this.recursiveCB.AutoSize = true;
            this.recursiveCB.Location = new System.Drawing.Point(18, 87);
            this.recursiveCB.Name = "recursiveCB";
            this.recursiveCB.Size = new System.Drawing.Size(74, 17);
            this.recursiveCB.TabIndex = 11;
            this.recursiveCB.Text = "Recursive";
            this.recursiveCB.UseVisualStyleBackColor = true;
            // 
            // generateCompositeCB
            // 
            this.generateCompositeCB.AutoSize = true;
            this.generateCompositeCB.Location = new System.Drawing.Point(98, 87);
            this.generateCompositeCB.Name = "generateCompositeCB";
            this.generateCompositeCB.Size = new System.Drawing.Size(127, 17);
            this.generateCompositeCB.TabIndex = 12;
            this.generateCompositeCB.Text = "Generate Composites";
            this.generateCompositeCB.UseVisualStyleBackColor = true;
            // 
            // versionDD
            // 
            this.versionDD.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.versionDD.FormattingEnabled = true;
            this.versionDD.Items.AddRange(new object[] {
            "9",
            "10"});
            this.versionDD.Location = new System.Drawing.Point(357, 38);
            this.versionDD.Name = "versionDD";
            this.versionDD.Size = new System.Drawing.Size(106, 21);
            this.versionDD.TabIndex = 0;
            // 
            // compressedCB
            // 
            this.compressedCB.AutoSize = true;
            this.compressedCB.Location = new System.Drawing.Point(6, 69);
            this.compressedCB.Name = "compressedCB";
            this.compressedCB.Size = new System.Drawing.Size(84, 17);
            this.compressedCB.TabIndex = 1;
            this.compressedCB.Text = "Compressed";
            this.compressedCB.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(354, 20);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(103, 13);
            this.label3.TabIndex = 3;
            this.label3.Text = "Output SWF version";
            // 
            // packageTXT
            // 
            this.packageTXT.Location = new System.Drawing.Point(6, 38);
            this.packageTXT.Name = "packageTXT";
            this.packageTXT.Size = new System.Drawing.Size(334, 20);
            this.packageTXT.TabIndex = 4;
            this.packageTXT.Text = "resources";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 20);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(50, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Package";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.packageTXT);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.compressedCB);
            this.groupBox1.Controls.Add(this.versionDD);
            this.groupBox1.Location = new System.Drawing.Point(13, 159);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(469, 96);
            this.groupBox1.TabIndex = 5;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Optional Properties";
            // 
            // fileFilerTXT
            // 
            this.fileFilerTXT.Location = new System.Drawing.Point(18, 133);
            this.fileFilerTXT.Name = "fileFilerTXT";
            this.fileFilerTXT.Size = new System.Drawing.Size(457, 20);
            this.fileFilerTXT.TabIndex = 13;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(15, 115);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(123, 13);
            this.label4.TabIndex = 14;
            this.label4.Text = "Filter (regular expression)";
            // 
            // selectedFolderTXT
            // 
            this.selectedFolderTXT.Location = new System.Drawing.Point(19, 61);
            this.selectedFolderTXT.Name = "selectedFolderTXT";
            this.selectedFolderTXT.Size = new System.Drawing.Size(334, 20);
            this.selectedFolderTXT.TabIndex = 15;
            // 
            // CreateResourcesFile
            // 
            this.AcceptButton = this.okBTN;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.cancelBTN;
            this.ClientSize = new System.Drawing.Size(494, 308);
            this.Controls.Add(this.selectedFolderTXT);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.fileFilerTXT);
            this.Controls.Add(this.generateCompositeCB);
            this.Controls.Add(this.recursiveCB);
            this.Controls.Add(this.fromFolderBTN);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.locationTXT);
            this.Controls.Add(this.browseBTN);
            this.Controls.Add(this.groupBox1);
            this.Controls.Add(this.okBTN);
            this.Controls.Add(this.cancelBTN);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "CreateResourcesFile";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.SizeGripStyle = System.Windows.Forms.SizeGripStyle.Hide;
            this.Text = "Create Resources File";
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Button cancelBTN;
        private System.Windows.Forms.Button okBTN;
        private System.Windows.Forms.Button browseBTN;
        private System.Windows.Forms.TextBox locationTXT;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button fromFolderBTN;
        private System.Windows.Forms.CheckBox recursiveCB;
        private System.Windows.Forms.CheckBox generateCompositeCB;
        private System.Windows.Forms.ComboBox versionDD;
        private System.Windows.Forms.CheckBox compressedCB;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox packageTXT;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox fileFilerTXT;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox selectedFolderTXT;
    }
}