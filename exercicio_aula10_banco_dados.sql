-- ============================================================
-- EXERCÍCIO PRÁTICO: MANIPULAÇÃO DE DADOS EM BANCO DE DADOS
-- ============================================================

-- ============================================================
-- PARTE 1 — CRIAÇÃO DO AMBIENTE
-- ============================================================

-- 1. Criação do banco de dados
CREATE DATABASE IF NOT EXISTS aula10;

-- 2. Seleção do banco de dados
USE aula10;

-- 3. Criação da tabela tb_livros
CREATE TABLE IF NOT EXISTS tb_livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    ano_publicacao INT,
    disponivel BOOLEAN DEFAULT TRUE
);


-- ============================================================
-- PARTE 2 — INSERÇÃO DE DADOS (Estrutura padrão de suporte)
-- ============================================================
-- Nota: Insira aqui os registros fornecidos pelo seu professor/anexo.


-- ============================================================
-- PARTE 3 — ATUALIZAÇÕES (UPDATE)
-- ============================================================

-- 🟢 Nível 1 – Básico

-- 01. Atualizar o título do livro com id = 1 para 'Dom Casmurro - Edição Comentada'
UPDATE tb_livros
SET titulo = 'Dom Casmurro - Edição Comentada'
WHERE id = 1;

-- 02. Alterar o nome do autor 'Machado de Assis' para 'Machado Assis'
UPDATE tb_livros
SET autor = 'Machado Assis'
WHERE autor = 'Machado de Assis';

-- 03. Corrigir o nome do autor 'Machado Assis' para 'Machado de Assis'
UPDATE tb_livros
SET autor = 'Machado de Assis'
WHERE autor = 'Machado Assis';

-- 04. Atualizar o ano de publicação do livro 'O Cortiço' para 1891
UPDATE tb_livros
SET ano_publicacao = 1891
WHERE titulo = 'O Cortiço';

-- 05. Marcar como indisponível o livro 'Iracema'
UPDATE tb_livros
SET disponivel = FALSE
WHERE titulo = 'Iracema';

-- 06. Corrigir o título do livro 'Odisséia' para 'Odisseia' (sem acento)
UPDATE tb_livros
SET titulo = 'Odisseia'
WHERE titulo = 'Odisséia';


-- 🟡 Nível 2 – Intermediário

-- 07. Marcar como disponível todos os livros do autor 'George Orwell'
UPDATE tb_livros
SET disponivel = TRUE
WHERE autor = 'George Orwell';

-- 08. Atualizar o ano de publicação para 2000 nos livros do autor 'J.K. Rowling'
UPDATE tb_livros
SET ano_publicacao = 2000
WHERE autor = 'J.K. Rowling';

-- 09. Marcar como indisponíveis todos os livros publicados antes do ano 1900
UPDATE tb_livros
SET disponivel = FALSE
WHERE ano_publicacao < 1900;

-- 10. Atualizar todos os livros do autor 'J.R.R. Tolkien' para estarem indisponíveis
UPDATE tb_livros
SET disponivel = FALSE
WHERE autor = 'J.R.R. Tolkien';

-- 11. Corrigir o título 'A Hora da Estrela' para 'A Hora da Estrela - Edição Definitiva'
UPDATE tb_livros
SET titulo = 'A Hora da Estrela - Edição Definitiva'
WHERE titulo = 'A Hora da Estrela';


-- 🔴 Nível 3 – Avançado

-- 12. Marcar como disponível todos os livros com título que contenha 'Harry Potter'
UPDATE tb_livros
SET disponivel = TRUE
WHERE titulo LIKE '%Harry Potter%';

-- 13. Adicionar ' - Volume Único' ao final de todos os títulos dos livros do autor 'Victor Hugo'
UPDATE tb_livros
SET titulo = CONCAT(titulo, ' - Volume Único')
WHERE autor = 'Victor Hugo';

-- 14. Atualizar os títulos dos livros de 'Franz Kafka' para iniciarem com '[Kafka] '
UPDATE tb_livros
SET titulo = CONCAT('[Kafka] ', titulo)
WHERE autor = 'Franz Kafka';

-- 15. Marcar como indisponíveis todos os livros entre os anos de 1940 e 1980 (inclusive)
UPDATE tb_livros
SET disponivel = FALSE
WHERE ano_publicacao BETWEEN 1940 AND 1980;

-- 16. Atualizar o autor 'H.G. Wells' para aparecer em letras maiúsculas
UPDATE tb_livros
SET autor = UPPER(autor)
WHERE autor = 'H.G. Wells';


-- ============================================================
-- PARTE 4 — CONSULTAS (SELECT)
-- ============================================================

-- 17. Liste todos os autores e a quantidade de livros que possuem na tabela
SELECT 
    autor, 
    COUNT(*) AS total_livros
FROM tb_livros
GROUP BY autor;

-- 18. Mostre os autores que possuem mais de 2 livros cadastrados
SELECT 
    autor, 
    COUNT(*) AS total_livros
FROM tb_livros
GROUP BY autor
HAVING COUNT(*) > 2;

-- 19. Apresente a média do ano de publicação dos livros disponíveis
SELECT 
    AVG(ano_publicacao) AS media_ano_disponiveis
FROM tb_livros
WHERE disponivel = TRUE;

-- 20. Liste os livros publicados antes da média geral de ano de publicação
SELECT 
    *
FROM tb_livros
WHERE ano_publicacao < (SELECT AVG(ano_publicacao) FROM tb_livros);

-- 21. Liste os autores e a média de ano de publicação de seus livros, ordenados do mais novo para o mais antigo
SELECT 
    autor, 
    AVG(ano_publicacao) AS media_ano_publicacao
FROM tb_livros
GROUP BY autor
ORDER BY media_ano_publicacao DESC;

-- 22. Liste os livros com título contendo a letra 'e' ordenados alfabeticamente
SELECT 
    *
FROM tb_livros
WHERE titulo LIKE '%e%'
ORDER BY titulo ASC;

-- 23. Conte quantos livros estão disponíveis e quantos estão indisponíveis
SELECT 
    disponivel, 
    COUNT(*) AS quantidade
FROM tb_livros
GROUP BY disponivel;

-- 24. Liste os livros agrupados por século (ano_publicacao/100), e a quantidade de livros por século
SELECT 
    FLOOR(ano_publicacao / 100) + 1 AS seculo,
    COUNT(*) AS quantidade_livros
FROM tb_livros
GROUP BY FLOOR(ano_publicacao / 100) + 1
ORDER BY seculo ASC;

-- 25. Liste os livros que foram publicados no mesmo ano de algum outro livro (ano com mais de um título)
SELECT 
    *
FROM tb_livros
WHERE ano_publicacao IN (
    SELECT ano_publicacao
    FROM tb_livros
    GROUP BY ano_publicacao
    HAVING COUNT(*) > 1
);

-- 26. Liste os autores que só têm livros indisponíveis
SELECT 
    autor
FROM tb_livros
GROUP BY autor
HAVING SUM(disponivel = TRUE) = 0;
