using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Business;
using Data.Models;

namespace WebApp
{
    public partial class Default : System.Web.UI.Page
    {
        private readonly LancamentoBusiness _business = new LancamentoBusiness();

        protected decimal SaldoTotalValue { get; set; }
        protected string SaldoTotalClass { get; set; }
        protected decimal PendenteTotalValue { get; set; }
        protected string PendenteTotalClass { get; set; }
        protected int QtdCanceladosValue { get; set; }
        protected string AlertCssClass { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CarregarFiltroCompetencia();
                CarregarDados();
                txtData.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtCompetencia.Text = DateTime.Today.ToString("MM/yyyy");
            }
        }

        private void CarregarFiltroCompetencia()
        {
            string selecionado = ddlFiltroCompetencia.SelectedValue;
            ddlFiltroCompetencia.Items.Clear();
            ddlFiltroCompetencia.Items.Add(new ListItem("Todas", ""));

            try
            {
                // Carregar todas as competências únicas
                var todos = _business.Listar();
                var competencias = todos
                    .Select(l => l.Competencia)
                    .Distinct()
                    .OrderByDescending(c => {
                        // Ordenar por ano/mês
                        DateTime date;
                        if (DateTime.TryParseExact(c, "MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out date))
                            return date;
                        return DateTime.MinValue;
                    })
                    .ToList();

                foreach (var comp in competencias)
                {
                    ddlFiltroCompetencia.Items.Add(new ListItem(comp, comp));
                }

                if (!string.IsNullOrEmpty(selecionado) && ddlFiltroCompetencia.Items.FindByValue(selecionado) != null)
                {
                    ddlFiltroCompetencia.SelectedValue = selecionado;
                }
            }
            catch (Exception ex)
            {
                ExibirMensagem("Erro ao carregar compet\u00eancias: " + ex.Message, isError: true);
            }
        }

        private void CarregarDados()
        {
            try
            {
                string comp = ddlFiltroCompetencia.SelectedValue;
                string status = ddlFiltroStatus.SelectedValue;
                string tipo = ddlFiltroTipo.SelectedValue;

                var lista = _business.Listar(comp, status, tipo);
                rptLancamentos.DataSource = lista;
                rptLancamentos.DataBind();

                // Dashboard
                SaldoTotalValue = _business.ObterSaldoTotal();
                SaldoTotalClass = SaldoTotalValue >= 0 ? "positive" : "negative";

                PendenteTotalValue = _business.ObterValorPendente();
                PendenteTotalClass = PendenteTotalValue >= 0 ? "positive" : "negative";

                QtdCanceladosValue = _business.ObterQuantidadeCancelados();

                // Cabeçalho de Impressão
                List<string> filtros = new List<string>();
                if (!string.IsNullOrEmpty(comp)) filtros.Add("Compet\u00eancia: " + comp);
                if (!string.IsNullOrEmpty(status)) filtros.Add("Status: " + status);
                if (!string.IsNullOrEmpty(tipo)) filtros.Add("Tipo: " + (tipo == "Credito" ? "Cr\u00e9dito" : "D\u00e9bito"));
                
                lblFiltrosAtivosPrint.InnerText = filtros.Count > 0 
                    ? "Filtros aplicados: " + string.Join(" | ", filtros) 
                    : "Filtros aplicados: Nenhum";
            }
            catch (Exception ex)
            {
                ExibirMensagem("Erro ao carregar dados: " + ex.Message, isError: true);
            }
        }

        protected void btnSalvar_Click(object sender, EventArgs e)
        {
            try
            {
                var model = new Lancamento();
                
                if (!string.IsNullOrEmpty(hdnId.Value))
                {
                    model.Id = Convert.ToInt32(hdnId.Value);
                }

                model.Descricao = txtDescricao.Text.Trim();
                model.Tipo = ddlTipo.SelectedValue;
                
                decimal valOriginal;
                if (decimal.TryParse(txtValorOriginal.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out valOriginal))
                {
                    model.ValorOriginal = valOriginal;
                }
                else
                {
                    throw new ArgumentException("Valor Original inv\u00e1lido.");
                }

                if (model.Tipo == "Credito")
                {
                    model.PercentualTaxa = 0;
                    decimal desc;
                    if (decimal.TryParse(txtDesconto.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out desc))
                    {
                        model.PercentualDesconto = desc;
                    }
                    else
                    {
                        model.PercentualDesconto = 0;
                    }
                }
                else // Debito
                {
                    model.PercentualDesconto = 0;
                    decimal taxa;
                    if (decimal.TryParse(txtTaxa.Text, NumberStyles.Any, CultureInfo.InvariantCulture, out taxa))
                    {
                        model.PercentualTaxa = taxa;
                    }
                    else
                    {
                        model.PercentualTaxa = 0;
                    }
                }

                DateTime data;
                if (DateTime.TryParse(txtData.Text, out data))
                {
                    model.DataLancamento = data;
                }
                else
                {
                    throw new ArgumentException("Data de Lan\u00e7amento inv\u00e1lida.");
                }

                model.Competencia = txtCompetencia.Text.Trim();

                if (model.Id == 0)
                {
                    _business.Inserir(model);
                    ExibirMensagem("Lan\u00e7amento cadastrado com sucesso!", isError: false);
                }
                else
                {
                    _business.Atualizar(model);
                    ExibirMensagem("Lan\u00e7amento atualizado com sucesso!", isError: false);
                }

                LimparFormulario();
                CarregarFiltroCompetencia();
                CarregarDados();
            }
            catch (Exception ex)
            {
                ExibirMensagem(ex.Message, isError: true);
            }
        }

        protected void btnCancelarEdicao_Click(object sender, EventArgs e)
        {
            LimparFormulario();
        }

        protected void btnFiltrar_Click(object sender, EventArgs e)
        {
            CarregarDados();
        }

        protected void btnLimparFiltros_Click(object sender, EventArgs e)
        {
            ddlFiltroCompetencia.SelectedIndex = 0;
            ddlFiltroStatus.SelectedIndex = 0;
            ddlFiltroTipo.SelectedIndex = 0;
            CarregarDados();
        }

        protected void rptLancamentos_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int id = Convert.ToInt32(e.CommandArgument);
            try
            {
                if (e.CommandName == "Pagar")
                {
                    _business.Pagar(id);
                    ExibirMensagem("Lan\u00e7amento pago com sucesso!", isError: false);
                    CarregarDados();
                }
                else if (e.CommandName == "Cancelar")
                {
                    _business.Cancelar(id);
                    ExibirMensagem("Lan\u00e7amento cancelado com sucesso!", isError: false);
                    CarregarDados();
                }
                else if (e.CommandName == "Editar")
                {
                    var model = _business.ObterPorId(id);
                    if (model != null)
                    {
                        hdnId.Value = model.Id.ToString();
                        txtDescricao.Text = model.Descricao;
                        ddlTipo.SelectedValue = model.Tipo;
                        txtValorOriginal.Text = model.ValorOriginal.ToString(CultureInfo.InvariantCulture);
                        txtDesconto.Text = model.PercentualDesconto.ToString(CultureInfo.InvariantCulture);
                        txtTaxa.Text = model.PercentualTaxa.ToString(CultureInfo.InvariantCulture);
                        txtData.Text = model.DataLancamento.ToString("yyyy-MM-dd");
                        txtCompetencia.Text = model.Competencia;

                        litFormTitle.Text = "Editar Lan\u00e7amento #" + model.Id;
                        btnCancelarEdicao.Visible = true;
                        
                        // Executar script no cliente para ajustar estado desabilitado dos inputs
                        ScriptManager.RegisterStartupScript(this, GetType(), "toggleInputs", "toggleInputs();", true);
                    }
                }
            }
            catch (Exception ex)
            {
                ExibirMensagem(ex.Message, isError: true);
            }
        }


        private void ExibirMensagem(string mensagem, bool isError)
        {
            pnlAlert.Visible = true;
            litAlertMsg.Text = HttpUtility.HtmlEncode(mensagem);
            AlertCssClass = isError ? "alert-danger" : "alert-success";
        }

        private void LimparFormulario()
        {
            hdnId.Value = "";
            txtDescricao.Text = "";
            ddlTipo.SelectedValue = "Credito";
            txtValorOriginal.Text = "";
            txtDesconto.Text = "0";
            txtTaxa.Text = "0";
            txtData.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtCompetencia.Text = DateTime.Today.ToString("MM/yyyy");

            litFormTitle.Text = "Novo Lan\u00e7amento";
            btnCancelarEdicao.Visible = false;

            ScriptManager.RegisterStartupScript(this, GetType(), "toggleInputs", "toggleInputs();", true);
        }
    }
}
