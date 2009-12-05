using System;
using System.Collections;
using System.Windows.Forms;
using WeifenLuo.WinFormsUI;
using PluginCore;
using ResourcePRJ.Embeds;
using ResourcePRJ.Enums;
using System.IO;

namespace ResourcePRJ
{
	public class PluginUI : UserControl
    {
        private TabControl navigator;
        private TabPage images;
        private TabPage sounds;
        private DataGridView imagesDG;
        private DataGridView soundsDG;
        private Button addFile;
        private Button addFolder;
        private Label label1;
        private TextBox fileMask;
        private CheckBox checkBox1;
        private TabPage fonts;
        private TabPage swf;
        private TabPage svg;
        private TabPage fxg;
        private TabPage txt;
        private TabPage bin;
        private DataGridView fontsDG;
        private DataGridView swfDG;
        private DataGridView svgDG;
        private DataGridView fxgDG;
        private DataGridView stringsDG;
        private DataGridView binaryDG;
        private DataGridViewTextBoxColumn fileNameSND;
        private DataGridViewTextBoxColumn packageSND;
        private DataGridViewTextBoxColumn assetSND;
        private DataGridViewTextBoxColumn fileFNT;
        private DataGridViewTextBoxColumn packageFNT;
        private DataGridViewTextBoxColumn assetFNT;
        private DataGridViewTextBoxColumn fontFamily;
        private DataGridViewTextBoxColumn fontName;
        private DataGridViewTextBoxColumn fontStyle;
        private DataGridViewTextBoxColumn fontWeight;
        private DataGridViewTextBoxColumn advancedAntiAliasing;
        private DataGridViewTextBoxColumn flashType;
        private DataGridViewTextBoxColumn fontGridFitType;
        private DataGridViewTextBoxColumn fontSharpness;
        private DataGridViewTextBoxColumn fontThickness;
        private DataGridViewTextBoxColumn unicodeRange;
        private DataGridViewTextBoxColumn cff;
        private DataGridViewTextBoxColumn fileSWF;
        private DataGridViewTextBoxColumn symbol;
        private DataGridViewTextBoxColumn packageSWF;
        private DataGridViewTextBoxColumn assetSWF;
        private DataGridViewTextBoxColumn fileSVG;
        private DataGridViewTextBoxColumn packageSVG;
        private DataGridViewTextBoxColumn assetSVG;
        private DataGridViewTextBoxColumn fileFXG;
        private DataGridViewTextBoxColumn packageFXG;
        private DataGridViewTextBoxColumn assetFXG;
		private PluginMain pluginMain;
        private DataGridViewTextBoxColumn fileIMG;
        private DataGridViewTextBoxColumn packageIMG;
        private DataGridViewTextBoxColumn assetIMG;

        private BindingSource imgSource = new BindingSource();
        private static string[] filters = new string[8]
        { "Image files (*.jpg,*.jpeg,*.gif,*.png)|*.jpg;*.jpeg;*.gif;*.png",
            "", "", "", "", "", "", "" };

        private AssetTypes mode = AssetTypes.Img;

        private ResourcePRJ.RSXProject project;

        public RSXProject Project
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
            this.SetInitialValues();
            this.SetupHandlers();
            //this.Resize += new EventHandler(PluginUI_Resize);
		}

        private void PluginUI_Resize(object sender, EventArgs e)
        {
            this.navigator.Width = this.Width - 5;
        }

        private void SetupHandlers()
        {
            this.addFile.Click += new EventHandler(addFile_Click);
        }

