-- =============================================================================
-- FITLIFE GYM MANAGEMENT SYSTEM
-- Schema MySQL — gerado com base no MER, Modelo Lógico e Estudo de Caso
-- Versão: 1.0
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------------------------------
-- DATABASE
-- -----------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS fitlife
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE fitlife;

-- =============================================================================
-- BLOCO 1 — ESTRUTURA BASE (sem dependências externas)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- MODALIDADE
-- -----------------------------------------------------------------------------
CREATE TABLE modalidade (
    cod_modalidade  INT UNSIGNED      NOT NULL AUTO_INCREMENT,
    nome_mod        VARCHAR(80)       NOT NULL,
    descricao       TEXT,
    duracao         SMALLINT UNSIGNED NOT NULL COMMENT 'Duração em minutos',
    dificuldade     ENUM('Iniciante','Intermediário','Avançado') NOT NULL,
    CONSTRAINT pk_modalidade        PRIMARY KEY (cod_modalidade),
    CONSTRAINT uq_modalidade_nome   UNIQUE (nome_mod)
) ENGINE=InnoDB COMMENT='Modalidades de aula coletiva';


-- -----------------------------------------------------------------------------
-- PLANO
-- -----------------------------------------------------------------------------
CREATE TABLE plano (
    cod_plano       INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nome_plano      VARCHAR(100)    NOT NULL,
    descricao       TEXT,
    valor           DECIMAL(10,2)   NOT NULL,
    duracao         SMALLINT UNSIGNED NOT NULL COMMENT 'Duração em dias',
    CONSTRAINT pk_plano PRIMARY KEY (cod_plano)
) ENGINE=InnoDB COMMENT='Planos de assinatura';


-- =============================================================================
-- BLOCO 2 — UNIDADE E PROFESSOR
-- Estratégia: UNIDADE sem FK de gerente → PROFESSOR → ALTER TABLE adiciona FK
-- =============================================================================

CREATE TABLE unidade (
    cod_unidade         INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    endereco            VARCHAR(255)    NOT NULL,
    telefone            VARCHAR(20)     NOT NULL,
    horario_func        VARCHAR(100)    NOT NULL COMMENT 'Ex.: Seg-Sex 06:00–22:00',
    cref_gerente        VARCHAR(20)     NULL,
    CONSTRAINT pk_unidade PRIMARY KEY (cod_unidade)
) ENGINE=InnoDB COMMENT='Unidades (filiais) da FitLife';


