CREATE OR REPLACE VIEW VW_FICHAS_FINANCEIRA_POR_ANO_ATIVOS AS
SELECT "ANO_REF","MATRICULA","DAT_ADMISSAO","NOME","COD_CARGO","NOM_CARGO","COD_FCRUBRICA","DES_RUBRICA","NATUREZA","JANEIRO","FEVEREIRO","MARÇO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO","DECIMO_TERCEIRO"
FROM
(

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA AS MATRICULA,-- BEN.NUM_PRONTUARIO AS PRONTUARIO,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,
      HFPD.COD_FCRUBRICA,
      HFPD.FLG_NATUREZA AS FLG_NATUREZA,

      NVL((
      SELECT DISTINCT R.NOM_RUBRICA  FROM TB_RUBRICAS R
      WHERE R.COD_INS = 1
      AND R.COD_ENTIDADE = HFP.COD_ENTIDADE
      AND R.COD_RUBRICA = HFPD.COD_FCRUBRICA
      ) ,
          (
          SELECT DISTINCT CP.NOM_CONCEITO FROM TB_CONCEITOS_PAG CP
          WHERE CP.COD_INS = 1
          AND CP.COD_ENTIDADE = HFP.COD_ENTIDADE
          AND CP.COD_CONCEITO = TRUNC(HFPD.COD_FCRUBRICA/100)
          ))AS DES_RUBRICA,
      HFPD.FLG_NATUREZA AS NATUREZA,

      ROUND(HFPD.VAL_RUBRICA,2) AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM Tb_Hfolha_Pagamento     HFP,
     TB_HFOLHA_PAGAMENTO_DET HFPD,
	  TB_RELACAO_FUNCIONAL     RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFPD.COD_INS             = HFP.COD_INS
AND HFPD.PER_PROCESSO        = HFP.PER_PROCESSO
AND HFPD.TIP_PROCESSO        = HFP.TIP_PROCESSO
AND HFPD.SEQ_PAGAMENTO       = HFP.SEQ_PAGAMENTO
AND HFPD.COD_IDE_CLI         = HFP.COD_IDE_CLI
AND HFPD.COD_IDE_CLI         = PF.COD_IDE_CLI
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/08/2015','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         != 3
AND NOT EXISTS
                 (
                 SELECT 1 FROM TB_IMPRESAO_RUB IMP
                 WHERE IMP.COD_INS = 1
                 AND IMP.COD_RUBRICA = HFPD.COD_FCRUBRICA
                 AND IMP.COD_ENTIDADE = HFP.COD_ENTIDADE
                 AND IMP.COD_TIPO_PROCESSO = HFPD.TIP_PROCESSO
                 AND IMP.FLG_IMPRIME = 'N'
                  )

)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', ROUND(VAL_RUBRICA,2), ROUND(VAL_RUBRICA*-1,2))) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))


UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,-- BEN.NUM_PRONTUARIO AS PRONTUARIO,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,

      'C' AS FLG_NATUREZA,

      99000 AS COD_RUBRICA,
      'TOTAL CREDITO' AS DES_RUBRICA,
      'C' AS NATUREZA,

      HFP.TOT_CRED AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO     HFP,
     TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/08/2015','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         != 3

)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', VAL_RUBRICA, VAL_RUBRICA)) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))

UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,--  BEN.NUM_PRONTUARIO AS PRONTUARIO,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,


      'D' AS FLG_NATUREZA,

      99100 AS COD_RUBRICA,
      'TOTAL DEBITO' AS DES_RUBRICA,
      'D' AS NATUREZA,

      HFP.TOT_DEB AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO     HFP,
     TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/08/2015','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         != 3
)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', VAL_RUBRICA, VAL_RUBRICA)) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))

UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,


      'L' AS FLG_NATUREZA,

      99200 AS COD_RUBRICA,
      'TOTAL LIQUIDO' AS DES_RUBRICA,
      'L' AS NATUREZA,

      HFP.VAL_LIQUIDO AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO     HFP,
     TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/08/2015','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         != 3
)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', VAL_RUBRICA, VAL_RUBRICA)) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))

UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,

      HFPD.COD_FCRUBRICA,
      HFPD.FLG_NATUREZA AS FLG_NATUREZA,

      NVL((
      SELECT DISTINCT R.NOM_RUBRICA  FROM TB_RUBRICAS R
      WHERE R.COD_INS = 1
      AND R.COD_ENTIDADE = HFP.COD_ENTIDADE
      AND R.COD_RUBRICA = HFPD.COD_FCRUBRICA
      ) ,
          (
          SELECT DISTINCT CP.NOM_CONCEITO FROM TB_CONCEITOS_PAG CP
          WHERE CP.COD_INS = 1
          AND CP.COD_ENTIDADE = HFP.COD_ENTIDADE
          AND CP.COD_CONCEITO = TRUNC(HFPD.COD_FCRUBRICA/100)
          ))AS DES_RUBRICA,
      HFPD.FLG_NATUREZA AS NATUREZA,

      ROUND(HFPD.VAL_RUBRICA,2) AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO     HFP,
     TB_HDET_CALCULADO       HFPD,
     TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFPD.COD_INS             = HFP.COD_INS
