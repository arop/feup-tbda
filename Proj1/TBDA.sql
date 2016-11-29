create table xsemestre as (select * from GTD2.ipdw_semestre);
create table ysemestre as (select * from GTD2.ipdw_semestre);
create table zsemestre as (select * from GTD2.ipdw_semestre);

create table xrespostas as (select * from GTD2.ipdw_respostas);
create table yrespostas as (select * from GTD2.ipdw_respostas);
create table zrespostas as (select * from GTD2.ipdw_respostas);

create table xpergunta as (select * from GTD2.ipdw_pergunta);
create table ypergunta as (select * from GTD2.ipdw_pergunta);
create table zpergunta as (select * from GTD2.ipdw_pergunta);

create table xdisciplina as (select * from GTD2.ipdw_disciplina);
create table ydisciplina as (select * from GTD2.ipdw_disciplina);
create table zdisciplina as (select * from GTD2.ipdw_disciplina);

-- primary keys
alter table ysemestre add CONSTRAINT Y_SEMESTRE_PK primary key (semestre_id);
alter table zsemestre add CONSTRAINT Z_SEMESTRE_PK primary key (semestre_id);

alter table yrespostas add CONSTRAINT Y_RESPOSTAS_PK primary key (id);
alter table zrespostas add CONSTRAINT Z_RESPOSTAS_PK primary key (id);

alter table ypergunta add CONSTRAINT Y_PERGUNTA_PK primary key (pergunta_id);
alter table zpergunta add CONSTRAINT Z_PERGUNTA_PK primary key (pergunta_id);

alter table ydisciplina add CONSTRAINT Y_DISCIPLINA_PK primary key (disciplina_id);
alter table zdisciplina add CONSTRAINT Z_DISCIPLINA_PK primary key (disciplina_id);

--foreign keys

--respostas - semestre
  alter table yrespostas add CONSTRAINT Y_RESPOSTAS_FK_SEMESTRE 
    foreign key (semestre_id) references ysemestre(semestre_id);
  alter table zrespostas add CONSTRAINT Z_RESPOSTAS_FK_SEMESTRE 
    foreign key (semestre_id) references zsemestre(semestre_id);
    
--respostas - pergunta
  alter table yrespostas add CONSTRAINT Y_RESPOSTAS_FK_PERGUNTA 
    foreign key (pergunta_id) references ypergunta(pergunta_id);
  alter table zrespostas add CONSTRAINT Z_RESPOSTAS_FK_PERGUNTA 
    foreign key (pergunta_id) references zpergunta(pergunta_id);
    
--respostas - disciplina
  alter table yrespostas add CONSTRAINT Y_RESPOSTAS_FK_DISCIPLINA 
    foreign key (disciplina_id) references ydisciplina(disciplina_id);
  alter table zrespostas add CONSTRAINT Z_RESPOSTAS_FK_DISCIPLINA 
    foreign key (disciplina_id) references zdisciplina(disciplina_id);

--indexes
CREATE INDEX Z_RESPOSTAS_DISCIPLINA_IDX ON zrespostas (disciplina_id);
DROP INDEX Z_RESPOSTAS_DISCIPLINA_IDX ;
--CREATE BITMAP INDEX Z_RESPOSTAS_DISCIPLINA_IDX ON zrespostas (disciplina_id);

DROP INDEX Z_RESPOSTAS_SEMESTRE_IDX ;
--CREATE INDEX Z_RESPOSTAS_SEMESTRE_IDX ON zrespostas (semestre_id);
CREATE BITMAP INDEX Z_RESPOSTAS_SEMESTRE_IDX ON zrespostas (semestre_id);

CREATE INDEX Z_RESP_DISC_SEMESTRE_IDX ON zrespostas (semestre_id, disciplina_id);

