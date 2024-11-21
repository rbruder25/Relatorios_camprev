CREATE OR REPLACE PACKAGE "PAC_RELATORIOS_FOLHA" AS

  
  
  
  
     
    PROCEDURE SP_REL_ENTIDADE_APO_CIV 
    ( 
    P_NOME_ARQ        IN VARCHAR,
    P_COD_INS        IN NUMBER,
    P_TIPO_PROCESSO  IN CHAR,   
    P_PER_PROCESSO   IN DATE ,
    P_SEQ_PAGAMENTO  IN NUMBER,
    P_DT_PAGAMENTO   IN DATE,
    P_GRUPO_PAG      IN VARCHAR
    
    );

    PROCEDURE SP_REL_ENTIDADE_PENSAO_CIV
    (
    P_NOME_ARQ        IN VARCHAR,
    P_COD_INS        IN NUMBER,  
    P_TIPO_PROCESSO  IN CHAR, 
    P_PER_PROCESSO   IN DATE , 
    P_SEQ_PAGAMENTO  IN NUMBER, 
    P_DT_PAGAMENTO   IN DATE,
    P_GRUPO_PAG      IN VARCHAR

    );


    PROCEDURE SP_REL_ENTIDADE_PENSAO_MIL
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_NUM_GRP  IN NUMBER,
      P_DAT_PAGTO IN DATE
    );

    PROCEDURE SP_REL_ENTIDADE_13_SAL_PEN
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_NUM_GRP  IN NUMBER,
      P_DAT_PAGTO IN DATE
    );    

    PROCEDURE SP_REL_ENTIDADE_13_SAL_PEN_MIL
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_NUM_GRP  IN NUMBER,
      P_DAT_PAGTO IN DATE
    );


    PROCEDURE SP_REL_ENTIDADE_13_SAL
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_NUM_GRP  IN NUMBER,
      P_DAT_PAGTO IN DATE
    );









    PROCEDURE SP_REL_ANALITICO_RUBRICA
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_COD_GRUPO_PAGTO  IN NUMBER,
      P_DAT_PAGTO IN DATE,
      P_COD_CONCEITO NUMBER, 
      P_FLG_CONSIGNATARIA VARCHAR
    );



    PROCEDURE SP_REL_RUBRICAS
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS NUMBER,
      P_TIP_PROCESSO VARCHAR,
      P_SEQ_PAGAMENTO NUMBER,
      P_PER_PROCESSO DATE,
      P_COD_GRP_PAGAMENTO NUMBER,
      P_DAT_PAGTO DATE

    );



    PROCEDURE SP_REL_SALARIO_FAMILIA
    (

      P_NOME_ARQ IN VARCHAR,
      P_PER_PROCESSO DATE
    );



    PROCEDURE SP_REL_CONSIG_SINTETICO
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_DAT_PAGTO IN DATE,
      P_COD_CONCEITO NUMBER,
      P_GRP_PAG NUMBER
    );



    PROCEDURE SP_REL_CONSIG_CONCEITO
    (

      P_NOME_ARQ IN VARCHAR,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_DAT_PAGTO IN DATE,
      P_COD_CONCEITO NUMBER,
      P_GRP_PAG NUMBER
    );

    PROCEDURE SP_REL_VALOR_DEVOLVIDO_BANCO(
    P_NOME_ARQ        IN VARCHAR,
    P_COD_INS        IN NUMBER,  
    P_TIPO_PROCESSO  IN CHAR, 
    P_PER_PROCESSO   IN DATE , 
    P_SEQ_PAGAMENTO  IN NUMBER, 
    P_DT_PAGAMENTO   IN DATE,
    P_GRUPO_PAG      IN VARCHAR

    );



    PROCEDURE SP_REL_ARQ_ENV_BANCO(
    P_NOME_ARQ        IN VARCHAR,  
    P_DT_PAGAMENTO   IN DATE,
    P_FLG_DEFINITIVO IN VARCHAR,
    P_SEGMENTO      IN VARCHAR

    );

    PROCEDURE SP_REL_CONTASJUDICIAIS(
      P_NOME_ARQ        IN VARCHAR,
      P_COD_INS        IN NUMBER,  
      P_TIPO_PROCESSO  IN CHAR, 
      P_PER_PROCESSO   IN DATE , 
      P_SEQ_PAGAMENTO  IN NUMBER, 
      P_DT_PAGAMENTO   IN DATE,
      P_GRUPO_PAG      IN VARCHAR

    );

    PROCEDURE SP_REL_REENVIO_BANCARIO_BEN
    (
        P_NOME_ARQ        IN VARCHAR,
        P_DT_PAGAMENTO   IN DATE,
        P_ERRO OUT VARCHAR
    );

    PROCEDURE SP_REL_ENTIDADE_INAT_MIL
    (

      P_NOME_ARQ IN VARCHAR,
      P_COD_INS IN NUMBER,
      P_PER_PROCESSO IN DATE,
      P_TIP_PROCESSO IN VARCHAR,
      P_SEQ_PAGAMENTO IN NUMBER,
      P_NUM_GRP  IN NUMBER,
      P_DAT_PAGTO IN DATE
    );

    PROCEDURE SP_REL_RESUMO_BANCO_ORDJUD
    (
       P_COD_INS NUMBER, 
       P_PERIODO DATE,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    );

    PROCEDURE SP_REL_RUBRICAS_PODERES
  (

    P_NOME_ARQ IN VARCHAR,
    P_COD_INS NUMBER,
    P_TIP_PROCESSO VARCHAR,
    P_SEQ_PAGAMENTO NUMBER,
    P_PER_PROCESSO DATE,
    P_COD_GRP_PAGAMENTO NUMBER,
    P_DAT_PAGTO DATE,
    P_COD_PODER NUMBER
  );

END PAC_RELATORIOS_FOLHA;
/
CREATE OR REPLACE PACKAGE BODY "PAC_RELATORIOS_FOLHA" AS

PROCEDURE SP_REL_ENTIDADE_APO_CIV(
P_NOME_ARQ        IN VARCHAR,
P_COD_INS        IN NUMBER,  
P_TIPO_PROCESSO  IN CHAR, 
P_PER_PROCESSO   IN DATE , 
P_SEQ_PAGAMENTO  IN NUMBER, 
P_DT_PAGAMENTO   IN DATE,
P_GRUPO_PAG      IN VARCHAR

)
AS 
V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

  IF P_TIPO_PROCESSO = 'N' THEN
    V_AUX := 'NORMAL' ;
  ELSIF P_TIPO_PROCESSO = 'S' THEN
    V_AUX := 'SUPLEMENTAR';
  ELSE
    V_AUX := '13?';
  END IF;        

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRUPO_PAG);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;


      V_CAMINHO := 'ARQS_REL_GERAIS';          

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE - GRUPO '||P_GRUPO_PAG||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DT_PAGAMENTO,'DD/MM/YYYY'));
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');

            UTL_FILE.PUT_LINE(OUTPUT_FILE,
                              'ORG' || ';' ||
                              'UO' || ';' ||
                              'GRUPO' || ';' || 
                              'DESCRIC?O' || ';' ||
                              'QTDE_SERV' || ';' || 
                              'CONTR_PREV' || ';' ||
                              'LIQUIDO' || ';' || 
                              'IR_LIQUIDO' || ';' ||
                              'IAMSPE' || ';' || 
                              'PA_DESC' || ';' ||
                              'VB_SUCUM' || ';' || 
                              'SEFAZ' || ';' ||
                              'CONSIG' || ';' || 
                              'REP_DIVERSAS' || ';' ||
                              'TOT_DIVERSOS' || ';' || 
                              'DIVERSOS' || ';' ||
                              'TOT_GERAL');

            BEGIN
              FOR GERA2 IN (

                SELECT PN.ORG_LEGADOR || ';' ||
                       LPAD(TO_CHAR(PN.UO_LEGADOR),3,'0')  || ';' ||
                       PN.NOM_PODER|| ';' ||
                       PN.NOM_ENTIDADE|| ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'999,999,999,999'),',','.')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_PREV,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_IR_DEBITO-TOT_IR_CREDITO,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_IAMPS,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_PA_DESC,'99999999999999D99'),'.',',')) || ';' ||

                       TRIM(REPLACE(TO_CHAR(PN.TOT_VB_SUCUMB,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_SEFAZ,'99999999999999D99'),'.',',')) || ';' ||                       
                       TRIM(REPLACE(TO_CHAR(PN.TOT_CONSIG,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_DESCONTOS_DIV,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_DIVERSOS,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_GLOBAL,'99999999999999D99'),'.',',')) || ';' ||

                       TRIM(REPLACE(TO_CHAR(
                       PN.TOT_PREV + PN.TOT_LIQUIDO +
                       (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                       PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                       DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                       PN.TOT_SEFAZ + PN.TOT_CONSIG +
                       DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                       DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',','))
                       AS CONTEUDO
                  FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                    ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                 WHERE COD_INS = P_COD_INS
                   AND PER_PROCESSO = P_PER_PROCESSO
                   AND TIP_PROCESSO = P_TIPO_PROCESSO
                   AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                   AND PN.TOT_SERV > 0
                   AND PN.TOT_IDE_CLI > 0
                   AND PN.DAT_PAGTO = P_DT_PAGAMENTO
                 ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

                V_DADOS := NULL;
                V_DADOS := GERA2.CONTEUDO;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                COMMIT;
              END LOOP;

              SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PREV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IR_DEBITO)-SUM(PN.TOT_IR_CREDITO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IAMPS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PA_DESC),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_VB_SUCUMB),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SEFAZ),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_CONSIG),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DIVERSOS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_GLOBAL),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO +
                             (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                             PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                             DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                             PN.TOT_SEFAZ + PN.TOT_CONSIG +
                             DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                             DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV))), '99999999999999D99'),'.',','))
                         AS TOTAL   
                    INTO V_TOTAL          
                    FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                   INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                      ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                   WHERE COD_INS = P_COD_INS
                     AND PER_PROCESSO = P_PER_PROCESSO
                     AND TIP_PROCESSO = P_TIPO_PROCESSO
                     AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                     AND PN.TOT_SERV > 0
                     AND PN.TOT_IDE_CLI > 0
                     AND PN.DAT_PAGTO = P_DT_PAGAMENTO
                   ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

                 UTL_FILE.FCLOSE(OUTPUT_FILE);
            END;





END SP_REL_ENTIDADE_APO_CIV;


