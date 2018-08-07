using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Data.OracleClient;
using System.Configuration;

namespace MyWebSite.Utility
{
    /// <summary>
    /// 共用的資料庫存取功能
    /// </summary>
    public class DBHelper : IDisposable
    {
        /// <summary>
        /// DBHelper - 預設建構子
        /// </summary>
        public DBHelper()
        {

        }

        /// <summary>
        /// Determines the correct provider to use and sets up the connection and command
        /// objects for use in other methods
        /// </summary>
        /// <param name="connectString">The full connection string to the database</param>
        /// <param name="providerList">The enum value of providers from dbutilities.Providers</param>
        public DBHelper(string connectString, Provider providerList)
        {
            switch (providerList)
            {
                case Provider.SqlServer:
                    _factory = SqlClientFactory.Instance;
                    break;
                case Provider.Oracle:
                    _factory = OracleClientFactory.Instance;
                    break;
                default:
                    break;
            }

            _connection = _factory.CreateConnection();
            _command = _factory.CreateCommand();

            _connection.ConnectionString = connectString;
            _command.Connection = Connection;

            _command.CommandTimeout = 120;
        }

        /// <summary>
        /// 取得連線資料庫的DBHelper
        /// </summary>
        /// <param name="dbName">連線資料庫</param>
        /// <returns>DBHelper</returns>
        public static DBHelper GetDB(string dbName)
        {
            DBHelper db = null;

            switch (dbName)
            {
                case "RetailSQLServer":
                    db = GetDBHelper("RetailConnectionString", Provider.SqlServer);
                    break;
                case "EddieDBSQLServer":
                    db = GetDBHelper("EddieDBConnectionString", Provider.SqlServer);
                    break;
                case "Oracle":
                    db = GetDBHelper("UMask_ConnStr", Provider.Oracle);
                    break;
            }

            return db;
        }

        /// <summary>
        /// 取得DBHelper物件
        /// </summary>
        /// <param name="configKeyName">ConnectionString定義的KeyName</param>
        /// <param name="provider">資料庫類型</param>
        /// <returns>DBHelper</returns>
        private static DBHelper GetDBHelper(string configKeyName, Provider provider)
        {
            string connStr = ConfigurationManager.AppSettings[configKeyName].ToString();
            DBHelper db = new DBHelper(connStr, provider);
            return db;
        }

        #region private members
        private string _connectionstring = "";
        private DbConnection _connection;
        private DbCommand _command;
        private DbProviderFactory _factory = null;
        #endregion

        #region properties

        /// <summary>
        /// Gets or Sets the connection string for the database
        /// </summary>
        public string Connectionstring
        {
            get
            {
                return _connectionstring;
            }
            set
            {
                if (value != "")
                {
                    _connectionstring = value;
                }
            }
        }

        /// <summary>
        /// Gets the connection object for the database
        /// </summary>
        public DbConnection Connection
        {
            get
            {
                return _connection;
            }
        }

        /// <summary>
        /// Gets the command object for the database
        /// </summary>
        public DbCommand Command
        {
            get
            {
                return _command;
            }
        }

        #endregion

        # region methods

        #region parameters

        /// <summary>
        /// Creates a parameter and adds it to the command object
        /// </summary>
        /// <param name="name">The parameter name</param>
        /// <param name="value">The paremeter value</param>
        /// <returns></returns>
        public int AddParameter(string name, object value)
        {
            DbParameter parm = _factory.CreateParameter();
            parm.ParameterName = name;
            parm.Value = value;
            return Command.Parameters.Add(parm);
        }

        /// <summary>
        /// Creates a parameter and adds it to the command object
        /// </summary>
        /// <param name="parameter">A parameter object</param>
        /// <returns></returns>
        public int AddParameter(DbParameter parameter)
        {
            return Command.Parameters.Add(parameter);
        }

        /// <summary>
        /// Clear parameter
        /// </summary>
        public void ClearParameter()
        {
            Command.Parameters.Clear();
        }

        /// <summary>
        /// Add output parameter
        /// </summary>
        /// <param name="name">parameter name</param>
        /// <param name="dbType">parameter type</param>
        /// <returns></returns>
        public int AddOutParameter(string name, DbType dbType)
        {
            DbParameter parm = _factory.CreateParameter();
            parm.DbType = dbType;
            parm.ParameterName = name;
            parm.Direction = ParameterDirection.Output;
            parm.Size = 4000;
            return Command.Parameters.Add(parm);
        }

        /// <summary>
        /// Add Input and Output parameter
        /// </summary>
        /// <param name="name">parameter name</param>
        /// <param name="dbType">parameter type</param>
        /// <returns></returns>
        public int AddInOutParameter(string name, DbType dbType)
        {
            DbParameter parm = _factory.CreateParameter();
            parm.DbType = dbType;
            parm.ParameterName = name;
            parm.Direction = ParameterDirection.InputOutput;
            return Command.Parameters.Add(parm);
        }

        /// <summary>
        /// Add input parameter
        /// </summary>
        /// <param name="name">parameter name</param>
        /// <param name="dbType">parameter type</param>
        /// <param name="value">parameter value</param>
        /// <returns></returns>
        public int AddInParameter(string name, DbType dbType, object value)
        {
            DbParameter parm = _factory.CreateParameter();
            parm.DbType = dbType;
            parm.ParameterName = name;
            parm.Value = value;
            parm.Direction = ParameterDirection.Input;
            return Command.Parameters.Add(parm);
        }

