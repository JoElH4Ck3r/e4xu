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
        public static void Run(FileInfo template, String preprocessor, String jdk, Hashtable args)
        {
            //String inputText = "";
            if (String.IsNullOrEmpty(jdk)) jdk = "java.exe";
            Boolean wasError = false;
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
            String ppcArgs = "";
            if (args != null)
            {
                ppcArgs = "-jar " + @preprocessor + @formatArguments(args);
            }
            else
            {
                ppcArgs = "-jar " + @preprocessor;
            }
            proc.StartInfo.Arguments = ppcArgs;
            PluginCore.Managers.TraceManager.Add(
                "Running: " + proc.StartInfo.FileName + " " + ppcArgs, 
                (Int32)PluginCore.TraceType.ProcessStart);
            try
            {
                // TODO: Have to switch to ProcessHelper.StartAsync()
                proc.Start();
                Console.WriteLine("proc.StandardOutput.EndOfStream " + proc.StandardOutput.EndOfStream);
                while (!proc.StandardOutput.EndOfStream)
                {
                    PluginCore.Managers.TraceManager.AddAsync(
                        proc.StandardOutput.ReadLine().Trim(),
                        (Int32)PluginCore.TraceType.Info);
                }
                while (!proc.StandardError.EndOfStream)
                {
                    wasError = true;
                    PluginCore.Managers.TraceManager.AddAsync(
                        proc.StandardError.ReadLine().Trim(),
                        (Int32)PluginCore.TraceType.ProcessError);
                }
                if (wasError)
                {
                    PluginCore.Managers.TraceManager.AddAsync(
                        "Exit code: " + proc.ExitCode,
                        (Int32)PluginCore.TraceType.ProcessEnd);
                }
                proc.Close();
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                proc.Close();
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