AND HFPD.PER_PROCESSO        = HFP.PER_PROCESSO
AND HFPD.TIP_PROCESSO        = HFP.TIP_PROCESSO
AND HFPD.SEQ_PAGAMENTO       = HFP.SEQ_PAGAMENTO
AND HFPD.COD_IDE_CLI         = HFP.COD_IDE_CLI
AND HFPD.COD_IDE_CLI         = PF.COD_IDE_CLI
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/04/2014','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         = 3

AND NOT EXISTS
                 (
                 SELECT 1 FROM TB_IMPRESAO_RUB IMP
                 WHERE IMP.COD_INS = 1
                 AND IMP.COD_RUBRICA = HFPD.COD_FCRUBRICA
                 AND IMP.COD_ENTIDADE = HFP.COD_ENTIDADE
                 AND IMP.COD_TIPO_PROCESSO = HFPD.TIP_PROCESSO
                 AND IMP.FLG_IMPRIME = 'N'
                  )

)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', ROUND(VAL_RUBRICA,2), ROUND(VAL_RUBRICA*-1,2))) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))


UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,


      'C' AS FLG_NATUREZA,

      99000 AS COD_RUBRICA,
      'TOTAL CREDITO' AS DES_RUBRICA,
      'C' AS NATUREZA,

      HFP.TOT_CRED AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO     HFP,
     TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/04/2014','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         = 3
)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', VAL_RUBRICA, VAL_RUBRICA)) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))

UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,--BEN.NUM_PRONTUARIO AS PRONTUARIO,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,


      'D' AS FLG_NATUREZA,

      99100 AS COD_RUBRICA,
      'TOTAL DEBITO' AS DES_RUBRICA,
      'D' AS NATUREZA,

      HFP.TOT_DEB AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO     HFP,
     TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA        PF

WHERE HFP.COD_INS            = 1
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/04/2014','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         = 3

)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', VAL_RUBRICA, VAL_RUBRICA)) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))

UNION

SELECT*
FROM
(
SELECT
      HFP.NUM_MATRICULA,
      PF.NOM_PESSOA_FISICA AS NOME,
			PF.NUM_CPF AS CPF,
			RF.DAT_INI_EXERC AS DAT_ADMISSAO,
      HFP.COD_CARGO,
      HFP.NOM_CARGO,


      'L' AS FLG_NATUREZA,

      99200 AS COD_RUBRICA,
      'TOTAL LIQUIDO' AS DES_RUBRICA,
      'L' AS NATUREZA,

      HFP.VAL_LIQUIDO AS VAL_RUBRICA,

      CASE WHEN HFP.TIP_PROCESSO = 'T' THEN '13' ELSE
      TO_CHAR(HFP.PER_PROCESSO,'MM') END MES_REF,
      TO_CHAR(HFP.PER_PROCESSO,'YYYY')AS ANO_REF

FROM TB_HFOLHA_PAGAMENTO HFP,
     TB_BENEFICIARIO          BEN,
		  TB_RELACAO_FUNCIONAL    RF,
     TB_PESSOA_FISICA         PF

WHERE HFP.COD_INS            = 1
AND HFP.COD_IDE_CLI          = PF.COD_IDE_CLI
AND BEN.COD_IDE_CLI_BEN      = PF.COD_IDE_CLI
AND RF.COD_IDE_CLI           = HFP.COD_IDE_CLI
AND HFP.PER_PROCESSO         >= TO_DATE('01/04/2014','DD/MM/YYYY')
AND HFP.COD_ENTIDADE         = 3
)PIVOT (SUM(DECODE(FLG_NATUREZA, 'C', VAL_RUBRICA, VAL_RUBRICA)) FOR (MES_REF)
      IN ('01' as Janeiro,
          '02' as Fevereiro,
          '03' as Março,
          '04' as Abril,
          '05' as Maio,
          '06' as Junho,
          '07' as Julho,
          '08' as Agosto,
          '09' as Setembro,
          '10' as Outubro,
          '11' as Novembro,
          '12' as Dezembro,
          '13' as "DECIMO_TERCEIRO"))

)
ORDER BY ANO_REF,COD_FCRUBRICA
;
