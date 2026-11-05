-- ============================================================
-- SCRIPT DE CONSULTAS SQL: MISSÕES E DESAFIO FINAL
-- ============================================================

-- ------------------------------------------------------------
-- MISSÃO 1 — Arredondamentos com FLOOR
-- ------------------------------------------------------------

-- 1. Preço arredondado para baixo
SELECT 
    nome, 
    preco, 
    FLOOR(preco) AS preco_arredondado_baixo
FROM produtos;

-- 2. Caixas completas de 6 unidades
SELECT 
    nome, 
    estoque, 
    FLOOR(estoque / 6.0) AS caixas_completas
FROM produtos;

-- 3. Kits completos com 4 unidades
SELECT 
    nome, 
    estoque, 
    FLOOR(estoque / 4.0) AS kits_completos
FROM produtos;

-- 4. Preço médio por categoria e arredondamento para baixo
SELECT 
    categoria, 
    AVG(preco) AS preco_medio_original, 
    FLOOR(AVG(preco)) AS preco_medio_arredondado_baixo
FROM produtos
GROUP BY categoria;


-- ------------------------------------------------------------
-- MISSÃO 2 — Arredondamentos com CEILING
-- ------------------------------------------------------------

-- 1. Preço arredondado para cima
SELECT 
    nome, 
    preco, 
    CEIL(preco) AS preco_arredondado_cima
FROM produtos;

-- 2. Total de caixas necessárias (incluindo caixa incompleta)
SELECT 
    nome, 
    estoque, 
    CEIL(estoque / 6.0) AS total_caixas_necessarias
FROM produtos;

-- 3. Pacotes de 8 unidades para atingir/ultrapassar 25 unidades por produto
SELECT 
    nome, 
    CEIL(25.0 / 8.0) AS pacotes_a_comprar
FROM produtos;

-- 4. Comparativo de preços (Original, FLOOR, CEILING e Diferença)
SELECT 
    nome, 
    preco AS preco_original, 
    FLOOR(preco) AS preco_baixo, 
    CEIL(preco) AS preco_cima, 
    (CEIL(preco) - FLOOR(preco)) AS diferenca
FROM produtos;


-- ------------------------------------------------------------
-- MISSÃO 3 — Filtros de grupos com HAVING
-- ------------------------------------------------------------

-- 1. Categorias com mais de 3 produtos
SELECT 
    categoria, 
    COUNT(*) AS total_produtos
FROM produtos
GROUP BY categoria
HAVING COUNT(*) > 3;

-- 2. Categorias com estoque total superior a 50 unidades
SELECT 
    categoria, 
    SUM(estoque) AS total_estoque
FROM produtos
GROUP BY categoria
HAVING SUM(estoque) > 50;

-- 3. Categorias com preço médio maior que R$ 100,00
SELECT 
    categoria, 
    AVG(preco) AS preco_medio
FROM produtos
GROUP BY categoria
HAVING AVG(preco) > 100.00;

-- 4. Categorias com valor total de estoque > R$ 5.000,00 (estoque > 0)
SELECT 
    categoria, 
    SUM(estoque * preco) AS valor_total_estoque
FROM produtos
WHERE estoque > 0
GROUP BY categoria
HAVING SUM(estoque * preco) > 5000.00;


-- ------------------------------------------------------------
-- MISSÃO 4 — Classificações com CASE
-- ------------------------------------------------------------

-- 1. Classificação simples de disponibilidade
SELECT 
    nome, 
    estoque,
    CASE 
        WHEN estoque = 0 THEN 'Fora de estoque'
        ELSE 'Disponível'
    END AS classificacao
FROM produtos;

-- 2. Classificação detalhada por faixa de estoque
SELECT 
    nome, 
    estoque,
    CASE 
        WHEN estoque = 0 THEN 'Esgotado'
        WHEN estoque BETWEEN 1 AND 5 THEN 'Estoque crítico'
        WHEN estoque BETWEEN 6 AND 20 THEN 'Estoque moderado'
        ELSE 'Estoque adequado'
    END AS status_estoque
FROM produtos;

-- 3. Classificação por faixa de preço
SELECT 
    nome, 
    preco,
    CASE 
        WHEN preco < 100.00 THEN 'Econômico'
        WHEN preco BETWEEN 100.00 AND 500.00 THEN 'Intermediário'
        ELSE 'Premium'
    END AS faixa_preco
FROM produtos;

-- 4. Quantidade necessária para reposição (Meta = 20)
SELECT 
    nome, 
    estoque AS estoque_atual,
    CASE 
        WHEN estoque >= 20 THEN 0
        ELSE 20 - estoque
    END AS quantidade_reposicao
FROM produtos;


-- ------------------------------------------------------------
-- DESAFIO FINAL — Relatório de reposição
-- ------------------------------------------------------------

SELECT 
    categoria,
    COUNT(*) AS qtd_produtos_cadastrados,
    SUM(estoque) AS total_estoque,
    AVG(preco) AS preco_medio_original,
    CEIL(AVG(preco)) AS preco_medio_arredondado_cima,
    SUM(estoque * preco) AS valor_total_estoque,
    CASE 
        WHEN SUM(estoque) < 20 THEN 'Reposição urgente'
        WHEN SUM(estoque) BETWEEN 20 AND 50 THEN 'Atenção'
        ELSE 'Estoque confortável'
    END AS classificacao_estoque
FROM produtos
GROUP BY categoria
HAVING COUNT(*) >= 2
ORDER BY total_estoque ASC;
