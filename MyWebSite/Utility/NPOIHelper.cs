//Created By：Ares Jerry
//Created Date：2013/07/15

using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI.HtmlControls;
using NPOI;
using NPOI.HPSF;
using NPOI.HSSF;
using NPOI.HSSF.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.POIFS;
using NPOI.Util;
using NPOI.HSSF.Util;
using NPOI.HSSF.Extractor;
using NPOI.SS.UserModel;
using NPOI.OpenXml4Net.OPC;
using NPOI.POIFS.FileSystem;
using NPOI.SS.Util;

namespace MyWebSite.Utility
{
    /// <summary>
    /// 使用NPOI元件來Import、Export的共用Function
    /// </summary>
    public class NPOIHelper
    {
        #region 位元流(stream)應用及與workbook轉換
        /// <summary>
        /// Write Steam To File
        /// </summary>
        /// <param name="ms">stream</param>
        /// <param name="fileName">file name</param>
        public static void WriteSteamToFile(MemoryStream ms, string fileName)
        {
            FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.Write);
            byte[] data = ms.ToArray();

            fs.Write(data, 0, data.Length);
            fs.Flush();
            fs.Close();

            data = null;
            fs = null;
        }

        /// <summary>
        /// Write Byte array to file
        /// </summary>
        /// <param name="data">byte array</param>
        /// <param name="fileName">file name</param>
        public static void WriteSteamToFile(byte[] data, string fileName)
        {
            FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.Write);
            fs.Write(data, 0, data.Length);
            fs.Flush();
            fs.Close();
            fs = null;
        }

        /// <summary>
        /// Transfer workbook to stream
        /// </summary>
        /// <param name="inputWorkBook">workbook</param>
        /// <returns>stream</returns>
        public static Stream WorkBookToStream(IWorkbook inputWorkBook)
        {
            MemoryStream ms = new MemoryStream();
            inputWorkBook.Write(ms);
            ms.Flush();
            ms.Position = 0;
            return ms;
        }

        /// <summary>
        /// transfer stream to workbook
        /// </summary>
        /// <param name="inputStream">stream</param>
        /// <returns>workbook</returns>
        public static IWorkbook StreamToWorkBook(Stream inputStream)
        {
            IWorkbook workBook = WorkbookFactory.Create(inputStream);
            return workBook;
        }

        /// <summary>
        /// transfer memory stream to workbook
        /// </summary>
        /// <param name="inputStream">memory stream</param>
        /// <returns>workbook</returns>
        public static IWorkbook MemoryStreamToWorkBook(MemoryStream inputStream)
        {
            IWorkbook workBook = WorkbookFactory.Create(inputStream as Stream);
            return workBook;
        }

        /// <summary>
        /// transfer workbook to memory stream
        /// </summary>
        /// <param name="inputStream">workbook</param>
        /// <returns>memmory stream</returns>
        public static MemoryStream WorkBookToMemoryStream(HSSFWorkbook inputStream)
        {
            //Write the stream data of workbook to the root directory
            MemoryStream file = new MemoryStream();
            inputStream.Write(file);
            return file;
        }

        /// <summary>
        /// transfer file to stream
        /// </summary>
        /// <param name="fileName">filename</param>
        /// <returns>stream</returns>
        public static Stream FileToStream(string fileName)
        {
            FileInfo fi = new FileInfo(fileName);
            if (fi.Exists == true)
            {
                FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                return fs;
            }
            else return null;
        }

        /// <summary>
        /// transfer memory stream to stream
        /// </summary>
        /// <param name="ms"></param>
        /// <returns></returns>
        public static Stream MemoryStreamToStream(MemoryStream ms)
        {
            return ms as Stream;
        }

        /// <summary>
        /// transfer file to workbook
        /// </summary>
        /// <param name="fileName">filename</param>
        /// <returns>workbook</returns>
        public static HSSFWorkbook FileToWorkBook(string fileName)
        {
            FileInfo fi = new FileInfo(fileName);
            HSSFWorkbook workBook = null;

            if (fi.Exists == true)
            {
                FileStream fs = new FileStream(fileName, FileMode.Open, FileAccess.Read);
                workBook = new HSSFWorkbook(fs);
            }

            return workBook;

        }
        #endregion

        #region DataTable與Excel資料格式轉換
        /// <summary>
        /// render datatable to workbook stream
        /// </summary>
        /// <param name="sourceTable">datatable</param>
        /// <returns>workbook stream</returns>
        public static Stream RenderDataTableToExcel(DataTable sourceTable)
        {
            HSSFWorkbook workbook = new HSSFWorkbook();
            MemoryStream ms = new MemoryStream();
            HSSFSheet sheet = (HSSFSheet)workbook.CreateSheet();
            HSSFRow headerRow = (HSSFRow)sheet.CreateRow(0);

            //設定 Header Style
            HSSFCellStyle headerStyle = (HSSFCellStyle)workbook.CreateCellStyle();
            headerStyle.Alignment = NPOI.SS.UserModel.HorizontalAlignment.Center;
            headerStyle.VerticalAlignment = NPOI.SS.UserModel.VerticalAlignment.Center;
            headerStyle.FillForegroundColor = NPOI.HSSF.Util.HSSFColor.LightBlue.Index;
            headerStyle.FillPattern = NPOI.SS.UserModel.FillPattern.SolidForeground;
            headerStyle.BorderTop = headerStyle.BorderLeft;
            headerStyle.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
            headerStyle.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
            HSSFFont headerFont = (HSSFFont)workbook.CreateFont();
            headerFont.Color = HSSFColor.White.Index;
            headerFont.Boldweight = 1;
            headerStyle.SetFont(headerFont);

            // handling header.
            for (int i = 0; i < sourceTable.Columns.Count; i++)
            {
                DataColumn column = sourceTable.Columns[i];
                NPOI.SS.UserModel.ICell headerCell = headerRow.CreateCell(column.Ordinal);
                headerCell.SetCellValue(column.ColumnName);
                headerCell.CellStyle = headerStyle;
            }

            // handling value.
            int rowIndex = 1;

            foreach (DataRow row in sourceTable.Rows)
            {
                HSSFRow dataRow = (HSSFRow)sheet.CreateRow(rowIndex);

                foreach (DataColumn column in sourceTable.Columns)
                {
                    dataRow.CreateCell(column.Ordinal).SetCellValue(row[column].ToString());
                }

                rowIndex++;
            }

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;

            sheet = null;
            headerRow = null;
            workbook = null;

            return ms;
        }

        /// <summary>
        /// render datatable to excel file
        /// </summary>
        /// <param name="sourceTable">datatable</param>
        /// <param name="fileName">filename</param>
        public static void RenderDataTableToExcel(DataTable sourceTable, string fileName)
        {
            MemoryStream ms = RenderDataTableToExcel(sourceTable) as MemoryStream;
            FileStream fs = new FileStream(fileName, FileMode.Create, FileAccess.Write);
            byte[] data = ms.ToArray();

            fs.Write(data, 0, data.Length);
            fs.Flush();
            fs.Close();

            data = null;
            ms = null;
            fs = null;
        }

        /// <summary>
        /// 將多個DataTable寫入ExcelFile並以Stream輸出.
        /// </summary>
        /// <param name="templateFileName">範本檔檔名</param>
        /// <param name="sourceTables">source table.</param>
        /// <param name="startRows">指定由範本檔第幾列開始附加資料</param>
        /// <returns></returns>
        public static Stream RenderDataTableToExcelSheet(string templateFileName, DataTable[] sourceTables, int[] startRows)
        {
            HSSFWorkbook workbook = FileToWorkBook(templateFileName); ;
            MemoryStream ms = new MemoryStream(); ;
            HSSFSheet sheet = null;

            for (int idx = 0; idx < sourceTables.Length; idx++)
            {
                sheet = (HSSFSheet)workbook.GetSheetAt(idx);
                DataTable sourceTable = sourceTables[idx];

                HSSFCellStyle cellStyle = (HSSFCellStyle)workbook.CreateCellStyle();
                cellStyle.Alignment = NPOI.SS.UserModel.HorizontalAlignment.Left;
                cellStyle.VerticalAlignment = NPOI.SS.UserModel.VerticalAlignment.Center;
                cellStyle.BorderTop = cellStyle.BorderLeft;
                cellStyle.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
                cellStyle.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
                cellStyle.WrapText = true;

                // handling value.
                int rowIndex = startRows[idx];

                foreach (DataRow row in sourceTable.Rows)
                {
                    HSSFRow dataRow = (HSSFRow)sheet.CreateRow(rowIndex);

                    foreach (DataColumn column in sourceTable.Columns)
                    {
                        NPOI.SS.UserModel.ICell cell = dataRow.CreateCell(column.Ordinal);
                        cell.SetCellValue(row[column].ToString());
                        cell.CellStyle = cellStyle;
                    }

                    rowIndex++;
                }

                sheet = null;
            }

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;
            workbook = null;

            return ms;
        }

        /// <summary>
        /// MLR將DataTable轉成Stream輸出.
        /// </summary>
        /// <param name="sourceTable">The source table.</param>
        /// <param name="templateFileName">範本檔檔名</param>
        /// <param name="startRows">指定由範本檔第幾列開始附加資料</param>
        /// <param name="tableId">MLR TableID</param>
        /// <returns></returns>
        public static Stream RenderDataTableToExcelForMLR(DataTable sourceTable, string templateFileName, int startRows, string tableId)
        {
            HSSFWorkbook workbook = FileToWorkBook(templateFileName);
            MemoryStream ms = new MemoryStream();
            HSSFSheet sheet = (HSSFSheet)workbook.GetSheetAt(0);

            HSSFCellStyle cellStyle = (HSSFCellStyle)workbook.CreateCellStyle();
            cellStyle.BorderTop = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle.BorderLeft = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle.BorderRight = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle.BorderBottom = NPOI.SS.UserModel.BorderStyle.Thin;
            cellStyle.WrapText = true;

            //Setting TableId
            HSSFRow fRow = (HSSFRow)sheet.CreateRow(0);
            NPOI.SS.UserModel.ICell firstCell = fRow.CreateCell(0);
            firstCell.SetCellValue(tableId);
            firstCell.CellStyle = cellStyle;

            // handling value.
            int rowIndex = startRows;

            foreach (DataRow row in sourceTable.Rows)
            {
                HSSFRow dataRow = (HSSFRow)sheet.CreateRow(rowIndex);

                foreach (DataColumn column in sourceTable.Columns)
                {
                    NPOI.SS.UserModel.ICell cell = dataRow.CreateCell(column.Ordinal);
                    cell.SetCellValue(row[column].ToString());
                    cell.CellStyle = cellStyle;
                }

                rowIndex++;
            }

            ISheet sheet1 = (ISheet)workbook.GetSheetAt(0);

            List<string> merged = new List<string>();
            for (int i = 0; i < sourceTable.Rows.Count; i++)
            {
                string seq = sourceTable.Rows[i]["MASK_TOOLING_SEQUENCE"].ToString();
                var query = sourceTable.Select(string.Format("MASK_TOOLING_SEQUENCE = '{0}'", seq));
                int count = query.Count();
                if (count > 1)
                {
                    if (!merged.Contains(seq))
                    {
                        merged.Add(seq);
                        int firstRow = startRows + i;
                        int lastRow = startRows + i + count - 1;
                        sheet1.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(firstRow, lastRow, 0, 0));
                        sheet1.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(firstRow, lastRow, 3, 3));
                        sheet1.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(firstRow, lastRow, 8, 8));
                    }
                }
            }

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;

            sheet = null;
            workbook = null;

            return ms;
        }

        /// <summary>
        /// 將DataTable轉成Stream輸出.
        /// </summary>
        /// <param name="sourceTable">The source table.</param>
        /// <param name="templateFileName">範本檔檔名</param>
        /// <param name="startRows">指定由範本檔第幾列開始附加資料</param>
        /// <returns></returns>
        public static Stream RenderDataTableToExcel(DataTable sourceTable, string templateFileName, int startRows)
        {
            HSSFWorkbook workbook = FileToWorkBook(templateFileName);
            MemoryStream ms = new MemoryStream();
            HSSFSheet sheet = (HSSFSheet)workbook.GetSheetAt(0);

            HSSFCellStyle cellStyle = (HSSFCellStyle)workbook.CreateCellStyle();
            cellStyle.Alignment = NPOI.SS.UserModel.HorizontalAlignment.Left;
            cellStyle.VerticalAlignment = NPOI.SS.UserModel.VerticalAlignment.Center;
            cellStyle.WrapText = true;

            // handling value.
            int rowIndex = startRows;

            foreach (DataRow row in sourceTable.Rows)
            {
                HSSFRow dataRow = (HSSFRow)sheet.CreateRow(rowIndex);

                foreach (DataColumn column in sourceTable.Columns)
                {
                    NPOI.SS.UserModel.ICell cell = dataRow.CreateCell(column.Ordinal);
                    cell.SetCellValue(row[column].ToString());
                    cell.CellStyle = cellStyle;
                }

                rowIndex++;
            }

            workbook.Write(ms);
            ms.Flush();
            ms.Position = 0;

            sheet = null;
            workbook = null;

            return ms;
        }
        /// <summary>
        /// 將DataTable轉成Workbook(自定資料型態)輸出.
        /// </summary>
        /// <param name="sourceTable">The source table.</param>
        /// <returns></returns>
        public static HSSFWorkbook RenderDataTableToWorkBook(DataTable sourceTable)
        {
            HSSFWorkbook workbook = new HSSFWorkbook();
            MemoryStream ms = new MemoryStream();
            HSSFSheet sheet = (HSSFSheet)workbook.CreateSheet();
            HSSFRow headerRow = (HSSFRow)sheet.CreateRow(0);

            // handling header.
            foreach (DataColumn column in sourceTable.Columns)
                headerRow.CreateCell(column.Ordinal).SetCellValue(column.ColumnName);

            // handling value.
            int rowIndex = 1;

            foreach (DataRow row in sourceTable.Rows)
            {
                HSSFRow dataRow = (HSSFRow)sheet.CreateRow(rowIndex);

                foreach (DataColumn column in sourceTable.Columns)
                {
                    dataRow.CreateCell(column.Ordinal).SetCellValue(row[column].ToString());
                }

                rowIndex++;
            }
            return workbook;
        }

        /// <summary>
        /// 將DataTable資料輸出成檔案.
        /// </summary>
        /// <param name="sourceTable">The source table.</param>
        /// <param name="templateFileName">範本檔檔名</param>
        /// <param name="startRows">指定由範本檔第幾列開始附加資料</param>
        /// <param name="exportFileName">輸出檔案名稱</param>
        public static void RenderDataTableToExcel(DataTable sourceTable, string templateFileName, int startRows, string exportFileName)
        {
            MemoryStream ms = RenderDataTableToExcel(sourceTable, templateFileName, startRows) as MemoryStream;
            WriteSteamToFile(ms, exportFileName);
        }

        /// <summary>
        /// 從位元流讀取資料到DataTable.
        /// </summary>
        /// <param name="excelFileStream">The excel file stream.</param>
        /// <param name="sheetName">Name of the sheet.</param>
        /// <param name="headerRowIndex">Index of the header row.</param>
        /// <param name="dataStartRows">Index of the data start row</param>
        /// <param name="haveHeader">if set to <c>true</c> [have header].</param>
        /// <returns></returns>
        public static DataTable RenderDataTableFromExcel(Stream excelFileStream, string sheetName, int headerRowIndex, int dataStartRows, bool haveHeader)
        {
            IWorkbook workbook = WorkbookFactory.Create(excelFileStream);
            ISheet sheet = (ISheet)workbook.GetSheet(sheetName);

            DataTable table = new DataTable();

            IRow headerRow = (IRow)sheet.GetRow(headerRowIndex);
            int cellCount = headerRow.LastCellNum;

            for (int i = headerRow.FirstCellNum; i < cellCount; i++)
            {
                string columnName = (haveHeader == true) ? headerRow.GetCell(i).StringCellValue : "f" + i.ToString();
                DataColumn column = new DataColumn(columnName);
                table.Columns.Add(column);
            }

            int rowCount = sheet.LastRowNum;
            int rowStart = dataStartRows;
            for (int i = rowStart; i <= sheet.LastRowNum; i++)
            {
                IRow row = (IRow)sheet.GetRow(i);

                if (row != null)
                {
                    DataRow dataRow = table.NewRow();
                    for (int j = row.FirstCellNum; j < cellCount; j++)
                    {
                        dataRow[j] = row.GetCell(j).ToString();
                    }
                }
            }

            excelFileStream.Close();
            workbook = null;
            sheet = null;
            return table;
        }

        /// <summary>
        /// 從位元流讀取資料到DataTable.
        /// </summary>
        /// <param name="excelFileStream">The excel file stream.</param>
        /// <param name="sheetIndex">Index of the sheet.</param>
        /// <param name="headerRowIndex">Index of the header row.</param>
        /// <param name="dataStartRows">Index of the data start row</param>
        /// <param name="haveHeader">if set to <c>true</c> [have header].</param>
        /// <returns></returns>
        public static DataTable RenderDataTableFromExcel(Stream excelFileStream, int sheetIndex, int headerRowIndex, int dataStartRows, bool haveHeader)
        {
            IWorkbook workbook = WorkbookFactory.Create(excelFileStream);
            ISheet sheet = (ISheet)workbook.GetSheetAt(sheetIndex);

            DataTable table = new DataTable();

            IRow headerRow = (IRow)sheet.GetRow(headerRowIndex);
            int cellCount = headerRow.LastCellNum;

            for (int i = headerRow.FirstCellNum; i < cellCount; i++)
            {
                string columnName = (haveHeader == true) ? headerRow.GetCell(i).StringCellValue : "f" + i.ToString();
                DataColumn column = new DataColumn(columnName);
                table.Columns.Add(column);
            }

            int rowCount = sheet.LastRowNum;
            int rowStart = dataStartRows;
            for (int i = rowStart; i <= sheet.LastRowNum; i++)
            {
                IRow row = (IRow)sheet.GetRow(i);

                if (row != null)
                {
                    DataRow dataRow = table.NewRow();
                    for (int j = row.FirstCellNum; j < cellCount; j++)
                    {
                        if (row.GetCell(j) != null)
                        {
                            dataRow[j] = row.GetCell(j).ToString();
                        }
                    }
                    if (dataRow[row.FirstCellNum].ToString().Trim() != string.Empty)
                    {
                        table.Rows.Add(dataRow);
                    }
                }
            }

            excelFileStream.Close();
            workbook = null;
            sheet = null;
            return table;
        }
        #endregion

        #region 合併儲存格

        /// <summary>
        /// 合併儲存格於位元流.
        /// </summary>
        /// <param name="inputStream">The input stream.</param>
        /// <param name="sheetIndex">Index of the sheet.</param>
        /// <param name="rowFrom">The row from.</param>
        /// <param name="columnFrom">The column from.</param>
        /// <param name="rowTo">The row to.</param>
        /// <param name="columnTo">The column to.</param>
        /// <returns></returns>
        public static Stream MergeCell(Stream inputStream, int sheetIndex, int rowFrom, int columnFrom, int rowTo, int columnTo)
        {
            IWorkbook workbook = WorkbookFactory.Create(inputStream);
            MemoryStream ms = new MemoryStream();
            ISheet sheet1 = (ISheet)workbook.GetSheetAt(sheetIndex);
            sheet1.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(rowFrom, columnFrom, rowTo, columnTo));
            workbook.Write(ms);
            ms.Flush();
            return ms;
        }
        /// <summary>
        /// 合併儲存格於檔案.
        /// </summary>
        /// <param name="fileName">Name of the file.</param>
        /// <param name="inputStream">The input stream.</param>
        /// <param name="sheetIndex">Index of the sheet.</param>
        /// <param name="rowFrom">The row from.</param>
        /// <param name="columnFrom">The column from.</param>
        /// <param name="rowTo">The row to.</param>
        /// <param name="columnTo">The column to.</param>
        public static void MergeCell(string fileName, Stream inputStream, int sheetIndex, int rowFrom, int columnFrom, int rowTo, int columnTo)
        {
            MemoryStream ms = MergeCell(inputStream, sheetIndex, rowFrom, columnFrom, rowTo, columnTo) as MemoryStream;
            WriteSteamToFile(ms, fileName);
        }

        /// <summary>
        /// 建立新位元流並合併儲存格.
        /// </summary>
        /// <param name="rowFrom">The row from.</param>
        /// <param name="columnFrom">The column from.</param>
        /// <param name="rowTo">The row to.</param>
        /// <param name="columnTo">The column to.</param>
        /// <returns></returns>
        public static Stream MergeCell(int rowFrom, int columnFrom, int rowTo, int columnTo)
        {
            IWorkbook workbook = new HSSFWorkbook();
            MemoryStream ms = new MemoryStream();
            ISheet sheet1 = (ISheet)workbook.CreateSheet();
            sheet1.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(rowFrom, columnFrom, rowTo, columnTo));
            workbook.Write(ms);
            ms.Flush();
            return ms;
        }

        /// <summary>
        /// 建立新檔案並合併儲存格.
        /// </summary>
        /// <param name="fileName">Name of the file.</param>
        /// <param name="rowFrom">The row from.</param>
        /// <param name="columnFrom">The column from.</param>
        /// <param name="rowTo">The row to.</param>
        /// <param name="columnTo">The column to.</param>
        public static void MergeCell(string fileName, int rowFrom, int columnFrom, int rowTo, int columnTo)
        {
            MemoryStream ms = MergeCell(rowFrom, columnFrom, rowTo, columnTo) as MemoryStream;
            WriteSteamToFile(ms, fileName);
        }
        #endregion

        /// <summary>
        /// 依檔案格式判斷Office版本，以決定使用的NPOI物件
        /// </summary>
        internal class WorkbookFactory
        {
            /// <summary>
            /// Factory for creating the appropriate kind of Workbook (be it HSSFWorkbook or XSSFWorkbook), from the given input Creates an HSSFWorkbook from the given POIFSFileSystem
            /// </summary>
            /// <param name="fs"></param>
            /// <returns></returns>      
            public static IWorkbook Create(POIFSFileSystem fs)
            {
                return new HSSFWorkbook(fs);
            }

            /// <summary>
            /// Creates an XSSFWorkbook from the given OOXML Package
            /// </summary>
            /// <param name="pkg"></param>
            /// <returns></returns>
            public static IWorkbook Create(OPCPackage pkg)
            {
                return new XSSFWorkbook(pkg);
            }

            /// <summary>
            /// Creates the appropriate HSSFWorkbook / XSSFWorkbook from the given InputStream. The Stream is wraped inside a PushbackInputStream.
            /// </summary>
            /// <param name="inp"></param>
            /// <returns></returns>
            public static IWorkbook Create(Stream inp)
            {
                Stream s = new PushbackStream(inp);
                if (POIFSFileSystem.HasPOIFSHeader(s))
                {
                    return new HSSFWorkbook(s);
                }
                s.Position = 0;
                if (POIXMLDocument.HasOOXMLHeader(s))
                {
                    return new XSSFWorkbook(OPCPackage.Open(s));
                }
                throw new ArgumentException("Your InputStream was neither an OLE2 stream, nor an OOXML stream.");
            }
        }
    }
}