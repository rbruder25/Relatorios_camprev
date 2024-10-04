--AtosPessoal_FolhaOrdinaria
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
