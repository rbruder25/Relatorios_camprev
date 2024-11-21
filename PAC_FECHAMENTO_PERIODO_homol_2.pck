CREATE OR REPLACE PACKAGE "PAC_FECHAMENTO_PERIODO" IS





   PROCEDURE SP_FECHA_PERIODO(P_COD_INS       IN  NUMBER  DEFAULT 1
                             ,P_PER_PROCESSO  IN  VARCHAR
                             ,P_TIP_PROCESSO  IN  CHAR
                             ,P_SEQ_PAGAMENTO IN  NUMBER DEFAULT 1
                             ,P_NOM_USUARIO   IN  VARCHAR2
                             ,P_MSG_ERRO     OUT  VARCHAR2
                             );

  FUNCTION  SP_VALIDA_MSG_CONTRA_CHEQUE( I_COD_INS         IN NUMBER ,
                                           I_DAT_INI_VIG     IN DATE   ,
                                           I_DAT_FIM_VIG     IN DATE   ,
                                           I_TIP_FOLHA       IN VARCHAR,
                                           I_COD_GRUPO_PAG   IN NUMBER ,
                                           I_NAT_MENSAGEM    IN VARCHAR,
                                           I_NUM_PRIORIDADE  IN NUMBER ,
                                           I_COD_FUNCAO      IN NUMBER,
                                           O_GLS_ERRO        OUT VARCHAR
                                         ) RETURN VARCHAR2 ;
 END PAC_FECHAMENTO_PERIODO;
