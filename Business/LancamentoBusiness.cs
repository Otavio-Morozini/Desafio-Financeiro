using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using Data;
using Data.Models;

namespace Business
{
    public class LancamentoBusiness
    {
        private readonly LancamentoRepository _repository;

        public LancamentoBusiness()
        {
            _repository = new LancamentoRepository();
        }

        public List<Lancamento> Listar(string competencia = null, string status = null, string tipo = null)
        {
            return _repository.Listar(competencia, status, tipo);
        }

        public Lancamento ObterPorId(int id)
        {
            return _repository.ObterPorId(id);
        }

        public void Inserir(Lancamento model)
        {
            Validar(model);

            // Regra: Não pode existir lançamento duplicado com a mesma competência, descrição e tipo.
            if (_repository.ExisteDuplicado(model.Competencia, model.Descricao, model.Tipo))
            {
                throw new InvalidOperationException("Já existe um lançamento cadastrado com esta mesma competência, descrição e tipo.");
            }

            model.Status = "Aberto";
            model.DataPagamento = null;
            model.DataCancelamento = null;
            model.DataCriacao = DateTime.Now;

            CalcularValorCalculado(model);

            _repository.Inserir(model);
        }

        public void Atualizar(Lancamento model)
        {
            var existente = _repository.ObterPorId(model.Id);
            if (existente == null)
            {
                throw new KeyNotFoundException("Lançamento não encontrado.");
            }

            // Regra: Edição permitida apenas para lançamentos com status Aberto.
            if (existente.Status != "Aberto")
            {
                throw new InvalidOperationException("Apenas lançamentos com status 'Aberto' podem ser editados.");
            }

            Validar(model);

            // Regra: Não pode existir lançamento duplicado com a mesma competência, descrição e tipo.
            if (_repository.ExisteDuplicado(model.Competencia, model.Descricao, model.Tipo, model.Id))
            {
                throw new InvalidOperationException("Já existe outro lançamento cadastrado com esta mesma competência, descrição e tipo.");
            }

            // Preservar campos que não podem ser editados
            model.Status = existente.Status;
            model.DataCriacao = existente.DataCriacao;
            model.DataPagamento = existente.DataPagamento;
            model.DataCancelamento = existente.DataCancelamento;

            CalcularValorCalculado(model);

            _repository.Atualizar(model);
        }

        public void Pagar(int id)
        {
            var existente = _repository.ObterPorId(id);
            if (existente == null)
            {
                throw new KeyNotFoundException("Lançamento não encontrado.");
            }

            if (existente.Status != "Aberto")
            {
                throw new InvalidOperationException("Apenas lançamentos com status 'Aberto' podem ser pagos.");
            }

            _repository.AtualizarStatus(id, "Pago", DateTime.Now, null);
        }

        public void Cancelar(int id)
        {
            var existente = _repository.ObterPorId(id);
            if (existente == null)
            {
                throw new KeyNotFoundException("Lançamento não encontrado.");
            }

            if (existente.Status != "Aberto")
            {
                throw new InvalidOperationException("Apenas lançamentos com status 'Aberto' podem ser cancelados.");
            }

            _repository.AtualizarStatus(id, "Cancelado", null, DateTime.Now);
        }

        public decimal ObterSaldoTotal()
        {
            var todos = _repository.Listar(status: "Pago");
            decimal saldo = 0;
            foreach (var item in todos)
            {
                if (item.Tipo == "Credito")
                {
                    saldo += item.ValorCalculado;
                }
                else if (item.Tipo == "Debito")
                {
                    saldo -= item.ValorCalculado;
                }
            }
            return saldo;
        }

        public decimal ObterValorPendente()
        {
            var todos = _repository.Listar(status: "Aberto");
            decimal total = 0;
            foreach (var item in todos)
            {
                if (item.Tipo == "Credito")
                {
                    total += item.ValorCalculado;
                }
                else if (item.Tipo == "Debito")
                {
                    total -= item.ValorCalculado;
                }
            }
            return total;
        }

        public int ObterQuantidadeCancelados()
        {
            return _repository.Listar(status: "Cancelado").Count;
        }

        private void Validar(Lancamento model)
        {
            if (string.IsNullOrWhiteSpace(model.Descricao))
            {
                throw new ArgumentException("A descrição é obrigatória.");
            }

            if (model.Tipo != "Credito" && model.Tipo != "Debito")
            {
                throw new ArgumentException("O tipo de lançamento deve ser 'Credito' ou 'Debito'.");
            }

            if (model.ValorOriginal <= 0)
            {
                throw new ArgumentException("O valor original deve ser maior que zero.");
            }

            if (string.IsNullOrWhiteSpace(model.Competencia) || !Regex.IsMatch(model.Competencia, @"^(0[1-9]|1[0-2])\/\d{4}$"))
            {
                throw new ArgumentException("A competência é obrigatória e deve estar no formato MM/AAAA.");
            }

            if (model.DataLancamento == DateTime.MinValue)
            {
                throw new ArgumentException("A data do lançamento é obrigatória.");
            }

            // Regra: Taxa somente para Débito. Desconto somente para Crédito. Ambos são obrigatórios em seus respectivos Tipos.
            if (model.Tipo == "Credito")
            {
                if (model.PercentualTaxa != 0)
                {
                    throw new ArgumentException("A taxa só pode ser aplicada a lançamentos do tipo Débito.");
                }
                if (model.PercentualDesconto < 0)
                {
                    throw new ArgumentException("O percentual de desconto não pode ser negativo.");
                }
            }
            else // Debito
            {
                if (model.PercentualDesconto != 0)
                {
                    throw new ArgumentException("O desconto só pode ser aplicado a lançamentos do tipo Crédito.");
                }
                if (model.PercentualTaxa < 0)
                {
                    throw new ArgumentException("O percentual de taxa não pode ser negativo.");
                }
            }
        }

        private void CalcularValorCalculado(Lancamento model)
        {
            if (model.Tipo == "Credito")
            {
                model.ValorCalculado = model.ValorOriginal * (1 - model.PercentualDesconto / 100);
            }
            else // Debito
            {
                model.ValorCalculado = model.ValorOriginal * (1 + model.PercentualTaxa / 100);
            }
        }
    }
}