PROCEDURE SP_REL_ENTIDADE_PENSAO_CIV(
P_NOME_ARQ        IN VARCHAR,
P_COD_INS        IN NUMBER,
P_TIPO_PROCESSO  IN CHAR,
P_PER_PROCESSO   IN DATE ,
P_SEQ_PAGAMENTO  IN NUMBER,
P_DT_PAGAMENTO   IN DATE,
P_GRUPO_PAG      IN VARCHAR

)
AS
V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

  IF P_TIPO_PROCESSO = 'N' THEN
    V_AUX := 'NORMAL' ;
  ELSIF P_TIPO_PROCESSO = 'S' THEN
    V_AUX := 'SUPLEMENTAR';
  ELSE
    V_AUX := '13?';
  END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRUPO_PAG);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        V_NOM_GRUPO := NULL;
  END;


      V_CAMINHO := 'ARQS_REL_GERAIS';

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE - GRUPO '||P_GRUPO_PAG||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DT_PAGAMENTO,'DD/MM/YYYY'));
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');


      UTL_FILE.PUT_LINE(OUTPUT_FILE,'PODER EXECUTIVO');

            UTL_FILE.PUT_LINE(OUTPUT_FILE,
                              'ORG' || ';' ||
                              'UO' || ';' ||
                              'GRUPO' || ';' ||
                              'DESCRIC?O' || ';' ||
                              'QTDE_SERV' || ';' ||

                              'QTDE_PENS' || ';' ||
                              'CONTR_PREV' || ';' ||
                              'LIQUIDO' || ';' ||
                              'IR_LIQUIDO' || ';' ||
                              'IAMSPE' || ';' ||
                              'PA_DESC' || ';' ||
                              'VB_SUCUM' || ';' ||
                              'SEFAZ' || ';' ||
                              'CONSIG' || ';' ||
                              'REP_DIVERSAS' || ';' ||
                              'TOT_DIVERSOS' || ';' ||
                              'DIVERSOS' || ';' ||
                              'TOT_GERAL');

            BEGIN
              FOR GERA2 IN (

                SELECT PN.ORG_LEGADOR || ';' ||
                       LPAD(TO_CHAR(PN.UO_LEGADOR),3,'0')  || ';' ||
                       PN.NOM_PODER|| ';' ||
                       PN.NOM_ENTIDADE|| ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'999,999,999,999'),',','.')) || ';' ||

                       PN.TOT_IDE_CLI  || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_PREV,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_IR_DEBITO-TOT_IR_CREDITO,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_IAMPS,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_PA_DESC,'99999999999999D99'),'.',',')) || ';' ||

                       TRIM(REPLACE(TO_CHAR(PN.TOT_VB_SUCUMB,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_SEFAZ,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_CONSIG,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_DESCONTOS_DIV,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_DIVERSOS,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_GLOBAL,'99999999999999D99'),'.',',')) || ';' ||

                       TRIM(REPLACE(TO_CHAR(
                       PN.TOT_PREV + PN.TOT_LIQUIDO +
                       (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                       PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                       DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                       PN.TOT_SEFAZ + PN.TOT_CONSIG +
                       DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                       DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',','))
                       AS CONTEUDO
                  FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                    ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                 WHERE COD_INS = P_COD_INS
                   AND PER_PROCESSO = P_PER_PROCESSO
                   AND TIP_PROCESSO = P_TIPO_PROCESSO
                   AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                   AND PN.TOT_SERV > 0
                   AND PN.TOT_IDE_CLI > 0
                   AND PN.DAT_PAGTO = P_DT_PAGAMENTO

                   AND PN.COD_AGRUPACAO = 1
                 ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

                V_DADOS := NULL;
                V_DADOS := GERA2.CONTEUDO;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                COMMIT;
              END LOOP;

              SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PODER EXECUTIVO'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||

                         SUM(PN.TOT_IDE_CLI) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PREV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IR_DEBITO)-SUM(PN.TOT_IR_CREDITO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IAMPS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PA_DESC),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_VB_SUCUMB),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SEFAZ),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_CONSIG),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DIVERSOS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_GLOBAL),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO +
                             (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                             PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                             DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                             PN.TOT_SEFAZ + PN.TOT_CONSIG +
                             DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                             DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV))), '99999999999999D99'),'.',','))
                         AS TOTAL
                    INTO V_TOTAL
                    FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                   INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                      ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                   WHERE COD_INS = P_COD_INS
                     AND PER_PROCESSO = P_PER_PROCESSO
                     AND TIP_PROCESSO = P_TIPO_PROCESSO
                     AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                     AND PN.TOT_SERV > 0
                     AND PN.TOT_IDE_CLI > 0
                     AND PN.DAT_PAGTO = P_DT_PAGAMENTO

                     AND PN.COD_AGRUPACAO = 1
                   ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

                 V_TOTAL := 0;



                 UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
                 UTL_FILE.PUT_LINE(OUTPUT_FILE,'OUTROS PODERES');

            UTL_FILE.PUT_LINE(OUTPUT_FILE,
                              'ORG' || ';' ||
                              'UO' || ';' ||
                              'GRUPO' || ';' ||
                              'DESCRIC?O' || ';' ||
                              'QTDE_SERV' || ';' ||

                              'QTDE_PENS' || ';' ||
                              'CONTR_PREV' || ';' ||
                              'LIQUIDO' || ';' ||
                              'IR_LIQUIDO' || ';' ||
                              'IAMSPE' || ';' ||
                              'PA_DESC' || ';' ||
                              'VB_SUCUM' || ';' ||
                              'SEFAZ' || ';' ||
                              'CONSIG' || ';' ||
                              'REP_DIVERSAS' || ';' ||
                              'TOT_DIVERSOS' || ';' ||
                              'DIVERSOS' || ';' ||
                              'TOT_GERAL');

            BEGIN
              FOR GERA2 IN (

                SELECT PN.ORG_LEGADOR || ';' ||
                       LPAD(TO_CHAR(PN.UO_LEGADOR),3,'0')  || ';' ||
                       PN.NOM_PODER|| ';' ||
                       PN.NOM_ENTIDADE|| ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'999,999,999,999'),',','.')) || ';' ||

                       PN.TOT_IDE_CLI  || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_PREV,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_IR_DEBITO-TOT_IR_CREDITO,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_IAMPS,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_PA_DESC,'99999999999999D99'),'.',',')) || ';' ||

                       TRIM(REPLACE(TO_CHAR(PN.TOT_VB_SUCUMB,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_SEFAZ,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_CONSIG,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_DESCONTOS_DIV,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_DIVERSOS,'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(PN.TOT_GLOBAL,'99999999999999D99'),'.',',')) || ';' ||

                       TRIM(REPLACE(TO_CHAR(
                       PN.TOT_PREV + PN.TOT_LIQUIDO +
                       (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                       PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                       DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                       PN.TOT_SEFAZ + PN.TOT_CONSIG +
                       DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                       DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',','))
                       AS CONTEUDO
                  FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                    ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                 WHERE COD_INS = P_COD_INS
                   AND PER_PROCESSO = P_PER_PROCESSO
                   AND TIP_PROCESSO = P_TIPO_PROCESSO
                   AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                   AND PN.TOT_SERV > 0
                   AND PN.TOT_IDE_CLI > 0
                   AND PN.DAT_PAGTO = P_DT_PAGAMENTO

                   AND PN.COD_AGRUPACAO = 2
                 ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

                V_DADOS := NULL;
                V_DADOS := GERA2.CONTEUDO;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                COMMIT;
              END LOOP;

              SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL OUTROS PODERES'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||

                         SUM(PN.TOT_IDE_CLI) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PREV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IR_DEBITO)-SUM(PN.TOT_IR_CREDITO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IAMPS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PA_DESC),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_VB_SUCUMB),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SEFAZ),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_CONSIG),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DIVERSOS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_GLOBAL),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO +
                             (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                             PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                             DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                             PN.TOT_SEFAZ + PN.TOT_CONSIG +
                             DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                             DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV))), '99999999999999D99'),'.',','))
                         AS TOTAL
                    INTO V_TOTAL
                    FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                   INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                      ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                   WHERE COD_INS = P_COD_INS
                     AND PER_PROCESSO = P_PER_PROCESSO
                     AND TIP_PROCESSO = P_TIPO_PROCESSO
                     AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                     AND PN.TOT_SERV > 0
                     AND PN.TOT_IDE_CLI > 0
                     AND PN.DAT_PAGTO = P_DT_PAGAMENTO

                     AND PN.COD_AGRUPACAO = 2
                   ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

                 V_TOTAL:=0;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE,'');



                 SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL GERAL'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||

                         SUM(PN.TOT_IDE_CLI) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PREV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IR_DEBITO)-SUM(PN.TOT_IR_CREDITO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IAMPS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PA_DESC),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_VB_SUCUMB),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SEFAZ),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_CONSIG),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DIVERSOS),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_GLOBAL),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO +
                             (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                             PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                             DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                             PN.TOT_SEFAZ + PN.TOT_CONSIG +
                             DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                             DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV))), '99999999999999D99'),'.',','))
                         AS TOTAL
                    INTO V_TOTAL
                    FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                   INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                      ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                   WHERE COD_INS = P_COD_INS
                     AND PER_PROCESSO = P_PER_PROCESSO
                     AND TIP_PROCESSO = P_TIPO_PROCESSO
                     AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND TO_NUMBER(PN.NUM_GRP) IN (P_GRUPO_PAG)
                     AND PN.TOT_SERV > 0
                     AND PN.TOT_IDE_CLI > 0
                     AND PN.DAT_PAGTO = P_DT_PAGAMENTO

                     AND PN.COD_AGRUPACAO IN (1,2)
                   ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

                 UTL_FILE.FCLOSE(OUTPUT_FILE);
                 END;
            END;





END SP_REL_ENTIDADE_PENSAO_CIV;


PROCEDURE SP_REL_ENTIDADE_PENSAO_MIL
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_NUM_GRP  IN NUMBER,
  P_DAT_PAGTO IN DATE
)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_NUM_GRP;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE - GRUPO '||P_NUM_GRP||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY'));
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'ORG' || ';' || 
                        'UO' || ';' ||
                        'GRUPO' || ';' ||
                        'DESCRIC?O' || ';' ||
                        'QTDE_SERV' || ';' ||
                        'QTDE_PENS' || ';' ||
                        'CONTR_PREV' || ';' ||
                        'LIQUIDO' || ';' || 
                        'IR_LIQUIDO' || ';' ||
                        'CRUZ_AZUL' || ';' || 
                        'PA_DESC' || ';' ||
                        'HONORARIO' || ';' || 
                        'RESSARC' || ';' ||
                        'CONSIG' || ';' || 
                        'REP_DIVERSAS' || ';' ||
                        'TOT_DIVERSOS' || ';' || 
                        'DIVERSOS' || ';' ||
                        'TOT_GERAL');

      BEGIN
        FOR GERA2 IN (

       SELECT 
       PN.ORG_LEGADOR  || ';' ||
       PN.UO_LEGADOR  || ';' || 
       PN.NUM_GRP || ';' ||
       PN.NOM_ENTIDADE  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'999,999,999,999'),',','.'))  || ';' || 
       TO_CHAR(PN.TOT_IDE_CLI)  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_PREV,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR((PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO),'99999999999999D99'),'.',',')) || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_IAMPS,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_PA_DESC,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_VB_SUCUMB,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SEFAZ,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_CONSIG,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_DESCONTOS_DIV,'99999999999999D99'),'.',','))   || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_DIVERSOS,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_GLOBAL,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR((PN.TOT_PREV 
       + PN.TOT_LIQUIDO 
       + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO)
       + PN.TOT_IAMPS 
       + PN.TOT_PA_DESC 
       + PN.TOT_VB_SUCUMB 
       + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS)
       + PN.TOT_SEFAZ + PN.TOT_CONSIG
       + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)
       + DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV)),'99999999999999D99'),'.',',')) 
        AS CONTEUDO
FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
       INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
WHERE COD_INS = P_COD_INS
AND   PER_PROCESSO = P_PER_PROCESSO
AND   TIP_PROCESSO =  P_TIP_PROCESSO
AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
AND   PN.TOT_SERV > 0
AND   PN.TOT_IDE_CLI > 0
AND   PN.DAT_PAGTO = P_DAT_PAGTO
ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.'))|| ';' ||  
                   TO_CHAR(SUM(PN.TOT_IDE_CLI)) || ';' ||  
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PREV),'99999999999999D99'),'.',','))|| ';' ||  
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO)),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IAMPS),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PA_DESC),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_VB_SUCUMB),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SEFAZ),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_CONSIG),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DIVERSOS),'99999999999999D99'),'.',','))      || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_GLOBAL),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO +
                   (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                   PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                   DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                   PN.TOT_SEFAZ + PN.TOT_CONSIG +
                   DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                   DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV))),'99999999999999D99'),'.',','))
                   AS TOTAL   
              INTO V_TOTAL          
              FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
             INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
             WHERE COD_INS = P_COD_INS
               AND PER_PROCESSO = P_PER_PROCESSO
               AND TIP_PROCESSO = P_TIP_PROCESSO
               AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND TO_NUMBER(PN.NUM_GRP) IN (P_NUM_GRP)
               AND PN.TOT_SERV > 0
               AND PN.TOT_IDE_CLI > 0
               AND PN.DAT_PAGTO = P_DAT_PAGTO
             ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;




    END;
END SP_REL_ENTIDADE_PENSAO_MIL;

PROCEDURE SP_REL_ENTIDADE_13_SAL_PEN
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_NUM_GRP  IN NUMBER,
  P_DAT_PAGTO IN DATE
)
AS

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   LONG;
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(30000);
V_AUX VARCHAR(15);


BEGIN



IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_NUM_GRP;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE 13? SALARIO - GRUPO '||P_NUM_GRP||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');

       UTL_FILE.PUT_LINE(OUTPUT_FILE, 'PODER EXECUTIVO');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'ORG' || ';' ||
                        'UO' || ';' ||
                        'GRUPO' || ';' ||
                        'DESCRIC?O' || ';' ||
                        'QTDE_SERV' || ';' ||

                        'QTDE_PENS' || ';' ||
                        'CREDITO_13'|| ';' ||
                        'DEBITO_13'|| ';' ||
                        'LIQUIDO_13');

      BEGIN
        FOR GERA2 IN (

      SELECT
       PN.ORG_LEGADOR || ';' ||
       PN.UO_LEGADOR  || ';' ||
       PN.NOM_PODER  || ';' ||
       PN.NOM_ENTIDADE  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'99999999999999D99'),'.',','))  || ';' ||

       PN.TOT_IDE_CLI  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607,'99999999999999D99'),'.',',')) || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607_DEB,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607-PN.TOT_18607_DEB,'99999999999999D99'),'.',','))
       AS CONTEUDO
      FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
       INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
        WHERE COD_INS = P_COD_INS
        AND   PER_PROCESSO = P_PER_PROCESSO
        AND   TIP_PROCESSO =  P_TIP_PROCESSO
        AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
        AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
        AND   PN.TOT_SERV > 0
        AND   PN.TOT_IDE_CLI > 0
        AND   PN.DAT_PAGTO = P_DAT_PAGTO
        AND PN.COD_AGRUPACAO = 1
        ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER)

        LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL PODER EXECUTIVO'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'99999999999999D99'),'.',','))|| ';' ||

                   SUM(PN.TOT_IDE_CLI) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607_DEB) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607-PN.TOT_18607_DEB),'99999999999999D99'),'.',','))
                   AS TOTAL
              INTO V_TOTAL
               FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
               INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                WHERE COD_INS = P_COD_INS
                AND   PER_PROCESSO = P_PER_PROCESSO
                AND   TIP_PROCESSO =  P_TIP_PROCESSO
                AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
                AND   PN.TOT_SERV > 0
                AND   PN.TOT_IDE_CLI > 0
                AND   PN.DAT_PAGTO = P_DAT_PAGTO
                AND PN.COD_AGRUPACAO=1
                ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;


         UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

         END;




          V_TOTAL:= 0;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
                UTL_FILE.PUT_LINE(OUTPUT_FILE, 'OUTROS PODERES');

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'ORG' || ';' ||
                        'UO' || ';' ||
                        'GRUPO' || ';' ||
                        'DESCRIC?O' || ';' ||
                        'QTDE_SERV' || ';' ||

                        'QTDE_PENS' || ';' ||
                        'CREDITO_13'|| ';' ||
                        'DEBITO_13'|| ';' ||
                        'LIQUIDO_13');

      BEGIN
        FOR GERA2 IN (

      SELECT
       PN.ORG_LEGADOR || ';' ||
       PN.UO_LEGADOR  || ';' ||
       PN.NOM_PODER  || ';' ||
       PN.NOM_ENTIDADE  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'99999999999999D99'),'.',','))  || ';' ||

       PN.TOT_IDE_CLI || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607,'99999999999999D99'),'.',',')) || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607_DEB,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607-PN.TOT_18607_DEB,'99999999999999D99'),'.',','))
        AS CONTEUDO
      FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
       INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
        WHERE COD_INS = P_COD_INS
        AND   PER_PROCESSO = P_PER_PROCESSO
        AND   TIP_PROCESSO =  P_TIP_PROCESSO
        AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
        AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
        AND   PN.TOT_SERV > 0
        AND   PN.TOT_IDE_CLI > 0
        AND   PN.DAT_PAGTO = P_DAT_PAGTO
        AND PN.COD_AGRUPACAO = 2
        ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER)

        LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL OUTROS PODERES'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'99999999999999D99'),'.',','))|| ';' ||

                   SUM(PN.TOT_IDE_CLI) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607_DEB) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607-PN.TOT_18607_DEB),'99999999999999D99'),'.',','))
                   AS TOTAL
              INTO V_TOTAL
               FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
               INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                WHERE COD_INS = P_COD_INS
                AND   PER_PROCESSO = P_PER_PROCESSO
                AND   TIP_PROCESSO =  P_TIP_PROCESSO
                AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
                AND   PN.TOT_SERV > 0
                AND   PN.TOT_IDE_CLI > 0
                AND   PN.DAT_PAGTO = P_DAT_PAGTO
                AND PN.COD_AGRUPACAO=2
                ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;


         UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

          UTL_FILE.PUT_LINE(OUTPUT_FILE, '');




         V_TOTAL := 0;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL GERAL'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'99999999999999D99'),'.',','))|| ';' ||

                   SUM(PN.TOT_IDE_CLI) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607_DEB) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607-PN.TOT_18607_DEB),'99999999999999D99'),'.',','))
                   AS TOTAL
              INTO V_TOTAL
               FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
               INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                WHERE COD_INS = P_COD_INS
                AND   PER_PROCESSO = P_PER_PROCESSO
                AND   TIP_PROCESSO =  P_TIP_PROCESSO
                AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
                AND   PN.TOT_SERV > 0
                AND   PN.TOT_IDE_CLI > 0
                AND   PN.DAT_PAGTO = P_DAT_PAGTO
                AND PN.COD_AGRUPACAO IN (1,2)
                ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

           END;

            UTL_FILE.FCLOSE(OUTPUT_FILE);









    END;
