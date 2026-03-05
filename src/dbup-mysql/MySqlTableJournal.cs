using System;
using DbUp.Engine;
using DbUp.Engine.Output;
using DbUp.Engine.Transactions;
using DbUp.Support;
using SmartFormat;

namespace DbUp.MySql
{
    /// <summary>
    /// An implementation of the <see cref="IJournal"/> interface which tracks version numbers for a
    /// MySql database using a table called SchemaVersions.
    /// </summary>
    public class MySqlTableJournal : TableJournal
    {
        /// <summary>
        /// Creates a new MySql table journal.
        /// </summary>
        /// <param name="connectionManager">The MySql connection manager.</param>
        /// <param name="logger">The upgrade logger.</param>
        /// <param name="schema">The name of the schema the journal is stored in.</param>
        /// <param name="table">The name of the journal table.</param>
        public MySqlTableJournal(Func<IConnectionManager> connectionManager, Func<IUpgradeLog> logger, string schema, string table)
            : base(connectionManager, logger, new MySqlObjectParser(), schema, table)
        {
        }

        private static string CreateSchemaTable =>
            """
            CREATE TABLE {FqSchemaTableName} 
            (
                `SchemaVersionId` INT NOT NULL AUTO_INCREMENT,
                `ScriptName` VARCHAR(255) NOT NULL,
                `Applied` TIMESTAMP NOT NULL,
                PRIMARY KEY (`SchemaVersionId`)
            );
            """;
    
        protected override string CreateSchemaTableSql(string quotedPrimaryKeyName)
        {
            var sql = Smart.Format(CreateSchemaTable, new { FqSchemaTableName });
            return sql;
        }    
    
    
        private static string InsertJournalEntry => 
            """
            insert into {FqSchemaTableName} 
                (ScriptName, Applied) 
            values 
                ({scriptName}, {applied})
            """;
    
        protected override string GetInsertJournalEntrySql(string scriptName, string applied)
        {
            var sql = Smart.Format(InsertJournalEntry, new { FqSchemaTableName, scriptName, applied });
            return sql;
        }

        private static string GetJournalEntries => 
            """
            select
                
                ScriptName

            from {FqSchemaTableName} 

            order by ScriptName
            """;
    
        protected override string GetJournalEntriesSql()
        {
            var sql = Smart.Format(GetJournalEntries, new { FqSchemaTableName });
            return sql;        
        }
    }
}
