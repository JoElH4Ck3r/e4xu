using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Collections;
using System.Diagnostics;

namespace NFXContext.TemplateShell
{
    class NFXShell
    {
        protected static StringBuilder output = null;

        public static String Run(FileInfo template, String preprocessor, String jdk, Hashtable args)
        {
            //String inputText = "";
            if (String.IsNullOrEmpty(jdk)) jdk = "java.exe";
            Process proc = new Process();
            proc.EnableRaisingEvents = false;
            proc.StartInfo.UseShellExecute = false;
            proc.StartInfo.RedirectStandardOutput = true;
            proc.StartInfo.RedirectStandardInput = true;
            proc.StartInfo.RedirectStandardError = true;
            proc.StartInfo.StandardOutputEncoding = Encoding.Default;
            proc.StartInfo.StandardErrorEncoding = Encoding.Default;
            proc.StartInfo.CreateNoWindow = true;
            proc.StartInfo.FileName = @jdk;
            proc.StartInfo.WorkingDirectory = template.Directory.FullName;
            //
            //proc.StartInfo.Arguments = jvmarg;
            //
            output = new StringBuilder("");
            if (args != null)
            {
                proc.StartInfo.Arguments = "-jar " + @preprocessor + @formatArguments(args);
            }
            else
            {
                proc.StartInfo.FileName = "-jar " + @preprocessor;
            }

            Console.WriteLine("Running: " + proc.StartInfo.FileName);
            try
            {
                proc.Start();
                while (!proc.StandardOutput.EndOfStream)
                {
                    PluginCore.Managers.TraceManager.Add(
                        proc.StandardOutput.ReadLine().Trim(),
                        (Int32)PluginCore.TraceType.Info);
                }
                while (!proc.StandardError.EndOfStream)
                {
                    String line = proc.StandardError.ReadLine().Trim();
                    PluginCore.Managers.TraceManager.Add(
                        proc.StandardError.ReadLine().Trim(),
                        (Int32)PluginCore.TraceType.Error);
                }
                proc.Close();
                return output.ToString();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                proc.Close();
                return ex.Message;
            }
        }

        static String formatArguments(Hashtable args)
        {
            StringBuilder sb = new StringBuilder();
            IDictionaryEnumerator id = args.GetEnumerator();
            while (id.MoveNext())
            {
                sb.Append(' ');
                sb.Append(id.Key);
                sb.Append('=' + (String)id.Value);
            }
            return sb.ToString();
        }
    }
}