CREATE TABLE professor (
    cref                VARCHAR(20)     NOT NULL,
    nome_prof           VARCHAR(150)    NOT NULL,
    cpf                 CHAR(11)        NOT NULL,
    e_mail              VARCHAR(150)    NOT NULL,
    telefone            VARCHAR(20)     NOT NULL,
    cref_supervisor     VARCHAR(20)     NULL COMMENT 'Auto-relacionamento: supervisor',
    CONSTRAINT pk_professor         PRIMARY KEY (cref),
    CONSTRAINT uq_professor_cpf     UNIQUE (cpf),
    CONSTRAINT uq_professor_email   UNIQUE (e_mail),
    CONSTRAINT fk_prof_supervisor   FOREIGN KEY (cref_supervisor)
        REFERENCES professor (cref)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Cadastro geral de professores';


-- FK de gerente adicionada após criação de professor
ALTER TABLE unidade
    ADD CONSTRAINT fk_unidade_gerente
        FOREIGN KEY (cref_gerente)
        REFERENCES professor (cref)
        ON DELETE SET NULL
        ON UPDATE CASCADE;


-- -----------------------------------------------------------------------------
-- CLT — subtipo de PROFESSOR; atua em UMA única unidade
-- -----------------------------------------------------------------------------
CREATE TABLE clt (
    cref              VARCHAR(20)       NOT NULL,
    salario_fixo      DECIMAL(10,2)     NOT NULL,
    carga_horaria     SMALLINT UNSIGNED NOT NULL COMMENT 'Horas semanais',
    data_admissao     DATE              NOT NULL,
    cod_unidade       INT UNSIGNED      NOT NULL,
    CONSTRAINT pk_clt           PRIMARY KEY (cref),
    CONSTRAINT fk_clt_prof      FOREIGN KEY (cref)
        REFERENCES professor (cref)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_clt_unidade   FOREIGN KEY (cod_unidade)
        REFERENCES unidade (cod_unidade)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Professores contratados no regime CLT';


-- -----------------------------------------------------------------------------
-- PJ — subtipo de PROFESSOR; pode atuar em múltiplas unidades
-- -----------------------------------------------------------------------------
CREATE TABLE pj (
    cref                      VARCHAR(20)  NOT NULL,
    cnpj                      CHAR(14)     NOT NULL,
    valor_hora_aula           DECIMAL(10,2) NOT NULL,
    disponibilidade_horarios  TEXT         COMMENT 'Descrição de disponibilidade',
    CONSTRAINT pk_pj        PRIMARY KEY (cref),
    CONSTRAINT uq_pj_cnpj   UNIQUE (cnpj),
    CONSTRAINT fk_pj_prof   FOREIGN KEY (cref)
        REFERENCES professor (cref)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Professores autônomos (PJ)';


-- -----------------------------------------------------------------------------
-- TRABALHA_EM_PJ — N:M entre PJ e UNIDADE
-- -----------------------------------------------------------------------------
CREATE TABLE trabalha_em_pj (
    cref_pj         VARCHAR(20)  NOT NULL,
    cod_unidade     INT UNSIGNED NOT NULL,
    CONSTRAINT pk_trabalha_em_pj    PRIMARY KEY (cref_pj, cod_unidade),
    CONSTRAINT fk_trab_pj_prof      FOREIGN KEY (cref_pj)
        REFERENCES pj (cref)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_trab_pj_unidade   FOREIGN KEY (cod_unidade)
        REFERENCES unidade (cod_unidade)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Unidades em que cada professor PJ atua';


-- =============================================================================
-- BLOCO 3 — ALUNO
-- =============================================================================

CREATE TABLE aluno (
    cpf                 CHAR(11)     NOT NULL,
    nome_aluno          VARCHAR(150) NOT NULL,
    data_nascimento     DATE         NOT NULL,
    endereco_aluno      VARCHAR(255) NOT NULL,
    telefone_aluno      VARCHAR(20)  NOT NULL,
    e_mail              VARCHAR(150) NOT NULL,
    restricoes          TEXT         COMMENT 'Restrições médicas',
    CONSTRAINT pk_aluno         PRIMARY KEY (cpf),
    CONSTRAINT uq_aluno_email   UNIQUE (e_mail)
) ENGINE=InnoDB COMMENT='Alunos matriculados na FitLife';


-- =============================================================================
-- BLOCO 4 — CONTRATO, PAGAMENTO E FATURA
-- =============================================================================

CREATE TABLE contrato_plano (
    num_contrato        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cpf_aluno           CHAR(11)     NOT NULL,
    cod_plano           INT UNSIGNED NOT NULL,
    cod_unidade         INT UNSIGNED NOT NULL,
    data_inicio         DATE         NOT NULL,
    data_vencimento     DATE         NOT NULL,
    status              ENUM('Ativo','Cancelado','Expirado') NOT NULL DEFAULT 'Ativo',
    CONSTRAINT pk_contrato          PRIMARY KEY (num_contrato),
    CONSTRAINT fk_contrato_aluno    FOREIGN KEY (cpf_aluno)
        REFERENCES aluno (cpf)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_contrato_plano    FOREIGN KEY (cod_plano)
        REFERENCES plano (cod_plano)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_contrato_unidade  FOREIGN KEY (cod_unidade)
        REFERENCES unidade (cod_unidade)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_contrato_datas   CHECK (data_vencimento > data_inicio)
) ENGINE=InnoDB COMMENT='Contratos de plano dos alunos (histórico completo)';


CREATE TABLE pagamento (
    cod_pagamento   INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    num_contrato    INT UNSIGNED  NOT NULL,
    forma_pagamento ENUM('PIX','Cartão de Crédito','Cartão de Débito','Boleto','Dinheiro') NOT NULL,
    valor           DECIMAL(10,2) NOT NULL,
    vencimento      DATE          NOT NULL,
    status_pag      ENUM('Pago','Pendente','Atrasado','Cancelado') NOT NULL DEFAULT 'Pendente',
    CONSTRAINT pk_pagamento             PRIMARY KEY (cod_pagamento),
    CONSTRAINT fk_pagamento_contrato    FOREIGN KEY (num_contrato)
        REFERENCES contrato_plano (num_contrato)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Cobranças geradas por contrato';


CREATE TABLE fatura (
    cod_fatura      INT UNSIGNED NOT NULL AUTO_INCREMENT,
    cod_pagamento   INT UNSIGNED NOT NULL,
    tipo_fatura     VARCHAR(60)  NOT NULL COMMENT 'Ex.: NF-e, Recibo, NFSe',
    CONSTRAINT pk_fatura            PRIMARY KEY (cod_fatura),
    CONSTRAINT fk_fatura_pagamento  FOREIGN KEY (cod_pagamento)
        REFERENCES pagamento (cod_pagamento)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Faturas emitidas a partir de pagamentos';


-- =============================================================================
-- BLOCO 5 — TURMA, INSCRIÇÃO E AVALIAÇÃO FÍSICA
-- =============================================================================

CREATE TABLE turma (
    cod_turma       INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    cod_modalidade  INT UNSIGNED  NOT NULL,
    cod_unidade     INT UNSIGNED  NOT NULL,
    cref_professor  VARCHAR(20)   NOT NULL,
    capacidade      SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT pk_turma             PRIMARY KEY (cod_turma),
    CONSTRAINT fk_turma_modalidade  FOREIGN KEY (cod_modalidade)
        REFERENCES modalidade (cod_modalidade)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_turma_unidade     FOREIGN KEY (cod_unidade)
        REFERENCES unidade (cod_unidade)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_turma_professor   FOREIGN KEY (cref_professor)
        REFERENCES professor (cref)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Turmas de aulas coletivas';


CREATE TABLE inscricao (
    cpf_aluno   CHAR(11)     NOT NULL,
    cod_turma   INT UNSIGNED NOT NULL,
    CONSTRAINT pk_inscricao     PRIMARY KEY (cpf_aluno, cod_turma),
    CONSTRAINT fk_insc_aluno    FOREIGN KEY (cpf_aluno)
        REFERENCES aluno (cpf)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_insc_turma    FOREIGN KEY (cod_turma)
        REFERENCES turma (cod_turma)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Inscrições de alunos em turmas';


-- Coluna IMC calculada automaticamente (GENERATED STORED)
CREATE TABLE avaliacao_fisica (
    cod_avaliacao       INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    cpf_aluno           CHAR(11)      NOT NULL,
    cref_professor_clt  VARCHAR(20)   NOT NULL COMMENT 'Somente professor CLT',
    data_avaliacao      DATE          NOT NULL,
    peso                DECIMAL(5,2)  NOT NULL COMMENT 'kg',
    altura              DECIMAL(4,2)  NOT NULL COMMENT 'metros',
    imc                 DECIMAL(5,2)  GENERATED ALWAYS AS (peso / (altura * altura)) STORED,
    percentual_gordura  DECIMAL(5,2),
    circunferencias     JSON          COMMENT 'cintura, quadril, braço, coxa… em cm',
    CONSTRAINT pk_avaliacao         PRIMARY KEY (cod_avaliacao),
    CONSTRAINT fk_aval_aluno        FOREIGN KEY (cpf_aluno)
        REFERENCES aluno (cpf)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_aval_professor    FOREIGN KEY (cref_professor_clt)
        REFERENCES clt (cref)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB COMMENT='Histórico de avaliações físicas';


-- =============================================================================
-- BLOCO 6 — ÍNDICES DE PERFORMANCE
-- =============================================================================

CREATE INDEX idx_aluno_nome         ON aluno (nome_aluno);
CREATE INDEX idx_contrato_aluno     ON contrato_plano (cpf_aluno);
CREATE INDEX idx_contrato_status    ON contrato_plano (status);
CREATE INDEX idx_contrato_venc      ON contrato_plano (data_vencimento);
CREATE INDEX idx_pag_contrato       ON pagamento (num_contrato);
CREATE INDEX idx_pag_status         ON pagamento (status_pag);
CREATE INDEX idx_pag_vencimento     ON pagamento (vencimento);
CREATE INDEX idx_turma_unidade      ON turma (cod_unidade);
CREATE INDEX idx_turma_modalidade   ON turma (cod_modalidade);
CREATE INDEX idx_turma_prof         ON turma (cref_professor);
CREATE INDEX idx_aval_aluno         ON avaliacao_fisica (cpf_aluno);
CREATE INDEX idx_aval_data          ON avaliacao_fisica (data_avaliacao);
CREATE INDEX idx_prof_supervisor    ON professor (cref_supervisor);


-- =============================================================================
-- BLOCO 7 — VIEWS ÚTEIS
-- =============================================================================

-- Alunos com contrato ativo e unidade atual
CREATE OR REPLACE VIEW vw_alunos_ativos AS
SELECT
    a.cpf,
    a.nome_aluno,
    pl.nome_plano,
    u.cod_unidade,
    u.endereco          AS unidade_endereco,
    c.data_inicio,
    c.data_vencimento
FROM aluno a
JOIN contrato_plano c   ON c.cpf_aluno   = a.cpf  AND c.status = 'Ativo'
JOIN plano          pl  ON pl.cod_plano   = c.cod_plano
JOIN unidade        u   ON u.cod_unidade  = c.cod_unidade;


-- Professores com tipo de vínculo empregatício
CREATE OR REPLACE VIEW vw_professores_tipo AS
SELECT
    pr.cref,
    pr.nome_prof,
    pr.cpf,
    pr.e_mail,
    CASE
        WHEN cl.cref IS NOT NULL THEN 'CLT'
        WHEN pj.cref IS NOT NULL THEN 'PJ'
        ELSE 'Indefinido'
    END                 AS tipo_contrato,
    cl.cod_unidade      AS unidade_clt,
    cl.data_admissao,
    cl.salario_fixo,
    pj.cnpj,
    pj.valor_hora_aula
FROM professor pr
LEFT JOIN clt cl ON cl.cref = pr.cref
LEFT JOIN pj  pj ON pj.cref = pr.cref;


-- Turmas com vagas disponíveis
CREATE OR REPLACE VIEW vw_turmas_vagas AS
SELECT
    t.cod_turma,
    m.nome_mod              AS modalidade,
    u.endereco              AS unidade,
    p.nome_prof             AS professor,
    t.capacidade,
    COUNT(i.cpf_aluno)      AS inscritos,
    t.capacidade - COUNT(i.cpf_aluno) AS vagas_disponiveis
FROM turma t
JOIN modalidade m   ON m.cod_modalidade = t.cod_modalidade
JOIN unidade    u   ON u.cod_unidade    = t.cod_unidade
JOIN professor  p   ON p.cref           = t.cref_professor
LEFT JOIN inscricao i ON i.cod_turma    = t.cod_turma
GROUP BY t.cod_turma, m.nome_mod, u.endereco, p.nome_prof, t.capacidade;


-- Histórico de pagamentos por aluno
CREATE OR REPLACE VIEW vw_historico_pagamentos AS
SELECT
    a.cpf,
    a.nome_aluno,
    pl.nome_plano,
    pg.cod_pagamento,
    pg.forma_pagamento,
    pg.valor,
    pg.vencimento,
    pg.status_pag
FROM aluno a
JOIN contrato_plano c   ON c.cpf_aluno      = a.cpf
JOIN plano          pl  ON pl.cod_plano      = c.cod_plano
JOIN pagamento      pg  ON pg.num_contrato   = c.num_contrato
ORDER BY a.nome_aluno, pg.vencimento;


-- =============================================================================
-- BLOCO 8 — TRIGGERS DE INTEGRIDADE DE NEGÓCIO
-- =============================================================================

DELIMITER $$

-- Avaliação física somente por professor CLT
CREATE TRIGGER trg_aval_somente_clt
BEFORE INSERT ON avaliacao_fisica
FOR EACH ROW
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM clt WHERE cref = NEW.cref_professor_clt
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Avaliação física deve ser conduzida por professor CLT.';
    END IF;
END$$


-- Professor não pode ter vínculo CLT e PJ simultaneamente
CREATE TRIGGER trg_sem_duplo_vinculo_clt
BEFORE INSERT ON clt
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM pj WHERE cref = NEW.cref) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Professor já possui vínculo PJ — não pode ter CLT ao mesmo tempo.';
    END IF;
END$$

CREATE TRIGGER trg_sem_duplo_vinculo_pj
BEFORE INSERT ON pj
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM clt WHERE cref = NEW.cref) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Professor já possui vínculo CLT — não pode ter PJ ao mesmo tempo.';
    END IF;
END$$


-- Professor CLT não pode ser inserido em TRABALHA_EM_PJ
CREATE TRIGGER trg_pj_nao_e_clt
BEFORE INSERT ON trabalha_em_pj
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM clt WHERE cref = NEW.cref_pj) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Professor CLT não pode ter vínculo multi-unidade via tabela PJ.';
    END IF;
END$$

DELIMITER ;

-- =============================================================================
-- FIM DO SCHEMA FITLIFE
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 1;