        void addFile_Click(object sender, EventArgs e)
        {
            if (!enabled) return;
            string filter;
            switch (mode)
            {
                case AssetTypes.Img:
                    filter = filters[0];
                    break;
                case AssetTypes.Snd:
                    filter = filters[0];
                    break;
                case AssetTypes.Fnt:
                    filter = filters[0];
                    break;
                case AssetTypes.Swf:
                    filter = filters[0];
                    break;
                case AssetTypes.Svg:
                    filter = filters[0];
                    break;
                case AssetTypes.Fxg:
                    filter = filters[0];
                    break;
                case AssetTypes.Bin:
                    filter = filters[0];
                    break;
                case AssetTypes.Txt:
                    filter = filters[0];
                    break;
                default:
                    filter = filters[0];
                    break;
            }
            OpenFileDialog fd = new OpenFileDialog();
            fd.Multiselect = true;
            fd.Filter = filter;
            fd.InitialDirectory = project.Directory;
            if (fd.ShowDialog() == DialogResult.OK)
            {
                if (fd.FileNames.Length > 0)
                {
                    foreach (string n in fd.FileNames)
                    {
                        this.imgSource.Add(new EmbedImg(n, "Image1", "com.example.assets.img"));
                    }
                    this.pluginMain.AddFiles(fd.FileNames, mode);
                }
            }
        }

        private void SetInitialValues()
        {
            this.imgSource.Add(new EmbedImg("C:\\Temp\\Image004.jpg", "Image1", "com.example.assets.img"));
            this.imagesDG.DataSource = this.imgSource;
        }

		#region Windows Forms Designer Generated Code

