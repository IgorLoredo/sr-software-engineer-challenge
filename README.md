# Senior Software Engineer Challenge

Desafio Senior Software Engineer

## Resumo
* [Preparando o Ambiente](#setup_environment)
* [Desafio](#desafio)
    * [Pontos que daremos mais atenção](#pontos_atencao)
    * [Pontos que não iremos avaliar](#pontos_sem_avaliacao)
    * [Observações importantes](#observacoes)
* [Sobre a documentação](#about_docs)
    * [Como esperamos receber sua solução](#como_esperamos_receber)
* [Dicas](#dicas)

### <a name="setup_environment">Preparando o Ambiente</a>

Tecnologias necessárias para o desafio:

- JDK11 ou JDK17
- Docker
- Maven ou Gradle
- IntelliJ ou Eclipse (ou qualquer outra IDE de sua preferência)
- Postman ou Insomnia (ou qualquer outra ferramenta de sua preferência)

### <a name="desafio">Desafio</a>

A seguradora ACME precisa de uma API REST capaz de receber e consultar cotações de seguro interagindo com outros sistemas conforme o desenho abaixo:

<img src="/assets/img/arch.png" alt="Arquitetura Proposta" title="Arquitetura Proposta"/>

O corpo da requisição a ser recebida deve seguir o seguinte formato:

```json
{
    "product_id": "1b2da7cc-b367-4196-8a78-9cfeec21f587",
    "offer_id": "adc56d77-348c-4bf0-908f-22d402ee715c",
    "category": "HOME",
    "total_monthly_premium_amount": 75.25,
    "total_coverage_amount": 825000.00,
    "coverages": {
      "Incêndio": 250000.00,
      "Desastres naturais": 500000.00,
      "Responsabiliadade civil": 75000.00
    },
    "assistances": [
      "Encanador",
      "Eletricista",
      "Chaveiro 24h"
    ],
    "customer": {
        "document_number": "36205578900",
        "name": "John Wick",
        "type": "NATURAL",
        "gender": "MALE",
        "date_of_birth": "1973-05-02",
        "email": "johnwick@gmail.com",
        "phone_number": 11950503030
    }
}
```

Ao receber a requisição é necessário validar a oferta e o produto informados consultando a API do serviço de Catálogo. 

Os seguintes itens devem ser validados:

- O produto e oferta são **existentes** e estão **ativos**
- As **coberturas informadas** estão dentro da lista de cobertuas da oferta
- As **assistências informadas** estão dentro da lista de assistências da oferta
- O **valor total do prêmio mensal** está entre o **máximo** e **mínimo** definido para a oferta
- O **valor total das coberturas** corresponde a somatória das coberturas informadas

Os campos dos dados do cliente são **livres**.

Caso a solicitação seja **válida** é necessário persistir a cotação em um **banco de dados** de sua preferência gerando um identificador único em formato **numérico** e publicar um evento em formato **avro** via tópico kafka da cotação recebida.

Se a solicitação for **inválida** é necessário retornar um erro na chamada da API para que cliente corrija os dados e tente novamente.

Após publicar o evento da cotação recebida o serviço de apólices irá emitir a apólice e publicar um evento de apólice emitida em formato **avro** em outro tópico kafka.

O serviço de cotação deverá então receber este evento (apólice emitida) e atualizar a cotação com o número da apólice gerada.

Abaixo os tópicos e avros necessários para esta integração:

| Tópico                              | Descrição                    | Avro                                                                                    |
|-------------------------------------|------------------------------|-----------------------------------------------------------------------------------------|
| itausegdev-insurance-quote-received | Tópico de cotações recebidas | [Clique Aqui](schemas/br.itausegdev.quotes.schemas.insurance_quote_received.avsc)   |  
| itausegdev-insurance-policy-emitted | Tópico de apólices emitidas  | [Clique Aqui](schemas/br.itausegdev.policies.schemas.insurance_policy_emitted.avsc) |  

Caso esteja utilizando Windows na raiz do projeto execute o seguinte comando antes de iniciar o docker compose.

```shell script
  git config core.autocrlf false
```

A raiz deste projeto contém um arquivo **docker-compose.yml** com toda infraestrutura necessária para o desafio, basta clonar o repositório e executar o seguinte comando:

```shell script
 docker-compose up -d
```

Após todos os serviços estarem executando você pode consultar a documentação da API de catálogo através do seguinte endpoint:

```shell script
 http://localhost:8080/swagger-ui
```

 **Observação:** As categorias, produtos e ofertas já estão cadastrados no serviço de catálogo, então não é necessário se preocupar em adicionar mais dados a esta API.

<img src="/assets/img/swagger.png"/>

> **ATENÇÃO:** Não se preocupe com a criação dos tópicos e schema registry, eles serão provisionados juntamente com a infraestrutura fornecida.


O endpoint de consulta da cotação de seguro deverá conter os seguintes campos:

```json
{
    "id": 22345,
    "insurance_policy_id": 756969,
    "product_id": "1b2da7cc-b367-4196-8a78-9cfeec21f587",
    "offer_id": "adc56d77-348c-4bf0-908f-22d402ee715c",
    "category": "HOME",
    "created_at": "2024-05-22T20:37:17.090098",
    "updated_at": "2024-05-22T21:05:02.090098",
    "total_monthly_premium_amount": 75.25,
    "total_coverage_amount": 825000.00,
    "coverages": {
      "Incêndio": 250000.00,
      "Desastres naturais": 500000.00,
      "Responsabiliadade civil": 75000.00
    },
    "assistances": [
      "Encanador",
      "Eletricista",
      "Chaveiro 24h"
    ],
    "customer": {
        "document_number": "36205578900",
        "name": "John Wick",
        "type": "NATURAL",
        "gender": "MALE",
        "date_of_birth": "1973-05-02",
        "email": "johnwick@gmail.com",
        "phone_number": 11950503030
    }
}
```

Abaixo deixamos um resumo de todos os requisitos para que você possa fazer um checklist antes de entregar o desafio:

| Requisito                                                                                           | Observações                                                                         |
|-----------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| <ul><li>[ ] Desenvolvimento do endpoint para receber as cotações de seguro</li></ul>                | Caso prefira pode documentar a API com OpenAPI                                      |
| <ul><li>[ ] Validação do produto e oferta da requisião</li></ul>                                    | O serviço de catálogo já é dado no desafio em uma imagem Docker                     |
| <ul><li>[ ] Persistência da cotação de seguro recebida</li></ul>                                    | O banco de dados pode ser de sua preferência, porém deve utilizar uma imagem Docker |
| <ul><li>[ ] Envio da mensagem da cotação recebida no tópico kafka</li></ul>                         | Apache Kafka, serviço apólice e avros já estão disponibilizados no desafio          |
| <ul><li>[ ] Recebimento da mensagem da apólice emitida no tópico kafka</li></ul>                    | Apache Kafka, serviço apólice e avros já estão disponibilizados no desafio          |
| <ul><li>[ ] Atualização da cotação de seguro no banco de dados com os dados da apólice</li></ul>    | O evento da apólice emitida contém a o ID da cotação                                |
| <ul><li>[ ] Desenvolvimento do(s) endpoint(s) para consulta da(s) cotação(ões) de seguro</li></ul>  | Caso prefira pode documentar a API com OpenAPI                                      |

### <a name="pontos_atencao">Pontos que daremos mais atenção</a>
- Testes de unidade e integração
- Cobertura de testes (Code Coverage)
- Arquitetura utilizada
- Abstração, acoplamento, extensibilidade e coesão
- Profundidade na utilização de Design Patterns
- Clean Architecture
- Clean Code
- SOLID
- Documentação da Solução no README.md
- Observabilidade (métricas, traces e logs)

### <a name="pontos_sem_avaliacao">Pontos que não iremos avaliar</a>
- Dockerfile
- Scripts CI/CD
- Collections do Postman, Insomnia ou qualquer outra ferramenta para execução

## <a name="about_docs">Sobre a documentação</a>
Nesta etapa do processo seletivo queremos entender as decisões por trás do código, portanto é fundamental que o README.md tenha algumas informações referentes a sua solução.

Algumas dicas do que esperamos ver são:
- Instruções básicas de como executar o projeto
- Detalhes sobre a solução, gostaríamos de saber qual foi o seu racional nas decisões
- Caso algo não esteja claro e você precisou assumir alguma premissa, quais foram e o que te motivou a tomar essas decisões

### <a name="como_esperamos_receber">Como esperamos receber sua solução</a>
Esta etapa é eliminatória, e por isso esperamos que o código reflita essa importância.

Se tiver algum imprevisto, dúvida ou problema, por favor entre em contato com a gente, estamos aqui para ajudar.

Atualmente trabalhamos com a stack Java/Spring, porém você pode utilizar a tecnologia de sua preferência.

Para candidatos externos nos envie o link de um repositório público com a sua solução e para candidatos internos o projeto em formato .zip

### <a name="observacoes">Observações importantes</a>

Não é necessário parametrizar os impostos em arquivos de configuração ou persisti-los em base de dados.
Os campos a serem persistidos devem ser somente os informados no <a name="desafio">desafio</a>.

## <a name="dicas">Dicas</a>

Aqui vão algumas dicas que podem ser úteis.

### <a name="testes">Testes</a>
Como item opcional de leitura, deixamos este artigo rápido sobre testes [Testing Strategies in a Microservice Architecture](https://martinfowler.com/articles/microservice-testing/).

Nele é possível ver a diferença entre os principais tipos de teste.

<img src="assets/img/piramide.png" alt="Piramide" title="Piramide">

Também há um exemplo para cada tipo de teste no artigo que pode ajudar no desafio.

<img src="assets/img/tipos_teste.png" alt="Tipos de Teste" title="Tipos de Teste">