END SP_REL_ENTIDADE_13_SAL_PEN;

PROCEDURE SP_REL_ENTIDADE_13_SAL_PEN_MIL
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_NUM_GRP  IN NUMBER,
  P_DAT_PAGTO IN DATE
)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   LONG;
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(30000);
V_AUX VARCHAR(15);


BEGIN



IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_NUM_GRP;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE 13? SALARIO - GRUPO '||P_NUM_GRP||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');

       UTL_FILE.PUT_LINE(OUTPUT_FILE, 'PODER EXECUTIVO');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'ORG' || ';' || 
                        'UO' || ';' ||
                        'GRUPO' || ';' ||
                        'DESCRIC?O' || ';' ||
                        'QTDE_SERV' || ';' ||

                        'QTDE_PENS' || ';' ||
                        'CREDITO_13'|| ';' || 
                        'DEBITO_13'|| ';' ||
                        'LIQUIDO_13');

      BEGIN
        FOR GERA2 IN (

      SELECT 
       PN.ORG_LEGADOR || ';' ||
       PN.UO_LEGADOR  || ';' ||
       PN.NOM_PODER  || ';' ||
       PN.NOM_ENTIDADE  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'99999999999999D99'),'.',','))  || ';' ||

       PN.TOT_IDE_CLI  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607_DEB,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607-PN.TOT_18607_DEB,'99999999999999D99'),'.',',')) 
       AS CONTEUDO
      FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
       INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
        WHERE COD_INS = P_COD_INS
        AND   PER_PROCESSO = P_PER_PROCESSO
        AND   TIP_PROCESSO =  P_TIP_PROCESSO
        AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
        AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
        AND   PN.TOT_SERV > 0
        AND   PN.TOT_IDE_CLI > 0
        AND   PN.DAT_PAGTO = P_DAT_PAGTO

        ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER)

        LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;


         END;

         V_TOTAL := 0;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL GERAL'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'99999999999999D99'),'.',','))|| ';' ||

                   SUM(PN.TOT_IDE_CLI) || ';' ||    
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607) ,'99999999999999D99'),'.',','))|| ';' ||  
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607_DEB) ,'99999999999999D99'),'.',','))|| ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607-PN.TOT_18607_DEB),'99999999999999D99'),'.',','))
                   AS TOTAL   
              INTO V_TOTAL          
               FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
               INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                WHERE COD_INS = P_COD_INS
                AND   PER_PROCESSO = P_PER_PROCESSO
                AND   TIP_PROCESSO =  P_TIP_PROCESSO
                AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
                AND   PN.TOT_SERV > 0
                AND   PN.TOT_IDE_CLI > 0
                AND   PN.DAT_PAGTO = P_DAT_PAGTO

                ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

           END;

            UTL_FILE.FCLOSE(OUTPUT_FILE);







END SP_REL_ENTIDADE_13_SAL_PEN_MIL;

PROCEDURE SP_REL_ENTIDADE_13_SAL
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_NUM_GRP  IN NUMBER,
  P_DAT_PAGTO IN DATE
)
AS

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   LONG;
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(30000);
V_AUX VARCHAR(15);


BEGIN



IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_NUM_GRP;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE 13? SALARIO - GRUPO '||P_NUM_GRP||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'ORG' || ';' ||
                        'UO' || ';' ||
                        'GRUPO' || ';' ||
                        'DESCRIC?O' || ';' ||
                        'QTDE_SERV' || ';' ||

                        'CREDITO_13'|| ';' ||
                        'DEBITO_13'|| ';' ||
                        'LIQUIDO_13');

      BEGIN
        FOR GERA2 IN (

      SELECT
       PN.ORG_LEGADOR || ';' ||
       PN.UO_LEGADOR  || ';' ||
       PN.NOM_PODER  || ';' ||
       PN.NOM_ENTIDADE  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607,'99999999999999D99'),'.',',')) || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607_DEB,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_18607-PN.TOT_18607_DEB,'99999999999999D99'),'.',','))
        AS CONTEUDO
      FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
       INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
        WHERE COD_INS = P_COD_INS
        AND   PER_PROCESSO = P_PER_PROCESSO
        AND   TIP_PROCESSO =  P_TIP_PROCESSO
        AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
        AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
        AND   PN.TOT_SERV > 0
        AND   PN.TOT_IDE_CLI > 0
        AND   PN.DAT_PAGTO = P_DAT_PAGTO
        ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER)

        LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607_DEB) ,'99999999999999D99'),'.',','))|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_18607-PN.TOT_18607_DEB),'99999999999999D99'),'.',','))
                   AS TOTAL
              INTO V_TOTAL
               FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
               INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                WHERE COD_INS = P_COD_INS
                AND   PER_PROCESSO = P_PER_PROCESSO
                AND   TIP_PROCESSO =  P_TIP_PROCESSO
                AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
                AND   PN.TOT_SERV > 0
                AND   PN.TOT_IDE_CLI > 0
                AND   PN.DAT_PAGTO = P_DAT_PAGTO
                ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;


         UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
         UTL_FILE.FCLOSE(OUTPUT_FILE);

      END;




    END;
END SP_REL_ENTIDADE_13_SAL;



PROCEDURE SP_REL_ANALITICO_RUBRICA
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_COD_GRUPO_PAGTO  IN NUMBER,
  P_DAT_PAGTO IN DATE,
  P_COD_CONCEITO NUMBER, 
  P_FLG_CONSIGNATARIA VARCHAR
)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_COD_GRUPO_PAGTO;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RELATORIO ANALITICO '||P_COD_CONCEITO||'  GRUPO '||P_COD_GRUPO_PAGTO||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                       'ORG?O'         || ';' || 
                       'UO'            || ';' ||
                       'NOM_ENTIDADE'  || ';' ||
                       'COD_BENEFICIO' || ';' ||
                       'NUM_CPF'       || ';' ||
                       'NOME'          || ';' ||
                       'COD_RUBRICA'   || ';' ||
                       'VALOR'         || ';' ||      
                       'DAT_INI_REF'   );


      BEGIN
        FOR GERA2 IN (

       SELECT
            T.COD_ORGAO_LEGADOR                    || ';' ||
            T.COD_UO_LEGADOR                       || ';' || 
            T.NOM_ENTIDADE                         || ';' ||
            T.COD_BENEFICIO                        || ';' ||
            DECODE(T.NUM_CPF, NULL,NULL, TRANSLATE(TO_CHAR(T.NUM_CPF/100,'000,000,000.00'),',.','.-')) || ';' ||
            T.NOME                                 || ';' || 
            T.COD_RUBRICA                          || ';' || 
            CASE WHEN (SELECT DISTINCT RU.FLG_NATUREZA FROM USER_IPESP.TB_REL_RUBRICAS RU WHERE RU.COD_INS = T.COD_INS AND RU.COD_CONCEITO = T.COD_CONCEITO AND RU.COD_TIP_RELATORIO = 2) = 'C' THEN
                     TRIM(REPLACE(TO_CHAR((T.VAL_CREDITO - T.VAL_DEBITO) ,'99999999999999D99'),'.',','))        
                 ELSE     
                      TRIM(REPLACE(TO_CHAR((T.VAL_DEBITO - T.VAL_CREDITO) ,'99999999999999D99'),'.',','))       
            END || ';' || TO_CHAR(T.DAT_INI_REF, 'DD/MM/YYYY')
            AS CONTEUDO
        FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL T
        WHERE T.COD_INS =                       P_COD_INS
        AND T.PER_PROCESSO =                    P_PER_PROCESSO
        AND T.SEQ_PAGAMENTO =                   P_SEQ_PAGAMENTO
        AND T.TIP_PROCESSO =                    P_TIP_PROCESSO
        AND T.COD_GRUPO_PAGTO =                 P_COD_GRUPO_PAGTO
        AND T.DAT_PAGTO =                       P_DAT_PAGTO
        AND T.COD_CONCEITO =                    P_COD_CONCEITO
        AND T.FLG_CONSIGNATARIA =               P_FLG_CONSIGNATARIA
        ORDER BY COD_RUBRICA, T.NOME


        ) LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(CASE WHEN SUM(T.VAL_DEBITO - T.VAL_CREDITO) < 0 THEN SUM(T.VAL_DEBITO - T.VAL_CREDITO)*-1 ELSE SUM(T.VAL_DEBITO - T.VAL_CREDITO) END ,'99999999999999D99'),'.',','))|| ';' ||
                   ''

          AS SOMA INTO V_TOTAL
          FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL T
          WHERE T.COD_INS =                            P_COD_INS
          AND T.PER_PROCESSO =                         P_PER_PROCESSO
          AND T.SEQ_PAGAMENTO =                        P_SEQ_PAGAMENTO
          AND T.TIP_PROCESSO =                         P_TIP_PROCESSO
          AND TO_NUMBER(T.COD_GRUPO_PAGTO) =           P_COD_GRUPO_PAGTO
          AND T.DAT_PAGTO =                            P_DAT_PAGTO
          AND T.COD_CONCEITO =                         P_COD_CONCEITO
          AND T.FLG_CONSIGNATARIA =                    P_FLG_CONSIGNATARIA
          ORDER BY COD_RUBRICA, T.NOME;

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;

    END;
END SP_REL_ANALITICO_RUBRICA;

PROCEDURE SP_REL_RUBRICAS
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS NUMBER,
  P_TIP_PROCESSO VARCHAR,
  P_SEQ_PAGAMENTO NUMBER,
  P_PER_PROCESSO DATE,
  P_COD_GRP_PAGAMENTO NUMBER,
  P_DAT_PAGTO DATE

)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_COD_GRP_PAGAMENTO;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR RUBRICAS - GRUPO '||P_COD_GRP_PAGAMENTO||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                       'RUBRICA'                      || ';' || 
                       'DESCRICAO_RUBRICA'            || ';' ||
                       'CREDITO'                      || ';' ||
                       'DEBITO'                       || ';' ||
                       'QTDE');



      BEGIN
        FOR GERA2 IN (

       SELECT
        COD_FCRUBRICA            || ';' ||
        NOM_RUBRICA              || ';' || 
        TRIM(REPLACE(TO_CHAR(VAL_CREDITO,'99999999999999D99'),'.',','))  || ';' ||
        TRIM(REPLACE(TO_CHAR(VAL_DEBITO,'99999999999999D99'),'.',','))   || ';' ||
        TRIM(REPLACE(TO_CHAR(NUM_QTDE,'99999999999999D99'),'.',',')) 

        AS CONTEUDO

    FROM USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
    WHERE R.COD_INS = P_COD_INS
    AND R.PER_PROCESSO = P_PER_PROCESSO
    AND R.TIP_PROCESSO = P_TIP_PROCESSO
    AND R.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
    AND TO_NUMBER(R.COD_GRP_PAGAMENTO) = P_COD_GRP_PAGAMENTO
    AND EXISTS
   (SELECT 1
           FROM USER_IPESP.TB_CRONOGRAMA_PAG C
          WHERE R.COD_INS = P_COD_INS
            AND R.TIP_PROCESSO = P_TIP_PROCESSO
            AND R.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
            AND R.PER_PROCESSO = P_PER_PROCESSO
            AND R.COD_GRP_PAGAMENTO = P_COD_GRP_PAGAMENTO
            AND R.DAT_PAGTO = P_DAT_PAGTO)
  ORDER BY R.NUM_SEQ


        ) LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;




    END;
END SP_REL_RUBRICAS;

PROCEDURE SP_REL_SALARIO_FAMILIA
(

  P_NOME_ARQ IN VARCHAR,
  P_PER_PROCESSO DATE
)
AS 


V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);


    BEGIN


      V_CAMINHO := 'ARQS_REL_GERAIS';  

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RELAC?O DE PAGAMENTO DE SALARIO FAMILIA');
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                       'PER_PROCESSO'         || ';' || 
                       'NUM_CPF'              || ';' ||      
                       'NOM_PESSOA_FISICA'    || ';' ||                 
                       'TOT_CREDITO'          || ';' ||               
                       'COD_BANCO'            || ';' ||
                       'NUM_AGENCIA'          || ';' ||  
                       'NUM_DV_AGENCIA'       || ';' ||     
                       'COD_TIPO_CONTA'       || ';' ||     
                       'NUM_CONTA'            || ';' ||
                       'NUM_DV_CONTA');      

      BEGIN
        FOR GERA2 IN (

       SELECT
       F1.PER_PROCESSO           || ';' ||
       DECODE(F1.NUM_CPF, NULL,NULL, TRANSLATE(TO_CHAR(F1.NUM_CPF/100,'000,000,000.00'),',.','.-')) || ';' ||
       F1.NOM_PESSOA_FISICA      || ';' ||
       TRIM(REPLACE(TO_CHAR(F1.TOT_CREDITO,'99999999999999D99'),'.',',')) || ';' ||
       F1.COD_BANCO              || ';' ||
       F1.NUM_AGENCIA            || ';' ||
       F1.NUM_DV_AGENCIA         || ';' ||
       F1.COD_TIPO_CONTA         || ';' ||
       F1.NUM_CONTA              || ';' ||
       F1.NUM_DV_CONTA           
       AS CONTEUDO

       FROM USER_IPESP.TB_FOLHA_SFAM  F1
       WHERE F1.PER_PROCESSO = P_PER_PROCESSO
       AND F1.TOT_CREDITO > 0


        ) LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT ''     || ';' ||
               ''     || ';' || 
               'TOTAL'|| ';' ||
               TRIM(REPLACE(TO_CHAR(SUM(F1.TOT_CREDITO),'99999999999999D99'),'.',','))
               AS SOMA INTO V_TOTAL
               FROM USER_IPESP.TB_FOLHA_SFAM  F1
               WHERE F1.PER_PROCESSO = P_PER_PROCESSO
               AND F1.TOT_CREDITO > 0;

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
           UTL_FILE.FCLOSE(OUTPUT_FILE);
        END;





