using ElmahCore;
using Helper;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccess
{
    public class DatabaseContext
    {
        public readonly AppConfig _config;
        public readonly string connectionString;
        public readonly IHttpContextAccessor httpContextAccessor;
        public SqlConnection cn;

      
        public DatabaseContext(string connectionString)
        {
            this.cn = new SqlConnection(connectionString);
        }

        public DatabaseContext(AppConfig config, IHttpContextAccessor httpContextAccessor)
        {
            _config = config;
            this.httpContextAccessor = httpContextAccessor;
            this.connectionString = _config.GetValue("DbConnection");
            this.cn = new SqlConnection(this.connectionString);

        }

        public List<SqlParameter> SqlParameters
        {
            get
            {
                return new List<SqlParameter>();
            }
        }

        public async Task<DataSet> ExecuteDataSetAsync(CommandType cmdType, string cmdString, IEnumerable<SqlParameter> sqlParameters = null)
        {
            SqlCommand cmd = new SqlCommand();
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataSet ds = new DataSet();

            cmd.CommandType = cmdType;
            cmd.CommandText = cmdString;
            if (SqlParameters != null)
            {
                cmd.Parameters.AddRange(sqlParameters.ToArray());

            }
            cmd.Connection = cn;
            await Task.Run(() => da.Fill(ds));
            cmd.Parameters.Clear();
            return ds;
        }

        public async Task<DataTable>ExecuteDataTableAsync(CommandType cmdType,string cmdString, IEnumerable<SqlParameter>sqlParameters = null)
        {
            var ds = await this.ExecuteDataSetAsync(cmdType, cmdString, sqlParameters);
            return ds.Tables[0];
        }

        public async Task<DbResponse> ExecuteDataTableWithDbResponse(CommandType cmdType, string cmdString, IEnumerable<SqlParameter> sqlParameters = null)
        {
            try
            {
                var result = await ExecuteDataTableAsync(cmdType, cmdString, sqlParameters);
                return new DbResponse() { Response = result };

            }
            catch (Exception ex)
            {
                httpContextAccessor.HttpContext.RiseError(ex);

                return new DbResponse
                {
                    Message = ex.Message,
                    HasError = true
                };

        }
    }


}
}