        /// <summary>
        /// Add return parameter
        /// </summary>
        /// <param name="name">parameter name</param>
        /// <param name="dbType">parameter type</param>
        /// <returns></returns>
        public int AddReturnParameter(string name, DbType dbType)
        {
            DbParameter parm = _factory.CreateParameter();
            parm.DbType = dbType;
            parm.ParameterName = name;
            parm.Direction = ParameterDirection.ReturnValue;
            return Command.Parameters.Add(parm);
        }

        /// <summary>
        /// Add output parameter For Oracle cursor
        /// </summary>
        /// <param name="name">parameter name</param>
        /// <returns></returns>
        public int AddOutParameterForOracleCursor(string name)
        {
            OracleParameter parm = new OracleParameter();
            parm.OracleType = OracleType.Cursor;
            parm.ParameterName = name;
            parm.Direction = ParameterDirection.Output;
            return Command.Parameters.Add(parm);
        }

        /// <summary>
        /// Get parameter
        /// </summary>
        /// <param name="name">parameter name</param>
        /// <returns></returns>
        public DbParameter GetParameter(string name)
        {
            return Command.Parameters[name];
        }
        #endregion

        #region transactions

        /// <summary>
        /// Starts a transaction for the command object
        /// </summary>
        public void BeginTransaction()
        {
            if (Command.Connection.State == System.Data.ConnectionState.Closed)
            {
                Command.Connection.Open();
            }
            Command.Transaction = Connection.BeginTransaction();
        }

        /// <summary>
        /// Commits a transaction for the command object
        /// </summary>
        public void CommitTransaction()
        {
            Command.Transaction.Commit();
            Connection.Close();
        }

        /// <summary>
        /// Rolls back the transaction for the command object
        /// </summary>
        public void RollbackTransaction()
        {
            Command.Transaction.Rollback();
            Connection.Close();
        }

        #endregion

        #region execute database functions

        /// <summary>
        /// Executes a statement that does not return a result set, such as an INSERT, UPDATE, DELETE, or a data definition statement
        /// </summary>
        /// <param name="query">The query, either SQL or Procedures</param>
        /// <param name="commandtype">The command type, text, storedprocedure, or tabledirect</param>
        /// <returns>An integer value</returns>
        public int ExecuteNonQuery(string query, CommandType commandtype)
        {
            if (Command.Connection.State == System.Data.ConnectionState.Closed)
            {
                Command.Connection.Open();
            }

            Command.CommandText = query;
            Command.CommandType = commandtype;
            int i = Command.ExecuteNonQuery();
            return i;
        }

        /// <summary>
        /// Executes a statement that returns a single value. 
        /// If this method is called on a query that returns multiple rows and columns, only the first column of the first row is returned.
        /// </summary>
        /// <param name="query">The query, either SQL or Procedures</param>
        /// <param name="commandtype">The command type, text, storedprocedure, or tabledirect</param>
        /// <returns>An object that holds the return value(s) from the query</returns>
        public object ExecuteScaler(string query, CommandType commandtype)
        {
            if (Command.Connection.State == System.Data.ConnectionState.Closed)
            {
                Command.Connection.Open();
            }

            Command.CommandText = query;
            Command.CommandType = commandtype;
            object obj = Command.ExecuteScalar();
            return obj;
        }

        /// <summary>
        /// Executes a SQL statement that returns a result set.
        /// </summary>
        /// <param name="query">The query, either SQL or Procedures</param>
        /// <param name="commandtype">The command type, text, storedprocedure, or tabledirect</param>
        /// <returns>A datareader object</returns>
        public DbDataReader ExecuteReader(string query, CommandType commandtype)
        {
            if (Command.Connection.State == System.Data.ConnectionState.Closed)
            {
                Command.Connection.Open();
            }

            Command.CommandText = query;
            Command.CommandType = commandtype;
            DbDataReader reader = Command.ExecuteReader();
            return reader;
        }

        /// <summary>
        /// Generates a dataset
        /// </summary>
        /// <param name="query">The query, either SQL or Procedures</param>
        /// <param name="commandtype">The command type, text, storedprocedure, or tabledirect</param>
        /// <returns>A dataset containing data from the database</returns>
        public DataSet GetDataSet(string query, CommandType commandtype)
        {
            DbDataAdapter adapter = _factory.CreateDataAdapter();
            Command.CommandText = query;
            Command.CommandType = commandtype;
            adapter.SelectCommand = Command;
            DataSet ds = new DataSet();
            adapter.Fill(ds);
            return ds;
        }

        /// <summary>
        /// Generates a datatable
        /// </summary>
        /// <param name="query">The query, either SQL or Procedures</param>
        /// <param name="commandtype">The command type, text, storedprocedure, or tabledirect</param>
        /// <returns>A datatable containing data from the database</returns>
        public DataTable GetDataTable(string query, CommandType commandtype)
        {
            DbDataAdapter adapter = _factory.CreateDataAdapter();
            Command.CommandText = query;
            Command.CommandType = commandtype;
            adapter.SelectCommand = Command;
            DataTable dt = new DataTable();
            adapter.Fill(dt);
            return dt;
        }
        #endregion

        #region Release Resource
        /// <summary>
        /// Release connection
        /// </summary>
        public void Dispose()
        {
            this.CloseConnection();
        }

        /// <summary>
        /// Close connection
        /// </summary>
        public void CloseConnection()
        {
            if (Connection.State == System.Data.ConnectionState.Open)
            {
                Connection.Close();
                Connection.Dispose();
            }
        }
        #endregion

        #endregion

        #region enums

        /// <summary>
        /// A list of data providers
        /// </summary>
        [Serializable]
        public enum Provider
        {
            /// <summary>
            /// SQL Server
            /// </summary>
            SqlServer,
            /// <summary>
            /// Oracle
            /// </summary>
            Oracle
        }

        #endregion
    }
}