END SP_REL_SALARIO_FAMILIA;

PROCEDURE SP_REL_CONSIG_SINTETICO
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_DAT_PAGTO IN DATE,
  P_COD_CONCEITO NUMBER,
  P_GRP_PAG NUMBER
)
AS 
V_AP  VARCHAR(1) := CHR(39);
V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_GRP_PAG;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

  OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

  UTL_FILE.PUT_LINE(OUTPUT_FILE,
                    'RELATORIO SINTETICO DE CONSIGNATARIAS - GRUPO '||P_GRP_PAG||' - '||V_NOM_GRUPO);
  UTL_FILE.PUT_LINE(OUTPUT_FILE,
                    'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' - DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
  UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
  UTL_FILE.PUT_LINE(OUTPUT_FILE,
                   'RUBRICA'                   || ';' ||
                   'ESPECIE'                   || ';' ||
                   'DESCRIC?O_RUBRICA'         || ';' ||
                   'CNPJ'                      || ';' ||
                   'TOTAL'                     || ';' ||
                   'TAXA_OPER'                 || ';' ||
                   'CUSTO_OPER'                || ';' ||
                   'QTD_PROCESSAMENTO'         || ';' ||  
                   'VAL_PROCESSAMENTO'         || ';' ||
                   'VALOR_LIQUIDO'             || ';' ||    
                   'QTDE');

   IF (P_PER_PROCESSO >= TO_DATE('01/08/2014','dd/mm/yyyy')) THEN
       BEGIN
            FOR GERA2 IN (

                 SELECT
                   T.COD_FCRUBRICA           || ';' ||
                   T.ESPECIE                 || ';' || 
                   T.NOM_RUBRICA             || ';' ||
                   TO_CHAR(T.NUM_CNPJ)       || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.TOTAL),'99999999999999D99'),'.',',')) || ';' || 
                   T.TAXA_OPER               || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_OPER),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(T.QTD_PROCESSAMENTO),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_PROCESSAMENTO),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_LIQ),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.NUM_QTDE) ,'99999999999999D99'),'.',',')) 

                   AS CONTEUDO

                     FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
                     WHERE T.COD_INS = P_COD_INS
                       AND T.PER_PROCESSO = P_PER_PROCESSO
                       AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                       AND T.TIP_PROCESSO = P_TIP_PROCESSO
                       AND T.COD_CONCEITO = P_COD_CONCEITO
                       AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
                       AND T.DAT_PAGTO = P_DAT_PAGTO
                       AND EXISTS
                       (
                           SELECT 1 FROM USER_IPESP.TB_CONSIGNATARIAS C
                            WHERE C.COD_INS = P_COD_INS
                              AND C.COD_CONSIGNATARIA = T.COD_CONSIGNATARIA
                              AND C.TIP_ENTRADA = 2
                       )
                     GROUP BY 
                       T.COD_FCRUBRICA,
                       T.ESPECIE, 
                       T.NOM_RUBRICA,
                       TO_CHAR(T.NUM_CNPJ),
                       T.TAXA_OPER
                     ORDER BY T.COD_FCRUBRICA 

            ) 
            LOOP

                  V_DADOS := NULL;
                  V_DADOS := GERA2.CONTEUDO;

                  UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                  COMMIT;
            END LOOP;

            SELECT ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL ' || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.TOTAL),'99999999999999D99'),'.',',')) || ';' ||
                   ' '|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_OPER),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.QTD_PROCESSAMENTO),'99999999999999D99'),'.',','))  || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_PROCESSAMENTO),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_LIQ),'99999999999999D99'),'.',','))  || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.NUM_QTDE),'99999999999999D99'),'.',','))

                    AS SOMA INTO V_TOTAL
                    FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
                   WHERE T.COD_INS = P_COD_INS
                     AND T.PER_PROCESSO = P_PER_PROCESSO
                     AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND T.TIP_PROCESSO = P_TIP_PROCESSO
                     AND T.COD_CONCEITO = P_COD_CONCEITO
                     AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
                     AND T.DAT_PAGTO = P_DAT_PAGTO
                     AND EXISTS
                     (
                         SELECT 1 FROM USER_IPESP.TB_CONSIGNATARIAS C
                          WHERE C.COD_INS = P_COD_INS
                            AND C.COD_CONSIGNATARIA = T.COD_CONSIGNATARIA
                            AND C.TIP_ENTRADA = 2
                     )
                   ORDER BY T.COD_FCRUBRICA; 

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

                 UTL_FILE.FCLOSE(OUTPUT_FILE);
        END;
    ELSE
        BEGIN
            FOR GERA2 IN (

                 SELECT
                   T.COD_FCRUBRICA           || ';' ||
                   T.ESPECIE                 || ';' || 
                   T.NOM_RUBRICA             || ';' ||
                   TO_CHAR(T.NUM_CNPJ)       || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.TOTAL),'99999999999999D99'),'.',',')) || ';' || 
                   T.TAXA_OPER               || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_OPER),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(T.QTD_PROCESSAMENTO),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_PROCESSAMENTO),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.VAL_LIQ),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(T.NUM_QTDE) ,'99999999999999D99'),'.',',')) 

                   AS CONTEUDO

                     FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
                     WHERE T.COD_INS = P_COD_INS
                       AND T.PER_PROCESSO = P_PER_PROCESSO
                       AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                       AND T.TIP_PROCESSO = P_TIP_PROCESSO
                       AND T.COD_CONCEITO = P_COD_CONCEITO
                       AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
                       AND T.DAT_PAGTO = P_DAT_PAGTO
                     GROUP BY 
                       T.COD_FCRUBRICA,
                       T.ESPECIE, 
                       T.NOM_RUBRICA,
                       TO_CHAR(T.NUM_CNPJ),
                       T.TAXA_OPER
                     ORDER BY T.COD_FCRUBRICA 

            ) 
            LOOP

                  V_DADOS := NULL;
                  V_DADOS := GERA2.CONTEUDO;

                  UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                  COMMIT;
            END LOOP;

            SELECT     ' '|| ';' ||
                       ' '|| ';' ||
                       ' '|| ';' ||
                       'TOTAL ' || ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(T.TOTAL),'99999999999999D99'),'.',',')) || ';' ||
                       ' '|| ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(T.VAL_OPER),'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(T.QTD_PROCESSAMENTO),'99999999999999D99'),'.',','))  || ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(T.VAL_PROCESSAMENTO),'99999999999999D99'),'.',',')) || ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(T.VAL_LIQ),'99999999999999D99'),'.',','))  || ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(T.NUM_QTDE),'99999999999999D99'),'.',','))

                        AS SOMA INTO V_TOTAL
                        FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
                       WHERE T.COD_INS = P_COD_INS
                         AND T.PER_PROCESSO = P_PER_PROCESSO
                         AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                         AND T.TIP_PROCESSO = P_TIP_PROCESSO
                         AND T.COD_CONCEITO = P_COD_CONCEITO
                         AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
                         AND T.DAT_PAGTO = P_DAT_PAGTO
                       ORDER BY T.COD_FCRUBRICA; 

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

                 UTL_FILE.FCLOSE(OUTPUT_FILE);
        END;
    END IF;

END SP_REL_CONSIG_SINTETICO;
































































































































































































































































































































PROCEDURE SP_REL_CONSIG_CONCEITO
(

  P_NOME_ARQ IN VARCHAR,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_DAT_PAGTO IN DATE,
  P_COD_CONCEITO NUMBER,
  P_GRP_PAG NUMBER
)
AS 
V_AP  VARCHAR(1) := CHR(39);
V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_GRP_PAG;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

  OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

  UTL_FILE.PUT_LINE(OUTPUT_FILE,
                    'RELATORIO SINTETICO DE CONSIGNATARIAS POR CONCEITO - GRUPO '||P_GRP_PAG||' - '||V_NOM_GRUPO);
  UTL_FILE.PUT_LINE(OUTPUT_FILE,
                    'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' - DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
  UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
  UTL_FILE.PUT_LINE(OUTPUT_FILE,
                   'CONCEITO'          || ';' ||
                   'DESCRIC?O_RUBRICA' || ';' ||
                   'CNPJ'              || ';' ||
                   'TOTAL'             || ';' ||
                   'CUSTO_OPER'        || ';' ||
                   'QTD_PROCESSAMENTO' || ';' ||
                   'VAL_PROCESSAMENTO' || ';' ||
                   'VALOR_LIQUIDO'     || ';' ||  
                   'QTDE');

  IF (P_PER_PROCESSO >= TO_DATE('01/08/2014','DD/MM/YYYY')) THEN
      BEGIN
        FOR GERA2 IN (

            SELECT
                  SUBSTR(T.COD_FCRUBRICA,1,5)   || ';' ||
                  T.NOM_RUBRICA                 || ';' || 
                  TO_CHAR(T.NUM_CNPJ) || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.TOTAL),'99999999999999D99'),'.',','))                  || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.VAL_OPER),'99999999999999D99'),'.',','))              || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.QTD_PROCESSAMENTO) ,'99999999999999D99'),'.',','))     || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.VAL_PROCESSAMENTO) ,'99999999999999D99'),'.',','))     || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.VAL_LIQ),'99999999999999D99'),'.',','))              || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.NUM_QTDE),'99999999999999D99'),'.',','))                     
                  AS CONTEUDO
             FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
             WHERE T.COD_INS = 1
               AND T.PER_PROCESSO = P_PER_PROCESSO
               AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND T.TIP_PROCESSO = P_TIP_PROCESSO
               AND T.COD_CONCEITO = P_COD_CONCEITO
               AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
               AND T.DAT_PAGTO = P_DAT_PAGTO
               AND EXISTS
               (
                   SELECT 1 FROM USER_IPESP.TB_CONSIGNATARIAS C
                    WHERE C.COD_INS = 1
                      AND C.COD_CONSIGNATARIA = T.COD_CONSIGNATARIA
                      AND C.TIP_ENTRADA = 2
               )
            GROUP BY SUBSTR(T.COD_FCRUBRICA,1,5),
                   T.NOM_RUBRICA,
                   T.NUM_CNPJ
            ORDER BY SUBSTR(T.COD_FCRUBRICA,1,5)

        ) 
        LOOP
            V_DADOS := NULL;
            V_DADOS := GERA2.CONTEUDO;

            UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
            COMMIT;
        END LOOP;

        SELECT   ' '|| ';' ||
                 ' '|| ';' ||
                 'TOTAL '|| ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.TOTAL)),'99999999999999D99'),'.',','))                 || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.VAL_OPER)),'99999999999999D99'),'.',','))               || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.QTD_PROCESSAMENTO)),'99999999999999D99'),'.',','))      || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.VAL_PROCESSAMENTO)),'99999999999999D99'),'.',','))      || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.VAL_LIQ)),'99999999999999D99'),'.',','))               || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.NUM_QTDE)),'99999999999999D99'),'.',','))                     
                  AS SOMA INTO V_TOTAL

                   FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
                   WHERE T.COD_INS = 1
                   AND T.PER_PROCESSO = P_PER_PROCESSO
                   AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND T.TIP_PROCESSO = P_TIP_PROCESSO
                   AND T.COD_CONCEITO = P_COD_CONCEITO
                   AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
                   AND T.DAT_PAGTO = P_DAT_PAGTO
                   AND EXISTS
                   (
                       SELECT 1 FROM USER_IPESP.TB_CONSIGNATARIAS C
                        WHERE C.COD_INS = 1
                          AND C.COD_CONSIGNATARIA = T.COD_CONSIGNATARIA
                          AND C.TIP_ENTRADA = 2
                   )
                GROUP BY SUBSTR(T.COD_FCRUBRICA,1,5),
                       T.NOM_RUBRICA,
                       T.NUM_CNPJ
                ORDER BY SUBSTR(T.COD_FCRUBRICA,1,5); 

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;
   ELSE
      BEGIN
        FOR GERA2 IN (

            SELECT
                  SUBSTR(T.COD_FCRUBRICA,1,5)   || ';' ||
                  T.NOM_RUBRICA                 || ';' || 
                  TO_CHAR(T.NUM_CNPJ) || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.TOTAL),'99999999999999D99'),'.',','))                  || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.VAL_OPER),'99999999999999D99'),'.',','))              || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.QTD_PROCESSAMENTO) ,'99999999999999D99'),'.',','))     || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.VAL_PROCESSAMENTO) ,'99999999999999D99'),'.',','))     || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.VAL_LIQ),'99999999999999D99'),'.',','))              || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(T.NUM_QTDE),'99999999999999D99'),'.',','))                     
                  AS CONTEUDO
              FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
             WHERE T.COD_INS = 1
               AND T.PER_PROCESSO = P_PER_PROCESSO
               AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND T.TIP_PROCESSO = P_TIP_PROCESSO
               AND T.COD_CONCEITO = P_COD_CONCEITO
               AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
               AND T.DAT_PAGTO = P_DAT_PAGTO
            GROUP BY SUBSTR(T.COD_FCRUBRICA,1,5),
                   T.NOM_RUBRICA,
                   T.NUM_CNPJ
            ORDER BY SUBSTR(T.COD_FCRUBRICA,1,5)

        ) 
        LOOP
            V_DADOS := NULL;
            V_DADOS := GERA2.CONTEUDO;

            UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
            COMMIT;
        END LOOP;

        SELECT   ' '|| ';' ||
                 ' '|| ';' ||
                 'TOTAL '|| ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.TOTAL)),'99999999999999D99'),'.',','))                 || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.VAL_OPER)),'99999999999999D99'),'.',','))               || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.QTD_PROCESSAMENTO)),'99999999999999D99'),'.',','))      || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.VAL_PROCESSAMENTO)),'99999999999999D99'),'.',','))      || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.VAL_LIQ)),'99999999999999D99'),'.',','))               || ';' ||
                 TRIM(REPLACE(TO_CHAR(SUM(SUM(T.NUM_QTDE)),'99999999999999D99'),'.',','))                     
                  AS SOMA INTO V_TOTAL

                   FROM USER_IPESP.TB_RESUMO_CONSIGNATARIAS T
                   WHERE T.COD_INS = 1
                   AND T.PER_PROCESSO = P_PER_PROCESSO
                   AND T.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND T.TIP_PROCESSO = P_TIP_PROCESSO
                   AND T.COD_CONCEITO = P_COD_CONCEITO
                   AND TO_NUMBER(T.COD_GRP_PAG) = P_GRP_PAG
                   AND T.DAT_PAGTO = P_DAT_PAGTO
                GROUP BY SUBSTR(T.COD_FCRUBRICA,1,5),
                       T.NOM_RUBRICA,
                       T.NUM_CNPJ
                ORDER BY SUBSTR(T.COD_FCRUBRICA,1,5); 

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;
   END IF; 


