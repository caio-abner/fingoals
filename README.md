# 🎯 FinGoals

**FinGoals** é um aplicativo financeiro multiplataforma desenvolvido focado na centralização da gestão financeira pessoal. Ele unifica o controle de fluxo de caixa diário (Orçamento), o planejamento de objetivos a curto/médio prazo (Metas) e a visão consolidada de patrimônio (Investimentos) em uma única interface inteligente, limpa e responsiva.

---

## 🎓 Contexto Acadêmico

Este projeto foi desenvolvido como requisito de avaliação parcial da disciplina **SSC0961 - Desenvolvimento Web e Mobile**, oferecida pelo **Instituto de Ciências Matemáticas e de Computação (ICMC) da Universidade de São Paulo (USP)**, sob a docência da Profa. Dra. Lina Garcés.

### Requisitos do Projeto Atendidos
* **Multiplataforma Nativo:** Desenvolvido para ser executado nativamente em navegadores web e em plataformas mobile (iOS e Android) a partir de uma única base de código.
* **Foco em UI/UX e MVP:** O projeto prioriza a entrega de um Produto Mínimo Viável (MVP) funcional, com design de interface fiel aos protótipos de alta fidelidade desenhados no Figma, garantindo uma ótima experiência de usuário.
* **Testes e Qualidade:** Implementação de testes funcionais orientados a widgets para garantir a estabilidade do fluxo de navegação e componentes críticos.
* **Modularização:** Arquitetura limpa com separação de responsabilidades, componentes visuais e gerenciamento de estado independente por tela.

---

## ✨ Principais Funcionalidades

O aplicativo é estruturado através de uma navegação lateral adaptativa (Web-first) e oferece as seguintes ferramentas:

* **📊 Dashboard Integrado:** Visão macro do saldo total, resumo de limite de gastos mensais e atalhos rápidos para as metas principais e carteira de investimentos.
* **🚩 Minhas Metas:** Acompanhamento visual (em formato de cards de progresso) de objetivos financeiros específicos, facilitando o engajamento com a poupança.
* **💳 Orçamento:** Gestão de limites de gastos divididos por categorias (ex: Alimentação, Transporte) com indicadores visuais de consumo.
* **📈 Portfólio (Investimentos):** Gráficos interativos renderizados nativamente evidenciando a evolução do patrimônio (gráfico de linha) e a distribuição percentual entre ativos de Renda Fixa e Variável (gráfico de rosca).

---

## 🛠️ Tecnologias Utilizadas

* **Framework:** [Flutter](https://flutter.dev/) (SDK 3.x)
* **Linguagem:** Dart
* **Gráficos e Visualização de Dados:** `fl_chart`
* **Gerenciamento de Estado:** Nativo (`setState` e passagem de Callbacks)
* **Design Pattern:** Componentização em Widgets (Orientação a Objetos estrita)

---

## 🔐 Acesso para Avaliação (Testes)

Para facilitar a correção e exploração das funcionalidades do projeto, o aplicativo injeta automaticamente uma conta de testes no banco de dados local (`SharedPreferences`) logo na primeira inicialização. Essa conta já possui exemplos para demonstrar a interface gráfica.

**Credenciais de Acesso Padrão:**
* **E-mail:** `caio_abner@usp.br`
* **Senha:** `1234`

*(Nota: Sinta-se à vontade para utilizar esta conta de testes ou criar uma conta "novinha em folha" através da tela de Cadastro para testar a funcionalidade de isolamento de banco de dados).*