using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IncentiveCalcPOC.Entities
{
    public class FileDetails
    {
        public string FileType { get; set; }
        public string FileTypeDesc { get; set; }
    }

    public class UploadDetails
    {
        public Int64 FileId { get; set; }
        public string FileName { get; set; }
        public string FileType { get; set; }
        public string DateCreated { get; set; }
        public bool IsProcessed { get; set; }
        public string ProcessedTime { get; set; }
       // public int Status { get; set; }
        public string StatusDesc { get; set; }

    }
}