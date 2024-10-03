DECLARE
BEGIN
  
 INSERT INTO reltabela
 SELECT MAX(COD_TABELA)+1,'VW_QTDE_VAGAS_OCUPADAS','Quantidade de vagas existentes e Ocupadas',MAX(COD_TABELA)+1 from reltabela;   

  INSERT INTO reltabela   
  SELECT MAX(COD_TABELA)+1,'VW_CONTROLE_ORGAO_LOTACAO','Quantidade de Vagas existentes e Ocupadas por Lotação',MAX(COD_TABELA)+1 from reltabela;

  INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_AUTORIAL_SERVIDORES','Arquivos e relatórios necessários para utilização em cálculo atuarial.',MAX(COD_TABELA)+1 from reltabela;
 
 INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_AUTORIAL_EXON','Arquivos e relatórios necessários para utilização da XENON.',MAX(COD_TABELA)+1 from reltabela;

 INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_AUTORIAL_DEPENDENTES','Arquivos e relatórios necessários para utilização da Dependentes.',MAX(COD_TABELA)+1 from reltabela;




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
create or replace VIEW  VW_AUTORIAL_SERVIDORES AS
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
create or replace VIEW  VW_AUTORIAL_EXON AS
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
--F.PER_PROCESSO >= '01/01/2023' AND
  F.TIP_PROCESSO = 'N' 
  AND F.NUM_MATRICULA  < 45
 -- AND R.DAT_FIM_EXERC <= '31/12/2023'    
  AND EF.DAT_INI_EFEITO  =(SELECT MIN(EF1.DAT_INI_EFEITO) FROM
  TB_EVOLUCAO_FUNCIONAL EF1      WHERE EF.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF1.COD_CARGO = (SELECT EF2.COD_CARGO FROM
  TB_EVOLUCAO_FUNCIONAL EF2      WHERE EF2.COD_IDE_REL_FUNC = EF1.COD_IDE_REL_FUNC
  AND EF2.DAT_FIM_EFEITO IS NULL))
            
  
ORDER BY NOME, NU_MES  

------------------------------------------------------------------
CREATE OR REPLACE VIEW VW_AUTORIAL_DEPENDENTES AS
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
