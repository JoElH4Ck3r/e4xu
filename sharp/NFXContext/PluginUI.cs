using System;
using System.Collections;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI;
using PluginCore;
using NFXContext.Embeds;
using NFXContext.Enums;
using System.IO;
using NFXContext.TemplateShell;

namespace NFXContext
{
	public class PluginUI : UserControl
    {
        private PluginMain pluginMain;

        private BindingSource imgSource = new BindingSource();
        private static string[] filters = new string[8]
        { "Image files (*.jpg,*.jpeg,*.gif,*.png)|*.jpg;*.jpeg;*.gif;*.png",
            "", "", "", "", "", "", "" };

        private NFXContext.NFXProject project;
        private TextBox browseForFile;
        private Label label2;
        private Button launchBrowseDialog;
        private Button generate;
        private TextBox nfxLocation;
        private Button browseForNFX;
        private TextBox jdkLocation;
        private Button browseJDK;
        private GroupBox statusBox;
        private TextBox statusLabel;

        public NFXProject Project
        {
            set
            {
                project = value;
                enabled = project != null;
            }
            get { return project; }
        }

        private bool enabled = false;

		public PluginUI(PluginMain pluginMain)
		{
			this.InitializeComponent();
			this.pluginMain = pluginMain;
            this.Show();
            //this.SetInitialValues();
            //this.SetupHandlers();
            //this.Resize += new EventHandler(PluginUI_Resize);
		}

		#region Windows Forms Designer Generated Code

		/// <summary>
		/// This method is required for Windows Forms designer support.
		/// Do not change the method contents inside the source code editor. The Forms designer might
		/// not be able to load this method if it was changed manually.
		/// </summary>
		private void InitializeComponent() 
        {
            this.browseForFile = new System.Windows.Forms.TextBox();
            this.label2 = new System.Windows.Forms.Label();
            this.launchBrowseDialog = new System.Windows.Forms.Button();
            this.generate = new System.Windows.Forms.Button();
            this.nfxLocation = new System.Windows.Forms.TextBox();
            this.browseForNFX = new System.Windows.Forms.Button();
            this.jdkLocation = new System.Windows.Forms.TextBox();
            this.browseJDK = new System.Windows.Forms.Button();
            this.statusBox = new System.Windows.Forms.GroupBox();
            this.statusLabel = new System.Windows.Forms.TextBox();
            this.statusBox.SuspendLayout();
            this.SuspendLayout();
            // 
            // browseForFile
            // 
            this.browseForFile.Location = new System.Drawing.Point(6, 27);
            this.browseForFile.Name = "browseForFile";
            this.browseForFile.Size = new System.Drawing.Size(593, 20);
            this.browseForFile.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 8);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(120, 13);
            this.label2.TabIndex = 2;
            this.label2.Text = "Generate template from:";
            // 
            // launchBrowseDialog
            // 
            this.launchBrowseDialog.Location = new System.Drawing.Point(606, 27);
            this.launchBrowseDialog.Name = "launchBrowseDialog";
            this.launchBrowseDialog.Size = new System.Drawing.Size(75, 23);
            this.launchBrowseDialog.TabIndex = 3;
            this.launchBrowseDialog.Text = "Browse";
            this.launchBrowseDialog.UseVisualStyleBackColor = true;
            this.launchBrowseDialog.Click += new System.EventHandler(this.launchBrowseDialog_Click);
            // 
            // generate
            // 
            this.generate.Location = new System.Drawing.Point(6, 56);
            this.generate.Name = "generate";
            this.generate.Size = new System.Drawing.Size(675, 23);
            this.generate.TabIndex = 4;
            this.generate.Text = "Generate";
            this.generate.UseVisualStyleBackColor = true;
            this.generate.Click += new System.EventHandler(this.generate_Click);
            // 
            // nfxLocation
            // 
            this.nfxLocation.Location = new System.Drawing.Point(6, 85);
            this.nfxLocation.Name = "nfxLocation";
            this.nfxLocation.Size = new System.Drawing.Size(593, 20);
            this.nfxLocation.TabIndex = 5;
            this.nfxLocation.Text = "nfx.jar location";
            // 
            // browseForNFX
            // 
            this.browseForNFX.Location = new System.Drawing.Point(606, 83);
            this.browseForNFX.Name = "browseForNFX";
            this.browseForNFX.Size = new System.Drawing.Size(75, 23);
            this.browseForNFX.TabIndex = 6;
            this.browseForNFX.Text = "Browse";
            this.browseForNFX.UseVisualStyleBackColor = true;
            this.browseForNFX.Click += new System.EventHandler(this.browseForNFX_Click);
            // 
            // jdkLocation
            // 
            this.jdkLocation.Location = new System.Drawing.Point(6, 111);
            this.jdkLocation.Name = "jdkLocation";
            this.jdkLocation.Size = new System.Drawing.Size(593, 20);
            this.jdkLocation.TabIndex = 8;
            this.jdkLocation.Text = "JDK location";
            // 
            // browseJDK
            // 
            this.browseJDK.Location = new System.Drawing.Point(606, 111);
            this.browseJDK.Name = "browseJDK";
            this.browseJDK.Size = new System.Drawing.Size(75, 23);
            this.browseJDK.TabIndex = 9;
            this.browseJDK.Text = "Browse";
            this.browseJDK.UseVisualStyleBackColor = true;
            this.browseJDK.Click += new System.EventHandler(this.browseJDK_Click);
            // 
            // statusBox
            // 
            this.statusBox.Controls.Add(this.statusLabel);
            this.statusBox.Location = new System.Drawing.Point(9, 137);
            this.statusBox.Name = "statusBox";
            this.statusBox.Size = new System.Drawing.Size(672, 277);
            this.statusBox.TabIndex = 10;
            this.statusBox.TabStop = false;
            this.statusBox.Text = "Status";
            // 
            // statusLabel
            // 
            this.statusLabel.Location = new System.Drawing.Point(6, 19);
            this.statusLabel.Multiline = true;
            this.statusLabel.Name = "statusLabel";
            this.statusLabel.Size = new System.Drawing.Size(660, 252);
            this.statusLabel.TabIndex = 8;
            // 
            // PluginUI
            // 
            this.Controls.Add(this.statusBox);
            this.Controls.Add(this.browseJDK);
            this.Controls.Add(this.jdkLocation);
            this.Controls.Add(this.browseForNFX);
            this.Controls.Add(this.nfxLocation);
            this.Controls.Add(this.generate);
            this.Controls.Add(this.launchBrowseDialog);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.browseForFile);
            this.Name = "PluginUI";
            this.Size = new System.Drawing.Size(800, 450);
            this.statusBox.ResumeLayout(false);
            this.statusBox.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		#endregion

