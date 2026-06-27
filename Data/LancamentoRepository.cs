using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Data.Models;

namespace Data
{
    public class LancamentoRepository
    {
        public List<Lancamento> Listar(string competencia = null, string status = null, string tipo = null)
        {
            var list = new List<Lancamento>();
            using (var conn = ConnectionManager.GetConnection())
            {
                var sql = "SELECT * FROM Lancamentos WHERE 1=1";
                
                if (!string.IsNullOrWhiteSpace(competencia))
                    sql += " AND Competencia = @Competencia";
                if (!string.IsNullOrWhiteSpace(status))
                    sql += " AND Status = @Status";
                if (!string.IsNullOrWhiteSpace(tipo))
                    sql += " AND Tipo = @Tipo";

                sql += " ORDER BY DataLancamento DESC, Id DESC";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    if (!string.IsNullOrWhiteSpace(competencia))
                        cmd.Parameters.AddWithValue("@Competencia", competencia);
                    if (!string.IsNullOrWhiteSpace(status))
                        cmd.Parameters.AddWithValue("@Status", status);
                    if (!string.IsNullOrWhiteSpace(tipo))
                        cmd.Parameters.AddWithValue("@Tipo", tipo);

                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            list.Add(MapFromReader(reader));
                        }
                    }
                }
            }
            return list;
        }

        public Lancamento ObterPorId(int id)
        {
            using (var conn = ConnectionManager.GetConnection())
            {
                var sql = "SELECT * FROM Lancamentos WHERE Id = @Id";
                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    conn.Open();
                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            return MapFromReader(reader);
                        }
                    }
                }
            }
            return null;
        }

        public void Inserir(Lancamento model)
        {
            using (var conn = ConnectionManager.GetConnection())
            {
                var sql = @"INSERT INTO Lancamentos 
                            (Descricao, Tipo, ValorOriginal, PercentualTaxa, PercentualDesconto, ValorCalculado, DataLancamento, Competencia, Status) 
                            VALUES 
                            (@Descricao, @Tipo, @ValorOriginal, @PercentualTaxa, @PercentualDesconto, @ValorCalculado, @DataLancamento, @Competencia, @Status);
                            SELECT SCOPE_IDENTITY();";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Descricao", model.Descricao);
                    cmd.Parameters.AddWithValue("@Tipo", model.Tipo);
                    cmd.Parameters.AddWithValue("@ValorOriginal", model.ValorOriginal);
                    cmd.Parameters.AddWithValue("@PercentualTaxa", model.PercentualTaxa);
                    cmd.Parameters.AddWithValue("@PercentualDesconto", model.PercentualDesconto);
                    cmd.Parameters.AddWithValue("@ValorCalculado", model.ValorCalculado);
                    cmd.Parameters.AddWithValue("@DataLancamento", model.DataLancamento);
                    cmd.Parameters.AddWithValue("@Competencia", model.Competencia);
                    cmd.Parameters.AddWithValue("@Status", model.Status);

                    conn.Open();
                    model.Id = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
        }

        public void Atualizar(Lancamento model)
        {
            using (var conn = ConnectionManager.GetConnection())
            {
                var sql = @"UPDATE Lancamentos SET 
                            Descricao = @Descricao, 
                            Tipo = @Tipo, 
                            ValorOriginal = @ValorOriginal, 
                            PercentualTaxa = @PercentualTaxa, 
                            PercentualDesconto = @PercentualDesconto, 
                            ValorCalculado = @ValorCalculado, 
                            DataLancamento = @DataLancamento, 
                            Competencia = @Competencia
                            WHERE Id = @Id";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", model.Id);
                    cmd.Parameters.AddWithValue("@Descricao", model.Descricao);
                    cmd.Parameters.AddWithValue("@Tipo", model.Tipo);
                    cmd.Parameters.AddWithValue("@ValorOriginal", model.ValorOriginal);
                    cmd.Parameters.AddWithValue("@PercentualTaxa", model.PercentualTaxa);
                    cmd.Parameters.AddWithValue("@PercentualDesconto", model.PercentualDesconto);
                    cmd.Parameters.AddWithValue("@ValorCalculado", model.ValorCalculado);
                    cmd.Parameters.AddWithValue("@DataLancamento", model.DataLancamento);
                    cmd.Parameters.AddWithValue("@Competencia", model.Competencia);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public void AtualizarStatus(int id, string status, DateTime? dataPagamento, DateTime? dataCancelamento)
        {
            using (var conn = ConnectionManager.GetConnection())
            {
                var sql = @"UPDATE Lancamentos SET 
                            Status = @Status, 
                            DataPagamento = @DataPagamento, 
                            DataCancelamento = @DataCancelamento 
                            WHERE Id = @Id";

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Id", id);
                    cmd.Parameters.AddWithValue("@Status", status);
                    cmd.Parameters.AddWithValue("@DataPagamento", (object)dataPagamento ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@DataCancelamento", (object)dataCancelamento ?? DBNull.Value);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }

        public bool ExisteDuplicado(string competencia, string descricao, string tipo, int? excluirId = null)
        {
            using (var conn = ConnectionManager.GetConnection())
            {
                var sql = "SELECT COUNT(1) FROM Lancamentos WHERE Competencia = @Competencia AND Descricao = @Descricao AND Tipo = @Tipo";
                if (excluirId.HasValue)
                {
                    sql += " AND Id <> @ExcluirId";
                }

                using (var cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Competencia", competencia);
                    cmd.Parameters.AddWithValue("@Descricao", descricao);
                    cmd.Parameters.AddWithValue("@Tipo", tipo);
                    if (excluirId.HasValue)
                    {
                        cmd.Parameters.AddWithValue("@ExcluirId", excluirId.Value);
                    }

                    conn.Open();
                    return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
                }
            }
        }

        private Lancamento MapFromReader(SqlDataReader reader)
        {
            return new Lancamento
            {
                Id = Convert.ToInt32(reader["Id"]),
                Descricao = Convert.ToString(reader["Descricao"]),
                Tipo = Convert.ToString(reader["Tipo"]),
                ValorOriginal = Convert.ToDecimal(reader["ValorOriginal"]),
                PercentualTaxa = Convert.ToDecimal(reader["PercentualTaxa"]),
                PercentualDesconto = Convert.ToDecimal(reader["PercentualDesconto"]),
                ValorCalculado = Convert.ToDecimal(reader["ValorCalculado"]),
                DataLancamento = Convert.ToDateTime(reader["DataLancamento"]),
                DataCriacao = Convert.ToDateTime(reader["DataCriacao"]),
                DataPagamento = reader["DataPagamento"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["DataPagamento"]),
                DataCancelamento = reader["DataCancelamento"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["DataCancelamento"]),
                Competencia = Convert.ToString(reader["Competencia"]),
                Status = Convert.ToString(reader["Status"])
            };
        }
    }
}
