-- ============================================================
-- ATIVIDADE PRÁTICA: MANIPULAÇÃO DE DADOS NA BIBLIOTECA
-- Banco de Dados: MySQL / Compatível
-- ============================================================

-- ============================================================
-- ETAPA 1 — EXCLUSÃO, LIMPEZA E RECARGA INICIAL
-- ============================================================

-- 01. Remover somente o registro duplicado de 'O Cortiço' de id = 71
-- Conferência prévia:
SELECT * FROM tb_livros WHERE id = 71;

-- Exclusão:
DELETE FROM tb_livros WHERE id = 71;

-- 02. Remover todos os registros restantes preservando a estrutura
TRUNCATE TABLE tb_livros;

-- 03. Recarga original e confirmação
-- (Insira os 71 INSERTs da carga original aqui)
SELECT COUNT(*) AS total_registros FROM tb_livros;


-- ============================================================
-- ETAPA 2 — INSERÇÃO DE NOVOS LIVROS
-- ============================================================

-- 01. Insira 'A Montanha Mágica' (id = 72, disponivel = TRUE)
INSERT INTO tb_livros (id, titulo, autor, ano_publicacao, disponivel)
VALUES (72, 'A Montanha Mágica', 'Thomas Mann', 1924, TRUE);

-- 02. Insira 'O Lobo da Estepe' (id = 73, disponivel = FALSE)
INSERT INTO tb_livros (id, titulo, autor, ano_publicacao, disponivel)
VALUES (73, 'O Lobo da Estepe', 'Hermann Hesse', 1927, FALSE);

-- 03. Insira 'Solaris' (id = 74, omitting disponivel) e verifique
INSERT INTO tb_livros (id, titulo, autor, ano_publicacao)
VALUES (74, 'Solaris', 'Stanisław Lem', 1961);

-- Conferência:
SELECT * FROM tb_livros WHERE id = 74;

-- 04. Insira 'O Som e a Fúria' (id = 75, disponivel = TRUE)
INSERT INTO tb_livros (id, titulo, autor, ano_publicacao, disponivel)
VALUES (75, 'O Som e a Fúria', 'William Faulkner', 1929, TRUE);

-- 05. Insira livro fictício de Albert Camus (id = 76, disponivel = FALSE)
INSERT INTO tb_livros (id, titulo, autor, ano_publicacao, disponivel)
VALUES (76, 'Horizontes do Amanhã', 'Albert Camus', 2020, FALSE);


-- ============================================================
-- ETAPA 3 — CONSULTAS E ANÁLISE DO CATÁLOGO
-- ============================================================

-- 01. Conte quantos livros estão disponíveis para empréstimo neste momento
SELECT COUNT(*) AS disponiveis_emprestimo 
FROM tb_livros 
WHERE disponivel = TRUE;

-- 02. Liste cada autor e sua quantidade de registros cadastrados
SELECT autor, COUNT(*) AS quantidade
FROM tb_livros
GROUP BY autor
ORDER BY quantidade DESC, autor ASC;

-- 03. Livro(s) com o menor ano de publicação
SELECT * 
FROM tb_livros
WHERE ano_publicacao = (SELECT MIN(ano_publicacao) FROM tb_livros);

-- 04. Autores com mais de dois registros cadastrados
SELECT autor, COUNT(*) AS quantidade
FROM tb_livros
GROUP BY autor
HAVING COUNT(*) > 2;


-- ============================================================
-- ETAPA 4 — ATUALIZAÇÕES BÁSICAS
-- ============================================================

-- 01. Marque 'Dom Casmurro' como indisponível
SELECT * FROM tb_livros WHERE titulo = 'Dom Casmurro';
UPDATE tb_livros SET disponivel = FALSE WHERE titulo = 'Dom Casmurro';

-- 02. Corrija o ano de publicação de 'O Cortiço' para 1891
SELECT * FROM tb_livros WHERE titulo = 'O Cortiço';
UPDATE tb_livros SET ano_publicacao = 1891 WHERE titulo = 'O Cortiço';

