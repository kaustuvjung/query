using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Helper
{
   public static class Extension
    {



    }
   
   public class DbResponse
    {
        public string Message { get; set; }
        public bool HasError { get; set; }
        public object Response { get; set; }
        public string Key { get; set; }
    }
}