END SP_REL_CONSIG_CONCEITO;


























































































































































PROCEDURE SP_REL_VALOR_DEVOLVIDO_BANCO(
P_NOME_ARQ        IN VARCHAR,
P_COD_INS        IN NUMBER,  
P_TIPO_PROCESSO  IN CHAR, 
P_PER_PROCESSO   IN DATE , 
P_SEQ_PAGAMENTO  IN NUMBER, 
P_DT_PAGAMENTO   IN DATE,
P_GRUPO_PAG      IN VARCHAR

)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

 IF P_TIPO_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIPO_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;        

    V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRUPO_PAG);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';          

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'VALOR DEVOLVIDO AO BANCO. GRUPO '||P_GRUPO_PAG||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DT_PAGAMENTO,'DD/MM/YYYY'));
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');

            UTL_FILE.PUT_LINE(OUTPUT_FILE,
                          'ORG' || ';' || 
                          'UO' || ';' ||
                          'GRUPO' || ';' || 
                          'DESCRIC?O' || ';' ||
                          'QTDE_SERV' || ';' ||

                          'QTDE_PENS' || ';' ||
                          'LIQUIDO' || ';' ||
                          'TOT_GERAL' || ';' ||
                          'TOT_1599'
                          );

            BEGIN
              FOR GERA2 IN (
                SELECT 
                PN.ORG_LEGADOR || ';' ||
                       LPAD(TO_CHAR(PN.UO_LEGADOR),3,'0')  || ';' ||
                       PN.NOM_PODER || ';' ||
                       PN.NOM_ENTIDADE || ';' ||
                 TRIM(REPLACE(TO_CHAR(PN.TOT_SERV ,'999,999,999,999'),',','.'))|| ';' ||

                 PN.TOT_IDE_CLI || ';' ||
                 TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO ,'99999999999999D99'),'.',','))|| ';' ||
                 TRIM(REPLACE(TO_CHAR((PN.TOT_PREV + PN.TOT_LIQUIDO + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO) + PN.TOT_IAMPS + PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS) + PN.TOT_SEFAZ + PN.TOT_CONSIG + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)+ DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV)),'99999999999999D99'),'.',',')) || ';' ||      
                 TRIM(REPLACE(TO_CHAR((
                 SELECT SUM(RT.VAL_CREDITO)-SUM(RT.VAL_DEBITO)
                  FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                 WHERE RT.COD_INS = PN.COD_INS
                   AND RT.PER_PROCESSO = PN.PER_PROCESSO
                   AND RT.TIP_PROCESSO = PN.TIP_PROCESSO
                   AND RT.SEQ_PAGAMENTO = PN.SEQ_PAGAMENTO
                   AND RT.COD_GRUPO_PAGTO = PN.NUM_GRP
                   AND RT.DAT_PAGTO   = PN.DAT_PAGTO
                   AND RT.COD_RUBRICA = 159900
                   AND RT.COD_ORGAO_LEGADOR = PN.ORG_LEGADOR
                   AND RT.COD_UO_LEGADOR = PN.UO_LEGADOR
            )  ,'99999999999999D99'),'.',','))    

                       AS CONTEUDO
                  FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                  WHERE COD_INS = P_COD_INS
                  AND   PER_PROCESSO = P_PER_PROCESSO
                  AND   TIP_PROCESSO =  P_TIPO_PROCESSO
                  AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   TO_NUMBER(PN.NUM_GRP)  IN (P_GRUPO_PAG)
                  AND   PN.TOT_SERV > 0
                  AND   PN.TOT_IDE_CLI > 0
                  AND   PN.DAT_PAGTO = P_DT_PAGAMENTO

                  AND   PN.COD_AGRUPACAO = 1
                  ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

                V_DADOS := NULL;
                V_DADOS := GERA2.CONTEUDO;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                COMMIT;
              END LOOP;

              SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PODER EXECUTIVO'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||

                        SUM(PN.TOT_IDE_CLI) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO) + PN.TOT_IAMPS + PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS) + PN.TOT_SEFAZ + PN.TOT_CONSIG + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)+ DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV))),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(
                         (SELECT SUM(RT.VAL_CREDITO)-SUM(RT.VAL_DEBITO)
                          FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                         WHERE RT.COD_INS = PN.COD_INS
                           AND RT.PER_PROCESSO = PN.PER_PROCESSO
                           AND RT.TIP_PROCESSO = PN.TIP_PROCESSO
                           AND RT.SEQ_PAGAMENTO = PN.SEQ_PAGAMENTO
                           AND RT.COD_GRUPO_PAGTO = PN.NUM_GRP
                           AND RT.DAT_PAGTO   = PN.DAT_PAGTO
                           AND RT.COD_RUBRICA = 159900
                           AND RT.COD_ORGAO_LEGADOR = PN.ORG_LEGADOR
                           AND RT.COD_UO_LEGADOR = PN.UO_LEGADOR)
                              ),'99999999999999D99'),'.',','))
                         AS TOTAL  INTO V_TOTAL          
                    FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                  WHERE COD_INS = P_COD_INS
                  AND   PER_PROCESSO = P_PER_PROCESSO
                  AND   TIP_PROCESSO =  P_TIPO_PROCESSO
                  AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   TO_NUMBER(PN.NUM_GRP)  IN (P_GRUPO_PAG)
                  AND   PN.TOT_SERV > 0
                  AND   PN.TOT_IDE_CLI > 0
                  AND   PN.DAT_PAGTO = P_DT_PAGAMENTO

                  AND   PN.COD_AGRUPACAO = 1
                  ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   
                 V_TOTAL := 0;


                 UTL_FILE.PUT_LINE(OUTPUT_FILE,'');
                 UTL_FILE.PUT_LINE(OUTPUT_FILE,'OUTROS PODERES');

                             UTL_FILE.PUT_LINE(OUTPUT_FILE,
                          'ORG' || ';' || 
                          'UO' || ';' ||
                          'GRUPO' || ';' || 
                          'DESCRIC?O' || ';' ||
                          'QTDE_SERV' || ';' ||

                          'QTDE_PENS' || ';' ||
                          'LIQUIDO' || ';' ||
                          'TOT_GERAL' || ';' ||
                          'TOT_1599'
                          );

            BEGIN
              FOR GERA2 IN (
                SELECT 
                PN.ORG_LEGADOR || ';' ||
                       LPAD(TO_CHAR(PN.UO_LEGADOR),3,'0')  || ';' ||
                       PN.NOM_PODER || ';' ||
                       PN.NOM_ENTIDADE || ';' ||
                 TRIM(REPLACE(TO_CHAR(PN.TOT_SERV ,'999,999,999,999'),',','.'))|| ';' ||

                 PN.TOT_IDE_CLI || ';' ||
                 TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO ,'99999999999999D99'),'.',','))|| ';' ||
                 TRIM(REPLACE(TO_CHAR((PN.TOT_PREV + PN.TOT_LIQUIDO + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO) + PN.TOT_IAMPS + PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS) + PN.TOT_SEFAZ + PN.TOT_CONSIG + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)+ DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV)),'99999999999999D99'),'.',',')) || ';' ||      
                 TRIM(REPLACE(TO_CHAR((
                 SELECT SUM(RT.VAL_CREDITO)-SUM(RT.VAL_DEBITO)
                  FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                 WHERE RT.COD_INS = PN.COD_INS
                   AND RT.PER_PROCESSO = PN.PER_PROCESSO
                   AND RT.TIP_PROCESSO = PN.TIP_PROCESSO
                   AND RT.SEQ_PAGAMENTO = PN.SEQ_PAGAMENTO
                   AND RT.COD_GRUPO_PAGTO = PN.NUM_GRP
                   AND RT.DAT_PAGTO   = PN.DAT_PAGTO
                   AND RT.COD_RUBRICA = 159900
                   AND RT.COD_ORGAO_LEGADOR = PN.ORG_LEGADOR
                   AND RT.COD_UO_LEGADOR = PN.UO_LEGADOR
            )  ,'99999999999999D99'),'.',','))    

                       AS CONTEUDO
                  FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                  WHERE COD_INS = P_COD_INS
                  AND   PER_PROCESSO = P_PER_PROCESSO
                  AND   TIP_PROCESSO =  P_TIPO_PROCESSO
                  AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   TO_NUMBER(PN.NUM_GRP)  IN (P_GRUPO_PAG)
                  AND   PN.TOT_SERV > 0
                  AND   PN.TOT_IDE_CLI > 0
                  AND   PN.DAT_PAGTO = P_DT_PAGAMENTO

                  AND   PN.COD_AGRUPACAO = 2
                  ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

                V_DADOS := NULL;
                V_DADOS := GERA2.CONTEUDO;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                COMMIT;
              END LOOP;

              SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL OUTROS PODERES'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||

                        SUM(PN.TOT_IDE_CLI) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO) + PN.TOT_IAMPS + PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS) + PN.TOT_SEFAZ + PN.TOT_CONSIG + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)+ DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV))),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(
                         (SELECT SUM(RT.VAL_CREDITO)-SUM(RT.VAL_DEBITO)
                          FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                         WHERE RT.COD_INS = PN.COD_INS
                           AND RT.PER_PROCESSO = PN.PER_PROCESSO
                           AND RT.TIP_PROCESSO = PN.TIP_PROCESSO
                           AND RT.SEQ_PAGAMENTO = PN.SEQ_PAGAMENTO
                           AND RT.COD_GRUPO_PAGTO = PN.NUM_GRP
                           AND RT.DAT_PAGTO   = PN.DAT_PAGTO
                           AND RT.COD_RUBRICA = 159900
                           AND RT.COD_ORGAO_LEGADOR = PN.ORG_LEGADOR
                           AND RT.COD_UO_LEGADOR = PN.UO_LEGADOR)
                              ),'99999999999999D99'),'.',','))
                         AS TOTAL  INTO V_TOTAL          
                    FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                  WHERE COD_INS = P_COD_INS
                  AND   PER_PROCESSO = P_PER_PROCESSO
                  AND   TIP_PROCESSO =  P_TIPO_PROCESSO
                  AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   TO_NUMBER(PN.NUM_GRP)  IN (P_GRUPO_PAG)
                  AND   PN.TOT_SERV > 0
                  AND   PN.TOT_IDE_CLI > 0
                  AND   PN.DAT_PAGTO = P_DT_PAGAMENTO

                  AND   PN.COD_AGRUPACAO = 2
                  ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   


                 V_TOTAL:=0;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE,'');




                               SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL OUTROS PODERES'|| ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.')) || ';' ||

                        SUM(PN.TOT_IDE_CLI) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO) + PN.TOT_IAMPS + PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS) + PN.TOT_SEFAZ + PN.TOT_CONSIG + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)+ DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV))),'99999999999999D99'),'.',',')) || ';' ||
                         TRIM(REPLACE(TO_CHAR(SUM(
                         (SELECT SUM(RT.VAL_CREDITO)-SUM(RT.VAL_DEBITO)
                          FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                         WHERE RT.COD_INS = PN.COD_INS
                           AND RT.PER_PROCESSO = PN.PER_PROCESSO
                           AND RT.TIP_PROCESSO = PN.TIP_PROCESSO
                           AND RT.SEQ_PAGAMENTO = PN.SEQ_PAGAMENTO
                           AND RT.COD_GRUPO_PAGTO = PN.NUM_GRP
                           AND RT.DAT_PAGTO   = PN.DAT_PAGTO
                           AND RT.COD_RUBRICA = 159900
                           AND RT.COD_ORGAO_LEGADOR = PN.ORG_LEGADOR
                           AND RT.COD_UO_LEGADOR = PN.UO_LEGADOR)
                              ),'99999999999999D99'),'.',','))
                         AS TOTAL  INTO V_TOTAL          
                    FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
                 INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
                  WHERE COD_INS = P_COD_INS
                  AND   PER_PROCESSO = P_PER_PROCESSO
                  AND   TIP_PROCESSO =  P_TIPO_PROCESSO
                  AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   TO_NUMBER(PN.NUM_GRP)  IN (P_GRUPO_PAG)
                  AND   PN.TOT_SERV > 0
                  AND   PN.TOT_IDE_CLI > 0
                  AND   PN.DAT_PAGTO = P_DT_PAGAMENTO


                  ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   




                 UTL_FILE.FCLOSE(OUTPUT_FILE);
              END;
          END;




END SP_REL_VALOR_DEVOLVIDO_BANCO;

