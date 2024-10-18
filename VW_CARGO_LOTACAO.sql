/*DECLARE
BEGIN
--  item 17
 INSERT INTO reltabela 
 SELECT MAX(COD_TABELA)+1,'VW_QTDE_VAGAS_OCUPADAS','Quantidade de vagas existentes e Ocupadas',MAX(COD_TABELA)+1 from reltabela;   

-- item 10
  INSERT INTO reltabela   
  SELECT MAX(COD_TABELA)+1,'VW_CONTROLE_ORGAO_LOTACAO','Quantidade de Vagas existentes e Ocupadas por Lotação',MAX(COD_TABELA)+1 from reltabela;

-- item 9 
  INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_ATUARIAL_SERVIDORES','Arquivos e relatórios necessários para utilização em cálculo atuarial.',MAX(COD_TABELA)+1 from reltabela;

-- item 9 
 INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_ATUARIAL_EXON','Arquivos e relatórios necessários para utilização da XENON.',MAX(COD_TABELA)+1 from reltabela;

-- item 9
 INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_ATUARIAL_DEPENDENTES','Arquivos e relatórios necessários para utilização da Dependentes.',MAX(COD_TABELA)+1 from reltabela;

-- item 10
 INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_PROVISIONAMENTO','Arquivos e relatórios de provisionamento.',MAX(COD_TABELA)+1 from reltabela;

-- item 13,
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_SERVIDOR','Arquivos e relatórios de servidor.',MAX(COD_TABELA)+1 from reltabela;
-- item 5
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_EXTRATO_PREV_RPPS','Arquivos e relatórios de EXTRATO RPPS.',MAX(COD_TABELA)+1 from reltabela;

-- item 5
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_EXTRATO_PREV_RGPS_MAT','Arquivos e relatórios de EXTRATO RGPS.',MAX(COD_TABELA)+1 from reltabela;
 
--AtosPessoal_FolhaOrdinaria Audesp -- 13 
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_PESSOAL_FOLHA_ORDINARIA','Relatório de Passoal folha ordinária',MAX(COD_TABELA)+1 from reltabela

--AtosPessoal_FolhaOrdinaria - Audesp - 13
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_PESSOAL_FOLHA_ORDINARIA_LINHA','Relatório de Passoal folha ordinária linha',MAX(COD_TABELA)+1 from reltabela
  
-- item 4.6
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_DIAS_AFASTAMENTO','Relatórios de dias afastado',MAX(COD_TABELA)+1 from reltabela;

-- item 13
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_FOLHA_BRUTA_ANUAL','Relatórios Folha Bruta Anual',MAX(COD_TABELA)+1 from reltabela;

Item 39
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_MARGEM_CONSIG','Relatórios de Margem Consignatarias',MAX(COD_TABELA)+1 from reltabela;

-- item 13
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_AUDESP_FOLHA_ORDINARIA','Relatórios de AUDESP_FOLHA_ORDINARIA',MAX(COD_TABELA)+1 from reltabela;

-- item 13
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_AUDESP_PAGTO_FOLHA_ORDINARIA','Relatórios de Audesp pagamento Folha Ordinaria',MAX(COD_TABELA)+1 from reltabela;

-- item 13
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_AUDESP_RESUMO_MENSAL','Relatório de Audesp Resumo Mensal',MAX(COD_TABELA)+1 from reltabela;

-- item 30
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_INSUFICIENCIA_SALDO_ATIVO','Relatório de Insuficiencia de Saldo Ativo',MAX(COD_TABELA)+1 from reltabela;



END;






----------------------------------------------------------------------------------------------------------------------------

create or replace  view VW_QTDE_VAGAS_OCUPADAS as
SELECT  *
FROM 
(
select nome,sum(vagas_previstas) total_de_vagas,sum(vagas_ocupadas) vagas_provida,sum(VAGAS_DISPONIVEIS) VAGAS_NAO_DISPONIVEIS, 
'Cargos Efetivos- LC nº 58/2014 e LC nº 446/2023' titulo
from 
(
   select distinct c.nom_cargo nome,
   count(f.cod_cargo) vagas_ocupadas,C.QTD_TOT_PREV_LEI vagas_previstas,
   C.QTD_TOT_PREV_LEI-count(f.cod_cargo)  VAGAS_DISPONIVEIS
   from tb_cargo C 
   LEFT   join TB_RELACAO_FUNCIONAL F on c.cod_cargo = f.cod_cargo
   LEFT   JOIN tb_evolu_ccomi_gfuncional E ON E.COD_CARGO_COMP = C.COD_CARGO
   where TO_NUMBER(c.cod_cargo) < 90000
   and   f.Dat_Fim_Exerc is null
   and   c.cod_cargo in ( 26,19,102,20,22,23,27,31,107,24,28,21) -- Cargos Efetivos- LC nº 58/2014 e LC nº 446/2023
   group by  c.nom_cargo,C.QTD_TOT_PREV_LEI
) group by nome
 UNION
 select nome,sum(vagas_previstas) total_de_vagas,sum(vagas_ocupadas) vagas_provida,sum(VAGAS_DISPONIVEIS) VAGAS_NAO_DISPONIVEIS, 
 'Cargos em Comissão - LC nº 446/2023' titulo
 from 
(
   select distinct c.nom_cargo nome,
   count(e.cod_cargo_comp) vagas_ocupadas,C.QTD_TOT_PREV_LEI vagas_previstas,
   C.QTD_TOT_PREV_LEI-count(e.cod_cargo_comp)  VAGAS_DISPONIVEIS
   from tb_cargo C 
   LEFT   JOIN tb_evolu_ccomi_gfuncional E ON E.COD_CARGO_COMP = C.COD_CARGO
   where TO_NUMBER(c.cod_cargo) < 90000
   and   E.Dat_Fim_Efeito is null
   and   c.cod_cargo in ( 1,201,202,203,204,205,206) -- Cargos em Comissão - LC nº 446/2023
   group by  c.nom_cargo,C.QTD_TOT_PREV_LEI
  ) group by nome
  UNION
 select nome,sum(vagas_previstas) total_de_vagas,sum(vagas_ocupadas) vagas_provida,sum(VAGAS_DISPONIVEIS) VAGAS_NAO_DISPONIVEIS, 
 'Funções Gratificadas - LC nº 446/2023' titulo
 from 
(
   select distinct c.nom_cargo nome,
   count(e.cod_cargo_comp) vagas_ocupadas,C.QTD_TOT_PREV_LEI vagas_previstas,
   C.QTD_TOT_PREV_LEI-count(e.cod_cargo_comp)  VAGAS_DISPONIVEIS
   from tb_cargo C 
   LEFT   JOIN tb_evolu_ccomi_gfuncional E ON E.COD_CARGO_COMP = C.COD_CARGO
   where TO_NUMBER(c.cod_cargo) < 90000
   and   E.Dat_Fim_Efeito is null
   and   c.cod_cargo in ( 8,31,302,303,304,305,10,7,306,17,307) -- Funções Gratificadas - LC nº 446/2023
   group by  c.nom_cargo,C.QTD_TOT_PREV_LEI
  ) group by nome
  )
ORDER BY 5


---------------------------------------------------------------------------------------------------------------

create or replace view VW_CONTROLE_ORGAO_LOTACAO as 
 select c.nom_cargo,count(l.cod_cargo) vagas_lotadas,o.nom_orgao
  from 
 tb_lotacao l
 inner join tb_cargo c on  c.cod_cargo = l.cod_cargo
 inner join tb_orgao o on  o.cod_orgao = l.cod_orgao
 where l.dat_fim is null
 and TO_NUMBER(l.cod_cargo) < 90000
 group by c.nom_cargo,o.nom_orgao
 
 
-----------------------------------------------------------------------------------------
create or replace VIEW  VW_ATUARIAL_SERVIDORES AS
SELECT * FROM 
(
SELECT DISTINCT
     
       TO_CHAR(F.PER_PROCESSO, 'YYYY')                                                AS NU_ANO
     , TO_CHAR(F.PER_PROCESSO, 'MM')                                                  AS NU_MES
     , '3509502'                                                                      AS CO_IBGE
     , 'CAMPINAS'                                                                     AS NO_ENTE
     , 'SP'                                                                           AS SG_UF
     , 1                                                                              AS CO_COMP_MASSA
     , CASE WHEN F.NUM_GRP IN (6) THEN 1  --'Plano Previdenciário'           
            WHEN F.NUM_GRP IN (5) THEN 2  --'Plano Financeiro'
                                                                                      END CO_TIPO_FUNDO
     , '06.916.689/0001-85'                                                           AS CNPJ_ORGAO
     , E.NOM_ENTIDADE                                                                 AS NO_ORGAO
     , E.COD_PODER                                                                    AS CO_PODER
     , 2                                                                              AS CO_TIPO_PODER
     , 1                                                                              AS CO_TIPO_POPULACAO
     , 7                                                                              AS CO_TIPO_CARGO
     , 1                                                                              AS CO_CRITERIO_ELEGIBILIDADE
     , F.NUM_MATRICULA                                                                AS ID_SERVIDOR_MATRICULA
     , regexp_replace(LPAD(P.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_SERVIDOR_CPF
     , regexp_replace(LPAD(S.NUM_PIS, 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-') AS ID_SERVIDOR_PIS_PASEP
     , DECODE(P.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_SERVIDOR
     , DECODE(P.COD_EST_CIV, 1, 1, 2, 2, 3, 4, 9, 3, 5, 5, 6, 6, 9)                   AS CO_EST_CIVIL_SERVIDOR
     , P.DAT_NASC                                                                     AS DT_NASC_SERVIDOR
     , DECODE (R.COD_SIT_FUNC, 1, 1, 3, 2, 4, 3, 5, 4, 6, 5, 7, 6, 8, 7, 20, 10, 11)  AS CO_SITUACAO_FUNCIONAL
     , 1                                                                              AS CO_TIPO_VINCULO
     , TO_DATE(S.DAT_ING_SERV_PUBLIC,'DD/MM/RRRR')                                    AS DT_ING_SERV_PUB
     , TO_DATE(R.DAT_INI_EXERC,'DD/MM/RRRR')                                          AS DT_ING_ENTE
     , TO_DATE(R.DAT_INI_EXERC,'DD/MM/RRRR')                                          AS DT_ING_CARREIRA
     
     , (SELECT distinct CA.NOM_CARREIRA FROM TB_EVOLUCAO_FUNCIONAL EF INNER JOIN TB_CARREIRA CA 
        ON EF.COD_CARREIRA = CA.COD_CARREIRA and EF.COD_ENTIDADE = CA.COD_ENTIDADE
       WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC AND F.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND 
       NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2100', 'DD/MM/YYYY')))                   AS NO_CARREIRA
    
     , EF.DAT_INI_EFEITO                                                              AS DT_ING_CARGO
     , (SELECT distinct CR.NOM_CARGO FROM TB_EVOLUCAO_FUNCIONAL EF INNER JOIN TB_CARGO CR 
        ON EF.COD_CARGO = CR.COD_CARGO and EF.COD_ENTIDADE = CR.COD_ENTIDADE
       WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC AND F.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND 
       NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2100', 'DD/MM/YYYY')))                   AS NO_CARGO
     
     , round((((SELECT SUM(FPD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET FPD 
                 WHERE F.COD_IDE_REL_FUNC = FPD.COD_IDE_REL_FUNC
                   AND F.PER_PROCESSO     = FPD.PER_PROCESSO
                   AND F.TIP_PROCESSO     = FPD.TIP_PROCESSO
                   AND TRUNC(FPD.COD_FCRUBRICA/100) IN (954,953))*100)/14),2)             AS VL_BASE_CALCULO
     
     , CASE WHEN (SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND F.PER_PROCESSO     = DET.PER_PROCESSO
                     AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (
                     4700,151,3410,
                     65600,65602,7300,7301,7302,7305,7400,7401,7405,
                     7500,7501,7505,7600,7601,7700,31000,31001,31002,11200,11201,12200,12201,2901)) > 0
   
            THEN ((SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.FLG_NATUREZA  = 'C') - 
                    
                  (SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.COD_FCRUBRICA IN (
                     4700,151,3410,
                     65600,65602,7300,7301,7302,7305,7400,7401,7405,
                     7500,7501,7505,7600,7601,7700,31000,31001,31002,11200,11201,12200,12201,2901)))
                        
            ELSE ((SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.FLG_NATUREZA  = 'C'))                                   END VL_REMUNERACAO

     , (SELECT SUM(FPD.VAL_RUBRICA) FROM TB_FOLHA_PAGAMENTO_DET FPD 
          WHERE F.COD_IDE_REL_FUNC = FPD.COD_IDE_REL_FUNC
            AND F.PER_PROCESSO     = FPD.PER_PROCESSO 
            AND F.TIP_PROCESSO     = FPD.TIP_PROCESSO 
            AND TRUNC(FPD.COD_FCRUBRICA/100) IN (954,953))                                AS VL_CONTRIBUICAO
     
     
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (1,7) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RGPS
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (2) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_MUN
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (3) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_EST
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (4) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_FED
     
     , ((SELECT COUNT(*) FROM TB_DEPENDENTE DEP WHERE DEP.COD_IDE_CLI_SERV = F.COD_IDE_CLI 
                                                  AND DEP.COD_PARENTESCO   IN (10,20,30)) + 
        (SELECT COUNT(*) FROM TB_DEPENDENTE DEP WHERE DEP.COD_IDE_CLI_SERV = F.COD_IDE_CLI 
                                                  AND DEP.COD_PARENTESCO   NOT IN (10,20,30)
                                                  AND DEP.COD_IDE_CLI_DEP  IN 
                                                  (SELECT PFFD.COD_IDE_CLI FROM TB_PESSOA_FISICA PFFD 
                                                    WHERE DEP.COD_IDE_CLI_DEP = PFFD.COD_IDE_CLI
                                                      AND PFFD.DAT_NASC >= '01/01/2002')))    AS NU_DEPENDENTES
    
     , CASE WHEN (SELECT DET.VAL_RUBRICA FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N') > 0 
            THEN  1 ELSE 2                                                               END IN_ABONO_PERMANENCIA
    
     , CASE WHEN (SELECT DET.VAL_RUBRICA FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N') > 0 
              
            THEN (SELECT MIN (DET.PER_PROCESSO) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N')                                      END DT_INICIO_ABONO 
     , 2                                                                              AS IN_PREV_COMP
     , CASE WHEN F.COD_CARGO in (8,16,28,301,302)
            THEN (SELECT PE.VAL_ELEMENTO FROM TB_DET_PARAM_ESTRUTURA PE WHERE COD_ELEMENTO = 'TETO_MIN'
                     AND F.PER_PROCESSO BETWEEN PE.INI_VIG AND NVL(PE.FIM_VIG, TO_DATE('01/12/2099','DD/MM/YYYY')))
            ELSE (SELECT PE.VAL_ELEMENTO FROM TB_DET_PARAM_ESTRUTURA PE WHERE COD_ELEMENTO = 'TETO_PREF'
                     AND F.PER_PROCESSO BETWEEN PE.INI_VIG AND NVL(PE.FIM_VIG, TO_DATE('01/12/2099','DD/MM/YYYY')))
                                                                                      END VL_TETO_ESPECIFICO
     , ''
                                                                                   AS DT_PROV_APOSENT
     , F.PER_PROCESSO                                                              AS PER_PROCESSO                  

FROM TB_HFOLHA_PAGAMENTO F
 INNER JOIN TB_ENTIDADE            E ON F.COD_ENTIDADE     = E.COD_ENTIDADE
 INNER JOIN TB_PESSOA_FISICA       P ON F.COD_IDE_CLI      = P.COD_IDE_CLI
 INNER JOIN TB_SERVIDOR            S ON P.COD_IDE_CLI      = S.COD_IDE_CLI
 LEFT  JOIN TB_DEPENDENTE          D ON F.COD_IDE_CLI      = D.COD_IDE_CLI_SERV
 INNER JOIN TB_RELACAO_FUNCIONAL   R ON F.COD_IDE_REL_FUNC = R.COD_IDE_REL_FUNC
 LEFT  JOIN TB_EVOLUCAO_FUNCIONAL EF ON F.COD_IDE_CLI      = EF.COD_IDE_CLI    AND
                                       P.COD_IDE_CLI      = EF.COD_IDE_CLI     AND 
                                       F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                             
WHERE 
--F.PER_PROCESSO = '01/12/2023'
--  AND 
  F.TIP_PROCESSO = 'N' 
  AND F.NUM_GRP = 6
  AND EF.DAT_INI_EFEITO  = (SELECT MIN(EF1.DAT_INI_EFEITO) FROM
  TB_EVOLUCAO_FUNCIONAL EF1      WHERE EF.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF1.COD_CARGO = (SELECT EF2.COD_CARGO FROM
  TB_EVOLUCAO_FUNCIONAL EF2      WHERE EF2.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF2.DAT_FIM_EFEITO IS NULL))  
  UNION
  SELECT DISTINCT
       TO_CHAR(F.PER_PROCESSO, 'YYYY')                                                AS NU_ANO
     , TO_CHAR(F.PER_PROCESSO, 'MM')                                                  AS NU_MES
     , '3509502'                                                                      AS CO_IBGE
     , 'CAMPINAS'                                                                     AS NO_ENTE
     , 'SP'                                                                           AS SG_UF
     , 1                                                                              AS CO_COMP_MASSA
     , CASE WHEN F.NUM_GRP IN (6) THEN 1  --'Plano Previdenciário'           
            WHEN F.NUM_GRP IN (5) THEN 2  --'Plano Financeiro'
                                                                                      END CO_TIPO_FUNDO
     , '06.916.689/0001-85'                                                           AS CNPJ_ORGAO
     , E.NOM_ENTIDADE                                                                 AS NO_ORGAO
     , E.COD_PODER                                                                    AS CO_PODER
     , 2                                                                              AS CO_TIPO_PODER
     , 1                                                                              AS CO_TIPO_POPULACAO
     , 7                                                                              AS CO_TIPO_CARGO
     , 1                                                                              AS CO_CRITERIO_ELEGIBILIDADE
     , F.NUM_MATRICULA                                                                AS ID_SERVIDOR_MATRICULA
     , regexp_replace(LPAD(P.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_SERVIDOR_CPF
     , regexp_replace(LPAD(S.NUM_PIS, 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-') AS ID_SERVIDOR_PIS_PASEP
     , DECODE(P.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_SERVIDOR
     , DECODE(P.COD_EST_CIV, 1, 1, 2, 2, 3, 4, 9, 3, 5, 5, 6, 6, 9)                   AS CO_EST_CIVIL_SERVIDOR
     , P.DAT_NASC                                                                     AS DT_NASC_SERVIDOR
     , DECODE (R.COD_SIT_FUNC, 1, 1, 3, 2, 4, 3, 5, 4, 6, 5, 7, 6, 8, 7, 20, 10, 11)  AS CO_SITUACAO_FUNCIONAL
     , 1                                                                              AS CO_TIPO_VINCULO
     , TO_DATE(S.DAT_ING_SERV_PUBLIC,'DD/MM/RRRR')                                    AS DT_ING_SERV_PUB
     , TO_DATE(R.DAT_INI_EXERC,'DD/MM/RRRR')                                          AS DT_ING_ENTE
     , TO_DATE(R.DAT_INI_EXERC,'DD/MM/RRRR')                                          AS DT_ING_CARREIRA
     
     , (SELECT distinct CA.NOM_CARREIRA FROM TB_EVOLUCAO_FUNCIONAL EF INNER JOIN TB_CARREIRA CA 
        ON EF.COD_CARREIRA = CA.COD_CARREIRA and EF.COD_ENTIDADE = CA.COD_ENTIDADE
       WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC AND F.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND 
       NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2100', 'DD/MM/YYYY')))                   AS NO_CARREIRA
    
     , EF.DAT_INI_EFEITO                                                              AS DT_ING_CARGO
     , (SELECT distinct CR.NOM_CARGO FROM TB_EVOLUCAO_FUNCIONAL EF INNER JOIN TB_CARGO CR 
        ON EF.COD_CARGO = CR.COD_CARGO and EF.COD_ENTIDADE = CR.COD_ENTIDADE
       WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC AND F.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND 
       NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2100', 'DD/MM/YYYY')))                   AS NO_CARGO
     
     , round((((SELECT SUM(FPD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET FPD 
                 WHERE F.COD_IDE_REL_FUNC = FPD.COD_IDE_REL_FUNC
                   AND F.PER_PROCESSO     = FPD.PER_PROCESSO
                   AND F.TIP_PROCESSO     = FPD.TIP_PROCESSO
                   AND TRUNC(FPD.COD_FCRUBRICA/100) IN (954,953))*100)/14),2)             AS VL_BASE_CALCULO
     
     , CASE WHEN (SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND F.PER_PROCESSO     = DET.PER_PROCESSO
                     AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (
                     4700,151,3410,
                     65600,65602,7300,7301,7302,7305,7400,7401,7405,
                     7500,7501,7505,7600,7601,7700,31000,31001,31002,11200,11201,12200,12201,2901)) > 0
   
            THEN ((SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.FLG_NATUREZA  = 'C') - 
                    
                  (SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.COD_FCRUBRICA IN (
                     4700,151,3410,
                     65600,65602,7300,7301,7302,7305,7400,7401,7405,
                     7500,7501,7505,7600,7601,7700,31000,31001,31002,11200,11201,12200,12201,2901)))
                        
            ELSE ((SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.FLG_NATUREZA  = 'C'))                                   END VL_REMUNERACAO

     , (SELECT SUM(FPD.VAL_RUBRICA) FROM TB_FOLHA_PAGAMENTO_DET FPD 
          WHERE F.COD_IDE_REL_FUNC = FPD.COD_IDE_REL_FUNC
            AND F.PER_PROCESSO     = FPD.PER_PROCESSO 
            AND F.TIP_PROCESSO     = FPD.TIP_PROCESSO 
            AND TRUNC(FPD.COD_FCRUBRICA/100) IN (954,953))                                AS VL_CONTRIBUICAO
     
     
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (1,7) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RGPS
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (2) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_MUN
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (3) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_EST
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (4) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_FED
     
     , ((SELECT COUNT(*) FROM TB_DEPENDENTE DEP WHERE DEP.COD_IDE_CLI_SERV = F.COD_IDE_CLI 
                                                  AND DEP.COD_PARENTESCO   IN (10,20,30)) + 
        (SELECT COUNT(*) FROM TB_DEPENDENTE DEP WHERE DEP.COD_IDE_CLI_SERV = F.COD_IDE_CLI 
                                                  AND DEP.COD_PARENTESCO   NOT IN (10,20,30)
                                                  AND DEP.COD_IDE_CLI_DEP  IN 
                                                  (SELECT PFFD.COD_IDE_CLI FROM TB_PESSOA_FISICA PFFD 
                                                    WHERE DEP.COD_IDE_CLI_DEP = PFFD.COD_IDE_CLI
                                                      AND PFFD.DAT_NASC >= '01/01/2002')))    AS NU_DEPENDENTES
    
     , CASE WHEN (SELECT DET.VAL_RUBRICA FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N') > 0 
            THEN  1 ELSE 2                                                               END IN_ABONO_PERMANENCIA
    
     , CASE WHEN (SELECT DET.VAL_RUBRICA FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N') > 0 
              
            THEN (SELECT MIN (DET.PER_PROCESSO) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N')                                      END DT_INICIO_ABONO 
     , 2                                                                              AS IN_PREV_COMP
     , CASE WHEN F.COD_CARGO in (8,16,28,301,302)
            THEN (SELECT PE.VAL_ELEMENTO FROM TB_DET_PARAM_ESTRUTURA PE WHERE COD_ELEMENTO = 'TETO_MIN'
                     AND F.PER_PROCESSO BETWEEN PE.INI_VIG AND NVL(PE.FIM_VIG, TO_DATE('01/12/2099','DD/MM/YYYY')))
            ELSE (SELECT PE.VAL_ELEMENTO FROM TB_DET_PARAM_ESTRUTURA PE WHERE COD_ELEMENTO = 'TETO_PREF'
                     AND F.PER_PROCESSO BETWEEN PE.INI_VIG AND NVL(PE.FIM_VIG, TO_DATE('01/12/2099','DD/MM/YYYY')))
                                                                                      END VL_TETO_ESPECIFICO
     , ''
                                                                                 AS DT_PROV_APOSENT 
     , F.PER_PROCESSO                                                            AS PER_PROCESSO                  

FROM TB_HFOLHA_PAGAMENTO F
 INNER JOIN TB_ENTIDADE            E ON F.COD_ENTIDADE     = E.COD_ENTIDADE
 INNER JOIN TB_PESSOA_FISICA       P ON F.COD_IDE_CLI      = P.COD_IDE_CLI
 INNER JOIN TB_SERVIDOR            S ON P.COD_IDE_CLI      = S.COD_IDE_CLI
 LEFT  JOIN TB_DEPENDENTE          D ON F.COD_IDE_CLI      = D.COD_IDE_CLI_SERV
 INNER JOIN TB_RELACAO_FUNCIONAL   R ON F.COD_IDE_REL_FUNC = R.COD_IDE_REL_FUNC
 LEFT  JOIN TB_EVOLUCAO_FUNCIONAL EF ON F.COD_IDE_CLI      = EF.COD_IDE_CLI    AND
                                       P.COD_IDE_CLI      = EF.COD_IDE_CLI     AND 
                                       F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                             
WHERE --F.PER_PROCESSO = '01/12/2023'
 -- AND 
  F.TIP_PROCESSO = 'N' 
  AND F.NUM_GRP = 1
  AND EF.DAT_INI_EFEITO  = (SELECT MIN(EF1.DAT_INI_EFEITO) FROM
  TB_EVOLUCAO_FUNCIONAL EF1      WHERE EF.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF1.COD_CARGO = (SELECT EF2.COD_CARGO FROM
  TB_EVOLUCAO_FUNCIONAL EF2      WHERE EF2.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF2.DAT_FIM_EFEITO IS NULL))    
)
--------------------------------------------------------------------------------------
create or replace VIEW  VW_ATUARIAL_EXON AS
SELECT DISTINCT 
  
  COD_IDE_CLI,NOME,NU_ANO,NU_MES,CO_IBGE,NO_ENTE,SG_UF,CO_COMP_MASSA,CO_TIPO_FUNDO,
  NU_CNPJ_ORGAO,NO_ORGAO,CO_PODER,CO_TIPO_PODER,CO_TIPO_POPULACAO,CO_TIPO_CARGO,CO_CRITERIO_ELEGIBILIDADE,
  ID_SERVIDOR_MATRICULA,ID_SERVIDOR_CPF,ID_SERVIDOR_PIS_PASEP,CO_SEXO_SERVIDOR,CO_EST_CIVIL_SERVIDOR,
  DT_NASC_SERVIDOR,CO_SITUACAO,DT_SITUACAO,CO_TIPO_VINCULO,DT_ING_SERV_PUB,DT_ING_ENTE,
  DT_ING_CARREIRA,NO_CARREIRA,DT_ING_CARGO,NO_CARGO,VL_BASE_CALCULO,VL_REMUNERACAO,
  VL_CONTRIBUICAO,NU_TEMPO_RGPS,NU_TEMPO_RPPS_MUN,NU_TEMPO_RPPS_EST,NU_TEMPO_RPPS_FED,
  NU_DEPENDENTES,IN_ABONO_PERMANENCIA,DT_INICIO_ABONO,IN_PREV_COMP,VL_TETO_ESPECIFICO,
  PER_PROCESSO,DAT_FIM_EXERC
  
FROM 
(
SELECT DISTINCT
     
      F.COD_IDE_CLI, F.NOME 
     ,  TO_CHAR(F.PER_PROCESSO, 'YYYY')                                                AS NU_ANO
     , TO_CHAR(F.PER_PROCESSO, 'MM')                                                  AS NU_MES
     , '3509502'                                                                      AS CO_IBGE
     , 'CAMPINAS'                                                                     AS NO_ENTE
     , 'SP'                                                                           AS SG_UF
     , 1                                                                              AS CO_COMP_MASSA
     , CASE WHEN F.NUM_GRP IN (6) THEN 1  --'Plano Previdenciário'           
            WHEN F.NUM_GRP IN (5) THEN 2  --'Plano Financeiro'
                                                                                      END CO_TIPO_FUNDO
     , '06.916.689/0001-85'                                                           AS NU_CNPJ_ORGAO
     , E.NOM_ENTIDADE                                                                 AS NO_ORGAO
     , E.COD_PODER                                                                    AS CO_PODER
     , 2                                                                              AS CO_TIPO_PODER
     , 1                                                                              AS CO_TIPO_POPULACAO
     , 7                                                                              AS CO_TIPO_CARGO
     , 1                                                                              AS CO_CRITERIO_ELEGIBILIDADE
     , F.NUM_MATRICULA                                                                AS ID_SERVIDOR_MATRICULA
     , regexp_replace(LPAD(P.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_SERVIDOR_CPF
     , regexp_replace(LPAD(S.NUM_PIS, 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-') AS ID_SERVIDOR_PIS_PASEP
     , DECODE(P.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_SERVIDOR
     , DECODE(P.COD_EST_CIV, 1, 1, 2, 2, 3, 4, 9, 3, 5, 5, 6, 6, 9)                   AS CO_EST_CIVIL_SERVIDOR
     , P.DAT_NASC                                                                     AS DT_NASC_SERVIDOR
     , DECODE (R.COD_MOT_DESLIG, 5, 12)                                               AS CO_SITUACAO
     , R.DAT_FIM_EXERC                                                                AS DT_SITUACAO
     , 1                                                                              AS CO_TIPO_VINCULO
     , TO_DATE(S.DAT_ING_SERV_PUBLIC,'DD/MM/RRRR')                                    AS DT_ING_SERV_PUB
     , TO_DATE(R.DAT_INI_EXERC,'DD/MM/RRRR')                                          AS DT_ING_ENTE
     , TO_DATE(R.DAT_INI_EXERC,'DD/MM/RRRR')                                          AS DT_ING_CARREIRA
     
     , (SELECT distinct CA.NOM_CARREIRA FROM TB_EVOLUCAO_FUNCIONAL EF INNER JOIN TB_CARREIRA CA 
        ON EF.COD_CARREIRA = CA.COD_CARREIRA and EF.COD_ENTIDADE = CA.COD_ENTIDADE
       WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC AND F.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND 
       NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2100', 'DD/MM/YYYY')))                   AS NO_CARREIRA
    
     , EF.DAT_INI_EFEITO                                                              AS DT_ING_CARGO
     , (SELECT distinct CR.NOM_CARGO FROM TB_EVOLUCAO_FUNCIONAL EF INNER JOIN TB_CARGO CR 
        ON EF.COD_CARGO = CR.COD_CARGO and EF.COD_ENTIDADE = CR.COD_ENTIDADE
       WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC AND F.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND 
       NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2100', 'DD/MM/YYYY')))                   AS NO_CARGO
     
     , round((((SELECT SUM(FPD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET FPD 
                 WHERE F.COD_IDE_REL_FUNC = FPD.COD_IDE_REL_FUNC
                   AND F.PER_PROCESSO     = FPD.PER_PROCESSO
                   AND F.TIP_PROCESSO     = FPD.TIP_PROCESSO
                   AND TRUNC(FPD.COD_FCRUBRICA/100) IN (953))*100)/11),2)             AS VL_BASE_CALCULO
     
     , CASE WHEN (SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND F.PER_PROCESSO     = DET.PER_PROCESSO
                     AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (65600,65602,7300,7301,7302,7305,7400,7401,7405,
                     7500,7501,7505,7600,7601,7700,31000,31001,31002,11200,11201,12200,12201,2901)) > 0
        
            THEN ((SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.FLG_NATUREZA  = 'C') - 
                    
                  (SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.COD_FCRUBRICA IN (65600,65602,7300,7301,7302,7305,7400,7401,7405,
                     7500,7501,7505,7600,7601,7700,31000,31001,31002,11200,11201,12200,12201,2901)))
                        
            ELSE ((SELECT SUM(DET.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                    WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                      AND F.PER_PROCESSO     = DET.PER_PROCESSO
                      AND F.TIP_PROCESSO     = DET.TIP_PROCESSO
                      AND DET.FLG_NATUREZA  = 'C'))                                   END VL_REMUNERACAO

     , (SELECT SUM(FPD.VAL_RUBRICA) FROM TB_FOLHA_PAGAMENTO_DET FPD 
          WHERE F.COD_IDE_REL_FUNC = FPD.COD_IDE_REL_FUNC
            AND F.PER_PROCESSO     = FPD.PER_PROCESSO 
            AND F.TIP_PROCESSO     = FPD.TIP_PROCESSO 
            AND TRUNC(FPD.COD_FCRUBRICA/100) IN (953))                                AS VL_CONTRIBUICAO
     
     
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (1,7) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RGPS
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (2) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_MUN
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (3) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_EST
     , (SELECT SUM (HCT.QTD_TMP_AVE_DIA_TOTAL_CERT) FROM TB_HIST_CARTEIRA_TRAB HCT WHERE HCT.COD_EMISSOR IN (4) AND HCT.COD_IDE_CLI = P.COD_IDE_CLI) AS NU_TEMPO_RPPS_FED
     
     , ((SELECT COUNT(*) FROM TB_DEPENDENTE DEP WHERE DEP.COD_IDE_CLI_SERV = F.COD_IDE_CLI 
                                                  AND DEP.COD_PARENTESCO   IN (10,20,30)) + 
        (SELECT COUNT(*) FROM TB_DEPENDENTE DEP WHERE DEP.COD_IDE_CLI_SERV = F.COD_IDE_CLI 
                                                  AND DEP.COD_PARENTESCO   NOT IN (10,20,30)
                                                  AND DEP.COD_IDE_CLI_DEP  IN 
                                                  (SELECT PFFD.COD_IDE_CLI FROM TB_PESSOA_FISICA PFFD 
                                                    WHERE DEP.COD_IDE_CLI_DEP = PFFD.COD_IDE_CLI
                                                      AND PFFD.DAT_NASC >= '01/01/2002')))    AS NU_DEPENDENTES
    
     , CASE WHEN (SELECT DET.VAL_RUBRICA FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N') > 0 
            THEN  1 ELSE 2                                                               END IN_ABONO_PERMANENCIA
 
     , CASE WHEN (SELECT DET.VAL_RUBRICA FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N') > 0 
              
            THEN (SELECT MIN (DET.PER_PROCESSO) FROM TB_HFOLHA_PAGAMENTO_DET DET 
                   WHERE DET.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC
                     AND DET.PER_PROCESSO     = F.PER_PROCESSO
                     AND DET.TIP_PROCESSO     = F.TIP_PROCESSO
                     AND DET.COD_FCRUBRICA IN (13900,13901,13902,13951,49000,49001,49002) 
                     AND DET.TIP_PROCESSO = 'N')                                      END DT_INICIO_ABONO 
     , 2                                                                              AS IN_PREV_COMP
     , CASE WHEN F.COD_CARGO in (8,16,28)
            THEN (SELECT PE.VAL_ELEMENTO FROM TB_DET_PARAM_ESTRUTURA PE WHERE COD_ELEMENTO = 'TETO_MIN'
                     AND F.PER_PROCESSO BETWEEN PE.INI_VIG AND NVL(PE.FIM_VIG, TO_DATE('01/12/2099','DD/MM/YYYY')))
            ELSE (SELECT PE.VAL_ELEMENTO FROM TB_DET_PARAM_ESTRUTURA PE WHERE COD_ELEMENTO = 'TETO_PREF'
                     AND F.PER_PROCESSO BETWEEN PE.INI_VIG AND NVL(PE.FIM_VIG, TO_DATE('01/12/2099','DD/MM/YYYY')))
                                                                                      END VL_TETO_ESPECIFICO
     ,F.PER_PROCESSO
      ,DAT_FIM_EXERC
     
FROM TB_HFOLHA_PAGAMENTO F INNER JOIN TB_ENTIDADE            E ON F.COD_ENTIDADE     = E.COD_ENTIDADE
                           INNER JOIN TB_PESSOA_FISICA       P ON F.COD_IDE_CLI      = P.COD_IDE_CLI
                           INNER JOIN TB_SERVIDOR            S ON P.COD_IDE_CLI      = S.COD_IDE_CLI
                           LEFT  JOIN TB_DEPENDENTE          D ON F.COD_IDE_CLI      = D.COD_IDE_CLI_SERV
                           --LEFT  JOIN TB_PESSOA_FISICA       Z ON D.COD_IDE_CLI_DEP  = Z.COD_IDE_CLI
                           INNER JOIN TB_RELACAO_FUNCIONAL   R ON F.COD_IDE_REL_FUNC = R.COD_IDE_REL_FUNC
                           LEFT  JOIN TB_EVOLUCAO_FUNCIONAL EF ON F.COD_IDE_CLI      = EF.COD_IDE_CLI          AND
                                                                  P.COD_IDE_CLI      = EF.COD_IDE_CLI          AND 
                                                                  F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC 
 WHERE 

     F.TIP_PROCESSO = 'N' 

    
   and R.DAT_FIM_EXERC  =(SELECT MIN(EF1.DAT_FIM_EXERC) FROM
  TB_RELACAO_FUNCIONAL EF1      WHERE EF.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC)   
  AND R.NUM_MATRICULA  < 90
  AND R.COD_REGIME_JUR = 1 
  AND R.TIP_PROVIMENTO = 2
  AND R.COD_VINCULO    = 1
  AND R.COD_CARGO      < 500

  AND F.PER_PROCESSO||F.COD_IDE_CLI||R.DAT_FIM_EXERC IN 
  (
  SELECT PER_PROCESSO FROM 
(   
   SELECT    
   MAX(Z.PER_PROCESSO)|| K.COD_IDE_CLI||DAT_FIM_EXERC PER_PROCESSO, K.COD_IDE_CLI,DAT_FIM_EXERC                                      --        AS NU_MES     
   FROM TB_HFOLHA_PAGAMENTO Z INNER JOIN TB_ENTIDADE            E ON Z.COD_ENTIDADE     = E.COD_ENTIDADE
                            INNER JOIN TB_RELACAO_FUNCIONAL   K ON Z.COD_IDE_REL_FUNC = K.COD_IDE_REL_FUNC
                            LEFT  JOIN TB_EVOLUCAO_FUNCIONAL  Y ON Z.COD_IDE_CLI      = Y.COD_IDE_CLI          AND
                                                                  Z.COD_IDE_CLI      = Y.COD_IDE_CLI          AND 
                                                                  Z.COD_IDE_REL_FUNC = Y.COD_IDE_REL_FUNC 
 
           
WHERE  
   Z.TIP_PROCESSO = 'N' 
   AND Z.NUM_MATRICULA  < 90
   AND K.COD_REGIME_JUR = 1 
   AND K.TIP_PROVIMENTO = 2
   AND K.COD_VINCULO    = 1
   AND K.COD_CARGO      < 500
   AND Z.COD_IDE_CLI    = F.COD_IDE_CLI
   AND DAT_FIM_EXERC    IS NOT NULL 

   GROUP BY K.COD_IDE_CLI,DAT_FIM_EXERC 
    ))) 
   WHERE  VL_BASE_CALCULO IS NOT NULL 
   ORDER BY NOME, NU_MES 
------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_ATUARIAL_DEPENDENTES AS
SELECT DISTINCT
       TO_CHAR(F.PER_PROCESSO, 'YYYY')                                                AS NU_ANO
     , TO_CHAR(F.PER_PROCESSO, 'MM')                                                  AS NU_MES
     , '3509502'                                                                      AS CO_IBGE
     , 'CAMPINAS'                                                                     AS NO_ENTE
     , 'SP'                                                                           AS SG_UF
     , 1                                                                              AS CO_COMP_MASSA
     , CASE WHEN F.NUM_GRP IN (6) THEN 1  --'Plano Previdenciário'
            WHEN F.NUM_GRP IN (5) THEN 2  --'Plano Financeiro'
                                                                                      END CO_TIPO_FUNDO
     , '06.916.689/0001-85'                                                           AS CNPJ_ORGAO
     , E.NOM_ENTIDADE                                                                 AS NO_ORGAO
     , E.COD_PODER                                                                    AS CO_PODER
     , 2                                                                              AS CO_TIPO_PODER
     , F.NUM_MATRICULA                                                                AS ID_SEGURADO_MATRICULA
     , regexp_replace(LPAD(P.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_SEGURADO_CPF
     , CASE WHEN S.NUM_PIS IS NULL OR S.NUM_PIS = 0
            THEN regexp_replace(LPAD('00000000000', 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-')
            ELSE regexp_replace(LPAD(S.NUM_PIS, 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-')
                                                                                      END ID_SEGURADO_PIS_PASEP
     , DECODE(P.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_SEGURADO
     , F.NUM_MATRICULA||D.NUM_DEPEND                                                  AS ID_DEPENDENTE
     , regexp_replace(LPAD(Z.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_DEPENDENTE_CPF
     , Z.DAT_NASC                                                                     AS DT_NASC_DEPENDENTE
     , DECODE(Z.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_DEPENDENTE
     , DECODE(D.COD_TIP_CAP, 1, 1, 2,2, 3, 2, 1)                                      AS CO_CONDICAO_DEPENDENTE
     , DECODE (D.COD_PARENTESCO, '10', 1, '20', 1, '3', 2, '40', 4, '50', 5, 6)       AS CO_TIPO_DEPENDECIA
     , F.PER_PROCESSO

FROM TB_HFOLHA_PAGAMENTO F INNER JOIN TB_ENTIDADE            E ON F.COD_ENTIDADE     = E.COD_ENTIDADE
                           INNER JOIN TB_PESSOA_FISICA       P ON F.COD_IDE_CLI      = P.COD_IDE_CLI
                           INNER JOIN TB_SERVIDOR            S ON P.COD_IDE_CLI      = S.COD_IDE_CLI
                           LEFT  JOIN TB_DEPENDENTE          D ON F.COD_IDE_CLI      = D.COD_IDE_CLI_SERV
                           LEFT  JOIN TB_PESSOA_FISICA       Z ON D.COD_IDE_CLI_DEP  = Z.COD_IDE_CLI
                           INNER JOIN TB_RELACAO_FUNCIONAL   R ON F.COD_IDE_REL_FUNC = R.COD_IDE_REL_FUNC
                           LEFT  JOIN TB_EVOLUCAO_FUNCIONAL EF ON F.COD_IDE_CLI      = EF.COD_IDE_CLI          AND
                                                                  P.COD_IDE_CLI      = EF.COD_IDE_CLI          AND
                                                                  F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC

WHERE
--F.PER_PROCESSO = '01/12/2023'  AND
  F.TIP_PROCESSO = 'N'
  --AND F.NUM_MATRICULA  < 45
  AND F.NUM_GRP      = 6
  AND Z.NUM_CPF NOT IN ('00000000000','99999999999' )
  AND EF.DAT_INI_EFEITO  = (SELECT MIN(EF1.DAT_INI_EFEITO) FROM
  TB_EVOLUCAO_FUNCIONAL EF1      WHERE EF.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF1.COD_CARGO = (SELECT EF2.COD_CARGO FROM
  TB_EVOLUCAO_FUNCIONAL EF2      WHERE EF2.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF2.DAT_FIM_EFEITO IS NULL))
  UNION
  SELECT DISTINCT
       TO_CHAR(F.PER_PROCESSO, 'YYYY')                                                AS NU_ANO
     , TO_CHAR(F.PER_PROCESSO, 'MM')                                                  AS NU_MES
     , '3509502'                                                                      AS CO_IBGE
     , 'CAMPINAS'                                                                     AS NO_ENTE
     , 'SP'                                                                           AS SG_UF
     , 1                                                                              AS CO_COMP_MASSA
     , CASE WHEN F.NUM_GRP IN (6) THEN 1  --'Plano Previdenciário'
            WHEN F.NUM_GRP IN (5) THEN 2  --'Plano Financeiro'
                                                                                      END CO_TIPO_FUNDO
     , '06.916.689/0001-85'                                                           AS CNPJ_ORGAO
     , E.NOM_ENTIDADE                                                                 AS NO_ORGAO
     , E.COD_PODER                                                                    AS CO_PODER
     , 2                                                                              AS CO_TIPO_PODER
     , F.NUM_MATRICULA                                                                AS ID_SEGURADO_MATRICULA
     , regexp_replace(LPAD(P.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_SEGURADO_CPF
     , CASE WHEN S.NUM_PIS IS NULL OR S.NUM_PIS = 0
            THEN regexp_replace(LPAD('00000000000', 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-')
            ELSE regexp_replace(LPAD(S.NUM_PIS, 11),'([0-9]{3})([0-9]{5})([0-9]{2})','\1.\2.\3-')
                                                                                      END ID_SEGURADO_PIS_PASEP
     , DECODE(P.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_SEGURADO
     , F.NUM_MATRICULA||D.NUM_DEPEND                                                  AS ID_DEPENDENTE
     , regexp_replace(LPAD(Z.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-') AS ID_DEPENDENTE_CPF
     , Z.DAT_NASC                                                                     AS DT_NASC_DEPENDENTE
     , DECODE(Z.COD_SEXO, 'F', 1, 'M',2)                                              AS CO_SEXO_DEPENDENTE
     , DECODE(D.COD_TIP_CAP, 1, 1, 2,2, 3, 2, 1)                                      AS CO_CONDICAO_DEPENDENTE
     , DECODE (D.COD_PARENTESCO, '10', 1, '20', 1, '3', 2, '40', 4, '50', 5, 6)       AS CO_TIPO_DEPENDECIA
     , F.PER_PROCESSO

FROM TB_HFOLHA_PAGAMENTO F INNER JOIN TB_ENTIDADE            E ON F.COD_ENTIDADE     = E.COD_ENTIDADE
                           INNER JOIN TB_PESSOA_FISICA       P ON F.COD_IDE_CLI      = P.COD_IDE_CLI
                           INNER JOIN TB_SERVIDOR            S ON P.COD_IDE_CLI      = S.COD_IDE_CLI
                           LEFT  JOIN TB_DEPENDENTE          D ON F.COD_IDE_CLI      = D.COD_IDE_CLI_SERV
                           LEFT  JOIN TB_PESSOA_FISICA       Z ON D.COD_IDE_CLI_DEP  = Z.COD_IDE_CLI
                           INNER JOIN TB_RELACAO_FUNCIONAL   R ON F.COD_IDE_REL_FUNC = R.COD_IDE_REL_FUNC
                           LEFT  JOIN TB_EVOLUCAO_FUNCIONAL EF ON F.COD_IDE_CLI      = EF.COD_IDE_CLI          AND
                                                                  P.COD_IDE_CLI      = EF.COD_IDE_CLI          AND
                                                                  F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC

WHERE
--F.PER_PROCESSO = '01/12/2023'  AND
  F.TIP_PROCESSO = 'N'
  AND F.NUM_MATRICULA  = 1
  AND Z.NUM_CPF NOT IN ('00000000000','99999999999' )
  AND EF.DAT_INI_EFEITO  = (SELECT MIN(EF1.DAT_INI_EFEITO) FROM
  TB_EVOLUCAO_FUNCIONAL EF1      WHERE EF.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF1.COD_CARGO = (SELECT EF2.COD_CARGO FROM
  TB_EVOLUCAO_FUNCIONAL EF2      WHERE EF2.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF2.DAT_FIM_EFEITO IS NULL))

ORDER BY NO_ORGAO, ID_SEGURADO_MATRICULA, ID_DEPENDENTE
;
--------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_PROVISIONAMENTO AS
SELECT ANO,
       MATRICULA,
       COD_IDE_REL_FUNC,
       COD_IDE_CLI,
       NOME,
       DATA_INICIO,
       ANOS,
       LOTAÇÃO,
       COD_GRUPO,
       GRUPO,
       PER_PROCESSO,
       DAT_INI_EXERC,
       VALOR_TETO,
       NOM_CARGO,
       REFERENCIA,
       ATS,
       SEXTA_PARTE,
       SUCUMBENCIA,
       ARV,
       DIF_CARGO_DIRETOR,
       DIFERENCA_GRATIFICACAO,
       DIF_CARGO_EM_COMISSAO,
       FUNCAO_GRATIFICADA_DIF_OU_30,
       FUNCAO_GRATIFICADA_50,
       FUNCAO_GRATIFICADA_30,
       GRAT_INCORPORADA_50,
       INCORPORACAO_LEI,
       AJUSTE_EXC_TETO,

       ROUND((NVL(REFERENCIA, 0) + NVL(ATS, 0)   +
       NVL(SEXTA_PARTE, 0) + NVL(SUCUMBENCIA, 0) + NVL(ARV, 0) +
       NVL(DIF_CARGO_DIRETOR, 0) + NVL(DIFERENCA_GRATIFICACAO, 0) +
       NVL(DIF_CARGO_EM_COMISSAO, 0) + NVL(FUNCAO_GRATIFICADA_DIF_OU_30, 0) +
       NVL(FUNCAO_GRATIFICADA_50, 0) + NVL(FUNCAO_GRATIFICADA_30, 0) +
       NVL(GRAT_INCORPORADA_50, 0) + NVL(INCORPORACAO_LEI, 0) -
       NVL(AJUSTE_EXC_TETO, 0)) / 3,2) AS FERIAS_TERCO,

       ROUND((NVL(REFERENCIA, 0) + NVL(ATS, 0)   +
       NVL(SEXTA_PARTE, 0) + NVL(SUCUMBENCIA, 0) + NVL(ARV, 0) +
       NVL(DIF_CARGO_DIRETOR, 0) + NVL(DIFERENCA_GRATIFICACAO, 0) +
       NVL(DIF_CARGO_EM_COMISSAO, 0) + NVL(FUNCAO_GRATIFICADA_DIF_OU_30, 0) +
       NVL(FUNCAO_GRATIFICADA_50, 0) + NVL(FUNCAO_GRATIFICADA_30, 0) +
       NVL(GRAT_INCORPORADA_50, 0) + NVL(INCORPORACAO_LEI, 0) -
       NVL(AJUSTE_EXC_TETO, 0)),2) AS DECIMO_TERCEIRO_SALARIO

  FROM (SELECT DISTINCT to_char(FP.PER_PROCESSO, 'YYYY') + 1 AS ANO,
                        TO_NUMBER(EF.NUM_MATRICULA) AS MATRICULA,
                        ef.cod_ide_rel_func,
                        ef.cod_ide_cli,
                        PF.NOM_PESSOA_FISICA AS NOME,
                        RF.DAT_INI_EXERC AS DATA_INICIO,
                        (to_char(sysdate, 'yyyy') + 1) -
                        to_char(RF.DAT_INI_EXERC, 'yyyy') as ANOS,
                        OG.NOM_ORGAO AS LOTAÇÃO,
                        LTRIM(FP.NUM_GRP, 0) AS COD_GRUPO,
                        (SELECT GP.DES_GRP_PAG
                           FROM FOLHA_PAR.TB_GRUPO_PAGAMENTO GP
                          WHERE GP.NUM_GRP_PAG = FP.NUM_GRP) AS GRUPO,

                        FP.PER_PROCESSO,
                        RF.DAT_INI_EXERC,

                        (SELECT D.VAL_ELEMENTO
                           FROM TB_DET_PARAM_ESTRUTURA D
                          WHERE D.COD_PARAM IN ('TETO_PREF')
                            AND D.FIM_VIG IS NULL) as VALOR_TETO,
                        CG.NOM_CARGO,
                        (SELECT V.VAL_VENCIMENTO
                           FROM FOLHA_PAR.TB_VENCIMENTO V
                          WHERE EF.COD_REFERENCIA = V.COD_REFERENCIA
                            AND FP.PER_PROCESSO BETWEEN V.DAT_INI_VIG AND
                                NVL(V.DAT_FIM_VIG,
                                    TO_DATE('01/12/2999', 'DD/MM/YYYY'))) AS REFERENCIA,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (3000, 3002)) AS ATS,

                        CASE
                          WHEN (SELECT SUM(DET.VAL_RUBRICA)
                                  FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                                 WHERE DET.COD_IDE_REL_FUNC =
                                       RF.COD_IDE_REL_FUNC
                                   AND DET.PER_PROCESSO = FP.PER_PROCESSO
                                   AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                                   AND DET.COD_FCRUBRICA IN (3100, 9600, 9601)) > 0 THEN
                           (SELECT SUM(DET.VAL_RUBRICA)
                              FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                             WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                               AND DET.PER_PROCESSO = FP.PER_PROCESSO
                               AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                               AND DET.COD_FCRUBRICA IN (3100, 9600, 9601))
                          ELSE
                           0.00
                        END SEXTA_PARTE,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (2901)) as SUCUMBENCIA,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (1900, 1901)) as ARV,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (2500, 2501)) as DIF_CARGO_DIRETOR,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (3400, 3401, 3402, 3410)) as DIFERENCA_GRATIFICACAO,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (3500)) as DIF_CARGO_EM_COMISSAO,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (3600)) as FUNCAO_GRATIFICADA_DIF_OU_30,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (4500)) as FUNCAO_GRATIFICADA_50,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (4700, 4701)) as FUNCAO_GRATIFICADA_30,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (4800)) as GRAT_INCORPORADA_50,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (12600, 12601)) as INCORPORACAO_LEI,

                        (SELECT sum(DET.VAL_RUBRICA)
                           FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DET
                          WHERE DET.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                            AND DET.PER_PROCESSO = FP.PER_PROCESSO
                            AND DET.TIP_PROCESSO = FP.TIP_PROCESSO
                            AND DET.COD_FCRUBRICA IN (65600, 65601, 65602)) as AJUSTE_EXC_TETO

          FROM FOLHA_PAR.TB_PESSOA_FISICA      PF,
               FOLHA_PAR.TB_EVOLUCAO_FUNCIONAL EF,
               FOLHA_PAR.TB_CARGO              CG,
               FOLHA_PAR.TB_ORGAO              OG,
               FOLHA_PAR.TB_LOTACAO            LO,
               FOLHA_PAR.TB_RELACAO_FUNCIONAL  RF,
               FOLHA_PAR.TB_FOLHA_PAGAMENTO    FP
         WHERE LO.COD_ENTIDADE = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI = EF.COD_IDE_CLI
           AND LO.COD_IDE_REL_FUNC = FP.COD_IDE_REL_FUNC
           AND EF.COD_IDE_REL_FUNC = FP.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI = FP.COD_IDE_CLI
           AND EF.COD_IDE_CLI = FP.COD_IDE_CLI

           AND LO.COD_ENTIDADE = RF.COD_ENTIDADE
           AND LO.NUM_MATRICULA = RF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI = RF.COD_IDE_CLI
           AND LO.COD_INS = RF.COD_INS
           AND FP.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
           AND FP.COD_IDE_CLI = RF.COD_IDE_CLI

           AND EF.COD_CARGO = CG.COD_CARGO
           AND EF.COD_INS = CG.COD_INS
           AND (LAST_DAY(FP.PER_PROCESSO) BETWEEN EF.DAT_INI_EFEITO AND
               NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/12/2200', 'DD/MM/YYYY')) OR
               FP.PER_PROCESSO BETWEEN EF.DAT_INI_EFEITO AND
               NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/12/2200', 'DD/MM/YYYY')))

           AND RF.COD_ENTIDADE = CG.COD_ENTIDADE
           AND RF.COD_INS = CG.COD_INS

           AND EF.COD_IDE_CLI = RF.COD_IDE_CLI
           AND EF.COD_INS = RF.COD_INS

           AND PF.COD_IDE_CLI = RF.COD_IDE_CLI
           AND PF.COD_INS = RF.COD_INS

           AND OG.COD_INS = 1
           AND OG.COD_ENTIDADE = LO.COD_ENTIDADE
           AND OG.COD_ORGAO = LO.COD_ORGAO

           AND FP.PER_PROCESSO =
               (SELECT MAX(PER_PROCESSO)
                  FROM TB_HFOLHA_PAGAMENTO
                 WHERE TIP_PROCESSO = 'N')
           AND FP.TIP_PROCESSO = 'N'
           AND (FP.PER_PROCESSO BETWEEN LO.DAT_INI AND
               NVL(LO.DAT_FIM, TO_DATE('01/12/2200', 'DD/MM/YYYY')) OR
               LAST_DAY(FP.PER_PROCESSO) BETWEEN LO.DAT_INI AND
               NVL(LO.DAT_FIM, TO_DATE('01/12/2200', 'DD/MM/YYYY')))
           AND FP.NUM_GRP IN (5, 6)
           AND FP.TOT_CRED > 0)

           ORDER BY 8,5;
--------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_SERVIDOR AS
SELECT
----- BLOCO 1 -----
----- Dados Pessoais
      lpad(pf.num_cpf,11,'0')                                            as CPF
     ,pf.nom_pessoa_fisica                                               as NOME_SERVIDOR
     ,pf.dat_nasc                                                        as DATA_NASCIMENTO
     ,pf.cod_uf_nasc                                                     as UF_NASCIMENTO
     ,pf.des_natural                                                     as NATURALIDADE
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2003
                                 AND PF.cod_sexo = T3.cod_par)           as SEXO
     ,pf.num_folha_nasc                                                  as FOLHA_NASCIMENTO
     ,pf.num_cartorio_nasc                                               as CARTORIO_NASCIMENTO
     ,pf.num_livro_nasc                                                  as LIVRO_NASCIMENTO
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2006
                                 AND PF.cod_escola = T3.cod_par)         as ESCOLARIDADE
     ,pf.num_rg                                                          as RG
     ,pf.dat_emi_rg                                                      as RG_DATA_EMISSAO
     ,pf.cod_uf_emi_rg                                                   as RG_COD_UF
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2001
                                 AND PF.cod_org_emi_rg = T3.cod_par)     as RG_ORG_EMISSOR
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2004
                                 AND PF.cod_raca = T3.cod_par)           as RACA
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2005
                                 AND PF.cod_est_civ = T3.cod_par)        as ESTADO_CIVIL
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2028
                                 AND PF.cod_reg_casamento = T3.cod_par)  as REGIME_CASAMENTO
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2007
                                 AND PF.cod_nacio = T3.cod_par)          as NACIONALIDADE
     ,pf.dat_cheg_pais                                                   as DATA_CHEGADA_PAIS
     ,pf.num_cpf_mae                                                     as CPF_MAE
     ,pf.nom_mae                                                         as NOME_MAE
     ,pf.num_cpf_pai                                                     as CPF_PAI
     ,pf.nom_pai                                                         as NOME_PAI
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 10007
                                 AND PF.tip_num_tel_1 = T3.cod_par)      as TIPO_TELEFONE1
     ,pf.num_ramal_tel_1                                                 as RAMAL_TELEFONE1
     ,pf.num_tel_1                                                       as NUM_TELEFONE1
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 10007
                                 AND PF.tip_num_tel_2 = T3.cod_par)      as TIPO_TELEFONE2
     ,pf.num_ramal_tel_2                                                 as RAMAL_TELEFONE2
     ,pf.num_tel_2                                                       as NUM_TELEFONE2
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 10007
                                 AND PF.tip_num_tel_3 = T3.cod_par)      as TIPO_TELEFONE3
     ,pf.num_ramal_tel_3                                                 as RAMAL_TELEFONE3
     ,pf.num_tel_3                                                       as NUM_TELEFONE3
     ,pf.des_email                                                       as EMAIL
     ,pf.num_dep_ir                                                      as QTD_DEP_IR
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2077
                                 AND SS.cod_tip_cap = T3.cod_par)        as CAPACIDADE_SERVIDOR
----- BLOCO 2 -----
----- Data de Ingresso no Serviço Público / Data do Primeiro Emprego
     ,ss.dat_ing_serv_public                                             as DAT_ING_SERV_PUB
     ,ss.num_inscricao                                                   as NUM_INSCRICAO
     ,ss.dat_cadastramento                                               as DAT_CADASTRAMENTO
     ,pf.dat_recenseamento                                               as DAT_RECENCEAMENTO
----- BLOCO 3 -----
----- Óbito
     ,pf.dat_obito                                                       as DATA_OBITO
     ,pf.des_obito                                                       as DES_OBITO
     ,pf.dat_emi_atest_obito                                             as DATA_ATESTADO_OBITO
     ,pf.nom_resp_obito                                                  as NOME_RESP_OBITO
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2002
                                 AND PF.cod_tipo_resp_obito = T3.cod_par)as TIPO_RESP_OBITO
     ,pf.num_crm_obito                                                   as NUM_CRM_OBITO
----- BLOCO 4 -----
----- Conta Bancária
     ,ib.num_agencia            ||'-'||ib.num_dv_agencia                 as AGENCIA
     ,ib.num_conta              ||'-'||ib.num_dv_conta                   as CONTA
----- BLOCO 5 -----
----- Endereço
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2010
                                 AND en.cod_tipo_end = T3.cod_par)           as TIPO_ENDERECO
     ,en.nom_logradouro                                                      as LOGRADOURO
     ,en.num_numero                                                          as NUMERO
     ,en.des_complemento                                                     as COMPLEMENTO
     ,(select cb.bai_no from tb_correios_bairro cb
                       where en.cod_bairro = cb.bai_nu)                      as BAIRRO
     ,(select cm.loc_no from tb_correios_municipio cm
                           where en.cod_municipio = cm.loc_nu)               as MUNICIPIO
     ,en.cod_uf                                                              as UF
     ,en.num_cep                                                             as CEP
----- BLOCO 6 -----
\*----- Escolaridade
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2006
                                 AND ee.cod_grau = T3.cod_par)           as GRAU_ESCOLARIDADE
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 10063
                                 AND ee.cod_situacao = T3.cod_par)       as SITUACAO_ESCOLARIDADE
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 10062
                                 AND ee.cod_grau = T3.cod_par)           as CURSO
     ,ee.des_curso_outro                                                 as OUTRO_CURSO
     ,ee.ano_conclusao                                                   as ANO_CONCLUSAO*\
----- BLOCO 7 -----
----- Profissões
     ,case when pf.cod_escola in ('3','7','10') then
          (select f.nom_profissao from tb_pessoa_fisica_prof e, tb_profissao f
                                 where e.cod_ide_cli   = pf.cod_ide_cli
                     and e.cod_profissao = f.cod_profissao
                     and e.cod_profissao in (select max (g.cod_profissao) from tb_pessoa_fisica_prof g
                                                                                  where g.cod_ide_cli = e.cod_ide_cli))
      end                  as PROFISSAO
----- BLOCO 8 -----
----- Documentos
     ,ss.num_ctps                                                        as NUM_CART_TRABALHO
     ,ss.num_serie_ctps                                                  as SERIE_CART_TRABALHO
     ,ss.dat_emi_ctps                                                    as DAT_EMI_CART_TRABALHO
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2012
                                 AND SS.cod_uf_emi_ctps = T3.cod_par)    as UF_CART_TRABALHO
     ,ss.num_pis                                                         as NUM_PIS
     ,ss.num_nit_inss                                                    as NUM_NIT_INSS
     ,pf.num_tit_ele                                                     as NUM_TITULO_ELEITOR
     ,pf.num_zon_ele                                                     as ZONA_TITULO_ELEITOR
     ,pf.num_sec_ele                                                     as SECAO_TITULO_ELEITOR
     ,pf.num_cer_res                                                     as CERTI_RESERVISTA
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2012
                                 AND PF.cod_sit_mil = T3.cod_par)        as SITUACAO_MILITAR
     ,pf.dat_cam                                                         as DATA_CERTI_RESERVISTA
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2416
                                 AND PF.tip_cart_hab = T3.cod_par)       as TIPO_CART_HABILITACAO
     ,pf.num_cart_hab                                                    as NUM_CART_HABILITACAO
     ,pf.dat_val_cart_hab                                                as DAT_VAL_CART_HABILITACAO
     ,(SELECT T3.des_descricao FROM tb_codigo T3
                               WHERE T3.COD_INS = 0
                                 AND T3.cod_num = 2417
                                 AND PF.tip_sangue = T3.cod_par)         as TIPO_SANGUINIO,
       -----dados do vínculo---

       rf.dat_nomea as data_nomeacao,
       rf.dat_ini_exerc,
       rf.dat_fim_exerc,
       rf.dat_rescisao,
       rf.num_matricula as matricula,
       rf.cod_ide_rel_func as vinculo,
       case when rf.dat_fim_exerc is null then 'Ativo'
         else 'Exonerado' end SITUACAO,

       case when rf.dat_fim_exerc is null then 'S'
         else 'N' end ATIVO_S_N,

       case when rf.dat_fim_exerc is null then 'N'
         else 'S' end EXONERADO_S_N,

       (
       SELECT EF.COD_CARGO FROM TB_EVOLUCAO_FUNCIONAL EF
       WHERE EF.COD_INS= 1
       AND EF.COD_IDE_CLI = RF.COD_IDE_CLI
       AND EF.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
       AND EF.NUM_MATRICULA = RF.NUM_MATRICULA
       AND EF.COD_ENTIDADE = RF.COD_ENTIDADE
       AND EF.DAT_FIM_EFEITO IS NULL
       AND EF.FLG_STATUS = 'V'
       AND EF.DAT_INI_EFEITO =
                              (
                              SELECT MAX(EF1.DAT_INI_EFEITO) FROM TB_EVOLUCAO_FUNCIONAL EF1
                              WHERE EF1.COD_INS = 1
                              AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                              AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                              AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                              AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                              AND EF1.FLG_STATUS = 'V'
                              )
       )AS COD_CARGO,

       (
       SELECT C.NOM_CARGO
       FROM TB_EVOLUCAO_FUNCIONAL EF,
            TB_CARGO C
       WHERE EF.COD_INS= 1
       AND EF.COD_IDE_CLI = RF.COD_IDE_CLI
       AND EF.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
       AND EF.NUM_MATRICULA = RF.NUM_MATRICULA
       AND EF.COD_ENTIDADE = RF.COD_ENTIDADE
       AND EF.FLG_STATUS = 'V'
       AND C.COD_INS = 1
       AND C.COD_CARGO = EF.COD_CARGO
       AND C.COD_ENTIDADE = EF.COD_ENTIDADE
       AND EF.DAT_FIM_EFEITO IS NULL
       AND EF.DAT_INI_EFEITO =
                              (
                              SELECT MAX(EF1.DAT_INI_EFEITO) FROM TB_EVOLUCAO_FUNCIONAL EF1
                              WHERE EF1.COD_INS = 1
                              AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                              AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                              AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                              AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                              AND EF1.FLG_STATUS = 'V'
                              )
       )AS NOME_CARGO,

       rf.cod_proc_grp_pag as cod_grupo,

       (
       select gp.des_grp_pag from tb_grupo_pagamento gp
       where gp.num_grp_pag = rf.cod_proc_grp_pag
       )as nome_grupo,


       NVL((
       SELECT LO.COD_ORGAO FROM TB_LOTACAO LO
       WHERE LO.COD_INS = 1
       AND LO.COD_IDE_CLI = RF.COD_IDE_CLI
       AND LO.COD_ENTIDADE = RF.COD_ENTIDADE
       AND LO.NUM_MATRICULA = RF.NUM_MATRICULA
       AND LO.DAT_FIM       IS NULL
       AND LO.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
       AND LO.DAT_INI =
                      (
                      SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                      WHERE LO1.COD_INS = LO.COD_INS
                      AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                      AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                      AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                      AND LO1.COD_IDE_REL_FUNC =LO.COD_IDE_REL_FUNC
                      )
       ),0) AS COD_LOTACAO,

       NVL((
       SELECT ORG.NOM_ORGAO
       FROM TB_LOTACAO LO,
            TB_ORGAO ORG
       WHERE LO.COD_INS = 1
       AND LO.COD_IDE_CLI = RF.COD_IDE_CLI
       AND LO.COD_ENTIDADE = RF.COD_ENTIDADE
       AND LO.NUM_MATRICULA = RF.NUM_MATRICULA
       AND LO.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
       AND ORG.COD_INS = LO.COD_INS
       AND ORG.COD_ENTIDADE = LO.COD_ENTIDADE
       AND ORG.COD_ORGAO = LO.COD_ORGAO
       AND LO.DAT_FIM          IS NULL
       AND LO.DAT_INI =
                      (
                      SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                      WHERE LO1.COD_INS = LO.COD_INS
                      AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                      AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                      AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                      AND LO1.COD_IDE_REL_FUNC =LO.COD_IDE_REL_FUNC

                      )
       ),0) AS NOME_LOTACAO



 from tb_pessoa_fisica       pf,
      tb_servidor            ss,
      tb_informacao_bancaria ib,
      --tb_escolaridade        ee,
      tb_end_pessoa_fisica   en,
      tb_relacao_funcional   rf
where pf.cod_ide_cli = ss.cod_ide_cli
    and pf.cod_ide_cli  = ib.cod_ide_cli      (+)
    --and pf.cod_ide_cli  = ee.cod_ide_cli      (+)
    and pf.cod_ide_cli  = en.cod_ide_cli      (+)
    and rf.cod_ins      = 1
    and rf.cod_ide_cli  = pf.cod_ide_cli
    --and pf.num_cpf = '03644597430'

order by NOME_SERVIDOR
;
-----------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_EXTRATO_PREV_RPPS AS
SELECT TO_CHAR(HF.PER_PROCESSO,'YYYY') PER_PROCESSO, TO_CHAR(HF.PER_PROCESSO,'MM') MES,HF.NUM_MATRICULA,
       (SELECT F.NOM_PESSOA_FISICA FROM TB_PESSOA_FISICA F WHERE HF.COD_IDE_CLI = F.COD_IDE_CLI) AS NOME,
       (SELECT C.NOM_CARGO         FROM TB_CARGO C         WHERE RF.COD_CARGO   = C.COD_CARGO)   AS CARGO,

       (SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1))
          FROM TB_HFOLHA_PAGAMENTO_DET HFD
         WHERE HFD.COD_INS = 1
           AND HFD.TIP_PROCESSO  = HF.TIP_PROCESSO
           AND HFD.PER_PROCESSO  = HF.PER_PROCESSO
           AND HFD.NUM_MATRICULA = HF.NUM_MATRICULA
           AND HFD.COD_FCRUBRICA IN (SELECT CO.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CO
                                      WHERE CO.COD_FCRUBRICA_COMPOSTA IN (95300,95400,58200) -- foi adicionado INSS 09/03/2023
                                        AND CO.DAT_FIM_VIG IS NULL
                                        AND CO.COD_FCRUBRICA_COMPOE = HFD.COD_FCRUBRICA
                                   )
       )AS BASE_CONTRIBUICAO,

       (SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'D', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1))
          FROM TB_HFOLHA_PAGAMENTO_DET HFD
         WHERE HFD.COD_INS = 1
           AND HFD.TIP_PROCESSO = HF.TIP_PROCESSO
           AND HFD.PER_PROCESSO = HF.PER_PROCESSO
           AND HFD.NUM_MATRICULA= HF.NUM_MATRICULA
           AND HFD.COD_IDE_CLI = HF.COD_IDE_CLI
           AND TRUNC (HFD.COD_FCRUBRICA/100) in (953,954,582) -- foi adicionado INSS 09/03/2023

       )AS CONTRIBUICAO_SERVIDOR,

       ROUND(((SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'D', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1))
                 FROM TB_HFOLHA_PAGAMENTO_DET HFD
                WHERE HFD.COD_INS = 1
                  AND HFD.TIP_PROCESSO  = HF.TIP_PROCESSO
                  AND HFD.PER_PROCESSO  = HF.PER_PROCESSO
                  AND HFD.NUM_MATRICULA = HF.NUM_MATRICULA
                  AND HFD.COD_IDE_CLI   = HF.COD_IDE_CLI
                  AND TRUNC(HFD.COD_FCRUBRICA/100) IN (953,954,582) -- foi adicionado INSS 09/03/2023
              )/ -- divisão

              (SELECT (T.VAL_PER_TAXA/100) FROM TB_TAXA T
                WHERE HF.PER_PROCESSO BETWEEN T.DAT_INI_VIGENCIA
                  AND NVL(T.DAT_FIM_VIGENCIA, TO_DATE('01/12/2099'))
                  AND T.COD_PLANO     = 1
                  AND T.COD_REGIME    = 1
                  AND T.FLG_TIPO_TAXA = 'S'
              ))* --mutiplicação

              (SELECT (T.VAL_PER_TAXA/100) FROM TB_TAXA T
                WHERE HF.PER_PROCESSO BETWEEN T.DAT_INI_VIGENCIA
                  AND NVL(T.DAT_FIM_VIGENCIA, TO_DATE('01/12/2099'))
                  AND T.COD_PLANO     = 1
                  AND T.COD_REGIME    = 1
                  AND T.FLG_TIPO_TAXA = 'E'
              ),2) AS CONTRIBUICAO_PATRONAL

  FROM TB_HFOLHA_PAGAMENTO   HF,
       TB_RELACAO_FUNCIONAL RF
 WHERE HF.COD_INS = 1
   AND RF.COD_INS = 1
   AND RF.COD_IDE_CLI      = HF.COD_IDE_CLI
   AND RF.COD_ENTIDADE     = HF.COD_ENTIDADE
   AND RF.NUM_MATRICULA    = HF.NUM_MATRICULA
   AND RF.COD_IDE_REL_FUNC = HF.COD_IDE_REL_FUNC
   AND HF.TIP_PROCESSO = 'N'
  --AND HF.PER_PROCESSO between to_date('01/01/2022', 'dd/mm/yyyy') and to_date('01/12/2022', 'dd/mm/yyyy')
 --   AND HF.NUM_MATRICULA = 47
   AND EXISTS ( SELECT 1 FROM TB_HFOLHA_PAGAMENTO_DET HFD1
                 WHERE HFD1.COD_INS = 1
                   AND HFD1.TIP_PROCESSO = HF.TIP_PROCESSO
                   AND HFD1.SEQ_PAGAMENTO = HF.SEQ_PAGAMENTO
                   AND HFD1.PER_PROCESSO = HF.PER_PROCESSO
                   AND HFD1.COD_IDE_CLI = HF.COD_IDE_CLI
                   AND HFD1.COD_ENTIDADE = HF.COD_ENTIDADE
                   AND HFD1.COD_IDE_REL_FUNC = HF.COD_IDE_REL_FUNC
                   AND HFD1.NUM_MATRICULA = HF.NUM_MATRICULA
                   AND TRUNC (HFD1.COD_FCRUBRICA/100) in (953,954,582) -- foi adicionado INSS 09/03/2023
    )
  ORDER BY PER_PROCESSO,MES
;
-------------------------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_EXTRATO_PREV_RGPS_MAT AS
SELECT TO_CHAR(HF.PER_PROCESSO,'YYYY') PER_PROCESSO, TO_CHAR(HF.PER_PROCESSO,'MM') MES ,HF.NUM_MATRICULA,
       (SELECT F.NOM_PESSOA_FISICA FROM TB_PESSOA_FISICA F WHERE HF.COD_IDE_CLI = F.COD_IDE_CLI) AS NOME,
       (SELECT C.NOM_CARGO         FROM TB_CARGO C         WHERE RF.COD_CARGO   = C.COD_CARGO)   AS CARGO,

       (SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1))
          FROM TB_HFOLHA_PAGAMENTO_DET HFD
         WHERE HFD.COD_INS = 1
           AND HFD.TIP_PROCESSO  = HF.TIP_PROCESSO
           AND HFD.PER_PROCESSO  = HF.PER_PROCESSO
           AND HFD.NUM_MATRICULA = HF.NUM_MATRICULA
           AND HFD.COD_FCRUBRICA IN (SELECT CO.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CO
                                      WHERE CO.COD_FCRUBRICA_COMPOSTA IN (52800,52900)
                                        AND CO.DAT_FIM_VIG IS NULL
                                        AND CO.COD_FCRUBRICA_COMPOE = HFD.COD_FCRUBRICA
                                   )
       )AS BASE_CONTRIBUICAO,

       (SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'D', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1))
          FROM TB_HFOLHA_PAGAMENTO_DET HFD
         WHERE HFD.COD_INS = 1
           AND HFD.TIP_PROCESSO = HF.TIP_PROCESSO
           AND HFD.PER_PROCESSO = HF.PER_PROCESSO
           AND HFD.NUM_MATRICULA= HF.NUM_MATRICULA
           AND HFD.COD_IDE_CLI = HF.COD_IDE_CLI
           AND TRUNC (HFD.COD_FCRUBRICA/100) in (528,529)

       )AS CONTRIBUICAO_SERVIDOR,

       ROUND(((SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1))
          FROM TB_HFOLHA_PAGAMENTO_DET HFD
         WHERE HFD.COD_INS = 1
           AND HFD.TIP_PROCESSO  = HF.TIP_PROCESSO
           AND HFD.PER_PROCESSO  = HF.PER_PROCESSO
           AND HFD.NUM_MATRICULA = HF.NUM_MATRICULA
           AND HFD.COD_FCRUBRICA IN (SELECT CO.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CO
                                      WHERE CO.COD_FCRUBRICA_COMPOSTA IN (52800,52900)
                                        AND CO.DAT_FIM_VIG IS NULL
                                        AND CO.COD_FCRUBRICA_COMPOE = HFD.COD_FCRUBRICA
                                   )
              )
           -- INSS patronal = 20% da folha de pagamento + (RAT x FAP)
           -- Atualmente RAT = 2 e FAP = 0,5
           -- Resumindo 20% + 1% = 21%
             )* 21 ) / 100  AS CONTRIBUICAO_PATRONAL

  FROM TB_HFOLHA_PAGAMENTO   HF,
       TB_RELACAO_FUNCIONAL RF
 WHERE HF.COD_INS = 1
   AND RF.COD_INS = 1
   AND RF.COD_IDE_CLI      = HF.COD_IDE_CLI
   AND RF.COD_ENTIDADE     = HF.COD_ENTIDADE
   AND RF.NUM_MATRICULA    = HF.NUM_MATRICULA
   AND RF.COD_IDE_REL_FUNC = HF.COD_IDE_REL_FUNC
   AND HF.TIP_PROCESSO = 'N'
--   AND HF.PER_PROCESSO between to_date('01/01/2024', 'dd/mm/yyyy') and to_date('01/12/2024', 'dd/mm/yyyy')
--   AND HF.NUM_MATRICULA = 47
   AND EXISTS ( SELECT 1 FROM TB_HFOLHA_PAGAMENTO_DET HFD1
                 WHERE HFD1.COD_INS = 1
                   AND HFD1.TIP_PROCESSO = HF.TIP_PROCESSO
                   AND HFD1.SEQ_PAGAMENTO = HF.SEQ_PAGAMENTO
                   AND HFD1.PER_PROCESSO = HF.PER_PROCESSO
                   AND HFD1.COD_IDE_CLI = HF.COD_IDE_CLI
                   AND HFD1.COD_ENTIDADE = HF.COD_ENTIDADE
                   AND HFD1.COD_IDE_REL_FUNC = HF.COD_IDE_REL_FUNC
                   AND HFD1.NUM_MATRICULA = HF.NUM_MATRICULA
                   AND TRUNC (HFD1.COD_FCRUBRICA/100) in (528,529)
    )
  ORDER BY PER_PROCESSO,MES
;
    
------------------------------------------------------------------------------------
   -- Carlos     
create or replace view VW_DIAS_AFASTAMENTO AS
SELECT *
        FROM (SELECT MATRICULA,
                     PF.NOM_PESSOA_FISICA AS SERVIDOR,
                     DATA_INICIO,
                     DATA_FIM,
                     T.QTD_DIAS AS QTD_DIAS_AFAST,
                     (SELECT SUM(QTD_DIAS_ACUMULADO)
                        FROM (SELECT ((F2.DAT_RET_PREV - F2.DAT_INI_AFAST) + 1) AS QTD_DIAS_ACUMULADO,
                                     F2.NUM_MATRICULA AS MATRICULA
                                FROM TB_AFASTAMENTO F2, TB_PARAM_MOTIVO_AFAST F3
                               WHERE TRUNC(SYSDATE - 60) <= TRUNC(F2.DAT_INI_AFAST)
                                 AND F3.COD_MOT_AFAST = F2.COD_MOT_AFAST
                                 AND F2.COD_MOT_AFAST in (select cod_mot_afast  from tb_rel_mot_afast_grupo r where r.id_grupo = 15)
                              ) A
                       WHERE A.MATRICULA = T.MATRICULA                    
                       GROUP BY matricula) AS QTD_DIAS_ACUMULADO,
                     (SELECT ORG.NOM_ORGAO
                        FROM TB_LOTACAO LO, TB_ORGAO ORG
                       WHERE LO.COD_INS = 1
                         AND LO.NUM_MATRICULA = T.MATRICULA
                         AND LO.DAT_FIM IS NULL
                         AND ORG.COD_INS = 1
                         AND ORG.COD_ENTIDADE = LO.COD_ENTIDADE
                         AND ORG.COD_ORGAO = LO.COD_ORGAO) AS LOTACAO
                FROM (SELECT ((F2.DAT_RET_PREV - F2.DAT_INI_AFAST) + 1) AS QTD_DIAS,
                             F2.DAT_INI_AFAST AS DATA_INICIO,
                             F2.DAT_RET_PREV AS DATA_FIM,
                             F2.NUM_MATRICULA AS MATRICULA,
                             F2.COD_IDE_CLI AS COD_IDE_CLI
                        FROM TB_AFASTAMENTO F2, TB_PARAM_MOTIVO_AFAST F3                        
                       WHERE F3.COD_MOT_AFAST = F2.COD_MOT_AFAST
                         AND F2.COD_MOT_AFAST in (select cod_mot_afast  from tb_rel_mot_afast_grupo r where r.id_grupo = 15) 
                      ) T
               INNER JOIN TB_PESSOA_FISICA PF
                  ON T.COD_IDE_CLI = PF.COD_IDE_CLI
               GROUP BY MATRICULA,
                        DATA_INICIO,
                        DATA_FIM,
                        PF.NOM_PESSOA_FISICA,
                        T.QTD_DIAS
               ORDER BY TO_NUMBER(MATRICULA)               
               )
 
-------------------------------------------------------------------------------------------------
CREATE OR REPLACE  FUNCTION FNC_CALC_CONTRIB         (P_COD_INS          NUMBER
                                    ,P_COD_IDE_CLI      VARCHAR2
                                    ,P_COD_ENTIDADE     NUMBER
                                    ,P_NUM_MATRICULA    VARCHAR2
                                    ,P_COD_IDE_REL_FUNC NUMBER
                                    ,P_PER_PROCESSO     DATE
                                    ,P_TIP_PROCESSO     VARCHAR2
                                    ,P_SEQ_PAGAMENTO    NUMBER) RETURN VARCHAR2 IS
                                    
       V_VAL_CONTRIB         NUMBER(18,4)   DEFAULT 0.0000;
       VAL_TETO_INSS         NUMBER(18,4)   DEFAULT 0.0000;
       VAL_PER_TAXA_SER      NUMBER(18,4)   DEFAULT 14.0000;
       V_FLG_ISENCAO_CONTRIB VARCHAR2(1)    DEFAULT 'N';
                                    
  BEGIN
  
      
      SELECT VAL_PER_TAXA
        INTO VAL_PER_TAXA_SER
        FROM TB_TAXA TAX
       WHERE TAX.COD_INS       = P_COD_INS
         AND TAX.FLG_TIPO_TAXA = 'S'
         AND ((P_PER_PROCESSO BETWEEN TAX.DAT_INI_VIGENCIA AND TAX.DAT_FIM_VIGENCIA) OR (P_PER_PROCESSO >= TAX.DAT_INI_VIGENCIA AND TAX.DAT_FIM_VIGENCIA IS NULL));  
  
      
      SELECT VAL_ELEMENTO 
        INTO VAL_TETO_INSS 
        FROM TB_DET_PARAM_ESTRUTURA DP 
       WHERE DP.COD_ELEMENTO  = 'VAL_TETOINSS' 
         AND DP.COD_ESTRUTURA = 2000 
         AND DP.COD_PARAM     = 'TETOPM' 
         AND ((P_PER_PROCESSO BETWEEN DP.INI_VIG AND DP.FIM_VIG) OR (P_PER_PROCESSO >= DP.INI_VIG AND DP.FIM_VIG IS NULL));

      
      SELECT DECODE(COUNT(1), 0, 'N', 'S')
        INTO V_FLG_ISENCAO_CONTRIB
        FROM TB_ATRIBUTOS_PF      AP
           , TB_RELACAO_FUNCIONAL RF
       WHERE RF.COD_INS           = P_COD_INS
         AND RF.COD_ENTIDADE      = P_COD_ENTIDADE
         AND RF.COD_IDE_CLI       = P_COD_IDE_CLI
         AND RF.NUM_MATRICULA     = P_NUM_MATRICULA
         AND RF.COD_IDE_REL_FUNC  = P_COD_IDE_REL_FUNC
         AND RF.COD_INS           = AP.COD_INS
         AND RF.COD_IDE_CLI       = AP.COD_IDE_CLI
         AND AP.COD_ATRIBUTO      IN (7000)
         AND AP.FLG_STATUS        = 'V'
         AND P_PER_PROCESSO BETWEEN AP.DAT_INI_VIG AND NVL(AP.DAT_FIM_VIG, TO_DATE('01/01/2020','DD/MM/YYYY'))
         AND ((AP.DAT_INI_VIG    <= P_PER_PROCESSO
         AND AP.DAT_FIM_VIG      >= P_PER_PROCESSO) OR (AP.DAT_INI_VIG <= P_PER_PROCESSO AND AP.DAT_FIM_VIG IS NULL));
         
         IF (V_FLG_ISENCAO_CONTRIB = 'S') THEN
         
              SELECT 0
                INTO V_VAL_CONTRIB
                FROM DUAL
               WHERE V_FLG_ISENCAO_CONTRIB = 'S';
         ELSE
         
              SELECT SUM(TB1.VAL_CONTRIBUICAO)
                INTO V_VAL_CONTRIB
               FROM  (



                      SELECT SUM(VAL_RUBRICA) AS VAL_CONTRIBUICAO
                        FROM TB_FOLHA_PAGAMENTO_DET DC
                           , TB_FOLHA_PAGAMENTO     FO
                           , TB_RELACAO_FUNCIONAL   RF
                       WHERE V_FLG_ISENCAO_CONTRIB = 'N'
                         AND DC.COD_INS          = FO.COD_INS
                         AND DC.PER_PROCESSO     = FO.PER_PROCESSO
                         AND DC.TIP_PROCESSO     = FO.TIP_PROCESSO
                         AND DC.SEQ_PAGAMENTO    = FO.SEQ_PAGAMENTO
                         
                         AND DC.COD_IDE_CLI      = FO.COD_IDE_CLI
                         AND DC.COD_ENTIDADE     = FO.COD_ENTIDADE
                         AND DC.NUM_MATRICULA    = FO.NUM_MATRICULA
                         AND DC.COD_IDE_REL_FUNC = FO.COD_IDE_REL_FUNC                        
                         
                         AND FO.COD_INS          = P_COD_INS
                         AND FO.PER_PROCESSO     = P_PER_PROCESSO
                         AND FO.TIP_PROCESSO     = P_TIP_PROCESSO
                         AND FO.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
                         
                         AND RF.COD_IDE_CLI      = P_COD_IDE_CLI
                         AND RF.COD_ENTIDADE     = P_COD_ENTIDADE
                         AND RF.NUM_MATRICULA    = P_NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
                         
                         AND RF.COD_IDE_CLI      = FO.COD_IDE_CLI
                         AND RF.COD_ENTIDADE     = FO.COD_ENTIDADE
                         AND RF.NUM_MATRICULA    = FO.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = FO.COD_IDE_REL_FUNC                             
                         
                         AND DC.COD_FCRUBRICA IN (95300,95400,52800)

                         
                         
                         
                     UNION 
                        
                        SELECT SUM(VAL_RUBRICA) AS VAL_CONTRIBUICAO
                          FROM TB_FOLHA_PAGAMENTO_DET  DC
                             , TB_FOLHA_PAGAMENTO      FO
                             , TB_RELACAO_FUNCIONAL    RF
                         WHERE DC.COD_INS          = FO.COD_INS
                           AND DC.PER_PROCESSO     = FO.PER_PROCESSO
                           AND DC.TIP_PROCESSO     = FO.TIP_PROCESSO
                           AND DC.SEQ_PAGAMENTO    = FO.SEQ_PAGAMENTO
                           
                           AND DC.COD_IDE_CLI       = FO.COD_IDE_CLI
                           AND DC.COD_ENTIDADE      = FO.COD_ENTIDADE
                           AND DC.NUM_MATRICULA     = FO.NUM_MATRICULA
                           AND DC.COD_IDE_REL_FUNC  = FO.COD_IDE_REL_FUNC
                           
                           AND RF.COD_INS           = FO.COD_INS
                           AND RF.COD_IDE_CLI       = FO.COD_IDE_CLI
                           AND RF.COD_ENTIDADE      = FO.COD_ENTIDADE
                           AND RF.NUM_MATRICULA     = FO.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC  = FO.COD_IDE_REL_FUNC
                           
                           AND FO.COD_INS           = P_COD_INS
                           AND FO.PER_PROCESSO      = P_PER_PROCESSO
                           AND FO.TIP_PROCESSO      = P_TIP_PROCESSO
                           AND FO.SEQ_PAGAMENTO     = P_SEQ_PAGAMENTO
                           AND RF.COD_IDE_CLI       = P_COD_IDE_CLI
                           AND RF.COD_ENTIDADE      = P_COD_ENTIDADE
                           AND RF.NUM_MATRICULA     = P_NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC  = P_COD_IDE_REL_FUNC
                           

                           AND DC.COD_FCRUBRICA   IN (95301,95401,52801)
                 ) TB1;        
         
         END IF;
           
        RETURN NVL(V_VAL_CONTRIB, 0);

  EXCEPTION 
  WHEN OTHERS THEN
      
      RETURN NVL(V_VAL_CONTRIB, 0);
  
  END FNC_CALC_CONTRI
--*********************************************************************************
 CREATE OR REPLACE  FUNCTION FNC_CALC_IR
                                    (P_COD_INS          NUMBER
                                    ,P_COD_IDE_CLI      VARCHAR2
                                    ,P_COD_ENTIDADE     VARCHAR2
                                    ,P_NUM_MATRICULA    VARCHAR2
                                    ,P_COD_IDE_REL_FUNC VARCHAR2                                    
                                    ,P_PER_PROCESSO     DATE
                                    ,P_TIP_PROCESSO     VARCHAR2
                                    ,P_SEQ_PAGAMENTO    NUMBER) RETURN VARCHAR2 IS
                                    
       V_VAL_IR_PROP_BEN NUMBER(18,4) DEFAULT 0.0000;
       VAL_DED_IR_DEP    NUMBER(18,4) DEFAULT 189.59;
                                    
  BEGIN
  
        
      SELECT MIN(VAL_ELEMENTO)
        INTO VAL_DED_IR_DEP 
        FROM TB_DET_PARAM_ESTRUTURA DP 
       WHERE DP.COD_ELEMENTO  = 'IMPDE' 
         AND DP.COD_ESTRUTURA = 1000 
         AND DP.COD_PARAM     = 'IMPDE' 
         AND ((P_PER_PROCESSO BETWEEN DP.INI_VIG AND DP.FIM_VIG) OR (P_PER_PROCESSO >= DP.INI_VIG AND DP.FIM_VIG IS NULL));  
  
SELECT 

       ROUND(IR * PROPORCAO_IR, 2) IR_NOVO_X_BENEFICIARIO
  INTO V_VAL_IR_PROP_BEN       
  FROM (
         SELECT 
                NVL(CASE

                      WHEN ((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) >=                       
                           2259.21 AND ((BASE_IR_BRUTA - VAL_CONTRIB * ISENCAO_IR) - DEPIR - MAIOR_65) <= 2826.65) THEN
                       ROUND(((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) *
                             0.075) - 169.44,
                             2)
                      WHEN ((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) >=
                           2826.66 AND ((BASE_IR_BRUTA - VAL_CONTRIB * ISENCAO_IR) - DEPIR - MAIOR_65) <= 3751.05) THEN
                       ROUND(((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) * 0.15) -
                             381.44,
                             2)
                      WHEN ((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) >=
                           3751.06 AND ((BASE_IR_BRUTA - VAL_CONTRIB * ISENCAO_IR) - DEPIR -
                           MAIOR_65) <= 4664.68) THEN
                       ROUND(((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) *
                             0.225) - 662.77,
                             2)
                      WHEN ((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) >
                           4664.68) THEN
                       ROUND(((((BASE_IR_BRUTA - VAL_CONTRIB) * ISENCAO_IR) - DEPIR - MAIOR_65) *
                             0.275) - 896.00,
                             2)
                    END,
                    0) AS IR


                ,TRUNC(IR_CALCULADO_FOLHA / IR_CALCULADO_FOLHA_TOTAL, 7) AS PROPORCAO_IR
        
          FROM (
                 
                  SELECT DET.COD_ENTIDADE,
                         DET.NUM_MATRICULA,
                         DET.COD_IDE_REL_FUNC,
                         DET.COD_IDE_CLI,
                         FIS.DAT_NASC,                         
                         (SELECT SUM(CASE
                                       WHEN DET21.FLG_NATUREZA = 'C' THEN
                                        DET21.VAL_RUBRICA
                                       ELSE
                                        ABS(DET21.VAL_RUBRICA) * -1
                                     END
                                     )
                            FROM TB_FOLHA_PAGAMENTO_DET DET21
                               , TB_FOLHA_PAGAMENTO     FOL21
                           WHERE DET21.COD_INS          = DET.COD_INS
                             AND DET21.TIP_PROCESSO     = DET.TIP_PROCESSO
                             AND DET21.PER_PROCESSO     = DET.PER_PROCESSO
                             AND DET21.COD_IDE_CLI      = DET.COD_IDE_CLI
                             
                             AND FOL21.COD_INS          = DET21.COD_INS
                             AND FOL21.TIP_PROCESSO     = DET21.TIP_PROCESSO
                             AND FOL21.PER_PROCESSO     = DET21.PER_PROCESSO
                             AND FOL21.SEQ_PAGAMENTO    = DET21.SEQ_PAGAMENTO

                             AND FOL21.COD_IDE_CLI      = DET21.COD_IDE_CLI                             
                             AND FOL21.COD_ENTIDADE     = DET21.COD_ENTIDADE
                             AND FOL21.NUM_MATRICULA    = DET21.NUM_MATRICULA
                             AND FOL21.COD_IDE_REL_FUNC = DET21.COD_IDE_REL_FUNC
                             
                             AND EXISTS
                          
                           (SELECT 1
                                    FROM TB_RUBRICAS RUB
                                   WHERE RUB.COD_INS            = FOL21.COD_INS
                                     AND RUB.COD_ENTIDADE       = FOL21.COD_ENTIDADE
                                     AND TRUNC(RUB.COD_RUBRICA) = DET21.COD_FCRUBRICA
                                  
                                     AND ((RUB.FLG_EXTRA_FOLHA    = 'S') OR (RUB.FLG_DED_IR = 'S'))
                                     AND EXISTS (SELECT COD_RUBRICA 
                                                   FROM TB_PROC_ESP_INCIDENCIA_RUB EIR
                                                  WHERE EIR.COD_INS          = RUB.COD_INS 
                                                    AND EIR.COD_TIPO_ARQUIVO = 26 
                                                    AND EIR.FLG_INCIDENCIA   = 'S'
                                                    AND EIR.COD_ENTIDADE     = RUB.COD_ENTIDADE
                                                    AND EIR.COD_RUBRICA      = RUB.COD_RUBRICA)                                                    
                            )
                          
                          ) BASE_IR_BRUTA,
                         
                         
                         NVL((
                             
                             SELECT DISTINCT '0'
                               FROM TB_ATRIBUTOS_PF PF
                              WHERE PF.COD_INS      = DET.COD_INS
                                AND PF.COD_ATRIBUTO IN (8000) 
                                AND PF.COD_IDE_CLI  = DET.COD_IDE_CLI
                                AND P_PER_PROCESSO BETWEEN PF.DAT_INI_VIG AND NVL(PF.DAT_FIM_VIG, TO_DATE('01/01/2020','DD/MM/YYYY'))
                                AND PF.FLG_STATUS   = 'V'
                                AND ROWNUM < 2    
                             ),
                             1) ISENCAO_IR,                         
                         CASE
                           WHEN TO_CHAR(ADD_MONTHS(FIS.DAT_NASC, 780), 'YYYYMM') <= 
                                
                                TO_CHAR(LAST_DAY(P_PER_PROCESSO),'YYYYMM')
                           THEN
                            0
                           ELSE
                            0
                         END MAIOR_65,
                        NVL((FIS.NUM_DEP_IR * VAL_DED_IR_DEP), 0) DEPIR,    
                         CASE WHEN 
                           ( 
                          SELECT SUM(DET2.VAL_RUBRICA)
                            FROM TB_FOLHA_PAGAMENTO_DET DET2
                           WHERE DET2.COD_INS          = DET.COD_INS
                             AND DET2.TIP_PROCESSO     = DET.TIP_PROCESSO
                             AND DET2.PER_PROCESSO     = DET.PER_PROCESSO
                             AND DET2.SEQ_PAGAMENTO    = DET.SEQ_PAGAMENTO                             
                             AND DET2.COD_IDE_CLI      = DET.COD_IDE_CLI
                             AND DET2.COD_ENTIDADE     = DET.COD_ENTIDADE
                             AND DET2.NUM_MATRICULA    = DET.NUM_MATRICULA
                             AND DET2.COD_IDE_REL_FUNC = DET.COD_IDE_REL_FUNC
                             AND DET2.COD_FCRUBRICA IN (50200)) > 0
                          THEN    
                         ( 
                          SELECT SUM(DET2.VAL_RUBRICA)
                            FROM TB_FOLHA_PAGAMENTO_DET DET2
                           WHERE DET2.COD_INS          = DET.COD_INS
                             AND DET2.TIP_PROCESSO     = DET.TIP_PROCESSO
                             AND DET2.PER_PROCESSO     = DET.PER_PROCESSO
                             AND DET2.SEQ_PAGAMENTO    = DET.SEQ_PAGAMENTO                             
                             AND DET2.COD_IDE_CLI      = DET.COD_IDE_CLI
                             AND DET2.COD_ENTIDADE     = DET.COD_ENTIDADE
                             AND DET2.NUM_MATRICULA    = DET.NUM_MATRICULA
                             AND DET2.COD_IDE_REL_FUNC = DET.COD_IDE_REL_FUNC
                             AND DET2.COD_FCRUBRICA IN (50200)) 
                          ELSE 1 END IR_CALCULADO_FOLHA,
                         
                         CASE WHEN 
                           ( 
                          SELECT SUM(DET2.VAL_RUBRICA)
                            FROM TB_FOLHA_PAGAMENTO_DET DET2
                           WHERE DET2.COD_INS       = DET.COD_INS
                             AND DET2.TIP_PROCESSO  = DET.TIP_PROCESSO
                             AND DET2.PER_PROCESSO  = DET.PER_PROCESSO
                             AND DET2.COD_IDE_CLI      = DET.COD_IDE_CLI
                             
                             AND DET2.COD_FCRUBRICA IN (50200)) > 0
                             
                         THEN
                         ( 
                          SELECT SUM(DET2.VAL_RUBRICA)
                            FROM TB_FOLHA_PAGAMENTO_DET DET2
                           WHERE DET2.COD_INS       = DET.COD_INS
                             AND DET2.TIP_PROCESSO  = DET.TIP_PROCESSO
                             AND DET2.PER_PROCESSO  = DET.PER_PROCESSO
                             AND DET2.COD_IDE_CLI      = DET.COD_IDE_CLI
                             
                             AND DET2.COD_FCRUBRICA IN (50200)) 
                         ELSE 1 END IR_CALCULADO_FOLHA_TOTAL
                 
                          , FNC_CALC_CONTRIB(DET.COD_INS, DET.COD_IDE_CLI, DET.COD_ENTIDADE, DET.NUM_MATRICULA, DET.COD_IDE_REL_FUNC, DET.PER_PROCESSO, DET.TIP_PROCESSO, DET.SEQ_PAGAMENTO) AS VAL_CONTRIB
                
                   FROM TB_FOLHA_PAGAMENTO     DET,
                        TB_PESSOA_FISICA       FIS,
                        TB_RELACAO_FUNCIONAL    RF
                  WHERE DET.COD_INS         = P_COD_INS
                    AND DET.TIP_PROCESSO    = P_TIP_PROCESSO
                    AND DET.PER_PROCESSO    = P_PER_PROCESSO
                    AND DET.SEQ_PAGAMENTO   = P_SEQ_PAGAMENTO
                    
                    AND RF.COD_IDE_CLI      = DET.COD_IDE_CLI
                    AND RF.COD_ENTIDADE     = DET.COD_ENTIDADE
                    AND RF.NUM_MATRICULA    = DET.NUM_MATRICULA
                    AND RF.COD_IDE_REL_FUNC = DET.COD_IDE_REL_FUNC
                    
                    AND RF.COD_IDE_CLI      = P_COD_IDE_CLI
                    AND RF.COD_ENTIDADE     = P_COD_ENTIDADE
                    AND RF.NUM_MATRICULA    = P_NUM_MATRICULA
                    AND RF.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
                    
                    AND FIS.COD_INS         = DET.COD_INS
                    AND DET.COD_IDE_CLI     = FIS.COD_IDE_CLI     

                                )
        );
               
        RETURN V_VAL_IR_PROP_BEN;
       
  EXCEPTION 
  WHEN OTHERS THEN
      
      RETURN V_VAL_IR_PROP_BEN;        
  
  END FNC_CALC_IR;
--*****************************************************************************
CREATE OR REPLACE VIEW VW_MARGEM_CONSIG AS
SELECT LPAD(RF.NUM_MATRICULA, 10, '0') NUM_MATRICULA
        --  , '001'
         -- , '003'
          ,  LPAD(TRIM(TO_CHAR(((SUM(DECODE(DC.FLG_NATUREZA, 'C', DC.VAL_RUBRICA, 0)) - SUM(DECODE(DC.FLG_NATUREZA, 'D', DC.VAL_RUBRICA, 0)) - FNC_CALC_CONTRIB(DC.COD_INS, RF.COD_IDE_CLI, RF.COD_ENTIDADE, RF.NUM_MATRICULA, RF.COD_IDE_REL_FUNC, DC.PER_PROCESSO, DC.TIP_PROCESSO, DC.SEQ_PAGAMENTO) - FNC_CALC_IR(DC.COD_INS, RF.COD_IDE_CLI, RF.COD_ENTIDADE, RF.NUM_MATRICULA, RF.COD_IDE_REL_FUNC, DC.PER_PROCESSO, DC.TIP_PROCESSO, DC.SEQ_PAGAMENTO)) / 2), '99999D99')), 9, '0') VALOR
          ,  RPAD(PF.NOM_PESSOA_FISICA, 50, ' ')     NOM_PESSOA_FISICA
          ,  LPAD(PF.NUM_CPF,       11,'0')          NUM_CPF
          ,  LPAD(LTRIM(FO.COD_BANCO  ,'0'), 3, '0') COD_BANCO
          ,  LPAD(LTRIM(FO.NUM_AGENCIA,'0'), 4, '0') NUM_AGENCIA
          ,  LPAD(LTRIM(FO.NUM_CONTA,  '0'), 9, '0') NUM_CONTA
          ,  LPAD(FO.NUM_DV_CONTA,  1, '0')          NUM_DV_CONTA
          ,  LPAD(TO_CHAR(PF.DAT_NASC, 'DDMMRRRR'), 8, '0') DATA_NASCIMENTO
          ,  TO_CHAR(FO.PER_PROCESSO,'MM')||'/'||TO_CHAR(FO.PER_PROCESSO,'YYYY') PER_PROCESSO
      FROM TB_FOLHA_PAGAMENTO       FO
         , TB_FOLHA_PAGAMENTO_DET   DC
         , TB_RELACAO_FUNCIONAL     RF
         , TB_PESSOA_FISICA         PF
     WHERE FO.COD_INS            = 1
       AND FO.COD_INS            = RF.COD_INS
       AND FO.COD_IDE_CLI        = RF.COD_IDE_CLI
       AND FO.NUM_MATRICULA      = RF.NUM_MATRICULA
       AND FO.COD_IDE_REL_FUNC   = RF.COD_IDE_REL_FUNC
       AND FO.COD_INS            = DC.COD_INS
       AND FO.COD_IDE_CLI        = DC.COD_IDE_CLI
       AND FO.COD_ENTIDADE       = DC.COD_ENTIDADE
       AND FO.NUM_MATRICULA      = DC.NUM_MATRICULA
       AND FO.COD_IDE_REL_FUNC   = DC.COD_IDE_REL_FUNC
       AND FO.PER_PROCESSO       = DC.PER_PROCESSO
       AND FO.COD_IDE_CLI        = DC.COD_IDE_CLI
       AND RF.COD_INS            = PF.COD_INS
       AND RF.COD_IDE_CLI        = PF.COD_IDE_CLI
       AND FO.TIP_PROCESSO       = DC.TIP_PROCESSO
       AND FO.SEQ_PAGAMENTO      = DC.SEQ_PAGAMENTO
       AND RF.COD_ENTIDADE       = 1
       AND RF.COD_PROC_GRP_PAG   in (5,6)

   --    AND FO.PER_PROCESSO       = '01/01/2024'





       AND DC.COD_FCRUBRICA IN (SELECT 0 FROM DUAL
                                 UNION
                                SELECT COD_RUBRICA
                                  FROM TB_PROC_ESP_INCIDENCIA_RUB
                                 WHERE COD_TIPO_ARQUIVO = 26
                                   AND FLG_INCIDENCIA   = 'S')
       AND DC.COD_FCRUBRICA NOT IN (SELECT 0 FROM DUAL
                                    UNION
                                    SELECT COD_RUBRICA
                                      FROM TB_PROC_ESP_INCIDENCIA_RUB
                                     WHERE COD_TIPO_ARQUIVO = 26
                                      AND FLG_INCIDENCIA   = 'N')
         -- CEDIDOS
       AND NOT EXISTS (
          SELECT 1
            FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DC2
           WHERE DC2.COD_INS = DC.COD_INS
             AND DC2.COD_IDE_CLI      = DC.COD_IDE_CLI
             AND DC2.COD_ENTIDADE     = DC.COD_ENTIDADE
             AND DC2.NUM_MATRICULA    = DC.NUM_MATRICULA
             AND DC2.COD_IDE_REL_FUNC = DC.COD_IDE_REL_FUNC
             AND DC2.PER_PROCESSO     = DC.PER_PROCESSO
             AND DC2.NUM_MATRICULA    IN (379166,585440)
                      )
         -- FIM CEDIDOS

      AND NOT EXISTS (
          SELECT 1
            FROM TB_FOLHA_PAGAMENTO_DET DC2
           WHERE DC2.COD_INS = DC.COD_INS
             AND DC2.COD_IDE_CLI      = DC.COD_IDE_CLI
             AND DC2.COD_ENTIDADE     = DC.COD_ENTIDADE
             AND DC2.NUM_MATRICULA    = DC.NUM_MATRICULA
             AND DC2.COD_IDE_REL_FUNC = DC.COD_IDE_REL_FUNC
             AND DC2.PER_PROCESSO      = DC.PER_PROCESSO

             AND DC2.COD_FCRUBRICA IN (
                 3400,3402,3401
             )
       )
     GROUP
        BY DC.COD_INS
         , RF.COD_IDE_CLI
         , RF.COD_ENTIDADE
         , RF.NUM_MATRICULA
         , RF.COD_IDE_REL_FUNC
         , DC.PER_PROCESSO
         , DC.TIP_PROCESSO
         , DC.SEQ_PAGAMENTO
         , PF.NOM_PESSOA_FISICA
         , PF.NUM_CPF
         , FO.COD_BANCO
         , FO.NUM_AGENCIA
         , FO.NUM_CONTA
         , FO.NUM_DV_CONTA
         , PF.DAT_NASC
         , FO.PER_PROCESSO
         union


          SELECT "NUM_MATRICULA","'000000,00'","NOM_PESSOA_FISICA","NUM_CPF","COD_BANCO","NUM_AGENCIA","NUM_CONTA","NUM_DV_CONTA","DAT_NASC","PER_PROCESSO" FROM (
           SELECT DISTINCT LPAD(RF.NUM_MATRICULA, 10, '0') NUM_MATRICULA
         -- , '001'
         -- , '003'
          , '000000,00'
          ,  RPAD(PF.NOM_PESSOA_FISICA, 50, ' ') NOM_PESSOA_FISICA
          ,  LPAD(PF.NUM_CPF,       11,'0') NUM_CPF
          ,  LPAD(LTRIM(FO.COD_BANCO  ,'0'), 3, '0') COD_BANCO
          ,  LPAD(LTRIM(FO.NUM_AGENCIA,'0'), 4, '0') NUM_AGENCIA
          ,  LPAD(LTRIM(FO.NUM_CONTA,  '0'), 9, '0') NUM_CONTA
          ,  LPAD(FO.NUM_DV_CONTA,  1, '0') NUM_DV_CONTA
          ,  LPAD(TO_CHAR(PF.DAT_NASC, 'DDMMRRRR'), 8, '0') DAT_NASC
          , TO_CHAR(FO.PER_PROCESSO,'MM')||'/'||TO_CHAR(FO.PER_PROCESSO,'YYYY') PER_PROCESSO
      FROM TB_FOLHA_PAGAMENTO       FO
         , TB_FOLHA_PAGAMENTO_DET   DC
         , TB_RELACAO_FUNCIONAL     RF
         , TB_PESSOA_FISICA         PF
     WHERE FO.COD_INS            = 1
       AND FO.COD_INS            = RF.COD_INS
       AND FO.COD_IDE_CLI        = RF.COD_IDE_CLI
       AND FO.NUM_MATRICULA      = RF.NUM_MATRICULA
       AND FO.COD_IDE_REL_FUNC   = RF.COD_IDE_REL_FUNC
       AND FO.COD_INS            = DC.COD_INS
       AND FO.COD_IDE_CLI        = DC.COD_IDE_CLI
       AND FO.COD_ENTIDADE       = DC.COD_ENTIDADE
       AND FO.NUM_MATRICULA      = DC.NUM_MATRICULA
       AND FO.COD_IDE_REL_FUNC   = DC.COD_IDE_REL_FUNC
       AND FO.PER_PROCESSO       = DC.PER_PROCESSO
       AND FO.COD_IDE_CLI        = DC.COD_IDE_CLI
       AND RF.COD_INS            = PF.COD_INS
       AND RF.COD_IDE_CLI        = PF.COD_IDE_CLI
       AND FO.TIP_PROCESSO       = DC.TIP_PROCESSO
       AND FO.SEQ_PAGAMENTO      = DC.SEQ_PAGAMENTO
       AND RF.COD_ENTIDADE       = 1
       AND RF.COD_PROC_GRP_PAG   in (5,6)
   --   AND FO.PER_PROCESSO       = '01/01/2024'

       AND NOT EXISTS (
            SELECT 1
              FROM TB_FOLHA_PAGAMENTO       FO1
                 , TB_FOLHA_PAGAMENTO_DET   DC1
                 , TB_RELACAO_FUNCIONAL     RF1
                 , TB_PESSOA_FISICA         PF1
             WHERE FO1.COD_INS            = 1
               AND FO1.COD_INS            = RF1.COD_INS
               AND FO1.COD_IDE_CLI        = RF1.COD_IDE_CLI
               AND FO1.NUM_MATRICULA      = RF1.NUM_MATRICULA
               AND FO1.COD_IDE_REL_FUNC   = RF1.COD_IDE_REL_FUNC
               AND FO1.COD_INS            = DC1.COD_INS
               AND FO1.COD_IDE_CLI        = DC1.COD_IDE_CLI
               AND FO1.COD_ENTIDADE       = DC1.COD_ENTIDADE
               AND FO1.NUM_MATRICULA      = DC1.NUM_MATRICULA
               AND FO1.COD_IDE_REL_FUNC   = DC1.COD_IDE_REL_FUNC
               AND FO1.PER_PROCESSO       = DC1.PER_PROCESSO
               AND FO1.COD_IDE_CLI        = DC1.COD_IDE_CLI
               AND RF1.COD_INS            = PF1.COD_INS
               AND RF1.COD_IDE_CLI        = PF1.COD_IDE_CLI
               AND FO1.TIP_PROCESSO       = DC1.TIP_PROCESSO
               AND FO1.SEQ_PAGAMENTO      = DC1.SEQ_PAGAMENTO
               AND RF1.COD_ENTIDADE       = 1
               AND RF1.COD_PROC_GRP_PAG   in (5,6)

     --          AND FO1.PER_PROCESSO       = '01/01/2024'

               AND FO1.COD_INS            = FO.COD_INS
               AND FO1.COD_IDE_CLI        = FO.COD_IDE_CLI
               AND FO1.NUM_MATRICULA      = FO.NUM_MATRICULA
               AND FO1.COD_IDE_REL_FUNC   = FO.COD_IDE_REL_FUNC
               AND FO1.PER_PROCESSO       = FO.PER_PROCESSO

               AND DC1.COD_FCRUBRICA IN (SELECT 0 FROM DUAL
                                         UNION
                                        SELECT COD_RUBRICA
                                          FROM TB_PROC_ESP_INCIDENCIA_RUB
                                         WHERE COD_TIPO_ARQUIVO = 26
                                           AND FLG_INCIDENCIA   = 'S')
               AND DC1.COD_FCRUBRICA NOT IN (SELECT 0 FROM DUAL
                                            UNION
                                            SELECT COD_RUBRICA
                                              FROM TB_PROC_ESP_INCIDENCIA_RUB
                                             WHERE COD_TIPO_ARQUIVO = 26
                                              AND FLG_INCIDENCIA   = 'N')
     -- CEDIDOS
       AND NOT EXISTS (
          SELECT 1
            FROM FOLHA_PAR.TB_FOLHA_PAGAMENTO_DET DC2
           WHERE DC2.COD_INS = DC.COD_INS
             AND DC2.COD_IDE_CLI      = DC.COD_IDE_CLI
             AND DC2.COD_ENTIDADE     = DC.COD_ENTIDADE
             AND DC2.NUM_MATRICULA    = DC.NUM_MATRICULA
             AND DC2.COD_IDE_REL_FUNC = DC.COD_IDE_REL_FUNC
             AND DC2.PER_PROCESSO     = DC.PER_PROCESSO
             AND DC2.NUM_MATRICULA    IN (379166,585440)
                      )
       -- FIM CEDIDOS

               AND NOT EXISTS (
                  SELECT 1
                    FROM TB_FOLHA_PAGAMENTO_DET DC2
                   WHERE DC2.COD_INS          = DC1.COD_INS
                     AND DC2.COD_IDE_CLI      = DC1.COD_IDE_CLI
                     AND DC2.COD_ENTIDADE     = DC1.COD_ENTIDADE
                     AND DC2.NUM_MATRICULA    = DC1.NUM_MATRICULA
                     AND DC2.COD_IDE_REL_FUNC = DC1.COD_IDE_REL_FUNC
                     AND DC2.PER_PROCESSO     = DC1.PER_PROCESSO
                     AND DC2.COD_FCRUBRICA IN (
                         3400,3402,3401
                     )
               )
       )
     GROUP
        BY DC.COD_INS
         , RF.COD_IDE_CLI
         , RF.COD_ENTIDADE
         , RF.NUM_MATRICULA
         , RF.COD_IDE_REL_FUNC
         , DC.PER_PROCESSO
         , DC.TIP_PROCESSO
         , DC.SEQ_PAGAMENTO
         , PF.NOM_PESSOA_FISICA
         , PF.NUM_CPF
         , FO.COD_BANCO
         , FO.NUM_AGENCIA
         , FO.NUM_CONTA
         , FO.NUM_DV_CONTA
         , PF.DAT_NASC
         , FO.PER_PROCESSO

       )
;

-------------------------------------------------------------
CREATE OR REPLACE VIEW VW_FOLHA_BRUTA_ANUAL AS
SELECT * FROM
(
SELECT DISTINCT
      --regexp_replace(LPAD(P.NUM_CPF, 11),'([0-9]{3})([0-9]{3})([0-9]{3})','\1.\2.\3-')   AS CPF
       P.NUM_CPF                                                                         AS CPF
     , R.NUM_MATRICULA                                                                   AS MATRICULA
     , P.NOM_PESSOA_FISICA                                                               AS SERVIDOR
     , (SELECT CC.DES_DESCRICAO FROM TB_CODIGO CC WHERE CC.COD_NUM = 2139
                                     AND CC.COD_PAR = R.COD_VINCULO)                     AS TIPO_VINCULO
                                     
     , CASE WHEN (SELECT SUM(DD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DD
                   WHERE DD.NUM_MATRICULA = F.NUM_MATRICULA       AND DD.TIP_PROCESSO  = F.TIP_PROCESSO
                     AND DD.PER_PROCESSO  = F.PER_PROCESSO         AND DD.COD_IDE_CLI   = F.COD_IDE_CLI
                     AND DD.COD_FCRUBRICA IN (2901,65600,65601,65602,65603,12101,12200,12201)) > 0

            THEN CAST(nvl(((SELECT SUM(DD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DD
                   WHERE DD.NUM_MATRICULA = F.NUM_MATRICULA        AND DD.TIP_PROCESSO  = F.TIP_PROCESSO
                     AND DD.PER_PROCESSO  = F.PER_PROCESSO         AND DD.COD_IDE_CLI   = F.COD_IDE_CLI
                     AND DD.FLG_NATUREZA  = 'C') -

                 (SELECT SUM(DD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DD
                   WHERE DD.NUM_MATRICULA = F.NUM_MATRICULA        AND DD.TIP_PROCESSO  = F.TIP_PROCESSO
                     AND DD.PER_PROCESSO  = F.PER_PROCESSO         AND DD.COD_IDE_CLI   = F.COD_IDE_CLI
                     AND DD.COD_FCRUBRICA IN (2901,65600,65601,65602,65603,12101,12200,12201))),0) AS NUMBER(8,2))

            ELSE CAST(nvl(((SELECT SUM(DD.VAL_RUBRICA) FROM TB_HFOLHA_PAGAMENTO_DET DD
                   WHERE DD.NUM_MATRICULA = F.NUM_MATRICULA        AND DD.TIP_PROCESSO  = F.TIP_PROCESSO
                     AND DD.PER_PROCESSO  = F.PER_PROCESSO         AND DD.COD_IDE_CLI   = F.COD_IDE_CLI
                     AND DD.FLG_NATUREZA  = 'C')),0)AS NUMBER(8,2))                     END VALOR
    
    , CASE WHEN f.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(f.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(f.PER_PROCESSO,'YYYY')AS ANO_REF


FROM TB_HFOLHA_PAGAMENTO F INNER JOIN TB_PESSOA_FISICA       P ON F.COD_IDE_CLI        = P.COD_IDE_CLI
                           INNER JOIN TB_SERVIDOR            S ON P.COD_IDE_CLI        = S.COD_IDE_CLI
                           INNER JOIN TB_RELACAO_FUNCIONAL   R ON R.COD_IDE_CLI        = F.COD_IDE_CLI

WHERE  
--F.PER_PROCESSO >= '01/01/2023' and F.PER_PROCESSO < '01/01/2024'
--and 
F.TIP_PROCESSO in ('N','T')
)

pivot ( sum (VALOR) for (MES_REF )  IN (
'01' as "JAN",
'02' as "FEV",
'03' as "MAR",
'04' as "ABR",
'05' as "MAI",
'06' as "JUN",
'07' as "JUL",
'08' as "AGO",
'09' as "SETEM",
'10' as "OUT",
'11' as "NOV",
'12' as "DEZ",
'13' as "DEZ13"

))b;                   
------------------------------------------------------------------------------
DROP TABLE TB_AUDESP_FOLHA_ORDINARIA;
DROP TABLE TB_AUDESP_PAGTO_FOLHA_ORDINARIA;
DROP TABLE TB_AUDESP_RESUMO_MENSAL;
          
CREATE TABLE TB_AUDESP_FOLHA_ORDINARIA
(
   ANO                  VARCHAR2(4),
   MES                  VARCHAR2(2), 
   TIPO_DOCUMENTO       VARCHAR2(30),
   DATA_ATUAL           DATE, 
   CPF                  VARCHAR2(12),
   NOME                 VARCHAR2(100),
   MUNICIPIO_LOTACAO    VARCHAR2(100),
   ENTIDADE_LOTACAO     VARCHAR2(10),
   CARGO_POLITICO       NUMBER,
   FuncaoGoverno        VARCHAR2(3),
   CARGO                NUMBER,
   SITUACAO             NUMBER,
   REGIME_JUR           NUMBER,
   VALOR                VARCHAR2(20),             
   AUT_ACIM             NUMBER,
   TOT_Remuneracao_Bruta VARCHAR2(20),
   TOT_DESCONTO         VARCHAR2(20),
   VAL_LIQUIDO          VARCHAR2(20),                 
   COD_VERBA            NUMBER,                
   NATUREZA             VARCHAR2(10),                 
   ESPECIE              VARCHAR2(10),
   DAT_ULT_ATU_DAT_INGRESSO          DATE
 );                                            

 CREATE TABLE TB_AUDESP_PAGTO_FOLHA_ORDINARIA
(
   ANO                  VARCHAR2(4),
   MES                  VARCHAR2(2), 
   TIPO_DOCUMENTO       VARCHAR2(100),
   DATA_ATUAL           DATE, 
   CPF                  VARCHAR2(12),
   MUNICIPIO_LOTACAO    VARCHAR2(100),
   ENTIDADE_LOTACAO     VARCHAR2(10),
   CARGO                NUMBER,
   TIPO_CONTA           VARCHAR2(20),
   COD_BANCO            NUMBER , 
   AGENCIA              VARCHAR2(15),  
   CONTA                NUMBER,
   PAGO_CORRENTE        VARCHAR2(20),
   PAGO_OUTRAS          VARCHAR2(20),
   DAT_ULT_ATU_INGRESSO      DATE
 );
--------------------------------------------------------------------
CREATE TABLE TB_AUDESP_RESUMO_MENSAL
(
   ANO                      VARCHAR2(4),
   MES                      VARCHAR(2), 
   TIPO_DOCUMENTO           VARCHAR2(100),
   DATA_ATUAL               DATE,
   MUNICIPIO_LOTACAO        VARCHAR2(100),
   ENTIDADE_LOTACAO         VARCHAR(10),
   CONTR_PREV_GERAL_POL     VARCHAR2(20),
   CONTR_PREV_PROP_POL      VARCHAR2(20),
   CONTR_PREV_GERAL_NAO_POL VARCHAR2(20),
   CONTR_PREV_PROP_NAO_POL  VARCHAR2(20),
   DAT_ULT_ATU_INGRESSO     DATE
);
-------------------------------------------------------------
CREATE OR REPLACE VIEW VW_AUDESP_FOLHA_ORDINARIA AS
SELECT
    MES,
    ANO,
    TIPO_DOCUMENTO,
    DATA_ATUAL,
    CPF,
    NOME,
   'CAMPINAS' AS MUNICIPIO_LOTACAO,
   'INSTITUTO DE PREV.SOCIAL DO MUNIC.DE CPS-CAMPREV'  AS ENTIDADE_LOTACAO,
    CARGO_POLITICO,
    FUNCAOGOVERNO,
    C.NOM_CARGO CARGO,
    SITUACAO,
    REGIME_JUR,
    VALOR,
    AUT_ACIM,
    TOT_REMUNERACAO_BRUTA,
    TOT_DESCONTO,
    VAL_LIQUIDO,
    COD_VERBA,
    NATUREZA,
    ESPECIE,   
    MES||'/'||ANO PERIODO,
    DAT_ULT_ATU_DAT_INGRESSO

FROM  TB_AUDESP_FOLHA_ORDINARIA O
join  TB_CARGO C ON C.COD_CARGO = O.CARGO
;
---------------------------------------------------
create or replace view VW_AUDESP_PAGTO_FOLHA_ORDINARIA AS
SELECT 
ANO,
MES,
TIPO_DOCUMENTO,
DATA_ATUAL,
CPF,
MUNICIPIO_LOTACAO,
ENTIDADE_LOTACAO,
C.NOM_CARGO CARGO,
TIPO_CONTA,
COD_BANCO,
AGENCIA,
CONTA,
PAGO_CORRENTE,
PAGO_OUTRAS,
MES||'/'||ANO PERIODO,
DAT_ULT_ATU_INGRESSO
FROM  TB_AUDESP_PAGTO_FOLHA_ORDINARIA A
join  TB_CARGO C ON C.COD_CARGO = A.CARGO ;
-------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_AUDESP_RESUMO_MENSAL AS
SELECT 
ANO,
MES,
TIPO_DOCUMENTO,
DATA_ATUAL,
MUNICIPIO_LOTACAO,
ENTIDADE_LOTACAO,
CONTR_PREV_GERAL_POL,
CONTR_PREV_PROP_POL,
CONTR_PREV_GERAL_NAO_POL,
CONTR_PREV_PROP_NAO_POL,
MES||'/'||ANO PERIODO,
DAT_ULT_ATU_INGRESSO
FROM TB_AUDESP_RESUMO_MENSAL
----------------------------------------------------------------*/
CREATE OR REPLACE VIEW VW_INSUFICIENCIA_SALDO_ATIVO AS
SELECT
        F.NUM_MATRICULA AS MATRICULA,
        F.NUM_CPF       AS CPF,
        F.NOME          AS NOME,
        F.PER_PROCESSO  AS PERIODO,
        F.TOT_CRED      AS CREDITO,
        F.TOT_DEB       AS DEBITO,
        F.VAL_LIQUIDO   AS LIQUIDO

FROM TB_FOLHA_PAGAMENTO F WHERE F.VAL_LIQUIDO < '0'  AND F.NUM_MATRICULA IN
(SELECT D.NUM_MATRICULA FROM TB_FOLHA_PAGAMENTO_DET D 
WHERE D.PER_PROCESSO = F.PER_PROCESSO  AND D.TIP_PROCESSO = F.TIP_PROCESSO
AND D.COD_FCRUBRICA >= 50000)

ORDER BY NOME;




