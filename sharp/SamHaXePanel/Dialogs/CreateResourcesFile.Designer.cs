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
            this.versionDD = new System.Windows.Forms.ComboBox();
            this.cancelBTN = new System.Windows.Forms.Button();
            this.okBTN = new System.Windows.Forms.Button();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label3 = new System.Windows.Forms.Label();
            this.compressedCB = new System.Windows.Forms.CheckBox();
            this.browseBTN = new System.Windows.Forms.Button();
            this.locationTXT = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.packageTXT = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.groupBox1.SuspendLayout();
            this.SuspendLayout();
            // 
            // versionDD
            // 
            this.versionDD.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.versionDD.FormattingEnabled = true;
            this.versionDD.Items.AddRange(new object[] {
            "9",
            "10"});
            this.versionDD.Location = new System.Drawing.Point(368, 60);
            this.versionDD.Name = "versionDD";
            this.versionDD.Size = new System.Drawing.Size(84, 21);
            this.versionDD.TabIndex = 0;
            // 
            // cancelBTN
            // 
            this.cancelBTN.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.cancelBTN.Location = new System.Drawing.Point(257, 162);
            this.cancelBTN.Name = "cancelBTN";
            this.cancelBTN.Size = new System.Drawing.Size(225, 23);
            this.cancelBTN.TabIndex = 3;
            this.cancelBTN.Text = "Cancel";
            this.cancelBTN.UseVisualStyleBackColor = true;
            // 
            // okBTN
            // 
            this.okBTN.Location = new System.Drawing.Point(13, 162);
            this.okBTN.Name = "okBTN";
            this.okBTN.Size = new System.Drawing.Size(225, 23);
            this.okBTN.TabIndex = 4;
            this.okBTN.Text = "OK";
            this.okBTN.UseVisualStyleBackColor = true;
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.packageTXT);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.compressedCB);
            this.groupBox1.Controls.Add(this.versionDD);
            this.groupBox1.Location = new System.Drawing.Point(13, 58);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(469, 98);
            this.groupBox1.TabIndex = 5;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Optional Properties";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(246, 65);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(103, 13);
            this.label3.TabIndex = 3;
            this.label3.Text = "Output SWF version";
            // 
            // compressedCB
            // 
            this.compressedCB.AutoSize = true;
            this.compressedCB.Location = new System.Drawing.Point(87, 64);
            this.compressedCB.Name = "compressedCB";
            this.compressedCB.Size = new System.Drawing.Size(84, 17);
            this.compressedCB.TabIndex = 1;
            this.compressedCB.Text = "Compressed";
            this.compressedCB.UseVisualStyleBackColor = true;
            // 
            // browseBTN
            // 
            this.browseBTN.Location = new System.Drawing.Point(370, 29);
            this.browseBTN.Name = "browseBTN";
            this.browseBTN.Size = new System.Drawing.Size(112, 23);
            this.browseBTN.TabIndex = 6;
            this.browseBTN.Text = "Browse";
            this.browseBTN.UseVisualStyleBackColor = true;
            // 
            // locationTXT
            // 
            this.locationTXT.Location = new System.Drawing.Point(13, 30);
            this.locationTXT.Name = "locationTXT";
            this.locationTXT.Size = new System.Drawing.Size(340, 20);
            this.locationTXT.TabIndex = 7;
            this.locationTXT.WordWrap = false;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 11);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(129, 13);
            this.label1.TabIndex = 8;
            this.label1.Text = "New resource file location";
            // 
            // packageTXT
            // 
            this.packageTXT.Location = new System.Drawing.Point(87, 19);
            this.packageTXT.Name = "packageTXT";
            this.packageTXT.Size = new System.Drawing.Size(365, 20);
            this.packageTXT.TabIndex = 4;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(19, 23);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(50, 13);
            this.label2.TabIndex = 5;
            this.label2.Text = "Package";
            // 
            // CreateResourcesFile
            // 
            this.AcceptButton = this.okBTN;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.cancelBTN;
            this.ClientSize = new System.Drawing.Size(494, 198);
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

        private System.Windows.Forms.ComboBox versionDD;
        private System.Windows.Forms.Button cancelBTN;
        private System.Windows.Forms.Button okBTN;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.CheckBox compressedCB;
        private System.Windows.Forms.Button browseBTN;
        private System.Windows.Forms.TextBox locationTXT;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox packageTXT;
    }
}