PROCEDURE SP_REL_ARQ_ENV_BANCO(
P_NOME_ARQ        IN VARCHAR,  
P_DT_PAGAMENTO   IN DATE,
P_FLG_DEFINITIVO IN VARCHAR,
P_SEGMENTO       IN VARCHAR

)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;


BEGIN             

V_CAMINHO := 'ARQS_REL_GERAIS';          

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RELATORIO DE ARQUIVOS ENVIADOS AO BANCO - DATA PAGTO '||TO_CHAR(P_DT_PAGAMENTO,'DD/MM/YYYY'));

      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');

            UTL_FILE.PUT_LINE(OUTPUT_FILE,
                          'DT_PAGTO'           || ';' || 
                          'GRP_PAGTO'          || ';' ||
                          'NOME_GRUPO'         || ';' || 
                          'ARQUIVO'            || ';' ||
                          'PENS?O_ALIMENTICIA' || ';' ||
                          'VALOR'              || ';' ||
                          'QTDE'               || ';' ||
                          'TIP_MOV' );

                  BEGIN
                  FOR GERA2 IN (
                  SELECT  

                  TO_CHAR(R1.DT_PAGTO,'DD/MM/YYYY') || ';' ||  
                  R1.GRP_PAGTO || ';' ||
                  (SELECT 
                  GP.DES_GRP_PAG FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP WHERE GP.NUM_GRP_PAG = R1.GRP_PAGTO) || ';' ||
                  R1.ARQUIVO || ';' ||
                  DECODE(R1.FLG_PA,'S','SIM','N','N?O',NULL) || ';' ||
                  TRIM(REPLACE(TO_CHAR(SUM(R1.VALOR),'99999999999999D99'),'.',',')) || ';' ||
                  TRIM(REPLACE(TO_CHAR(COUNT(*),'99999999999999D99'),'.',',')) || ';' ||
                  R1.TIP_MOV 
                  AS CONTEUDO
                  FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO R1
                  WHERE R1.DT_PAGTO = P_DT_PAGAMENTO
                  AND R1.FLG_DEFINITIVO = P_FLG_DEFINITIVO
                  AND R1.SEGMENTO  = P_SEGMENTO
                  GROUP BY GROUPING SETS (
                  (R1.DT_PAGTO,R1.GRP_PAGTO,R1.ARQUIVO,R1.FLG_PA),
                  (R1.DT_PAGTO,R1.GRP_PAGTO,R1.FLG_PA),
                  (R1.DT_PAGTO,R1.GRP_PAGTO), 
                  (R1.DT_PAGTO)
                  ), 
                  R1.TIP_MOV) LOOP

                  V_DADOS := NULL;
                  V_DADOS := GERA2.CONTEUDO;

                  UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);

              COMMIT;
              END LOOP;

                 UTL_FILE.FCLOSE(OUTPUT_FILE);

              END;





END SP_REL_ARQ_ENV_BANCO;
















































































PROCEDURE SP_REL_CONTASJUDICIAIS(
  P_NOME_ARQ        IN VARCHAR,
  P_COD_INS        IN NUMBER,
  P_TIPO_PROCESSO  IN CHAR,
  P_PER_PROCESSO   IN DATE ,
  P_SEQ_PAGAMENTO  IN NUMBER,
  P_DT_PAGAMENTO   IN DATE,
  P_GRUPO_PAG      IN VARCHAR

)
AS

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_ARQUIVO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
NUM_ARQ        NUMBER;
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

  IF P_TIPO_PROCESSO = 'N' THEN
    V_AUX := 'NORMAL' ;
  ELSIF P_TIPO_PROCESSO = 'S' THEN
    V_AUX := 'SUPLEMENTAR';
  ELSE
    V_AUX := '13?';
  END IF;

      V_NOM_GRUPO := NULL;
      BEGIN
        SELECT UPPER(TRIM(GP.DES_GRP_PAG))
          INTO V_NOM_GRUPO
          FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
         WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRUPO_PAG);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN 
            V_NOM_GRUPO := NULL;
      END;

      V_CAMINHO := 'ARQS_REL_GERAIS';

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RELATORIO ANALITICO CONTAS JUDICIAIS. GRUPO '||P_GRUPO_PAG||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DT_PAGAMENTO,'DD/MM/YYYY'));
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');

            UTL_FILE.PUT_LINE(OUTPUT_FILE,


                                     'DT_PAGTO'  || ';' ||
                                     'NOM_PESSOA_FISICA' || ';' ||
                                     'NUM_CPF' || ';' ||
                                     'BANCO' || ';' ||
                                     'AGENCIA' || ';' ||
                                     'DV_AGENCIA' || ';' ||
                                     'NUM_CONTA' || ';' ||
                                     'DV_CONTA' || ';' ||
                                     'TIPO' || ';' ||
                                     'VAL_LIQUIDO');



            BEGIN
              FOR GERA2 IN (
                SELECT
                JU.DAT_PAGTO  || ';' ||
                JU.NOM_PESSOA_FISICA  || ';' ||
                DECODE(JU.NUM_CPF, NULL,NULL, TRANSLATE(TO_CHAR(JU.NUM_CPF/100,'000,000,000.00'),',.','.-')) || ';' ||
                JU.COD_BANCO   || ';' ||
                JU.NUM_AGENCIA  || ';' ||
                JU.NUM_DV_AGENCIA   || ';' ||
                JU.NUM_CONTA   || ';' ||
                JU.NUM_DV_CONTA   || ';' ||
                JU.COD_TIP_CONTA   || ';' ||
                TRIM(REPLACE(TO_CHAR(JU.VAL_LIQUIDO,'99999999999999D99'),'.',','))
                 AS CONTEUDO
                FROM USER_IPESP.TB_REL_CONTAS_JUDICIAIS JU
                WHERE JU.COD_INS = P_COD_INS
                AND JU.PER_PROCESSO = P_PER_PROCESSO
                AND JU.TIP_PROCESSO = P_TIPO_PROCESSO
                AND JU.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND TO_NUMBER(JU.COD_GRP_PAGAMENTO) = P_GRUPO_PAG
                AND EXISTS
                (
                SELECT 1 FROM USER_IPESP.TB_CRONOGRAMA_PAG C
                WHERE JU.COD_INS = C.COD_INS
                AND JU.TIP_PROCESSO = C.COD_TIP_PROCESSO
                AND JU.SEQ_PAGAMENTO = C.SEQ_PAGAMENTO
                AND JU.PER_PROCESSO = C.PER_PROCESSO
                AND JU.COD_GRP_PAGAMENTO = C.NUM_GRP
                AND JU.DAT_PAGTO = P_DT_PAGAMENTO)
                ORDER BY JU.TIP_INSTITUICAO)


                 LOOP

                V_DADOS := NULL;
                V_DADOS := GERA2.CONTEUDO;

                UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
                COMMIT;
              END LOOP;

              SELECT     ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL'|| ';' ||
                       TRIM(REPLACE(TO_CHAR(SUM(JU.VAL_LIQUIDO),'99999999999999D99'),'.',','))

                         AS TOTAL
                    INTO V_TOTAL
                   FROM USER_IPESP.TB_REL_CONTAS_JUDICIAIS JU
                WHERE JU.COD_INS = P_COD_INS
                AND JU.PER_PROCESSO = P_PER_PROCESSO
                AND JU.TIP_PROCESSO = P_TIPO_PROCESSO
                AND JU.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND TO_NUMBER(JU.COD_GRP_PAGAMENTO) = P_GRUPO_PAG
                AND EXISTS
                (
                SELECT 1 FROM USER_IPESP.TB_CRONOGRAMA_PAG C
                WHERE JU.COD_INS = C.COD_INS
                AND JU.TIP_PROCESSO = C.COD_TIP_PROCESSO
                AND JU.SEQ_PAGAMENTO = C.SEQ_PAGAMENTO
                AND JU.PER_PROCESSO = C.PER_PROCESSO
                AND JU.COD_GRP_PAGAMENTO = C.NUM_GRP
                AND JU.DAT_PAGTO = P_DT_PAGAMENTO)
                ORDER BY JU.TIP_INSTITUICAO;

                 UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

                 UTL_FILE.FCLOSE(OUTPUT_FILE);
            END;

END SP_REL_CONTASJUDICIAIS;

PROCEDURE SP_REL_REENVIO_BANCARIO_BEN(
  P_NOME_ARQ        IN VARCHAR,
  P_DT_PAGAMENTO   IN DATE,
  P_ERRO OUT VARCHAR)

IS 

V_CAMINHO VARCHAR2(1000);
V_ARQUIVO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
NUM_ARQ        NUMBER;
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);

BEGIN

