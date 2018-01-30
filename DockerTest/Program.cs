using jsreport.Local;
using jsreport.Types;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace DockerTest
{
    class Program
    {
        static void Main(string[] args)
        {
            var rs = new LocalReporting()
               .UseBinary(RuntimeInformation.IsOSPlatform(OSPlatform.Windows) ?
                   jsreport.Binary.JsReportBinary.GetBinary() :
                   jsreport.Binary.Linux.JsReportBinary.GetBinary())
               .AsUtility()
               .Create();

            var report = rs.RenderAsync(new RenderRequest()
            {
                Template = new Template()
                {
                    Recipe = Recipe.Html,
                    Engine = Engine.None,
                    Content = "Hello"
                }
            }).Result;

            Console.WriteLine(new StreamReader(report.Content).ReadToEnd());
        }
    }
}
