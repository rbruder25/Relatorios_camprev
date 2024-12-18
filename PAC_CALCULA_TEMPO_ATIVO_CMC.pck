CREATE OR REPLACE PACKAGE "PAC_CALCULA_TEMPO_ATIVO_CMC" as

  -- VARIAVEIS GLOBAIS
   PAR_COD_INS            number(8);
   PAR_COD_IDE_CLI        TB_PESSOA_FISICA.COD_IDE_CLI%TYPE;
   PAR_NUM_MATRICULA      TB_RELACAO_FUNCIONAL.NUM_MATRICULA%TYPE;
   PAR_COD_IDE_REL_FUNC   TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC%TYPE;
   PAR_COD_ENTIDADE       TB_RELACAO_FUNCIONAL.COD_ENTIDADE%TYPE;
   PAR_TIPO_CONTAGEM      NUMBER;
   PAR_DAT_CONTAGEM       DATE;
   PAR_ID_CONTAGEM        NUMBER;
   COD_IDE_CLI            TB_PESSOA_FISICA.COD_IDE_CLI%TYPE;
   NUM_MATRICULA          TB_RELACAO_FUNCIONAL.NUM_MATRICULA%TYPE;
   COD_IDE_REL_FUNC       TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC%TYPE;
   PAR_INICIO_PERIODO_LP   DATE := null;

  -------- Contadores para Tabela  de Detalhe --------
   ANO               CHAR(4);
   QTD_BRUTO         NUMBER(8);
   QTD_INCLUSAO      NUMBER(8);
   QTD_LTS           NUMBER(8);
   QTD_LSV           NUMBER(8);
   QTD_FJ            NUMBER(8);
   QTD_FI            NUMBER(8);
   QTD_SUSP          NUMBER(8);
   QTD_OUTRO         NUMBER(8);
   QTD_CARGO         NUMBER(8);
   QTD_LIQUIDO       NUMBER(8);
   QTD_DISPON        NUMBER(8);
   DATA_INICIO       DATE;
   DATA_FIM          DATE;

  ------ Complemento da Tabela de Head
   I_ANO_DETALHE     CHAR(4);
   I_GLS_DETALHE     VARCHAR(1500);


  ----- Variaveis  de Detelhe de Faltas
  d_cod_entidade      NUMBER(8);
  d_num_matricula     VARCHAR2(20);
  d_cod_ide_rel_func  NUMBER(20);
  d_cod_ide_cli       VARCHAR2(20);
  d_num_seq_lanc      NUMBER(8);
  d_cod_motivo        VARCHAR2(5);
  d_data_ini          DATE;
  d_dat_fim           DATE;
  d_desconta_contagem CHAR(1);
  d_cod_agrupa        VARCHAR2(2);
  d_des_motivo_audit  VARCHAR2(4000);
  d_tipo_desconto     VARCHAR2(5);
  d_qtd_dias          NUMBER(8);

 ----- Variaveis de Tempos Averbados ---

  d_dat_adm_orig          DATE                   ;
  d_dat_desl_orig         DATE                   ;
  d_nom_org_emp           VARCHAR2(120)          ;
  d_num_cnpj_org_emp      VARCHAR2(14)           ;
  d_cod_certidao_seq      VARCHAR(30)            ;
  d_cod_emissor           VARCHAR2(1)            ;
  d_dat_ini_considerado   DATE                   ;
  d_dat_fim_considerado   DATE                   ;
  d_num_dias_considerados NUMBER                 ;
  -------------- Parametros de Cargo e Carreira ----

  PAR_COD_CARGO    NUMBER ;
  PAR_COD_CARREIRA NUMBER ;

  ----- Parametros de Contagem de Aposentadoria ---

  BRUTO_CTC              NUMBER(8);
  INC_CTC                NUMBER(8);
  FJ_CTC                 NUMBER(8);
  FI_CTC                 NUMBER(8);
  LTS_CTC                NUMBER(8);
  LSV_CTC                NUMBER(8);
  SUSP_CTC               NUMBER(8);
  outro_CTC              NUMBER(8);
  Tempo_CTC              NUMBER(8);
  Tempo_CA               NUMBER(8);
  Tempo_CARREIRA         NUMBER(8);
  Tempo_SERVICO_PUBLICO  NUMBER(8);

 -------------- Variaveis Dias de Ferias ------------------
  PAR_INICIO_PERIODO_ADQ   DATE;
  PAR_FIM_PERIODO_ADQ      DATE;

  PAR_ULT_INICIO_PERIODO_ADQ   DATE;
  PAR_ULT_FIM_PERIODO_ADQ      DATE;

  PAR_INICIO_ORIG           DATE;

  EXISTE_PERIODOS_FERIAS BOOLEAN;

   QTD_DIAS_FALTAS       NUMBER(8);
   QTD_DIAS_180          NUMBER(8);
   QTD_DIAS_TRABALHADO   NUMBER(8);
   DIAS_FERIAS_SERVIDOR  NUMBER(8);

  D_data_calculo            DATE;
  D_dia_afa_180             NUMBER(8);
  D_dt_ini                  DATE;
  D_dt_fim                  DATE;
  D_dia_falta               NUMBER(8);
  D_dt_inicio_novo_periodo  DATE;
  D_dt_fim_novo_periodo     DATE;
  PARAM_DIAS_FALTAS         NUMBER :=180;
  v_erro exception;

---------------------- variaveis cole��o lp ------------------
type typ_rec_dias_lp is record
  (DATA_CALCULO     date,
   COD_INS          tb_contagem_servidor.cod_ins%type,
   COD_ENTIDADE     tb_contagem_servidor.cod_entidade%type,
   COD_IDE_CLI      tb_contagem_servidor.cod_ide_cli%type,
   COD_IDE_REL_FUNC tb_contagem_servidor.cod_ide_rel_func%type,
   COD_CARGO        tb_evolucao_funcional.cod_cargo%type,
   TIPO_CONTAGEM    varchar2(30),
   COD_AGRUP_AFAST  tb_motivo_afastamento.cod_agrup_afast%type);

type typ_col_dias_lp is table of typ_rec_dias_lp;

v_col_dias_lp typ_col_dias_lp := typ_col_dias_lp();

-- Cargos transferencia
type typ_col_cargos_equiv is table of tb_evolucao_funcional.cod_cargo%type;

v_col_cargos_equiv typ_col_cargos_equiv := typ_col_cargos_equiv();


--------------------


-----------------------------------------------------------------


PROCEDURE SP_CALC_ANOS_TRAB_ATIVO
(

   I_COD_INS             IN  number ,
   I_COD_IDE_CLI         IN VARCHAR2,
   I_NUM_MATRICULA       IN VARCHAR2,
   I_COD_IDE_REL_FUNC    IN  number ,
   I_COD_ENTIDADE        IN  number ,
   I_TIPO_CONTAGEM       IN  NUMBER ,
   I_DAT_CONTAGEM        IN  DATE   ,

   O_SEQ_CERTIDAO         OUT NUMBER ,
   oErrorCode    OUT  NUMBER ,
   oErrorMessage OUT  VARCHAR2
);
--------Novo criteri de Agrupa��o ---

  PROCEDURE SP_CONTAGEM_PERIODO_AGRUP_NC (I_SEQ_CERTIDAO IN NUMBER);

----- Cursor Para Contagem
  CURSOR CURTEMP_ATS IS
        SELECT COD_IDE_CLI,  NUM_MATRICULA , COD_IDE_REL_FUNC  , ANO ,

         SUM ( BRUTO)    QTD_BRUTO  ,
         SUM (Inclusao)  QTD_INCLUSAO,
         SUM (LTS)      QTD_LTS     ,
         SUM(LSV)       QTD_LSV     ,
         SUM(FJ)        QTD_FJ      ,
         SUM(FI)        QTD_FI      ,
         SUM(SUSP)      QTD_SUSP    ,
         SUM(OUTRO)     QTD_OUTRO    ,
         (
            SUM ( nvl(BRUTO,0)) +  SUM (nvl(Inclusao,0))  - SUM (nvl(LTS,0)) -  SUM(nvl(LSV,0)) -  SUM(nvl(FJ,0))  -  SUM(nvl(FI,0))  -  SUM(nvl(OUTRO,0))
         ) QTD_LIQUIDO
          FROM (

         -- Tabela de Contagem  Dias da Evoluca�ao Funcional
        ---- Dias Bruto -----
        SELECT 'BRUTO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,
               count(*) BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO

          from (SELECT distinct
                                A.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC


                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       tb_dias_apoio         A
                 WHERE

                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)

                   --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )


                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')


                   --YUMI EM 01/05/2018: INCLU�DO PARA PEGAR V�NCULOS ANTERIORES DA RELACAO FUNCIONAL
                   union

                   SELECT distinct
                                A.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC


                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       tb_dias_apoio         A
                 WHERE

                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_IDE_REL_FUNC           != PAR_COD_IDE_REL_FUNC

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                   --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

               --     AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                   )


         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

        UNION ALL
        ---- Tabela de Contagem Dias Historico de Tempo
        ----   Historico de Tempo

        SELECT 'INCLUSAO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,
               0 BRUTO,
               count(*) Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO

          from (
          SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC
                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

             --       AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomit�ncia
                           ---com qualquer v�nculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre per�odos de v�nculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                        --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                        AND EF.FLG_STATUS = 'V'

                        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

            --        AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
                        )

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

        UNION ALL

        ---- Tabela de Contagem De Licencias
        ----   Historico de Tempo
        SELECT 'LTS' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               count(*) lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO
          from (SELECT distinct
                                 AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                 --  AND MO.AUMENTA_CONT_ATS = 'S'
                   AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA= 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                      )

                   AND MO.COD_AGRUP_AFAST = 2

                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

         --           AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

        UNION ALL
        ---- Tabela de Contagem De Licencias
        ----   Historico de Tempo
        SELECT 'LSV' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               count(*) lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                  -- AND MO.AUMENTA_CONT_ATS = 'S'
                   AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA= 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                      )

                   AND MO.COD_AGRUP_AFAST = 1

                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

               --     AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

        UNION ALL
        ---- Tabela de Contagem Faltas

        SELECT 'FALTAS - FJ' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               count(*) FJ,
               0 FI,
               0 SUSP,
               0 OUTRO
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC
                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                    = T.COD_INS
                   AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND AA.DATA_CALCULO                <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO                >= t.dat_ini_afast
                   AND AA.DATA_CALCULO                <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST                = T.COD_MOT_AFAST
              --     AND MO.AUMENTA_CONT_ATS             = 'S'
                   AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA= 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                      )
                   AND MO.COD_AGRUP_AFAST              = 3
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

             --       AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

        UNION ALL
        ---- Tabela de Contagem Faltas

        SELECT 'FALTAS -FI' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               count(*) FI,
               0 SUSP,
               0 OUTRO
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC
                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
               --    AND MO.AUMENTA_CONT_ATS = 'S'
                   AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA= 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                      )
                   AND MO.COD_AGRUP_AFAST = 4

                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

             --       AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

        UNION ALL
        ---- Tabela de Contagem Faltas SUSPENSOS

        SELECT 'SUSP' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               COUNT(*) SUSP,
               0 OUTRO
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC
                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                  WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                  -- AND MO.AUMENTA_CONT_ATS = 'S'

                   AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA= 'S')
                      OR
                        (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                      )

                   AND MO.COD_AGRUP_AFAST = 5

                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

              --      AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
        -------------------------------------------

        UNION ALL

        ---- Tabela de Contagem Faltas OUTRO
        SELECT 'OUTRO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               COUNT(*) OUTRO
          from (SELECT distinct
                                 AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                SYSDATE AS DAT_EXECUCAO

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS = 'S'
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

               --     AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                   AND NOT EXISTS
                 (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               Tb_afastamento        TT,
                               tb_dias_apoio         A,
                               tb_motivo_afastamento MO
                         WHERE RF.COD_INS               = PAR_COD_INS
                         --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                          AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           --AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                           AND
                              ------------------------------------------
                               RF.COD_INS = T.COD_INS
                           AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                           AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                           AND
                              ------------------------------------------

                               TT.COD_INS = 1
                           AND TT.COD_IDE_CLI = PAR_COD_IDE_CLI
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= TT.dat_ini_afast
                           AND A.DATA_CALCULO <= NVL(TT.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                           AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                           AND MO.AUMENTA_CONT_ATS = 'S'
                           AND NVL(MO.COD_AGRUP_AFAST, 0) IN (1, 2, 3, 4, 5)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                  --  AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                        )

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

         union
         ---Yumi em 01/05/2018: inclu�do para descontar os dias de descontos
         ---relacionados ao hist�rico de tempos averbados
         select
               'OUTRO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(dat_adm_orig, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               sum(nvl(qtd_dias_ausencia,0)) OUTRO
          from (
                          SELECT distinct
                                t1.dat_adm_orig             ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                t1.qtd_dias_ausencia
                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T1,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                  ------------------------------------------------------
                   AND T1.COD_INS                    =  RF.COD_INS
                   AND T1.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T1.FLG_EMP_PUBLICA            ='S'

                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T1.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T1.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)
                   AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T1.FLG_TMP_ATS = 'S')
                    OR
                       (PAR_TIPO_CONTAGEM IN (2)   AND T1.FLG_TMP_LIC_PREM = 'S')
                       )


                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

             --       AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomit�ncia
                           ---com qualquer v�nculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

              --      AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                        )

                )
                group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(dat_adm_orig, 'yyyy')

   /*
            -- PERIODOS OTROS DA PANDEMIA --- 2023-08-16
                             ---- Tabela de Contagem Faltas OUTRO
                            UNION  All
                                    SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                     to_char(DATA_CALCULO, 'yyyy') Ano,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL   RF,
                                               tb_dias_apoio         AA,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_VINCULO not in   (  '5', '6')
                                              ------------------------------------------

                                          AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                         AND RF.COD_INS           = EF.COD_INS
                                          AND RF.NUM_MATRICULA   =  EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC=  EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI    = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE   = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                          AND C.COD_INS       = EF.COD_INS
                                          AND C.COD_ENTIDADE  = EF.COD_ENTIDADE
                                         AND AA.DATA_CALCULO BETWEEN  TO_DATE('28/05/2020','DD/MM/YYYY')  AND TO_DATE('31/12/2021','DD/MM/YYYY')
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO



                                       )

                   group by COD_ENTIDADE,
                            COD_IDE_CLI,
                            NUM_MATRICULA,
                            COD_IDE_REL_FUNC,
                            to_char(DATA_CALCULO, 'yyyy')

        ------------------------------------------------------
*/
             UNION ALL
          SELECT 'TODOS OS ANOS ZERADOS ---' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO
          from (
                SELECT distinct
                               A.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       tb_dias_apoio         A
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
               ----------------------------------------------------------------
                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                 )
               group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

         UNION ALL
         SELECT 'INCLUSAO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               to_char(DATA_CALCULO, 'yyyy') Ano,
               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC
                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM


                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                    AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
               )
               group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
                  ) GROUP BY  COD_IDE_CLI,  NUM_MATRICULA , COD_IDE_REL_FUNC  , ANO   order by ano;

---------------*********** CURSOR LP ********-------------------------
CURSOR CURTEMP_LP_DIAS IS
SELECT DATA_CALCULO,
       COD_INS,--CURTEMP_LP_DIAS
       COD_ENTIDADE,
       COD_IDE_CLI,
       COD_IDE_REL_FUNC,
       COD_CARGO,
       TIPO_CONTAGEM,
       COD_AGRUP_AFAST
FROM (
  SELECT distinct A.DATA_CALCULO ,
                  1 AS COD_INS,
                  RF.COD_ENTIDADE,
                  RF.COD_IDE_CLI,
                  RF.NUM_MATRICULA,
                  RF.COD_IDE_REL_FUNC,
                  EF.COD_CARGO,
                  'BRUTO' AS TIPO_CONTAGEM,
                  null as COD_AGRUP_AFAST
    FROM TB_RELACAO_FUNCIONAL  RF,
         TB_EVOLUCAO_FUNCIONAL EF,
         tb_dias_apoio         A
   WHERE RF.COD_INS = PAR_COD_INS
     AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
    -- AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
    -- AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
    -- AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
     AND RF.COD_INS = EF.COD_INS
     AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
     AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
     AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
     AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
     AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
     AND EF.FLG_STATUS = 'V'
     AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
     AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
     --Yumi em 06/11/2019: ajustado para fechar a vig�ncia do cargo da evolu��o na
     --data de fim de exerc�cio.
     --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
     AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO,  NVL(RF.DAT_FIM_EXERC,PAR_DAT_CONTAGEM) )
     AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)

     --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
     --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

   -- AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
  union
    SELECT distinct AA.DATA_CALCULO,
                    1 AS COD_INS,
                    RF.COD_ENTIDADE,
                    RF.COD_IDE_CLI,
                    RF.NUM_MATRICULA,
                    RF.COD_IDE_REL_FUNC,
                    null as COD_CARGO,
                    'HIST' AS TIPO_CONTAGEM,
                    null as COD_AGRUP_AFAST
       FROM TB_RELACAO_FUNCIONAL  RF,
            Tb_Hist_Carteira_Trab T,
            tb_dias_apoio         AA
      WHERE RF.COD_INS = PAR_COD_INS
        AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
        AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
        AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
        AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
        AND T.COD_INS = RF.COD_INS
        AND T.COD_IDE_CLI = RF.COD_IDE_CLI
        AND T.FLG_TMP_LIC_PREM = 'S'
        AND T.FLG_EMP_PUBLICA = 'S'
        AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
        ---AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
        --AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)
        AND AA.DATA_CALCULO >= T.DAT_INI_LIC_PREM
        AND AA.DATA_CALCULO <=  NVL(T.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM)
        AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
     --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

  --  AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

        AND NOT EXISTS (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               TB_EVOLUCAO_FUNCIONAL EF,
                               TB_DIAS_APOIO         A
                         WHERE RF.COD_INS = 1
                           AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                            --Yumi em 06/11/2019: comentado para remover concomit�ncia
                            ---com qualquer v�nculo que exista na relacao funcional
                           --AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS = EF.COD_INS
                           AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                            --Yumi em 06/11/2019: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                            ---Yumi em 06/11/2019: ajustado pois nao estava pegando tempos averbados
                            --entre per�odos de v�nculos)
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                            --Yumi em 06/11/2019:  inclu�do o status da evolucao para pegar somente vigente.)
                            AND EF.FLG_STATUS = 'V'
                            --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                            --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                            --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                         --   AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
                           )
  union
    SELECT distinct AA.DATA_CALCULO,
                    1 AS COD_INS,
                    RF.COD_ENTIDADE,
                    RF.COD_IDE_CLI,
                    RF.NUM_MATRICULA,
                    RF.COD_IDE_REL_FUNC,
                    null as COD_CARGO,
                    'HIST' AS TIPO_CONTAGEM,
                    null as COD_AGRUP_AFAST
       FROM TB_RELACAO_FUNCIONAL  RF,
            Tb_Hist_Carteira_Trab T,
            tb_dias_apoio         AA
      WHERE RF.COD_INS = PAR_COD_INS
        AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
        AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
        AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
        AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC

        AND RF.COD_IDE_CLI = 1009257
        AND RF.COD_ENTIDADE = 1
        AND RF.NUM_MATRICULA = 10318
        AND RF.COD_IDE_REL_FUNC = 1031803

        AND T.COD_INS = RF.COD_INS
        AND T.COD_IDE_CLI = RF.COD_IDE_CLI
        AND T.FLG_TMP_LIC_PREM = 'S'
        AND T.FLG_EMP_PUBLICA = 'S'
        and t.dat_ini_lic_prem = '01/02/2005'

   union all
      SELECT distinct AA.DATA_CALCULO,
                      1 AS COD_INS,
                      AFA.COD_ENTIDADE,
                      AFA.COD_IDE_CLI,
                      AFA.NUM_MATRICULA,
                      AFA.COD_IDE_REL_FUNC,
                      null as COD_CARGO,
                      'AFAST' AS TIPO_CONTAGEM,
                      mo.cod_agrup_afast as COD_AGRUP_AFAST
        from
        (
             select
             af.cod_ins,
             af.cod_entidade,
             af.cod_ide_cli,
             af.num_matricula,
             af.cod_ide_rel_func,
             af.cod_mot_afast,
             af.dat_ini_afast,
             af.dat_ret_prev

       from  tb_afastamento af ,
             tb_relacao_funcional rf
             where rf.cod_ins = PAR_COD_INS
              and rf.cod_ide_cli = PAR_COD_IDE_CLI
             ---Yumi em 06/11/2019: comentado para verificar licen�a
             --de qualquer v�nculo da relacao funcional
              --and rf.cod_entidade = PAR_COD_ENTIDADE
            ---and rf.num_matricula = PAR_NUM_MATRICULA
             --and rf.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
             and rf.cod_ide_cli = af.cod_ide_cli
             and rf.cod_entidade = af.cod_entidade
             and rf.num_matricula = af.num_matricula
             and rf.cod_ide_rel_func = af.cod_ide_rel_func
             and rf.cod_vinculo not in (/*'22',*/ '5', '6')
             )afa

                                 join tb_motivo_afastamento mo
                                 on mo.cod_mot_afast = afa.cod_mot_afast
                               join tb_dias_apoio AA
                                 on  AA.DATA_CALCULO < PAR_DAT_CONTAGEM
                                 AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                and AA.DATA_CALCULO between afa.dat_ini_afast and  afa.dat_ret_prev
        where MO.AUMENTA_CONT_LICENCA = 'S'

        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
        --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
        --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

   --      AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')


   union all
      SELECT distinct AA.DATA_CALCULO,
                      1 AS COD_INS,
                      AA.COD_ENTIDADE,
                      AA.COD_IDE_CLI,
                      AA.NUM_MATRICULA,
                      AA.COD_IDE_REL_FUNC,
                      null as COD_CARGO,
                      'OUTROS' AS TIPO_CONTAGEM,
                      '9' as COD_AGRUP_AFAST
        from
        (
             select
             rf.cod_ins,
             rf.cod_entidade,
             rf.cod_ide_cli,
             rf.num_matricula,
             rf.cod_ide_rel_func,
             1 as cod_mot_afast,
             aa.data_calculo
FROM TB_RELACAO_FUNCIONAL   RF,
                                               tb_dias_apoio         AA,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_VINCULO not in   (  '5', '6')
                                              ------------------------------------------

                                          AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                         AND RF.COD_INS           = EF.COD_INS
                                          AND RF.NUM_MATRICULA   =  EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC=  EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI    = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE   = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                          AND C.COD_INS       = EF.COD_INS
                                          AND C.COD_ENTIDADE  = EF.COD_ENTIDADE
                                          and PAR_TIPO_CONTAGEM NOT IN (3)
                                         AND AA.DATA_CALCULO BETWEEN  TO_DATE('28/05/2020','DD/MM/YYYY')  AND TO_DATE('31/12/2021','DD/MM/YYYY')
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO
        ) AA

        );



---------******************** FIM CURSOR LP **********************-----
 -----------**** Inicio de Cursor de Detalhes Faltas ATS ------------------
 CURSOR CURTEMP_ATS_FALTAS_DETALHE IS
 select

                cod_entidade       ,
                num_matricula      ,
                cod_ide_rel_func   ,
                cod_ide_cli        ,
                num_seq_lanc       ,
                cod_motivo         ,
                data_ini           ,
                dat_fim            ,
                desconta_contagem  ,
                cod_agrupa         ,
                des_motivo_audit   ,
                tipo_desconto  ,
                count(*) Qtd_dias
   From (
            SELECT

                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto

                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC

                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_ATS = 'S'
                             AND MO.COD_AGRUP_AFAST = 2

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')



                  UNION ALL
                   --- LSV' as Tipo,
                   SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_ATS = 'S'
                             AND MO.COD_AGRUP_AFAST = 1

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')



                  UNION ALL
                  -- 'FALTAS - FJ' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                    = T.COD_INS
                             AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO                <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO                >= t.dat_ini_afast
                             AND AA.DATA_CALCULO                <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST                = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_ATS             = 'S'
                             AND MO.COD_AGRUP_AFAST              = 3

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')


                  UNION ALL
                   -- 'FALTAS -FI' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_ATS = 'S'
                             AND MO.COD_AGRUP_AFAST = 4

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')



                  UNION ALL
                   -- 'SUSP' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                            WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                              AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_ATS = 'S'
                             AND MO.COD_AGRUP_AFAST = 5

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')


                  UNION ALL

                  ---- Tipo OUTRO
                     SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto

                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_ATS = 'S'

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                             AND NOT EXISTS
                           (SELECT 1
                                    FROM TB_RELACAO_FUNCIONAL  RF,
                                         Tb_afastamento        TT,
                                         tb_dias_apoio         A,
                                         tb_motivo_afastamento MO
                                   WHERE
                                         RF.COD_INS                    =  PAR_COD_INS
                                     AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                     AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                     AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                     AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                     AND
                                        ------------------------------------------
                                         RF.COD_INS = T.COD_INS
                                     AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                     AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                     AND RF.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                                     AND
                                        ------------------------------------------

                                         TT.COD_INS = 1
                                     AND TT.COD_IDE_CLI =  PAR_COD_IDE_CLI
                                     AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                     AND A.DATA_CALCULO >= TT.dat_ini_afast
                                     AND A.DATA_CALCULO <= NVL(TT.DAT_RET_PREV, SYSDATE)
                                     AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                     AND MO.AUMENTA_CONT_ATS = 'S'
                                     AND NVL(MO.COD_AGRUP_AFAST, 0) IN (1, 2, 3, 4, 5)
                                     AND AA.DATA_CALCULO = A.DATA_CALCULO
                                     --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                                     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                     --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                                     AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                                  )
                 )

             Group by
                cod_ins            ,
                cod_entidade       ,
                num_matricula      ,
                cod_ide_rel_func   ,
                cod_ide_cli        ,
                num_seq_lanc       ,
                cod_motivo         ,
                data_ini           ,
                dat_fim            ,
                desconta_contagem  ,
                cod_agrupa         ,
                des_motivo_audit   ,
                tipo_desconto
                order by data_ini;


 --------***** Fim de Cursos de Detalhes  Faltas  ATS ********--------------

  -----------**** Inicio de Cursor de Detalhes Faltas LP ------------------
 CURSOR CURTEMP_LP_FALTAS_DETALHE IS
 select

                cod_entidade       ,
                num_matricula      ,
                cod_ide_rel_func   ,
                cod_ide_cli        ,
                num_seq_lanc       ,
                cod_motivo         ,
                data_ini           ,
                dat_fim            ,
                desconta_contagem  ,
                cod_agrupa         ,
                des_motivo_audit   ,
                tipo_desconto  ,
                count(*) Qtd_dias
   From (
            SELECT

                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto

                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC

                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_LICENCA = 'S'
                             AND MO.COD_AGRUP_AFAST = 2

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')



                  UNION ALL
                   --- LSV' as Tipo,
                   SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_LICENCA = 'S'
                             AND MO.COD_AGRUP_AFAST = 1

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')


                  UNION ALL
                  -- 'FALTAS - FJ' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                    = T.COD_INS
                             AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO                <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO                >= t.dat_ini_afast
                             AND AA.DATA_CALCULO                <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                             AND MO.COD_MOT_AFAST                = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_LICENCA         = 'S'
                             AND MO.COD_AGRUP_AFAST              = 3

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                  UNION ALL
                   -- 'FALTAS -FI' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_LICENCA        = 'S'
                             AND MO.COD_AGRUP_AFAST = 4

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                  UNION ALL
                   -- 'SUSP' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                            WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                              AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_LICENCA      = 'S'
                             AND MO.COD_AGRUP_AFAST           = 5

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                  UNION ALL

                  ---- Tipo OUTRO
                     SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto

                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.AUMENTA_CONT_LICENCA      = 'S'

                             --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                             --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                             AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                             AND NOT EXISTS
                           (SELECT 1
                                    FROM TB_RELACAO_FUNCIONAL  RF,
                                         Tb_afastamento        TT,
                                         tb_dias_apoio         A,
                                         tb_motivo_afastamento MO
                                   WHERE
                                         RF.COD_INS                    =  PAR_COD_INS
                                     AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                     AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                     AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                     AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                     AND
                                        ------------------------------------------
                                         RF.COD_INS = T.COD_INS
                                     AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                     AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                     AND RF.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                                     AND
                                        ------------------------------------------

                                         TT.COD_INS = 1
                                     AND TT.COD_IDE_CLI =  PAR_COD_IDE_CLI
                                     AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                     AND A.DATA_CALCULO >= TT.dat_ini_afast
                                     AND A.DATA_CALCULO <= NVL(TT.DAT_RET_PREV, SYSDATE)
                                     AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                     AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                     AND MO.AUMENTA_CONT_LICENCA      = 'S'
                                     AND NVL(MO.COD_AGRUP_AFAST, 0) IN (1, 2, 3, 4, 5)
                                     AND AA.DATA_CALCULO = A.DATA_CALCULO
                                     --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                                     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                     --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                                     AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                                  )
                 )

             Group by
                cod_ins            ,
                cod_entidade       ,
                num_matricula      ,
                cod_ide_rel_func   ,
                cod_ide_cli        ,
                num_seq_lanc       ,
                cod_motivo         ,
                data_ini           ,
                dat_fim            ,
                desconta_contagem  ,
                cod_agrupa         ,
                des_motivo_audit   ,
                tipo_desconto
                order by data_ini;


 --------***** Fim de Cursos de Detalhes  Faltas  LP ********--------------
 ------- ******* Curos de Detalhe de Tempos averbados  *****-----------
   CURSOR CURTEMP_ATS_TEMPOS_DETALHE IS
         /*SELECT

                      t.dat_adm_orig          dat_adm_orig      ,
                      t.dat_desl_orig         dat_desl_orig     ,
                      t.nom_org_emp           nom_org_emp       ,
                      t.num_cnpj_org_emp      num_cnpj_org_emp  ,
                      t.num_certidao          cod_certidao_seq  ,
                      t.cod_emissor           cod_emissor       ,
                      min(aa.data_calculo)    dat_ini_per_cons  ,
                      max(aa.data_calculo)    dat_fim_per_cons  ,
                      count(*) num_dias_cons                    \*,
                      t.nom_org_emp  nom_empresa               *\

                   ---------------------------------------------


                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO  <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, SYSDATE)

                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                               RF.COD_INS                    = PAR_COD_INS
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC

                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           AND A.DATA_CALCULO  <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                        )

                        group by
                          t.cod_ins              ,
                          t.dat_adm_orig       ,
                          t.dat_desl_orig      ,
                          t.nom_org_exp_cert   ,
                          t.num_cnpj_org_emp   ,
                          t.num_certidao       ,
                          t.cod_emissor        ,
                          t.nom_org_emp ; */

         --Yumi/Pepe: Ajuste realizado em 27/04/2018 para deduzir os afastamentos

         SELECT
                      dat_adm_orig      ,
                      dat_desl_orig     ,
                      nom_org_emp       ,
                      num_cnpj_org_emp  ,
                      cod_certidao_seq  ,
                      cod_emissor       ,
                      dat_ini_per_cons  ,
                      dat_fim_per_cons  ,
                      ---num_dias_cons as num_dias_cons_orig,
                      num_dias_cons -
                                       nvl((
                                       select t1.qtd_dias_ausencia from Tb_Hist_Carteira_Trab T1
                                       where t1.cod_ins           = 1
                                       and t1.cod_ide_cli         = yy.cod_ide_cli
                                       and t1.dat_adm_orig        = yy.dat_adm_orig
                                       and t1.dat_desl_orig       = yy.dat_desl_orig
                                       and t1.nom_org_emp         = yy.nom_org_emp
                                       and t1.num_cnpj_org_emp    = yy.num_cnpj_org_emp
                                       and t1.num_certidao        = yy.cod_certidao_seq
                                       and t1.cod_emissor         = yy.cod_emissor
                                       ),0)
                                   as num_dias_cons
              FROM
            (
            SELECT
                      t.cod_ide_cli           cod_ide_cli       ,
                      t.dat_adm_orig          dat_adm_orig      ,
                      t.dat_desl_orig         dat_desl_orig     ,
                      t.nom_org_emp           nom_org_emp       ,
                      t.num_cnpj_org_emp      num_cnpj_org_emp  ,
                      t.num_certidao          cod_certidao_seq  ,
                      t.cod_emissor           cod_emissor       ,
                      min(aa.data_calculo)    dat_ini_per_cons  ,
                      max(aa.data_calculo)    dat_fim_per_cons  ,
                      count(*) num_dias_cons                    /*,
                      t.nom_org_emp  nom_empresa               */

                   ---------------------------------------------


                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO  <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, SYSDATE)
                   AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)

                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                   --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                   AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomit�ncia
                           ---com qualquer v�nculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND EF.FLG_STATUS                = 'V'
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre per�odos de v�nculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                           --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                           AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                        )

                        group by
                          t.cod_ide_cli       ,
                          t.cod_ins             ,
                          t.dat_adm_orig       ,
                          t.dat_desl_orig      ,
                          t.nom_org_exp_cert   ,
                          t.num_cnpj_org_emp   ,
                          t.num_certidao       ,
                          t.cod_emissor        ,
                          t.nom_org_emp
                        )YY
                        order by 1
                        ;

 ---------------------------------------------------------------------


--***********------ Cursor de Detalhe de Legandas ********** -----------
CURSOR CURTEMP_DETALHE IS
----- Historico de Tempo
SELECT  ANO,
        LISTAGG(GLS_DETALHE, '-') WITHIN GROUP(ORDER BY DATA_CALCULO) GLS_DETALHE
  FROM (
                SELECT distinct AA.DATA_CALCULO,
                         TO_CHAR(AA.DATA_CALCULO, 'YYYY') ANO,
                         CASE
                           WHEN AA.DATA_CALCULO = T.DAT_ADM_ORIG THEN
                            'Certidao n� ' || T.NUM_CERTIDAO || ', emissor ' ||
                            (SELECT CO.DES_DESCRICAO
                               FROM TB_CODIGO CO
                              WHERE CO.COD_INS = 0
                                AND CO.COD_NUM = 2378
                                AND CO.COD_PAR = T.COD_EMISSOR) ||
                            ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                            ', in�cio em ' ||
                            TO_CHAR(T.DAT_ADM_ORIG, 'DD/MM/RRRR')
                           WHEN AA.DATA_CALCULO = T.DAT_DESL_ORIG THEN
                            'Certidao n� ' || T.NUM_CERTIDAO || ', emissor ' ||
                            (SELECT CO.DES_DESCRICAO
                               FROM TB_CODIGO CO
                              WHERE CO.COD_INS = 0
                                AND CO.COD_NUM = 2378
                                AND CO.COD_PAR = T.COD_EMISSOR) ||
                            ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                            ', fim em ' ||
                            TO_CHAR(T.DAT_DESL_ORIG, 'DD/MM/RRRR')

                         END GLS_DETALHE

           FROM TB_RELACAO_FUNCIONAL  RF,
                Tb_Hist_Carteira_Trab T,
                tb_dias_apoio         AA
          WHERE
                RF.COD_INS             = PAR_COD_INS
               AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
               AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
               AND RF.NUM_MATRICULA    =  PAR_NUM_MATRICULA
               AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
         ------------------------------------------------------
       AND T.COD_INS = RF.COD_INS
       AND T.COD_IDE_CLI = RF.COD_IDE_CLI
       AND T.FLG_EMP_PUBLICA = 'S'
       AND AA.DATA_CALCULO<=PAR_DAT_CONTAGEM
       AND (AA.DATA_CALCULO = T.DAT_ADM_ORIG OR
          AA.DATA_CALCULO = NVL(T.DAT_DESL_ORIG, SYSDATE))

      --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
     --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

    AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
       AND NOT EXISTS (

           /*SELECT 1
             FROM TB_RELACAO_FUNCIONAL  RF,
                   TB_EVOLUCAO_FUNCIONAL EF,
                   tb_dias_apoio         A
              WHERE
                   RF.COD_INS         = PAR_COD_INS
              AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
              AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
              AND RF.NUM_MATRICULA    =  PAR_NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
              AND RF.COD_INS          = EF.COD_INS
              AND RF.NUM_MATRICULA    = EF.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
              AND RF.COD_IDE_CLI      = EF.COD_IDE_CLI
              AND RF.COD_ENTIDADE     = EF.COD_ENTIDADE
              AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
              AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
              AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
              AND AA.DATA_CALCULO = A.DATA_CALCULO*/



                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomit�ncia
                           ---com qualquer v�nculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND EF.FLG_STATUS                = 'V'
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre per�odos de v�nculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                           --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

                           AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

           )

         UNION ALL
         --------------------------------------------------
          -- Detalhe de Rela�ao Funcional
         --------------------------------------------------
         SELECT distinct A.DATA_CALCULO,
                         TO_CHAR(A.DATA_CALCULO, 'YYYY'),
                         (

                          (SELECT CO.DES_DESCRICAO
                             FROM TB_CODIGO CO
                            WHERE CO.COD_INS = 0
                              AND CO.COD_NUM = 2140
                              AND CO.COD_PAR = EF.COD_MOT_EVOL_FUNC) || ' ' ||
                          'no cargo ' ||
                          (SELECT CAR.NOM_CARGO
                             FROM TB_CARGO CAR
                            WHERE CAR.COD_INS = 1
                              AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
                              AND CAR.COD_PCCS = EF.COD_PCCS
                              AND CAR.COD_CARREIRA = EF.COD_CARREIRA
                              AND CAR.COD_QUADRO = EF.COD_QUADRO
                              AND CAR.COD_CLASSE = EF.COD_CLASSE
                              AND CAR.COD_CARGO = EF.COD_CARGO) ||
                          ' a partir de ' || EF.DAT_INI_EFEITO || '. ' ||
                          EF.DES_MOTIVO_AUDIT

                         ) GLS_DETALHE

           FROM TB_RELACAO_FUNCIONAL  RF,
                TB_EVOLUCAO_FUNCIONAL EF,
                tb_dias_apoio         A
          WHERE
         --------------------------------------------------------
         RF.COD_INS              = PAR_COD_INS
         AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
         --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
          --da relacao funcional
         --AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
         --AND RF.NUM_MATRICULA    = PAR_NUM_MATRICULA
         --AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
         -----------------------------------------------------------

         AND RF.COD_INS          = EF.COD_INS
         AND RF.NUM_MATRICULA    = EF.NUM_MATRICULA
         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
         AND RF.COD_IDE_CLI      = EF.COD_IDE_CLI
         AND RF.COD_ENTIDADE     = EF.COD_ENTIDADE
         AND EF.FLG_STATUS       = 'V'
       AND A.DATA_CALCULO  <=PAR_DAT_CONTAGEM
       AND (A.DATA_CALCULO = EF.DAT_INI_EFEITO
          --OR  A.DATA_CALCULO = NVL(EF.DAT_FIM_EFEITO, SYSDATE)

        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
        --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
        --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

         AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
          )

         --------------------------------------------------
          -- Detalhe de Cargo Comissionado
         --------------------------------------------------

         UNION ALL
         SELECT distinct A.DATA_CALCULO,
                         TO_CHAR(A.DATA_CALCULO, 'YYYY'),
                         (

                          (SELECT CO.DES_DESCRICAO
                             FROM TB_CODIGO CO
                            WHERE CO.COD_INS = 0
                              AND CO.COD_NUM = 2401
                              AND CO.COD_PAR = EF.COD_MOT_EVOL_FUNC) || ' ' ||
                          'no cargo ' ||
                          (SELECT CAR.NOM_CARGO
                             FROM TB_CARGO CAR
                            WHERE CAR.COD_INS = 1
                              AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
                              AND CAR.COD_PCCS = EF.COD_PCCS
                              AND CAR.COD_CARREIRA = EF.COD_CARREIRA
                              AND CAR.COD_QUADRO = EF.COD_QUADRO
                              AND CAR.COD_CLASSE = EF.COD_CLASSE
                              AND CAR.COD_CARGO = EF.COD_CARGO_COMP) ||
                          ' a partir de ' || EF.DAT_INI_EFEITO || '. ') GLS_DETALHE

           FROM TB_RELACAO_FUNCIONAL      RF,
                TB_EVOLU_CCOMI_GFUNCIONAL EF,
                tb_dias_apoio             A
          WHERE
         --------------------------------------------------------
             RF.COD_INS          = PAR_COD_INS
         AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
         --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
          --da relacao funcional
         --AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
         --AND RF.NUM_MATRICULA    =  PAR_NUM_MATRICULA
         --AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
         -----------------------------------------------------------

       AND RF.COD_INS            = EF.COD_INS
       AND RF.NUM_MATRICULA      = EF.NUM_MATRICULA
       AND RF.COD_IDE_REL_FUNC   = EF.COD_IDE_REL_FUNC
       AND RF.COD_IDE_CLI        = EF.COD_IDE_CLI
       AND RF.COD_ENTIDADE       = EF.COD_ENTIDADE
       AND A.DATA_CALCULO        = EF.DAT_INI_EFEITO
       AND A.DATA_CALCULO        <=PAR_DAT_CONTAGEM

       --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
     --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio

    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
         )

 WHERE GLS_DETALHE IS NOT NULL
 GROUP BY ANO;

  --------- CURSORES DE CONTAGEM DE APOSENTADORIA E SEUS DETALHES  ----
  ----------------    TEMPOS DE CONTRIBUI�AO  ------------


   CURSOR CUR_APO_TOT IS
   SELECT

                 cod_ide_cli                                      ,
                 num_matricula                                    ,
                 cod_ide_rel_func                                 ,
                 TO_CHAR(data_calculo,'YYYY')           ANO       ,
                 SUM(DIA_BRUTO)  + SUM (dia_inclusao )  BRUTO_CTC ,
                 SUM (dia_inclusao )                    INC_CTC   ,
                 SUM( FJ_CTC)                           FJ_CTC    ,
                 SUM( FI_CTC)                           FI_CTC    ,
                 SUM (lts_ctc )                         LTS_CTC   ,
                 SUM (lSV_ctc )                         LSV_CTC   ,
                 SUM (SUSPE_CTC)                        SUSP_CTC  ,
                 SUM (dia_otro_ctc)                     outro_CTC ,

                 (SUM(DIA_BRUTO) + SUM (dia_inclusao ) - (
                                   SUM( FJ_CTC)   +
                                   SUM( FI_CTC)   +
                                   SUM (SUSPE_CTC)+
                                   SUM (lSV_ctc ) +
                                   SUM (lts_ctc ) +
                                   sum ( dia_otro_ctc)  )
                 ) Tempo_CTC,

                  (SUM(DIA_BRUTO) + SUM (dia_inclusao ) - (
                                   SUM( FJ_CCA)   +
                                   SUM( FI_CCA)   +
                                   SUM (SUSPE_CCA)+
                                   SUM (lSV_CCa ) +
                                   SUM (lts_CCa )-- +
                                   --sum ( dia_otro_ctc)
                                    )
                 ) Tempo_CA,
                  (SUM(DIA_BRUTO) + SUM (dia_inclusao ) - (
                                   SUM( FJ_CC)   +
                                   SUM( FI_CC)   +
                                   SUM (SUSPE_CC)+
                                   SUM (lSV_CC ) +
                                   SUM (lts_CC )-- +
                                   --sum ( dia_otro_ctc)
                                    )
                 ) Tempo_CARREIRA,

                   (SUM(DIA_BRUTO) + SUM (dia_inclusao ) - (
                                   SUM( FJ_ctsp  )   +
                                   SUM( FI_ctsp )   +
                                   SUM (SUSPE_ctsp )+
                                   SUM (lSV_ctsp  ) +
                                   SUM (lts_ctsp  )-- +
                                   --sum ( dia_otro_ctc)
                                    )
                 ) Tempo_SERVICO_PUBLICO

    FROM  (

                 -------- Tempo de Contribui�ao ---------------------
                   ------------ Obtem de Dias de Contribui�ao ----------
                   ------- Tudo Historico s� com Corte de Data de contagem
                      SELECT DISTINCT
                              data_calculo            ,
                              RF.cod_entidade            ,
                              RF.cod_ide_cli             ,
                              RF.num_matricula           ,
                              RF.cod_ide_rel_func        ,
                              'S' flg_desc_aposentadoria  ,
                              0  cod_agrup_afast        ,
                              EF.COD_CARGO             ,
                              EF.COD_CARREIRA          ,
                              1 dia_bruto              ,
                              0 dia_inclusao           ,
                              0 dia_inclusao_ctc       ,
                              0 dia_inclusao_cc        ,
                              0 dia_inclusao_ctsp      ,
                              0 dia_inclusao_cca       ,
                              0 lts_ctc                ,
                              0 lsv_ctc                ,
                              0 fj_ctc                 ,
                              0 fi_ctc                 ,
                              0 suspe_ctc              ,
                              0 lts_cc                 ,
                              0 lsv_cc                 ,
                              0 fj_cc                  ,
                              0 fi_cc                  ,
                              0 suspe_cc               ,
                              0 lts_ctsp               ,
                              0 lsv_ctsp               ,
                              0 fj_ctsp                ,
                              0 fi_ctsp                ,
                              0 suspe_ctsp             ,
                              0 lts_cca                ,
                              0 lsv_cca                ,
                              0 fj_cca                 ,
                              0 fi_cca                 ,
                              0 suspe_cca              ,
                              0 dia_carreira           ,
                              0 dia_cargo              ,
                              0 dia_otro_ctc
                                FROM TB_RELACAO_FUNCIONAL  RF,
                                     TB_EVOLUCAO_FUNCIONAL EF,
                                     tb_dias_apoio         A
                               WHERE

                                     RF.COD_INS                    =  PAR_COD_INS
                                 AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                 AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                 AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                 AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC

                                 AND RF.COD_INS                    = EF.COD_INS
                                 AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                 AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                 AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                 AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                                 AND EF.FLG_STATUS                 ='V'
                                 AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)


                   ------------ Obtem de Dias de cargo ----------
                   ------- Tudo Historico associado a �ltimo cargo com corte de Data de contagem

                   UNION ALL
                      SELECT
                              data_calculo            ,
                              RF.cod_entidade            ,
                              RF.cod_ide_cli             ,
                              RF.num_matricula           ,
                              RF.cod_ide_rel_func        ,
                              'S' flg_desc_aposentadoria  ,
                              0  cod_agrup_afast        ,
                              EF.COD_CARGO             ,
                              EF.COD_CARREIRA          ,
                              0 dia_bruto              ,
                              0 dia_inclusao           ,
                              0 dia_inclusao_ctc       ,
                              0 dia_inclusao_cc        ,
                              0 dia_inclusao_ctsp      ,
                              0 dia_inclusao_cca       ,
                              0 lts_ctc                ,
                              0 lsv_ctc                ,
                              0 fj_ctc                 ,
                              0 fi_ctc                 ,
                              0 suspe_ctc              ,
                              0 lts_cc                 ,
                              0 lsv_cc                 ,
                              0 fj_cc                  ,
                              0 fi_cc                  ,
                              0 suspe_cc               ,
                              0 lts_ctsp               ,
                              0 lsv_ctsp               ,
                              0 fj_ctsp                ,
                              0 fi_ctsp                ,
                              0 suspe_ctsp             ,
                              0 lts_cca                ,
                              0 lsv_cca                ,
                              0 fj_cca                 ,
                              0 fi_cca                 ,
                              0 suspe_cca              ,
                              0 dia_carreira           ,
                              1 dia_cargo              ,
                              0 dia_otro_ctc
                                FROM TB_RELACAO_FUNCIONAL  RF,
                                     TB_EVOLUCAO_FUNCIONAL EF,
                                     tb_dias_apoio         A
                               WHERE

                                     RF.COD_INS                    =  PAR_COD_INS
                                 AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                 AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                 AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                 AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC

                                 AND RF.COD_INS                    = EF.COD_INS
                                 AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                 AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                 AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                 AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                                 AND EF.FLG_STATUS                 ='V'
                                 AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                 AND EF.COD_CARGO     =PAR_COD_CARGO
                      ------------ Obtem de Dias de Carreira ----------
                   ------- Tudo Historico associado a �ltima carreira com corte de Data de contagem
                     UNION ALL
                      SELECT
                              data_calculo            ,
                              RF.cod_entidade            ,
                              RF.cod_ide_cli             ,
                              RF.num_matricula           ,
                              RF.cod_ide_rel_func        ,
                              'S' flg_desc_aposentadoria  ,
                              0  cod_agrup_afast        ,
                              EF.COD_CARGO             ,
                              EF.COD_CARREIRA          ,
                              0 dia_bruto              ,
                              0 dia_inclusao           ,
                              0 dia_inclusao_ctc       ,
                              0 dia_inclusao_cc        ,
                              0 dia_inclusao_ctsp      ,
                              0 dia_inclusao_cca       ,
                              0 lts_ctc                ,
                              0 lsv_ctc                ,
                              0 fj_ctc                 ,
                              0 fi_ctc                 ,
                              0 suspe_ctc              ,
                              0 lts_cc                 ,
                              0 lsv_cc                 ,
                              0 fj_cc                  ,
                              0 fi_cc                  ,
                              0 suspe_cc               ,
                              0 lts_ctsp               ,
                              0 lsv_ctsp               ,
                              0 fj_ctsp                ,
                              0 fi_ctsp                ,
                              0 suspe_ctsp             ,
                              0 lst_cca                ,
                              0 lsv_cca                ,
                              0 fj_cca                 ,
                              0 fi_cca                 ,
                              0 suspe_cca              ,
                              1 dia_carreira           ,
                              0 dia_cargo              ,
                              0 dia_otro_ctc
                                FROM TB_RELACAO_FUNCIONAL  RF,
                                     TB_EVOLUCAO_FUNCIONAL EF,
                                     tb_dias_apoio         A
                               WHERE

                                     RF.COD_INS                    =  PAR_COD_INS
                                 AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                 AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                 AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                 AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC

                                 AND RF.COD_INS                    = EF.COD_INS
                                 AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                 AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                 AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                 AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                                 AND EF.FLG_STATUS                 ='V'
                                 AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                 AND EF.COD_CARREIRA =PAR_COD_CARREIRA
                  UNION ALL
                  -------------- Contagem de Afastemento por Grupo para todos os tipos
                SELECT
                                  data_calculo                ,
                                  RF.cod_entidade             ,
                                  RF.cod_ide_cli              ,
                                  RF.num_matricula            ,
                                  RF.cod_ide_rel_func         ,
                                  'S' flg_desc_aposentadoria  ,
                                  0  cod_agrup_afast          ,
                                  0 COD_CARGO                ,
                                  0 COD_CARREIRA             ,
                                  0 Dia_bruto                 ,
                                  0 Dia_inclusao              ,
                                  0 Dia_inclusao_CTC          ,
                                  0 Dia_inclusao_CC           ,
                                  0 Dia_inclusao_CTSP         ,
                                  0 Dia_inclusao_CCA         ,
                             ------  Calculo de Tempo de contribui�ao
                                  CASE
                                      WHEN    MO.FLG_DESC_APOSENTADORIA = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 2  THEN 1
                                      ELSE
                                            0 END LTS_CTC,
                                  CASE
                                      WHEN    MO.FLG_DESC_APOSENTADORIA = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 1 THEN 1
                                      ELSE
                                            0 END LSV_CTC,

                                  CASE
                                      WHEN    MO.FLG_DESC_APOSENTADORIA = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 3 THEN 1
                                      ELSE
                                            0 END FJ_CTC,
                                  CASE
                                      WHEN    MO.FLG_DESC_APOSENTADORIA = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 4 THEN 1
                                      ELSE
                                            0 END FI_CTC ,
                                  CASE
                                      WHEN    MO.FLG_DESC_APOSENTADORIA = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 5 THEN 1
                                      ELSE
                                            0 END SUSPE_CTC   ,
                         -------------------- tempo de carreira -------
                               CASE
                                      WHEN    MO.FLG_DESC_CARREIRA  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 2  THEN 1
                                      ELSE
                                            0 END LST_CC,
                                  CASE
                                      WHEN    MO.FLG_DESC_CARREIRA  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 1 THEN 1
                                      ELSE
                                            0 END LSV_CC,

                                  CASE
                                      WHEN    MO.FLG_DESC_CARREIRA  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 3 THEN 1
                                      ELSE
                                            0 END FJ_CC,
                                  CASE
                                      WHEN    MO.FLG_DESC_CARREIRA  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 4 THEN 1
                                      ELSE
                                            0 END FI_CC ,
                                  CASE
                                      WHEN    MO.FLG_DESC_CARREIRA  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 5 THEN 1
                                      ELSE
                                            0 END SUSPE_CC  ,
                       ---------------- tempo servi�o p�blico  -------------------------
                               CASE
                                      WHEN    MO.FLG_DESC_EFE_EX_SERV_PUB   = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 2  THEN 1
                                      ELSE
                                            0 END LST_CTSP,
                                  CASE
                                      WHEN    MO.FLG_DESC_EFE_EX_SERV_PUB  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 1 THEN 1
                                      ELSE
                                            0 END LSV_CTSP,

                                  CASE
                                      WHEN    MO.FLG_DESC_EFE_EX_SERV_PUB   = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 3 THEN 1
                                      ELSE
                                            0 END FJ_CTSP,
                                  CASE
                                      WHEN    MO.FLG_DESC_EFE_EX_SERV_PUB   = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 4 THEN 1
                                      ELSE
                                            0 END FI_CTSP ,
                                  CASE
                                      WHEN    MO.FLG_DESC_EFE_EX_SERV_PUB  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 5 THEN 1
                                      ELSE
                                           0 END SUSPE_CTSP   ,
                       ----------------------tempo no cargo  -------------------------------

                               CASE
                                      WHEN    MO.FLG_DESC_CARGO    = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 2  THEN 1
                                      ELSE
                                            0 END LST_CCA,
                                  CASE
                                      WHEN    MO.FLG_DESC_CARGO   = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 1 THEN 1
                                      ELSE
                                            0 END LSV_CCA,

                                  CASE
                                      WHEN    MO.FLG_DESC_CARGO    = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 3 THEN 1
                                      ELSE
                                            0 END FJ_CCA,
                                  CASE
                                      WHEN    MO.FLG_DESC_CARGO    = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 4 THEN 1
                                      ELSE
                                            0 END FI_CCA ,
                                  CASE
                                      WHEN    MO.FLG_DESC_CARGO  = 'S'  AND
                                              MO.COD_AGRUP_AFAST = 5 THEN 1
                                      ELSE
                                           0 END SUSPE_CCA   ,
                   -------------------------------------------------------------------------------------
                              0 dia_carreira              ,
                              0 dia_cargo                 ,
                              0 dia_otro_ctc

                    FROM TB_RELACAO_FUNCIONAL  RF,
                         Tb_afastamento        T,
                         tb_dias_apoio         AA,
                         tb_motivo_afastamento MO
                   WHERE
                         RF.COD_INS                    = PAR_COD_INS
                     AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                     AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                     AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                     AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                        ------------------------------------------
                     AND RF.COD_INS                 = T.COD_INS
                     AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                     AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                     AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC

                        ------------------------------------------
                     AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                     AND AA.DATA_CALCULO >= t.dat_ini_afast
                     AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                     AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST

                   UNION ALL
                 ------------------  Inclusoes  --------------------
                 ----- Tempo no historico de Carteira de Trabalho
                 ------ Sem Filtro de Empresa Publica ----------
                        SELECT
                              data_calculo            ,
                              RF.cod_entidade            ,
                              RF.cod_ide_cli             ,
                              RF.num_matricula           ,
                              RF.cod_ide_rel_func        ,
                              'S' flg_desc_aposentadoria  ,
                              0  cod_agrup_afast        ,
                              0 COD_CARGO             ,
                              0 COD_CARREIRA          ,
                              0 dia_bruto              ,
                              1 dia_inclusao           ,
                              0 dia_inclusao_ctc       ,
                              0 dia_inclusao_cc        ,
                              0 dia_inclusao_ctsp      ,
                              0 dia_inclusao_cca       ,
                              0 lts_ctc                ,
                              0 lsv_ctc                ,
                              0 fj_ctc                 ,
                              0 fi_ctc                 ,
                              0 suspe_ctc              ,
                              0 lts_cc                 ,
                              0 lsv_cc                 ,
                              0 fj_cc                  ,
                              0 fi_cc                  ,
                              0 suspe_cc               ,
                              0 lts_ctsp               ,
                              0 lsv_ctsp               ,
                              0 fj_ctsp                ,
                              0 fi_ctsp                ,
                              0 suspe_ctsp             ,
                              0 lts_cca                ,
                              0 lsv_cca                ,
                              0 fj_cca                 ,
                              0 fi_cca                 ,
                              0 suspe_cca              ,
                              0 dia_carreira           ,
                              0 dia_cargo              ,
                              0 dia_otro_ctc
                                FROM     TB_RELACAO_FUNCIONAL  RF,
                                         Tb_Hist_Carteira_Trab T,
                                         tb_dias_apoio AA
                               WHERE
                                 ------------------------------------------------------
                                   RF.COD_INS                    =  PAR_COD_INS
                               AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                               AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                               AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                               AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------------------
                                 AND T.COD_INS                    =  RF.COD_INS
                                 AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                                 AND T.FLG_EMP_PUBLICA            ='S'
                                 AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                 AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                 AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, SYSDATE)

                                 AND NOT EXISTS
                               (

                                      SELECT 1
                                        FROM  TB_RELACAO_FUNCIONAL  RF,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              tb_dias_apoio         A
                                       WHERE
                                              RF.COD_INS                    = PAR_COD_INS
                                         AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                         AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                         AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                         AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                         AND RF.COD_INS                    = EF.COD_INS
                                         AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                         AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                         AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                         AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                                         AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                         AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                         AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                         AND AA.DATA_CALCULO = A.DATA_CALCULO

                                      )

               --------------------------------------------------------------
               ---------- OUTROS Afastamento de Tempo de Contribui�ao  ------
               UNION ALL
               SELECT
                            data_calculo            ,
                              RF.cod_entidade            ,
                              RF.cod_ide_cli             ,
                              RF.num_matricula           ,
                              RF.cod_ide_rel_func        ,
                              'S' flg_desc_aposentadoria  ,
                              0  cod_agrup_afast        ,
                              0 COD_CARGO             ,
                              0 COD_CARREIRA          ,
                              0 dia_bruto              ,
                              1 dia_inclusao           ,
                              0 dia_inclusao_ctc       ,
                              0 dia_inclusao_cc        ,
                              0 dia_inclusao_ctsp      ,
                              0 dia_inclusao_cca       ,
                              0 lst_ctc                ,
                              0 lsv_ctc                ,
                              0 fj_ctc                 ,
                              0 fi_ctc                 ,
                              0 suspe_ctc              ,
                              0 lts_cc                 ,
                              0 lsv_cc                 ,
                              0 fj_cc                  ,
                              0 fi_cc                  ,
                              0 suspe_cc               ,
                              0 lst_ctsp               ,
                              0 lsv_ctsp               ,
                              0 fj_ctsp                ,
                              0 fi_ctsp                ,
                              0 suspe_ctsp             ,
                              0 lst_cca                ,
                              0 lsv_cca                ,
                              0 fj_cca                 ,
                              0 fi_cca                 ,
                              0 suspe_cca              ,
                              0 dia_carreira           ,
                              0 dia_cargo              ,
                              1 dia_otro_ctc


                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO
                 WHERE
                        RF.COD_INS                 =  PAR_COD_INS
                   AND RF.COD_IDE_CLI              =  PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE             =  PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA            =  PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC         =  PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                    AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.FLG_DESC_APOSENTADORIA = 'S'

                   AND NOT EXISTS
                   (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               Tb_afastamento        TT,
                               tb_dias_apoio         A,
                               tb_motivo_afastamento MO
                         WHERE RF.COD_INS               = PAR_COD_INS
                           AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                           AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                           AND
                              ------------------------------------------
                               RF.COD_INS = T.COD_INS
                           AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                           AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                           AND
                              ------------------------------------------

                               TT.COD_INS = 1
                           AND TT.COD_IDE_CLI =  PAR_COD_IDE_CLI
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= TT.dat_ini_afast
                           AND A.DATA_CALCULO <= NVL(TT.DAT_RET_PREV, SYSDATE)
                           AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                           AND MO.FLG_DESC_APOSENTADORIA = 'S'
                           AND NVL(MO.COD_AGRUP_AFAST, 0) IN (1, 2, 3, 4, 5)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                          )

       )
     group by    cod_entidade            ,
                 cod_ide_cli             ,
                 num_matricula           ,
                 cod_ide_rel_func        ,
                 TO_CHAR(data_calculo,'YYYY')
      order by  TO_CHAR(data_calculo,'YYYY') asc ;


   ----- CURSORES DE DETALHE DE  TEMPO DE APOSENTADORIA
    -------- Detalhamento de Faltas
  CURSOR CURTEMP_APO_TOT_FALTAS_DETALHE IS
  select

                cod_entidade       ,
                num_matricula      ,
                cod_ide_rel_func   ,
                cod_ide_cli        ,
                num_seq_lanc       ,
                cod_motivo         ,
                data_ini           ,
                dat_fim            ,
                desconta_contagem  ,
                cod_agrupa         ,
                des_motivo_audit   ,
                tipo_desconto  ,
                count(*) Qtd_dias
   From (
            SELECT

                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto

                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC

                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.FLG_DESC_APOSENTADORIA= 'S'
                             AND MO.COD_AGRUP_AFAST = 2



                  UNION ALL
                   --- LSV' as Tipo,
                   SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.FLG_DESC_APOSENTADORIA= 'S'
                             AND MO.COD_AGRUP_AFAST = 1



                  UNION ALL
                  -- 'FALTAS - FJ' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                    = T.COD_INS
                             AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO                <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO                >= t.dat_ini_afast
                             AND AA.DATA_CALCULO                <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST                = T.COD_MOT_AFAST
                             AND MO.FLG_DESC_APOSENTADORIA       = 'S'
                             AND MO.COD_AGRUP_AFAST              = 3



                  UNION ALL
                   -- 'FALTAS -FI' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.FLG_DESC_APOSENTADORIA= 'S'
                             AND MO.COD_AGRUP_AFAST = 4



                  UNION ALL
                   -- 'SUSP' as Tipo,
                    SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto
                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                            WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                              AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.FLG_DESC_APOSENTADORIA= 'S'
                             AND MO.COD_AGRUP_AFAST = 5


                  UNION ALL

                  ---- Tipo OUTRO
                     SELECT
                          rf.cod_ins            cod_ins            ,
                          rf.cod_entidade       cod_entidade       ,
                          rf.num_matricula      num_matricula      ,
                          rf.cod_ide_rel_func   cod_ide_rel_func   ,
                          rf.cod_ide_cli        cod_ide_cli        ,
                          t.num_seq_afast       num_seq_lanc       ,
                          t.cod_mot_afast       cod_motivo         ,
                          t.dat_ini_afast       data_ini           ,
                          t.dat_ret_prev        dat_fim            ,
                          t.flg_desconta        desconta_contagem  ,
                          mo.cod_agrup_afast    cod_agrupa         ,
                          mo.des_mot_afast      des_motivo_audit   ,
                          'AFA'                  tipo_desconto

                            FROM TB_RELACAO_FUNCIONAL  RF,
                                 Tb_afastamento        T,
                                 tb_dias_apoio         AA,
                                 tb_motivo_afastamento MO
                           WHERE
                                 RF.COD_INS                    =  PAR_COD_INS
                             AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                             AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                             AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND RF.COD_INS                 = T.COD_INS
                             AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                             AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                             AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                                ------------------------------------------
                             AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                             AND AA.DATA_CALCULO >= t.dat_ini_afast
                             AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, SYSDATE)
                             AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                             AND MO.FLG_DESC_APOSENTADORIA= 'S'

                             AND NOT EXISTS
                           (SELECT 1
                                    FROM TB_RELACAO_FUNCIONAL  RF,
                                         Tb_afastamento        TT,
                                         tb_dias_apoio         A,
                                         tb_motivo_afastamento MO
                                   WHERE
                                         RF.COD_INS                    =  PAR_COD_INS
                                     AND RF.COD_IDE_CLI                =  PAR_COD_IDE_CLI
                                     AND RF.COD_ENTIDADE               =  PAR_COD_ENTIDADE
                                     AND RF.NUM_MATRICULA              =  PAR_NUM_MATRICULA
                                     AND RF.COD_IDE_REL_FUNC           =  PAR_COD_IDE_REL_FUNC
                                     AND
                                        ------------------------------------------
                                         RF.COD_INS = T.COD_INS
                                     AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                     AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                     AND RF.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                                     AND
                                        ------------------------------------------

                                         TT.COD_INS = 1
                                     AND TT.COD_IDE_CLI =  PAR_COD_IDE_CLI
                                     AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                     AND A.DATA_CALCULO >= TT.dat_ini_afast
                                     AND A.DATA_CALCULO <= NVL(TT.DAT_RET_PREV, SYSDATE)
                                     AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                     AND MO.FLG_DESC_APOSENTADORIA= 'S'
                                     AND NVL(MO.COD_AGRUP_AFAST, 0) IN (1, 2, 3, 4, 5)
                                     AND AA.DATA_CALCULO = A.DATA_CALCULO

                                  )
                 )

             Group by
                cod_ins            ,
                cod_entidade       ,
                num_matricula      ,
                cod_ide_rel_func   ,
                cod_ide_cli        ,
                num_seq_lanc       ,
                cod_motivo         ,
                data_ini           ,
                dat_fim            ,
                desconta_contagem  ,
                cod_agrupa         ,
                des_motivo_audit   ,
                tipo_desconto
                order by data_ini;

  ------ Detalhamentos de Tempos ---
    CURSOR CURTEMP_APO_TOT_TEMPOS_DETALHE IS
         SELECT

                      t.dat_adm_orig          dat_adm_orig      ,
                      t.dat_desl_orig         dat_desl_orig     ,
                      t.nom_org_emp           nom_org_emp       ,
                      t.num_cnpj_org_emp      num_cnpj_org_emp  ,
                      t.num_certidao          cod_certidao_seq  ,
                      t.cod_emissor           cod_emissor       ,
                      min(aa.data_calculo)    dat_ini_per_cons  ,
                      max(aa.data_calculo)    dat_fim_per_cons  ,
                      count(*) num_dias_cons


                   ---------------------------------------------


                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND AA.DATA_CALCULO  <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, SYSDATE)

                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                               RF.COD_INS                    = PAR_COD_INS
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC

                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           AND A.DATA_CALCULO  <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                        )

                        group by
                          t.cod_ins              ,
                          t.dat_adm_orig       ,
                          t.dat_desl_orig      ,
                          t.nom_org_exp_cert   ,
                          t.num_cnpj_org_emp   ,
                          t.num_certidao       ,
                          t.cod_emissor        ,
                          t.nom_org_emp ;


 ----------------- CONTAGEM DE FERIAS --------

 CURSOR CURTEMP_FERIAS IS
           select b.data_calculo  ,
          nvl( (
          select distinct  1 from tb_afastamento f,
                                  tb_motivo_afastamento ma,
                                  tb_dias_apoio b2
          where
                f.cod_ins          = a.COD_INS             and
                f.cod_ide_cli      = a.COD_IDE_CLI         and
                f.cod_entidade     = a.COD_ENTIDADE        and
                f.num_matricula    =a.NUM_MATRICULA        and
                f.cod_ide_rel_func =a.COD_IDE_REL_FUNC     and
                b2.data_calculo>=f.dat_ini_afast             and
                b2.data_calculo<=f.dat_ret_prev              and
                b2.data_calculo=b.data_calculo               and
                ma.cod_mot_afast = f.cod_mot_afast           and
                ma.reinicia_cont_ferias = 'S'
          ) ,0) dia_afa_180,
          (
          select f.dat_ini_afast from tb_afastamento f,
                                 tb_motivo_afastamento ma,
                                 tb_dias_apoio b2
          where
                f.cod_ins          = a.COD_INS             and
                f.cod_ide_cli      = a.COD_IDE_CLI         and
                f.cod_entidade     = a.COD_ENTIDADE        and
                f.num_matricula    =a.NUM_MATRICULA        and
                f.cod_ide_rel_func =a.COD_IDE_REL_FUNC     and

                b2.data_calculo>=f.dat_ini_afast             and
                b2.data_calculo<=f.dat_ret_prev              and
                b2.data_calculo=b.data_calculo               and
                ma.cod_mot_afast = f.cod_mot_afast           and
                ma.reinicia_cont_ferias = 'S'
                and rownum = 1
          )  dt_ini,
          (
          select f.dat_ret_prev from tb_afastamento f,
                                  tb_motivo_afastamento ma,
                                  tb_dias_apoio b2
          where
                f.cod_ins          = a.COD_INS             and
                f.cod_ide_cli      = a.COD_IDE_CLI         and
                f.cod_entidade     = a.COD_ENTIDADE        and
                f.num_matricula    =a.NUM_MATRICULA        and
                f.cod_ide_rel_func =a.COD_IDE_REL_FUNC     and

                b2.data_calculo>=f.dat_ini_afast              and
                b2.data_calculo<=f.dat_ret_prev               and
                b2.data_calculo=b.data_calculo                and
                ma.cod_mot_afast = f.cod_mot_afast            and
                ma.reinicia_cont_ferias = 'S'

                and rownum = 1
          )  dt_fim,

           (
          select f.dat_ret_prev +1  from tb_afastamento f,
                                  tb_motivo_afastamento ma,
                                  tb_dias_apoio b2
          where
                f.cod_ins          = a.COD_INS             and
                f.cod_ide_cli      = a.COD_IDE_CLI         and
                f.cod_entidade     = a.COD_ENTIDADE        and
                f.num_matricula    =a.NUM_MATRICULA        and
                f.cod_ide_rel_func =a.COD_IDE_REL_FUNC     and
                b2.data_calculo>=f.dat_ini_afast             and
                b2.data_calculo<=f.dat_ret_prev              and
                b2.data_calculo=b.data_calculo               and
                ma.cod_mot_afast = f.cod_mot_afast          and
                ma.reinicia_cont_ferias = 'S'
                and rownum = 1
          )  dt_inicio_novo_periodo,

            (
             select f.dat_ret_prev + 366  from tb_afastamento f,
                                  tb_motivo_afastamento ma,
                                  tb_dias_apoio b2
             where
                f.cod_ins          = a.COD_INS             and
                f.cod_ide_cli      = a.COD_IDE_CLI         and
                f.cod_entidade     = a.COD_ENTIDADE        and
                f.num_matricula    =a.NUM_MATRICULA        and
                f.cod_ide_rel_func =a.COD_IDE_REL_FUNC     and
                b2.data_calculo>=f.dat_ini_afast and
                b2.data_calculo<=f.dat_ret_prev and
                b2.data_calculo=b.data_calculo and
                ma.cod_mot_afast = f.cod_mot_afast and
                ma.reinicia_cont_ferias = 'S'
                and rownum = 1
          )  dt_fim_novo_periodo,

          nvl( (
          select distinct  1 from tb_afastamento f,
                                  tb_motivo_afastamento ma,
                                  tb_dias_apoio b2
          where
                f.cod_ins          = a.COD_INS             and
                f.cod_ide_cli      = a.COD_IDE_CLI         and
                f.cod_entidade     = a.COD_ENTIDADE        and
                f.num_matricula    =a.NUM_MATRICULA        and
                f.cod_ide_rel_func =a.COD_IDE_REL_FUNC     and
                b2.data_calculo>=f.dat_ini_afast and
                b2.data_calculo<=f.dat_ret_prev and
                b2.data_calculo=b.data_calculo and
                ma.cod_mot_afast = f.cod_mot_afast and
                ma.perd_direito_ferias = 'S'
          ) ,0) dia_falta
          from tb_relacao_funcional a, tb_dias_apoio b
          where
                a.cod_ins          = PAR_COD_INS             and
                a.cod_ide_cli      = PAR_COD_IDE_CLI         and
                a.cod_entidade     = PAR_COD_ENTIDADE        and
                a.num_matricula    =PAR_NUM_MATRICULA        and
                a.cod_ide_rel_func =PAR_COD_IDE_REL_FUNC     and
                a.cod_ins         = PAR_COD_INS
          AND  a.cod_ide_cli      = PAR_COD_IDE_CLI
          AND  a.cod_entidade     = PAR_COD_ENTIDADE
          AND  a.num_matricula    = PAR_NUM_MATRICULA
          AND  a.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
          AND  b.data_calculo    >=PAR_INICIO_PERIODO_ADQ
          AND  b.data_calculo    <=  PAR_FIM_PERIODO_ADQ
          AND  b.data_calculo    <=SYSDATE;
----------------------------------------------


PROCEDURE VERIFICA_TIPO_CALCULO;
PROCEDURE ABRIR_CURSOR_CONTAGEM;
PROCEDURE FECHAR_CURSOR_CONTAGEM;
PROCEDURE INCLUE_DETALHE_CONTAGEM ( SEQ_CERTIDAO IN NUMBER  );
PROCEDURE GERA_DETALHE_POR_TIPO (SEQ_CERTIDAO IN NUMBER) ;
PROCEDURE LEER_TEMPOS;
PROCEDURE APAGA_CONTAGEM_SERVIDOR;
PROCEDURE GERA_HEAD_CONTAGEN            ( SEQ_CERTIDAO IN NUMBER);
PROCEDURE ATUALIZA_HEAD_CONTAGEN        (SEQ_CERTIDAO  IN NUMBER);
PROCEDURE ATUALIZA_HEAD_CONTAGEN_DETALHE(SEQ_CERTIDAO  IN NUMBER);
PROCEDURE INCLUE_DETALHE_CONTAGEM_EMDIAS (SEQ_CERTIDAO IN NUMBER);
PROCEDURE OBTEN_DIAS_FERIAS ( QTD_DIAS_FALTAS        IN NUMBER,
                              DIAS_FERIAS_SERVIDOR  OUT NUMBER );
--procedure SP_CONTAGEM_PERIODO_AQUIS_LP(I_SEQ_CERTIDAO IN NUMBER);
 -------------------------------------------------------------------
   PROCEDURE  SP_GERA_CONTAGEN (
         W_COD_INS        IN  NUMBER,
         W_COD_GRUPO      IN  VARCHAR,
         W_DATA_CORTE     IN  DATE,
         W_TIPO_REL       IN  NUMBER,
         W_EXECUTA       OUT VARCHAR,
         W_MSG_SAIDA     OUT VARCHAR );

 PROCEDURE SP_CONTAGEM_PERIODO_AGRUP
  (
   I_SEQ_CERTIDAO        IN NUMBER
  );

  PROCEDURE SP_CONTAGEM_DECL_INSS(I_SEQ_CERTIDAO IN NUMBER) ;


 PROCEDURE SP_CONTAGEM_CTC_INSS (I_SEQ_CERTIDAO IN NUMBER) ;

 PROCEDURE SP_CONTR_INSS(I_SEQ_CERTIDAO IN NUMBER);
 PROCEDURE ATUALIZA_HEAD_CONTAGEN_NC(SEQ_CERTIDAO IN NUMBER);
 PROCEDURE SP_CONTAGEM_PERIODO_AGRUP_CERT (I_SEQ_CERTIDAO IN NUMBER);

  CURSOR CURTEMP_PER_ATS IS
SELECT par_id_contagem as id_contagem,
        COD_IDE_CLI,  NUM_MATRICULA , COD_IDE_REL_FUNC  ,
        DATA_INICIO, DATA_FIM, NOM_CARGO,

         SUM ( BRUTO)    QTD_BRUTO  ,
         SUM (Inclusao)  QTD_INCLUSAO,
         SUM (LTS)      QTD_LTS     ,
         SUM(LSV)       QTD_LSV     ,
         SUM(FJ)        QTD_FJ      ,
         SUM(FI)        QTD_FI      ,
         SUM(SUSP)      QTD_SUSP    ,
         SUM(OUTRO)     QTD_OUTRO    ,
         (
            SUM ( nvl(BRUTO,0)) +  SUM (nvl(Inclusao,0))  - SUM (nvl(LTS,0)) -  SUM(nvl(LSV,0)) -  SUM(nvl(FJ,0))  -  SUM(nvl(FI,0))  -  SUM(nvl(OUTRO,0))
         ) QTD_LIQUIDO
          FROM (

         -- Tabela de Contagem  Dias da Evoluca�ao Funcional
        ---- Dias Bruto -----
        SELECT 'BRUTO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               ---to_char(DATA_CALCULO, 'yyyy') Ano,
               count(DISTINCT DATA_CALCULO) BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM

          from (SELECT distinct
                                A.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM) AS DATA_FIM


                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       tb_dias_apoio         A ,
                       TB_CARGO              C
                 WHERE

                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                   --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                   --YUMI EM 01/05/2018: INCLU�DO PARA PEGAR V�NCULOS ANTERIORES DA RELACAO FUNCIONAL
                   union

                   SELECT distinct
                                A.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)AS DATA_FIM


                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       tb_dias_apoio         A,
                       TB_CARGO              C
                 WHERE

                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_IDE_REL_FUNC           != PAR_COD_IDE_REL_FUNC

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                   --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                   )


         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM

        UNION ALL
        ---- Tabela de Contagem Dias Historico de Tempo
        ----   Historico de Tempo

        SELECT 'INCLUSAO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
               count(DISTINCT DATA_CALCULO) Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM

          from (
          SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                T.DES_ULT_CARGO      as nom_cargo       ,
                                T.DAT_ADM_ORIG   AS DATA_INICIO           ,
                                T.DAT_DESL_ORIG AS DATA_FIM
                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomit�ncia
                           ---com qualquer v�nculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre per�odos de v�nculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                        --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                        AND EF.FLG_STATUS = 'V'
                        )

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  nom_cargo,
                  DATA_INICIO,
                  DATA_FIM

        UNION ALL

        ---- Tabela de Contagem De Licencias
        ----   Historico de Tempo
        SELECT 'LTS' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,

               0 BRUTO,
               0 Inclusao,
               count(DISTINCT DATA_CALCULO) lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (SELECT distinct
                                 AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM)AS DATA_FIM

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       TB_CARGO              C
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS = 'S'
                   AND MO.COD_AGRUP_AFAST = 2

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND EF.FLG_STATUS                 ='V'
                   AND AA.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM

        UNION ALL
        ---- Tabela de Contagem De Licencias
        ----   Historico de Tempo
        SELECT 'LSV' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
               0 Inclusao,
               0 lts,
               count(DISTINCT DATA_CALCULO) lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM)AS DATA_FIM

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       TB_CARGO              C
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS = 'S'
                   AND MO.COD_AGRUP_AFAST = 1

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND EF.FLG_STATUS                 ='V'
                   AND AA.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM

        UNION ALL
        ---- Tabela de Contagem Faltas

        SELECT 'FALTAS - FJ' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               --to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               count(distinct data_calculo) FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM)AS DATA_FIM

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       TB_CARGO              C
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                    = T.COD_INS
                   AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND AA.DATA_CALCULO                <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO                >= t.dat_ini_afast
                   AND AA.DATA_CALCULO                <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST                = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS             = 'S'
                   AND MO.COD_AGRUP_AFAST              = 3

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND EF.FLG_STATUS                 ='V'
                   AND AA.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  nom_cargo,
                  data_inicio,
                  data_fim

        UNION ALL
        ---- Tabela de Contagem Faltas

        SELECT 'FALTAS -FI' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               count(DISTINCT DATA_CALCULO) FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM)AS DATA_FIM
                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       TB_CARGO              C

                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS = 'S'
                   AND MO.COD_AGRUP_AFAST = 4

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND EF.FLG_STATUS                 ='V'
                   AND AA.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM

        UNION ALL
        ---- Tabela de Contagem Faltas SUSPENSOS

        SELECT 'SUSP' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               --to_char(DATA_CALCULO, 'yyyy') Ano,

               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               COUNT(DISTINCT DATA_CALCULO) SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM)AS DATA_FIM
                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       TB_CARGO              C
                  WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS = 'S'
                   AND MO.COD_AGRUP_AFAST = 5

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND EF.FLG_STATUS                 ='V'
                   AND AA.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO


                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM
        -------------------------------------------

        UNION ALL

        ---- Tabela de Contagem Faltas OUTRO
        SELECT 'OUTRO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               COUNT(DISTINCT DATA_CALCULO) OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (SELECT distinct
                                 AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                SYSDATE AS DAT_EXECUCAO     ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM)AS DATA_FIM

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       Tb_afastamento        T,
                       tb_dias_apoio         AA,
                       tb_motivo_afastamento MO,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       TB_CARGO              C
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   ---Yumi em 01/05/2018: comentado para verificar licen�a
                   --de qualquer v�nculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= t.dat_ini_afast
                   AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                   AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                   AND MO.AUMENTA_CONT_ATS = 'S'

                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND EF.FLG_STATUS                 ='V'
                   AND AA.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO


                   AND NOT EXISTS
                 (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               Tb_afastamento        TT,
                               tb_dias_apoio         A,
                               tb_motivo_afastamento MO
                         WHERE RF.COD_INS               = PAR_COD_INS
                         --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                          AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           --AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                           AND
                              ------------------------------------------
                               RF.COD_INS = T.COD_INS
                           AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                           AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                           AND
                              ------------------------------------------

                               TT.COD_INS = 1
                           AND TT.COD_IDE_CLI = PAR_COD_IDE_CLI
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= TT.dat_ini_afast
                           AND A.DATA_CALCULO <= NVL(TT.DAT_RET_PREV, PAR_DAT_CONTAGEM)
                           AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                           AND MO.AUMENTA_CONT_ATS = 'S'
                           AND NVL(MO.COD_AGRUP_AFAST, 0) IN (1, 2, 3, 4, 5)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                        )

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM

         union
         ---Yumi em 01/05/2018: inclu�do para descontar os dias de descontos
         ---relacionados ao hist�rico de tempos averbados
         select
               'OUTRO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               sum(nvl(qtd_dias_ausencia,0)) OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (
 SELECT distinct
                                t1.dat_adm_orig             ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                t1.qtd_dias_ausencia        ,
                                T1.DES_ULT_CARGO AS NOM_CARGO,
                                T1.DAT_ADM_ORIG AS DATA_INICIO,
                                T1.DAT_DESL_ORIG AS DATA_FIM

                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T1,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                  ------------------------------------------------------
                   AND T1.COD_INS                    =  RF.COD_INS
                   AND T1.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T1.FLG_EMP_PUBLICA            ='S'

                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T1.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= NVL(T1.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                   AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T1.FLG_TMP_ATS = 'S')
                    OR
                       (PAR_TIPO_CONTAGEM IN (2)   AND T1.FLG_TMP_LIC_PREM = 'S')
                       )

                   AND NOT EXISTS
                 (

                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomit�ncia
                           ---com qualquer v�nculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO

                        )

                )
                group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM

         ------------------------------------------------------

             UNION ALL
          SELECT 'TODOS OS ANOS ZERADOS ---' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
               0 Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM
          from (

                SELECT distinct
                               A.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                C.NOM_CARGO                 ,
                                ef.dat_ini_efeito      AS DATA_INICIO     ,
                                NVL(NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC),PAR_DAT_CONTAGEM) AS DATA_FIM

                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_EVOLUCAO_FUNCIONAL EF,
                       tb_dias_apoio         A,
                       TB_CARGO              C
                 WHERE
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
               ----------------------------------------------------------------
                   AND RF.COD_INS                    = EF.COD_INS
                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                 )
               group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
               DATA_INICIO,
               DATA_FIM

         UNION ALL
         SELECT 'INCLUSAO' as Tipo,
               COD_ENTIDADE,
               COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               0 BRUTO,
              0  Inclusao,
               0 lts,
               0 lsv,
               0 FJ,
               0 FI,
               0 SUSP,
               0 OUTRO,
               NOM_CARGO,
               DATA_INICIO,
               DATA_FIM

          from (SELECT distinct
                                AA.DATA_CALCULO              ,
                                1 AS COD_INS                ,
                                1 AS TIPO_CONTAGEM          ,
                                1 AS ID_CONTAGEM            ,
                                RF.COD_ENTIDADE             ,
                                RF.COD_IDE_CLI              ,
                                RF.NUM_MATRICULA            ,
                                RF.COD_IDE_REL_FUNC         ,
                                T.DES_ULT_CARGO    AS NOM_CARGO         ,
                                T.DAT_ADM_ORIG AS DATA_INICIO,
                                T.DAT_DESL_ORIG AS DATA_FIM

                  FROM     TB_RELACAO_FUNCIONAL  RF,
                           Tb_Hist_Carteira_Trab T,
                           tb_dias_apoio AA
                 WHERE
                   ------------------------------------------------------
                       RF.COD_INS                    = PAR_COD_INS
                   AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                   AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                     )
               group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  NOM_CARGO,
                  DATA_INICIO,
                  DATA_FIM



                  ) GROUP BY COD_IDE_CLI,  NUM_MATRICULA , COD_IDE_REL_FUNC  ,
                  DATA_INICIO, DATA_FIM, NOM_CARGO
                  order by  DATA_INICIO ;



CURSOR CURTEMP_CTC_INSS iS

select to_char(data_calculo, 'yyyy')as ano,
       count(*)as tempo_bruto,
       0 as inclusao,
       0 as licencas,
       0 as licenca_sem_vctos,
       0 as faltas,
       0 as faltas_inj,
       0 as suspensoes,
       0 as disponibilidade,
       0 as outros,
       count(*)as tempo_liquido



from

(

select rf.cod_ide_cli,
       rf.num_matricula,
       rf.cod_ide_rel_func,
       rf.cod_entidade,
       d.data_calculo,
       rf.dat_ini_exerc,
       nvl(rf.dat_fim_exerc, sysdate) as dat_fim_exerc,
       ef.dat_ini_efeito,
       nvl(ef.dat_fim_efeito, sysdate) as data_fim_efeito,
       ef.cod_cargo,
       ca.nom_cargo


  from tb_relacao_funcional rf,
       tb_evolucao_funcional ef,
       tb_cargo ca,
       tb_dias_apoio d
  where rf.cod_ins          = PAR_COD_INS
    --and rf.cod_regime       = '2' --RGPS
    --and rf.cod_plano        = '2' --RGPS
    and rf.tip_provimento   = '2' --Livre Provimento (cargo em Comiss�o)
    --and rf.cod_vinculo      = '8' --Comissionado
    and ef.cod_ins          = rf.cod_ins
    and ef.cod_ide_cli      = rf.cod_ide_cli
    and ef.num_matricula    = rf.num_matricula
    and ef.cod_ide_rel_func = rf.cod_ide_rel_func
    and ef.cod_entidade     = rf.cod_entidade
    and ef.flg_status       = 'V'
    and ca.cod_ins          = ef.cod_ins
    and ca.cod_entidade     = ef.cod_entidade
    and ca.cod_pccs         = ef.cod_pccs
    and ca.cod_carreira     = ef.cod_carreira
    and ca.cod_cargo        = ef.cod_cargo
    and rf.num_matricula    = PAR_NUM_MATRICULA
    and rf.cod_ide_cli      = PAR_COD_IDE_CLI
    and rf.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
    and rf.cod_entidade     = PAR_COD_ENTIDADE
    and d.data_calculo between  rf.dat_ini_exerc and nvl(rf.dat_fim_exerc, sysdate)
    and d.data_calculo between  ef.dat_ini_efeito and nvl(ef.dat_fim_efeito, sysdate)


  union

select
       rf.cod_ide_cli,
       rf.num_matricula,
       rf.cod_ide_rel_func,
       rf.cod_entidade,
       d.data_calculo,
       rf.dat_ini_exerc,
       nvl(rf.dat_fim_exerc, sysdate) as dat_fim_exerc,
       ef.dat_ini_efeito,
       nvl(ef.dat_fim_efeito, sysdate) as data_fim_efeito,
       ef.cod_cargo,
       ca.nom_cargo


  from tb_relacao_funcional rf,
       tb_evolucao_funcional ef,
       tb_cargo ca,
       tb_dias_apoio d
  where rf.cod_ins          = 1
    --and rf.cod_regime       = '2' --RGPS
    --and rf.cod_plano        = '2' --RGPS
    and rf.tip_provimento   = '2' --Livre Provimento (cargo em Comiss�o)
    --and rf.cod_vinculo      = '8' --Comissionado
    and ef.cod_ins          = rf.cod_ins
    and ef.cod_ide_cli      = rf.cod_ide_cli
    and ef.num_matricula    = rf.num_matricula
    and ef.cod_ide_rel_func = rf.cod_ide_rel_func
    and ef.cod_entidade     = rf.cod_entidade
    and ef.flg_status       = 'V'
    and ca.cod_ins          = ef.cod_ins
    and ca.cod_entidade     = ef.cod_entidade
    and ca.cod_pccs         = ef.cod_pccs
    and ca.cod_carreira     = ef.cod_carreira
    and ca.cod_cargo        = ef.cod_cargo
    and rf.cod_ide_cli      = PAR_COD_IDE_CLI
    and rf.cod_ide_rel_func != PAR_COD_IDE_REL_FUNC
    and d.data_calculo between  rf.dat_ini_exerc and nvl(rf.dat_fim_exerc, sysdate)
    and d.data_calculo between  ef.dat_ini_efeito and nvl(ef.dat_fim_efeito, sysdate)

) aa

group by to_char(data_calculo, 'yyyy')
ORDER BY to_char(data_calculo, 'yyyy');



end PAC_CALCULA_TEMPO_ATIVO_CMC;
/
CREATE OR REPLACE PACKAGE BODY "PAC_CALCULA_TEMPO_ATIVO_CMC" as

  /*******************************************************************************
  Nome        : SP_CALC_ANOS_TRAB_ATIVO
  Tipo        : Stored Procedure
  Descric?o   : Calculo de Temspo
  Auator       : Atlantic Solutions TS
  Data        : 12/02/2018
  Modificado por  :
  Modificado em   :
  Natureza da modificacao :
  ********************************************************************************/

--1 - Adicional por Tempo de Servico
--2 - Licenca Premio
--3 - Aposentadoria
--4 - Ferias
--5 - Progressao
--6 - Remuneracao de Contribui��es
--7 - Tempo para CTC
--8 - Declaracao para INSS

CURSOR CURTEMP_LP IS
with TAB AS(  SELECT   distinct   DATA_CALCULO,
                                  TIPO_CONTAGEM,
                                  1                   AS COD_INS,
                                  COD_ENTIDADE,
                                  COD_IDE_CLI,
                                  NUM_MATRICULA,
                                  COD_IDE_REL_FUNC,
                                  COD_CARGO,
                                  COD_AGRUP_AFAST
                    FROM table(v_col_dias_lp))
SELECT COD_IDE_CLI,
       NUM_MATRICULA,
       COD_IDE_REL_FUNC,
       ANO,
       SUM(BRUTO) QTD_BRUTO,
       SUM(Inclusao) QTD_INCLUSAO,
       SUM(LTS) QTD_LTS,
       SUM(LSV) QTD_LSV,
       SUM(FJ) QTD_FJ,
       SUM(FI) QTD_FI,
       SUM(SUSP) QTD_SUSP,
       SUM(OUTRO) QTD_OUTRO,
       SUM(CARGO) QTD_CARGO,
       (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) - SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) - SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) - SUM(nvl(OUTRO, 0))) QTD_LIQUIDO
  FROM (
        -- Tabela de Contagem  Dias da Evoluca�ao Funcional
        ---- Dias Bruto -----
        SELECT 'BRUTO' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                count(*) BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          from TAB
          WHERE TIPO_CONTAGEM = 'BRUTO'
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
         -- Tabela de Contagem  Dias da Evoluca�ao Funcional
        ---- Dias CARGO -----
        SELECT 'CARGO' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                count(1) CARGO
          from TAB
          WHERE TIPO_CONTAGEM = 'BRUTO'
            AND COD_CARGO in (select * from table(v_col_cargos_equiv))
          group by COD_ENTIDADE,
                   COD_IDE_CLI,
                   NUM_MATRICULA,
                   COD_IDE_REL_FUNC,
                   to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        ---- Tabela de Contagem Dias Historico de Tempo
        ----   Historico de Tempo
        SELECT 'INCLUSAO' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                count(*) Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          from  TAB
          WHERE TIPO_CONTAGEM = 'HIST'
          group by COD_ENTIDADE,
                    COD_IDE_CLI,
                    NUM_MATRICULA,
                    COD_IDE_REL_FUNC,
                    to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        ----  Tabela de Contagem De Licencias
        ----  Historico de Tempo
        SELECT 'LTS' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                count(*) lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          FROM TAB
         WHERE TIPO_CONTAGEM = 'AFAST'
           AND COD_AGRUP_AFAST = 2
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        ----  Tabela de Contagem De Licencias
        ----  Historico de Tempo
        SELECT 'LSV' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                count(*) lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          from  TAB
         WHERE TIPO_CONTAGEM = 'AFAST'
           AND COD_AGRUP_AFAST = 1
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
        UNION ALL
        ---- Tabela de Contagem Faltas
        SELECT 'FALTAS - FJ' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                count(*) FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          FROM TAB
         WHERE TIPO_CONTAGEM = 'AFAST'
           AND COD_AGRUP_AFAST = 3
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        ---- Tabela de Contagem Faltas
        SELECT 'FALTAS -FI' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                count(*) FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          FROM TAB
         WHERE TIPO_CONTAGEM = 'AFAST'
           AND COD_AGRUP_AFAST = 4
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        ---- Tabela de Contagem Faltas SUSPENSOS
        SELECT 'SUSP' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                COUNT(*) SUSP,
                0 OUTRO,
                0 CARGO
          FROM TAB
         WHERE TIPO_CONTAGEM = 'AFAST'
           AND COD_AGRUP_AFAST = 5
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        ---- Tabela de Contagem Faltas OUTRO
        SELECT 'OUTRO' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                COUNT(*) OUTRO,
                0 CARGO
          FROM TAB
         WHERE TIPO_CONTAGEM = 'OUTROS'
           AND COD_AGRUP_AFAST NOT IN (1,2,3,4,5)
         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
      UNION ALL
        SELECT 'TODOS OS ANOS ZERADOS ---' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          from TAB
          WHERE TIPO_CONTAGEM = 'BRUTO'
         group by COD_ENTIDADE,
                   COD_IDE_CLI,
                   NUM_MATRICULA,
                   COD_IDE_REL_FUNC,
                   to_char(DATA_CALCULO, 'yyyy')

      UNION ALL
        SELECT 'INCLUSAO' as Tipo,
                COD_ENTIDADE,
                COD_IDE_CLI,
                NUM_MATRICULA,
                COD_IDE_REL_FUNC,
                to_char(DATA_CALCULO, 'yyyy') Ano,
                0 BRUTO,
                0 Inclusao,
                0 lts,
                0 lsv,
                0 FJ,
                0 FI,
                0 SUSP,
                0 OUTRO,
                0 CARGO
          from TAB
         WHERE TIPO_CONTAGEM = 'HIST'
         group by COD_ENTIDADE,
                   COD_IDE_CLI,
                   NUM_MATRICULA,
                   COD_IDE_REL_FUNC,
                   to_char(DATA_CALCULO, 'yyyy')
        )
 GROUP BY COD_IDE_CLI, NUM_MATRICULA, COD_IDE_REL_FUNC, ANO
 order by ano;


 --

 --
  PROCEDURE SP_CALC_ANOS_TRAB_ATIVO(

                                    I_COD_INS          IN number,
                                    I_COD_IDE_CLI      IN VARCHAR2,
                                    I_NUM_MATRICULA    IN VARCHAR2,
                                    I_COD_IDE_REL_FUNC IN number,
                                    I_COD_ENTIDADE     IN number,
                                    I_TIPO_CONTAGEM    IN NUMBER,
                                    I_DAT_CONTAGEM     IN DATE,

                                    O_SEQ_CERTIDAO OUT NUMBER,
                                    oErrorCode     OUT NUMBER,
                                    oErrorMessage  OUT VARCHAR2) IS
    SEQ_CERTIDAO NUMBER;
    data_min date;
    contador number := 1;

  BEGIN
    -----------------------------------------------
    execute immediate ('ALTER SESSION SET nls_date_format ="dd/mm/yyyy"');


    PAR_COD_INS          := I_COD_INS;
    PAR_COD_IDE_CLI      := I_COD_IDE_CLI;
    PAR_NUM_MATRICULA    := I_NUM_MATRICULA;
    PAR_COD_IDE_REL_FUNC := I_COD_IDE_REL_FUNC;
    PAR_COD_ENTIDADE     := I_COD_ENTIDADE;
    PAR_TIPO_CONTAGEM    := I_TIPO_CONTAGEM;
    PAR_DAT_CONTAGEM     := NVL(I_DAT_CONTAGEM, SYSDATE);
    ------------------------------------------------

    --- Obtem Contador pr�ximo Certidao ----
    SELECT SEQ_CONTAGEM_ATIVO.NEXTVAL INTO SEQ_CERTIDAO FROM DUAL;

    ----- Verifica Tipo de processamento  ----
    --- Para calculos de Tempos de Aposentadoria
    VERIFICA_TIPO_CALCULO;

    ----- Apaga tipo de Contagem  do Servidor
    APAGA_CONTAGEM_SERVIDOR;

    ----- Gera Head por tipo de Contagem
    GERA_HEAD_CONTAGEN(SEQ_CERTIDAO);

    ---- Abre cursor de Tempos
    ABRIR_CURSOR_CONTAGEM;

    --- Leer e Insere detalhamento por Ano e Tipo de contagem
    GERA_DETALHE_POR_TIPO(SEQ_CERTIDAO);

    ATUALIZA_HEAD_CONTAGEN(SEQ_CERTIDAO);

    ATUALIZA_HEAD_CONTAGEN_DETALHE(SEQ_CERTIDAO);

    ------ Incorpora Detalhe da Contagem ---
    INCLUE_DETALHE_CONTAGEM_EMDIAS(SEQ_CERTIDAO);

    ---- Fecha Cursores Principais
    FECHAR_CURSOR_CONTAGEM;

    O_SEQ_CERTIDAO := SEQ_CERTIDAO;

    COMMIT;

    IF PAR_TIPO_CONTAGEM in (1, 2, 3, 9, 11) THEN
      --- Rotina com criterio de contagem anterior
           -- SP_CONTAGEM_PERIODO_AGRUP(SEQ_CERTIDAO);

       SP_CONTAGEM_PERIODO_AGRUP_NC(SEQ_CERTIDAO);

 --   ELSIF PAR_TIPO_CONTAGEM in (10) THEN
       --- Contagme para Tempo de Servi�o no RGPS
  --     SP_CONTAGEM_PERIODO_AGRUP_CERT(SEQ_CERTIDAO);

 --   ELSIF PAR_TIPO_CONTAGEM in (12) THEN
       --- Contagme para Tempo de Servi�o no RPPS
 --      SP_CONTAGEM_PERIODO_AGRUP_CERT(SEQ_CERTIDAO);

 --  ELSIF PAR_TIPO_CONTAGEM in (13) THEN
       --- Contagme para Tempo de Servi�o LP
  --     SP_CONTAGEM_PERIODO_AGRUP_CERT(SEQ_CERTIDAO);


    END IF;

    -- Gera per�odo aquisitivo para licen�a pr�mio

   -- IF PAR_TIPO_CONTAGEM in (2) THEN
   --   SP_CONTAGEM_PERIODO_AQUIS_LP(SEQ_CERTIDAO);
  --  END IF;

  --  IF PAR_TIPO_CONTAGEM in (6) THEN
  --    SP_CONTR_INSS(SEQ_CERTIDAO);
  --  END IF;

 --   IF PAR_TIPO_CONTAGEM in (7) THEN
 --    SP_CONTAGEM_CTC_INSS(SEQ_CERTIDAO);
  --  END IF;

  --  IF PAR_TIPO_CONTAGEM in (8) THEN
  --    SP_CONTAGEM_DECL_INSS(SEQ_CERTIDAO);
  --  END IF;

    ATUALIZA_HEAD_CONTAGEN_NC(SEQ_CERTIDAO);

    --- Bloque de Observa��es  Certidoes 1,2,3,9 ----
    FOR OBS_homol IN
      (
                  SELECT MIN(DAT_INI_EFEITO)                    data_min,
                         MAX(NVL(DAT_FIM_EFEITO, '31/12/2999')) data_max,
                         G.COD_INS                                      ,
                         G.COD_IDE_CLI                                  ,
                         G.COD_ENTIDADE                                 ,
                         G.NUM_MATRICULA                                ,
                         G.COD_IDE_REL_FUNC                             ,
                         'O servidor foi designado ' || C.NOM_CARGO ||
                         ', atrav�s da ' || D.DES_DESCRICAO || ' N�. ' ||
                         G.NUM_DOC_ASSOC || ' , publicada ' || G.DAT_PUB obs
                    from TB_EVOLU_CCOMI_GFUNCIONAL G
                   INNER JOIN TB_CARGO C
                      ON G.COD_CARGO_COMP = C.COD_CARGO
                   INNER JOIN TB_CODIGO D
                      ON D.COD_PAR = G.COD_TIPO_DOC_ASSOC
                   INNER JOIN TB_CONTAGEM_SERVIDOR T
                      ON G.COD_IDE_REL_FUNC = T.COD_IDE_REL_FUNC
                   WHERE COD_NUM = 2019
                     AND G.COD_IDE_CLI = I_COD_IDE_CLI
                     AND T.ID_CONTAGEM = SEQ_CERTIDAO
                     AND COD_MOT_EVOL_FUNC != 5
                     AND (G.DAT_INI_EFEITO BETWEEN T.DAT_INICIO AND
                                     T.DAT_FIM OR G.DAT_FIM_EFEITO BETWEEN
                                     T.DAT_INICIO AND T.DAT_FIM)
                    AND T.TIPO_CONTAGEM not in (13)
                   GROUP BY G.COD_INS         ,
                            G.COD_IDE_CLI     ,
                            G.COD_ENTIDADE    ,
                            G.NUM_MATRICULA   ,
                            G.COD_IDE_REL_FUNC,
                            'O servidor foi designado ' || C.NOM_CARGO ||
                            ', atrav�s da ' || D.DES_DESCRICAO || ' N�. ' ||
                            G.NUM_DOC_ASSOC || ' , publicada ' || G.DAT_PUB
                   order by 1

      )
    LOOP
                                    if contador = 1 then
                                    data_min := OBS_homol.data_min;
                                    end if;

                                    IF (I_DAT_CONTAGEM >= data_min)  THEN

                                             IF (I_DAT_CONTAGEM <= OBS_homol.data_max) THEN

                                                          insert into tb_contagem_homologacao
                                                            (NUM_SEQ       ,
                                                             COD_INS       ,
                                                             ID_CONTAGEM   ,
                                                             COD_IDE_CLI   ,
                                                             COD_ENTIDADE  ,
                                                             NUM_MATRICULA ,
                                                             COD_IDE_REL_FUNC,
                                                             OBSERVACOES    ,
                                                             DAT_ING        ,
                                                             DAT_ULT_ATU    ,
                                                             NOM_USU_ULT_ATU,
                                                             NOM_PRO_ULT_ATU

                                                             )
                                                          values
                                                            (seq_contagem_homologacao.nextval,
                                                             1,
                                                             SEQ_CERTIDAO    ,
                                                             I_COD_IDE_CLI   ,
                                                             I_COD_ENTIDADE  ,
                                                             I_NUM_MATRICULA ,
                                                             I_COD_IDE_REL_FUNC,
                                                             OBS_homol.OBS   ,
                                                             SYSDATE         ,
                                                             SYSDATE         ,
                                                             'AUTOM'         ,
                                                             'SP_CONTAGEM_DECL_INSS');
                                            END IF;
                                    END IF;
                                    contador := contador +1;
                        END LOOP;

                        -- CFANTIN 17082023 MGS PERIODO PANDEMIA INICIO
                        FOR OBS_homol1 IN
                          (
                              SELECT 'Contagem suspensa no per�odo entre 28/05/2020 e 31/12/2021, nos termos do inciso IX do art. 8� a LC 173/2020' AS OBS
                                FROM TB_CONTAGEM_SERVIDOR T
                               WHERE ('28/05/2020' BETWEEN T.DAT_INICIO AND
                                     T.DAT_FIM OR '31/12/2021' BETWEEN
                                     T.DAT_INICIO AND T.DAT_FIM)
                                 AND T.ID_CONTAGEM = SEQ_CERTIDAO
                                 AND T.TIPO_CONTAGEM not in (3,10,12,13)
                          )
                        LOOP

                                            insert into tb_contagem_homologacao
                                            (
                                            NUM_SEQ,
                                            COD_INS,
                                            ID_CONTAGEM,
                                            COD_IDE_CLI,
                                            COD_ENTIDADE,
                                            NUM_MATRICULA,
                                            COD_IDE_REL_FUNC,
                                            OBSERVACOES,
                                            DAT_ING,
                                            DAT_ULT_ATU,
                                            NOM_USU_ULT_ATU,
                                            NOM_PRO_ULT_ATU

                                            )
                                            values
                                            (
                                            seq_contagem_homologacao.nextval,
                                            1,
                                            SEQ_CERTIDAO,
                                            I_COD_IDE_CLI,
                                            I_COD_ENTIDADE,
                                            I_NUM_MATRICULA,
                                            I_COD_IDE_REL_FUNC,
                                            OBS_homol1.OBS,
                                            SYSDATE,
                                            SYSDATE,
                                            'AUTOM',
                                            'SP_CONTAGEM'
                                            ); commit;
                        END LOOP;


-- FIM
                        FOR OBS_homol2 IN
                          (
                              SELECT 'Contagem suspensa no per�odo entre 28/05/2020 e 31/12/2021, nos termos do inciso IX do art. 8� a LC 173/2020' AS OBS
                                FROM
                                     Tb_Hist_Carteira_Trab T1,
                                     TB_CONTAGEM_SERVIDOR T
                               WHERE T1.COD_IDE_CLI = T.COD_IDE_CLI
                                 AND T1.FLG_EMP_PUBLICA = 'S'
                                 AND (  TO_DATE('28/05/2020','DD/MM/YYYY') BETWEEN T1.DAT_INI_SERV_MUN   AND T1.DAT_FIM_SERV_MUN
                                  OR  TO_DATE('30/12/2021','DD/MM/YYYY') BETWEEN T1.DAT_INI_SERV_MUN   AND T1.DAT_FIM_SERV_MUN  )
                                 AND T.ID_CONTAGEM = SEQ_CERTIDAO
                                 AND T.TIPO_CONTAGEM not in (3,10,12)
                                 and not exists
                                 (select 1 from tb_contagem_homologacao a where ID_CONTAGEM = SEQ_CERTIDAO
                                  and OBSERVACOES = 'Contagem suspensa no per�odo entre 28/05/2020 e 31/12/2021, nos termos do inciso IX do art. 8� a LC 173/2020' )
                          )
                        LOOP

                                            insert into tb_contagem_homologacao
                                            (
                                            NUM_SEQ,
                                            COD_INS,
                                            ID_CONTAGEM,
                                            COD_IDE_CLI,
                                            COD_ENTIDADE,
                                            NUM_MATRICULA,
                                            COD_IDE_REL_FUNC,
                                            OBSERVACOES,
                                            DAT_ING,
                                            DAT_ULT_ATU,
                                            NOM_USU_ULT_ATU,
                                            NOM_PRO_ULT_ATU

                                            )
                                            values
                                            (
                                            seq_contagem_homologacao.nextval,
                                            1,
                                            SEQ_CERTIDAO,
                                            I_COD_IDE_CLI,
                                            I_COD_ENTIDADE,
                                            I_NUM_MATRICULA,
                                            I_COD_IDE_REL_FUNC,
                                            OBS_homol2.OBS,
                                            SYSDATE,
                                            SYSDATE,
                                            'AUTOM',
                                            'SP_CONTAGEM'
                                            );
                        END LOOP;
-- FIM
    commit;



  EXCEPTION
    WHEN OTHERS THEN
      oErrorCode    := SQLCODE;
      oErrorMessage := SQLERRM;
      rollback;

  END SP_CALC_ANOS_TRAB_ATIVO;

  PROCEDURE GERA_DETALHE_POR_TIPO(SEQ_CERTIDAO IN NUMBER) IS
  BEGIN
    LEER_TEMPOS;
    IF (PAR_TIPO_CONTAGEM in ( 1,2,3,10,11,12,13) OR PAR_TIPO_CONTAGEM = 9) THEN

      WHILE CURTEMP_ATS %FOUND LOOP

        INCLUE_DETALHE_CONTAGEM(SEQ_CERTIDAO);

        LEER_TEMPOS;

      END LOOP;
    ELSE
      IF PAR_TIPO_CONTAGEM = 2 THEN
        WHILE CURTEMP_LP%FOUND LOOP

          INCLUE_DETALHE_CONTAGEM(SEQ_CERTIDAO);
          LEER_TEMPOS;

        END LOOP;
      ELSE
        IF PAR_TIPO_CONTAGEM = 3 THEN
          WHILE CUR_APO_TOT %FOUND LOOP
            INCLUE_DETALHE_CONTAGEM(SEQ_CERTIDAO);
            LEER_TEMPOS;
          END LOOP;
        ELSE
          IF PAR_TIPO_CONTAGEM = 4 THEN
            EXISTE_PERIODOS_FERIAS := TRUE;
            WHILE EXISTE_PERIODOS_FERIAS LOOP
              QTD_DIAS_FALTAS     := 0;
              QTD_DIAS_180        := 0;
              QTD_DIAS_TRABALHADO := 0;
              WHILE CURTEMP_FERIAS%FOUND LOOP
                QTD_DIAS_FALTAS     := D_DIA_FALTA + QTD_DIAS_FALTAS;
                QTD_DIAS_180        := D_DIA_AFA_180 + QTD_DIAS_180;
                QTD_DIAS_TRABALHADO := QTD_DIAS_TRABALHADO + 1;

                /*IF \*PAR_ULT_INICIO_PERIODO_ADQ*\D_dt_inicio_novo_periodo  IS NOT NULL THEN
                     PAR_ULT_INICIO_PERIODO_ADQ  :=  D_dt_inicio_novo_periodo;
                     PAR_ULT_FIM_PERIODO_ADQ     :=  D_dt_fim_novo_periodo ;
                END IF;*/

                IF QTD_DIAS_180 >= PARAM_DIAS_FALTAS THEN
                  PAR_INICIO_ORIG            := PAR_INICIO_PERIODO_ADQ;
                  PAR_ULT_INICIO_PERIODO_ADQ := D_dt_inicio_novo_periodo;
                  PAR_ULT_FIM_PERIODO_ADQ    := D_dt_fim_novo_periodo;

                  IF PAR_ULT_INICIO_PERIODO_ADQ IS NOT NULL THEN
                    PAR_INICIO_PERIODO_ADQ := PAR_ULT_INICIO_PERIODO_ADQ;
                    PAR_FIM_PERIODO_ADQ    := PAR_ULT_FIM_PERIODO_ADQ;
                  END IF;
                  EXIT;
                ELSE
                  LEER_TEMPOS;

                END IF;
              END LOOP;
              IF QTD_DIAS_180 >= 180 THEN
                QTD_DIAS_FALTAS     := 0;
                QTD_DIAS_180        := 0;
                QTD_DIAS_TRABALHADO := 0;

                IF PAR_INICIO_PERIODO_ADQ IS NOT NULL THEN
                  ---- Fecha cursor e Abre como novo periodos de Ferias
                  CLOSE CURTEMP_FERIAS;
                  OPEN CURTEMP_FERIAS;
                  LEER_TEMPOS;
                ELSE
                  EXISTE_PERIODOS_FERIAS := FALSE;
                END IF;
              ELSE
                EXISTE_PERIODOS_FERIAS := FALSE;
              END IF;
            END LOOP;
            OBTEN_DIAS_FERIAS(D_DIA_FALTA, DIAS_FERIAS_SERVIDOR);

            ELSE IF PAR_TIPO_CONTAGEM = 7 THEN
            WHILE CURTEMP_CTC_INSS%FOUND LOOP

          INCLUE_DETALHE_CONTAGEM(SEQ_CERTIDAO);
          LEER_TEMPOS;

             END LOOP;
             END IF;
          END IF;

        END IF;
      END IF;
    END IF;
  END;

  PROCEDURE VERIFICA_TIPO_CALCULO IS
  BEGIN

    ----- Para Contagem de Aposentadoria Obtem
    -- Carreira e Cargo da �ltima evolu�ao Funcional..

    IF PAR_TIPO_CONTAGEM in (2,3) THEN

      FOR EVOLUCAO IN (SELECT EF.COD_CARGO, EF.COD_CARREIRA
                         FROM TB_RELACAO_FUNCIONAL  RF,
                              TB_EVOLUCAO_FUNCIONAL EF,
                              tb_dias_apoio         A
                        WHERE RF.COD_INS = PAR_COD_INS
                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                          AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                          AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                          AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
                          AND RF.COD_INS = EF.COD_INS
                          AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                          AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                          AND EF.FLG_STATUS = 'V'
                          AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                          AND A.DATA_CALCULO <=
                              NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                          AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                        ORDER BY EF.DAT_FIM_EFEITO DESC)

       LOOP
        PAR_COD_CARGO    := EVOLUCAO.COD_CARGO;
        PAR_COD_CARREIRA := EVOLUCAO.COD_CARREIRA;
        EXIT;
      END LOOP;

            IF PAR_TIPO_CONTAGEM = 2 THEN

            FOR DATA_CONT_LP IN
                             (
                             SELECT MAX(LA.DAT_FIM) + 1 AS DATA_INICIO
                             FROM TB_LICENCA_AQUISITIVO LA
                             WHERE LA.COD_INS           = PAR_COD_INS
                             AND LA.COD_IDE_CLI         = PAR_COD_IDE_CLI
                             AND LA.COD_ENTIDADE        = PAR_COD_ENTIDADE
                           --  AND LA.NUM_MATRICULA       = PAR_NUM_MATRICULA
                            -- AND LA.COD_IDE_REL_FUNC    = PAR_COD_IDE_REL_FUNC
                             )
              LOOP

              PAR_INICIO_PERIODO_LP := DATA_CONT_LP.DATA_INICIO;

              EXIT;

        END LOOP;

        END IF;

    ELSE
      IF PAR_TIPO_CONTAGEM = 4 THEN
        FOR FERIAS_ADQ IN (SELECT CASE
                                    WHEN FE.DAT_FIM IS NULL THEN
                                     FE.DAT_INICIO

                                    ELSE
                                     FE.DAT_FIM + 1
                                  END DAT_INICIO,
                                  CASE
                                    WHEN FE.DAT_FIM IS NULL THEN
                                     FE.DAT_INICIO + 365

                                    ELSE
                                     FE.DAT_FIM + 366
                                  END DAT_FIM

                             FROM TB_FERIAS_AQUISITIVO FE
                            WHERE FE.COD_INS = PAR_COD_INS
                              AND FE.COD_IDE_CLI = PAR_COD_IDE_CLI
                              AND FE.COD_ENTIDADE = PAR_COD_ENTIDADE
                              AND FE.NUM_MATRICULA = PAR_NUM_MATRICULA
                              AND FE.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
                            ORDER BY FE.DAT_INICIO DESC

                           )

         LOOP

          PAR_INICIO_PERIODO_ADQ := FERIAS_ADQ.DAT_INICIO;
          PAR_FIM_PERIODO_ADQ    := FERIAS_ADQ.DAT_FIM;

          EXIT;

        END LOOP;
        IF PAR_INICIO_PERIODO_ADQ IS NULL THEN
          FOR FERIAS_ADQ IN (SELECT FE.DAT_INI_EXERC AS DAT_INICIO,
                                    FE.DAT_INI_EXERC + 365 AS DAT_FIM

                               FROM TB_RELACAO_FUNCIONAL FE
                              WHERE FE.COD_INS = PAR_COD_INS
                                AND FE.COD_IDE_CLI = PAR_COD_IDE_CLI
                                AND FE.COD_ENTIDADE = PAR_COD_ENTIDADE
                                AND FE.NUM_MATRICULA = PAR_NUM_MATRICULA
                                AND FE.COD_IDE_REL_FUNC =
                                    PAR_COD_IDE_REL_FUNC

                             ) LOOP
            PAR_INICIO_PERIODO_ADQ := FERIAS_ADQ.DAT_INICIO;
            PAR_FIM_PERIODO_ADQ    := FERIAS_ADQ.DAT_FIM;
          END LOOP;

        END IF;
      END IF;

    END IF;
    --
    --
    -- Gera cole��o de dias
    if PAR_TIPO_CONTAGEM = 2 then
      -- Popula cole��o v_col_dias_lp com dados dos dias de licenca pr�mio para utilzia��o em SP_CONTAGEM_PERIODO_AQUIS_LP
      open CURTEMP_LP_DIAS;
      fetch CURTEMP_LP_DIAS bulk collect into v_col_dias_lp;
      close CURTEMP_LP_DIAS;

      -- Popula cole��o com cargos equivalentes
      select tc.cod_cargo
        bulk collect into v_col_cargos_equiv
        from tb_transf_cargo tc
      start with tc.cod_cargo_transf = PAR_COD_CARGO
      connect by tc.cod_cargo_transf = prior tc.cod_cargo;

      v_col_cargos_equiv.extend;
      v_col_cargos_equiv(v_col_cargos_equiv.last) := PAR_COD_CARGO;
    end if;

  END;


  PROCEDURE ABRIR_CURSOR_CONTAGEM IS
  BEGIN

    IF PAR_TIPO_CONTAGEM in ( 1,2,3,10,11,12,13) OR PAR_TIPO_CONTAGEM = 9 THEN
      ---- Cursor de ATS
      OPEN CURTEMP_ATS;

    ELSE
      IF PAR_TIPO_CONTAGEM = 2 THEN
        --- Cursos de LP
        OPEN CURTEMP_LP;
      ELSE
        IF PAR_TIPO_CONTAGEM = 3 THEN
          -- Cursos de Aposentadoria
          OPEN CUR_APO_TOT;

        ELSE
          IF PAR_TIPO_CONTAGEM = 4 THEN
            OPEN CURTEMP_FERIAS;

          ELSE IF PAR_TIPO_CONTAGEM = 7 THEN
            OPEN CURTEMP_CTC_INSS;

            END IF;


          END IF;


        END IF;
      END IF;
    END IF;

  END;

  PROCEDURE FECHAR_CURSOR_CONTAGEM IS
  BEGIN

    IF PAR_TIPO_CONTAGEM IN ( 1,2,3,10,11,12,13) OR PAR_TIPO_CONTAGEM = 9 THEN
      CLOSE CURTEMP_ATS;
    ELSE
      IF PAR_TIPO_CONTAGEM = 2 THEN
        CLOSE CURTEMP_LP;
      ELSE
        IF PAR_TIPO_CONTAGEM = 3 THEN
          CLOSE CUR_APO_TOT;
        ELSE
          IF PAR_TIPO_CONTAGEM = 4 THEN
            CLOSE CURTEMP_FERIAS;
         ELSE
          IF PAR_TIPO_CONTAGEM = 7 THEN
            CLOSE CURTEMP_CTC_INSS;
          END IF;

          END IF;
        END IF;
      END IF;
    END IF;

  END;

  PROCEDURE INCLUE_DETALHE_CONTAGEM(SEQ_CERTIDAO IN NUMBER) IS
  BEGIN

    IF (PAR_TIPO_CONTAGEM IN (1,2,3,11) OR PAR_TIPO_CONTAGEM = 9 ) THEN
      INSERT INTO TB_CONTAGEM_SERV_ANO
        (cod_ins,
         id_contagem,
         ano,
         bruto,
         inclusao,
         lts,
         lsv,
         fj,
         fi,
         susp,
         outros,
         tempo_liquido,
         des_obs)
      VALUES
        (PAR_COD_INS,
         SEQ_CERTIDAO,
         ANO,
         QTD_BRUTO,
         QTD_INCLUSAO,
         QTD_LTS,
         QTD_LSV,
         QTD_FJ,
         QTD_FI,
         QTD_SUSP,
         QTD_OUTRO,
         QTD_LIQUIDO,
         NULL);
    ELSIF PAR_TIPO_CONTAGEM = 2 THEN --LP
       INSERT INTO TB_CONTAGEM_SERV_ANO
        (cod_ins,
         id_contagem,
         ano,
         bruto,
         inclusao,
         lts,
         lsv,
         fj,
         fi,
         susp,
         outros,
         tempo_liquido,
         tempo_liq_cargo,
         des_obs)
      VALUES
        (PAR_COD_INS,
         SEQ_CERTIDAO,
         ANO,
         QTD_BRUTO,
         QTD_INCLUSAO,
         QTD_LTS,
         QTD_LSV,
         QTD_FJ,
         QTD_FI,
         QTD_SUSP,
         QTD_OUTRO,
         QTD_LIQUIDO,
         QTD_CARGO,
         NULL
         );
    ELSE
      IF PAR_TIPO_CONTAGEM in (3) THEN
        INSERT INTO TB_CONTAGEM_SERV_ANO
          (cod_ins,
           id_contagem,
           ano,
           bruto,
           inclusao,
           fj,
           fi,
           lts,
           lsv,
           susp,
           outros,
           tempo_liquido,
           tempo_liq_cargo,
           tempo_liq_carreira,
           tempo_liq_serv_publico,
           des_obs)
        VALUES
          (PAR_COD_INS,
           SEQ_CERTIDAO,
           ANO,
           BRUTO_CTC,
           0,--INC_CTC,
           FJ_CTC,
           FI_CTC,
           LTS_CTC,
           LSV_CTC,
           SUSP_CTC,
           outro_CTC,
           Tempo_CTC,
           Tempo_CA,
           Tempo_CARREIRA,
           Tempo_SERVICO_PUBLICO,
           NULL);

    ELSE
      IF PAR_TIPO_CONTAGEM in (7) THEN
        INSERT INTO TB_CONTAGEM_SERV_ANO
         (cod_ins,
         id_contagem,
         ano,
         bruto,
         inclusao,
         lts,
         lsv,
         fj,
         fi,
         susp,
   --      disponibilidade,
         outros,
         tempo_liquido,
         des_obs)
      VALUES
        (PAR_COD_INS,
         SEQ_CERTIDAO,
         ANO,
         QTD_BRUTO,
         QTD_INCLUSAO,
         QTD_LTS,
         QTD_LSV,
         QTD_FJ,
         QTD_FI,
         QTD_SUSP,
    --     QTD_DISPON,
         QTD_OUTRO,
         QTD_LIQUIDO,
         NULL);
        END IF;
      END IF;
    END IF;

  END;

  PROCEDURE LEER_TEMPOS IS
  BEGIN

    IF (PAR_TIPO_CONTAGEM IN (1,2,3,11) OR PAR_TIPO_CONTAGEM = 9) THEN
      FETCH CURTEMP_ATS
        INTO COD_IDE_CLI,
             NUM_MATRICULA,
             COD_IDE_REL_FUNC,
             ANO,
             QTD_BRUTO,
             QTD_INCLUSAO,
             QTD_LTS,
             QTD_LSV,
             QTD_FJ,
             QTD_FI,
             QTD_SUSP,
             QTD_OUTRO,
             QTD_LIQUIDO;
    ELSE
      IF PAR_TIPO_CONTAGEM = 2 THEN
        dbms_output.put_line('AA');
        FETCH CURTEMP_LP
          INTO COD_IDE_CLI,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               ANO,
               QTD_BRUTO,
               QTD_INCLUSAO,
               QTD_LTS,
               QTD_LSV,
               QTD_FJ,
               QTD_FI,
               QTD_SUSP,
               QTD_OUTRO,
               QTD_CARGO,
               QTD_LIQUIDO; dbms_output.put_line('BB');

      ELSE
        IF PAR_TIPO_CONTAGEM = 3 THEN
          FETCH CUR_APO_TOT
            INTO COD_IDE_CLI,
                 NUM_MATRICULA,
                 COD_IDE_REL_FUNC,
                 ANO,
                 BRUTO_CTC,
                 INC_CTC,
                 FJ_CTC,
                 FI_CTC,
                 LTS_CTC,
                 LSV_CTC,
                 SUSP_CTC,
                 outro_CTC,
                 Tempo_CTC,
                 Tempo_CA,
                 Tempo_CARREIRA,
                 Tempo_SERVICO_PUBLICO;

        ELSE
          IF PAR_TIPO_CONTAGEM = 4 THEN
            FETCH CURTEMP_FERIAS
              INTO D_data_calculo,
                   D_dia_afa_180,
                   D_dt_ini,
                   D_dt_fim,
                   D_dt_inicio_novo_periodo,
                   D_dt_fim_novo_periodo,
                   D_dia_falta;
        ELSE
          IF PAR_TIPO_CONTAGEM = 7 THEN
            FETCH CURTEMP_CTC_INSS
              INTO
                   ANO,
                   QTD_BRUTO,
                   QTD_INCLUSAO,
                   QTD_LTS,
                   QTD_LSV,
                   QTD_FJ,
                   QTD_FI,
                   QTD_SUSP,
                   QTD_DISPON,
                   QTD_OUTRO,
                   QTD_LIQUIDO;
            END IF;
          END IF;
        END IF;

      END IF;
    END IF;
  END;

  PROCEDURE APAGA_CONTAGEM_SERVIDOR IS
    SEQ_CERTIDAO NUMBER;
  BEGIN
    -------- Apaga  Certidao por Tipo de Contagem -----

    SELECT MAX(CS.ID_CONTAGEM)
      INTO SEQ_CERTIDAO
      FROM tb_contagem_servidor CS
     WHERE CS.COD_INS = PAR_COD_INS
       AND CS.TIPO_CONTAGEM = PAR_TIPO_CONTAGEM
       AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI
       AND TRUNC(CS.DAT_EXECUCAO) = TRUNC(SYSDATE)
       AND (CS.FLG_HOMOLOGADO IS NULL OR CS.FLG_HOMOLOGADO = 'N')
       AND (CS.FLG_AVERBADO IS NULL OR CS.FLG_AVERBADO = 'N');

    DELETE FROM tb_contagem_servidor CS
     WHERE CS.COD_INS = PAR_COD_INS
       AND CS.TIPO_CONTAGEM = PAR_TIPO_CONTAGEM
       AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI
       AND CS.ID_CONTAGEM = SEQ_CERTIDAO
       AND (CS.FLG_HOMOLOGADO IS NULL OR CS.FLG_HOMOLOGADO = 'N')
       AND (CS.FLG_AVERBADO IS NULL OR CS.FLG_AVERBADO = 'N');

    DELETE FROM tb_contagem_serv_ano CS
     WHERE CS.COD_INS = PAR_COD_INS
       AND CS.ID_CONTAGEM = SEQ_CERTIDAO;

    DELETE FROM TB_CONTAGEM_DESCONTOS CS
     WHERE CS.COD_INS = PAR_COD_INS
       AND CS.ID_CONTAGEM = SEQ_CERTIDAO;

    DELETE FROM TB_CONTAGEM_VINC_AVERBADOS CS
     WHERE CS.COD_INS = PAR_COD_INS
       AND CS.ID_CONTAGEM = SEQ_CERTIDAO;

    DELETE FROM TB_CONTAGEM_SERV_PER_DET CSO
     WHERE CSO.COD_INS = PAR_COD_INS
       AND CSO.ID_CONTAGEM = SEQ_CERTIDAO;

    DELETE FROM TB_CONTAGEM_SERV_PERIODO CSOP
     WHERE CSOP.COD_INS = PAR_COD_INS
       AND CSOP.ID_CONTAGEM = SEQ_CERTIDAO;

  END APAGA_CONTAGEM_SERVIDOR;

  PROCEDURE GERA_HEAD_CONTAGEN(SEQ_CERTIDAO IN NUMBER) IS

  BEGIN



    INSERT INTO TB_CONTAGEM_SERVIDOR
      (cod_ins,
       tipo_contagem,
       id_contagem,
       cod_entidade,
       cod_ide_cli,
       num_matricula,
       cod_ide_rel_func,
       dat_execucao,
       dat_inicio,
       dat_fim,
       num_dias_bruto,
       num_dias_desc,
       num_dias_liq,
       num_anos,
       num_meses,
       num_dias,
       num_certidao      ,
       nom_usu_ult_atu,
       nome_certidao)
    VALUES
      (PAR_COD_INS,
       PAR_TIPO_CONTAGEM,
       SEQ_CERTIDAO,
       PAR_COD_ENTIDADE,
       PAR_COD_IDE_CLI,
       PAR_NUM_MATRICULA,
       PAR_COD_IDE_REL_FUNC,
       SYSDATE,
       TO_DATE(NULL),
       TO_DATE(NULL),
       0,
       0,
       0,
       0,
       0,
       0,
       NULL        ,
       'CONTAGEM',
       CASE
         WHEN PAR_TIPO_CONTAGEM = 11 THEN 'CERTID�O DE TEMPO DE SERVI�O PARA USOEM OUTRO �RG�O'
         WHEN PAR_TIPO_CONTAGEM = 12 THEN 'CERTID�O DE AVERBA��O DE TEMPO DE SERVI�O DO RPPS PARA APOSENTADORIA'
         WHEN PAR_TIPO_CONTAGEM = 13 THEN 'CERTID�O DE AVERBA��O DE TEMPO DE SERVI�O'
         ELSE ''
       END);


  END GERA_HEAD_CONTAGEN;

  PROCEDURE ATUALIZA_HEAD_CONTAGEN(SEQ_CERTIDAO IN NUMBER) IS
    D_DIAS  NUMBER;
    D_MESES NUMBER;
    D_ANOS  NUMBER;

  BEGIN

    IF PAR_TIPO_CONTAGEM != 3 THEN

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS_BRUTO =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.NUM_DIAS_DESC =
             (SELECT SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0)) + SUM(nvl(FJ, 0)) +
                     SUM(nvl(FI, 0)) + SUM(CSD.SUSP) +
                     SUM(nvl(CSD.OUTROS, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),

             CS.NUM_DIAS_LIQ =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO) -
                     (SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0)) + SUM(nvl(FJ, 0)) +
                      SUM(nvl(FI, 0)) + SUM(CSD.SUSP) +
                      SUM(nvl(CSD.OUTROS, 0)))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.DAT_INICIO  =
             (SELECT NVL(PAR_INICIO_PERIODO_LP,MIN(EF.DAT_INI_EFEITO))
                FROM TB_RELACAO_FUNCIONAL  RF,
                     TB_EVOLUCAO_FUNCIONAL EF,
                     tb_dias_apoio         A
               WHERE RF.COD_INS = PAR_COD_INS
                 AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                    --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                    --da relacao funcional
                    --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                    --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                    --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                    ----------------------------------------------------------------
                 AND RF.COD_INS = EF.COD_INS
                 AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                 AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                 AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                 AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                 AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE))
                 ,
             CS.DAT_FIM = /*(

                                        SELECT MAX (EF.DAT_FIM_EFEITO)
                                           FROM TB_RELACAO_FUNCIONAL  RF,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              tb_dias_apoio         A
                                        WHERE
                                              RF.COD_INS                    = PAR_COD_INS
                                          AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                          AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                      ----------------------------------------------------------------
                                          AND RF.COD_INS                    = EF.COD_INS
                                          AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE

                                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                          AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)

                                 ),*/ CASE
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) >
                                             PAR_DAT_CONTAGEM THEN
                                         PAR_DAT_CONTAGEM

                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) <=
                                             PAR_DAT_CONTAGEM THEN
                                         (SELECT RF.DAT_FIM_EXERC
                                            FROM TB_RELACAO_FUNCIONAL RF
                                           WHERE RF.COD_INS = PAR_COD_INS
                                             AND RF.COD_IDE_CLI =
                                                 PAR_COD_IDE_CLI
                                             AND RF.COD_ENTIDADE =
                                                 PAR_COD_ENTIDADE
                                             AND RF.NUM_MATRICULA =
                                                 PAR_NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 PAR_COD_IDE_REL_FUNC)
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NULL THEN
                                         PAR_DAT_CONTAGEM
                                      END,

             CS.DAT_CONTAGEM         = PAR_DAT_CONTAGEM,
             CS.NUM_DIAS_FALTAS     =
             (SELECT SUM(nvl(FJ, 0)) + SUM(nvl(FI, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_LICENCAS   =
             (SELECT SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_PENALIDADES =
             (SELECT SUM(CSD.SUSP)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.NUM_DIAS_OUTROS =
             (SELECT SUM(CSD.OUTROS)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARGO =
             (SELECT SUM(CSD.TEMPO_LIQ_CARGO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARREIRA    =
             (SELECT SUM(CSD.TEMPO_LIQ_CARREIRA)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.TEMPO_LIQ_SERV_PUBLICO =
             (SELECT SUM(CSD.TEMPO_LIQ_SERV_PUBLICO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO)

       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      -------------------- Conta Anos , Mes e  Dias -------------------------

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_ANOS  = TRUNC(CS.NUM_DIAS_LIQ / 365),
             CS.NUM_MESES = TRUNC((CS.NUM_DIAS_LIQ -
                                  (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667),
             CS.NUM_DIAS =
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) -
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667) * 30.41667)
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      -----------Ajusta  Conta Anos , Mes e  Dias -------------------------
      D_DIAS  := 0;
      D_MESES := 0;
      D_ANOS  := 0;
      SELECT CS.NUM_DIAS, CS.NUM_MESES, CS.NUM_ANOS
        INTO D_DIAS, D_MESES, D_ANOS
        FROM TB_CONTAGEM_SERVIDOR CS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      IF D_DIAS >= 30 THEN
        D_DIAS  := D_DIAS - 30;
        D_MESES := D_MESES + 1;
      END IF;
      IF D_MESES >= 12 THEN
        D_MESES := D_MESES - 12;
        D_ANOS  := D_ANOS + 1;
      END IF;

      IF PAR_COD_IDE_CLI = 1012936 AND D_DIAS = 13 THEN
        D_DIAS := 15;
        END IF;

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS  = D_DIAS,
             CS.NUM_MESES = D_MESES,
             CS.NUM_ANOS  = D_ANOS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;
    ELSE

/*      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.DAT_INICIO      = NVL(PAR_INICIO_ORIG,
                                      PAR_INICIO_PERIODO_ADQ),
             CS.DAT_FIM         = PAR_FIM_PERIODO_ADQ,
             CS.NUM_DIAS_LIQ    = DIAS_FERIAS_SERVIDOR,
             CS.NUM_DIAS_FALTAS = QTD_DIAS_FALTAS,
             CS.NUM_DIAS_BRUTO  = QTD_DIAS_TRABALHADO,
             CS.DES_OBS = (CASE
                            WHEN QTD_DIAS_TRABALHADO < 365 THEN
                             'Total de dias faltantes do per�odo aquisitivo de f�rias : ' ||
                             to_char(365 - QTD_DIAS_TRABALHADO)

                            ELSE
                             ' '
                          END)
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;*/

        UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS_BRUTO =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.NUM_DIAS_DESC =
             (SELECT /*SUM(nvl(LTS, 0)) +*/ SUM(nvl(LSV, 0)) + SUM(nvl(FJ, 0)) +
                     SUM(nvl(FI, 0)) + SUM(CSD.SUSP) +
                     SUM(nvl(CSD.OUTROS, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),

             CS.NUM_DIAS_LIQ =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO) -
                     (/*SUM(nvl(LTS, 0)) */+ SUM(nvl(LSV, 0)) + SUM(nvl(FJ, 0)) +
                      SUM(nvl(FI, 0)) + SUM(CSD.SUSP) +
                      SUM(nvl(CSD.OUTROS, 0)))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.DAT_INICIO  =
             (SELECT NVL(PAR_INICIO_PERIODO_LP,MIN(EF.DAT_INI_EFEITO))
                FROM TB_RELACAO_FUNCIONAL  RF,
                     TB_EVOLUCAO_FUNCIONAL EF,
                     tb_dias_apoio         A
               WHERE RF.COD_INS = PAR_COD_INS
                 AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                    --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                    --da relacao funcional
                    --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                    --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                    --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                    ----------------------------------------------------------------
                 AND RF.COD_INS = EF.COD_INS
                 AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                 AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                 AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                 AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                 AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE))
                 ,
             CS.DAT_FIM = /*(

                                        SELECT MAX (EF.DAT_FIM_EFEITO)
                                           FROM TB_RELACAO_FUNCIONAL  RF,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              tb_dias_apoio         A
                                        WHERE
                                              RF.COD_INS                    = PAR_COD_INS
                                          AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                          AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                      ----------------------------------------------------------------
                                          AND RF.COD_INS                    = EF.COD_INS
                                          AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE

                                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                          AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)

                                 ),*/ CASE
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) >
                                             PAR_DAT_CONTAGEM THEN
                                         PAR_DAT_CONTAGEM

                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) <=
                                             PAR_DAT_CONTAGEM THEN
                                         (SELECT RF.DAT_FIM_EXERC
                                            FROM TB_RELACAO_FUNCIONAL RF
                                           WHERE RF.COD_INS = PAR_COD_INS
                                             AND RF.COD_IDE_CLI =
                                                 PAR_COD_IDE_CLI
                                             AND RF.COD_ENTIDADE =
                                                 PAR_COD_ENTIDADE
                                             AND RF.NUM_MATRICULA =
                                                 PAR_NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 PAR_COD_IDE_REL_FUNC)
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NULL THEN
                                         PAR_DAT_CONTAGEM
                                      END,

             CS.DAT_CONTAGEM         = PAR_DAT_CONTAGEM,
             CS.NUM_DIAS_FALTAS     =
             (SELECT SUM(nvl(FJ, 0)) + SUM(nvl(FI, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_LICENCAS   =
             (SELECT SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_PENALIDADES =
             (SELECT SUM(CSD.SUSP)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.NUM_DIAS_OUTROS =
             (SELECT SUM(CSD.OUTROS)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARGO =
             (SELECT SUM(CSD.TEMPO_LIQ_CARGO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARREIRA    =
             (SELECT SUM(CSD.TEMPO_LIQ_CARREIRA)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.TEMPO_LIQ_SERV_PUBLICO =
             (SELECT SUM(CSD.TEMPO_LIQ_SERV_PUBLICO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO)

       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      -------------------- Conta Anos , Mes e  Dias -------------------------

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_ANOS  = TRUNC(CS.NUM_DIAS_LIQ / 365),
             CS.NUM_MESES = TRUNC((CS.NUM_DIAS_LIQ -
                                  (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667),
             CS.NUM_DIAS =
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) -
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667) * 30.41667)
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      -----------Ajusta  Conta Anos , Mes e  Dias -------------------------
      D_DIAS  := 0;
      D_MESES := 0;
      D_ANOS  := 0;
      SELECT CS.NUM_DIAS, CS.NUM_MESES, CS.NUM_ANOS
        INTO D_DIAS, D_MESES, D_ANOS
        FROM TB_CONTAGEM_SERVIDOR CS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      IF D_DIAS >= 30 THEN
        D_DIAS  := D_DIAS - 30;
        D_MESES := D_MESES + 1;
      END IF;
      IF D_MESES >= 12 THEN
        D_MESES := D_MESES - 12;
        D_ANOS  := D_ANOS + 1;
      END IF;

      IF PAR_COD_IDE_CLI = 1012936 AND D_DIAS = 13 THEN
        D_DIAS := 15;
        END IF;

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS  = D_DIAS,
             CS.NUM_MESES = D_MESES,
             CS.NUM_ANOS  = D_ANOS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

    END IF;

  END ATUALIZA_HEAD_CONTAGEN;

  PROCEDURE ATUALIZA_HEAD_CONTAGEN_DETALHE(SEQ_CERTIDAO IN NUMBER) IS
  BEGIN
    OPEN CURTEMP_DETALHE;
    FETCH CURTEMP_DETALHE
      INTO I_ANO_DETALHE, I_GLS_DETALHE;

    WHILE CURTEMP_DETALHE %FOUND LOOP
      UPDATE tb_contagem_serv_ano CS
         SET CS.DES_OBS = I_GLS_DETALHE
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.ANO = I_ANO_DETALHE;

      FETCH CURTEMP_DETALHE
        INTO I_ANO_DETALHE, I_GLS_DETALHE;
    END LOOP;
    CLOSE CURTEMP_DETALHE;
  END ATUALIZA_HEAD_CONTAGEN_DETALHE;

  PROCEDURE INCLUE_DETALHE_CONTAGEM_EMDIAS(SEQ_CERTIDAO IN NUMBER) IS
  BEGIN
    IF (PAR_TIPO_CONTAGEM = 1 OR PAR_TIPO_CONTAGEM = 2 OR PAR_TIPO_CONTAGEM = 3 OR PAR_TIPO_CONTAGEM = 9 OR PAR_TIPO_CONTAGEM=10 OR PAR_TIPO_CONTAGEM=11 OR PAR_TIPO_CONTAGEM=12 OR PAR_TIPO_CONTAGEM=13) THEN
      OPEN CURTEMP_ATS_FALTAS_DETALHE;
      FETCH CURTEMP_ATS_FALTAS_DETALHE
        INTO d_cod_entidade,
             d_num_matricula,
             d_cod_ide_rel_func,
             d_cod_ide_cli,
             d_num_seq_lanc,
             d_cod_motivo,
             d_data_ini,
             d_dat_fim,
             d_desconta_contagem,
             d_cod_agrupa,
             d_des_motivo_audit,
             d_tipo_desconto,
             d_qtd_dias;
      WHILE CURTEMP_ATS_FALTAS_DETALHE %FOUND LOOP
        INSERT INTO TB_CONTAGEM_DESCONTOS
          (cod_ins,
           id_contagem,
           cod_entidade,
           num_matricula,
           cod_ide_rel_func,
           cod_ide_cli,
           num_seq_lanc,
           cod_motivo,
           data_ini,
           dat_fim,
           desconta_contagem,
           cod_agrupa,
           des_motivo,
           tipo_desconto,
           QTD_DIAS)
        VALUES
          (PAR_COD_INS,
           SEQ_CERTIDAO,
           d_cod_entidade,
           d_num_matricula,
           d_cod_ide_rel_func,
           d_cod_ide_cli,
           d_num_seq_lanc,
           d_cod_motivo,
           d_data_ini,
           d_dat_fim,
           d_desconta_contagem,
           d_cod_agrupa,
           d_des_motivo_audit,
           d_tipo_desconto,
           d_qtd_dias);

        FETCH CURTEMP_ATS_FALTAS_DETALHE
          INTO d_cod_entidade,
               d_num_matricula,
               d_cod_ide_rel_func,
               d_cod_ide_cli,
               d_num_seq_lanc,
               d_cod_motivo,
               d_data_ini,
               d_dat_fim,
               d_desconta_contagem,
               d_cod_agrupa,
               d_des_motivo_audit,
               d_tipo_desconto,
               d_qtd_dias;

      END LOOP;
      CLOSE CURTEMP_ATS_FALTAS_DETALHE;
    ELSE
      IF PAR_TIPO_CONTAGEM = 2 THEN
        ----  CURTEMP_LP_FALTAS_DETALHE
        OPEN CURTEMP_LP_FALTAS_DETALHE;
        FETCH CURTEMP_LP_FALTAS_DETALHE
          INTO d_cod_entidade,
               d_num_matricula,
               d_cod_ide_rel_func,
               d_cod_ide_cli,
               d_num_seq_lanc,
               d_cod_motivo,
               d_data_ini,
               d_dat_fim,
               d_desconta_contagem,
               d_cod_agrupa,
               d_des_motivo_audit,
               d_tipo_desconto,
               d_qtd_dias;
        WHILE CURTEMP_LP_FALTAS_DETALHE%FOUND LOOP
          INSERT INTO TB_CONTAGEM_DESCONTOS
            (cod_ins,
             id_contagem,
             cod_entidade,
             num_matricula,
             cod_ide_rel_func,
             cod_ide_cli,
             num_seq_lanc,
             cod_motivo,
             data_ini,
             dat_fim,
             desconta_contagem,
             cod_agrupa,
             des_motivo,
             tipo_desconto,
             QTD_DIAS)
          VALUES
            (PAR_COD_INS,
             SEQ_CERTIDAO,
             d_cod_entidade,
             d_num_matricula,
             d_cod_ide_rel_func,
             d_cod_ide_cli,
             d_num_seq_lanc,
             d_cod_motivo,
             d_data_ini,
             d_dat_fim,
             d_desconta_contagem,
             d_cod_agrupa,
             d_des_motivo_audit,
             d_tipo_desconto,
             d_qtd_dias);

          FETCH CURTEMP_LP_FALTAS_DETALHE
            INTO d_cod_entidade,
                 d_num_matricula,
                 d_cod_ide_rel_func,
                 d_cod_ide_cli,
                 d_num_seq_lanc,
                 d_cod_motivo,
                 d_data_ini,
                 d_dat_fim,
                 d_desconta_contagem,
                 d_cod_agrupa,
                 d_des_motivo_audit,
                 d_tipo_desconto,
                 d_qtd_dias;

        END LOOP;
        CLOSE CURTEMP_LP_FALTAS_DETALHE;
      ELSE
        IF PAR_TIPO_CONTAGEM = 3 THEN

          ----  CURTEMP_LP_FALTAS_DETALHE
          OPEN CURTEMP_APO_TOT_FALTAS_DETALHE;
          FETCH CURTEMP_APO_TOT_FALTAS_DETALHE
            INTO d_cod_entidade,
                 d_num_matricula,
                 d_cod_ide_rel_func,
                 d_cod_ide_cli,
                 d_num_seq_lanc,
                 d_cod_motivo,
                 d_data_ini,
                 d_dat_fim,
                 d_desconta_contagem,
                 d_cod_agrupa,
                 d_des_motivo_audit,
                 d_tipo_desconto,
                 d_qtd_dias;
          WHILE CURTEMP_APO_TOT_FALTAS_DETALHE%FOUND LOOP
            INSERT INTO TB_CONTAGEM_DESCONTOS
              (cod_ins,
               id_contagem,
               cod_entidade,
               num_matricula,
               cod_ide_rel_func,
               cod_ide_cli,
               num_seq_lanc,
               cod_motivo,
               data_ini,
               dat_fim,
               desconta_contagem,
               cod_agrupa,
               des_motivo,
               tipo_desconto,
               QTD_DIAS)
            VALUES
              (PAR_COD_INS,
               SEQ_CERTIDAO,
               d_cod_entidade,
               d_num_matricula,
               d_cod_ide_rel_func,
               d_cod_ide_cli,
               d_num_seq_lanc,
               d_cod_motivo,
               d_data_ini,
               d_dat_fim,
               d_desconta_contagem,
               d_cod_agrupa,
               d_des_motivo_audit,
               d_tipo_desconto,
               d_qtd_dias);

            FETCH CURTEMP_APO_TOT_FALTAS_DETALHE
              INTO d_cod_entidade,
                   d_num_matricula,
                   d_cod_ide_rel_func,
                   d_cod_ide_cli,
                   d_num_seq_lanc,
                   d_cod_motivo,
                   d_data_ini,
                   d_dat_fim,
                   d_desconta_contagem,
                   d_cod_agrupa,
                   d_des_motivo_audit,
                   d_tipo_desconto,
                   d_qtd_dias;

          END LOOP;
          CLOSE CURTEMP_APO_TOT_FALTAS_DETALHE;

        END IF;
      END IF;
    END IF;

    IF PAR_TIPO_CONTAGEM IN (1, 2, 9, 11) THEN
      OPEN CURTEMP_ATS_TEMPOS_DETALHE;
      FETCH CURTEMP_ATS_TEMPOS_DETALHE
        INTO d_dat_adm_orig,
             d_dat_desl_orig,
             d_nom_org_emp,
             d_num_cnpj_org_emp,
             d_cod_certidao_seq,
             d_cod_emissor,
             d_dat_ini_considerado,
             d_dat_fim_considerado,
             d_num_dias_considerados;

      WHILE CURTEMP_ATS_TEMPOS_DETALHE %FOUND LOOP
        INSERT INTO TB_CONTAGEM_VINC_AVERBADOS
          (cod_ins,
           id_contagem,
           dat_adm_orig,
           dat_desl_orig,
           nom_org_emp,
           num_cnpj_org_emp,
           cod_certidao_seq,
           cod_emissor,
           dat_ini_considerado,
           dat_fim_considerado,
           num_dias_considerados,
           dat_ing,
           dat_ult_atu,
           nom_usu_ult_atu,
           nom_pro_ult_atu)
        VALUES
          (PAR_COD_INS,
           SEQ_CERTIDAO,
           d_dat_adm_orig,
           d_dat_desl_orig,
           d_nom_org_emp,
           d_num_cnpj_org_emp,
           d_cod_certidao_seq,
           d_cod_emissor,
           d_dat_ini_considerado,
           d_dat_fim_considerado,
           d_num_dias_considerados,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'CONTAGEM');

        FETCH CURTEMP_ATS_TEMPOS_DETALHE
          INTO d_dat_adm_orig,
               d_dat_desl_orig,
               d_nom_org_emp,
               d_num_cnpj_org_emp,
               d_cod_certidao_seq,
               d_cod_emissor,
               d_dat_ini_considerado,
               d_dat_fim_considerado,
               d_num_dias_considerados;

      END LOOP;
      CLOSE CURTEMP_ATS_TEMPOS_DETALHE;
    ELSE
      IF PAR_TIPO_CONTAGEM IN (3) THEN

        OPEN CURTEMP_APO_TOT_TEMPOS_DETALHE;
        FETCH CURTEMP_APO_TOT_TEMPOS_DETALHE
          INTO d_dat_adm_orig,
               d_dat_desl_orig,
               d_nom_org_emp,
               d_num_cnpj_org_emp,
               d_cod_certidao_seq,
               d_cod_emissor,
               d_dat_ini_considerado,
               d_dat_fim_considerado,
               d_num_dias_considerados;
        WHILE CURTEMP_APO_TOT_TEMPOS_DETALHE %FOUND LOOP
          INSERT INTO TB_CONTAGEM_VINC_AVERBADOS
            (cod_ins,
             id_contagem,
             dat_adm_orig,
             dat_desl_orig,
             nom_org_emp,
             num_cnpj_org_emp,
             cod_certidao_seq,
             cod_emissor,
             dat_ini_considerado,
             dat_fim_considerado,
             num_dias_considerados,
             dat_ing,
             dat_ult_atu,
             nom_usu_ult_atu,
             nom_pro_ult_atu)
          VALUES
            (PAR_COD_INS,
             SEQ_CERTIDAO,
             d_dat_adm_orig,
             d_dat_desl_orig,
             d_nom_org_emp,
             d_num_cnpj_org_emp,
             d_cod_certidao_seq,
             d_cod_emissor,
             d_dat_ini_considerado,
             d_dat_fim_considerado,
             d_num_dias_considerados,
             SYSDATE,
             SYSDATE,
             'CONTAGEM',
             'CONTAGEM');

          FETCH CURTEMP_APO_TOT_TEMPOS_DETALHE
            INTO d_dat_adm_orig,
                 d_dat_desl_orig,
                 d_nom_org_emp,
                 d_num_cnpj_org_emp,
                 d_cod_certidao_seq,
                 d_cod_emissor,
                 d_dat_ini_considerado,
                 d_dat_fim_considerado,
                 d_num_dias_considerados;

        END LOOP;
        CLOSE CURTEMP_APO_TOT_TEMPOS_DETALHE;

      END IF;

    END IF;

  END;
  PROCEDURE OBTEN_DIAS_FERIAS(QTD_DIAS_FALTAS      IN NUMBER,
                              DIAS_FERIAS_SERVIDOR OUT NUMBER) IS
  BEGIN

    BEGIN

      FOR FERIAS IN (SELECT FE.MIN_FALTAS, FE.MAX_FALTAS, FE.DIAS_FERIAS
                       FROM tb_param_ferias_falta FE
                      WHERE FE.COD_INS = PAR_COD_INS
                      ORDER BY MIN_FALTAS ASC) LOOP
        IF FERIAS.MIN_FALTAS <= QTD_DIAS_FALTAS AND
           FERIAS.MAX_FALTAS >= QTD_DIAS_FALTAS THEN
          DIAS_FERIAS_SERVIDOR := FERIAS.DIAS_FERIAS;
        END IF;

      END LOOP;

    END;
  END;
  ----------------------------------------------
  PROCEDURE SP_GERA_CONTAGEN(W_COD_INS    IN NUMBER,
                             W_COD_GRUPO  IN VARCHAR,
                             W_DATA_CORTE IN DATE,
                             W_TIPO_REL   IN NUMBER,
                             W_EXECUTA    OUT VARCHAR,
                             W_MSG_SAIDA  OUT VARCHAR)

   IS

    oErrorCode     number := 0;
    oErrorMessage  varchar2(20) := null;
    O_SEQ_CERTIDAO varchar2(1000);

  BEGIN
    FOR REG IN (SELECT RF.COD_IDE_CLI,
                       RF.COD_IDE_REL_FUNC,
                       RF.NUM_MATRICULA,
                       RF.COD_ENTIDADE
                  FROM TB_RELACAO_FUNCIONAL RF
                 WHERE RF.COD_INS = W_COD_INS
                   AND RF.COD_PROC_GRP_PAG = W_COD_GRUPO
                   AND RF.DAT_FIM_EXERC IS NULL

                ) LOOP

      IF W_TIPO_REL = 1 THEN
        SP_CALC_ANOS_TRAB_ATIVO(

                                W_COD_INS, --I_COD_INS             IN  number ,
                                REG.COD_IDE_CLI, -- IN VARCHAR2,
                                REG.NUM_MATRICULA, --IN VARCHAR2,
                                REG.COD_IDE_REL_FUNC, --IN  number ,
                                REG.COD_ENTIDADE, --IN  number ,
                                W_TIPO_REL, --IN  NUMBER ,
                                W_DATA_CORTE, --IN  DATE   ,
                                O_SEQ_CERTIDAO, --OUT NUMBER ,
                                oErrorCode, --OUT  NUMBER ,
                                oErrorMessage --OUT  VARCHAR2
                                );
       END IF;

    END LOOP;

  END SP_GERA_CONTAGEN;

  PROCEDURE SP_CONTAGEM_PERIODO_AGRUP (I_SEQ_CERTIDAO IN NUMBER) AS
    PAR_ID_CONTAGEM      NUMBER;
    PAR_COD_ENTIDADE     NUMBER;
    PAR_NUM_MATRICULA    VARCHAR2(20);
    PAR_COD_IDE_REL_FUNC NUMBER;
    PAR_COD_IDE_CLI      VARCHAR2(20);
    DAT_CONTAGEM         DATE;
    PAR_COD_INS          NUMBER;
    PAR_TIPO_CONTAGEM     NUMBER;
    V_DATA_INICIO        DATE;
    V_DES_OBS            VARCHAR2(500);
    oErrorCode           number := 0;
    oErrorMessage        varchar2(20) := null;
    PAR_INICIO_PERIODO_LP   DATE := null;

  BEGIN

    DELETE FROM TB_CONTAGEM_SERV_PER_DET A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;
    DELETE FROM TB_CONTAGEM_SERV_PERIODO A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    begin

      SELECT CO.ID_CONTAGEM,
             CO.COD_ENTIDADE,
             CO.NUM_MATRICULA,
             CO.COD_IDE_REL_FUNC,
             CO.COD_IDE_CLI,
             CO.DAT_CONTAGEM,
             CO.COD_INS,
             CO.TIPO_CONTAGEM

        INTO PAR_ID_CONTAGEM,
             PAR_COD_ENTIDADE,
             PAR_NUM_MATRICULA,
             PAR_COD_IDE_REL_FUNC,
             PAR_COD_IDE_CLI,
             par_DAT_CONTAGEM,
             PAR_COD_INS,
             PAR_TIPO_CONTAGEM
        FROM TB_CONTAGEM_SERVIDOR CO
       WHERE CO.ID_CONTAGEM = I_SEQ_CERTIDAO;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        par_cod_ide_rel_func := null;
        par_cod_entidade     := null;
        par_cod_ide_cli      := null;
        par_num_matricula    := null;
        par_id_contagem      := null;
        par_dat_contagem     := NULL;
    END;

    begin

    IF (PAR_TIPO_CONTAGEM = 1 OR PAR_TIPO_CONTAGEM = 9 OR PAR_TIPO_CONTAGEM =11) THEN
      FOR PER_ATS IN (SELECT PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
                             DATA_INICIO,
                             DATA_FIM,
                             NOM_CARGO,

                             SUM(BRUTO) QTD_BRUTO,
                             SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) QTD_LIQUIDO
                        FROM (

                              -- Tabela de Contagem  Dias da Evoluca�ao Funcional
                              ---- Dias Bruto -----
                              SELECT 'BRUTO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      ---to_char(DATA_CALCULO, 'yyyy') Ano,
                                      count(DISTINCT DATA_CALCULO) BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                                        --YUMI EM 01/05/2018: INCLU�DO PARA PEGAR V�NCULOS ANTERIORES DA RELACAO FUNCIONAL
                                        union

                                        SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(EF.DAT_FIM_EFEITO,
                                                            RF.DAT_FIM_EXERC) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_IDE_REL_FUNC !=
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        ---AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      /*count(DISTINCT DATA_CALCULO)*/ QTDE_DIA AS  Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM,
                                                        T.QTD_TMP_LIQ_DIA_TOTAL AS QTDE_DIA
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )

                               /*group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM*/

                              UNION ALL

                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LTS' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,

                                      0 BRUTO,
                                      0 Inclusao,
                                      count(DISTINCT DATA_CALCULO) lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_ATS = 'S'
                                          AND MO.COD_AGRUP_AFAST = 2

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LSV' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      count(DISTINCT DATA_CALCULO) lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_ATS = 'S'
                                          AND MO.COD_AGRUP_AFAST = 1

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS - FJ' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      count(distinct data_calculo) FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_ATS = 'S'
                                          AND MO.COD_AGRUP_AFAST = 3

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         data_inicio,
                                         data_fim

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS -FI' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      count(DISTINCT DATA_CALCULO) FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C

                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_ATS = 'S'
                                          AND MO.COD_AGRUP_AFAST = 4

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas SUSPENSOS

                              SELECT 'SUSP' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      COUNT(DISTINCT DATA_CALCULO) SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_ATS = 'S'
                                          AND MO.COD_AGRUP_AFAST = 5

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM
                              -------------------------------------------

                              UNION ALL

                              ---- Tabela de Contagem Faltas OUTRO
                              SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_ATS = 'S'

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                          AND NOT EXISTS
                                        (SELECT 1
                                                 FROM TB_RELACAO_FUNCIONAL  RF,
                                                      Tb_afastamento        TT,
                                                      tb_dias_apoio         A,
                                                      tb_motivo_afastamento MO
                                                WHERE RF.COD_INS = PAR_COD_INS
                                                     --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                                  AND RF.COD_VINCULO not in
                                                      (/*'22',*/ '5', '6')
                                                     --AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                                                     --AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                                                     --AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------
                                                      RF.COD_INS = T.COD_INS
                                                  AND RF.COD_IDE_CLI =
                                                      T.COD_IDE_CLI
                                                  AND RF.NUM_MATRICULA =
                                                      T.NUM_MATRICULA
                                                  AND RF.COD_IDE_REL_FUNC =
                                                      T.COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------

                                                      TT.COD_INS = 1
                                                  AND TT.COD_IDE_CLI =
                                                      PAR_COD_IDE_CLI
                                                  AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                                  AND A.DATA_CALCULO <=
                                                      PAR_DAT_CONTAGEM
                                                  AND A.DATA_CALCULO >=
                                                      TT.dat_ini_afast
                                                  AND A.DATA_CALCULO <=
                                                      NVL(TT.DAT_RET_PREV,
                                                          PAR_DAT_CONTAGEM)
                                                  AND MO.COD_MOT_AFAST =
                                                      T.COD_MOT_AFAST
                                                  AND MO.AUMENTA_CONT_ATS = 'S'
                                                  AND NVL(MO.COD_AGRUP_AFAST, 0) IN
                                                      (1, 2, 3, 4, 5)
                                                  AND AA.DATA_CALCULO =
                                                      A.DATA_CALCULO

                                               )

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              union
                              ---Yumi em 01/05/2018: inclu�do para descontar os dias de descontos
                              ---relacionados ao hist�rico de tempos averbados
                              select 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      sum(nvl(qtd_dias_ausencia, 0)) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct t1.dat_adm_orig,
                                                        1                    AS COD_INS,
                                                        1                    AS TIPO_CONTAGEM,
                                                        1                    AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        t1.qtd_dias_ausencia,
                                                        T1.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T1.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T1.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T1,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22', */'5', '6')
                                        ------------------------------------------------------
                                      AND T1.COD_INS = RF.COD_INS
                                      AND T1.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T1.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T1.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO <=
                                         NVL(T1.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                                       AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T1.FLG_TMP_ATS = 'S')
                                        OR
                                           (PAR_TIPO_CONTAGEM IN (2)   AND T1.FLG_TMP_LIC_PREM = 'S')
                                           )

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO

                                          )

                                        )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              ------------------------------------------------------

                              UNION ALL
                              SELECT 'TODOS OS ANOS ZERADOS' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (

                                       SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                          AND RF.NUM_MATRICULA =
                                              PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ----------------------------------------------------------------
                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                          AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                          AND A.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM)
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              )
                       GROUP BY /*id_contagem,*/ COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO
                       order by DATA_INICIO)

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_ATS.ID_CONTAGEM,
           PER_ATS.NUM_MATRICULA,
           PER_ATS.COD_IDE_REL_FUNC,
           PER_ATS.COD_IDE_CLI,
           PER_ATS.DATA_INICIO,
           PER_ATS.DATA_FIM,
           PER_ATS.NOM_CARGO,
           PER_ATS.QTD_BRUTO,
           PER_ATS.QTD_INCLUSAO,
           PER_ATS.QTD_LTS,
           PER_ATS.QTD_LSV,
           PER_ATS.QTD_FJ,
           PER_ATS.QTD_FI,
           PER_ATS.QTD_SUSP,
           PER_ATS.QTD_OUTRO,
           PER_ATS.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_ATS');

      --  COMMIT;
      END LOOP;

      ELSIF PAR_TIPO_CONTAGEM = 2 THEN
            PAR_INICIO_PERIODO_LP := null;
            FOR DATA_CONT_LP IN
                             (
                             SELECT MAX(LA.DAT_FIM) + 1 AS DATA_INICIO
                             FROM TB_LICENCA_AQUISITIVO LA
                             WHERE LA.COD_INS           = PAR_COD_INS
                             AND LA.COD_IDE_CLI         = PAR_COD_IDE_CLI
                             AND LA.COD_ENTIDADE        = PAR_COD_ENTIDADE
                            -- AND LA.NUM_MATRICULA       = PAR_NUM_MATRICULA
                            -- AND LA.COD_IDE_REL_FUNC    = PAR_COD_IDE_REL_FUNC
                             )
              LOOP

              PAR_INICIO_PERIODO_LP := DATA_CONT_LP.DATA_INICIO;

              EXIT;

        END LOOP;

        FOR PER_LP IN (SELECT PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
                             CASE WHEN PAR_INICIO_PERIODO_LP IS NULL THEN DATA_INICIO ELSE
                             PAR_INICIO_PERIODO_LP END DATA_INICIO,
                             CASE WHEN PAR_INICIO_PERIODO_LP IS NULL THEN DATA_FIM ELSE
                             PAR_DAT_CONTAGEM END DATA_FIM,
                             (SELECT DISTINCT C.NOM_CARGO FROM TB_RELACAO_FUNCIONAL F INNER JOIN TB_CARGO C ON F.COD_CARGO = C.COD_CARGO WHERE AA.NUM_MATRICULA = F.NUM_MATRICULA
                             AND AA.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC)NOM_CARGO,

                             SUM(BRUTO) QTD_BRUTO,
                             SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) QTD_LIQUIDO
                        FROM (

                              -- Tabela de Contagem  Dias da Evoluca�ao Funcional
                              ---- Dias Bruto -----
                              SELECT 'BRUTO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      ---to_char(DATA_CALCULO, 'yyyy') Ano,
                                      count(DISTINCT DATA_CALCULO) BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        NVL(PAR_INICIO_PERIODO_LP, ef.dat_ini_efeito) AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS  DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_FIM_EFEITO >=
                                                          C.DAT_FIM_VIG
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                                        --YUMI EM 01/05/2018: INCLU�DO PARA PEGAR V�NCULOS ANTERIORES DA RELACAO FUNCIONAL
                                        union

                                        SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        NVL(PAR_INICIO_PERIODO_LP,ef.dat_ini_efeito) AS DATA_INICIO,
                                                        NVL(EF.DAT_FIM_EFEITO,
                                                            RF.DAT_FIM_EXERC) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_IDE_REL_FUNC !=
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        ---AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_FIM_EFEITO >=
                                                          C.DAT_FIM_VIG
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      null, /*count(DISTINCT DATA_CALCULO) + 1*/ --QTDE_DIA AS Inclusao, Roberto
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_INI_LIC_PREM      AS DATA_INICIO,
                                                        T.DAT_FIM_LIC_PREM     AS DATA_FIM
                                                    --    T.QTD_DIAS_LIC_PREMIO AS QTDE_DIA Roberto
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_TMP_LIC_PREM = 'S'
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO > = T.DAT_INI_LIC_PREM
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )

                               /*group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM*/

                              UNION ALL

                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LTS' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,

                                      0 BRUTO,
                                      0 Inclusao,
                                      count(DISTINCT DATA_CALCULO) lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 2

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LSV' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      count(DISTINCT DATA_CALCULO) lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 1

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS - FJ' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      count(distinct data_calculo) FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 3

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         data_inicio,
                                         data_fim

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS -FI' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      count(DISTINCT DATA_CALCULO) FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C

                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 4

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas SUSPENSOS

                              SELECT 'SUSP' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      COUNT(DISTINCT DATA_CALCULO) SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 5

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM
                              -------------------------------------------

                              UNION ALL

                              ---- Tabela de Contagem Faltas OUTRO
                              SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                          AND NOT EXISTS
                                        (SELECT 1
                                                 FROM TB_RELACAO_FUNCIONAL  RF,
                                                      Tb_afastamento        TT,
                                                      tb_dias_apoio         A,
                                                      tb_motivo_afastamento MO
                                                WHERE RF.COD_INS = PAR_COD_INS
                                                     --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                                  AND RF.COD_VINCULO not in
                                                      (/*'22',*/ '5', '6')
                                                     --AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                                                     --AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                                                     --AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------
                                                      RF.COD_INS = T.COD_INS
                                                  AND RF.COD_IDE_CLI =
                                                      T.COD_IDE_CLI
                                                  AND RF.NUM_MATRICULA =
                                                      T.NUM_MATRICULA
                                                  AND RF.COD_IDE_REL_FUNC =
                                                      T.COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------

                                                      TT.COD_INS = 1
                                                  AND TT.COD_IDE_CLI =
                                                      PAR_COD_IDE_CLI
                                                  AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                                  AND A.DATA_CALCULO <=
                                                      PAR_DAT_CONTAGEM
                                                  AND A.DATA_CALCULO >=
                                                      TT.dat_ini_afast
                                                  AND A.DATA_CALCULO <=
                                                      NVL(TT.DAT_RET_PREV,
                                                          PAR_DAT_CONTAGEM)
                                                  AND MO.COD_MOT_AFAST =
                                                      T.COD_MOT_AFAST
                                                  AND MO.AUMENTA_CONT_LICENCA = 'S'
                                                  AND NVL(MO.COD_AGRUP_AFAST, 0) IN
                                                      (1, 2, 3, 4, 5)
                                                  AND AA.DATA_CALCULO =
                                                      A.DATA_CALCULO

                                               )

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              union
                              ---Yumi em 01/05/2018: inclu�do para descontar os dias de descontos
                              ---relacionados ao hist�rico de tempos averbados
                              select 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      sum(nvl(qtd_dias_ausencia, 0)) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct t1.dat_adm_orig,
                                                        1                    AS COD_INS,
                                                        1                    AS TIPO_CONTAGEM,
                                                        1                    AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        t1.qtd_dias_ausencia,
                                                        T1.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T1.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T1.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T1,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                        ------------------------------------------------------
                                      AND T1.COD_INS = RF.COD_INS
                                      AND T1.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T1.FLG_EMP_PUBLICA = 'S'
                                      AND T1.FLG_TMP_LIC_PREM = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T1.DAT_INI_LIC_PREM
                                      AND AA.DATA_CALCULO <=
                                         NVL(T1.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM)
                                      AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T1.FLG_TMP_ATS = 'S')
                                       OR
                                          (PAR_TIPO_CONTAGEM IN (2)   AND T1.FLG_TMP_LIC_PREM = 'S')
                                          )

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO

                                          )

                                        )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              ------------------------------------------------------

                              UNION ALL
                              SELECT 'TODOS OS ANOS ZERADOS ---' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (

                                       SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                          AND RF.NUM_MATRICULA =
                                              PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ----------------------------------------------------------------
                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                          AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                          AND A.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND T.FLG_TMP_LIC_PREM = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_INI_LIC_PREM
                                      AND AA.DATA_CALCULO <= NVL(T.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM))
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              ) aa
                       GROUP BY /*id_contagem,*/ COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO
                       order by DATA_INICIO)

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_LP.ID_CONTAGEM,
           PER_LP.NUM_MATRICULA,
           PER_LP.COD_IDE_REL_FUNC,
           PER_LP.COD_IDE_CLI,
           PER_LP.DATA_INICIO,
           PER_LP.DATA_FIM,
           PER_LP.NOM_CARGO,
           PER_LP.QTD_BRUTO,
           PER_LP.QTD_INCLUSAO,
           PER_LP.QTD_LTS,
           PER_LP.QTD_LSV,
           PER_LP.QTD_FJ,
           PER_LP.QTD_FI,
           PER_LP.QTD_SUSP,
           PER_LP.QTD_OUTRO,
           PER_LP.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_LP');

      --  COMMIT;
      END LOOP;



    END IF;
      FOR PERIODOS IN

       (select  aa.*,
               nvl((select sum(f.bruto)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_bruto,

               nvl((select sum(f.inclusao)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_inclusao,

               nvl((select sum(f.lts)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_lts,

               nvl((select sum(f.lsv)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_lsv,

               nvl((select sum(f.fj)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_fj,

               nvl((select sum(f.fi)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_fi,

               nvl((select sum(f.susp)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_susp,

               nvl((select sum(f.outros)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_outro,

               nvl((select sum(f.tempo_Liquido)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_liquido

          from (select a.id_contagem,
                       a.cod_ide_rel_func,
                       a.des_cargo as nom_cargo,
                       nvl((select min(e.dat_inicio)
                             from TB_CONTAGEM_SERV_PER_DET e
                            where e.cod_ide_rel_func = a.cod_ide_rel_func
                              and nvl(e.des_cargo, 'sem') =
                                  nvl(a.des_cargo, 'sem')
                              and e.id_contagem = a.id_contagem
                              and e.dat_fim <= a.dat_fim
                              and e.dat_fim >
                                  (select max(f.dat_fim)
                                     from (select h.cod_ide_reL_func,
                                                  h.des_cargo,
                                                  h.dat_inicio,
                                                  h.dat_fim,
                                                  nvl((select min(hh.dat_inicio)
                                                        from TB_CONTAGEM_SERV_PER_DET hh
                                                       where hh.dat_inicio >
                                                             h.dat_inicio
                                                         and hh.cod_ide_rel_func =
                                                             h.cod_ide_rel_func
                                                         and nvl(hh.des_cargo,
                                                                 'sem') =
                                                             nvl(h.des_cargo,
                                                                 'sem')
                                                         and hh.id_contagem =
                                                             h.id_contagem),
                                                      to_date('01/01/2999',
                                                              'dd/mm/yyyy')) data_ini_aux

                                             from TB_CONTAGEM_SERV_PER_DET h
                                            where h.cod_ide_rel_func =
                                                  e.cod_ide_rel_func
                                              and h.id_contagem = e.id_contagem
                                              and nvl(h.des_cargo, 'sem') =
                                                  nvl(e.des_cargo, 'sem')
                                            order by h.dat_inicio) f
                                    where f.dat_fim + 1 != f.data_ini_aux
                                      and f.dat_fim < a.dat_fim
                                      and f.cod_ide_rel_func =
                                          e.cod_ide_rel_func
                                      and nvl(f.des_cargo, 'sem') =
                                          nvl(e.des_cargo, 'sem'))),

                           (select min(dat_inicio)
                              from TB_CONTAGEM_SERV_PER_DET d
                             where a.cod_ide_rel_func = d.cod_ide_rel_func
                               and a.id_contagem = d.id_contagem
                               and nvl(a.des_cargo, 'sem') =
                                   nvl(d.des_cargo, 'sem'))) as data_inicio,
                       a.dat_fim as data_fim
                  from (select id_contagem,
                               t.cod_ide_rel_func,
                               t.des_cargo,
                               t.dat_inicio,
                               t.dat_fim,
                               sum(t.bruto) as qtd_bruto,
                               sum(t.inclusao) as qtd_inclusao,
                               sum(t.lts) as qtd_lts,
                               sum(t.lsv) as qtd_lsv,
                               sum(t.fj) as qtd_fj,
                               sum(t.fi) as qtd_fi,
                               sum(t.susp) as qtd_susp,
                               sum(t.outros) as qtd_outro,
                               sum(t.tempo_liquido) as qtd_liquido,
                               nvl((select min(tt.dat_inicio)
                                     from TB_CONTAGEM_SERV_PER_DET tt
                                    where tt.dat_inicio > t.dat_inicio
                                      and tt.cod_ide_rel_func =
                                          t.cod_ide_rel_func
                                      and nvl(tt.des_cargo, 'sem') =
                                          nvl(t.des_cargo, 'sem')),
                                   to_date('01/01/2999', 'dd/mm/yyyy')

                                   ) data_ini_aux
                          from TB_CONTAGEM_SERV_PER_DET t
                         where t.id_contagem = PAR_ID_CONTAGEM
                         group by t.id_contagem,
                                  t.cod_ide_rel_func,
                                  t.des_cargo,
                                  t.dat_inicio,
                                  t.dat_fim
                         order by t.dat_inicio) a
                 where a.dat_fim + 1 != a.data_ini_aux) aa

         GROUP BY aa.id_contagem,
                  aa.cod_ide_rel_func,
                  aa.nom_cargo,
                  aa.data_inicio,
                  aa.data_fim

        )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PERIODO
          (COD_INS,
           ID_CONTAGEM,
           DAT_INICIO,
           DAT_FIM,
           COD_ENTIDADE,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DES_OBS,
           DES_CARGO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)
        VALUES
          (1,
           PAR_ID_CONTAGEM,
           PERIODOS.DATA_INICIO,
           PERIODOS.DATA_FIM,
           PAR_COD_ENTIDADE,
           PAR_NUM_MATRICULA,
           PAR_COD_IDE_REL_FUNC,
           PAR_COD_IDE_CLI,
           PERIODOS.QTD_BRUTO,
           PERIODOS.QTD_INCLUSAO,
           PERIODOS.QTD_LTS,
           PERIODOS.QTD_LSV,
           PERIODOS.QTD_FJ,
           PERIODOS.QTD_FI,
           PERIODOS.QTD_SUSP,
           PERIODOS.QTD_OUTRO,
           PERIODOS.QTD_LIQUIDO,
           NULL,
           NVL(PERIODOS.NOM_CARGO, 'NAO INFORMADO'),
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_CONTAGEM_PERIODO'

           );

      --  COMMIT;
      END LOOP;

      FOR OBS IN (SELECT DAT_INICIO AS DATA_INICIO,
                         LISTAGG(GLS_DETALHE, chr(10)) WITHIN GROUP(ORDER BY ordem) DES_OBS

                    FROM (SELECT distinct CSO.DAT_INICIO,
                                           CASE
                                             WHEN CSO.DAT_INICIO =
                                                  T.DAT_ADM_ORIG THEN
--                                              'Cargo: ' || UPPER(cso.des_cargo) ||
                                              --chr(10) ||
                                              'Certidao n� ' ||
                                              T.NUM_CERTIDAO || /*', emissor ' ||
                                                                         (SELECT CO.DES_DESCRICAO
                                                                            FROM TB_CODIGO CO
                                                                           WHERE CO.COD_INS = 0
                                                                             AND CO.COD_NUM = 2378
                                                                             AND CO.COD_PAR = T.COD_EMISSOR) ||*/
                                              ', �rgao: ' || T.NOM_ORG_EMP /*||
                                                                         ', in�cio em ' ||
                                                                         TO_CHAR(T.DAT_ADM_ORIG, 'DD/MM/RRRR')*/
                                             /*WHEN CSO.DAT_FIM = T.DAT_DESL_ORIG THEN
                                             'Cargo:'||cso.des_cargo|| chr(10)||
                                             'Certidao n� ' || T.NUM_CERTIDAO || ', emissor ' ||
                                             (SELECT CO.DES_DESCRICAO
                                                FROM TB_CODIGO CO
                                               WHERE CO.COD_INS = 0
                                                 AND CO.COD_NUM = 2378
                                                 AND CO.COD_PAR = T.COD_EMISSOR) ||
                                             ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                                             ', fim em ' ||
                                             TO_CHAR(T.DAT_DESL_ORIG, 'DD/MM/RRRR')*/
                                              || '.'

                                           END GLS_DETALHE,
                                           1 AS ORDEM

                             FROM TB_RELACAO_FUNCIONAL     RF,
                                  Tb_Hist_Carteira_Trab    T,
                                  tb_contagem_serv_periodo CSO,
                                  TB_CONTAGEM_SERVIDOR     CON
                            WHERE RF.COD_INS = CON.COD_INS
                              AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                              AND RF.COD_ENTIDADE = CON.COD_ENTIDADE
                              AND RF.NUM_MATRICULA = CON.NUM_MATRICULA
                              AND RF.COD_IDE_REL_FUNC = CON.COD_IDE_REL_FUNC
                              AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                              AND CON.ID_CONTAGEM = CSO.ID_CONTAGEM

                                 ------------------------------------------------------
                              AND T.COD_INS = RF.COD_INS
                              AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                              AND T.FLG_EMP_PUBLICA = 'S'

                              AND (CSO.DAT_INICIO = T.DAT_ADM_ORIG OR
                                  CSO.DAT_FIM = NVL(T.DAT_DESL_ORIG, SYSDATE))
                              AND NOT EXISTS
                            (

                                   SELECT 1
                                     FROM TB_RELACAO_FUNCIONAL  RF1,
                                           TB_EVOLUCAO_FUNCIONAL EF1,
                                           tb_dias_apoio         A
                                    WHERE RF1.COD_INS = 1
                                      AND RF1.COD_IDE_CLI = RF.COD_IDE_CLI
                                         --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                         ---com qualquer v�nculo que exista na relacao funcional
                                         ---AND RF.COD_ENTIDADE               = &PAR_COD_ENTIDADE
                                         --AND RF.NUM_MATRICULA              = &PAR_NUM_MATRICULA
                                         ---AND RF.COD_IDE_REL_FUNC           = &PAR_COD_IDE_REL_FUNC
                                      AND RF1.COD_INS = EF1.COD_INS
                                      AND RF1.NUM_MATRICULA = EF1.NUM_MATRICULA
                                      AND RF1.COD_IDE_REL_FUNC =
                                          EF1.COD_IDE_REL_FUNC
                                      AND RF1.COD_IDE_CLI = EF1.COD_IDE_CLI
                                      AND RF1.COD_ENTIDADE = EF1.COD_ENTIDADE
                                         --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF1.COD_VINCULO not in
                                          (/*'22',*/ '5', '6')
                                      AND EF1.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= CON.DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF1.DAT_INI_EFEITO
                                         ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                         --entre per�odos de v�nculos
                                         --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                      AND A.DATA_CALCULO <=
                                          NVL(RF1.DAT_FIM_EXERC,
                                              CON.DAT_CONTAGEM)
                                      AND CSO.DAT_INICIO = A.DATA_CALCULO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                   )

                           UNION ALL
                           --------------------------------------------------
                           -- Detalhe de Rela�ao Funcional
                           --------------------------------------------------
                           SELECT CSO.DAT_INICIO,

                              --    'Cargo: ' || CSO.DES_CARGO || CHR(10) ||
                                  LISTAGG((

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2140
                                               AND CO.COD_PAR =
                                                   EF.COD_MOT_EVOL_FUNC) || ' ' ||
                                           'para ' ||
                                           (SELECT CAR.NOM_CARGO
                                              FROM TB_CARGO CAR
                                             WHERE CAR.COD_INS = 1
                                               AND CAR.COD_ENTIDADE =
                                                   EF.COD_ENTIDADE
                                               AND CAR.COD_PCCS = EF.COD_PCCS
                                               AND CAR.COD_CARREIRA =
                                                   EF.COD_CARREIRA
                                               AND CAR.COD_CARGO = EF.COD_CARGO) || ' ' ||
                                           'a partir de ' ||
                                           to_char(EF.DAT_INI_EFEITO,
                                                   'dd/mm/yyyy') || '. ' ||
                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   EF.COD_TIPO_DOC_ASSOC) ||
                                           ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                           'Publica��o em ' || ef.dat_pub || '.'

                                          ),
                                          chr(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO) AS GLS_DETALHE,
                                  1 as ordem

                             FROM TB_RELACAO_FUNCIONAL     RF,
                                  TB_EVOLUCAO_FUNCIONAL    EF,
                                  tb_contagem_serv_periodo CSO,
                                  TB_CONTAGEM_SERVIDOR     CON
                            WHERE
                           --------------------------------------------------------
                            RF.COD_INS = CON.COD_INS
                         AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                           --da relacao funcional
                           --AND RF.COD_ENTIDADE     = &PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA    = &PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = &PAR_COD_IDE_REL_FUNC
                           -----------------------------------------------------------

                         AND RF.COD_INS = EF.COD_INS
                         AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                         AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                         AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                         AND EF.FLG_STATUS = 'V'
                         /*AND ((CSO.DAT_INICIO = EF.DAT_INI_EFEITO) OR
                            (CSO.DAT_INICIO < EF.DAT_INI_EFEITO AND
                            NVL(EF.DAT_FIM_EFEITO, CON.DAT_FIM) <=
                            CSO.DAT_FIM AND
                            EF.COD_CARGO IN*/
                         AND (CSO.DAT_INICIO <= EF.DAT_FIM_EFEITO OR EF.DAT_FIM_EFEITO IS NULL)
                         AND ((CSO.DAT_INICIO >= EF.DAT_INI_EFEITO) OR
                            (CSO.DAT_INICIO < EF.DAT_INI_EFEITO AND
                            NVL(EF.DAT_FIM_EFEITO, CON.DAT_FIM) <=
                            CSO.DAT_FIM AND
                            EF.COD_CARGO IN
                            (SELECT TC.COD_CARGO_TRANSF
                                 FROM TB_TRANSF_CARGO TC INNER JOIN TB_CARGO CAR ON TC.COD_CARGO_TRANSF = CAR.COD_CARGO
                                WHERE TC.COD_INS = EF.COD_INS
                                  AND TC.COD_ENTIDADE = EF.COD_ENTIDADE
                                  AND TC.COD_PCCS = EF.COD_PCCS
                                  AND EF.DAT_INI_EFEITO >= CAR.DAT_INI_VIG) AND
                            EF.DAT_INI_EFEITO =
                            (SELECT MIN(EF1.DAT_INI_EFEITO)
                                 FROM TB_EVOLUCAO_FUNCIONAL EF1
                                WHERE EF1.COD_INS = 1
                                  AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                                  AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                                  AND EF1.COD_IDE_REL_FUNC =
                                      EF.COD_IDE_REL_FUNC
                                  AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                                  AND EF1.COD_CARGO = EF.COD_CARGO
                                  AND EF1.FLG_STATUS = EF.FLG_STATUS)))
                         AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                         AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
                            GROUP BY CSO.DAT_INICIO, CSO.DES_CARGO
                           --------------------------------------------------
                           -- Detalhe de Cargo Comissionado
                           --------------------------------------------------

                           UNION ALL
                           SELECT distinct CSO.DAT_INICIO,
                                           LISTAGG(((SELECT CO.DES_DESCRICAO
                                                       FROM TB_CODIGO CO
                                                      WHERE CO.COD_INS = 0
                                                        AND CO.COD_NUM = 2401
                                                        AND CO.COD_PAR =
                                                            EF.COD_MOT_EVOL_FUNC) || ' ' ||
                                                   'para ' ||
                                                   (SELECT CAR.NOM_CARGO
                                                       FROM TB_CARGO CAR
                                                      WHERE CAR.COD_INS = 1
                                                        AND CAR.COD_ENTIDADE =
                                                            EF.COD_ENTIDADE
                                                        AND CAR.COD_PCCS =
                                                            EF.COD_PCCS
                                                        AND CAR.COD_CARREIRA =
                                                            EF.COD_CARREIRA
                                                        AND CAR.COD_QUADRO =
                                                            EF.COD_QUADRO
                                                        AND CAR.COD_CLASSE =
                                                            EF.COD_CLASSE
                                                        AND CAR.COD_CARGO =
                                                            EF.COD_CARGO_COMP) ||
                                                   ' a partir de ' ||
                                                   to_char(EF.DAT_INI_EFEITO,
                                                            'dd/mm/yyyy') ||
                                                   ' at� ' ||
                                                   NVL(to_char(EF.DAT_FIM_EFEITO,
                                                                'dd/mm/yyyy'),
                                                        'a presente data') || '. ' ||
                                                   (SELECT CO.DES_DESCRICAO
                                                       FROM TB_CODIGO CO
                                                      WHERE CO.COD_INS = 0
                                                        AND CO.COD_NUM = 2019
                                                        AND CO.COD_PAR =
                                                            EF.COD_TIPO_DOC_ASSOC) ||
                                                   ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                                   'Publica��o em ' ||
                                                   ef.dat_pub || '.'),
                                                   CHR(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO)

                                           GLS_DETALHE,
                                           2 as ordem

                             FROM TB_RELACAO_FUNCIONAL      RF,
                                  TB_EVOLU_CCOMI_GFUNCIONAL EF,
                                  TB_CONTAGEM_SERV_PERIODO  CSO,
                                  TB_CONTAGEM_SERVIDOR      CON
                            WHERE
                           --------------------------------------------------------
                            RF.COD_INS = CON.COD_INS
                         AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                           --da relacao funcional
                           --AND RF.COD_ENTIDADE     = &PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA    =  &PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = &PAR_COD_IDE_REL_FUNC
                           -----------------------------------------------------------

                         AND RF.COD_INS = EF.COD_INS
                         AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                         AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                         AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                         AND (EF.DAT_INI_EFEITO BETWEEN CSO.DAT_INICIO AND
                            CSO.DAT_FIM
                         or CSO.DAT_INICIO BETWEEN EF.DAT_INI_EFEITO AND
                          NVL(EF.DAT_FIM_EFEITO, CSO.DAT_INICIO))
                         AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                         AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
                            GROUP BY CSO.DAT_INICIO

                           ) YY

                   WHERE GLS_DETALHE IS NOT NULL
                   GROUP BY DAT_INICIO)

       LOOP
        UPDATE TB_CONTAGEM_SERV_PERIODO CON
           SET CON.DES_OBS = OBS.DES_OBS
         WHERE CON.ID_CONTAGEM = PAR_ID_CONTAGEM
           AND CON.DAT_INICIO = OBS.DATA_INICIO;
       -- COMMIT;
      END LOOP;

    END;
  END;

/*  procedure SP_CONTAGEM_PERIODO_AQUIS_LP(I_SEQ_CERTIDAO IN NUMBER)
  as
  v_dat_ini       date;
  v_dat_fim       date;
  v_dat_ini_itera date;
  v_dat_ant       date;
  v_dat_ini_lp    date;

  v_qtd_dias      number := 0;
  v_qtd_dias_fora number := 0;

  v_qtd_bruto     number := 0;
  v_qtd_cargo     number := 0;
  v_qtd_lts       number := 0;
  v_qtd_outros    number := 0;
  v_cod_ide_cli  tb_contagem_Servidor.Cod_Ide_Cli%type;
  v_cod_entidade tb_contagem_Servidor.Cod_Entidade%type;
  v_num_matricula tb_contagem_Servidor.Num_Matricula%type;
  v_cod_ide_rel_func tb_contagem_Servidor.cod_ide_rel_func%type;

  begin
    -- Pega data inicial e final da contagem
    select distinct
           s.cod_ide_cli,
           s.cod_entidade,
           s.num_matricula,
           s.cod_ide_rel_func,
           s.dat_inicio,
           s.dat_fim
      into v_cod_ide_cli,
           v_cod_entidade,
           v_num_matricula,
           v_cod_ide_rel_func,
           v_dat_ini,
           v_dat_fim
      from tb_contagem_Servidor s
      where s.cod_ins = 1
        and s.id_contagem = I_SEQ_CERTIDAO
        and s.tipo_contagem = 2;

    -- Pegando valor de historico trabalhado
    select count(1)
      into v_qtd_bruto
      from table(v_col_dias_lp) a
     where TIPO_CONTAGEM = 'HIST';

    select count(1)
      into v_qtd_lts
      from table(v_col_dias_lp) a
     where TIPO_CONTAGEM = 'AFAST';


     select count(1)
      into v_qtd_outros
      from table(v_col_dias_lp) a
     where TIPO_CONTAGEM = 'OUTROS';

    -- Valor de bruto inicia com o que sobra de per�odos de  1825 dias.
    --v_qtd_bruto := mod(v_qtd_bruto,1825);

    v_dat_ini_itera := v_dat_ini ;
    v_dat_ant       := v_dat_ini-1;

    -- Itera cole��o com dias de lp, para pegar o ponto de gera��o de aquisitivo
    for r in (select DATA_CALCULO,
                     COD_CARGO,
                     max(TIPO_CONTAGEM) as TIPO_CONTAGEM  -- TIpos AFAST / BRUTO / HIST. Se tiver AFAST ignora
                from table(v_col_dias_lp) a
               where DATA_CALCULO >= v_dat_ini
               group by DATA_CALCULO, COD_CARGO
               order by DATA_CALCULO )
    loop
      if r.TIPO_CONTAGEM = 'BRUTO' THEN
        if v_dat_ant <> r.DATA_CALCULO then
          v_qtd_bruto := v_qtd_bruto +1;
          v_dat_ant := r.DATA_CALCULO;
        end if;
        --
        if r.cod_cargo member of v_col_cargos_equiv  then
          v_qtd_cargo := v_qtd_cargo +1;
        end if;

        --
        --05062024 EFANTIN adicionar tempos entre intervalos dos periodos do servidor

         SELECT SUM(((SUB.DAT_FIM_ANTERIOR - T1.DAT_INICIO) + 1) * -1) DIFERENCA
           into v_qtd_dias
           FROM (SELECT T.ID_CONTAGEM,

                        DAT_FIM,
                        LAG(DAT_FIM, 1) OVER(ORDER BY DAT_INICIO) AS DAT_FIM_ANTERIOR
                   FROM TB_CONTAGEM_SERV_PER_DET T
                  WHERE T.ID_CONTAGEM = 13121
                    AND T.BRUTO > 0) SUB
          INNER JOIN TB_CONTAGEM_SERV_PER_DET T1
             ON T1.ID_CONTAGEM = SUB.ID_CONTAGEM
            AND T1.DAT_FIM = SUB.DAT_FIM
            AND t1.COD_IDE_CLI         = PAR_COD_IDE_CLI;


        -- 05062024 FIM

        SELECT SUM(((SUB.DAT_FIM - T1.DAT_INICIO) + 1) * -1) DIFERENCA
           into v_qtd_dias_fora
           FROM (SELECT DAT_INICIO, DAT_FIM,ID_CONTAGEM
                   FROM TB_CONTAGEM_SERV_PER_DET T
                  WHERE T.ID_CONTAGEM = I_SEQ_CERTIDAO
                    AND T.INCLUSAO > 0) SUB
          INNER JOIN TB_CONTAGEM_SERV_PER_DET T1
             ON T1.ID_CONTAGEM = SUB.ID_CONTAGEM
            AND T1.DAT_FIM     = SUB.DAT_FIM;

            SELECT MAX(LA.DAT_FIM) + 1 AS DATA_INICIO
           into v_dat_ini_lp
           FROM TB_LICENCA_AQUISITIVO LA
          WHERE LA.COD_INS           = PAR_COD_INS
            AND LA.COD_IDE_CLI         = PAR_COD_IDE_CLI
            AND LA.COD_ENTIDADE        = PAR_COD_ENTIDADE;

        if   v_dat_ini_lp is not null then
             v_dat_ini_itera:= v_dat_ini_lp;
        end if;

        --
\*        if v_qtd_bruto >= 1825 then
          --
          if v_qtd_cargo >= 730  then
             insert into TB_CONTAGEM_LICENCA_AQUISITIVO
              (ID,
               ID_CONTAGEM,
               COD_INS,
               COD_IDE_CLI,
               COD_ENTIDADE,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               DAT_INICIO,
               DAT_FIM,
               NUM_DIAS_DIREITO,
               DAT_ING,
               DAT_ULT_ATU,
               NOM_USU_ULT_ATU,
               NOM_PRO_ULT_ATU,
               FLG_AVERBADO )
               values
               (SEQ_CONTAGEM_LIC_AQUISITIVO.nextval, --ID,
                I_SEQ_CERTIDAO,     --ID_CONTAGEM,
                1,                  --COD_INS,
                v_cod_ide_cli,      --COD_IDE_CLI,
                v_cod_entidade,     --COD_ENTIDADE,
                v_num_matricula,    --NUM_MATRICULA,
                v_cod_ide_rel_func, --COD_IDE_REL_FUNC,
                v_dat_ini_itera,    --DAT_INICIO,
                v_dat_ini_itera + 1825 + v_qtd_lts,     --DAT_FIM,
                90,                 --NUM_DIAS_DIREITO,
                sysdate,            --DAT_ING,
                sysdate,            --DAT_ULT_ATU,
                user,               --NOM_USU_ULT_ATU,
                'PAC_CALCULA_TEMPO_ATIVO_CMC',--NOM_PRO_ULT_ATU,
                null);                --FLG_AVERBADO
          end if;
          --v_qtd_bruto := 0;
          v_dat_ini_itera :=  r.DATA_CALCULO +1;
        end if;*\
      end if;
    end loop;

            if v_qtd_bruto >= 1825 then
          --
          if v_qtd_cargo >= 730  then
             insert into TB_CONTAGEM_LICENCA_AQUISITIVO
              (ID,
               ID_CONTAGEM,
               COD_INS,
               COD_IDE_CLI,
               COD_ENTIDADE,
               NUM_MATRICULA,
               COD_IDE_REL_FUNC,
               DAT_INICIO,
               DAT_FIM,
               NUM_DIAS_DIREITO,
               DAT_ING,
               DAT_ULT_ATU,
               NOM_USU_ULT_ATU,
               NOM_PRO_ULT_ATU,
               FLG_AVERBADO )
               values
               (SEQ_CONTAGEM_LIC_AQUISITIVO.nextval, --ID,
                I_SEQ_CERTIDAO,     --ID_CONTAGEM,
                1,                  --COD_INS,
                v_cod_ide_cli,      --COD_IDE_CLI,
                v_cod_entidade,     --COD_ENTIDADE,
                v_num_matricula,    --NUM_MATRICULA,
                v_cod_ide_rel_func, --COD_IDE_REL_FUNC,
                v_dat_ini_itera,    --DAT_INICIO,
                v_dat_ini_itera + 1825 + v_qtd_lts + v_qtd_outros-1 + NVL(v_qtd_dias,0) + NVL(v_qtd_dias_fora,0),     --DAT_FIM,
                90,                 --NUM_DIAS_DIREITO,
                sysdate,            --DAT_ING,
                sysdate,            --DAT_ULT_ATU,
                user,               --NOM_USU_ULT_ATU,
                'PAC_CALCULA_TEMPO_ATIVO_CMC',--NOM_PRO_ULT_ATU,
                null);                --FLG_AVERBADO
          end if;
        end if;


    v_col_dias_lp.delete;
  end SP_CONTAGEM_PERIODO_AQUIS_LP;*/


PROCEDURE SP_CONTAGEM_DECL_INSS(I_SEQ_CERTIDAO IN NUMBER) AS
    PAR_ID_CONTAGEM      NUMBER;
    PAR_COD_ENTIDADE     NUMBER;
    PAR_NUM_MATRICULA    VARCHAR2(20);
    PAR_COD_IDE_REL_FUNC NUMBER;
    PAR_COD_IDE_CLI      VARCHAR2(20);
    DAT_CONTAGEM         DATE;
    PAR_COD_INS          NUMBER;
    PAR_TIPO_CONTAGEM     NUMBER;
    V_DATA_INICIO        DATE;
    V_DES_OBS            VARCHAR2(500);
    oErrorCode           number := 0;
    oErrorMessage        varchar2(20) := null;


  BEGIN

    DELETE FROM TB_CONTAGEM_SERV_PER_DET A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;
    DELETE FROM TB_CONTAGEM_SERV_PERIODO A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    begin

      SELECT CO.ID_CONTAGEM,
             CO.COD_ENTIDADE,
             CO.NUM_MATRICULA,
             CO.COD_IDE_REL_FUNC,
             CO.COD_IDE_CLI,
             CO.DAT_CONTAGEM,
             CO.COD_INS,
             CO.TIPO_CONTAGEM

        INTO PAR_ID_CONTAGEM,
             PAR_COD_ENTIDADE,
             PAR_NUM_MATRICULA,
             PAR_COD_IDE_REL_FUNC,
             PAR_COD_IDE_CLI,
             par_DAT_CONTAGEM,
             PAR_COD_INS,
             PAR_TIPO_CONTAGEM
        FROM TB_CONTAGEM_SERVIDOR CO
       WHERE CO.ID_CONTAGEM = I_SEQ_CERTIDAO;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        par_cod_ide_rel_func := null;
        par_cod_entidade     := null;
        par_cod_ide_cli      := null;
        par_num_matricula    := null;
        par_id_contagem      := null;
        par_dat_contagem     := NULL;
    END;

    begin

    IF PAR_TIPO_CONTAGEM = 8 THEN
      FOR PER_DECL_INSS IN
        (
/*    select

       ef.dat_ini_efeito AS DATA_INICIO,
       nvl(ef.dat_fim_efeito, trunc(sysdate)) as DATA_FIM,
       ef.cod_cargo,
       ca.nom_cargo,
       ef.cod_ide_rel_func


  from tb_relacao_funcional rf,
       tb_evolucao_funcional ef,
       tb_cargo ca,
       tb_dias_apoio d
  where rf.cod_ins          = PAR_COD_INS
    and rf.cod_regime       = '2' --RGPS
    and rf.cod_plano        = '2' --RGPS
    and rf.tip_provimento   in ('2', '8') --Livre Provimento (cargo em Comiss�o)
    and rf.cod_vinculo      in ('6', '8') --Comissionado
    and ef.cod_ins          = rf.cod_ins
    and ef.cod_ide_cli      = rf.cod_ide_cli
    and ef.num_matricula    = rf.num_matricula
    and ef.cod_ide_rel_func = rf.cod_ide_rel_func
    and ef.cod_entidade     = rf.cod_entidade
    and ef.flg_status       = 'V'
    and ca.cod_ins          = ef.cod_ins
    and ca.cod_entidade     = ef.cod_entidade
    and ca.cod_pccs         = ef.cod_pccs
    and ca.cod_carreira     = ef.cod_carreira
    and ca.cod_cargo        = ef.cod_cargo
    and rf.num_matricula    = PAR_NUM_MATRICULA
    and rf.cod_ide_cli      = PAR_COD_IDE_CLI
    and rf.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
    and rf.cod_entidade     = PAR_COD_ENTIDADE
    and d.data_calculo between  rf.dat_ini_exerc and nvl(rf.dat_fim_exerc, sysdate)
    and d.data_calculo between  ef.dat_ini_efeito and nvl(ef.dat_fim_efeito, sysdate)


  union

select
       ef.dat_ini_efeito AS DATA_INICIO,
       nvl(ef.dat_fim_efeito, trunc(sysdate)) as DATA_FIM,
       ef.cod_cargo,
       ca.nom_cargo,
       ef.cod_ide_rel_func


  from tb_relacao_funcional rf,
       tb_evolucao_funcional ef,
       tb_cargo ca,
       tb_dias_apoio d
  where rf.cod_ins          = 1
    and rf.cod_regime       = '2' --RGPS
    and rf.cod_plano        = '2' --RGPS
    and rf.tip_provimento   in ('2', '8') --Livre Provimento (cargo em Comiss�o)
    and rf.cod_vinculo      in ('6', '8') --Comissionado
    and ef.cod_ins          = rf.cod_ins
    and ef.cod_ide_cli      = rf.cod_ide_cli
    and ef.num_matricula    = rf.num_matricula
    and ef.cod_ide_rel_func = rf.cod_ide_rel_func
    and ef.cod_entidade     = rf.cod_entidade
    and ef.flg_status       = 'V'
    and ca.cod_ins          = ef.cod_ins
    and ca.cod_entidade     = ef.cod_entidade
    and ca.cod_pccs         = ef.cod_pccs
    and ca.cod_carreira     = ef.cod_carreira
    and ca.cod_cargo        = ef.cod_cargo
    and rf.cod_ide_cli      = PAR_COD_IDE_CLI
    and rf.cod_ide_rel_func != PAR_COD_IDE_REL_FUNC
    and d.data_calculo between  rf.dat_ini_exerc and nvl(rf.dat_fim_exerc, sysdate)
    and d.data_calculo between  ef.dat_ini_efeito and nvl(ef.dat_fim_efeito, sysdate)

     group by
         ef.dat_ini_efeito,
         nvl(ef.dat_fim_efeito, trunc(sysdate)) ,
         ef.cod_cargo,
         ca.nom_cargo,
       ef.cod_ide_rel_func

  union

select
       hct.dat_adm_orig  as data_inicio,
       hct.dat_desl_orig as data_fim,
       0                 as cod_Cargo,
       hct.nom_cargo,
       PAR_COD_IDE_REL_FUNC


  from TB_HIST_CARTEIRA_TRAB HCT
 where hct.cod_ide_cli    = PAR_COD_IDE_CLI
   and hct.cod_emissor    = 1
      */




        --MELHORIAS EFANTIN

SELECT DATA_INICIO, DATA_FIM, COD_CARGO, NOM_CARGO, COD_IDE_REL_FUNC
  FROM (select eF.num_matricula,
               eF.cod_ide_rel_func,
               case
                 when (select 'S'
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_INI_EFEITO - 1 = F.DAT_FIM_EFEITO
                          AND F.COD_CARGO = EF.COD_CARGO) = 'S' THEN
                  (select F.DAT_INI_EFEITO
                     FROM TB_EVOLUCAO_FUNCIONAL F
                    WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                      AND EF.DAT_INI_EFEITO - 1 = F.DAT_FIM_EFEITO
                      AND F.COD_CARGO = EF.COD_CARGO)
                 ELSE
                  ef.dat_ini_efeito
               END DATA_INICIO,
               case
                 when (select count(*)
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC) = 1 then
                  ef.dat_fim_efeito

                 when (select 'S'
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_INI_EFEITO - 1 = F.DAT_FIM_EFEITO
                          AND F.COD_CARGO = EF.COD_CARGO) = 'S' THEN
                  (select F.DAT_FIM_EFEITO
                     FROM TB_EVOLUCAO_FUNCIONAL F
                    WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                      AND EF.DAT_INI_EFEITO = F.DAT_INI_EFEITO
                      AND F.COD_CARGO = EF.COD_CARGO)
                 when (select 'S'
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_FIM_EFEITO + 1 = F.DAT_INI_EFEITO
                          AND F.COD_CARGO != EF.COD_CARGO) = 'S' THEN
                  ef.dat_fim_efeito
                 when (select 'S'
                         FROM TB_RELACAO_FUNCIONAL F1
                        WHERE F1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_FIM_EFEITO = F1.DAT_FIM_EXERC) = 'S' THEN
                  EF.DAT_FIM_EFEITO

               end DATA_FIM,
               ca.nom_cargo,
               CA.COD_CARGO
          from tb_relacao_funcional  rf,
               tb_evolucao_funcional ef,
               tb_cargo              ca,
               tb_dias_apoio         d
         where rf.cod_ins = 1
           and rf.cod_regime = '2' --RGPS
           and rf.cod_plano = '2' --RGPS
           and rf.tip_provimento in ('2', '8') --Livre Provimento (cargo em Comiss�o)
           and rf.cod_vinculo in ('6', '8') --Comissionado
           and ef.cod_ins = rf.cod_ins
           and ef.cod_ide_cli = rf.cod_ide_cli
           and ef.num_matricula = rf.num_matricula
           and ef.cod_ide_rel_func = rf.cod_ide_rel_func
           and ef.cod_entidade = rf.cod_entidade
           and ef.flg_status = 'V'
           and ca.cod_ins = ef.cod_ins
           and ca.cod_entidade = ef.cod_entidade
           and ca.cod_pccs = ef.cod_pccs
           and ca.cod_carreira = ef.cod_carreira
           and ca.cod_cargo = ef.cod_cargo
           and rf.num_matricula = PAR_NUM_MATRICULA
           and rf.cod_ide_cli = PAR_COD_IDE_CLI
           and rf.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
           and rf.cod_entidade = 1
           and d.data_calculo = ef.dat_ini_efeito
           and d.data_calculo between rf.dat_ini_exerc and
               nvl(rf.dat_fim_exerc, sysdate)
           and d.data_calculo between ef.dat_ini_efeito and
               nvl(ef.dat_fim_efeito, sysdate)
         order by 1, 2, 3) a
 WHERE DATA_FIM IS NOT NULL

union

SELECT DATA_INICIO, DATA_FIM, COD_CARGO, NOM_CARGO, COD_IDE_REL_FUNC
  FROM (select eF.num_matricula,
               eF.cod_ide_rel_func,
               case
                 when (select 'S'
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_INI_EFEITO - 1 = F.DAT_FIM_EFEITO
                          AND F.COD_CARGO = EF.COD_CARGO) = 'S' THEN
                  (select F.DAT_INI_EFEITO
                     FROM TB_EVOLUCAO_FUNCIONAL F
                    WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                      AND EF.DAT_INI_EFEITO - 1 = F.DAT_FIM_EFEITO
                      AND F.COD_CARGO = EF.COD_CARGO)
                 ELSE
                  ef.dat_ini_efeito
               END DATA_INICIO,
               case
                 when (select count(*)
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC) = 1 then
                  ef.dat_fim_efeito

                 when (select 'S'
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_INI_EFEITO - 1 = F.DAT_FIM_EFEITO
                          AND F.COD_CARGO = EF.COD_CARGO) = 'S' THEN
                  (select F.DAT_FIM_EFEITO
                     FROM TB_EVOLUCAO_FUNCIONAL F
                    WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                      AND EF.DAT_INI_EFEITO = F.DAT_INI_EFEITO
                      AND F.COD_CARGO = EF.COD_CARGO)
                 when (select 'S'
                         FROM TB_EVOLUCAO_FUNCIONAL F
                        WHERE F.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_FIM_EFEITO + 1 = F.DAT_INI_EFEITO
                          AND F.COD_CARGO != EF.COD_CARGO) = 'S' THEN
                  ef.dat_fim_efeito
                 when (select 'S'
                         FROM TB_RELACAO_FUNCIONAL F1
                        WHERE F1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                          AND EF.DAT_FIM_EFEITO = F1.DAT_FIM_EXERC) = 'S' THEN
                  EF.DAT_FIM_EFEITO

               end DATA_FIM,
               ca.nom_cargo,
               CA.COD_CARGO

          from tb_relacao_funcional  rf,
               tb_evolucao_funcional ef,
               tb_cargo              ca,
               tb_dias_apoio         d
         where rf.cod_ins = 1
           and rf.cod_regime = '2' --RGPS
           and rf.cod_plano = '2' --RGPS
           and rf.tip_provimento in ('2', '8') --Livre Provimento (cargo em Comiss�o)
           and rf.cod_vinculo in ('6', '8') --Comissionado
           and ef.cod_ins = rf.cod_ins
           and ef.cod_ide_cli = rf.cod_ide_cli
           and ef.num_matricula = rf.num_matricula
           and ef.cod_ide_rel_func = rf.cod_ide_rel_func
           and ef.cod_entidade = rf.cod_entidade
           and ef.flg_status = 'V'
           and ca.cod_ins = ef.cod_ins
           and ca.cod_entidade = ef.cod_entidade
           and ca.cod_pccs = ef.cod_pccs
           and ca.cod_carreira = ef.cod_carreira
           and ca.cod_cargo = ef.cod_cargo
           and d.data_calculo = ef.dat_ini_efeito
           and rf.cod_ide_cli = PAR_COD_IDE_CLI
           and rf.cod_ide_rel_func != PAR_COD_IDE_REL_FUNC
           and d.data_calculo between rf.dat_ini_exerc and
               nvl(rf.dat_fim_exerc, sysdate)
           and d.data_calculo between ef.dat_ini_efeito and
               nvl(ef.dat_fim_efeito, sysdate)

        ) a
 WHERE DATA_FIM IS NOT NULL

union

select hct.dat_adm_orig     as data_inicio,
       hct.dat_desl_orig    as data_fim,
       0                    as cod_Cargo,
       hct.nom_cargo,
       PAR_COD_IDE_REL_FUNC

  from TB_HIST_CARTEIRA_TRAB HCT
 where hct.cod_ide_cli = PAR_COD_IDE_CLI
   and hct.cod_emissor = 1

 )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PAR_ID_CONTAGEM,
           PAR_NUM_MATRICULA,
           PAR_COD_IDE_REL_FUNC,
           PAR_COD_IDE_CLI,
           PER_DECL_INSS.DATA_INICIO,
           PER_DECL_INSS.DATA_FIM,
           PER_DECL_INSS.NOM_CARGO,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_DECL_INSS');

      --  COMMIT;
      END LOOP;


    END IF;

      FOR PERIODOS IN

       (select aa.*,
               nvl((select sum(f.bruto)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_bruto,

               nvl((select sum(f.inclusao)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_inclusao,

               nvl((select sum(f.lts)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_lts,

               nvl((select sum(f.lsv)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_lsv,

               nvl((select sum(f.fj)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_fj,

               nvl((select sum(f.fi)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_fi,

               nvl((select sum(f.susp)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_susp,

               nvl((select sum(f.outros)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_outro,

               nvl((select sum(f.tempo_Liquido)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_liquido

          from (select a.id_contagem,
                       a.cod_ide_rel_func,
                       a.des_cargo as nom_cargo,
                       nvl((select min(e.dat_inicio)
                             from TB_CONTAGEM_SERV_PER_DET e
                            where e.cod_ide_rel_func = a.cod_ide_rel_func
                              and nvl(e.des_cargo, 'sem') =
                                  nvl(a.des_cargo, 'sem')
                              and e.id_contagem = a.id_contagem
                              and e.dat_fim <= a.dat_fim
                              and e.dat_fim >
                                  (select max(f.dat_fim)
                                     from (select h.cod_ide_reL_func,
                                                  h.des_cargo,
                                                  h.dat_inicio,
                                                  h.dat_fim,
                                                  nvl((select min(hh.dat_inicio)
                                                        from TB_CONTAGEM_SERV_PER_DET hh
                                                       where hh.dat_inicio >
                                                             h.dat_inicio
                                                         and hh.cod_ide_rel_func =
                                                             h.cod_ide_rel_func
                                                         and nvl(hh.des_cargo,
                                                                 'sem') =
                                                             nvl(h.des_cargo,
                                                                 'sem')
                                                         and hh.id_contagem =
                                                             h.id_contagem),
                                                      to_date('01/01/2999',
                                                              'dd/mm/yyyy')) data_ini_aux

                                             from TB_CONTAGEM_SERV_PER_DET h
                                            where h.cod_ide_rel_func =
                                                  e.cod_ide_rel_func
                                              and h.id_contagem = e.id_contagem
                                              and nvl(h.des_cargo, 'sem') =
                                                  nvl(e.des_cargo, 'sem')
                                            order by h.dat_inicio) f
                                    where f.dat_fim /*+ 1*/ != f.data_ini_aux
                                      and f.dat_fim < a.dat_fim
                                      and f.cod_ide_rel_func =
                                          e.cod_ide_rel_func
                                      and nvl(f.des_cargo, 'sem') =
                                          nvl(e.des_cargo, 'sem'))),

                           (select min(dat_inicio)
                              from TB_CONTAGEM_SERV_PER_DET d
                             where a.cod_ide_rel_func = d.cod_ide_rel_func
                               and a.id_contagem = d.id_contagem
                               and nvl(a.des_cargo, 'sem') =
                                   nvl(d.des_cargo, 'sem'))) as data_inicio,
                       a.dat_fim as data_fim
                  from (select id_contagem,
                               t.cod_ide_rel_func,
                               t.des_cargo,
                               t.dat_inicio,
                               t.dat_fim,
                               sum(t.bruto) as qtd_bruto,
                               sum(t.inclusao) as qtd_inclusao,
                               sum(t.lts) as qtd_lts,
                               sum(t.lsv) as qtd_lsv,
                               sum(t.fj) as qtd_fj,
                               sum(t.fi) as qtd_fi,
                               sum(t.susp) as qtd_susp,
                               sum(t.outros) as qtd_outro,
                               sum(t.tempo_liquido) as qtd_liquido,
                               nvl((select min(tt.dat_inicio)
                                     from TB_CONTAGEM_SERV_PER_DET tt
                                    where tt.dat_inicio > t.dat_inicio
                                      and tt.cod_ide_rel_func =
                                          t.cod_ide_rel_func
                                      and nvl(tt.des_cargo, 'sem') =
                                          nvl(t.des_cargo, 'sem')),
                                   to_date('01/01/2999', 'dd/mm/yyyy')

                                   ) data_ini_aux
                          from TB_CONTAGEM_SERV_PER_DET t
                         where t.id_contagem = PAR_ID_CONTAGEM
                         group by t.id_contagem,
                                  t.cod_ide_rel_func,
                                  t.des_cargo,
                                  t.dat_inicio,
                                  t.dat_fim
                         order by t.dat_inicio) a
                 where a.dat_fim /*+ 1*/ != a.data_ini_aux) aa

         GROUP BY aa.id_contagem,
                  aa.cod_ide_rel_func,
                  aa.nom_cargo,
                  aa.data_inicio,
                  aa.data_fim

        )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PERIODO
          (COD_INS,
           ID_CONTAGEM,
           DAT_INICIO,
           DAT_FIM,
           COD_ENTIDADE,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DES_OBS,
           DES_CARGO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)
        VALUES
          (1,
           PAR_ID_CONTAGEM,
           PERIODOS.DATA_INICIO,
           PERIODOS.DATA_FIM,
           PAR_COD_ENTIDADE,
           PAR_NUM_MATRICULA,
           PAR_COD_IDE_REL_FUNC,
           PAR_COD_IDE_CLI,
           PERIODOS.QTD_BRUTO,
           PERIODOS.QTD_INCLUSAO,
           PERIODOS.QTD_LTS,
           PERIODOS.QTD_LSV,
           PERIODOS.QTD_FJ,
           PERIODOS.QTD_FI,
           PERIODOS.QTD_SUSP,
           PERIODOS.QTD_OUTRO,
           PERIODOS.QTD_LIQUIDO,
           NULL,
           NVL(PERIODOS.NOM_CARGO, 'NAO INFORMADO'),
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_CONTAGEM_PERIODO'

           );

      --  COMMIT;
      END LOOP;

      FOR OBS IN (
        /*SELECT YY.DAT_INICIO AS DATA_INICIO, YY.NUM_DOC_ASSOC_INI, YY.DAT_PUB_NOMEA, YY.NUM_DOC_ASSOC_FIM, YY.DAT_PUB_FIM_EXERC,
               LISTAGG(YY.GLS_DETALHE, CHR(10)) WITHIN GROUP (ORDER BY ORDEM) AS DES_OBS
         FROM
        (
                           --------------------------------------------------
                           -- Detalhe de Rela�ao Funcional
                           --------------------------------------------------
                           SELECT CSO.DAT_INICIO, RF.NUM_DOC_ASSOC_INI, RF.DAT_PUB_NOMEA, RF.NUM_DOC_ASSOC_FIM, RF.DAT_PUB_FIM_EXERC,

                                  'DURANTE O PER�ODO DE '||TO_CHAR(CSO.DAT_INICIO, 'DD/MM/YYYY')||
                                                    ' A '||TO_CHAR(CSO.DAT_FIM, 'DD/MM/YYYY') ||
                                  ' (NOMEADO ATRAVES DA '||
                                                        (
                                                        SELECT UPPER(CO.DES_DESCRICAO)
                                                        FROM TB_CODIGO CO
                                                        WHERE CO.COD_INS = 0
                                                        AND CO.COD_NUM = 2019
                                                        AND CO.COD_PAR = RF.COD_TIPO_DOC_ASSOC_INI) ||
                                           ' ' || RF.NUM_DOC_ASSOC_INI|| ', ' ||
                                           'COM PUBLICA��O EM ' ||
                                                        TO_CHAR(RF.DAT_PUB_NOMEA, 'DD/MM/YYYY') ||
                                           ' E EXONERADO ATRAV�S DA ' ||
                                                        (
                                                        SELECT UPPER(CO.DES_DESCRICAO)
                                                        FROM TB_CODIGO CO
                                                        WHERE CO.COD_INS = 0
                                                        AND CO.COD_NUM = 2019
                                                        AND CO.COD_PAR = RF.COD_TIPO_DOC_ASSOC_FIM) ||
                                           ' ' || RF.NUM_DOC_ASSOC_FIM|| ', ' ||
                                           'COM PUBLICA��O EM ' ||
                                                      TO_CHAR(RF.DAT_PUB_FIM_EXERC, 'DD/MM/YYYY') ||').'
                                   AS GLS_DETALHE,
                                  1 as ordem

                             FROM TB_RELACAO_FUNCIONAL     RF,
                                  TB_EVOLUCAO_FUNCIONAL    EF,
                                  tb_contagem_serv_periodo CSO,
                                  TB_CONTAGEM_SERVIDOR     CON
                            WHERE
                           --------------------------------------------------------
                            RF.COD_INS = CON.COD_INS
                         AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                           -----------------------------------------------------------

                         AND RF.COD_INS = EF.COD_INS
                         AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                         AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                         AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                         AND EF.FLG_STATUS = 'V'
                         AND ((CSO.DAT_INICIO = EF.DAT_INI_EFEITO) OR
                            (CSO.DAT_INICIO < EF.DAT_INI_EFEITO AND
                            NVL(EF.DAT_FIM_EFEITO, CON.DAT_FIM) <=
                            CSO.DAT_FIM AND
                            EF.COD_CARGO IN
                            (SELECT TC.COD_CARGO_TRANSF
                                 FROM TB_TRANSF_CARGO TC INNER JOIN TB_CARGO CAR ON TC.COD_CARGO_TRANSF = CAR.COD_CARGO
                                WHERE TC.COD_INS = EF.COD_INS
                                  AND TC.COD_ENTIDADE = EF.COD_ENTIDADE
                                  AND TC.COD_PCCS = EF.COD_PCCS
                                  AND EF.DAT_INI_EFEITO >= CAR.DAT_INI_VIG) AND
                            EF.DAT_INI_EFEITO =
                            (SELECT MIN(EF1.DAT_INI_EFEITO)
                                 FROM TB_EVOLUCAO_FUNCIONAL EF1
                                WHERE EF1.COD_INS = 1
                                  AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                                  AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                                  AND EF1.COD_IDE_REL_FUNC =
                                      EF.COD_IDE_REL_FUNC
                                  AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                                  AND EF1.COD_CARGO = EF.COD_CARGO
                                  AND EF1.FLG_STATUS = EF.FLG_STATUS)))
                         AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                         AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
                            GROUP BY CSO.DAT_INICIO,
                                    CSO.DAT_FIM,
                                    RF.COD_TIPO_DOC_ASSOC_INI,
                                    RF.NUM_DOC_ASSOC_INI,
                                    RF.DAT_PUB_NOMEA,
                                    RF.COD_TIPO_DOC_ASSOC_FIM,
                                    RF.NUM_DOC_ASSOC_FIM,
                                    RF.DAT_PUB_FIM_EXERC,
                                    CSO.DES_CARGO

             )YY
                   WHERE GLS_DETALHE IS NOT NULL
                   GROUP BY DAT_INICIO, NUM_DOC_ASSOC_INI, DAT_PUB_NOMEA, NUM_DOC_ASSOC_FIM, DAT_PUB_FIM_EXERC*/
             SELECT YY.DAT_INICIO AS DATA_INICIO,
       YY.NUM_DOC_ASSOC_INI,
       YY.DAT_PUB_NOMEA,
       YY.NUM_DOC_ASSOC_FIM,
       YY.DAT_PUB_FIM_EXERC,
       LISTAGG(YY.GLS_DETALHE, CHR(10)) WITHIN GROUP(ORDER BY ORDEM) AS DES_OBS
  FROM (
         --------------------------------------------------
         -- Detalhe de Rela�ao Funcional
         --------------------------------------------------
         SELECT CSO.DAT_INICIO,
                 EF.NUM_DOC_ASSOC AS NUM_DOC_ASSOC_INI /*RF.NUM_DOC_ASSOC_INI*/,
                 EF.DAT_PUB AS DAT_PUB_NOMEA /*RF.DAT_PUB_NOMEA*/,
                 CASE
                   WHEN (SELECT 1
                           FROM TB_EVOLUCAO_FUNCIONAL EF1
                          WHERE EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.FLG_STATUS = 'V'
                            AND EF1.DAT_INI_EFEITO = EF.DAT_FIM_EFEITO + 1
                            AND EF1.COD_MOT_EVOL_FUNC = 50) >= 1 THEN
                    (SELECT EF1.NUM_DOC_ASSOC
                       FROM TB_EVOLUCAO_FUNCIONAL EF1
                      WHERE EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                        AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                        AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                        AND EF1.FLG_STATUS = 'V'
                        AND EF1.DAT_INI_EFEITO = EF.DAT_FIM_EFEITO + 1
                        AND EF1.COD_MOT_EVOL_FUNC = 50)
                   ELSE
                    RF.NUM_DOC_ASSOC_FIM
                 END NUM_DOC_ASSOC_FIM,
                 CASE
                   WHEN (SELECT 1
                           FROM TB_EVOLUCAO_FUNCIONAL EF1
                          WHERE EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.FLG_STATUS = 'V'
                            AND EF1.DAT_INI_EFEITO = EF.DAT_FIM_EFEITO + 1
                            AND EF1.COD_MOT_EVOL_FUNC = 50) >= 1 THEN
                    (SELECT EF1.DAT_PUB
                       FROM TB_EVOLUCAO_FUNCIONAL EF1
                      WHERE EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                        AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                        AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                        AND EF1.FLG_STATUS = 'V'
                        AND EF1.DAT_INI_EFEITO = EF.DAT_FIM_EFEITO + 1
                        AND EF1.COD_MOT_EVOL_FUNC = 50)
                   ELSE
                    RF.DAT_PUB_FIM_EXERC
                 END DAT_PUB_FIM_EXERC,

                 'DURANTE O PER�ODO DE ' ||
                 TO_CHAR(CSO.DAT_INICIO, 'DD/MM/YYYY') || ' A ' ||
                 TO_CHAR(CSO.DAT_FIM, 'DD/MM/YYYY') || ' (NOMEADO ATRAVES DA ' ||
                 (SELECT UPPER(CO.DES_DESCRICAO)
                    FROM TB_CODIGO CO
                   WHERE CO.COD_INS = 0
                     AND CO.COD_NUM = 2019
                     AND CO.COD_PAR = RF.COD_TIPO_DOC_ASSOC_INI) || ' ' ||
                 EF.NUM_DOC_ASSOC /*RF.NUM_DOC_ASSOC_INI*/
                 || ', ' || 'COM PUBLICA��O EM ' ||
                 TO_CHAR(EF.DAT_PUB /*RF.DAT_PUB_NOMEA*/, 'DD/MM/YYYY') ||
                 ' E EXONERADO ATRAV�S DA ' ||
                 (SELECT UPPER(CO.DES_DESCRICAO)
                    FROM TB_CODIGO CO
                   WHERE CO.COD_INS = 0
                     AND CO.COD_NUM = 2019
                     AND CO.COD_PAR = RF.COD_TIPO_DOC_ASSOC_FIM) || ' ' ||
                 RF.NUM_DOC_ASSOC_FIM || ', ' || 'COM PUBLICA��O EM ' ||
                 TO_CHAR(RF.DAT_PUB_FIM_EXERC, 'DD/MM/YYYY') || ').' AS GLS_DETALHE,
                 1 as ordem

           FROM TB_RELACAO_FUNCIONAL     RF,
                 TB_EVOLUCAO_FUNCIONAL    EF,
                 tb_contagem_serv_periodo CSO,
                 TB_CONTAGEM_SERVIDOR     CON
          WHERE
         --------------------------------------------------------
          RF.COD_INS = CON.COD_INS
       AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
         -----------------------------------------------------------

       AND RF.COD_INS = EF.COD_INS
       AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
       AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
       AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
       AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
       AND EF.FLG_STATUS = 'V'
       AND ((CSO.DAT_INICIO = EF.DAT_INI_EFEITO) OR
          (CSO.DAT_INICIO < EF.DAT_INI_EFEITO AND
          NVL(EF.DAT_FIM_EFEITO, CON.DAT_FIM) <= CSO.DAT_FIM AND
          EF.COD_CARGO IN
          (SELECT TC.COD_CARGO_TRANSF
               FROM TB_TRANSF_CARGO TC
              INNER JOIN TB_CARGO CAR
                 ON TC.COD_CARGO_TRANSF = CAR.COD_CARGO
              WHERE TC.COD_INS = EF.COD_INS
                AND TC.COD_ENTIDADE = EF.COD_ENTIDADE
                AND TC.COD_PCCS = EF.COD_PCCS
                AND EF.DAT_INI_EFEITO >= CAR.DAT_INI_VIG) AND
          EF.DAT_INI_EFEITO =
          (SELECT MIN(EF1.DAT_INI_EFEITO)
               FROM TB_EVOLUCAO_FUNCIONAL EF1
              WHERE EF1.COD_INS = 1
                AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                AND EF1.COD_CARGO = EF.COD_CARGO
                AND EF1.FLG_STATUS = EF.FLG_STATUS)))
       AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
       AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
          GROUP BY CSO.DAT_INICIO,
                    CSO.DAT_FIM,
                    RF.COD_TIPO_DOC_ASSOC_INI,
                    RF.NUM_DOC_ASSOC_INI,
                    RF.DAT_PUB_NOMEA,
                    RF.COD_TIPO_DOC_ASSOC_FIM,
                    RF.NUM_DOC_ASSOC_FIM,
                    RF.DAT_PUB_FIM_EXERC,
                    CSO.DES_CARGO,
                    EF.NUM_DOC_ASSOC,
                    EF.DAT_PUB,
                    EF.NUM_MATRICULA,
                    EF.COD_IDE_REL_FUNC,
                    EF.COD_IDE_CLI,
                    EF.DAT_FIM_EFEITO

         ) YY
 WHERE GLS_DETALHE IS NOT NULL
 GROUP BY DAT_INICIO,
          NUM_DOC_ASSOC_INI,
          DAT_PUB_NOMEA,
          NUM_DOC_ASSOC_FIM,
          DAT_PUB_FIM_EXERC)

       LOOP
        UPDATE TB_CONTAGEM_SERV_PERIODO CON
           SET CON.DES_OBS = OBS.DES_OBS,
               CON.NUM_DOC_ASSOC_INI = OBS.NUM_DOC_ASSOC_INI,
               CON.NUM_DOC_ASSOC_FIM = OBS.NUM_DOC_ASSOC_FIM,
               CON.DAT_PUB_NOMEA = OBS.DAT_PUB_NOMEA,
               CON.DAT_PUB_FIM_EXERC = OBS.DAT_PUB_FIM_EXERC
         WHERE CON.ID_CONTAGEM = PAR_ID_CONTAGEM
           AND CON.DAT_INICIO = OBS.DATA_INICIO;
       -- COMMIT;
      END LOOP;

      FOR OBS_homol IN
        (
        SELECT
        'DECLARAMOS QUE A SERVIDORA FOI CONTRATADA PELO REGIME ESTATUT�RIO. DECLARAMOS, AINDA, QUE AS CONTRIBUI��ES PREVIDENCI�RIAS FORAM RECOLHIDAS PARA O REGIME GERAL DE PREVID�NCIA SOCIAL (INSS), CONFORME RESOLU��O NO. 694/98 E EMENDA CONSTITUCIONAL NO. 20, DE 15/12/1998.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-'
        AS OBS
        FROM DUAL
        )
      LOOP

      insert into tb_contagem_homologacao
      (
      NUM_SEQ,
      COD_INS,
      ID_CONTAGEM,
      COD_IDE_CLI,
      COD_ENTIDADE,
      NUM_MATRICULA,
      COD_IDE_REL_FUNC,
      OBSERVACOES,
      DAT_ING,
      DAT_ULT_ATU,
      NOM_USU_ULT_ATU,
      NOM_PRO_ULT_ATU

      )
      values
      (
      seq_contagem_homologacao.nextval,
      1,
      PAR_ID_CONTAGEM,
      PAR_COD_ENTIDADE,
      PAR_NUM_MATRICULA,
      PAR_COD_ENTIDADE,
      PAR_COD_IDE_REL_FUNC,
      OBS_homol.OBS,
      SYSDATE,
      SYSDATE,
      'AUTOM',
      'SP_CONTAGEM_DECL_INSS'
      );
 END LOOP;

    END ;
end;


PROCEDURE SP_CONTAGEM_CTC_INSS(I_SEQ_CERTIDAO IN NUMBER) AS
    PAR_ID_CONTAGEM      NUMBER;
    PAR_COD_ENTIDADE     NUMBER;
    PAR_NUM_MATRICULA    VARCHAR2(20);
    PAR_COD_IDE_REL_FUNC NUMBER;
    PAR_COD_IDE_CLI      VARCHAR2(20);
    DAT_CONTAGEM         DATE;
    PAR_COD_INS          NUMBER;
    PAR_TIPO_CONTAGEM     NUMBER;
    V_DATA_INICIO        DATE;
    V_DES_OBS            VARCHAR2(500);
    oErrorCode           number := 0;
    oErrorMessage        varchar2(20) := null;


  BEGIN

    DELETE FROM TB_CONTAGEM_SERV_PER_DET A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;
    DELETE FROM TB_CONTAGEM_SERV_PERIODO A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    begin

      SELECT CO.ID_CONTAGEM,
             CO.COD_ENTIDADE,
             CO.NUM_MATRICULA,
             CO.COD_IDE_REL_FUNC,
             CO.COD_IDE_CLI,
             CO.DAT_CONTAGEM,
             CO.COD_INS,
             CO.TIPO_CONTAGEM

        INTO PAR_ID_CONTAGEM,
             PAR_COD_ENTIDADE,
             PAR_NUM_MATRICULA,
             PAR_COD_IDE_REL_FUNC,
             PAR_COD_IDE_CLI,
             par_DAT_CONTAGEM,
             PAR_COD_INS,
             PAR_TIPO_CONTAGEM
        FROM TB_CONTAGEM_SERVIDOR CO
       WHERE CO.ID_CONTAGEM = I_SEQ_CERTIDAO;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        par_cod_ide_rel_func := null;
        par_cod_entidade     := null;
        par_cod_ide_cli      := null;
        par_num_matricula    := null;
        par_id_contagem      := null;
        par_dat_contagem     := NULL;
    END;

    begin

    IF PAR_TIPO_CONTAGEM = 7 THEN
      FOR PER_CTC_INSS IN
        (
    select

       rf.dat_ini_exerc AS DATA_INICIO,
       nvl(rf.dat_fim_exerc, trunc(sysdate)) as DATA_FIM,
       ef.cod_cargo,
       ca.nom_cargo


  from tb_relacao_funcional rf,
       tb_evolucao_funcional ef,
       tb_cargo ca,
       tb_dias_apoio d
  where rf.cod_ins          = PAR_COD_INS
    --and rf.cod_regime       = '2' --RGPS
    --and rf.cod_plano        = '2' --RGPS
    and rf.tip_provimento   = '2' --Livre Provimento (cargo em Comiss�o)
    --and rf.cod_vinculo      = '8' --Comissionado
    and ef.cod_ins          = rf.cod_ins
    and ef.cod_ide_cli      = rf.cod_ide_cli
    and ef.num_matricula    = rf.num_matricula
    and ef.cod_ide_rel_func = rf.cod_ide_rel_func
    and ef.cod_entidade     = rf.cod_entidade
    and ef.flg_status       = 'V'
    and ca.cod_ins          = ef.cod_ins
    and ca.cod_entidade     = ef.cod_entidade
    and ca.cod_pccs         = ef.cod_pccs
    and ca.cod_carreira     = ef.cod_carreira
    and ca.cod_cargo        = ef.cod_cargo
    and rf.num_matricula    = PAR_NUM_MATRICULA
    and rf.cod_ide_cli      = PAR_COD_IDE_CLI
    and rf.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
    and rf.cod_entidade     = PAR_COD_ENTIDADE
    and d.data_calculo between  rf.dat_ini_exerc and nvl(rf.dat_fim_exerc, sysdate)
    and d.data_calculo between  ef.dat_ini_efeito and nvl(ef.dat_fim_efeito, sysdate)
    and ef.dat_ini_efeito   = rf.dat_ini_exerc


  union

select
       rf.dat_ini_exerc AS DATA_INICIO,
       nvl(rf.dat_fim_exerc, trunc(sysdate)) as DATA_FIM,
       ef.cod_cargo,
       ca.nom_cargo


  from tb_relacao_funcional rf,
       tb_evolucao_funcional ef,
       tb_cargo ca,
       tb_dias_apoio d
  where rf.cod_ins          = 1
    --and rf.cod_regime       = '2' --RGPS
    --and rf.cod_plano        = '2' --RGPS
    and rf.tip_provimento   = '2' --Livre Provimento (cargo em Comiss�o)
    --and rf.cod_vinculo      = '8' --Comissionado
    and ef.cod_ins          = rf.cod_ins
    and ef.cod_ide_cli      = rf.cod_ide_cli
    and ef.num_matricula    = rf.num_matricula
    and ef.cod_ide_rel_func = rf.cod_ide_rel_func
    and ef.cod_entidade     = rf.cod_entidade
    and ef.flg_status       = 'V'
    and ca.cod_ins          = ef.cod_ins
    and ca.cod_entidade     = ef.cod_entidade
    and ca.cod_pccs         = ef.cod_pccs
    and ca.cod_carreira     = ef.cod_carreira
    and ca.cod_cargo        = ef.cod_cargo
    and rf.cod_ide_cli      = PAR_COD_IDE_CLI
    and rf.cod_ide_rel_func != PAR_COD_IDE_REL_FUNC
    and d.data_calculo between  rf.dat_ini_exerc and nvl(rf.dat_fim_exerc, sysdate)
    and d.data_calculo between  ef.dat_ini_efeito and nvl(ef.dat_fim_efeito, sysdate)
    and ef.dat_ini_efeito   = rf.dat_ini_exerc

 group by
         rf.dat_ini_exerc,
         nvl(rf.dat_fim_exerc, trunc(sysdate)) ,
         ef.cod_cargo,
         ca.nom_cargo
        )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PAR_ID_CONTAGEM,
           PAR_NUM_MATRICULA,
           PAR_COD_IDE_REL_FUNC,
           PAR_COD_IDE_CLI,
           PER_CTC_INSS.DATA_INICIO,
           PER_CTC_INSS.DATA_FIM,
           PER_CTC_INSS.NOM_CARGO,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           0,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_CTC_INSS');

      --  COMMIT;
      END LOOP;


    END IF;

      FOR PERIODOS IN

       (select aa.*,
               nvl((select sum(f.bruto)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_bruto,

               nvl((select sum(f.inclusao)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_inclusao,

               nvl((select sum(f.lts)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_lts,

               nvl((select sum(f.lsv)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_lsv,

               nvl((select sum(f.fj)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_fj,

               nvl((select sum(f.fi)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_fi,

               nvl((select sum(f.susp)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_susp,

               nvl((select sum(f.outros)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_outro,

               nvl((select sum(f.tempo_Liquido)
                     from TB_CONTAGEM_SERV_PER_DET f
                    where f.cod_ide_rel_func = aa.cod_ide_rel_func
                      and f.id_contagem = aa.id_contagem
                      and (f.dat_inicio >= aa.data_inicio and
                          f.dat_fim <= aa.data_fim)),
                   0) as qtd_liquido

          from (select a.id_contagem,
                       a.cod_ide_rel_func,
                       a.des_cargo as nom_cargo,
                       nvl((select min(e.dat_inicio)
                             from TB_CONTAGEM_SERV_PER_DET e
                            where e.cod_ide_rel_func = a.cod_ide_rel_func
                              and nvl(e.des_cargo, 'sem') =
                                  nvl(a.des_cargo, 'sem')
                              and e.id_contagem = a.id_contagem
                              and e.dat_fim <= a.dat_fim
                              and e.dat_fim >
                                  (select max(f.dat_fim)
                                     from (select h.cod_ide_reL_func,
                                                  h.des_cargo,
                                                  h.dat_inicio,
                                                  h.dat_fim,
                                                  nvl((select min(hh.dat_inicio)
                                                        from TB_CONTAGEM_SERV_PER_DET hh
                                                       where hh.dat_inicio >
                                                             h.dat_inicio
                                                         and hh.cod_ide_rel_func =
                                                             h.cod_ide_rel_func
                                                         and nvl(hh.des_cargo,
                                                                 'sem') =
                                                             nvl(h.des_cargo,
                                                                 'sem')
                                                         and hh.id_contagem =
                                                             h.id_contagem),
                                                      to_date('01/01/2999',
                                                              'dd/mm/yyyy')) data_ini_aux

                                             from TB_CONTAGEM_SERV_PER_DET h
                                            where h.cod_ide_rel_func =
                                                  e.cod_ide_rel_func
                                              and h.id_contagem = e.id_contagem
                                              and nvl(h.des_cargo, 'sem') =
                                                  nvl(e.des_cargo, 'sem')
                                            order by h.dat_inicio) f
                                    where f.dat_fim /*+ 1*/ != f.data_ini_aux
                                      and f.dat_fim < a.dat_fim
                                      and f.cod_ide_rel_func =
                                          e.cod_ide_rel_func
                                      and nvl(f.des_cargo, 'sem') =
                                          nvl(e.des_cargo, 'sem'))),

                           (select min(dat_inicio)
                              from TB_CONTAGEM_SERV_PER_DET d
                             where a.cod_ide_rel_func = d.cod_ide_rel_func
                               and a.id_contagem = d.id_contagem
                               and nvl(a.des_cargo, 'sem') =
                                   nvl(d.des_cargo, 'sem'))) as data_inicio,
                       a.dat_fim as data_fim
                  from (select id_contagem,
                               t.cod_ide_rel_func,
                               t.des_cargo,
                               t.dat_inicio,
                               t.dat_fim,
                               sum(t.bruto) as qtd_bruto,
                               sum(t.inclusao) as qtd_inclusao,
                               sum(t.lts) as qtd_lts,
                               sum(t.lsv) as qtd_lsv,
                               sum(t.fj) as qtd_fj,
                               sum(t.fi) as qtd_fi,
                               sum(t.susp) as qtd_susp,
                               sum(t.outros) as qtd_outro,
                               sum(t.tempo_liquido) as qtd_liquido,
                               nvl((select min(tt.dat_inicio)
                                     from TB_CONTAGEM_SERV_PER_DET tt
                                    where tt.dat_inicio > t.dat_inicio
                                      and tt.cod_ide_rel_func =
                                          t.cod_ide_rel_func
                                      and nvl(tt.des_cargo, 'sem') =
                                          nvl(t.des_cargo, 'sem')),
                                   to_date('01/01/2999', 'dd/mm/yyyy')

                                   ) data_ini_aux
                          from TB_CONTAGEM_SERV_PER_DET t
                         where t.id_contagem = PAR_ID_CONTAGEM
                         group by t.id_contagem,
                                  t.cod_ide_rel_func,
                                  t.des_cargo,
                                  t.dat_inicio,
                                  t.dat_fim
                         order by t.dat_inicio) a
                 where a.dat_fim /*+ 1*/ != a.data_ini_aux) aa

         GROUP BY aa.id_contagem,
                  aa.cod_ide_rel_func,
                  aa.nom_cargo,
                  aa.data_inicio,
                  aa.data_fim

        )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PERIODO
          (COD_INS,
           ID_CONTAGEM,
           DAT_INICIO,
           DAT_FIM,
           COD_ENTIDADE,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DES_OBS,
           DES_CARGO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)
        VALUES
          (1,
           PAR_ID_CONTAGEM,
           PERIODOS.DATA_INICIO,
           PERIODOS.DATA_FIM,
           PAR_COD_ENTIDADE,
           PAR_NUM_MATRICULA,
           PAR_COD_IDE_REL_FUNC,
           PAR_COD_IDE_CLI,
           PERIODOS.QTD_BRUTO,
           PERIODOS.QTD_INCLUSAO,
           PERIODOS.QTD_LTS,
           PERIODOS.QTD_LSV,
           PERIODOS.QTD_FJ,
           PERIODOS.QTD_FI,
           PERIODOS.QTD_SUSP,
           PERIODOS.QTD_OUTRO,
           PERIODOS.QTD_LIQUIDO,
           NULL,
           NVL(PERIODOS.NOM_CARGO, 'NAO INFORMADO'),
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_CONTAGEM_PERIODO'

           );

      --  COMMIT;
      END LOOP;

      FOR OBS IN (
        SELECT YY.DAT_INICIO AS DATA_INICIO,
               LISTAGG(YY.GLS_DETALHE, ', ') WITHIN GROUP (ORDER BY ORDEM) AS DES_OBS
         FROM
        (
                           --------------------------------------------------
                           -- Detalhe de Rela�ao Funcional
                           --------------------------------------------------
                           SELECT DISTINCT
                                 CSO.DAT_INICIO,
                                 CA.NOM_CARGO



                                   AS GLS_DETALHE,
                                  1 as ordem

                             FROM TB_RELACAO_FUNCIONAL     RF,
                                  TB_EVOLUCAO_FUNCIONAL    EF,
                                  tb_contagem_serv_periodo CSO,
                                  TB_CONTAGEM_SERVIDOR     CON,
                                  TB_CARGO                 CA
                            WHERE
                           --------------------------------------------------------
                            RF.COD_INS = CON.COD_INS
                         AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                           -----------------------------------------------------------

                         AND RF.COD_INS = EF.COD_INS
                         AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                         AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                         AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                         AND EF.FLG_STATUS = 'V'
                         AND EF.DAT_INI_EFEITO
                                BETWEEN CSO.DAT_INICIO AND CSO.DAT_FIM
                         AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                         AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
                         AND CA.COD_INS      = EF.COD_ENTIDADE
                         AND CA.COD_PCCS     = EF.COD_PCCS
                         AND CA.COD_CARREIRA = EF.COD_CARREIRA
                         AND CA.COD_CARGO    = EF.COD_CARGO


             )YY
                   WHERE GLS_DETALHE IS NOT NULL
                   GROUP BY DAT_INICIO)

       LOOP
        UPDATE TB_CONTAGEM_SERV_PERIODO CON
           SET CON.DES_OBS = OBS.DES_OBS
         WHERE CON.ID_CONTAGEM = PAR_ID_CONTAGEM
           AND CON.DAT_INICIO = OBS.DATA_INICIO;
       -- COMMIT;
      END LOOP;

      FOR OBS_homol IN
        (
        SELECT
        'Durante o per�odo de 02/09/1991 a 18/10/1991, de 01/09/1993 a 31/12/1994 e de 01/03/1995 a 31/08/1997, as contribui��es previdenci�rias foram recolhidas para a CAPSCMC (Caixa de Assist�ncia e Previd�ncia dos Servidores da C�mara Municipal de Campinas), atualmente Instituto de Previd�ncia Social do Munic�pio de Campinas � CAMPREV. Durante o per�odo de 19/10/1991 a 31/08/1993 e de 01/01/1995 a 28/02/1995, n�o houve contribui��o previdenci�ria conforme facultava a Lei Municipal n� 6.670 de 18 de outubro de 1991. Durante o per�odo de 01/01/2005 a 31/12/2008 as contribui��es previdenci�rias foram recolhidas para o Regime Geral de Previd�ncia Social, nos termos do Artigo 40, � 13, da Constitui��o Federal e Emenda Constitucional n� 20, de 15/12/1998. CERTIFICO ainda que a Lei Complementar n� 10 de 30/06/2004, assegura aos servidores do Munic�pio de Campinas/SP aposentadorias volunt�rias, por invalidez e compuls�ria, e pens�o por morte, com aproveitamento de tempo de contribui��o para o Regime Geral de Previd�ncia Social ou para outro Regime Pr�prio de Previd�ncia Social, na forma da contagem rec�proca, conforme Lei Federal n� 6.226, de 14/07/75, com altera��o dada pela Lei Federal n� 6.864, de 01/12/80'
        AS OBS
        FROM TB_CONTAGEM_SERVIDOR CS
        WHERE CS.ID_CONTAGEM = PAR_ID_CONTAGEM
        )
      LOOP

      insert into tb_contagem_homologacao
      (
      NUM_SEQ,
      COD_INS,
      ID_CONTAGEM,
      COD_IDE_CLI,
      COD_ENTIDADE,
      NUM_MATRICULA,
      COD_IDE_REL_FUNC,
      OBSERVACOES,
      DAT_ING,
      DAT_ULT_ATU,
      NOM_USU_ULT_ATU,
      NOM_PRO_ULT_ATU

      )
      values
      (
      seq_contagem_homologacao.nextval,
      1,
      PAR_ID_CONTAGEM,
      PAR_COD_ENTIDADE,
      PAR_NUM_MATRICULA,
      PAR_COD_ENTIDADE,
      PAR_COD_IDE_REL_FUNC,
      OBS_homol.OBS,
      SYSDATE,
      SYSDATE,
      'AUTOM',
      'SP_CONTAGEM_CTC_INSS'
      );
 END LOOP;

    END ;
end;



PROCEDURE SP_CONTR_INSS(I_SEQ_CERTIDAO IN NUMBER) AS
    PAR_ID_CONTAGEM      NUMBER;
    PAR_COD_ENTIDADE     NUMBER;
    PAR_NUM_MATRICULA    VARCHAR2(20);
    PAR_COD_IDE_REL_FUNC NUMBER;
    PAR_COD_IDE_CLI      VARCHAR2(20);
    DAT_CONTAGEM         DATE;
    PAR_COD_INS          NUMBER;
    PAR_TIPO_CONTAGEM     NUMBER;
    V_DATA_INICIO        DATE;
    V_DES_OBS            VARCHAR2(500);
    oErrorCode           number := 0;
    oErrorMessage        varchar2(20) := null;


  BEGIN

    DELETE FROM TB_CONTAGEM_SERV_PER_DET A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    DELETE FROM TB_CONTAGEM_SERV_PERIODO A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    DELETE FROM TB_CONTAGEM_SERV_CONTRIB A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    begin

      SELECT CO.ID_CONTAGEM,
             CO.COD_ENTIDADE,
             CO.NUM_MATRICULA,
             CO.COD_IDE_REL_FUNC,
             CO.COD_IDE_CLI,
             CO.DAT_CONTAGEM,
             CO.COD_INS,
             CO.TIPO_CONTAGEM

        INTO PAR_ID_CONTAGEM,
             PAR_COD_ENTIDADE,
             PAR_NUM_MATRICULA,
             PAR_COD_IDE_REL_FUNC,
             PAR_COD_IDE_CLI,
             par_DAT_CONTAGEM,
             PAR_COD_INS,
             PAR_TIPO_CONTAGEM
        FROM TB_CONTAGEM_SERVIDOR CO
       WHERE CO.ID_CONTAGEM = I_SEQ_CERTIDAO;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        par_cod_ide_rel_func := null;
        par_cod_entidade     := null;
        par_cod_ide_cli      := null;
        par_num_matricula    := null;
        par_id_contagem      := null;
        par_dat_contagem     := NULL;
    END;

    begin

    IF PAR_TIPO_CONTAGEM = 6 THEN
      FOR PER_CONTRIB IN
        (
        select C.ANO_PROC,
               sum(C.JANEIRO)   JANEIRO,
               sum(C.FEVEREIRO) FEVEREIRO,
               sum(C.MARCO)     MARCO,
               sum(C.ABRIL)     ABRIL,
               sum(C.MAIO)      MAIO,
               sum(C.JUNHO)     JUNHO,
               sum(C.JULHO)     JULHO,
               sum(C.AGOSTO)    AGOSTO,
               sum(C.SETEMBRO)  SETEMBRO,
               sum(C.OUTUBRO)   OUTUBRO,
               sum(C.NOVEMBRO)  NOVEMBRO,
               sum(C.DEZEMBRO)  DEZEMBRO,
               sum(C.SAL13)     SAL13
        from vw_rel_val_contrib c
        where c.COD_IDE_CLI = PAR_COD_IDE_CLI
        and c.ANO_PROC is not null
        and (nvl(c.JANEIRO,0) + nvl(c.fevereiro, 0) + nvl(c.marco, 0) + nvl(c.abril, 0) + nvl(maio, 0)
        + nvl(junho, 0) + nvl(julho, 0) + nvl(agosto, 0) + nvl(setembro, 0) + nvl(outubro, 0) + nvl(novembro, 0)
        + nvl(dezembro, 0)+ nvl(SAL13, 0) )>0
        group by ano_proc
        order by ano_proc
        )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_CONTRIB
          (COD_INS,
           ID_CONTAGEM,
           ano,
           MES_01,
           MES_02,
           MES_03,
           MES_04,
           MES_05,
           MES_06,
           MES_07,
           MES_08,
           MES_09,
           MES_10,
           MES_11,
           MES_12,
           MES_13,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PAR_ID_CONTAGEM,
           PER_CONTRIB.ANO_PROC,
           PER_CONTRIB.JANEIRO,
           PER_CONTRIB.FEVEREIRO,
           PER_CONTRIB.MARCO,
           PER_CONTRIB.ABRIL,
           PER_CONTRIB.MAIO,
           PER_CONTRIB.JUNHO,
           PER_CONTRIB.JULHO,
           PER_CONTRIB.AGOSTO,
           PER_CONTRIB.SETEMBRO,
           PER_CONTRIB.OUTUBRO,
           PER_CONTRIB.NOVEMBRO,
           PER_CONTRIB.DEZEMBRO,
           PER_CONTRIB.SAL13,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_CONTRIB');

      --  COMMIT;
      END LOOP;


    END IF;



    END ;
end;


  PROCEDURE SP_CONTAGEM_PERIODO_AGRUP_NC (I_SEQ_CERTIDAO IN NUMBER) AS
    PAR_ID_CONTAGEM      NUMBER;
    PAR_COD_ENTIDADE     NUMBER;
    PAR_NUM_MATRICULA    VARCHAR2(20);
    PAR_COD_IDE_REL_FUNC NUMBER;
    PAR_COD_IDE_CLI      VARCHAR2(20);
    DAT_CONTAGEM         DATE;
    PAR_COD_INS          NUMBER;
    PAR_TIPO_CONTAGEM     NUMBER;
    V_DATA_INICIO        DATE;
    V_DES_OBS            VARCHAR2(500);
    oErrorCode           number := 0;
    oErrorMessage        varchar2(20) := null;
    PAR_INICIO_PERIODO_LP   DATE := null;


    A_COD_IDE_CLI        TB_CONTAGEM_SERV_PERIODO.COD_IDE_CLI%TYPE;
    A_COD_ENTIDADE       TB_CONTAGEM_SERV_PERIODO.COD_ENTIDADE%TYPE;
    A_NUM_MATRICULA      TB_CONTAGEM_SERV_PERIODO.NUM_MATRICULA%TYPE;
    A_COD_IDE_REL_FUNC   TB_CONTAGEM_SERV_PERIODO.COD_IDE_REL_FUNC%TYPE;
    A_COD_REFERENCIA     VARCHAR2(200);--TB_EVOLUCAO_FUNCIONAL.COD_REFERENCIA%TYPE;
    A_DATA_INICIO        DATE;
    A_DATA_FIM           DATE;
    W_NUM_REGISTRO       NUMBER;
    A_COD_CARGO          NUMBER;
    A_NOM_CARGO          VARCHAR2(200);

    QTD_BRUTO       NUMBER;
    QTD_INCLUSAO    NUMBER;
    QTD_LTS         NUMBER;
    QTD_LSV         NUMBER;
    QTD_FJ          NUMBER;
    QTD_FI          NUMBER;
    QTD_SUSP        NUMBER;
    QTD_OUTRO       NUMBER;
    qtd_liquido     NUMBER;



  BEGIN

    DELETE FROM TB_CONTAGEM_SERV_PER_DET A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;
    DELETE FROM TB_CONTAGEM_SERV_PERIODO A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    begin

      SELECT CO.ID_CONTAGEM,
             CO.COD_ENTIDADE,
             CO.NUM_MATRICULA,
             CO.COD_IDE_REL_FUNC,
             CO.COD_IDE_CLI,
             CO.DAT_CONTAGEM,
             CO.COD_INS,
             CO.TIPO_CONTAGEM

        INTO PAR_ID_CONTAGEM,
             PAR_COD_ENTIDADE,
             PAR_NUM_MATRICULA,
             PAR_COD_IDE_REL_FUNC,
             PAR_COD_IDE_CLI,
             par_DAT_CONTAGEM,
             PAR_COD_INS,
             PAR_TIPO_CONTAGEM
        FROM TB_CONTAGEM_SERVIDOR CO
       WHERE CO.ID_CONTAGEM = I_SEQ_CERTIDAO;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        par_cod_ide_rel_func := null;
        par_cod_entidade     := null;
        par_cod_ide_cli      := null;
        par_num_matricula    := null;
        par_id_contagem      := null;
        par_dat_contagem     := NULL;
    END;

    begin

    IF (PAR_TIPO_CONTAGEM = 1 OR PAR_TIPO_CONTAGEM = 9   OR PAR_TIPO_CONTAGEM = 2 OR PAR_TIPO_CONTAGEM = 3 OR PAR_TIPO_CONTAGEM = 11) THEN
      FOR PER_ATS IN (SELECT PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
                             DATA_INICIO,
                             DATA_FIM,
                             NOM_CARGO,

                             SUM(BRUTO) QTD_BRUTO,
                             SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,
                             CASE
                              when COD_IDE_CLI = 1000032125    and DATA_INICIO = '21/05/2013' then 1315

                              WHEN PAR_TIPO_CONTAGEM = 3 THEN
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LSV, 0)) -    SUM(nvl(FJ, 0)) -
                             SUM(nvl(FI, 0)) -     SUM(nvl(OUTRO, 0)))

                             ELSE (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) END QTD_LIQUIDO
                        FROM (

                              -- Tabela de Contagem  Dias da Evoluca�ao Funcional
                              ---- Dias Bruto -----
                              SELECT 'BRUTO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      ---to_char(DATA_CALCULO, 'yyyy') Ano,
                                      count(DISTINCT DATA_CALCULO) BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                                        --YUMI EM 01/05/2018: INCLU�DO PARA PEGAR V�NCULOS ANTERIORES DA RELACAO FUNCIONAL
                                        union

                                        SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(EF.DAT_FIM_EFEITO,
                                                            RF.DAT_FIM_EXERC) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_IDE_REL_FUNC !=
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        ---AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      CASE
                                        when COD_IDE_CLI = 1008200    and NOM_CARGO = 'OFICIAL DE PROMOTORIA' then 315
                                        when COD_IDE_CLI = 1000032030 and NOM_CARGO = 'SERVENTE DE ESCOLA' then 3309
                                        when COD_IDE_CLI = 1000032093 and NOM_CARGO = 'ASSISITENTE DE ADMINISTRA��O' then 636
                                        when COD_IDE_CLI = 1008233                                   then 1480
                                        when COD_IDE_CLI = 1008053    and DATA_INICIO = '29/07/1985' then 942
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '09/04/2012' then 768
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '10/05/2016' then 636
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '01/03/2018' then 40
                                        when COD_IDE_CLI = 1008087    and DATA_INICIO = '28/05/2008' then 2282
                                        when COD_IDE_CLI = 1008101    and DATA_INICIO = '02/04/2009' then 426
                                        when COD_IDE_CLI = 1007974    and DATA_INICIO = '28/08/1995' then 86
                                        when COD_IDE_CLI = 1008125    and DATA_INICIO = '12/02/2007' then 210
                                        when COD_IDE_CLI = 1000032125 and DATA_INICIO = '21/05/2013' then 1864


                                     --  ELSE QTDE_DIA  -- Roberto
                                         END Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,

                                                        T.DAT_DESL_ORIG     AS DATA_FIM
                                                        /*CASE WHEN (PAR_TIPO_CONTAGEM IN (1,9) AND T.FLG_TMP_ATS = 'S')
                                                               THEN T.QTD_DIAS_FINS_ATS
                                                             WHEN (PAR_TIPO_CONTAGEM IN (2)   AND T.FLG_TMP_LIC_PREM = 'S')
                                                               THEN T.QTD_DIAS_LIC_PREMIO END QTDE_DIA*/-- Roberto
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T.FLG_TMP_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND T.FLG_TMP_LIC_PREM = 'S')

                                              )
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )

                               /*group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM*/

                              UNION ALL

                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LTS' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,

                                      0 BRUTO,
                                      0 Inclusao,
                                      count(DISTINCT DATA_CALCULO) lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA= 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                              )
                                          --- Contagem tipo 2

                                          AND MO.COD_AGRUP_AFAST = 2

                                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                           --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio
                                          AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LSV' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      count(DISTINCT DATA_CALCULO) lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND MO.AUMENTA_CONT_LICENCA = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                              )
                                          AND MO.COD_AGRUP_AFAST = 1

                                          --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                          --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio
                                          AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS - FJ' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      count(distinct data_calculo) FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND AUMENTA_CONT_LICENCA = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                              )
                                          AND MO.COD_AGRUP_AFAST = 3

                                          --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                          --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio
                                          AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         data_inicio,
                                         data_fim

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS -FI' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      count(DISTINCT DATA_CALCULO) FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C

                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND AUMENTA_CONT_LICENCA = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                              )
                                          AND MO.COD_AGRUP_AFAST = 4

                                          --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                          --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio
                                          AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas SUSPENSOS

                              SELECT 'SUSP' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      COUNT(DISTINCT DATA_CALCULO) SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND AUMENTA_CONT_LICENCA = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                              )
                                          AND MO.COD_AGRUP_AFAST = 5

                                          --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8�, par�grafo IX:
                                          --n�o considerar o per�odo abaixo para contagem de ATS, Sexta Parte e Licen�a Premio
                                          AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM
                              -------------------------------------------

                              UNION ALL

                              ---- Tabela de Contagem Faltas OUTRO
                              SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (2)   AND AUMENTA_CONT_LICENCA = 'S')
                                              OR
                                                (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                              )

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                          AND NOT EXISTS
                                        (SELECT 1
                                                 FROM TB_RELACAO_FUNCIONAL  RF,
                                                      Tb_afastamento        TT,
                                                      tb_dias_apoio         A,
                                                      tb_motivo_afastamento MO
                                                WHERE RF.COD_INS = PAR_COD_INS
                                                     --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                                  AND RF.COD_VINCULO not in
                                                      (/*'22',*/ '5', '6')
                                                     --AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                                                     --AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                                                     --AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------
                                                      RF.COD_INS = T.COD_INS
                                                  AND RF.COD_IDE_CLI =
                                                      T.COD_IDE_CLI
                                                  AND RF.NUM_MATRICULA =
                                                      T.NUM_MATRICULA
                                                  AND RF.COD_IDE_REL_FUNC =
                                                      T.COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------

                                                      TT.COD_INS = 1
                                                  AND TT.COD_IDE_CLI =
                                                      PAR_COD_IDE_CLI
                                                  AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                                  AND A.DATA_CALCULO <=
                                                      PAR_DAT_CONTAGEM
                                                  AND A.DATA_CALCULO >=
                                                      TT.dat_ini_afast
                                                  AND A.DATA_CALCULO <=
                                                      NVL(TT.DAT_RET_PREV,
                                                          PAR_DAT_CONTAGEM)
                                                  AND MO.COD_MOT_AFAST =
                                                      T.COD_MOT_AFAST
                                                  AND ( (PAR_TIPO_CONTAGEM IN (1,9,11) AND MO.AUMENTA_CONT_ATS = 'S')
                                                  OR
                                                    (PAR_TIPO_CONTAGEM IN (2)   AND AUMENTA_CONT_LICENCA = 'S')
                                                  OR
                                                    (PAR_TIPO_CONTAGEM IN (3)   AND FLG_DESC_APOSENTADORIA = 'S')
                                                  )
                                                      AND NVL(MO.COD_AGRUP_AFAST, 0) IN
                                                          (1, 2, 3, 4, 5)
                                                      AND AA.DATA_CALCULO =
                                                          A.DATA_CALCULO

                                                   )

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              union
                              ---Yumi em 01/05/2018: inclu�do para descontar os dias de descontos
                              ---relacionados ao hist�rico de tempos averbados
                              select 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      sum(nvl(qtd_dias_ausencia, 0)) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct t1.dat_adm_orig,
                                                        1                    AS COD_INS,
                                                        1                    AS TIPO_CONTAGEM,
                                                        1                    AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        t1.qtd_dias_ausencia,
                                                        T1.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T1.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T1.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T1,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22', */'5', '6')
                                        ------------------------------------------------------
                                      AND PAR_TIPO_CONTAGEM NOT IN (3)

                                      AND T1.COD_INS = RF.COD_INS
                                      AND T1.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T1.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T1.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO <=
                                         NVL(T1.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)
                                      AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T1.FLG_TMP_ATS = 'S')
                                       OR
                                          (PAR_TIPO_CONTAGEM IN (2)   AND T1.FLG_TMP_LIC_PREM = 'S')
                                          )

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO

                                          )

                                        )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM


                               -- PERIODOS OTROS DA PANDEMIA --- 2023-08-16
                             ---- Tabela de Contagem Faltas OUTRO
                            UNION
                             SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL   RF,
                                               tb_dias_apoio         AA,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_VINCULO not in   (  '5', '6')
                                              ------------------------------------------

                                          AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                         AND RF.COD_INS           = EF.COD_INS
                                          AND RF.NUM_MATRICULA   =  EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC=  EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI    = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE   = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                          AND C.COD_INS       = EF.COD_INS
                                          AND C.COD_ENTIDADE  = EF.COD_ENTIDADE
                                          and PAR_TIPO_CONTAGEM NOT IN (3)
                                         AND AA.DATA_CALCULO BETWEEN  TO_DATE('28/05/2020','DD/MM/YYYY')  AND TO_DATE('31/12/2021','DD/MM/YYYY')
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO



                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM


                           ------------------------------
                            UNION  -- DESCONSIDERAR TEMPO PANDEMIA FORA
                             SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       T1.DES_ULT_CARGO AS NOM_CARGO,
                                                       T1.DAT_ADM_ORIG  AS DATA_INICIO,
                                                       T1.DAT_DESL_ORIG AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T1,
                                               tb_dias_apoio         AA
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                          AND RF.COD_VINCULO not in   (  '5', '6')
                                              ------------------------------------------

                                          AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                                          AND T1.COD_INS = RF.COD_INS
                                          AND T1.COD_IDE_CLI = RF.COD_IDE_CLI
                                          AND T1.FLG_EMP_PUBLICA = 'S'
                                          and PAR_TIPO_CONTAGEM NOT IN (3)
                                          AND AA.DATA_CALCULO BETWEEN  TO_DATE('28/05/2020','DD/MM/YYYY')  AND TO_DATE('31/12/2021','DD/MM/YYYY')
                                          AND ( (PAR_TIPO_CONTAGEM IN (1,9) AND T1.FLG_TMP_ATS = 'S')
                                           OR
                                              (PAR_TIPO_CONTAGEM IN (2)   AND T1.FLG_TMP_LIC_PREM = 'S')

                                              )
                                          AND (TO_DATE('28/05/2020','DD/MM/YYYY') BETWEEN T1.DAT_ADM_ORIG AND T1.DAT_DESL_ORIG
                                           OR TO_DATE('31/12/2021','DD/MM/YYYY')BETWEEN T1.DAT_ADM_ORIG AND T1.DAT_DESL_ORIG  )

                                       ) WHERE DATA_CALCULO BETWEEN DATA_INICIO AND DATA_FIM

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM



                              ------------------------------------------------------

                              UNION ALL
                              SELECT 'TODOS OS ANOS ZERADOS' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (

                                       SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                          AND RF.NUM_MATRICULA =
                                              PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (/*'22',*/ '5', '6')
                                             ----------------------------------------------------------------
                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                          AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                          AND A.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM)
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              )
                       GROUP BY /*id_contagem,*/ COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO
                       order by DATA_INICIO)

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_ATS.ID_CONTAGEM,
           PER_ATS.NUM_MATRICULA,
           PER_ATS.COD_IDE_REL_FUNC,
           PER_ATS.COD_IDE_CLI,
           PER_ATS.DATA_INICIO,
           PER_ATS.DATA_FIM,
           PER_ATS.NOM_CARGO,
           PER_ATS.QTD_BRUTO,
           PER_ATS.QTD_INCLUSAO,
           PER_ATS.QTD_LTS,
           PER_ATS.QTD_LSV,
           PER_ATS.QTD_FJ,
           PER_ATS.QTD_FI,
           PER_ATS.QTD_SUSP,
           PER_ATS.QTD_OUTRO,
           PER_ATS.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_ATS');

      --  COMMIT;
      END LOOP;

      ELSIF PAR_TIPO_CONTAGEM = 2 THEN

            PAR_INICIO_PERIODO_LP := null;

            FOR DATA_CONT_LP IN
                             (
                             SELECT MAX(LA.DAT_FIM) + 1 AS DATA_INICIO
                             FROM TB_LICENCA_AQUISITIVO LA
                             WHERE LA.COD_INS           = PAR_COD_INS
                             AND LA.COD_IDE_CLI         = PAR_COD_IDE_CLI
                             AND LA.COD_ENTIDADE        = PAR_COD_ENTIDADE
                           --  AND LA.NUM_MATRICULA       = PAR_NUM_MATRICULA
                            -- AND LA.COD_IDE_REL_FUNC    = PAR_COD_IDE_REL_FUNC
                             )
              LOOP

              PAR_INICIO_PERIODO_LP := DATA_CONT_LP.DATA_INICIO;

              EXIT;

        END LOOP;

       -- PAR_INICIO_PERIODO_LP := TO_DATE('01/03/1991','DD/MM/YYYY');

        FOR PER_LP IN (SELECT PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
/*                             CASE WHEN PAR_INICIO_PERIODO_LP IS NULL THEN DATA_INICIO ELSE
                             PAR_INICIO_PERIODO_LP END DATA_INICIO,
                             CASE WHEN PAR_INICIO_PERIODO_LP IS NULL THEN DATA_FIM ELSE
                             PAR_DAT_CONTAGEM END DATA_FIM,

                             (SELECT DISTINCT C.NOM_CARGO FROM TB_RELACAO_FUNCIONAL F INNER JOIN TB_CARGO C ON F.COD_CARGO = C.COD_CARGO WHERE AA.NUM_MATRICULA = F.NUM_MATRICULA
                             AND AA.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC)NOM_CARGO,*/

                             DATA_INICIO,
                             DATA_FIM,
                             NOM_CARGO,

                             SUM(BRUTO) QTD_BRUTO,
                             SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) QTD_LIQUIDO
                        FROM (

                              -- Tabela de Contagem  Dias da Evoluca�ao Funcional
                              ---- Dias Bruto -----
                              SELECT 'BRUTO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      ---to_char(DATA_CALCULO, 'yyyy') Ano,
                                      count(DISTINCT DATA_CALCULO) BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --AND C.COD_CARGO                   = EF.COD_CARGO
                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_FIM_EFEITO >=
                                                          C.DAT_FIM_VIG
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                                        --YUMI EM 01/05/2018: INCLU�DO PARA PEGAR V�NCULOS ANTERIORES DA RELACAO FUNCIONAL


                                      union

                                        SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                         WHERE

                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_IDE_REL_FUNC !=
                                         PAR_COD_IDE_REL_FUNC

                                      AND RF.COD_INS = EF.COD_INS
                                      AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         EF.COD_IDE_REL_FUNC
                                      AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in ( '5', '6')
                                      AND EF.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                      AND A.DATA_CALCULO <=
                                         NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                                        --Yumi em 02/05/2018: Precisa colocar a regra do v�nculo que nao considera
                                        --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                                      AND C.COD_INS = EF.COD_INS
                                      AND C.COD_ENTIDADE = EF.COD_ENTIDADE

                                      AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                               FROM  TB_TRANSF_CARGO TC
                                              WHERE TC.cod_ins = 1
                                              START WITH TC.COD_CARGO =
                                                         EF.COD_CARGO
                                                     AND TC.COD_PCCS =
                                                         EF.COD_PCCS
                                                     AND TC.COD_ENTIDADE =
                                                         EF.COD_ENTIDADE
                                                     AND EF.DAT_FIM_EFEITO >=
                                                          C.DAT_FIM_VIG
                                                     AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                             CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                         TC.COD_CARGO),
                                             EF.COD_CARGO) = C.COD_CARGO

                                        )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM


               UNION ALL
                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0,
                                     -- /*count(DISTINCT DATA_CALCULO)*/ QTDE_DIA AS Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_INI_LIC_PREM      AS DATA_INICIO,
                                                        T.DAT_FIM_LIC_PREM     AS DATA_FIM
                                                 --       T.QTD_DIAS_LIC_PREMIO AS QTDE_DIA Roberto
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_TMP_LIC_PREM = 'S'
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO > = T.DAT_INI_LIC_PREM
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 ( '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )

                               /*group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM*/

                 /* will
                              UNION ALL

                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LTS' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,

                                      0 BRUTO,
                                      0 Inclusao,
                                      count(DISTINCT DATA_CALCULO) lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (  '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 2

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE

                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem De Licencias
                              ----   Historico de Tempo
                              SELECT 'LSV' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      count(DISTINCT DATA_CALCULO) lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (  '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 1

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE

                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS - FJ' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      count(distinct data_calculo) FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              ( '5', '6')
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 3

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         data_inicio,
                                         data_fim

                              UNION ALL
                              ---- Tabela de Contagem Faltas

                              SELECT 'FALTAS -FI' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      count(DISTINCT DATA_CALCULO) FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C

                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              ( '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 4

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              ---- Tabela de Contagem Faltas SUSPENSOS

                              SELECT 'SUSP' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      --to_char(DATA_CALCULO, 'yyyy') Ano,

                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      COUNT(DISTINCT DATA_CALCULO) SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM
                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (  '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'
                                          AND MO.COD_AGRUP_AFAST = 5

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE

                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM
                              -------------------------------------------

                              UNION ALL

                              ---- Tabela de Contagem Faltas OUTRO
                              SELECT 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      COUNT(DISTINCT DATA_CALCULO) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct AA.DATA_CALCULO,
                                                       1 AS COD_INS,
                                                       1 AS TIPO_CONTAGEM,
                                                       1 AS ID_CONTAGEM,
                                                       RF.COD_ENTIDADE,
                                                       RF.COD_IDE_CLI,
                                                       RF.NUM_MATRICULA,
                                                       RF.COD_IDE_REL_FUNC,
                                                       SYSDATE AS DAT_EXECUCAO,
                                                       C.NOM_CARGO,
                                                       ef.dat_ini_efeito AS DATA_INICIO,
                                                       NVL(NVL(EF.DAT_FIM_EFEITO,
                                                               RF.DAT_FIM_EXERC),
                                                           PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                              Tb_afastamento        T,
                                              tb_dias_apoio         AA,
                                              tb_motivo_afastamento MO,
                                              TB_EVOLUCAO_FUNCIONAL EF,
                                              TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                             ---Yumi em 01/05/2018: comentado para verificar licen�a
                                             --de qualquer v�nculo da relacao funcional
                                             --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                             --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                             --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              ( '5', '6')
                                             ------------------------------------------
                                          AND RF.COD_INS = T.COD_INS
                                          AND RF.COD_IDE_CLI = T.COD_IDE_CLI
                                          AND RF.NUM_MATRICULA = T.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              T.COD_IDE_REL_FUNC
                                             ------------------------------------------
                                          AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                          AND AA.DATA_CALCULO <=
                                              PAR_DAT_CONTAGEM
                                          AND AA.DATA_CALCULO >= t.dat_ini_afast
                                          AND AA.DATA_CALCULO <=
                                              NVL(T.DAT_RET_PREV,
                                                  PAR_DAT_CONTAGEM)
                                          AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
                                          AND MO.AUMENTA_CONT_LICENCA = 'S'

                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA =
                                              EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND EF.FLG_STATUS = 'V'
                                          AND AA.DATA_CALCULO >=
                                              EF.DAT_INI_EFEITO
                                          AND AA.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE

                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                          AND NOT EXISTS
                                        (SELECT 1
                                                 FROM TB_RELACAO_FUNCIONAL  RF,
                                                      Tb_afastamento        TT,
                                                      tb_dias_apoio         A,
                                                      tb_motivo_afastamento MO
                                                WHERE RF.COD_INS = PAR_COD_INS
                                                     --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                                  AND RF.COD_VINCULO not in
                                                      ( '5', '6')
                                                     --AND RF.COD_ENTIDADE          = PAR_COD_ENTIDADE
                                                     --AND RF.NUM_MATRICULA         = PAR_NUM_MATRICULA
                                                     --AND RF.COD_IDE_REL_FUNC      = PAR_COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------
                                                      RF.COD_INS = T.COD_INS
                                                  AND RF.COD_IDE_CLI =
                                                      T.COD_IDE_CLI
                                                  AND RF.NUM_MATRICULA =
                                                      T.NUM_MATRICULA
                                                  AND RF.COD_IDE_REL_FUNC =
                                                      T.COD_IDE_REL_FUNC
                                                  AND
                                                     ------------------------------------------

                                                      TT.COD_INS = 1
                                                  AND TT.COD_IDE_CLI =
                                                      PAR_COD_IDE_CLI
                                                  AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                                  AND A.DATA_CALCULO <=
                                                      PAR_DAT_CONTAGEM
                                                  AND A.DATA_CALCULO >=
                                                      TT.dat_ini_afast
                                                  AND A.DATA_CALCULO <=
                                                      NVL(TT.DAT_RET_PREV,
                                                          PAR_DAT_CONTAGEM)
                                                  AND MO.COD_MOT_AFAST =
                                                      T.COD_MOT_AFAST
                                                  AND MO.AUMENTA_CONT_LICENCA = 'S'
                                                  AND NVL(MO.COD_AGRUP_AFAST, 0) IN
                                                      (1, 2, 3, 4, 5)
                                                  AND AA.DATA_CALCULO =
                                                      A.DATA_CALCULO

                                               )

                                       )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              union
                              ---Yumi em 01/05/2018: inclu�do para descontar os dias de descontos
                              ---relacionados ao hist�rico de tempos averbados
                              select 'OUTRO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      sum(nvl(qtd_dias_ausencia, 0)) OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (SELECT distinct t1.dat_adm_orig,
                                                        1                    AS COD_INS,
                                                        1                    AS TIPO_CONTAGEM,
                                                        1                    AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        t1.qtd_dias_ausencia,
                                                        T1.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T1.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T1.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T1,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in (  '5', '6')
                                        ------------------------------------------------------
                                      AND T1.COD_INS = RF.COD_INS
                                      AND T1.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T1.FLG_EMP_PUBLICA = 'S'
                                      AND T1.FLG_TMP_LIC_PREM = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T1.DAT_INI_LIC_PREM
                                      AND AA.DATA_CALCULO <=
                                         NVL(T1.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 ( '5', '6')
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO

                                          )

                                        )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              ------------------------------------------------------

                            ----------------------------------------------------------
                              UNION ALL
                              SELECT 'TODOS OS ANOS ZERADOS ---' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM
                                from (

                                       SELECT distinct A.DATA_CALCULO,
                                                        1 AS COD_INS,
                                                        1 AS TIPO_CONTAGEM,
                                                        1 AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        C.NOM_CARGO,
                                                        ef.dat_ini_efeito AS DATA_INICIO,
                                                        NVL(NVL(EF.DAT_FIM_EFEITO,
                                                                RF.DAT_FIM_EXERC),
                                                            PAR_DAT_CONTAGEM) AS DATA_FIM

                                         FROM TB_RELACAO_FUNCIONAL  RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               tb_dias_apoio         A,
                                               TB_CARGO              C
                                        WHERE RF.COD_INS = PAR_COD_INS
                                          AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                          AND RF.NUM_MATRICULA =
                                              PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              PAR_COD_IDE_REL_FUNC
                                             --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                          AND RF.COD_VINCULO not in
                                              (  '5', '6')
                                             ----------------------------------------------------------------
                                          AND RF.COD_INS = EF.COD_INS
                                          AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC =
                                              EF.COD_IDE_REL_FUNC
                                          AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                          AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                          AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                          AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                          AND A.DATA_CALCULO <=
                                              NVL(EF.DAT_FIM_EFEITO,
                                                  PAR_DAT_CONTAGEM)
                                          AND C.COD_INS = EF.COD_INS
                                          AND C.COD_ENTIDADE = EF.COD_ENTIDADE
                                             --AND C.COD_CARGO                   = EF.COD_CARGO
                                          AND NVL((SELECT MAX(TC.COD_CARGO_TRANSF)
                                                    FROM  TB_TRANSF_CARGO TC
                                                   WHERE TC.cod_ins = 1
                                                   START WITH TC.COD_CARGO =
                                                              EF.COD_CARGO
                                                          AND TC.COD_PCCS =
                                                              EF.COD_PCCS
                                                          AND TC.COD_ENTIDADE =
                                                              EF.COD_ENTIDADE
                                                          AND EF.DAT_FIM_EFEITO >=
                                                               C.DAT_FIM_VIG
                                                          AND EF.DAT_INI_EFEITO >= '01/03/2018'
                                                  CONNECT BY PRIOR TC.COD_CARGO_TRANSF =
                                                              TC.COD_CARGO),
                                                  EF.COD_CARGO) = C.COD_CARGO

                                       )
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM

                              UNION ALL
                              SELECT 'INCLUSAO' as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      0 Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     AS NOM_CARGO,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM

                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF.COD_VINCULO not in ( '5', '6')
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND T.FLG_TMP_LIC_PREM = 'S'
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_INI_LIC_PREM
                                      AND AA.DATA_CALCULO <= NVL(T.DAT_FIM_LIC_PREM, PAR_DAT_CONTAGEM))
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         NOM_CARGO,
                                         DATA_INICIO,
                                         DATA_FIM
 */
                              ) aa
                       GROUP BY   COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO
                       order by DATA_INICIO)


       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_LP.ID_CONTAGEM,
           PER_LP.NUM_MATRICULA,
           PER_LP.COD_IDE_REL_FUNC,
           PER_LP.COD_IDE_CLI,
           PER_LP.DATA_INICIO,
           PER_LP.DATA_FIM,
           PER_LP.NOM_CARGO,
           PER_LP.QTD_BRUTO,
           PER_LP.QTD_INCLUSAO,
           PER_LP.QTD_LTS,
           PER_LP.QTD_LSV,
           PER_LP.QTD_FJ,
           PER_LP.QTD_FI,
           PER_LP.QTD_SUSP,
           PER_LP.QTD_OUTRO,
           PER_LP.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_LP');

      --  COMMIT;
      END LOOP;



    END IF;

   -----------------------  FIM PERIODO -----------------------
   commit;
    W_NUM_REGISTRO:=1;
      FOR PERIODOS IN
       (
         SELECT
                HT.COD_IDE_CLI   as  COD_IDE_CLI,
                PAR_COD_ENTIDADE as COD_ENTIDADE,
                HT.NUM_MATRICULA                ,
                HT.COD_IDE_REL_FUNC             ,
                to_char(LENGTH(HT.DES_CARGO)) COD_REFERENCIA             ,
                LENGTH(HT.DES_CARGO) COD_CARGO ,
                /*'-1' COD_REFERENCIA             ,
                -1 COD_CARGO                    ,*/
                0 QTD_BRUTO                     ,
                0 QTD_INCLUSAO                  ,
                0 QTD_LTS                       ,
                0 QTD_LSV                       ,
                0 QTD_FJ                        ,
                0 QTD_FI                        ,
                0 QTD_SUSP                      ,
                0 QTD_OUTRO                     ,
                0 qtd_liquido                   ,
                HT.DES_CARGO   as NOM_CARGO     ,
                HT.DAT_INICIO  as DATA_INICIO   ,
                HT.DAT_FIM     as DATA_FIM
           FROM TB_CONTAGEM_SERV_PER_det HT
          WHERE HT.COD_INS     =PAR_COD_INS           AND
                HT.ID_CONTAGEM = PAR_ID_CONTAGEM      AND
                HT.INCLUSAO>0
                   AND EXISTS (
                       SELECT 1 FROM  tb_dias_apoio    AA
                                WHERE  AA.DATA_CALCULO BETWEEN  HT.DAT_INICIO AND HT.DAT_FIM
                                  AND AA.DATA_CALCULO<= PAR_DAT_CONTAGEM
                      )
       UNION ALL
       SELECT   EF.COD_IDE_CLI                 ,
                EF.COD_ENTIDADE                ,
                EF.NUM_MATRICULA               ,
                EF.COD_IDE_REL_FUNC            ,
                --EF.COD_REFERENCIA              ,
                FE.COD_NIVEL || FE.COD_GRAU  ||
                EF.COD_CARGO AS COD_REFERENCIA ,
                EF.COD_CARGO                   ,
                0 QTD_BRUTO                    ,
                0 QTD_INCLUSAO                 ,
                0 QTD_LTS                      ,
                0 QTD_LSV                      ,
                0 QTD_FJ                       ,
                0 QTD_FI                       ,
                0 QTD_SUSP                     ,
                0 QTD_OUTRO                    ,
                0 qtd_liquido                  ,
                NULL   NOM_CARGO               ,
              EF.DAT_INI_EFEITO as DATA_INICIO ,
              NVL(EF.Dat_Fim_Efeito,PAR_DAT_CONTAGEM ) as DATA_FIM


                                         FROM TB_RELACAO_FUNCIONAL   RF,
                                               TB_EVOLUCAO_FUNCIONAL EF,
                                               TB_REFERENCIA         FE
                                        WHERE RF.COD_INS          = PAR_COD_INS
                                          AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
                                          /*AND RF.NUM_MATRICULA    = PAR_NUM_MATRICULA
                                          AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC*/
                                          AND EF.COD_INS          = RF.COD_INS
                                          AND EF.COD_IDE_CLI      = RF.COD_IDE_CLI
                                          AND EF.COD_ENTIDADE     = RF.COD_ENTIDADE
                                          AND EF.NUM_MATRICULA    = RF.NUM_MATRICULA
                                          AND EF.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                                          AND EF.COD_REFERENCIA   = FE.COD_REFERENCIA
                      AND EXISTS (
                       SELECT 1 FROM  tb_dias_apoio    AA
                                WHERE  AA.DATA_CALCULO BETWEEN  EF.DAT_INI_EFEITO AND NVL(EF.DAT_FIM_EFEITO,PAR_DAT_CONTAGEM)
                                  AND AA.DATA_CALCULO<= PAR_DAT_CONTAGEM
                      )

                 ORDER BY 17 --- Data de Inicio

        )

       LOOP
        IF  W_NUM_REGISTRO     =1                     THEN
            A_DATA_INICIO      := PERIODOS.DATA_INICIO;
            A_DATA_FIM         := PERIODOS.DATA_FIM;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA;
            A_COD_IDE_CLI      := PERIODOS.COD_IDE_CLI    ;
            A_COD_ENTIDADE     := PERIODOS.COD_ENTIDADE   ;
            A_NUM_MATRICULA    := PERIODOS.NUM_MATRICULA  ;
            A_COD_IDE_REL_FUNC := PERIODOS.COD_IDE_REL_FUNC ;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA ;
            A_COD_CARGO        := PERIODOS.COD_CARGO;
            A_NOM_CARGO        := PERIODOS.NOM_CARGO;

        END IF;

        IF   A_COD_IDE_CLI        = PERIODOS.COD_IDE_CLI      AND
             A_COD_ENTIDADE       = PERIODOS.COD_ENTIDADE     AND
             A_NUM_MATRICULA      = PERIODOS.NUM_MATRICULA    AND
             A_COD_IDE_REL_FUNC   = PERIODOS.COD_IDE_REL_FUNC AND
             A_COD_REFERENCIA     = PERIODOS.COD_REFERENCIA  THEN

             A_DATA_FIM       :=PERIODOS.DATA_FIM;

         ELSE
               --- Contagem de Periodos ----

              BEGIN
                   SELECT
                       sum(pd.bruto)          bruto
                     , sum(pd.inclusao)       inclusao
                     , sum(pd.lts )           lts
                     , sum(pd.lsv)            lsv
                     , sum(pd.fj)             fj
                     , sum(pd.fi)             fi
                     , sum(pd.susp )          susp
                     , sum(pd.outros )        outros
                     , sum(pd.tempo_liquido)  tempo_liquido
                     INTO
                           PERIODOS.QTD_BRUTO   ,
                           PERIODOS.QTD_INCLUSAO,
                           PERIODOS.QTD_LTS     ,
                           PERIODOS.QTD_LSV     ,
                           PERIODOS.QTD_FJ      ,
                           PERIODOS.QTD_FI      ,
                           PERIODOS.QTD_SUSP    ,
                           PERIODOS.QTD_OUTRO   ,
                           PERIODOS.QTD_LIQUIDO

                  FROM  TB_CONTAGEM_SERV_PER_DET PD
                  WHERE PD.COD_INS     =PAR_COD_INS           AND
                        PD.ID_CONTAGEM = PAR_ID_CONTAGEM      AND
                        PD.DAT_INICIO >= A_DATA_INICIO AND
                        PD.DAT_FIM    <=NVL(A_DATA_FIM,TO_DATE('01/12/2099','DD/MM/YYYY'));
              END;
              ---- Determina Cargo -----
                IF   PERIODOS.QTD_INCLUSAO = 0  THEN
                      BEGIN
                              SELECT CA.NOM_CARGO
                                INTO PERIODOS.NOM_CARGO
                                FROM TB_CARGO CA
                               WHERE CA.COD_INS      = PAR_COD_INS
                                 AND CA.COD_ENTIDADE = PAR_COD_ENTIDADE
                                 AND CA.COD_CARGO     = A_COD_CARGO;
                              EXCEPTION WHEN OTHERS THEN PERIODOS.NOM_CARGO := NULL;
                                                         A_NOM_CARGO:=PERIODOS.NOM_CARGO;

                      END;
                ELSE
                   -- PERIODOS.NOM_CARGO:=A_NOM_CARGO;
                    SELECT DES_CARGO
                      INTO PERIODOS.NOM_CARGO
                      FROM TB_CONTAGEM_SERV_PER_DET CSP
                     WHERE CSP.COD_INS     =PAR_COD_INS
                       AND CSP.ID_CONTAGEM = PAR_ID_CONTAGEM
                       AND CSP.DAT_INICIO  = A_DATA_INICIO;
                END IF;

                   INSERT INTO TB_CONTAGEM_SERV_PERIODO
                          (COD_INS,
                           ID_CONTAGEM,
                           DAT_INICIO,
                           DAT_FIM ,
                           COD_ENTIDADE,
                           NUM_MATRICULA,
                           COD_IDE_REL_FUNC,
                           COD_IDE_CLI,
                           BRUTO,
                           INCLUSAO,
                           LTS,
                           LSV,
                           FJ,
                           FI,
                           SUSP,
                           OUTROS,
                           TEMPO_LIQUIDO,
                           DES_OBS,
                           DES_CARGO,
                           DAT_ING,
                           DAT_ULT_ATU,
                           NOM_USU_ULT_ATU,
                           NOM_PRO_ULT_ATU)
                        VALUES
                          (1,
                           PAR_ID_CONTAGEM,
                           A_DATA_INICIO,
                           A_DATA_FIM , -- PERIODOS.DATA_FIM,
                           PAR_COD_ENTIDADE,
                           PAR_NUM_MATRICULA,
                           PAR_COD_IDE_REL_FUNC,
                           PAR_COD_IDE_CLI,
                           PERIODOS.QTD_BRUTO,
                           PERIODOS.QTD_INCLUSAO,
                           PERIODOS.QTD_LTS,
                           PERIODOS.QTD_LSV,
                           PERIODOS.QTD_FJ,
                           PERIODOS.QTD_FI,
                           PERIODOS.QTD_SUSP,
                           PERIODOS.QTD_OUTRO,
                           PERIODOS.QTD_LIQUIDO,
                           NULL,
                           NVL(PERIODOS.NOM_CARGO, 'NAO INFORMADO'),
                           SYSDATE,
                           SYSDATE,
                           'CONTAGEM',
                           'SP_CONTAGEM_PERIODO'

                           );
                          A_DATA_INICIO      := PERIODOS.DATA_INICIO;
                          A_DATA_FIM         := PERIODOS.DATA_FIM;
                          A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA;
                          A_COD_IDE_CLI      := PERIODOS.COD_IDE_CLI    ;
                          A_COD_ENTIDADE     := PERIODOS.COD_ENTIDADE   ;
                          A_NUM_MATRICULA    := PERIODOS.NUM_MATRICULA  ;
                          A_COD_IDE_REL_FUNC := PERIODOS.COD_IDE_REL_FUNC ;
                          A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA ;
                          A_COD_CARGO        := PERIODOS.COD_CARGO;
                          A_NOM_CARGO        := PERIODOS.NOM_CARGO;

       END IF;


         W_NUM_REGISTRO:= W_NUM_REGISTRO+1;



      END LOOP;
      IF  W_NUM_REGISTRO >1 THEN

                  BEGIN
                   SELECT
                       sum(pd.bruto)          bruto
                     , sum(pd.inclusao)       inclusao
                     , sum(pd.lts )           lts
                     , sum(pd.lsv)            lsv
                     , sum(pd.fj)             fj
                     , sum(pd.fi)             fi
                     , sum(pd.susp )          susp
                     , sum(pd.outros )        outros
                     , sum(pd.tempo_liquido)  tempo_liquido
                     INTO
                           QTD_BRUTO
                          ,QTD_INCLUSAO
                          ,QTD_LTS
                          ,QTD_LSV
                          ,QTD_FJ
                          ,QTD_FI
                          ,QTD_SUSP
                          ,QTD_OUTRO
                          ,qtd_liquido

                  FROM  TB_CONTAGEM_SERV_PER_DET PD
                  WHERE PD.COD_INS     =PAR_COD_INS           AND
                        PD.ID_CONTAGEM = PAR_ID_CONTAGEM      AND
                        PD.DAT_INICIO >= A_DATA_INICIO        AND
                        PD.DAT_FIM    <=NVL(A_DATA_FIM,TO_DATE('01/12/2099','DD/MM/YYYY'));

              END;
              ---- Determina Cargo -----

                  BEGIN
                    SELECT  CA.NOM_CARGO
                     INTO A_NOM_CARGO
                    FROM TB_CARGO CA
                    WHERE CA.COD_INS      =PAR_COD_INS       AND
                          CA.COD_ENTIDADE =PAR_COD_ENTIDADE  AND
                          CA.COD_CARGO    =  A_COD_CARGO ;
                  EXCEPTION
                      WHEN OTHERS THEN
                         A_NOM_CARGO:=NULL;
                  END;


                    INSERT INTO TB_CONTAGEM_SERV_PERIODO
                          (COD_INS,
                           ID_CONTAGEM,
                           DAT_INICIO,
                           DAT_FIM ,
                           COD_ENTIDADE,
                           NUM_MATRICULA,
                           COD_IDE_REL_FUNC,
                           COD_IDE_CLI,
                           BRUTO,
                           INCLUSAO,
                           LTS,
                           LSV,
                           FJ,
                           FI,
                           SUSP,
                           OUTROS,
                           TEMPO_LIQUIDO,
                           DES_OBS,
                           DES_CARGO,
                           DAT_ING,
                           DAT_ULT_ATU,
                           NOM_USU_ULT_ATU,
                           NOM_PRO_ULT_ATU)
                        VALUES
                          (1,
                           PAR_ID_CONTAGEM,
                           A_DATA_INICIO,
                           PAR_DAT_CONTAGEM,  --- Fecha com data de contagem-- A_DATA_FIM
                           PAR_COD_ENTIDADE,
                           PAR_NUM_MATRICULA,
                           PAR_COD_IDE_REL_FUNC,
                           PAR_COD_IDE_CLI,
                           QTD_BRUTO
                          ,QTD_INCLUSAO
                          ,QTD_LTS
                          ,QTD_LSV
                          ,QTD_FJ
                          ,QTD_FI
                          ,QTD_SUSP
                          ,QTD_OUTRO
                          ,qtd_liquido,
                           NULL,
                           A_NOM_CARGO,
                           SYSDATE,
                           SYSDATE,
                           'CONTAGEM',
                           'SP_CONTAGEM_PERIODO'

                           );

      END if;



      FOR OBS IN (SELECT DAT_INICIO AS DATA_INICIO,
                         LISTAGG(GLS_DETALHE, chr(10)) WITHIN GROUP(ORDER BY ordem) DES_OBS

                    FROM (SELECT distinct CSO.DAT_INICIO,
                                           CASE
                                             WHEN CSO.DAT_INICIO =
                                                  T.DAT_ADM_ORIG THEN
--                                              'Cargo: ' || UPPER(cso.des_cargo) ||
                                              --chr(10) ||
                                              'Certidao n� ' ||
                                              T.NUM_CERTIDAO || /*', emissor ' ||
                                                                         (SELECT CO.DES_DESCRICAO
                                                                            FROM TB_CODIGO CO
                                                                           WHERE CO.COD_INS = 0
                                                                             AND CO.COD_NUM = 2378
                                                                             AND CO.COD_PAR = T.COD_EMISSOR) ||*/
                                              ', �rgao: ' || T.NOM_ORG_EMP /*||
                                                                         ', in�cio em ' ||
                                                                         TO_CHAR(T.DAT_ADM_ORIG, 'DD/MM/RRRR')*/
                                             /*WHEN CSO.DAT_FIM = T.DAT_DESL_ORIG THEN
                                             'Cargo:'||cso.des_cargo|| chr(10)||
                                             'Certidao n� ' || T.NUM_CERTIDAO || ', emissor ' ||
                                             (SELECT CO.DES_DESCRICAO
                                                FROM TB_CODIGO CO
                                               WHERE CO.COD_INS = 0
                                                 AND CO.COD_NUM = 2378
                                                 AND CO.COD_PAR = T.COD_EMISSOR) ||
                                             ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                                             ', fim em ' ||
                                             TO_CHAR(T.DAT_DESL_ORIG, 'DD/MM/RRRR')*/
                                              || '.'

                                           END GLS_DETALHE,
                                           1 AS ORDEM

                             FROM TB_RELACAO_FUNCIONAL     RF,
                                  Tb_Hist_Carteira_Trab    T,
                                  tb_contagem_serv_periodo CSO,
                                  TB_CONTAGEM_SERVIDOR     CON
                            WHERE RF.COD_INS = CON.COD_INS
                              AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                              AND RF.COD_ENTIDADE = CON.COD_ENTIDADE
                              AND RF.NUM_MATRICULA = CON.NUM_MATRICULA
                              AND RF.COD_IDE_REL_FUNC = CON.COD_IDE_REL_FUNC
                              AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                              AND CON.ID_CONTAGEM = CSO.ID_CONTAGEM

                                 ------------------------------------------------------
                              AND T.COD_INS = RF.COD_INS
                              AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                              AND T.FLG_EMP_PUBLICA = 'S'

                              AND (CSO.DAT_INICIO = T.DAT_ADM_ORIG OR
                                  CSO.DAT_FIM = NVL(T.DAT_DESL_ORIG, SYSDATE))
                              AND NOT EXISTS
                            (

                                   SELECT 1
                                     FROM TB_RELACAO_FUNCIONAL  RF1,
                                           TB_EVOLUCAO_FUNCIONAL EF1,
                                           tb_dias_apoio         A
                                    WHERE RF1.COD_INS = 1
                                      AND RF1.COD_IDE_CLI = RF.COD_IDE_CLI
                                         --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                         ---com qualquer v�nculo que exista na relacao funcional
                                         ---AND RF.COD_ENTIDADE               = &PAR_COD_ENTIDADE
                                         --AND RF.NUM_MATRICULA              = &PAR_NUM_MATRICULA
                                         ---AND RF.COD_IDE_REL_FUNC           = &PAR_COD_IDE_REL_FUNC
                                      AND RF1.COD_INS = EF1.COD_INS
                                      AND RF1.NUM_MATRICULA = EF1.NUM_MATRICULA
                                      AND RF1.COD_IDE_REL_FUNC =
                                          EF1.COD_IDE_REL_FUNC
                                      AND RF1.COD_IDE_CLI = EF1.COD_IDE_CLI
                                      AND RF1.COD_ENTIDADE = EF1.COD_ENTIDADE
                                         --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                      AND RF1.COD_VINCULO not in
                                          (/*'22',*/ '5', '6')
                                      AND EF1.FLG_STATUS = 'V'
                                      AND A.DATA_CALCULO <= CON.DAT_CONTAGEM
                                      AND A.DATA_CALCULO >= EF1.DAT_INI_EFEITO
                                         ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                         --entre per�odos de v�nculos
                                         --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                      AND A.DATA_CALCULO <=
                                          NVL(RF1.DAT_FIM_EXERC,
                                              CON.DAT_CONTAGEM)
                                      AND CSO.DAT_INICIO = A.DATA_CALCULO
                                      AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                   )

                           UNION ALL
                           --------------------------------------------------
                           -- Detalhe de Rela�ao Funcional
                           --------------------------------------------------
                           SELECT CSO.DAT_INICIO,
                                  CASE WHEN RF.DAT_FIM_EXERC IS NULL THEN
                              --    'Cargo: ' || CSO.DES_CARGO || CHR(10) ||
                                  LISTAGG((

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2140
                                               AND CO.COD_PAR =
                                                   EF.COD_MOT_EVOL_FUNC) || ' - ' ||
                                         /*  'para ' ||
                                           (SELECT CAR.NOM_CARGO
                                              FROM TB_CARGO CAR
                                             WHERE CAR.COD_INS = 1
                                               AND CAR.COD_ENTIDADE =
                                                   EF.COD_ENTIDADE
                                               AND CAR.COD_PCCS = EF.COD_PCCS
                                               AND CAR.COD_CARREIRA =
                                                   EF.COD_CARREIRA
                                               AND CAR.COD_CARGO = EF.COD_CARGO) || ' ' ||
                                           'a partir de ' ||
                                           to_char(EF.DAT_INI_EFEITO,
                                                   'dd/mm/yyyy') || '. ' ||*/
                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   EF.COD_TIPO_DOC_ASSOC) ||
                                           ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                           'Publica��o em ' || ef.dat_pub || '.'

                                          )
                                          ,
                                          chr(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO)

                                          WHEN RF.DAT_FIM_EXERC IS NOT NULL AND CSO.DAT_FIM = RF.DAT_FIM_EXERC THEN
                              --    'Cargo: ' || CSO.DES_CARGO || CHR(10) ||
                                   LISTAGG((

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2140
                                               AND CO.COD_PAR =
                                                   EF.COD_MOT_EVOL_FUNC) || ' ' ||
                                         /*  'para ' ||
                                           (SELECT CAR.NOM_CARGO
                                              FROM TB_CARGO CAR
                                             WHERE CAR.COD_INS = 1
                                               AND CAR.COD_ENTIDADE =
                                                   EF.COD_ENTIDADE
                                               AND CAR.COD_PCCS = EF.COD_PCCS
                                               AND CAR.COD_CARREIRA =
                                                   EF.COD_CARREIRA
                                               AND CAR.COD_CARGO = EF.COD_CARGO) || ' ' ||
                                           'a partir de ' ||
                                           to_char(EF.DAT_INI_EFEITO,
                                                   'dd/mm/yyyy') || '. ' ||*/
                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   EF.COD_TIPO_DOC_ASSOC) ||
                                           ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                           'Publica��o em ' || ef.dat_pub || '. ' ||
                                           chr(10)||

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2020
                                               AND CO.COD_PAR =
                                                   RF.COD_MOT_DESLIG) || ' - ' ||
                                        /* 'em '|| RF.DAT_FIM_EXERC || ' - ' ||*/

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   RF.COD_TIPO_DOC_ASSOC_FIM) ||
                                           ' n� ' || RF.NUM_DOC_ASSOC_FIM || '. ' ||
                                           'Publica��o em ' || RF.Dat_Pub_Fim_Exerc || '. '
                                           )
                                          ,
                                          chr(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO)

                                          WHEN RF.DAT_FIM_EXERC IS NOT NULL AND RF.DAT_FIM_EXERC != EF.DAT_FIM_EFEITO THEN
                              --    'Cargo: ' || CSO.DES_CARGO || CHR(10) ||
                                  LISTAGG((

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2140
                                               AND CO.COD_PAR =
                                                   EF.COD_MOT_EVOL_FUNC) || ' - ' ||
                                         /*  'para ' ||
                                           (SELECT CAR.NOM_CARGO
                                              FROM TB_CARGO CAR
                                             WHERE CAR.COD_INS = 1
                                               AND CAR.COD_ENTIDADE =
                                                   EF.COD_ENTIDADE
                                               AND CAR.COD_PCCS = EF.COD_PCCS
                                               AND CAR.COD_CARREIRA =
                                                   EF.COD_CARREIRA
                                               AND CAR.COD_CARGO = EF.COD_CARGO) || ' ' ||
                                           'a partir de ' ||
                                           to_char(EF.DAT_INI_EFEITO,
                                                   'dd/mm/yyyy') || '. ' ||*/
                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   EF.COD_TIPO_DOC_ASSOC) ||
                                           ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                           'Publica��o em ' || ef.dat_pub || '.'

                                          )
                                          ,
                                          chr(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO)

                                          else
                                            LISTAGG((

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2140
                                               AND CO.COD_PAR =
                                                   EF.COD_MOT_EVOL_FUNC) || ' ' ||
                                         /*  'para ' ||
                                           (SELECT CAR.NOM_CARGO
                                              FROM TB_CARGO CAR
                                             WHERE CAR.COD_INS = 1
                                               AND CAR.COD_ENTIDADE =
                                                   EF.COD_ENTIDADE
                                               AND CAR.COD_PCCS = EF.COD_PCCS
                                               AND CAR.COD_CARREIRA =
                                                   EF.COD_CARREIRA
                                               AND CAR.COD_CARGO = EF.COD_CARGO) || ' ' ||
                                           'a partir de ' ||
                                           to_char(EF.DAT_INI_EFEITO,
                                                   'dd/mm/yyyy') || '. ' ||*/
                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   EF.COD_TIPO_DOC_ASSOC) ||
                                           ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                           'Publica��o em ' || ef.dat_pub || '. ' ||
                                           chr(10)||

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2020
                                               AND CO.COD_PAR =
                                                   RF.COD_MOT_DESLIG) || ' - ' ||
                                        /* 'em '|| RF.DAT_FIM_EXERC || ' - ' ||*/

                                           (SELECT CO.DES_DESCRICAO
                                              FROM TB_CODIGO CO
                                             WHERE CO.COD_INS = 0
                                               AND CO.COD_NUM = 2019
                                               AND CO.COD_PAR =
                                                   RF.COD_TIPO_DOC_ASSOC_FIM) ||
                                           ' n� ' || RF.NUM_DOC_ASSOC_FIM || '. ' ||
                                           'Publica��o em ' || RF.Dat_Pub_Fim_Exerc || '. '
                                           )
                                          ,
                                          chr(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO)

                                            end GLS_DETALHE,
                                  1 as ordem

                             FROM TB_RELACAO_FUNCIONAL     RF,
                                  TB_EVOLUCAO_FUNCIONAL    EF,
                                  tb_contagem_serv_periodo CSO,
                                  TB_CONTAGEM_SERVIDOR     CON
                            WHERE
                           --------------------------------------------------------
                            RF.COD_INS = CON.COD_INS
                         AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                           --da relacao funcional
                           --AND RF.COD_ENTIDADE     = &PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA    = &PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = &PAR_COD_IDE_REL_FUNC
                           -----------------------------------------------------------

                         AND RF.COD_INS = EF.COD_INS
                         AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                         AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                         AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                         AND EF.FLG_STATUS = 'V'
                         /*AND ((CSO.DAT_INICIO = EF.DAT_INI_EFEITO) OR
                            (CSO.DAT_INICIO < EF.DAT_INI_EFEITO AND
                            NVL(EF.DAT_FIM_EFEITO, CON.DAT_FIM) <=
                            CSO.DAT_FIM AND
                            EF.COD_CARGO IN*/
                         AND (CSO.DAT_INICIO <= EF.DAT_FIM_EFEITO OR EF.DAT_FIM_EFEITO IS NULL)
                         AND ((CSO.DAT_INICIO >= EF.DAT_INI_EFEITO) OR
                            (CSO.DAT_INICIO < EF.DAT_INI_EFEITO AND
                            NVL(EF.DAT_FIM_EFEITO, CON.DAT_FIM) <=
                            CSO.DAT_FIM AND
                            EF.COD_CARGO IN
                            (SELECT TC.COD_CARGO_TRANSF
                                 FROM TB_TRANSF_CARGO TC INNER JOIN TB_CARGO CAR ON TC.COD_CARGO_TRANSF = CAR.COD_CARGO
                                WHERE TC.COD_INS = EF.COD_INS
                                  AND TC.COD_ENTIDADE = EF.COD_ENTIDADE
                                  AND TC.COD_PCCS = EF.COD_PCCS
                                  AND EF.DAT_INI_EFEITO >= CAR.DAT_INI_VIG) AND
                            EF.DAT_INI_EFEITO =
                            (SELECT MIN(EF1.DAT_INI_EFEITO)
                                 FROM TB_EVOLUCAO_FUNCIONAL EF1
                                WHERE EF1.COD_INS = 1
                                  AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                                  AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                                  AND EF1.COD_IDE_REL_FUNC =
                                      EF.COD_IDE_REL_FUNC
                                  AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                                  AND EF1.COD_CARGO = EF.COD_CARGO
                                  AND EF1.FLG_STATUS = EF.FLG_STATUS)))
                         AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                         AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
                            GROUP BY CSO.DAT_INICIO, CSO.DES_CARGO, RF.DAT_FIM_EXERC, EF.DAT_FIM_EFEITO, CSO.DAT_FIM
                           --------------------------------------------------
                           -- Detalhe de Cargo Comissionado
                           --------------------------------------------------

                           /*UNION ALL
                           SELECT distinct CSO.DAT_INICIO,
                                           LISTAGG(((SELECT CO.DES_DESCRICAO
                                                       FROM TB_CODIGO CO
                                                      WHERE CO.COD_INS = 0
                                                        AND CO.COD_NUM = 2401
                                                        AND CO.COD_PAR =
                                                            EF.COD_MOT_EVOL_FUNC) || ' ' ||
                                                   'para ' ||
                                                   (SELECT CAR.NOM_CARGO
                                                       FROM TB_CARGO CAR
                                                      WHERE CAR.COD_INS = 1
                                                        AND CAR.COD_ENTIDADE =
                                                            EF.COD_ENTIDADE
                                                        AND CAR.COD_PCCS =
                                                            EF.COD_PCCS
                                                        AND CAR.COD_CARREIRA =
                                                            EF.COD_CARREIRA
                                                        AND CAR.COD_QUADRO =
                                                            EF.COD_QUADRO
                                                        AND CAR.COD_CLASSE =
                                                            EF.COD_CLASSE
                                                        AND CAR.COD_CARGO =
                                                            EF.COD_CARGO_COMP) ||
                                                   ' a partir de ' ||
                                                   to_char(EF.DAT_INI_EFEITO,
                                                            'dd/mm/yyyy') ||
                                                   ' at� ' ||
                                                   NVL(to_char(EF.DAT_FIM_EFEITO,
                                                                'dd/mm/yyyy'),
                                                        'a presente data') || '. ' ||
                                                   (SELECT CO.DES_DESCRICAO
                                                       FROM TB_CODIGO CO
                                                      WHERE CO.COD_INS = 0
                                                        AND CO.COD_NUM = 2019
                                                        AND CO.COD_PAR =
                                                            EF.COD_TIPO_DOC_ASSOC) ||
                                                   ' n� ' || EF.NUM_DOC_ASSOC || '. ' ||
                                                   'Publica��o em ' ||
                                                   ef.dat_pub || '.'),
                                                   CHR(10)) WITHIN GROUP(ORDER BY EF.DAT_INI_EFEITO)

                                           GLS_DETALHE,
                                           2 as ordem

                             FROM TB_RELACAO_FUNCIONAL      RF,
                                  TB_EVOLU_CCOMI_GFUNCIONAL EF,
                                  TB_CONTAGEM_SERV_PERIODO  CSO,
                                  TB_CONTAGEM_SERVIDOR      CON
                            WHERE
                           --------------------------------------------------------
                            RF.COD_INS = CON.COD_INS
                         AND RF.COD_IDE_CLI = CON.COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                           --da relacao funcional
                           --AND RF.COD_ENTIDADE     = &PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA    =  &PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = &PAR_COD_IDE_REL_FUNC
                           -----------------------------------------------------------

                         AND RF.COD_INS = EF.COD_INS
                         AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                         AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                         AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                         AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                         AND (EF.DAT_INI_EFEITO BETWEEN CSO.DAT_INICIO AND
                            CSO.DAT_FIM
                         or CSO.DAT_INICIO BETWEEN EF.DAT_INI_EFEITO AND
                          NVL(EF.DAT_FIM_EFEITO, CSO.DAT_INICIO))
                         AND CSO.ID_CONTAGEM = PAR_ID_CONTAGEM
                         AND CSO.ID_CONTAGEM = CON.ID_CONTAGEM
                            GROUP BY CSO.DAT_INICIO*/

                           ) YY

                   WHERE GLS_DETALHE IS NOT NULL
                   GROUP BY DAT_INICIO)

       LOOP
        UPDATE TB_CONTAGEM_SERV_PERIODO CON
           SET CON.DES_OBS = OBS.DES_OBS
         WHERE CON.ID_CONTAGEM = PAR_ID_CONTAGEM
           AND CON.DAT_INICIO = OBS.DATA_INICIO;
       -- COMMIT;
      END LOOP;

    END;
  END;
PROCEDURE ATUALIZA_HEAD_CONTAGEN_NC(SEQ_CERTIDAO IN NUMBER) IS
    D_DIAS  NUMBER;
    D_MESES NUMBER;
    D_ANOS  NUMBER;

  BEGIN

    IF PAR_TIPO_CONTAGEM != 3 THEN

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS_BRUTO =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO)
                FROM TB_CONTAGEM_SERV_PER_DET CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.NUM_DIAS_DESC =
             (SELECT SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0)) + SUM(nvl(FJ, 0)) +
                     SUM(nvl(FI, 0)) + SUM(CSD.SUSP) +
                     SUM(nvl(CSD.OUTROS, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),

             CS.NUM_DIAS_LIQ =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO) -
                     (SUM(nvl( CSD.LTS, 0)) + SUM(nvl(CSD.LSV, 0)) + SUM(nvl(CSD.FJ, 0)) +
                      SUM(nvl(CSD.FI, 0)) + SUM(CSD.SUSP) +
                      SUM(nvl(CSD.OUTROS, 0)))
                FROM  TB_CONTAGEM_SERV_PER_DET CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.DAT_INICIO  =
             (SELECT NVL(PAR_INICIO_PERIODO_LP,MIN(EF.DAT_INI_EFEITO))
                FROM TB_RELACAO_FUNCIONAL  RF,
                     TB_EVOLUCAO_FUNCIONAL EF,
                     tb_dias_apoio         A
               WHERE RF.COD_INS = PAR_COD_INS
                 AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                    --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                    --da relacao funcional
                    --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                    --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                    --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                    ----------------------------------------------------------------
                 AND RF.COD_INS = EF.COD_INS
                 AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                 AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                 AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                 AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                 AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE))
                 ,
             CS.DAT_FIM =  CASE
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) >
                                             PAR_DAT_CONTAGEM THEN
                                         PAR_DAT_CONTAGEM

                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) <=
                                             PAR_DAT_CONTAGEM THEN
                                         (SELECT RF.DAT_FIM_EXERC
                                            FROM TB_RELACAO_FUNCIONAL RF
                                           WHERE RF.COD_INS = PAR_COD_INS
                                             AND RF.COD_IDE_CLI =
                                                 PAR_COD_IDE_CLI
                                             AND RF.COD_ENTIDADE =
                                                 PAR_COD_ENTIDADE
                                             AND RF.NUM_MATRICULA =
                                                 PAR_NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 PAR_COD_IDE_REL_FUNC)
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NULL THEN
                                         PAR_DAT_CONTAGEM
                                      END,

             CS.DAT_CONTAGEM         = PAR_DAT_CONTAGEM,
             CS.NUM_DIAS_FALTAS     =
             (SELECT SUM(nvl(FJ, 0)) + SUM(nvl(FI, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_LICENCAS   =
             (SELECT SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_PENALIDADES =
             (SELECT SUM(CSD.SUSP)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.NUM_DIAS_OUTROS =
             (SELECT SUM(CSD.OUTROS)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARGO =
             (SELECT SUM(CSD.TEMPO_LIQ_CARGO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARREIRA    =
             (SELECT SUM(CSD.TEMPO_LIQ_CARREIRA)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.TEMPO_LIQ_SERV_PUBLICO =
             (SELECT SUM(CSD.TEMPO_LIQ_SERV_PUBLICO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO)

       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;
      commit;
      -------------------- Conta Anos , Mes e  Dias -------------------------

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_ANOS  = TRUNC(CS.NUM_DIAS_LIQ / 365),
             CS.NUM_MESES = TRUNC((CS.NUM_DIAS_LIQ -
                                  (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667),
             CS.NUM_DIAS =
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) -
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667) * 30.41667)
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      -----------Ajusta  Conta Anos , Mes e  Dias -------------------------
      D_DIAS  := 0;
      D_MESES := 0;
      D_ANOS  := 0;
      SELECT CS.NUM_DIAS, CS.NUM_MESES, CS.NUM_ANOS
        INTO D_DIAS, D_MESES, D_ANOS
        FROM TB_CONTAGEM_SERVIDOR CS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      IF D_DIAS >= 30 THEN
        D_DIAS  := D_DIAS - 30;
        D_MESES := D_MESES + 1;
      END IF;
      IF D_MESES >= 12 THEN
        D_MESES := D_MESES - 12;
        D_ANOS  := D_ANOS + 1;
      END IF;

      IF PAR_COD_IDE_CLI = 1012936 AND D_DIAS = 13 THEN
        D_DIAS := 15;
        END IF;

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS  = D_DIAS,
             CS.NUM_MESES = D_MESES,
             CS.NUM_ANOS  = D_ANOS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;
    ELSE

      /*UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.DAT_INICIO      = NVL(PAR_INICIO_ORIG,
                                      PAR_INICIO_PERIODO_ADQ),
             CS.DAT_FIM         = PAR_FIM_PERIODO_ADQ,
             CS.NUM_DIAS_LIQ    = DIAS_FERIAS_SERVIDOR,
             CS.NUM_DIAS_FALTAS = QTD_DIAS_FALTAS,
             CS.NUM_DIAS_BRUTO  = QTD_DIAS_TRABALHADO,
             CS.DES_OBS = (CASE
                            WHEN QTD_DIAS_TRABALHADO < 365 THEN
                             'Total de dias faltantes do per�odo aquisitivo de f�rias : ' ||
                             to_char(365 - QTD_DIAS_TRABALHADO)

                            ELSE
                             ' '
                          END)
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;*/

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS_BRUTO =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO)
                FROM TB_CONTAGEM_SERV_PER_DET CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.NUM_DIAS_DESC =
             (SELECT /*SUM(nvl(LTS, 0)) +*/ SUM(nvl(LSV, 0)) + SUM(nvl(FJ, 0)) +
                     SUM(nvl(FI, 0)) + SUM(CSD.SUSP) +
                     SUM(nvl(CSD.OUTROS, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),

             CS.NUM_DIAS_LIQ =
             (SELECT SUM(CSD.BRUTO) + SUM(CSD.INCLUSAO) -
                     (/*SUM(nvl( CSD.LTS, 0)) +*/ SUM(nvl(CSD.LSV, 0)) + SUM(nvl(CSD.FJ, 0)) +
                      SUM(nvl(CSD.FI, 0)) + SUM(CSD.SUSP) +
                      SUM(nvl(CSD.OUTROS, 0)))
                FROM  TB_CONTAGEM_SERV_PER_DET CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO

              ),
             CS.DAT_INICIO  =
             (SELECT NVL(PAR_INICIO_PERIODO_LP,MIN(EF.DAT_INI_EFEITO))
                FROM TB_RELACAO_FUNCIONAL  RF,
                     TB_EVOLUCAO_FUNCIONAL EF,
                     tb_dias_apoio         A
               WHERE RF.COD_INS = PAR_COD_INS
                 AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                    --Yumi em 01/05/2018: comentado para pegar todos os v�nculos
                    --da relacao funcional
                    --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                    --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                    --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                    ----------------------------------------------------------------
                 AND RF.COD_INS = EF.COD_INS
                 AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                 AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                 AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                 AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                 AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                 AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                 AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE))
                 ,
             CS.DAT_FIM =  CASE
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) >
                                             PAR_DAT_CONTAGEM THEN
                                         PAR_DAT_CONTAGEM

                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NOT NULL AND
                                             (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) <=
                                             PAR_DAT_CONTAGEM THEN
                                         (SELECT RF.DAT_FIM_EXERC
                                            FROM TB_RELACAO_FUNCIONAL RF
                                           WHERE RF.COD_INS = PAR_COD_INS
                                             AND RF.COD_IDE_CLI =
                                                 PAR_COD_IDE_CLI
                                             AND RF.COD_ENTIDADE =
                                                 PAR_COD_ENTIDADE
                                             AND RF.NUM_MATRICULA =
                                                 PAR_NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 PAR_COD_IDE_REL_FUNC)
                                        WHEN (SELECT RF.DAT_FIM_EXERC
                                                FROM TB_RELACAO_FUNCIONAL RF
                                               WHERE RF.COD_INS = PAR_COD_INS
                                                 AND RF.COD_IDE_CLI =
                                                     PAR_COD_IDE_CLI
                                                 AND RF.COD_ENTIDADE =
                                                     PAR_COD_ENTIDADE
                                                 AND RF.NUM_MATRICULA =
                                                     PAR_NUM_MATRICULA
                                                 AND RF.COD_IDE_REL_FUNC =
                                                     PAR_COD_IDE_REL_FUNC) IS NULL THEN
                                         PAR_DAT_CONTAGEM
                                      END,

             CS.DAT_CONTAGEM         = PAR_DAT_CONTAGEM,
             CS.NUM_DIAS_FALTAS     =
             (SELECT SUM(nvl(FJ, 0)) + SUM(nvl(FI, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_LICENCAS   =
             (SELECT SUM(nvl(LTS, 0)) + SUM(nvl(LSV, 0))
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.NUM_DIAS_PENALIDADES =
             (SELECT SUM(CSD.SUSP)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.NUM_DIAS_OUTROS =
             (SELECT SUM(CSD.OUTROS)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARGO =
             (SELECT SUM(CSD.TEMPO_LIQ_CARGO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),

             CS.TEMPO_LIQ_CARREIRA    =
             (SELECT SUM(CSD.TEMPO_LIQ_CARREIRA)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO),
             CS.TEMPO_LIQ_SERV_PUBLICO =
             (SELECT SUM(CSD.TEMPO_LIQ_SERV_PUBLICO)
                FROM TB_CONTAGEM_SERV_ANO CSD
               WHERE CSD.COD_INS = PAR_COD_INS
                 AND CSD.ID_CONTAGEM = SEQ_CERTIDAO)

       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;
      commit;
      -------------------- Conta Anos , Mes e  Dias -------------------------

      UPDATE TB_CONTAGEM_SERVIDOR
         SET NUM_DIAS_LIQ  = 1315
       WHERE COD_IDE_CLI   = 1000032125  AND
             NUM_MATRICULA = 587         AND
             DAT_INICIO    = '05/07/2018';
       COMMIT;





      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_ANOS  = TRUNC(CS.NUM_DIAS_LIQ / 365),
             CS.NUM_MESES = TRUNC((CS.NUM_DIAS_LIQ -
                                  (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667),
             CS.NUM_DIAS =
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) -
             TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ / 365) * 365)) / 30.41667) * 30.41667)
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      -----------Ajusta  Conta Anos , Mes e  Dias -------------------------
      D_DIAS  := 0;
      D_MESES := 0;
      D_ANOS  := 0;
      SELECT CS.NUM_DIAS, CS.NUM_MESES, CS.NUM_ANOS
        INTO D_DIAS, D_MESES, D_ANOS
        FROM TB_CONTAGEM_SERVIDOR CS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

      IF D_DIAS >= 30 THEN
        D_DIAS  := D_DIAS - 30;
        D_MESES := D_MESES + 1;
      END IF;
      IF D_MESES >= 12 THEN
        D_MESES := D_MESES - 12;
        D_ANOS  := D_ANOS + 1;
      END IF;

      UPDATE TB_CONTAGEM_SERVIDOR CS
         SET CS.NUM_DIAS  = D_DIAS,
             CS.NUM_MESES = D_MESES,
             CS.NUM_ANOS  = D_ANOS
       WHERE CS.COD_INS = PAR_COD_INS
         AND CS.ID_CONTAGEM = SEQ_CERTIDAO
         AND CS.COD_IDE_CLI = PAR_COD_IDE_CLI;

    END IF;

  END ATUALIZA_HEAD_CONTAGEN_NC;

----------------------------------------------



  PROCEDURE SP_CONTAGEM_PERIODO_AGRUP_CERT (I_SEQ_CERTIDAO IN NUMBER) AS
    PAR_ID_CONTAGEM      NUMBER;
    PAR_COD_ENTIDADE     NUMBER;
    PAR_NUM_MATRICULA    VARCHAR2(20);
    PAR_COD_IDE_REL_FUNC NUMBER;
    PAR_COD_IDE_CLI      VARCHAR2(20);
    DAT_CONTAGEM         DATE;
    PAR_COD_INS          NUMBER;
    PAR_TIPO_CONTAGEM     NUMBER;
    V_DATA_INICIO        DATE;
    V_DES_OBS            VARCHAR2(500);
    oErrorCode           number := 0;
    oErrorMessage        varchar2(20) := null;
    PAR_INICIO_PERIODO_LP   DATE:= null;


    A_COD_IDE_CLI        TB_CONTAGEM_SERV_PERIODO.COD_IDE_CLI%TYPE;
    A_COD_ENTIDADE       TB_CONTAGEM_SERV_PERIODO.COD_ENTIDADE%TYPE;
    A_NUM_MATRICULA      TB_CONTAGEM_SERV_PERIODO.NUM_MATRICULA%TYPE;
    A_COD_IDE_REL_FUNC   TB_CONTAGEM_SERV_PERIODO.COD_IDE_REL_FUNC%TYPE;
    A_COD_REFERENCIA     TB_EVOLUCAO_FUNCIONAL.COD_REFERENCIA%TYPE;
    A_DATA_INICIO        DATE;
    A_DATA_FIM           DATE;
    W_NUM_REGISTRO       NUMBER;
    A_COD_CARGO          NUMBER;
    A_NUM_CNPJ           VARCHAR2(200);
    A_NOM_ORG_EMP        VARCHAR2(200);
    QTD_BRUTO            NUMBER;
    QTD_INCLUSAO         NUMBER;
    QTD_LTS              NUMBER;
    QTD_LSV              NUMBER;
    QTD_FJ               NUMBER;
    QTD_FI               NUMBER;
    QTD_SUSP             NUMBER;
    QTD_OUTRO            NUMBER;
    qtd_liquido          NUMBER;



  BEGIN

    DELETE FROM TB_CONTAGEM_SERV_PER_DET A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;
    DELETE FROM TB_CONTAGEM_SERV_PERIODO A
     WHERE A.ID_CONTAGEM = I_SEQ_CERTIDAO;

    begin

      SELECT CO.ID_CONTAGEM,
             CO.COD_ENTIDADE,
             CO.NUM_MATRICULA,
             CO.COD_IDE_REL_FUNC,
             CO.COD_IDE_CLI,
             CO.DAT_CONTAGEM,
             CO.COD_INS,
             CO.TIPO_CONTAGEM

        INTO PAR_ID_CONTAGEM,
             PAR_COD_ENTIDADE,
             PAR_NUM_MATRICULA,
             PAR_COD_IDE_REL_FUNC,
             PAR_COD_IDE_CLI,
             par_DAT_CONTAGEM,
             PAR_COD_INS,
             PAR_TIPO_CONTAGEM
        FROM TB_CONTAGEM_SERVIDOR CO
       WHERE CO.ID_CONTAGEM = I_SEQ_CERTIDAO;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        par_cod_ide_rel_func := null;
        par_cod_entidade     := null;
        par_cod_ide_cli      := null;
        par_num_matricula    := null;
        par_id_contagem      := null;
        par_dat_contagem     := NULL;
    END;

    begin

    IF (PAR_TIPO_CONTAGEM = 10) THEN
      FOR PER_ATS IN (SELECT PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
                             DATA_INICIO,
                             DATA_FIM,
                             NOM_CARGO,

                             SUM(BRUTO) QTD_BRUTO,
                             SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) QTD_LIQUIDO
                        FROM (

                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'BRUTO'  as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      count(DISTINCT DATA_CALCULO)  Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      0 OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct AA.DATA_CALCULO,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'N'
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )

                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM





                )    GROUP BY   COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO
                       order by DATA_INICIO

             )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_ATS.ID_CONTAGEM,
           PER_ATS.NUM_MATRICULA,
           PER_ATS.COD_IDE_REL_FUNC,
           PER_ATS.COD_IDE_CLI,
           PER_ATS.DATA_INICIO,
           PER_ATS.DATA_FIM,
           PER_ATS.NOM_CARGO,
           PER_ATS.QTD_BRUTO,
           PER_ATS.QTD_INCLUSAO,
           PER_ATS.QTD_LTS,
           PER_ATS.QTD_LSV,
           PER_ATS.QTD_FJ,
           PER_ATS.QTD_FI,
           PER_ATS.QTD_SUSP,
           PER_ATS.QTD_OUTRO,
           PER_ATS.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_ATS');

     --  COMMIT;
      END LOOP;


    END IF;


    IF (PAR_TIPO_CONTAGEM = 12) THEN
      FOR PER_ATS IN (SELECT DISTINCT
                             PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
                             DATA_INICIO,
                             DATA_FIM,
                             NOM_CARGO,

                             (BRUTO) QTD_BRUTO,
                             (Inclusao) QTD_INCLUSAO,
                             (LTS) QTD_LTS,
                             (LSV) QTD_LSV,
                             (FJ) QTD_FJ,
                             (FI) QTD_FI,
                             (SUSP) QTD_SUSP,
                             (OUTRO) QTD_OUTRO,
                             ((nvl(BRUTO, 0)) + (nvl(Inclusao, 0)) -
                             (nvl(LTS, 0)) - (nvl(LSV, 0)) -
                             (nvl(FJ, 0)) - (nvl(FI, 0)) -
                             (nvl(OUTRO, 0))) QTD_LIQUIDO

                             /*SUM(BRUTO) QTD_BRUTO,
                             SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) QTD_LIQUIDO*/
                        FROM (

                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'BRUTO'  as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      /*count(DISTINCT DATA_CALCULO)*/ QTDE_DIA AS Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      QTD_DIAS_AUSENCIA OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct T.DAT_ADM_ORIG,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM,
                                                        QTD_DIAS_AUSENCIA,
                                                        T.QTD_TMP_LIQ_DIA_TOTAL AS QTDE_DIA
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )
/*
                               group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM,
                                         QTD_DIAS_AUSENCIA*/





                )    /*GROUP BY   COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO*/
                       order by DATA_INICIO

             )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_ATS.ID_CONTAGEM,
           PER_ATS.NUM_MATRICULA,
           PER_ATS.COD_IDE_REL_FUNC,
           PER_ATS.COD_IDE_CLI,
           PER_ATS.DATA_INICIO,
           PER_ATS.DATA_FIM,
           PER_ATS.NOM_CARGO,
           PER_ATS.QTD_BRUTO,
           PER_ATS.QTD_INCLUSAO,
           PER_ATS.QTD_LTS,
           PER_ATS.QTD_LSV,
           PER_ATS.QTD_FJ,
           PER_ATS.QTD_FI,
           PER_ATS.QTD_SUSP,
           PER_ATS.QTD_OUTRO,
           PER_ATS.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_ATS');

     --  COMMIT;
      END LOOP;


    END IF;


    IF (PAR_TIPO_CONTAGEM = 13) THEN
      FOR PER_ATS IN (SELECT PAR_ID_CONTAGEM as id_contagem,
                             COD_IDE_CLI,
                             NUM_MATRICULA,
                             COD_IDE_REL_FUNC,
                             DATA_INICIO,
                             DATA_FIM,
                             NOM_CARGO,

                             SUM(BRUTO) QTD_BRUTO,
                             CASE WHEN COD_IDE_CLI = 1012840 AND DATA_FIM = '10/10/2023' -- SOLICITA��O PEDRO/RENATA PARA FICAR IGUAL A CERTID�O PMC 06/12/2023
                                        THEN sum( Inclusao) -1
                                        --when COD_IDE_CLI = 1008200 and NOM_CARGO = 'OFICIAL DE PROMOTORIA I' then 463
                                        when COD_IDE_CLI = 1008200 and NOM_CARGO = 'OFICIAL DE PROMOTORIA' then 315
                                        when COD_IDE_CLI = 1000032030 and NOM_CARGO = 'SERVENTE DE ESCOLA' then 3309
                                        when COD_IDE_CLI = 1008174 then sum( Inclusao)-1
                                        when COD_IDE_CLI = 1000032093 and NOM_CARGO = 'ASSISITENTE DE ADMINISTRA��O' then 636
                                        when COD_IDE_CLI = 1008233 then 1480
                                        when COD_IDE_CLI = 1008053 and DATA_INICIO = '29/07/1985' then 942

                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '09/04/2012' then 768
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '10/05/2016' then 636
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '01/03/2018' then 40
                                        when COD_IDE_CLI = 1008087    and DATA_INICIO = '28/05/2008' then 2282
                                        when COD_IDE_CLI = 1008101    and DATA_INICIO = '02/04/2009' then 426
                                        when COD_IDE_CLI = 1007974    and DATA_INICIO = '28/08/1995' then 86
                                        when COD_IDE_CLI = 1008125    and DATA_INICIO = '12/02/2007' then 210
                                        when COD_IDE_CLI = 1009771    and DATA_INICIO = '31/07/2017' then 983
                                        when COD_IDE_CLI = 1000032125 and DATA_INICIO = '21/05/2013' then 1864

                                          ELSE sum( Inclusao) END QTD_INCLUSAO,
                           --  SUM(Inclusao) QTD_INCLUSAO,
                             SUM(LTS) QTD_LTS,
                             SUM(LSV) QTD_LSV,
                             SUM(FJ) QTD_FJ,
                             SUM(FI) QTD_FI,
                             SUM(SUSP) QTD_SUSP,
                             SUM(OUTRO) QTD_OUTRO,

                             CASE WHEN COD_IDE_CLI = 1012840 AND DATA_FIM = '10/10/2023' -- SOLICITA��O PEDRO/RENATA PARA FICAR IGUAL A CERTID�O PMC 06/12/2023
                                        THEN sum( Inclusao) -1
                                        --when COD_IDE_CLI = 1008200 and NOM_CARGO = 'OFICIAL DE PROMOTORIA I' then 463
                                        when COD_IDE_CLI = 1008200 and NOM_CARGO = 'OFICIAL DE PROMOTORIA' then 315
                                        when COD_IDE_CLI = 1000032030 and NOM_CARGO = 'SERVENTE DE ESCOLA' then 3309
                                        when COD_IDE_CLI = 1008174 then sum (DISTINCT Inclusao)-1
                                        when COD_IDE_CLI = 1000032093 and NOM_CARGO = 'ASSISITENTE DE ADMINISTRA��O' then 636
                                        when COD_IDE_CLI = 1008233 then 1480
                                        when COD_IDE_CLI = 1008053 and DATA_INICIO = '29/07/1985' then 942

                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '09/04/2012' then 768
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '10/05/2016' then 636
                                        when COD_IDE_CLI = 1000032093 and DATA_INICIO = '01/03/2018' then 40
                                        when COD_IDE_CLI = 1008087    and DATA_INICIO = '28/05/2008' then 2282
                                        when COD_IDE_CLI = 1008101    and DATA_INICIO = '02/04/2009' then 426
                                        when COD_IDE_CLI = 1007974    and DATA_INICIO = '28/08/1995' then 86
                                        when COD_IDE_CLI = 1008125    and DATA_INICIO = '12/02/2007' then 210
                                        when COD_IDE_CLI = 1009771    and DATA_INICIO = '31/07/2017' then 983
                                        when COD_IDE_CLI = 1000032125 and DATA_INICIO = '21/05/2013' then 1315
                             else
                             (SUM(nvl(BRUTO, 0)) + SUM(nvl(Inclusao, 0)) -
                             SUM(nvl(LTS, 0)) - SUM(nvl(LSV, 0)) -
                             SUM(nvl(FJ, 0)) - SUM(nvl(FI, 0)) -
                             SUM(nvl(OUTRO, 0))) end QTD_LIQUIDO
                        FROM (

                              ---- Tabela de Contagem Dias Historico de Tempo
                              ----   Historico de Tempo

                              SELECT 'BRUTO'  as Tipo,
                                      COD_ENTIDADE,
                                      COD_IDE_CLI,
                                      NUM_MATRICULA,
                                      COD_IDE_REL_FUNC,
                                      0 BRUTO,
                                      /*count(DISTINCT DATA_CALCULO)*/ QTDE_DIA AS Inclusao,
                                      0 lts,
                                      0 lsv,
                                      0 FJ,
                                      0 FI,
                                      0 SUSP,
                                      QTD_DIAS_AUSENCIA OUTRO,
                                      NOM_CARGO,
                                      DATA_INICIO,
                                      DATA_FIM

                                from (SELECT distinct T.DAT_ADM_ORIG/* AA.DATA_CALCULO*/,
                                                        1                   AS COD_INS,
                                                        1                   AS TIPO_CONTAGEM,
                                                        1                   AS ID_CONTAGEM,
                                                        RF.COD_ENTIDADE,
                                                        RF.COD_IDE_CLI,
                                                        RF.NUM_MATRICULA,
                                                        RF.COD_IDE_REL_FUNC,
                                                        T.DES_ULT_CARGO     as nom_cargo,
                                                        T.DAT_ADM_ORIG      AS DATA_INICIO,
                                                        T.DAT_DESL_ORIG     AS DATA_FIM,
                                                        QTD_DIAS_AUSENCIA,
                                                        T.QTD_TMP_LIQ_DIA_TOTAL AS QTDE_DIA
                                          FROM TB_RELACAO_FUNCIONAL  RF,
                                               Tb_Hist_Carteira_Trab T,
                                               tb_dias_apoio         AA
                                         WHERE
                                        ------------------------------------------------------
                                         RF.COD_INS = PAR_COD_INS
                                      AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                      AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                                      AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                                      AND RF.COD_IDE_REL_FUNC =
                                         PAR_COD_IDE_REL_FUNC
                                      --AND T.NOM_ORG_EMP != 'PREFEITURA MUNICIPAL DE CAMPINAS'
                                        ------------------------------------------------------
                                      AND T.COD_INS = RF.COD_INS
                                      AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                                      AND T.FLG_EMP_PUBLICA = 'S'
                                      AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                      AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                                      AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                      AND AA.DATA_CALCULO <=
                                         NVL(T.DAT_DESL_ORIG, PAR_DAT_CONTAGEM)

                                      AND NOT EXISTS
                                         (

                                          SELECT 1
                                            FROM TB_RELACAO_FUNCIONAL  RF,
                                                  TB_EVOLUCAO_FUNCIONAL EF,
                                                  tb_dias_apoio         A
                                           WHERE RF.COD_INS = 1
                                             AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                                                --Yumi em 01/05/2018: comentado para remover concomit�ncia
                                                ---com qualquer v�nculo que exista na relacao funcional
                                                ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                                                --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                                                ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                                             AND RF.COD_INS = EF.COD_INS
                                             AND RF.NUM_MATRICULA =
                                                 EF.NUM_MATRICULA
                                             AND RF.COD_IDE_REL_FUNC =
                                                 EF.COD_IDE_REL_FUNC
                                             AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                                             AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                                                --Yumi em 07/05/2018: Agregado para nao pegar v�nculos com cod_vinculo = 22 (cedidos)
                                             AND RF.COD_VINCULO not in
                                                 (/*'22',*/ '5', '6')
                                             AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                                             AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                                             AND A.DATA_CALCULO >=
                                                 EF.DAT_INI_EFEITO
                                                ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                                                --entre per�odos de v�nculos
                                                --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                                             AND A.DATA_CALCULO <=
                                                 NVL(RF.DAT_FIM_EXERC,
                                                     PAR_DAT_CONTAGEM)
                                             AND AA.DATA_CALCULO = A.DATA_CALCULO
                                                --Yumi em 23/07/2018: inclu�do o status da evolucao para pegar somente vigente.
                                             AND EF.FLG_STATUS = 'V')

                                        )

                              /* group by COD_ENTIDADE,
                                         COD_IDE_CLI,
                                         NUM_MATRICULA,
                                         COD_IDE_REL_FUNC,
                                         nom_cargo,
                                         DATA_INICIO,
                                         DATA_FIM,
                                         QTD_DIAS_AUSENCIA*/





                )    GROUP BY   COD_IDE_CLI,
                                NUM_MATRICULA,
                                COD_IDE_REL_FUNC,
                                DATA_INICIO,
                                DATA_FIM,
                                NOM_CARGO
                       order by DATA_INICIO

             )

       LOOP

        INSERT INTO TB_CONTAGEM_SERV_PER_DET
          (COD_INS,
           ID_CONTAGEM,
           NUM_MATRICULA,
           COD_IDE_REL_FUNC,
           COD_IDE_CLI,
           DAT_INICIO,
           DAT_FIM,
           DES_CARGO,
           BRUTO,
           INCLUSAO,
           LTS,
           LSV,
           FJ,
           FI,
           SUSP,
           OUTROS,
           TEMPO_LIQUIDO,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU)

        VALUES
          (1,
           PER_ATS.ID_CONTAGEM,
           PER_ATS.NUM_MATRICULA,
           PER_ATS.COD_IDE_REL_FUNC,
           PER_ATS.COD_IDE_CLI,
           PER_ATS.DATA_INICIO,
           PER_ATS.DATA_FIM,
           PER_ATS.NOM_CARGO,
           PER_ATS.QTD_BRUTO,
           PER_ATS.QTD_INCLUSAO,
           PER_ATS.QTD_LTS,
           PER_ATS.QTD_LSV,
           PER_ATS.QTD_FJ,
           PER_ATS.QTD_FI,
           PER_ATS.QTD_SUSP,
           PER_ATS.QTD_OUTRO,
           PER_ATS.QTD_LIQUIDO,
           SYSDATE,
           SYSDATE,
           'CONTAGEM',
           'SP_PER_ATS');

     --  COMMIT;
      END LOOP;


    END IF;

   -----------------------  FIM PERIODO -----------------------
   commit;
    W_NUM_REGISTRO:=1;
    IF (PAR_TIPO_CONTAGEM = 10) THEN
      FOR PERIODOS IN
       (
           SELECT DISTINCT
                CT.COD_IDE_CLI                 ,
                CT.COD_ENTIDADE                ,
                0 NUM_MATRICULA               ,
                0 COD_IDE_REL_FUNC            ,
                -1 COD_REFERENCIA              ,
                -1 COD_CARGO                   ,
                0 QTD_BRUTO                    ,
                0 QTD_INCLUSAO                 ,
                0 QTD_LTS                      ,
                0 QTD_LSV                      ,
                0 QTD_FJ                       ,
                0 QTD_FI                       ,
                0 QTD_SUSP                     ,
                0 QTD_OUTRO                    ,
                0 qtd_liquido                  ,
                CT.NOM_ORG_EMP                 ,
                CT.NUM_CNPJ_ORG_EMP  NUM_CNPJ  ,
              CT.DAT_ADM_ORIG as DATA_INICIO   ,
              NVL(CT.DAT_DESL_ORIG,PAR_DAT_CONTAGEM ) as DATA_FIM


                                         FROM TB_RELACAO_FUNCIONAL   RF,
                                               Tb_Hist_Carteira_Trab CT
                                        WHERE RF.COD_INS          = PAR_COD_INS
                                          AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
                                          AND CT.COD_INS          = RF.COD_INS
                                          AND CT.COD_IDE_CLI      = RF.COD_IDE_CLI
                                          AND NVL(CT.COD_ENTIDADE ,RF.COD_ENTIDADE)   = RF.COD_ENTIDADE
                                          AND CT.FLG_EMP_PUBLICA   ='N'


                 ORDER BY 17 --- Data de Inicio

        )

       LOOP
             A_DATA_INICIO      := PERIODOS.DATA_INICIO;
            A_DATA_FIM         := PERIODOS.DATA_FIM;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA;
            A_COD_IDE_CLI      := PERIODOS.COD_IDE_CLI    ;
            A_COD_ENTIDADE     := PERIODOS.COD_ENTIDADE   ;
            A_NUM_MATRICULA    := PERIODOS.NUM_MATRICULA  ;
            A_COD_IDE_REL_FUNC := PERIODOS.COD_IDE_REL_FUNC ;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA ;
            A_COD_CARGO        := PERIODOS.COD_CARGO;
            A_NUM_CNPJ         := PERIODOS.NUM_CNPJ;
            A_NOM_ORG_EMP      := PERIODOS.NOM_ORG_EMP ;


               --- Contagem de Periodos ----

              BEGIN
                   SELECT
                       sum(pd.bruto)          bruto
                     , sum(pd.inclusao)       inclusao
                     , sum(pd.lts )           lts
                     , sum(pd.lsv)            lsv
                     , sum(pd.fj)             fj
                     , sum(pd.fi)             fi
                     , sum(pd.susp )          susp
                     , sum(pd.outros )        outros
                     , sum(pd.tempo_liquido)  tempo_liquido
                     INTO
                           PERIODOS.QTD_BRUTO   ,
                           PERIODOS.QTD_INCLUSAO,
                           PERIODOS.QTD_LTS     ,
                           PERIODOS.QTD_LSV     ,
                           PERIODOS.QTD_FJ      ,
                           PERIODOS.QTD_FI      ,
                           PERIODOS.QTD_SUSP    ,
                           PERIODOS.QTD_OUTRO   ,
                           PERIODOS.QTD_LIQUIDO

                  FROM  TB_CONTAGEM_SERV_PER_DET PD
                  WHERE PD.COD_INS     =PAR_COD_INS           AND
                        PD.ID_CONTAGEM = PAR_ID_CONTAGEM      AND
                        PD.DAT_INICIO >= A_DATA_INICIO AND
                        PD.DAT_FIM    <=NVL(A_DATA_FIM,TO_DATE('01/12/2099','DD/MM/YYYY'));

           END;

                   INSERT INTO TB_CONTAGEM_SERV_PERIODO
                          (COD_INS,
                           ID_CONTAGEM,
                           DAT_INICIO,
                           DAT_FIM ,
                           COD_ENTIDADE,
                           NUM_MATRICULA,
                           COD_IDE_REL_FUNC,
                           COD_IDE_CLI,
                           BRUTO,
                           INCLUSAO,
                           LTS,
                           LSV,
                           FJ,
                           FI,
                           SUSP,
                           OUTROS,
                           TEMPO_LIQUIDO,
                           DES_OBS,
                           DES_CARGO,
                           DAT_ING,
                           DAT_ULT_ATU,
                           NOM_USU_ULT_ATU,
                           NOM_PRO_ULT_ATU)
                        VALUES
                          (1,
                           PAR_ID_CONTAGEM,
                           A_DATA_INICIO,
                           A_DATA_FIM , -- PERIODOS.DATA_FIM,
                           PAR_COD_ENTIDADE,
                           PAR_NUM_MATRICULA,
                           PAR_COD_IDE_REL_FUNC,
                           PAR_COD_IDE_CLI,
                           nvl(PERIODOS.QTD_BRUTO,0),
                           nvl(PERIODOS.QTD_INCLUSAO,0),
                           nvl(PERIODOS.QTD_LTS,0),
                           nvl(PERIODOS.QTD_LSV,0),
                           nvl(PERIODOS.QTD_FJ,0),
                           nvl(PERIODOS.QTD_FI,0),
                           nvl(PERIODOS.QTD_SUSP,0),
                           nvl(PERIODOS.QTD_OUTRO,0),
                           nvl(PERIODOS.QTD_LIQUIDO,0),
                           A_NOM_ORG_EMP,
                           NVL(PERIODOS.NUM_CNPJ, 'NAO INFORMADO'),
                           SYSDATE,
                           SYSDATE,
                           'CONTAGEM',
                           'SP_CONTAGEM_PERIODO'

                           );

      END LOOP;

    END IF;

    IF (PAR_TIPO_CONTAGEM = 12) THEN
      FOR PERIODOS IN
       (
         SELECT DISTINCT
                CT.COD_IDE_CLI                 ,
                CT.COD_ENTIDADE                ,
                0 NUM_MATRICULA               ,
                0 COD_IDE_REL_FUNC            ,
                -1 COD_REFERENCIA              ,
                -1 COD_CARGO                   ,
                0 QTD_BRUTO                    ,
                0 QTD_INCLUSAO                 ,
                0 QTD_LTS                      ,
                0 QTD_LSV                      ,
                0 QTD_FJ                       ,
                0 QTD_FI                       ,
                0 QTD_SUSP                     ,
                0 QTD_OUTRO                    ,
                0 qtd_liquido                  ,
                CT.NOM_ORG_EMP                 ,
                CT.NUM_CNPJ_ORG_EMP  NUM_CNPJ  ,
              CT.DAT_ADM_ORIG as DATA_INICIO   ,
              NVL(CT.DAT_DESL_ORIG,PAR_DAT_CONTAGEM ) as DATA_FIM


                                         FROM TB_RELACAO_FUNCIONAL   RF,
                                               Tb_Hist_Carteira_Trab CT
                                        WHERE RF.COD_INS          = PAR_COD_INS
                                          AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
                                          AND CT.COD_INS          = RF.COD_INS
                                          AND CT.COD_IDE_CLI      = RF.COD_IDE_CLI
                                          AND NVL(CT.COD_ENTIDADE ,RF.COD_ENTIDADE)   = RF.COD_ENTIDADE
                                          AND CT.FLG_EMP_PUBLICA   ='S'


                 ORDER BY 17 --- Data de Inicio

        )

       LOOP
             A_DATA_INICIO      := PERIODOS.DATA_INICIO;
            A_DATA_FIM         := PERIODOS.DATA_FIM;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA;
            A_COD_IDE_CLI      := PERIODOS.COD_IDE_CLI    ;
            A_COD_ENTIDADE     := PERIODOS.COD_ENTIDADE   ;
            A_NUM_MATRICULA    := PERIODOS.NUM_MATRICULA  ;
            A_COD_IDE_REL_FUNC := PERIODOS.COD_IDE_REL_FUNC ;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA ;
            A_COD_CARGO        := PERIODOS.COD_CARGO;
            A_NUM_CNPJ         := PERIODOS.NUM_CNPJ;
            A_NOM_ORG_EMP      := PERIODOS.NOM_ORG_EMP ;


               --- Contagem de Periodos ----

              BEGIN
                   SELECT
                       sum(pd.bruto)          bruto
                     , sum(pd.inclusao)       inclusao
                     , sum(pd.lts )           lts
                     , sum(pd.lsv)            lsv
                     , sum(pd.fj)             fj
                     , sum(pd.fi)             fi
                     , sum(pd.susp )          susp
                     , sum(pd.outros )        outros
                     , sum(pd.tempo_liquido)  tempo_liquido
                     INTO
                           PERIODOS.QTD_BRUTO   ,
                           PERIODOS.QTD_INCLUSAO,
                           PERIODOS.QTD_LTS     ,
                           PERIODOS.QTD_LSV     ,
                           PERIODOS.QTD_FJ      ,
                           PERIODOS.QTD_FI      ,
                           PERIODOS.QTD_SUSP    ,
                           PERIODOS.QTD_OUTRO   ,
                           PERIODOS.QTD_LIQUIDO

                  FROM  TB_CONTAGEM_SERV_PER_DET PD
                  WHERE PD.COD_INS     =PAR_COD_INS           AND
                        PD.ID_CONTAGEM = PAR_ID_CONTAGEM      AND
                        PD.DAT_INICIO >= A_DATA_INICIO AND
                        PD.DAT_FIM    <=NVL(A_DATA_FIM,TO_DATE('01/12/2099','DD/MM/YYYY'));

           END;

                   INSERT INTO TB_CONTAGEM_SERV_PERIODO
                          (COD_INS,
                           ID_CONTAGEM,
                           DAT_INICIO,
                           DAT_FIM ,
                           COD_ENTIDADE,
                           NUM_MATRICULA,
                           COD_IDE_REL_FUNC,
                           COD_IDE_CLI,
                           BRUTO,
                           INCLUSAO,
                           LTS,
                           LSV,
                           FJ,
                           FI,
                           SUSP,
                           OUTROS,
                           TEMPO_LIQUIDO,
                           DES_OBS,
                           DES_CARGO,
                           DAT_ING,
                           DAT_ULT_ATU,
                           NOM_USU_ULT_ATU,
                           NOM_PRO_ULT_ATU)
                        VALUES
                          (1,
                           PAR_ID_CONTAGEM,
                           A_DATA_INICIO,
                           A_DATA_FIM , -- PERIODOS.DATA_FIM,
                           PAR_COD_ENTIDADE,
                           PAR_NUM_MATRICULA,
                           PAR_COD_IDE_REL_FUNC,
                           PAR_COD_IDE_CLI,
                           nvl(PERIODOS.QTD_BRUTO,0),
                           nvl(PERIODOS.QTD_INCLUSAO,0),
                           nvl(PERIODOS.QTD_LTS,0),
                           nvl(PERIODOS.QTD_LSV,0),
                           nvl(PERIODOS.QTD_FJ,0),
                           nvl(PERIODOS.QTD_FI,0),
                           nvl(PERIODOS.QTD_SUSP,0),
                           nvl(PERIODOS.QTD_OUTRO,0),
                           nvl(PERIODOS.QTD_LIQUIDO,0),
                           A_NOM_ORG_EMP,
                           NVL(PERIODOS.NUM_CNPJ, 'NAO INFORMADO'),
                           SYSDATE,
                           SYSDATE,
                           'CONTAGEM',
                           'SP_CONTAGEM_PERIODO'

                           );

      END LOOP;

      END IF;

    IF (PAR_TIPO_CONTAGEM = 13) THEN
      FOR PERIODOS IN
       (
           SELECT DISTINCT
                CT.COD_IDE_CLI                 ,
                CT.COD_ENTIDADE                ,
                0 NUM_MATRICULA               ,
                0 COD_IDE_REL_FUNC            ,
                -1 COD_REFERENCIA              ,
                -1 COD_CARGO                   ,
                0 QTD_BRUTO                    ,
                0 QTD_INCLUSAO                 ,
                0 QTD_LTS                      ,
                0 QTD_LSV                      ,
                0 QTD_FJ                       ,
                0 QTD_FI                       ,
                0 QTD_SUSP                     ,
                0 QTD_OUTRO                    ,
                0 qtd_liquido                  ,
                CT.NOM_ORG_EMP                 ,
                CT.Des_Ult_Cargo  NUM_CNPJ  ,
              CT.DAT_ADM_ORIG as DATA_INICIO   ,
              NVL(CT.DAT_DESL_ORIG,PAR_DAT_CONTAGEM ) as DATA_FIM


                                         FROM TB_RELACAO_FUNCIONAL   RF,
                                               Tb_Hist_Carteira_Trab CT
                                        WHERE RF.COD_INS          = PAR_COD_INS
                                          AND RF.COD_IDE_CLI      = PAR_COD_IDE_CLI
                                          AND RF.COD_ENTIDADE     = PAR_COD_ENTIDADE
                                          AND CT.COD_INS          = RF.COD_INS
                                          AND CT.COD_IDE_CLI      = RF.COD_IDE_CLI
                                          AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
                                          AND NVL(CT.COD_ENTIDADE ,RF.COD_ENTIDADE)   = RF.COD_ENTIDADE
                                          AND CT.FLG_EMP_PUBLICA   ='S'
                                          --AND CT.NOM_ORG_EMP != 'PREFEITURA MUNICIPAL DE CAMPINAS'


                 ORDER BY 17 --- Data de Inicio

        )

       LOOP
             A_DATA_INICIO      := PERIODOS.DATA_INICIO;
            A_DATA_FIM         := PERIODOS.DATA_FIM;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA;
            A_COD_IDE_CLI      := PERIODOS.COD_IDE_CLI    ;
            A_COD_ENTIDADE     := PERIODOS.COD_ENTIDADE   ;
            A_NUM_MATRICULA    := PERIODOS.NUM_MATRICULA  ;
            A_COD_IDE_REL_FUNC := PERIODOS.COD_IDE_REL_FUNC ;
            A_COD_REFERENCIA   := PERIODOS.COD_REFERENCIA ;
            A_COD_CARGO        := PERIODOS.COD_CARGO;
            A_NUM_CNPJ         := PERIODOS.NUM_CNPJ;
            A_NOM_ORG_EMP      := PERIODOS.NOM_ORG_EMP ;


               --- Contagem de Periodos ----

              BEGIN
                   SELECT
                       sum(pd.bruto)          bruto
                     , sum(pd.inclusao)       inclusao
                     , sum(pd.lts )           lts
                     , sum(pd.lsv)            lsv
                     , sum(pd.fj)             fj
                     , sum(pd.fi)             fi
                     , sum(pd.susp )          susp
                     , sum(pd.outros )        outros
                     , sum(pd.tempo_liquido)  tempo_liquido
                     INTO
                           PERIODOS.QTD_BRUTO   ,
                           PERIODOS.QTD_INCLUSAO,
                           PERIODOS.QTD_LTS     ,
                           PERIODOS.QTD_LSV     ,
                           PERIODOS.QTD_FJ      ,
                           PERIODOS.QTD_FI      ,
                           PERIODOS.QTD_SUSP    ,
                           PERIODOS.QTD_OUTRO   ,
                           PERIODOS.QTD_LIQUIDO

                  FROM  TB_CONTAGEM_SERV_PER_DET PD
                  WHERE PD.COD_INS     =PAR_COD_INS           AND
                        PD.ID_CONTAGEM = PAR_ID_CONTAGEM      AND
                        PD.DAT_INICIO >= A_DATA_INICIO AND
                        PD.DAT_FIM    <=NVL(A_DATA_FIM,TO_DATE('01/12/2099','DD/MM/YYYY'));

           END;

                   INSERT INTO TB_CONTAGEM_SERV_PERIODO
                          (COD_INS,
                           ID_CONTAGEM,
                           DAT_INICIO,
                           DAT_FIM ,
                           COD_ENTIDADE,
                           NUM_MATRICULA,
                           COD_IDE_REL_FUNC,
                           COD_IDE_CLI,
                           BRUTO,
                           INCLUSAO,
                           LTS,
                           LSV,
                           FJ,
                           FI,
                           SUSP,
                           OUTROS,
                           TEMPO_LIQUIDO,
                           DES_OBS,
                           DES_CARGO,
                           DAT_ING,
                           DAT_ULT_ATU,
                           NOM_USU_ULT_ATU,
                           NOM_PRO_ULT_ATU)
                        VALUES
                          (1,
                           PAR_ID_CONTAGEM,
                           A_DATA_INICIO,
                           A_DATA_FIM , -- PERIODOS.DATA_FIM,
                           PAR_COD_ENTIDADE,
                           PAR_NUM_MATRICULA,
                           PAR_COD_IDE_REL_FUNC,
                           PAR_COD_IDE_CLI,
                           nvl(PERIODOS.QTD_BRUTO,0),
                           nvl(PERIODOS.QTD_INCLUSAO,0),
                           nvl(PERIODOS.QTD_LTS,0),
                           nvl(PERIODOS.QTD_LSV,0),
                           nvl(PERIODOS.QTD_FJ,0),
                           nvl(PERIODOS.QTD_FI,0),
                           nvl(PERIODOS.QTD_SUSP,0),
                           nvl(PERIODOS.QTD_OUTRO,0),
                           nvl(PERIODOS.QTD_LIQUIDO,0),
                           A_NOM_ORG_EMP,
                           NVL(PERIODOS.NUM_CNPJ, 'NAO INFORMADO'),
                           SYSDATE,
                           SYSDATE,
                           'CONTAGEM',
                           'SP_CONTAGEM_PERIODO'

                           );

      END LOOP;

      END IF;


    END;
  END;
END PAC_CALCULA_TEMPO_ATIVO_CMC;
/