---------------------------------------------------------
---------------------------------------------------------
-- 1
---------------------------------------------------------
---------------------------------------------------------

  -- a
  select count(*)
  from xrespostas
  where semestre_id = 21;
  
  select count(*)
  from yrespostas
  where semestre_id = 21;
  
  select count(*)
  from zrespostas
  where semestre_id = 21;
  
  -- b
  select count(*) 
  from xrespostas 
  Where disciplina_id = 1237; 
  
  select count(*) 
  from yrespostas 
  Where disciplina_id = 1237; 
  
  select count(*) 
  from zrespostas 
  Where disciplina_id = 1237; 
  
  -- c
  select count(*) 
  from xrespostas, xsemestre 
  where xrespostas.semestre_id = xsemestre.semestre_id 
  and xsemestre.ano_lectivo = '2008/2009'
  and xsemestre.semestre = '1S';

  select count(*) 
  from yrespostas, ysemestre 
  where yrespostas.semestre_id = ysemestre.semestre_id 
  and ysemestre.ano_lectivo = '2008/2009'
  and ysemestre.semestre = '1S';
  
  select count(*) 
  from zrespostas, zsemestre 
  where zrespostas.semestre_id = zsemestre.semestre_id 
  and zsemestre.ano_lectivo = '2008/2009'
  and zsemestre.semestre = '1S';


---------------------------------------------------------
---------------------------------------------------------
-- 2
---------------------------------------------------------
---------------------------------------------------------

-- a Qual  a média dos resultados dos vários inquéritos à disciplina FPRO? 

select avg(xrespostas.resposta)
from xrespostas, xdisciplina
where xrespostas.disciplina_id = xdisciplina.disciplina_id
and xdisciplina.sigla = 'FPRO';

select avg(yrespostas.resposta)
from yrespostas, ydisciplina
where yrespostas.disciplina_id = ydisciplina.disciplina_id
and ydisciplina.sigla = 'FPRO';

select avg(zrespostas.resposta)
from zrespostas, zdisciplina
where zrespostas.disciplina_id = zdisciplina.disciplina_id
and zdisciplina.sigla = 'FPRO';

-- b 
-- Qual o id e a sigla da disciplina que, no inquérito de id 21, 
-- teve o melhor resultado, das que tiveram mais do que 300 respostas?

select * from (
  select xdisciplina.disciplina_id, xdisciplina.sigla, avg(xrespostas.resposta) nota, count(*) nr 
  from xrespostas, xdisciplina
  where xrespostas.semestre_id = 21
  and xrespostas.disciplina_id = xdisciplina.disciplina_id
  group by xdisciplina.disciplina_id, xdisciplina.sigla
  having count(*) > 300
  order by nota desc
)
where rownum <= 1;

select * from (
  select ydisciplina.disciplina_id, ydisciplina.sigla, avg(yrespostas.resposta) nota, count(*) nr 
  from yrespostas, ydisciplina
  where yrespostas.semestre_id = 21
  and yrespostas.disciplina_id = ydisciplina.disciplina_id
  group by ydisciplina.disciplina_id, ydisciplina.sigla
  having count(*) > 300
  order by nota desc
)
where rownum <= 1;


select * from (
  select zdisciplina.disciplina_id, zdisciplina.sigla, avg(zrespostas.resposta) nota, count(*) nr 
  from zrespostas, zdisciplina
  where zrespostas.semestre_id = 21
  and zrespostas.disciplina_id = zdisciplina.disciplina_id
  group by zdisciplina.disciplina_id, zdisciplina.sigla
  having count(*) > 300
  order by nota desc
)
where rownum <= 1;


-- c
-- Qual o id e a sigla das disciplinas que têm uma média da pergunta 
-- ‘Apreciação Global’ superior em mais do que 0.1 à média de todas as suas 
-- respostas, no inquérito de id 21 e entre as que tiveram mais de 
-- 300 respostas?

