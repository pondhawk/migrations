using DbUp.Support;

namespace DbUp.Sqlite
{
    /// <summary>
    /// Parses Sql Objects and performs quoting functions.
    /// </summary>
    public class SqliteObjectParser : SqlObjectParser
    {
        public SqliteObjectParser()
            : base("[", "]")
        {
        }
    }
}