-- 03. Marque 'Vidas Secas' (id = 6) como disponível
SELECT * FROM tb_livros WHERE id = 6;
UPDATE tb_livros SET disponivel = TRUE WHERE id = 6;

-- 04. Atualize autor 'George Orwell' para 'George Orwell (Verificado)'
SELECT * FROM tb_livros WHERE autor = 'George Orwell';
UPDATE tb_livros SET autor = 'George Orwell (Verificado)' WHERE autor = 'George Orwell';

-- 05. Marque todos os livros de Fiódor Dostoiévski como disponíveis
SELECT * FROM tb_livros WHERE autor LIKE '%Dostoiévski%';
UPDATE tb_livros SET disponivel = TRUE WHERE autor LIKE '%Dostoiévski%';

-- 06. Atualize o título do livro com id = 18
SELECT * FROM tb_livros WHERE id = 18;
UPDATE tb_livros SET titulo = 'O Senhor dos Anéis: A Sociedade do Anel' WHERE id = 18;


-- ============================================================
-- ETAPA 5 — ATUALIZAÇÕES COM FILTROS E SUBQUERIES
-- ============================================================

-- 01. Indisponibilizar livros de J.K. Rowling anteriores a 1999
SELECT * FROM tb_livros WHERE autor LIKE '%J.K. Rowling%' AND ano_publicacao < 1999;
UPDATE tb_livros SET disponivel = FALSE WHERE autor LIKE '%J.K. Rowling%' AND ano_publicacao < 1999;

-- 02. Torne disponíveis livros indisponíveis publicados entre 1950 e 2000
SELECT * FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao BETWEEN 1950 AND 2000;
UPDATE tb_livros SET disponivel = TRUE WHERE disponivel = FALSE AND ano_publicacao BETWEEN 1950 AND 2000;

-- 03. Marque livros de Victor Hugo como indisponíveis (com subquery em tabela derivada no MySQL)
SELECT * FROM tb_livros WHERE autor = 'Victor Hugo';
UPDATE tb_livros 
SET disponivel = FALSE 
WHERE id IN (
    SELECT temp.id FROM (
        SELECT id FROM tb_livros WHERE autor = 'Victor Hugo'
    ) AS temp
);

-- 04. Torne disponíveis indisponíveis entre 1930 e 1950 (subquery)
SELECT * FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao BETWEEN 1930 AND 1950;
UPDATE tb_livros 
SET disponivel = TRUE 
WHERE id IN (
    SELECT temp.id FROM (
        SELECT id FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao BETWEEN 1930 AND 1950
    ) AS temp
);

-- 05. Marque como disponíveis livros com autor contendo 'Kafka'
SELECT * FROM tb_livros WHERE autor LIKE '%Kafka%';
UPDATE tb_livros SET disponivel = TRUE WHERE autor LIKE '%Kafka%';

-- 06. Marque como indisponíveis livros dos autores Dan Brown, George Orwell (Verificado) e H.G. Wells
SELECT * FROM tb_livros WHERE autor IN ('Dan Brown', 'George Orwell (Verificado)', 'H.G. Wells');
UPDATE tb_livros SET disponivel = FALSE WHERE autor IN ('Dan Brown', 'George Orwell (Verificado)', 'H.G. Wells');

-- 07. Disponibilize todas as obras de 1930 a 1969
SELECT * FROM tb_livros WHERE ano_publicacao BETWEEN 1930 AND 1969;
UPDATE tb_livros SET disponivel = TRUE WHERE ano_publicacao BETWEEN 1930 AND 1969;

-- 08. Atualize autor contendo 'Tolstói' para 'Autor Revisado'
SELECT * FROM tb_livros WHERE autor LIKE '%Tolstói%';
UPDATE tb_livros SET autor = 'Autor Revisado' WHERE autor LIKE '%Tolstói%';

-- 09. Marque como indisponíveis livros antes de 1950 ou com 'Mundo' no título
SELECT * FROM tb_livros WHERE ano_publicacao < 1950 OR titulo LIKE '%Mundo%';
UPDATE tb_livros SET disponivel = FALSE WHERE ano_publicacao < 1950 OR titulo LIKE '%Mundo%';