-- X
--
CREATE VIEW x_media_mais_300_semestre_21 AS(
  SELECT disciplina_id, avg(resposta) nota_glob, COUNT(*) nr_respostas
  FROM xrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id
  HAVING COUNT(*) > 300
);
 
CREATE VIEW x_med_pergunta_apreciacao_glob AS(
  SELECT xr.disciplina_id, avg(xr.resposta) nota_perg, COUNT(*) nr_respostas
  FROM xrespostas xr, xpergunta xp
  WHERE xr.semestre_id = 21
  AND xr.pergunta_id = xp.pergunta_id
  AND xp.nome LIKE 'Apreciação Global'
  GROUP BY xr.disciplina_id
);
 
SELECT d.disciplina_id, d.sigla, med_glob.nota_glob, med_perg.nota_perg
FROM x_media_mais_300_semestre_21 med_glob, x_med_pergunta_apreciacao_glob med_perg, xdisciplina d
WHERE med_glob.disciplina_id = med_perg.disciplina_id
AND med_glob.disciplina_id = d.disciplina_id
AND nota_glob + 0.1 < nota_perg;
 
-- Y
--
CREATE VIEW y_media_mais_300_semestre_21 AS(
  SELECT disciplina_id, avg(resposta) nota_glob, COUNT(*) nr_respostas
  FROM yrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id
  HAVING COUNT(*) > 300
);
 
CREATE VIEW y_med_pergunta_apreciacao_glob AS(
  SELECT yr.disciplina_id, avg(yr.resposta) nota_perg, COUNT(*) nr_respostas
  FROM yrespostas yr, ypergunta yp
  WHERE yr.semestre_id = 21
  AND yr.pergunta_id = yp.pergunta_id
  AND yp.nome LIKE 'Apreciação Global'
  GROUP BY yr.disciplina_id
);
 
SELECT d.disciplina_id, d.sigla, med_glob.nota_glob, med_perg.nota_perg
FROM y_media_mais_300_semestre_21 med_glob, y_med_pergunta_apreciacao_glob med_perg, ydisciplina d
WHERE med_glob.disciplina_id = med_perg.disciplina_id
AND med_glob.disciplina_id = d.disciplina_id
AND nota_glob + 0.1 < nota_perg;
 
-- Z
--
CREATE VIEW z_media_mais_300_semestre_21 AS(
  SELECT disciplina_id, avg(resposta) nota_glob, COUNT(*) nr_respostas
  FROM zrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id
  HAVING COUNT(*) > 300
);
 
CREATE VIEW z_med_pergunta_apreciacao_glob AS(
  SELECT zr.disciplina_id, avg(zr.resposta) nota_perg, COUNT(*) nr_respostas
  FROM zrespostas zr, zpergunta zp
  WHERE zr.semestre_id = 21
  AND zr.pergunta_id = zp.pergunta_id
  AND zp.nome LIKE 'Apreciação Global'
  GROUP BY zr.disciplina_id
);
 
SELECT d.disciplina_id, d.sigla, med_glob.nota_glob, med_perg.nota_perg
FROM z_media_mais_300_semestre_21 med_glob, z_med_pergunta_apreciacao_glob med_perg, zdisciplina d
WHERE med_glob.disciplina_id = med_perg.disciplina_id
AND med_glob.disciplina_id = d.disciplina_id
AND nota_glob + 0.1 < nota_perg;


---------------------------------------------------------
---------------------------------------------------------
-- 3
---------------------------------------------------------
---------------------------------------------------------
ALTER SESSION SET OPTIMIZER_MODE = CHOOSE; --default
ALTER SESSION SET OPTIMIZER_MODE = RULE;
 
-- X
-- not in
SELECT *
FROM xdisciplina
WHERE disciplina_id NOT IN(
  SELECT disciplina_id
  FROM xrespostas
  GROUP BY disciplina_id
);
 
