CREATE OR REPLACE PACKAGE "PAC_REL_FECHAMENTO_FOLHA" AS

  PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_PC
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    );
    
    PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_PM
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    );

    PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_AC
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    );

    PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_AM
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    );
    
    PROCEDURE SP_FECHAMENTO_RUBRICA_PODER
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DAT_PAGTO DATE,
       P_ERRO OUT VARCHAR2
    );
    
    PROCEDURE SP_FECHAMENTO_CONSIG_DET 
  (
       PN_COD_INS NUMBER,  
       PS_PER_PROCESSO VARCHAR2, 
       PC_TIP_PROCESSO CHAR, 
       PN_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       VS_ERRO OUT VARCHAR2,
       PD_DAT_PAGTO DATE
  );
  PROCEDURE SP_FECHAMENTO_GERAL_PA
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_ERRO OUT VARCHAR2,
       P_DATA_PAGTO DATE
    );
    
    PROCEDURE SP_FECHAMENTO_GERAL_TJM
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_ERRO OUT VARCHAR2,
       P_DATA_PAGTO DATE
    );

END PAC_REL_FECHAMENTO_FOLHA;				 
				
/
CREATE OR REPLACE PACKAGE BODY "PAC_REL_FECHAMENTO_FOLHA" AS

PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_PC
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    ) IS


    
    V_DAT_PAGTO DATE;
    ERROR_DATA_PGTO EXCEPTION;
    V_NOM_GRUPO VARCHAR2(100);

    
    VS_ERRO VARCHAR2 (1000);
    VS_ERRO_RUBRICA_PODER VARCHAR2(1000);
    V_CREDITO NUMBER;
    V_DEBITO NUMBER;
    V_TOTAL_LIQUIDO NUMBER;
    V_TOTAL_VENCIMENTO NUMBER;
    V_TOTAL_DESCONTO NUMBER;
    V_NUM_SEQ NUMBER;
    V_COD_ENTIDADE NUMBER;
    V_CONTROLE NUMBER;
    ERROR_PARAM EXCEPTION;
    V_NUM_GRUPO_MIGRAR VARCHAR2(2);

    
    CURSOR V_CURSOR IS
        SELECT T1.COD_FCRUBRICA,
               








               R1.NOM_RUBRICA,
               SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
               SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
               COUNT(*) AS QTDE
          FROM USER_IPESP.TB_DET_CALCULADO T1, 
               USER_IPESP.TB_CONCESSAO_BENEFICIO CB, 
               USER_IPESP.TB_RUBRICAS R1
         WHERE T1.COD_INS = P_COD_INS
          AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
           AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
           AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
           AND CB.COD_INS = T1.COD_INS
           AND CB.COD_BENEFICIO = T1.COD_BENEFICIO
           AND R1.COD_INS = T1.COD_INS
           AND R1.COD_RUBRICA = T1.COD_FCRUBRICA
           AND R1.COD_ENTIDADE = CB.COD_ENTIDADE
           AND R1.DAT_FIM_VIG IS NULL
           AND EXISTS
           (
               SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                WHERE AX.COD_INS = T1.COD_INS
                   AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                   AND AX.PER_PROCESSO = T1.PER_PROCESSO
                   AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                   AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                   AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                   AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                   AND AX.DAT_PGTO = V_DAT_PAGTO
           )
           AND EXISTS (SELECT 1 FROM USER_IPESP.TB_IMPRESAO_RUB  IR
                      WHERE IR.COD_RUBRICA  = T1.COD_FCRUBRICA
                        AND IR.COD_ENTIDADE = CB.COD_ENTIDADE
                        AND (IR.FLG_IMPRIME  IN ('S'))
                      )
           
        GROUP BY T1.COD_FCRUBRICA, R1.NOM_RUBRICA
        ORDER BY T1.COD_FCRUBRICA;

        
        VOUTROSDIVERSOS NUMBER(18,2) := 0;
        VIR_CREDITO  NUMBER(18,2) := 0; 
        VIR_DEBITO   NUMBER(18,2) := 0; 
        VIAMPS       NUMBER(18,2) := 0; 
        VPADESC      NUMBER(18,2) := 0; 
        VPAVENC      NUMBER(18,2) := 0; 
        VCONSIG      NUMBER(18,2) := 0; 
        VTOTIDECLI   NUMBER := 0;
        VTOTSERV     NUMBER := 0;
        VTOTCRED     NUMBER(18,2) := 0; 
        VTOTDEB      NUMBER(18,2) := 0; 
        VTOTGER      NUMBER(18,2) := 0;
        VTOTSEFAZ    NUMBER(18,2) := 0;
        V18607       NUMBER(18,2) := 0;
        V18607_DEB   NUMBER(18,2) := 0;
        VTOTDESCONTOSDIVCRED NUMBER(18,2) := 0;
        VTOTDESCONTOSDIVDEB NUMBER(18,2) := 0;
        VOUTRO_CRE_DEB NUMBER(18,2) :=0;

        
        CURSOR C_ENT IS
           SELECT TE.ORG_LEGADOR, TE.COD_ENTIDADE_FGV AS COD_ENTIDADE,
                  TE.UO_LEGADOR, TE.NOM_ENTIDADE, NVL(TE.PODER, 'AUTARQUIAS') AS PODER,
                  TE.UG_LEGADOR, TE.GESTAO_LEGADOR, TE.CLASSIF_LEGADOR,
                  TE.COD_PODER_RELATORIO
           FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
           WHERE TE.COD_ENTIDADE_FGV != 5
           ORDER BY 1,2;

      
      BEGIN
          IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
                 RAISE ERROR_PARAM;
          END IF;
          
          
          
          
          

          BEGIN


              V_DAT_PAGTO := NULL;
              V_DAT_PAGTO := TO_DATE(P_DATA_PAGTO,'DD/MM/YYYY');
              
              BEGIN
                SELECT C.DAT_PAG_EFETIVA
                  INTO V_DAT_PAGTO
                  FROM USER_IPESP.TB_CRONOGRAMA_PAG C
                 WHERE C.COD_INS = P_COD_INS
                   AND C.COD_TIP_PROCESSO = P_TIP_PROCESSO
                   AND C.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND C.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                   AND C.NUM_GRP = P_GRP_PGTO;

                   
              EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     RAISE ERROR_DATA_PGTO;
              END;

              DELETE FROM USER_IPESP.TB_REL_FOLHA_AUX AX
               WHERE AX.COD_INS = P_COD_INS
                 AND AX.TIP_PROCESSO = P_TIP_PROCESSO
                 AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                 AND EXISTS (SELECT 1 
                             FROM TB_CONCESSAO_BENEFICIO CB 
                            WHERE CB.COD_INS       = AX.COD_INS 
                              AND CB.COD_BENEFICIO = AX.COD_BENEFICIO
                              AND CB.COD_TIPO_BENEFICIO = 'M')      
                 AND AX.DAT_PGTO = V_DAT_PAGTO;
              COMMIT;

              INSERT INTO USER_IPESP.TB_REL_FOLHA_AUX AX
               SELECT P_COD_INS, 
                      P_TIP_PROCESSO,
                      TO_DATE(P_PERIODO,'dd/mm/yyyy'), 
                      P_SEQ_PAGAMENTO,
                      BE.COD_BENEFICIO, 
                      BE.COD_IDE_CLI_BEN, 
                      LPAD(P_GRP_PGTO,2,'0'),
                      SYSDATE, 
                      SYSDATE, 
                      USER, 
                      'REL_FOLHA_AUX', 
                      V_DAT_PAGTO,
                      BE.FLG_STATUS, 
                      BE.DAT_INI_BEN, 
                      BE.DAT_FIM_BEN, 
                      BE.NUM_SEQ_BENEF,
                      CB.VAL_PERCENT_BEN
                 FROM USER_IPESP.TB_BENEFICIARIO BE, USER_IPESP.TB_CONCESSAO_BENEFICIO CB
                WHERE BE.COD_INS = P_COD_INS
                  AND BE.COD_PROC_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
                  AND BE.FLG_STATUS IN ('A','X')
                  AND BE.FLG_REG_ATIV = 'S'
                  AND (BE.DAT_FIM_BEN IS NULL OR BE.DAT_FIM_BEN >= TO_DATE(P_PERIODO,'dd/mm/yyyy'))
                  AND CB.COD_INS = BE.COD_INS
                  AND CB.COD_BENEFICIO = BE.COD_BENEFICIO
                  AND CB.COD_TIPO_BENEFICIO = 'M'
                  AND CB.COD_ENTIDADE != 5
                  
                  
                  AND EXISTS
                  (
                      SELECT 1
                        FROM USER_IPESP.TB_FOLHA  TF
                       WHERE TF.COD_INS = P_COD_INS
                         AND TF.TIP_PROCESSO = P_TIP_PROCESSO
                         AND TF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                         AND TF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                         AND NVL(TF.VAL_LIQUIDO,0)  >= 0
                         AND NVL(TF.TOT_CRED,0) != 0 
                         AND TF.COD_BENEFICIO = BE.COD_BENEFICIO
                         AND TF.COD_IDE_CLI = BE.COD_IDE_CLI_BEN
                  );
                  COMMIT;

              
              DELETE FROM USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS A
               WHERE A.COD_INS = P_COD_INS
                 AND A.TIP_PROCESSO = P_TIP_PROCESSO
                 AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND A.COD_GRP_PAGAMENTO = LPAD(P_GRP_PGTO,2,'0')
                 AND A.DAT_PAGTO = V_DAT_PAGTO;
              COMMIT;

              SELECT UPPER(TRIM(GP.DES_GRP_PAG))
                INTO V_NOM_GRUPO
                FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
               WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRP_PGTO);
               
              V_CREDITO := 0;
              V_DEBITO := 0;
              V_NUM_SEQ := 0;
              V_CONTROLE := 1;
              V_TOTAL_LIQUIDO := 0;
              V_TOTAL_VENCIMENTO := 0;
              V_TOTAL_DESCONTO := 0;


              FOR REG IN V_CURSOR
              LOOP
                  IF (REG.COD_FCRUBRICA < 2400000) THEN
                     V_CREDITO := V_CREDITO + REG.CREDITO;
                     V_DEBITO := V_DEBITO + REG.DEBITO;

                     V_NUM_SEQ := V_NUM_SEQ + 1;
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                       V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );

                     COMMIT;
                  ELSE
                     
                     IF (V_CONTROLE = 1) THEN

                         
                         V_NUM_SEQ := V_NUM_SEQ + 1;
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           NULL, NULL, NULL, NULL, NULL,
                            V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                           V_DAT_PAGTO
                         );
                         COMMIT;

                         
                         V_NUM_SEQ := 299;
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           NULL, 'TOTAIS DE VENCIMENTOS', V_CREDITO, V_DEBITO, NULL,
                           V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                           V_DAT_PAGTO
                         );

                         
                         V_NUM_SEQ := V_NUM_SEQ + 1;
                         V_TOTAL_VENCIMENTO := V_CREDITO - V_DEBITO;
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           NULL, NULL, V_TOTAL_VENCIMENTO, NULL, NULL,
                           V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                           V_DAT_PAGTO
                         );
                         COMMIT;

                         
                         V_NUM_SEQ := V_NUM_SEQ + 1;
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           NULL, NULL, NULL, NULL, NULL,
                           V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                           V_DAT_PAGTO
                         );
                         COMMIT;

                         
                         V_NUM_SEQ := V_NUM_SEQ + 1;
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           NULL, NULL, NULL, NULL, NULL,
                           V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                           V_DAT_PAGTO
                         );
                         COMMIT;

                         V_CONTROLE := 2;
                         V_CREDITO := 0;
                         V_DEBITO := 0;
                     END IF;

                     V_CREDITO := V_CREDITO + REG.CREDITO;
                     V_DEBITO := V_DEBITO + REG.DEBITO;
                     V_NUM_SEQ := V_NUM_SEQ + 1;

                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                       V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );
                     COMMIT;
                  END IF;
              END LOOP;

              
              V_NUM_SEQ := V_NUM_SEQ + 1;
              INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
              (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
               COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
               NUM_SEQ, DAT_ING, DAT_ULT_ATU,
               NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
               DAT_PAGTO
              ) VALUES
              (
                P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                NULL, NULL, NULL, NULL, NULL,
                V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                V_DAT_PAGTO
              );
              COMMIT;

              
              V_NUM_SEQ := 599;
              INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
              (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
               COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
               NUM_SEQ, DAT_ING, DAT_ULT_ATU,
               NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
               DAT_PAGTO
              ) VALUES
              (
                P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                NULL, 'TOTAIS DE DESCONTOS', V_CREDITO, V_DEBITO, NULL,
                V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                V_DAT_PAGTO
              );

              V_TOTAL_DESCONTO := V_DEBITO - V_CREDITO;

              
              V_NUM_SEQ := V_NUM_SEQ + 1;
              INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
              (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
               COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
               NUM_SEQ, DAT_ING, DAT_ULT_ATU,
               NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
               DAT_PAGTO
              ) VALUES
              (
                P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                NULL, NULL, NULL, NULL, NULL,
                V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                V_DAT_PAGTO
              );
              COMMIT;

              
              V_NUM_SEQ := V_NUM_SEQ + 1;
              INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
              (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
               COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
               NUM_SEQ, DAT_ING, DAT_ULT_ATU,
               NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
               DAT_PAGTO
              ) VALUES
              (
                P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                NULL, 'TOTAL LIQUIDO', V_TOTAL_VENCIMENTO - V_TOTAL_DESCONTO, NULL, NULL,
                V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                V_DAT_PAGTO
              );
              COMMIT;


               
               
               
               
               FOR R_C IN (SELECT ROWID, CB.*
                              FROM TB_CONCESSAO_BENEFICIO CB
                             WHERE CB.COD_INS = P_COD_INS
                                AND CB.COD_TIPO_BENEFICIO = 'M'
                                AND EXISTS
                                (
                                    SELECT 1 FROM TB_REL_FOLHA_AUX AX
                                      WHERE AX.COD_INS = CB.COD_INS
                                        AND AX.COD_BENEFICIO = CB.COD_BENEFICIO
                                        AND AX.TIP_PROCESSO = P_TIP_PROCESSO
                                        AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                                        AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                                        AND AX.COD_BENEFICIO = CB.COD_BENEFICIO
                                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                        AND AX.DAT_PGTO = V_DAT_PAGTO
                                )
                                AND (CB.COD_ORG_LEGADOR IS NULL OR CB.COD_UO_LEGADOR IS NULL)
                            )
               LOOP
                   UPDATE TB_CONCESSAO_BENEFICIO CB
                     SET CB.COD_ORG_LEGADOR = (
                                               SELECT ORG_LEGADOR FROM
                                               (
                                               SELECT TE.ORG_LEGADOR
                                                 FROM TB_ENTIDADE_FOLHA TE WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                                 ORDER BY TE.ORG_LEGADOR
                                               )WHERE ROWNUM = 1
                                              ),


                         CB.COD_UO_LEGADOR = (SELECT DISTINCT TE.UO_LEGADOR
                                                FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                                               WHERE TE.COD_ENTIDADE_FGV = CB.COD_ENTIDADE
                                                 AND TE.ORG_LEGADOR =
                                                 (
                                                     SELECT ORG_LEGADOR FROM
                                                     (
                                                         SELECT TE.ORG_LEGADOR
                                                           FROM TB_ENTIDADE_FOLHA TE
                                                           WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                                           ORDER BY TE.ORG_LEGADOR
                                                     )WHERE ROWNUM = 1
                                                 )
                                                 AND ROWNUM = 1
                                             )
                  WHERE ROWID = R_C.ROWID;
                  COMMIT;
               END LOOP;

               V18607_DEB := 0;
               V18607     := 0;


                DELETE USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW A
                WHERE A.COD_INS = P_COD_INS
                AND   A.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                AND   A.TIP_PROCESSO = P_TIP_PROCESSO
                AND   A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   A.NUM_GRP = LPAD( P_GRP_PGTO, 2, '0')
                AND   A.COD_TIPO_BENEFICIO = 'M' 
                AND   A.DAT_PAGTO = V_DAT_PAGTO;
                COMMIT;

                FOR V_ENT IN C_ENT
                LOOP
                  BEGIN
                      
                      SELECT     SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_DEB,
                                 SUM( DECODE( FF.FLG_NATUREZA, 'C', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_CRED
                      INTO       VTOTDEB, VTOTCRED
                      FROM TB_DET_CALCULADO FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 1 
                                                )
                      AND   EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                       )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      );

                  EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           VTOTCRED := 0;
                           VTOTDEB  := 0;
                  END;


                  BEGIN
                      
                      SELECT     NVL(SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ),0) TOT_DEB,
                                 NVL(SUM( DECODE( FF.FLG_NATUREZA, 'C', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ),0) TOT_CRED
                      INTO       VTOTDESCONTOSDIVDEB, VTOTDESCONTOSDIVCRED
                      FROM TB_DET_CALCULADO FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 2 
                                                )
                      AND   EXISTS
                      ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      );
                  EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           VTOTDESCONTOSDIVCRED := 0;
                           VTOTDESCONTOSDIVDEB := 0;
                  END;


                  BEGIN
                        
                        
                        SELECT NVL(  SUM( FF.VAL_LIQUIDO ), 0 ) F_TOT_CRED
                        INTO  VTOTGER
                        FROM TB_FOLHA FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.VAL_LIQUIDO >= 0
                        AND   EXISTS
                        ( SELECT 1 FROM TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO = FF.COD_BENEFICIO
                           AND   TC.COD_INS       = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR  = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                        );

                  EXCEPTION
                     WHEN OTHERS THEN
                           VTOTGER := 0;
                  END;



                  BEGIN
                        
                        
                        SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0))
                        INTO       VIR_DEBITO
                        FROM TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 3 
                                                  )
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );

                  EXCEPTION
                       WHEN OTHERS THEN
                            VIR_DEBITO := 0;
                  END;


                  BEGIN
                      
                      SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0))
                        INTO       VIR_CREDITO
                        FROM TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 4 
                                                  )
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );

                  EXCEPTION
                       WHEN OTHERS THEN
                            VIR_CREDITO := 0;
                  END;


                  BEGIN
                      
                      SELECT SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                      INTO   VOUTROSDIVERSOS
                      FROM TB_DET_CALCULADO FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   EXISTS
                      (
                            SELECT 1 FROM USER_IPESP.TB_REL_RUBRICAS RU
                             WHERE RU.COD_INS = P_COD_INS
                              AND RU.COD_TIP_INSTITUICAO = 1 
                              AND RU.COD_TIP_RELATORIO = 1  
                              AND RU.COD_AGRUPACAO_RUBRICA = 14 
                              AND RU.COD_RUBRICA = FF.COD_FCRUBRICA
                      )
                      AND   EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                       )
                      AND EXISTS
                     (
                         SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                          WHERE AX.COD_INS = FF.COD_INS
                            AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                            AND AX.PER_PROCESSO = FF.PER_PROCESSO
                            AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                            AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                            AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                            AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                            AND AX.DAT_PGTO = V_DAT_PAGTO
                     );
                  EXCEPTION
                  WHEN OTHERS THEN
                      VOUTROSDIVERSOS := 0;
                  END;
                  
                  
                  
                  BEGIN
                        
                        SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                        INTO       VIAMPS
                        FROM TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA IN
                                                  (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 5 
                                                  )
                        AND   EXISTS
                        (
                          SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );
                  EXCEPTION
                        WHEN OTHERS THEN
                            VIAMPS := 0;
                  END;


                  BEGIN
                        
                        SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                        INTO       VPADESC
                        FROM TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA IN (SELECT DISTINCT COD_RUBRICA FROM USER_IPESP.TB_RUBRICAS R WHERE R.TIP_EVENTO_ESPECIAL = 'P')
                        AND EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC         
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR        = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR         = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );
                  EXCEPTION
                      WHEN OTHERS THEN
                          VPADESC := 0;
                  END;


                  BEGIN
                        
                        SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                        INTO       VPAVENC
                        FROM TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 6 
                                                  )
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );
                  EXCEPTION
                       WHEN OTHERS THEN
                           VPAVENC := 0;
                  END;


                  BEGIN
                        
                      SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                      INTO       VTOTSEFAZ
                      FROM TB_DET_CALCULADO FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 7 
                                                  )
                      AND   EXISTS
                      ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      );
                  EXCEPTION
                     WHEN OTHERS THEN
                         VTOTSEFAZ := 0;
                  END;

                  BEGIN
                      
                      SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                      INTO       VCONSIG
                      FROM TB_DET_CALCULADO FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 8 
                                                  )
                      AND   EXISTS
                      ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      );

                  EXCEPTION
                  WHEN OTHERS THEN
                      VCONSIG := 0;
                  END;

                  BEGIN
                    
                    SELECT COUNT(*)
                    INTO   VTOTIDECLI
                    FROM
                    (
                        SELECT DISTINCT FF.COD_IDE_CLI, FF.COD_BENEFICIO
                        FROM TB_FOLHA FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.VAL_LIQUIDO   >= 0
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        )
                     );
                  EXCEPTION
                      WHEN OTHERS THEN
                          VTOTIDECLI := 0;
                  END;


                  BEGIN
                      
                      SELECT COUNT(*)
                      INTO   VTOTSERV
                      FROM
                      (
                          SELECT DISTINCT FF.COD_BENEFICIO
                          FROM TB_FOLHA FF
                          WHERE FF.COD_INS = P_COD_INS
                          AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                          AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                          AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                          AND   FF.VAL_LIQUIDO  >= 0
                          AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                           WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                           AND   TC.COD_INS            = FF.COD_INS
                           AND   TC.COD_TIPO_BENEFICIO = 'M'
                           AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                           AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        )
                     );
                  EXCEPTION
                       WHEN OTHERS THEN
                            VTOTSERV := 0;
                  END;

                  
                  














































                  BEGIN
                     
                     SELECT
                        SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                        SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) )
                        INTO  V18607
                        FROM USER_IPESP.TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA < 2400000
                        AND   FF.COD_FCRUBRICA  IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 9 
                                                  )
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                                       WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                                       AND   TC.COD_INS            = FF.COD_INS
                                       AND   TC.COD_TIPO_BENEFICIO = 'M'
                                       AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                                       AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );

                  EXCEPTION
                     WHEN OTHERS THEN
                          V18607     := 0;
                  END;
                  
                  BEGIN
                     
                     SELECT
                        SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                        SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) )
                        INTO  V18607_DEB
                        FROM USER_IPESP.TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA >= 2400000
                        AND   FF.COD_FCRUBRICA  IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 9 
                                                  )
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                                       WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                                       AND   TC.COD_INS            = FF.COD_INS
                                       AND   TC.COD_TIPO_BENEFICIO = 'M'
                                       AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                                       AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );

                  EXCEPTION
                     WHEN OTHERS THEN
                          V18607_DEB := 0;
                  END;
                  

                  BEGIN
                      
                      SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                        INTO    VOUTRO_CRE_DEB
                        FROM TB_DET_CALCULADO FF
                        WHERE FF.COD_INS = P_COD_INS
                        AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                        AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                        AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                        AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 1 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 10 
                                                  )
                        AND   EXISTS
                        ( SELECT 1 FROM  TB_CONCESSAO_BENEFICIO TC
                                       WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                                       AND   TC.COD_INS            = FF.COD_INS
                                       AND   TC.COD_TIPO_BENEFICIO = 'M'
                                       AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                                       AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                        )
                        AND EXISTS
                        (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = FF.COD_INS
                                AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                                AND AX.PER_PROCESSO = FF.PER_PROCESSO
                                AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                                AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                                AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                AND AX.DAT_PGTO = V_DAT_PAGTO
                        );
                  EXCEPTION
                      WHEN OTHERS THEN
                           VOUTRO_CRE_DEB := 0;
                  END;



                  INSERT INTO USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW
                  VALUES (
                             TO_DATE( P_PERIODO, 'dd/mm/yyyy' ),
                             LPAD(P_GRP_PGTO,2,'0'),
                             V_ENT.COD_ENTIDADE,
                             V_ENT.ORG_LEGADOR,
                             V_ENT.UO_LEGADOR,
                             V_ENT.PODER,
                             V_ENT.NOM_ENTIDADE,
                             NVL( VTOTSERV, 0 ),
                             NVL( VTOTIDECLI, 0 ),
                             NVL( VTOTDEB - VTOTCRED, 0),
                             NVL( VTOTGER, 0 ),
                             NVL( VIR_CREDITO, 0 ),
                             NVL( VIR_DEBITO, 0 ),
                             NVL( VIAMPS, 0 ),
                             NVL( VPADESC, 0 ),
                             NVL( VPAVENC, 0 ),
                             NVL( VTOTSEFAZ, 0 ),
                             NVL( VCONSIG, 0 ),
                             0,
                             NVL(V18607, 0),
                             NVL(V18607_DEB, 0),
                             NVL(VOUTRO_CRE_DEB,0),
                             P_COD_INS,
                             P_TIP_PROCESSO,
                             P_SEQ_PAGAMENTO,
                             NULL,
                             V_DAT_PAGTO,
                             V_ENT.COD_PODER_RELATORIO,
                             

















                             V_ENT.UG_LEGADOR,
                             V_ENT.GESTAO_LEGADOR,
                             V_ENT.CLASSIF_LEGADOR,
                             VTOTDESCONTOSDIVDEB - VTOTDESCONTOSDIVCRED,
                             NVL(VOUTROSDIVERSOS,0),
                             0
                          );

                          COMMIT;
                END LOOP;


            
            SP_FECHAMENTO_RUBRICA_PODER(P_COD_INS,
                                        P_PERIODO,
                                        P_TIP_PROCESSO,
                                        P_SEQ_PAGAMENTO,
                                        P_GRP_PGTO,
                                        V_DAT_PAGTO,
                                        VS_ERRO_RUBRICA_PODER);
            
            
            USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_CONSIG_DET(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                       P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);

            
            USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_PA(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                       P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);

             
            USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_TJM(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                       P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);


            
            USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_PENSAO_CIV ('Folha_Entidade_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_SEQ_PAGAMENTO, V_DAT_PAGTO, LPAD(P_GRP_PGTO,2,'0'));
            USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_VALOR_DEVOLVIDO_BANCO ('Folha_Entidade_ValorDevolvido_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_SEQ_PAGAMENTO, V_DAT_PAGTO, LPAD(P_GRP_PGTO,2,'0'));
            USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_13_SAL_PEN ('Folha_Entidade_13_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
            USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_RUBRICAS ('Folha_Rubricas_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
            USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_SINTETICO ('Folha_SinteticoConsig_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
            USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_CONCEITO ('Folha_SinteticoConsig_Conceito_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
            
            
            
            FOR REL IN 
              (
                SELECT DISTINCT RT.COD_CONCEITO, UPPER(TRIM(RT.NOM_RUBRICA)) NOM_RUBRICA 
                  FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                 WHERE RT.COD_INS = P_COD_INS
                   AND RT.PER_PROCESSO = P_PERIODO
                   AND RT.TIP_PROCESSO = P_TIP_PROCESSO
                   AND RT.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND RT.COD_GRUPO_PAGTO = LPAD(P_GRP_PGTO,2,'0')
                   AND RT.DAT_PAGTO = V_DAT_PAGTO
                   AND RT.FLG_CONSIGNATARIA = 'N'
              )
            LOOP
                  USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ANALITICO_RUBRICA ('Folha_Analitico_'||TO_CHAR(REL.COD_CONCEITO)||'_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD')||'.xls', P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO, REL.COD_CONCEITO, 'N'); 
            END LOOP;
            
            

         EXCEPTION
             WHEN ERROR_PARAM THEN
                  VS_ERRO := 'OS PARAMETROS P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, P_PERIODO, P_GRP_PAGTO SAO OBRIGATORIOS';
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
   END SP_FECHAMENTO_GERAL_RUBRICA_PC;


   
   
   
    PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_PM
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    ) IS

    
    VS_ERRO VARCHAR2 (1000);
    ERROR_PARAM EXCEPTION;
    ERROR_DATA_PGTO EXCEPTION;

    

    VS_BANCO VARCHAR2(10);
    VS_AGENCIA VARCHAR2(10);
    VS_CONTA VARCHAR2(10);
    NOM_RUBRICA VARCHAR2(150);
    PERC_OPERACIONAL NUMBER;
    VS_CNPJ VARCHAR2(20);
    V_NUM_GRUPO_MIGRAR VARCHAR2(2);

    V_CREDITO NUMBER;
    V_DEBITO NUMBER;
    V_TOTAL_LIQUIDO NUMBER;
    V_TOTAL_VENCIMENTO NUMBER;
    V_TOTAL_DESCONTO NUMBER;
    V_NUM_SEQ NUMBER;
    V_COD_ENTIDADE NUMBER;
    V_CONTROLE NUMBER;
    V_DAT_PAGTO DATE;
    V_NOM_GRUPO VARCHAR2(100);

    
    CURSOR V_CURSOR IS
      SELECT T1.COD_FCRUBRICA,
              








             R1.NOM_RUBRICA,
             SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
             SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
             COUNT(*) AS QTDE
        FROM USER_IPESP.TB_DET_CALCULADO T1, USER_IPESP.TB_RUBRICAS  R1
       WHERE T1.COD_INS = P_COD_INS
         AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
         AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
         AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
         AND R1.COD_INS = T1.COD_INS
         AND R1.COD_RUBRICA =T1.COD_FCRUBRICA
         AND R1.COD_ENTIDADE = V_COD_ENTIDADE
         AND R1.DAT_FIM_VIG IS NULL
         AND EXISTS (SELECT 1 FROM USER_IPESP.TB_IMPRESAO_RUB  IR
                    WHERE IR.COD_RUBRICA  = T1.COD_FCRUBRICA
                      AND IR.COD_ENTIDADE = V_COD_ENTIDADE
                      AND (IR.FLG_IMPRIME  IN ('A','S'))
                    )
         AND EXISTS
         (
             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
              WHERE AX.COD_INS = T1.COD_INS
                AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                AND AX.PER_PROCESSO = T1.PER_PROCESSO
                AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                AND AX.DAT_PGTO = V_DAT_PAGTO
         )
        GROUP BY T1.COD_FCRUBRICA, R1.NOM_RUBRICA
        ORDER BY T1.COD_FCRUBRICA;


    
    VIR_CREDITO     NUMBER(18,2) := 0; 
    VIR_DEBITO      NUMBER(18,2) := 0; 
    VIAMPS          NUMBER(18,2) := 0; 
    VPADESC         NUMBER(18,2) := 0; 
    VPAVENC         NUMBER(18,2) := 0; 
    VCONSIG         NUMBER(18,2) := 0; 
    VTOTIDECLI      NUMBER := 0;
    VTOTSERV        NUMBER := 0;
    VTOTCRED        NUMBER(18,2) := 0; 
    VTOTDEB         NUMBER(18,2) := 0; 
    VTOTGER         NUMBER(18,2) := 0;
    VTOTSEFAZ       NUMBER(18,2) := 0;
    V18607          NUMBER(18,2) := 0;
    V18607_DEB      NUMBER(18,2) := 0;
    VOUTRO_CRE_DEB  NUMBER(18,2) := 0;
    VTOTDIVERSOS    NUMBER(18,2) := 0;
    VOUTROSDIVERSOS NUMBER(18,2) := 0;

    
    CURSOR C_ENT IS
       SELECT TE.ORG_LEGADOR,
              TE.UO_LEGADOR, TE.NOM_ENTIDADE, NVL(TE.PODER, 'AUTARQUIAS') AS PODER,
              TE.COD_ENTIDADE_FGV AS COD_ENTIDADE, TE.UG_LEGADOR, 
              TE.GESTAO_LEGADOR, TE.CLASSIF_LEGADOR,
              TE.COD_PODER_RELATORIO
       FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
       WHERE TE.COD_ENTIDADE_FGV = 5
       ORDER BY 1,2;

  BEGIN
      BEGIN
          IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
             RAISE ERROR_PARAM;
          END IF;













































          
          
          V_DAT_PAGTO := NULL;
          V_DAT_PAGTO := TO_DATE(P_DATA_PAGTO,'DD/MM/YYYY');

          BEGIN
            SELECT C.DAT_PAG_EFETIVA
              INTO V_DAT_PAGTO
              FROM USER_IPESP.TB_CRONOGRAMA_PAG C
             WHERE C.COD_INS = P_COD_INS
               AND C.COD_TIP_PROCESSO = P_TIP_PROCESSO
               AND C.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND C.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
               AND C.NUM_GRP = P_GRP_PGTO;
               
               
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 RAISE ERROR_DATA_PGTO;
          END;

          DELETE FROM USER_IPESP.TB_REL_FOLHA_AUX AX
           WHERE AX.COD_INS = P_COD_INS
             AND AX.TIP_PROCESSO = P_TIP_PROCESSO
             AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
             AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
             AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
             AND AX.DAT_PGTO = V_DAT_PAGTO;
          COMMIT;

          INSERT INTO USER_IPESP.TB_REL_FOLHA_AUX AX
           SELECT P_COD_INS, P_TIP_PROCESSO,
                  TO_DATE(P_PERIODO,'dd/mm/yyyy'), P_SEQ_PAGAMENTO,
                  BE.COD_BENEFICIO, BE.COD_IDE_CLI_BEN, LPAD(P_GRP_PGTO,2,'0'),
                  SYSDATE, SYSDATE, USER, 'REL_FOLHA_AUX', V_DAT_PAGTO,
                  BE.FLG_STATUS, BE.DAT_INI_BEN, BE.DAT_FIM_BEN, BE.NUM_SEQ_BENEF,
                  CB.VAL_PERCENT_BEN
             FROM TB_BENEFICIARIO BE, USER_IPESP.TB_CONCESSAO_BENEFICIO CB
            WHERE BE.COD_INS = P_COD_INS
              AND BE.COD_PROC_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
              AND BE.FLG_STATUS IN ('A','X')
              AND BE.FLG_REG_ATIV = 'S'
              AND (BE.DAT_FIM_BEN IS NULL OR BE.DAT_FIM_BEN >= TO_DATE(P_PERIODO,'dd/mm/yyyy'))
              AND CB.COD_INS = BE.COD_INS
              AND CB.COD_BENEFICIO = BE.COD_BENEFICIO
              AND CB.COD_TIPO_BENEFICIO = 'M'
              AND CB.COD_ENTIDADE = 5
              
              
              AND EXISTS
              (
                  SELECT 1
                    FROM USER_IPESP.TB_FOLHA  TF
                   WHERE TF.COD_INS = P_COD_INS
                     AND TF.TIP_PROCESSO = P_TIP_PROCESSO
                     AND TF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                     AND TF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND NVL(TF.VAL_LIQUIDO,0)  >= 0
                     AND NVL(TF.TOT_CRED,0) != 0 
                     AND TF.COD_BENEFICIO = BE.COD_BENEFICIO
                     AND TF.COD_IDE_CLI = BE.COD_IDE_CLI_BEN
              );
              COMMIT;


          
          
          

          DELETE FROM USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS A
           WHERE A.COD_INS = P_COD_INS
             AND A.TIP_PROCESSO = P_TIP_PROCESSO
             AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
             AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
             AND A.COD_GRP_PAGAMENTO = LPAD(P_GRP_PGTO,2,'0')
             AND A.DAT_PAGTO = V_DAT_PAGTO;
          COMMIT;

          SELECT DECODE(TIP_INSTITUICAO,2,5,4,5,1), UPPER(TRIM(GP.DES_GRP_PAG))
            INTO V_COD_ENTIDADE, V_NOM_GRUPO
            FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
           WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRP_PGTO);


          V_CREDITO := 0;
          V_DEBITO := 0;
          V_NUM_SEQ := 0;
          V_CONTROLE := 1;
          V_TOTAL_LIQUIDO := 0;
          V_TOTAL_VENCIMENTO := 0;
          V_TOTAL_DESCONTO := 0;

          FOR REG IN V_CURSOR
          LOOP
              IF (REG.COD_FCRUBRICA < 2400000) THEN
                 V_CREDITO := V_CREDITO + REG.CREDITO;
                 V_DEBITO := V_DEBITO + REG.DEBITO;

                 V_NUM_SEQ := V_NUM_SEQ + 1;
                 INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                 (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                  COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                  NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                  NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                  DAT_PAGTO
                 ) VALUES
                 (
                   P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                   REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                   V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                   'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                   V_DAT_PAGTO
                 );

                 COMMIT;
              ELSE
                 
                 IF (V_CONTROLE = 1) THEN

                     
                     V_NUM_SEQ := V_NUM_SEQ + 1;
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       NULL, NULL, NULL, NULL, NULL,
                        V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );
                     COMMIT;

                     
                     V_NUM_SEQ := 299;
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       NULL, 'TOTAIS DE VENCIMENTOS', V_CREDITO, V_DEBITO, NULL,
                       V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );

                     
                     V_NUM_SEQ := V_NUM_SEQ + 1;
                     V_TOTAL_VENCIMENTO := V_CREDITO - V_DEBITO;
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       NULL, NULL, V_TOTAL_VENCIMENTO, NULL, NULL,
                       V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );
                     COMMIT;

                     
                     V_NUM_SEQ := V_NUM_SEQ + 1;
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       NULL, NULL, NULL, NULL, NULL,
                       V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );
                     COMMIT;

                     
                     V_NUM_SEQ := V_NUM_SEQ + 1;
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                     (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                      COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                      NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                      NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                      DAT_PAGTO
                     ) VALUES
                     (
                       P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                       NULL, NULL, NULL, NULL, NULL,
                       V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                       'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                       V_DAT_PAGTO
                     );
                     COMMIT;

                     V_CONTROLE := 2;
                     V_CREDITO := 0;
                     V_DEBITO := 0;
                 END IF;

                 V_CREDITO := V_CREDITO + REG.CREDITO;
                 V_DEBITO := V_DEBITO + REG.DEBITO;
                 V_NUM_SEQ := V_NUM_SEQ + 1;

                 INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                 (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                  COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                  NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                  NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                  DAT_PAGTO
                 ) VALUES
                 (
                   P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                   REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                   V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                   'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                   V_DAT_PAGTO
                 );
                 COMMIT;
              END IF;
          END LOOP;

          
          V_NUM_SEQ := V_NUM_SEQ + 1;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, NULL, NULL, NULL, NULL,
            V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );
          COMMIT;

          
          V_NUM_SEQ := 599;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, 'TOTAIS DE DESCONTOS', V_CREDITO, V_DEBITO, NULL,
            V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );

          V_TOTAL_DESCONTO := V_DEBITO - V_CREDITO;


         
          V_NUM_SEQ := V_NUM_SEQ + 1;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, NULL, NULL, NULL, NULL,
            V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );
          COMMIT;

          
          V_NUM_SEQ := V_NUM_SEQ + 1;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, 'TOTAL LIQUIDO', V_TOTAL_VENCIMENTO - V_TOTAL_DESCONTO, NULL, NULL,
            V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );
          COMMIT;


          
          
          
          
          FOR R_C IN (SELECT ROWID, CB.*
                        FROM TB_CONCESSAO_BENEFICIO CB
                       WHERE CB.COD_INS = P_COD_INS
                          AND CB.COD_TIPO_BENEFICIO = 'M'
                          AND EXISTS
                           (
                               SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                                WHERE AX.COD_INS = CB.COD_INS
                                  AND AX.TIP_PROCESSO = P_TIP_PROCESSO
                                  AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                                  AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                                  AND AX.COD_BENEFICIO = CB.COD_BENEFICIO
                                  AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                  AND AX.DAT_PGTO = V_DAT_PAGTO
                           )
                          AND (CB.COD_ORG_LEGADOR IS NULL OR CB.COD_UO_LEGADOR IS NULL)
                      )
          LOOP
             UPDATE TB_CONCESSAO_BENEFICIO CB
               SET CB.COD_ORG_LEGADOR = (
                                         SELECT ORG_LEGADOR FROM
                                         (
                                         SELECT TE.ORG_LEGADOR
                                           FROM TB_ENTIDADE_FOLHA TE WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                           ORDER BY TE.ORG_LEGADOR
                                         )WHERE ROWNUM = 1
                                        ),
                   CB.COD_UO_LEGADOR = (SELECT DISTINCT TE.UO_LEGADOR
                                          FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                                         WHERE TE.COD_ENTIDADE_FGV = CB.COD_ENTIDADE
                                           AND TE.ORG_LEGADOR =
                                           (
                                               SELECT ORG_LEGADOR FROM
                                               (
                                                   SELECT TE.ORG_LEGADOR
                                                     FROM TB_ENTIDADE_FOLHA TE
                                                     WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                                     ORDER BY TE.ORG_LEGADOR
                                               )WHERE ROWNUM = 1
                                           )
                                           AND ROWNUM = 1
                                       )
            WHERE ROWID = R_C.ROWID;
            COMMIT;
          END LOOP;

          V18607_DEB := 0;
          V18607     := 0;

          DELETE USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW A
          WHERE A.COD_INS = P_COD_INS
          AND   A.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
          AND   A.TIP_PROCESSO = P_TIP_PROCESSO
          AND   A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
          AND   A.NUM_GRP = LPAD(P_GRP_PGTO,2,'0')
          AND   A.DAT_PAGTO = V_DAT_PAGTO;
          COMMIT;


          <<L_ENT>>
          FOR V_ENT IN C_ENT
          LOOP

              BEGIN

                
                SELECT     SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_DEB,
                           SUM( DECODE( FF.FLG_NATUREZA, 'C', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_CRED
                INTO       VTOTDEB, VTOTCRED
                FROM TB_DET_CALCULADO FF
                WHERE FF.COD_INS = P_COD_INS
                AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 1 
                                             )
                AND   EXISTS
                ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                   WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                   AND   TC.COD_INS            = FF.COD_INS
                   AND   TC.COD_TIPO_BENEFICIO = 'M'
                   AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                   AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                )
                AND EXISTS
                (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                );

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     VTOTCRED := 0;
                     VTOTDEB  := 0;
              END;

              BEGIN
                  
                  
                  SELECT NVL(  SUM( FF.VAL_LIQUIDO ), 0 ) F_TOT_CRED
                  INTO   VTOTGER
                  FROM TB_FOLHA FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.VAL_LIQUIDO >= 0
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );


              EXCEPTION
              WHEN OTHERS THEN
                   VTOTGER := 0;
              END;

              BEGIN
                  
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0))
                  INTO       VIR_DEBITO
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 3 
                                             )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

              EXCEPTION
               WHEN OTHERS THEN
                    VIR_DEBITO := 0;
              END;

              
              BEGIN
                  
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0))
                  INTO       VIR_CREDITO
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 4 
                                             )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

              EXCEPTION
               WHEN OTHERS THEN
                    VIR_CREDITO := 0;
              END;


              
              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VIAMPS
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 11 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
              WHEN OTHERS THEN
                  VIAMPS := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VPADESC
                  FROM  TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (SELECT DISTINCT COD_RUBRICA FROM USER_IPESP.TB_RUBRICAS R WHERE R.TIP_EVENTO_ESPECIAL = 'P')
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

              EXCEPTION
                WHEN OTHERS THEN
                    VPADESC := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VPAVENC
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 12 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
                  WHEN OTHERS THEN
                       VPAVENC := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VTOTSEFAZ
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 13 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
               WHEN OTHERS THEN
                   VTOTSEFAZ := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VTOTDIVERSOS
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 2 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
                  WHEN OTHERS THEN
                       VTOTDIVERSOS := 0;
              END;


              BEGIN
                 
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VCONSIG
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND  FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 8 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
                   WHEN OTHERS THEN
                        VCONSIG := 0;
              END;

              
              BEGIN
                SELECT COUNT(*)
                INTO   VTOTIDECLI
                FROM (
                    SELECT DISTINCT FF.COD_IDE_CLI, FF.COD_BENEFICIO
                    FROM TB_FOLHA FF
                    WHERE FF.COD_INS = P_COD_INS
                    AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                    AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                    AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                    AND   FF.VAL_LIQUIDO   >= 0
                    AND EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      )
                   );
               EXCEPTION
              WHEN OTHERS THEN
                  VTOTIDECLI := 0;
              END;

              BEGIN
                  
                  SELECT COUNT(*)
                  INTO   VTOTSERV
                  FROM
                  (
                      SELECT DISTINCT FF.COD_BENEFICIO
                      FROM TB_FOLHA FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.VAL_LIQUIDO  >= 0
                      AND EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO = 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      )
                   );

               EXCEPTION
               WHEN OTHERS THEN
                    VTOTSERV := 0;
               END;

               














































               
               
               
               BEGIN
                SELECT
                  SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                  SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) )
                  INTO  V18607
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA < 2400000
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 9 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

               EXCEPTION
               WHEN OTHERS THEN
                    V18607     := 0;
               END;

               
               
               BEGIN
                SELECT
                  SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                  SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) )
                  INTO V18607_DEB
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA >= 2400000
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 9 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

               EXCEPTION
               WHEN OTHERS THEN
                    V18607_DEB := 0;
               END;

               
               
               BEGIN

                
                SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VOUTRO_CRE_DEB
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 2 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 10 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO = 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
               EXCEPTION
               WHEN OTHERS THEN
                    VOUTRO_CRE_DEB := 0;
               END;

               
               INSERT INTO USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW
               VALUES (
                         TO_DATE( P_PERIODO, 'dd/mm/yyyy' ),
                         LPAD(P_GRP_PGTO,2,'0'),
                         V_ENT.COD_ENTIDADE,
                         V_ENT.ORG_LEGADOR,
                         V_ENT.UO_LEGADOR,
                         V_ENT.PODER,
                         V_ENT.NOM_ENTIDADE,
                         NVL( VTOTSERV, 0 ),
                         NVL( VTOTIDECLI, 0 ),
                         NVL( VTOTDEB - VTOTCRED, 0),
                         NVL( VTOTGER, 0 ),
                         NVL( VIR_CREDITO, 0 ),
                         NVL( VIR_DEBITO, 0 ),
                         NVL( VIAMPS, 0 ),
                         NVL( VPADESC, 0 ),
                         NVL( VPAVENC, 0 ),
                         NVL( VTOTSEFAZ, 0 ),
                         NVL( VCONSIG, 0 ),
                         VTOTDIVERSOS,
                         NVL(V18607, 0),
                         NVL(V18607_DEB, 0),
                         NVL(VOUTRO_CRE_DEB,0),
                         P_COD_INS,
                         P_TIP_PROCESSO,
                         P_SEQ_PAGAMENTO,
                         NULL,
                         V_DAT_PAGTO,
                         V_ENT.COD_PODER_RELATORIO,
                         

















                         V_ENT.UG_LEGADOR,
                         V_ENT.GESTAO_LEGADOR,
                         V_ENT.CLASSIF_LEGADOR,
                         0, 
                         NVL(VOUTROSDIVERSOS,0),
                         0
                      );

                      COMMIT;
          END LOOP L_ENT;

          






























































































































































































































































          
          USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_CONSIG_DET(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                     P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);

          
          USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_PA(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                     P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);


          
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_PENSAO_MIL ('Folha_Entidade_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO,  LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_13_SAL_PEN_MIL ('Folha_Entidade_13_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_VALOR_DEVOLVIDO_BANCO ('Folha_Entidade_ValorDevolvido_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_SEQ_PAGAMENTO, V_DAT_PAGTO, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_RUBRICAS ('Folha_Rubricas_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_SINTETICO ('Folha_SinteticoConsig_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_CONCEITO ('Folha_SinteticoConsig_Conceito_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
          
          
          
          FOR REL IN 
            (
              SELECT DISTINCT RT.COD_CONCEITO, UPPER(TRIM(RT.NOM_RUBRICA)) NOM_RUBRICA 
                FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
               WHERE RT.COD_INS = P_COD_INS
                 AND RT.PER_PROCESSO = P_PERIODO
                 AND RT.TIP_PROCESSO = P_TIP_PROCESSO
                 AND RT.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND RT.COD_GRUPO_PAGTO = LPAD(P_GRP_PGTO,2,'0')
                 AND RT.DAT_PAGTO = V_DAT_PAGTO
                 AND RT.FLG_CONSIGNATARIA = 'N'
            )
          LOOP
                USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ANALITICO_RUBRICA ('Folha_Analitico_'||TO_CHAR(REL.COD_CONCEITO)||'_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD')||'.xls', P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO, REL.COD_CONCEITO, 'N'); 
          END LOOP;


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
 END SP_FECHAMENTO_GERAL_RUBRICA_PM;
   
 
 
 

  PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_AC
  (
     P_COD_INS NUMBER, 
     P_PERIODO VARCHAR2,  
     P_TIP_PROCESSO CHAR, 
     P_SEQ_PAGAMENTO NUMBER, 
     P_GRP_PGTO VARCHAR2,
     P_DATA_PAGTO VARCHAR2,
     P_ERRO OUT VARCHAR2
  ) IS

  
  V_DAT_PAGTO DATE;
  ERROR_DATA_PGTO EXCEPTION;
  GERAL EXCEPTION;

  
  CURSOR C_ENT IS
     SELECT TE.ORG_LEGADOR,
            TE.UO_LEGADOR, TE.COD_ENTIDADE_FGV AS COD_ENTIDADE, TE.NOM_ENTIDADE, NVL(TE.PODER, 'AUTARQUIAS') AS PODER,
            TE.UG_LEGADOR, TE.GESTAO_LEGADOR, TE.CLASSIF_LEGADOR,
            TE.COD_PODER_RELATORIO
     FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
     ORDER BY 1,2;

  
  VIR_CREDITO  NUMBER(18,2) := 0; 
  VIR_DEBITO   NUMBER(18,2) := 0; 
  VIAMPS       NUMBER(18,2) := 0; 
  VPADESC      NUMBER(18,2) := 0; 
  VPAVENC      NUMBER(18,2) := 0; 
  VCONSIG      NUMBER(18,2) := 0; 
  VTOTIDECLI   NUMBER := 0;
  VTOTSERV     NUMBER := 0;
  VTOTCRED     NUMBER(18,2) := 0; 
  VTOTDEB      NUMBER(18,2) := 0; 
  VTOTGER      NUMBER(18,2) := 0;
  VTOTSEFAZ    NUMBER(18,2) := 0;
  V18607       NUMBER(18,2) := 0;
  V18607_DEB   NUMBER(18,2) := 0;
  VOUTRO_CRE_DEB NUMBER(18,2) :=0;
  VTOTDESCONTOSDIVCRED NUMBER(18,2) := 0;
  VTOTDESCONTOSDIVDEB NUMBER(18,2) := 0;
  VOUTROSDIVERSOS NUMBER(18,2) := 0;
  V_NUM_GRUPO_MIGRAR VARCHAR2(2);

  
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
  V_NOM_GRUPO VARCHAR2(100);
  V_NOM_RUBRICA VARCHAR2(200);

  
  CURSOR V_CURSOR IS
      SELECT T1.COD_FCRUBRICA,
              








             
             SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
             SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
             COUNT(*) AS QTDE
        FROM USER_IPESP.TB_DET_CALCULADO T1
       WHERE T1.COD_INS = P_COD_INS
         AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
         AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
         AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
         
         
         
         
         AND EXISTS
         (
             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
              WHERE AX.COD_INS = T1.COD_INS
                AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                AND AX.PER_PROCESSO = T1.PER_PROCESSO
                AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                AND AX.DAT_PGTO = V_DAT_PAGTO
         )
      GROUP BY T1.COD_FCRUBRICA
      ORDER BY T1.COD_FCRUBRICA;

    BEGIN
        BEGIN

            IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
               RAISE ERROR_PARAM;
            END IF;













































            V_DAT_PAGTO := NULL;
            V_DAT_PAGTO := TO_DATE(P_DATA_PAGTO,'DD/MM/YYYY');
            
            BEGIN
              SELECT C.DAT_PAG_EFETIVA
                INTO V_DAT_PAGTO
                FROM USER_IPESP.TB_CRONOGRAMA_PAG C
               WHERE C.COD_INS = P_COD_INS
                 AND C.COD_TIP_PROCESSO = P_TIP_PROCESSO
                 AND C.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND C.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND C.NUM_GRP = P_GRP_PGTO;

            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   RAISE ERROR_DATA_PGTO;
            END;

            
            DELETE FROM USER_IPESP.TB_REL_FOLHA_AUX AX
             WHERE AX.COD_INS = P_COD_INS
               AND AX.TIP_PROCESSO = P_TIP_PROCESSO
               AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
               AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
               AND EXISTS (SELECT 1 
                             FROM TB_CONCESSAO_BENEFICIO CB 
                            WHERE CB.COD_INS       = AX.COD_INS 
                              AND CB.COD_BENEFICIO = AX.COD_BENEFICIO
                              AND CB.COD_TIPO_BENEFICIO <> 'M')      
               AND AX.DAT_PGTO = V_DAT_PAGTO;
            COMMIT;

            INSERT INTO USER_IPESP.TB_REL_FOLHA_AUX AX
             SELECT P_COD_INS, P_TIP_PROCESSO,
                    TO_DATE(P_PERIODO,'dd/mm/yyyy'), P_SEQ_PAGAMENTO,
                    BE.COD_BENEFICIO, BE.COD_IDE_CLI_BEN, LPAD(P_GRP_PGTO,2,'0'),
                    SYSDATE, SYSDATE, USER, 'REL_FOLHA_AUX', V_DAT_PAGTO,
                    BE.FLG_STATUS, BE.DAT_INI_BEN, BE.DAT_FIM_BEN, BE.NUM_SEQ_BENEF,
                    CB.VAL_PERCENT_BEN
               FROM TB_BENEFICIARIO BE, USER_IPESP.TB_CONCESSAO_BENEFICIO CB
              WHERE BE.COD_INS = P_COD_INS
                AND BE.COD_PROC_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
                AND BE.FLG_STATUS IN ('A','X')
                AND BE.FLG_REG_ATIV = 'S'
                AND (BE.DAT_FIM_BEN IS NULL OR BE.DAT_FIM_BEN >= TO_DATE(P_PERIODO,'dd/mm/yyyy'))
                AND CB.COD_INS = BE.COD_INS
                AND CB.COD_BENEFICIO = BE.COD_BENEFICIO
                AND CB.COD_TIPO_BENEFICIO != 'M'
                AND CB.COD_ENTIDADE != 5
                AND EXISTS
                (
                    SELECT 1
                      FROM USER_IPESP.TB_FOLHA  TF
                     WHERE TF.COD_INS = P_COD_INS
                       AND TF.TIP_PROCESSO = P_TIP_PROCESSO
                       AND TF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                       AND TF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                       AND TF.VAL_LIQUIDO  >= 0
                       AND NVL(TF.VAL_LIQUIDO,0)  >= 0
                       AND NVL(TF.TOT_CRED,0) != 0 
                       AND TF.COD_BENEFICIO = BE.COD_BENEFICIO
                       AND TF.COD_IDE_CLI = BE.COD_IDE_CLI_BEN
                );
                COMMIT;

            DELETE FROM USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS A
             WHERE A.COD_INS = P_COD_INS
               AND A.TIP_PROCESSO = P_TIP_PROCESSO
               AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
               AND A.COD_GRP_PAGAMENTO = LPAD(P_GRP_PGTO,2,'0')
               AND A.DAT_PAGTO = V_DAT_PAGTO;
            COMMIT;

            SELECT DECODE(TIP_INSTITUICAO,2,5,1), UPPER(TRIM(GP.DES_GRP_PAG))
              INTO V_COD_ENTIDADE, V_NOM_GRUPO
              FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
             WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRP_PGTO);

            V_CREDITO := 0;
            V_DEBITO := 0;
            V_NUM_SEQ := 0;
            V_CONTROLE := 1;
            V_TOTAL_LIQUIDO := 0;
            V_TOTAL_VENCIMENTO := 0;
            V_TOTAL_DESCONTO := 0;


            FOR REG IN V_CURSOR
            LOOP
               V_NOM_RUBRICA := NULL;
               
               BEGIN
                   SELECT NOM_RUBRICA
                     INTO V_NOM_RUBRICA
                     FROM USER_IPESP.TB_RUBRICAS R
                    WHERE R.COD_INS = 1
                      AND R.COD_RUBRICA = REG.COD_FCRUBRICA
                      AND ROWNUM = 1;
               EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                         VS_ERRO := 'RUBRICA '||REG.COD_FCRUBRICA||' NAO LOCALIZADA NA TABELA TB_RUBRICAS' ;
                         RAISE GERAL;
               END;
               
                IF (REG.COD_FCRUBRICA < 2400000) THEN

                   V_CREDITO := V_CREDITO + REG.CREDITO;
                   V_DEBITO := V_DEBITO + REG.DEBITO;

                   V_NUM_SEQ := V_NUM_SEQ + 1;
                   INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                   (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                    COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                    NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                    NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                    DAT_PAGTO
                   ) VALUES
                   (
                     P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                     REG.COD_FCRUBRICA, V_NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                     V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                     'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                     V_DAT_PAGTO
                   );

                   COMMIT;
                ELSE
                   
                   IF (V_CONTROLE = 1) THEN

                       
                       V_NUM_SEQ := V_NUM_SEQ + 1;
                       INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                       (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                        COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                        NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                        NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                        DAT_PAGTO
                       ) VALUES
                       (
                         P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                         NULL, NULL, NULL, NULL, NULL,
                          V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                         'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                         V_DAT_PAGTO
                       );
                       COMMIT;

                       
                       V_NUM_SEQ := 1009;
                       INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                       (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                        COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                        NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                        NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                        DAT_PAGTO
                       ) VALUES
                       (
                         P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                         NULL, 'TOTAIS DE VENCIMENTOS', V_CREDITO, V_DEBITO, NULL,
                         V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                         'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                         V_DAT_PAGTO
                       );

                       
                         V_NUM_SEQ := V_NUM_SEQ + 1;
                         V_TOTAL_VENCIMENTO := V_CREDITO - V_DEBITO;
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           NULL, NULL, V_TOTAL_VENCIMENTO, NULL, NULL,
                           V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                           V_DAT_PAGTO
                         );
                         COMMIT;

                       
                       V_NUM_SEQ := V_NUM_SEQ + 1;
                       INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                       (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                        COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                        NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                        NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                        DAT_PAGTO
                       ) VALUES
                       (
                         P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                         NULL, NULL, NULL, NULL, NULL,
                         V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                         'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                         V_DAT_PAGTO
                       );
                       COMMIT;

                       
                       V_NUM_SEQ := V_NUM_SEQ + 1;
                       INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                       (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                        COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                        NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                        NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                        DAT_PAGTO
                       ) VALUES
                       (
                         P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                         NULL, NULL, NULL, NULL, NULL,
                         V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                         'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                         V_DAT_PAGTO
                       );
                       COMMIT;

                       V_CONTROLE := 2;
                       V_CREDITO := 0;
                       V_DEBITO := 0;
                   END IF;

                   V_CREDITO := V_CREDITO + REG.CREDITO;
                   V_DEBITO := V_DEBITO + REG.DEBITO;
                   V_NUM_SEQ := V_NUM_SEQ + 1;

                   INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
                   (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                    COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                    NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                    NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                    DAT_PAGTO
                   ) VALUES
                   (
                     P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                     REG.COD_FCRUBRICA, V_NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                     V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                     'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
                     V_DAT_PAGTO
                   );
                   COMMIT;
                END IF;
            END LOOP;

            
            V_NUM_SEQ := V_NUM_SEQ + 1;
            INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
            (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
             COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
             NUM_SEQ, DAT_ING, DAT_ULT_ATU,
             NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
             DAT_PAGTO
            ) VALUES
            (
              P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
              NULL, NULL, NULL, NULL, NULL,
              V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
              'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
              V_DAT_PAGTO
            );
            COMMIT;

            
            V_NUM_SEQ := 2009;
            INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
            (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
             COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
             NUM_SEQ, DAT_ING, DAT_ULT_ATU,
             NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
             DAT_PAGTO
            ) VALUES
            (
              P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
              NULL, 'TOTAIS DE DESCONTOS', V_CREDITO, V_DEBITO, NULL,
              V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
              'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
              V_DAT_PAGTO
            );

            V_TOTAL_DESCONTO := V_DEBITO - V_CREDITO;

           
            V_NUM_SEQ := V_NUM_SEQ + 1;
            INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
            (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
             COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
             NUM_SEQ, DAT_ING, DAT_ULT_ATU,
             NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
             DAT_PAGTO
            ) VALUES
            (
              P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
              NULL, NULL, NULL, NULL, NULL,
              V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
              'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
              V_DAT_PAGTO
            );
            COMMIT;

            
            V_NUM_SEQ := V_NUM_SEQ + 1;
            INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
            (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
             COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
             NUM_SEQ, DAT_ING, DAT_ULT_ATU,
             NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
             DAT_PAGTO
            ) VALUES
            (
              P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
              NULL, 'TOTAL LIQUIDO', V_TOTAL_VENCIMENTO - V_TOTAL_DESCONTO, NULL, NULL,
              V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
              'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_A',
              V_DAT_PAGTO
            );
            COMMIT;

          
          
          

          
          FOR R_C IN (SELECT ROWID, CB.*
                        FROM TB_CONCESSAO_BENEFICIO CB
                       WHERE CB.COD_INS = P_COD_INS
                          AND CB.COD_TIPO_BENEFICIO != 'M'
                          AND EXISTS
                           (
                               SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                                WHERE AX.COD_INS = CB.COD_INS
                                  AND AX.TIP_PROCESSO = P_TIP_PROCESSO
                                  AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                                  AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                                  AND AX.COD_BENEFICIO = CB.COD_BENEFICIO
                                  AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                  AND AX.DAT_PGTO = V_DAT_PAGTO
                           )
                          AND (CB.COD_ORG_LEGADOR IS NULL OR CB.COD_UO_LEGADOR IS NULL)
                      )
          LOOP
             UPDATE TB_CONCESSAO_BENEFICIO CB
               SET CB.COD_ORG_LEGADOR = (
                                         SELECT LPAD(ORG_LEGADOR,3,'0') FROM
                                         (
                                         SELECT TE.ORG_LEGADOR
                                           FROM USER_IPESP.TB_ENTIDADE_FOLHA TE WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                           ORDER BY TE.ORG_LEGADOR
                                         )WHERE ROWNUM = 1
                                        ),
                   CB.COD_UO_LEGADOR = (SELECT DISTINCT LPAD(TE.UO_LEGADOR,3,'0')
                                          FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                                         WHERE TE.COD_ENTIDADE_FGV = CB.COD_ENTIDADE
                                           AND TE.ORG_LEGADOR =
                                           (
                                               SELECT ORG_LEGADOR FROM
                                               (
                                                   SELECT TE.ORG_LEGADOR
                                                     FROM TB_ENTIDADE_FOLHA TE
                                                     WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                                     ORDER BY TE.ORG_LEGADOR
                                               )WHERE ROWNUM = 1
                                           )
                                           AND ROWNUM = 1
                                       )
            WHERE ROWID = R_C.ROWID;
            COMMIT;
          END LOOP;
          

          DELETE USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW A
                WHERE A.COD_INS = P_COD_INS
                AND   A.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                AND   A.TIP_PROCESSO = P_TIP_PROCESSO
                AND   A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   A.NUM_GRP = LPAD( P_GRP_PGTO, 2, '0')
                AND   A.COD_TIPO_BENEFICIO <> 'M'  
                AND   A.DAT_PAGTO = V_DAT_PAGTO;
          COMMIT;


          <<L_ENT>>
          FOR V_ENT IN C_ENT
          LOOP

              BEGIN

                
                SELECT     SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_DEB,
                           SUM( DECODE( FF.FLG_NATUREZA, 'C', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_CRED
                INTO       VTOTDEB, VTOTCRED
                FROM TB_DET_CALCULADO FF
                WHERE FF.COD_INS = P_COD_INS
                AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 1 
                                           )
                AND   EXISTS
                ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                   WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                   AND   TC.COD_INS            = FF.COD_INS
                   AND   TC.COD_TIPO_BENEFICIO != 'M'
                   AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                   AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                 )
                AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   VTOTCRED := 0;
                   VTOTDEB  := 0;
              END;


              BEGIN
                
                SELECT     NVL(SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ),0) TOT_DEB,
                           NVL(SUM( DECODE( FF.FLG_NATUREZA, 'C', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ),0) TOT_CRED
                INTO         VTOTDESCONTOSDIVDEB, VTOTDESCONTOSDIVCRED

                FROM TB_DET_CALCULADO FF
                WHERE FF.COD_INS = P_COD_INS
                AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 2 
                                           )
                AND   EXISTS
                ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                   WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                   AND   TC.COD_INS            = FF.COD_INS
                   AND   TC.COD_TIPO_BENEFICIO != 'M'
                   AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                   AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                 )
                AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

              EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   VTOTDESCONTOSDIVDEB := 0;
                   VTOTDESCONTOSDIVCRED  := 0;
              END;


              BEGIN
                  
                  
                  SELECT NVL(  SUM( FF.VAL_LIQUIDO ), 0 ) F_TOT_CRED
                  INTO   VTOTGER
                  FROM TB_FOLHA FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.VAL_LIQUIDO >= 0
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );


              EXCEPTION
              WHEN OTHERS THEN
                   VTOTGER := 0;
              END;



              BEGIN
                  
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0))
                  INTO       VIR_DEBITO
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 3 
                                           )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

              EXCEPTION
               WHEN OTHERS THEN
                    VIR_DEBITO := 0;
              END;
              
              BEGIN
                  
                  

                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0))
                  INTO       VIR_CREDITO
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 4 
                                           )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

              EXCEPTION
               WHEN OTHERS THEN
                    VIR_CREDITO := 0;
              END;


              
              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VIAMPS
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 5 
                                           )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
              EXCEPTION
               WHEN OTHERS THEN
                  VIAMPS := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VPADESC
                  FROM  TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (SELECT DISTINCT COD_RUBRICA FROM USER_IPESP.TB_RUBRICAS R WHERE R.TIP_EVENTO_ESPECIAL = 'P')
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

              EXCEPTION
               WHEN OTHERS THEN
                  VPADESC := 0;
              END;


              BEGIN

                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VPAVENC
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 6 
                                           )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
               EXCEPTION
               WHEN OTHERS THEN
                   VPAVENC := 0;
               END;


              BEGIN

                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VTOTSEFAZ
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                 SELECT RU.COD_RUBRICA
                                                   FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                  WHERE RU.COD_INS = P_COD_INS
                                                    AND RU.COD_TIP_INSTITUICAO = 3 
                                                    AND RU.COD_TIP_RELATORIO = 1  
                                                    AND RU.COD_AGRUPACAO_RUBRICA = 7 
                                           )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
               EXCEPTION
               WHEN OTHERS THEN
                   VTOTSEFAZ := 0;
               END;

              BEGIN

                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VCONSIG
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  
                  AND   FF.COD_FCRUBRICA IN 
                  (
                      SELECT RU.COD_RUBRICA
                         FROM USER_IPESP.TB_REL_RUBRICAS RU
                        WHERE RU.COD_INS = FF.COD_INS
                          AND RU.COD_TIP_INSTITUICAO = 3 
                          AND RU.COD_TIP_RELATORIO = 1  
                          AND RU.COD_AGRUPACAO_RUBRICA = 8  
                  )                  
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
              EXCEPTION
              WHEN OTHERS THEN
                  VCONSIG := 0;
              END;

              BEGIN

                
                SELECT COUNT(*)
                INTO   VTOTIDECLI
                FROM
                (
                    SELECT DISTINCT FF.COD_IDE_CLI, FF.COD_BENEFICIO
                      FROM TB_FOLHA FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.VAL_LIQUIDO   >= 0
                      AND   EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO != 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                       )
                      AND EXISTS
                       (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                       )
                );
               EXCEPTION
              WHEN OTHERS THEN
                  VTOTIDECLI := 0;
              END;


              BEGIN

                  
                  SELECT COUNT(*)
                  INTO   VTOTSERV
                  FROM (
                      SELECT DISTINCT FF.COD_BENEFICIO
                      FROM TB_FOLHA FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.VAL_LIQUIDO  >= 0
                      AND   EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO != 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                       )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      )
                   );

               EXCEPTION
               WHEN OTHERS THEN
                    VTOTSERV := 0;
               END;


               
               















































               BEGIN

                SELECT
                  SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) )-
                  SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) )
                  INTO  V18607
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA < 2400000
                  AND   EXISTS
                  (
                        SELECT 1 FROM USER_IPESP.TB_REL_RUBRICAS RU
                         WHERE RU.COD_INS = P_COD_INS
                          AND RU.COD_TIP_INSTITUICAO = 3 
                          AND RU.COD_TIP_RELATORIO = 1  
                          AND RU.COD_AGRUPACAO_RUBRICA = 9 
                          AND RU.COD_RUBRICA = FF.COD_FCRUBRICA
                  )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

               EXCEPTION
               WHEN OTHERS THEN
                    V18607     := 0;
               END;
               
               
               BEGIN

                SELECT
                  SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                  SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) )
                  INTO V18607_DEB
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA >= 2400000
                  AND   EXISTS
                  (
                        SELECT 1 FROM USER_IPESP.TB_REL_RUBRICAS RU
                         WHERE RU.COD_INS = P_COD_INS
                          AND RU.COD_TIP_INSTITUICAO = 3 
                          AND RU.COD_TIP_RELATORIO = 1  
                          AND RU.COD_AGRUPACAO_RUBRICA = 9 
                          AND RU.COD_RUBRICA = FF.COD_FCRUBRICA
                  )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );

               EXCEPTION
               WHEN OTHERS THEN
                    V18607_DEB := 0;
               END;
          


               BEGIN

                 
                SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VOUTRO_CRE_DEB
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   EXISTS
                  (
                        SELECT 1 FROM USER_IPESP.TB_REL_RUBRICAS RU
                         WHERE RU.COD_INS = P_COD_INS
                          AND RU.COD_TIP_INSTITUICAO = 3 
                          AND RU.COD_TIP_RELATORIO = 1  
                          AND RU.COD_AGRUPACAO_RUBRICA = 10 
                          AND RU.COD_RUBRICA = FF.COD_FCRUBRICA
                  )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
               EXCEPTION
               WHEN OTHERS THEN
                    VOUTRO_CRE_DEB := 0;
               END;


               BEGIN

                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO   VOUTROSDIVERSOS
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   EXISTS
                  (
                        SELECT 1 FROM USER_IPESP.TB_REL_RUBRICAS RU
                         WHERE RU.COD_INS = P_COD_INS
                          AND RU.COD_TIP_INSTITUICAO = 3 
                          AND RU.COD_TIP_RELATORIO = 1  
                          AND RU.COD_AGRUPACAO_RUBRICA = 14 
                          AND RU.COD_RUBRICA = FF.COD_FCRUBRICA
                  )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 );
              EXCEPTION
              WHEN OTHERS THEN
                  VOUTROSDIVERSOS := 0;
              END;



              

              INSERT INTO USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW
              VALUES (
                         TO_DATE( P_PERIODO, 'dd/mm/yyyy' ),
                         LPAD(P_GRP_PGTO,2,'0'),
                         V_ENT.COD_ENTIDADE,
                         V_ENT.ORG_LEGADOR,
                         V_ENT.UO_LEGADOR,
                         V_ENT.PODER,
                         V_ENT.NOM_ENTIDADE,
                         NVL( VTOTSERV, 0 ),
                         NVL( VTOTIDECLI, 0 ),
                         NVL( VTOTDEB - VTOTCRED, 0),
                         NVL( VTOTGER, 0 ),
                         NVL( VIR_CREDITO, 0 ),
                         NVL( VIR_DEBITO, 0 ),
                         NVL( VIAMPS, 0 ),
                         NVL( VPADESC, 0 ),
                         NVL( VPAVENC, 0 ),
                         NVL( VTOTSEFAZ, 0 ),
                         NVL( VCONSIG, 0 ),
                         0,
                         NVL(V18607, 0),
                         NVL(V18607_DEB, 0),
                         NVL(VOUTRO_CRE_DEB,0),
                         P_COD_INS,
                         P_TIP_PROCESSO,
                         P_SEQ_PAGAMENTO,
                         NULL,
                         V_DAT_PAGTO,
                         V_ENT.COD_PODER_RELATORIO,
                         

















                         V_ENT.UG_LEGADOR,
                         V_ENT.GESTAO_LEGADOR,
                         V_ENT.CLASSIF_LEGADOR,
                         VTOTDESCONTOSDIVDEB - VTOTDESCONTOSDIVCRED,
                         NVL(VOUTROSDIVERSOS,0),
                         0
                        );

                COMMIT;
            END LOOP L_ENT;

          
          USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_CONSIG_DET(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                     P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);

          
          USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_PA(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                     P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);

          
          
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_APO_CIV ('Folha_Entidade_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_SEQ_PAGAMENTO,  V_DAT_PAGTO, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_13_SAL ('Folha_Entidade_13_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_VALOR_DEVOLVIDO_BANCO ('Folha_Entidade_ValorDevolvido_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_SEQ_PAGAMENTO, V_DAT_PAGTO, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_RUBRICAS ('Folha_Rubricas_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_SINTETICO ('Folha_SinteticoConsig_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_CONCEITO ('Folha_SinteticoConsig_Conceito_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
          
          
          
          FOR REL IN 
            (
              SELECT DISTINCT RT.COD_CONCEITO, UPPER(TRIM(RT.NOM_RUBRICA)) NOM_RUBRICA 
                FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
               WHERE RT.COD_INS = P_COD_INS
                 AND RT.PER_PROCESSO = TO_DATE(P_PERIODO,'dd/mm/yyyy')
                 AND RT.TIP_PROCESSO = P_TIP_PROCESSO
                 AND RT.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND RT.COD_GRUPO_PAGTO = LPAD(P_GRP_PGTO,2,'0')
                 AND RT.DAT_PAGTO = V_DAT_PAGTO
                 AND RT.FLG_CONSIGNATARIA = 'N'
            )
          LOOP
                USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ANALITICO_RUBRICA ('Folha_Analitico_'||TO_CHAR(REL.COD_CONCEITO)||'_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD')||'.xls', P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO, REL.COD_CONCEITO, 'N'); 
          END LOOP;

       EXCEPTION
         WHEN ERROR_PARAM THEN
              VS_ERRO := 'OS PARAMETROS P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, P_PERIODO, P_GRP_PAGTO S?O OBRIGATORIOS';
              P_ERRO := VS_ERRO;
              RETURN;
         WHEN ERROR_DATA_PGTO THEN
              VS_ERRO := 'DATA DE PAGAMENTO ENCERRADA NO CRONOGRAMA';
              P_ERRO := VS_ERRO;
              RETURN;
         WHEN GERAL THEN
              P_ERRO := VS_ERRO;
              RETURN;
         WHEN OTHERS THEN
              VS_ERRO := SQLCODE ||' - '||SQLERRM;
              P_ERRO := VS_ERRO;
       END;
   END SP_FECHAMENTO_GERAL_RUBRICA_AC;


   PROCEDURE SP_FECHAMENTO_GERAL_RUBRICA_AM
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DATA_PAGTO VARCHAR2,
       P_ERRO OUT VARCHAR2
    ) IS

    
    VS_ERRO VARCHAR2 (1000);
    ERROR_PARAM EXCEPTION;
    ERROR_DATA_PGTO EXCEPTION;
    V_ACAO NUMBER;

    

    VS_BANCO VARCHAR2(10);
    VS_AGENCIA VARCHAR2(10);
    VS_CONTA VARCHAR2(10);
    NOM_RUBRICA VARCHAR2(150);
    PERC_OPERACIONAL NUMBER;
    VS_CNPJ VARCHAR2(20);
    V_NUM_GRUPO_MIGRAR VARCHAR2(2);

    V_CREDITO NUMBER;
    V_DEBITO NUMBER;
    V_TOTAL_LIQUIDO NUMBER;
    V_TOTAL_VENCIMENTO NUMBER;
    V_TOTAL_DESCONTO NUMBER;
    V_NUM_SEQ NUMBER;
    V_COD_ENTIDADE NUMBER;
    V_CONTROLE NUMBER;
    V_DAT_PAGTO DATE;
    V_NOM_GRUPO VARCHAR2(100);

    
    CURSOR V_CURSOR_CIMA IS
      SELECT T1.COD_FCRUBRICA,
             R1.NOM_RUBRICA,
             SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
             SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
             COUNT(*) AS QTDE
        FROM USER_IPESP.TB_DET_CALCULADO T1, USER_IPESP.TB_RUBRICAS  R1
       WHERE T1.COD_INS = P_COD_INS
         AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
         AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
         AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
         AND R1.COD_INS = T1.COD_INS
         AND R1.COD_RUBRICA =T1.COD_FCRUBRICA
         AND R1.COD_ENTIDADE = V_COD_ENTIDADE
         AND R1.DAT_FIM_VIG IS NULL
         AND EXISTS
         (
             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
              WHERE AX.COD_INS = T1.COD_INS
                AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                AND AX.PER_PROCESSO = T1.PER_PROCESSO
                AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                AND AX.DAT_PGTO = V_DAT_PAGTO
         )
         AND T1.COD_FCRUBRICA < 2400000
         AND NOT EXISTS
         (
            SELECT 1
              FROM USER_IPESP.TB_REL_RUBRICAS A 
             WHERE A.COD_INS = 1
               AND A.COD_TIP_INSTITUICAO = 4
               AND A.COD_TIP_RELATORIO = 1
               AND A.COD_AGRUPACAO_RUBRICA = 15
               AND A.COD_RUBRICA = T1.COD_FCRUBRICA
         )
         GROUP BY T1.COD_FCRUBRICA, R1.NOM_RUBRICA
        ORDER BY T1.COD_FCRUBRICA;               


     CURSOR V_CURSOR_BAIXO IS
        SELECT * FROM 
        (
              SELECT T1.COD_FCRUBRICA,
                     R1.NOM_RUBRICA,
                     SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
                     SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
                     COUNT(*) AS QTDE
                FROM USER_IPESP.TB_DET_CALCULADO T1, USER_IPESP.TB_RUBRICAS  R1
               WHERE T1.COD_INS = P_COD_INS
                 AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
                 AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND R1.COD_INS = T1.COD_INS
                 AND R1.COD_RUBRICA =T1.COD_FCRUBRICA
                 AND R1.COD_ENTIDADE = V_COD_ENTIDADE
                 AND R1.DAT_FIM_VIG IS NULL
                 AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = T1.COD_INS
                        AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                        AND AX.PER_PROCESSO = T1.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 )
              AND T1.COD_FCRUBRICA >= 2400000
            GROUP BY COD_FCRUBRICA, NOM_RUBRICA
               
              UNION
               
              SELECT T1.COD_FCRUBRICA,
                     R1.NOM_RUBRICA,
                     SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
                     SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
                     COUNT(*) AS QTDE
                FROM USER_IPESP.TB_DET_CALCULADO T1, USER_IPESP.TB_RUBRICAS  R1
               WHERE T1.COD_INS = P_COD_INS
                 AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
                 AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND R1.COD_INS = T1.COD_INS
                 AND R1.COD_RUBRICA =T1.COD_FCRUBRICA
                 AND R1.COD_ENTIDADE = V_COD_ENTIDADE
                 AND R1.DAT_FIM_VIG IS NULL
                 AND EXISTS
                 (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = T1.COD_INS
                        AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                        AND AX.PER_PROCESSO = T1.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                 )
                 AND EXISTS
                 (
                    SELECT 1
                      FROM USER_IPESP.TB_REL_RUBRICAS A 
                     WHERE A.COD_INS = 1
                       AND A.COD_TIP_INSTITUICAO = 4
                       AND A.COD_TIP_RELATORIO = 1
                       AND A.COD_AGRUPACAO_RUBRICA = 15
                       AND A.COD_RUBRICA = T1.COD_FCRUBRICA
                 )
                 GROUP BY COD_FCRUBRICA, NOM_RUBRICA
        ) ORDER BY COD_FCRUBRICA;

    
    VIR_CREDITO     NUMBER(18,2) := 0; 
    VIR_DEBITO      NUMBER(18,2) := 0; 
    VIAMPS          NUMBER(18,2) := 0; 
    VPADESC         NUMBER(18,2) := 0; 
    VPAVENC         NUMBER(18,2) := 0; 
    VCONSIG         NUMBER(18,2) := 0; 
    VTOTIDECLI      NUMBER := 0;
    VTOTSERV        NUMBER := 0;
    VTOTCRED        NUMBER(18,2) := 0; 
    VTOTDEB         NUMBER(18,2) := 0; 
    VTOTGER         NUMBER(18,2) := 0;
    VTOTDEVPM       NUMBER(18,2) := 0;
    VTOTSEFAZ       NUMBER(18,2) := 0;
    V18607          NUMBER(18,2) := 0;
    V18607_DEB      NUMBER(18,2) := 0;
    VOUTRO_CRE_DEB  NUMBER(18,2) := 0;
    VTOTDIVERSOS    NUMBER(18,2) := 0;
    VOUTROSDIVERSOS NUMBER(18,2) := 0;

    
    CURSOR C_ENT IS
       SELECT TE.ORG_LEGADOR,
              TE.UO_LEGADOR, TE.NOM_ENTIDADE, NVL(TE.PODER, 'AUTARQUIAS') AS PODER,
              TE.COD_ENTIDADE_FGV AS COD_ENTIDADE, TE.UG_LEGADOR, 
              TE.GESTAO_LEGADOR, TE.CLASSIF_LEGADOR,
              TE.COD_PODER_RELATORIO
       FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
       WHERE TE.COD_ENTIDADE_FGV = 5
       ORDER BY 1,2;

  BEGIN
      BEGIN
          IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
             RAISE ERROR_PARAM;
          END IF;

          
          V_DAT_PAGTO := NULL;
          V_DAT_PAGTO := TO_DATE(P_DATA_PAGTO,'DD/MM/YYYY');
          
          BEGIN
            SELECT C.DAT_PAG_EFETIVA
              INTO V_DAT_PAGTO
              FROM USER_IPESP.TB_CRONOGRAMA_PAG C
             WHERE C.COD_INS = P_COD_INS
               AND C.COD_TIP_PROCESSO = P_TIP_PROCESSO
               AND C.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
               AND C.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
               AND C.NUM_GRP = P_GRP_PGTO;
               
               
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 RAISE ERROR_DATA_PGTO;
          END;

          DELETE FROM USER_IPESP.TB_REL_FOLHA_AUX AX
           WHERE AX.COD_INS = P_COD_INS
             AND AX.TIP_PROCESSO = P_TIP_PROCESSO
             AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
             AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
             AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
             AND AX.DAT_PGTO = V_DAT_PAGTO;
          COMMIT;

          INSERT INTO USER_IPESP.TB_REL_FOLHA_AUX AX
           SELECT P_COD_INS, P_TIP_PROCESSO,
                  TO_DATE(P_PERIODO,'dd/mm/yyyy'), P_SEQ_PAGAMENTO,
                  BE.COD_BENEFICIO, BE.COD_IDE_CLI_BEN, LPAD(P_GRP_PGTO,2,'0'),
                  SYSDATE, SYSDATE, USER, 'REL_FOLHA_AUX', V_DAT_PAGTO,
                  BE.FLG_STATUS, BE.DAT_INI_BEN, BE.DAT_FIM_BEN, BE.NUM_SEQ_BENEF,
                  CB.VAL_PERCENT_BEN
             FROM USER_IPESP.TB_BENEFICIARIO BE, USER_IPESP.TB_CONCESSAO_BENEFICIO CB
            WHERE BE.COD_INS = P_COD_INS
              AND BE.COD_PROC_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
              AND BE.FLG_STATUS IN ('A','X')
              AND (BE.DAT_FIM_BEN IS NULL OR BE.DAT_FIM_BEN >= TO_DATE(P_PERIODO,'dd/mm/yyyy'))
              AND CB.COD_INS = BE.COD_INS
              AND CB.COD_BENEFICIO = BE.COD_BENEFICIO
              AND CB.COD_TIPO_BENEFICIO != 'M'
              AND CB.COD_ENTIDADE = 5
              AND EXISTS
              (
                  SELECT 1
                    FROM USER_IPESP.TB_FOLHA  TF
                   WHERE TF.COD_INS = P_COD_INS
                     AND TF.TIP_PROCESSO = P_TIP_PROCESSO
                     AND TF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                     AND TF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                     AND NVL(TF.VAL_LIQUIDO,0)  >= 0
                     AND NVL(TF.TOT_CRED,0) != 0 
                     AND TF.COD_BENEFICIO = BE.COD_BENEFICIO
                     AND TF.COD_IDE_CLI = BE.COD_IDE_CLI_BEN
              );
              COMMIT;


          
          
          

          DELETE FROM USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS A
           WHERE A.COD_INS = P_COD_INS
             AND A.TIP_PROCESSO = P_TIP_PROCESSO
             AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
             AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
             AND A.COD_GRP_PAGAMENTO = LPAD(P_GRP_PGTO,2,'0')
             AND A.DAT_PAGTO = V_DAT_PAGTO;
          COMMIT;

          BEGIN
              SELECT DECODE(TIP_INSTITUICAO,2,5,4,5,1), UPPER(TRIM(GP.DES_GRP_PAG))
                INTO V_COD_ENTIDADE, V_NOM_GRUPO
                FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
               WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRP_PGTO);
          EXCEPTION
               WHEN OTHERS THEN
                    NULL;
          END;

          V_CREDITO := 0;
          V_DEBITO := 0;
          V_NUM_SEQ := 0;
          V_CONTROLE := 1;
          V_TOTAL_LIQUIDO := 0;
          V_TOTAL_VENCIMENTO := 0;
          V_TOTAL_DESCONTO := 0;

          FOR REG IN V_CURSOR_CIMA
          LOOP
             V_CREDITO := V_CREDITO + REG.CREDITO;
             V_DEBITO := V_DEBITO + REG.DEBITO;

             V_NUM_SEQ := V_NUM_SEQ + 1;
             INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
             (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
              COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
              NUM_SEQ, DAT_ING, DAT_ULT_ATU,
              NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
              DAT_PAGTO
             ) VALUES
             (
               P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
               REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
               V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
               'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
               V_DAT_PAGTO
             );
             COMMIT;
          END LOOP;
             
           
           V_NUM_SEQ := V_NUM_SEQ + 1;
           INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
           (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
            COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
            NUM_SEQ, DAT_ING, DAT_ULT_ATU,
            NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
            DAT_PAGTO
           ) VALUES
           (
             P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
             NULL, NULL, NULL, NULL, NULL,
              V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
             'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
             V_DAT_PAGTO
           );
           COMMIT;

           
           V_NUM_SEQ := 299;
           INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
           (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
            COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
            NUM_SEQ, DAT_ING, DAT_ULT_ATU,
            NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
            DAT_PAGTO
           ) VALUES
           (
             P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
             NULL, 'TOTAIS DE VENCIMENTOS', V_CREDITO, V_DEBITO, NULL,
             V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
             'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
             V_DAT_PAGTO
           );

           
           V_NUM_SEQ := V_NUM_SEQ + 1;
           V_TOTAL_VENCIMENTO := V_CREDITO - V_DEBITO;
           INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
           (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
            COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
            NUM_SEQ, DAT_ING, DAT_ULT_ATU,
            NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
            DAT_PAGTO
           ) VALUES
           (
             P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
             NULL, NULL, V_TOTAL_VENCIMENTO, NULL, NULL,
             V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
             'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
             V_DAT_PAGTO
           );
           COMMIT;

           
           V_NUM_SEQ := V_NUM_SEQ + 1;
           INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
           (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
            COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
            NUM_SEQ, DAT_ING, DAT_ULT_ATU,
            NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
            DAT_PAGTO
           ) VALUES
           (
             P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
             NULL, NULL, NULL, NULL, NULL,
             V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
             'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
             V_DAT_PAGTO
           );
           COMMIT;

           
           V_NUM_SEQ := V_NUM_SEQ + 1;
           INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
           (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
            COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
            NUM_SEQ, DAT_ING, DAT_ULT_ATU,
            NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
            DAT_PAGTO
           ) VALUES
           (
             P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
             NULL, NULL, NULL, NULL, NULL,
             V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
             'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
             V_DAT_PAGTO
           );
           COMMIT;

           V_CONTROLE := 2;
           V_CREDITO := 0;
           V_DEBITO := 0;

           FOR REG IN V_CURSOR_BAIXO
           LOOP
               V_CREDITO := V_CREDITO + REG.CREDITO;
               V_DEBITO := V_DEBITO + REG.DEBITO;
               V_NUM_SEQ := V_NUM_SEQ + 1;

               INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
               (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                DAT_PAGTO
               ) VALUES
               (
                 P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                 REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                 V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
                 'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
                 V_DAT_PAGTO
               );
               COMMIT;
          END LOOP;

          
          V_NUM_SEQ := V_NUM_SEQ + 1;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, NULL, NULL, NULL, NULL,
            V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );
          COMMIT;

          
          V_NUM_SEQ := 599;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, 'TOTAIS DE DESCONTOS', V_CREDITO, V_DEBITO, NULL,
            V_NUM_SEQ,  TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );

          V_TOTAL_DESCONTO := V_DEBITO - V_CREDITO;


         
          V_NUM_SEQ := V_NUM_SEQ + 1;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, NULL, NULL, NULL, NULL,
            V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );
          COMMIT;

          
          V_NUM_SEQ := V_NUM_SEQ + 1;
          INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_RUBRICAS R
          (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
           COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
           NUM_SEQ, DAT_ING, DAT_ULT_ATU,
           NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
           DAT_PAGTO
          ) VALUES
          (
            P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
            NULL, 'TOTAL LIQUIDO', V_TOTAL_VENCIMENTO - V_TOTAL_DESCONTO, NULL, NULL,
            V_NUM_SEQ, TRUNC(SYSDATE), TRUNC(SYSDATE),
            'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_RUBRICAS_P',
            V_DAT_PAGTO
          );
          COMMIT;


          
          
          
          
          FOR R_C IN (SELECT ROWID, CB.*
                        FROM TB_CONCESSAO_BENEFICIO CB
                       WHERE CB.COD_INS = P_COD_INS
                          AND CB.COD_TIPO_BENEFICIO != 'M'
                          AND EXISTS
                           (
                               SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                                WHERE AX.COD_INS = CB.COD_INS
                                  AND AX.TIP_PROCESSO = P_TIP_PROCESSO
                                  AND AX.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                                  AND AX.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                                  AND AX.COD_BENEFICIO = CB.COD_BENEFICIO
                                  AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                  AND AX.DAT_PGTO = V_DAT_PAGTO
                           )
                          AND (CB.COD_ORG_LEGADOR IS NULL OR CB.COD_UO_LEGADOR IS NULL)
                      )
          LOOP
             UPDATE TB_CONCESSAO_BENEFICIO CB
               SET CB.COD_ORG_LEGADOR = (
                                         SELECT ORG_LEGADOR FROM
                                         (
                                         SELECT TE.ORG_LEGADOR
                                           FROM TB_ENTIDADE_FOLHA TE WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                           ORDER BY TE.ORG_LEGADOR
                                         )WHERE ROWNUM = 1
                                        ),
                   CB.COD_UO_LEGADOR = (SELECT DISTINCT TE.UO_LEGADOR
                                          FROM USER_IPESP.TB_ENTIDADE_FOLHA TE
                                         WHERE TE.COD_ENTIDADE_FGV = CB.COD_ENTIDADE
                                           AND TE.ORG_LEGADOR =
                                           (
                                               SELECT ORG_LEGADOR FROM
                                               (
                                                   SELECT TE.ORG_LEGADOR
                                                     FROM TB_ENTIDADE_FOLHA TE
                                                     WHERE TE.COD_ENTIDADE_FGV = R_C.COD_ENTIDADE
                                                     ORDER BY TE.ORG_LEGADOR
                                               )WHERE ROWNUM = 1
                                           )
                                           AND ROWNUM = 1
                                       )
            WHERE ROWID = R_C.ROWID;
            COMMIT;
          END LOOP;

          V18607_DEB := 0;
          V18607     := 0;

          DELETE USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW A
          WHERE A.COD_INS = P_COD_INS
          AND   A.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
          AND   A.TIP_PROCESSO = P_TIP_PROCESSO
          AND   A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
          AND   A.NUM_GRP = LPAD(P_GRP_PGTO,2,'0')
          AND   A.DAT_PAGTO = V_DAT_PAGTO;
          COMMIT;


          <<L_ENT>>
          FOR V_ENT IN C_ENT
          LOOP

              BEGIN

                
                SELECT     SUM( DECODE( FF.FLG_NATUREZA, 'D', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_DEB,
                           SUM( DECODE( FF.FLG_NATUREZA, 'C', NVL( FF.VAL_RUBRICA, 0 ), 0 ) ) TOT_CRED
                INTO       VTOTDEB, VTOTCRED
                FROM TB_DET_CALCULADO FF
                WHERE FF.COD_INS = P_COD_INS
                AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 1 
                                             )
                AND   EXISTS
                ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                   WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                   AND   TC.COD_INS            = FF.COD_INS
                   AND   TC.COD_TIPO_BENEFICIO != 'M'
                   AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                   AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                )
                AND EXISTS
                (
                     SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                      WHERE AX.COD_INS = FF.COD_INS
                        AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                        AND AX.PER_PROCESSO = FF.PER_PROCESSO
                        AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                        AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                        AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                        AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                        AND AX.DAT_PGTO = V_DAT_PAGTO
                );

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                     VTOTCRED := 0;
                     VTOTDEB  := 0;
              END;

              BEGIN
                  
                  
                  SELECT NVL(  SUM( FF.VAL_LIQUIDO ), 0 ) F_TOT_CRED
                  INTO   VTOTGER
                  FROM TB_FOLHA FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.VAL_LIQUIDO >= 0
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );


              EXCEPTION
              WHEN OTHERS THEN
                   VTOTGER := 0;
              END;

              BEGIN
                  
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0))
                  INTO       VIR_DEBITO
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 3 
                                             )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

              EXCEPTION
               WHEN OTHERS THEN
                    VIR_DEBITO := 0;
              END;

              
              BEGIN
                  
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0))
                  INTO       VIR_CREDITO
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 4 
                                             )
                  AND   EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

              EXCEPTION
               WHEN OTHERS THEN
                    VIR_CREDITO := 0;
              END;


              
              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VIAMPS
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 11 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
              WHEN OTHERS THEN
                  VIAMPS := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VPADESC
                  FROM  TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (SELECT DISTINCT COD_RUBRICA FROM USER_IPESP.TB_RUBRICAS R WHERE R.TIP_EVENTO_ESPECIAL = 'P')
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

              EXCEPTION
                WHEN OTHERS THEN
                    VPADESC := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VPAVENC
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 12 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
                  WHEN OTHERS THEN
                       VPAVENC := 0;
              END;


              
              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO  VTOTDEVPM    
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 15 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
              WHEN OTHERS THEN
                  VTOTDEVPM := 0;
              END;
              
              
              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VTOTSEFAZ
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 13 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                   )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
               WHEN OTHERS THEN
                   VTOTSEFAZ := 0;
              END;


              BEGIN
                  
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VTOTDIVERSOS
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 2 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
                  WHEN OTHERS THEN
                       VTOTDIVERSOS := 0;
              END;


              BEGIN
                 
                  SELECT SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VCONSIG
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND  FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 8 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
              EXCEPTION
                   WHEN OTHERS THEN
                        VCONSIG := 0;
              END;

              
              BEGIN
                SELECT COUNT(*)
                INTO   VTOTIDECLI
                FROM (
                    SELECT DISTINCT FF.COD_IDE_CLI, FF.COD_BENEFICIO
                    FROM TB_FOLHA FF
                    WHERE FF.COD_INS = P_COD_INS
                    AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                    AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                    AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                    AND   FF.VAL_LIQUIDO   >= 0
                    AND EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO != 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      )
                   );
               EXCEPTION
              WHEN OTHERS THEN
                  VTOTIDECLI := 0;
              END;

              BEGIN
                  
                  SELECT COUNT(*)
                  INTO   VTOTSERV
                  FROM
                  (
                      SELECT DISTINCT FF.COD_BENEFICIO
                      FROM TB_FOLHA FF
                      WHERE FF.COD_INS = P_COD_INS
                      AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                      AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                      AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                      AND   FF.VAL_LIQUIDO  >= 0
                      AND EXISTS
                      ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                         WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                         AND   TC.COD_INS            = FF.COD_INS
                         AND   TC.COD_TIPO_BENEFICIO != 'M'
                         AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                         AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                      )
                      AND EXISTS
                      (
                           SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                            WHERE AX.COD_INS = FF.COD_INS
                              AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                              AND AX.PER_PROCESSO = FF.PER_PROCESSO
                              AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                              AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                              AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                              AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                              AND AX.DAT_PGTO = V_DAT_PAGTO
                      )
                   );

               EXCEPTION
               WHEN OTHERS THEN
                    VTOTSERV := 0;
               END;

             
               
               
               BEGIN
                SELECT
                  SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                  SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) )
                  INTO  V18607
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA < 2400000
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 9 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

               EXCEPTION
               WHEN OTHERS THEN
                    V18607     := 0;
               END;

               
               
               BEGIN
                SELECT
                  SUM( DECODE( FF.FLG_NATUREZA,'D',NVL( FF.VAL_RUBRICA,0),0 ) ) -
                  SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),0 ) )
                  INTO V18607_DEB
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA >= 2400000
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 9 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );

               EXCEPTION
               WHEN OTHERS THEN
                    V18607_DEB := 0;
               END;

               
               
               BEGIN

                
                SELECT SUM( DECODE( FF.FLG_NATUREZA,'C',NVL( FF.VAL_RUBRICA,0),NVL(FF.VAL_RUBRICA,0 )*-1 ) )
                  INTO       VOUTRO_CRE_DEB
                  FROM TB_DET_CALCULADO FF
                  WHERE FF.COD_INS = P_COD_INS
                  AND   FF.TIP_PROCESSO = P_TIP_PROCESSO
                  AND   FF.PER_PROCESSO = TO_DATE( P_PERIODO, 'dd/mm/yyyy' )
                  AND   FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                  AND   FF.COD_FCRUBRICA IN (
                                                   SELECT RU.COD_RUBRICA
                                                     FROM USER_IPESP.TB_REL_RUBRICAS RU
                                                    WHERE RU.COD_INS = P_COD_INS
                                                      AND RU.COD_TIP_INSTITUICAO = 4 
                                                      AND RU.COD_TIP_RELATORIO = 1  
                                                      AND RU.COD_AGRUPACAO_RUBRICA = 10 
                                             )
                  AND EXISTS
                  ( SELECT 1 FROM  USER_IPESP.TB_CONCESSAO_BENEFICIO TC
                     WHERE TC.COD_BENEFICIO      = FF.COD_BENEFICIO
                     AND   TC.COD_INS            = FF.COD_INS
                     AND   TC.COD_TIPO_BENEFICIO != 'M'
                     AND   TC.COD_ORG_LEGADOR    = V_ENT.ORG_LEGADOR
                     AND   TC.COD_UO_LEGADOR     = V_ENT.UO_LEGADOR
                  )
                  AND EXISTS
                  (
                       SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                        WHERE AX.COD_INS = FF.COD_INS
                          AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                          AND AX.PER_PROCESSO = FF.PER_PROCESSO
                          AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                          AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                          AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                          AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                          AND AX.DAT_PGTO = V_DAT_PAGTO
                  );
               EXCEPTION
               WHEN OTHERS THEN
                    VOUTRO_CRE_DEB := 0;
               END;

               
               INSERT INTO USER_IPESP.TB_GERAL_ENTIDADE_FOLHA_NEW
               VALUES (
                         TO_DATE( P_PERIODO, 'dd/mm/yyyy' ),
                         LPAD(P_GRP_PGTO,2,'0'),
                         V_ENT.COD_ENTIDADE,
                         V_ENT.ORG_LEGADOR,
                         V_ENT.UO_LEGADOR,
                         V_ENT.PODER,
                         V_ENT.NOM_ENTIDADE,
                         NVL( VTOTSERV, 0 ),
                         NVL( VTOTIDECLI, 0 ),
                         NVL( VTOTDEB - VTOTCRED, 0),
                         NVL( VTOTGER, 0 ),
                         NVL( VIR_CREDITO, 0 ),
                         NVL( VIR_DEBITO, 0 ),
                         NVL( VIAMPS, 0 ),
                         NVL( VPADESC, 0 ),
                         NVL( VPAVENC, 0 ),
                         NVL( VTOTSEFAZ, 0 ),
                         NVL( VCONSIG, 0 ),
                         VTOTDIVERSOS,
                         NVL(V18607, 0),
                         NVL(V18607_DEB, 0),
                         NVL(VOUTRO_CRE_DEB,0),
                         P_COD_INS,
                         P_TIP_PROCESSO,
                         P_SEQ_PAGAMENTO,
                         NULL,
                         V_DAT_PAGTO,
                         V_ENT.COD_PODER_RELATORIO,
                         

















                         V_ENT.UG_LEGADOR,
                         V_ENT.GESTAO_LEGADOR,
                         V_ENT.CLASSIF_LEGADOR,
                         0, 
                         NVL(VOUTROSDIVERSOS,0),
                         NVL(VTOTDEVPM,0)
                      );

                      COMMIT;
          END LOOP L_ENT;

          

























































































































































































































































          
          USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_CONSIG_DET(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                     P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);

          
          USER_IPESP.PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_PA(P_COD_INS,P_PERIODO,P_TIP_PROCESSO,
                     P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), P_ERRO, V_DAT_PAGTO);


          
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_INAT_MIL ('Folha_Entidade_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO,  LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ENTIDADE_13_SAL_PEN_MIL ('Folha_Entidade_13_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_VALOR_DEVOLVIDO_BANCO ('Folha_Entidade_ValorDevolvido_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_SEQ_PAGAMENTO, V_DAT_PAGTO, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_RUBRICAS ('Folha_Rubricas_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO);
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_SINTETICO ('Folha_SinteticoConsig_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
          USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_CONSIG_CONCEITO ('Folha_SinteticoConsig_Conceito_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD'), TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, V_DAT_PAGTO, 97000, LPAD(P_GRP_PGTO,2,'0'));
          
          
          
          FOR REL IN 
            (
              SELECT DISTINCT RT.COD_CONCEITO, UPPER(TRIM(RT.NOM_RUBRICA)) NOM_RUBRICA 
                FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
               WHERE RT.COD_INS = P_COD_INS
                 AND RT.PER_PROCESSO = P_PERIODO
                 AND RT.TIP_PROCESSO = P_TIP_PROCESSO
                 AND RT.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND RT.COD_GRUPO_PAGTO = LPAD(P_GRP_PGTO,2,'0')
                 AND RT.DAT_PAGTO = V_DAT_PAGTO
                 AND RT.FLG_CONSIGNATARIA = 'N'
            )
          LOOP
                USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_ANALITICO_RUBRICA ('Folha_Analitico_'||TO_CHAR(REL.COD_CONCEITO)||'_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD')||'.xls', P_COD_INS, TO_DATE(P_PERIODO,'DD/MM/YYYY'), P_TIP_PROCESSO, P_SEQ_PAGAMENTO, LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO, REL.COD_CONCEITO, 'N'); 
          END LOOP;


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
 END SP_FECHAMENTO_GERAL_RUBRICA_AM;
 


   PROCEDURE SP_FECHAMENTO_RUBRICA_PODER
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_DAT_PAGTO DATE,
       P_ERRO OUT VARCHAR2
    ) IS

    
    V_DAT_PAGTO DATE;
    ERROR_DATA_PGTO EXCEPTION;
    V_NOM_GRUPO VARCHAR2(100);
    VS_ERRO VARCHAR2 (1000);
    V_COD_ENTIDADE NUMBER;
    ERROR_PARAM EXCEPTION;

    
    V_CREDITO_E NUMBER;
    V_DEBITO_E NUMBER;
    V_NUM_SEQ_E NUMBER;
    V_CONTROLE_E NUMBER;
    V_TOTAL_LIQUIDO_E NUMBER;
    V_TOTAL_VENCIMENTO_E NUMBER;
    V_TOTAL_DESCONTO_E NUMBER;

    
    V_CREDITO_O NUMBER;
    V_DEBITO_O NUMBER;
    V_NUM_SEQ_O NUMBER;
    V_CONTROLE_O NUMBER;
    V_TOTAL_LIQUIDO_O NUMBER;
    V_TOTAL_VENCIMENTO_O NUMBER;
    V_TOTAL_DESCONTO_O NUMBER;
    I NUMBER ;
    

      
      BEGIN
          IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
                 RAISE ERROR_PARAM;
          END IF;
          
          
          
          

          BEGIN

              V_DAT_PAGTO := P_DAT_PAGTO;
              
              DELETE FROM USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER A
               WHERE A.COD_INS = P_COD_INS
                 AND A.TIP_PROCESSO = P_TIP_PROCESSO
                 AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND A.COD_GRP_PAGAMENTO = LPAD(P_GRP_PGTO,2,'0')
                 AND A.DAT_PAGTO = V_DAT_PAGTO;
              COMMIT;

              SELECT UPPER(TRIM(GP.DES_GRP_PAG))
                INTO V_NOM_GRUPO
                FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
               WHERE GP.NUM_GRP_PAG = TO_NUMBER(P_GRP_PGTO);
              
              
             
              I := 1;

              WHILE I <= 6 
              LOOP
                  V_CREDITO_E := 0;
                  V_DEBITO_E := 0;
                  V_NUM_SEQ_E := 0;
                  V_CONTROLE_E := 1;
                  V_TOTAL_LIQUIDO_E := 0;
                  V_TOTAL_VENCIMENTO_E := 0;
                  V_TOTAL_DESCONTO_E := 0;
                  
                  FOR REG IN (
                      SELECT T1.COD_FCRUBRICA,
                             R1.NOM_RUBRICA,
                             SUM(DECODE(T1.FLG_NATUREZA,'C',T1.VAL_RUBRICA,0)) CREDITO,
                             SUM(DECODE(T1.FLG_NATUREZA,'D',T1.VAL_RUBRICA,0)) DEBITO,
                             E.COD_PODER_RELATORIO AS COD_PODER,
                             COUNT(*) AS QTDE
                        FROM USER_IPESP.TB_DET_CALCULADO T1, 
                             USER_IPESP.TB_CONCESSAO_BENEFICIO CB, 
                             USER_IPESP.TB_RUBRICAS R1,
                             USER_IPESP.TB_ENTIDADE_FOLHA E
                       WHERE T1.COD_INS = P_COD_INS
                        AND T1.TIP_PROCESSO  = P_TIP_PROCESSO
                         AND T1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                         AND T1.PER_PROCESSO  = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                         AND CB.COD_INS = T1.COD_INS
                         AND CB.COD_BENEFICIO = T1.COD_BENEFICIO
                         AND R1.COD_INS = T1.COD_INS
                         AND R1.COD_RUBRICA = T1.COD_FCRUBRICA
                         AND R1.COD_ENTIDADE = CB.COD_ENTIDADE
                         AND R1.DAT_FIM_VIG IS NULL
                         AND CB.COD_INS = P_COD_INS
                         
                         AND E.ORG_LEGADOR = CB.COD_ORG_LEGADOR
                         AND E.UO_LEGADOR = CB.COD_UO_LEGADOR
                         AND E.COD_PODER_RELATORIO = DECODE(I,6,2,1,1)
                         AND EXISTS
                         (
                             SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                              WHERE AX.COD_INS = T1.COD_INS
                                 AND AX.TIP_PROCESSO = T1.TIP_PROCESSO
                                 AND AX.PER_PROCESSO = T1.PER_PROCESSO
                                 AND AX.SEQ_PAGAMENTO = T1.SEQ_PAGAMENTO
                                 AND AX.COD_BENEFICIO = T1.COD_BENEFICIO
                                 AND AX.COD_IDE_CLI = T1.COD_IDE_CLI
                                 AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                                 AND AX.DAT_PGTO = V_DAT_PAGTO
                         )
                         AND EXISTS (SELECT 1 FROM USER_IPESP.TB_IMPRESAO_RUB  IR
                                    WHERE IR.COD_RUBRICA  = T1.COD_FCRUBRICA
                                      AND IR.COD_ENTIDADE = CB.COD_ENTIDADE
                                      AND (IR.FLG_IMPRIME  IN ('S'))
                                    )
                      GROUP BY T1.COD_FCRUBRICA, R1.NOM_RUBRICA, E.COD_PODER_RELATORIO
                      ORDER BY T1.COD_FCRUBRICA, E.COD_PODER_RELATORIO
                  
                  
                  )
                  LOOP
                      IF (REG.COD_FCRUBRICA < 2400000) THEN
                         V_CREDITO_E := V_CREDITO_E + REG.CREDITO;
                         V_DEBITO_E := V_DEBITO_E + REG.DEBITO;
                         V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                               
                         INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO, COD_PODER
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                           V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                           V_DAT_PAGTO, I
                         );

                         COMMIT;
                      ELSE
                         
                         IF (V_CONTROLE_E = 1) THEN

                             
                             V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                             INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                             (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                              COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                              NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                              NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                              DAT_PAGTO, COD_PODER
                             ) VALUES
                             (
                               P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                               NULL, NULL, NULL, NULL, NULL,
                                V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                               'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                               V_DAT_PAGTO, I
                             );
                             COMMIT;

                             
                             V_NUM_SEQ_E := 299;
                             INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                             (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                              COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                              NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                              NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                              DAT_PAGTO, COD_PODER
                             ) VALUES
                             (
                               P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                               NULL, 'TOTAIS DE VENCIMENTOS', V_CREDITO_E, V_DEBITO_E, NULL,
                               V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                               'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                               V_DAT_PAGTO, I
                             );

                             
                             V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                             V_TOTAL_VENCIMENTO_E := V_CREDITO_E - V_DEBITO_E;
                                   
                             INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                             (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                              COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                              NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                              NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                              DAT_PAGTO, COD_PODER
                             ) VALUES
                             (
                               P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                               NULL, NULL, V_TOTAL_VENCIMENTO_E, NULL, NULL,
                               V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                               'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                               V_DAT_PAGTO, I
                             );
                             COMMIT;

                             
                             V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                             INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                             (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                              COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                              NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                              NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                              DAT_PAGTO, COD_PODER
                             ) VALUES
                             (
                               P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                               NULL, NULL, NULL, NULL, NULL,
                               V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                               'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                               V_DAT_PAGTO, I
                             );
                             COMMIT;

                             
                             V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                             INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                             (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                              COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                              NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                              NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                              DAT_PAGTO, COD_PODER
                             ) VALUES
                             (
                               P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                               NULL, NULL, NULL, NULL, NULL,
                               V_NUM_SEQ_E,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                               'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                               V_DAT_PAGTO, I
                             );
                             COMMIT;

                             V_CONTROLE_E := 2;
                             V_CREDITO_E := 0;
                             V_DEBITO_E := 0;
                         END IF;

                         V_CREDITO_E := V_CREDITO_E + REG.CREDITO;
                         V_DEBITO_E := V_DEBITO_E + REG.DEBITO;
                         V_NUM_SEQ_E := V_NUM_SEQ_E + 1;

                         INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                         (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                          COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                          NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                          DAT_PAGTO, COD_PODER
                         ) VALUES
                         (
                           P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                           REG.COD_FCRUBRICA, REG.NOM_RUBRICA, REG.CREDITO, REG.DEBITO, REG.QTDE,
                           V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                           'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                           V_DAT_PAGTO, I
                         );
                         COMMIT;
                      END IF;
                  END LOOP;

                  
                  
                  V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                  INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                  (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                   COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                   NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                   NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                   DAT_PAGTO, COD_PODER
                  ) VALUES
                  (
                    P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                    NULL, NULL, NULL, NULL, NULL,
                    V_NUM_SEQ_E,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                    'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                    V_DAT_PAGTO, I
                  );
                  COMMIT;
                  
                  
                  
                  V_NUM_SEQ_E := 599;
                  INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                  (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                   COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                   NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                   NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                   DAT_PAGTO, COD_PODER
                  ) VALUES
                  (
                    P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                    NULL, 'TOTAIS DE DESCONTOS', V_CREDITO_E, V_DEBITO_E, NULL,
                    V_NUM_SEQ_E,  TRUNC(SYSDATE), TRUNC(SYSDATE),
                    'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                    V_DAT_PAGTO, I
                  );

                  V_TOTAL_DESCONTO_E := V_DEBITO_E - V_CREDITO_E;
                  
                  
                  V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                  INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                  (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                   COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                   NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                   NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                   DAT_PAGTO, COD_PODER
                  ) VALUES
                  (
                    P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                    NULL, NULL, NULL, NULL, NULL,
                    V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                    'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                    V_DAT_PAGTO, I
                  );
                  COMMIT;
                  
                  
                  V_NUM_SEQ_E := V_NUM_SEQ_E + 1;
                  INSERT INTO USER_IPESP.TB_REL_FOLHA_RUBRICAS_PODER R
                  (COD_INS, TIP_PROCESSO, SEQ_PAGAMENTO, PER_PROCESSO, COD_GRP_PAGAMENTO,
                   COD_FCRUBRICA, NOM_RUBRICA, VAL_CREDITO, VAL_DEBITO, NUM_QTDE,
                   NUM_SEQ, DAT_ING, DAT_ULT_ATU,
                   NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,
                   DAT_PAGTO, COD_PODER
                  ) VALUES
                  (
                    P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'dd/mm/yyyy'), LPAD(P_GRP_PGTO,2,'0'),
                    NULL, 'TOTAL LIQUIDO', V_TOTAL_VENCIMENTO_E - V_TOTAL_DESCONTO_E, NULL, NULL,
                    V_NUM_SEQ_E, TRUNC(SYSDATE), TRUNC(SYSDATE),
                    'LANTONIO','PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_RUBRICAS_PODER',
                    V_DAT_PAGTO, I
                  );
                  
                  I := I+5;
                  COMMIT;
              END LOOP;
              
              
              USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_RUBRICAS_PODERES ('Folha_Rubricas_Poderes_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD')||'_01', P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO, 1);
              
              USER_IPESP.PAC_RELATORIOS_FOLHA.SP_REL_RUBRICAS_PODERES ('Folha_Rubricas_Poderes_'||LPAD(P_GRP_PGTO,2,'0')||'_'||P_TIP_PROCESSO||'_'||LPAD(P_SEQ_PAGAMENTO,2,'0')||'_'||TO_CHAR(TO_DATE(P_PERIODO,'DD/MM/YYYY'),'YYYYMMDD')||'_'||TO_CHAR(V_DAT_PAGTO,'YYYYMMDD')||'_06', P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, TO_DATE(P_PERIODO,'DD/MM/YYYY'), LPAD(P_GRP_PGTO,2,'0'), V_DAT_PAGTO, 6);

              
         EXCEPTION
             WHEN ERROR_PARAM THEN
                  VS_ERRO := 'OS PARAMETROS P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, P_PERIODO, P_GRP_PAGTO E P_COD_PODER SAO OBRIGATORIOS';
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

         
   END SP_FECHAMENTO_RUBRICA_PODER;

  
  
  

  PROCEDURE SP_FECHAMENTO_CONSIG_DET 
  (
       PN_COD_INS NUMBER,  
       PS_PER_PROCESSO VARCHAR2, 
       PC_TIP_PROCESSO CHAR, 
       PN_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       VS_ERRO OUT VARCHAR2,
       PD_DAT_PAGTO DATE
  )
  AS
       VS_DADOS VARCHAR2(10000);
       VN_ERRO NUMBER;
       VN_TOTAL_VENC NUMBER;
       VN_TOTAL_DESC NUMBER;
       VS_CPF VARCHAR2(15);
       VS_NOME_BEN VARCHAR2(150);
       VS_NOME_LEGADOR VARCHAR2(150);
       VS_NOM_RUBRICA VARCHAR2(100);
       VN_CREDITO NUMBER := 0;
       VN_DEBITO NUMBER := 0;
       VS_COD_GRP_PAG VARCHAR2(2);
       VS_DAT_PGTO DATE;
       DATA_CRONOGRAMA EXCEPTION;
       ERROR_PARAM EXCEPTION;
       PERC_OPERACIONAL NUMBER;
       NOM_RUBRICA VARCHAR2(100);
       VN_ESPECIE NUMBER;
       V_TIPO_INSTITUICAO NUMBER;
       V_NUM_CARGA_APOS NUMBER;
       V_NUM_CARGA_CIV NUMBER;
       V_NOME_ENTIDADE VARCHAR2(120);
       VC_TIPO_BENEFICIO VARCHAR(10);
       VS_CNPJ VARCHAR2(20);
       VN_QTD_PROCESSADOS NUMBER;
       VN_VAL_PROCESSADOS NUMBER;
       VN_LIQUIDO NUMBER;

      CURSOR C_RUB_CONSIG_ESPECIFICA IS
        SELECT DC.COD_BENEFICIO, DC.COD_IDE_CLI, DC.COD_FCRUBRICA, DC.DAT_INI_REF,
           (CASE
              WHEN DC.FLG_NATUREZA = 'C' THEN DC.VAL_RUBRICA
              ELSE 0
           END) AS VAL_RUBRICA_CRED,

           (CASE
              WHEN DC.FLG_NATUREZA = 'D' THEN DC.VAL_RUBRICA
              ELSE 0
            END) AS VAL_RUBRICA_DEB,
            CB.COD_ENTIDADE,
            DC.NUM_CARGA,
            DC.NUM_SEQ_CONTROLE_CARGA,
            CB.COD_ORG_LEGADOR, CB.COD_UO_LEGADOR
          FROM USER_IPESP.TB_DET_CALCULADO DC, 
               USER_IPESP.TB_CONCESSAO_BENEFICIO CB
         WHERE DC.COD_INS = PN_COD_INS
           AND DC.TIP_PROCESSO = PC_TIP_PROCESSO
           AND DC.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
           AND DC.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
           AND DC.COD_INS = CB.COD_INS
           AND DC.COD_BENEFICIO = CB.COD_BENEFICIO
           AND EXISTS
           (
                 SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                  WHERE AX.COD_INS = DC.COD_INS
                    AND AX.TIP_PROCESSO = DC.TIP_PROCESSO
                    AND AX.PER_PROCESSO = DC.PER_PROCESSO
                    AND AX.SEQ_PAGAMENTO = DC.SEQ_PAGAMENTO
                    AND AX.COD_BENEFICIO = DC.COD_BENEFICIO
                    AND AX.COD_IDE_CLI = DC.COD_IDE_CLI
                    AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                    AND AX.DAT_PGTO = PD_DAT_PAGTO
           )
           AND DC.COD_FCRUBRICA IN (SELECT DISTINCT T.COD_RUBRICA
                                       FROM USER_IPESP.TB_REL_RUBRICAS T
                                      WHERE T.COD_INS = 1
                                        AND T.COD_TIP_INSTITUICAO = V_TIPO_INSTITUICAO
                                        AND T.COD_TIP_RELATORIO = 2 
                                   )
           ORDER BY DC.COD_FCRUBRICA, DC.COD_INS, DC.COD_BENEFICIO, DC.COD_IDE_CLI;

      
      CURSOR C_RUB_CONSIG IS
        SELECT DC.COD_BENEFICIO, DC.COD_IDE_CLI, 
               DC.COD_FCRUBRICA, DC.DAT_INI_REF,
           (CASE
              WHEN DC.FLG_NATUREZA = 'C' THEN DC.VAL_RUBRICA
              ELSE 0
           END) AS VAL_RUBRICA_CRED,

           (CASE
              WHEN DC.FLG_NATUREZA = 'D' THEN DC.VAL_RUBRICA
              ELSE 0
            END) AS VAL_RUBRICA_DEB,
            CB.COD_ENTIDADE,
            DC.NUM_CARGA,
            DC.NUM_SEQ_CONTROLE_CARGA,
            CB.COD_ORG_LEGADOR, 
            CB.COD_UO_LEGADOR
          FROM USER_IPESP.TB_DET_CALCULADO DC, 
               USER_IPESP.TB_CONCESSAO_BENEFICIO CB
         WHERE DC.COD_INS = PN_COD_INS
           AND DC.TIP_PROCESSO = PC_TIP_PROCESSO
           AND DC.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
           AND DC.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
           
           AND CB.COD_INS = DC.COD_INS
           AND CB.COD_BENEFICIO = DC.COD_BENEFICIO
           
            AND EXISTS
           (
                 SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                  WHERE AX.COD_INS = DC.COD_INS
                    AND AX.TIP_PROCESSO = DC.TIP_PROCESSO
                    AND AX.PER_PROCESSO = DC.PER_PROCESSO
                    AND AX.SEQ_PAGAMENTO = DC.SEQ_PAGAMENTO
                    AND AX.COD_BENEFICIO = DC.COD_BENEFICIO
                    AND AX.COD_IDE_CLI = DC.COD_IDE_CLI
                    AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                    AND AX.DAT_PGTO = PD_DAT_PAGTO
           )
           AND EXISTS
           (
                 SELECT 1 FROM USER_IPESP.TB_RUBRICAS R
                  WHERE R.COD_INS = DC.COD_INS
                    AND R.COD_RUBRICA = DC.COD_FCRUBRICA
                    AND R.TIP_COMPOSICAO = 'C'
                    AND R.COD_ENTIDADE = CB.COD_ENTIDADE
                    
           )
           ORDER BY DC.COD_FCRUBRICA, DC.COD_INS, DC.COD_BENEFICIO, DC.COD_IDE_CLI;


    BEGIN
        EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

        BEGIN

            IF (PN_COD_INS IS NULL OR PC_TIP_PROCESSO IS NULL OR PN_SEQ_PAGAMENTO IS NULL OR PS_PER_PROCESSO IS NULL OR P_GRP_PGTO IS NULL) THEN
                RAISE ERROR_PARAM;
            END IF;

            VS_DAT_PGTO := NULL;
            VS_DAT_PGTO := PD_DAT_PAGTO;

            BEGIN
                SELECT GP.TIP_INSTITUICAO
                  INTO V_TIPO_INSTITUICAO
                  FROM USER_IPESP.TB_GRUPO_PAGAMENTO GP
                 WHERE GP.COD_PROC_GRP_PAGO = LPAD(P_GRP_PGTO,2,'0');
            EXCEPTION
                  WHEN OTHERS THEN
                    V_TIPO_INSTITUICAO := 0;
            END;


            
            DELETE FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
             WHERE RT.COD_INS = PN_COD_INS
               AND RT.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO, 'DD/MM/YYYY')
               AND RT.TIP_PROCESSO = PC_TIP_PROCESSO
               AND RT.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
               AND RT.COD_GRUPO_PAGTO = LPAD(P_GRP_PGTO,2,'0')
               AND RT.DAT_PAGTO = VS_DAT_PGTO;
            COMMIT;

            FOR R_C IN C_RUB_CONSIG_ESPECIFICA
            LOOP
                BEGIN

                    IF R_C.COD_FCRUBRICA = 7000756 THEN
                      NULL;
                    END IF;

                    NOM_RUBRICA := NULL;
                    BEGIN
                        SELECT R.NOM_RUBRICA
                          INTO NOM_RUBRICA
                          FROM USER_IPESP.TB_RUBRICAS R
                         WHERE R.COD_INS = PN_COD_INS
                           AND R.COD_RUBRICA = R_C.COD_FCRUBRICA
                           AND R.COD_ENTIDADE = R_C.COD_ENTIDADE;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        BEGIN
                            SELECT R.NOM_RUBRICA
                              INTO NOM_RUBRICA
                              FROM USER_IPESP.TB_RUBRICAS R
                             WHERE R.COD_INS = PN_COD_INS
                               AND R.COD_RUBRICA = R_C.COD_FCRUBRICA
                               AND ROWNUM=1;
                        EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                            NOM_RUBRICA := 'NAO INFORMADO';
                        END;
                    END;

                    V_NOME_ENTIDADE := NULL;
                    BEGIN
                        SELECT TRIM(UPPER(F.NOM_ENTIDADE))
                          INTO V_NOME_ENTIDADE
                          FROM USER_IPESP.TB_ENTIDADE_FOLHA F
                         WHERE F.ORG_LEGADOR = R_C.COD_ORG_LEGADOR
                           AND F.UO_LEGADOR = R_C.COD_UO_LEGADOR
                           AND ROWNUM = 1;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                           V_NOME_ENTIDADE := 1;
                    END;

                    VS_CPF := NULL;
                    VS_NOME_BEN := NULL;
                    BEGIN
                        SELECT NUM_CPF, NOM_PESSOA_FISICA
                          INTO VS_CPF, VS_NOME_BEN
                          FROM TB_PESSOA_FISICA PF
                         WHERE PF.COD_INS = PN_COD_INS
                           AND PF.COD_IDE_CLI = R_C.COD_IDE_CLI
                           AND ROWNUM = 1;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            VS_ERRO := SQLERRM;
                            VN_ERRO := SQLCODE;
                            INSERT INTO TB_LOG_ERRO_EXSERV (COD_TB_LOG_ERRO_EXSERV, NOM_PROCEDURE, NOM_TABELA, REF_FOLHA, COD_INS, COD_IDE_CLI, NUM_REF_FUNC, COD_ERRO, DES_ERRO, DAT_ERRO, NUM_CPF, IND_TIPO, NUM_PADRAO, COD_IDE_CLI_BEN)
                            VALUES (SEQ_TB_LOG_ERRO_EXSERV.NEXTVAL, 'SP_GERA_REL_CONSIGNACOES', 'TB_PESSOA_FISICIA', SUBSTR(PS_PER_PROCESSO,4,7), PN_COD_INS, NULL, R_C.COD_BENEFICIO, VN_ERRO, VS_ERRO, TO_DATE(SYSDATE,'DD/MM/YYYY'), VS_CPF, 'C', NULL, R_C.COD_IDE_CLI);
                    END;

                    
                    VS_NOME_LEGADOR := NULL;
                    BEGIN
                        SELECT TRIM(UPPER(NOM_PESSOA_FISICA))
                          INTO VS_NOME_LEGADOR
                          FROM TB_CONCESSAO_BENEFICIO CB, TB_PESSOA_FISICA PF
                         WHERE CB.COD_INS = PN_COD_INS
                           AND CB.COD_BENEFICIO = R_C.COD_BENEFICIO
                           AND PF.COD_INS = CB.COD_INS
                           AND PF.COD_IDE_CLI = CB.COD_IDE_CLI_SERV;
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                            VS_ERRO := SQLERRM;
                            VN_ERRO := SQLCODE;
                            INSERT INTO TB_LOG_ERRO_EXSERV (COD_TB_LOG_ERRO_EXSERV, NOM_PROCEDURE, NOM_TABELA, REF_FOLHA, COD_INS, COD_IDE_CLI, NUM_REF_FUNC, COD_ERRO, DES_ERRO, DAT_ERRO, NUM_CPF, IND_TIPO, NUM_PADRAO, COD_IDE_CLI_BEN)
                            VALUES (SEQ_TB_LOG_ERRO_EXSERV.NEXTVAL, 'SP_GERA_REL_CONSIGNACOES', 'TB_PESSOA_FISICIA', SUBSTR(PS_PER_PROCESSO,4,7), PN_COD_INS, NULL, R_C.COD_BENEFICIO, VN_ERRO, VS_ERRO, TO_DATE(SYSDATE,'DD/MM/YYYY'), VS_CPF, 'C', NULL, R_C.COD_IDE_CLI);
                    END;

                    INSERT INTO USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL DT
                    (
                          COD_INS,
                          PER_PROCESSO,
                          SEQ_PAGAMENTO,
                          TIP_PROCESSO,
                          COD_GRUPO_PAGTO,
                          DAT_PAGTO,
                          COD_BENEFICIO,
                          COD_IDE_CLI,
                          NUM_CPF,
                          NOME,
                          COD_CONCEITO,
                          COD_RUBRICA,
                          VAL_CREDITO,
                          VAL_DEBITO,
                          DAT_INI_REF,
                          DAT_ING,
                          DAT_ULT_ATU,
                          NOM_USU_ULT_ATU,
                          NOM_PRO_ULT_ATU,
                          FLG_CONSIGNATARIA,
                          ESPECIE,
                          NOM_RUBRICA,
                          NOM_LEGADOR,
                          COD_ORGAO_LEGADOR,
                          COD_UO_LEGADOR,
                          NOM_ENTIDADE,
                          NUM_CARGA

                    )
                    VALUES
                    (
                          PN_COD_INS,
                          TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY'),
                          PN_SEQ_PAGAMENTO,
                          PC_TIP_PROCESSO,
                          LPAD(P_GRP_PGTO,2,'0'),
                          TO_DATE(VS_DAT_PGTO,'DD/MM/YYYY'),
                          R_C.COD_BENEFICIO,
                          R_C.COD_IDE_CLI,
                          VS_CPF,
                          VS_NOME_BEN,
                          SUBSTR(R_C.COD_FCRUBRICA,1,LENGTH(R_C.COD_FCRUBRICA)-2),
                          R_C.COD_FCRUBRICA,
                          R_C.VAL_RUBRICA_CRED,
                          R_C.VAL_RUBRICA_DEB,
                          R_C.DAT_INI_REF,
                          TRUNC(SYSDATE),
                          TRUNC(SYSDATE),
                          'LANTONIO',
                          'PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_CONSIG_DET',
                          'N',
                           0, 
                           NOM_RUBRICA,
                           VS_NOME_LEGADOR,
                           R_C.COD_ORG_LEGADOR,
                           R_C.COD_UO_LEGADOR,
                           V_NOME_ENTIDADE,
                           R_C.NUM_CARGA
                    );
                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                    VS_ERRO := SQLERRM;
                    VN_ERRO := SQLCODE;
                END;
            END LOOP;

            
            
            FOR R_C IN C_RUB_CONSIG
            LOOP
                BEGIN
                  
                        NOM_RUBRICA := NULL;
                        BEGIN
                            SELECT R.NOM_RUBRICA
                              INTO NOM_RUBRICA
                              FROM USER_IPESP.TB_RUBRICAS R
                             WHERE R.COD_INS = PN_COD_INS
                               AND R.COD_RUBRICA = R_C.COD_FCRUBRICA
                               AND R.COD_ENTIDADE = R_C.COD_ENTIDADE;
                        EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                            NOM_RUBRICA := 'NAO INFORMADO';
                        END;

                        VS_CPF := NULL;
                        VS_NOME_BEN := NULL;
                        BEGIN
                            SELECT NUM_CPF, NOM_PESSOA_FISICA
                              INTO VS_CPF, VS_NOME_BEN
                              FROM TB_PESSOA_FISICA PF
                             WHERE PF.COD_INS = PN_COD_INS
                               AND PF.COD_IDE_CLI = R_C.COD_IDE_CLI
                               AND ROWNUM = 1;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                                VS_ERRO := SQLERRM;
                                VN_ERRO := SQLCODE;
                                INSERT INTO TB_LOG_ERRO_EXSERV (COD_TB_LOG_ERRO_EXSERV, NOM_PROCEDURE, NOM_TABELA, REF_FOLHA, COD_INS, COD_IDE_CLI, NUM_REF_FUNC, COD_ERRO, DES_ERRO, DAT_ERRO, NUM_CPF, IND_TIPO, NUM_PADRAO, COD_IDE_CLI_BEN)
                                VALUES (SEQ_TB_LOG_ERRO_EXSERV.NEXTVAL, 'SP_GERA_REL_CONSIGNACOES', 'TB_PESSOA_FISICIA', SUBSTR(PS_PER_PROCESSO,4,7), PN_COD_INS, NULL, R_C.COD_BENEFICIO, VN_ERRO, VS_ERRO, TO_DATE(SYSDATE,'DD/MM/YYYY'), VS_CPF, 'C', NULL, R_C.COD_IDE_CLI);
                        END;

                        
                        VS_NOME_LEGADOR := NULL;
                        VC_TIPO_BENEFICIO := NULL;
                        BEGIN
                            SELECT TRIM(UPPER(NOM_PESSOA_FISICA)), CB.COD_TIPO_BENEFICIO
                              INTO VS_NOME_LEGADOR, VC_TIPO_BENEFICIO
                              FROM TB_CONCESSAO_BENEFICIO CB, TB_PESSOA_FISICA PF
                             WHERE CB.COD_INS = PN_COD_INS
                               AND CB.COD_BENEFICIO = R_C.COD_BENEFICIO
                               AND PF.COD_INS = CB.COD_INS
                               AND PF.COD_IDE_CLI = CB.COD_IDE_CLI_SERV;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                                VS_ERRO := SQLERRM;
                                VN_ERRO := SQLCODE;
                                INSERT INTO TB_LOG_ERRO_EXSERV (COD_TB_LOG_ERRO_EXSERV, NOM_PROCEDURE, NOM_TABELA, REF_FOLHA, COD_INS, COD_IDE_CLI, NUM_REF_FUNC, COD_ERRO, DES_ERRO, DAT_ERRO, NUM_CPF, IND_TIPO, NUM_PADRAO, COD_IDE_CLI_BEN)
                                VALUES (SEQ_TB_LOG_ERRO_EXSERV.NEXTVAL, 'SP_GERA_REL_CONSIGNACOES', 'TB_PESSOA_FISICIA', SUBSTR(PS_PER_PROCESSO,4,7), PN_COD_INS, NULL, R_C.COD_BENEFICIO, VN_ERRO, VS_ERRO, TO_DATE(SYSDATE,'DD/MM/YYYY'), VS_CPF, 'C', NULL, R_C.COD_IDE_CLI);
                        END;

                        
                        V_NOME_ENTIDADE := NULL;
                        BEGIN
                             SELECT TRIM(UPPER(F.NOM_ENTIDADE))
                               INTO V_NOME_ENTIDADE
                               FROM USER_IPESP.TB_ENTIDADE_FOLHA F
                              WHERE F.ORG_LEGADOR = R_C.COD_ORG_LEGADOR
                                AND F.UO_LEGADOR = R_C.COD_UO_LEGADOR
                                AND ROWNUM = 1;
                        EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                                V_NOME_ENTIDADE := 1;
                        END;

                        
                        BEGIN
                            SELECT MIN(TO_NUMBER(AP.COD_CONVENIO))
                              INTO VN_ESPECIE
                              FROM USER_IPESP.TB_COMPOSICAO_CONSIG AP
                             WHERE AP.COD_INS = PN_COD_INS AND
                                   AP.COD_BENEFICIO = R_C.COD_BENEFICIO   AND
                                   AP.COD_IDE_CLI_BEN = R_C.COD_IDE_CLI   AND
                                   AP.COD_FCRUBRICA = R_C.COD_FCRUBRICA AND
                                   AP.NUM_CARGA = R_C.NUM_CARGA AND
                                   AP.NUM_SEQ_CONTROLE_CARGA = R_C.NUM_SEQ_CONTROLE_CARGA;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                              VN_ESPECIE := 0;
                        END;


                        INSERT INTO USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL DT
                        (
                              COD_INS,
                              PER_PROCESSO,
                              SEQ_PAGAMENTO,
                              TIP_PROCESSO,
                              COD_GRUPO_PAGTO,
                              DAT_PAGTO,
                              COD_BENEFICIO,
                              COD_IDE_CLI,
                              NUM_CPF,
                              NOME,
                              COD_CONCEITO,
                              COD_RUBRICA,
                              VAL_CREDITO,
                              VAL_DEBITO,
                              DAT_INI_REF,
                              DAT_ING,
                              DAT_ULT_ATU,
                              NOM_USU_ULT_ATU,
                              NOM_PRO_ULT_ATU,
                              FLG_CONSIGNATARIA,
                              ESPECIE,
                              NOM_RUBRICA,
                              NOM_LEGADOR,
                              COD_ORGAO_LEGADOR,
                              COD_UO_LEGADOR,
                              NOM_ENTIDADE,
                              NUM_CARGA
                        )
                        VALUES
                        (
                              PN_COD_INS,
                              TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY'),
                              PN_SEQ_PAGAMENTO,
                              PC_TIP_PROCESSO,
                              LPAD(P_GRP_PGTO,2,'0'),
                              TO_DATE(VS_DAT_PGTO,'DD/MM/YYYY'),
                              R_C.COD_BENEFICIO,
                              R_C.COD_IDE_CLI,
                              VS_CPF,
                              VS_NOME_BEN,
                              '97000',
                              R_C.COD_FCRUBRICA,
                              R_C.VAL_RUBRICA_CRED,
                              R_C.VAL_RUBRICA_DEB,
                              R_C.DAT_INI_REF,
                              TRUNC(SYSDATE),
                              TRUNC(SYSDATE),
                              'LANTONIO',
                              'PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_CONSIG_DET',
                              'S',
                              VN_ESPECIE,
                              NOM_RUBRICA,
                              VS_NOME_LEGADOR,
                              R_C.COD_ORG_LEGADOR,
                              R_C.COD_UO_LEGADOR,
                              V_NOME_ENTIDADE,
                              R_C.NUM_CARGA
                        );
                        COMMIT;
                    
                EXCEPTION
                    WHEN OTHERS THEN
                    VS_ERRO := SQLERRM;
                    VN_ERRO := SQLCODE;
                END;



            END LOOP;

            
            DELETE FROM  USER_IPESP.TB_RESUMO_CONSIGNATARIAS  RC
             WHERE RC.COD_INS = PN_COD_INS
               AND RC.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO, 'DD/MM/YYYY')
               AND RC.TIP_PROCESSO = PC_TIP_PROCESSO
               AND RC.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
               AND RC.COD_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
               AND RC.DAT_PAGTO = VS_DAT_PGTO;
            COMMIT;

            FOR REG IN
            (
                SELECT RT.COD_RUBRICA, RT.ESPECIE, (SUM(RT.VAL_DEBITO)-SUM(RT.VAL_CREDITO)) AS VAL_BRUTO,
                SUM(RT.VAL_PROCESSADOS) AS VALOR_PROCESSADOS,
                COUNT(*) AS QTDE, RT.NUM_CARGA
                  FROM USER_IPESP.TB_REL_GERAL_RUBRICAS_DETL RT
                 WHERE RT.COD_INS = PN_COD_INS
                   AND RT.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO, 'DD/MM/YYYY')
                   AND RT.TIP_PROCESSO = PC_TIP_PROCESSO
                   AND RT.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
                   AND RT.COD_GRUPO_PAGTO = LPAD(P_GRP_PGTO,2,'0')
                   AND RT.DAT_PAGTO = VS_DAT_PGTO
                   AND RT.FLG_CONSIGNATARIA = 'S'
                   
                 GROUP BY RT.COD_RUBRICA, RT.ESPECIE, RT.NUM_CARGA
                 ORDER BY RT.COD_RUBRICA
            )
            LOOP
                    VS_CNPJ := NULL;
                    BEGIN
                      SELECT NUM_CNPJ
                        INTO VS_CNPJ
                        FROM USER_IPESP.TB_CONSIGNATARIAS C
                       WHERE C.COD_CONSIGNATARIA = SUBSTR(REG.COD_RUBRICA,1,LENGTH(REG.COD_RUBRICA)-2);
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         VS_CNPJ := NULL;
                    END;

                    NOM_RUBRICA := NULL;
                    BEGIN
                        SELECT R.NOM_RUBRICA
                          INTO NOM_RUBRICA
                          FROM USER_IPESP.TB_RUBRICAS R
                         WHERE R.COD_INS = PN_COD_INS
                           AND R.COD_RUBRICA = REG.COD_RUBRICA
                           AND R.COD_ENTIDADE = 1;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        BEGIN
                          SELECT R.NOM_RUBRICA
                          INTO NOM_RUBRICA
                          FROM USER_IPESP.TB_RUBRICAS R
                         WHERE R.COD_INS = PN_COD_INS
                           AND R.COD_RUBRICA = REG.COD_RUBRICA
                           AND ROWNUM = 1;
                        EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                             NOM_RUBRICA := 'NAO INFORMADO';
                        END;
                    END;

                    PERC_OPERACIONAL := 0;
                    BEGIN
                           BEGIN
                               SELECT CR.VAL_PORC_COMISSAO
                                INTO PERC_OPERACIONAL
                                FROM USER_IPESP.TB_CONSIGNATARIA_RUBRICA CR
                               WHERE CR.COD_INS = PN_COD_INS
                                 AND CR.COD_FCRUBRICA = REG.COD_RUBRICA
                                 AND CR.COD_ENTIDADE = 1
                                 AND CR.COD_CONVENIO = REG.ESPECIE
                                 AND CR.DAT_FIM_VIG IS NULL
                                 AND ROWNUM = 1;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                   SELECT MAX(CR.VAL_PORC_COMISSAO)
                                    INTO PERC_OPERACIONAL
                                    FROM USER_IPESP.TB_CONSIGNATARIA_RUBRICA CR
                                   WHERE CR.COD_INS = PN_COD_INS
                                     AND CR.COD_FCRUBRICA = REG.COD_RUBRICA
                                     AND CR.COD_ENTIDADE = 5
                                     AND CR.COD_CONVENIO = REG.ESPECIE
                                     AND CR.DAT_FIM_VIG IS NULL
                                     AND ROWNUM = 1;
                            END;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        PERC_OPERACIONAL := 0;
                    END;

                    VN_LIQUIDO := 0;

                    IF (REG.COD_RUBRICA >= 9700000) THEN
                      VN_LIQUIDO := REG.VAL_BRUTO-((REG.VAL_BRUTO*PERC_OPERACIONAL)/100);
                    ELSE
                      VN_LIQUIDO := REG.VAL_BRUTO;
                    END IF;

                    IF VN_LIQUIDO < 0 THEN
                      VN_LIQUIDO := 0;
                    END IF;

                    INSERT INTO USER_IPESP.TB_RESUMO_CONSIGNATARIAS RC
                    (
                      COD_INS,
                      TIP_PROCESSO,
                      PER_PROCESSO,
                      SEQ_PAGAMENTO,
                      COD_FCRUBRICA,
                      NOM_RUBRICA,
                      TOTAL,
                      NUM_QTDE,
                      TIPO_PENSAO,
                      COD_GRP_PAG,
                      DAT_PAGTO,
                      ESPECIE,
                      COD_CONCEITO,
                      TAXA_OPER,
                      VAL_OPER,
                      VAL_LIQ,
                      NUM_CNPJ,
                      NUM_CARGA,
                      COD_CONSIGNATARIA

                    )
                    VALUES
                    (
                      PN_COD_INS,
                      PC_TIP_PROCESSO,
                      TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY'),
                      PN_SEQ_PAGAMENTO,
                      REG.COD_RUBRICA,
                      NOM_RUBRICA,
                      REG.VAL_BRUTO,
                      REG.QTDE,
                      NULL,
                      LPAD(P_GRP_PGTO,2,'0'),
                      VS_DAT_PGTO,
                      REG.ESPECIE,
                      97000,
                      PERC_OPERACIONAL,
                      (REG.VAL_BRUTO*PERC_OPERACIONAL)/100,
                      VN_LIQUIDO,
                      VS_CNPJ,
                      REG.NUM_CARGA,
                      TRUNC(REG.COD_RUBRICA/100)
                   );
                   COMMIT;
            END LOOP;


            
            
            FOR REG IN
            (
                
                SELECT CC.COD_FCRUBRICA, CC.COD_CONVENIO, COUNT(*) AS QTDE, CC.NUM_CARGA, 
                       COUNT(*) * (SELECT DISTINCT VAL_TAXA 
                                     FROM USER_IPESP.TB_CONSIGNATARIA_TAXA CT 
                                    WHERE CT.COD_INS = PN_COD_INS 
                                      AND CT.COD_TIPO_TAXA = 1 
                                      AND CT.COD_CONSIGNATARIA = SUBSTR(CC.COD_FCRUBRICA,1,LENGTH(CC.COD_FCRUBRICA)-2) 
                                      AND CT.DAT_FIM_VIG IS NULL      
                                   ) AS VALOR
                  FROM USER_IPESP.TB_COMPOSICAO_CONSIG CC
                 WHERE CC.COD_INS = PN_COD_INS
                   AND CC.FLG_STATUS IN ('V','P')
                   
                   AND (CC.DAT_FIM_VIG IS NULL OR CC.DAT_FIM_VIG >= ADD_MONTHS(TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY'),1)-1)
                   AND CC.NUM_CARGA IN 
                   (
                       
                           SELECT EA.ID_ARQUIVO FROM USER_IPESP.TB_ENVIO_ARQ_CONSIG EA
                            WHERE EA.COD_INS = PN_COD_INS
                              AND EA.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                              AND EA.FLG_STATUS_PROCESSO = 'F'
                              AND EA.ID_ARQUIVO = CC.NUM_CARGA
                           UNION   
                           SELECT EA.ID_ARQUIVO FROM USER_IPESP.TB_ENVIO_ARQ_CONSIG_CIP EA
                            WHERE EA.COD_INS = PN_COD_INS
                              AND EA.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                              AND EA.FLG_STATUS_PROCESSO = 'F'
                              AND EA.ID_ARQUIVO = CC.NUM_CARGA
                   )
                   

















  
                   AND EXISTS
                   (
                         SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                          WHERE AX.COD_INS = PN_COD_INS
                            AND AX.TIP_PROCESSO = PC_TIP_PROCESSO
                            AND AX.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                            AND AX.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
                            AND AX.COD_BENEFICIO = CC.COD_BENEFICIO
                            AND AX.COD_IDE_CLI = CC.COD_IDE_CLI_BEN
                            AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                            AND AX.DAT_PGTO = PD_DAT_PAGTO
                   )
                   AND EXISTS
                   (
                       SELECT 1 FROM USER_IPESP.TB_DET_CALCULADO DC
                        WHERE DC.COD_INS = CC.COD_INS
                           AND DC.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
                           AND DC.TIP_PROCESSO = PC_TIP_PROCESSO
                           AND DC.NUM_CARGA = CC.NUM_CARGA
                           AND DC.NUM_SEQ_CONTROLE_CARGA = CC.NUM_SEQ_CONTROLE_CARGA
                           AND DC.COD_BENEFICIO = CC.COD_BENEFICIO
                           AND DC.COD_IDE_CLI = CC.COD_IDE_CLI_BEN
                           AND DC.COD_FCRUBRICA = CC.COD_FCRUBRICA
                           AND DC.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                   )
                 GROUP BY CC.COD_FCRUBRICA, CC.COD_CONVENIO, CC.NUM_CARGA
                 ORDER BY CC.COD_FCRUBRICA, CC.COD_CONVENIO, CC.NUM_CARGA
                
            )
            LOOP

                 
                 UPDATE USER_IPESP.TB_RESUMO_CONSIGNATARIAS C
                    SET C.QTD_PROCESSAMENTO = NVL(REG.QTDE,0),
                        C.VAL_PROCESSAMENTO = NVL(REG.VALOR,0)
                  WHERE C.COD_INS = PN_COD_INS
                    AND C.TIP_PROCESSO = PC_TIP_PROCESSO
                    AND C.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                    AND C.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
                    AND C.DAT_PAGTO = VS_DAT_PGTO
                    AND C.COD_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
                    AND C.COD_FCRUBRICA = REG.COD_FCRUBRICA
                    AND C.ESPECIE = REG.COD_CONVENIO
                    AND C.NUM_CARGA = REG.NUM_CARGA;
                 

                 IF (SQL%ROWCOUNT = 0) THEN

                    NOM_RUBRICA := NULL;
                    BEGIN
                        SELECT R.NOM_RUBRICA
                          INTO NOM_RUBRICA
                          FROM USER_IPESP.TB_RUBRICAS R
                         WHERE R.COD_INS = PN_COD_INS
                           AND R.COD_RUBRICA = REG.COD_FCRUBRICA
                           AND R.COD_ENTIDADE = 1;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        BEGIN
                          SELECT R.NOM_RUBRICA
                          INTO NOM_RUBRICA
                          FROM USER_IPESP.TB_RUBRICAS R
                         WHERE R.COD_INS = PN_COD_INS
                           AND R.COD_RUBRICA = REG.COD_FCRUBRICA
                           AND ROWNUM = 1;
                        EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                             NOM_RUBRICA := 'NAO INFORMADO';
                        END;
                    END;


                    PERC_OPERACIONAL := 0;
                    BEGIN
                       BEGIN
                             SELECT CR.VAL_PORC_COMISSAO
                              INTO PERC_OPERACIONAL
                              FROM USER_IPESP.TB_CONSIGNATARIA_RUBRICA CR
                             WHERE CR.COD_INS = PN_COD_INS
                               AND CR.COD_FCRUBRICA = REG.COD_FCRUBRICA
                               AND CR.COD_ENTIDADE = 1
                               AND CR.COD_CONVENIO = REG.COD_CONVENIO
                               AND CR.DAT_FIM_VIG IS NULL
                               AND ROWNUM = 1;
                       EXCEPTION
                              WHEN NO_DATA_FOUND THEN
                                 SELECT MAX(CR.VAL_PORC_COMISSAO)
                                  INTO PERC_OPERACIONAL
                                  FROM USER_IPESP.TB_CONSIGNATARIA_RUBRICA CR
                                 WHERE CR.COD_INS = PN_COD_INS
                                   AND CR.COD_FCRUBRICA = REG.COD_FCRUBRICA
                                   AND CR.COD_ENTIDADE NOT IN (1,5)
                                   AND CR.COD_CONVENIO = REG.COD_CONVENIO
                                   AND CR.DAT_FIM_VIG IS NULL
                                   AND ROWNUM = 1;
                       END;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN

                        PERC_OPERACIONAL := 0;
                    END;

                    VS_CNPJ := NULL;
                    BEGIN
                      SELECT NUM_CNPJ
                        INTO VS_CNPJ
                        FROM USER_IPESP.TB_CONSIGNATARIAS C
                       WHERE C.COD_CONSIGNATARIA = SUBSTR(REG.COD_FCRUBRICA,1,LENGTH(REG.COD_FCRUBRICA)-2);
                    EXCEPTION
                       WHEN NO_DATA_FOUND THEN
                         VS_CNPJ := NULL;
                    END;

                    INSERT INTO USER_IPESP.TB_RESUMO_CONSIGNATARIAS
                    (
                           COD_INS,
                           TIP_PROCESSO,
                           PER_PROCESSO,
                           SEQ_PAGAMENTO,
                           COD_FCRUBRICA,
                           NOM_RUBRICA,
                           TOTAL,
                           NUM_QTDE,
                           TIPO_PENSAO,
                           COD_GRP_PAG,
                           DAT_PAGTO,
                           ESPECIE,
                           COD_CONCEITO,
                           TAXA_OPER,
                           VAL_OPER,
                           VAL_LIQ,
                           NUM_CNPJ,
                           QTD_PROCESSAMENTO,
                           VAL_PROCESSAMENTO,
                           NUM_CARGA,
                           COD_CONSIGNATARIA
                    )
                    VALUES
                    (
                           PN_COD_INS,
                           PC_TIP_PROCESSO,
                           TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY'),
                           PN_SEQ_PAGAMENTO,
                           REG.COD_FCRUBRICA,
                           NOM_RUBRICA,
                           0,
                           0,
                           NULL,
                           LPAD(P_GRP_PGTO,2,'0'),
                           VS_DAT_PGTO,
                           REG.COD_CONVENIO,
                           '97000',
                           PERC_OPERACIONAL,
                           0,
                           0,
                           VS_CNPJ,
                           REG.QTDE,
                           REG.VALOR,
                           REG.NUM_CARGA,
                           TRUNC(REG.COD_FCRUBRICA/100)
                    );

                 END IF;

                 COMMIT;

            END LOOP;

            UPDATE USER_IPESP.TB_RESUMO_CONSIGNATARIAS C
                    SET C.QTD_PROCESSAMENTO = 0,
                        C.VAL_PROCESSAMENTO = 0
                  WHERE C.COD_INS = PN_COD_INS
                    AND C.TIP_PROCESSO = PC_TIP_PROCESSO
                    AND C.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                    AND C.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
                    AND C.DAT_PAGTO = VS_DAT_PGTO
                    AND C.COD_GRP_PAG = LPAD(P_GRP_PGTO,2,'0')
                    AND C.QTD_PROCESSAMENTO IS NULL;











             UPDATE USER_IPESP.TB_RESUMO_CONSIGNATARIAS C
                    SET C.VAL_LIQ = ROUND(CASE WHEN NVL(C.TOTAL,0)-NVL(C.VAL_OPER,0)-NVL(C.VAL_PROCESSAMENTO,0) < 0 THEN 0 ELSE NVL(C.TOTAL,0)-NVL(C.VAL_OPER,0)-NVL(C.VAL_PROCESSAMENTO,0) END,2)
                  WHERE C.COD_INS = PN_COD_INS
                    AND C.TIP_PROCESSO = PC_TIP_PROCESSO
                    AND C.PER_PROCESSO = TO_DATE(PS_PER_PROCESSO,'DD/MM/YYYY')
                    AND C.SEQ_PAGAMENTO = PN_SEQ_PAGAMENTO
                    AND C.DAT_PAGTO = VS_DAT_PGTO
                    AND C.COD_GRP_PAG = LPAD(P_GRP_PGTO,2,'0');

             COMMIT;
             
        EXCEPTION
           WHEN DATA_CRONOGRAMA THEN
             VS_ERRO := 'SEM DATA EM ABERTO NA CRONOGRAMA PAG';
             RETURN;
           WHEN ERROR_PARAM THEN
             VS_ERRO := 'E NECESSARIO PREENCHER TODOS OS PARAMETROS';
             RETURN;
           WHEN OTHERS THEN
             VS_ERRO := SQLCODE ||' - '||SQLERRM;
             RETURN;
        END;

    END SP_FECHAMENTO_CONSIG_DET;


    



    PROCEDURE SP_FECHAMENTO_GERAL_PA
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_ERRO OUT VARCHAR2,
       P_DATA_PAGTO DATE
    ) IS

    
    VS_ERRO VARCHAR2 (1000);
    ERROR_PARAM EXCEPTION;
    ERROR_DATA_PGTO EXCEPTION;
    V_DAT_PAGTO DATE;
    V_NOM_GRUPO VARCHAR2(100);
    V_BANCO VARCHAR2(10);
    V_DESC_BANCO VARCHAR2(100);
    V_AGENCIA VARCHAR2(10);
    V_CONTA VARCHAR2(10);
    V_DVCONTA VARCHAR2(10);
    V_COD_TIPO_CONTA VARCHAR2(10);

    
    CURSOR V_CURSOR IS
        SELECT R1.COD_BENEFICIO      COD_BENEFICIO,
               R1.COD_IDE_CLI  AS COD_ALIMENTANTE,
               R1.COD_IDE_CLI_BEN AS COD_ALIMENTADO,
               (
                  SELECT PF1.NOM_PESSOA_FISICA
                    FROM USER_IPESP.TB_PESSOA_FISICA PF1
                   WHERE PF1.COD_INS = R1.COD_INS
                     AND PF1.COD_IDE_CLI = R1.COD_IDE_CLI
               ) AS NOME_ALIMENTANTE,
               (
                  SELECT PF2.NOM_PESSOA_FISICA
                    FROM USER_IPESP.TB_PESSOA_FISICA PF2
                   WHERE PF2.COD_INS     = R1.COD_INS
                     AND PF2.COD_IDE_CLI = R1.COD_IDE_CLI_BEN
               ) AS NOME_ALIMENTADO,
               (
                  SELECT PF2.NUM_CPF
                    FROM USER_IPESP.TB_PESSOA_FISICA PF2
                   WHERE PF2.COD_INS     = R1.COD_INS
                     AND PF2.COD_IDE_CLI = R1.COD_IDE_CLI_BEN
               ) AS  CPF_ALIMENTADO,
               R1.COD_FCRUBRICA AS RUBRICA,
               DECODE (R1.FLG_NATUREZA,'C',R1.VAL_RUBRICA*-1, R1.VAL_RUBRICA) AS VALOR
          FROM USER_IPESP.TB_DET_CALCULADO R1
         WHERE R1.COD_INS = P_COD_INS
           AND R1.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
           AND R1.TIP_PROCESSO = P_TIP_PROCESSO
           AND R1.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
           AND EXISTS
           (
               SELECT 1 FROM USER_IPESP.TB_FOLHA_PA PA
                WHERE PA.COD_INS = R1.COD_INS
                  AND PA.TIP_PROCESSO = R1.TIP_PROCESSO
                  AND PA.PER_PROCESSO = R1.PER_PROCESSO
                  AND PA.SEQ_PAGAMENTO = R1.SEQ_PAGAMENTO
                  AND PA.COD_BENEFICIO = R1.COD_BENEFICIO
                  AND PA.COD_IDE_CLI = R1.COD_IDE_CLI
                  AND PA.COD_IDE_CLI_BEN = R1.COD_IDE_CLI_BEN
                  AND PA.VAL_LIQUIDO >= 0
           )
           AND R1.COD_FCRUBRICA IN (SELECT DISTINCT COD_RUBRICA FROM USER_IPESP.TB_RUBRICAS R WHERE R.TIP_EVENTO_ESPECIAL = 'P')
           AND EXISTS
           (
                 SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                  WHERE AX.COD_INS = R1.COD_INS
                    AND AX.TIP_PROCESSO = R1.TIP_PROCESSO
                    AND AX.PER_PROCESSO = R1.PER_PROCESSO
                    AND AX.SEQ_PAGAMENTO = R1.SEQ_PAGAMENTO
                    AND AX.COD_BENEFICIO = R1.COD_BENEFICIO
                    AND AX.COD_IDE_CLI = R1.COD_IDE_CLI
                    AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                    AND AX.DAT_PGTO = P_DATA_PAGTO
           )
        ORDER BY NOME_ALIMENTANTE;


    BEGIN

          BEGIN

              IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
                 RAISE ERROR_PARAM;
              END IF;

              
              V_DAT_PAGTO := NULL;
              V_DAT_PAGTO := P_DATA_PAGTO;


              DELETE FROM USER_IPESP.TB_REL_FOLHA_GERAL_PA A
               WHERE A.COD_INS = P_COD_INS
                 AND A.TIP_PROCESSO = P_TIP_PROCESSO
                 AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND A.COD_GRP_PAGAMENTO = TO_NUMBER(P_GRP_PGTO)
                 AND A.DAT_PAGTO = V_DAT_PAGTO;
              COMMIT;

              FOR REG IN V_CURSOR
              LOOP
                  V_BANCO := NULL;
                  V_DESC_BANCO := NULL;
                  V_AGENCIA := NULL;
                  V_CONTA := NULL;
                  V_DVCONTA := NULL;
                  V_COD_TIPO_CONTA := NULL;

                  BEGIN
                          SELECT DISTINCT IB.COD_BANCO, IB.NUM_AGENCIA, B.DES_BANCO,
                                 IB.NUM_CONTA, IB.NUM_DV_CONTA, IB.COD_TIPO_CONTA
                            INTO V_BANCO, V_AGENCIA, V_DESC_BANCO, V_CONTA, V_DVCONTA, V_COD_TIPO_CONTA
                            FROM USER_IPESP.TB_INFORMACAO_BANCARIA IB, USER_IPESP.TB_BANCO B
                           WHERE IB.COD_INS = 1
                             AND IB.COD_IDE_CLI = REG.COD_ALIMENTADO
                             AND IB.COD_BANCO = B.COD_BANCO
                             AND EXISTS
                             (
                                 SELECT 1 FROM USER_IPESP.TB_INFO_BANC_BENEFICIO BC
                                  WHERE BC.COD_INS = IB.COD_INS
                                    AND BC.COD_IDE_CLI = IB.COD_IDE_CLI
                                    AND BC.COD_IDE_INF_BANC = IB.COD_IDE_INF_BANC
                             );
                  EXCEPTION
                           WHEN NO_DATA_FOUND THEN
                               BEGIN

                                    SELECT DISTINCT IB.COD_BANCO, IB.NUM_AGENCIA, B.DES_BANCO,
                                           IB.NUM_CONTA, IB.NUM_DV_CONTA, IB.COD_TIPO_CONTA
                                      INTO V_BANCO, V_AGENCIA, V_DESC_BANCO, V_CONTA, V_DVCONTA, V_COD_TIPO_CONTA
                                      FROM USER_IPESP.TB_INFORMACAO_BANCARIA IB, USER_IPESP.TB_BANCO B
                                     WHERE IB.COD_INS = 1
                                       AND IB.COD_IDE_CLI = REG.COD_ALIMENTADO
                                       AND IB.COD_BANCO = B.COD_BANCO
                                       AND NOT EXISTS
                                       (
                                           SELECT 1 FROM USER_IPESP.TB_INFO_BANC_BENEFICIO BC
                                            WHERE BC.COD_INS = IB.COD_INS
                                              AND BC.COD_IDE_CLI = IB.COD_IDE_CLI
                                              AND BC.COD_IDE_INF_BANC = IB.COD_IDE_INF_BANC
                                       );
                               EXCEPTION
                                       WHEN OTHERS THEN
                                          V_BANCO := '000';
                                          V_AGENCIA := '0000';
                                          V_DESC_BANCO := '****  Sem Conta ******' ;
                                          V_CONTA := '000000';
                                          V_DVCONTA := '0';
                                          V_COD_TIPO_CONTA := '0';
                               END;
                          WHEN TOO_MANY_ROWS THEN
                               BEGIN
                                    SELECT DISTINCT IB.COD_BANCO, IB.NUM_AGENCIA, B.DES_BANCO,
                                           IB.NUM_CONTA, IB.NUM_DV_CONTA, IB.COD_TIPO_CONTA
                                      INTO V_BANCO, V_AGENCIA, V_DESC_BANCO, V_CONTA, V_DVCONTA, V_COD_TIPO_CONTA
                                      FROM USER_IPESP.TB_INFORMACAO_BANCARIA IB, USER_IPESP.TB_BANCO B
                                     WHERE IB.COD_INS = 1
                                       AND IB.COD_IDE_CLI = REG.COD_ALIMENTADO
                                       AND IB.COD_BANCO = B.COD_BANCO
                                       AND EXISTS
                                       (
                                           SELECT 1 FROM USER_IPESP.TB_INFO_BANC_BENEFICIO BC
                                            WHERE BC.COD_INS = IB.COD_INS
                                              AND BC.COD_IDE_CLI = IB.COD_IDE_CLI
                                              AND BC.COD_IDE_INF_BANC = IB.COD_IDE_INF_BANC
                                              AND BC.COD_BENEFICIO = REG.COD_BENEFICIO
                                       );
                               EXCEPTION
                                       WHEN OTHERS THEN
                                          V_BANCO := '000';
                                          V_AGENCIA := '0000';
                                          V_DESC_BANCO := '****  Sem Conta ******' ;
                                          V_CONTA := '000000';
                                          V_DVCONTA := '0';
                                          V_COD_TIPO_CONTA := '0';
                               END;     
                          
                 END;


                 INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_PA
                  VALUES
                  (
                      P_COD_INS,
                      TO_DATE(P_PERIODO,'DD/MM/YYYY'),
                      P_TIP_PROCESSO,
                      P_SEQ_PAGAMENTO,
                      TO_NUMBER(P_GRP_PGTO),
                      V_DAT_PAGTO,
                      REG.COD_BENEFICIO,
                      REG.COD_ALIMENTANTE,
                      REG.NOME_ALIMENTANTE,
                      REG.COD_ALIMENTADO,
                      REG.NOME_ALIMENTADO,
                      REG.CPF_ALIMENTADO,
                      REG.RUBRICA,
                      REG.VALOR,
                      V_BANCO,
                      V_DESC_BANCO,
                      V_AGENCIA,
                      V_CONTA,
                      V_DVCONTA,
                      V_COD_TIPO_CONTA,
                      SYSDATE,
                      SYSDATE,
                      'LANTONIO',
                      'PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_PA'
                  );
                  COMMIT;
              END LOOP;


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
   END SP_FECHAMENTO_GERAL_PA;

    



    PROCEDURE SP_FECHAMENTO_GERAL_TJM
    (
       P_COD_INS NUMBER, 
       P_PERIODO VARCHAR2,  
       P_TIP_PROCESSO CHAR, 
       P_SEQ_PAGAMENTO NUMBER, 
       P_GRP_PGTO VARCHAR2,
       P_ERRO OUT VARCHAR2,
       P_DATA_PAGTO DATE
    ) IS

    
    VS_ERRO VARCHAR2 (1000);
    ERROR_PARAM EXCEPTION;
    ERROR_DATA_PGTO EXCEPTION;
    V_DAT_PAGTO DATE;
    V_NOM_GRUPO VARCHAR2(100);
    V_BANCO VARCHAR2(10);
    V_DESC_BANCO VARCHAR2(100);
    V_AGENCIA VARCHAR2(10);
    V_CONTA VARCHAR2(10);
    V_DVCONTA VARCHAR2(10);
    V_COD_TIPO_CONTA VARCHAR2(10);

    
    CURSOR V_CURSOR IS
       SELECT FF.COD_INS,
              FF.PER_PROCESSO,
              CB.COD_ORG_LEGADOR,
              CB.COD_UO_LEGADOR,
              FF.COD_BENEFICIO,
              FF.COD_IDE_CLI,
              (SELECT NUM_CPF FROM USER_IPESP.TB_PESSOA_FISICA PF WHERE PF.COD_INS = FF.COD_INS AND PF.COD_IDE_CLI = FF.COD_IDE_CLI) AS CPF,
              FF.NOM_BEN NOME,
              DC.COD_FCRUBRICA RUBRICA,
              (SELECT DISTINCT R.NOM_RUBRICA FROM USER_IPESP.TB_RUBRICAS R WHERE R.COD_INS=DC.COD_INS AND R.COD_RUBRICA=DC.COD_FCRUBRICA AND R.COD_ENTIDADE=CB.COD_ENTIDADE AND R.DAT_FIM_VIG IS NULL ) AS NOM_RUBRICA,
              DECODE( DC.FLG_NATUREZA, 'C', DC.VAL_RUBRICA, 0 ) AS VAL_CREDITO,
              DECODE( DC.FLG_NATUREZA, 'D', DC.VAL_RUBRICA, 0 ) AS VAL_DEBITO,
              DC.DAT_INI_REF
         FROM USER_IPESP.TB_FOLHA FF,
              USER_IPESP.TB_CONCESSAO_BENEFICIO CB,
              USER_IPESP.TB_DET_CALCULADO      DC,
              USER_IPESP.TB_ENTIDADE_FOLHA      EF
        WHERE FF.COD_INS = P_COD_INS
          AND FF.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
          AND FF.TIP_PROCESSO = P_TIP_PROCESSO
          AND FF.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
          AND FF.VAL_LIQUIDO >= 0

          AND CB.COD_ORG_LEGADOR = EF.ORG_LEGADOR
          AND CB.COD_UO_LEGADOR  = EF.UO_LEGADOR

          AND CB.COD_INS = FF.COD_INS
          AND CB.COD_BENEFICIO = FF.COD_BENEFICIO
          AND CB.COD_TIPO_BENEFICIO = 'M'
          AND CB.COD_ENTIDADE = 48

          AND DC.COD_INS       = FF.COD_INS
          AND DC.PER_PROCESSO  = FF.PER_PROCESSO
          AND DC.COD_IDE_CLI   = FF.COD_IDE_CLI
          AND DC.COD_BENEFICIO = FF.COD_BENEFICIO
          AND DC.TIP_PROCESSO  = FF.TIP_PROCESSO
          AND DC.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO

          AND   EXISTS
          (
                SELECT 1
                 FROM USER_IPESP.TB_IMPRESAO_RUB IR
                WHERE IR.COD_INS = DC.COD_INS
                  AND IR.COD_RUBRICA = DC.COD_FCRUBRICA
                  AND IR.COD_TIPO_PROCESSO = DC.TIP_PROCESSO
                  AND IR.COD_ENTIDADE      = CB.COD_ENTIDADE
                  AND IR.FLG_IMPRIME       = 'S'
                  AND IR.DAT_FIM_VIG IS NULL
          )
          AND EXISTS
             (
                   SELECT 1 FROM USER_IPESP.TB_REL_FOLHA_AUX AX
                    WHERE AX.COD_INS = FF.COD_INS
                      AND AX.TIP_PROCESSO = FF.TIP_PROCESSO
                      AND AX.PER_PROCESSO = FF.PER_PROCESSO
                      AND AX.SEQ_PAGAMENTO = FF.SEQ_PAGAMENTO
                      AND AX.COD_BENEFICIO = FF.COD_BENEFICIO
                      AND AX.COD_IDE_CLI = FF.COD_IDE_CLI
                      AND AX.NUM_GRUPO = LPAD(P_GRP_PGTO,2,'0')
                      AND AX.DAT_PGTO = P_DATA_PAGTO
             )
        ORDER BY NOME, RUBRICA;


    BEGIN

          BEGIN

              IF (P_COD_INS IS NULL OR P_TIP_PROCESSO IS NULL OR P_SEQ_PAGAMENTO IS NULL OR P_PERIODO IS NULL OR P_GRP_PGTO IS NULL) THEN
                 RAISE ERROR_PARAM;
              END IF;

              
              V_DAT_PAGTO := NULL;
              V_DAT_PAGTO := P_DATA_PAGTO;


              DELETE FROM USER_IPESP.TB_REL_FOLHA_GERAL_TJM A
               WHERE A.COD_INS = P_COD_INS
                 AND A.TIP_PROCESSO = P_TIP_PROCESSO
                 AND A.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                 AND A.PER_PROCESSO = TO_DATE(P_PERIODO,'DD/MM/YYYY')
                 AND A.COD_GRP_PAGAMENTO = TO_NUMBER(P_GRP_PGTO)
                 AND A.DAT_PAGTO = V_DAT_PAGTO;
              COMMIT;

              FOR REG IN V_CURSOR
              LOOP

                 BEGIN
                     INSERT INTO USER_IPESP.TB_REL_FOLHA_GERAL_TJM
                     (
                            COD_INS,
                            PER_PROCESSO,
                            TIP_PROCESSO,
                            SEQ_PAGAMENTO,
                            COD_GRP_PAGAMENTO,
                            DAT_PAGTO,
                            ORGAO,
                            UO,
                            COD_BENEFICIO,
                            COD_IDE_CLI,
                            CPF,
                            NOME,
                            COD_FCRUBRICA,
                            NOM_RUBRICA,
                            VAL_CREDITO,
                            VAL_DEBITO,
                            VAL_LIQUIDO,
                            DAT_INI_REF,
                            DAT_ING,
                            DAT_ULT_ATU,
                            NOM_USU_ULT_ATU,
                            NOM_PRO_ULT_ATU
                     )
                      VALUES
                      (
                          P_COD_INS,
                          TO_DATE(P_PERIODO,'DD/MM/YYYY'),
                          P_TIP_PROCESSO,
                          P_SEQ_PAGAMENTO,
                          TO_NUMBER(P_GRP_PGTO),
                          V_DAT_PAGTO,
                          REG.COD_ORG_LEGADOR,
                          REG.COD_UO_LEGADOR,
                          REG.COD_BENEFICIO,
                          REG.COD_IDE_CLI,
                          REG.CPF,
                          REG.NOME,
                          REG.RUBRICA,
                          REG.NOM_RUBRICA,
                          REG.VAL_CREDITO,
                          REG.VAL_DEBITO,
                          REG.VAL_CREDITO-REG.VAL_DEBITO,
                          REG.DAT_INI_REF,
                          SYSDATE,
                          SYSDATE,
                          'LANTONIO',
                          'PAC_REL_FECHAMENTO_FOLHA.SP_FECHAMENTO_GERAL_TJM'
                      );

                      COMMIT;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                        P_ERRO:= 'Inclusao dos registros do TJM - Cod_beneficio: '||REG.COD_BENEFICIO||' - cod_ide_cli: '||REG.COD_IDE_CLI;
                  END;

              END LOOP;


         EXCEPTION
           WHEN ERROR_PARAM THEN
                VS_ERRO := 'OS PARAMETROS P_COD_INS, P_TIP_PROCESSO, P_SEQ_PAGAMENTO, P_PERIODO, P_GRP_PAGTO SAO OBRIGATORIOS';
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
   END SP_FECHAMENTO_GERAL_TJM;

END PAC_REL_FECHAMENTO_FOLHA;				 
				
/
