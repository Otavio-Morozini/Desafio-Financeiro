<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="WebApp.Default" Culture="pt-BR" UICulture="pt-BR" %>

<!DOCTYPE html>
<html lang="pt-br">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Controle de Lançamentos Financeiros</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --bg-primary: #f8fafc;
            --bg-card: #ffffff;
            --text-main: #0f172a;
            --text-muted: #64748b;
            --primary: #4f46e5;
            --primary-hover: #4338ca;
            --success: #10b981;
            --success-bg: #ecfdf5;
            --danger: #ef4444;
            --danger-bg: #fef2f2;
            --warning: #f59e0b;
            --warning-bg: #fffbeb;
            --border-color: #e2e8f0;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-main);
            line-height: 1.5;
            -webkit-font-smoothing: antialiased;
        }

        .header {
            background: linear-gradient(135deg, #1e1b4b 0%, #312e81 100%);
            color: #ffffff;
            padding: 1.5rem 2rem;
            box-shadow: var(--shadow-md);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header h1 {
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.025em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .header h1 span {
            background: linear-gradient(to right, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header .subtitle {
            font-size: 0.875rem;
            color: #cbd5e1;
        }

        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 1.5rem;
        }

        /* Dashboard Cards */
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .card-stat {
            background: var(--bg-card);
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            border: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            transition: transform 0.2s, box-shadow 0.2s;
        }

        .card-stat:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .card-stat::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
        }

        .card-stat.saldo::before { background-color: var(--success); }
        .card-stat.pendente::before { background-color: var(--warning); }
        .card-stat.cancelado::before { background-color: var(--danger); }

        .stat-details h3 {
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--text-muted);
            margin-bottom: 0.5rem;
        }

        .stat-details .value {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--text-main);
        }

        .stat-details .value.positive { color: var(--success); }
        .stat-details .value.negative { color: var(--danger); }

        .stat-icon {
            width: 3.5rem;
            height: 3.5rem;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-stat.saldo .stat-icon {
            background-color: var(--success-bg);
            color: var(--success);
        }

        .card-stat.pendente .stat-icon {
            background-color: var(--warning-bg);
            color: var(--warning);
        }

        .card-stat.cancelado .stat-icon {
            background-color: var(--danger-bg);
            color: var(--danger);
        }

        /* Layout Grid */
        .layout-grid {
            display: grid;
            grid-template-columns: 380px 1fr;
            gap: 2rem;
        }

        @media (max-width: 1024px) {
            .layout-grid {
                grid-template-columns: 1fr;
            }
        }

        .panel {
            background: var(--bg-card);
            border-radius: 1rem;
            border: 1px solid var(--border-color);
            box-shadow: var(--shadow-sm);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .panel-title {
            font-size: 1.125rem;
            font-weight: 600;
            margin-bottom: 1.25rem;
            color: var(--text-main);
            display: flex;
            align-items: center;
            gap: 0.5rem;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 0.75rem;
        }

        /* Form Controls */
        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-main);
            margin-bottom: 0.375rem;
        }

        .form-control {
            width: 100%;
            padding: 0.625rem 0.75rem;
            font-size: 0.875rem;
            border-radius: 0.5rem;
            border: 1px solid var(--border-color);
            background-color: #ffffff;
            color: var(--text-main);
            font-family: inherit;
            transition: border-color 0.15s, box-shadow 0.15s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.15);
        }

        .disabled-input {
            background-color: #f1f5f9;
            color: #94a3b8;
            cursor: not-allowed;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-size: 0.875rem;
            font-weight: 600;
            padding: 0.625rem 1rem;
            border-radius: 0.5rem;
            border: 1px solid transparent;
            cursor: pointer;
            transition: all 0.15s;
            font-family: inherit;
            width: 100%;
            text-decoration: none;
        }

        .btn-primary {
            background-color: var(--primary);
            color: #ffffff;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
        }

        .btn-secondary {
            background-color: #f1f5f9;
            color: #334155;
            border: 1px solid var(--border-color);
        }

        .btn-secondary:hover {
            background-color: #e2e8f0;
        }

        .btn-danger {
            background-color: var(--danger);
            color: #ffffff;
        }

        .btn-danger:hover {
            background-color: #dc2626;
        }

        .btn-group {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }

        /* Alert Messages */
        .alert {
            padding: 0.75rem 1rem;
            border-radius: 0.5rem;
            font-size: 0.875rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
        }

        .alert-success {
            background-color: var(--success-bg);
            color: var(--success);
            border-color: rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background-color: var(--danger-bg);
            color: var(--danger);
            border-color: rgba(239, 68, 68, 0.2);
        }

        /* Filter Section */
        .filter-bar {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            align-items: flex-end;
            margin-bottom: 1.5rem;
            background: #ffffff;
            padding: 1.25rem;
            border-radius: 0.75rem;
            border: 1px solid var(--border-color);
        }

        .filter-group {
            flex: 1;
            min-width: 150px;
        }

        .filter-actions {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .filter-actions .btn {
            width: auto;
            white-space: nowrap;
        }

        /* Table & Lists */
        .table-responsive {
            width: 100%;
            overflow-x: auto;
            border-radius: 0.75rem;
            border: 1px solid var(--border-color);
            background-color: #ffffff;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
            font-size: 0.875rem;
        }

        .data-table th {
            background-color: #f8fafc;
            color: var(--text-muted);
            font-weight: 600;
            padding: 0.75rem 1rem;
            border-bottom: 1px solid var(--border-color);
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
        }

        .data-table td {
            padding: 1rem;
            border-bottom: 1px solid var(--border-color);
            color: var(--text-main);
            vertical-align: middle;
        }

        .data-table tr:last-child td {
            border-bottom: none;
        }

        .data-table tr:hover td {
            background-color: #f8fafc;
        }

        /* Badges */
        .badge {
            display: inline-flex;
            align-items: center;
            font-size: 0.75rem;
            font-weight: 600;
            padding: 0.25rem 0.625rem;
            border-radius: 9999px;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        .badge-pago {
            background-color: var(--success-bg);
            color: var(--success);
        }

        .badge-aberto {
            background-color: var(--warning-bg);
            color: var(--warning);
        }

        .badge-cancelado {
            background-color: var(--danger-bg);
            color: var(--danger);
        }

        .badge-credito {
            color: var(--success);
            font-weight: 600;
        }

        .badge-debito {
            color: var(--danger);
            font-weight: 600;
        }

        /* Action Buttons in Table */
        .actions-cell {
            display: flex;
            gap: 0.375rem;
        }

        .btn-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 2rem;
            height: 2rem;
            border-radius: 0.375rem;
            border: 1px solid var(--border-color);
            background-color: #ffffff;
            color: var(--text-muted);
            cursor: pointer;
            transition: all 0.15s;
            text-decoration: none;
        }

        .btn-action:hover {
            color: var(--text-main);
            background-color: #f1f5f9;
        }

        .btn-action.pay:hover {
            color: var(--success);
            background-color: var(--success-bg);
            border-color: rgba(16, 185, 129, 0.2);
        }

        .btn-action.cancel:hover {
            color: var(--danger);
            background-color: var(--danger-bg);
            border-color: rgba(239, 68, 68, 0.2);
        }

        .btn-action.edit:hover {
            color: var(--primary);
            background-color: #e0e7ff;
            border-color: rgba(79, 70, 229, 0.2);
        }

        /* Empty State */
        .empty-state {
            padding: 3rem 1.5rem;
            text-align: center;
            color: var(--text-muted);
        }

        .empty-state svg {
            width: 3rem;
            height: 3rem;
            margin-bottom: 1rem;
            color: #94a3b8;
        }

        /* Print styling */
        @media print {
            body {
                background-color: #ffffff;
                color: #000000;
            }
            .header, .filter-bar, .panel.form-panel, .actions-cell, .filter-actions, .btn-group, .btn, hr {
                display: none !important;
            }
            .container {
                margin: 0;
                padding: 0;
                max-width: 100%;
            }
            .layout-grid {
                grid-template-columns: 1fr !important;
            }
            .panel {
                border: none !important;
                box-shadow: none !important;
                padding: 0 !important;
            }
            .data-table th, .data-table td {
                padding: 0.5rem !important;
                border-bottom: 1px solid #000000 !important;
            }
            .badge {
                border: 1px solid #000000;
                padding: 1px 4px;
                border-radius: 4px;
                color: #000000 !important;
                background: none !important;
            }
            .print-header {
                display: block !important;
                margin-bottom: 2rem;
                border-bottom: 2px solid #000000;
                padding-bottom: 1rem;
            }
            .print-header h2 {
                font-size: 1.75rem;
                font-weight: 700;
            }
        }

        .print-header {
            display: none;
        }
    </style>
    <script>
        function toggleInputs() {
            var ddlTipo = document.getElementById('<%= ddlTipo.ClientID %>');
            var txtDesconto = document.getElementById('<%= txtDesconto.ClientID %>');
            var txtTaxa = document.getElementById('<%= txtTaxa.ClientID %>');
            
            if (!ddlTipo || !txtDesconto || !txtTaxa) return;

            if (ddlTipo.value === 'Credito') {
                txtDesconto.disabled = false;
                txtDesconto.classList.remove('disabled-input');
                txtTaxa.disabled = true;
                txtTaxa.classList.add('disabled-input');
                txtTaxa.value = '0';
            } else if (ddlTipo.value === 'Debito') {
                txtDesconto.disabled = true;
                txtDesconto.classList.add('disabled-input');
                txtDesconto.value = '0';
                txtTaxa.disabled = false;
                txtTaxa.classList.remove('disabled-input');
            }
        }

        function updateCompetencia() {
            var txtData = document.getElementById('<%= txtData.ClientID %>');
            var txtCompetencia = document.getElementById('<%= txtCompetencia.ClientID %>');
            
            if (!txtData || !txtCompetencia) return;

            if (txtData.value) {
                var parts = txtData.value.split('-'); // YYYY-MM-DD
                if (parts.length === 3) {
                    txtCompetencia.value = parts[1] + '/' + parts[0];
                }
            }
        }

        window.onload = function() {
            toggleInputs();
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <header class="header">
            <div>
                <h1>Desafio <span>Finance</span></h1>
                <div class="subtitle">Controle de Lançamentos Financeiros</div>
            </div>
            <div class="filter-actions">
                <button type="button" class="btn btn-secondary" onclick="window.print();">
                    <svg style="width:1.25rem;height:1.25rem;vertical-align:middle;margin-right:0.25rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/>
                    </svg>
                    Imprimir Relatório
                </button>
            </div>
        </header>

        <div class="container">
            <!-- Print-Only Header -->
            <div class="print-header">
                <h2>Relatório de Lançamentos Financeiros</h2>
                <p>Gerado em: <%= DateTime.Now.ToString("dd/MM/yyyy HH:mm") %></p>
                <p runat="server" id="lblFiltrosAtivosPrint">Filtros aplicados: Nenhum</p>
            </div>

            <!-- Messages Alert -->
            <asp:Panel ID="pnlAlert" runat="server" Visible="false">
                <div class="alert <%= AlertCssClass %>">
                    <asp:Literal ID="litAlertMsg" runat="server"></asp:Literal>
                </div>
            </asp:Panel>

            <!-- Dashboard Stats -->
            <div class="dashboard-grid">
                <div class="card-stat saldo">
                    <div class="stat-details">
                        <h3>Saldo Total (Pago)</h3>
                        <div class="value <%= SaldoTotalClass %>">
                            <%= SaldoTotalValue.ToString("C") %>
                        </div>
                    </div>
                    <div class="stat-icon">
                        <svg style="width:2rem;height:2rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                </div>

                <div class="card-stat pendente">
                    <div class="stat-details">
                        <h3>Resultado Pendente (Aberto)</h3>
                        <div class="value <%= PendenteTotalClass %>">
                            <%= PendenteTotalValue.ToString("C") %>
                        </div>
                    </div>
                    <div class="stat-icon">
                        <svg style="width:2rem;height:2rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                </div>

                <div class="card-stat cancelado">
                    <div class="stat-details">
                        <h3>Lançamentos Cancelados</h3>
                        <div class="value">
                            <%= QtdCanceladosValue %>
                        </div>
                    </div>
                    <div class="stat-icon">
                        <svg style="width:2rem;height:2rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                    </div>
                </div>
            </div>

            <!-- Layout Grid -->
            <div class="layout-grid">
                <!-- Form Column -->
                <div>
                    <div class="panel form-panel">
                        <div class="panel-title">
                            <svg style="width:1.5rem;height:1.5rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 13h6m-3-3v6m5 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                            </svg>
                            <asp:Literal ID="litFormTitle" runat="server">Novo Lançamento</asp:Literal>
                        </div>
                        <asp:HiddenField ID="hdnId" runat="server" Value="" />
                        
                        <div class="form-group">
                            <label for="txtDescricao">Descrição *</label>
                            <asp:TextBox ID="txtDescricao" runat="server" CssClass="form-control" placeholder="Ex: Pagamento Fornecedor" Required="true" MaxLength="250"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="ddlTipo">Tipo *</label>
                            <asp:DropDownList ID="ddlTipo" runat="server" CssClass="form-control" onchange="toggleInputs()">
                                <asp:ListItem Value="Credito">Crédito</asp:ListItem>
                                <asp:ListItem Value="Debito">Débito</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label for="txtValorOriginal">Valor Original (R$) *</label>
                            <asp:TextBox ID="txtValorOriginal" runat="server" CssClass="form-control" type="number" step="0.01" min="0.01" placeholder="0.00" Required="true"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label id="lblDesconto" for="txtDesconto">Percentual de Desconto (%) *</label>
                            <asp:TextBox ID="txtDesconto" runat="server" CssClass="form-control" type="number" step="0.01" min="0" max="100" placeholder="0.00"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label id="lblTaxa" for="txtTaxa">Percentual de Taxa (%) *</label>
                            <asp:TextBox ID="txtTaxa" runat="server" CssClass="form-control" type="number" step="0.01" min="0" max="100" placeholder="0.00"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtData">Data do Lançamento *</label>
                            <asp:TextBox ID="txtData" runat="server" CssClass="form-control" type="date" onchange="updateCompetencia()" Required="true"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtCompetencia">Competência *</label>
                            <asp:TextBox ID="txtCompetencia" runat="server" CssClass="form-control" placeholder="MM/AAAA" Required="true" MaxLength="7"></asp:TextBox>
                        </div>

                        <div class="btn-group">
                            <asp:Button ID="btnSalvar" runat="server" CssClass="btn btn-primary" Text="Salvar" OnClick="btnSalvar_Click" />
                            <asp:Button ID="btnCancelarEdicao" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCancelarEdicao_Click" Visible="false" />
                        </div>
                    </div>
                </div>

                <!-- List Column -->
                <div>
                    <!-- Filter Bar -->
                    <div class="filter-bar">
                        <div class="filter-group">
                            <label for="ddlFiltroCompetencia">Competência</label>
                            <asp:DropDownList ID="ddlFiltroCompetencia" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                        <div class="filter-group">
                            <label for="ddlFiltroStatus">Status</label>
                            <asp:DropDownList ID="ddlFiltroStatus" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Todos</asp:ListItem>
                                <asp:ListItem Value="Aberto">Aberto</asp:ListItem>
                                <asp:ListItem Value="Pago">Pago</asp:ListItem>
                                <asp:ListItem Value="Cancelado">Cancelado</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="filter-group">
                            <label for="ddlFiltroTipo">Tipo</label>
                            <asp:DropDownList ID="ddlFiltroTipo" runat="server" CssClass="form-control">
                                <asp:ListItem Value="">Todos</asp:ListItem>
                                <asp:ListItem Value="Credito">Crédito</asp:ListItem>
                                <asp:ListItem Value="Debito">Débito</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <!-- List Panel -->
                    <div class="panel">
                        <div class="panel-title">
                            <svg style="width:1.5rem;height:1.5rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 10h16M4 14h16M4 18h16"/>
                            </svg>
                            Lançamentos Cadastrados
                        </div>

                        <div class="table-responsive">
                            <asp:Repeater ID="rptLancamentos" runat="server" OnItemCommand="rptLancamentos_ItemCommand">
                                <HeaderTemplate>
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>Descrição</th>
                                                <th>Tipo</th>
                                                <th>Vl. Original</th>
                                                <th>Taxa / Desc</th>
                                                <th>Vl. Calculado</th>
                                                <th>Data Lanç.</th>
                                                <th>Competência</th>
                                                <th>Status</th>
                                                <th>Ações</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td style="font-weight: 500;"><%# Eval("Descricao") %></td>
                                        <td>
                                            <span class="badge-<%# Eval("Tipo").ToString().ToLower() %>">
                                                <%# Eval("Tipo").ToString() == "Credito" ? "Crédito" : "Débito" %>
                                            </span>
                                        </td>
                                        <td><%# Convert.ToDecimal(Eval("ValorOriginal")).ToString("C") %></td>
                                        <td>
                                            <%# Eval("Tipo").ToString() == "Credito" ? 
                                                Eval("PercentualDesconto").ToString() + "% desc" : 
                                                Eval("PercentualTaxa").ToString() + "% taxa" %>
                                        </td>
                                        <td style="font-weight: 700; color: #1e293b;"><%# Convert.ToDecimal(Eval("ValorCalculado")).ToString("C") %></td>
                                        <td><%# Convert.ToDateTime(Eval("DataLancamento")).ToString("dd/MM/yyyy") %></td>
                                        <td><%# Eval("Competencia") %></td>
                                        <td>
                                            <span class="badge badge-<%# Eval("Status").ToString().ToLower() %>">
                                                <%# Eval("Status") %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="actions-cell">
                                                <!-- Pagar -->
                                                <asp:LinkButton ID="lnkPagar" runat="server" CommandName="Pagar" CommandArgument='<%# Eval("Id") %>' 
                                                    CssClass="btn-action pay" ToolTip="Marcar como Pago" Visible='<%# Eval("Status").ToString() == "Aberto" %>'>
                                                    <svg style="width:1.25rem;height:1.25rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                                                    </svg>
                                                </asp:LinkButton>
                                                
                                                <!-- Editar -->
                                                <asp:LinkButton ID="lnkEditar" runat="server" CommandName="Editar" CommandArgument='<%# Eval("Id") %>' 
                                                    CssClass="btn-action edit" ToolTip="Editar Lançamento" Visible='<%# Eval("Status").ToString() == "Aberto" %>'>
                                                    <svg style="width:1.25rem;height:1.25rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/>
                                                    </svg>
                                                </asp:LinkButton>
    
                                                <!-- Cancelar -->
                                                <asp:LinkButton ID="lnkCancelar" runat="server" CommandName="Cancelar" CommandArgument='<%# Eval("Id") %>' 
                                                    CssClass="btn-action cancel" ToolTip="Cancelar Lançamento" Visible='<%# Eval("Status").ToString() == "Aberto" %>'
                                                    OnClientClick="return confirm('Deseja realmente cancelar este lançamento?');">
                                                    <svg style="width:1.25rem;height:1.25rem;" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                                    </svg>
                                                </asp:LinkButton>
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                    <asp:Panel ID="pnlNoData" runat="server" Visible='<%# rptLancamentos.Items.Count == 0 %>'>
                                        <div class="empty-state">
                                            <svg fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"/>
                                            </svg>
                                            <p>Nenhum lançamento financeiro encontrado.</p>
                                        </div>
                                    </asp:Panel>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