-- junção externa e filtragem para nulo
SELECT disc.sigla, disc.nome
FROM (
  SELECT disciplina_id
  FROM xrespostas
  GROUP BY disciplina_id
) resp FULL OUTER JOIN xdisciplina disc
ON resp.disciplina_id = disc.disciplina_id
WHERE resp.disciplina_id IS NULL;
 
-- Y
-- not in
SELECT *
FROM ydisciplina
WHERE disciplina_id NOT IN(
  SELECT disciplina_id
  FROM yrespostas
  GROUP BY disciplina_id
);
 
-- junção externa e filtragem para nulo
SELECT disc.sigla, disc.nome
FROM (
  SELECT disciplina_id
  FROM yrespostas
  GROUP BY disciplina_id
) resp FULL OUTER JOIN ydisciplina disc
ON resp.disciplina_id = disc.disciplina_id
WHERE resp.disciplina_id IS NULL;
 
-- Z
-- not in
SELECT *
FROM zdisciplina
WHERE disciplina_id NOT IN(
  SELECT disciplina_id
  FROM zrespostas
  GROUP BY disciplina_id
);
 
-- junção externa e filtragem para nulo
SELECT disc.sigla, disc.nome
FROM (
  SELECT disciplina_id
  FROM zrespostas
  GROUP BY disciplina_id
) resp FULL OUTER JOIN zdisciplina disc
ON resp.disciplina_id = disc.disciplina_id
WHERE resp.disciplina_id IS NULL;

---------------------------------------------------------
---------------------------------------------------------
-- 4
---------------------------------------------------------
---------------------------------------------------------
 
-- X
-- contagem
CREATE VIEW x_total_respostas AS (
  SELECT disciplina_id , COUNT(*) total_respostas
  FROM (
    SELECT disciplina_id, pergunta_id, COUNT(*) c
    FROM xrespostas
    WHERE semestre_id = 21
    GROUP BY disciplina_id, pergunta_id
  )
  GROUP BY disciplina_id
);
 
CREATE VIEW x_respostas_5 AS (
  SELECT disciplina_id , COUNT(*) respostas_5
  FROM (
    SELECT disciplina_id, pergunta_id, COUNT(*)
    FROM xrespostas
    WHERE semestre_id = 21
    AND resposta = 5
    GROUP BY DISCIPLINA_ID, pergunta_id
  )
  GROUP BY disciplina_id
);
 
SELECT d.disciplina_id, d.sigla, t.total_respostas, r.respostas_5
FROM x_total_respostas t, x_respostas_5 r, xdisciplina d
WHERE t.disciplina_id = r.disciplina_id
AND t.disciplina_id = d.disciplina_id
AND t.total_respostas = r.respostas_5;
 
 
-- dupla negação
 
CREATE VIEW x_disciplinas_inq_21 AS (
  SELECT disciplina_id
  FROM xrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id
);
 
 SELECT db.disciplina_id, db.sigla
 FROM x_disciplinas_inq_21 da, xdisciplina db
 WHERE da.disciplina_id = db.disciplina_id
 AND da.disciplina_id NOT IN (
    SELECT disciplina_id
    FROM xrespostas ra
    WHERE semestre_id = 21
    AND NOT EXISTS (
      SELECT rb.disciplina_id, rb.pergunta_id
      FROM xrespostas rb
      WHERE rb.disciplina_id = ra.disciplina_id
      AND rb.pergunta_id = ra.pergunta_id
      AND rb.semestre_id = 21
      AND rb.resposta = 5
      GROUP BY disciplina_id, pergunta_id
    )
    GROUP BY disciplina_id, pergunta_id
);
 
 
-- Y
-- contagem
CREATE VIEW y_total_respostas AS (
  SELECT disciplina_id , COUNT(*) total_respostas
  FROM (
    SELECT disciplina_id, pergunta_id, COUNT(*) c
    FROM yrespostas
    WHERE semestre_id = 21
    GROUP BY disciplina_id, pergunta_id
  )
  GROUP BY disciplina_id
);
 
