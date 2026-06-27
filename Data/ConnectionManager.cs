using System.Configuration;
using System.Data.SqlClient;

namespace Data
{
    public static class ConnectionManager
    {
        private static readonly string ConnectionString = 
            ConfigurationManager.ConnectionStrings["DesafioDB"]?.ConnectionString 
            ?? "Server=(localdb)\\MSSQLLocalDB;Database=DesafioDB;Integrated Security=True;";

        public static SqlConnection GetConnection()
        {
            return new SqlConnection(ConnectionString);
        }
    }
}
