# Desafio Técnico: Controle de Lançamentos Financeiros

Esta aplicação é um sistema de controle de Lançamentos Financeiros construída seguindo as especificações do desafio técnico. A solução foi desenhada para ser limpa, performática, possuir um design premium e responsivo, e aderir aos requisitos de arquitetura (ADO.NET puro, sem ORMs e sem MVC).

---

## 🛠️ Stack Tecnológica

*   **Front-end**: ASP.NET Web Site (Páginas `.aspx`, CodeBehind `.aspx.cs` e Estilização CSS Nativa).
*   **Back-end**: C# (.NET Framework 4.8) estruturado em Class Libraries.
*   **Banco de Dados**: SQL Server LocalDB (`(localdb)\MSSQLLocalDB`).
*   **Acesso a Dados**: ADO.NET Puro (`SqlConnection`, `SqlCommand`, `SqlDataReader`).
*   **Editor/IDE**: Compatível com JetBrains Rider e Visual Studio.

---

## 🏗️ Arquitetura e Estrutura do Projeto

A solução está dividida em 3 camadas lógicas organizadas da seguinte forma:

```
/Desafio.slnx        # Arquivo de Solução do .NET
/Data/               # Camada de Acesso a Dados
  - ConnectionManager.cs (Gerenciador de Conexão ADO.NET)
  - LancamentoRepository.cs (Persistência e Consultas SQL puras)
  - Models/Lancamento.cs (Entidade Principal de Dados)
  - Script.sql (Scripts DDL de criação e DML de mock de dados)
/Business/           # Camada de Regras de Negócio e Validações
  - LancamentoBusiness.cs (Cálculos de Taxa/Desconto, Duplicidade, etc.)
/WebApp/             # Camada de Interface do Usuário (Web Forms Site)
  - Default.aspx (Página principal com Dashboard, Formulário e Grid)
  - Default.aspx.cs (Código de eventos do CodeBehind)
  - Web.config (String de conexão e parametrização do ASP.NET)
  - bin/ (Assemblies compilados das camadas Data e Business)
```

---

## 🚀 Como Executar o Projeto

### 1. Inicializar o Banco de Dados
A aplicação utiliza o SQL Server LocalDB. Certifique-se de que a instância padrão `MSSQLLocalDB` está criada e iniciada.
Execute o script em `Data/Script.sql` no seu banco de dados LocalDB para criar a base de dados `DesafioDB`, a tabela `Lancamentos` e alimentar com alguns registros fictícios de teste.

### 2. Compilar a Solução
Como o front-end é um **ASP.NET Web Site**, ele é compilado dinamicamente pelo servidor web. No entanto, as camadas de **Business** e **Data** precisam ser pré-compiladas.
Para sua comodidade, o arquivo `Business.csproj` possui uma tarefa de automação (Target MSBuild) que, ao compilar, copia automaticamente os arquivos `Business.dll` e `Data.dll` para a pasta `/WebApp/bin`.

Abra o terminal na pasta raiz do projeto e execute:
```bash
dotnet build
```

### 3. Hospedar e Rodar no IIS Express
Inicie o IIS Express apontando para a pasta física `/WebApp` na porta `51234`:
```bash
& "C:\Program Files\IIS Express\iisexpress.exe" /path:C:\Caminho\Ate\O\Projeto\WebApp /port:51234
```
Acesse no seu navegador: `http://localhost:51234/`

---

## 💡 Decisões Técnicas & Diferenciais

1. **Separação de Responsabilidades (N-Tier)**: Cada componente é isolado. A camada de `Data` cuida apenas de conexões e comandos SQL. A camada de `Business` centraliza toda a lógica de validação e cálculo, impedindo inconsistências e dados inválidos de chegarem ao banco.
2. **Cálculo Consistente no Back-end**: O campo `ValorCalculado` é calculado e validado inteiramente no C# antes de ser enviado ao banco de dados:
    *   **Crédito**: `ValorOriginal * (1 - PercentualDesconto / 100)`. Desconto obrigatório, Taxa zerada.
    *   **Débito**: `ValorOriginal * (1 + PercentualTaxa / 100)`. Taxa obrigatória, Desconto zerado.
3. **Preenchimento Inteligente (UX)**: Ao selecionar a Data do Lançamento no formulário, um script em Javascript calcula e sugere automaticamente a Competência contábil no formato `MM/AAAA`. Além disso, os inputs de Taxa e Desconto se habilitam/desabilitam de forma dinâmica baseado no tipo de lançamento.
4. **Exportação Premium para Excel (CSV)**: O arquivo CSV gerado no servidor inclui a marcação de bytes **UTF-8 BOM (`\uFEFF`)** no início do fluxo. Isso garante que o Excel abra o arquivo diretamente, reconhecendo corretamente caracteres com acentos (como Crédito/Débito) e o símbolo monetário `R$`.
5. **Relatório Pronto para Impressão (PDF)**: O CSS do projeto inclui regras `@media print` personalizadas. Ao clicar em "Imprimir Relatório", todos os botões, filtros e formulários são ocultados automaticamente, gerando um layout de extrato financeiro limpo, corporativo e pronto para ser impresso ou salvo como PDF pelo navegador.
