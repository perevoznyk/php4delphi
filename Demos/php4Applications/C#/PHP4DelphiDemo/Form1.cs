using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Text;
using System.Data;
using System.Runtime.InteropServices;



namespace PHP4DelphiDemo
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.TextBox textBox1;
		private System.Windows.Forms.Button button1;
		private System.Windows.Forms.OpenFileDialog openFileDialog1;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
		{
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.textBox1 = new System.Windows.Forms.TextBox();
			this.button1 = new System.Windows.Forms.Button();
			this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
			this.SuspendLayout();
			// 
			// textBox1
			// 
			this.textBox1.Location = new System.Drawing.Point(8, 16);
			this.textBox1.Multiline = true;
			this.textBox1.Name = "textBox1";
			this.textBox1.ScrollBars = System.Windows.Forms.ScrollBars.Both;
			this.textBox1.Size = new System.Drawing.Size(272, 176);
			this.textBox1.TabIndex = 0;
			this.textBox1.Text = "";
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(208, 200);
			this.button1.Name = "button1";
			this.button1.TabIndex = 1;
			this.button1.Text = "Execute";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// openFileDialog1
			// 
			this.openFileDialog1.Filter = "PHP files|*.php";
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 229);
			this.Controls.AddRange(new System.Windows.Forms.Control[] {
																		  this.button1,
																		  this.textBox1});
			this.Name = "Form1";
			this.Text = "PHP";
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void button1_Click(object sender, System.EventArgs e)
		{
			int l = 0;
			int RequestID = 0;
			StringBuilder builder = new  StringBuilder();

			if(openFileDialog1.ShowDialog() == DialogResult.OK)
			{
				RequestID = InitRequest();
				string fn = openFileDialog1.FileName;
				ExecutePHP(RequestID, fn);
				l = GetResultText(RequestID, builder, 0);
				builder.Capacity = l;
				l = GetResultText(RequestID, builder, builder.Capacity + 1);
				textBox1.Text = builder.ToString();
				DoneRequest(RequestID);
			}

			
		}

		
		[DllImport("PHP4App.dll")]
		public static extern int InitRequest();
		
		/// <summary>
		/// Execute PHP script
		/// </summary>
		[DllImport("PHP4App.dll")]
		public static extern int ExecutePHP(int RequestID, string FileName);

		
		[DllImport("PHP4App.dll", SetLastError=true)]
		public static extern void DoneRequest(int RequestID);

		[DllImport("PHP4App.dll", SetLastError=true)]
		public static extern int GetResultText(int RequestID, StringBuilder Buf, int BufLen);

		
	}
}
