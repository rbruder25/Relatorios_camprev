CREATE OR REPLACE PACKAGE "PAC_CALCULA_TEMPO_ATIVO"
 AS
 
/*   -- VARIAVEIS GLOBAIS  - cmc
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
  
  
  
  
  
  
  
  
  
  
  
  
  
  

---------------------- variaveis coleção lp ------------------
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

----- Cursor Para Contagem ------------------------------------------------------
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

         -- Tabela de Contagem  Dias da Evolucaçao Funcional
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)

                   --Yumi em 02/05/2018: Precisa colocar a regra do vínculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                   
                    
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
                   
                   
                   --YUMI EM 01/05/2018: INCLUÍDO PARA PEGAR VÍNCULOS ANTERIORES DA RELACAO FUNCIONAL
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                   --Yumi em 02/05/2018: Precisa colocar a regra do vínculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                   
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                        --Yumi em 23/07/2018: incluído o status da evolucao para pegar somente vigente.
                        AND EF.FLG_STATUS = 'V'
                        
                        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                    = T.COD_INS
                   AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
               --     AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                   AND NOT EXISTS
                 (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               Tb_afastamento        TT,
                               tb_dias_apoio         A,
                               tb_motivo_afastamento MO
                         WHERE RF.COD_INS               = PAR_COD_INS
                         --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                          AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                  --  AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                        )

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

         union
         ---Yumi em 01/05/2018: incluído para descontar os dias de descontos
         ---relacionados ao histórico de tempos averbados
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
              --      AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                        )

                )
                group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(dat_adm_orig, 'yyyy')
  
   \*
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
                                                    FROM folha.TB_TRANSF_CARGO TC
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
*\
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                   
                   
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                    AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
               )
               group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')
                  ) GROUP BY  COD_IDE_CLI,  NUM_MATRICULA , COD_IDE_REL_FUNC  , ANO   order by ano;


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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                                     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                                     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
         \*SELECT

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
                          t.nom_org_emp ; *\

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
                   AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                   
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                           AND EF.FLG_STATUS                = 'V'
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                           --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                            'Certidao nº ' || T.NUM_CERTIDAO || ', emissor ' ||
                            (SELECT CO.DES_DESCRICAO
                               FROM TB_CODIGO CO
                              WHERE CO.COD_INS = 0
                                AND CO.COD_NUM = 2378
                                AND CO.COD_PAR = T.COD_EMISSOR) ||
                            ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                            ', início em ' ||
                            TO_CHAR(T.DAT_ADM_ORIG, 'DD/MM/RRRR')
                           WHEN AA.DATA_CALCULO = T.DAT_DESL_ORIG THEN
                            'Certidao nº ' || T.NUM_CERTIDAO || ', emissor ' ||
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
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
    AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
       AND NOT EXISTS (

           \*SELECT 1
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
              AND AA.DATA_CALCULO = A.DATA_CALCULO*\



                        SELECT 1
                          FROM  TB_RELACAO_FUNCIONAL  RF,
                                TB_EVOLUCAO_FUNCIONAL EF,
                                tb_dias_apoio         A
                         WHERE
                                RF.COD_INS                    = 1
                           AND RF.COD_IDE_CLI                = PAR_COD_IDE_CLI
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (\*'22',*\ '5', '6')
                           AND EF.FLG_STATUS                = 'V'
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                           --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                           AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

           )

         UNION ALL
         --------------------------------------------------
          -- Detalhe de Relaçao Funcional
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
         --Yumi em 01/05/2018: comentado para pegar todos os vínculos
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
        --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
        --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
         --Yumi em 01/05/2018: comentado para pegar todos os vínculos
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
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
         )

 WHERE GLS_DETALHE IS NOT NULL
 GROUP BY ANO;

  --------- CURSORES DE CONTAGEM DE APOSENTADORIA E SEUS DETALHES  ----
  ----------------    TEMPOS DE CONTRIBUIÇAO  ------------


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

                 -------- Tempo de Contribuiçao ---------------------
                   ------------ Obtem de Dias de Contribuiçao ----------
                   ------- Tudo Historico só com Corte de Data de contagem
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
                   ------- Tudo Historico associado a último cargo com corte de Data de contagem

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
                   ------- Tudo Historico associado a última carreira com corte de Data de contagem
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
                             ------  Calculo de Tempo de contribuiçao
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
                       ---------------- tempo serviço público  -------------------------
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
               ---------- OUTROS Afastamento de Tempo de Contribuiçao  ------
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
     AND RF.COD_VINCULO not in (\*'22',*\ '5', '6')
     AND EF.FLG_STATUS = 'V'
     AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
     AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
     --Yumi em 06/11/2019: ajustado para fechar a vigência do cargo da evolução na
     --data de fim de exercício.
     --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
     AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO,  NVL(RF.DAT_FIM_EXERC,PAR_DAT_CONTAGEM) )
     AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
     
     --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
  --  AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
        
        AND NOT EXISTS (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               TB_EVOLUCAO_FUNCIONAL EF,
                               TB_DIAS_APOIO         A
                         WHERE RF.COD_INS = 1
                           AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                            --Yumi em 06/11/2019: comentado para remover concomitância
                            ---com qualquer vínculo que exista na relacao funcional
                           --AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS = EF.COD_INS
                           AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                            --Yumi em 06/11/2019: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO not in (\*'22',*\ '5', '6')
                           AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                            ---Yumi em 06/11/2019: ajustado pois nao estava pegando tempos averbados
                            --entre períodos de vínculos)
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                            --Yumi em 06/11/2019:  incluído o status da evolucao para pegar somente vigente.)
                            AND EF.FLG_STATUS = 'V'
                            --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                            --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                            --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
             ---Yumi em 06/11/2019: comentado para verificar licença
             --de qualquer vínculo da relacao funcional
              --and rf.cod_entidade = PAR_COD_ENTIDADE
            ---and rf.num_matricula = PAR_NUM_MATRICULA
             --and rf.cod_ide_rel_func = PAR_COD_IDE_REL_FUNC
             and rf.cod_ide_cli = af.cod_ide_cli
             and rf.cod_entidade = af.cod_entidade
             and rf.num_matricula = af.num_matricula
             and rf.cod_ide_rel_func = af.cod_ide_rel_func
             and rf.cod_vinculo not in (\*'22',*\ '5', '6')
             )afa

                                 join tb_motivo_afastamento mo
                                 on mo.cod_mot_afast = afa.cod_mot_afast
                               join tb_dias_apoio AA
                                 on  AA.DATA_CALCULO < PAR_DAT_CONTAGEM
                                 AND AA.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, AA.DATA_CALCULO)
                                and AA.DATA_CALCULO between afa.dat_ini_afast and  afa.dat_ret_prev
        where MO.AUMENTA_CONT_LICENCA = 'S'
        
        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
        --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
        --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                                    FROM TB_TRANSF_CARGO TC
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



---------******************** FIM CURSOR LP **********************-----*/

   DIAS_CINCO_ANOS NUMBER := 1825;
   DIAS_UM_ANO     NUMBER := 365;

   FUNCTION FNC_DEFINE_TIPO_CONTAGEM (I_TIPO_CONTAGEM IN NUMBER,
                                     I_DES_CONTAGEM  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2;

   FUNCTION FNC_RET_NUM_CERTIDAO_CTC RETURN NUMBER;

   FUNCTION FNC_RET_NUM_CERTIDAO_LP RETURN NUMBER;

   PROCEDURE SP_CONTAGEM_TEMPO (I_TIPO_CONTAGEM IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE , 
                                I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                I_COD_ENTIDADE  IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                I_NUM_MATRICULA IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE,
                                I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                I_DATA_CONTAGEM IN DATE,           
                                O_ID_CONTAGEM  OUT NUMBER,                    
                                O_COD_ERRO     OUT NUMBER,
                                O_DES_ERRO     OUT VARCHAR2);





   PROCEDURE SP_AVERBAR_ATS (P_ID_CONTAGEM      IN  TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE,
                             P_ID_TIPO_CONTAGEM IN  TB_CONTAGEM_SERVIDOR.TIPO_CONTAGEM%TYPE,
                             P_COD_INS          IN  TB_PESSOA_FISICA.COD_INS%TYPE,
                             P_COD_ENTIDADE     IN  TB_ENTIDADE.COD_ENTIDADE%TYPE,
                             P_COD_IDE_CLI      IN  TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                             P_NUM_MATRICULA    IN  TB_RELACAO_FUNCIONAL.NUM_MATRICULA%TYPE,
                             P_COD_IDE_REL_FUNC IN  TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC%TYPE,
                             P_DATA_DIREITO     IN  DATE,
                             O_ERRO             OUT NUMBER,
                             O_MSG              OUT VARCHAR2);

  PROCEDURE SP_LIMPA_CONTAGEM(P_ID_AQUISITIVO IN NUMBER, P_DES_MSG_BKP IN VARCHAR2);                         

/*
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
                                    oErrorMessage  OUT VARCHAR2) ;*/
                                    
 
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

---------------------- variaveis coleção lp ------------------
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

         -- Tabela de Contagem  Dias da Evolucaçao Funcional
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)

                   --Yumi em 02/05/2018: Precisa colocar a regra do vínculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                   
                    
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
                   
                   
                   --YUMI EM 01/05/2018: INCLUÍDO PARA PEGAR VÍNCULOS ANTERIORES DA RELACAO FUNCIONAL
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                   --Yumi em 02/05/2018: Precisa colocar a regra do vínculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )
                   
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                        --Yumi em 23/07/2018: incluído o status da evolucao para pegar somente vigente.
                        AND EF.FLG_STATUS = 'V'
                        
                        --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                    = T.COD_INS
                   AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
               --     AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')

                   AND NOT EXISTS
                 (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               Tb_afastamento        TT,
                               tb_dias_apoio         A,
                               tb_motivo_afastamento MO
                         WHERE RF.COD_INS               = PAR_COD_INS
                         --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                  --  AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

                        )

                )

         group by COD_ENTIDADE,
                  COD_IDE_CLI,
                  NUM_MATRICULA,
                  COD_IDE_REL_FUNC,
                  to_char(DATA_CALCULO, 'yyyy')

         union
         ---Yumi em 01/05/2018: incluído para descontar os dias de descontos
         ---relacionados ao histórico de tempos averbados
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                                    FROM folha.TB_TRANSF_CARGO TC
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                  ------------------------------------------------------
                   AND T.COD_INS                    =  RF.COD_INS
                   AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                   AND T.FLG_EMP_PUBLICA            ='S'
                   AND AA.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG
                   AND AA.DATA_CALCULO <= PAR_DAT_CONTAGEM
                   
                   
                   --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
     --Yumi em 06/11/2019: ajustado para fechar a vigência do cargo da evolução na
     --data de fim de exercício.
     --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
     AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO,  NVL(RF.DAT_FIM_EXERC,PAR_DAT_CONTAGEM) )
     AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
     
     --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
  --  AND (AA.DATA_CALCULO < '28/05/2020' OR AA.DATA_CALCULO > '31/12/2021')
        
        AND NOT EXISTS (SELECT 1
                          FROM TB_RELACAO_FUNCIONAL  RF,
                               TB_EVOLUCAO_FUNCIONAL EF,
                               TB_DIAS_APOIO         A
                         WHERE RF.COD_INS = 1
                           AND RF.COD_IDE_CLI = PAR_COD_IDE_CLI
                            --Yumi em 06/11/2019: comentado para remover concomitância
                            ---com qualquer vínculo que exista na relacao funcional
                           --AND RF.COD_ENTIDADE = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA = PAR_NUM_MATRICULA
                           --AND RF.COD_IDE_REL_FUNC = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS = EF.COD_INS
                           AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
                            --Yumi em 06/11/2019: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO not in (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <= PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= NVL(PAR_INICIO_PERIODO_LP, A.DATA_CALCULO)
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                            ---Yumi em 06/11/2019: ajustado pois nao estava pegando tempos averbados
                            --entre períodos de vínculos)
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                            --Yumi em 06/11/2019:  incluído o status da evolucao para pegar somente vigente.)
                            AND EF.FLG_STATUS = 'V'
                            --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                            --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                            --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
             ---Yumi em 06/11/2019: comentado para verificar licença
             --de qualquer vínculo da relacao funcional
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
        --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
        --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                                    FROM TB_TRANSF_CARGO TC
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                                     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                             --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                             --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                                     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                                     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                   --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                   --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND EF.FLG_STATUS                = 'V'
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                           --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                            'Certidao nº ' || T.NUM_CERTIDAO || ', emissor ' ||
                            (SELECT CO.DES_DESCRICAO
                               FROM TB_CODIGO CO
                              WHERE CO.COD_INS = 0
                                AND CO.COD_NUM = 2378
                                AND CO.COD_PAR = T.COD_EMISSOR) ||
                            ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                            ', início em ' ||
                            TO_CHAR(T.DAT_ADM_ORIG, 'DD/MM/RRRR')
                           WHEN AA.DATA_CALCULO = T.DAT_DESL_ORIG THEN
                            'Certidao nº ' || T.NUM_CERTIDAO || ', emissor ' ||
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
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND EF.FLG_STATUS                = 'V'
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                           
                           --Yumi em 09/06/2020: SOLICITADO POR EMAIL - RONISE:
                           --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
                           --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
                           AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')

           )

         UNION ALL
         --------------------------------------------------
          -- Detalhe de Relaçao Funcional
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
         --Yumi em 01/05/2018: comentado para pegar todos os vínculos
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
        --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
        --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
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
         --Yumi em 01/05/2018: comentado para pegar todos os vínculos
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
     --DE ACORDO COM A LC 173/2020 (ENFRENTAMENTO COVID-19), Art 8º, parágrafo IX:
     --não considerar o período abaixo para contagem de ATS, Sexta Parte e Licença Premio
      
    AND (A.DATA_CALCULO < '28/05/2020' OR A.DATA_CALCULO > '31/12/2021')
         )

 WHERE GLS_DETALHE IS NOT NULL
 GROUP BY ANO;

  --------- CURSORES DE CONTAGEM DE APOSENTADORIA E SEUS DETALHES  ----
  ----------------    TEMPOS DE CONTRIBUIÇAO  ------------


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

                 -------- Tempo de Contribuiçao ---------------------
                   ------------ Obtem de Dias de Contribuiçao ----------
                   ------- Tudo Historico só com Corte de Data de contagem
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
                   ------- Tudo Historico associado a último cargo com corte de Data de contagem

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
                   ------- Tudo Historico associado a última carreira com corte de Data de contagem
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
                             ------  Calculo de Tempo de contribuiçao
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
                       ---------------- tempo serviço público  -------------------------
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
               ---------- OUTROS Afastamento de Tempo de Contribuiçao  ------
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

         -- Tabela de Contagem  Dias da Evolucaçao Funcional
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, PAR_DAT_CONTAGEM)
                   AND C.COD_INS                     = EF.COD_INS
                   AND C.COD_ENTIDADE                = EF.COD_ENTIDADE
                   AND C.COD_CARGO                   = EF.COD_CARGO

                   --Yumi em 02/05/2018: Precisa colocar a regra do vínculo que nao considera
                   --AND RF.COD_IDE_REL_FUNC NOT IN (94101, 213901 )

                   --YUMI EM 01/05/2018: INCLUÍDO PARA PEGAR VÍNCULOS ANTERIORES DA RELACAO FUNCIONAL
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                   AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                   AND EF.FLG_STATUS                 ='V'
                   AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                   AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC)
                   --Yumi em 02/05/2018: Precisa colocar a regra do vínculo que nao considera
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
                           AND RF.COD_VINCULO                not in  (/*'22',*/ '5', '6')
                           AND A.DATA_CALCULO <=PAR_DAT_CONTAGEM
                           AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                           ---Yumi em 02/05/201*: ajustado pois nao estava pegando tempos averrbados
                           --entre períodos de vínculos
                           --AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, SYSDATE)
                           AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, PAR_DAT_CONTAGEM)
                           AND AA.DATA_CALCULO = A.DATA_CALCULO
                        --Yumi em 23/07/2018: incluído o status da evolucao para pegar somente vigente.
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                 = T.COD_INS
                   AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                      ------------------------------------------
                   AND RF.COD_INS                    = T.COD_INS
                   AND RF.COD_IDE_CLI                = T.COD_IDE_CLI
                   AND RF.NUM_MATRICULA              = T.NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = T.COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   ---Yumi em 01/05/2018: comentado para verificar licença
                   --de qualquer vínculo da relacao funcional
                   --AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                   --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                   --AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                         --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
         ---Yumi em 01/05/2018: incluído para descontar os dias de descontos
         ---relacionados ao histórico de tempos averbados
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                           --Yumi em 01/05/2018: comentado para remover concomitância
                           ---com qualquer vínculo que exista na relacao funcional
                           ---AND RF.COD_ENTIDADE               = PAR_COD_ENTIDADE
                           --AND RF.NUM_MATRICULA              = PAR_NUM_MATRICULA
                           ---AND RF.COD_IDE_REL_FUNC           = PAR_COD_IDE_REL_FUNC
                           AND RF.COD_INS                    = EF.COD_INS
                           AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                           AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                           AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                           AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                           --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
                   --Yumi em 07/05/2018: Agregado para nao pegar vínculos com cod_vinculo = 22 (cedidos)
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
    and rf.tip_provimento   = '2' --Livre Provimento (cargo em Comissão)
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
    and rf.tip_provimento   = '2' --Livre Provimento (cargo em Comissão)
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


 END PAC_CALCULA_TEMPO_ATIVO;