		/// <summary>
		/// This method is required for Windows Forms designer support.
		/// Do not change the method contents inside the source code editor. The Forms designer might
		/// not be able to load this method if it was changed manually.
		/// </summary>
		private void InitializeComponent() 
        {
            this.navigator = new System.Windows.Forms.TabControl();
            this.images = new System.Windows.Forms.TabPage();
            this.imagesDG = new System.Windows.Forms.DataGridView();
            this.sounds = new System.Windows.Forms.TabPage();
            this.soundsDG = new System.Windows.Forms.DataGridView();
            this.fileNameSND = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.packageSND = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.assetSND = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fonts = new System.Windows.Forms.TabPage();
            this.fontsDG = new System.Windows.Forms.DataGridView();
            this.fileFNT = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.packageFNT = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.assetFNT = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontFamily = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontName = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontStyle = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontWeight = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.advancedAntiAliasing = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.flashType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontGridFitType = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontSharpness = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fontThickness = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.unicodeRange = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.cff = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.swf = new System.Windows.Forms.TabPage();
            this.swfDG = new System.Windows.Forms.DataGridView();
            this.fileSWF = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.symbol = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.packageSWF = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.assetSWF = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.svg = new System.Windows.Forms.TabPage();
            this.svgDG = new System.Windows.Forms.DataGridView();
            this.fileSVG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.packageSVG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.assetSVG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.fxg = new System.Windows.Forms.TabPage();
            this.fxgDG = new System.Windows.Forms.DataGridView();
            this.fileFXG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.packageFXG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.assetFXG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.txt = new System.Windows.Forms.TabPage();
            this.stringsDG = new System.Windows.Forms.DataGridView();
            this.bin = new System.Windows.Forms.TabPage();
            this.binaryDG = new System.Windows.Forms.DataGridView();
            this.addFile = new System.Windows.Forms.Button();
            this.addFolder = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.fileMask = new System.Windows.Forms.TextBox();
            this.checkBox1 = new System.Windows.Forms.CheckBox();
            this.fileIMG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.packageIMG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.assetIMG = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.navigator.SuspendLayout();
            this.images.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.imagesDG)).BeginInit();
            this.sounds.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.soundsDG)).BeginInit();
            this.fonts.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fontsDG)).BeginInit();
            this.swf.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.swfDG)).BeginInit();
            this.svg.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.svgDG)).BeginInit();
            this.fxg.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.fxgDG)).BeginInit();
            this.txt.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.stringsDG)).BeginInit();
            this.bin.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.binaryDG)).BeginInit();
            this.SuspendLayout();
            // 
            // navigator
            // 
            this.navigator.Controls.Add(this.images);
            this.navigator.Controls.Add(this.sounds);
            this.navigator.Controls.Add(this.fonts);
            this.navigator.Controls.Add(this.swf);
            this.navigator.Controls.Add(this.svg);
            this.navigator.Controls.Add(this.fxg);
            this.navigator.Controls.Add(this.txt);
            this.navigator.Controls.Add(this.bin);
            this.navigator.Dock = System.Windows.Forms.DockStyle.Top;
            this.navigator.Location = new System.Drawing.Point(0, 0);
            this.navigator.Name = "navigator";
            this.navigator.SelectedIndex = 0;
            this.navigator.Size = new System.Drawing.Size(800, 350);
            this.navigator.TabIndex = 1;
            // 
            // images
            // 
            this.images.Controls.Add(this.imagesDG);
            this.images.Location = new System.Drawing.Point(4, 23);
            this.images.Name = "images";
            this.images.Padding = new System.Windows.Forms.Padding(3);
            this.images.Size = new System.Drawing.Size(792, 323);
            this.images.TabIndex = 0;
            this.images.Text = "Images";
            this.images.UseVisualStyleBackColor = true;
            // 
            // imagesDG
            // 
            this.imagesDG.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.imagesDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.imagesDG.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.fileIMG,
            this.packageIMG,
            this.assetIMG});
            this.imagesDG.Dock = System.Windows.Forms.DockStyle.Fill;
            this.imagesDG.Location = new System.Drawing.Point(3, 3);
            this.imagesDG.Name = "imagesDG";
            this.imagesDG.Size = new System.Drawing.Size(786, 317);
            this.imagesDG.TabIndex = 0;
            // 
            // sounds
            // 
            this.sounds.Controls.Add(this.soundsDG);
            this.sounds.Location = new System.Drawing.Point(4, 23);
            this.sounds.Name = "sounds";
            this.sounds.Padding = new System.Windows.Forms.Padding(3);
            this.sounds.Size = new System.Drawing.Size(792, 323);
            this.sounds.TabIndex = 1;
            this.sounds.Text = "Sounds";
            this.sounds.UseVisualStyleBackColor = true;
            // 
            // soundsDG
            // 
            this.soundsDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.soundsDG.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.fileNameSND,
            this.packageSND,
            this.assetSND});
            this.soundsDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.soundsDG.Location = new System.Drawing.Point(3, 3);
            this.soundsDG.Name = "soundsDG";
            this.soundsDG.Size = new System.Drawing.Size(786, 323);
            this.soundsDG.TabIndex = 0;
            // 
            // fileNameSND
            // 
            this.fileNameSND.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fileNameSND.DataPropertyName = "fileData";
            this.fileNameSND.HeaderText = "File";
            this.fileNameSND.Name = "fileNameSND";
            // 
            // packageSND
            // 
            this.packageSND.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.packageSND.DataPropertyName = "packageData";
            this.packageSND.HeaderText = "Package";
            this.packageSND.Name = "packageSND";
            // 
            // assetSND
            // 
            this.assetSND.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.assetSND.DataPropertyName = "assetData";
            this.assetSND.HeaderText = "Asset Class";
            this.assetSND.Name = "assetSND";
            // 
            // fonts
            // 
            this.fonts.Controls.Add(this.fontsDG);
            this.fonts.Location = new System.Drawing.Point(4, 23);
            this.fonts.Name = "fonts";
            this.fonts.Size = new System.Drawing.Size(792, 323);
            this.fonts.TabIndex = 2;
            this.fonts.Text = "Fonts";
            this.fonts.UseVisualStyleBackColor = true;
            // 
            // fontsDG
            // 
            this.fontsDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.fontsDG.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.fileFNT,
            this.packageFNT,
            this.assetFNT,
            this.fontFamily,
            this.fontName,
            this.fontStyle,
            this.fontWeight,
            this.advancedAntiAliasing,
            this.flashType,
            this.fontGridFitType,
            this.fontSharpness,
            this.fontThickness,
            this.unicodeRange,
            this.cff});
            this.fontsDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.fontsDG.Location = new System.Drawing.Point(0, 0);
            this.fontsDG.Name = "fontsDG";
            this.fontsDG.Size = new System.Drawing.Size(792, 320);
            this.fontsDG.TabIndex = 1;
            // 
            // fileFNT
            // 
            this.fileFNT.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fileFNT.DataPropertyName = "fileData";
            this.fileFNT.HeaderText = "File";
            this.fileFNT.Name = "fileFNT";
            // 
            // packageFNT
            // 
            this.packageFNT.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.packageFNT.DataPropertyName = "packageData";
            this.packageFNT.HeaderText = "Package";
            this.packageFNT.Name = "packageFNT";
            // 
            // assetFNT
            // 
            this.assetFNT.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.assetFNT.DataPropertyName = "assetData";
            this.assetFNT.HeaderText = "Asset Class";
            this.assetFNT.Name = "assetFNT";
            // 
            // fontFamily
            // 
            this.fontFamily.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontFamily.DataPropertyName = "familyData";
            this.fontFamily.HeaderText = "Family";
            this.fontFamily.Name = "fontFamily";
            // 
            // fontName
            // 
            this.fontName.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontName.DataPropertyName = "nameData";
            this.fontName.HeaderText = "Name";
            this.fontName.Name = "fontName";
            // 
            // fontStyle
            // 
            this.fontStyle.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontStyle.DataPropertyName = "styleData";
            this.fontStyle.HeaderText = "Style";
            this.fontStyle.Name = "fontStyle";
            // 
            // fontWeight
            // 
            this.fontWeight.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontWeight.DataPropertyName = "weightData";
            this.fontWeight.HeaderText = "Weight";
            this.fontWeight.Name = "fontWeight";
            // 
            // advancedAntiAliasing
            // 
            this.advancedAntiAliasing.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.advancedAntiAliasing.DataPropertyName = "aliasingData";
            this.advancedAntiAliasing.HeaderText = "Advanced Antialiasing";
            this.advancedAntiAliasing.Name = "advancedAntiAliasing";
            // 
            // flashType
            // 
            this.flashType.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.flashType.DataPropertyName = "flashTypeData";
            this.flashType.HeaderText = "Flash Type";
            this.flashType.Name = "flashType";
            // 
            // fontGridFitType
            // 
            this.fontGridFitType.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontGridFitType.DataPropertyName = "gridFitTypeData";
            this.fontGridFitType.HeaderText = "Grid Fit Type";
            this.fontGridFitType.Name = "fontGridFitType";
            // 
            // fontSharpness
            // 
            this.fontSharpness.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontSharpness.DataPropertyName = "sharpnessData";
            this.fontSharpness.HeaderText = "Sharpness";
            this.fontSharpness.Name = "fontSharpness";
            // 
            // fontThickness
            // 
            this.fontThickness.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fontThickness.DataPropertyName = "thiknessData";
            this.fontThickness.HeaderText = "Thikness";
            this.fontThickness.Name = "fontThickness";
            // 
            // unicodeRange
            // 
            this.unicodeRange.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.unicodeRange.DataPropertyName = "unicodeRangeData";
            this.unicodeRange.HeaderText = "Unicode Range";
            this.unicodeRange.Name = "unicodeRange";
            // 
            // cff
            // 
            this.cff.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.cff.DataPropertyName = "sffData";
            this.cff.HeaderText = "CFF";
            this.cff.Name = "cff";
            // 
            // swf
            // 
            this.swf.Controls.Add(this.swfDG);
            this.swf.Location = new System.Drawing.Point(4, 23);
            this.swf.Name = "swf";
            this.swf.Size = new System.Drawing.Size(792, 323);
            this.swf.TabIndex = 3;
            this.swf.Text = "SWF";
            this.swf.UseVisualStyleBackColor = true;
            // 
            // swfDG
            // 
            this.swfDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.swfDG.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.fileSWF,
            this.symbol,
            this.packageSWF,
            this.assetSWF});
            this.swfDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.swfDG.Location = new System.Drawing.Point(0, 0);
            this.swfDG.Name = "swfDG";
            this.swfDG.Size = new System.Drawing.Size(792, 323);
            this.swfDG.TabIndex = 0;
            // 
            // fileSWF
            // 
            this.fileSWF.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fileSWF.DataPropertyName = "fileData";
            this.fileSWF.HeaderText = "File";
            this.fileSWF.Name = "fileSWF";
            // 
            // symbol
            // 
            this.symbol.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.symbol.DataPropertyName = "symbolData";
            this.symbol.HeaderText = "Symbol";
            this.symbol.Name = "symbol";
            // 
            // packageSWF
            // 
            this.packageSWF.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.packageSWF.DataPropertyName = "packageData";
            this.packageSWF.HeaderText = "Package";
            this.packageSWF.Name = "packageSWF";
            // 
            // assetSWF
            // 
            this.assetSWF.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.assetSWF.DataPropertyName = "assetData";
            this.assetSWF.HeaderText = "Asset Class";
            this.assetSWF.Name = "assetSWF";
            // 
            // svg
            // 
            this.svg.Controls.Add(this.svgDG);
            this.svg.Location = new System.Drawing.Point(4, 23);
            this.svg.Name = "svg";
            this.svg.Size = new System.Drawing.Size(792, 323);
            this.svg.TabIndex = 4;
            this.svg.Text = "SVG";
            this.svg.UseVisualStyleBackColor = true;
            // 
            // svgDG
            // 
            this.svgDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.svgDG.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.fileSVG,
            this.packageSVG,
            this.assetSVG});
            this.svgDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.svgDG.Location = new System.Drawing.Point(0, 0);
            this.svgDG.Name = "svgDG";
            this.svgDG.Size = new System.Drawing.Size(792, 320);
            this.svgDG.TabIndex = 0;
            // 
            // fileSVG
            // 
            this.fileSVG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fileSVG.HeaderText = "File";
            this.fileSVG.Name = "fileSVG";
            // 
            // packageSVG
            // 
            this.packageSVG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.packageSVG.HeaderText = "Package";
            this.packageSVG.Name = "packageSVG";
            // 
            // assetSVG
            // 
            this.assetSVG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.assetSVG.HeaderText = "Asset Class";
            this.assetSVG.Name = "assetSVG";
            // 
            // fxg
            // 
            this.fxg.Controls.Add(this.fxgDG);
            this.fxg.Location = new System.Drawing.Point(4, 23);
            this.fxg.Name = "fxg";
            this.fxg.Size = new System.Drawing.Size(792, 323);
            this.fxg.TabIndex = 5;
            this.fxg.Text = "FXG";
            this.fxg.UseVisualStyleBackColor = true;
            // 
            // fxgDG
            // 
            this.fxgDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.fxgDG.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.fileFXG,
            this.packageFXG,
            this.assetFXG});
            this.fxgDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.fxgDG.Location = new System.Drawing.Point(0, 0);
            this.fxgDG.Name = "fxgDG";
            this.fxgDG.Size = new System.Drawing.Size(792, 323);
            this.fxgDG.TabIndex = 0;
            // 
            // fileFXG
            // 
            this.fileFXG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fileFXG.DataPropertyName = "fileData";
            this.fileFXG.HeaderText = "File";
            this.fileFXG.Name = "fileFXG";
            // 
            // packageFXG
            // 
            this.packageFXG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.packageFXG.DataPropertyName = "packageData";
            this.packageFXG.HeaderText = "Package";
            this.packageFXG.Name = "packageFXG";
            // 
            // assetFXG
            // 
            this.assetFXG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.assetFXG.DataPropertyName = "assetData";
            this.assetFXG.HeaderText = "Asset Class";
            this.assetFXG.Name = "assetFXG";
            // 
            // txt
            // 
            this.txt.Controls.Add(this.stringsDG);
            this.txt.Location = new System.Drawing.Point(4, 23);
            this.txt.Name = "txt";
            this.txt.Size = new System.Drawing.Size(792, 323);
            this.txt.TabIndex = 6;
            this.txt.Text = "Strings";
            this.txt.UseVisualStyleBackColor = true;
            // 
            // stringsDG
            // 
            this.stringsDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.stringsDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.stringsDG.Location = new System.Drawing.Point(0, 0);
            this.stringsDG.Name = "stringsDG";
            this.stringsDG.Size = new System.Drawing.Size(792, 323);
            this.stringsDG.TabIndex = 0;
            // 
            // bin
            // 
            this.bin.Controls.Add(this.binaryDG);
            this.bin.Location = new System.Drawing.Point(4, 23);
            this.bin.Name = "bin";
            this.bin.Size = new System.Drawing.Size(792, 323);
            this.bin.TabIndex = 7;
            this.bin.Text = "Binary";
            this.bin.UseVisualStyleBackColor = true;
            // 
            // binaryDG
            // 
            this.binaryDG.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.binaryDG.Dock = System.Windows.Forms.DockStyle.Top;
            this.binaryDG.Location = new System.Drawing.Point(0, 0);
            this.binaryDG.Name = "binaryDG";
            this.binaryDG.Size = new System.Drawing.Size(792, 323);
            this.binaryDG.TabIndex = 0;
            // 
            // addFile
            // 
            this.addFile.Location = new System.Drawing.Point(13, 355);
            this.addFile.Name = "addFile";
            this.addFile.Size = new System.Drawing.Size(75, 23);
            this.addFile.TabIndex = 2;
            this.addFile.Text = "Add File";
            this.addFile.UseVisualStyleBackColor = true;
            // 
            // addFolder
            // 
            this.addFolder.Location = new System.Drawing.Point(13, 381);
            this.addFolder.Name = "addFolder";
            this.addFolder.Size = new System.Drawing.Size(75, 23);
            this.addFolder.TabIndex = 3;
            this.addFolder.Text = "Add Folder";
            this.addFolder.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(360, 386);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(52, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "File Mask";
            // 
            // fileMask
            // 
            this.fileMask.Location = new System.Drawing.Point(94, 383);
            this.fileMask.Name = "fileMask";
            this.fileMask.Size = new System.Drawing.Size(260, 20);
            this.fileMask.TabIndex = 5;
            // 
            // checkBox1
            // 
            this.checkBox1.AutoSize = true;
            this.checkBox1.Location = new System.Drawing.Point(419, 386);
            this.checkBox1.Name = "checkBox1";
            this.checkBox1.Size = new System.Drawing.Size(75, 17);
            this.checkBox1.TabIndex = 6;
            this.checkBox1.Text = "Recursive";
            this.checkBox1.UseVisualStyleBackColor = true;
            // 
            // fileIMG
            // 
            this.fileIMG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.fileIMG.DataPropertyName = "FileName";
            this.fileIMG.HeaderText = "File";
            this.fileIMG.Name = "fileIMG";
            // 
            // packageIMG
            // 
            this.packageIMG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.packageIMG.DataPropertyName = "PackageName";
            this.packageIMG.HeaderText = "Package";
            this.packageIMG.Name = "packageIMG";
            // 
            // assetIMG
            // 
            this.assetIMG.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.assetIMG.DataPropertyName = "ClassName";
            this.assetIMG.HeaderText = "Asset Class";
            this.assetIMG.Name = "assetIMG";
            // 
            // PluginUI
            // 
            this.Controls.Add(this.checkBox1);
            this.Controls.Add(this.fileMask);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.addFolder);
            this.Controls.Add(this.addFile);
            this.Controls.Add(this.navigator);
            this.Name = "PluginUI";
            this.Size = new System.Drawing.Size(800, 450);
            this.navigator.ResumeLayout(false);
            this.images.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.imagesDG)).EndInit();
            this.sounds.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.soundsDG)).EndInit();
            this.fonts.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.fontsDG)).EndInit();
            this.swf.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.swfDG)).EndInit();
            this.svg.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.svgDG)).EndInit();
            this.fxg.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.fxgDG)).EndInit();
            this.txt.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.stringsDG)).EndInit();
            this.bin.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.binaryDG)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

		}

		#endregion
				
 	}

}
