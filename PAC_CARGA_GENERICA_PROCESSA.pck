CREATE OR REPLACE PACKAGE "PAC_CARGA_GENERICA_PROCESSA"
AS
  i_cod_entidade number;

  FUNCTION FNC_VALIDA_DATA (I_DATA    IN VARCHAR2,I_FORMATO IN VARCHAR2 DEFAULT 'AAAAMMDD') RETURN DATE;
  PROCEDURE SP_CARREGA_HFE(I_ID_HEADER NUMBER);
  PROCEDURE SP_CARREGA_EVF (I_ID_HEADER IN NUMBER);
  PROCEDURE SP_ATUALIZA_DATA_FINAL(P_COD_IDE_CLI VARCHAR2);
  PROCEDURE SP_ATUAL_DT_ADMISSAO(p_num_matricula VARCHAR2);
END PAC_CARGA_GENERICA_PROCESSA;
/
CREATE OR REPLACE PACKAGE BODY "PAC_CARGA_GENERICA_PROCESSA"
AS





    PROCEDURE SP_GRAVA_ERRO(I_ID_HEADER       IN TB_CARGA_GEN_ERRO.ID_HEADER%TYPE,
                            I_ID_PROCESSO     IN TB_CARGA_GEN_HEADER.ID_PROCESSO%TYPE,
                            I_NUM_LINHA       IN TB_CARGA_GEN_ERRO.NUM_LINHA_HEADER%TYPE,
                            I_NOM_PRO_ULT_ATU IN TB_CARGA_GEN_ERRO.NOM_PRO_ULT_ATU%TYPE,
                            I_DES_ERRO        IN TB_CARGA_GEN_ERRO.DES_ERRO%TYPE,
                            I_DES_CHAVE       IN TB_CARGA_GEN_ERRO.DES_CHAVE%TYPE ) IS

        V_DES_CAMPO_INTER TB_CARGA_GEN_DEPARA_ARQUIVO.DES_CAMPO_INTER%TYPE;
        V_NOM_CAMPO_INTER TB_CARGA_GEN_DEPARA_ARQUIVO.DES_CAMPO_INTER%TYPE;
        V_DES_ERRO        VARCHAR2(4000);
        V_ID_LOG_ERRO NUMBER;

    BEGIN

            INSERT INTO TB_CARGA_GEN_ERRO
                (ID,
                 ID_HEADER,
                 NUM_LINHA_HEADER,
                 NOM_CAMPO_ERRO,
                 COD_FASE_PROCESSO,
                 DES_ERRO,
                 DAT_PROCESSAMENTO,
                 NOM_USU_ULT_ATU,
                 NOM_PRO_ULT_ATU,
                 DES_CHAVE,
                 DAT_ING,
                 DAT_ULT_ATU)
            VALUES
                (SEQ_CARGA_GEN_ERRO.NEXTVAL,
                 I_ID_HEADER,
                 I_NUM_LINHA,
                 NULL,
                 '2',
                 SUBSTR(I_DES_ERRO, 1, 4000),
                 SYSDATE,
                 USER,
                 I_NOM_PRO_ULT_ATU,
                 I_DES_CHAVE,
                 SYSDATE,
                 SYSDATE );

      COMMIT;
    END SP_GRAVA_ERRO;

    FUNCTION FNC_GRAVA_STATUS_PROCESSAMENTO (I_NOM_TABELA IN VARCHAR2,
                                             I_ID_REGISTRO IN NUMBER,
                                             I_COD_STATUS_PROCESSAMENTO IN VARCHAR2,
                                             I_OBS_PROCESSAMENTO IN VARCHAR2,
                                             I_NOM_PRO_ULT_ATU IN VARCHAR2) RETURN VARCHAR2 IS

    V_ID_LOG_ERRO NUMBER;
    V_CMD VARCHAR2(4000);
    V_DES_ERRO VARCHAR2(4000);

    BEGIN
        V_CMD := 'update ' || I_NOM_TABELA ||
                          ' set COD_STATUS_PROCESSAMENTO = '''||I_COD_STATUS_PROCESSAMENTO||''','||
                              ' DAT_PROCESSAMENTO = sysdate,'||
                              ' OBS_PROCESSAMENTO = substr('''||NVL(I_OBS_PROCESSAMENTO,'Processamento realizado com sucesso')||''', 1, 2000),'||
                              ' NOM_USU_ULT_ATU = user,'||
                              ' NOM_PRO_ULT_ATU = '''||I_NOM_PRO_ULT_ATU||''''||
                          ' where id = '||I_ID_REGISTRO;

        EXECUTE IMMEDIATE V_CMD;

        COMMIT;
        RETURN 'TRUE';



    EXCEPTION
        WHEN OTHERS THEN
            V_DES_ERRO := SQLERRM;
            RETURN 'FALSE';


    END FNC_GRAVA_STATUS_PROCESSAMENTO;
    FUNCTION FNC_VALIDA_PESSOA_FISICA (I_COD_INS   IN TB_PESSOA_FISICA.COD_INS%TYPE,
                                       I_IDE_CLI   IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE ,
                                       I_ID_SERVIDOR IN TB_CARGA_GEN_IDENT_EXT.COD_IDE_CLI_EXT%TYPE
                                      ) RETURN CHAR

    AS
      V_QTD_BENEFICIOS NUMBER;
      V_RETORNO  VARCHAR2(2000) := NULL;
    BEGIN


      SELECT COUNT(1)
        INTO V_QTD_BENEFICIOS
        FROM TB_CONCESSAO_BENEFICIO CB
       WHERE CB.COD_INS = I_COD_INS
         AND CB.COD_IDE_CLI_SERV = I_IDE_CLI
        and CB.NUM_MATRICULA = I_ID_SERVIDOR;

      IF V_QTD_BENEFICIOS > 0 THEN
         V_RETORNO := 'BENEFICIO';
    /*  ELSE
        SELECT COUNT(1)
          INTO V_QTD_BENEFICIOS
          FROM TB_BENEFICIARIO BEN
         WHERE BEN.COD_INS = I_COD_INS
           AND BEN.COD_IDE_CLI_BEN = I_IDE_CLI;

         IF V_QTD_BENEFICIOS > 0 THEN
           V_RETORNO := 'BENEFICIO';
         END IF;     */
      END IF;

      RETURN (V_RETORNO);
     EXCEPTION
      WHEN OTHERS THEN
        RETURN (SUBSTR(SQLERRM, 1, 2000));
     END;
     FUNCTION FNC_RET_COD_IDE_CLI(I_COD_INS     IN TB_CARGA_GEN_IDENT_EXT.COD_INS%TYPE,
                                  I_TIPO        IN NUMBER,
                                  I_ID_SERVIDOR IN TB_CARGA_GEN_IDENT_EXT.COD_IDE_CLI_EXT%TYPE
                                  ) RETURN VARCHAR2
     AS
       V_COD_IDE_CLI TB_PESSOA_FISICA.COD_IDE_CLI%TYPE;
BEGIN
/*
    SELECT Max(COD_IDE_CLI)
          INTO V_COD_IDE_CLI
          FROM TB_CARGA_GEN_IDENT_EXT
          WHERE COD_INS         = I_COD_INS
          AND COD_IDE_CLI_EXT = I_ID_SERVIDOR;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RETURN (NULL);
          END;
          */

          IF I_TIPO = 1 THEN  -- EXECUTA HFE
          BEGIN
            SELECT  F.COD_IDE_CLI INTO V_COD_IDE_CLI  FROM TB_CARGA_GEN_IFS  I
            INNER  JOIN TB_PESSOA_FISICA F ON F.NUM_CPF = I.NUM_CPF
            INNER  JOIN TB_CARGA_GEN_HFE H ON H.ID_SERVIDOR = I.ID_SERVIDOR
            WHERE  I.ID_SERVIDOR = I_ID_SERVIDOR
              AND  ROWNUM = 1 ;
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RETURN (NULL);
          END;

          ELSE

          BEGIN
            SELECT R.COD_IDE_CLI
            INTO V_COD_IDE_CLI
            FROM TB_RELACAO_FUNCIONAL R
            WHERE COD_INS         = I_COD_INS
            AND R.COD_ENTIDADE    = i_cod_entidade--29
            AND R.NUM_MATRICULA = I_ID_SERVIDOR
            AND ROWNUM = 1;
            EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RETURN (NULL);
            END;
          END IF;



          RETURN V_COD_IDE_CLI;
     EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RETURN (NULL);
         --  RAISE_APPLICATION_ERROR(-20000, 'Não foi possivel identificar o codigo externo para o servidor');
     END FNC_RET_COD_IDE_CLI;

    FUNCTION FNC_VALIDA_DATA (I_DATA    IN VARCHAR2,
                              I_FORMATO IN VARCHAR2 DEFAULT 'AAAAMMDD') RETURN DATE IS

        V_DATA_CONV DATE;

    BEGIN

        V_DATA_CONV := TO_DATE(I_DATA, I_FORMATO);

        RETURN (V_DATA_CONV);

    EXCEPTION

        WHEN OTHERS THEN
            RETURN (NULL);

    END FNC_VALIDA_DATA;


   PROCEDURE SP_ATUALIZA_HEADER (I_ID_HEADER       IN NUMBER,
                                 I_NOM_PRO_ULT_ATU IN VARCHAR2,
                                 I_DES_ERRO        IN VARCHAR2) IS

        V_QTD_AGUARDANDO        NUMBER := 0;
        V_QTD_PROCESSANDO       NUMBER := 0;
        V_QTD_PROCESSADO_OK     NUMBER := 0;
        V_QTD_PROCESSADO_ERRO   NUMBER := 0;
        V_MAX_DAT_PROCESSAMENTO DATE;
        V_STATUS_HEADER         NUMBER := 0;
        V_QUERY                 VARCHAR2(4000);
        V_ID_LOG_ERRO           NUMBER;


    BEGIN


      UPDATE TB_CARGA_GEN_HEADER
         SET DAT_PROCESSAMENTO        = SYSDATE,
             COD_STATUS_PROCESSAMENTO = 4,
             DAT_ULT_ATU              = SYSDATE,
             NOM_USU_ULT_ATU          = USER,
             NOM_PRO_ULT_ATU          = I_NOM_PRO_ULT_ATU,
             DES_OBSERVACAO           = I_DES_ERRO
        WHERE ID = I_ID_HEADER;

   EXCEPTION
        WHEN OTHERS THEN
          UPDATE TB_CARGA_GEN_HEADER
             SET DAT_PROCESSAMENTO        = SYSDATE,
                 COD_STATUS_PROCESSAMENTO = 4,
                 DAT_ULT_ATU              = SYSDATE,
                 NOM_USU_ULT_ATU          = USER,
                 NOM_PRO_ULT_ATU          = I_NOM_PRO_ULT_ATU,
                 DES_OBSERVACAO           = 'Erro em SP_ATUALIZA_HEADER - Não foi possível inserir detalhe do erro'
            WHERE ID = I_ID_HEADER;

   END SP_ATUALIZA_HEADER;


   PROCEDURE SP_BUSCA_DADOS_PROCESSO(I_ID_HEADER           IN     TB_CARGA_GEN_ERRO.ID_HEADER%TYPE,
                                      O_FLG_ACAO_POSTERGADA IN OUT TB_CARGA_GEN_PROCESSO.FLG_ACAO_POSTERGADA%TYPE,
                                      O_COD_SITU_OCORRENCIA IN OUT TB_CARGA_GEN_LOG.COD_SITU_OCORRENCIA%TYPE,
                                      V_RESULT              IN OUT VARCHAR2) IS

        V_ID_PROCESSO TB_CARGA_GEN_HEADER.ID_PROCESSO%TYPE;
        V_ERRO_TMP VARCHAR2(100);

    BEGIN

        V_ERRO_TMP := 'Erro ao acessar dados do header';

        SELECT ID_PROCESSO
        INTO V_ID_PROCESSO
        FROM TB_CARGA_GEN_HEADER
        WHERE ID = I_ID_HEADER;

        V_ERRO_TMP := 'Erro ao acessar dados do processo';

        SELECT FLG_ACAO_POSTERGADA
        INTO O_FLG_ACAO_POSTERGADA
        FROM TB_CARGA_GEN_PROCESSO
        WHERE ID = V_ID_PROCESSO;

        V_ERRO_TMP := 'Erro ao definir cod_situ_ocorrencia';

        SELECT DECODE(NVL(O_FLG_ACAO_POSTERGADA, '1'), '0', 'R', 'S')
        INTO O_COD_SITU_OCORRENCIA
        FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_RESULT := SUBSTR(V_ERRO_TMP||': '||SQLERRM, 1, 2000);

    END SP_BUSCA_DADOS_PROCESSO;




    PROCEDURE SP_EXEC_CARREGA_HFE (I_ID_HEADER           IN TB_CARGA_GEN_HEADER.ID%TYPE,
                                  I_FLG_ACAO_POSTERGADA  IN TB_CARGA_GEN_PROCESSO.FLG_ACAO_POSTERGADA%TYPE,
                                  O_COD_ERRO             OUT NUMBER,
                                  O_DES_ERRO             OUT VARCHAR2
                                  ) IS

        V_RESULT                        VARCHAR2(4000);
        V_CUR_ID                        TB_CARGA_GEN_HFE.ID%TYPE;
        V_COD_TIPO_OCORRENCIA           TB_CARGA_GEN_LOG.COD_TIPO_OCORRENCIA%TYPE;

        V_NOM_ROTINA                    VARCHAR2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_HFE';
        V_NOM_TABELA                    VARCHAR2(100) := 'TB_CARGA_GEN_HFE';
        V_LINHA_TB_RELACAO_FUNCIONAL    TB_RELACAO_FUNCIONAL%ROWTYPE;
        V_LIN_TB_REL_FUNC_PERIODO_EXER  TB_REL_FUNC_PERIODO_EXERC%ROWTYPE;
        V_COD_PCCS                      TB_PCCS.COD_PCCS%TYPE;
        V_ID_LOG_ERRO                   NUMBER;
        V_MSG_ERRO                      VARCHAR2(4000);
        V_COD_ERRO                      NUMBER;
        V_VLR_ITERACAO                  NUMBER := 20;
        V_COD_ENTIDADE                  TB_CARGA_GEN_HFE.COD_ENTIDADE%TYPE;
        V_ID_SERVIDOR                   TB_CARGA_GEN_HFE.ID_SERVIDOR%TYPE;
        V_COD_IDE_REL_FUNC              TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC%TYPE;
        V_COD_IDE_CLI                   TB_RELACAO_FUNCIONAL.COD_IDE_CLI%TYPE;
        V_DATA_INI_EXERC                DATE;
        V_DATA_FIM_EXERC                DATE;
        V_DATA_FIM_EXERC_LOT            DATE;
        V_COD_ORGAO                    TB_ORGAO.COD_ORGAO%TYPE;
        V_QTD_LOTACAO                  NUMBER;
        V_DAT_INI_LOTACAO              DATE;
        V_DAT_FIM_LOTACAO              DATE;
        ERRO_REG                       EXCEPTION;
        ERRO_GRAVA_STATUS              EXCEPTION;
    BEGIN



    FOR HFE IN (SELECT A.COD_INS                                                                    AS COD_INS,
                       A.ID_HEADER                                                                  AS ID_HEADER,
                       TRIM(A.COD_ENTIDADE)                                                         AS COD_ENTIDADE,
                       LAG (A.COD_ENTIDADE,1) OVER (PARTITION BY ID_SERVIDOR,ID_VINCULO
                                                        ORDER BY DAT_INI_EXERC)                     AS COD_ENTIDADE_ANT,
                       TRIM(A.ID_SERVIDOR)                                                          AS ID_SERVIDOR,
                       LAG (A.ID_SERVIDOR,1) OVER (PARTITION BY  ID_SERVIDOR,ID_VINCULO
                                                       ORDER BY DAT_INI_EXERC)                      AS ID_SERVIDOR_ANT,
                       TRIM(A.ID_VINCULO)                                                           AS ID_VINCULO,
                       LAG (A.ID_VINCULO,1) OVER (PARTITION BY  ID_SERVIDOR,ID_VINCULO
                                                      ORDER BY DAT_INI_EXERC)                       AS ID_VINCULO_ANT,
                       TRIM(A.COD_CARGO)                                                            AS COD_CARGO,
                       TRIM(A.DAT_NOMEACAO)                                                         AS DAT_NOMEACAO,
                       TRIM(A.DAT_POSSE)                                                            AS DAT_POSSE,
                       TRIM(A.DAT_INI_EXERC)                                                        AS DAT_INI_EXERC,
                       LEAD(A.DAT_INI_EXERC,1) OVER (PARTITION BY  ID_SERVIDOR,ID_VINCULO
                                                         ORDER BY DAT_INI_EXERC)                    AS DAT_INI_EXERC_PROX,                                                                                                        TRIM(A.COD_ORGAO_LOTACAO)        COD_ORGAO_LOTACAO,
                       TRIM(A.COD_REGIME_JUR)                                                       AS COD_REGIME_JUR,
                       FNC_CODIGO_EXT(A.COD_INS, 3020, TRIM(A.COD_REGIME_JUR), NULL, 'COD_PAR')     AS COD_REGIME_JUR_INT,
                       TRIM(TO_NUMBER(A.COD_TIPO_PROVIMENTO))                                       AS COD_TIPO_PROVIMENTO,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      2025,
                                      TRIM(TO_NUMBER(A.COD_TIPO_PROVIMENTO)),
                                      NULL,
                                      'COD_PAR')                                                    AS  COD_TIPO_PROVIMENTO_INT,
                       TRIM(TO_NUMBER(A.COD_TIPO_DOC_INI_VINCULO))                                  AS COD_TIPO_DOC_INI_VINCULO,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      2019,
                                      TRIM(TO_NUMBER(A.COD_TIPO_DOC_INI_VINCULO)),
                                      NULL,
                                      'COD_PAR')                                                    AS COD_TIPO_DOC_INI_VINCULO_INT,
                       TRIM(A.NUM_DOC_INI_VINCULO)                                                  AS NUM_DOC_INI_VINCULO,
                       TRIM(TO_NUMBER(A.COD_TIPO_VINCULO))                                          AS COD_TIPO_VINCULO,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      10131,
                                      TRIM(TO_NUMBER(A.COD_TIPO_VINCULO)),
                                      NULL,
                                      'COD_PAR')                                                    AS COD_TIPO_VINCULO_INT,
                       TRIM(A.DAT_FIM_EXERC)                                                        AS DAT_FIM_EXERC,
                       MAX(A.DAT_FIM_EXERC) OVER (PARTITION BY ID_SERVIDOR,ID_VINCULO )             AS DAT_FIM_EXERC_PROX,
                       TRIM(A.COD_MOTIVO_DESLIGAMENTO)                                              AS COD_MOTIVO_DESLIGAMENTO,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      2020,
                                      TRIM(A.COD_MOTIVO_DESLIGAMENTO),
                                      NULL,
                                      'COD_PAR')                                                     AS COD_MOTIVO_DESLIGAMENTO_INT,
                       TRIM(TO_NUMBER(A.COD_TIPO_DOC_FIM_VINCULO))                                   AS COD_TIPO_DOC_FIM_VINCULO,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      2072,
                                      TRIM(TO_NUMBER(A.COD_TIPO_DOC_FIM_VINCULO)),
                                      NULL,
                                      'COD_PAR')                                                     AS COD_TIPO_DOC_FIM_VINCULO_INT,
                       TRIM(A.NUM_DOC_FIM_VINCULO)                                                   AS NUM_DOC_FIM_VINCULO,
                       TRIM(A.COD_SITU_FUNCIONAL)                                                    AS COD_SITU_FUNCIONAL,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      2036,
                                      TRIM(A.COD_SITU_FUNCIONAL),
                                      NULL,
                                      'COD_PAR')                                                     AS COD_SITU_FUNCIONAL_INT,
                       TRIM(A.COD_REGIME_PREVID)                                                     AS COD_REGIME_PREVID,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      10132,
                                      TRIM(A.COD_REGIME_PREVID),
                                      NULL,
                                      'COD_PAR')                                                     AS COD_REGIME_PREVID_INT,
                       TRIM(A.COD_PLAN_PREVID)                                                       AS COD_PLAN_PREVID,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      10133,
                                      TRIM(A.COD_PLAN_PREVID),
                                      NULL,
                                      'COD_PAR')                                                     AS COD_PLAN_PREVID_INT,
                       TRIM(A.COD_TIPO_HISTORICO)                                                    AS COD_TIPO_HISTORICO,
                       FNC_CODIGO_EXT(A.COD_INS,
                                      2016,
                                      TRIM( DECODE(A.COD_TIPO_HISTORICO,'9','99',A.COD_TIPO_HISTORICO)),
                                      NULL,
                                      'COD_PAR')                                                     AS COD_TIPO_HISTORICO_INT,
                       TRIM(A.DES_OBSERVACAO)                                                        AS DES_OBSERVACAO,
                       A.ID                                                                          AS ID,
                       A.NUM_LINHA_HEADER                                                            AS NUM_LINHA_HEADER,
                       A.ID_PROCESSO                                                                 AS ID_PROCESSO
                FROM TB_CARGA_GEN_HFE A
                WHERE A.ID_HEADER = I_ID_HEADER
                  AND A.COD_STATUS_PROCESSAMENTO = '2'
                ORDER BY A.ID_SERVIDOR, A.ID_VINCULO, A.COD_ENTIDADE, A.DAT_INI_EXERC ) LOOP

        V_CUR_ID              := HFE.ID;
        V_RESULT              := NULL;

        BEGIN
            IF HFE.NUM_LINHA_HEADER = 35492 THEN
              NULL;
            END IF;

            V_COD_PCCS := NULL;
            V_RESULT                       := NULL;
            V_CUR_ID                       := NULL;
            V_LINHA_TB_RELACAO_FUNCIONAL   := NULL;
            V_LIN_TB_REL_FUNC_PERIODO_EXER := NULL;





            V_ID_SERVIDOR  := PAC_CARGA_GENERICA_CLIENTE.FNC_RET_ID_SERVIDOR(HFE.ID_SERVIDOR);
            V_COD_ENTIDADE := PAC_CARGA_GENERICA_CLIENTE.FNC_RET_COD_ENTIDADE(HFE.COD_ENTIDADE,HFE.ID_SERVIDOR);
  

            V_COD_IDE_REL_FUNC   := PAC_CARGA_GENERICA_CLIENTE.FNC_RET_COD_IDE_REL_FUNC(V_ID_SERVIDOR,HFE.ID_VINCULO);

            IF HFE.DAT_NOMEACAO = '00000000' THEN
                HFE.DAT_NOMEACAO := NULL;
            END IF;

            IF HFE.DAT_POSSE = '00000000' THEN
                HFE.DAT_POSSE := NULL;
            END IF;

            V_DATA_INI_EXERC := FNC_VALIDA_DATA(HFE.DAT_INI_EXERC,'RRRRMMDD');

            IF V_DATA_INI_EXERC IS NULL THEN
              V_DATA_INI_EXERC := FNC_VALIDA_DATA(HFE.DAT_POSSE,'RRRRMMDD');
            END IF;

            V_DATA_FIM_EXERC  := FNC_VALIDA_DATA(HFE.DAT_INI_EXERC_PROX,'RRRRMMDD');
            V_DATA_FIM_EXERC  := V_DATA_FIM_EXERC -1;



             i_cod_entidade := V_COD_ENTIDADE;
            V_COD_IDE_CLI := FNC_RET_COD_IDE_CLI( HFE.COD_INS, 1 , V_ID_SERVIDOR);

             if  V_COD_IDE_CLI = null then
               RAISE ERRO_REG;
             END IF;

               IF FNC_VALIDA_PESSOA_FISICA(HFE.COD_INS, V_COD_IDE_CLI,HFE.ID_SERVIDOR) IS NOT NULL THEN
              V_RESULT := 'Servidor possui Benefício cadastrado';
              RAISE ERRO_REG;
            END IF;


            BEGIN
              SELECT O.COD_ORGAO
                INTO V_COD_ORGAO
                FROM TB_ORGAO O
               WHERE O.COD_INS = HFE.COD_INS
                 AND O.COD_ENTIDADE = V_COD_ENTIDADE
                 AND O.COD_ORGAO = HFE.COD_ENTIDADE
                 AND ROWNUM <2;
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 V_COD_ORGAO := NULL;
             END;

             IF V_COD_ORGAO IS NOT NULL THEN

                SELECT MIN(L.DAT_INI), MAX(L.DAT_FIM)
                  INTO V_DAT_INI_LOTACAO,V_DAT_FIM_LOTACAO
                  FROM TB_LOTACAO L
                 WHERE L.COD_INS = HFE.COD_INS
                   AND L.COD_IDE_CLI  = V_COD_IDE_CLI
                   AND L.COD_ENTIDADE = V_COD_ENTIDADE
                   AND L.NUM_MATRICULA = V_ID_SERVIDOR
                   AND L.COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
                   AND L.COD_ORGAO = V_COD_ORGAO;

                V_DAT_INI_LOTACAO := LEAST(V_DAT_INI_LOTACAO,V_DATA_INI_EXERC);
                  V_DAT_FIM_LOTACAO := V_DATA_FIM_EXERC;

                IF V_DAT_INI_LOTACAO IS NULL THEN

                  INSERT INTO TB_LOTACAO
                  (COD_INS,
                   COD_IDE_CLI,
                   COD_ENTIDADE,
                   COD_PCCS,
                   COD_CARGO,
                   NUM_MATRICULA,
                   COD_IDE_REL_FUNC,
                   COD_ORGAO,
                   DAT_INI,
                   COD_MOT_INI,
                   DAT_FIM,
                   COD_MOT_FIM,
                   DAT_ING,
                   DAT_ULT_ATU,
                   NOM_USU_ULT_ATU,
                   NOM_PRO_ULT_ATU)
                  VALUES
                  (HFE.COD_INS,
                   V_COD_IDE_CLI,
                   V_COD_ENTIDADE,
                   V_COD_PCCS,
                   HFE.COD_CARGO,
                   V_ID_SERVIDOR,
                   V_COD_IDE_REL_FUNC,
                   V_COD_ORGAO,
                   V_DATA_INI_EXERC,
                   '1',
                   V_DATA_FIM_EXERC_LOT,
                   HFE.COD_MOTIVO_DESLIGAMENTO,
                   SYSDATE,
                   SYSDATE,
                   USER,
                   'PAC_CARGA_GENERICA.SP_CARREGA_HFE');
                ELSE
                  UPDATE TB_LOTACAO LOT
                   SET DAT_INI  = V_DAT_INI_LOTACAO,
                       DAT_FIM  = V_DAT_FIM_LOTACAO
                   WHERE COD_INS = HFE.COD_INS
                     AND COD_IDE_CLI  = V_COD_IDE_CLI
                     AND COD_ENTIDADE = V_COD_ENTIDADE
                     AND NUM_MATRICULA = V_ID_SERVIDOR
                     AND COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
                     AND COD_ORGAO = V_COD_ORGAO
                     AND ROWNUM <2;
                END IF;
           END IF;


           IF HFE.ID_SERVIDOR = HFE.ID_SERVIDOR_ANT AND
              HFE.ID_VINCULO = HFE.ID_VINCULO_ANT THEN
              IF (FNC_GRAVA_STATUS_PROCESSAMENTO(V_NOM_TABELA, HFE.ID, '3', NULL, V_NOM_ROTINA) != 'TRUE') THEN
                RAISE ERRO_GRAVA_STATUS;
              END IF;
              CONTINUE;
           END IF;



           BEGIN
                SELECT *
                INTO V_LINHA_TB_RELACAO_FUNCIONAL
                FROM TB_RELACAO_FUNCIONAL
                WHERE COD_INS = HFE.COD_INS
                  AND COD_IDE_CLI = V_COD_IDE_CLI
                  AND NUM_MATRICULA = V_ID_SERVIDOR
                  AND COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC;
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;

            IF (V_LINHA_TB_RELACAO_FUNCIONAL.COD_INS IS NOT NULL) THEN

                IF (NVL(I_FLG_ACAO_POSTERGADA, '1') = '0') THEN

                    UPDATE TB_RELACAO_FUNCIONAL
                    SET

                        DAT_NOMEA              = FNC_VALIDA_DATA(HFE.DAT_NOMEACAO, 'RRRRMMDD'),
                        DAT_POSSE              = FNC_VALIDA_DATA(HFE.DAT_POSSE, 'RRRRMMDD'),
                        DAT_INI_ESTAG_PROB     = V_DATA_INI_EXERC,
                        COD_REGIME             = HFE.COD_REGIME_PREVID_INT,
                        COD_PLANO              = NVL(HFE.COD_PLAN_PREVID_INT, COD_PLANO),
                        DES_OBS                = NVL(SUBSTR(HFE.DES_OBSERVACAO, 1, 255), DES_OBS),

                        COD_REGIME_JUR         = HFE.COD_REGIME_JUR_INT,
                        TIP_PROVIMENTO         = HFE.COD_TIPO_PROVIMENTO_INT,
                        COD_SIT_FUNC           = NVL(HFE.COD_SITU_FUNCIONAL_INT, COD_SIT_FUNC),

                        COD_MOT_DESLIG         = NVL(HFE.COD_MOTIVO_DESLIGAMENTO_INT, COD_MOT_DESLIG),
                        COD_TIPO_DOC_ASSOC_FIM = NVL(HFE.COD_TIPO_DOC_FIM_VINCULO_INT, COD_TIPO_DOC_ASSOC_FIM),
                        NUM_DOC_ASSOC_FIM      = NVL(HFE.NUM_DOC_FIM_VINCULO, NUM_DOC_ASSOC_FIM),

                        COD_TIPO_DOC_ASSOC_INI = NVL(HFE.COD_TIPO_DOC_INI_VINCULO_INT, COD_TIPO_DOC_ASSOC_INI),
                        NUM_DOC_ASSOC_INI      = NVL(HFE.NUM_DOC_INI_VINCULO, NUM_DOC_ASSOC_INI),
                        COD_TIPO_HIST_INI      = HFE.COD_TIPO_HISTORICO_INT,
                        DAT_ULT_ATU            = SYSDATE,
                        NOM_USU_ULT_ATU        = USER,
                        NOM_PRO_ULT_ATU        = V_NOM_ROTINA
                    WHERE COD_INS          = V_LINHA_TB_RELACAO_FUNCIONAL.COD_INS
                      AND COD_IDE_CLI      = V_LINHA_TB_RELACAO_FUNCIONAL.COD_IDE_CLI
                      AND COD_ENTIDADE     = V_LINHA_TB_RELACAO_FUNCIONAL.COD_ENTIDADE
                      AND NUM_MATRICULA    = V_LINHA_TB_RELACAO_FUNCIONAL.NUM_MATRICULA
                      AND COD_IDE_REL_FUNC = V_LINHA_TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC
                      AND NOM_PRO_ULT_ATU = V_NOM_ROTINA;
                END IF;

            ELSE

                V_COD_TIPO_OCORRENCIA := 'I';

                IF (NVL(I_FLG_ACAO_POSTERGADA, '1') = '0') THEN

                    INSERT INTO TB_RELACAO_FUNCIONAL
                        (COD_INS,
                         COD_IDE_CLI,
                         COD_ENTIDADE,
                         COD_PCCS,
                         COD_CARGO,
                         NUM_MATRICULA,
                         COD_IDE_REL_FUNC,
                         COD_SIT_PREV,
                         DAT_NOMEA,
                         DAT_POSSE,
                         DAT_INI_ESTAG_PROB,
                         DAT_ING,
                         DAT_ULT_ATU,
                         NOM_USU_ULT_ATU,
                         NOM_PRO_ULT_ATU,
                         COD_REGIME,
                         COD_PLANO,
                         DES_OBS,
                         COD_VINCULO,
                         COD_REGIME_JUR,
                         TIP_PROVIMENTO,
                         COD_SIT_FUNC,
                         DAT_FIM_EXERC,
                         COD_MOT_DESLIG,
                         COD_TIPO_DOC_ASSOC_FIM,
                         NUM_DOC_ASSOC_FIM,
                         DAT_INI_EXERC,
                         COD_TIPO_DOC_ASSOC_INI,
                         NUM_DOC_ASSOC_INI,
                         COD_TIPO_HIST_INI)
                    VALUES
                        (HFE.COD_INS,
                         V_COD_IDE_CLI,
                         V_COD_ENTIDADE,
                         V_COD_PCCS,
                         HFE.COD_CARGO,
                         V_ID_SERVIDOR,
                         V_COD_IDE_REL_FUNC,
                         '1',
                         FNC_VALIDA_DATA(HFE.DAT_NOMEACAO, 'RRRRMMDD'),
                         FNC_VALIDA_DATA(HFE.DAT_POSSE, 'RRRRMMDD'),
                         V_DATA_INI_EXERC,
                         SYSDATE,
                         SYSDATE,
                         USER,
                         V_NOM_ROTINA,
                         HFE.COD_REGIME_PREVID_INT,
                         HFE.COD_PLAN_PREVID_INT,
                         SUBSTR(HFE.DES_OBSERVACAO, 1, 255),
                         HFE.ID_VINCULO,
                         HFE.COD_REGIME_JUR_INT,
                         HFE.COD_TIPO_PROVIMENTO_INT,
                         HFE.COD_SITU_FUNCIONAL_INT,
                         FNC_VALIDA_DATA(HFE.DAT_FIM_EXERC, 'RRRRMMDD'),
                         HFE.COD_MOTIVO_DESLIGAMENTO_INT,
                         HFE.COD_TIPO_DOC_FIM_VINCULO_INT,
                         HFE.NUM_DOC_FIM_VINCULO,
                         V_DATA_INI_EXERC,
                         HFE.COD_TIPO_DOC_INI_VINCULO_INT,
                         HFE.NUM_DOC_INI_VINCULO,
                         HFE.COD_TIPO_HISTORICO_INT);

                END IF;
            END IF;

            IF (FNC_GRAVA_STATUS_PROCESSAMENTO(V_NOM_TABELA, HFE.ID, '3', NULL, V_NOM_ROTINA) != 'TRUE') THEN
               RAISE ERRO_GRAVA_STATUS;
            END IF;

        EXCEPTION
            WHEN ERRO_REG THEN

               SP_GRAVA_ERRO(I_ID_HEADER,HFE.ID_PROCESSO , HFE.NUM_LINHA_HEADER,V_NOM_ROTINA, V_RESULT, NULL);

               IF (FNC_GRAVA_STATUS_PROCESSAMENTO(V_NOM_TABELA, HFE.ID, '4', 'Erro de processamento', V_NOM_ROTINA) != 'TRUE') THEN
                    RAISE ERRO_GRAVA_STATUS;
               END IF;


            WHEN OTHERS THEN

                V_MSG_ERRO := SUBSTR(SQLERRM, 1, 4000);

                SP_GRAVA_ERRO(I_ID_HEADER,HFE.ID_PROCESSO , HFE.NUM_LINHA_HEADER,V_NOM_ROTINA, V_MSG_ERRO, NULL);

                IF (FNC_GRAVA_STATUS_PROCESSAMENTO(V_NOM_TABELA, HFE.ID, '4', 'Erro de processamento', V_NOM_ROTINA) != 'TRUE') THEN
                    RAISE ERRO_GRAVA_STATUS;
                END IF;
        END;
    END LOOP;

    EXCEPTION
      WHEN ERRO_GRAVA_STATUS THEN
        O_COD_ERRO := 1;
        O_DES_ERRO := 'Erro ao tentar gravar status';
      WHEN OTHERS THEN
        O_COD_ERRO := 1;
        O_DES_ERRO := 'Erro Geral: '||SQLERRM;
    END SP_EXEC_CARREGA_HFE;


    PROCEDURE SP_CARREGA_HFE (I_ID_HEADER IN NUMBER) IS
     V_RESULT                        VARCHAR2(4000);
     V_FLG_ACAO_POSTERGADA           TB_CARGA_GEN_PROCESSO.FLG_ACAO_POSTERGADA%TYPE;
     V_COD_SITU_OCORRENCIA           TB_CARGA_GEN_LOG.COD_SITU_OCORRENCIA%TYPE;
     V_NOM_ROTINA                    VARCHAR2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_HFE';

     V_COD_ERRO                      NUMBER;
     V_DES_ERRO                      VARCHAR2(4000);
     V_QTD_PROC                      NUMBER;
     V_QTD_TOTAL                     NUMBER;

     V_COD_PROC                      NUMBER;
     V_OBS                           VARCHAR2(4000);
    BEGIN

      SP_BUSCA_DADOS_PROCESSO(I_ID_HEADER, V_FLG_ACAO_POSTERGADA, V_COD_SITU_OCORRENCIA, V_RESULT);

      IF V_RESULT IS NOT NULL THEN
         SP_ATUALIZA_HEADER(I_ID_HEADER, V_NOM_ROTINA, V_RESULT);
         RETURN;
       END IF;

      V_QTD_PROC := 0;

      SELECT COUNT(1)
        INTO V_QTD_TOTAL
        FROM TB_CARGA_GEN_HFE
       WHERE ID_HEADER = I_ID_HEADER
         AND COD_STATUS_PROCESSAMENTO = 1;

      V_COD_PROC := 3;
      V_OBS      := NULL;


      LOOP
         UPDATE TB_CARGA_GEN_HFE
               SET COD_STATUS_PROCESSAMENTO = 2 , DAT_PROCESSAMENTO = NULL, OBS_PROCESSAMENTO = NULL
              WHERE ID_HEADER = I_ID_HEADER
                AND (ID_SERVIDOR, ID_VINCULO) IN (SELECT DISTINCT ID_SERVIDOR, ID_VINCULO
                                                               FROM TB_CARGA_GEN_HFE
                                                              WHERE ID_HEADER = I_ID_HEADER
                                                                AND COD_STATUS_PROCESSAMENTO = 1
                                                                FETCH FIRST 20 ROWS ONLY);



         IF SQL%ROWCOUNT = 0 OR V_QTD_PROC = V_QTD_TOTAL THEN
              EXIT;
         END IF;


         SP_EXEC_CARREGA_HFE(I_ID_HEADER,
                             V_FLG_ACAO_POSTERGADA,
                             V_COD_ERRO,
                             V_DES_ERRO
                             );

         V_QTD_PROC := V_QTD_PROC + SQL%ROWCOUNT;
         IF V_COD_ERRO = 1 THEN
           ROLLBACK;

           V_COD_PROC := 4;
           V_OBS      := V_DES_ERRO;

            EXIT;
         END IF;
       END LOOP;

       UPDATE TB_CARGA_GEN_HEADER A
            SET A.COD_STATUS_PROCESSAMENTO = V_COD_PROC,
                A.DES_OBSERVACAO = V_OBS,
                A.DAT_PROCESSAMENTO = SYSDATE,
                A.NOM_PRO_ULT_ATU = V_NOM_ROTINA,
                A.NOM_USU_ULT_ATU = USER,
                A.DAT_ULT_ATU = SYSDATE
          WHERE ID = I_ID_HEADER;

        UPDATE TB_CARGA_GEN_HFE
          SET COD_STATUS_PROCESSAMENTO = 1
        WHERE ID_HEADER = I_ID_HEADER
          AND COD_STATUS_PROCESSAMENTO = 2;
          COMMIT;

   END SP_CARREGA_HFE;





  ----------- ========================================================roberto
   PROCEDURE SP_EXEC_CARREGA_EVF (i_id_header in number,
                                  i_flg_acao_postergada  in tb_carga_gen_processo.flg_acao_postergada%type,
                                  o_cod_erro             out number,   -- 1 Erro Geral 0: Sucesos no processamento
                                  o_des_erro             out varchar2 ) IS

        v_result                     varchar2(2000);
        v_cod_tipo_ocorrencia        tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia        tb_carga_gen_log.cod_situ_ocorrencia%type;

        v_nom_rotina                 varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_EVF';
        v_nom_tabela                 varchar2(100) := 'TB_CARGA_GEN_EVF';
        v_lin_tb_evolucao_funcional  tb_evolucao_funcional%rowtype;
        v_cod_jornada                tb_jornada.cod_jornada%type;
        v_cod_pccs                   tb_pccs.cod_pccs%type;
        v_des_sigla_pccs             tb_pccs.des_sigla%type;
        v_cod_quadro                 tb_cargo.cod_quadro%type;
        v_cod_carreira               tb_cargo.cod_carreira%type;
        v_cod_classe                 tb_cargo.cod_classe%type;
        v_cod_nivel                  tb_referencia.cod_nivel%type;
        v_cod_grau                   tb_referencia.cod_grau%type;
        v_cod_ref_pad_venc           tb_referencia.cod_ref_pad_venc%type;
        v_cod_referencia             tb_referencia.cod_referencia%type;
        v_cod_composicao             tb_composicao.cod_composicao%type;
        v_cod_regime_retrib          varchar2(4000);
        v_cod_escala_venc            varchar2(4000);
        v_id_log_erro                number;
        v_msg_erro                   varchar2(4000);
        v_cod_erro                   number;
        v_dat_ini_even_func          date;
        v_dat_fim_even_func          date;
        v_vlr_iteracao               number := 100;
        v_cod_entidade               tb_carga_gen_evf.cod_entidade%type;
        v_id_servidor                tb_CargA_gen_evf.Id_Servidor%type;
        v_cod_ide_cli                tb_evolucao_funcional.cod_ide_cli%type;
        v_cod_ide_Rel_func           tb_evolucao_funcional.cod_ide_rel_func%type;
        v_qtd_concomitante           number;
        v_qtd_perido_duplicado       number;
        erro                         exception;
        v_existe_dat_fim             char;
        v_dat_fim                    date;

        ERRO_GRAVA_STATUS            exception;
        erro_reg                     exception;
        v_primeiro_registro_Serv     boolean;
        v_num_seq_periodo_exerc      number;
        v_dat_ini_efeito               date;
        v_dat_fim_efeito               date;
        V_existe_beneficio           boolean;
        V_existe_registro            boolean;
        V_existe_registro_alterado   boolean;
        v_alterado_data              boolean;
        v_cod_ide_cli_g              number;
        v_nom_pro_ult_atu_g          varchar2(100);
        V_SEQ                        number;
        v_salva_data_ant              number := 1;
        v_dat_ini_efeito_ant         date;
        v_total                      number;
        v_dat_fim_efeito_ant         date;
        v_dat_inicio_ant             date;
        c_cod_ins                    varchar2(100);
        c_id_servidor                varchar2(100);
        v_cod_cargo                  varchar2(100);
        c_id_vinculo                 varchar2(100);
        v_cod_ins                     number;
        c_cod_ide_cli                 number;
        c_cod_entidade                number;
        c_cod_ide_rel_func            number;
        c_dat_inicio_ant              date;
        C_SERVIDOR                    NUMBER;
        erro_for                      boolean := False;
        i_data_inicio                 date;
    BEGIN

      for ser in
      (select distinct  id_servidor, id_vinculo
         from tb_carga_gen_evf a
        where a.id_header = i_id_header
          and a.cod_status_processamento = '2'
        --  AND A.ID_SERVIDOR in  (1014560)
          order by id_servidor

    --     (933520,660620)
          )
     loop
        v_primeiro_registro_Serv := true;
        v_num_seq_periodo_exerc := 0;
        C_SERVIDOR := SER.ID_SERVIDOR;


         -- Seleciona o  ultima seguencia valida e adiciona mais 1
         BEGIN
           SELECT MAX(NVL(E.NUM_SEQ_PERIODO_EXERC,0))+1 INTO v_num_seq_periodo_exerc FROM tb_rel_func_periodo_exerc E
           WHERE E.COD_IDE_CLI IN
           (
             SELECT F.COD_IDE_CLI FROM TB_RELACAO_FUNCIONAL F  WHERE F.NUM_MATRICULA = SER.ID_SERVIDOR
           );

         END;
           IF v_num_seq_periodo_exerc IS NULL THEN
              v_num_seq_periodo_exerc := 1;
           END IF;

            V_existe_beneficio :=FALSE;

            
            i_cod_entidade := V_COD_ENTIDADE;
            v_cod_ide_cli := fnc_ret_cod_ide_cli( 1, 2, ser.id_servidor);

-- 1 - conta quanto registros vão ser incluido na tabela tb_evolucao_funcional
       begin
       select  distinct
                a.cod_ins,
       --    trim(a.cod_entidade) ,
           trim(a.id_servidor)  ,
           trim(a.id_vinculo)
           into   c_cod_ins  /* ,c_cod_entidade */ , c_id_servidor , c_id_vinculo--, c_cod_cargo
        from tb_carga_gen_evf a
        where a.id_header = i_id_header
         and a.cod_status_processamento = '2'
         and a.id_Servidor              = ser.id_servidor
         and a.id_vinculo               = ser.id_vinculo;
         EXCEPTION
         WHEN NO_DATA_FOUND THEN
               null;
         END;


               v_cod_ide_Rel_func   := pac_carga_generica_cliente.fnc_ret_cod_ide_rel_func(c_id_servidor,c_id_vinculo);
               v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(c_cod_entidade,c_id_servidor);

          

                begin
                select count(1) into v_total from
                (
                   select substr(e.dat_ini_even_func,7,2)||'/'||substr(e.dat_ini_even_func,5,2)||'/'||substr(e.dat_ini_even_func,1,4) dat_ini_even_func
                   from tb_carga_gen_evf e
                   where e.id_Servidor = ser.id_servidor
                   and e.cod_status_processamento = '2'
                   minus
                   select to_char(dat_ini_efeito,'dd/mm/yyyy')  dat_ini_efeitofrom from tb_evolucao_funcional g
                   where num_matricula = c_id_servidor
                     and g.cod_ins     = c_cod_ins
                     and g.num_matricula = ser.id_servidor
                     and g.cod_entidade     =   v_cod_entidade
                     and g.cod_ide_rel_func =  v_cod_ide_rel_func
                 );
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      null;
                 END;

                 begin
                   select p.dat_ini_efeito into i_data_inicio
                   from tb_evolucao_funcional p
                   where p.cod_ide_cli = v_cod_ide_cli
                   AND DAT_FIM_EFEITO IS NULL
                   order by dat_ini_efeito;
                 EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                      null;
                 END;

-- faz a verificação das informações na tabel de Carga.
          IF NOT V_existe_beneficio  THEN
            for evf in (select a.cod_ins,
                               NVL((select  1 from tb_cargo c where c.cod_cargo = a.cod_cargo
                               and c.cod_entidade = a.cod_entidade--29 
                               and rownum = 1),0) EXISTE_CARGO,
                               a.id_header,
                               trim(a.cod_entidade)                                                         as cod_entidade,
                               trim(a.id_servidor)                                                          as id_servidor,
                               trim(a.id_vinculo)                                                           as id_vinculo,
                               trim(a.cod_cargo)                                                            as cod_cargo,
                               trim(to_number(a.cod_moti_evol_even_func))                                   as cod_moti_evol_even_func,
                               fnc_codigo_ext(a.cod_ins,
                                              10134,
                                              trim(to_number(a.cod_moti_evol_even_func)),
                                              null,
                                              'COD_PAR')                                                    as cod_moti_evol_even_func_int,
                               trim(a.dat_ini_even_func)                                                    as dat_ini_even_func,
                               lead(trim(a.dat_ini_even_func),1) over (partition by id_servidor,id_vinculo
                                                                           order by  dat_ini_even_func)     as dat_ini_even_func_prox,
                               trim(to_number(a.cod_tipo_doc_ini_even_func)) cod_tipo_doc_ini_even_func,
                               fnc_codigo_ext(a.cod_ins,
                                              2019,
                                              trim(to_number(a.cod_tipo_doc_ini_even_func)),
                                              null,
                                              'COD_PAR')                                                    as cod_tipo_doc_ini_even_func_int,
                               trim(a.num_doc_ini_even_func)                                                as num_doc_ini_even_func,
                               trim(a.dat_fim_even_func)                                                    as dat_fim_even_func,
                               fnc_codigo_ext(a.cod_ins,
                                              2072,
                                              trim(to_number(a.cod_tipo_doc_fim_even_func)),
                                              null,
                                              'COD_PAR')                                                    as cod_tipo_doc_fim_even_func_int,
                               trim(to_number(a.cod_tipo_doc_fim_even_func))                                as cod_tipo_doc_fim_even_func,
                               trim(a.num_doc_fim_even_func)                                                as num_doc_fim_even_func,
                               trim(a.cod_referencia)                                                       as cod_referencia,
                               trim(a.cod_grau_nivel)                                                       as cod_grau_nivel,
                               trim(a.des_jornada)                                                          as des_jornada,
                               trim(a.des_observacao)                                                       as des_observacao,
                               trim(a.num_faixa_nivel)                                                      as num_faixa_nivel,
                               a.id,
                               a.num_linha_header,
                               a.id_processo
                        from tb_carga_gen_evf a
                        where a.id_header = i_id_header
      --                    and exists  (select  1 from tb_cargo c where c.cod_cargo = a.cod_cargo and c.cod_entidade = 29 and rownum = 1 )
                         and to_date(substr(a.dat_ini_even_func,7,2)||'/' ||substr(a.dat_ini_even_func,5,2)||'/' ||substr(a.dat_ini_even_func,1,4)) >
                         nvl((select MAX(e.dat_ini_efeito) from tb_evolucao_funcional e where e.num_matricula = a.id_servidor and e.dat_fim_efeito is null),'01/01/1900')
                        and a.cod_status_processamento = '2'
                         and a.id_Servidor = ser.id_servidor
                         and a.id_vinculo = ser.id_vinculo

                          order by id_servidor, id_vinculo,dat_ini_even_func ) loop

                        v_result              := null;

                          BEGIN

                            erro_for := true;
                            v_result := null;
                            v_cod_erro := null;
                            v_cod_erro := null;

                            -- Se a data inicial for igual a proxima data gera log de erro
                            if evf.dat_ini_even_func = evf.dat_ini_even_func_prox then
                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '5', 'Registro com data inicio duplicada', v_nom_rotina) != 'TRUE') then
                                --raise ERRO_GRAVA_STATUS;
                                continue;
                              end if;

                              continue;
                            end if;
                            --
                            -- separando entidade de id_header
                            v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(evf.id_servidor);
                            v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(evf.cod_entidade,evf.id_servidor);
                                                                                         --
                            -- Pega cod_ide_cli da ident_ext_servidor
                            v_cod_ide_cli := fnc_ret_cod_ide_cli( evf.cod_ins, 2, v_id_Servidor);

                            -- valida benenficio caso exista não executa a inclusão pois existe beneficio
                            if FNC_VALIDA_PESSOA_FISICA(evf.cod_ins, v_cod_ide_cli,evf.id_servidor) is not null then
                               v_result := 'Servidor possui Benefício cadastrado';
                               raise erro_reg;
                            end if;
                            --
                            --
                            v_cod_ide_Rel_func   := pac_carga_generica_cliente.fnc_ret_cod_ide_rel_func(v_id_servidor,evf.id_vinculo);

                            --
                            -- adiciona zero na data inicial caso a inicial seja nula
                            if (evf.dat_ini_even_func is not null and evf.dat_ini_even_func = '00000000') then
                                evf.dat_ini_even_func := null;
                            end if;
                            --
                            if (evf.dat_fim_even_func is not null and evf.dat_fim_even_func = '00000000') then
                                evf.dat_fim_even_func := null;
                            end if;

                            -- Valida Data e atribuia
                            v_dat_ini_even_func := fnc_valida_data(evf.dat_ini_even_func, 'RRRRMMDD');
                            v_dat_fim_even_func := fnc_valida_data(evf.dat_ini_even_func_prox, 'RRRRMMDD');
                            v_dat_fim_even_func := v_dat_fim_even_func-1;


                            if v_dat_ini_even_func is null then
                              v_result := 'Data de inicio da evolução está nulo';
                              raise erro_reg;
                            end if;


                            --
                            -- Retorna Dados Referencia
                            v_cod_pccs       := null;
                            v_cod_quadro     := null;
                            v_cod_carreira   := null;
                            v_cod_classe     := null;
                            v_cod_referencia := null;
                            v_cod_composicao := null;
                            v_cod_jornada    := null;

                     V_existe_registro:= true;
                     V_existe_registro_alterado:= False;

                    begin
                     -- verifica se existe na tabela de tb_evolucao_funcional de acordo com vinculo
                          SELECT g.cod_ide_cli,g.nom_pro_ult_atu
                          into  v_cod_ide_cli_g,v_nom_pro_ult_atu_g
                          FROM tb_evolucao_funcional G
                          WHERE
                    --   vinculo
                          G.NUM_MATRICULA = evf.id_servidor
                          and g.cod_ins = evf.cod_ins
                          and g.cod_cargo = evf.cod_cargo
                          and g.dat_ini_efeito   =   to_date(substr(evf.dat_ini_even_func,7,2)||'/' ||substr(evf.dat_ini_even_func,5,2)||'/' ||substr(evf.dat_ini_even_func,1,4))
                          and g.cod_ide_cli      =   v_cod_ide_cli                                      --  2 COD_IDE_CLI
                          and g.cod_entidade     =   v_cod_entidade                                     --  3 COD_ENTIDADE
                          and g.cod_ide_rel_func =  v_cod_ide_rel_func ;                               --  6 NUM_MATRICULA

                           EXCEPTION
                             WHEN NO_DATA_FOUND THEN
                              V_existe_registro := false;
                           END;



             -- Se já existe não faz nada e vai para o proximo registro
                          if V_existe_registro = true   then
                             continue;
                          end if;


    --  pega a data inicio anterior para fazer update
                    if v_salva_data_ant = 1 then
                          begin
                            SELECT max(g.dat_ini_efeito)
                            into  v_dat_inicio_ant
                            FROM tb_evolucao_funcional G
                            WHERE
                      --   vinculo
                            G.NUM_MATRICULA = evf.id_servidor
                            and g.cod_ins = evf.cod_ins
                        --    and g.cod_cargo = evf.cod_cargo
                            and g.dat_fim_efeito   is null
                            and g.cod_ide_cli    =   v_cod_ide_cli                                      --  2 COD_IDE_CLI
                            and g.cod_entidade     =   v_cod_entidade                                     --  3 COD_ENTIDADE
                            and g.cod_ide_rel_func =  v_cod_ide_rel_func ;
                          EXCEPTION
                          WHEN NO_DATA_FOUND THEN
                               null;
                          END;

                      end if;

        v_cod_cargo := evf.cod_cargo;
                    -- verifica se existe carga de referencia
                         pac_carga_Generica_cliente.sp_Ret_dados_referencia (evf.cod_ins,
                                                    evf.cod_grau_nivel,
                                                    evf.des_jornada,
                                                    v_cod_entidade,
                                                    v_cod_cargo,
                                                    evf.cod_Referencia,
                                                    v_cod_pccs,           -- out
                                                    v_cod_quadro,         -- out
                                                    v_cod_carreira,       -- out
                                                    v_cod_classe,         -- out
                                                    v_cod_referencia,     -- out
                                                    v_cod_composicao,     -- out
                                                    v_cod_jornada,        -- out
                                                    v_cod_Erro,           -- out
                                                    v_msg_erro);

                           if v_cod_Erro is not null then
                             v_result := 'Erro ao tentar localizar referencia.';
                             -- Localizar cargo genérico,referencia e composição
                        --     raise erro_Reg ;
                           v_cod_referencia := 999999;
                           v_cod_composicao := 999999;
                           v_cod_entidade := v_cod_entidade;--29;

                         insert into carga_erro_evf
                              values
                                  (
                                      I_ID_HEADER,
                                      EVF.NUM_LINHA_HEADER,
                                      V_COD_ENTIDADE,
                                      V_ID_SERVIDOR,
                                      EVF.ID_VINCULO,
                                      V_COD_CARGO,
                                      'I',
                                      'P06',
                                      '036',
                                      V_COD_IDE_CLI,
                                      V_COD_COMPOSICAO,
                                      999999,
                                       'COMPOSIÇÃO SEM CONFORMIDADE COM O CADASTRO',
                                      V_DAT_INI_EVEN_FUNC,
                                      V_DAT_FIM_EVEN_FUNC,
                                      SYSDATE,
                                      SYSDATE
                                   );


                              v_cod_pccs := 27;
                              V_COD_QUADRO   := v_cod_entidade;--29;
                              V_COD_CARREIRA := 6;
                              V_COD_CLASSE  := 999999;
                              V_COD_REFERENCIA := 999999 ;
                              V_COD_COMPOSICAO := 999999 ;

                           end if;
                           --
                           -- primeira interação do vinculo
                            if v_primeiro_registro_Serv then
                                v_primeiro_registro_Serv := false;

                               evf.cod_moti_evol_even_func_int := 1;


                            end if;
                           --
                  -- primeira iteração do vinculo
                  if v_primeiro_registro_Serv then

                      -- Deleta antigos (carga full)
                          delete tb_evolucao_funcional a
                            where a.cod_ins = evf.cod_ins
                              and a.cod_ide_cli = v_cod_ide_cli
                              and a.num_matricula =v_id_servidor
                              and a.cod_ide_rel_func =  v_cod_ide_Rel_func;

                          delete tb_rel_func_periodo_exerc b
                            where b.cod_ins = evf.cod_ins
                              and b.cod_ide_cli = v_cod_ide_cli
                              and b.num_matricula =v_id_servidor
                              and b.cod_ide_rel_func =  v_cod_ide_Rel_func;

                          -- Atualiza relacao funcional
                          update tb_relacao_funcional rf
                             set rf.cod_pccs = v_cod_pccs,
                                 rf.cod_cargo = evf.cod_cargo,
                                 rf.dat_ini_exerc = v_dat_ini_even_func,
                                 rf.dat_fim_exerc = null
                           where rf.cod_ins = evf.cod_ins
                              and rf.cod_ide_cli = v_cod_ide_cli
                              and rf.num_matricula =v_id_servidor
                              and rf.cod_ide_rel_func =  v_cod_ide_Rel_func;

                          update tb_Servidor s
                             set s.dat_ing_serv_public = v_dat_ini_even_func
                           where cod_ins = evf.cod_ins
                             and cod_ide_cli = v_cod_ide_cli;

                           v_primeiro_registro_Serv := false;

                           evf.cod_moti_evol_even_func_int := 1;

                        end if;
                                           --
                        begin
                           case 
                                when  V_COD_CARGO = 95330  then v_cod_jornada := 30;
                            end case;  
                        end;    


                          if (nvl(i_flg_acao_postergada, '1') = '0')  then
                          BEGIN
                           -- Ação imediata, não postergada


                                  insert into carga_erro_evf
                                     values
                                  (
                                      I_ID_HEADER,
                                      EVF.NUM_LINHA_HEADER,
                                      V_COD_ENTIDADE,
                                      V_ID_SERVIDOR,
                                      EVF.ID_VINCULO,
                                      V_COD_CARGO,
                                      'I',
                                      'P06',
                                      v_cod_jornada,
                                      V_COD_IDE_CLI,
                                      V_COD_COMPOSICAO,
                                      100000,
                                       'ERRO DE INSERSÃO NA TABELA  tb_evolucao_funcional',
                                      V_DAT_INI_EVEN_FUNC,
                                      V_DAT_FIM_EVEN_FUNC,
                                      SYSDATE,
                                      SYSDATE
                                   );



                               insert into tb_evolucao_funcional
                                  (COD_INS,                   --  1
                                   COD_IDE_CLI,               --  2
                                   COD_ENTIDADE,              --  3
                                   COD_PCCS,                  --  4
                                   COD_CARGO,                 --  5
                                   NUM_MATRICULA,             --  6
                                   COD_IDE_REL_FUNC,          --  7
                                   COD_QUADRO,                --  8
                                   COD_CARREIRA,              --  9
                                   COD_CLASSE,                -- 10
                                   COD_REFERENCIA,            -- 11
                                   COD_COMPOSICAO,            -- 12
                                   COD_MOT_EVOL_FUNC,         -- 13
                                   COD_TIPO_DOC_ASSOC,        -- 14
                                   NUM_DOC_ASSOC,             -- 15
                                   DAT_PUB,                   -- 16
                                   DAT_INI_EFEITO,            -- 17
                                   DAT_FIM_EFEITO,            -- 18
                                   DAT_ING,                   -- 19
                                   DAT_ULT_ATU,               -- 20
                                   NOM_USU_ULT_ATU,           -- 21
                                   NOM_PRO_ULT_ATU,           -- 22
                                   COD_JORNADA,               -- 23
                                   FLG_STATUS,                -- 24
                                   FLG_INI_VINCULO,           -- 25
                                   COD_REFERENCIA_2,          -- 26
                                   COD_COMPOSICAO_2           -- 27
                                   )
                              values
                                  (evf.cod_ins,                                        --  1 COD_INS
                                   v_cod_ide_cli,                                      --  2 COD_IDE_CLI
                                   v_cod_entidade,                                     --  3 COD_ENTIDADE
                                   v_cod_pccs,                                         --  4 COD_PCCS
                                   v_cod_cargo,                                      --  5 COD_CARGO
                                   v_id_servidor,                                      --  6 NUM_MATRICULA
                                   v_cod_ide_rel_func,                                 --  7 COD_IDE_REL_FUNC
                                   v_cod_quadro,                                       --  8 COD_QUADRO
                                   v_cod_carreira,                                     --  9 COD_CARREIRA
                                   v_cod_classe,                                       -- 10 COD_CLASSE
                                   v_cod_referencia,                                   -- 11 COD_REFERENCIA
                                   v_cod_composicao,                                   -- 12 COD_COMPOSICAO
                                   evf.cod_moti_evol_even_func_int,                    -- 13 COD_MOT_EVOL_FUNC
                                   evf.cod_tipo_doc_ini_even_func_int,                 -- 14 COD_TIPO_DOC_ASSOC
                                   evf.num_doc_ini_even_func,                          -- 15 NUM_DOC_ASSOC
                                   v_dat_ini_even_func,                                -- 16 DAT_PUB
                                   v_dat_ini_even_func,                                -- 17 DAT_INI_EFEITO
                                   v_dat_fim_even_func,                                -- 18 DAT_FIM_EFEITO
                                   sysdate,                                            -- 19 DAT_ING
                                   sysdate,                                            -- 20 DAT_ULT_ATU
                                   user,                                               -- 21 NOM_USU_ULT_ATU
                                   v_nom_rotina,                                       -- 22 NOM_PRO_ULT_ATU
                                   v_cod_jornada,                                      -- 23 COD_JORNADA
                                   'V',                                                -- 24 FLG_STATUS
                                   'I',
                                   v_cod_referencia,
                                   v_cod_composicao
                                   );
                                EXCEPTION
                                    WHEN OTHERS THEN
                                    insert into carga_erro_evf
                                     values
                                  (
                                      I_ID_HEADER,
                                      EVF.NUM_LINHA_HEADER,
                                      V_COD_ENTIDADE,
                                      V_ID_SERVIDOR,
                                      EVF.ID_VINCULO,
                                      V_COD_CARGO,
                                      'I',
                                      'P06',
                                      v_cod_jornada,
                                      V_COD_IDE_CLI,
                                      V_COD_COMPOSICAO,
                                      999999,
                                       'ERRO DE INSERSÃO NA TABELA  tb_evolucao_funcional',
                                      V_DAT_INI_EVEN_FUNC,
                                      V_DAT_FIM_EVEN_FUNC,
                                      SYSDATE,
                                      SYSDATE
                                   );
                                  continue;
                                END;
                               --
                              BEGIN
                              insert into tb_rel_func_periodo_exerc
                                      (COD_INS,                   --  1
                                       COD_IDE_CLI,               --  2
                                       COD_ENTIDADE,              --  3
                                       COD_PCCS,                  --  4
                                       COD_CARGO,                 --  5
                                       NUM_MATRICULA,             --  6
                                       COD_IDE_REL_FUNC,          --  7
                                       NUM_SEQ_PERIODO_EXERC,     --  8
                                       DAT_INI_EXERC,             --  9
                                       COD_TIPO_DOC_ASSOC_INI,    -- 10
                                       NUM_DOC_ASSOC_INI,         -- 11
                                       COD_TIPO_HIST_INI,         -- 12
                                       DAT_FIM_EXERC,             -- 13
                                       COD_TIPO_DOC_ASSOC_FIM,    -- 14
                                       NUM_DOC_ASSOC_FIM,         -- 15
                                       COD_MOT_DESLIG,            -- 16
                                       DAT_ING,                   -- 17
                                       DAT_ULT_ATU,               -- 18
                                       NOM_USU_ULT_ATU,           -- 19
                                       NOM_PRO_ULT_ATU)           -- 20
                                  values
                                      (evf.cod_ins,                                    --  1 COD_INS
                                       v_cod_ide_cli,                                  --  2 COD_IDE_CLI
                                       v_cod_entidade,                                 --  3 COD_ENTIDADE
                                       v_cod_pccs,                                     --  4 COD_PCCS
                                       v_cod_cargo,                                  --  5 COD_CARGO
                                       v_id_servidor,                                  --  6 NUM_MATRICULA
                                       v_Cod_ide_rel_func,                             --  7 COD_IDE_REL_FUNC
                                       v_num_seq_periodo_exerc,                        --  8 NUM_SEQ_PERIODO_EXERC
                                       v_dat_ini_even_func,                            --  9 DAT_INI_EXERC
                                       null, --hfe.cod_tipo_doc_ini_vinculo_int,       -- 10 COD_TIPO_DOC_ASSOC_INI
                                       null, --hfe.num_doc_ini_vinculo,                -- 11 NUM_DOC_ASSOC_INI
                                       null, --hfe.cod_tipo_historico_int,             -- 12 COD_TIPO_HIST_INI
                                       v_dat_fim_even_func,                            -- 13 DAT_FIM_EXERC
                                       null, --hfe.cod_tipo_doc_fim_vinculo_int,       -- 14 COD_TIPO_DOC_ASSOC_FIM
                                       null, --hfe.num_doc_fim_vinculo,                -- 15 NUM_DOC_ASSOC_FIM
                                       null, --hfe.cod_motivo_desligamento_int,        -- 16 COD_MOT_DESLIG
                                       sysdate,                                        -- 17 DAT_ING
                                       sysdate,                                        -- 18 DAT_ULT_ATU
                                       user,                                           -- 19 NOM_USU_ULT_ATU
                                       v_nom_rotina);
                                       EXCEPTION
                                         WHEN OTHERS THEN
                                      insert into carga_erro_evf
                                      values
                                     (
                                        I_ID_HEADER,
                                        EVF.NUM_LINHA_HEADER,
                                        V_COD_ENTIDADE,
                                        V_ID_SERVIDOR,
                                        EVF.ID_VINCULO,
                                        V_COD_CARGO,
                                        'I',
                                        'P06',
                                        v_cod_jornada,
                                        V_COD_IDE_CLI,
                                        V_COD_COMPOSICAO,
                                        999999,
                                         'ERRO DE INSERSÃO NA TABELA  tb_rel_func_periodo_exerc',
                                        V_DAT_INI_EVEN_FUNC,
                                        V_DAT_FIM_EVEN_FUNC,
                                        SYSDATE,
                                        SYSDATE
                                     );
                                     continue;
                                       END;


                           v_num_seq_periodo_exerc  := v_num_seq_periodo_exerc+ 1;
                           
                          
                          if c_cod_ide_cli <>  v_cod_ide_cli and c_cod_ide_cli is not null  then
                            v_salva_data_ant := 1;
                          end if;                                    

                        -- 2 -  Atualiza a data final quando houver nova evolução.
                       if v_salva_data_ant = 1 then
                           v_cod_ins := evf.cod_ins;
                           c_cod_ide_cli      :=   v_cod_ide_cli;                                      --  2 COD_IDE_CLI
                           c_cod_entidade     :=   v_cod_entidade;                                     --  3 COD_ENTIDADE
                           c_cod_ide_rel_func :=   v_cod_ide_rel_func;
                           c_dat_inicio_ant   :=   v_dat_inicio_ant; 
                       
                       
                          update tb_evolucao_funcional g set g.dat_fim_efeito = v_dat_ini_even_func-1
                          WHERE G.NUM_MATRICULA = v_id_servidor
                          and g.cod_ins = v_cod_ins
                          and g.dat_ini_efeito  =    i_data_inicio
                          and g.cod_ide_cli     =    c_cod_ide_cli                                      --  2 COD_IDE_CLI
                          and g.cod_entidade     =   c_cod_entidade                                     --  3 COD_ENTIDADE
                          and g.cod_ide_rel_func =   c_cod_ide_rel_func;
                          
                          update tb_rel_func_periodo_exerc p set p.dat_fim_exerc = v_dat_ini_even_func-1
                          WHERE p.NUM_MATRICULA = v_id_servidor
                          and p.cod_ins = v_cod_ins
                          and p.dat_ini_exerc  =     i_data_inicio
                          and p.cod_ide_cli     =    c_cod_ide_cli                                      --  2 COD_IDE_CLI
                          and p.cod_entidade     =   c_cod_entidade                                     --  3 COD_ENTIDADE
                          and p.cod_ide_rel_func =   c_cod_ide_rel_func;  
                          v_salva_data_ant := v_salva_data_ant+1;               
                          
                          
                          
                          
                            
                          v_salva_data_ant := v_salva_data_ant+1;
                          
                          
                          
                       
                        --  v_dat_fim_efeito_ant := v_dat_ini_even_func;
                        else
                           v_salva_data_ant := v_salva_data_ant+1;
                       end if;


                          end if;
                          --


                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '3', null, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      exception
                        WHEN ERRO_REG THEN

                           SP_GRAVA_ERRO(i_id_header,evf.id_processo , evf.num_linha_header,v_nom_rotina, v_result, null);

                           if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                           end if;

                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            SP_GRAVA_ERRO(i_id_header,evf.id_processo , evf.num_linha_header,v_nom_rotina, v_msg_erro, null);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;
                        end;



                          v_cod_ins := evf.cod_ins;
                           c_cod_ide_cli      :=   v_cod_ide_cli;                                      --  2 COD_IDE_CLI
                           c_cod_entidade     :=   v_cod_entidade;                                     --  3 COD_ENTIDADE
                           c_cod_ide_rel_func :=   v_cod_ide_rel_func;
                           c_dat_inicio_ant   :=   v_dat_inicio_ant;


                     end loop;
                      if erro_for = false then  -- Se não registro

                             insert into carga_erro_evf
                                      values
                                     (
                                        I_ID_HEADER,
                                        null ,
                                        V_COD_ENTIDADE,
                                        V_ID_SERVIDOR,
                                        null,
                                        V_COD_CARGO,
                                        'I',
                                        'P06',
                                        v_cod_jornada,
                                        V_COD_IDE_CLI,
                                        V_COD_COMPOSICAO,
                                        999999,
                                         'ERRO DE VERIFICAÇÃO NA TABELA  tb_carga_gen_evf',
                                        V_DAT_INI_EVEN_FUNC,
                                        V_DAT_FIM_EVEN_FUNC,
                                        SYSDATE,
                                        SYSDATE
                                     );

                         else
                     /*    update tb_evolucao_funcional g set g.dat_fim_efeito = v_dat_fim_efeito_ant-1
                          WHERE G.NUM_MATRICULA = v_id_servidor
                          and g.cod_ins = v_cod_ins
                          and g.dat_ini_efeito  =    c_dat_inicio_ant
                          and g.cod_ide_cli     =    c_cod_ide_cli                                      --  2 COD_IDE_CLI
                          and g.cod_entidade     =   c_cod_entidade                                     --  3 COD_ENTIDADE
                          and g.cod_ide_rel_func =   c_cod_ide_rel_func;*/

              --          SP_ATUALIZA_DATA_FINAL(c_cod_ide_cli) ;


                        -- Atulizada data inicial de aposentados
                          SP_ATUAL_DT_ADMISSAO(v_id_servidor);

                     end if;
                 End If;
               end loop;

            o_cod_erro := 0;
           UPDATE TB_CARGA_GEN_EVF E SET COD_STATUS_PROCESSAMENTO = 0
           WHERE E.ID_SERVIDOR = v_id_servidor
           AND E.ID_HEADER = i_id_header ;



    exception
          when ERRO_GRAVA_STATUS then
            o_cod_erro := 1;
            o_des_erro := 'Erro ao tentar gravar status';
          when OTHERS THEN
            o_cod_erro := 1;
            o_des_erro := 'Erro Geral: '||sqlerrm;

    END SP_EXEC_CARREGA_EVF;





  ----------- ========================================================



    PROCEDURE SP_CARREGA_EVF (I_ID_HEADER IN NUMBER) IS
     V_RESULT                        VARCHAR2(4000);
     V_FLG_ACAO_POSTERGADA           TB_CARGA_GEN_PROCESSO.FLG_ACAO_POSTERGADA%TYPE;
     V_COD_SITU_OCORRENCIA           TB_CARGA_GEN_LOG.COD_SITU_OCORRENCIA%TYPE;
     V_NOM_ROTINA                    VARCHAR2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_HFE';

     V_COD_ERRO                      NUMBER;
     V_DES_ERRO                      VARCHAR2(4000);
     V_QTD_PROC                      NUMBER;
     V_QTD_TOTAL                     NUMBER;

     V_COD_PROC                      NUMBER;
     V_OBS                           VARCHAR2(4000);
    BEGIN

      SP_BUSCA_DADOS_PROCESSO(I_ID_HEADER, V_FLG_ACAO_POSTERGADA, V_COD_SITU_OCORRENCIA, V_RESULT);

      IF V_RESULT IS NOT NULL THEN
         SP_ATUALIZA_HEADER(I_ID_HEADER, V_NOM_ROTINA, V_RESULT);
         RETURN;
       END IF;

      V_QTD_PROC := 0;

      SELECT COUNT(1)
        INTO V_QTD_TOTAL
        FROM TB_CARGA_GEN_EVF
       WHERE ID_HEADER = I_ID_HEADER
         AND COD_STATUS_PROCESSAMENTO = 1;
      --   AND ID_SERVIDOR = 1014560 ;

      V_COD_PROC := 3;
      V_OBS      := NULL;


      LOOP
         UPDATE TB_CARGA_GEN_EVF
              SET COD_STATUS_PROCESSAMENTO = 2 , DAT_PROCESSAMENTO = NULL, OBS_PROCESSAMENTO = NULL
              WHERE ID_HEADER = I_ID_HEADER
         --     AND ID_SERVIDOR = 1014560
      --        AND COD_STATUS_PROCESSAMENTO = 1;
              AND (ID_SERVIDOR, ID_VINCULO) IN (SELECT DISTINCT ID_SERVIDOR, ID_VINCULO
                                                               FROM TB_CARGA_GEN_EVF
                                                              WHERE ID_HEADER = I_ID_HEADER
                                                               AND COD_STATUS_PROCESSAMENTO = 1
                                                            --   FETCH FIRST 20 ROWS ONLY
                                                                );

         IF SQL%ROWCOUNT = 0 OR V_QTD_PROC = V_QTD_TOTAL THEN
              EXIT;
         END IF;

        SELECT COUNT(1)
        INTO V_QTD_TOTAL
        FROM TB_CARGA_GEN_EVF
       WHERE ID_HEADER = I_ID_HEADER
         AND COD_STATUS_PROCESSAMENTO = 2;



         SP_EXEC_CARREGA_EVF(I_ID_HEADER,
                             V_FLG_ACAO_POSTERGADA,
                             V_COD_ERRO,
                             V_DES_ERRO
                             );

         V_QTD_PROC := V_QTD_PROC + SQL%ROWCOUNT;
         IF V_COD_ERRO = 1 THEN
           ROLLBACK;

           V_COD_PROC := 4;
           V_OBS      := V_DES_ERRO;

            EXIT;
         END IF;
       END LOOP;

       UPDATE TB_CARGA_GEN_HEADER A
            SET A.COD_STATUS_PROCESSAMENTO = V_COD_PROC,
                A.DES_OBSERVACAO = V_OBS,
                A.DAT_PROCESSAMENTO = SYSDATE,
                A.NOM_PRO_ULT_ATU = V_NOM_ROTINA,
                A.NOM_USU_ULT_ATU = USER,
                A.DAT_ULT_ATU = SYSDATE
          WHERE ID = I_ID_HEADER;

       UPDATE TB_CARGA_GEN_EVF
          SET COD_STATUS_PROCESSAMENTO = 1
        WHERE ID_HEADER = I_ID_HEADER
          AND COD_STATUS_PROCESSAMENTO = 2;


       COMMIT;

   END SP_CARREGA_EVF;

   PROCEDURE SP_ATUALIZA_DATA_FINAL(P_COD_IDE_CLI VARCHAR2)
as
V_DATA_FIM DATE;
V_DATA_INI DATE;
V_dat_FIM_even_func_prox  DATE;
V_DAT_INI_EFEITO   DATE;
V_ALTERADO_DAT_FIM  BOOLEAN := FALSE;
BEGIN
    FOR F IN
      (
          SELECT DAT_INI_EFEITO,COD_IDE_CLI,DAT_FIM_EFEITO,NUM_MATRICULA,TO_DATE(dat_ini_even_func_prox) dat_ini_even_func_prox
          FROM
          (
           SELECT MIN(DAT_INI_EFEITO) DAT_INI_EFEITO,COD_IDE_CLI,U.DAT_INI_EFEITO   DAT_FIM_EFEITO,U.NUM_MATRICULA
           ,lead(trim(DAT_INI_EFEITO),1) over (partition by COD_IDE_CLI--,id_vinculo
                 order by  DAT_INI_EFEITO)     as dat_ini_even_func_prox
           FROM tb_evolucao_funcional  U
           WHERE U.COD_IDE_CLI = P_COD_IDE_CLI
               AND DAT_INI_EFEITO <>  sysdate
           GROUP BY COD_IDE_CLI,U.DAT_INI_EFEITO,DAT_FIM_EFEITO,U.NUM_MATRICULA
           )
           )
      LOOP

      BEGIN
           SELECT MIN(G.DAT_INI_EFEITO),G.DAT_FIM_EFEITO
           INTO V_DAT_INI_EFEITO,V_dat_FIM_even_func_prox FROM
           tb_evolucao_funcional G
           WHERE G.COD_IDE_CLI = P_COD_IDE_CLI
           AND G.DAT_INI_EFEITO = F.DAT_INI_EFEITO
           GROUP BY   G.DAT_FIM_EFEITO
           ORDER BY 1;
           EXCEPTION
             WHEN NO_DATA_FOUND THEN
              V_dat_FIM_even_func_prox := V_dat_FIM_even_func_prox;
      END;


         IF  (V_dat_FIM_even_func_prox is  NULL)  THEN
          UPDATE  tb_evolucao_funcional U
          SET U.DAT_FIM_EFEITO = F.dat_ini_even_func_prox
          WHERE U.COD_IDE_CLI = P_COD_IDE_CLI
          AND   U.DAT_INI_EFEITO = V_DAT_INI_EFEITO;
       --   AND DAT_FIM_EFEITO IS NULL;
          V_ALTERADO_DAT_FIM := TRUE;
        END IF;
    END LOOP;
END;


PROCEDURE SP_ATUAL_DT_ADMISSAO(p_num_matricula VARCHAR2)

IS
BEGIN

for PMC in (
  select a.data_admissao,f.cod_ide_cli,a.cpf,r.cod_ide_rel_func,a.matricula
  from TMP_ADMISSAO_ATIVOS_PMC a
  inner join tb_pessoa_fisica f on a.cpf = f.num_cpf
  inner join tb_relacao_funcional r on r.cod_ide_cli = f.cod_ide_cli
  where r.num_matricula = a.matricula
  and  r.num_matricula =  p_num_matricula
  order by 2
) loop
 begin

-- Atualiza tb_servidor

 begin
     update tb_servidor s
     set s.dat_ing_serv_public = pmc.data_admissao
     where s.cod_ide_cli = pmc.cod_ide_cli;
   exception
   WHEN OTHERS THEN
     null;
   end;

--Atualiza tb_relacao_funcional
  begin
  update tb_relacao_funcional r
  set r.dat_ini_estag_prob  = pmc.data_admissao,
        r.dat_ini_exerc       = pmc.data_admissao,
        r.cod_regime          = 1,
        r.cod_plano           = (select case when a.data_admissao < '01/07/2004' then 2 else 3 end COD_PLANO
                                from user_ipesp.TMP_ADMISSAO_ATIVOS_PMC a where a.matricula = p_num_matricula),
        r.cod_vinculo         = (select case when a.categoria = 'EFE' then 1
                                            when a.categoria = 'EFP' then 1
                                            when a.categoria = 'FAT' then 2
                                            when a.categoria = 'FPB' then 3 end cod_vinculo
                                  from user_ipesp.TMP_ADMISSAO_ATIVOS_PMC a where a.matricula = p_num_matricula)
         where r.cod_ide_cli   = pmc.cod_ide_cli;
 exception
   WHEN OTHERS THEN
     null;
   end;

-- Atualiza tb_evolucao_funcional
begin
 update tb_evolucao_funcional e
     set e.dat_ini_efeito      = pmc.data_admissao,
         e.dat_pub             = pmc.data_admissao,
         e.cod_mot_evol_func   = 1
     where e.cod_ide_cli   = pmc.cod_ide_cli
     and e.num_matricula  =  pmc.matricula
     and e.dat_ini_efeito =  (SELECT min(ef.dat_ini_efeito) FROM tb_evolucao_funcional ef
                                   where ef.cod_ide_cli      = pmc.cod_ide_cli
                                     and ef.cod_ide_rel_func = pmc.cod_ide_rel_func
                                     and ef.num_matricula    = pmc.matricula);
 exception
   WHEN OTHERS THEN
     null;
   end;


-- atualiza tb_evolucao_funcional > DATA_ADMISSAO
begin
   update tb_evolucao_funcional e
       set e.cod_mot_evol_func   = 13
    where e.dat_ini_efeito      > (select MIN(DATA_ADMISSAO) from TMP_ADMISSAO_ATIVOS_PMC a where a.matricula = pmc.matricula)
     and e.cod_ide_cli         = pmc.cod_ide_cli
     and e.num_matricula       = pmc.matricula;
 exception
   WHEN OTHERS THEN
     null;
   end;

begin
  update tb_evolucao_funcional e
   set e.cod_composicao_2    = '',
       e.cod_referencia_2    = '',
       e.cod_composicao_3    = '',
       e.cod_referencia_3    = ''
 where e.cod_ide_cli         = pmc.cod_ide_cli
   and e.num_matricula       = pmc.matricula;
 exception
   WHEN OTHERS THEN
     null;
   end ;

begin
 update tb_rel_func_periodo_exerc f
   set f.dat_ini_exerc      = (select DATA_ADMISSAO from TMP_ADMISSAO_ATIVOS_PMC a where a.matricula = f.num_matricula)
 where f.cod_ide_cli        = pmc.cod_ide_cli
   and f.num_matricula      = pmc.matricula
   and f.dat_ini_exerc      = (SELECT min(fp.dat_ini_exerc) FROM tb_rel_func_periodo_exerc fp
                                 where fp.cod_ide_cli      = pmc.cod_ide_cli
                                   and fp.cod_ide_rel_func = pmc.cod_ide_rel_func
                                   and fp.num_matricula    = pmc.matricula);
 exception
   WHEN OTHERS THEN
     null;
   end;
    end;
    end loop;
    end;


END PAC_CARGA_GENERICA_PROCESSA;
/