/
CREATE OR REPLACE PACKAGE BODY "PAC_CALCULA_TEMPO_ATIVO"
 AS
  V_TIPO_CONTAGEM VARCHAR2(3);
  V_GLB_CONTAGEM_PERIODO NUMBER  := 0;
  V_GLB_CALC_BRUTO_DESCONTO BOOLEAN;
  V_GLB_DIAS_PERIODO NUMBER;



  FUNCTION FNC_DEFINE_TIPO_CONTAGEM (I_TIPO_CONTAGEM IN NUMBER,
                                     I_DES_CONTAGEM  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
  AS

  BEGIN
    IF I_DES_CONTAGEM IS NULL AND I_TIPO_CONTAGEM IS NOT NULL THEN  
      IF I_TIPO_CONTAGEM = 1 THEN 
        RETURN 'ATS';
      ELSIF I_TIPO_CONTAGEM = 2 THEN 
        RETURN 'SP';
      ELSIF I_TIPO_CONTAGEM = 3 THEN 
        RETURN 'LP';
      ELSIF I_TIPO_CONTAGEM = 4 THEN 
        RETURN 'TES';     
      ELSIF I_TIPO_CONTAGEM = 5 THEN 
        RETURN 'TPM';     
      ELSIF I_TIPO_CONTAGEM = 6 THEN 
        RETURN 'TPG';     
      ELSIF I_TIPO_CONTAGEM = 7 THEN 
        RETURN 'CTC';     
      ELSIF I_TIPO_CONTAGEM = 8 THEN      
        RETURN 'APS';     
      END IF;  
    ELSIF I_TIPO_CONTAGEM IS NULL AND I_DES_CONTAGEM IS NOT NULL THEN 
      IF I_DES_CONTAGEM = 'ATS' THEN 
        RETURN '1';
      ELSIF I_DES_CONTAGEM = 'SP' THEN 
        RETURN '2';
      ELSIF I_DES_CONTAGEM = 'LP' THEN 
        RETURN '3';
      ELSIF I_DES_CONTAGEM = 'TES' THEN 
        RETURN '4';     
      ELSIF I_DES_CONTAGEM = 'TPM' THEN 
        RETURN '5';     
      ELSIF I_DES_CONTAGEM = 'TPG' THEN 
        RETURN '6';     
      ELSIF I_DES_CONTAGEM = 'CTC' THEN 
        RETURN '7';     
      ELSIF I_DES_CONTAGEM = 'APS' THEN      
        RETURN '8';     
      END IF;  
    RETURN NULL; 
    END IF;
  END;

   FUNCTION FNC_RET_NUM_CERTIDAO_CTC RETURN NUMBER
  AS
    V_NUM_CERT NUMBER;
  BEGIN 

    SELECT NVL(MAX(CS.NUM_CERTIDAO),0)+1
      INTO V_NUM_CERT
      FROM TB_CONTAGEM_SERVIDOR CS
     WHERE CS.COD_INS = '1'
       AND CS.TIPO_CONTAGEM = 7
       AND EXTRACT (YEAR FROM CS.DAT_EXECUCAO) = EXTRACT (YEAR FROM SYSDATE);

    RETURN V_NUM_CERT;

  END;

  FUNCTION FNC_RET_NUM_CERTIDAO_LP RETURN NUMBER
  AS
    V_NUM_CERT NUMBER;
  BEGIN 

    SELECT NVL(MAX(CS.NUM_CERTIDAO),0)+1
      INTO V_NUM_CERT
      FROM TB_CONTAGEM_SERVIDOR CS
     WHERE CS.COD_INS = '1'
       AND CS.TIPO_CONTAGEM = 3
       AND EXTRACT (YEAR FROM CS.DAT_EXECUCAO) = EXTRACT (YEAR FROM SYSDATE);

    RETURN V_NUM_CERT;

  END;


  FUNCTION FNC_RET_TEMPO_DESCONTO_AVERB (I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                         I_COD_IDE_CLI   IN TB_CONTAGEM_SERVIDOR.COD_IDE_CLI%TYPE 
                                        ) RETURN NUMBER
  AS
    V_QTD_DIAS_AUSENCIA NUMBER;
  BEGIN 

     IF V_TIPO_CONTAGEM IN ('TES','CTC') THEN 
       RETURN 0;
     END IF;

     SELECT SUM(TAB.QTD_DIAS_AUSENCIA)
      INTO V_QTD_DIAS_AUSENCIA
      FROM TB_HIST_CARTEIRA_TRAB TAB
      WHERE TAB.COD_INS = I_COD_INS
       AND TAB.COD_IDE_CLI = I_COD_IDE_CLI;

     RETURN V_QTD_DIAS_AUSENCIA;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      RETURN NULL;      

  END FNC_RET_TEMPO_DESCONTO_AVERB;



  FUNCTION FNC_DEFINE_DIAS_PERIODO (I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                    I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                    I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE 
                                    ) RETURN NUMBER
  AS
   V_QTD_CONT NUMBER;
   V_RET NUMBER;
  BEGIN 
    IF V_GLB_CONTAGEM_PERIODO = 0 THEN 
      RETURN 0;
    END IF;

    IF V_TIPO_CONTAGEM = 'LP' THEN 
      V_RET := DIAS_CINCO_ANOS;
    ELSIF V_TIPO_CONTAGEM = 'ATS' THEN
      SELECT COUNT(1) 
        INTO V_QTD_CONT
        FROM TB_CONTAGEM_SERVIDOR CS
       WHERE CS.COD_INS = I_COD_INS
         AND CS.COD_IDE_CLI = I_IDE_CLI
         AND CS.TIPO_CONTAGEM = TO_NUMBER(FNC_DEFINE_TIPO_CONTAGEM(NULL, V_TIPO_CONTAGEM));

      IF V_QTD_CONT = 0 THEN
        V_RET := DIAS_CINCO_ANOS;
      ELSE
        V_RET := DIAS_UM_ANO;
      END IF;
    END IF;

    RETURN V_RET;
  END FNC_DEFINE_DIAS_PERIODO;




  PROCEDURE SP_TRATA_SALDO_AVERBADOS_PER(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                         I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                         I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE,
                                         O_SALDO_TOTAL_DIAS OUT NUMBER)
  AS
    V_QTD_DIAS_SALDO NUMBER;
    V_SALDO_AVERB NUMBER;
    V_SALDO_TOTAL NUMBER :=0;
  BEGIN 

    IF V_GLB_CONTAGEM_PERIODO = 0 THEN 
      RETURN;
    END IF;




    FOR R IN 
    (SELECT CASE WHEN V_TIPO_CONTAGEM = 'LP' THEN   (DAT_FIM_LIC_PREM - DAT_INI_LIC_PREM)+1 
                 WHEN V_TIPO_CONTAGEM = 'ATS' THEN  (DAT_FIM_ATS - DAT_INI_ATS)+1 
            END AS QTD_DIAS_AVERBADO, 
            COD_CERTIDAO_SEQ
      FROM TB_HIST_CARTEIRA_TRAB CT
     WHERE CT.COD_INS = I_COD_INS
       AND CT.COD_IDE_CLI = I_IDE_CLI      
       AND ((V_TIPO_CONTAGEM = 'LP' AND CT.FLG_TMP_LIC_PREM = 'S') OR 
            (V_TIPO_CONTAGEM = 'ATS' AND CT.FLG_TMP_ATS = 'S')) 
     )
    LOOP        

      SELECT NVL(SUM(QTD_DIAS),0)
        INTO V_QTD_DIAS_SALDO
        FROM TB_CONTAGEM_SALDO_AVERB_LP SLP
       WHERE SLP.COD_CERTIDAO_SEQ = R.COD_CERTIDAO_SEQ
         AND STATUS = 'A'
         AND (SELECT FNC_DEFINE_TIPO_CONTAGEM (NUM_TIPO_CONTAGEM)
                FROM TB_CONTAGEM_SERVIDOR CS WHERE CS.ID_CONTAGEM = SLP.ID_CONTAGEM) = V_TIPO_CONTAGEM;    


      V_SALDO_AVERB := LEAST(R.QTD_DIAS_AVERBADO - V_QTD_DIAS_SALDO,V_GLB_DIAS_PERIODO);


      IF V_SALDO_AVERB > 0 THEN  

        V_SALDO_TOTAL := V_SALDO_TOTAL + V_SALDO_AVERB; 


        IF V_SALDO_TOTAL >= V_GLB_DIAS_PERIODO THEN          
          V_SALDO_TOTAL := V_GLB_DIAS_PERIODO;         
        END IF;

        IF V_SALDO_AVERB > 0 THEN 
          INSERT INTO TB_CONTAGEM_SALDO_AVERB_LP
          (ID_CONTAGEM,
           COD_CERTIDAO_SEQ,
           QTD_DIAS,
           STATUS,
           DAT_ING,
           DAT_ULT_ATU,
           NOM_USU_ULT_ATU,
           NOM_PRO_ULT_ATU,
           NUM_TIPO_CONTAGEM
           )
          VALUES
          (I_ID_CONTAGEM,
           R.COD_CERTIDAO_SEQ,
           V_SALDO_AVERB,
           'A',
           SYSDATE,
           SYSDATE,
           USER,
           'CONTAGEM LP',
           FNC_DEFINE_TIPO_CONTAGEM(NULL,  V_TIPO_CONTAGEM)      
           );
        END IF;


        IF V_SALDO_TOTAL = V_GLB_DIAS_PERIODO THEN
          EXIT;
        END IF;
      END IF;
    END LOOP;           


    O_SALDO_TOTAL_DIAS := V_SALDO_TOTAL;
  END;


   PROCEDURE SP_GERA_ID_CONTAGEM(O_ID_CONTAGEM OUT NUMBER,
                                 O_COD_ERRO    OUT NUMBER,
                                 O_DES_ERRO    OUT VARCHAR2)
   IS
   BEGIN
     SELECT SEQ_CONTAGEM_ATIVO.NEXTVAL 
       INTO O_ID_CONTAGEM 
       FROM DUAL;
   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := SQLCODE;
       O_DES_ERRO := '[sp_gera_id_contagem] - Erro geral - '||SQLERRM;
   END SP_GERA_ID_CONTAGEM;



   PROCEDURE SP_RET_PERIODO   (I_COD_INS          IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                               I_IDE_CLI          IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                               I_IDE_REL_FUNC     IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                               I_ID_CONTAGEM      IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE,
                               I_TIPO_CONTAGEM    IN TB_CONTAGEM_SERVIDOR.TIPO_CONTAGEM%TYPE,
                               I_DATA_CONTAGEM    IN DATE,
                               O_DATA_INICIO     OUT DATE,
                               O_DATA_FIM        OUT DATE,
                               O_SALDO_AVERBADOS OUT NUMBER,
                               O_COD_ERRO        OUT NUMBER,
                               O_DES_ERRO        OUT VARCHAR2)
   AS
     V_DAT_INICIO DATE := NULL;  
     V_DAT_FIM    DATE := NULL;  
     V_DATA_INI_FERIAS DATE;

     V_SALDO_AVERBADOS NUMBER;
     V_NUM_DIAS_CALCULO NUMBER;
     V_ULT_ID_CONTAGEM  NUMBER;
     VQTDDIASNAOAVERBADOS NUMBER;
     V_DAT_INI_ANTIGO DATE;

   BEGIN

     IF V_GLB_CONTAGEM_PERIODO  = 0 THEN  
       RETURN;
     END IF;


     SP_TRATA_SALDO_AVERBADOS_PER(I_COD_INS,
                                 I_IDE_CLI,
                                 I_ID_CONTAGEM,                                
                                 V_SALDO_AVERBADOS);         

     V_NUM_DIAS_CALCULO := V_GLB_DIAS_PERIODO - V_SALDO_AVERBADOS;  




     SELECT MAX(CS.DAT_FIM) + 1,
            MAX(ID_CONTAGEM),
            MAX(CS.DAT_INICIO)  
       INTO V_DAT_INICIO , V_ULT_ID_CONTAGEM, V_DAT_INI_ANTIGO
       FROM TB_CONTAGEM_SERVIDOR CS 
      WHERE CS.COD_INS = I_COD_INS
        AND CS.TIPO_CONTAGEM = I_TIPO_CONTAGEM  
        AND CS.COD_IDE_CLI = I_IDE_CLI
        AND CS.DAT_FIM < I_DATA_CONTAGEM;









     IF  V_DAT_INICIO IS NOT NULL AND V_DAT_INI_ANTIGO = V_DAT_INICIO THEN    
       SELECT SUM(SA.BRUTO)
         INTO VQTDDIASNAOAVERBADOS
         FROM TB_CONTAGEM_SERV_ANO SA 
        WHERE SA.ID_CONTAGEM = V_ULT_ID_CONTAGEM; 

       IF VQTDDIASNAOAVERBADOS = 0 THEN
         V_DAT_INICIO := V_DAT_INICIO -1 ;
       END IF;

     ELSIF V_DAT_INICIO IS NULL THEN                    
       SELECT MIN(EF.DAT_INI_EFEITO)
         INTO V_DAT_INICIO
         FROM TB_EVOLUCAO_FUNCIONAL EF
        WHERE EF.COD_INS = I_COD_INS
          AND EF.COD_IDE_CLI = I_IDE_CLI;
     END IF;   





     IF V_NUM_DIAS_CALCULO = 0 THEN       
       V_DAT_FIM := V_DAT_INICIO;  
       V_GLB_CALC_BRUTO_DESCONTO := FALSE;  
     ELSE 
       LOOP   

         SELECT MAX(DATA_CALCULO), MIN(DATA_CALCULO)  
         INTO V_DAT_FIM , V_DAT_INICIO
         FROM
         (SELECT DISTINCT
                 A.DATA_CALCULO,  
                 DENSE_RANK() OVER (ORDER BY DATA_CALCULO) AS LINHA
           FROM TB_RELACAO_FUNCIONAL  RF,
                TB_EVOLUCAO_FUNCIONAL EF,
                TB_DIAS_APOIO         A
          WHERE RF.COD_INS                    = I_COD_INS
            AND RF.COD_IDE_CLI                = I_IDE_CLI                   
            AND RF.COD_INS                    = EF.COD_INS
            AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
            AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
            AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
            AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE                   
            AND RF.COD_VINCULO                NOT IN  ('22', '5', '6') 
            AND EF.FLG_STATUS                 ='V'
            AND ((RF.COD_IDE_REL_FUNC = I_IDE_REL_FUNC) OR
                 (RF.COD_IDE_REL_FUNC <> I_IDE_REL_FUNC AND NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC) <= I_DATA_CONTAGEM) 
                )
            AND A.DATA_CALCULO <= LEAST(NVL(EF.DAT_FIM_EFEITO,I_DATA_CONTAGEM) ,I_DATA_CONTAGEM)
            AND A.DATA_CALCULO >= GREATEST(V_DAT_INICIO, EF.DAT_INI_EFEITO)

            AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                 (V_TIPO_CONTAGEM = 'LP' AND A.FLG_LP = 'S') OR
                 (V_TIPO_CONTAGEM = 'SP' AND A.FLG_SP = 'S') OR 
                 (V_TIPO_CONTAGEM = 'ATS' AND A.FLG_ATS = 'S')                   
                )

          ) WHERE LINHA <= V_NUM_DIAS_CALCULO;


          BEGIN 
            SELECT DAT_RET_PREV 
            INTO V_DATA_INI_FERIAS
            FROM 
            (SELECT DISTINCT  MAX(AF.DAT_RET_PREV) OVER (PARTITION BY 1) DAT_RET_PREV,
                              COUNT(1) OVER (PARTITION BY 1) AS QTD
              FROM TB_AFASTAMENTO AF JOIN TB_DIAS_APOIO D ON D.DATA_CALCULO BETWEEN AF.DAT_INI_AFAST AND AF.DAT_RET_PREV
                                     JOIN TB_MOTIVO_AFASTAMENTO MO ON MO.COD_MOT_AFAST = AF.COD_MOT_AFAST
             WHERE AF.COD_INS = I_COD_INS
              AND AF.COD_IDE_CLI = I_IDE_CLI
              AND V_TIPO_CONTAGEM = 'LP'  
              AND  MO.AUMENTA_CONT_LICENCA = 'S'

              AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                   (V_TIPO_CONTAGEM = 'LP' AND D.FLG_LP = 'S') OR
                   (V_TIPO_CONTAGEM = 'SP' AND D.FLG_SP = 'S') OR 
                   (V_TIPO_CONTAGEM = 'ATS' AND D.FLG_ATS = 'S')                   
                  )

              AND D.DATA_CALCULO BETWEEN V_DAT_INICIO AND V_DAT_FIM
             ) WHERE QTD >= 30;  
          EXCEPTION 
            WHEN NO_DATA_FOUND THEN 
              EXIT;
          END;           
          V_DAT_INICIO := V_DATA_INI_FERIAS+1;        
       END LOOP;
     END IF;



     O_DATA_INICIO := V_DAT_INICIO;
     O_DATA_FIM := V_DAT_FIM;   
     O_SALDO_AVERBADOS := V_SALDO_AVERBADOS;

   END SP_RET_PERIODO;  


   PROCEDURE SP_INS_CONTAGEM_SERVIDOR(I_ID_CONTAGEM       IN TB_CONTAGEM_SERV_ANO.ID_CONTAGEM%TYPE,
                                      I_TIPO_CONTAGEM     IN TB_CONTAGEM_SERVIDOR.TIPO_CONTAGEM%TYPE,
                                      I_COD_INS           IN TB_CONTAGEM_SERV_ANO.COD_INS%TYPE,     
                                      I_COD_ENTIDADE      IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                      I_COD_CLI           IN TB_CONTAGEM_SERVIDOR.COD_IDE_CLI%TYPE,
                                      I_IDE_REL_FUNC      IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                      I_NUM_MATRICULA     IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE                                                                                     
                                     )                           
   AS
   BEGIN 

     BEGIN 


       INSERT INTO TB_CONTAGEM_SERVIDOR
       (
         COD_INS          ,
         TIPO_CONTAGEM    ,
         ID_CONTAGEM       ,
         COD_ENTIDADE      ,
         COD_IDE_CLI       ,
         NUM_MATRICULA     ,
         COD_IDE_REL_FUNC  ,
         DAT_EXECUCAO      ,
         DAT_INICIO        ,
         DAT_FIM           ,
         NUM_DIAS_BRUTO    ,
         NUM_DIAS_DESC     ,
         NUM_DIAS_LIQ      ,
         NUM_ANOS          ,
         NUM_MESES         ,
         NUM_DIAS          ,
         NUM_CERTIDAO      ,
         NOM_USU_ULT_ATU
       )
       VALUES
       (
         I_COD_INS           ,
         I_TIPO_CONTAGEM     ,
         I_ID_CONTAGEM       ,
         I_COD_ENTIDADE      ,
         I_COD_CLI           ,
         I_NUM_MATRICULA     ,
         I_IDE_REL_FUNC      ,
         SYSDATE             ,
         TO_DATE(NULL)       ,
         TO_DATE(NULL)       ,
         0                   ,
         0                   ,
         0                   ,
         0                   ,
         0                   ,
         0                   ,
         NULL                ,
         'CONTAGEM'
       );
     EXCEPTION 
       WHEN DUP_VAL_ON_INDEX THEN 
          NULL; 
     END;        
   END SP_INS_CONTAGEM_SERVIDOR; 



   PROCEDURE SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM       IN TB_CONTAGEM_SERV_ANO.ID_CONTAGEM%TYPE,                            
                                      I_COD_INS           IN TB_CONTAGEM_SERV_ANO.COD_INS%TYPE,                                                                 
                                      I_ANO               IN TB_CONTAGEM_SERV_ANO.ANO%TYPE,                               
                                      I_DES_OBS           IN TB_CONTAGEM_SERV_ANO.DES_OBS%TYPE,                                       
                                      I_VLR_BRUTO         IN TB_CONTAGEM_SERV_ANO.BRUTO%TYPE,   
                                      I_VLR_INCLUSAO      IN TB_CONTAGEM_SERV_ANO.INCLUSAO%TYPE,
                                      I_VLR_LTS           IN TB_CONTAGEM_SERV_ANO.LTS%TYPE,     
                                      I_VLR_LSV           IN TB_CONTAGEM_SERV_ANO.LSV%TYPE,     
                                      I_VLR_FJ            IN TB_CONTAGEM_SERV_ANO.FJ%TYPE,      
                                      I_VLR_FI            IN TB_CONTAGEM_SERV_ANO.FI%TYPE,      
                                      I_VLR_SUSP          IN TB_CONTAGEM_SERV_ANO.SUSP%TYPE,    
                                      I_VLR_CSV           IN TB_CONTAGEM_SERV_ANO.CSV%TYPE,                                         
                                      I_VLR_OUTROS        IN TB_CONTAGEM_SERV_ANO.OUTROS%TYPE,  
                                      I_VLR_TMP_LIQ       IN TB_CONTAGEM_SERV_ANO.TEMPO_LIQUIDO%TYPE,
                                      I_VLR_TMP_LIQ_CARG  IN TB_CONTAGEM_SERV_ANO.TEMPO_LIQ_CARGO %TYPE,
                                      I_VLR_TMP_LIQ_CARR  IN TB_CONTAGEM_SERV_ANO.TEMPO_LIQ_CARREIRA%TYPE,
                                      I_VLR_TMP_LIQ_SP    IN TB_CONTAGEM_SERV_ANO.TEMPO_LIQ_SERV_PUBLICO%TYPE
                                      )
   AS

   BEGIN       

     BEGIN 
       INSERT INTO TB_CONTAGEM_SERV_ANO 
         (COD_INS,
          ID_CONTAGEM,
          ANO,
          BRUTO,
          INCLUSAO,
          LTS,
          LSV,
          FJ,
          FI,
          SUSP,
          CSV,
          OUTROS,
          TEMPO_LIQUIDO,
          DES_OBS,
          TEMPO_LIQ_CARGO,
          TEMPO_LIQ_CARREIRA,
          TEMPO_LIQ_SERV_PUBLICO)
       VALUES
          (I_COD_INS,          
           I_ID_CONTAGEM,      
           I_ANO,              
           NVL(I_VLR_BRUTO,0), 
           NVL(I_VLR_INCLUSAO,0), 
           NVL(I_VLR_LTS,0),          
           NVL(I_VLR_LSV,0),          
           NVL(I_VLR_FJ,0),           
           NVL(I_VLR_FI,0),           
           NVL(I_VLR_SUSP,0),         
           NVL(I_VLR_CSV,0),          
           NVL(I_VLR_OUTROS,0),       
           NVL(I_VLR_TMP_LIQ,0),      
           I_DES_OBS,          
           NVL(I_VLR_TMP_LIQ_CARG,0), 
           NVL(I_VLR_TMP_LIQ_CARR,0), 
           NVL(I_VLR_TMP_LIQ_SP,0)   
           );
     EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN 

         UPDATE TB_CONTAGEM_SERV_ANO SA
            SET SA.BRUTO = NVL(I_VLR_BRUTO,SA.BRUTO),
                SA.INCLUSAO = NVL(I_VLR_INCLUSAO, SA.INCLUSAO),
                SA.LTS = NVL(I_VLR_LTS,SA.LTS),
                SA.LSV = NVL(I_VLR_LSV,SA.LSV),
                SA.FJ  = NVL(I_VLR_FJ, SA.FJ),
                SA.FI  = NVL(I_VLR_FI, SA.FI),
                SA.SUSP = NVL(I_VLR_SUSP, SA.SUSP),
                SA.CSV = NVL(I_VLR_CSV, SA.CSV),               
                SA.OUTROS = NVL(I_VLR_OUTROS, SA.OUTROS),
                SA.TEMPO_LIQUIDO = NVL(I_VLR_TMP_LIQ, SA.TEMPO_LIQUIDO),
                SA.TEMPO_LIQ_CARGO = NVL(I_VLR_TMP_LIQ_CARG, SA.TEMPO_LIQ_CARGO),
                SA.TEMPO_LIQ_CARREIRA = NVL(I_VLR_TMP_LIQ_CARR, SA.TEMPO_LIQ_CARREIRA),
                SA.TEMPO_LIQ_SERV_PUBLICO = NVL(I_VLR_TMP_LIQ_SP, SA.TEMPO_LIQ_SERV_PUBLICO),
                SA.DES_OBS = I_DES_OBS
          WHERE SA.COD_INS = I_COD_INS
            AND SA.ID_CONTAGEM = I_ID_CONTAGEM
            AND SA.ANO = I_ANO;            
     END;       
   END SP_INS_CONTAGEM_SERV_ANO;




   PROCEDURE SP_ATU_DES_OBS_ANO_SERVIDOR(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                        I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                        I_DATA_CONTAGEM IN DATE,
                                        I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                        I_COD_ENTIDADE  IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                        I_NUM_MATRICULA IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE,
                                        I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                        O_COD_ERRO     OUT NUMBER,
                                        O_DES_ERRO     OUT VARCHAR2) 
   AS

   BEGIN 
     FOR R IN (
     SELECT  ANO,
             LISTAGG(GLS_DETALHE, '-') WITHIN GROUP(ORDER BY DATA_CALCULO) GLS_DETALHE
       FROM (SELECT DISTINCT AA.DATA_CALCULO,
                     TO_CHAR(AA.DATA_CALCULO, 'YYYY') ANO,
                      CASE
                        WHEN AA.DATA_CALCULO = T.DAT_ADM_ORIG THEN
                         'Certidao n¿ ' || T.NUM_CERTIDAO || ', emissor ' ||
                         (SELECT CO.DES_DESCRICAO
                            FROM TB_CODIGO CO
                           WHERE CO.COD_INS = 0
                             AND CO.COD_NUM = 2378
                             AND CO.COD_PAR = T.COD_EMISSOR) ||
                         ', empresa/orgao: ' || T.NOM_ORG_EMP ||
                         ', in¿cio em ' ||
                         TO_CHAR(T.DAT_ADM_ORIG, 'DD/MM/RRRR')
                        WHEN AA.DATA_CALCULO = T.DAT_DESL_ORIG THEN
                         'Certidao n¿ ' || T.NUM_CERTIDAO || ', emissor ' ||
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
                    TB_HIST_CARTEIRA_TRAB T,
                    TB_DIAS_APOIO         AA
              WHERE RF.COD_INS          = I_COD_INS
                AND RF.COD_IDE_CLI      = I_IDE_CLI
                AND RF.COD_ENTIDADE     = I_COD_ENTIDADE
                AND RF.NUM_MATRICULA    = I_NUM_MATRICULA
                AND RF.COD_IDE_REL_FUNC = I_IDE_REL_FUNC
                AND T.COD_INS = RF.COD_INS
                AND T.COD_IDE_CLI = RF.COD_IDE_CLI
                AND T.FLG_EMP_PUBLICA = 'S'
                AND AA.DATA_CALCULO<=I_DATA_CONTAGEM
                AND (AA.DATA_CALCULO = T.DAT_ADM_ORIG OR
                     AA.DATA_CALCULO = NVL(T.DAT_DESL_ORIG, TRUNC(SYSDATE)))

                AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                     (V_TIPO_CONTAGEM = 'LP' AND AA.FLG_LP = 'S') OR
                     (V_TIPO_CONTAGEM = 'SP' AND AA.FLG_SP = 'S') OR 
                     (V_TIPO_CONTAGEM = 'ATS' AND AA.FLG_ATS = 'S')                   
                    )

                AND NOT EXISTS (SELECT 1
                                  FROM  TB_RELACAO_FUNCIONAL  RF,
                                        TB_EVOLUCAO_FUNCIONAL EF,
                                        TB_DIAS_APOIO         A
                                 WHERE RF.COD_INS                    = I_COD_INS
                                   AND RF.COD_IDE_CLI                = I_IDE_CLI
                                   AND RF.COD_INS                    = EF.COD_INS
                                   AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                   AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                   AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                   AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                                   AND RF.COD_VINCULO                NOT IN  ('22', '5', '6')
                                   AND EF.FLG_STATUS                = 'V'
                                   AND A.DATA_CALCULO <= I_DATA_CONTAGEM
                                   AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                   AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, I_DATA_CONTAGEM)
                                   AND AA.DATA_CALCULO = A.DATA_CALCULO)
           UNION ALL



           SELECT DISTINCT A.DATA_CALCULO,
                           TO_CHAR(A.DATA_CALCULO, 'YYYY'),
                           ((SELECT CO.DES_DESCRICAO
                               FROM TB_CODIGO CO
                              WHERE CO.COD_INS = 0
                                AND CO.COD_NUM = 2140
                                AND CO.COD_PAR = EF.COD_MOT_EVOL_FUNC) || ' ' ||'no cargo ' ||
                            (SELECT CAR.NOM_CARGO
                               FROM TB_CARGO CAR
                              WHERE CAR.COD_INS = 1
                                AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
                                AND CAR.COD_PCCS = EF.COD_PCCS
                                AND CAR.COD_CARREIRA = EF.COD_CARREIRA
                                AND CAR.COD_QUADRO = EF.COD_QUADRO
                                AND CAR.COD_CLASSE = EF.COD_CLASSE
                                AND CAR.COD_CARGO = EF.COD_CARGO) ||
                            ' a partir de ' || EF.DAT_INI_EFEITO || '. ' ||EF.DES_MOTIVO_AUDIT
                           ) GLS_DETALHE
             FROM TB_RELACAO_FUNCIONAL  RF,
                  TB_EVOLUCAO_FUNCIONAL EF,
                  TB_DIAS_APOIO         A
            WHERE RF.COD_INS          = I_COD_INS
              AND RF.COD_IDE_CLI      = I_IDE_CLI
              AND RF.COD_INS          = EF.COD_INS
              AND RF.NUM_MATRICULA    = EF.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
              AND RF.COD_IDE_CLI      = EF.COD_IDE_CLI
              AND RF.COD_ENTIDADE     = EF.COD_ENTIDADE
              AND EF.FLG_STATUS       = 'V'

              AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                   (V_TIPO_CONTAGEM = 'LP' AND A.FLG_LP = 'S') OR
                   (V_TIPO_CONTAGEM = 'SP' AND A.FLG_SP = 'S') OR 
                   (V_TIPO_CONTAGEM = 'ATS' AND A.FLG_ATS = 'S')                   
                  )

              AND A.DATA_CALCULO  <=I_DATA_CONTAGEM
              AND (A.DATA_CALCULO = EF.DAT_INI_EFEITO)



           UNION ALL
           SELECT DISTINCT A.DATA_CALCULO,
                           TO_CHAR(A.DATA_CALCULO, 'YYYY'),
                           ((SELECT CO.DES_DESCRICAO
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
                 TB_DIAS_APOIO             A
           WHERE RF.COD_INS         = I_COD_INS
          AND RF.COD_IDE_CLI        = I_IDE_CLI
          AND RF.COD_INS            = EF.COD_INS
          AND RF.NUM_MATRICULA      = EF.NUM_MATRICULA
          AND RF.COD_IDE_REL_FUNC   = EF.COD_IDE_REL_FUNC
          AND RF.COD_IDE_CLI        = EF.COD_IDE_CLI
          AND RF.COD_ENTIDADE       = EF.COD_ENTIDADE
          AND A.DATA_CALCULO        = EF.DAT_INI_EFEITO
          AND A.DATA_CALCULO        <=I_DATA_CONTAGEM    

          AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
               (V_TIPO_CONTAGEM = 'LP' AND A.FLG_LP = 'S') OR
               (V_TIPO_CONTAGEM = 'SP' AND A.FLG_SP = 'S') OR 
               (V_TIPO_CONTAGEM = 'ATS' AND A.FLG_ATS = 'S')                   
              )

          )
        WHERE GLS_DETALHE IS NOT NULL
        GROUP BY ANO  
        )
        LOOP
          UPDATE    TB_CONTAGEM_SERV_ANO  CS
             SET CS.DES_OBS=  R.GLS_DETALHE
           WHERE CS.COD_INS       = I_COD_INS
             AND CS.ID_CONTAGEM   = I_ID_CONTAGEM
             AND CS.ANO           = R.ANO;           
        END LOOP; 
  EXCEPTION 
    WHEN OTHERS THEN 
      O_COD_ERRO := 100;
      O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_des_obs_detalhe] -'||SQLERRM;
  END SP_ATU_DES_OBS_ANO_SERVIDOR;




   PROCEDURE SP_ATU_DIAS_CONTAGEM_SERVIDOR(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                           I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE)
   AS  
     D_DIAS NUMBER := 0;
     D_MESES NUMBER := 0;
     D_ANOS NUMBER := 0;
   BEGIN  


     UPDATE TB_CONTAGEM_SERVIDOR CS
        SET CS.NUM_ANOS     =TRUNC(CS.NUM_DIAS_LIQ/365),
            CS.NUM_MESES    = TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ/365)*365 ) )/30) ,
            CS.NUM_DIAS     =(CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ/365)*365 ) )- TRUNC((CS.NUM_DIAS_LIQ - (TRUNC(CS.NUM_DIAS_LIQ/365)*365 ) )/30)*30
      WHERE CS.COD_INS     =I_COD_INS
        AND CS.ID_CONTAGEM =I_ID_CONTAGEM;


     SELECT CS.NUM_DIAS,
            CS.NUM_MESES,
            CS.NUM_ANOS
       INTO D_DIAS,
            D_MESES,
            D_ANOS
       FROM TB_CONTAGEM_SERVIDOR CS
      WHERE CS.COD_INS     =I_COD_INS
        AND CS.ID_CONTAGEM =I_ID_CONTAGEM;

     IF D_DIAS  >=30  THEN
       D_DIAS  :=D_DIAS  -30;
       D_MESES :=D_MESES +1;
     END IF;

     IF D_MESES  >=12 THEN
       D_MESES := D_MESES -12;
       D_ANOS  := D_ANOS +1;
     END IF;

     UPDATE  TB_CONTAGEM_SERVIDOR CS
        SET CS.NUM_DIAS  = D_DIAS,
            CS.NUM_MESES = D_MESES,
            CS.NUM_ANOS  = D_ANOS
      WHERE CS.COD_INS     =I_COD_INS
        AND CS.ID_CONTAGEM =I_ID_CONTAGEM;
   END SP_ATU_DIAS_CONTAGEM_SERVIDOR;


   PROCEDURE SP_ATU_VLR_CONTAGEM_SERVIDOR(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                          I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                          I_TIPO_CONTAGEM IN NUMBER,                                    
                                          I_DATA_CONTAGEM IN DATE,
                                          I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                          I_COD_ENTIDADE  IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                          I_NUM_MATRICULA IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE,
                                          I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                          I_DATA_MIN_LP   IN DATE,
                                          I_DATA_MAX_LP   IN DATE,   
                                          O_COD_ERRO     OUT NUMBER,
                                          O_DES_ERRO     OUT VARCHAR2) 
   AS 
     V_QTD_DESC_AVERB NUMBER;
   BEGIN 

       SP_INS_CONTAGEM_SERVIDOR(I_ID_CONTAGEM,   
                                I_TIPO_CONTAGEM, 
                                I_COD_INS,       
                                I_COD_ENTIDADE,      
                                I_IDE_CLI,           
                                I_IDE_REL_FUNC,     
                                I_NUM_MATRICULA                                                                             
                                );                           


       UPDATE TB_CONTAGEM_SERVIDOR CS
          SET ( CS.NUM_DIAS_BRUTO , 
                CS.NUM_DIAS_DESC,
                CS.NUM_DIAS_LIQ,
                CS.NUM_DIAS_FALTAS,
                CS.NUM_DIAS_LICENCAS,
                CS.NUM_DIAS_PENALIDADES,
                CS.NUM_DIAS_OUTROS,
                CS.TEMPO_LIQ_CARGO,
                CS.TEMPO_LIQ_CARREIRA,
                CS.TEMPO_LIQ_SERV_PUBLICO) = (SELECT (SUM(CSD.BRUTO)  + SUM(CSD.INCLUSAO)), 
                                              (SUM (NVL(LTS,0)) +                           
                                               SUM (NVL(LSV,0)) +
                                               SUM(NVL(FJ,0))   +
                                               SUM(NVL(FI,0))   +
                                               SUM(CSD.SUSP)    +
                                               SUM(NVL(CSD.OUTROS,0))),
                                              (SUM(CSD.BRUTO ) +                        
                                               SUM(CSD.INCLUSAO)- 
                                               (SUM (NVL(LTS,0)) +
                                                SUM (NVL(LSV,0)) +
                                                SUM(NVL(FJ,0))   +
                                                SUM(NVL(FI,0))   +
                                                SUM(CSD.SUSP)    +
                                                SUM(NVL(CSD.OUTROS,0)))),
                                              (SUM(NVL(FJ,0))   + SUM(NVL(FI,0))),       
                                              (SUM(NVL(LTS,0))  + SUM(NVL(LSV,0))),      
                                              (SUM(CSD.SUSP)),                           
                                              (SUM(CSD.OUTROS)),                         
                                              (SUM(CSD.TEMPO_LIQ_CARGO)),                
                                              (SUM(CSD.TEMPO_LIQ_CARREIRA)),             
                                              (SUM(CSD.TEMPO_LIQ_SERV_PUBLICO))          
                                      FROM  TB_CONTAGEM_SERV_ANO CSD
                                     WHERE CSD.COD_INS     = I_COD_INS AND
                                           CSD.ID_CONTAGEM =I_ID_CONTAGEM),
                CS.DAT_INICIO  =  (SELECT MIN (EF.DAT_INI_EFEITO)
                                     FROM TB_RELACAO_FUNCIONAL  RF,
                                          TB_EVOLUCAO_FUNCIONAL EF,
                                          TB_DIAS_APOIO         A
                                     WHERE RF.COD_INS                    = I_COD_INS
                                       AND RF.COD_IDE_CLI                = I_IDE_CLI                              
                                       AND RF.COD_INS                    = EF.COD_INS
                                       AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                                       AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                                       AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                                       AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE

                                        AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                                             (V_TIPO_CONTAGEM = 'LP' AND A.FLG_LP = 'S') OR
                                             (V_TIPO_CONTAGEM = 'SP' AND A.FLG_SP = 'S') OR 
                                             (V_TIPO_CONTAGEM = 'ATS' AND A.FLG_ATS = 'S')                   
                                            )

                                       AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                                       AND A.DATA_CALCULO <= NVL(EF.DAT_FIM_EFEITO, TRUNC(SYSDATE))),      
                CS.DAT_FIM  =  (SELECT LEAST(NVL(RF.DAT_FIM_EXERC,I_DATA_CONTAGEM), I_DATA_CONTAGEM)
                                  FROM TB_RELACAO_FUNCIONAL  RF
                                 WHERE RF.COD_INS                    = I_COD_INS
                                   AND RF.COD_IDE_CLI                = I_IDE_CLI
                                   AND RF.COD_ENTIDADE               = I_COD_ENTIDADE
                                   AND RF.NUM_MATRICULA              = I_NUM_MATRICULA
                                   AND RF.COD_IDE_REL_FUNC           = I_IDE_REL_FUNC),
                CS.DAT_CONTAGEM = I_DATA_CONTAGEM                                                                                        
        WHERE CS.COD_INS     =I_COD_INS
          AND CS.ID_CONTAGEM =I_ID_CONTAGEM
          AND CS.COD_IDE_CLI =I_IDE_CLI; 



      IF V_TIPO_CONTAGEM NOT IN ('TES','CTC') THEN 

        V_QTD_DESC_AVERB := FNC_RET_TEMPO_DESCONTO_AVERB(I_COD_INS, I_IDE_CLI);

        IF NVL(V_QTD_DESC_AVERB,0) > 0 THEN
          UPDATE TB_CONTAGEM_SERVIDOR CS
          SET NUM_DIAS_BRUTO = NUM_DIAS_BRUTO-V_QTD_DESC_AVERB,
              NUM_DIAS_LIQ =  NUM_DIAS_LIQ - V_QTD_DESC_AVERB         
          WHERE CS.COD_INS     =I_COD_INS
              AND CS.ID_CONTAGEM =I_ID_CONTAGEM
              AND CS.COD_IDE_CLI =I_IDE_CLI; 
        END IF;

        SP_ATU_DIAS_CONTAGEM_SERVIDOR(I_COD_INS,I_ID_CONTAGEM);
      END IF;  

      SP_ATU_DES_OBS_ANO_SERVIDOR(I_COD_INS,
                                 I_ID_CONTAGEM,
                                 I_DATA_CONTAGEM,
                                 I_IDE_CLI, 
                                 I_COD_ENTIDADE,
                                 I_NUM_MATRICULA, 
                                 I_IDE_REL_FUNC,
                                 O_COD_ERRO,  
                                 O_DES_ERRO); 

      IF V_GLB_CONTAGEM_PERIODO =1  THEN 
         UPDATE TB_CONTAGEM_SERVIDOR CS
           SET CS.DAT_INICIO = I_DATA_MIN_LP,
               CS.DAT_FIM = I_DATA_MAX_LP
          WHERE CS.COD_INS     =I_COD_INS
          AND CS.ID_CONTAGEM =I_ID_CONTAGEM
          AND CS.COD_IDE_CLI =I_IDE_CLI;        
      END IF;                                                                                                             
   END SP_ATU_VLR_CONTAGEM_SERVIDOR; 



   PROCEDURE SP_ATU_VLR_CONTAGEM_ANO_SERV(I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE,                                          
                                          O_COD_ERRO     OUT NUMBER,
                                          O_DES_ERRO     OUT VARCHAR2) 
   AS                                         
   BEGIN 
     UPDATE TB_CONTAGEM_SERV_ANO SA
        SET SA.TEMPO_LIQUIDO = ((BRUTO + INCLUSAO) - 
                               (NVL(LTS,0) +
                                NVL(LSV,0) +
                                NVL(FJ,0)  +
                                NVL(FI,0)  +
                                SUSP    +
                                NVL(OUTROS,0)))
      WHERE SA.ID_CONTAGEM = I_ID_CONTAGEM;
   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_atu_vlr_contagem_ano_serv] -'||SQLERRM;          
   END SP_ATU_VLR_CONTAGEM_ANO_SERV;                                         


   PROCEDURE SP_CALCULA_AVERBADOS(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                  I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                  I_DATA_CONTAGEM IN DATE,
                                  I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                  I_COD_ENTIDADE  IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                  I_NUM_MATRICULA IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE,
                                  I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                  I_DATA_MIN_LP   IN DATE,
                                  I_DATA_MAX_LP   IN DATE,
                                  I_DIAS_AVERBADOS_LP IN NUMBER,
                                  O_COD_ERRO     OUT NUMBER,
                                  O_DES_ERRO     OUT VARCHAR2) 
   AS                                          
   BEGIN 



     IF V_TIPO_CONTAGEM IN ('TES','CTC') THEN 
       RETURN;
     END IF;

     IF V_GLB_CONTAGEM_PERIODO  = 1  THEN  
       IF I_DIAS_AVERBADOS_LP > 0 THEN 
         SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM, 
                                  I_COD_INS,     
                                  TO_CHAR(I_DATA_MIN_LP,'yyyy'), 
                                  NULL,          
                                  NULL,          
                                  I_DIAS_AVERBADOS_LP, 
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL,          
                                  NULL);         
       END IF;      
       RETURN;
     END IF;


     FOR R IN
     (SELECT TO_CHAR(DATA_CALCULO, 'yyyy') AS ANO,                  
             COUNT(1) AS QTD 
     FROM (SELECT DISTINCT DATA_CALCULO                  
                  FROM TB_RELACAO_FUNCIONAL  RF,
                       TB_HIST_CARTEIRA_TRAB T,
                       TB_DIAS_APOIO AA
                 WHERE RF.COD_INS                    = I_COD_INS
                   AND RF.COD_IDE_CLI                = I_IDE_CLI
                   AND RF.COD_ENTIDADE               = I_COD_ENTIDADE
                   AND RF.NUM_MATRICULA              = I_NUM_MATRICULA
                   AND RF.COD_IDE_REL_FUNC           = I_IDE_REL_FUNC
                   AND T.COD_INS                     =  RF.COD_INS
                   AND T.COD_IDE_CLI                 = RF.COD_IDE_CLI                               
                   AND ((T.FLG_TMP_ATS = 'S' AND V_TIPO_CONTAGEM IN ('ATS','SP') AND AA.DATA_CALCULO >= T.DAT_INI_ATS AND AA.DATA_CALCULO <= T.DAT_FIM_ATS) OR
                        (T.FLG_TMP_SERV_MUN = 'S' AND V_TIPO_CONTAGEM = 'TPM' AND AA.DATA_CALCULO >= T.DAT_INI_SERV_MUN AND AA.DATA_CALCULO <= T.DAT_FIM_SERV_MUN) OR
                        (T.FLG_EMP_PUBLICA = 'S' AND V_TIPO_CONTAGEM = 'TPG' AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG AND AA.DATA_CALCULO <= T.DAT_DESL_ORIG) OR                        
                        (V_TIPO_CONTAGEM = 'APS' AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG AND AA.DATA_CALCULO <= T.DAT_DESL_ORIG)                      
                        )
                   AND AA.DATA_CALCULO <= I_DATA_CONTAGEM        
                   AND NOT EXISTS
                    (
                       SELECT 1
                         FROM  TB_RELACAO_FUNCIONAL  RF,
                               TB_EVOLUCAO_FUNCIONAL EF,
                               TB_DIAS_APOIO         A
                        WHERE RF.COD_INS                    = 1
                          AND RF.COD_IDE_CLI                = I_IDE_CLI                          
                          AND RF.COD_INS                    = EF.COD_INS
                          AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                          AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                          AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                          AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE
                          AND RF.COD_VINCULO                NOT IN  ('22', '5', '6')                         
                          AND A.DATA_CALCULO <=I_DATA_CONTAGEM
                          AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                          AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, I_DATA_CONTAGEM)
                          AND AA.DATA_CALCULO = A.DATA_CALCULO
                          AND EF.FLG_STATUS = 'V'
                     )
            )
            GROUP BY TO_CHAR(DATA_CALCULO, 'yyyy')
      )    
    LOOP      
      SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM, 
                               I_COD_INS,     
                               R.ANO,         
                               NULL,          
                               NULL,          
                               R.QTD,         
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL,          
                               NULL);         

    END LOOP;        
   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_averbados] -'||SQLERRM;         
   END SP_CALCULA_AVERBADOS;  


   PROCEDURE SP_CALCULA_BRUTOS(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                               I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE,                                   
                               I_DATA_CONTAGEM IN DATE,
                               I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                               I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                               V_DATA_MIN_PER   IN DATE,
                               V_DATA_MAX_PER   IN DATE,   
                               O_COD_ERRO     OUT NUMBER,
                               O_DES_ERRO     OUT VARCHAR2) 
   AS
     CURSOR CUR_BRUTOS IS
     SELECT          
               COD_IDE_CLI,      
               TO_CHAR(DATA_CALCULO, 'yyyy') ANO,
               COUNT(*) BRUTO
       FROM (SELECT DISTINCT
                     A.DATA_CALCULO,                                                                       
                     RF.COD_IDE_CLI                
               FROM TB_RELACAO_FUNCIONAL  RF,
                    TB_EVOLUCAO_FUNCIONAL EF,
                    TB_DIAS_APOIO         A
              WHERE RF.COD_INS                    = I_COD_INS
                AND RF.COD_IDE_CLI                = I_IDE_CLI                   
                AND RF.COD_INS                    = EF.COD_INS
                AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE                   
                AND RF.COD_VINCULO                NOT IN  ('22', '5', '6') 
                AND EF.FLG_STATUS                 ='V'

                AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                     (V_TIPO_CONTAGEM = 'LP' AND A.FLG_LP = 'S') OR
                     (V_TIPO_CONTAGEM = 'SP' AND A.FLG_SP = 'S') OR 
                     (V_TIPO_CONTAGEM = 'ATS' AND A.FLG_ATS = 'S')                   
                    )

                AND ((RF.COD_IDE_REL_FUNC = I_IDE_REL_FUNC) OR
                     (RF.COD_IDE_REL_FUNC <> I_IDE_REL_FUNC AND NVL(EF.DAT_FIM_EFEITO, RF.DAT_FIM_EXERC) <= I_DATA_CONTAGEM) 
                    )
                AND A.DATA_CALCULO <= LEAST(NVL(EF.DAT_FIM_EFEITO,I_DATA_CONTAGEM) ,I_DATA_CONTAGEM)
                AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
               )
      WHERE ((V_GLB_CONTAGEM_PERIODO  = 1 AND DATA_CALCULO BETWEEN V_DATA_MIN_PER AND V_DATA_MAX_PER) OR V_GLB_CONTAGEM_PERIODO = 0)
      GROUP BY COD_IDE_CLI, 
               TO_CHAR(DATA_CALCULO, 'yyyy')
      ORDER BY COD_IDE_CLI;  

     VALORES_BRUTOS CUR_BRUTOS%ROWTYPE;         


   BEGIN  

     IF V_GLB_CONTAGEM_PERIODO = 1 AND V_GLB_CALC_BRUTO_DESCONTO = FALSE THEN 
       RETURN;
     END IF;      

     OPEN CUR_BRUTOS;     

     LOOP      
       FETCH CUR_BRUTOS INTO VALORES_BRUTOS;
       EXIT WHEN CUR_BRUTOS%NOTFOUND;



       SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM, 
                                I_COD_INS,     
                                VALORES_BRUTOS.ANO,         
                                NULL,          
                                VALORES_BRUTOS.BRUTO,       
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL);         
     END LOOP;

     CLOSE CUR_BRUTOS;  

   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_brutos] -'||SQLERRM;   
   END SP_CALCULA_BRUTOS;        


   PROCEDURE SP_CALCULA_PENALIDADES(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                    I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                    I_DATA_CONTAGEM IN DATE,
                                    I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                    I_DATA_MIN_PER   IN DATE,
                                    I_DATA_MAX_PER   IN DATE,
                                    O_COD_ERRO     OUT NUMBER,
                                    O_DES_ERRO     OUT VARCHAR2) 
   AS 
     V_ANO_ANTERIOR NUMBER := NULL;
   BEGIN 

     IF V_GLB_CONTAGEM_PERIODO = 1 AND V_GLB_CALC_BRUTO_DESCONTO = FALSE THEN 
       RETURN;
     END IF;   


     FOR R IN
     (SELECT TO_CHAR(DATA_CALCULO, 'yyyy') AS ANO, 
             COUNT(1) AS QTD
     FROM (SELECT  DISTINCT
                   DATA_CALCULO
             FROM TB_RELACAO_FUNCIONAL  RF,
                  TB_PENALIDADE   P,
                  TB_DIAS_APOIO         AA,
                  TB_PARAM_MOTIVO_PENALIDADE MP
            WHERE RF.COD_INS                 = I_COD_INS
              AND RF.COD_IDE_CLI             = I_IDE_CLI        
              AND RF.COD_INS                 = P.COD_INS 
              AND RF.COD_IDE_CLI             = P.COD_IDE_CLI
              AND RF.NUM_MATRICULA           = P.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC        = P.COD_IDE_REL_FUNC
              AND RF.COD_VINCULO  NOT IN  ('22', '5', '6')

              AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                   (V_TIPO_CONTAGEM = 'LP' AND AA.FLG_LP = 'S') OR
                   (V_TIPO_CONTAGEM = 'SP' AND AA.FLG_SP = 'S') OR 
                   (V_TIPO_CONTAGEM = 'ATS' AND AA.FLG_ATS = 'S')                   
                  )

              AND AA.DATA_CALCULO <=I_DATA_CONTAGEM
              AND AA.DATA_CALCULO >= P.DAT_INI_PEN
              AND AA.DATA_CALCULO <= NVL(P.DAT_FIM_PEN, I_DATA_CONTAGEM)
              AND MP.COD_PAR = P.COD_TIPO_PEN 
              AND ((MP.FLG_DESC_ATS = 'S' AND V_TIPO_CONTAGEM IN ('ATS','SP')) OR
                   (MP.FLG_DESC_LICENCA_PREMIO = 'S' AND V_TIPO_CONTAGEM = 'LP') OR
                   (MP.FLG_DESC_APOSENTADORIA_ESP = 'S' AND V_TIPO_CONTAGEM = 'APS') OR 
                   (MP.FLG_DESC_EFE_EX_SERV_PUB = 'S' AND V_TIPO_CONTAGEM IN ('TES', 'TPM', 'TPG', 'CTC'))                  
                  )         
         )
         WHERE ((V_GLB_CONTAGEM_PERIODO = 1 AND DATA_CALCULO BETWEEN I_DATA_MIN_PER AND I_DATA_MAX_PER) OR V_GLB_CONTAGEM_PERIODO = 0) 
         GROUP BY TO_CHAR(DATA_CALCULO, 'yyyy')
     )    
     LOOP        

       SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM, 
                                I_COD_INS,     
                                R.ANO,         
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                R.QTD,         
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL);         

     END LOOP;  

   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_descontos] -'||SQLERRM;                   
   END SP_CALCULA_PENALIDADES;


   PROCEDURE SP_CALCULA_DESCONTOS(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                  I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                  I_DATA_CONTAGEM IN DATE,
                                  I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                  I_DATA_MIN_PER   IN DATE,
                                  I_DATA_MAX_PER   IN DATE,
                                  O_COD_ERRO     OUT NUMBER,
                                  O_DES_ERRO     OUT VARCHAR2) 
   AS 
     V_VLR_LSV NUMBER;
     V_VLR_LTS NUMBER;
     V_VLR_FJ NUMBER;
     V_VLR_FI NUMBER;     
     V_VLR_CSV NUMBER;      
     V_VLR_SUSP NUMBER;          
     V_VLR_OUTROS NUMBER:= 0;
     V_ANO_ANTERIOR NUMBER := NULL;
   BEGIN 

     IF V_GLB_CONTAGEM_PERIODO = 1 AND V_GLB_CALC_BRUTO_DESCONTO = FALSE THEN 
       RETURN;
     END IF;   




     FOR R IN
     (SELECT TO_CHAR(DATA_CALCULO, 'yyyy') AS ANO, 
             COD_AGRUP_AFAST,
             COUNT(1) AS QTD
     FROM (SELECT  DISTINCT
                   DATA_CALCULO,
                   NVL(MO.COD_AGRUP_AFAST,0) AS COD_AGRUP_AFAST
             FROM TB_RELACAO_FUNCIONAL  RF,
                  TB_AFASTAMENTO        T,
                  TB_DIAS_APOIO         AA,
                  TB_MOTIVO_AFASTAMENTO MO
            WHERE
                  RF.COD_INS                 = I_COD_INS
              AND RF.COD_IDE_CLI             = I_IDE_CLI        
              AND RF.COD_INS                 = T.COD_INS
              AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
              AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
              AND RF.COD_VINCULO  NOT IN  ('22', '5', '6')
              AND AA.DATA_CALCULO <=I_DATA_CONTAGEM
              AND AA.DATA_CALCULO >= T.DAT_INI_AFAST
              AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, I_DATA_CONTAGEM)
              AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST 

              AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                   (V_TIPO_CONTAGEM = 'LP' AND AA.FLG_LP = 'S') OR
                   (V_TIPO_CONTAGEM = 'SP' AND AA.FLG_SP = 'S') OR 
                   (V_TIPO_CONTAGEM = 'ATS' AND AA.FLG_ATS = 'S')                   
                  )

              AND ((MO.AUMENTA_CONT_ATS = 'S' AND V_TIPO_CONTAGEM = 'ATS') OR
                   (MO.AUMENTA_CONT_SEXTA = 'S' AND V_TIPO_CONTAGEM = 'SP') OR
                   (MO.AUMENTA_CONT_LICENCA = 'S' AND V_TIPO_CONTAGEM = 'LP') OR
                   (MO.FLG_DESC_APOSENTADORIA = 'S' AND V_TIPO_CONTAGEM = 'APS') OR 
                   (MO.FLG_DESC_EFE_EX_SERV_PUB = 'S' AND V_TIPO_CONTAGEM IN ('TES', 'TPM', 'TPG', 'CTC'))                  
                  )         
         )
         WHERE ((V_GLB_CONTAGEM_PERIODO = 1 AND DATA_CALCULO BETWEEN I_DATA_MIN_PER AND I_DATA_MAX_PER) OR V_GLB_CONTAGEM_PERIODO = 0) 
         GROUP BY TO_CHAR(DATA_CALCULO, 'yyyy'),                        
                  COD_AGRUP_AFAST
        ORDER BY TO_CHAR(DATA_CALCULO, 'yyyy')
     )    
     LOOP        

       IF V_ANO_ANTERIOR IS NULL OR V_ANO_ANTERIOR <> R.ANO THEN 
         IF V_ANO_ANTERIOR IS NOT NULL THEN 
           SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM, 
                                    I_COD_INS,     
                                    V_ANO_ANTERIOR,
                                    NULL,          
                                    NULL,          
                                    NULL,          
                                    V_VLR_LTS,     
                                    V_VLR_LSV,     
                                    V_VLR_FJ,      
                                    V_VLR_FI,      
                                    V_VLR_SUSP,    
                                    V_VLR_CSV,     
                                    V_VLR_OUTROS,  
                                    NULL,          
                                    NULL,          
                                    NULL,          
                                    NULL);         
         END IF;                                               


         V_VLR_LTS := 0;
         V_VLR_LSV := 0;   
         V_VLR_FJ := 0;    
         V_VLR_FI := 0;    
         V_VLR_CSV := 0; 
         V_VLR_SUSP := 0;
         V_VLR_OUTROS := 0;
         V_ANO_ANTERIOR :=  R.ANO;

       END IF;                                                                


       IF R.COD_AGRUP_AFAST =  1 THEN  
         V_VLR_LSV := R.QTD;
       ELSIF R.COD_AGRUP_AFAST = 2 THEN 
         V_VLR_LTS := R.QTD;
       ELSIF R.COD_AGRUP_AFAST = 3 THEN 
         V_VLR_FJ := R.QTD;
       ELSIF R.COD_AGRUP_AFAST = 4 THEN 
         V_VLR_FI := R.QTD;
       ELSIF R.COD_AGRUP_AFAST = 5 THEN 
         V_VLR_CSV := R.QTD;
       ELSIF R.COD_AGRUP_AFAST = 6 THEN 
         V_VLR_SUSP := R.QTD;     
       ELSE
         V_VLR_OUTROS := V_VLR_OUTROS + R.QTD; 
       END IF;  
     END LOOP;  


     IF V_ANO_ANTERIOR IS NOT NULL THEN 
       SP_INS_CONTAGEM_SERV_ANO(I_ID_CONTAGEM, 
                                I_COD_INS,     
                                V_ANO_ANTERIOR,
                                NULL,          
                                NULL,          
                                NULL,          
                                V_VLR_LTS,     
                                V_VLR_LSV,     
                                V_VLR_FJ,      
                                V_VLR_FI,      
                                V_VLR_SUSP,    
                                V_VLR_CSV,     
                                V_VLR_OUTROS,  
                                NULL,          
                                NULL,          
                                NULL,          
                                NULL);         
     END IF;                               

   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_descontos] -'||SQLERRM;                   
   END SP_CALCULA_DESCONTOS;         


   PROCEDURE SP_CALCULA_DESCONTOS_DETALHE(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                          I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                          I_DATA_CONTAGEM IN DATE,
                                          I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                          I_DATA_MIN_PER   IN DATE,
                                          I_DATA_MAX_PER   IN DATE,
                                          O_COD_ERRO     OUT NUMBER,
                                          O_DES_ERRO     OUT VARCHAR2) 
   AS
   BEGIN 


     IF V_GLB_CONTAGEM_PERIODO =1 AND V_GLB_CALC_BRUTO_DESCONTO = FALSE THEN 
       RETURN;
     END IF;   



     FOR R IN
     (SELECT COD_ENTIDADE,
             NUM_MATRICULA,
             COD_IDE_REL_FUNC,
             COD_IDE_CLI,
             NUM_SEQ_LANC,
             COD_MOTIVO,
             DATA_INI,
             DAT_FIM,
             DESCONTA_CONTAGEM,
             COD_AGRUPA,
             DES_MOTIVO_AUDIT,
             TIPO_DESCONTO,
             COUNT(*) QTD_DIAS
     FROM (SELECT  DISTINCT
                   RF.COD_INS            COD_INS            ,
                   RF.COD_ENTIDADE       COD_ENTIDADE       ,
                   RF.NUM_MATRICULA      NUM_MATRICULA      ,
                   RF.COD_IDE_REL_FUNC   COD_IDE_REL_FUNC   ,
                   RF.COD_IDE_CLI        COD_IDE_CLI        ,
                   T.NUM_SEQ_AFAST       NUM_SEQ_LANC       ,
                   T.COD_MOT_AFAST       COD_MOTIVO         ,
                   T.DAT_INI_AFAST       DATA_INI           ,
                   T.DAT_RET_PREV        DAT_FIM            ,
                   T.FLG_DESCONTA        DESCONTA_CONTAGEM  ,
                   MO.COD_AGRUP_AFAST    COD_AGRUPA         ,
                   MO.DES_MOT_AFAST      DES_MOTIVO_AUDIT   ,
                   AA.DATA_CALCULO       DATA_CALCULO,
                   DECODE(MO.COD_AGRUP_AFAST,3,'FAL',  
                                             4,'FAL',  
                                             6, 'PEN', 
                                             'AFA') TIPO_DESCONTO
             FROM TB_RELACAO_FUNCIONAL  RF,
                  TB_AFASTAMENTO        T,
                  TB_DIAS_APOIO   AA,
                  TB_MOTIVO_AFASTAMENTO MO
            WHERE RF.COD_INS                 = I_COD_INS
              AND RF.COD_IDE_CLI             = I_IDE_CLI        
              AND RF.COD_INS                 = T.COD_INS
              AND RF.COD_IDE_CLI             = T.COD_IDE_CLI
              AND RF.NUM_MATRICULA           = T.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC        = T.COD_IDE_REL_FUNC
              AND RF.COD_VINCULO  NOT IN  ('22', '5', '6')

              AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                   (V_TIPO_CONTAGEM = 'LP' AND AA.FLG_LP = 'S') OR
                   (V_TIPO_CONTAGEM = 'SP' AND AA.FLG_SP = 'S') OR 
                   (V_TIPO_CONTAGEM = 'ATS' AND AA.FLG_ATS = 'S')                   
                  )

              AND AA.DATA_CALCULO <=I_DATA_CONTAGEM
              AND AA.DATA_CALCULO >= T.DAT_INI_AFAST
              AND AA.DATA_CALCULO <= NVL(T.DAT_RET_PREV, I_DATA_CONTAGEM)
              AND MO.COD_MOT_AFAST = T.COD_MOT_AFAST
              AND ((MO.AUMENTA_CONT_ATS = 'S' AND V_TIPO_CONTAGEM = 'ATS') OR
                   (MO.AUMENTA_CONT_SEXTA = 'S' AND V_TIPO_CONTAGEM = 'SP') OR
                   (MO.AUMENTA_CONT_LICENCA = 'S' AND V_TIPO_CONTAGEM = 'LP') OR
                   (MO.FLG_DESC_APOSENTADORIA = 'S' AND V_TIPO_CONTAGEM = 'APS') OR 
                   (MO.FLG_DESC_EFE_EX_SERV_PUB = 'S' AND V_TIPO_CONTAGEM IN ('TES', 'TPM', 'TPG', 'CTC'))                  
                  )  
              AND ((V_GLB_CONTAGEM_PERIODO= 1 AND DATA_CALCULO BETWEEN I_DATA_MIN_PER AND I_DATA_MAX_PER) OR V_GLB_CONTAGEM_PERIODO = 0) 
             )                   
           GROUP BY 
             COD_ENTIDADE,
             NUM_MATRICULA,
             COD_IDE_REL_FUNC,
             COD_IDE_CLI,
             NUM_SEQ_LANC,
             COD_MOTIVO,
             DATA_INI,
             DAT_FIM,
             DESCONTA_CONTAGEM,
             COD_AGRUPA,
             DES_MOTIVO_AUDIT,
             TIPO_DESCONTO
       )
       LOOP
         INSERT INTO TB_CONTAGEM_DESCONTOS
                      (COD_INS,
                       ID_CONTAGEM,
                       COD_ENTIDADE,
                       NUM_MATRICULA,
                       COD_IDE_REL_FUNC,
                       COD_IDE_CLI,
                       NUM_SEQ_LANC,
                       COD_MOTIVO,
                       DATA_INI,
                       DAT_FIM,
                       DESCONTA_CONTAGEM,
                       COD_AGRUPA,
                       DES_MOTIVO,
                       TIPO_DESCONTO,
                       QTD_DIAS,
                       DAT_ING,
                       DAT_ULT_ATU,
                       NOM_USU_ULT_ATU,
                       NOM_PRO_ULT_ATU )
           VALUES      (
                        I_COD_INS,
                        I_ID_CONTAGEM,
                        R.COD_ENTIDADE,
                        R.NUM_MATRICULA,
                        R.COD_IDE_REL_FUNC,
                        R.COD_IDE_CLI,
                        R.NUM_SEQ_LANC,
                        R.COD_MOTIVO,
                        R.DATA_INI,
                        R.DAT_FIM,
                        R.DESCONTA_CONTAGEM,
                        R.COD_AGRUPA,
                        R.DES_MOTIVO_AUDIT,
                        R.TIPO_DESCONTO,
                        R.QTD_DIAS,
                        SYSDATE, 
                        SYSDATE, 
                        USER, 
                        'PAC_CALCULA_TEMPO_ATIVO'
                        );

       END LOOP;  
   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_descontos_detalhe] -'||SQLERRM;                            
   END SP_CALCULA_DESCONTOS_DETALHE;

   PROCEDURE SP_CALCULA_AVERBADOS_DETALHE(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                          I_ID_CONTAGEM   IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                          I_DATA_CONTAGEM IN DATE,
                                          I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                          I_COD_ENTIDADE  IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                          I_NUM_MATRICULA IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE,
                                          I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                          O_COD_ERRO     OUT NUMBER,
                                          O_DES_ERRO     OUT VARCHAR2) 
   AS
   BEGIN    


     IF V_TIPO_CONTAGEM IN ('TES','CTC') THEN 
       RETURN;
     END IF;



     IF V_GLB_CONTAGEM_PERIODO = 1 THEN
       INSERT INTO TB_CONTAGEM_VINC_AVERBADOS
       (
         COD_INS                ,
         ID_CONTAGEM            ,
         DAT_ADM_ORIG           ,
         DAT_DESL_ORIG          ,
         NOM_ORG_EMP            ,
         NUM_CNPJ_ORG_EMP       ,
         COD_CERTIDAO_SEQ       ,
         COD_EMISSOR            ,
         DAT_INI_CONSIDERADO    ,
         DAT_FIM_CONSIDERADO    ,
         NUM_DIAS_CONSIDERADOS ,
         DAT_ING                ,
         DAT_ULT_ATU            ,
         NOM_USU_ULT_ATU        ,
         NOM_PRO_ULT_ATU
       )      
       SELECT 
       I_COD_INS,
       I_ID_CONTAGEM,
       HC.DAT_ADM_ORIG,
       HC.DAT_DESL_ORIG,
       HC.NOM_ORG_EMP,
       HC.NUM_CNPJ_ORG_EMP,
       HC.COD_CERTIDAO_SEQ,
       HC.COD_EMISSOR,
       HC.DAT_INI_LIC_PREM,
       HC.DAT_FIM_LIC_PREM,
       LP.QTD_DIAS - HC.QTD_DIAS_AUSENCIA AS NUM_DIAS_CONSIDERADOS,
       SYSDATE, 
       SYSDATE,
       USER,
       'CONTAGEM LP'
       FROM 
       TB_CONTAGEM_SALDO_AVERB_LP LP JOIN TB_HIST_CARTEIRA_TRAB HC ON LP.COD_CERTIDAO_SEQ = HC.COD_CERTIDAO_SEQ
       WHERE LP.ID_CONTAGEM = I_ID_CONTAGEM;
     ELSE

       FOR R IN 
       (SELECT DAT_ADM_ORIG,
               DAT_DESL_ORIG,
               NOM_ORG_EMP,
               NUM_CNPJ_ORG_EMP,
               COD_CERTIDAO_SEQ,
               COD_EMISSOR,
               DAT_INI_PER_CONS,
               DAT_FIM_PER_CONS,
               NUM_DIAS_CONS - QTD_DIAS_AUSENCIA AS NUM_DIAS_CONSIDERADOS
          FROM
               (
               SELECT
                         T.COD_IDE_CLI           COD_IDE_CLI       ,
                         T.DAT_ADM_ORIG          DAT_ADM_ORIG      ,
                         T.DAT_DESL_ORIG         DAT_DESL_ORIG     ,
                         T.NOM_ORG_EMP           NOM_ORG_EMP       ,
                         T.NUM_CNPJ_ORG_EMP      NUM_CNPJ_ORG_EMP  ,
                         T.NUM_CERTIDAO          COD_CERTIDAO_SEQ  ,
                         T.COD_EMISSOR           COD_EMISSOR       ,
                         T.QTD_DIAS_AUSENCIA     QTD_DIAS_AUSENCIA,
                         MIN(AA.DATA_CALCULO)    DAT_INI_PER_CONS  ,
                         MAX(AA.DATA_CALCULO)    DAT_FIM_PER_CONS  ,
                         COUNT(*) NUM_DIAS_CONS                    
                     FROM     TB_RELACAO_FUNCIONAL  RF,
                              TB_HIST_CARTEIRA_TRAB T,
                              TB_DIAS_APOIO AA
                    WHERE RF.COD_INS                    = I_COD_INS
                      AND RF.COD_IDE_CLI                = I_IDE_CLI
                      AND RF.COD_ENTIDADE               = I_COD_ENTIDADE
                      AND RF.NUM_MATRICULA              = I_NUM_MATRICULA
                      AND RF.COD_IDE_REL_FUNC           = I_IDE_REL_FUNC
                      AND T.COD_INS                    =  RF.COD_INS
                      AND T.COD_IDE_CLI                = RF.COD_IDE_CLI
                      AND T.FLG_EMP_PUBLICA            ='S'

                      AND ((V_TIPO_CONTAGEM NOT IN ('LP','SP','ATS')) OR
                           (V_TIPO_CONTAGEM = 'LP' AND AA.FLG_LP = 'S') OR
                           (V_TIPO_CONTAGEM = 'SP' AND AA.FLG_SP = 'S') OR 
                           (V_TIPO_CONTAGEM = 'ATS' AND AA.FLG_ATS = 'S')                   
                          )

                      AND AA.DATA_CALCULO  <=I_DATA_CONTAGEM                   
                      AND ((T.FLG_TMP_ATS = 'S' AND V_TIPO_CONTAGEM IN ('ATS','SP') AND AA.DATA_CALCULO >= T.DAT_INI_ATS AND AA.DATA_CALCULO <= T.DAT_FIM_ATS) OR
                          (T.FLG_TMP_SERV_MUN = 'S' AND V_TIPO_CONTAGEM = 'TPM' AND AA.DATA_CALCULO >= T.DAT_INI_SERV_MUN AND AA.DATA_CALCULO <= T.DAT_FIM_SERV_MUN) OR
                          (T.FLG_EMP_PUBLICA = 'S' AND V_TIPO_CONTAGEM = 'TPG' AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG AND AA.DATA_CALCULO <= T.DAT_DESL_ORIG) OR                        
                          (V_TIPO_CONTAGEM = 'APS' AND AA.DATA_CALCULO >= T.DAT_ADM_ORIG AND AA.DATA_CALCULO <= T.DAT_DESL_ORIG)                      
                          )
                      AND NOT EXISTS
                    (SELECT 1
                       FROM  TB_RELACAO_FUNCIONAL  RF,
                             TB_EVOLUCAO_FUNCIONAL EF,
                             TB_DIAS_APOIO         A
                      WHERE RF.COD_INS                    = 1
                        AND RF.COD_IDE_CLI                = I_IDE_CLI               
                        AND RF.COD_INS                    = EF.COD_INS
                        AND RF.NUM_MATRICULA              = EF.NUM_MATRICULA
                        AND RF.COD_IDE_REL_FUNC           = EF.COD_IDE_REL_FUNC
                        AND RF.COD_IDE_CLI                = EF.COD_IDE_CLI
                        AND RF.COD_ENTIDADE               = EF.COD_ENTIDADE                   
                        AND RF.COD_VINCULO                NOT IN  ('22', '5', '6')
                        AND EF.FLG_STATUS                = 'V'                                            
                        AND A.DATA_CALCULO <=I_DATA_CONTAGEM
                        AND A.DATA_CALCULO >= EF.DAT_INI_EFEITO
                        AND A.DATA_CALCULO <= NVL(RF.DAT_FIM_EXERC, I_DATA_CONTAGEM)
                        AND AA.DATA_CALCULO = A.DATA_CALCULO
                     )
                     GROUP BY
                       T.COD_IDE_CLI        ,
                       T.COD_INS            ,
                       T.DAT_ADM_ORIG       ,
                       T.DAT_DESL_ORIG      ,
                       T.NOM_ORG_EXP_CERT   ,
                       T.NUM_CNPJ_ORG_EMP   ,
                       T.NUM_CERTIDAO       ,
                       T.COD_EMISSOR        ,
                       T.QTD_DIAS_AUSENCIA  ,
                       T.NOM_ORG_EMP
                     )YY
                     ORDER BY 1
       )
       LOOP
         INSERT INTO TB_CONTAGEM_VINC_AVERBADOS
                       (
                         COD_INS                ,
                         ID_CONTAGEM            ,
                         DAT_ADM_ORIG           ,
                         DAT_DESL_ORIG          ,
                         NOM_ORG_EMP            ,
                         NUM_CNPJ_ORG_EMP       ,
                         COD_CERTIDAO_SEQ       ,
                         COD_EMISSOR            ,
                         DAT_INI_CONSIDERADO    ,
                         DAT_FIM_CONSIDERADO    ,
                         NUM_DIAS_CONSIDERADOS  ,
                         DAT_ING                ,
                         DAT_ULT_ATU            ,
                         NOM_USU_ULT_ATU        ,
                         NOM_PRO_ULT_ATU
                       )
                       VALUES
                       (
                           I_COD_INS               ,
                           I_ID_CONTAGEM           ,
                           R.DAT_ADM_ORIG          ,
                           R.DAT_DESL_ORIG         ,
                           R.NOM_ORG_EMP           ,
                           R.NUM_CNPJ_ORG_EMP      ,
                           R.COD_CERTIDAO_SEQ      ,
                           R.COD_EMISSOR           ,
                           R.DAT_INI_PER_CONS   ,
                           R.DAT_FIM_PER_CONS   ,
                           R.NUM_DIAS_CONSIDERADOS ,
                           SYSDATE                 ,
                           SYSDATE                 ,
                           'CONTAGEM'              ,
                           'CONTAGEM'
                       );
     END LOOP;  
   END IF;

   EXCEPTION 
     WHEN OTHERS THEN 
       O_COD_ERRO := 100;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_calcula_averbados_detalhe] -'||SQLERRM;                           
   END SP_CALCULA_AVERBADOS_DETALHE;    


   PROCEDURE SP_LIMPA_CONTAGENS_ANTERIORES(I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                           I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                           I_TIPO_CONTAGEM IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE)
   IS
     V_ID_CONTAGEM_ANTIGA NUMBER;
   BEGIN
     BEGIN     
       IF V_GLB_CONTAGEM_PERIODO = 1 THEN 
         DELETE TB_CONTAGEM_SERVIDOR CS
          WHERE CS.COD_INS = I_COD_INS
            AND CS.COD_IDE_CLI = I_IDE_CLI
            AND CS.TIPO_CONTAGEM = I_TIPO_CONTAGEM
            AND NUM_DIAS_LIQ < V_GLB_DIAS_PERIODO          
           RETURNING CS.ID_CONTAGEM INTO V_ID_CONTAGEM_ANTIGA;
       ELSE
         DELETE TB_CONTAGEM_SERVIDOR CS
          WHERE CS.COD_INS = I_COD_INS
            AND CS.COD_IDE_CLI = I_IDE_CLI
            AND TRUNC(CS.DAT_EXECUCAO) = TRUNC(SYSDATE)
            AND CS.TIPO_CONTAGEM = I_TIPO_CONTAGEM
            RETURNING CS.ID_CONTAGEM INTO V_ID_CONTAGEM_ANTIGA;      
       END IF;  

     EXCEPTION 
       WHEN NO_DATA_FOUND THEN 
         V_ID_CONTAGEM_ANTIGA := NULL;         
     END;

     IF V_ID_CONTAGEM_ANTIGA IS NOT NULL THEN 
       DELETE TB_CONTAGEM_SERV_ANO SA
        WHERE SA.COD_INS = I_COD_INS
          AND SA.ID_CONTAGEM = V_ID_CONTAGEM_ANTIGA;

       DELETE TB_CONTAGEM_DESCONTOS CD
        WHERE CD.COD_INS = I_COD_INS
          AND CD.ID_CONTAGEM = V_ID_CONTAGEM_ANTIGA;

       DELETE TB_CONTAGEM_VINC_AVERBADOS VA
        WHERE VA.COD_INS = I_COD_INS
          AND VA.ID_CONTAGEM = V_ID_CONTAGEM_ANTIGA;

       UPDATE TB_CONTAGEM_SALDO_AVERB_LP LP
          SET LP.STATUS = 'C', 
              LP.DAT_ULT_ATU = SYSDATE, 
              LP.NOM_USU_ULT_ATU = USER, 
              LP.NOM_PRO_ULT_ATU = 'NOVO LP'
        WHERE LP.ID_CONTAGEM = V_ID_CONTAGEM_ANTIGA;       
     END IF;

   END SP_LIMPA_CONTAGENS_ANTERIORES;  


   PROCEDURE SP_CONTAGEM_TEMPO (I_TIPO_CONTAGEM IN TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE , 
                                I_COD_INS       IN TB_CONTAGEM_SERVIDOR.COD_INS%TYPE,
                                I_COD_ENTIDADE  IN TB_CONTAGEM_SERVIDOR.COD_ENTIDADE%TYPE,
                                I_IDE_CLI       IN TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                I_NUM_MATRICULA IN TB_CONTAGEM_SERVIDOR.NUM_MATRICULA%TYPE,
                                I_IDE_REL_FUNC  IN TB_CONTAGEM_SERVIDOR.COD_IDE_REL_FUNC%TYPE,
                                I_DATA_CONTAGEM IN DATE,           
                                O_ID_CONTAGEM  OUT NUMBER,                    
                                O_COD_ERRO     OUT NUMBER,
                                O_DES_ERRO     OUT VARCHAR2)
   IS
     V_ID_CONTAGEM NUMBER;
     V_DATA_MIN_PERIODO DATE;
     V_DATA_MAX_PERIODO DATE;
     V_COD_ERRO NUMBER;
     V_DES_ERRO VARCHAR2(2000);
     V_DIAS_AVERBADOS_PERIODO NUMBER;
     E_ERRO EXCEPTION;
     V_DIAS_LIQUIDO NUMBER;
     V_DIAS_DIF_LIQ NUMBER;

   BEGIN

     V_GLB_CALC_BRUTO_DESCONTO := TRUE; 

     V_TIPO_CONTAGEM := NULL;



     V_TIPO_CONTAGEM := FNC_DEFINE_TIPO_CONTAGEM(I_TIPO_CONTAGEM);


     SP_GERA_ID_CONTAGEM(V_ID_CONTAGEM, 
                         V_COD_ERRO,    
                         V_DES_ERRO);   

     IF V_COD_ERRO IS NOT NULL THEN 
       RAISE E_ERRO;
     END IF;


     IF V_TIPO_CONTAGEM IN('LP','ATS') THEN 
       V_GLB_CONTAGEM_PERIODO := 1; 
     ELSE
       V_GLB_CONTAGEM_PERIODO := 0;
     END IF;  


     IF V_GLB_CONTAGEM_PERIODO = 1 THEN 
       V_GLB_DIAS_PERIODO := FNC_DEFINE_DIAS_PERIODO (I_COD_INS,
                                                      I_IDE_CLI,
                                                      V_ID_CONTAGEM
                                                      );
     END IF;


     SP_LIMPA_CONTAGENS_ANTERIORES(I_COD_INS,
                                   I_IDE_CLI,
                                   I_TIPO_CONTAGEM);


     IF V_GLB_CONTAGEM_PERIODO = 1 THEN 
       SP_RET_PERIODO(I_COD_INS,
                      I_IDE_CLI,
                      I_IDE_REL_FUNC,
                      V_ID_CONTAGEM,
                      I_TIPO_CONTAGEM,
                      I_DATA_CONTAGEM,
                      V_DATA_MIN_PERIODO, 
                      V_DATA_MAX_PERIODO,  
                      V_DIAS_AVERBADOS_PERIODO, 
                      V_COD_ERRO,          
                      V_DES_ERRO);         

     END IF;
     LOOP 



       SP_CALCULA_BRUTOS(I_COD_INS,
                         V_ID_CONTAGEM,
                         I_DATA_CONTAGEM,
                         I_IDE_CLI, 
                         I_IDE_REL_FUNC,
                         V_DATA_MIN_PERIODO,       
                         V_DATA_MAX_PERIODO,
                         V_COD_ERRO,  
                         V_DES_ERRO); 
       IF V_COD_ERRO IS NOT NULL THEN 
         RAISE E_ERRO;
       END IF;    


       SP_CALCULA_AVERBADOS (I_COD_INS,
                             V_ID_CONTAGEM,
                             I_DATA_CONTAGEM,
                             I_IDE_CLI, 
                             I_COD_ENTIDADE,
                             I_NUM_MATRICULA, 
                             I_IDE_REL_FUNC,
                             V_DATA_MIN_PERIODO,          
                             V_DATA_MAX_PERIODO,
                             V_DIAS_AVERBADOS_PERIODO,
                             V_COD_ERRO,  
                             V_DES_ERRO); 
       IF V_COD_ERRO IS NOT NULL THEN 
         RAISE E_ERRO;
       END IF;


       SP_CALCULA_DESCONTOS (I_COD_INS,
                             V_ID_CONTAGEM,
                             I_DATA_CONTAGEM,
                             I_IDE_CLI, 
                             V_DATA_MIN_PERIODO,            
                             V_DATA_MAX_PERIODO,
                             V_COD_ERRO,  
                             V_DES_ERRO); 
       IF V_COD_ERRO IS NOT NULL THEN 
         RAISE E_ERRO;
       END IF;

       SP_CALCULA_PENALIDADES (I_COD_INS,
                               V_ID_CONTAGEM,
                               I_DATA_CONTAGEM,
                               I_IDE_CLI, 
                               V_DATA_MIN_PERIODO,            
                               V_DATA_MAX_PERIODO,
                               V_COD_ERRO,  
                               V_DES_ERRO); 
       IF V_COD_ERRO IS NOT NULL THEN 
         RAISE E_ERRO;
       END IF;



       SP_ATU_VLR_CONTAGEM_SERVIDOR (I_COD_INS,
                                     V_ID_CONTAGEM,
                                     I_TIPO_CONTAGEM,
                                     I_DATA_CONTAGEM,
                                     I_IDE_CLI, 
                                     I_COD_ENTIDADE,
                                     I_NUM_MATRICULA, 
                                     I_IDE_REL_FUNC,
                                     V_DATA_MIN_PERIODO,           
                                     V_DATA_MAX_PERIODO,
                                     V_COD_ERRO,  
                                     V_DES_ERRO); 
       IF V_COD_ERRO IS NOT NULL THEN 
         RAISE E_ERRO;
       END IF;      


       IF V_GLB_CONTAGEM_PERIODO = 1 THEN  
         SELECT CS.NUM_DIAS_LIQ
           INTO  V_DIAS_LIQUIDO
           FROM TB_CONTAGEM_SERVIDOR CS       
          WHERE  CS.COD_INS =I_COD_INS
            AND CS.ID_CONTAGEM = V_ID_CONTAGEM
            AND CS.COD_IDE_CLI =I_IDE_CLI; 
       END IF;

       IF V_GLB_CONTAGEM_PERIODO = 0 OR 
          V_DIAS_LIQUIDO >= V_GLB_DIAS_PERIODO OR
          V_DATA_MAX_PERIODO >= I_DATA_CONTAGEM THEN 
         EXIT;
       ELSE
         V_DIAS_DIF_LIQ := V_GLB_DIAS_PERIODO - V_DIAS_LIQUIDO;
         V_DATA_MAX_PERIODO  := LEAST(V_DATA_MAX_PERIODO + V_DIAS_DIF_LIQ,I_DATA_CONTAGEM );        
       END IF;   

     END LOOP; 


     SP_CALCULA_DESCONTOS_DETALHE(I_COD_INS,
                                  V_ID_CONTAGEM, 
                                  I_DATA_CONTAGEM,
                                  I_IDE_CLI,
                                  V_DATA_MIN_PERIODO,
                                  V_DATA_MAX_PERIODO,
                                  V_COD_ERRO, 
                                  V_DES_ERRO); 

     IF V_COD_ERRO IS NOT NULL THEN 
       RAISE E_ERRO;
     END IF;


     SP_CALCULA_AVERBADOS_DETALHE(I_COD_INS,
                                  V_ID_CONTAGEM,                                   
                                  I_DATA_CONTAGEM,
                                  I_IDE_CLI,
                                  I_COD_ENTIDADE,
                                  I_NUM_MATRICULA,
                                  I_IDE_REL_FUNC,
                                  V_COD_ERRO,
                                  V_DES_ERRO);

     IF V_COD_ERRO IS NOT NULL THEN 
       RAISE E_ERRO;
     END IF;


     SP_ATU_VLR_CONTAGEM_ANO_SERV(V_ID_CONTAGEM ,                                          
                                  V_COD_ERRO,
                                  V_DES_ERRO);
     IF V_COD_ERRO IS NOT NULL THEN 
       RAISE E_ERRO;
     END IF;                                 


     O_ID_CONTAGEM := V_ID_CONTAGEM;
     COMMIT;       
   EXCEPTION 
     WHEN E_ERRO THEN 
       O_COD_ERRO := 0;
       O_DES_ERRO := V_DES_ERRO;
       ROLLBACK;                             
     WHEN OTHERS THEN 
       O_COD_ERRO := 0;
       O_DES_ERRO := 'Erro geral - [pac_calcula_tempo_ativo.sp_contagem_tempo] -'||SQLERRM;                               
       ROLLBACK;
   END SP_CONTAGEM_TEMPO;        


   FUNCTION FNC_RET_PODE_AVERBAR(P_ID_CONTAGEM      IN  TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE, 
                                 P_ID_TIPO_CONTAGEM IN  TB_CONTAGEM_SERVIDOR.TIPO_CONTAGEM%TYPE,                             
                                 P_COD_INS          IN  TB_PESSOA_FISICA.COD_INS%TYPE,                                                    
                                 P_COD_ENTIDADE     IN  TB_ENTIDADE.COD_ENTIDADE%TYPE,
                                 P_COD_IDE_CLI      IN  TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                                 P_NUM_MATRICULA    IN  TB_RELACAO_FUNCIONAL.NUM_MATRICULA%TYPE,
                                 P_COD_IDE_REL_FUNC IN  TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC%TYPE) RETURN CHAR


   AS








   VNUMANOS NUMBER;
   V_LIMITE_ANOS NUMBER;

   BEGIN
     V_TIPO_CONTAGEM := FNC_DEFINE_TIPO_CONTAGEM(P_ID_TIPO_CONTAGEM);

     IF V_TIPO_CONTAGEM NOT IN ('ATS','SP') THEN 
       RAISE_APPLICATION_ERROR(-20000,'Erro. Tipo de Contagem n¿o possui averba¿¿o');
     END IF;


     IF V_TIPO_CONTAGEM = 'ATS' THEN 
       V_LIMITE_ANOS := 5;
     ELSIF V_TIPO_CONTAGEM = 'SP' THEN 
       V_LIMITE_ANOS := 20;
     END IF;


     SELECT CT.NUM_ANOS
     INTO VNUMANOS
     FROM TB_CONTAGEM_SERVIDOR CT
     WHERE CT.COD_INS             = P_COD_INS
      AND  CT.COD_ENTIDADE        = P_COD_ENTIDADE
      AND  CT.COD_IDE_CLI         = P_COD_IDE_CLI
      AND  CT.NUM_MATRICULA       = P_NUM_MATRICULA
      AND  CT.COD_IDE_REL_FUNC    = P_COD_IDE_REL_FUNC
      AND  CT.ID_CONTAGEM         = P_ID_CONTAGEM;   


     IF VNUMANOS >=V_LIMITE_ANOS THEN 
       RETURN 'S';
     ELSE
       RETURN 'N';
     END IF;    

   END FNC_RET_PODE_AVERBAR;


   PROCEDURE SP_AVERBAR_ATS (P_ID_CONTAGEM      IN  TB_CONTAGEM_SERVIDOR.ID_CONTAGEM%TYPE,
                             P_ID_TIPO_CONTAGEM IN  TB_CONTAGEM_SERVIDOR.TIPO_CONTAGEM%TYPE,
                             P_COD_INS          IN  TB_PESSOA_FISICA.COD_INS%TYPE,
                             P_COD_ENTIDADE     IN  TB_ENTIDADE.COD_ENTIDADE%TYPE,
                             P_COD_IDE_CLI      IN  TB_PESSOA_FISICA.COD_IDE_CLI%TYPE,
                             P_NUM_MATRICULA    IN  TB_RELACAO_FUNCIONAL.NUM_MATRICULA%TYPE,
                             P_COD_IDE_REL_FUNC IN  TB_RELACAO_FUNCIONAL.COD_IDE_REL_FUNC%TYPE,
                             P_DATA_DIREITO     IN  DATE,
                             O_ERRO             OUT NUMBER,
                             O_MSG              OUT VARCHAR2)
   AS







   VQTD NUMBER;
   V_RUBRICA TB_COMPOSICAO_PAG.COD_FCRUBRICA%TYPE;



   VMSGERRO VARCHAR2(4000);


   CURSOR C_ANOS_CONTAGEM IS
   SELECT CS.NUM_ANOS, CS.ROWID AS LINHA
   FROM TB_CONTAGEM_SERVIDOR CS
   WHERE CS.COD_INS = P_COD_INS
     AND CS.COD_ENTIDADE = P_COD_ENTIDADE
     AND CS.COD_IDE_CLI = P_COD_IDE_CLI
     AND CS.NUM_MATRICULA = P_NUM_MATRICULA
     AND CS.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
     AND CS.ID_CONTAGEM = P_ID_CONTAGEM
     AND CS.TIPO_CONTAGEM = P_ID_TIPO_CONTAGEM; 


   VNUMANOS TB_CONTAGEM_SERVIDOR.NUM_ANOS%TYPE;
   VLINHA ROWID;    
   BEGIN

    V_TIPO_CONTAGEM := FNC_DEFINE_TIPO_CONTAGEM(P_ID_TIPO_CONTAGEM);


    IF FNC_RET_PODE_AVERBAR(P_ID_CONTAGEM,  
                            P_ID_TIPO_CONTAGEM,   
                            P_COD_INS,         
                            P_COD_ENTIDADE,    
                            P_COD_IDE_CLI,     
                            P_NUM_MATRICULA,   
                            P_COD_IDE_REL_FUNC) = 'N' THEN 
       O_ERRO := 0;
       O_MSG := 'Servidor n¿o atingiu os crit¿rios para averba¿¿o.';
       RETURN;
     END IF; 

     IF V_TIPO_CONTAGEM  = 'ATS' THEN 
       V_RUBRICA := 3000;            
     ELSIF V_TIPO_CONTAGEM  = 'SP' THEN 
       V_RUBRICA := 9600;            
     END IF;


     SELECT COUNT(1)
     INTO VQTD
     FROM TB_COMPOSICAO_PAG PAG
     WHERE PAG.COD_INS =  P_COD_INS
       AND PAG.COD_ENTIDADE = P_COD_ENTIDADE
       AND PAG.COD_IDE_CLI = P_COD_IDE_CLI
       AND PAG.NUM_MATRICULA = P_NUM_MATRICULA
       AND PAG.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
       AND PAG.COD_FCRUBRICA = V_RUBRICA
       AND NVL(PAG.DAT_FIM_VIG,TRUNC(SYSDATE)-1) < TRUNC(SYSDATE)
       AND PAG.FLG_STATUS = 'V';

     IF VQTD >0 THEN

       VMSGERRO := 'Ja existe rubrica para esse servidor';

       O_ERRO := 0;
       O_MSG  := VMSGERRO;

       RETURN;
     ELSE


       OPEN C_ANOS_CONTAGEM;
       FETCH C_ANOS_CONTAGEM INTO VNUMANOS,VLINHA;
       CLOSE C_ANOS_CONTAGEM;


       INSERT INTO TB_COMPOSICAO_PAG
       (COD_INS,
        COD_ENTIDADE,
        COD_IDE_CLI,
        NUM_MATRICULA,
        COD_IDE_REL_FUNC,
        COD_REFERENCIA,
        COD_FCRUBRICA,
        VAL_FIXO,
        VAL_PORC,
        VAL_UNIDADE,
        SEQ_VIG,
        FLG_STATUS,
        DAT_INI_VIG,
        DAT_FIM_VIG,
        DAT_ING,
        DAT_ULT_ATU,
        NOM_USU_ULT_ATU,
        NOM_PRO_ULT_ATU,
        COD_CARGO
       )
       VALUES
       (P_COD_INS,          
        P_COD_ENTIDADE,     
        P_COD_IDE_CLI,      
        P_NUM_MATRICULA,    
        P_COD_IDE_REL_FUNC, 
        NULL,               
        V_RUBRICA,          
        0,                  
        VNUMANOS,           
        0,                  
        1,                  
        'V',                
        TRUNC(P_DATA_DIREITO),     
        NULL,               
        SYSDATE,            
        SYSDATE,            
        USER,               
        'SP_AVERBAR_ATS',   
        NULL                
       );

       UPDATE TB_CONTAGEM_SERVIDOR CS
          SET CS.FLG_AVERBADO = 'S'
        WHERE ROWID = VLINHA;
     END IF;


     COMMIT;
   EXCEPTION 
     WHEN OTHERS THEN 
       O_ERRO := 0;
       O_MSG  := SQLERRM;
       ROLLBACK;
   END SP_AVERBAR_ATS;

   PROCEDURE SP_LIMPA_CONTAGEM(P_ID_AQUISITIVO IN NUMBER, P_DES_MSG_BKP IN VARCHAR2)
   AS
     V_DAT_BKP DATE;
   BEGIN 
     V_DAT_BKP := SYSDATE;
     IF P_DES_MSG_BKP IS NOT NULL THEN
       INSERT INTO TB_CONTAGEM_SALDO_AVERB_LP_BKP SELECT A.*,V_DAT_BKP, P_DES_MSG_BKP FROM TB_CONTAGEM_SALDO_AVERB_LP A  WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
       INSERT INTO TB_CONTAGEM_SERV_ANO_BKP SELECT A.*,V_DAT_BKP, P_DES_MSG_BKP FROM TB_CONTAGEM_SERV_ANO A  WHERE ID_CONTAGEM = P_ID_AQUISITIVO;     
       INSERT INTO TB_CONTAGEM_DESCONTOS_BKP SELECT A.*,V_DAT_BKP, P_DES_MSG_BKP FROM TB_CONTAGEM_DESCONTOS A  WHERE ID_CONTAGEM = P_ID_AQUISITIVO; 
       INSERT INTO TB_CONTAGEM_VINC_AVERBADOS_BKP SELECT A.*,V_DAT_BKP, P_DES_MSG_BKP FROM TB_CONTAGEM_VINC_AVERBADOS A  WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
       --INSERT INTO TB_CONTAGEM_SERVIDOR_BKP SELECT A.*,V_DAT_BKP, P_DES_MSG_BKP FROM TB_CONTAGEM_SERVIDOR A WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
    END IF;

    DELETE  TB_CONTAGEM_SALDO_AVERB_LP  WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
    DELETE  TB_CONTAGEM_SERV_ANO WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
    DELETE  TB_CONTAGEM_DESCONTOS WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
    DELETE  TB_CONTAGEM_VINC_AVERBADOS WHERE ID_CONTAGEM = P_ID_AQUISITIVO;
    DELETE  TB_CONTAGEM_SERVIDOR WHERE ID_CONTAGEM = P_ID_AQUISITIVO;           
   END SP_LIMPA_CONTAGEM;


 END PAC_CALCULA_TEMPO_ATIVO;
/
