using System;
using System.Collections;
using System.IO;
using System.Windows.Forms;
using NFXContext.TemplateShell;
using PluginCore;

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
        private TextBox outputSWF;
        private Label label1;
        private Button browseForOutput;

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
            this.outputSWF = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.browseForOutput = new System.Windows.Forms.Button();
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
            this.generate.Location = new System.Drawing.Point(6, 104);
            this.generate.Name = "generate";
            this.generate.Size = new System.Drawing.Size(675, 23);
            this.generate.TabIndex = 4;
            this.generate.Text = "Generate";
            this.generate.UseVisualStyleBackColor = true;
            this.generate.Click += new System.EventHandler(this.generate_Click);
            // 
            // nfxLocation
            // 
            this.nfxLocation.Location = new System.Drawing.Point(6, 133);
            this.nfxLocation.Name = "nfxLocation";
            this.nfxLocation.Size = new System.Drawing.Size(593, 20);
            this.nfxLocation.TabIndex = 5;
            this.nfxLocation.Text = "nfx.jar location";
            // 
            // browseForNFX
            // 
            this.browseForNFX.Location = new System.Drawing.Point(606, 131);
            this.browseForNFX.Name = "browseForNFX";
            this.browseForNFX.Size = new System.Drawing.Size(75, 23);
            this.browseForNFX.TabIndex = 6;
            this.browseForNFX.Text = "Browse";
            this.browseForNFX.UseVisualStyleBackColor = true;
            this.browseForNFX.Click += new System.EventHandler(this.browseForNFX_Click);
            // 
            // jdkLocation
            // 
            this.jdkLocation.Location = new System.Drawing.Point(6, 159);
            this.jdkLocation.Name = "jdkLocation";
            this.jdkLocation.Size = new System.Drawing.Size(593, 20);
            this.jdkLocation.TabIndex = 8;
            this.jdkLocation.Text = "JDK location";
            // 
            // browseJDK
            // 
            this.browseJDK.Location = new System.Drawing.Point(606, 159);
            this.browseJDK.Name = "browseJDK";
            this.browseJDK.Size = new System.Drawing.Size(75, 23);
            this.browseJDK.TabIndex = 9;
            this.browseJDK.Text = "Browse";
            this.browseJDK.UseVisualStyleBackColor = true;
            this.browseJDK.Click += new System.EventHandler(this.browseJDK_Click);
            // 
            // outputSWF
            // 
            this.outputSWF.Location = new System.Drawing.Point(6, 74);
            this.outputSWF.Name = "outputSWF";
            this.outputSWF.Size = new System.Drawing.Size(593, 20);
            this.outputSWF.TabIndex = 10;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 55);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(54, 13);
            this.label1.TabIndex = 11;
            this.label1.Text = "Output to:";
            // 
            // browseForOutput
            // 
            this.browseForOutput.Location = new System.Drawing.Point(606, 74);
            this.browseForOutput.Name = "browseForOutput";
            this.browseForOutput.Size = new System.Drawing.Size(75, 23);
            this.browseForOutput.TabIndex = 12;
            this.browseForOutput.Text = "Browse";
            this.browseForOutput.UseVisualStyleBackColor = true;
            this.browseForOutput.Click += new System.EventHandler(this.browseForOutput_Click);
            // 
            // PluginUI
            // 
            this.Controls.Add(this.browseForOutput);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.outputSWF);
            this.Controls.Add(this.browseJDK);
            this.Controls.Add(this.jdkLocation);
            this.Controls.Add(this.browseForNFX);
            this.Controls.Add(this.nfxLocation);
            this.Controls.Add(this.generate);
            this.Controls.Add(this.launchBrowseDialog);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.browseForFile);
            this.Name = "PluginUI";
            this.Size = new System.Drawing.Size(700, 206);
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
                if (String.IsNullOrEmpty(this.outputSWF.Text))
                {
                    this.outputSWF.Text = dialog.FileNames[0].Replace(".mxml", ".swf");
                }
            }
        }

        private void generate_Click(object sender, EventArgs e)
        {
            /*OutputPanel.PluginMain op = 
                (OutputPanel.PluginMain)PluginBase.MainForm.FindPlugin(
                "54749f71-694b-47e0-9b05-e9417f39f20d");
            ControlCollection cc = op.PluginPanel.Controls;
            IEnumerator iter = cc.GetEnumerator();
            Control c = null;
            while (iter.MoveNext())
            {
                c = (Control)iter.Current;
                if (c is OutputPanel.PluginUI)
                {
                    (c as OutputPanel.PluginUI).ClearOutput(null, null);
                    break;
                }
            }*/
            PluginCore.Managers.EventManager.DispatchEvent(
                this, new DataEvent(EventType.Command, "ResultsPanel.ClearResults", null));
            
            if (!String.IsNullOrEmpty(this.browseForFile.Text)
                && !String.IsNullOrEmpty(this.nfxLocation.Text)
                && this.nfxLocation.Text != "nfx.jar location")
            {
                FileInfo fi = new FileInfo(this.browseForFile.Text);
                FileInfo fij = new FileInfo(this.nfxLocation.Text);
                FileInfo jc = new FileInfo(this.jdkLocation.Text);

                if (String.IsNullOrEmpty(this.outputSWF.Text))
                {
                    this.outputSWF.Text = this.browseForFile.Text.Replace(".mxml", ".swf");
                }

                if (fi.Exists && fij.Exists)
                {
                    Hashtable ht = new Hashtable();
                    ht.Add("-source", this.browseForFile.Text);
                    ht.Add("-output", this.outputSWF.Text);
                    if (jc.Exists)
                    {
                        NFXShell.Run(fi, this.nfxLocation.Text, this.jdkLocation.Text, ht);
                    }
                    else
                    {
                        NFXShell.Run(fi, this.nfxLocation.Text, null, ht);
                    }
                }
                if (!fi.Exists)
                {
                    PluginCore.Managers.TraceManager.Add(
                        "Cannot find MXML template.",
                        (Int32)PluginCore.TraceType.Fatal);
                }
                if (!fij.Exists)
                {
                    PluginCore.Managers.TraceManager.Add(
                        "Cannot find nfx.jar.",
                        (Int32)PluginCore.TraceType.Fatal);
                }
                if (!jc.Exists)
                {
                    PluginCore.Managers.TraceManager.Add(
                        "Cannot find java.exe. Default java.exe will be used.",
                        (Int32)PluginCore.TraceType.Info);
                }
            }
            if (String.IsNullOrEmpty(this.browseForFile.Text))
            {
                PluginCore.Managers.TraceManager.Add(
                        "You must select MXML file.",
                        (Int32)PluginCore.TraceType.Fatal);
            }
            if (String.IsNullOrEmpty(this.nfxLocation.Text) || 
                this.nfxLocation.Text == "nfx.jar location")
            {
                PluginCore.Managers.TraceManager.Add(
                        "Locate nfx.jar",
                        (Int32)PluginCore.TraceType.Fatal);
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
            dialog.Filter = "Java runtime launcher (*.exe)|*.exe";
            DialogResult dr = dialog.ShowDialog();
            if (dr == DialogResult.OK)
            {
                this.jdkLocation.Text = dialog.FileNames[0];
            }
        }

        private void browseForOutput_Click(object sender, EventArgs e)
        {
            SaveFileDialog dialog = new SaveFileDialog();
            dialog.CheckFileExists = true;
            dialog.Filter = "SWF ShockWave Flash (*.swf)|*.swf";
            DialogResult dr = dialog.ShowDialog();
            if (dr == DialogResult.OK)
            {
                this.outputSWF.Text = dialog.FileNames[0];
            }
        }		
 	}

}