-- 10. Garantir disponibilidade dos livros IDs 3, 6, 11, 18 e 45
SELECT * FROM tb_livros WHERE id IN (3, 6, 11, 18, 45);
UPDATE tb_livros SET disponivel = TRUE WHERE id IN (3, 6, 11, 18, 45);

-- 11. Coleção especial para títulos contendo 'Senhor' ou 'Nárnia'
SELECT * FROM tb_livros WHERE titulo LIKE '%Senhor%' OR titulo LIKE '%Nárnia%';
UPDATE tb_livros 
SET titulo = CONCAT(titulo, ' (Coleção Especial)') 
WHERE titulo LIKE '%Senhor%' OR titulo LIKE '%Nárnia%';


-- ============================================================
-- ETAPA 6 — EXCLUSÕES ESPECÍFICAS E COM MÚLTIPLAS CONDIÇÕES
-- ============================================================

-- 01. Excluir 'O Código Da Vinci'
SELECT * FROM tb_livros WHERE titulo LIKE '%O Código Da Vinci%';
DELETE FROM tb_livros WHERE titulo LIKE '%O Código Da Vinci%';

-- 02. Excluir livros indisponíveis do autor H.G. Wells
SELECT * FROM tb_livros WHERE autor = 'H.G. Wells' AND disponivel = FALSE;
DELETE FROM tb_livros WHERE autor = 'H.G. Wells' AND disponivel = FALSE;

-- 03. Remova todos os livros do autor Eça de Queirós
SELECT * FROM tb_livros WHERE autor LIKE '%Eça de Queirós%';
DELETE FROM tb_livros WHERE autor LIKE '%Eça de Queirós%';

-- 04. Excluir livros cujo ano de publicação seja menor que zero
SELECT * FROM tb_livros WHERE ano_publicacao < 0;
DELETE FROM tb_livros WHERE ano_publicacao < 0;

-- 05. Remova os livros disponíveis do autor José de Alencar
SELECT * FROM tb_livros WHERE autor LIKE '%José de Alencar%' AND disponivel = TRUE;
DELETE FROM tb_livros WHERE autor LIKE '%José de Alencar%' AND disponivel = TRUE;

-- 06. Remova livros indisponíveis de Victor Hugo e Franz Kafka
SELECT * FROM tb_livros WHERE autor IN ('Victor Hugo', 'Franz Kafka') AND disponivel = FALSE;
DELETE FROM tb_livros WHERE autor IN ('Victor Hugo', 'Franz Kafka') AND disponivel = FALSE;

-- 07. Remova indisponíveis entre 1800 e 1900
SELECT * FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao BETWEEN 1800 AND 1900;
DELETE FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao BETWEEN 1800 AND 1900;

-- 08. Exclua indisponíveis antes de 1900
SELECT * FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao < 1900;
DELETE FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao < 1900;

-- 09. Exclua indisponíveis a partir do ano 2000
SELECT * FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao >= 2000;
DELETE FROM tb_livros WHERE disponivel = FALSE AND ano_publicacao >= 2000;


-- ============================================================
-- ETAPA 7 — EXCLUSÃO COM SUBQUERY E COLEÇÃO TEMÁTICA
-- ============================================================

-- 01. Excluir livros de autores com mais de 2 livros cadastrados no momento
SELECT * FROM tb_livros WHERE autor IN (
    SELECT autor FROM (
        SELECT autor FROM tb_livros GROUP BY autor HAVING COUNT(*) > 2
    ) AS autores_muitos
);

DELETE FROM tb_livros 
WHERE autor IN (
    SELECT autor FROM (
        SELECT autor FROM tb_livros GROUP BY autor HAVING COUNT(*) > 2
    ) AS temp_autores
);

-- 02. Manter apenas obras de J.K. Rowling
SELECT * FROM tb_livros WHERE autor NOT LIKE '%J.K. Rowling%';
DELETE FROM tb_livros WHERE autor NOT LIKE '%J.K. Rowling%';

-- Conferência final da coleção temática:
SELECT * FROM tb_livros;
