using System;
using System.IO;
using DbUp.Helpers;
using Microsoft.Data.Sqlite;


namespace DbUp.Sqlite.Helpers
{
    /// <summary>
    /// Used to create SQLite databases that are deleted at the end of a test.
    /// </summary>
    public class TemporarySqliteDatabase : IDisposable
    {
        readonly string dataSourcePath;
        readonly SqliteConnection sqLiteConnection;

        /// <summary>
        /// Initializes a new instance of the <see cref="TemporarySqliteDatabase"/> class.
        /// </summary>
        /// <param name="name">The name.</param>
        public TemporarySqliteDatabase(string name)
        {
            dataSourcePath = Path.Combine(Directory.GetCurrentDirectory(), name);

            var connectionStringBuilder = new SqliteConnectionStringBuilder
            {
                DataSource = name,
                DefaultTimeout = 5,
            };

            sqLiteConnection = new SqliteConnection(connectionStringBuilder.ConnectionString);
            sqLiteConnection.Open();
            SharedConnection = new SharedConnection(sqLiteConnection);
            SqlRunner = new AdHocSqlRunner(() => sqLiteConnection.CreateCommand(), new SqliteObjectParser(), null, () => true);
        }

        /// <summary>
        /// An adhoc sql runner against the temporary database
        /// </summary>
        public AdHocSqlRunner SqlRunner { get; }

        public SharedConnection SharedConnection { get; }

        /// <summary>
        /// Deletes the database.
        /// </summary>
        public void Dispose()
        {
            var filePath = new FileInfo(dataSourcePath);
            if (!filePath.Exists) return;
            SharedConnection.Dispose();
            sqLiteConnection.Dispose();
            
            // SQLite requires all created sql connection/command objects to be disposed
            // in order to delete the database file
            SqliteConnection.ClearAllPools();

            File.Delete(dataSourcePath);
        }
    }
}
