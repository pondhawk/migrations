using System;
using DbUp.Engine.Transactions;
using DbUp.Helpers;
using Microsoft.Data.Sqlite;


namespace DbUp.Sqlite.Helpers
{
    /// <summary>
    /// Used to create in-memory SQLite database that is deleted at the end of a test.
    /// </summary>
    public class InMemorySqliteDatabase : IDisposable
    {
        readonly SqliteConnectionManager connectionManager;
        readonly SqliteConnection sharedConnection;

        /// <summary>
        /// Initializes a new instance of the <see cref="InMemorySqliteDatabase"/> class.
        /// </summary>
        public InMemorySqliteDatabase()
        {
            var connectionStringBuilder = new SqliteConnectionStringBuilder
            {
                DataSource = ":memory:",
                DefaultTimeout = 5,
                Mode = SqliteOpenMode.Memory
            };
            ConnectionString = connectionStringBuilder.ToString();

            connectionManager = new SqliteConnectionManager(connectionStringBuilder.ConnectionString);
            sharedConnection = new SqliteConnection(connectionStringBuilder.ConnectionString);
            sharedConnection.Open();
            SqlRunner = new AdHocSqlRunner(() => sharedConnection.CreateCommand(), new SqliteObjectParser(), null, () => true);
        }

        public string ConnectionString { get; set; }

        /// <summary>
        /// Gets the connection factory of in-memory database.
        /// </summary>
        public IConnectionManager GetConnectionManager() => connectionManager;

        /// <summary>
        /// An adhoc sql runner against the in-memory database
        /// </summary>
        public AdHocSqlRunner SqlRunner { get; }

        /// <summary>
        /// Remove the database from memory.
        /// </summary>
        public void Dispose() => sharedConnection.Dispose();
    }
}