CREATE VIEW y_respostas_5 AS (
  SELECT disciplina_id , COUNT(*) respostas_5
  FROM (
    SELECT disciplina_id, pergunta_id, COUNT(*)
    FROM yrespostas
    WHERE semestre_id = 21
    AND resposta = 5
    GROUP BY DISCIPLINA_ID, pergunta_id
  )
  GROUP BY disciplina_id
);
 
SELECT d.disciplina_id, d.sigla, t.total_respostas, r.respostas_5
FROM y_total_respostas t, y_respostas_5 r, ydisciplina d
WHERE t.disciplina_id = r.disciplina_id
AND t.disciplina_id = d.disciplina_id
AND t.total_respostas = r.respostas_5;
 
 
-- dupla negação
 
CREATE VIEW y_disciplinas_inq_21 AS (
  SELECT disciplina_id
  FROM yrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id
);
 
 SELECT db.disciplina_id, db.sigla
 FROM y_disciplinas_inq_21 da, ydisciplina db
 WHERE da.disciplina_id = db.disciplina_id
 AND da.disciplina_id NOT IN (
    SELECT disciplina_id
    FROM yrespostas ra
    WHERE semestre_id = 21
    AND NOT EXISTS (
      SELECT rb.disciplina_id, rb.pergunta_id
      FROM yrespostas rb
      WHERE rb.disciplina_id = ra.disciplina_id
      AND rb.pergunta_id = ra.pergunta_id
      AND rb.semestre_id = 21
      AND rb.resposta = 5
      GROUP BY disciplina_id, pergunta_id
    )
    GROUP BY disciplina_id, pergunta_id
);
 
-- Z
-- contagem
CREATE VIEW z_total_respostas AS (
  SELECT disciplina_id , COUNT(*) total_respostas
  FROM (
    SELECT disciplina_id, pergunta_id, COUNT(*) c
    FROM zrespostas
    WHERE semestre_id = 21
    GROUP BY disciplina_id, pergunta_id
  )
  GROUP BY disciplina_id
);
 
CREATE VIEW z_respostas_5 AS (
  SELECT disciplina_id , COUNT(*) respostas_5
  FROM (
    SELECT disciplina_id, pergunta_id, COUNT(*)
    FROM zrespostas
    WHERE semestre_id = 21
    AND resposta = 5
    GROUP BY DISCIPLINA_ID, pergunta_id
  )
  GROUP BY disciplina_id
);
 
SELECT d.disciplina_id, d.sigla, t.total_respostas, r.respostas_5
FROM z_total_respostas t, z_respostas_5 r, zdisciplina d
WHERE t.disciplina_id = r.disciplina_id
AND t.disciplina_id = d.disciplina_id
AND t.total_respostas = r.respostas_5;
 
 
-- dupla negação
 
CREATE VIEW z_disciplinas_inq_21 AS (
  SELECT disciplina_id
  FROM zrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id
);

select * from  z_disciplinas_inq_21;
SELECT disciplina_id
  FROM zrespostas
  WHERE semestre_id = 21
  GROUP BY disciplina_id;
 
 SELECT db.disciplina_id, db.sigla
 FROM z_disciplinas_inq_21 da, zdisciplina db
 WHERE da.disciplina_id = db.disciplina_id
 AND da.disciplina_id NOT IN (
    SELECT disciplina_id
    FROM zrespostas ra
    WHERE semestre_id = 21
    AND NOT EXISTS (
      SELECT rb.disciplina_id, rb.pergunta_id
      FROM zrespostas rb
      WHERE rb.disciplina_id = ra.disciplina_id
      AND rb.pergunta_id = ra.pergunta_id
      AND rb.semestre_id = 21
      AND rb.resposta = 5
      GROUP BY disciplina_id, pergunta_id
    )
    GROUP BY disciplina_id, pergunta_id
);