/
CREATE OR REPLACE PACKAGE BODY "PAC_FECHAMENTO_PERIODO" IS

 PROCEDURE SP_FECHA_PERIODO(P_COD_INS       IN  NUMBER  DEFAULT 1
                           ,P_PER_PROCESSO  IN  VARCHAR
                           ,P_TIP_PROCESSO  IN  CHAR
                           ,P_SEQ_PAGAMENTO IN  NUMBER DEFAULT 1
                           ,P_NOM_USUARIO   IN  VARCHAR2
                           ,P_MSG_ERRO     OUT  VARCHAR2
                           ) IS

      EXCECAO_20001 EXCEPTION;
      PRAGMA EXCEPTION_INIT(EXCECAO_20001, -20001);

      EXCECAO_20002 EXCEPTION;
      PRAGMA EXCEPTION_INIT(EXCECAO_20002, -20002);

      EXISTE_REGISTRO BOOLEAN := FALSE;

    BEGIN

      FOR REG IN ( SELECT CP.NUM_GRP
                        , CP.DAT_PAG_EFETIVA
                     FROM TB_PERIODOS_PROCESSAMENTO PP
                        , TB_CRONOGRAMA_PAG         CP
                    WHERE PP.COD_INS          = P_COD_INS
                      AND PP.PER_PROCESSO     = TO_DATE(P_PER_PROCESSO,'DD/MM/YYYY')
                      AND PP.COD_TIP_PROCESSO = P_TIP_PROCESSO
                      AND PP.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
                      AND CP.COD_INS          = PP.COD_INS
                      AND CP.PER_PROCESSO     = PP.PER_PROCESSO
                      AND CP.COD_TIP_PROCESSO = PP.COD_TIP_PROCESSO
                      AND PP.FLG_STATUS       = 'A'
                    ) LOOP

                 EXISTE_REGISTRO := TRUE;

                 IF (REG.DAT_PAG_EFETIVA IS NULL) THEN
                     RAISE_APPLICATION_ERROR( -20002, 'A Data de Pagamento Efetiva esta nula e precisa ser preenchida. Reveja esta informac?o na Tela de Definic?o de Pagamentos. Periodo: ' || P_PER_PROCESSO || ', Tipo de Processo: ' || P_TIP_PROCESSO);
                 END IF;



                 DELETE TB_HFOLHA_PAGAMENTO_DET FD
                   WHERE FD.COD_INS          = P_COD_INS
                     AND FD.TIP_PROCESSO     = P_TIP_PROCESSO
                     AND FD.PER_PROCESSO     = P_PER_PROCESSO
                     AND FD.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
                     AND EXISTS (
                         SELECT 1
                           FROM TB_HFOLHA_PAGAMENTO FO
                          WHERE FO.COD_INS          = FD.COD_INS
                            AND FO.TIP_PROCESSO     = FD.TIP_PROCESSO
                            AND FO.PER_PROCESSO     = FD.PER_PROCESSO
                            AND FO.SEQ_PAGAMENTO    = FD.SEQ_PAGAMENTO
                            AND FO.NUM_GRP          = REG.NUM_GRP
                            AND FO.COD_IDE_CLI      = FD.COD_IDE_CLI
                            AND FO.COD_ENTIDADE     = FD.COD_ENTIDADE
                            AND FO.NUM_MATRICULA    = FD.NUM_MATRICULA
                            AND FO.COD_IDE_REL_FUNC = FD.COD_IDE_REL_FUNC
                     );

                 DELETE TB_HFOLHA_PAGAMENTO HP
                  WHERE HP.COD_INS          = P_COD_INS
                    AND HP.PER_PROCESSO     = P_PER_PROCESSO
                    AND HP.TIP_PROCESSO     = P_TIP_PROCESSO
                    AND HP.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
                    AND HP.NUM_GRP          = REG.NUM_GRP;


                 INSERT
                   INTO TB_HFOLHA_PAGAMENTO HP
                     (COD_INS
                      , TIP_PROCESSO
                      , PER_PROCESSO
                      , SEQ_PAGAMENTO
                      , COD_IDE_CLI
                      , NUM_CPF
                      , COD_ENTIDADE
                      , NUM_MATRICULA
                      , COD_IDE_REL_FUNC
                      , NUM_GRP
                      , NOME
                      , COD_IDE_TUTOR
                      , NOM_TUTOR
                      , DAT_PROCESSO
                      , VAL_SAL_BASE
                      , TOT_CRED
                      , TOT_DEB
                      , VAL_LIQUIDO
                      , VAL_BASE_IR
                      , VAL_IR_RET
                      , DED_BASE_IR
                      , DED_IR_OJ
                      , DED_IR_DOENCA
                      , DED_IR_PA
                      , FLG_PAG
                      , FLG_IND_PAGO
                      , FLG_IND_ULTIMO_PAG
                      , TOT_CRED_PAG
                      , TOT_DEB_PAG
                      , VAL_LIQUIDO_PAG
                      , VAL_BASE_IR_PAG
                      , VAL_IR_RET_PAG
                      , VAL_BASE_IR_13
                      , VAL_IR_13_RET
                      , VAL_BASE_IR_13_PAG
                      , VAL_BASE_IR_13_RET_PAG
                      , VAL_BASE_ISENCAO
                      , IND_PROCESSO
                      , COD_BANCO
                      , NUM_AGENCIA
                      , NUM_DV_AGENCIA
                      , NUM_CONTA
                      , NUM_DV_CONTA
                      , COD_TIPO_CONTA
                      , VAL_BASE_PREV
                      , FLG_IND_CHEQ
                      , FLG_IND_ANALISE
                      , MARGEM_CONSIG
                      , DAT_PAGAMENTO
                      , DAT_INGRESSO
                      , VAL_BASE_IR_ACUM
                      , COD_DISSOCIACAO
                      , DAT_ING
                      , DAT_ULT_ATU
                      , NOM_USU_ULT_ATU
                      , NOM_PRO_ULT_ATU
                      , VAL_BASE_IR_ISENTO
                      , TOT_DEP_IR
                      , TOT_DEP_SF
                      , NOM_CARGO
                      , COD_CARGO
                      , NUM_DEP_IR							
											)
                 SELECT COD_INS
                      , TIP_PROCESSO
                      , PER_PROCESSO
                      , SEQ_PAGAMENTO
                      , COD_IDE_CLI
                      , NUM_CPF
                      , COD_ENTIDADE
                      , NUM_MATRICULA
                      , COD_IDE_REL_FUNC
                      , NUM_GRP
                      , NOME
                      , COD_IDE_TUTOR
                      , NOM_TUTOR
                      , DAT_PROCESSO
                      , VAL_SAL_BASE
                      , TOT_CRED
                      , TOT_DEB
                      , VAL_LIQUIDO
                      , VAL_BASE_IR
                      , VAL_IR_RET
                      , DED_BASE_IR
                      , DED_IR_OJ
                      , DED_IR_DOENCA
                      , DED_IR_PA
                      , FLG_PAG
                      , FLG_IND_PAGO
                      , FLG_IND_ULTIMO_PAG
                      , TOT_CRED_PAG
                      , TOT_DEB_PAG
                      , VAL_LIQUIDO_PAG
                      , VAL_BASE_IR_PAG
                      , VAL_IR_RET_PAG
                      , VAL_BASE_IR_13
                      , VAL_IR_13_RET
                      , VAL_BASE_IR_13_PAG
                      , VAL_BASE_IR_13_RET_PAG
                      , VAL_BASE_ISENCAO
                      , IND_PROCESSO
                      , COD_BANCO
                      , NUM_AGENCIA
                      , NUM_DV_AGENCIA
                      , NUM_CONTA
                      , NUM_DV_CONTA
                      , COD_TIPO_CONTA
                      , VAL_BASE_PREV
                      , FLG_IND_CHEQ
                      , FLG_IND_ANALISE
                      , MARGEM_CONSIG
                      , REG.DAT_PAG_EFETIVA AS DAT_PAGAMENTO
                      , DAT_INGRESSO
                      , VAL_BASE_IR_ACUM
                      , COD_DISSOCIACAO
                      , DAT_ING
                      , SYSDATE       AS DAT_ULT_ATU
                      , P_NOM_USUARIO AS NOM_USU_ULT_ATU
                      , 'PAC_FECHAMENTO_PER' AS NOM_PRO_ULT_ATU
                      , VAL_BASE_IR_ISENTO
                      , TOT_DEP_IR
                      , TOT_DEP_SF
                      , NOM_CARGO
                      , COD_CARGO
                      , NUM_DEP_IR
                  FROM TB_FOLHA_PAGAMENTO HP

                 WHERE HP.COD_INS       = P_COD_INS
                   AND HP.TIP_PROCESSO  = P_TIP_PROCESSO
                   AND HP.PER_PROCESSO  = P_PER_PROCESSO
                   AND HP.SEQ_PAGAMENTO = P_SEQ_PAGAMENTO
                   AND HP.NUM_GRP       = REG.NUM_GRP


                     ;

                  INSERT INTO TB_HFOLHA_PAGAMENTO_DET
                       (COD_INS
                       , TIP_PROCESSO
                       , PER_PROCESSO
                       , COD_IDE_CLI
                       , COD_IDE_CLI_BEN
                       , COD_ENTIDADE
                       , NUM_MATRICULA
                       , COD_IDE_REL_FUNC
                       , SEQ_PAGAMENTO
                       , COD_FCRUBRICA
                       , SEQ_VIG
                       , VAL_RUBRICA
                       , NUM_QUOTA
                       , TOT_QUOTA
                       , VAL_RUBRICA_CHEIO
                       , VAL_UNIDADE
                       , VAL_PORC
                       , DAT_INI_REF
                       , DAT_FIM_REF
                       , FLG_NATUREZA
                       , NUM_ORD_JUD
                       , SEQ_DETALHE
                       , DES_INFORMACAO
                       , DES_COMPLEMENTO
                       , FLG_IR_ACUMULADO
                       , NUM_CARGA
                       , NUM_SEQ_CONTROLE_CARGA
                       , DAT_ING
                       , DAT_ULT_ATU
                       , NOM_USU_ULT_ATU
                       , NOM_PRO_ULT_ATU
                       , DAT_PAGAMENTO
											 , flg_log_calc             
                       ,  cod_formula_cond         
                       ,  des_condicao             
                       ,  cod_formula_rubrica      
                       ,  des_formula              
                       ,  des_composicao
											 
                       )
                  SELECT FD.COD_INS
                       , FD.TIP_PROCESSO
                       , FD.PER_PROCESSO
                       , FD.COD_IDE_CLI
                       , FD.COD_IDE_CLI_BEN
                       , FD.COD_ENTIDADE
                       , FD.NUM_MATRICULA
                       , FD.COD_IDE_REL_FUNC
                       , FD.SEQ_PAGAMENTO
                       , FD.COD_FCRUBRICA
                       , FD.SEQ_VIG
                       , FD.VAL_RUBRICA
                       , FD.NUM_QUOTA
                       , FD.TOT_QUOTA
                       , FD.VAL_RUBRICA_CHEIO
                       , FD.VAL_UNIDADE
                       , FD.VAL_PORC
                       , FD.DAT_INI_REF
                       , FD.DAT_FIM_REF
                       , FD.FLG_NATUREZA
                       , FD.NUM_ORD_JUD
                       , FD.SEQ_DETALHE
                       , FD.DES_INFORMACAO
                       , FD.DES_COMPLEMENTO
                       , FD.FLG_IR_ACUMULADO
                       , FD.NUM_CARGA
                       , FD.NUM_SEQ_CONTROLE_CARGA
                       , FD.DAT_ING
                       , SYSDATE              AS DAT_ULT_ATU
                       , P_NOM_USUARIO        AS NOM_USU_ULT_ATU
                       , 'PAC_FECHAMENTO_PER' AS NOM_PRO_ULT_ATU
                       , REG.DAT_PAG_EFETIVA  AS DAT_PAGAMENTO
										   ,  flg_log_calc   -- roberto - 25-03-2024            
                       ,  cod_formula_cond         
                       ,  des_condicao             
                       ,  cod_formula_rubrica      
                       ,  des_formula              
                       ,  des_composicao									
											 
                    FROM TB_FOLHA_PAGAMENTO_DET FD
                       , TB_FOLHA_PAGAMENTO     FO

                   WHERE FO.COD_INS          = P_COD_INS
                     AND FO.TIP_PROCESSO     = P_TIP_PROCESSO
                     AND FO.PER_PROCESSO     = P_PER_PROCESSO
                     AND FO.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
                     AND FO.NUM_GRP          = REG.NUM_GRP


                     AND FO.COD_INS          = FD.COD_INS
                     AND FO.TIP_PROCESSO     = FD.TIP_PROCESSO
                     AND FO.PER_PROCESSO     = FD.PER_PROCESSO
                     AND FO.SEQ_PAGAMENTO    = FD.SEQ_PAGAMENTO
                     AND FO.COD_IDE_CLI      = FD.COD_IDE_CLI
                     AND FO.COD_ENTIDADE     = FD.COD_ENTIDADE
                     AND FO.NUM_MATRICULA    = FD.NUM_MATRICULA
                     AND FO.COD_IDE_REL_FUNC = FD.COD_IDE_REL_FUNC
                    ;
                    
                  UPDATE TB_HFOLHA_PAGAMENTO H
              --      SET H.DES_OBS_PAG = ticket 92894 - 24/09/2024 - Req.Rose
                    SET H.DESC_MENSAGEM =
                    (SELECT  DESC_MENSAGEM
                         FROM   (                                        
                         SELECT  TB1.DESC_MENSAGEM
                          FROM 
                            (SELECT  C1.DESC_MENSAGEM
                                   FROM TB_MENSAGEM_CTR  C1                                   
                                  WHERE H.COD_INS          = H.COD_INS
                                    AND C1.TIP_FOLHA        = H.TIP_PROCESSO
                                    AND NAT_MENSAGEM     = 'I'                                                    
                                    AND C1.COD_FUNCAO    =  2
                                    AND C1.NUM_PRIORIDADE = 2
                                    AND C1.COD_GRUPO_PAG = H.NUM_GRP
                                    AND C1.FLG_STATUS    = 'V'
                                    AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                       ORDER
                          BY C1.NUM_PRIORIDADE) TB1 
                       UNION 
                       SELECT  TB1.DESC_MENSAGEM  -- mensagem Geral
                       FROM          
                       (SELECT  C1.DESC_MENSAGEM
                                   FROM TB_MENSAGEM_CTR  C1                                  
                                  WHERE H.COD_INS        = H.COD_INS
                                    AND C1.TIP_FOLHA     = H.TIP_PROCESSO
                                    AND NAT_MENSAGEM     = 'G'                                                    
                                    AND C1.COD_FUNCAO    =  2
                                    AND C1.NUM_PRIORIDADE = 2
                                    AND C1.COD_GRUPO_PAG = H.NUM_GRP
                                    AND C1.FLG_STATUS    = 'V'
                                    AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                       ORDER
                         BY C1.NUM_PRIORIDADE
                          ) TB1
                       UNION
                            SELECT  TB1.DESC_MENSAGEM  -- mensagem 
                            FROM 
                            (SELECT  C1.DESC_MENSAGEM
                                   FROM TB_MENSAGEM_CTR  C1                                   
                                  WHERE H.COD_INS        = H.COD_INS
                                    AND TIP_FOLHA        = H.TIP_PROCESSO
                                    AND NAT_MENSAGEM     = 'G'                                                    
                                    AND C1.COD_FUNCAO    =  2
                                    AND C1.NUM_PRIORIDADE = 1
                                    AND C1.COD_GRUPO_PAG = H.NUM_GRP
                                    AND C1.FLG_STATUS    = 'V'
                                    AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                       ORDER
                          BY C1.NUM_PRIORIDADE) TB1
                        UNION
                         SELECT  TB1.DESC_MENSAGEM  -- Aniversariante 
                         FROM  
                         (SELECT  C1.DESC_MENSAGEM
                                   FROM TB_MENSAGEM_CTR  C1                                
                                  WHERE H.COD_INS        = H.COD_INS
                                    AND TIP_FOLHA        = H.TIP_PROCESSO
                                    AND NAT_MENSAGEM     = 'G'                                                    
                                    AND C1.COD_FUNCAO    =  1
                                    AND C1.NUM_PRIORIDADE = 2
                                    AND C1.COD_GRUPO_PAG = H.NUM_GRP
                                    AND C1.FLG_STATUS    = 'V'
                                    AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                       ORDER
                          BY C1.NUM_PRIORIDADE) TB1   
                       UNION
                       SELECT  TB1.DESC_MENSAGEM
                       FROM 
                       (SELECT  C1.DESC_MENSAGEM
                                   FROM TB_MENSAGEM_CTR  C1                                      
                                  WHERE H.COD_INS          = H.COD_INS
                                    AND TIP_FOLHA          = H.TIP_PROCESSO
                                    AND NAT_MENSAGEM       = 'G'                                                    
                                    AND C1.COD_FUNCAO      =  2
                                    AND C1.NUM_PRIORIDADE  =  1
                                    AND C1.COD_GRUPO_PAG = H.NUM_GRP
                                    AND C1.FLG_STATUS    = 'V'
                                    AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                       ORDER
                          BY C1.NUM_PRIORIDADE) TB1                                                                            
                                    
                        )) 
                    WHERE H.COD_INS       = P_COD_INS
                    AND   H.TIP_PROCESSO  = P_TIP_PROCESSO
                    AND   H.PER_PROCESSO  = P_PER_PROCESSO
                    AND   H.NUM_GRP       = REG.NUM_GRP;
                    
                    
                    
      UPDATE TB_HFOLHA_PAGAMENTO H -- Mensagem Indivudual
             SET H.DESC_MENSAGEM =  
      (
       SELECT  TB1.DESC_MENSAGEM
       FROM (SELECT C1.DESC_MENSAGEM
          FROM TB_MENSAGEM_CTR C1
          JOIN TB_MENSAGEM_BENEFICIARIOS M ON M.DAT_INI_VIGENCIA = C1.DAT_INI_VIG  
          AND M.DAT_FIM_VIGENCIA = C1.DAT_FIM_VIG 
          WHERE C1.COD_INS = H.COD_INS
            AND C1.TIP_FOLHA = H.TIP_PROCESSO
            AND C1.NAT_MENSAGEM = 'I'
            AND C1.COD_FUNCAO = 2
             AND C1.NUM_PRIORIDADE  = 2
            AND C1.COD_GRUPO_PAG = H.NUM_GRP
            AND C1.FLG_STATUS = 'V'
            AND C1.NUM_MENSAGEM = M.NUM_MENSAGEM
            AND M.COD_IDE_CLI = H.COD_IDE_CLI
            AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
          ORDER BY C1.NUM_PRIORIDADE  
          ) TB1
     )
        WHERE H.COD_INS       = P_COD_INS
            AND   H.TIP_PROCESSO  = P_TIP_PROCESSO
            AND   H.PER_PROCESSO  = P_PER_PROCESSO
            AND   H.NUM_GRP       = REG.NUM_GRP; 
            
            
