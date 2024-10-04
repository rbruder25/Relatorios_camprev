--AtosPessoal_FolhaOrdinaria
INSERT INTO reltabela  
  SELECT MAX(COD_TABELA)+1,'VW_PESSOAL_FOLHA_ORDINARIA','Relatório de Passoal folha ordinária',MAX(COD_TABELA)+1 from reltabela
------------------------------------------------------------------------------------------------------------------------  
create or replace VW_PESSOAL_FOLHA_ORDINARIA AS 
SELECT
        A.PER_PROCESSO
       ,A.COD_ENTIDADE
       ,B.NUM_CPF
       ,A.COD_IDE_CLI
       ,A.NOME                             AS NOM_BEN
       ,A.COD_CARGO
       ,TO_CHAR(A.PER_PROCESSO,'YYYY')     AS ANO_EXERCIO
       ,TO_CHAR(A.PER_PROCESSO,'MM')       AS MES_EXERCIO
       ,TO_CHAR(B.DAT_NASC,'DD/MM/YYYY')   AS DAT_NASC
       ,REPLACE(A.TOT_CRED,',','.')        AS TOT_CRED
       ,REPLACE(A.TOT_DEB,',','.')         AS TOT_DEB
       ,REPLACE(A.VAL_LIQUIDO,',','.')     AS VAL_LIQUIDO
       , NVL((SELECT T3.DES_DESCRICAO
              FROM TB_CODIGO T3
             WHERE T3.COD_INS = 0
               AND T3.COD_NUM = 2015
               AND T3.COD_PAR = E.COD_PARENTESCO),
            '-')                  AS NOM_PARENTESCO
       ,E.COD_PARENTESCO          AS COD_PARENTESCO
       ,B.COD_SEXO
       ,FNC_DEPARA_NOME(1,'e.COD_PARENTESCO-L.69',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 
       ,A.PER_PROCESSO

   FROM TB_HFOLHA_PAGAMENTO      A, 
        TB_PESSOA_FISICA         B,
        TB_DEPENDENTE            E
  WHERE A.COD_ENTIDADE         =  A.COD_ENTIDADE
    AND A.PER_PROCESSO         = '01/08/2024'
    AND A.TIP_PROCESSO         = 'N' 
    AND A.COD_ENTIDADE         = '1' 
    AND A.COD_IDE_CLI          = B.COD_IDE_CLI
    AND A.COD_INS              = E.COD_INS          (+)
    AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
    AND A.NUM_GRP              <> 3
    AND A.TOT_CRED             != 0
    AND A.TOT_DEB              != 0
    ORDER BY B.NOM_PESSOA_FISICA;
    
------------------------------------------------------------------------------------
--AtosPessoal_FolhaOrdinaria_linha
create or replace VW_PESSOAL_FOLHA_ORDINARIA_LINHA AS 
   SELECT 

          REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'C',VAL_RUBRICA, NULL))),',','.')   AS PROVENTO
         ,REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'D', VAL_RUBRICA, NULL))),',','.')  AS DESCONTO
         ,DECODE(R1.TIP_EVENTO,'N','2','1')                                                 AS NATUREZA
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')                                          AS ESPECIE
         ,R1.COD_CONCEITO                                                                   AS RUBRICAS
         ,R1.COD_VERBA                                                                      AS TIPO_AUDESP
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_vinculo-L.116',RF.COD_VINCULO) AS CARGO_POLITICO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_sit_prev-L.121',RF.COD_SIT_PREV) AS COD_SITUACAO 


         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.128',RF.COD_REGIME_JUR) AS ESTAGIARIO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.133',RF.COD_REGIME_JUR) AS COD_REGIME_JURIDICO



    FROM TB_HFOLHA_PAGAMENTO_DET         D1,
         TB_HFOLHA_PAGAMENTO             F1,
         TB_RUBRICA_VERBA_AUDESP         R1,
         TB_PESSOA_FISICA                PF,
         TB_RELACAO_FUNCIONAL RF
   WHERE D1.COD_INS              = 1
     AND D1.PER_PROCESSO         = P_PERPROCESSO
     AND D1.TIP_PROCESSO         = 'N'
     AND D1.SEQ_PAGAMENTO        = 1
     AND D1.COD_IDE_CLI          = PF.COD_IDE_CLI
     AND PF.NUM_CPF              = P_NUM_CPF
     AND D1.COD_INS              = F1.COD_INS
     AND D1.PER_PROCESSO         = F1.PER_PROCESSO
     AND D1.TIP_PROCESSO         = F1.TIP_PROCESSO
     AND D1.SEQ_PAGAMENTO        = F1.SEQ_PAGAMENTO
     AND D1.COD_IDE_CLI          = F1.COD_IDE_CLI
     AND R1.COD_INS              = D1.COD_INS
     AND D1.TIP_PROCESSO         = 'N'
     AND R1.COD_ENTIDADE         = F1.COD_ENTIDADE
     AND R1.COD_RUBRICA          = D1.COD_FCRUBRICA

     AND RF.COD_IDE_CLI          = D1.COD_IDE_CLI
     AND RF.COD_IDE_CLI          = F1.COD_IDE_CLI     
     AND RF.COD_IDE_CLI          = PF.COD_IDE_CLI      
     AND F1.NUM_GRP              <> 3


    AND RF.COD_ENTIDADE          = D1.COD_ENTIDADE
    AND RF.NUM_MATRICULA         = D1.NUM_MATRICULA
    AND RF.COD_IDE_REL_FUNC      = D1.COD_IDE_REL_FUNC

    AND D1.COD_ENTIDADE          = F1.COD_ENTIDADE
    AND D1.NUM_MATRICULA         = F1.NUM_MATRICULA
    AND D1.COD_IDE_REL_FUNC      = F1.COD_IDE_REL_FUNC

GROUP BY  DECODE(R1.TIP_EVENTO,'N','2','1')
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')
         ,R1.COD_VERBA
         ,R1.COD_VERBA
         ,R1.COD_CONCEITO
         ,RF.COD_VINCULO
         ,RF.COD_SIT_PREV
         ,RF.COD_REGIME_JUR;
 -------------------------------------------------------------------------------        

