INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_DIAS_AFASTAMENTO','Relatórios de dias afastado',MAX(COD_TABELA)+1 from reltabela;


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
              