V_CAMINHO := 'ARQS_REL_GERAIS';

      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RELATORIO DE PAGAMENTOS REENVIADOS AO BANCO POR BENEFICIARIO DATA DE PAGAMENTO : '||TO_CHAR(P_DT_PAGAMENTO,'DD/MM/YYYY'));

      UTL_FILE.PUT_LINE(OUTPUT_FILE, CHR(10));

           UTL_FILE.PUT_LINE(OUTPUT_FILE,'APOSENTADORIA CIVIL');
           UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO');

              BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (
              SELECT TE.ORG_LEGADOR
                FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
               WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                 AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
                 AND ROWNUM = 1
            ) 
            ELSE
                CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (
              SELECT DISTINCT TE.UO_LEGADOR
                FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
               WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                 AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
                 AND TE.ORG_LEGADOR =
                     (
                      SELECT TE.ORG_LEGADOR
                        FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                       WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                         AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
                     )
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||

            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
            NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO)) 
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO 
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'S'

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PA'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'S';

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             END;




             V_TOTAL := 0;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, CHR(10));

                         UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIP_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO');

            BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
            NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO))
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO 
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'N'

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PGTO NORMAL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'N';



             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             UTL_FILE.PUT_LINE(OUTPUT_FILE, '');
                         V_TOTAL := 0;

             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL APOSENTADORIA CIVIL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M';


             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

             V_TOTAL := 0;

            END;

            UTL_FILE.PUT_LINE(OUTPUT_FILE,'');
            UTL_FILE.PUT_LINE(OUTPUT_FILE,'');

           UTL_FILE.PUT_LINE(OUTPUT_FILE,'APOSENTADORIA MILITAR');
             UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO');

              BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
            NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO)) 
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO 
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'S'

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PA'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'S';

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             END;


             V_TOTAL := 0;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, CHR(10));

                         UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIP_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO');

            BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
            NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO)) 
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO 
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'N'

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PGTO NORMAL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M'
             AND EA.FLG_PA = 'N';


             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             UTL_FILE.PUT_LINE(OUTPUT_FILE, '');
                         V_TOTAL := 0;

             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL APOSENTADORIA MILITAR'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO != 'M';

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

             V_TOTAL := 0;
            END;



           UTL_FILE.PUT_LINE(OUTPUT_FILE,'PENS?O CIVIL - PODER EXECUTIVO');
           UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO'                     || ';' ||
                      'PODER');

              BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
                WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
                    (SELECT TE.ORG_LEGADOR
                    FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                    WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                    AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
                    AND ROWNUM = 1) 
                ELSE
                    CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
                  WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
                      (SELECT DISTINCT TE.UO_LEGADOR
                      FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                      WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                      AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
                      AND TE.ORG_LEGADOR =
                          (SELECT TE.ORG_LEGADOR
                          FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                          WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                          AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
                      )
                      ELSE
                          CC.COD_UO_LEGADOR
                  END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM(
                  (SELECT EF.NOM_ENTIDADE
                     FROM TB_ENTIDADE_FOLHA EF
                    WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
                      AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
                WHEN CC.COD_ENTIDADE = '5'  AND CC.COD_TIPO_BENEFICIO = 'M' THEN
                     'Pens?o Militar'
                WHEN CC.COD_ENTIDADE = '5'  AND CC.COD_TIPO_BENEFICIO != 'M' THEN
                     'Aposentadoria Militar'
                WHEN CC.COD_ENTIDADE != '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
                     'Pens?o Civil'
                WHEN CC.COD_ENTIDADE != '5' AND CC.COD_TIPO_BENEFICIO != 'M' THEN
                     'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
                WHEN 'S' THEN 'PA'
                WHEN 'N' THEN 'PGTO NORMAL'
            END  || ';' ||

            ( SELECT SUM(EA.VALOR)
                FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
                WHERE EA.COD_INS = 1
                AND EA.FLG_DEFINITIVO = 'S'
                AND EA.SEGMENTO = 'A'
                AND EA.FLG_PA = 'S'
                AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
                AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
             NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO)) 
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO')  || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO  || ';' ||
            DECODE(EN.COD_PODER, 1, 'PODER EXECUTIVO', 'OUTROS PODERES')
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'S'
             AND EN.COD_PODER = 1 

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PA'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'S'      
             AND EN.COD_PODER = 1;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             END;


             V_TOTAL := 0;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, CHR(10));

                         UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO'                     || ';' ||
                      'PODER');

            BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
            NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO))
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO || ';' ||
            DECODE(EN.COD_PODER, 1, 'PODER EXECUTIVO', 'OUTROS PODERES')
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO R,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_INS = 1
               AND R.DT_PAGAMENTO = P_DT_PAGAMENTO
               AND EA.COD_INS = R.COD_INS
               AND EA.COD_IDE_CLI = R.COD_IDE_CLI_BEN
               AND EA.COD_BENEFICIO = R.COD_BENEFICIO
               AND EA.DT_PAGTO = R.DT_PAGAMENTO
               AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
               AND EA.FLG_DEFINITIVO = 'S'
               AND EA.SEGMENTO = 'A'
               AND EA.FLG_PA = 'N'

               AND CC.COD_INS = EA.COD_INS
               AND CC.COD_BENEFICIO = EA.COD_BENEFICIO
               AND CC.COD_ENTIDADE != 5
               AND CC.COD_TIPO_BENEFICIO = 'M'

               AND PF.COD_INS = CC.COD_INS
               AND PF.COD_IDE_CLI = EA.COD_IDE_CLI

               AND EN.COD_INS = PF.COD_INS
               AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
               AND EN.COD_PODER = 1

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PGTO NORMAL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'N'     
             AND EN.COD_PODER = 1;



             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             UTL_FILE.PUT_LINE(OUTPUT_FILE, '');
                         V_TOTAL := 0;



              END;

           UTL_FILE.PUT_LINE(OUTPUT_FILE,'PENS?O CIVIL - OUTROS PODERES');
            UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO'                     || ';' ||
                      'PODER');

              BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
             NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO))
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO  || ';' ||
            DECODE(EN.COD_PODER, 1, 'PODER EXECUTIVO', 'OUTROS PODERES')
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'S'
             AND EN.COD_PODER != 1 

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PA'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'S'      
             AND EN.COD_PODER != 1;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);



             END;


             V_TOTAL := 0;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, CHR(10));

                         UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO'                     || ';' ||
                      'PODER');

            BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
             NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO) )
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO || ';' ||
            DECODE(EN.COD_PODER, 1, 'PODER EXECUTIVO', 'OUTROS PODERES')
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'N'
             AND EN.COD_PODER != 1

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PGTO NORMAL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'N'     
             AND EN.COD_PODER != 1;      

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             UTL_FILE.PUT_LINE(OUTPUT_FILE, '');
                         V_TOTAL := 0;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL OUTROS PODERES'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'     
             AND EN.COD_PODER != 1;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

             V_TOTAL := 0;                         



             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PENS?O CIVIL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE != '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M';

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

             V_TOTAL := 0;

            END;

            UTL_FILE.PUT_LINE(OUTPUT_FILE,'');
            UTL_FILE.PUT_LINE(OUTPUT_FILE,'');

           UTL_FILE.PUT_LINE(OUTPUT_FILE,'PENS?O MILITAR');
             UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO');

              BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
             NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO))
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO') || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY') || ';' ||
            EA.ARQUIVO 
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'S'

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PA'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'S';

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             END;




             V_TOTAL := 0;

             UTL_FILE.PUT_LINE(OUTPUT_FILE, CHR(10));

                         UTL_FILE.PUT_LINE(OUTPUT_FILE,

                      'ORG'                       || ';' ||
                      'UO'                        || ';' ||
                      'COD_ENTIDADE'              || ';' ||
                      'NOM_ENTIDADE'              || ';' ||
                      'NUM_CPF'                   || ';' ||
                      'NOM_PESSOA_FISICA'         || ';' ||
                      'DT_PAGAMENTO_ORIGEM'       || ';' ||
                      'PER_PROCESSO'              || ';' ||
                      'TIPO_BENEFICIO'            || ';' ||
                      'TIPO_PGTO'                 || ';' ||
                      'VALOR_ORIGEM'              || ';' ||
                      'COD_BANCO'                 || ';' ||
                      'DES_BANCO'                 || ';' ||
                      'COD_AGENCIA'               || ';' ||
                      'DV_AGENCIA'                || ';' ||
                      'COD_CONTA'                 || ';' ||
                      'DV_CONTA'                  || ';' ||
                      'DATA_PAGAMENTO_REENVIO'    || ';' ||
                      'ARQUIVO');

            BEGIN

            FOR GERA2 IN (
            SELECT 
            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND ROWNUM = 1) 
            ELSE
            CC.COD_ORG_LEGADOR
            END  || ';' ||

            CASE
            WHEN CC.COD_TIPO_BENEFICIO <> 'M' AND CC.COD_ENTIDADE = 5 THEN
            (SELECT DISTINCT TE.UO_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR
            AND TE.ORG_LEGADOR =
            (SELECT TE.ORG_LEGADOR
            FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
            WHERE TE.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND TE.UO_LEGADOR = CC.COD_UO_LEGADOR)
            )
            ELSE
            CC.COD_UO_LEGADOR
            END || ';' ||
            CC.COD_ENTIDADE || ';' ||
            TRIM((SELECT EF.NOM_ENTIDADE
            FROM TB_ENTIDADE_FOLHA EF
            WHERE EF.ORG_LEGADOR = CC.COD_ORG_LEGADOR
            AND EF.UO_LEGADOR = CC.COD_UO_LEGADOR)) || ';' ||
            PF.NUM_CPF || ';' ||
            PF.NOM_PESSOA_FISICA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO_ORIGEM,'DD/MM/YYYY') || ';' ||
            TO_CHAR(EA.PER_PROCESSO,'DD/MM/YYYY') || ';' ||
            CASE
            WHEN CC.COD_ENTIDADE = '5' AND CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Militar'
            WHEN CC.COD_ENTIDADE = '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Militar'
            WHEN CC.COD_ENTIDADE != '5'      AND
            CC.COD_TIPO_BENEFICIO = 'M' THEN
            'Pens?o Civil'
            WHEN CC.COD_ENTIDADE != '5' AND
            CC.COD_TIPO_BENEFICIO != 'M' THEN
            'Aposentadoria Civil'
            END  || ';' ||
            CASE EA.FLG_PA
            WHEN 'S' THEN
            'PA'
            WHEN 'N' THEN
            'PGTO NORMAL'
            END  || ';' ||
            (SELECT SUM(EA.VALOR)
            FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
            WHERE EA.COD_INS = 1
            AND EA.FLG_DEFINITIVO = 'S'
            AND EA.SEGMENTO = 'A'
            AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
            AND EA.DT_PAGTO = R.DT_PAGAMENTO) || ';' ||
            EA.COD_BANCO || ';' ||
             NVL((
               SELECT DISTINCT UPPER(TRIM(BA.DES_BANCO))
                 FROM USER_IPESP.TB_BANCO BA
                WHERE BA.COD_INS = PF.COD_INS
                  AND BA.COD_BANCO = EA.COD_BANCO
            ),'BANCO NAO LOCALIZADO')  || ';' ||
            EA.COD_AGENCIA || ';' ||
            EA.DV_AGENCIA || ';' ||
            EA.COD_CONTA || ';' ||
            EA.DV_CONTA || ';' ||
            TO_CHAR(R.DT_PAGAMENTO,'DD/MM/YYYY')  || ';' ||
            EA.ARQUIVO 
            AS CONTEUDO
            FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
                 USER_IPESP.TB_PESSOA_FISICA       PF,
                 USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
                 USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
                 USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'N'

             )

               LOOP
               V_DADOS := NULL;
               V_DADOS := GERA2.CONTEUDO;
               UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
               COMMIT;
               END LOOP;


             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PGTO NORMAL'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M'
             AND EA.FLG_PA = 'N';



             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);
             UTL_FILE.PUT_LINE(OUTPUT_FILE, '');
                         V_TOTAL := 0;

             SELECT      ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         ' '|| ';' ||
                         'TOTAL PENS?O MILITAR'|| ';' ||


             SUM(EA.VALOR)
             AS TOTAL
             INTO V_TOTAL
             FROM USER_IPESP.TB_REENVIO_BANCARIO    R,
             USER_IPESP.TB_PESSOA_FISICA       PF,
             USER_IPESP.TB_ENVIO_ARQ_BANCARIO  EA,
             USER_IPESP.TB_CONCESSAO_BENEFICIO CC,
             USER_IPESP.TB_ENTIDADE            EN
             WHERE R.COD_IDE_CLI_BEN = PF.COD_IDE_CLI
             AND EA.COD_INS = 1
             AND EA.FLG_DEFINITIVO = 'S'
             AND EA.SEGMENTO = 'A'
             AND EA.COD_IDENTIFICADOR = R.COD_IDENTIFICADOR
             AND EA.DT_PAGTO = R.DT_PAGAMENTO
             AND CC.COD_INS = 1
             AND CC.COD_BENEFICIO = R.COD_BENEFICIO
             AND EN.COD_INS = 1
             AND EN.COD_ENTIDADE = CC.COD_ENTIDADE
             AND EA.COD_IDE_CLI = PF.COD_IDE_CLI

             AND R.DT_PAGAMENTO = P_DT_PAGAMENTO

             AND CC.COD_ENTIDADE = '5'     
             AND CC.COD_TIPO_BENEFICIO = 'M';

             UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);

             V_TOTAL := 0;
             END;


 UTL_FILE.FCLOSE(OUTPUT_FILE);                          
EXCEPTION  
  WHEN OTHERS THEN
    UTL_FILE.FCLOSE(OUTPUT_FILE);
    P_ERRO := SQLERRM;
    ROLLBACK;
END SP_REL_REENVIO_BANCARIO_BEN;


PROCEDURE SP_REL_ENTIDADE_INAT_MIL
(

  P_NOME_ARQ IN VARCHAR,
  P_COD_INS IN NUMBER,
  P_PER_PROCESSO IN DATE,
  P_TIP_PROCESSO IN VARCHAR,
  P_SEQ_PAGAMENTO IN NUMBER,
  P_NUM_GRP  IN NUMBER,
  P_DAT_PAGTO IN DATE
)
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
PER_PROCESSO DATE;
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_TOTAL  VARCHAR2(3000);
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_NUM_GRP;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR ENTIDADE - GRUPO '||P_NUM_GRP||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY'));
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'ORG' || ';' || 
                        'UO' || ';' ||
                        'GRUPO' || ';' ||
                        'DESCRIC?O' || ';' ||
                        'QTDE_SERV' || ';' ||
                        'QTDE_PENS' || ';' ||
                        'CONTR_PREV' || ';' ||
                        'LIQUIDO' || ';' || 
                        'IR_LIQUIDO' || ';' ||
                        'CBPM' || ';' || 
                        'PA_DESC' || ';' ||
                        'HONORARIO' || ';' || 
                        'SALDO_DEV_PM' || ';' ||
                        'RESSARC' || ';' ||
                        'CONSIG' || ';' || 
                        'REP_DIVERSAS' || ';' ||
                        'TOT_DIVERSOS' || ';' || 
                        'DIVERSOS' || ';' ||
                        'TOT_GERAL');

      BEGIN
        FOR GERA2 IN (

       SELECT 
       PN.ORG_LEGADOR  || ';' ||
       PN.UO_LEGADOR  || ';' || 
       PN.NUM_GRP || ';' ||
       PN.NOM_ENTIDADE  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SERV,'999,999,999,999'),',','.'))  || ';' || 
       TO_CHAR(PN.TOT_IDE_CLI)  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_PREV,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_LIQUIDO,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR((PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO),'99999999999999D99'),'.',',')) || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_IAMPS,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_PA_DESC,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_VB_SUCUMB,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SALDO_DEVEDOR,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_SEFAZ,'99999999999999D99'),'.',','))  || ';' || 
       TRIM(REPLACE(TO_CHAR(PN.TOT_CONSIG,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_DESCONTOS_DIV,'99999999999999D99'),'.',','))   || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_DIVERSOS,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR(PN.TOT_GLOBAL,'99999999999999D99'),'.',','))  || ';' ||
       TRIM(REPLACE(TO_CHAR((PN.TOT_PREV 
       + PN.TOT_LIQUIDO 
       + (PN.TOT_IR_DEBITO-PN.TOT_IR_CREDITO)
       + PN.TOT_IAMPS 
       + PN.TOT_PA_DESC 
       + PN.TOT_VB_SUCUMB 
       + DECODE(PN.TOT_DIVERSOS,'',0,PN.TOT_DIVERSOS)
       + PN.TOT_SEFAZ + PN.TOT_CONSIG + PN.TOT_SALDO_DEVEDOR
       + DECODE(PN.TOT_GLOBAL,'',0,PN.TOT_GLOBAL)
       + DECODE(PN.TOT_DESCONTOS_DIV,'',0,PN.TOT_DESCONTOS_DIV)),'99999999999999D99'),'.',',')) 
        AS CONTEUDO
FROM   USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
       INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