        private void launchBrowseDialog_Click(object sender, EventArgs e)
        {
            OpenFileDialog dialog = new OpenFileDialog();
            dialog.CheckFileExists = true;
            dialog.Filter = "MXML template files (*.mxml)|*.mxml|All files (*.*)|*.*";
            DialogResult dr = dialog.ShowDialog();
            if (dr == DialogResult.OK)
            {
                this.browseForFile.Text = dialog.FileNames[0];
            }
        }

        private void generate_Click(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(this.browseForFile.Text)
                && !String.IsNullOrEmpty(this.nfxLocation.Text)
                && this.nfxLocation.Text != "nfx.jar location")
            {
                FileInfo fi = new FileInfo(this.browseForFile.Text);
                FileInfo fij = new FileInfo(this.nfxLocation.Text);
                FileInfo jc = new FileInfo(this.jdkLocation.Text);
                
                if (fi.Exists && fij.Exists)
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("-source", this.browseForFile.Text);
                    if (jc.Exists)
                    {
                        this.statusLabel.Text += @NFXShell.Run(fi, this.nfxLocation.Text, this.jdkLocation.Text, ht);
                    }
                    else
                    {
                        this.statusLabel.Text += @NFXShell.Run(fi, this.nfxLocation.Text, null, ht);
                    }
                }
                else if (!fi.Exists)
                {
                    this.statusLabel.Text += Environment.NewLine + "Cannot find MXML template.";
                }
                else if (!fij.Exists)
                {
                    this.statusLabel.Text += Environment.NewLine + "Cannot find nfx.jar.";
                }
                if (!jc.Exists)
                {
                    this.statusLabel.Text += Environment.NewLine + "Cannot find java.exe. Default java.exe will be used";
                }
            }
            else if (String.IsNullOrEmpty(this.browseForFile.Text))
            {
                this.statusLabel.Text += Environment.NewLine + "You must select MXML file.";
            }
            else if (String.IsNullOrEmpty(this.nfxLocation.Text) || this.nfxLocation.Text == "nfx.jar location")
            {
                this.statusLabel.Text += Environment.NewLine + "Locate nfx.jar";
            }
        }

        private void browseForNFX_Click(object sender, EventArgs e)
        {
            OpenFileDialog dialog = new OpenFileDialog();
            dialog.CheckFileExists = true;
            dialog.Filter = "JAR files (*.jar)|*.jar";
            DialogResult dr = dialog.ShowDialog();
            if (dr == DialogResult.OK)
            {
                this.nfxLocation.Text = dialog.FileNames[0];
            }
        }

        private void browseJDK_Click(object sender, EventArgs e)
        {
            OpenFileDialog dialog = new OpenFileDialog();
            dialog.CheckFileExists = true;
            dialog.Filter = "Javac compiler (*.exe)|*.exe";
            DialogResult dr = dialog.ShowDialog();
            if (dr == DialogResult.OK)
            {
                this.jdkLocation.Text = dialog.FileNames[0];
            }
        }		
 	}

}
