using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Data;
using ClosedXML.Excel;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.HSSF.Util;

namespace MyWebSite.Utility
{
    public class ExportUtility
    {
        private DataTable _data;
        private string _sheetName;
        private string _fileName;
        private string _extensionName;

        /// <summary>
        /// Constructor
        /// </summary>
        public ExportUtility()
        {
        }

        //public ExportUtility(DataTable dt, string sheetName, string fileName)
        //{
        //    Data = dt;
        //    SheetName = sheetName;
        //    FileName = fileName;
        //}

        public DataTable Data
        {
            get { return _data; }
            set { _data = value; }
        }

        public string SheetName
        {
            get { return _sheetName; }
            set { _sheetName = value; }
        }

        public string FileName
        {
            get { return _fileName; }
            set { _fileName = value; }
        }

        //public string FileName
        //{
        //    get { return _fileName; }
        //    set { _fileName = value; }
        //}

        #region CloseXML
        /// <summary>
        /// ClosedXML方式匯出.xlsx excel檔
        /// </summary>
        public void ExportExcel()
        {
            XLWorkbook workbook = DataTableToWorkbook(_data, _sheetName);
            MemoryStream memStream = WorkbookToStream(workbook);
            SteamToExcel(memStream, _fileName);
        }

        /// <summary>
        /// DataTable格式資料來源轉成ClosedXML的wookbook
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="sheetName"></param>
        /// <returns>workbook</returns>
        public XLWorkbook DataTableToWorkbook(DataTable dt, string sheetName)
        {
            using (XLWorkbook workbook = new XLWorkbook())
            {
                workbook.Worksheets.Add(dt, sheetName);
                return workbook;
            }
        }

        /// <summary>
        /// ClosedXML格式workbook轉成 Memory Stream
        /// </summary>
        /// <param name="workbook"></param>
        /// <returns>Memory Stream</returns>
        public MemoryStream WorkbookToStream(XLWorkbook workbook)
        {
            MemoryStream ms = new MemoryStream();
            workbook.SaveAs(ms);
            ms.Position = 0;
            return ms;
        }

        #endregion

        /// <summary>
        /// Memory Stream 存成Excel檔
        /// </summary>
        /// <param name="ms"></param>
        /// <param name="fileName"></param>
        public void SteamToExcel(MemoryStream ms, string fileName)
        {
            HttpResponse response = HttpContext.Current.Response;
            response.Clear();
            response.Buffer = true;
            response.AddHeader("content-disposition", "attachment; filename=" + fileName);
            //string extension = Path.GetExtension(fileName);
            if (_extensionName == "xlsx")
            {
                response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            }
            else if (_extensionName == "xls")
            {
                response.ContentType = "application/vnd.ms-excel";
            }
            response.BinaryWrite(ms.ToArray());
            ms.Close();
            ms.Dispose();
            response.End();
        }

        /// <summary>
        /// NPOI方式匯出.xlsx excel檔 
        /// </summary>
        /// <param name="ms"></param>
        /// <param name="filename"></param>
        public void ExportExcelNPOI()
        {
            //取得副檔名 xls or xlsx
            _extensionName = Path.GetExtension(_fileName).Replace(".","").ToLower();

            IWorkbook workbook = DataTableToWorkbookNPOI(_data, _sheetName);
            MemoryStream memStream = WorkbookToStreamNPOI(workbook);
            SteamToExcel(memStream, _fileName);
        }

        /// <summary>
        /// DataTable格式資料來源轉成NPOI的wookbook
        /// </summary>
        /// <param name="dt"></param>
        /// <param name="sheetName"></param>
        /// <returns>workbook</returns>
        public IWorkbook DataTableToWorkbookNPOI(DataTable dt, string sheetName)
        {
            //HSSFWorkbook workbook = new HSSFWorkbook();  // xls formate
            //XSSFWorkbook workbook = new XSSFWorkbook();  // xlsx formate

            IWorkbook workbook;
            if (_extensionName == "xlsx")
            {
                workbook = new XSSFWorkbook();       // => xlsx
            }
            else
            {
                workbook = new HSSFWorkbook();       // => xls
            }

            ISheet sheet = workbook.CreateSheet(sheetName);
            IRow headerRow = sheet.CreateRow(0);

            //設定 Header Style
            ICellStyle headerStyle = workbook.CreateCellStyle();
            headerStyle.Alignment = HorizontalAlignment.Left;
            headerStyle.VerticalAlignment = VerticalAlignment.Center;
            headerStyle.FillForegroundColor = HSSFColor.LightBlue.Index;
            headerStyle.FillPattern = FillPattern.SolidForeground;
            headerStyle.BorderTop = headerStyle.BorderLeft;
            headerStyle.BorderRight = BorderStyle.Thin;
            headerStyle.BorderBottom = BorderStyle.Thin;
            IFont headerFont = workbook.CreateFont();
            headerFont.Color = HSSFColor.White.Index;
            headerFont.Boldweight = 1;
            headerStyle.SetFont(headerFont);

            // handling header.
            foreach (DataColumn column in dt.Columns)
            {
                ICell headerCell = headerRow.CreateCell(column.Ordinal);
                headerCell.SetCellValue(column.ColumnName);
                headerCell.CellStyle = headerStyle;
                //headerCell.SetCellType(CellType.Numeric);
            }

            // handling value.
            int rowIndex = 1;

            foreach (DataRow row in dt.Rows)
            {
                IRow dataRow = sheet.CreateRow(rowIndex);

                foreach (DataColumn column in dt.Columns)
                {
                    ICell dataCell = dataRow.CreateCell(column.Ordinal);
                    //dataCell.SetCellValue(row[column].ToString());
                    SetCellValueAndType(dataCell, row[column], column);
                }

                rowIndex++;
            }

            return workbook;
        }

        /// <summary>
        /// NPOI格式workbook轉成 Memory Stream
        /// </summary>
        /// <param name="workbook"></param>
        /// <returns>Memory Stream</returns>
        public MemoryStream WorkbookToStreamNPOI(IWorkbook workbook)
        {
            MemoryStream ms = new MemoryStream();
            workbook.Write(ms);
            //ms.Position = 0;
            //ms.Flush();
            //ms.Seek(0, 0);

            return ms;
        }

        /// <summary>
        /// 設定欄位值與指定格式
        /// </summary>
        /// <param name="cell"></param>
        /// <param name="cellData"></param>
        /// <param name="item"></param>
        private void SetCellValueAndType(ICell cell, object cellData, DataColumn item)
        {
            CellType cellType = new CellType();

            switch (item.DataType.Name)
            {
                case "Decimal":
                    cellType = CellType.Numeric;
                    break;
                case "Double":
                    cellType = CellType.Numeric;
                    break;
                case "Int32":
                    cellType = CellType.Numeric;
                    break;
                case "Int64":
                    cellType = CellType.Numeric;
                    break;
                case "String":
                    cellType = CellType.String;
                    break;
                case "DateTime":
                    cellType = CellType.String;
                    break;
                case "Date":
                    cellType = CellType.String;
                    break;
                default:
                    cellType = CellType.String;
                    break;
            }

            cell.SetCellType(cellType);
            if (cellType == CellType.String)
            {
                cell.SetCellValue(cellData.ToString());
            }
            else if (cellType == CellType.Numeric)
            {
                if (cellData != DBNull.Value)
                {
                    cell.SetCellValue(Convert.ToDouble(cellData));
                }
                else
                {
                    cell.SetCellValue(string.Empty);
                }
            }
        }
    }
}