/*   
   FOR ANI IN ( -- aniversário
          SELECT DISTINCT  C1.DESC_MENSAGEM,P.COD_IDE_CLI,H.PER_PROCESSO
          FROM TB_MENSAGEM_CTR C1,TB_HFOLHA_PAGAMENTO H,
          TB_PESSOA_FISICA  P
                 
          WHERE C1.COD_INS = H.COD_INS
            AND C1.TIP_FOLHA = H.TIP_PROCESSO
            AND NAT_MENSAGEM     = 'G'                                                    
            AND C1.COD_FUNCAO    =  1
            AND C1.NUM_PRIORIDADE = 2
            AND C1.FLG_STATUS = 'V'
            AND P.DAT_NASC     BETWEEN     C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
            AND H.PER_PROCESSO BETWEEN     C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
          ORDER BY C1.NUM_PRIORIDADE  
          )LOOP
          
          
                             
         UPDATE TB_HFOLHA_PAGAMENTO H -- Aniversariante
             SET   H.DESC_MENSAGEM =  ANI.DESC_MENSAGEM
             WHERE H.COD_IDE_CLI =  ANI.COD_IDE_CLI
             AND   H.PER_PROCESSO = H.PER_PROCESSO;
                 
         END LOOP;  */  
            
   /*   UPDATE TB_HFOLHA_PAGAMENTO H -- Aniversariante 
      SET H.DESC_MENSAGEM =  
      (
       SELECT  TB1.DESC_MENSAGEM
       FROM (SELECT C1.DESC_MENSAGEM
          FROM TB_MENSAGEM_CTR C1
          JOIN TB_MENSAGEM_BENEFICIARIOS M ON M.DAT_INI_VIGENCIA = C1.DAT_INI_VIG  
          JOIN TB_PESSOA_FISICA          P ON TO_CHAR(P.DAT_NASC,'MM') = TO_CHAR(SYSDATE,'MM')             
          AND M.DAT_FIM_VIGENCIA = C1.DAT_FIM_VIG 
          WHERE C1.COD_INS = H.COD_INS
            AND C1.TIP_FOLHA = H.TIP_PROCESSO
            AND NAT_MENSAGEM     = 'G'                                                    
            AND C1.COD_FUNCAO    =  1
            AND C1.NUM_PRIORIDADE = 2
            AND C1.FLG_STATUS = 'V'
            AND C1.NUM_MENSAGEM = M.NUM_MENSAGEM
            AND M.COD_IDE_CLI = H.COD_IDE_CLI
            AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
          ORDER BY C1.NUM_PRIORIDADE  
          ) TB1
     )
        WHERE H.COD_INS       = P_COD_INS
            AND   H.TIP_PROCESSO  = P_TIP_PROCESSO
            AND   H.PER_PROCESSO  = P_PER_PROCESSO
            AND   H.NUM_GRP       = REG.NUM_GRP; */
            
            
            
            
                                
     