WHERE COD_INS = P_COD_INS
AND   PER_PROCESSO = P_PER_PROCESSO
AND   TIP_PROCESSO =  P_TIP_PROCESSO
AND   SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
AND   TO_NUMBER(PN.NUM_GRP)  IN (P_NUM_GRP)
AND   PN.TOT_SERV > 0
AND   PN.TOT_IDE_CLI > 0
AND   PN.DAT_PAGTO = P_DAT_PAGTO
ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER) LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

        SELECT     ' '|| ';' ||
                   ' '|| ';' ||
                   ' '|| ';' ||
                   'TOTAL'|| ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SERV),'999,999,999,999'),',','.'))|| ';' ||  
                   TO_CHAR(SUM(PN.TOT_IDE_CLI)) || ';' ||  
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PREV),'99999999999999D99'),'.',','))|| ';' ||  
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_LIQUIDO),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO)),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_IAMPS),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_PA_DESC),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_VB_SUCUMB),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SALDO_DEVEDOR),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_SEFAZ),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_CONSIG),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DESCONTOS_DIV),'99999999999999D99'),'.',',')) || ';' ||
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_DIVERSOS),'99999999999999D99'),'.',','))      || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM(PN.TOT_GLOBAL),'99999999999999D99'),'.',',')) || ';' || 
                   TRIM(REPLACE(TO_CHAR(SUM((PN.TOT_PREV + PN.TOT_LIQUIDO +
                   (PN.TOT_IR_DEBITO - PN.TOT_IR_CREDITO) + PN.TOT_IAMPS +
                   PN.TOT_PA_DESC + PN.TOT_VB_SUCUMB +
                   DECODE(PN.TOT_DIVERSOS, '', 0, PN.TOT_DIVERSOS) +
                   PN.TOT_SEFAZ + PN.TOT_CONSIG + 
                   DECODE(PN.TOT_SALDO_DEVEDOR, '', 0, PN.TOT_SALDO_DEVEDOR) +
                   DECODE(PN.TOT_GLOBAL, '', 0, PN.TOT_GLOBAL) +
                   DECODE(PN.TOT_DESCONTOS_DIV, '', 0, PN.TOT_DESCONTOS_DIV))),'99999999999999D99'),'.',','))
                   AS TOTAL   
              INTO V_TOTAL          
              FROM USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW PN
             INNER JOIN USER_IPESP.TB_GRUPO_PAGAMENTO GP
                ON (PN.NUM_GRP = GP.NUM_GRP_PAG)
             WHERE COD_INS = P_COD_INS
               AND PER_PROCESSO = P_PER_PROCESSO
               AND TIP_PROCESSO = P_TIP_PROCESSO
               AND SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND TO_NUMBER(PN.NUM_GRP) IN (P_NUM_GRP)
               AND PN.TOT_SERV > 0
               AND PN.TOT_IDE_CLI > 0
               AND PN.DAT_PAGTO = P_DAT_PAGTO
             ORDER BY PN.COD_AGRUPACAO, PN.NOM_PODER;

           UTL_FILE.PUT_LINE(OUTPUT_FILE, V_TOTAL);   

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;




    END;
  END SP_REL_ENTIDADE_INAT_MIL;


   PROCEDURE SP_REL_RESUMO_BANCO_ORDJUD
    (
       P_COD_INS NUMBER, 
       P_PERIODO DATE,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    ) IS



    V_DAT_PAGTO DATE;
    ERROR_DATA_PGTO EXCEPTION;
    V_NOM_GRUPO VARCHAR2(100);


    VS_ERRO VARCHAR2 (1000);
    V_CREDITO NUMBER;
    V_DEBITO NUMBER;
    V_TOTAL_LIQUIDO NUMBER;
    V_TOTAL_VENCIMENTO NUMBER;
    V_TOTAL_DESCONTO NUMBER;
    V_NUM_SEQ NUMBER;
    V_COD_ENTIDADE NUMBER;
    V_CONTROLE NUMBER;
    ERROR_PARAM EXCEPTION;






    BEGIN





        BEGIN
            IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
               RAISE ERROR_PARAM;
            END IF;

            V_DAT_PAGTO := NULL;
            BEGIN
              SELECT C.DAT_PAG_EFETIVA
                INTO V_DAT_PAGTO
                FROM USER_IPESP.TB_CRONOGRAMA_PAG C
               WHERE C.COD_INS = P_COD_INS
                 AND C.COD_TIP_PROCESSO = P_TIP_PROCESSO
                 AND C.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND C.PER_PROCESSO = P_PERIODO
                 AND C.NUM_GRP = P_GRP_PGTO;

            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   RAISE ERROR_DATA_PGTO;
            END;







            DELETE FROM USER_IPESP.TB_REL_CONTAS_JUDICIAIS A
             WHERE A.COD_INS = P_COD_INS
               AND A.TIP_PROCESSO = P_TIP_PROCESSO
               AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND A.PER_PROCESSO = P_PERIODO
               AND A.COD_GRP_PAGAMENTO = LPAD(P_GRP_PGTO,2,'0')
               AND A.DAT_PAGTO = V_DAT_PAGTO;
            COMMIT;

            INSERT INTO USER_IPESP.TB_REL_CONTAS_JUDICIAIS
            SELECT TF.COD_INS, TF.TIP_PROCESSO, TF.PER_PROCESSO, TF.SEQ_PAGAMENTO, EB.DT_PAGTO, LPAD(P_GRP_PGTO,2,'0'),
                   PF.NUM_CPF, PF.NOM_PESSOA_FISICA,
                   EB.COD_BANCO, EB.COD_AGENCIA, EB.DV_AGENCIA, EB.COD_CONTA, EB.DV_CONTA, EB.TIPO_CONTA,
                   TF.VAL_LIQUIDO, EB.VALOR,
                   (
                      SELECT DECODE(COD_ENTIDADE,5, 'MILITAR', 'CIVIL') FROM USER_IPESP.TB_CONCESSAO_BENEFICIO CB
                       WHERE CB.COD_INS = EB.COD_INS
                         AND CB.COD_BENEFICIO = EB.COD_BENEFICIO
                   ) AS TIPO_BENEF, SYSDATE, SYSDATE, USER, 'FOLHA_CONTA_JUDICIAL',
                   TF.COD_BENEFICIO, TF.COD_IDE_CLI
              FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EB,
                   USER_IPESP.TB_FOLHA TF,
                   USER_IPESP.TB_PESSOA_FISICA PF
               WHERE EB.COD_INS = P_COD_INS
                 AND EB.FLG_DEFINITIVO   = 'S'
                 AND EB.SEGMENTO         = 'A'
                 AND EB.DT_PAGTO         = V_DAT_PAGTO
                 AND EB.TIP_MOV          = '0'
                 AND EB.PER_PROCESSO     = P_PERIODO
                 AND EB.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
                 AND EB.TIP_PROCESSO     = P_TIP_PROCESSO
                 AND EB.TIPO_CONTA IN ('25','26','31')
                 AND TF.COD_INS          = EB.COD_INS
                 AND TF.PER_PROCESSO     = EB.PER_PROCESSO
                 AND TF.SEQ_PAGAMENTO    = EB.SEQ_PAGAMENTO
                 AND TF.TIP_PROCESSO     = EB.TIP_PROCESSO
                 AND TF.COD_IDE_CLI      = EB.COD_IDE_CLI
                 AND TF.COD_BENEFICIO    = EB.COD_BENEFICIO
                 AND PF.COD_INS          = TF.COD_INS
                 AND PF.COD_IDE_CLI      = TF.COD_IDE_CLI
                 AND EXISTS
                 (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = TF.COD_INS
                          AND AX.TIP_PROCESSO = TF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = TF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = TF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = TF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = TF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
             COMMIT;





          DELETE FROM USER_IPESP.TB_RESUMO_BANCO A
           WHERE A.COD_INS = P_COD_INS
             AND A.TIPO_PROCESSO = P_TIP_PROCESSO
             AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
             AND A.PER_PROCESSO = P_PERIODO
             AND A.COD_GRP_PAGTO = LPAD(P_GRP_PGTO,2,'0')
             AND A.DAT_PAGTO = V_DAT_PAGTO;
          COMMIT;


          INSERT INTO USER_IPESP.TB_RESUMO_BANCO
            SELECT RES.COD_INS, TIP_PROCESSO, PER_PROCESSO, SEQ_PAGAMENTO  , GRP_PAGTO, DT_PAGTO,
            COUNT(DISTINCT COD_IDE_CLI), RES.COD_BANCO,
            BA.DES_BANCO,
            SUM(TOT_CRED), SUM(TOT_DEB), SUM(VALOR)
            FROM
            (

                      SELECT EA.COD_INS, EA.TIP_PROCESSO, EA.PER_PROCESSO,
                             EA.SEQ_PAGAMENTO, EA.DT_PAGTO, LPAD(EA.GRP_PAGTO,2,'0') AS GRP_PAGTO, 
                             EA.COD_IDE_CLI,
                             EA.COD_BANCO,

                             (SELECT FO.TOT_CRED FROM USER_IPESP.TB_FOLHA FO
                               WHERE FO.COD_INS = EA.COD_INS
                                 AND FO.TIP_PROCESSO = EA.TIP_PROCESSO
                                 AND FO.PER_PROCESSO = EA.PER_PROCESSO
                                 AND FO.SEQ_PAGAMENTO = EA.SEQ_PAGAMENTO
                                 AND FO.COD_BENEFICIO = EA.COD_BENEFICIO
                                 AND FO.COD_IDE_CLI = EA.COD_IDE_CLI
                             )AS TOT_CRED,
                             (SELECT FO.TOT_DEB FROM USER_IPESP.TB_FOLHA FO
                               WHERE FO.COD_INS = EA.COD_INS
                                 AND FO.TIP_PROCESSO = EA.TIP_PROCESSO
                                 AND FO.PER_PROCESSO = EA.PER_PROCESSO
                                 AND FO.SEQ_PAGAMENTO = EA.SEQ_PAGAMENTO
                                 AND FO.COD_BENEFICIO = EA.COD_BENEFICIO
                                 AND FO.COD_IDE_CLI = EA.COD_IDE_CLI
                             )AS TOT_DEB,
                             EA.VALOR
                      FROM USER_IPESP.TB_ENVIO_ARQ_BANCARIO EA
                     WHERE EA.COD_INS = P_COD_INS
                      AND EA.SEGMENTO  ='A'
                      AND EA.FLG_DEFINITIVO  = 'S'
                      AND EA.TIP_MOV = '0'
                      AND EA.GRP_PAGTO = P_GRP_PGTO
                      AND EA.TIP_PROCESSO = P_TIP_PROCESSO
                      AND EA.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND EA.DT_PAGTO = V_DAT_PAGTO
                      AND EA.PER_PROCESSO = P_PERIODO
                      AND EA.FLG_PA = 'N'
                      AND EXISTS
                      (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = EA.COD_INS
                                AND AX.TIP_PROCESSO = EA.TIP_PROCESSO
                                AND AX.PER_PROCESSO = EA.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = EA.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = EA.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = EA.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(EA.GRP_PAGTO,2,'0')
                                AND AX.DAT_PGTO = EA.DT_PAGTO
                       )
            ) RES, USER_IPESP.TB_BANCO BA
            WHERE BA.COD_BANCO = RES.COD_BANCO AND BA.COD_INS = RES.COD_INS
            GROUP BY RES.COD_INS, RES.TIP_PROCESSO, RES.PER_PROCESSO, RES.SEQ_PAGAMENTO, RES.GRP_PAGTO,
                    RES.DT_PAGTO, RES.COD_BANCO, BA.DES_BANCO;

        COMMIT;


       EXCEPTION
           WHEN ERROR_PARAM THEN
                VS_ERRO := 'OS PARAMETROS P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, P_PERIODO, P_GRP_PAGTO S?O OBRIGATORIOS';
                P_ERRO := VS_ERRO;
                RETURN;
           WHEN ERROR_DATA_PGTO THEN
                VS_ERRO := 'DATA DE PAGAMENTO ENCERRADA NO CRONOGRAMA';
                P_ERRO := VS_ERRO;
                RETURN;
           WHEN OTHERS THEN
                VS_ERRO := SQLCODE ||' - '||SQLERRM;
                P_ERRO := VS_ERRO;
       END;


   END SP_REL_RESUMO_BANCO_ORDJUD;


   PROCEDURE SP_REL_RUBRICAS_PODERES
  (

    P_NOME_ARQ IN VARCHAR,
    P_COD_INS NUMBER,
    P_TIP_PROCESSO VARCHAR,
    P_SEQ_PAGAMENTO NUMBER,
    P_PER_PROCESSO DATE,
    P_COD_GRP_PAGAMENTO NUMBER,
    P_DAT_PAGTO DATE,
    P_COD_PODER NUMBER

  )
AS 

V_NOM_GRUPO VARCHAR2(200);
V_CAMINHO VARCHAR2(1000);
V_DADOS   VARCHAR2(30000);
OUTPUT_FILE UTL_FILE.FILE_TYPE;
V_AUX VARCHAR(15);


BEGIN

IF P_TIP_PROCESSO = 'N' THEN
  V_AUX := 'NORMAL' ;
ELSIF P_TIP_PROCESSO = 'S' THEN
  V_AUX := 'SUPLEMENTAR';
ELSE
  V_AUX := '13?';
END IF;

  V_NOM_GRUPO := NULL;
  BEGIN
    SELECT UPPER(TRIM(GP.DES_GRP_PAG))
      INTO V_NOM_GRUPO
      FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
     WHERE GP.NUM_GRP_PAG = P_COD_GRP_PAGAMENTO;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN 
        V_NOM_GRUPO := NULL;
  END;

  V_CAMINHO := 'ARQS_REL_GERAIS';

    BEGIN
      OUTPUT_FILE := UTL_FILE.FOPEN(V_CAMINHO,P_NOME_ARQ||'.CSV','W',32767);

      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'RESUMO GERAL POR RUBRICAS - '||CASE WHEN P_COD_PODER = 1 THEN 'PODER EXECUTIVO ' ELSE 'OUTROS PODERES ' END
                        ||' - GRUPO '||P_COD_GRP_PAGAMENTO||' - '||V_NOM_GRUPO);
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                        'PROCESSO  '||V_AUX||' '||TO_CHAR(P_PER_PROCESSO,'DD/MM/YYYY')||' DATA PAGTO '||TO_CHAR(P_DAT_PAGTO,'DD/MM/YYYY') );
      UTL_FILE.PUT_LINE(OUTPUT_FILE, ' ');
      UTL_FILE.PUT_LINE(OUTPUT_FILE,
                       'RUBRICA'                      || ';' || 
                       'DESCRICAO_RUBRICA'            || ';' ||
                       'CREDITO'                      || ';' ||
                       'DEBITO'                       || ';' ||
                       'QTDE');



      BEGIN
        FOR GERA2 IN (

       SELECT
        COD_FCRUBRICA            || ';' ||
        NOM_RUBRICA              || ';' || 
        TRIM(REPLACE(TO_CHAR(VAL_CREDITO,'99999999999999D99'),'.',','))  || ';' ||
        TRIM(REPLACE(TO_CHAR(VAL_DEBITO,'99999999999999D99'),'.',','))   || ';' ||
        TRIM(REPLACE(TO_CHAR(NUM_QTDE,'99999999999999D99'),'.',',')) 

        AS CONTEUDO

    FROM USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
    WHERE R.COD_INS = P_COD_INS
    AND R.PER_PROCESSO = P_PER_PROCESSO
    AND R.TIP_PROCESSO = P_TIP_PROCESSO
    AND R.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
    AND TO_NUMBER(R.COD_GRP_PAGAMENTO) = P_COD_GRP_PAGAMENTO
    AND R.COD_PODER = P_COD_PODER
    AND EXISTS
   (SELECT 1
           FROM USER_IPESP.TB_CRONOGRAMA_PAG C
          WHERE R.COD_INS = P_COD_INS
            AND R.TIP_PROCESSO = P_TIP_PROCESSO
            AND R.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
            AND R.PER_PROCESSO = P_PER_PROCESSO
            AND R.COD_GRP_PAGAMENTO = P_COD_GRP_PAGAMENTO
            AND R.DAT_PAGTO = P_DAT_PAGTO)
  ORDER BY R.NUM_SEQ


        ) LOOP

          V_DADOS := NULL;
          V_DADOS := GERA2.CONTEUDO;

          UTL_FILE.PUT_LINE(OUTPUT_FILE, V_DADOS);
          COMMIT;
        END LOOP;

           UTL_FILE.FCLOSE(OUTPUT_FILE);
      END;


    END;
END SP_REL_RUBRICAS_PODERES;

END PAC_RELATORIOS_FOLHA;
/