/*                UPDATE TB_HFOLHA_PAGAMENTO H
              --      SET H.DES_OBS_PAG = ticket 92894 - 24/09/2024 - Req.Rose
                    SET H.DESC_MENSAGEM =  
                    NVL((SELECT TB1.DESC_MENSAGEM
                                           FROM   (SELECT C1.DESC_MENSAGEM
                                                     FROM TB_MENSAGEM_CTR  C1
                                                    WHERE COD_INS          = H.COD_INS
                                                      AND TIP_FOLHA        = H.TIP_PROCESSO
                                                      AND NAT_MENSAGEM     = 'G'
                                                      AND C1.COD_FUNCAO    = 2
                                                      AND C1.COD_GRUPO_PAG = H.NUM_GRP
                                                      AND C1.FLG_STATUS    = 'V'
                                                      AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                                         ORDER
                                            BY C1.NUM_PRIORIDADE) TB1
                                       UNION
                                           SELECT TB1.DESC_MENSAGEM
                                           FROM   (SELECT C1.DESC_MENSAGEM
                                                     FROM TB_MENSAGEM_CTR  C1
                                                    WHERE COD_INS       = 1
                                                      AND TIP_FOLHA     = 'N'
                                                      AND NAT_MENSAGEM  = 'G'
                                                      AND C1.COD_FUNCAO = 2
                                                      AND C1.COD_GRUPO_PAG IS NULL
                                                      AND C1.FLG_STATUS    = 'V'
                                                      AND H.PER_PROCESSO BETWEEN C1.DAT_INI_VIG AND C1.DAT_FIM_VIG
                                                      AND NOT EXISTS (SELECT 1
                                                                        FROM TB_MENSAGEM_CTR  C2
                                                                       WHERE C2.COD_INS       = C1.COD_INS
                                                                         AND C2.TIP_FOLHA     = C1.TIP_FOLHA
                                                                         AND C2.NAT_MENSAGEM  = C1.NAT_MENSAGEM
                                                                         AND C2.COD_GRUPO_PAG = NUM_GRP
                                                                         AND C2.FLG_STATUS    = 'V'
                                                                         AND H.PER_PROCESSO BETWEEN C2.DAT_INI_VIG AND C2.DAT_FIM_VIG
                                                                         )
                                                   ORDER
                                                      BY C1.NUM_PRIORIDADE) TB1
                                          WHERE ROWNUM = 1), H.DES_OBS_PAG)
                  WHERE H.COD_INS      = P_COD_INS
                    AND H.TIP_PROCESSO = P_TIP_PROCESSO
                    AND H.PER_PROCESSO = P_PER_PROCESSO
                    AND H.NUM_GRP      = REG.NUM_GRP
                    ;*/


       END LOOP;

       IF (EXISTE_REGISTRO) THEN

         UPDATE TB_PERIODOS_PROCESSAMENTO PP
            SET PP.DAT_FECHAMENTO   = TRUNC(SYSDATE)
              , PP.FLG_STATUS       = 'F'
              , PP.DAT_ULT_ATU      = SYSDATE
              , PP.NOM_USU_ULT_ATU  = P_NOM_USUARIO
              , PP.NOM_PRO_ULT_ATU  = 'PAC_FECHAMENTO_PER'
          WHERE PP.COD_INS          = P_COD_INS
            AND PP.COD_TIP_PROCESSO = P_TIP_PROCESSO
            AND PP.PER_PROCESSO     = P_PER_PROCESSO
            AND PP.SEQ_PAGAMENTO    = P_SEQ_PAGAMENTO
            ;

       ELSE

          RAISE_APPLICATION_ERROR( -20001, 'N?o foi executada a ac?o porque n?o existe folha aberta para os parametros inseridos. Periodo: ' || P_PER_PROCESSO || ' Tipo de Processo: ' || P_TIP_PROCESSO);

       END IF;


       COMMIT;

    EXCEPTION
       WHEN OTHERS THEN
            P_MSG_ERRO := SQLERRM;
    END SP_FECHA_PERIODO;

  FUNCTION  SP_VALIDA_MSG_CONTRA_CHEQUE( I_COD_INS         IN NUMBER ,
                                           I_DAT_INI_VIG     IN DATE   ,
                                           I_DAT_FIM_VIG     IN DATE   ,
                                           I_TIP_FOLHA       IN VARCHAR,
                                           I_COD_GRUPO_PAG   IN NUMBER ,
                                           I_NAT_MENSAGEM    IN VARCHAR,
                                           I_NUM_PRIORIDADE  IN NUMBER ,
                                           I_COD_FUNCAO      IN NUMBER,
                                           O_GLS_ERRO        OUT VARCHAR
                                         ) RETURN VARCHAR2  AS
     V_QTD_CONCOMIT NUMBER;
    BEGIN



      SELECT COUNT(1)
        INTO V_QTD_CONCOMIT
        FROM  TB_MENSAGEM_CTR A
       WHERE A.COD_INS = I_COD_INS
         AND (A.DAT_INI_VIG BETWEEN I_DAT_INI_VIG AND NVL(I_DAT_FIM_VIG,A.DAT_INI_VIG+1) OR
              A.DAT_FIM_VIG BETWEEN I_DAT_INI_VIG AND NVL(I_DAT_FIM_VIG,A.DAT_FIM_VIG+1) OR
              (A.DAT_INI_VIG < I_DAT_INI_VIG AND A.DAT_FIM_VIG > I_DAT_FIM_VIG)
             )
          AND A.TIP_FOLHA =  I_TIP_FOLHA
          AND NVL(A.COD_GRUPO_PAG,99999999999) = NVL(I_COD_GRUPO_PAG,99999999999)
          AND A.NAT_MENSAGEM = I_NAT_MENSAGEM
          AND A.NUM_PRIORIDADE = I_NUM_PRIORIDADE
          AND A.COD_FUNCAO = I_COD_FUNCAO;

       IF V_QTD_CONCOMIT > 0 THEN
         O_GLS_ERRO :='Ja existe mensagem nessa configurac?o com data concomitante.';
         RETURN 'N';
       ELSE
         O_GLS_ERRO :=NULL;
         RETURN 'S';
       END IF;

    EXCEPTION
      WHEN OTHERS THEN
        O_GLS_ERRO :='ERRO GERAL NA VALIDACAO DA MSG - '||SQLERRM;
        RETURN 'N';
    END SP_VALIDA_MSG_CONTRA_CHEQUE;

 END PAC_FECHAMENTO_PERIODO;
/
