CREATE OR REPLACE PACKAGE "PAC_FOLHA_CALCULADA_ATIVO" is
  -- Author          : ATLANTIC SOLUTIONS
  -- Created         : 20/04/2014 -
  -- Atualizac?p     : 02/05/2013
    -- Purpose         : Processamento da folha calculada


  -- VARIAVEIS DE ENTRADA

  PAR_COD_INS                number(8);
  PAR_COD_GRP                number(8);
  PAR_PER_PRO                date;
  PAR_COD_USU                varchar2(20);
  PAR_TIP_TRA                char;
  PAR_TIP_PRO                char;
  PAR_NUM_CPF                TB_PESSOA_FISICA.NUM_CPF%TYPE;
  PAR_ERR                    number(8);
  PAR_MEN                    varchar2(200);
  PAR_PER_NUM                number(3);
  PAR_COD_PAR                varchar2(25);
  PAR_PARTIR_DE              varchar2(1);
  PAR_PER_REAL               date;
  PAR_DATA_PRIMEIRO          date;
  PAR_COD_TIPO_BEN           varchar2(6);
  PAR_GRP_PAG                number;
  PAR_IDE_CLI                TB_PESSOA_FISICA.COD_IDE_CLI%TYPE;
  PAR_COD_CATEGORIA          number(8);
  PAR_COD_CARGO              number(8);
  PAR_COD_ENTIDADE           number(8);
  PAR_NOM_BENEF              TB_TIPOS_BENEFICIOS.NOM_TIPO_BENEF_CC%TYPE;
  PAR_PERCENT_CORRECAO       NUMBER(14, 5);
  PAR_IND_PROC_ENQUADRAMENTO NUMBER;
  PAR_NUM_PROCESSO           TB_CONTROLE_PROCESSAMENTO.NUM_PROCESSO%TYPE;
  PAR_NUM_GRP_PAG            TB_CONTROLE_PROCESSAMENTO.NUM_GRP_PAG%TYPE;
  PAR_NUM_SEQ_PROC           TB_CONTROLE_PROCESSAMENTO.SEQ_PROCESSAMENTO%TYPE;
  PAR_SEQ_PAGAMENTO          NUMBER(1);

  -- VARIAVEIS PARA O BENEFICIADO

  BEN_IDE_CLI               VARCHAR2(20);
  BEN_IDE_CLI_SERV          VARCHAR2(20);
  BEN_IDE_REL_FUNC          tb_concessao_beneficio.cod_ide_rel_func%type;
  BEN_NUM_CPF               VARCHAR2(11);
  BEN_NOME                  VARCHAR2(80);
  BEN_SEQ_BENEF             tb_beneficiario.num_seq_benef%type;
  BEN_DTA_NASC              DATE;
  BEN_TIPO_PESSOA           CHAR(1);
  BEN_DAT_INICIO            DATE;
  BEN_DAT_FIM               DATE;
  BEN_COD_REFERENCIA        NUMBER(8);
  BEN_FLG_STATUS            CHAR(1);
  BEN_COD_TIPO_CALCULO      VARCHAR2(1);
  BEN_FLG_OPCAO_13          VARCHAR2(1);
  BEN_FLG_OPCAO_IAMSP       VARCHAR2(1);
  BEN_DISSOCIACAO           NUMBER;
  BEN_ENVIO_CORREIO         CHAR(1);

  BEN_COD_BANCO             TB_INFORMACAO_BANCARIA.COD_BANCO%TYPE;
  BEN_NUM_AGENCIA           TB_INFORMACAO_BANCARIA.NUM_AGENCIA%TYPE;
  BEN_NUM_DV_AGENCIA        TB_INFORMACAO_BANCARIA.NUM_DV_AGENCIA%TYPE;
  BEN_NUM_CONTA             TB_INFORMACAO_BANCARIA.NUM_CONTA%TYPE;
  BEN_NUM_DV_CONTA          TB_INFORMACAO_BANCARIA.NUM_DV_CONTA%TYPE;

  ---------------------------------
  --  ALT JTS 24

   COM_REFERENCIA_2 NUMBER(8);
   COM_REFERENCIA_3 NUMBER(8);
   COM_JORNADA_2    VARCHAR2(10);
   COM_JORNADA_3    VARCHAR2(10);
   COM_QTD_MES_2    VARCHAR2(10);
   COM_QTD_MES_3    NUMBER(8);
   COM_QTD_MES      NUMBER(8);


  ---- ALT JTS-25
    LCOMPOE_DET       TB_COMPOE_DET%ROWTYPE;           --- Linha de Tipo Compoe DET
    type COMPOE_DET is table of TB_COMPOE_DET%ROWTYPE; --- TABELA EM MEMRIA DE TIPO TB_COMPOE_DET
    vCOMPOE_DET        COMPOE_DET :=COMPOE_DET();
    idx_COMPOE_DET     number(3);

 ---------------------------------------

  -- VARIAVEIS PARA AS COMPOSICOES

  COM_COD_BENEFICIO        NUMBER(8) := 0;
  COM_TIP_BENEFICIO        VARCHAR2(20);
  COM_COD_RUBRICA          NUMBER(8);
  COM_COD_FCRUBRICA        NUMBER(8);
  COM_SEQ_VIG_FC           NUMBER(8);
  COM_NAT_COMP             CHAR(1);
  COM_NUM_ORD_JUD          NUMBER(8);
  COM_IDE_CLI_INSTITUIDOR  VARCHAR2(20);
  COM_VAL_FIXO_IND         NUMBER(18, 4);
  COM_VAL_PORC_IND         NUMBER(18, 5);
  COM_VAL_PORC2            NUMBER(18, 5);
  COM_QTY_UNID_IND         NUMBER(18, 4);
  COM_VAL_UNID             NUMBER(8);
  COM_TIPO_VALOR           CHAR(1);
  COM_IND_QTAS             CHAR(1);
  COM_NUM_QTAS_PAG         NUMBER(8);
  COM_TOT_QTAS_PAG         NUMBER(8);
  COM_IND_COMP_RUB         CHAR(1);
  COM_NAT_RUB              CHAR(1);
  COM_INI_REF              DATE;
  COM_FIM_REF              DATE;
  COM_PRIORIDADE           NUMBER(8);
  COM_DED_IR               CHAR(1);
  COM_NUM_FUNCAO           NUMBER;
  COM_FLG_PROCESSA         CHAR(1);
  COM_NAT_VAL              CHAR(1);
  COM_TIPO_APLICACAO       CHAR(1);
  COM_PERCENT_BEN          NUMBER(18, 5);
  COM_TIPO_EVENTO_ESPECIAL VARCHAR2(2);
  COM_VAL_STR1             VARCHAR2(30);
  COM_VAL_STR2             VARCHAR2(30);
  COM_MATRICULA            VARCHAR2(20);
  COM_ENTIDADE             NUMBER(8);
  COM_CARGO                tb_cargo.cod_cargo%type;
  COM_CARGO_LEIDO          tb_cargo.cod_cargo%type;
  COM_CARGO_APOS           NUMBER(8);
  COM_PCCS                 NUMBER(8);
  COM_QUADRO               tb_evolucao_funcional.cod_quadro%type;
  COM_COD_JORNADA          VARCHAR2(10);
  COM_DAT_INI_VIG          DATE;
  COM_DAT_FIM_VIG          DATE;
  COM_COD_VINCULO          NUMBER(8);
  COM_COD_REGIME_JUR       NUMBER(8);
  COM_TIP_PROVIMENTO       VARCHAR2(5);
  COM_COD_JORNADA_REL      VARCHAR2(10);
  COM_COD_IDE_CLI          VARCHAR2(20);
  COM_NUM_MATRICULA        tb_evolucao_funcional.num_matricula%type;
  COM_COD_ENTIDADE         NUMBER(8);
  COM_COD_IDE_REL_FUNC     tb_evolucao_funcional.cod_ide_rel_func%type;
  COM_COD_IDE_CLI_BEN      VARCHAR2(20);
  COM_MSC_INFORMACAO       VARCHAR2(10);
  COM_COL_INFORMACAO       VARCHAR2(25);
  COM_PORC_VIG             NUMBER(18, 5);
  COM_DAT_VIG_RUBRICA      tb_rubricas.dat_fim_vig%TYPE;
  COM_APLICA_RATEIO        CHAR(1);
  COM_SEQ_VIG              NUMBER(8);
  COM_VAL_RUBRICA_CHEIO    NUMBER(18, 4);
  COM_COD_SIT_PREV         VARCHAR2(5);
  COM_IND_CALCULO          VARCHAR2(1); -- Indicador para correc?o indice ordem judicial
  COM_DAT_CONTRATO         DATE;
  COM_COD_PODER            VARCHAR2(1); -- CODIGO PARA CALCULO DO REDUTOR
  COM_COD_CONVENIO         NUMBER(8);

  COM_NUM_CARGA              NUMBER;
  COM_NUM_SEQ_CONTROLE_CARGA NUMBER;
  COM_NUM_GRUPO_PAG          CHAR(2);
  COM_RUBRICA_TIPO           CHAR(1);

 --- Variaveis para dissociac?o de calculo
  COM_DISSOCIACAO             NUMBER;
  COM_TIPO_DISSOCIACAO        NUMBER;
  COM_COD_ENVIO_CORREIO       CHAR(1);

  -- parametro para data de suspensao
  NUM_DIAS_PRAZO   NUMBER;
  DAT_PRZ_SUSPENSO DATE  ;
  COM_FLG_STATUS   CHAR(1);

  -- PARAMETRO NOVO
    COM_COD_CONCEITO           NUMBER;
    COM_COD_FUNCAO             NUMBER ;
  -- Categoria e SubCategoria - funcoes 3 e 4

  NOM_CATEGORIA    VARCHAR2(50);
  NOM_SUBCATEGORIA VARCHAR2(50);

  -- Tipo provimento, Regime Ju, Vinculo, funcoes 8, 1 e 2

  NOM_TIPO_PROVIMENTO VARCHAR2(50);
  NOM_REGIME_JUR      VARCHAR2(50);
  NOM_VINCULO         VARCHAR2(50);

  ANT_IDE_CLI         VARCHAR2(20);
  ANT_FLG_STATUS      CHAR(1);
  PREV_IDE_CLI        VARCHAR2(20);
  ANT_COD_BENEFICIO   NUMBER(8) := 0;
  ANT_DTA_NASC        DATE := null;
  ANT_COD_IDE_CLI_BEN VARCHAR2(20);
  ANT_MATRICULA       NUMBER;
  ANT_ENTIDADE        NUMBER;
  ANT_CARGO           NUMBER;
  ANT_COM_COD_IDE_CLI VARCHAR2(20);
  ANT_COM_COD_IDE_REL_FUNC  tb_evolucao_funcional.cod_ide_rel_func%type;

  ANT_DAT_INI_BEN     DATE := null;
  ANT_TIP_BENEFICIO   VARCHAR2(20);
  ANT_NUM_GRUPO_PAG   CHAR(2);
  ANT_BEN_DISSOCIACAO NUMBER;
  ANT_NUM_CPF VARCHAR2(11);
  ANT_NOME    VARCHAR2(80);

  ---- VARIAVEL DE CORREIO ---
  ANT_BEN_ENVIO_CORREIO CHAR(1);

  -- Militar
  NUM_DEP_IR_MIL NUMBER := 0;
  vs_militar     char(1) := null;

  desc_prev number(18, 4) := 0;
  --Desconto de Excesso de teto
  desc_teto     number(18, 4) := 0;
  v_val_externo number(18, 4) := 0;

  -- Variaveis para o processamento  -----------------
  ---- Variavel para Controle de IR Recidente Exterior

   VI_IR_EXTERIOR          BOOLEAN;
  -----------------------------------------------------

  V_INST_PREV              NUMBER := 0;
  v_ide_cli                varchar2(20) := null;
  VI_SUPLEMENTAR           BOOLEAN;
  V_DED_IR_65              NUMBER(18, 4);
  V_DED_IR_DEP             NUMBER(18, 4);
  APLICAR_PROP_BEN         BOOLEAN;
  APLICAR_PROP_SAIDA       BOOLEAN;
  APLICAR_ENTRADA          BOOLEAN;
  APLICAR_RATEIO_BENEFICIO BOOLEAN;
  APLICAR_DEC_TERCEIRO     BOOLEAN;
  HOUVE_RATEIO             BOOLEAN;
  VI_DOENCA                BOOLEAN;
  VI_ORD_JUD               BOOLEAN;
  VI_PAGAR                 BOOLEAN;
  VI_PROP_SAIDA            NUMBER(18, 6);
  VI_PROP_BEN              NUMBER(18, 6);
  VI_PERC_PECUNIA          NUMBER(18, 5);
  VI_PROP_COMPOSICAO       NUMBER(18, 6);
  VI_FATOR_DIAS            NUMBER(18, 4);
  VI_FATOR_MES             NUMBER(18, 4);
  VI_FATOR_REAL            NUMBER(18, 4);
  VI_FATOR_DIAS_RET        NUMBER(18, 4);
  VI_FATOR_DIAS_SAIDA      NUMBER(18, 4) := 0;
  QTD_MESES_13             NUMBER;
  MON_CALCULO              NUMBER(18, 4);
  V_DESC_SIMP_IR           NUMBER(18, 4);
  V_VAL_SAL_MIN            NUMBER(18, 4);
  V_VAL_SAL_MIN_2          NUMBER(18, 4);
  FAIXA1_SF                NUMBER(18, 4);
  VAL1SF                   NUMBER(18, 4);
  FAIXA2_SF                NUMBER(18, 4);
  VAL2SF                   NUMBER(18, 4);
  VI_NUM_DEP_ECO           NUMBER;
  VI_TEM_SAIDA             BOOLEAN;
  V_VAL_IR                 NUMBER(18, 4);
  VI_BASE_IR               NUMBER(18, 4);
  VI_BASE_PREV             NUMBER(18, 4);
  VI_BASE_BRUTA            NUMBER(18, 4);
  VI_BASE_BRUTA_13         NUMBER(18, 4);
  VI_VAL_BASE_13           NUMBER(18, 4);
  V_VAL_13                 NUMBER(18, 4);
  V_VAL_IR_13              NUMBER(18, 4);
  VI_PROP_13               NUMBER(18, 4);
  VI_BASE_IR_13            NUMBER(18, 4);
  VI_SAL_BASE_TOTAL        NUMBER(18, 4) := 0;
  V_CONT_BENEF             NUMBER := 0;
  cont_benef               number := 0; -- para suplementar, proporc?o do desconto
  V_QTD_MESES              NUMBER := 0;
  V_NUM_AVOS_13            NUMBER := 0;
  V_NUM_AVOS_13_ADI        NUMBER := 0;
  V_NUM_AVOS_13_AD         NUMBER := 0;
  V_FATOR_13_SAIDA         NUMBER(15, 8) := 0;
  V_DAT_OBITO              DATE;
  V_DAT_EVENTO             DATE;
  V_DIAS_MES               NUMBER := 0;
  V_QTD_DIAS               NUMBER := 0;
  VI_PERCENTUAL_RATEIO     NUMBER(18, 6) := 0;
  VI_PERCENTUAL_RATEIO_ANT NUMBER(18, 6) := 0;
  V_DED_IR_PA              NUMBER(18, 4) := 0;
  V_DED_IR_DOENCA          NUMBER(18, 4) := 0;
  V_ISMAX                  NUMBER(8, 4)  := 0;
  V_BASE_ISENCAO           NUMBER(18, 4) := 0;
  VI_IDADE                 NUMBER        := 0;
  V_COD_GRUPO_45           NUMBER(8)     := 0;
  V_CALCULO_IR             CHAR(1)       := 'N';
  VI_VAL_RUBRICA_PREV      NUMBER(18, 4) := 0;
  VI_REDUC                 NUMBER(18, 4) := 0;
  valor_prev_calc          NUMBER(18, 4) := 0;
  SUPL_OK                  CHAR(1)       := 'N';
  v_val_percentual         number(18, 5) := 0;
  v_qtd_horas              number(9, 5)  := 0;
  vi_seq_pagamento         number;
  vi_cod_ref_pad_venc      tb_referencia.cod_ref_pad_venc%type;
  VI_META_GLOBAL           tb_det_param_estrutura.val_elemento%type;
  VI_VAL_APIPREM           tb_det_param_estrutura.val_elemento%type;
  VI_QTD_ERROS             NUMBER       := 0;
  vlr_margem_consig        NUMBER(8, 4) := 0; --Rod18
  v_per                    NUMBER       :=0;
  VI_DATA_ENQUADRAMENTO DATE;

  -- Variaveis para Pensao por Morte
  v_percent_rateio      number(7, 4)  := 0;
  v_val_teto_pensao     NUMBER(18, 4) := 0;
  v_porc_teto_pensao    NUMBER(18, 4) := 0;
  v_valor_total_pa      number(18, 4) := 0;
  v_cod_ref_oj          NUMBER(8)     := 0;
  v_cod_beneficio_oj    NUMBER(8)     := 0;
  RAT_COD_BENEFICIO_ANT NUMBER(8)     := 0;
  RAT_IDE_CLI_ANT       VARCHAR2(20)  := '';
  RAT_PERCENTUAL_RATEIO NUMBER(18, 5) := 1;
  v_date_obito_char     VARCHAR2(8)   := '';

  W_COD_PARAM_GERAL_CORRECAO varchaR2(10) := '';


  -- Variavel totalizacao processados

  cont_proc  number(8) := 0;
  wcont_proc number(8) := 0;
  
  -------------------- Memoria de Calculo ------------------------- 
  mc_flg_log_calc         TB_FOLHA_PAGAMENTO_DET.flg_log_calc%type;
  mc_cod_formula_cond     TB_FOLHA_PAGAMENTO_DET.cod_formula_cond%type;
  mc_des_condicao         TB_FOLHA_PAGAMENTO_DET.des_condicao%type;
  mc_cod_formula_rubrica  TB_FOLHA_PAGAMENTO_DET.cod_formula_rubrica%type;
  mc_des_formula          TB_FOLHA_PAGAMENTO_DET.des_formula%type;
  mc_des_composicao       TB_FOLHA_PAGAMENTO_DET.des_composicao%type;

  -- Variaveis para tratamento de erro

  P_MSGERRO       VARCHAR2(1500) := null;
  P_CODERRO       VARCHAR2(15);
  P_SUB_PROC_ERRO VARCHAR2(40);

  -- Cursores
  type curform is ref cursor;
  type curesp  is ref cursor;
  type curparc is ref cursor;

  -- Tipos especiais

  type typcaln  is table of  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
  type typcalt  is table of  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
  type typcalv  is table of  TB_VALOR_NPAGO_RET_ATIVO%rowtype;
  type valstr20 is table of varchar2(30);
  type valstr10 is table of varchar2(10);
  type valnum18 is table of number(18, 4);
  type ValTra   is table of number;

  type conceito     is table of number;
  type rubricas     is table of number;
  type rubricas_seg is table of number;

  type rubricas_tipo       is table of varchar2(5);
  type entidade            is table of number;
  type flg_ded             is table of varchar2(5);
  type flg_base            is table of varchar2(5);
  type flg_rateio          is table of varchar2(5);
  type flg_evento          is table of varchar2(5);
  type flg_evento_especial is table of varchar2(5);
  type flg_grava_detalhe   is table of varchar2(1);
  type sal_base            is table of number(18, 4) index by binary_integer;
  type t_sal_base          is table of sal_base index by binary_integer;
  type PARAM               is table of TB_DET_PARAM_ESTRUTURA%ROWTYPE;
  type beneficio           is table of number;
  type totvar              is table of TB_VARIAVEIS%ROWTYPE;
  type rubricas_exc        is table of tb_rubricas_exc_serv_ben%rowtype;

  type cargo is table of number index by binary_integer;
  type t_cargo is table of cargo index by binary_integer;

  v_cargo t_cargo;

  --    type rubricas_excesso is table of tb_rubricas_excesso_ben%rowtype;

  type folha    is table of TB_FOLHA_PAGAMENTO%ROWTYPE;
  type folha_pa is table of TB_FOLHA_PA%ROWTYPE;

  v_sal_base        t_sal_base;
  vi_base_ir_arr    t_sal_base;
  vi_base_ir_arr_13 t_sal_base;
  v_base_prev       t_sal_base;
  v_base_teto       t_sal_base;
  v_base_teto_cheio t_sal_base;
  VI_PERC_IR        t_sal_base;
  VI_PERC_IR13       t_sal_base;
  VI_MARGEM_CONSIG  t_sal_base;
----- Agregado Controle de Base de Ir Deducida
----- 12-06-2011
   vi_base_ir_arr_ded    t_sal_base;


  --    v_val_ir       t_sal_base;
  fdcd    TB_DET_CALCULADO_ESTRUC%rowtype;

  rfol    TB_FOLHA_PAGAMENTO%ROWTYPE; -- Armazena Totais
  rdcn    TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe calculado normal
  rdct    TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe calculado para Terceiros
  irdcn   TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe para IR
  rdcd    TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe para Desconto
  rpval   TB_DET_PARAM_ESTRUTURA%ROWTYPE; --Amazena o valor do parametro
  rvar    TB_VARIAVEIS%ROWTYPE; --Armazena a variavel para o calculo de total
  parcela TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe calculado normal
  rfol_pa TB_FOLHA_PA%ROWTYPE; -- Armazena Totais somente para PA
  rdcn_pa TB_DET_CALCULADO_PA%rowtype; -- Armazena detalhe calculado para PA
  rub_exc TB_RUBRICAS_EXC_SERV_BEN%rowtype;

  --    rub_excesso  TB_RUBRICAS_EXCESSO_BEN%rowtype;
  -- para o retroativo

  ret_rdcn          TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe calculado para o retroativo
  ret_rdcn_ref      TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- Armazena detalhe calculado para o retroativo data de referencia
  ret_vnpago_rdcn   TB_VALOR_NPAGO_RET_ATIVO%rowtype; -- Armazena detalhe calculado para o retroativo valor n pago
  --

  -- Indices para Arrais
  idx_caln        number(8);
  idx_calt        number(8);
  idx_folha       number(3);
  idx_cald        number(8);
  idx_param       number(3);
  idx_totvar      number(3);
  idx_parcela     number(4);
  idx_ret13       number(4);
  idx_seq_detalhe number(4);
  idx_elemento    number(4);
  idx_rubexc      number(4);
  idx_rubexcesso  number(4);
  p               number(3);
  d               number(3);

  idx_ret     number(8);
  idx_ret_ref number(8);

  idx_folha_pa number(4);
  idx_caln_pa  number(8);

  -- Vectores


  type typbene is table of TB_BENEFICIARIO%rowtype;
  R_beneficiario           TB_BENEFICIARIO%rowtype; -- Armazena detalhe calculado normal
  T_beneficiario           typbene  := typbene ();
  ----



  tdcn            typcaln      := typcaln(); -- Vetor para armazenar dados por Rubrica
  tdcn_pa         typcaln      := typcaln(); -- Vetor para armazenar dados por Rubrica PA
  tdct            typcalt      := typcalt();
  tdcd            typcalt      := typcalt(); -- Vetor para armazenar dados Desconto
  pdcn            typcalt      := typcalt(); -- Vetor para armazenar dados calculo Pensao
  tdca            typcalt      := typcalt(); -- Vetor para armazenar Retroativo 13?
  vfolha          folha        := folha(); --  Vetor para armazenar dados por beneficio
  vfolha_pa       folha_pa     := folha_pa(); --  Vetor para armazenar dados PA
  parc            typcalt      := typcalt(); -- Vetor para armazenar dados do parcelamento
  val_taxa_prev   valnum18     := valnum18();
  lim_taxa_prev   valnum18     := valnum18();
  dsc_taxa_prev   valnum18     := valnum18();
  vi_ir_ret       valnum18     := valnum18();
  v_cod_beneficio beneficio    := beneficio();
  vparam          param        := param(); -- Vetor para armazenar valores de parametros no periodo
  vrubexc         rubricas_exc := rubricas_exc();
  vtotvar totvar               := totvar();

  ret_tdcn       typcaln := typcaln(); -- Vetor para armazenar dados por Rubrica no retroativo
  ret_tdcn_ref   typcaln := typcaln(); -- Vetor para armazenar dados por Rubrica no retroativo por data de referencia
  ret_tval_npago typcalv := typcalv(); -- Vatoer pra armazenar dados por Rubrica no retroativo valor n pago


  --  Vetores IR
  cod_con             conceito   := conceito();
  cod_rub             rubricas   := rubricas();
  flag_ded            flg_ded    := flg_ded();
  flag_base           flg_base   := flg_base();
  flag_rateio         flg_rateio := flg_rateio();
  tip_evento          flg_evento := flg_evento();
  tip_evento_especial flg_evento_especial := flg_evento_especial();
  cod_entidade        entidade            := entidade();
  ind_grava_detalhe   flg_grava_detalhe   := flg_grava_detalhe();

 --- Controle de Ir
  cod_con2             conceito := conceito();
  cod_rub2             rubricas := rubricas();
  flag_base2           flg_base := flg_base();
  flag_ded2            flg_ded := flg_ded();
  tip_evento2          flg_evento := flg_evento();
  tip_evento_especial2 flg_evento_especial := flg_evento_especial();
  flag_ded_Legal       flg_ded := flg_ded();




  type IRPARAM is table of TB_DET_PARAM_ESTRUTURA%ROWTYPE index by binary_integer;
  type typir is table of IRPARAM index by binary_integer;
  --  type ttypir is table of typir index by binary_integer;

  reg_ttypir typir;

  -- Variaveis para formatacao do campo info contra-cheque
  QTD_HORAS_JORNADA NUMBER(5, 2) := 0;

  NOM_VARIAVEL valstr20 := valstr20();
  VAL_VARIAVEL valnum18 := valnum18();

  -- Para formula
  rubricas_tipos           rubricas_tipo:=rubricas_tipo();
  ------------------------------------------------
  cod_elemento             valstr20 := valstr20();
  tip_elemento             valstr10 := valstr10();
  val_elemento             valnum18 := valnum18();
  vas_elemento             valstr20 := valstr20();
  vas_informacao           valstr20 := valstr20();
  cod_fcrubrica            rubricas := rubricas();
  --- CONTROLE DE PA
  cod_fcrubrica_seg        rubricas_seg := rubricas_seg();
  cod_beneficiario         valstr20     := valstr20();
  a_beneficio              beneficio    := beneficio();
  cod_beneficiario_redutor valstr20     := valstr20();
  cod_fcrubrica_redutor    rubricas     := rubricas();
  a_beneficio_redutor      beneficio    := beneficio();
  num_funcao               valtra       := valtra();
  lim_funcao               NUMBER       := 0;
  vi_condicao              BOOLEAN;
  vi_sem_condicao          BOOLEAN;
  VI_TOT_DED               NUMBER(18, 4) := 0;
  VI_TOT_DED_RUB           NUMBER(18, 4) := 0;
  VI_TOT_DED_ANT           NUMBER(18, 4) := 0;
  ------------- IR REAL DE DESCONTO IR ----- ROBERTO
  VI_TOT_DED_RUB_REAL      NUMBER(18, 4) := 0;
 --- VARIAVEIS UTILIZADAS PARA IR ACUMULADO.

  Global_num_funcao   number :=0;
  tdcn_IRRF          typcaln := typcaln(); -- Armazena detalhe calculado normal Perioo Atual
  tdcn_IRRF_RETRO    typcaln := typcaln(); -- Armazena detalhe calculado normal Periodo Anterior
  tdcn_ACUMULADO     typcaln := typcaln(); -- Armazena detalhe calculado normal da competencia
  tdcn_ACUMULADO_13  typcaln := typcaln(); -- Armazena detalhe de 13 Calculado  da competencia

-- Implementa IR diferenciado para 13
  tdcn_IRRF_RETRO13   typcaln := typcaln(); -- Armazena detalhe calculado normal Periodo Anterior
  IDX_IRRF_RETRO13     number:=0;


  ---- Variavies para o novo Calculo de Ir

  IDX_IRRF                number:=0;
  IDX_IRRF_RETRO          number:=0;
  IDX_IRRF_HISTO          number:=0;
  QTA_MESES               number:=0;
  QTA_MESES13             number:=0;
  --- Variaveis de Calculo
  V_BASE_BRUTA_IRRF       number:=0;
  V_BASE_BRUTA_13_IRRF    number:=0;
  V_BASE_IR_IRRF          number:=0;
    ---- Data ----
  DAT_INI_IRRF_RETRO      date;
  DAT_FIM_IRRF_RETRO      date;
  DAT_INI_IRRF_HIST       date;
  DAT_FIM_IRRF_HIST       date;

  ---------------------
  VI_IR_ACUMULADA         number;
  VI_DAT_INI_IR           date;
  VI_DAT_TER_IR           date;
 ----------------------

  PER_ANTERIOR            date;
  PER_HANTERIOR           date;

  V_VAL_IR_RETRO          number(18, 4);
  V_VAL_IR_HISTO          number(18, 4);
-----------------------
  ---  Definic?o de Vetor de Meses
  TYPE VETOR_MES IS VARRAY (13) OF NUMBER (1);
  MESES_IRRF  VETOR_MES;


  -- Para Reprocesso
  num_cpf valstr20 := valstr20();
  ide_cli valstr20 := valstr20();
  -- Para controle IR de Pagamento.

  type typdatpag is table of TB_GRUPO_PAGAMENTO_ESTRUC%rowtype;
  tgrup          typdatpag :=typdatpag();

  PAG_NUM_GRP_PAG         number;
  PAG_DAT_PAGAMENTO       date;

  ----- Variaveis 133
  COM_COD_BENE_DIF_VENC       NUMBER;
  COM_CARGO_DIF_VENC          NUMBER;
  COM_COD_RUBRICA_DIF         NUMBER(8);
  COM_FLG_MUDA_BASE           CHAR  (1);
  mon_dif_venc_calculo        number(18, 4);
  COM_COD_REFERENCIA_DIF      NUMBER(8);

  COM_CONCEITO_DIF_VENC       NUMBER;
  COM_ENTIDADE_DIF_VENC       NUMBER;

  ----- Data de Incorporac?o -----
  COM_DAT_INCORP_RUB         DATE;
  COM_COD_CARGO_RUB          NUMBER;
  COM_COD_REFERENCIA_RUB     NUMBER;
  COM_COD_TABELA             VARCHAR2(3);
------ VARIAVEIS ART 133  -- Despues de Definic?o de cursores...
  vi_sem_condicao_rec      BOOLEAN;
  cod_elemento_rec         valstr20 := valstr20();
  tip_elemento_rec         valstr10 := valstr10();
  val_elemento_rec         valnum18 := valnum18();
  vas_elemento_rec         valstr20 := valstr20();
  num_funcao_rec           valtra := valtra();
  lim_funcao_rec           NUMBER := 0;
  vi_condicao_rec          BOOLEAN;
  idx_elemento_rec         number(4);
  COM_TIPO_BASE            VARCHAR2(1);
  COM_VAL_PORC_IND_133    NUMBER(18, 5):=0;
------  Art 133
  tdvenc            typcaln := typcaln(); -- Vetor para armazenar dados por Rubrica
  tdvenc_nor        typcaln := typcaln(); -- Vetor para armazenar dados por Rubrica

  -- Cursor sobre Beneficios
  CURSOR CURATIV IS
  -- POR BENEFICIO PREVIDENCIARIO
    SELECT DISTINCT /*+ RULE */ B.COD_IDE_CLI      AS BEN_IDE_CLI    ,
                    P.NUM_CPF                      AS BEN_NUM_CPF    ,
                    P.NOM_PESSOA_FISICA            AS BEN_NOME       ,
                    P.DAT_NASC                     AS BEN_DAT_NASC   ,
                   'B'                             AS BEN_TIPO_PESSOA,
                   'A'                             AS BEN_FLG_STATUS ,
                    0                              AS COM_TIPO_DISSOCIACAO,
                    P.FLG_ENVIO_CORREIO            AS COM_COD_ENVIO_CORREIO
      FROM TB_RELACAO_FUNCIONAL      B ,
           TB_PESSOA_FISICA          P ,
           TB_GRUPO_PAGAMENTO        GP,
           TB_CONTROLE_PROCESSAMENTO CP
     WHERE B.COD_INS             = PAR_COD_INS
       AND B.COD_ENTIDADE        = nvl(PAR_COD_ENTIDADE, B.COD_ENTIDADE)
       AND B.COD_IDE_CLI    >= 0
       AND P.COD_INS            = B.COD_INS
       AND P.COD_IDE_CLI        = B.COD_IDE_CLI
       AND (P.NUM_CPF >= PAR_NUM_CPF and PAR_PARTIR_DE = 'S')
       and GP.NUM_GRP_PAG        > 0
       AND GP.NUM_GRP_PAG       = PAR_NUM_GRP_PAG
       AND b.cod_proc_grp_pag   =  gp.cod_proc_grp_pago
       AND CP.COD_INS           = B.COD_INS
       AND CP.NUM_PROCESSO      = PAR_NUM_PROCESSO
       AND CP.SEQ_PROCESSAMENTO = PAR_NUM_SEQ_PROC
       AND P.NUM_CPF            >= CP.NUM_CPF_INICIAL
       AND P.NUM_CPF            < CP.NUM_CPF_FINAL
       AND B.COD_SIT_FUNC       =1
    Union All
    SELECT DISTINCT /*+ RULE */ B.COD_IDE_CLI  AS BEN_IDE_CLI    ,
                    P.NUM_CPF                      AS BEN_NUM_CPF    ,
                    P.NOM_PESSOA_FISICA            AS BEN_NOME       ,
                    P.DAT_NASC                     AS BEN_DAT_NASC   ,
                   'B'                             AS BEN_TIPO_PESSOA,
                   'A'                             AS BEN_FLG_STATUS ,
                    0                              AS COM_TIPO_DISSOCIACAO,
                    P.FLG_ENVIO_CORREIO COM_COD_ENVIO_CORREIO
      FROM TB_RELACAO_FUNCIONAL      B,
           TB_PESSOA_FISICA          P,
           TB_GRUPO_PAGAMENTO        GP,
           TB_CONTROLE_PROCESSAMENTO CP
     WHERE B.COD_INS = PAR_COD_INS
       AND B.COD_ENTIDADE = nvl(PAR_COD_ENTIDADE, B.COD_ENTIDADE)
       AND P.COD_INS = B.COD_INS
       AND B.COD_IDE_CLI  >= 0
       AND P.COD_IDE_CLI = B.COD_IDE_CLI
       AND (P.NUM_CPF = nvl(PAR_NUM_CPF, P.NUM_CPF) and PAR_PARTIR_DE = 'N')
       and GP.NUM_GRP_PAG > 0
       AND (      (PAR_NUM_CPF IS NULL AND GP.NUM_GRP_PAG = PAR_NUM_GRP_PAG) --ROD7
              OR  (PAR_NUM_CPF IS NOT NULL )
            )
       AND b.cod_proc_grp_pag    =  gp.cod_proc_grp_pago
       AND CP.COD_INS = B.COD_INS
       AND CP.NUM_PROCESSO = PAR_NUM_PROCESSO
       AND CP.SEQ_PROCESSAMENTO = PAR_NUM_SEQ_PROC
       AND P.NUM_CPF >= CP.NUM_CPF_INICIAL
       AND P.NUM_CPF < CP.NUM_CPF_FINAL
      AND B.COD_SIT_FUNC      =1
  ORDER BY BEN_TIPO_PESSOA, BEN_NUM_CPF;

  -- Cursor sobre composic?o DO BENEFICIO
  CURSOR CUR_COMPATIV IS
    SELECT  BB.COD_IDE_CLI                    AS COM_COD_IDE_CLI,
            BB.NUM_MATRICULA                  AS COM_NUM_MATRICULA,
            BB.COD_IDE_REL_FUNC               AS COM_COD_IDE_REL_FUNC,
            BB.COD_ENTIDADE                   AS COM_ENTIDADE     ,
           'ATIVO'                            AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA                     AS COM_COD_RUBRICA  ,
           FC.COD_FCRUBRICA                   AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG                         AS COM_SEQ_VIG_FC   ,
           'B'                                AS COM_NAT_COMP     ,
           null                               AS COM_NUM_ORD_JUD ,
           null                               AS COM_IDE_CLI_INSTITUIDOR,
           CE.VAL_FIXO                        AS COM_VAL_FIXO_IND,
           CE.VAL_PORC                        AS COM_VAL_PORC_IND,
           CE.VAL_UNIDADE                     AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE                     AS COM_VAL_UNID,
           FC.TIP_VALOR                       AS COM_TIPO_VALOR,
           'N'                                AS COM_IND_QTAS,
           0                                  AS COM_NUM_QTAS_PAG,
           0                                  AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP                        AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA                    AS COM_NAT_RUB,
           null                               AS COM_INI_REF,
           null                               AS COM_FIM_REF,
           FC.NUM_PRIORIDADE                  AS COM_PRIORIDADE,
           CP.FLG_DED_IR                      AS COM_DED_IR,
           RP.FLG_PROCESSA                    AS COM_FLG_PROCESSA,
           CP.NAT_VAL                         AS COM_NAT_VAL,
           FC.TIP_APLICACAO                   AS COM_TIPO_APLICACAO,
           100                                AS COM_PERCENT_BEN,
           nvl(RR.TIP_EVENTO_ESPECIAL, 'N')   AS COM_TIPO_EVENTO_ESPECIAL     ,
           BC.NUM_MATRICULA                   AS COM_MATRICULA              ,
           /*EC.COD_CARGO  */            NULL AS COM_CARGO                  ,
           /*EC.COD_CARGO_APOS*/         NULL AS COM_CARGO_APOS             ,
           BB.DAT_INI_EXERC                   AS BEN_DAT_INICIO             ,
           BB.DAT_FIM_EXERC                   AS BEN_DAT_FIM                ,
           CE.DAT_INI_VIG                     AS COM_DAT_INI_VIG            ,
           CE.DAT_FIM_VIG                     AS COM_DAT_FIM_VIG            ,
           null                               AS COM_COD_IDE_CLI_BEN        ,
           FC.MSC_INFORMACAO                  AS COM_MSC_INFORMACAO         ,
           FC.COL_INFORMACAO                  AS COM_COL_INFORMACAO         ,
           1                                  AS COM_PORC_VIG               ,
           RR.DAT_FIM_VIG                     AS COM_DAT_VIG_RUBRICA        ,
           FC.FLG_APLICA_RATEIO               AS COM_APLICA_RATEIO          ,
           CE.SEQ_VIG                         AS COM_SEQ_VIG                ,
           0                                  AS COM_NUM_CARGA              ,
           0                                  AS COM_NUM_SEQ_CONTROLE_CARGA ,
            BB.COD_PROC_GRP_PAG              AS COM_NUM_GRUPO_PAG,
           'N'                                AS COM_RUBRICA_TIPO,
          /* BB.FLG_STATUS*/ 'A'              AS COM_FLG_STATUS,
           to_date('01/01/1901','dd/mm/yyyy') AS  COM_DAT_CONTRATO,
           0                                  AS COM_COD_CONVENIO  ,
           0                                  AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO                   AS  COM_COD_CONCEITO
           ,CE.COD_CARGO                      AS  COM_COD_CARGO_RUB
           ,CE.COD_REFERENCIA                 AS  COM_COD_REFERENCIA_RUB

     FROM TB_COMPOSICAO_PAG       CE,
           TB_RELACAO_FUNCIONAL   BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_RELACAO_FUNCIONAL   BC,
           TB_CONCEITOS_PAG       CP


     WHERE BB.COD_INS         = PAR_COD_INS
       AND BB.COD_IDE_CLI     = ben_ide_cli
       AND BB.COD_INS         = CE.COD_INS
       AND BB.COD_IDE_CLI     = CE.COD_IDE_CLI
       AND BB.NUM_MATRICULA   = CE.NUM_MATRICULA
       AND BB.COD_IDE_REL_FUNC= CE.COD_IDE_REL_FUNC
       AND BB.COD_ENTIDADE    = CE.COD_ENTIDADE
       ------------ Bloco 1 ----------------

       AND BC.COD_INS         = BB.COD_INS
       AND BC.COD_IDE_CLI     = BB.COD_IDE_CLI
       AND BC.NUM_MATRICULA   = BB.NUM_MATRICULA
       AND BC.COD_ENTIDADE    = BB.COD_ENTIDADE
       AND BC.COD_IDE_REL_FUNC=BB.COD_IDE_REL_FUNC

       ----- Falta Controle de vinculo Ativo -----
        AND BB.COD_ENTIDADE = RR.COD_ENTIDADE

       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND FC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND CE.COD_INS = BB.COD_INS

       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CE.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CE.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CE.COD_FCRUBRICA
       AND FC.TIP_APLICACAO = 'I'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND CE.FLG_STATUS = 'V'
       AND BB.COD_SIT_FUNC      =1
    ----------- Controle de Datas  Vigencia de Vinculos ----------
       AND ((
             to_char(PAR_PER_PRO, 'YYYYMM')    >=
             to_char(bb.dat_ini_exerc, 'YYYYMM') AND
             to_char(PAR_PER_PRO, 'YYYYMM')    <=
             to_char(nvl(bb.dat_fim_exerc, to_date('01/01/2045', 'dd/mm/yyyy')),'YYYYMM')
           )
      -- 18052023
      or
             (
             to_char(PAR_PER_PRO, 'YYYYMM')    <=
             --Yumi em 04/07/2018:
             --Para rescisoes com data de fim no ultimo dia do mes anterior n?o esta calculando rubricas gerais
             to_char((bb.dat_rescisao+2),'YYYYMM')
             )
          )
    --------------------------------------------------------------

   UNION ALL
       SELECT  BB.COD_IDE_CLI                    AS COM_COD_IDE_CLI,
            BB.NUM_MATRICULA                  AS COM_NUM_MATRICULA,
            BB.COD_IDE_REL_FUNC               AS COM_COD_IDE_REL_FUNC,
            BB.COD_ENTIDADE                   AS COM_ENTIDADE     ,
           'ATIVO'                            AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA                     AS COM_COD_RUBRICA  ,
           FC.COD_FCRUBRICA                   AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG                         AS COM_SEQ_VIG_FC   ,
           'I'                                AS COM_NAT_COMP     ,
           NULL                               AS COM_NUM_ORD_JUD  ,
           NULL                               AS COM_IDE_CLI_INSTITUIDOR,
           CI.VAL_FIXO                        AS COM_VAL_FIXO_IND,
           CI.VAL_PORC                        AS COM_VAL_PORC_IND,
           CI.VAL_UNIDADE                     AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE                     AS COM_VAL_UNID,
           FC.TIP_VALOR                       AS COM_TIPO_VALOR,
           'N'                                AS COM_IND_QTAS,
           0                                  AS COM_NUM_QTAS_PAG,
           0                                  AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP                        AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA                    AS COM_NAT_RUB,
           CI.DAT_INI_REF                    AS COM_INI_REF,
           CI.DAT_FIM_REF                    AS COM_FIM_REF,
           FC.NUM_PRIORIDADE                  AS COM_PRIORIDADE,
           CP.FLG_DED_IR                      AS COM_DED_IR,
           RP.FLG_PROCESSA                    AS COM_FLG_PROCESSA,
           CP.NAT_VAL                         AS COM_NAT_VAL,
           FC.TIP_APLICACAO                   AS COM_TIPO_APLICACAO,
           100                                AS COM_PERCENT_BEN,
           nvl(RR.TIP_EVENTO_ESPECIAL, 'N')   AS COM_TIPO_EVENTO_ESPECIAL     ,
           BB.NUM_MATRICULA                   AS COM_MATRICULA              ,
           /*EC.COD_CARGO  */            NULL AS COM_CARGO                  ,
           /*EC.COD_CARGO_APOS*/         NULL AS COM_CARGO_APOS             ,
           BB.DAT_INI_EXERC                   AS BEN_DAT_INICIO             ,
           BB.DAT_FIM_EXERC                   AS BEN_DAT_FIM                ,
           CI.DAT_INI_VIG                     AS COM_DAT_INI_VIG            ,
           CI.DAT_FIM_VIG                     AS COM_DAT_FIM_VIG            ,
           CI.COD_IDE_CLI_BEN                 AS COM_COD_IDE_CLI_BEN        ,
           FC.MSC_INFORMACAO                  AS COM_MSC_INFORMACAO         ,
           FC.COL_INFORMACAO                  AS COM_COL_INFORMACAO         ,
           1                                  AS COM_PORC_VIG               ,
           RR.DAT_FIM_VIG                     AS COM_DAT_VIG_RUBRICA        ,
           FC.FLG_APLICA_RATEIO               AS COM_APLICA_RATEIO          ,
           FC.SEQ_VIG                         AS COM_SEQ_VIG                ,
           0                                  AS COM_NUM_CARGA              ,
           0                                  AS COM_NUM_SEQ_CONTROLE_CARGA ,
           BB.COD_PROC_GRP_PAG               AS COM_NUM_GRUPO_PAG,
           'N'                                AS COM_RUBRICA_TIPO,
          /* BB.FLG_STATUS*/ 'A'              AS COM_FLG_STATUS,
           to_date('01/01/1901','dd/mm/yyyy') AS  COM_DAT_CONTRATO,
           0                                  AS COM_COD_CONVENIO  ,
           0                                  AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO                   AS  COM_COD_CONCEITO
           ,NULL                              AS  COM_COD_CARGO_RUB
           ,NULL                              AS  COM_COD_REFERENCIA_RUB

----------------------------
/*
            BB.COD_PROC_GRP_PAG              AS COM_NUM_GRUPO_PAG,
           'N'                                AS COM_RUBRICA_TIPO,
          \* BB.FLG_STATUS*\ 'A'              AS COM_FLG_STATUS,
           to_date('01/01/1901','dd/mm/yyyy') AS  COM_DAT_CONTRATO,
           0                                  AS COM_COD_CONVENIO  ,
           0                                  AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO                   AS  COM_COD_CONCEITO
           ,CE.COD_CARGO                      AS  COM_COD_CARGO_RUB
           ,CE.COD_REFERENCIA                 AS  COM_COD_REFERENCIA_RUB*/

   FROM    TB_COMPOSICAO_PAG_EVENTUAL  CI,
           TB_RELACAO_FUNCIONAL   BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCEITOS_PAG       CP

     WHERE BB.COD_INS          = PAR_COD_INS
       AND BB.COD_IDE_CLI      = ben_ide_cli
       AND BB.COD_INS          = CI.COD_INS
       AND BB.COD_IDE_CLI      = CI.COD_IDE_CLI
       AND BB.COD_ENTIDADE     = CI.COD_ENTIDADE
       AND BB.NUM_MATRICULA    = CI.NUM_MATRICULA
       AND BB.COD_IDE_REL_FUNC = CI.COD_IDE_REL_FUNC

       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_EXERC, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_EXERC +2, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))

       AND CI.FLG_STATUS = 'V'
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = FC.COD_ENTIDADE
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CI.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CI.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CI.COD_FCRUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.TIP_APLICACAO = 'I'
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND BB.COD_SIT_FUNC      =1


  UNION ALL
    SELECT  BB.COD_IDE_CLI                    AS COM_COD_IDE_CLI,
            BB.NUM_MATRICULA                  AS COM_NUM_MATRICULA,
            BB.COD_IDE_REL_FUNC               AS COM_COD_IDE_REL_FUNC,
            BB.COD_ENTIDADE                   AS COM_ENTIDADE     ,
           'ATIVO'                            AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA                     AS COM_COD_RUBRICA  ,
           FC.COD_FCRUBRICA                   AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG                         AS COM_SEQ_VIG_FC   ,
           'G'                                AS COM_NAT_COMP,
           null                               AS COM_NUM_ORD_JUD ,
           null                               AS COM_IDE_CLI_INSTITUIDOR,
           NULL                               AS COM_VAL_FIXO_IND,
           NULL                               AS COM_VAL_PORC_IND,
           NULL                               AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE                     AS COM_VAL_UNID,
           FC.TIP_VALOR                       AS COM_TIPO_VALOR,
           'N'                                AS COM_IND_QTAS,
           0                                  AS COM_NUM_QTAS_PAG,
           0                                  AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP                        AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA                    AS COM_NAT_RUB,
           null                               AS COM_INI_REF,
           null                               AS COM_FIM_REF,
           FC.NUM_PRIORIDADE                  AS COM_PRIORIDADE,
           CP.FLG_DED_IR                      AS COM_DED_IR,
           RP.FLG_PROCESSA                    AS COM_FLG_PROCESSA,
           CP.NAT_VAL                         AS COM_NAT_VAL,
           FC.TIP_APLICACAO                   AS COM_TIPO_APLICACAO,
           100                                AS COM_PERCENT_BEN,
           nvl(RR.TIP_EVENTO_ESPECIAL, 'N')   AS COM_TIPO_EVENTO_ESPECIAL     ,
           BC.NUM_MATRICULA                   AS COM_MATRICULA              ,
           /*EC.COD_CARGO  */            NULL AS COM_CARGO                  ,
           /*EC.COD_CARGO_APOS*/         NULL AS COM_CARGO_APOS             ,
           BB.DAT_INI_EXERC                   AS BEN_DAT_INICIO             ,
           BB.DAT_FIM_EXERC                   AS BEN_DAT_FIM                ,
           BB.DAT_INI_EXERC                   AS COM_DAT_INI_VIG            ,
           BB.DAT_FIM_EXERC                   AS COM_DAT_FIM_VIG            ,
           null                               AS COM_COD_IDE_CLI_BEN        ,
           FC.MSC_INFORMACAO                  AS COM_MSC_INFORMACAO         ,
           FC.COL_INFORMACAO                  AS COM_COL_INFORMACAO         ,
           1                                  AS COM_PORC_VIG               ,
           RR.DAT_FIM_VIG                     AS COM_DAT_VIG_RUBRICA        ,
           FC.FLG_APLICA_RATEIO               AS COM_APLICA_RATEIO          ,
           FC.SEQ_VIG                         AS COM_SEQ_VIG                ,
           0                                  AS COM_NUM_CARGA              ,
           0                                  AS COM_NUM_SEQ_CONTROLE_CARGA ,
           BB.COD_PROC_GRP_PAG                AS COM_NUM_GRUPO_PAG,
           'N'                                AS COM_RUBRICA_TIPO,
          /* BB.FLG_STATUS*/ 'A'              AS COM_FLG_STATUS,
           to_date('01/01/1901','dd/mm/yyyy') AS  COM_DAT_CONTRATO,
           0                                  AS COM_COD_CONVENIO  ,
           0                                  AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO                   AS  COM_COD_CONCEITO
           ,NULL                              AS  COM_COD_CARGO_RUB
           ,NULL                              AS  COM_COD_REFERENCIA_RUB

     FROM
           TB_RELACAO_FUNCIONAL   BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_RELACAO_FUNCIONAL   BC,
           TB_CONCEITOS_PAG       CP


     WHERE BB.COD_INS         = PAR_COD_INS
       AND BB.COD_IDE_CLI     = ben_ide_cli

       ------------ Bloco 1 ----------------

       AND BC.COD_INS         = BB.COD_INS
       AND BC.COD_IDE_CLI     = BB.COD_IDE_CLI
       AND BC.NUM_MATRICULA   = BB.NUM_MATRICULA
       AND BC.COD_ENTIDADE    = BB.COD_ENTIDADE
       AND BC.COD_IDE_REL_FUNC=BB.COD_IDE_REL_FUNC

       ----- Falta Controle de vinculo Ativo -----
        AND BB.COD_ENTIDADE = RR.COD_ENTIDADE

       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND FC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND FC.COD_INS = BB.COD_INS
       AND FC.TIP_APLICACAO = 'G'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND BB.COD_SIT_FUNC      =1

    ----------- Controle de Datas  Vigencia de Vinculos ----------
       AND ((
             to_char(PAR_PER_PRO, 'YYYYMM')    >=
             to_char(bb.dat_ini_exerc, 'YYYYMM') AND
             to_char(PAR_PER_PRO, 'YYYYMM')    <=
             to_char(nvl(bb.dat_fim_exerc, to_date('01/01/2045', 'dd/mm/yyyy')),'YYYYMM')
           )
      -- 18052023
      or
             (
             to_char(PAR_PER_PRO, 'YYYYMM')    <=
             --Yumi em 04/07/2018:
             --Para rescisoes com data de fim no ultimo dia do mes anterior n?o esta calculando rubricas gerais
             to_char((bb.dat_rescisao+2),'YYYYMM')
             )
          )
    --------------------------------------------------------------
   UNION ALL
       SELECT  BB.COD_IDE_CLI                    AS COM_COD_IDE_CLI,
            BB.NUM_MATRICULA                  AS COM_NUM_MATRICULA,
            BB.COD_IDE_REL_FUNC               AS COM_COD_IDE_REL_FUNC,
            BB.COD_ENTIDADE                   AS COM_ENTIDADE     ,
           'ATIVO'                            AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA                     AS COM_COD_RUBRICA  ,
           FC.COD_FCRUBRICA                   AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG                         AS COM_SEQ_VIG_FC   ,
           'C'                                AS COM_NAT_COMP,
           NULL                               AS COM_NUM_ORD_JUD  ,
           NULL                               AS COM_IDE_CLI_INSTITUIDOR,
           CI.VAL_TOT_CONSIG                  AS COM_VAL_FIXO_IND,
           NULL                               AS COM_VAL_PORC_IND,
           NULL                               AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE                     AS COM_VAL_UNID,
           FC.TIP_VALOR                       AS COM_TIPO_VALOR,
           'N'                                AS COM_IND_QTAS,
           0                                  AS COM_NUM_QTAS_PAG,
           0                                  AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP                        AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA                    AS COM_NAT_RUB,
           CI.DAT_INI_REF                     AS COM_INI_REF,
           CI.DAT_FIM_REF                     AS COM_FIM_REF,
           FC.NUM_PRIORIDADE                  AS COM_PRIORIDADE,
           CP.FLG_DED_IR                      AS COM_DED_IR,
           RP.FLG_PROCESSA                    AS COM_FLG_PROCESSA,
           CP.NAT_VAL                         AS COM_NAT_VAL,
           FC.TIP_APLICACAO                   AS COM_TIPO_APLICACAO,
           100                                AS COM_PERCENT_BEN,
           nvl(RR.TIP_EVENTO_ESPECIAL, 'N')   AS COM_TIPO_EVENTO_ESPECIAL     ,
           BB.NUM_MATRICULA                   AS COM_MATRICULA              ,
           /*EC.COD_CARGO  */            NULL AS COM_CARGO                  ,
           /*EC.COD_CARGO_APOS*/         NULL AS COM_CARGO_APOS             ,
           BB.DAT_INI_EXERC                   AS BEN_DAT_INICIO             ,
           BB.DAT_FIM_EXERC                   AS BEN_DAT_FIM                ,
           CI.DAT_INI_VIG                     AS COM_DAT_INI_VIG            ,
           CI.DAT_FIM_VIG                     AS COM_DAT_FIM_VIG            ,
           null                               AS COM_COD_IDE_CLI_BEN        ,
           FC.MSC_INFORMACAO                  AS COM_MSC_INFORMACAO         ,
           FC.COL_INFORMACAO                  AS COM_COL_INFORMACAO         ,
           1                                  AS COM_PORC_VIG               ,
           RR.DAT_FIM_VIG                     AS COM_DAT_VIG_RUBRICA        ,
           FC.FLG_APLICA_RATEIO               AS COM_APLICA_RATEIO          ,
           FC.SEQ_VIG                         AS COM_SEQ_VIG                ,
           0                                  AS COM_NUM_CARGA              ,
           0                                  AS COM_NUM_SEQ_CONTROLE_CARGA ,
           BB.COD_PROC_GRP_PAG         AS COM_NUM_GRUPO_PAG,
           'N'                                AS COM_RUBRICA_TIPO,
          /* BB.FLG_STATUS*/ 'A'              AS COM_FLG_STATUS,
           to_date('01/01/1901','dd/mm/yyyy') AS  COM_DAT_CONTRATO,
           0                                  AS COM_COD_CONVENIO  ,
           0                                  AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO                   AS  COM_COD_CONCEITO
           ,NULL                              AS  COM_COD_CARGO_RUB
           ,NULL                              AS  COM_COD_REFERENCIA_RUB


   FROM    TB_COMPOSICAO_PAG_CONSIG   CI,
           TB_RELACAO_FUNCIONAL   BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCEITOS_PAG       CP

     WHERE BB.COD_INS          = PAR_COD_INS
       AND BB.COD_IDE_CLI      = ben_ide_cli
       AND BB.COD_INS          = CI.COD_INS
       AND BB.COD_IDE_CLI      = CI.COD_IDE_CLI
       AND BB.COD_ENTIDADE     = CI.COD_ENTIDADE
       AND BB.NUM_MATRICULA    = CI.NUM_MATRICULA
       AND BB.COD_IDE_REL_FUNC = CI.COD_IDE_REL_FUNC

       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_EXERC, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_EXERC, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))

       AND CI.FLG_STATUS = 'V'
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = FC.COD_ENTIDADE
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CI.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CI.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CI.COD_FCRUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.TIP_APLICACAO = 'I'
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND BB.COD_SIT_FUNC      =1

/*


    --- COMPOSICAO CONSIGNACOES
    SELECT BB.COD_BENEFICIO AS COM_COD_BENEFICIO,
           DECODE(trim(BC.COD_TIPO_BENEFICIO),
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA AS COM_COD_RUBRICA,
           FC.COD_FCRUBRICA AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG AS COM_SEQ_VIG_FC,
           'C' AS COM_NAT_COMP,
           null AS COM_NUM_ORD_JUD,
           BC.COD_IDE_CLI_SERV AS COM_IDE_CLI_INSTITUIDOR, --efv
           CC.VAL_CONSIG_QTA AS COM_VAL_FIXO_IND,
           CC.VAL_CONSIG_QTA AS COM_VAL_PORC_IND,
           0 AS COM_VAL_PORC2,
           0 AS COM_QTY_UNID_IND,
           0 AS COM_VAL_UNID,
           'F' AS COM_TIPO_VALOR,
           RR.FLG_QUOTA AS COM_IND_QTAS,
           CC.NUM_QTAS_PAGAS AS COM_NUM_QTAS_PAG,
           CC.NUM_QTAS AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA AS COM_NAT_RUB,
           cc.dat_ini_refer AS COM_INI_REF,
           cc.dat_fim_refer AS COM_FIM_REF,
           FC.NUM_PRIORIDADE AS COM_PRIORIDADE,
           CP.FLG_DED_IR AS COM_DED_IR,
           RP.FLG_PROCESSA AS COM_FLG_PROCESSA,
           CP.NAT_VAL AS COM_NAT_VAL,
           FC.TIP_APLICACAO AS COM_TIPO_APLICACAO,
          -- BC.VAL_PERCENT_BEN AS COM_PERCENT_BEN,
           CASE
              WHEN ( BB.COD_BENEFICIO>40000001 AND
                     BB.COD_BENEFICIO<41000000 AND
                     BC.COD_ENTIDADE IN ( 7,6)        AND
                     NVL(BC.NAO_PROPORCIONA_FOLHA,'N')!='S' ) THEN
                     BC.VAL_PERCENT_BEN
               ELSE
                 BC.VAL_PERCENT_BEN  END   AS COM_PERCENT_BEN,


           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           null AS COM_VAL_STR1,
           null AS COM_VAL_STR2,
           BC.NUM_MATRICULA AS COM_MATRICULA,
           BC.COD_ENTIDADE AS COM_ENTIDADE,
           EC.COD_CARGO AS COM_CARGO,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS,
           BB.DAT_INI_BEN AS BEN_DAT_INICIO,
           BB.DAT_FIM_BEN AS BEN_DAT_FIM,
           CC.DAT_INI_VIG AS COM_DAT_INI_VIG,
           CC.DAT_FIM_VIG AS COM_DAT_FIM_VIG,
           null AS COM_COD_IDE_CLI_BEN,
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO,
           1 AS COM_PORC_VIG, --RAO 20060321
           RR.DAT_FIM_VIG AS COM_DAT_VIG_RUBRICA, -- MVL
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO, -- efv
           CC.NUM_SEQ_BENEF AS COM_SEQ_VIG,
           bc.cod_entidade as com_cod_entidade,
           CC.NUM_CARGA              COM_NUM_CARGA                    ,
           CC.NUM_SEQ_CONTROLE_CARGA COM_NUM_SEQ_CONTROLE_CARGA       ,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG,
            'N'  COM_RUBRICA_TIPO,
            BB.FLG_STATUS COM_FLG_STATUS,
           NVL(CC.DAT_CONTRATO,to_date('01/01/1901','dd/mm/yyyy')  ) COM_DAT_CONTRATO,
           CC.COD_CONVENIO    AS COM_COD_CONVENIO,
           DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO   AS  COM_COD_CONCEITO
           ,NULL     AS  COM_COD_FUNCAO

           ,NULL  AS  COM_COD_CARGO_RUB      -- CODIGO DE RUBRICA ASSOCIADO AO CARGO
           ,NULL  AS  COM_COD_REFERENCIA_RUB -- CODIGO DE REFERENCIA ASSOCIADO AO CARGO
           ,NULL  AS  COM_DAT_INCORP_RUB
           ------ Campo Novo Cod_tabela
           ,NULL  AS  COM_COD_TABELA

      FROM TB_COMPOSICAO_CONSIG   CC,
           TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC
     WHERE BB.COD_INS = PAR_COD_INS
       AND BB.COD_IDE_CLI_BEN = ben_ide_cli
       AND to_char(BB.DAT_INI_BEN, 'YYYYMM') <=
           to_char(PAR_PER_PRO, 'YYYYMM')
       AND (to_char(BB.DAT_FIM_BEN, 'YYYYMM') >=
           to_char(PAR_PER_PRO, 'YYYYMM') or BB.DAT_FIM_BEN is null)
       AND BB.FLG_STATUS in ('A', 'H', \*'S',*\ 'X')
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = FC.COD_ENTIDADE
       AND CC.COD_INS = BB.COD_INS
       AND CC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND CC.COD_IDE_CLI_BEN = BB.COD_IDE_CLI_BEN
          --AND trim(BC.COD_TIPO_BENEFICIO) = 'M'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CC.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CC.COD_FCRUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.TIP_APLICACAO = 'I'
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.COD_IDE_CLI_BEN = bb.cod_ide_cli_ben
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.FLG_STATUS = 'V'
       AND CC.FLG_STATUS = 'V'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(EC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND  not  EXISTS (
        SELECT 1 FROM  user_ipesp.tb_isensao_tot   ii
        WHERE  ii.cod_ide_cli=bb.cod_ide_cli_ben
       )
      AND NOT ( (   BB.COD_BENEFICIO>=40000000 AND
                    BB.COD_BENEFICIO<=41000000) AND
                   (   (BC.COD_ENTIDADE !=31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201105' )
                    OR ( BC.COD_ENTIDADE =31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201111' )
                   )
           )
      AND  ( BEN_DISSOCIACAO=0 OR
           (BEN_DISSOCIACAO!=0 AND DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) =BEN_DISSOCIACAO)
         )
      AND NOT (
               BB.COD_BENEFICIO >40000000 AND BB.COD_BENEFICIO<41000000 AND
               BC.COD_ENTIDADE =5         AND BC.COD_TIPO_BENEFICIO !='M'
            )
    ----RUBRICAS DE TIPO GERAL
    UNION ALL
    SELECT BB.COD_BENEFICIO AS COM_COD_BENEFICIO,
           DECODE(trim(BC.COD_TIPO_BENEFICIO),
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA AS COM_COD_RUBRICA,
           FC.COD_FCRUBRICA AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG AS COM_SEQ_VIG_FC, -- MVL03
           'G' AS COM_NAT_COMP,
           null AS COM_NUM_ORD_JUD,
           BC.COD_IDE_CLI_SERV AS COM_IDE_CLI_INSTITUIDOR,
           null AS COM_VAL_FIXO_IND,
           null AS COM_VAL_PORC_IND,
           0 AS COM_VAL_PORC2,
           null AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE AS COM_VAL_UNID,
           FC.TIP_VALOR AS COM_TIPO_VALOR,
           'N' AS COM_IND_QTAS,
           0 AS COM_NUM_QTAS_PAG,
           0 AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA AS COM_NAT_RUB,
           null AS COM_INI_REF,
           null AS COM_FIM_REF,
           FC.NUM_PRIORIDADE AS COM_PRIORIDADE,
           CP.FLG_DED_IR AS COM_DED_IR,
           RP.FLG_PROCESSA AS COM_FLG_PROCESSA,
           CP.NAT_VAL AS COM_NAT_VAL,
           FC.TIP_APLICACAO AS COM_TIPO_APLICACAO,
         --  BC.VAL_PERCENT_BEN AS COM_PERCENT_BEN,
           CASE
              WHEN ( BB.COD_BENEFICIO>40000001 AND
                     BB.COD_BENEFICIO<41000000 and
                     BC.COD_ENTIDADE IN ( 7,6)         AND
                     NVL(BC.NAO_PROPORCIONA_FOLHA,'N')!='S' ) THEN
                     BC.VAL_PERCENT_BEN
               ELSE
                 BC.VAL_PERCENT_BEN  END   AS COM_PERCENT_BEN,

           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           null AS COM_VAL_STR1,
           null AS COM_VAL_STR2,
           BC.NUM_MATRICULA AS COM_MATRICULA,
           BC.COD_ENTIDADE AS COM_ENTIDADE,
           EC.COD_CARGO AS COM_CARGO,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS,
           BB.DAT_INI_BEN AS BEN_DAT_INICIO,
           BB.DAT_FIM_BEN AS BEN_DAT_FIM,
           FC.DAT_INI_VIG AS COM_DAT_INI_VIG,
           FC.DAT_FIM_VIG AS COM_DAT_FIM_VIG,
           null AS COM_COD_IDE_CLI_BEN, --efv 20060823
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO,
           (to_char(decode(rr.dat_fim_vig,
                           null,
                           add_months(PAR_PER_PRO, 1) - 1,
                           rr.dat_fim_vig),
                    'dd') / to_char(decode(rr.dat_fim_vig,
                                            null,
                                            add_months(PAR_PER_PRO, 1) - 1,
                                            last_day(rr.dat_fim_vig)),
                                     'dd')) AS COM_PORC_VIG, --RAO 20060321
           RR.DAT_FIM_VIG AS COM_DAT_VIG_RUBRICA, -- MVL
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO, -- efv
           RR.SEQ_VIG AS COM_SEQ_VIG,
           bc.cod_entidade as com_cod_entidade,
           0 COM_NUM_CARGA                    ,
           0 COM_NUM_SEQ_CONTROLE_CARGA       ,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG,
            'N'  COM_RUBRICA_TIPO,
           BB.FLG_STATUS COM_FLG_STATUS,
            to_date('01/01/1901','dd/mm/yyyy') COM_DAT_CONTRATO,
           0 COM_COD_CONVENIO,
            DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO   AS  COM_COD_CONCEITO
           ,NULL     AS  COM_COD_FUNCAO
           ,NULL  AS  COM_COD_CARGO_RUB      -- CODIGO DE RUBRICA ASSOCIADO AO CARGO
           ,NULL  AS  COM_COD_REFERENCIA_RUB -- CODIGO DE REFERENCIA ASSOCIADO AO CARGO
           ,NULL  AS  COM_DAT_INCORP_RUB
           ------ Campo Novo Cod_tabela
           ,NULL  AS  COM_COD_TABELA

      FROM TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC
     WHERE BB.COD_INS = PAR_COD_INS
       AND BB.COD_IDE_CLI_BEN = ben_ide_cli
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_BEN, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_BEN, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND BB.FLG_STATUS in ('A', 'H',\* 'S',*\ 'X')
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = FC.COD_ENTIDADE
       AND FC.COD_INS = BB.COD_INS
       AND FC.TIP_APLICACAO = 'G'
          --AND trim(BC.COD_TIPO_BENEFICIO) = 'M'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND nvl(RR.TIP_EVENTO_ESPECIAL, 'N') <> 'I'
       AND nvl(RR.TIP_EVENTO_ESPECIAL, 'N') <> 'J'
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.COD_IDE_CLI_BEN = bb.cod_ide_cli_ben
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.FLG_STATUS = 'V'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(EC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))

       AND NOT ( (  BB.COD_BENEFICIO>=40000000 AND
                    BB.COD_BENEFICIO<=41000000) AND
                   (   (BC.COD_ENTIDADE !=31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201105' )
                    OR ( BC.COD_ENTIDADE =31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201111' )
                   )
           )
       AND  not  EXISTS (
        SELECT 1 FROM  user_ipesp.tb_isensao_tot   ii
        WHERE  ii.cod_ide_cli=bb.cod_ide_cli_ben
       )
    AND  ( BEN_DISSOCIACAO=0 OR
           (BEN_DISSOCIACAO!=0 AND DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) =BEN_DISSOCIACAO)
         )
    AND NOT (
               BB.COD_BENEFICIO >40000000 AND BB.COD_BENEFICIO<41000000 AND
               BC.COD_ENTIDADE =5         AND BC.COD_TIPO_BENEFICIO !='M'
            )

 UNION ALL
    -- A rubrica do IR e processada, apos tudo o calculo
 SELECT BB.COD_BENEFICIO AS COM_COD_BENEFICIO,
           DECODE(trim(BC.COD_TIPO_BENEFICIO),
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO,
           RA.COD_RUBRICA   AS COM_COD_RUBRICA,
           RA.COD_FCRUBRICA AS COM_COD_FCRUBRICA,
           CI.SEQ_VIG_FC AS COM_SEQ_VIG_FC,
           'I' AS COM_NAT_COMP,
           CI.NUM_ORD_JUD AS COM_NUM_ORD_JUD,
           BC.COD_IDE_CLI_SERV AS COM_IDE_CLI_INSTITUIDOR, --efv
           CI.VAL_FIXO AS COM_VAL_FIXO_IND,
           CI.VAL_PORC AS COM_VAL_PORC_IND,
           0 AS COM_VAL_PORC2,
           CI.VAL_UNIDADE AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE AS COM_VAL_UNID,
           FC.TIP_VALOR AS COM_TIPO_VALOR,
           RR.FLG_QUOTA AS COM_IND_QTAS,
           CI.NUM_QTAS_PAGAS AS COM_NUM_QTAS_PAG,
           CI.NUM_QTAS_PAGAS AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA AS COM_NAT_RUB,
           ci.dat_ini_refer AS COM_INI_REF, -- mvl7
           ci.dat_fim_refer AS COM_FIM_REF, -- mvl7
           FC.NUM_PRIORIDADE AS COM_PRIORIDADE,
           CP.FLG_DED_IR AS COM_DED_IR,
           RP.FLG_PROCESSA AS COM_FLG_PROCESSA,
           CP.NAT_VAL AS COM_NAT_VAL,
           FC.TIP_APLICACAO AS COM_TIPO_APLICACAO,
           BC.VAL_PERCENT_BEN AS COM_PERCENT_BEN,
           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           null AS COM_VAL_STR1,
           null AS COM_VAL_STR2,
           BC.NUM_MATRICULA AS COM_MATRICULA,
           BC.COD_ENTIDADE AS COM_ENTIDADE,
           EC.COD_CARGO AS COM_CARGO,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS,
           BB.DAT_INI_BEN AS BEN_DAT_INICIO,
           BB.DAT_FIM_BEN AS BEN_DAT_FIM,
           CI.DAT_INI_VIG AS COM_DAT_INI_VIG, --ROD3
           CI.DAT_FIM_VIG AS COM_DAT_FIM_VIG, --ROD3
           CI.COD_IDE_CLI_BEN AS COM_COD_IDE_CLI_BEN,
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO,
           1 AS COM_PORC_VIG, --RAO 20060321
           RR.DAT_FIM_VIG AS COM_DAT_VIG_RUBRICA, -- MVL
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO, -- efv
           CI.SEQ_VIG AS COM_SEQ_VIG,
           bc.cod_entidade as com_cod_entidade,
           0 COM_NUM_CARGA                    ,
           0 COM_NUM_SEQ_CONTROLE_CARGA       ,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG,
            'A'  COM_RUBRICA_TIPO               ,
           BB.FLG_STATUS COM_FLG_STATUS         ,
          to_date('01/01/1901','dd/mm/yyyy') COM_DAT_CONTRATO,
          0 AS COM_COD_CONVENIO,
           DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO
           ,RR.COD_CONCEITO   AS  COM_COD_CONCEITO
           ,NULL     AS  COM_COD_FUNCAO

          ,NULL  AS  COM_COD_CARGO_RUB      -- CODIGO DE RUBRICA ASSOCIADO AO CARGO
          ,NULL  AS  COM_COD_REFERENCIA_RUB -- CODIGO DE REFERENCIA ASSOCIADO AO CARGO
          ,NULL  AS  COM_DAT_INCORP_RUB
           ------ Campo Novo Cod_tabela
           ,NULL  AS  COM_COD_TABELA
      FROM TB_COMPOSICAO_INDIV    CI,
           TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC ,
           TB_RUBRICAS_AUTOMATICAS RA

     WHERE BB.COD_INS = 1
       AND BB.COD_IDE_CLI_BEN =  ben_ide_cli
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
          to_char(BB.DAT_INI_BEN, 'YYYYMM') and
         to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_BEN, to_date('01/01/2045', 'dd/mm/yyyy')),
                   'YYYYMM'))
       AND BB.FLG_STATUS in ('A', 'H', \*'S',*\ 'X')
       AND CI.FLG_STATUS = 'V'
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND CI.COD_INS = BB.COD_INS
       AND CI.COD_IDE_CLI = BB.COD_IDE_CLI_BEN --efv 20060823
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = FC.COD_ENTIDADE
       AND CI.COD_BEN = BB.COD_BENEFICIO
          --AND trim(BC.COD_TIPO_BENEFICIO) = 'M'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CI.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CI.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CI.COD_FCRUBRICA
      AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
         to_char(FC.DAT_INI_VIG, 'YYYYMM') and
          to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                   'YYYYMM'))
       AND FC.TIP_APLICACAO = 'I'
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
      AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
         to_char(RR.DAT_INI_VIG, 'YYYYMM') and
        to_char(PAR_PER_PRO, 'YYYYMM') <=
          to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                  'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RA.COD_RUBRICA
       AND RP.TIP_PROCESSO = 'N'
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_IDE_CLI_BEN = bb.cod_ide_cli_ben
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.FLG_STATUS = 'V'
      AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
          to_char(EC.DAT_INI_VIG, 'YYYYMM')
     AND  to_char(PAR_PER_PRO, 'YYYYMM') <=
          to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                     'YYYYMM'))
 --      AND NOT (BB.COD_BENEFICIO>=40000000 AND BB.COD_BENEFICIO<=41000000)
       AND RA.COD_INS=FC.COD_INS
       AND RA.COD_FCRUBRICA_ASSOC =FC.COD_FCRUBRICA
       AND RA.COD_ENTIDADE        =FC.COD_ENTIDADE
       AND   (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RA.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RA.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND  not  EXISTS (
        SELECT 1 FROM  user_ipesp.tb_isensao_tot   ii
        WHERE  ii.cod_ide_cli=bb.cod_ide_cli_ben
       )

       AND NOT ( (  BB.COD_BENEFICIO>=40000000 AND
                    BB.COD_BENEFICIO<=41000000) AND
                   (    (BC.COD_ENTIDADE !=31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201105' )
                    OR  (BC.COD_ENTIDADE =31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201111' )
                   )
           )

    AND  ( BEN_DISSOCIACAO=0 OR
           (BEN_DISSOCIACAO!=0 AND DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) =BEN_DISSOCIACAO)
         )
        ---------------- CONTROLE PARA NAO PROCESSAR  FOLHA------
        AND NOT  EXISTS (
         SELECT 1 FROM TB_NAO_PROCESSA_PA_13  NPA
         WHERE NPA.COD_INS=1                           AND
               NPA.COD_BENEFICIO=CI.COD_BEN            AND
               NPA.COD_IDE_CLI =CI.COD_IDE_CLI         AND
               NPA.COD_IDE_CLI_BEN=CI.COD_IDE_CLI_BEN  AND
               (to_char(PAR_PER_PRO, 'YYYYMM') >=
                to_char(NPA.DAT_INI_VIG, 'YYYYMM')     AND
                to_char(PAR_PER_PRO, 'YYYYMM') <=
                to_char(nvl(NPA.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
           AND  NVL(NPA.FLG_STATUS,'V')='V'
           AND  NPA.COD_RUBRICA=CI.COD_FCRUBRICA

        )


        ----------------------------------------------------------
      AND NOT (
               BB.COD_BENEFICIO >40000000 AND BB.COD_BENEFICIO<41000000 AND
               BC.COD_ENTIDADE =5         AND BC.COD_TIPO_BENEFICIO !='M'
            )
   ------------------------------------------------------------------*/
     ORDER BY
              COM_COD_IDE_CLI     ,
              COM_NUM_MATRICULA   ,
              COM_COD_IDE_REL_FUNC,
              COM_ENTIDADE        ,
              COM_PRIORIDADE      ,
              COM_DAT_CONTRATO    ,
              COM_COD_RUBRICA     ,
              COM_DAT_INI_VIG;

   -----------------Cursores Artigo 133
       ---- CURSOS DE DIFERENCA DE VENCIMENTOS ----
    --------------------------------------------

   CURSOR CUR_COMPATIV_DIFVEN IS
    SELECT
           BB.COD_BENEFICIO AS COM_COD_BENEFICIO,
           DECODE(trim(BC.COD_TIPO_BENEFICIO),
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA AS COM_COD_RUBRICA,
           FC.COD_FCRUBRICA AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG AS COM_SEQ_VIG_FC, -- MVL03
           'B' AS COM_NAT_COMP,
           null AS COM_NUM_ORD_JUD,
           bc.cod_ide_cli_serv  AS COM_IDE_CLI_INSTITUIDOR,
           CE.VAL_FIXO AS COM_VAL_FIXO_IND,
           CE.VAL_PORC AS COM_VAL_PORC_IND,
           CE.VAL_PORC2 AS COM_VAL_PORC2,
           CE.VAL_INIDADE AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE AS COM_VAL_UNID,
           FC.TIP_VALOR AS COM_TIPO_VALOR,
           'N' AS COM_IND_QTAS,
           0 AS COM_NUM_QTAS_PAG,
           0 AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA AS COM_NAT_RUB,
           null AS COM_INI_REF,
           null AS COM_FIM_REF,
           FC.NUM_PRIORIDADE AS COM_PRIORIDADE,
           CP.FLG_DED_IR AS COM_DED_IR,
           RP.FLG_PROCESSA AS COM_FLG_PROCESSA,
           CP.NAT_VAL AS COM_NAT_VAL,
           FC.TIP_APLICACAO AS COM_TIPO_APLICACAO,
           --      BC.VAL_PERCENT_BEN AS COM_PERCENT_BEN,
           CASE
             WHEN (BB.COD_BENEFICIO > 40000001 AND
                  BB.COD_BENEFICIO < 41000000 and BC.COD_ENTIDADE IN (7, 6) AND
                  NVL(BC.NAO_PROPORCIONA_FOLHA, 'N') != 'S') THEN
              BC.VAL_PERCENT_BEN
             ELSE
              BC.VAL_PERCENT_BEN
           END AS COM_PERCENT_BEN,

           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           CE.VAL_STR1 AS COM_VAL_STR1,
           CE.VAL_STR2 AS COM_VAL_STR2,
           BC.NUM_MATRICULA AS COM_MATRICULA,
           BC.COD_ENTIDADE AS COM_ENTIDADE,
           EC.COD_CARGO AS COM_CARGO,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS,
           BB.DAT_INI_BEN AS BEN_DAT_INICIO,
           BB.DAT_FIM_BEN AS BEN_DAT_FIM,
           CE.DAT_INI_VIG AS COM_DAT_INI_VIG,
           CE.DAT_FIM_VIG AS COM_DAT_FIM_VIG,
           null AS COM_COD_IDE_CLI_BEN,
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO,
           1 AS COM_PORC_VIG, --RAO 20060321
           RR.DAT_FIM_VIG AS COM_DAT_VIG_RUBRICA, -- MVL
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO, -- efv
           CE.SEQ_VIG AS COM_SEQ_VIG,
           BC.cod_entidade as com_cod_entidade,
           0 COM_NUM_CARGA,
           0 COM_NUM_SEQ_CONTROLE_CARGA,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG,
           'N' COM_RUBRICA_TIPO,
           BB.FLG_STATUS COM_FLG_STATUS,
           to_date('01/01/1901', 'dd/mm/yyyy') COM_DAT_CONTRATO,
           0 COM_COD_CONVENIO,

           DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO,
           RR.FLG_MUDA_BASE                         AS COM_FLG_MUDA_BASE
/*           ,
           1 COM_TIPO_COMPOSICAO_DIFV*/
           ,CE.COD_TABELA                           AS  COM_COD_TABELA
      FROM TB_COMPOSICAO_BEN      CE,
           TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC
     WHERE BB.COD_INS = PAR_COD_INS
       AND BB.COD_IDE_CLI_BEN = ben_ide_cli
       AND BB.COD_BENEFICIO   = COM_COD_BENE_DIF_VENC
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_BEN, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_BEN, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND BB.FLG_STATUS in ('A', 'H', 'X')
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND FC.COD_ENTIDADE = RR.COD_ENTIDADE

       AND CE.COD_INS = BB.COD_INS
       AND CE.COD_BENEFICIO = BB.COD_BENEFICIO
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CE.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CE.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CE.COD_FCRUBRICA
       AND FC.TIP_APLICACAO = 'I'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = 'N' ---PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S'
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND CE.FLG_STATUS = 'V'
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_IDE_CLI_BEN = BB.COD_IDE_CLI_BEN
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.COD_IDE_REL_FUNC = BC.COD_IDE_REL_FUNC
       AND EC.FLG_STATUS = 'V'
       AND CE.IND_OPCAO = EC.IND_OPCAO
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(EC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND NOT
            ((BB.COD_BENEFICIO >= 40000000 AND BB.COD_BENEFICIO <= 41000000) AND
            ((BC.COD_ENTIDADE != 31 AND
            to_char(PAR_PER_PRO, 'YYYYMM') < '201105') OR
            (BC.COD_ENTIDADE = 31 AND
            to_char(PAR_PER_PRO, 'YYYYMM') < '201111')

            ))
       AND EXISTS
       ---- Modificado 16-09-2013
      (SELECT 1
              FROM TB_rub_dif_vencimento PP
             WHERE PP.COD_INS      = BB.COD_INS
               AND PP.COD_ENTIDADE = COM_ENTIDADE_DIF_VENC
               AND PP.COD_CONCEITO = COM_CONCEITO_DIF_VENC
               AND PP.COD_CARGO = COM_CARGO_DIF_VENC
               AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
                   to_char(PP.DAT_INI_VIG, 'YYYYMM') AND
                   to_char(PAR_PER_PRO, 'YYYYMM') <=
                   to_char(nvl(PP.DAT_FIM_VIG,
                                to_date('01/01/2045', 'dd/mm/yyyy')),
                            'YYYYMM'))
               AND FC.COD_INS = BB.COD_INS
               AND RR.COD_CONCEITO = TRUNC(PP.COD_FCRUBRICA / 100)
               AND PP.FLG_COND_CALC = 'S')

    ------ RUBRICAS ASSOCIADAS AO CARGO ----
    UNION ALL

    SELECT
           BB.COD_BENEFICIO AS COM_COD_BENEFICIO,
           DECODE(trim(BC.COD_TIPO_BENEFICIO),
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO,
           FC.COD_RUBRICA AS COM_COD_RUBRICA,
           FC.COD_FCRUBRICA AS COM_COD_FCRUBRICA,
           FC.SEQ_VIG AS COM_SEQ_VIG_FC, -- MVL03
           'B' AS COM_NAT_COMP,
           null AS COM_NUM_ORD_JUD,
           bc.cod_ide_cli_serv AS COM_IDE_CLI_INSTITUIDOR,
           CE.VAL_FIXO AS COM_VAL_FIXO_IND,
           CE.VAL_PORC AS COM_VAL_PORC_IND,
           0 AS COM_VAL_PORC2,
           CE.VAL_INIDADE AS COM_QTY_UNID_IND,
           FC.VAL_UNIDADE AS COM_VAL_UNID,
           FC.TIP_VALOR AS COM_TIPO_VALOR,
           'N' AS COM_IND_QTAS,
           0 AS COM_NUM_QTAS_PAG,
           0 AS COM_TOT_QTAS_PAG,
           FC.FLG_COMP AS COM_IND_COMP_RUB,
           RR.FLG_NATUREZA AS COM_NAT_RUB,
           null AS COM_INI_REF,
           null AS COM_FIM_REF,
           FC.NUM_PRIORIDADE AS COM_PRIORIDADE,
           CP.FLG_DED_IR AS COM_DED_IR,
           RP.FLG_PROCESSA AS COM_FLG_PROCESSA,
           CP.NAT_VAL AS COM_NAT_VAL,
           FC.TIP_APLICACAO AS COM_TIPO_APLICACAO,
           --      BC.VAL_PERCENT_BEN AS COM_PERCENT_BEN,
           CASE
             WHEN (BB.COD_BENEFICIO > 40000001 AND
                  BB.COD_BENEFICIO < 41000000 and BC.COD_ENTIDADE IN (7, 6) AND
                  NVL(BC.NAO_PROPORCIONA_FOLHA, 'N') != 'S') THEN
              BC.VAL_PERCENT_BEN
             ELSE
              BC.VAL_PERCENT_BEN
           END AS COM_PERCENT_BEN,

           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           ' ' AS COM_VAL_STR1,
           ' ' AS COM_VAL_STR2,
           BC.NUM_MATRICULA AS COM_MATRICULA,
           BC.COD_ENTIDADE AS COM_ENTIDADE,
           EC.COD_CARGO AS COM_CARGO,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS,
           BB.DAT_INI_BEN AS BEN_DAT_INICIO,
           BB.DAT_FIM_BEN AS BEN_DAT_FIM,
           CE.DAT_INI_VIG AS COM_DAT_INI_VIG,
           CE.DAT_FIM_VIG AS COM_DAT_FIM_VIG,
           null AS COM_COD_IDE_CLI_BEN,
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO,
           1 AS COM_PORC_VIG, --RAO 20060321
           RR.DAT_FIM_VIG AS COM_DAT_VIG_RUBRICA, -- MVL
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO, -- efv
           CE.SEQ_VIG AS COM_SEQ_VIG,
           BC.cod_entidade as com_cod_entidade,
           0 COM_NUM_CARGA,
           0 COM_NUM_SEQ_CONTROLE_CARGA,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG,
           'N' COM_RUBRICA_TIPO,
           BB.FLG_STATUS COM_FLG_STATUS,
           to_date('01/01/1901', 'dd/mm/yyyy') COM_DAT_CONTRATO,
           0 COM_COD_CONVENIO,

           DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO,
           RR.FLG_MUDA_BASE                         AS COM_FLG_MUDA_BASE
/*           ,
           1 COM_TIPO_COMPOSICAO_DIFV*/
            ,NULL                           AS  COM_COD_TABELA
      FROM TB_rub_dif_vencimento /*TB_COMPOSICAO_BEN */  CE,
           TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC
     WHERE BB.COD_INS =  PAR_COD_INS
       AND BB.COD_IDE_CLI_BEN = ben_ide_cli
       AND BB.COD_BENEFICIO   =  COM_COD_BENE_DIF_VENC
       AND CE.FLG_COND_CALC='N'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_BEN, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_BEN, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND BB.FLG_STATUS in ('A', 'H', 'X')
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND FC.COD_ENTIDADE = RR.COD_ENTIDADE

       AND CE.COD_INS = BB.COD_INS
       ---- Modificado 16-09-2013
       AND CE.COD_CARGO    = COM_CARGO_DIF_VENC
       AND CE.COD_ENTIDADE = COM_ENTIDADE_DIF_VENC
       AND CE.COD_CONCEITO = COM_CONCEITO_DIF_VENC

       AND CE.FLG_COND_CALC = 'N'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CE.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CE.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CE.COD_FCRUBRICA
          -- AND FC.TIP_APLICACAO = 'I'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = 'N' ---PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S'
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND CE.FLG_STATUS = 'V'
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_IDE_CLI_BEN = BB.COD_IDE_CLI_BEN
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.COD_IDE_REL_FUNC = BC.COD_IDE_REL_FUNC
       AND EC.FLG_STATUS = 'V'
          -- AND CE.IND_OPCAO = EC.IND_OPCAO
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(EC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND NOT
            ((BB.COD_BENEFICIO >= 40000000 AND BB.COD_BENEFICIO <= 41000000) AND
            ((BC.COD_ENTIDADE != 31 AND
            to_char(PAR_PER_PRO, 'YYYYMM') < '201105') OR
            (BC.COD_ENTIDADE = 31 AND
            to_char(PAR_PER_PRO, 'YYYYMM') < '201111')

            ))

     ORDER BY COM_COD_BENEFICIO,
              COM_PRIORIDADE,
              COM_DAT_CONTRATO,
              COM_COD_RUBRICA,
              COM_DAT_INI_VIG;

     -------- CURSOS BASE DE SERVIDOR ARTICULO 133
   CURSOR CUR_COMPATIV_BADIFVEN IS
    SELECT  * FROM (

    SELECT
           BB.COD_BENEFICIO AS COM_COD_BENEFICIO      ,
           DECODE(trim(BC.COD_TIPO_BENEFICIO)         ,
                  'M'          ,
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO   ,
           FC.COD_RUBRICA AS COM_COD_RUBRICA           ,
           FC.COD_FCRUBRICA AS COM_COD_FCRUBRICA       ,
           FC.SEQ_VIG AS COM_SEQ_VIG_FC                ,
           'B' AS COM_NAT_COMP                         ,
           null AS COM_NUM_ORD_JUD                       ,
           bc.cod_ide_cli_serv AS COM_IDE_CLI_INSTITUIDOR,
           CE.VAL_FIXO AS COM_VAL_FIXO_IND               ,
           CE.VAL_PORC AS COM_VAL_PORC_IND               ,
           CE.VAL_PORC2 AS COM_VAL_PORC2                 ,
           CE.VAL_INIDADE AS COM_QTY_UNID_IND            ,
           FC.VAL_UNIDADE AS COM_VAL_UNID                ,
           FC.TIP_VALOR AS COM_TIPO_VALOR                ,
           'N' AS COM_IND_QTAS                           ,
           0 AS COM_NUM_QTAS_PAG                         ,
           0 AS COM_TOT_QTAS_PAG                         ,
           FC.FLG_COMP AS COM_IND_COMP_RUB               ,
           RR.FLG_NATUREZA AS COM_NAT_RUB                ,
           null AS COM_INI_REF                           ,
           null AS COM_FIM_REF                           ,
           -- Agregado em 16012013
           FC.NUM_PRIORIDADE_133 AS COM_PRIORIDADE           ,
           CP.FLG_DED_IR AS COM_DED_IR                   ,
           RP.FLG_PROCESSA AS COM_FLG_PROCESSA           ,
           CP.NAT_VAL AS COM_NAT_VAL                     ,
           FC.TIP_APLICACAO AS COM_TIPO_APLICACAO        ,
           --      BC.VAL_PERCENT_BEN AS COM_PERCENT_BEN,
           CASE
             WHEN (BB.COD_BENEFICIO > 40000001 AND
                  BB.COD_BENEFICIO < 41000000 and BC.COD_ENTIDADE IN (7, 6) AND
                  NVL(BC.NAO_PROPORCIONA_FOLHA, 'N') != 'S') THEN
              BC.VAL_PERCENT_BEN
             ELSE
              BC.VAL_PERCENT_BEN
           END AS COM_PERCENT_BEN,

           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           CE.VAL_STR1 AS COM_VAL_STR1               ,
           CE.VAL_STR2 AS COM_VAL_STR2               ,
           BC.NUM_MATRICULA AS COM_MATRICULA         ,
           BC.COD_ENTIDADE AS COM_ENTIDADE           ,
           EC.COD_CARGO AS COM_CARGO                 ,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS       ,
           BB.DAT_INI_BEN AS BEN_DAT_INICIO          ,
           BB.DAT_FIM_BEN AS BEN_DAT_FIM             ,
           CE.DAT_INI_VIG AS COM_DAT_INI_VIG         ,
           CE.DAT_FIM_VIG AS COM_DAT_FIM_VIG         ,
           null AS COM_COD_IDE_CLI_BEN               ,
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO   ,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO   ,
           1 AS COM_PORC_VIG                         ,
           RR.DAT_FIM_VIG AS COM_DAT_VIG_RUBRICA     ,
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO ,
           CE.SEQ_VIG AS COM_SEQ_VIG                 ,
           BC.cod_entidade as com_cod_entidade       ,
           0 COM_NUM_CARGA                           ,
           0 COM_NUM_SEQ_CONTROLE_CARGA              ,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG     ,
           'N' COM_RUBRICA_TIPO                      ,
           BB.FLG_STATUS COM_FLG_STATUS              ,
           to_date('01/01/1901', 'dd/mm/yyyy') COM_DAT_CONTRATO,
           0 COM_COD_CONVENIO                        ,

           DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO  ,
           RR.FLG_MUDA_BASE                         AS COM_FLG_MUDA_BASE
          ,CE.COD_TABELA                           AS  COM_COD_TABELA
      FROM TB_COMPOSICAO_BEN      CE,
           TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC
     WHERE BB.COD_INS = PAR_COD_INS
       AND BB.COD_IDE_CLI_BEN = ben_ide_cli
       AND BB.COD_BENEFICIO   = COM_COD_BENE_DIF_VENC
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_BEN, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_BEN, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND BB.FLG_STATUS in ('A', 'H', 'X')
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND FC.COD_ENTIDADE = RR.COD_ENTIDADE

       AND CE.COD_INS = BB.COD_INS
       AND CE.COD_BENEFICIO = BB.COD_BENEFICIO
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(CE.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(CE.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND FC.COD_INS = BB.COD_INS
       AND FC.COD_FCRUBRICA = CE.COD_FCRUBRICA
       AND FC.TIP_APLICACAO = 'I'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = 'N' ---PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S'
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND CE.FLG_STATUS = 'V'
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_IDE_CLI_BEN = BB.COD_IDE_CLI_BEN
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.COD_IDE_REL_FUNC = BC.COD_IDE_REL_FUNC
       AND EC.FLG_STATUS = 'V'
       AND CE.IND_OPCAO = EC.IND_OPCAO
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(EC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND NOT
            ((BB.COD_BENEFICIO >= 40000000 AND BB.COD_BENEFICIO <= 41000000) AND
            ((BC.COD_ENTIDADE != 31 AND
            to_char(PAR_PER_PRO, 'YYYYMM') < '201105') OR
            (BC.COD_ENTIDADE = 31 AND
            to_char(PAR_PER_PRO, 'YYYYMM') < '201111')

            ))
   UNION ALL
    SELECT BB.COD_BENEFICIO AS COM_COD_BENEFICIO         ,
           DECODE(trim(BC.COD_TIPO_BENEFICIO)            ,
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO     ,
           FC.COD_RUBRICA       AS COM_COD_RUBRICA       ,
           FC.COD_FCRUBRICA     AS COM_COD_FCRUBRICA     ,
           FC.SEQ_VIG           AS COM_SEQ_VIG_FC        ,
           'G'                  AS COM_NAT_COMP          ,
           null                 AS COM_NUM_ORD_JUD       ,
           BC.COD_IDE_CLI_SERV  AS COM_IDE_CLI_INSTITUIDOR,
           null                 AS COM_VAL_FIXO_IND      ,
           null                 AS COM_VAL_PORC_IND      ,
           0                    AS COM_VAL_PORC2         ,
           null                 AS COM_QTY_UNID_IND      ,
           FC.VAL_UNIDADE       AS COM_VAL_UNID          ,
           FC.TIP_VALOR         AS COM_TIPO_VALOR        ,
           'N'                  AS COM_IND_QTAS          ,
           0                    AS COM_NUM_QTAS_PAG      ,
           0                    AS COM_TOT_QTAS_PAG      ,
           FC.FLG_COMP          AS COM_IND_COMP_RUB      ,
           RR.FLG_NATUREZA      AS COM_NAT_RUB           ,
           null                 AS COM_INI_REF           ,
           null                 AS COM_FIM_REF           ,
           -- Agregado em 16012013
           FC.NUM_PRIORIDADE_133 AS COM_PRIORIDADE           ,
           CP.FLG_DED_IR        AS COM_DED_IR            ,
           RP.FLG_PROCESSA      AS COM_FLG_PROCESSA      ,
           CP.NAT_VAL           AS COM_NAT_VAL           ,
           FC.TIP_APLICACAO     AS COM_TIPO_APLICACAO    ,
           CASE
              WHEN ( BB.COD_BENEFICIO>40000001 AND
                     BB.COD_BENEFICIO<41000000 and
                     BC.COD_ENTIDADE IN ( 7,6)         AND
                     NVL(BC.NAO_PROPORCIONA_FOLHA,'N')!='S' ) THEN
                     BC.VAL_PERCENT_BEN
               ELSE
                 BC.VAL_PERCENT_BEN  END   AS COM_PERCENT_BEN,

           nvl(RR.TIP_EVENTO_ESPECIAL, 'N') AS COM_TIPO_EVENTO_ESPECIAL,
           null              AS COM_VAL_STR1,
           null              AS COM_VAL_STR2,
           BC.NUM_MATRICULA  AS COM_MATRICULA,
           BC.COD_ENTIDADE   AS COM_ENTIDADE,
           EC.COD_CARGO      AS COM_CARGO,
           EC.COD_CARGO_APOS AS COM_CARGO_APOS,
           BB.DAT_INI_BEN    AS BEN_DAT_INICIO,
           BB.DAT_FIM_BEN    AS BEN_DAT_FIM,
           FC.DAT_INI_VIG    AS COM_DAT_INI_VIG,
           FC.DAT_FIM_VIG    AS COM_DAT_FIM_VIG,
           null              AS COM_COD_IDE_CLI_BEN, --efv 20060823
           FC.MSC_INFORMACAO AS COM_MSC_INFORMACAO,
           FC.COL_INFORMACAO AS COM_COL_INFORMACAO,
           (to_char(decode(rr.dat_fim_vig,
                           null,
                           add_months(PAR_PER_PRO, 1) - 1,
                           rr.dat_fim_vig),
                    'dd') / to_char(decode(rr.dat_fim_vig,
                                            null,
                                            add_months(PAR_PER_PRO, 1) - 1,
                                            last_day(rr.dat_fim_vig)),
                                     'dd')) AS COM_PORC_VIG, --RAO 20060321
           RR.DAT_FIM_VIG       AS COM_DAT_VIG_RUBRICA, -- MVL
           FC.FLG_APLICA_RATEIO AS COM_APLICA_RATEIO, -- efv
           RR.SEQ_VIG           AS COM_SEQ_VIG,
           bc.cod_entidade      AS com_cod_entidade,
           0                    AS COM_NUM_CARGA                    ,
           0                    AS COM_NUM_SEQ_CONTROLE_CARGA       ,
           BB.COD_PROC_GRP_PAG COM_NUM_GRUPO_PAG,
            'N'                 AS COM_RUBRICA_TIPO,
           BB.FLG_STATUS        AS COM_FLG_STATUS,
            to_date('01/01/1901','dd/mm/yyyy') COM_DAT_CONTRATO,
           0                    AS COM_COD_CONVENIO,
            DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) AS COM_ASSOCIACAO ,
            RR.FLG_MUDA_BASE                         AS COM_FLG_MUDA_BASE
           ------ Campo Novo Codigo
          ,NULL                           AS  COM_COD_TABELA
     FROM TB_BENEFICIARIO        BB,
           TB_RUBRICAS            RR,
           TB_FORMULA_CALCULO     FC,
           TB_RUBRICAS_PROCESSO   RP,
           TB_CONCESSAO_BENEFICIO BC,
           TB_CONCEITOS_PAG       CP,
           TB_BENEFICIO_CARGO     EC
     WHERE BB.COD_INS = PAR_COD_INS
       AND BB.COD_IDE_CLI_BEN = ben_ide_cli
      AND BB.COD_BENEFICIO   = COM_COD_BENE_DIF_VENC
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(BB.DAT_INI_BEN, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(BB.DAT_FIM_BEN, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND BB.FLG_STATUS in ('A', 'H',/* 'S',*/ 'X')
       AND BB.FLG_REG_ATIV = 'S'
       AND BB.FLG_CONT_BEN = 'N'
       AND BC.COD_INS = BB.COD_INS
       AND BC.COD_BENEFICIO = BB.COD_BENEFICIO
       AND BC.COD_ENTIDADE = RR.COD_ENTIDADE
       AND RR.COD_ENTIDADE = RP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = CP.COD_ENTIDADE
       AND RR.COD_ENTIDADE = FC.COD_ENTIDADE
       AND FC.COD_INS = BB.COD_INS
       AND FC.TIP_APLICACAO = 'G'
          --AND trim(BC.COD_TIPO_BENEFICIO) = 'M'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(FC.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(FC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND RR.COD_INS = BB.COD_INS
       AND RR.COD_RUBRICA = FC.COD_RUBRICA
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(RR.DAT_INI_VIG, 'YYYYMM') and
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(RR.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))
       AND CP.COD_INS = RR.COD_INS
       AND CP.COD_CONCEITO = RR.COD_CONCEITO
       AND RP.COD_INS = RR.COD_INS
       AND RP.COD_RUBRICA = RR.COD_RUBRICA
       AND RP.TIP_PROCESSO = PAR_TIP_PRO
       AND RP.SEQ_VIG >= 0
       AND RP.FLG_PROCESSA = 'S' ---RAO 20060410
       AND nvl(RR.TIP_EVENTO_ESPECIAL, 'N') <> 'I'
       AND nvl(RR.TIP_EVENTO_ESPECIAL, 'N') <> 'J'
       AND RR.SEQ_VIG = RP.SEQ_VIG_RUBRICA
       AND RR.SEQ_VIG = FC.SEQ_VIG_RUBRICA
       AND EC.COD_INS = BC.COD_INS
       AND EC.COD_BENEFICIO = BC.COD_BENEFICIO
       AND EC.COD_IDE_CLI_SERV = BC.COD_IDE_CLI_SERV
       AND EC.COD_ENTIDADE = BC.COD_ENTIDADE
       AND EC.COD_IDE_CLI_BEN = bb.cod_ide_cli_ben
       AND EC.NUM_MATRICULA = BC.NUM_MATRICULA
       AND EC.FLG_STATUS = 'V'
       AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
           to_char(EC.DAT_INI_VIG, 'YYYYMM') AND
           to_char(PAR_PER_PRO, 'YYYYMM') <=
           to_char(nvl(EC.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')),
                    'YYYYMM'))

       AND NOT ( (  BB.COD_BENEFICIO>=40000000 AND
                    BB.COD_BENEFICIO<=41000000) AND
                   (   (BC.COD_ENTIDADE !=31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201105' )
                    OR ( BC.COD_ENTIDADE =31 AND to_char(PAR_PER_PRO, 'YYYYMM') <'201111' )
                   )
           )

    AND  ( BEN_DISSOCIACAO=0 OR
           (BEN_DISSOCIACAO!=0 AND DECODE(BC.COD_TIPO_BENEFICIO, 'M', 2, 1) =BEN_DISSOCIACAO)
         )


        ) CUR_BASE_SER WHERE EXISTS (
         SELECT 1 FROM tb_compoe_det RUBP
         WHERE RUBP.COD_INS=PAR_COD_INS AND
               RUBP.COD_FCRUBRICA_COMPOSTA= COM_COD_RUBRICA_DIF  AND
               RUBP.COD_FCRUBRICA_COMPOE=CUR_BASE_SER.COM_COD_FCRUBRICA AND
               NVL(RUBP.DAT_FIM_VIG, TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO AND
               RUBP.DAT_INI_VIG<=PAR_PER_PRO
        )
     ORDER BY COM_COD_BENEFICIO,
              COM_PRIORIDADE,
              COM_DAT_CONTRATO,
              COM_COD_RUBRICA,
              COM_DAT_INI_VIG;


  ERRO EXCEPTION;

  ----------------------------------------------------------------------------
  PROCEDURE SP_FOLHA_CALCULADA3(i_cod_ins                in number,
                                i_per_pro                in date,
                                i_cod_usu                in varchar2,
                                i_tip_tra                in varchar2,
                                i_tip_pro                in varchar2,
                                i_num_cpf                in varchar2,
                                i_partir_de              in varchar2,
                                i_par_per_real           in date,
                                i_data_primeiro          in date,
                                i_des_tipos_benef        in varchar2,
                                i_cod_tipo_ben           in varchar2,
                                i_cod_categoria          in number,
                                i_cod_cargo              in number, --  MVL
                                i_cod_entidade           in number, -- FCPF
                                i_percent_correcao       in number, -- MVL
                                i_ind_proc_enquadramento in number, -- MVL
                                i_num_processo           in number, -- MVL
                                i_num_grp                in number,
                                i_num_seq_proc           in number,
                                i_seq_pagamento          in number); --ROD7

  ----------------------------------------------------------------------------
  PROCEDURE SP_INICIO_PROCESSO;
  ----------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_VARIAVEIS_PARAMETRO;
  ----------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_REPROCESSAMENTO;
  ----------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_FORMULA;
  --------------------------------------------------------------------------
  FUNCTION SP_VALIDA_CONDICAO RETURN BOOLEAN;
   --------------------------------------------------------------------------
  FUNCTION SP_OBTEM_VALOR_VAR(I_NUM_FUNCAO   IN NUMBER,
                              I_COD_VARIAVEL IN VARCHAR2,
                              I_ORDEM        IN NUMBER) RETURN VARCHAR2;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VALOR_FORMULA;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_EVOLU_REL_FUNCIONAL;
  ---------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_VAR_RUBRICA;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SOMA_PENSAO(o_valor out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SOMA_SALFA(o_valor out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SOMA_VENCIMENTO(i_cod_beneficio in number,
                                     i_cod_entidade  in number,
                                     i_ind_val_cheio in varchar2,
                                     o_valor         out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_DEPENDENTES(P_COD_IDE_CLI IN VARCHAR2,
                                     O_VALOR       OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_DEPENDENTES_MIL(P_COD_IDE_CLI IN VARCHAR2,
                                         O_VALOR       OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RELACAO_FUNCIONAL(I_NUM_FUNCAO IN NUMBER,
                                       O_STR        OUT VARCHAR2,
                                       O_NUM        OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_CATEGORIA(O_VALOR OUT VARCHAR2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SUBCATEGORIA(O_VALOR OUT VARCHAR2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_CATEGORIA_OPCAO(O_STR OUT VARCHAR2);
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_PADRAO_VENCIMENTO RETURN VARCHAR2;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PERCENTUAL_CARGO(O_VALOR OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PROPORCAO_JORNADA(I_NUM_FUNCAO IN NUMBER,
                                       O_VALOR      OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_HORAS(i_num_funcao in number, O_VALOR OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPOS_ATRIBUTOS(num_funcao      in number,
                                     i_num_matricula number,
                                     i_entidade      in number,
                                     i_cargo         in number,
                                     O_STR           OUT VARCHAR2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPOS_ATRIBUTOS_prev(num_funcao      in number,
                                          i_num_matricula number,
                                          i_entidade      in number,
                                          i_cargo         in number,
                                          O_STR           OUT VARCHAR2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF_REP(i_num_funcao in number,
                                           o_valor      out number);
  ---------------------------------------------------------------------------
   PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF_COR(i_num_funcao in number,
                                           o_valor      out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_BASE_CCOMIG(i_num_funcao in number,
                                      o_valor      out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF(i_num_funcao in number,
                                       o_valor      out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF_RF(i_num_funcao in number,
                                          o_valor      out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RELGRUPO(o_valor out number);
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_QTD_DIAS_AFAST  Return number;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_NOME_CARGO(o_str out varchar2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_CODGRUPO_ABONO(o_valor out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPO_ABONO(o_str out varchar2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VALOR_ABONO(o_valor out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENCIMENTO(cod_refer in number, o_valor out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_COMPOSICAO(I_COD_RUBRICA       IN NUMBER,
                          I_VARIAVEL          IN VARCHAR2,
                          I_NUM_MATRICULA     IN VARCHAR2,
                          I_COD_IDE_REL_FUNC  IN NUMBER,
                          I_COD_ENTIDADE      IN NUMBER,
                          i_ind_val_cheio     IN varchar2,
                          I_VALOR         OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_COMPOSICAO_TETO(I_COD_RUBRICA in number,
                               I_VARIAVEL    in varchar2,
                               I_VALOR       OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_IRRF(IDE_CLI    IN VARCHAR2,
                          IDX_VAL    IN NUMBER,
                          FLG_PA     IN VARCHAR2,
                          O_VALOR    OUT NUMBER,
                          O_VALOR_13 OUT NUMBER);
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DED_PAGOS RETURN NUMBER;
  --------------------------------------------
  FUNCTION SP_OBTEM_DED_PAGOS_SEMPA RETURN NUMBER;
  ---------------------------------------------------------------------------
  PROCEDURE SP_CONTRIB(I_VARIAVEL IN VARCHAR,
                       I_VALBASE  NUMBER,
                       O_VALOR    OUT NUMBER);
  ----------------------------------------------------------------------------
  FUNCTION SP_VALOR_SUPLEMENTAR(I_COD_IDE_CLI   VARCHAR2,
                                I_num_matricula VARCHAR2,
                                I_cod_ide_rel_func NUMBER,
                                I_cod_entidade  NUMBER   ,
                                I_COD_FCRUBRICA NUMBER   ,
                                I_FLG_NATUREZA  VARCHAR2,
                                I_VAL_RUBRICA   NUMBER  ,
                                I_DAT_INI_REF   DATE   ,
                                I_IDE_CLI_BEN   VARCHAR2) return NUMBER;
  ----------------------------------------------------------------------------
  FUNCTION SP_VALOR_SUPLEMENTAR_DECIMO(I_COD_IDE_CLI   VARCHAR2,
                                       I_num_matricula VARCHAR2,
                                       I_cod_ide_rel_func NUMBER,
                                       I_cod_entidade  NUMBER   ,
                                       I_COD_FCRUBRICA NUMBER,
                                       I_FLG_NATUREZA  VARCHAR2,
                                       I_VAL_RUBRICA   NUMBER) return NUMBER;

  -------------------------------------------------------------------------
  FUNCTION SP_OBTEM_RUBRICA_SUPL(I_FCRUBRICA NUMBER) RETURN NUMBER;
  --------------------------------------------------------------------------
  FUNCTION SP_ISENTA_IRRF(ide_cli in varchar2) return boolean;
  --------------------------------------------------------------------------
  FUNCTION SP_DED_IR(I_NUM_FCRUBRICA NUMBER) RETURN BOOLEAN;
  --------------------------------------------------------------------------
  FUNCTION SP_DED_IR_PA(I_NUM_FCRUBRICA NUMBER, I_NUM_ORD_JUD NUMBER)
    RETURN BOOLEAN;
  --------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DEP_DED_IR(IDE_CLI IN VARCHAR2, I_TIPO_BEN CHAR)
    RETURN NUMBER;
  ---------------------------------------------------------------------------
  PROCEDURE SP_INS_DETCAL_NORMAL(i_valor in number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_INS_DETCAL_PA(ide_cli in varchar2, i_valor in number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_INS_DETCALCULADO(i_valor in number);
  --------------------------------------------------------------------------
  PROCEDURE SP_INS_ARRAY_DESCONTO(i_valor in number);
  --------------------------------------------------------------------------
  FUNCTION SP_OBTEM_VALOR_OJ RETURN NUMBER;
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_PROP_COMPOSICAO RETURN NUMBER;
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_BASE_CARGO(o_cod_referencia in number)
    RETURN NUMBER;
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_BASE_CARGO_OJ RETURN NUMBER;
  ----------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_PADRAO_INI RETURN NUMBER;
  ----------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_PADRAO_INI_A RETURN NUMBER;
  ----------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_REFERENCIA RETURN NUMBER;

  ---------------------------------------------------------------------------
  PROCEDURE SP_RATEIO_BENEFICIO(P_COD_BENEFICIO IN NUMBER,
                                COD_CLI         IN VARCHAR2,
                                MON_VALOR       IN NUMBER,
                                I_VALOR         OUT NUMBER,
                                I_PERC_RATEIO   OUT NUMBER);
  ---------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_MASTER_PAG;
  ---------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_DETALHE_PAG;
  ---------------------------------------------------------------------------
/*  PROCEDURE SP_GRAVA_MASTER_FOLHA_PA(IDE_CLI IN VARCHAR2,
                                     COD_BEN IN NUMBER,
                                     VAL_PA IN NUMBER);*/
  ---------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_DET_PAG_PA (IDE_CLI IN VARCHAR2, COD_BEN IN NUMBER);
  ---------------------------------------------------------------------------

  PROCEDURE SP_PROCESSA_RUBRICA(CALC_RUB OUT BOOLEAN) ;
  ---------------------------------------------------------------------------
  PROCEDURE SP_VALOR_CALCULADO(I_RUBRICA        IN NUMBER,
                                i_num_matricula    IN VARCHAR2 ,
                                i_cod_ide_rel_func IN NUMBER,
                                I_COD_VARIAVEL  IN VARCHAR2,
                                I_COD_ENTIDADE  IN NUMBER,
                                I_IND_VAL_CHEIO IN VARCHAR2,
                                O_VALOR         OUT NUMBER);
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_VALOR_RUBRICA;
  ---------------------------------------------------------------------------
  PROCEDURE SP_INICIA_VAR;
  ---------------------------------------------------------------------------
  PROCEDURE SP_INICIALIZA_ARRAY;
    -----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DADOS_PF(IDE_CLI IN VARCHAR2,
                              I_TIPO  IN CHAR,
                              I_CPF   OUT VARCHAR2,
                              I_NOME  OUT VARCHAR2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_PORC(I_VALOR out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_IND_DJ(o_str out varchar2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_PORC_GRADUACAO(I_VALOR out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_CALC_PORC_GRADUACAO_EVOLU(I_VALOR out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ORIG_TAB_VENC(o_str out varchar2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_COD_REFERENCIA(o_str out varchar2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ORIG_TAB_VENC_CCOMI(o_str out varchar2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VALORES_TOTAIS(I_COD_VARIAVEL     IN  VARCHAR2,
                                    I_NUM_MATRICULA    IN VARCHAR2 ,
                                    I_COD_IDE_REL_FUNC IN NUMBER   ,
                                    I_COD_ENTIDADE     IN NUMBER   ,
                                    I_COD_RUBRICA      IN    NUMBER,
                                    i_ind_val_cheio    IN varchar2,
                                    I_VALOR            OUT NUMBER);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_BASE_IR(idx        in number,
                             tipo_irr   in varchar,
                             vi_base_ir out number,
                             base_ir_13 out number
                              );
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DETALHE_PAG(IDE_CLI            IN VARCHAR2,
                                 FLG_PA             IN VARCHAR2,
                                 TP_EVENTO_ESPECIAL IN VARCHAR2,
                                 TP_EVENTO          IN VARCHAR2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_DETALHE_PAG(
                                  TB_NUM_MATRICULA    IN VARCHAR2,
                                  TP_COD_IDE_REL_FUNC IN NUMBER  ,
                                  TP_COD_ENTIDADE     IN NUMBER  ,
                                  TP_RUBRICA          IN NUMBER  ,
                                  TP_VAL_RUBRICA      IN NUMBER  ,
                                  TP_SEQ_VIG          IN NUMBER  ,
                                  TP_FLG_NATUREZA     IN VARCHAR2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_DETALHE_PAG_PA(IDE_CLI          IN VARCHAR2,
                                     TP_COD_BENEFICIO IN NUMBER,
                                     TP_RUBRICA       IN NUMBER,
                                     TP_VAL_RUBRICA   IN NUMBER,
                                     TP_SEQ_VIG       IN NUMBER,
                                     TP_FLG_NATUREZA  IN VARCHAR2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_BENEFICIO_ARRAY;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ANTECIPACAO(v_COD_BENEF           IN NUMBER,
                                 V_TIP_EVENTO_ESPECIAL IN VARCHAR2,
                                 V_COD_RUBRICA         OUT NUMBER,
                                 V_VAL_RUBRICA         OUT NUMBER,
                                 V_SEQ_VIG             OUT NUMBER);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_13_SAIDA(V_COD_BENEFICIO IN NUMBER,
                              V_COD_RUBRICA   OUT NUMBER,
                              V_VAL_RUBRICA   OUT NUMBER,
                              V_SEQ_VIG       OUT NUMBER);
  ----------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_DET_SUSPENSO;
  ----------------------------------------------------------------------------
/*  PROCEDURE SP_INC_DET_RETROATIVO_INICIAL;*/
  ----------------------------------------------------------------------------
  PROCEDURE SP_CALC_DATAS_PROPORCIONAL;
  ----------------------------------------------------------------------------
 /* PROCEDURE SP_CALCULA_PREV_DETALHE;*/
  ----------------------------------------------------------------------------
  PROCEDURE SP_INS_DETCAL_RET;
  ----------------------------------------------------------------------------
/*  PROCEDURE SP_INS_DETCAL_PARC;*/
  ----------------------------------------------------------------------------
  --PROCEDURE SP_INS_NPAGO_RET;
  ----------------------------------------------------------------------------
/*  PROCEDURE SP_INS_DETCAL_ACIMA;*/
  ----------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_MASTER_RET;
  ----------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_DETALHE_RET;
  ----------------------------------------------------------------------------
   PROCEDURE SP_OBTER_DIF_RET(P_num_matricula     IN NUMBER,
                             P_cod_ide_rel_func  IN NUMBER,
                             P_cod_entidade      IN NUMBER,
                             P_COD_RUBRICA       IN NUMBER,
                             VAL_RET             IN NUMBER,
                             P_IDE_CLI           IN VARCHAR2,
                             P_COD_IDE_CLI_BEN   IN VARCHAR2,
                             P_FLG_NATUREZA      IN VARCHAR2,
                             P_INI_REF           IN DATE,
                             VALOR               OUT NUMBER,
                             EVENTO_ESPECIAL     OUT VARCHAR2);

  ----------------------------------------------------------------------------
  PROCEDURE SP_MONTAR_ARRAY_RET(P_COD_BENEFICIO IN NUMBER);
  ----------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_PARVAL_FOLHA(p_per_pro in date);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PARVAL_FOLHA2(P_COD_PARAM     in varchar,
                                   P_COD_ESTRUTURA in varchar,
                                   P_COD_ELEMENTO  in varchar,
                                   P_VADI01        out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PARVAL_FOLHA3(P_COD_PARAM     in varchar,
                                   P_COD_ESTRUTURA in varchar,
                                   P_COD_ELEMENTO  in varchar,
                                   P_DADI01        out date);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBT_FAIXA_IRRF_SALFA_TASCO(P_COD_PARAM     in varchar2,
                                          P_COD_ESTRUTURA in varchar2,
                                          P_VADI01        out number,
                                          P_VADI02        out number,
                                          P_VADI03        out number,
                                          P_VADI04        out number,
                                          P_VADI05        out number,
                                          P_VADI06        out number,
                                          P_VADI07        out number,
                                          P_VADI08        out number,
                                          P_VADI09        out number,
                                          P_MSGERRO       out varchar2);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PERCEN_CALC_IR(ide_cli  in varchar2,
                                    TotBru   in number,
                                    PERC_IR  out number,
                                    REDUT_IR out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DEDUCOES(ide_cli in varchar2, deducao_ir out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_IMPOSTO2(TotBru in number, MonImp out number);
  ----------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_VAR_TOTAIS_FOLHA;
  ----------------------------------------------------------------------------
  PROCEDURE SP_VERIF_RUBRICA_NPAGA_MES_SUP;
  ----------------------------------------------------------------------------
/*  PROCEDURE SP_GRAVA_TOTAIS_FOLHA(P_COD_BENEFICIO IN NUMBER,
                                  P_COD_CLI       IN VARCHAR2,
                                  P_COD_VARIAVEL  IN VARCHAR2,
                                  P_VALOR1        IN NUMBER,
                                  P_VALOR2        IN NUMBER,
                                  P_VALOR3        IN NUMBER,
                                  P_VALOR4        IN NUMBER);*/
  ----------------------------------------------------------------------------
/*  PROCEDURE SP_CALCULA_PENSAO;
  ----------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_REDUTOR;*/
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RUBRICA(i_cod_fcrubrica in number,
                             i_flg_natureza  in varchar2,
                             o_cod_rubrica   out number);
  ----------------------------------------------------------------------------
  --PROCEDURE SP_OBTEM_PROV_CC_FG(O_STR OUT VARCHAR);
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_FATOR_CORRECAO(I_COD_IDE_CLI    IN VARCHAR2,
                                    i_data_param     in date,
                                    O_FATOR_CORRECAO OUT NUMBER); --efv fator correcao
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_ADIANTAMENTO_13 RETURN NUMBER; --efv ADIANTAMENTO 13
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_TETO_PENSAO RETURN NUMBER; --efv Teto Pensao
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DESC_NIVEL RETURN VARCHAR2;
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DESC_PISO RETURN VARCHAR2;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VAL_JORN_PISO(o_valor out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DATA_OBITO(I_BENEFICIO  IN NUMBER,
                                O_DATA_OBITO OUT date); --efv Data de Obito
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DATA_OBITO_INV(I_BENEFICIO  IN NUMBER,
                                    O_DATA_OBITO OUT varchar2); --efv Data de Obito
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PAGAMENTO_ESPECIAL(o_pagto_especial out number); -- MVL 26/08/2008
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ENQUADRAMENTO(o_tipo_efeito      in number,
                                   o_cod_ref_oj       out number,
                                   o_cod_beneficio_oj out number,
                                   o_val_porc_efe     out number); -- MVL 26/08/2008
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_LIMITE_REGIME_GERAL(o_dat_obito out date); -- MVL 26/08/2008
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DIAS_BENEFICIO RETURN NUMBER;
  ---------------------------------------------------------------------------
/*  PROCEDURE SP_CALCULA_TETO;*/
  ---------------------------------------------------------------------------
 /* PROCEDURE SP_GERA_RUBRICA_AGRUPADA;*/
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_REFERENCIA(o_var_padrao in varchar2,
                                o_referencia out number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_ORDEM_JUDICIAL(i_num_funcao  in number,
                                       o_val_percent out number);
  ---------------------------------------------------------------------------
 -- PROCEDURE SP_RUBRICAS_EXCESSO;
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RUBRICA_EVENTO_ESPEC(itip_evento_especial in varchar2,
                                          i_cod_entidade       in number,
                                          i_flg_natureza       in varchar2,
                                          o_cod_rubrica        out number,
                                          o_seq_vig            out number);
  ---------------------------------------------------------------------------
  FUNCTION SP_OBTEM_PODER(o_cod_entidade in number) RETURN VARCHAR2;
  ---------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_RESULTADO_CALC_RET(i_rdcn in  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype);
  ---------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_TB_DET_RET(i_rdcn in  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype);
  ---------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_VALOR_NPAGO_RET(i_rdcn in  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype);
  ---------------------------------------------------------------------------
/*  PROCEDURE SP_VERIFICA_VALOR_EXTERNO(i_cod_benef   in number,
                                      i_ide_cli     in VARCHAR2,
                                      o_val_externo out number);*/
  ---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPO_BENEFICIO(cod_benef in number);
  ---------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_TETO_FIXO(i_cod_benef in NUMBER,
                                  o_teto_fixo out NUMBER);
  ---------------------------------------------------------------------------
/*  PROCEDURE SP_INCLUI_REDUTOR_2100600(i_ide_cli           in VARCHAR2,
                                      valor_teto_aplicado in number);*/
  ---------------------------------------------------------------------------
 -- FUNCTION CALCULA_MARGEM_CONSIG RETURN NUMBER;
  ---------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_CORRECAO_MONETARIA(I_COD_IDE_CLI  IN VARCHAR2,
                                           O_ANO_INICIO   OUT NUMBER ,
                                           O_FLG_CORRECAO OUT BOOLEAN) ;
  ---------------------------------------------------------------------------
  PROCEDURE SP_ATUALIZA_DECIMOTERC(i_cod_ins         in number,
                                   i_per_pro         in date,
                                   i_cod_usu         in varchar2,
                                   i_tip_pro         in varchar2,
                                   i_par_per_real    in date,
                                   i_des_tipos_benef in varchar2,
                                   i_cod_tipo_ben    in varchar2,
                                   i_num_processo    in number,
                                   i_num_grp         in number,
                                   i_seq_pag         in number,
                                   i_num_cpf         in varchar2,
                                   i_num_seq_proc    in number,
                                   i_flg_retorno     out varchar2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_ATUALIZA_PENSAOALIMENTICIA(i_cod_ins         in number,
                                          i_per_pro         in date,
                                          i_cod_usu         in varchar2,
                                          i_tip_pro         in varchar2,
                                          i_par_per_real    in date,
                                          i_des_tipos_benef in varchar2,
                                          i_cod_tipo_ben    in varchar2,
                                          i_num_processo    in number,
                                          i_num_grp         in number,
                                          i_seq_pag         in number,
                                          i_num_cpf         in varchar2,
                                          i_num_seq_proc    in number,
                                          i_flg_retorno     out varchar2);
  ---------------------------------------------------------------------------

  FUNCTION SP_VALOR_PORCENTUAL13(
                                I_COD_BENEFICIO VARCHAR2
                                ) return NUMBER;

  PROCEDURE SP_ATUALIZA_TOTAIS_FOLHA(i_cod_ins         in number,
                                     i_per_pro         in date,
                                     i_cod_usu         in varchar2,
                                     i_tip_pro         in varchar2,
                                     i_par_per_real    in date,
                                     i_des_tipos_benef in varchar2,
                                     i_cod_tipo_ben    in varchar2,
                                     i_num_processo    in number,
                                     i_num_grp         in number,
                                     i_seq_pag         in number,
                                     i_num_cpf         in varchar2,
                                     i_num_seq_proc    in number,
                                     i_flg_retorno     out varchar2);
  ---------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_FOLHA_PARAM(ind in number);
  ---------------------------------------------------------------------------
  --PROCEDURE SP_GERA_PA_LIQ;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DEDUCOES_BASICAS(ide_cli in varchar2, deducao_ir out number);
  --------------------------------------------------------------------------------

   -- ALT JTS25
  PROCEDURE SP_VERIFICA_TOTAIS;

  PROCEDURE SP_OBTEM_ESENCAOEC40 ( VI_COD_IDE_CLI IN  VARCHAR2 ,
                                   vi_ind_atb out CHAR         );

  PROCEDURE SP_OBTEM_FATOR_MES_PRO (VI_BEN_DAT_INICIO  IN   DATE  ,
                                    VI_DIA_MES         OUT  CHAR    );
  --PROCEDURE SP_GRAVA_DETALHE_PA;
  ----- ROTINAS IMPLEMENTADAS PARA CACULO DE IR ACUMULADO

  PROCEDURE SP_SEPARA_IRRF (    IDX_IRRF2       OUT NUMBER,
                                IDX_IRRF2_RETRO OUT NUMBER,
                                IDX_IRRF2_HISTO OUT NUMBER
                            );

  PROCEDURE SP_SEPARA_IRRF_SUP (IDX_IRRF2       OUT NUMBER,
                                IDX_IRRF2_RETRO OUT NUMBER,
                                IDX_IRRF2_HISTO OUT NUMBER
                            );

  PROCEDURE SP_OBTEM_IRRF_RETRO(ide_cli         IN  varchar2,
                          idx_val               IN  number,
                          FLG_PA                IN  varchar2,
                          O_VALOR               OUT number,
                          O_VALOR_13            OUT number,
                          O_BASE_BRUTA_IRRF     OUT number,
                          O_BASE_BRUTA_13_IRRF  OUT number,
                          O_QTA_MES             OUT number
                               );
 PROCEDURE SP_OBTEM_DETALHE_PAG_IRRF(IDE_CLI         IN VARCHAR2,
 FLG_PA               IN VARCHAR2,
 TP_EVENTO_ESPECIAL   IN VARCHAR2,
 TP_EVENTO            IN VARCHAR2,
 TP_IRRF              IN VARCHAR,
 V_BASE_BRUTA_IRRF    IN NUMBER ,
 V_BASE_BRUTA_13_IRRF IN NUMBER);

 FUNCTION SP_OBTEM_DED_PAGOS_IRRF(tipo_irr IN VARCHAR) RETURN NUMBER ;

 PROCEDURE SP_OBTEM_BASE_IR_ACUM (tipo_irr IN VARCHAR , V_BASE_IR_ACUMULADA OUT NUMBER);


  PROCEDURE SP_OBTEM_IR_ACUM (tipo_irr      IN VARCHAR,
                             V_IR_ACUMULADA OUT NUMBER,
                             V_DAT_INI_IR   OUT DATE  ,
                             V_DAT_TER_IR   OUT DATE) ;

 FUNCTION  SP_OBTEM_MESES_PAG_IRRF (TP_IRRF    IN VARCHAR
                                     ) RETURN NUMBER;
 PROCEDURE SP_CALCULA_IMPOSTO2_RETRO(TotBru in number,qta_meses in number , MonImp out number);

 PROCEDURE SP_INCLUI_DETALHE_PAG_IRRF(TP_COD_BENEFICIO IN NUMBER,
                                  TP_RUBRICA       IN NUMBER,
                                  TP_VAL_RUBRICA   IN NUMBER,
                                  TP_SEQ_VIG       IN NUMBER,
                                  TP_FLG_NATUREZA  IN VARCHAR2,
                                  TP_IRRF          IN VARCHAR);
 PROCEDURE   SP_CARREGA_DAT_PAGAMENTO;
 ---------------------------------------------------------
 PROCEDURE SP_INCLUI_DETALHE_PAG_CONSIG(TP_COD_BENEFICIO IN NUMBER,
                                  TP_RUBRICA       IN NUMBER,
                                  TP_VAL_RUBRICA   IN NUMBER,
                                  TP_SEQ_VIG       IN NUMBER,
                                  TP_FLG_NATUREZA  IN VARCHAR2,
                                  TP_INI_REF       IN DATE,
                                  TP_FIM_REF       IN DATE,
                                  TP_DES_COMPLEMENTO in VARCHAR);

 ----------------- CORRECAO MONETARIA -----------------
 --PROCEDURE SP_CALCULA_CORRECAO_UFESP;
 PROCEDURE SP_OBTEM_FATOR_CORRECAO_UFESP(
                                    ANO_ATUAL in NUMBER,
                                    ANO_RETRO in NUMBER,
                                    O_FATOR_CORRECAO OUT NUMBER);

 FUNCTION SP_OBTEM_PERC_FEQ  RETURN NUMBER;
 PROCEDURE SP_OBTEM_SIM_CNT(COM_COD_BENEFICIO IN NUMBER ,   O_VALOR OUT NUMBER);
 ---- Artigo 133 Novos Procedimentos --
  ---- Modificado 16-09-2013
 /* PROCEDURE SP_OBTEM_BASE_133(
                              VAL_CONCEITO_DIF_VENC IN NUMBER ,
                              VAL_ENTIDADE_DIF_VENC IN NUMBER ,
                              VAL_CARGO_DIF_VENC IN NUMBER ,
                              o_valor out number);


  PROCEDURE SP_OBTEM_BASE_NORMAL133(VAL_CARGO_DIF_VENC IN NUMBER ,o_valor out number);
  PROCEDURE SP_CALCULA_RDIFF_VENC;
  PROCEDURE SP_LER_RDIFF_VENC (TIPO_CURSOR IN NUMBER);
  PROCEDURE SP_OBTEM_VALOR_FORMULA_RECUR ;
  PROCEDURE SP_CARREGA_FORMULA_RECUR ;

  FUNCTION  SP_OBTEM_VALOR_VAR_DIFVENC(i_num_funcao   in number,
                              i_cod_variavel          in varchar2,
                              i_ordem                 in number) return varchar2;


  PROCEDURE SP_VALOR_CALCULADO_DIFVENC (I_RUBRICA       IN NUMBER,
                               I_COD_BENEFICIO IN NUMBER,
                               I_COD_VARIAVEL  IN VARCHAR2,
                               I_COD_ENTIDADE  IN NUMBER,
                               I_IND_VAL_CHEIO IN VARCHAR2,
                               I_TIPO          IN NUMBER,
                               O_VALOR         OUT NUMBER);

  PROCEDURE SP_COMPOSICAO_DIFVECN(I_COD_RUBRICA   in number,
                          I_VARIAVEL      in varchar2,
                          I_COD_BENEFICIO IN NUMBER,
                          I_COD_ENTIDADE  IN NUMBER,
                          i_ind_val_cheio in varchar2,
                          I_VALOR         OUT NUMBER);



  PROCEDURE SP_COMPOSICAO_DIFV_MB(I_COD_RUBRICA   in number,
                          I_VARIAVEL      in varchar2,
                          I_COD_BENEFICIO IN NUMBER,
                          I_COD_ENTIDADE  IN NUMBER,
                          I_tipo_base     in VARCHAR2,
                          I_ind_val_cheio in varchar2,
                          I_VALOR         OUT NUMBER);*/

 FUNCTION SP_OBTEM_PADRAO_VENCIMENTO_DIF RETURN VARCHAR2;
 FUNCTION SP_VALIDA_CONDICAO_RECUR RETURN BOOLEAN;
  PROCEDURE SP_CALCULA_SALMIN_ANTER(i_valor out number);
 FUNCTION SP_IRRF_EXT(ide_cli in varchar2) return boolean;
 PROCEDURE SP_OBTEM_TETO (ide_cli         in varchar2,
                         i_cod_entidade  in number  ,
                         i_cargo         in number  ,
                         o_valor         out number );
 PROCEDURE SP_VERIFICA_TIP_JUDICIAL ( I_DE_CLI         IN VARCHAR2  ,
                                      I_NUM_ORD_JUD    IN NUMBER,
                                      O_TIP_ORDEM_JUD OUT VARCHAR);
/* PROCEDURE SP_COMPOSICAO_BENEFICIO(I_COD_RUBRICA   IN NUMBER,
                          I_VARIAVEL      IN VARCHAR2,
                          I_COD_BENEFICIO IN NUMBER,
                          I_COD_ENTIDADE  IN NUMBER,
                          I_IND_VAL_CHEIO IN VARCHAR2,
                          I_VALOR         OUT NUMBER);*/
 -- PROCEDURE SP_CALCULA_PREV_DETALHE_AD ;
  FUNCTION SP_OBTEM_PERC_CARGO  RETURN NUMBER;

 FUNCTION  SP_CALC_PORCENTUAL13(
                        I_COD_BENEFICIO VARCHAR2
                       ) Return number;

 FUNCTION SP_OBTEM_QTD_DIAS_RESCISAO RETURN NUMBER;
 FUNCTION SP_VERIFICA_ANTECIPA_FERIAS_13 RETURN NUMBER;
 FUNCTION SP_VERIFICA_ANTECIPA_13 RETURN NUMBER;


 --INI [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
 PROCEDURE SP_GERA_DEBITO_AD_13 ;
 --FIM [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO

 FUNCTION SP_OBTEM_DIAS_FERIAS_PREV  Return number;
 FUNCTION SP_OBTEM_DIAS_FERIAS_M  Return number;
 FUNCTION SP_MEDIA_FERIAS_PREV RETURN NUMBER;
 FUNCTION SP_MEDIA_FERIAS_MES RETURN NUMBER;
 FUNCTION SP_RUB_VAR_FERIAS_PREV RETURN NUMBER ;
 FUNCTION SP_RUB_VAR_FERIAS_MES RETURN NUMBER ;
 FUNCTION SP_ANTECIPA_FERIAS_13_PROX RETURN NUMBER;
 FUNCTION SP_OBTEM_DIAS_FERIAS_PROP_RESC RETURN NUMBER;
 FUNCTION SP_OBTEM_DIAS_FERIAS_MES RETURN NUMBER;
 FUNCTION SP_OBTEM_DIAS_EVO_COMI RETURN NUMBER;
 FUNCTION SP_OBTEM_DIAS_EVO_COMI_COR RETURN NUMBER;
 FUNCTION SP_OBTEM_QTD_DIAS_FERIAS RETURN NUMBER;

 FUNCTION SP_OBTEM_QTD_DIAS_LICENCA RETURN NUMBER;

 FUNCTION SP_OBTEM_SAL_PRO RETURN NUMBER ;
 FUNCTION SP_VALOR_PAGO_FOL  RETURN NUMBER;
 FUNCTION SP_AQUISITIVO_COMPLETO  RETURN NUMBER;
 FUNCTION SP_DIAS_AQUISITIVO_COMPLETO  RETURN NUMBER;
 FUNCTION SP_QTDE_AQUISITIVO_COMPLETO  RETURN NUMBER;
 FUNCTION SP_CALC_AVOS13_RESCISAO Return number;
 FUNCTION SP_OBTEM_DIAS_FERIAS_RESCISAO Return number;
 FUNCTION SP_OBTEM_MEDIA_1_A_11 RETURN NUMBER;
 FUNCTION SP_OBTEM_MEDIA_FUNC RETURN NUMBER;
 FUNCTION FC_CALCULA_AVOS_AFAST (P_COD_INS         IN NUMBER,
                                    P_COD_ENTIDADE     IN NUMBER,
                                    P_COD_IDE_CLI      IN VARCHAR2,
                                    P_NUM_MATRICULA    IN VARCHAR2,
                                    P_COD_IDE_REL_FUNC IN NUMBER,
                                    P_ANO              IN VARCHAR2,
                                    P_COD_MOT_AFAST    IN VARCHAR2
                                    )
 RETURN NUMBER;
 FUNCTION SP_VALOR_PAGO_MES_ANT  RETURN NUMBER;
 FUNCTION SP_VALOR_PAGO_MES_ANT_2  RETURN NUMBER;
 FUNCTION SP_OBTEM_DIAS_LIC_SEM_REMUN RETURN NUMBER   ;

 --INI [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
 PROCEDURE SP_LIMPA_DETALHE_RET13;
--FIM [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO

 PROCEDURE SP_PROCESSA_RUBRICAS_EXCL;

 FUNCTION SP_OBTEM_DIAS_AVISO_PREVIO Return number;
 FUNCTION SP_OBTEM_QTD_DIAS_FALTAS   Return number;
 FUNCTION SP_OBTEM_QTD_DIAS_PENAL    Return number;

 PROCEDURE SP_GERA_FOLHA_PA;
 PROCEDURE SP_GRAVA_INFO_REF;
   -------------------------------------------------------
 FUNCTION SP_OBTEM_DED_LEGAIS_IRRF(tipo_irr IN VARCHAR)   RETURN NUMBER;
 FUNCTION SP_DED_IR_LEGAL(I_NUM_FCRUBRICA NUMBER)       RETURN BOOLEAN;

 FUNCTION SP_TRADUCAO_FORMULA (V_FORMULA  IN VARCHAR2 )  
 RETURN VARCHAR2  ;

	FUNCTION SP_OBTEM_DAT_INI_EXERC( I_num_matricula VARCHAR2,
                                I_cod_ide_rel_func NUMBER,
                                I_cod_entidade  NUMBER   
                               ) RETURN VARCHAR;
FUNCTION SP_IRRF_SIMPLIFICADO(ide_cli in varchar2) return boolean;

 -- ticket - 91568  21/05/2024 - Roberto
---------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_DEPENDENTES_IR(P_COD_IDE_CLI IN VARCHAR2,
                                     O_VALOR       OUT NUMBER);
  ---------------------------------------------------------------------------
 PROCEDURE SP_AJUSTA_TOTAIS;
 ---------------------------------------------------------------
 FUNCTION SP_OBTER_VALOR_BAR return NUMBER;



 
END     PAC_FOLHA_CALCULADA_ATIVO;
/
CREATE OR REPLACE PACKAGE BODY "PAC_FOLHA_CALCULADA_ATIVO" is
  -------------------------------------------------------------------------------------
  PROCEDURE SP_FOLHA_CALCULADA3(i_cod_ins                in number,
                                i_per_pro                in date, -- Periodo a processar
                                i_cod_usu                in varchar2,
                                i_tip_tra                in varchar2,
                                i_tip_pro                in varchar2, -- TIPO DE PROCESSO: N (normal), S (Suplementar), T (13 Salario)
                                i_num_cpf                in varchar2,
                                i_partir_de              in varchar2,
                                i_par_per_real           in date,
                                i_data_primeiro          in date,
                                i_des_tipos_benef        in varchar2,
                                i_cod_tipo_ben           in varchar2,
                                i_cod_categoria          in number,
                                i_cod_cargo              in number,
                                i_cod_entidade           in number,
                                i_percent_correcao       in number,
                                i_ind_proc_enquadramento in number,
                                i_num_processo           in number,
                                i_num_grp                in number,
                                i_num_seq_proc           in number,
                                i_seq_pagamento           in number)
   AS
    j              number;
    p              number;
    valor2         number;
    val_base_13    number(16, 4) := 0;
    c_concei       curform;
    processa_rub   boolean      := TRUE;
    ver_benef      number       := 0;
    xcont          number       :=0;
    i_flg_retorno  number       :=0;
    cont_com       number       := 0;
    p_flg_retorno  varchar2(2)  := '';

    o_v_pgto               number      := 0;
    v_status_processamento varchar2(2) := null;
    cont_proc              number(8)   := 0;
    nao_tem_prev           char(1)     := null;

  BEGIN
    BEGIN
      -- Atribuindo parametros de entrada a variaveis globais
      PAR_COD_INS       := i_cod_ins;
      PAR_PER_PRO       := i_per_pro;
      PAR_COD_USU       := i_cod_usu;
      PAR_TIP_TRA       := i_tip_tra;
      PAR_TIP_PRO       := i_tip_pro;
      PAR_NUM_CPF       := i_num_cpf;
      PAR_PARTIR_DE     := i_partir_de;
      PAR_PER_REAL      := i_par_per_real;
      PAR_DATA_PRIMEIRO := i_data_primeiro;
      PAR_NOM_BENEF     := i_des_tipos_benef;
      PAR_COD_TIPO_BEN  := i_cod_tipo_ben;
      PAR_IDE_CLI       := NULL;
      PAR_COD_CATEGORIA := i_cod_categoria;
      PAR_COD_CARGO     := i_cod_cargo;
      PAR_COD_ENTIDADE  := i_cod_entidade;
      PAR_NUM_PROCESSO  := i_num_processo; --ROD6
      PAR_NUM_GRP_PAG   := i_num_grp; --ROD7
      PAR_NUM_SEQ_PROC  := i_num_seq_proc;
      PAR_SEQ_PAGAMENTO := i_seq_pagamento;
      --
      PAR_PERCENT_CORRECAO       := i_percent_correcao;
      PAR_IND_PROC_ENQUADRAMENTO := i_ind_proc_enquadramento;
      SP_INICIO_PROCESSO;

      SP_CARREGA_VARIAVEIS_PARAMETRO;

      SP_VERIFICA_REPROCESSAMENTO;

      FOR J IN 1 .. num_cpf.count LOOP

        IF J = 1 then
          par_num_cpf := null;
        END IF;

        IF num_cpf(j) is not null and nvl(par_num_cpf, '0') <> num_cpf(j) then
          par_num_cpf := num_cpf(j);
        END IF;

        OPEN CURATIV;
        FETCH CURATIV
          INTO BEN_IDE_CLI, BEN_NUM_CPF, BEN_NOME, BEN_DTA_NASC, BEN_TIPO_PESSOA, BEN_FLG_STATUS,
               BEN_DISSOCIACAO,BEN_ENVIO_CORREIO;

        ANT_IDE_CLI        := BEN_IDE_CLI;
        ANT_NUM_CPF        := BEN_NUM_CPF;
        ANT_NOME           := BEN_NOME;
        ANT_FLG_STATUS     := BEN_FLG_STATUS;
        ANT_DTA_NASC       := BEN_DTA_NASC;
        ANT_BEN_DISSOCIACAO:= BEN_DISSOCIACAO;
        ANT_BEN_ENVIO_CORREIO  :=BEN_ENVIO_CORREIO;

        begin
          update tb_controle_processamento cp
             set cp.num_cpf_atual_proc = BEN_NUM_CPF,
                 cp.num_cpf_anter_proc = null
           where cp.cod_ins            = PAR_COD_INS
             and cp.num_processo       = PAR_NUM_PROCESSO
             and cp.num_grp_pag        = PAR_NUM_GRP_PAG
             and cp.seq_processamento  = PAR_NUM_SEQ_PROC;
        exception
          when others then
            null;
        end;
        COMMIT;

        SP_INICIA_VAR;


        xcont := CURATIV%rowcount;

        WHILE CURATIV%FOUND LOOP
          VI_SAL_BASE_TOTAL := 0;
          VI_TOT_DED        := 0;
          VI_BASE_IR        := 0;
          VI_BASE_PREV      := 0;
          VI_BASE_BRUTA     := 0;
          VI_BASE_BRUTA_13  := 0;
          COM_VAL_PORC_IND_133 :=0;
          -- Carrega Composic?o de salarios
          OPEN CUR_COMPATIV;
          FETCH CUR_COMPATIV
            INTO
              ------ Chave de Controle  de Processo ------
                  COM_COD_IDE_CLI       ,
                  COM_NUM_MATRICULA     ,
                  COM_COD_IDE_REL_FUNC  ,
                  COM_ENTIDADE          ,
              ------ Chave de Controle  de Processo ------
                  COM_TIP_BENEFICIO ,
                  COM_COD_RUBRICA   ,
                  COM_COD_FCRUBRICA ,
                  COM_SEQ_VIG_FC    ,
                  COM_NAT_COMP      ,
                  COM_NUM_ORD_JUD   ,
                  COM_IDE_CLI_INSTITUIDOR ,
                  COM_VAL_FIXO_IND  ,
                  COM_VAL_PORC_IND  ,
                  COM_QTY_UNID_IND  ,
                  COM_VAL_UNID      ,
                  COM_TIPO_VALOR    ,
                  COM_IND_QTAS      ,
                  COM_NUM_QTAS_PAG  ,
                  COM_TOT_QTAS_PAG  ,
                  COM_IND_COMP_RUB  ,
                  COM_NAT_RUB       ,
                  COM_INI_REF       ,
                  COM_FIM_REF       ,
                  COM_PRIORIDADE    ,
                  COM_DED_IR        ,
                  COM_FLG_PROCESSA  ,
                  COM_NAT_VAL       ,
                  COM_TIPO_APLICACAO,
                  COM_PERCENT_BEN   ,
                  COM_TIPO_EVENTO_ESPECIAL  ,
                  COM_MATRICULA   ,
                  COM_CARGO       ,
                  COM_CARGO_APOS  ,
                  BEN_DAT_INICIO  ,
                  BEN_DAT_FIM     ,
                  COM_DAT_INI_VIG ,
                  COM_DAT_FIM_VIG ,
                  COM_COD_IDE_CLI_BEN ,
                  COM_MSC_INFORMACAO  ,
                  COM_COL_INFORMACAO  ,
                  COM_PORC_VIG        ,
                  COM_DAT_VIG_RUBRICA ,
                  COM_APLICA_RATEIO   ,
                  COM_SEQ_VIG         ,
                  COM_NUM_CARGA       ,
                  COM_NUM_SEQ_CONTROLE_CARGA  ,
                  COM_NUM_GRUPO_PAG   ,
                  COM_RUBRICA_TIPO    ,
                  COM_FLG_STATUS      ,
                  COM_DAT_CONTRATO    ,
                  COM_COD_CONVENIO    ,
                  COM_DISSOCIACAO     ,
                  COM_COD_CONCEITO    ,
                  COM_COD_CARGO_RUB   ,
                  COM_COD_REFERENCIA_RUB;

          IF CUR_COMPATIV%found then

            ANT_COM_COD_IDE_CLI      :=COM_COD_IDE_CLI ;
            ANT_COM_COD_IDE_REL_FUNC :=COM_COD_IDE_REL_FUNC;
            ANT_ENTIDADE             :=COM_ENTIDADE    ;
            ANT_COD_IDE_CLI_BEN      :=COM_COD_IDE_CLI ;
            ANT_MATRICULA            :=COM_NUM_MATRICULA;

            ANT_ENTIDADE             := COM_ENTIDADE;
            ANT_CARGO                := COM_CARGO;
            ANT_DAT_INI_BEN          := BEN_DAT_INICIO;
            ANT_FLG_STATUS           := COM_FLG_STATUS;

            SP_CALC_DATAS_PROPORCIONAL;
            VI_PROP_BEN := 1;
               VI_PROP_SAIDA:=1;
               VI_PROP_13   :=1;
               SP_OBTEM_EVOLU_REL_FUNCIONAL;
               VI_PROP_COMPOSICAO := SP_OBTEM_PROP_COMPOSICAO;

          END IF;

          WHILE CUR_COMPATIV%FOUND LOOP

            SP_VERIFICA_ORDEM_JUDICIAL(0, PAR_PERCENT_CORRECAO); -- verifica ordem judicila para correc?o no calculo

            PROCESSA_RUB := TRUE;

            SP_PROCESSA_RUBRICA(PROCESSA_RUB);

            VI_PROP_COMPOSICAO := SP_OBTEM_PROP_COMPOSICAO;
            -------------------------
            --Novo modelo de rubricas
            -------------------------

            IF PROCESSA_RUB = TRUE THEN
              SP_CALCULA_VALOR_RUBRICA;

              IF mon_calculo > 0 and COM_FLG_PROCESSA = 'S' THEN

                -- armazena em array
                SP_INS_DETCALCULADO(mon_calculo);
              END IF;
            ELSE
              -- 'Rubrica Excludentes';
              --'Aviso - Rubrica Excluida por ser incompativel com outra';
              NULL;
            END IF;
            COM_COD_BENEFICIO := 0;
            FETCH CUR_COMPATIV
              INTO
                  COM_COD_IDE_CLI       ,
                  COM_NUM_MATRICULA     ,
                  COM_COD_IDE_REL_FUNC  ,
                  COM_ENTIDADE          ,
                  COM_TIP_BENEFICIO     ,
                  COM_COD_RUBRICA       ,
                  COM_COD_FCRUBRICA     ,
                  COM_SEQ_VIG_FC        ,
                  COM_NAT_COMP          ,
                  COM_NUM_ORD_JUD       ,
                  COM_IDE_CLI_INSTITUIDOR,
                  COM_VAL_FIXO_IND      ,
                  COM_VAL_PORC_IND      ,
                  COM_QTY_UNID_IND      ,
                  COM_VAL_UNID          ,
                  COM_TIPO_VALOR        ,
                  COM_IND_QTAS          ,
                  COM_NUM_QTAS_PAG      ,
                  COM_TOT_QTAS_PAG      ,
                  COM_IND_COMP_RUB      ,
                  COM_NAT_RUB           ,
                  COM_INI_REF           ,
                  COM_FIM_REF           ,
                  COM_PRIORIDADE        ,
                  COM_DED_IR            ,
                  COM_FLG_PROCESSA      ,
                  COM_NAT_VAL           ,
                  COM_TIPO_APLICACAO    ,
                  COM_PERCENT_BEN ,
                  COM_TIPO_EVENTO_ESPECIAL  ,
                  COM_MATRICULA             ,
                  COM_CARGO                 ,
                  COM_CARGO_APOS            ,
                  BEN_DAT_INICIO            ,
                  BEN_DAT_FIM               ,
                  COM_DAT_INI_VIG           ,
                  COM_DAT_FIM_VIG       ,
                  COM_COD_IDE_CLI_BEN   ,
                  COM_MSC_INFORMACAO    ,
                  COM_COL_INFORMACAO    ,
                  COM_PORC_VIG          ,
                  COM_DAT_VIG_RUBRICA   ,
                  COM_APLICA_RATEIO     ,
                  COM_SEQ_VIG           ,
                  COM_NUM_CARGA         ,
                  COM_NUM_SEQ_CONTROLE_CARGA  ,
                  COM_NUM_GRUPO_PAG           ,
                  COM_RUBRICA_TIPO            ,
                  COM_FLG_STATUS              ,
                  COM_DAT_CONTRATO            ,
                  COM_COD_CONVENIO            ,
                  COM_DISSOCIACAO             ,
                  COM_COD_CONCEITO            ,
                  COM_COD_CARGO_RUB           ,
                  COM_COD_REFERENCIA_RUB;

            IF
                  COM_COD_IDE_CLI      <>    ANT_COM_COD_IDE_CLI      OR
                  COM_NUM_MATRICULA    <>    ANT_MATRICULA            OR
                  COM_COD_IDE_REL_FUNC <>    ANT_COM_COD_IDE_REL_FUNC OR
                  COM_ENTIDADE         <>    ANT_ENTIDADE
                  --INI [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
                  --OR CUR_COMPATIV%NOTFOUND
                  --FIM [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
             THEN

              VI_PERCENTUAL_RATEIO_ANT:=1;
              VI_PERCENTUAL_RATEIO_ANT:= VI_PERCENTUAL_RATEIO;
              APLICAR_PROP_SAIDA := TRUE;

              SP_CALC_DATAS_PROPORCIONAL;
              VI_PROP_SAIDA:=1 ;
              VI_PROP_13:=1;



              v_cod_beneficio.extend;
              V_CONT_BENEF := V_CONT_BENEF + 1;
              v_cod_beneficio( ANT_COM_COD_IDE_REL_FUNC ) := ANT_COD_BENEFICIO;
               ver_benef := v_cod_beneficio.count;

               BEGIN
                IF v_cod_beneficio.count > 1 THEN
                  vi_sal_base_total := vi_sal_base_total +
                                       v_sal_base(ANT_cod_beneficio) (1);
                ELSE
                  vi_sal_base_total := v_sal_base(ANT_cod_beneficio) (1);
                END IF;
              EXCEPTION
                when others then
                  p_coderro       := sqlcode;
                  p_sub_proc_erro := 'Erro Salario Base Benef. - ' ||
                                     ANT_cod_beneficio;
                  p_msgerro       := sqlerrm;
                  INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                        p_coderro,
                                        'Calcula Folha',
                                        sysdate,
                                        p_msgerro,
                                        p_sub_proc_erro,
                                        BEN_IDE_CLI,
                                        COM_COD_FCRUBRICA);
                  VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              END;

              SP_INCLUI_BENEFICIO_ARRAY;
              ANT_ENTIDADE        := COM_ENTIDADE;
              IF COM_COD_BENEFICIO <> 0 THEN
                    ANT_COM_COD_IDE_CLI      :=COM_COD_IDE_CLI  ;
                    ANT_COM_COD_IDE_REL_FUNC :=COM_COD_IDE_REL_FUNC;
                    ANT_ENTIDADE             :=COM_ENTIDADE;
                    ANT_COD_IDE_CLI_BEN      :=COM_COD_IDE_CLI;
                    ANT_MATRICULA            :=COM_NUM_MATRICULA;
                    ANT_ENTIDADE             := COM_ENTIDADE;
                    ANT_CARGO                := COM_CARGO;
                    ANT_DAT_INI_BEN          := BEN_DAT_INICIO;
                    ANT_FLG_STATUS           := COM_FLG_STATUS;

              END IF;

              IF CUR_COMPATIV%FOUND THEN

                SP_OBTEM_EVOLU_REL_FUNCIONAL;

              END IF;

            ELSE
              ANT_MATRICULA            := COM_NUM_MATRICULA;
              ANT_COM_COD_IDE_REL_FUNC :=COM_COD_IDE_REL_FUNC;
              ANT_ENTIDADE             := COM_ENTIDADE;
              ANT_CARGO                := COM_CARGO;
              ANT_NUM_GRUPO_PAG        :=COM_NUM_GRUPO_PAG;
              ANT_FLG_STATUS           :=COM_FLG_STATUS;
            END IF;

          END LOOP;
          CLOSE CUR_COMPATIV;
          PREV_IDE_CLI   := BEN_IDE_CLI;
          BEN_IDE_CLI    := '0';
          BEN_FLG_STATUS := 'X';
          FETCH CURATIV
            INTO BEN_IDE_CLI, BEN_NUM_CPF, BEN_NOME, BEN_DTA_NASC, BEN_TIPO_PESSOA, BEN_FLG_STATUS, BEN_DISSOCIACAO,BEN_ENVIO_CORREIO;

          IF CURATIV%rowcount >= 0 AND ant_ide_cli is not null THEN

            IF BEN_IDE_CLI <> ANT_IDE_CLI  THEN

               --INI [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
               IF PAR_TIP_PRO = 'T' THEN
                    SP_INCLUI_BENEFICIO_ARRAY;
                    SP_LIMPA_DETALHE_RET13;
                    SP_GERA_DEBITO_AD_13;
               END IF;
               --FIM [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO

               IF PAR_TIP_PRO <> 'R' AND PAR_PER_PRO = PAR_PER_REAL THEN

               -----descomentado 12-06-2022 -- Inclusao de Retroativo
                IF  PAR_TIP_PRO <> 'T'   THEN
                    SP_INCLUI_BENEFICIO_ARRAY;
                    SP_INS_DETCAL_RET;
                END IF;
               ---  Comentado 12-06-2022 -- Inclusao de Retroativo
               --  IF PAR_TIP_PRO <> 'T' THEN
                --    SP_INCLUI_BENEFICIO_ARRAY;
                -- END IF;

                ------------------------------------------------------
                -- Bloco de limpeza de Rubricas para apoio do calculo
                -- Tony Caravana, em : 2019-04-23
                ------------------------------------------------------
                SP_PROCESSA_RUBRICAS_EXCL;

                 V_CALCULO_IR := 'S';
                ----------------------------------------------
                 -- Rotina de Separac?o de Rendimentos
                -- Separa os Rendimento do Ano de competencia
                -- dos rendimentos de Periodos Anteriores e
                -- Rendimento de 13.

          ----- ROTINA DE CONTROLE CALCULO  DE IR
         IF NOT vi_suplementar  THEN

              --- Controle de Base de Ir Deducida
              VI_BASE_IR_ARR    ( ANT_COM_COD_IDE_REL_FUNC )(1)    := 0;
              VI_BASE_IR_ARR_13 ( ANT_COM_COD_IDE_REL_FUNC )(1) := 0;
              VI_PERC_IR        ( ANT_COM_COD_IDE_REL_FUNC )(1)        := 0;
              VI_PERC_IR13      ( ANT_COM_COD_IDE_REL_FUNC )(1)      := 0;
              VI_BASE_IR_ARR_DED ( ANT_COM_COD_IDE_REL_FUNC )(1):=0;


             VI_IR_EXTERIOR:=FALSE;
             VI_IR_EXTERIOR:=SP_IRRF_EXT(ANT_IDE_CLI);
             IF  NOT VI_IR_EXTERIOR  THEN
                     BEGIN
                         IDX_IRRF:=0;
                        V_VAL_IR:=0;
                        V_VAL_IR_13 :=0;

                        IF PAR_PER_PRO = PAR_PER_REAL THEN
                               SP_SEPARA_IRRF(IDX_IRRF,IDX_IRRF_RETRO ,IDX_IRRF_HISTO) ;

                               SP_OBTEM_IRRF(ant_ide_cli,
                                            IDX_CALN,
                                            'N',
                                            V_VAL_IR,
                                            V_VAL_IR_13);
                             --- FIM PARA NAO PROCESSAR IR PARA RETROATIVOS
                            IF V_VAL_IR > 0 OR V_VAL_IR_13 > 0 THEN
                              IF PAR_TIP_PRO = 'T' THEN
                                -- Incluir a Rubrica do IR no ARRAY
                                SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'T');
                              ELSE
                                SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'N');
                              END IF;
                            ELSE
                              vi_ir_ret.extend;
                              -- Inicializacao da variavel do ir retido, recebendo o valor do ir calculado
                              vi_ir_ret(1) := V_VAL_IR;
                              -- nao existindo IR , o valor da variavel ir retido ficara com zero.
                            END IF;

                     ---- Bloque de IR ACUMULADO do Periodo ----

                               V_VAL_IR:=V_VAL_IR_RETRO;
                               SP_OBTEM_IRRF_RETRO(ant_ide_cli   ,
                                             IDX_IRRF_RETRO      , -- IDX_CALN, -- Novo Calculo
                                             'R'                 ,
                                             V_VAL_IR_RETRO      ,
                                             V_VAL_IR_13         ,
                                             V_BASE_BRUTA_IRRF   ,
                                             V_BASE_BRUTA_13_IRRF,
                                             QTA_MESES);

                                V_VAL_IR:=V_VAL_IR_RETRO;
                                IF V_VAL_IR_RETRO > 0 OR V_VAL_IR_13 > 0 THEN
                                   SP_OBTEM_DETALHE_PAG_IRRF(ANT_IDE_CLI, 'R', 'J', 'N','R',V_BASE_BRUTA_IRRF,V_BASE_BRUTA_13_IRRF);
                                ELSE
                                          vi_ir_ret.extend;
                                          vi_ir_ret(1) := V_VAL_IR_RETRO;
                                END IF;
                             ------- BLOQUE DE CALCULO DE IR DE 13 SALARIO ------
                               FOR i2 IN 1 .. vfolha.count LOOP
                                  rfol := vfolha(i2);
                                  VI_BASE_IR_ARR_DED(rfol.COD_IDE_REL_FUNC)(1):=0;
                                  VI_BASE_IR_ARR    (rfol.COD_IDE_REL_FUNC)(1):=0;
                                  VI_PERC_IR13      (rfol.COD_IDE_REL_FUNC)(1):=0;
                                END LOOP;
                                  p  := VI_BASE_IR_ARR_DED(rfol.COD_IDE_REL_FUNC)(1);

                               SP_OBTEM_IRRF_RETRO (ant_ide_cli   ,
                                             IDX_IRRF_HISTO      , -- IDX_CALN, -- Novo Calculo
                                             'D'                 ,
                                             V_VAL_IR_RETRO      ,
                                             V_VAL_IR_13         ,
                                             V_BASE_BRUTA_IRRF   ,
                                             V_BASE_BRUTA_13_IRRF,
                                             QTA_MESES13);
                              IF V_VAL_IR > 0 OR V_VAL_IR_13 > 0 THEN
                                 p  := VI_BASE_IR_ARR_DED(rfol.COD_IDE_REL_FUNC)(1);
                                 SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'D', 'K', 'N');
                              ELSE
                                 NULL;
                              END IF;

                        ELSE
                           V_VAL_IR    := 0;
                           V_VAL_IR_13 := 0;
                        END IF;

                     EXCEPTION
                     WHEN OTHERS THEN
                         p_coderro       := sqlcode;
                         p_sub_proc_erro := 'SP_FOLHA_CALCULADA -Calculo IR';
                         p_msgerro       := sqlerrm;
                         INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'Calcula Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                ant_ide_cli,
                                                0);

                          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                    END;

           ELSE
             ---- Calculo de Ir para Residentes no Exterior
             BEGIN
                IDX_IRRF:=0;
                V_VAL_IR:=0;
                IDX_IRRF:=0;
                V_VAL_IR_13 :=0;
                              SP_OBTEM_IRRF(ant_ide_cli,
                              IDX_CALN,
                              'E',
                              V_VAL_IR,
                              V_VAL_IR_13);
                  IF V_VAL_IR > 0 OR V_VAL_IR_13 > 0 THEN
                    IF PAR_TIP_PRO = 'T' THEN
                      -- Incluir a Rubrica do IR no ARRAY
                      SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'T');
                    ELSE
                      SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'N');
                    END IF;
                  ELSE
                    vi_ir_ret.extend;
                    -- Inicializacao da variavel do ir retido, recebendo o valor do ir calculado
                    vi_ir_ret(1) := V_VAL_IR;
                    -- nao existindo IR , o valor da variavel ir retido ficara com zero.
                  END IF;
               EXCEPTION
              WHEN OTHERS THEN
                         p_coderro       := sqlcode;
                         p_sub_proc_erro := 'SP_FOLHA_CALCULADA -Calculo IR';
                         p_msgerro       := sqlerrm;
                         INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'Calcula Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                ant_ide_cli,
                                                0);

                          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
               END;
          END IF;

         END IF;
           --------------------------------------------
          -- Termino de Calculo de IR ----
         --------------------------------------------
               -- Comentando 11-10-2011
               --- vlr_margem_consig := CALCULA_MARGEM_CONSIG;

                IF VI_TEM_SAIDA AND VI_BASE_IR_13 > 0 THEN
                  -- Incluir a Rubrica do IR - 13  - no ARRAY
                  IF PAR_TIP_PRO = 'T' THEN
                    SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'A', 'T');
                  END IF;
                  SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'T');
                END IF;

                --              SP_CALCULA_REDUTOR; -- calculo do redutor MVL - 20060613

                --            verificar limite valor pagamento  (Creditos - Desconto)
                SP_INCLUI_DET_SUSPENSO;	
						  -- ticket - 91568  21/05/2024 - Roberto 
								SP_AJUSTA_TOTAIS;					
                SP_GRAVA_MASTER_PAG;
     
                SP_GRAVA_DETALHE_PAG;
                ----- Gerac?o de Folha Pa por Vinculo  --
                SP_GERA_FOLHA_PA;
                SP_GRAVA_INFO_REF;

                cont_com  := nvl(cont_com, 0) + 1;
                cont_proc := nvl(cont_proc, 0) + 1;
                --              IF  cont_com = 150 THEN
                COMMIT;
                --                   cont_com := 0;
                --              END IF;
                IF PAR_TIP_PRO <> 'R' THEN
                   begin
                     update tb_controle_processamento cp
                        set --cp.num_cpf_inicial    = ANT_NUM_CPF,
                         cp.num_cpf_anter_proc = ANT_NUM_CPF,
                         cp.num_cpf_atual_proc = BEN_NUM_CPF
                      where cp.cod_ins = PAR_COD_INS
                        and cp.num_processo = PAR_NUM_PROCESSO
                        and cp.num_grp_pag = PAR_NUM_GRP_PAG
                        and cp.seq_processamento = PAR_NUM_SEQ_PROC;

                   exception
                     when others then
                       null;
                       commit;
                   end;

                   begin
                     update tb_processamento pp
                        set pp.qtde_calculado = cont_proc
                      where pp.cod_tip_processamento IN ( '01','20')
                        and pp.cod_ins = par_cod_ins
                        and pp.per_processo = par_per_pro
                        and pp.cod_tip_processo = par_tip_pro
                        and pp.seq_pagamento = vi_seq_pagamento
                        and pp.flg_processamento = 'P'
                        and pp.num_processo = PAR_NUM_PROCESSO --ROD6
                        and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
                        and pp.seq_processamento = PAR_NUM_SEQ_PROC
                        and pp.dat_fim_proc is null;
                     COMMIT;
                   exception
                     when others then
                       null;
                   end;
                end if;

                SP_INICIALIZA_ARRAY;
                ANT_BEN_DISSOCIACAO := BEN_DISSOCIACAO;
                ANT_IDE_CLI     := BEN_IDE_CLI;
                ANT_NUM_CPF     := BEN_NUM_CPF;
                ANT_NOME        := BEN_NOME;
                ANT_FLG_STATUS  := BEN_FLG_STATUS;
                ANT_DTA_NASC    := BEN_DTA_NASC;
                ANT_MATRICULA   := replace(COM_MATRICULA, '-', ''); -- alterado Ffranco 21/11/2006              ANT_ENTIDADE := COM_ENTIDADE;
                ANT_ENTIDADE    := COM_ENTIDADE;
                ANT_CARGO       := COM_CARGO;
                ANT_DAT_INI_BEN := BEN_DAT_INICIO;
                ANT_BEN_ENVIO_CORREIO  :=BEN_ENVIO_CORREIO;
              END IF;
            END IF;

            IF PAR_TIP_PRO = 'R' OR
               (PAR_TIP_PRO = 'T' AND PAR_PER_PRO <> PAR_PER_REAL) THEN
              -- GRAVA MASTER RETROATIVO
              SP_GRAVA_MASTER_RET;
              -- GRAVA DETALHE RETROATIVO
              SP_GRAVA_DETALHE_RET;

              COMMIT;

              SP_INICIALIZA_ARRAY;

              ANT_IDE_CLI    := BEN_IDE_CLI;
              ANT_NUM_CPF    := BEN_NUM_CPF;
              ANT_NOME       := BEN_NOME;
              ANT_FLG_STATUS := BEN_FLG_STATUS;
              ANT_DTA_NASC   := BEN_DTA_NASC;
            END IF;
          END IF;

          IF PAR_TIP_PRO <> 'R' OR
             (PAR_TIP_PRO = 'T' AND PAR_PER_PRO <> PAR_PER_REAL) THEN
            begin
              update tb_processamento pp
                 set pp.qtde_calculado = cont_proc
               where pp.cod_tip_processamento IN ( '01','20')
                 and pp.cod_ins = par_cod_ins
                 and pp.per_processo = par_per_pro
                 and pp.cod_tip_processo = par_tip_pro
                 and pp.seq_pagamento = vi_seq_pagamento
                 and pp.flg_processamento = 'P'
                 and pp.num_processo = PAR_NUM_PROCESSO --ROD6
                 and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
                 and pp.seq_processamento = PAR_NUM_SEQ_PROC
                 and pp.dat_fim_proc is null;
              COMMIT;
            exception
              when others then
                null;
            end;
          END IF;

          -- verifica se houve cancelamento do usuario

          IF cont_com >= 0 THEN
            cont_com := 0;

            begin
              select pp.flg_processamento
                into v_status_processamento
                from tb_processamento pp
               where pp.cod_tip_processamento in ( '01', '08','20')
                 and pp.cod_ins = par_cod_ins
                 and pp.per_processo = par_per_pro
                 and pp.cod_tip_processo = par_tip_pro
                 and pp.seq_pagamento = vi_seq_pagamento
                 and pp.flg_processamento = 'C'
                 and pp.num_processo = PAR_NUM_PROCESSO --ROD6
                 and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
                 and pp.seq_processamento = PAR_NUM_SEQ_PROC
                 and pp.dat_fim_proc is null;

              if v_status_processamento = 'C' then
                update tb_processamento pp
                   set pp.dat_fim_proc = sysdate
                 where pp.cod_tip_processamento in ( '01', '08','20')
                   and pp.cod_ins = par_cod_ins
                   and pp.per_processo = par_per_pro
                   and pp.cod_tip_processo = par_tip_pro
                   and pp.num_processo = PAR_NUM_PROCESSO --ROD6
                   and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
                   and pp.seq_pagamento = vi_seq_pagamento
                   and pp.seq_processamento = PAR_NUM_SEQ_PROC
                   and pp.flg_processamento = 'C'
                   and pp.dat_fim_proc is null;

                commit;
                exit;
              end if;

            exception
              when others then

                null;
            end;
          END IF;

        END LOOP;
        CLOSE CURATIV;

      END LOOP;

              i_flg_retorno := 0;


      if cont_com > 0 then
        commit;
      end if;

      /* */
      if i_num_cpf is not null AND PAR_PARTIR_DE = 'N' then
        NULL;
      ELSE
        v_ide_cli := null;
      END IF;

      if nvl(v_status_processamento, 'N') <> 'C' and
         PAR_IND_PROC_ENQUADRAMENTO = 0 then

        IF PAR_TIP_PRO <> 'R' AND PAR_PER_PRO = PAR_PER_REAL THEN

          begin
            update tb_processamento pp
               set pp.qtde_calculado = cont_proc,
                   pp.qtde_erros     = VI_QTD_ERROS
             where pp.cod_tip_processamento IN ( '01','20')
               and pp.cod_ins = par_cod_ins
               and pp.per_processo = par_per_pro
               and pp.cod_tip_processo = par_tip_pro
               and pp.seq_pagamento = vi_seq_pagamento
               and pp.flg_processamento = 'P'
               and pp.num_processo = PAR_NUM_PROCESSO --ROD6
               and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
               and pp.seq_processamento = PAR_NUM_SEQ_PROC
               and pp.dat_fim_proc is null;

            commit;
          exception
            when others then
              null;
          end;

          pac_processamento_GRP.sp_registra_log(p_cod_tip_processamento => '01',
                                                p_cod_ins               => PAR_COD_INS,
                                                p_per_processo          => PAR_PER_PRO,
                                                p_cod_tip_processo      => PAR_TIP_PRO,
                                                p_seq_pagamento         => vi_seq_pagamento,
                                                p_des_tipos_benef       => PAR_NOM_BENEF, --PAR_GRP_PAG,
                                                p_cod_tipo_beneficio    => PAR_COD_TIPO_BEN,
                                                p_cod_banco             => null,
                                                p_num_tip_emissao       => null,
                                                p_cod_ide_cli           => v_ide_cli,
                                                p_dat_agenda_proc       => sysdate,
                                                p_flg_processamento     => 'F',
                                                p_msg_erro              => P_MSGERRO,
                                                p_cod_cargo             => NULL,
                                                p_cod_categoria         => NULL,
                                                p_cod_pccs              => NULL,
                                                p_cod_entidade          => null,
                                                p_num_processo          => PAR_NUM_PROCESSO, --ROD6
                                                p_num_grp               => PAR_NUM_GRP_PAG, --ROD7
                                                p_num_seq_proc          => PAR_NUM_SEQ_PROC, --ROD8
                                                p_flg_retorno           => p_flg_retorno);


          COMMIT;

        END IF;
      else
        begin
          update tb_processamento pp
             set pp.dat_fim_proc = sysdate
           where pp.cod_tip_processamento in ('01','08','20')
             and pp.cod_ins = par_cod_ins
             and pp.per_processo = par_per_pro
             and pp.cod_tip_processo = par_tip_pro
             and pp.seq_pagamento = vi_seq_pagamento
             and pp.flg_processamento = 'C'
             and pp.num_processo = PAR_NUM_PROCESSO --ROD6 inc
             and pp.num_grp = PAR_NUM_GRP_PAG --ROD7 inc
             and pp.seq_processamento = PAR_NUM_SEQ_PROC
             and pp.dat_fim_proc is null;
          commit;
        exception
          when others then
            null;
        end;

      end if;

      /* */
    EXCEPTION
      WHEN ERRO THEN

        if PAR_IND_PROC_ENQUADRAMENTO = 0 then

          pac_processamento_GRP.sp_registra_log(p_cod_tip_processamento => '01',
                                                p_cod_ins               => PAR_COD_INS,
                                                p_per_processo          => PAR_PER_PRO,
                                                p_cod_tip_processo      => PAR_TIP_PRO,
                                                p_seq_pagamento         => vi_seq_pagamento,
                                                p_des_tipos_benef       => PAR_NOM_BENEF, --PAR_GRP_PAG,
                                                p_cod_tipo_beneficio    => PAR_COD_TIPO_BEN,
                                                p_cod_banco             => null,
                                                p_num_tip_emissao       => null,
                                                p_cod_ide_cli           => v_ide_cli,
                                                p_dat_agenda_proc       => sysdate,
                                                p_flg_processamento     => 'E',
                                                p_msg_erro              => P_MSGERRO,
                                                p_cod_cargo             => NULL,
                                                p_cod_categoria         => NULL,
                                                p_cod_pccs              => NULL,
                                                p_cod_entidade          => null,
                                                p_num_processo          => PAR_NUM_PROCESSO, --ROD6
                                                p_num_grp               => PAR_NUM_GRP_PAG, --ROD7
                                                p_num_seq_proc          => PAR_NUM_SEQ_PROC, --ROD8
                                                p_flg_retorno           => p_flg_retorno);

          COMMIT;
        end if;
    END;

  END SP_FOLHA_CALCULADA3;

  -------------------------------------------------------------------------------------
  PROCEDURE SP_INICIO_PROCESSO AS

    j                      number;
    p                      number;
    cont_com               number := 0;
    p_flg_retorno          varchar2(2) := '';
    RET_DELETE             NUMBER := 0;
    o_v_pgto               number := 0;
    v_status_processamento varchar2(2) := null;
    num_cpf_ant            tb_pessoa_fisica.num_cpf%type;
    vo_num_cpf             tb_pessoa_fisica.num_cpf%type;

  BEGIN

    num_cpf_ant := ' ';

    IF PAR_TIP_PRO = 'E' THEN
      IF PAR_NUM_CPF is not null THEN
        null;
      ELSE
        p_coderro       := 'CPF Invalido para o processo Especial';
        p_sub_proc_erro := 'PROCESSO PRINCIPAL';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              PAR_NUM_CPF,
                              NULL);
                              VI_QTD_ERROS:=VI_QTD_ERROS+1;

        RAISE ERRO;
      END IF;
    end if;

    -- carrega seq_pagamento
    --select pp.seq_pagamento, pp.per_processo
    --  into vi_seq_pagamento, VI_DATA_ENQUADRAMENTO
    --  from tb_periodos_processamento pp
    -- where pp.flg_status = 'A';

    ------ Rod em 02/12/09 carrega seq_pagamento na m?o
    VI_DATA_ENQUADRAMENTO:=PAR_PER_REAL;
    vi_seq_pagamento :=  par_seq_pagamento;
    ------------------------

    p_sub_proc_erro := 'SP_FOLHA_CALCULADA';

    num_cpf.delete;
    ide_cli.delete;

    if PAR_NUM_CPF is not null AND PAR_PARTIR_DE = 'N' then
      BEGIN

        SELECT DISTINCT P.COD_IDE_CLI
          INTO v_ide_cli
          FROM TB_RELACAO_FUNCIONAL B, TB_PESSOA_FISICA P
         WHERE P.COD_INS = PAR_COD_INS
           AND P.COD_INS = B.COD_INS
           AND P.NUM_CPF = PAR_NUM_CPF
           AND P.COD_IDE_CLI = B.COD_IDE_CLI
           AND (to_char(B.DAT_FIM_EXERC, 'YYYYMM') >=
               to_char(PAR_PER_PRO, 'YYYYMM') or B.DAT_FIM_EXERC IS NULL
               or to_char(PAR_PER_PRO, 'YYYYMM')    <=to_char(B.DAT_FIM_EXERC+1, 'YYYYMM'));

        j := nvl(j, 0) + 1;
        num_cpf.extend;
        ide_cli.extend;
        num_cpf(j) := par_num_cpf;
        ide_cli(j) := v_ide_cli;

      exception
        when too_many_rows then

          for z in (SELECT DISTINCT P.COD_IDE_CLI, p.num_cpf
                      FROM TB_BENEFICIARIO B, TB_PESSOA_FISICA P
                     WHERE P.COD_INS = PAR_COD_INS
                       AND P.COD_INS = B.COD_INS
                       AND P.NUM_CPF = PAR_NUM_CPF
                       AND P.COD_IDE_CLI = B.COD_IDE_CLI_BEN
                       AND B.FLG_STATUS in ('A', 'H', 'S', 'X')
                       AND B.DAT_FIM_BEN IS NULL) loop

            IF z.num_cpf <> num_cpf_ant then

              j := nvl(j, 0) + 1;
              num_cpf.extend;
              ide_cli.extend;
              num_cpf(j) := par_num_cpf;
              ide_cli(j) := z.cod_ide_cli;

              num_cpf_ant := z.num_cpf;

            END IF;

          end loop;

        when others then
          p_coderro       := substr(p_msgerro, 1, 10);
          p_msgerro       := 'N?o foi encontrado um beneficio ativo para o CPF ';
          p_sub_proc_erro := 'PROCESSO PRINCIPAL';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                PAR_NUM_CPF,
                                0);

          RAISE ERRO;
      end;

    ELSE
      v_ide_cli := null;
      /*  j:=nvl(j,0)+1;
      num_cpf.extend;
      ide_cli.extend;
      num_cpf(j) := par_num_cpf;    */

    END IF;

    -- Registra entrada no log
    /**/

    if PAR_IND_PROC_ENQUADRAMENTO = 0 and PAR_TIP_PRO <> 'R' AND
       PAR_PER_PRO = PAR_PER_REAL AND PAR_PARTIR_DE = 'N' then

      pac_processamento_GRP.sp_registra_log(p_cod_tip_processamento => '01',
                                            p_cod_ins               => PAR_COD_INS,
                                            p_per_processo          => PAR_PER_PRO,
                                            p_cod_tip_processo      => PAR_TIP_PRO,
                                            p_seq_pagamento         => vi_seq_pagamento,
                                            p_des_tipos_benef       => PAR_NOM_BENEF, --PAR_GRP_PAG,
                                            p_cod_tipo_beneficio    => PAR_COD_TIPO_BEN,
                                            p_cod_banco             => null,
                                            p_num_tip_emissao       => null,
                                            p_cod_ide_cli           => v_ide_cli,
                                            p_dat_agenda_proc       => sysdate,
                                            p_flg_processamento     => 'P',
                                            p_msg_erro              => P_MSGERRO,
                                            p_cod_cargo             => NULL,
                                            p_cod_categoria         => NULL,
                                            p_cod_pccs              => NULL,
                                            p_cod_entidade          => null,
                                            p_num_processo          => PAR_NUM_PROCESSO,
                                            p_num_grp               => PAR_NUM_GRP_PAG,
                                            p_num_seq_proc          => PAR_NUM_SEQ_PROC, --ROD8
                                            p_flg_retorno           => p_flg_retorno); --ROD6

      commit;

    end if;

  END SP_INICIO_PROCESSO;
  -------------------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_VARIAVEIS_PARAMETRO AS

    j        number;
    c_concei curform;

  BEGIN
    vparam.delete;
    val_taxa_prev.delete;
    lim_taxa_prev.delete;
    dsc_taxa_prev.delete;
    idx_param := 0;

    vtotvar.delete;
    idx_totvar := 0;
    ---Inicio variaveis --
    reg_ttypir.delete;
    -----------------------

    SP_CARREGA_PARVAL_FOLHA(PAR_PER_PRO);
    SP_CARREGA_VAR_TOTAIS_FOLHA;
    SP_CARREGA_DAT_PAGAMENTO;

    v_val_teto_pensao := SP_OBTEM_TETO_PENSAO;

    if par_tip_pro = 'R' then
      --efv
      W_COD_PARAM_GERAL_CORRECAO := 'FIPE';
      SP_OBTEM_FATOR_CORRECAO('', PAR_PER_PRO, VI_FATOR_MES);
    else
      VI_FATOR_MES := 1;
    end if;

--  IF PAR_TIP_PRO = 'S' THEN
    IF PAR_TIP_PRO IN ('S','D') THEN --FOLHA DE RESCISAO 2020-02-25
      VI_SUPLEMENTAR := TRUE;
    ELSE
      VI_SUPLEMENTAR := FALSE;
    END IF;

    -- Carrega Variaveis globais
    v_ded_ir_65  := 0;
    v_ded_ir_dep := 0;

    --  Taxa de Contribuic?o
    PAR_COD_PAR := 'TASCO';
    PAR_PER_NUM := 1;

    val_taxa_prev.extend;
    lim_taxa_prev.extend;
    dsc_taxa_prev.extend;

    p_msgerro := null;

    PAR_PER_NUM := 3;
    PAR_COD_PAR := 'IMPMA';

    -- Valor deducivel para maiores de 65 anos
    --SP_OBTEM_PARVAL_FOLHA2('IMPMA', 1000, 'IMPMA', V_DED_IR_65);    -- ALTERADO CARLOS FANTIN 21092020 N?O TEM ISENC?O DE 65 ANOS PARA ATIVOS
    --PAR_COD_PAR := 'IMPDE';

 -- Desconto simplificado aplicado na deducao da base de ir
    PAR_COD_PAR := 'DESC_SIMP';
    SP_OBTEM_PARVAL_FOLHA2('DESC_SIMP', 2000, 'DESC_SIMP', V_DESC_SIMP_IR)  ;


    -- Valor deducivel por dependente economico
    SP_OBTEM_PARVAL_FOLHA2('IMPDE', 1000, 'IMPDE', V_DED_IR_DEP);

    -- Salario Minimo
    PAR_COD_PAR := 'SALMIN';
    SP_OBTEM_PARVAL_FOLHA2('SALMIN', 1000, 'PAR_SAL_MIN', V_VAL_SAL_MIN);

    -- Salario Minimo de insalubridade
    PAR_COD_PAR := 'SALMIN2';
    SP_OBTEM_PARVAL_FOLHA2('SALMIN2', 1000, 'PAR_SAL_MIN_2', V_VAL_SAL_MIN_2);

     -- Percentual para desconto
    PAR_COD_PAR := 'ISMAX';
    SP_OBTEM_PARVAL_FOLHA2('ISMAX', 1000, 'ISMAX', V_ISMAX);

    V_ISMAX := V_ISMAX / 100; -- Percentual

    -- Carrega Valor Meta global

    SP_OBTEM_PARVAL_FOLHA2('METAG',
                           1000,
                           'VAL_META_GLOBAL',
                           VI_META_GLOBAL);

    -- Carrega valor Contrib. APIPREM

    SP_OBTEM_PARVAL_FOLHA2('APIPREM', 1000, 'VAL_APIPREM', VI_VAL_APIPREM);

    -- Carrega numero de dias para suspensao

    IF p_msgerro IS NOT NULL THEN
      p_coderro       := substr(p_msgerro, 1, 10);
      p_msgerro       := 'Erro ao obter os parametros - SALMIN, ISMAX';
      p_sub_proc_erro := 'OBTEM_PARVAL_FOLHA';
      INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                            p_coderro,
                            'Calcula Folha',
                            sysdate,
                            p_msgerro,
                            p_sub_proc_erro,
                            BEN_IDE_CLI,
                            COM_COD_FCRUBRICA);

      --    RAISE ERRO;
    END IF;

    -- Obtem qtd meses para calculo
    SELECT decode((to_number(to_char(PAR_PER_PRO, 'mm')) - 1),
                  0,
                  1,
                  to_number(to_char(PAR_PER_PRO, 'mm')) - 1),
           to_number(to_char(LAST_DAY(PAR_PER_PRO), 'DD'))
      INTO V_QTD_MESES, V_DIAS_MES
      FROM dual;

    SP_OBTEM_PARVAL_FOLHA2('PRZ_RT_PM',
                           1000,
                           'PRAZO_RETROATIVO',
                           NUM_DIAS_PRAZO);

    DAT_PRZ_SUSPENSO := PAR_PER_PRO - NUM_DIAS_PRAZO;

    -- Carrega Array - Rubrica e conceito com indicadores de IR

    cod_con.delete;
    cod_rub.delete;
    flag_ded.delete;
    flag_base.delete;
    flag_rateio.delete;
    tip_evento.delete;
    tip_evento_especial.delete;
    nom_variavel.delete;
    val_variavel.delete;
    cod_entidade.delete;
    ind_grava_detalhe.delete;

    j := 1;
    cod_con.extend;
    cod_rub.extend;
    flag_ded.extend;
    flag_base.extend;
    flag_rateio.extend;
    tip_evento.extend;
    tip_evento_especial.extend;
    nom_variavel.extend;
    val_variavel.extend;
    cod_entidade.extend;
    ind_grava_detalhe.extend;

     IF PAR_NUM_CPF IS NOT NULL THEN
            OPEN c_concei FOR
            SELECT /*+ RULE */
            distinct b.cod_conceito,
                     a.cod_rubrica,
                     nvl(a.flg_ded_ir, 'N'),
                     nvl(a.flg_base_ir, 'N'),
                     nvl(fc.flg_aplica_rateio, 'N'),
                     nvl(a.tip_evento, 'N'),
                     nvl(a.tip_evento_especial, 'N'),
                     nvl(fc.col_informacao, ' '),
                     0,
                     b.cod_entidade,
                     nvl(fc.ind_grava_detalhe, 'S')
             FROM tb_conceitos_pag b, tb_rubricas a, tb_formula_calculo fc
             WHERE a.cod_ins = b.cod_ins
               AND a.cod_conceito = b.cod_conceito
               AND a.cod_entidade = b.cod_entidade
               and a.cod_rubrica = fc.cod_rubrica
               and fc.cod_rubrica = fc.cod_fcrubrica
               and fc.cod_ins = a.cod_ins
               and b.cod_entidade = fc.cod_entidade
               and b.cod_entidade = nvl(null, b.cod_entidade)

            and b.cod_entidade = 01
            UNION ALL
            SELECT /*+ RULE */
            distinct b.cod_conceito,
                     fc.cod_fcrubrica,
                     nvl(a.flg_ded_ir, 'N'),
                     nvl(a.flg_base_ir, 'N'),
                     nvl(fc.flg_aplica_rateio, 'N'),
                     nvl(a.tip_evento, 'N'),
                     nvl(a.tip_evento_especial, 'N'),
                     nvl(fc.col_informacao, ' '),
                     0,
                     b.cod_entidade,
                     nvl(fc.ind_grava_detalhe, 'S')
              FROM tb_conceitos_pag b, tb_rubricas a, tb_formula_calculo fc
             WHERE a.cod_ins = b.cod_ins
               AND a.cod_conceito = b.cod_conceito
               and a.cod_rubrica = fc.cod_rubrica
               and fc.cod_rubrica <> fc.cod_fcrubrica
               and fc.cod_ins = a.cod_ins
               and b.cod_entidade = a.cod_entidade
               and b.cod_entidade = fc.cod_entidade
               and b.cod_entidade = nvl(null, b.cod_entidade)
                -- agregado para teste
                   and b.cod_entidade = 01  ;
    ELSE
             OPEN c_concei FOR
            SELECT /*+ RULE */
            distinct b.cod_conceito,
                     a.cod_rubrica,
                     nvl(a.flg_ded_ir, 'N'),
                     nvl(a.flg_base_ir, 'N'),
                     nvl(fc.flg_aplica_rateio, 'N'),
                     nvl(a.tip_evento, 'N'),
                     nvl(a.tip_evento_especial, 'N'),
                     nvl(fc.col_informacao, ' '),
                     0,
                     b.cod_entidade,
                     nvl(fc.ind_grava_detalhe, 'S')
             FROM tb_conceitos_pag b, tb_rubricas a, tb_formula_calculo fc
             WHERE a.cod_ins = b.cod_ins
               AND a.cod_conceito = b.cod_conceito
               AND a.cod_entidade = b.cod_entidade
               and a.cod_rubrica = fc.cod_rubrica
               and fc.cod_rubrica = fc.cod_fcrubrica
               and fc.cod_ins = a.cod_ins
               and b.cod_entidade = fc.cod_entidade
               and b.cod_entidade = nvl(null, b.cod_entidade)

            and b.cod_entidade = 01
            UNION ALL
            SELECT /*+ RULE */
            distinct b.cod_conceito,
                     fc.cod_fcrubrica,
                     nvl(a.flg_ded_ir, 'N'),
                     nvl(a.flg_base_ir, 'N'),
                     nvl(fc.flg_aplica_rateio, 'N'),
                     nvl(a.tip_evento, 'N'),
                     nvl(a.tip_evento_especial, 'N'),
                     nvl(fc.col_informacao, ' '),
                     0,
                     b.cod_entidade,
                     nvl(fc.ind_grava_detalhe, 'S')
              FROM tb_conceitos_pag b, tb_rubricas a, tb_formula_calculo fc
             WHERE a.cod_ins = b.cod_ins
               AND a.cod_conceito = b.cod_conceito
               and a.cod_rubrica = fc.cod_rubrica
               and fc.cod_rubrica <> fc.cod_fcrubrica
               and fc.cod_ins = a.cod_ins
               and b.cod_entidade = a.cod_entidade
               and b.cod_entidade = fc.cod_entidade
               and b.cod_entidade = nvl(null, b.cod_entidade)
                -- agregado para teste
                   and b.cod_entidade = 01  ;
    END IF;


    FETCH C_CONCEI
      INTO cod_con(j), cod_rub(j), flag_ded(j), flag_base(j), flag_rateio(j), tip_evento(j), tip_evento_especial(j), nom_variavel(j), val_variavel(j), cod_entidade(j), ind_grava_detalhe(j);
    WHILE C_CONCEI%FOUND LOOP
      j := j + 1;
      cod_con.extend;
      cod_rub.extend;
      flag_ded.extend;
      flag_base.extend;
      flag_rateio.extend;
      tip_evento.extend;
      tip_evento_especial.extend;
      nom_variavel.extend;
      val_variavel.extend;
      cod_entidade.extend;
      ind_grava_detalhe.extend;

      FETCH C_CONCEI
        INTO cod_con(j), cod_rub(j), flag_ded(j), flag_base(j), flag_rateio(j), tip_evento(j), tip_evento_especial(j), nom_variavel(j), val_variavel(j), cod_entidade(j), ind_grava_detalhe(j);
    END LOOP;
    CLOSE C_CONCEI;

     --- BLOQUE PARA CONTROLE DE IR
     --  IF   (PAR_TIP_PRO <>'R' ) THEN
            j := 1;

            cod_con2.delete;
            cod_rub2.delete;
            flag_ded2.delete;
            flag_base2.delete;
            tip_evento2.delete;
            tip_evento_especial2.delete;

            cod_con2.extend;
            cod_rub2.extend;
            flag_ded2.extend;
            flag_base2.extend;
            tip_evento2.extend;
            tip_evento_especial2.extend;

        ---- Extende Variavel Nova lei IR Roberto - 25/05/2023
            flag_ded_Legal.extend;


            OPEN c_concei FOR
            SELECT /*+ RULE */
            distinct A.cod_conceito,
                     a.cod_rubrica,
                     nvl(a.flg_ded_ir, 'N'),
                     nvl(a.flg_base_ir, 'N'),
                     nvl(a.tip_evento, 'N'),
                     nvl(a.tip_evento_especial, 'N'),
                     nvl(a.flag_ded_Legal,'N')
             FROM  VW_RUBRICAS_IR A;
                -- agregado para teste

             FETCH C_CONCEI
                INTO cod_con2(j), cod_rub2(j), flag_ded2(j), flag_base2(j),  tip_evento2(j), tip_evento_especial2(j), flag_ded_Legal(j);
              WHILE C_CONCEI%FOUND LOOP
                j := j + 1;
                cod_con2.extend;
                cod_rub2.extend;
                flag_ded2.extend;
                flag_base2.extend;

                tip_evento2.extend;
                tip_evento_especial2.extend;
                flag_ded_Legal.extend;
                FETCH C_CONCEI
                  INTO cod_con2(j), cod_rub2(j), flag_ded2(j), flag_base2(j),  tip_evento2(j), tip_evento_especial2(j), flag_ded_Legal(j);
              END LOOP;
              CLOSE C_CONCEI;

  END SP_CARREGA_VARIAVEIS_PARAMETRO;
  -------------------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_REPROCESSAMENTO AS

    j          number;
    k          number;
    RET_DELETE NUMBER := 0;
    w_contar   char(1) := 'S';
    WWCON_PROC number := 0;

  BEGIN
    -- Carrega Reprocesso
    w_contar := 'S';

    -- num_cpf.extend;
    -- ide_cli.extend;

    -- IF PAR_TIP_PRO <> 'R' THEN
    IF PAR_NUM_CPF is null and PAR_IND_PROC_ENQUADRAMENTO = 0 then

      j := 0;


      IF PAR_TIP_PRO <> 'R' AND PAR_PER_PRO = PAR_PER_REAL THEN
      if j > 0 then
        update tb_processamento pp
           set pp.qtde_a_calcular = j
         where pp.cod_tip_processamento in ( '01', '08','20')
           and pp.cod_ins = par_cod_ins
           and pp.per_processo = par_per_pro
           and pp.cod_tip_processo = par_tip_pro
           and pp.num_processo = PAR_NUM_PROCESSO --ROD6
           and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
           and pp.seq_pagamento = vi_seq_pagamento
           and pp.flg_processamento = 'P'
           and pp.seq_processamento = PAR_NUM_SEQ_PROC
           and pp.dat_fim_proc is null;
        commit;
        END IF;
        cont_proc := j;

        w_contar := 'N';

      end if;

    ELSE
      IF PAR_PARTIR_DE = 'N' THEN
        IF num_cpf(1) is null then
          j := 0;
          j := j + 1;
          num_cpf.extend;
          ide_cli.extend;
          num_cpf(j) := par_num_cpf;

          select distinct pf.cod_ide_cli
            into ide_cli(j)
            from tb_pessoa_fisica       pf,
                 tb_informacao_bancaria ib
           where pf.cod_ins = PAR_COD_INS
             and pf.num_CPF = par_num_cpf
             and ib.cod_ins = pf.cod_ins
             and nvl(ib.cod_ide_cli_englob, ib.cod_ide_cli) =
                 pf.cod_ide_cli;
        END IF;
      END IF;
    END IF;

    IF j = 0 then
      j := j + 1;
      num_cpf.extend;
      ide_cli.extend;
    END IF;

    IF PAR_IND_PROC_ENQUADRAMENTO = 0 then
      IF PAR_PARTIR_DE = 'N' THEN -- AND w_contar = 'S' THEN comentado Rod em 27.out.09

        BEGIN
          -- obter total a calcular para atualizacao no processamento

     SELECT count(distinct b.cod_ide_cli)
       into WWCON_PROC
       FROM TB_RELACAO_FUNCIONAL          B,
            TB_PESSOA_FISICA          P,
            TB_GRUPO_PAGAMENTO        GP,
            TB_CONTROLE_PROCESSAMENTO CP
      WHERE B.COD_INS = PAR_COD_INS
        AND B.COD_ENTIDADE = nvl(PAR_COD_ENTIDADE, B.COD_ENTIDADE)
        AND P.COD_INS = B.COD_INS
        AND B.COD_IDE_CLI >= 0
        AND P.COD_IDE_CLI = B.COD_IDE_CLI
        AND to_char(B.DAT_INI_EXERC, 'YYYYMM')  <= to_char(PAR_PER_PRO, 'YYYYMM')
        AND (to_char(B.DAT_FIM_EXERC, 'YYYYMM') >= to_char(PAR_PER_PRO, 'YYYYMM') or
            B.DAT_FIM_EXERC IS NULL)
        AND B.COD_SIT_FUNC      =1
        AND (P.NUM_CPF          = nvl(PAR_NUM_CPF, P.NUM_CPF) and PAR_PARTIR_DE = 'N')
        and GP.NUM_GRP_PAG      > 0
        and GP.NUM_GRP_PAG      = PAR_NUM_GRP_PAG
        AND b.cod_proc_grp_pag  = gp.cod_proc_grp_pago
        AND CP.COD_INS          = B.COD_INS
        AND CP.NUM_PROCESSO     = PAR_NUM_PROCESSO
        AND CP.Num_Grp_Pag      = PAR_NUM_GRP_PAG
        AND P.NUM_CPF           >= CP.NUM_CPF_INICIAL
        AND P.NUM_CPF           < CP.NUM_CPF_FINAL
        AND CP.SEQ_PROCESSAMENTO = PAR_NUM_SEQ_PROC;

          wcont_proc := 0;
          wcont_proc := wcont_proc + WWCON_PROC;
          cont_proc  := cont_proc + WWCON_PROC;

        exception
          when others then

            p_coderro       := substr(sqlerrm, 1, 10);
            p_msgerro       := 'Erro ao atualizar total a processar';
            p_sub_proc_erro := 'Processo Principal';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  1,
                                  0);

            RAISE ERRO;

        end;
      END IF;

      IF PAR_TIP_PRO <> 'R' AND PAR_PER_PRO = PAR_PER_REAL THEN
         update tb_processamento pp
            set pp.qtde_a_calcular = cont_proc
          where pp.cod_tip_processamento in ('01','20')
            and pp.cod_ins = par_cod_ins
            and pp.per_processo = par_per_pro
            and pp.cod_tip_processo = par_tip_pro
            and pp.seq_pagamento = vi_seq_pagamento
            and pp.flg_processamento = 'P'
            and pp.num_processo = PAR_NUM_PROCESSO --ROD6
            and pp.num_grp = PAR_NUM_GRP_PAG --ROD7
            and pp.seq_processamento = PAR_NUM_SEQ_PROC
            and pp.dat_fim_proc is null;
      commit;
      END IF;
    end if;

    cont_proc := 0;

    IF PAR_TIP_PRO <> 'R' AND
       --(PAR_TIP_PRO <> 'T' AND PAR_PER_REAL = PAR_PER_PRO) AND
       PAR_PARTIR_DE = 'N' THEN
      --ROD6 BLOCO LIMPA FOLHA "comentado Rodolfo 07/2009

      IF num_cpf(1) is null AND PAR_PARTIR_DE = 'N' THEN

 
                    RET_DELETE := PAC_LIMPA_TABELAS.PAC_LIMPA_FOLHA_GERAL (PAR_PER_PRO,
                                                                      PAR_TIP_PRO,
                                                                      PAR_COD_INS,
                                                                      PAR_NOM_BENEF,
                                                                      PAR_COD_TIPO_BEN,
                                                                      PAR_NUM_CPF,
                                                                      PAR_PARTIR_DE,
                                                                      PAR_NUM_PROCESSO,
                                                                      PAR_NUM_GRP_PAG,
                                                                      PAR_NUM_SEQ_PROC ); 



         null;
      END IF;

      FOR J IN 1 .. num_cpf.count LOOP

        IF num_cpf(j) is not null then
          par_num_cpf := num_cpf(j);

          k := 0;
          ide_cli.delete;

       FOR z in (select distinct pf.cod_ide_cli
                      from tb_pessoa_fisica pf
                     where pf.cod_ins = PAR_COD_INS
                       and pf.num_CPF = par_num_cpf
                         AND   exists (
                           select 1 from tb_processamento pp
                              where
                              pp.cod_tip_processamento in (01,08,20) and
                              pp.seq_processamento=PAR_NUM_SEQ_PROC  /*and
                              pp.cod_ide_cli=bb.cod_ide_cli_ben*/
                           )


                       ) loop


            k := nvl(k, 0) + 1;
            ide_cli.extend;
            ide_cli(k) := z.cod_ide_cli;

          END LOOP;

------------------------------------------------
     FOR K IN 1 .. ide_cli.count LOOP

      v_ide_cli := ide_cli(k);
      FOR APAGA IN (
        SELECT DISTINCT /*+ RULE */
            CB.COD_IDE_CLI AS BEN_IDE_CLI ,
            CB.COD_ENTIDADE               ,
            CB.NUM_MATRICULA              ,
            CB.COD_IDE_REL_FUNC           ,
            0  COM_TIPO_DISSOCIACAO
          FROM
               TB_RELACAO_FUNCIONAL  CB
         WHERE CB.COD_INS          = PAR_COD_INS
           AND CB.COD_ENTIDADE    = nvl(NULL, CB.COD_ENTIDADE)
           AND CB.COD_IDE_CLI     = v_ide_cli

      ) LOOP
            v_ide_cli := APAGA.BEN_IDE_CLI;
           IF APAGA.COM_TIPO_DISSOCIACAO=0 THEN


               delete tb_folha_pagamento_det fo
               where cod_ins             = PAR_COD_INS
                 and per_processo        = PAR_PER_PRO
                 and fo.cod_ide_cli      = v_ide_cli
                 and fo.num_matricula    = apaga.num_matricula
                 and fo.cod_ide_rel_func = apaga.cod_ide_rel_func
                 and fo.cod_entidade     = apaga.cod_entidade
                 and tip_processo        = PAR_TIP_PRO
                 and seq_pagamento       = vi_seq_pagamento;



              delete tb_folha_pagamento fo
               where cod_ins = PAR_COD_INS
                 and per_processo = PAR_PER_PRO
                 and fo.cod_ide_cli      = v_ide_cli
                 and fo.num_matricula    = apaga.num_matricula
                 and fo.cod_ide_rel_func = apaga.cod_ide_rel_func
                 and fo.cod_entidade     = apaga.cod_entidade
                 and tip_processo = PAR_TIP_PRO
                 and seq_pagamento = vi_seq_pagamento;
           -- **** AGREGADO PROJETO CAMPINAS ---
             delete tb_log_erro_folha er
               where er.cod_ins = PAR_COD_INS
                 and er.cod_ide_cli= v_ide_cli;
             commit;
           ELSE

               delete tb_folha_pagamento_det fo
               where cod_ins             = PAR_COD_INS
                 and per_processo        = PAR_PER_PRO
                 and fo.cod_ide_cli      = v_ide_cli
                 and fo.num_matricula    = apaga.num_matricula
                 and fo.cod_ide_rel_func = apaga.cod_ide_rel_func
                 and fo.cod_entidade     = apaga.cod_entidade
                 and tip_processo        = PAR_TIP_PRO
                 and seq_pagamento       = vi_seq_pagamento;



              delete tb_folha_pagamento fo
               where cod_ins = PAR_COD_INS
                 and per_processo = PAR_PER_PRO
                 and fo.cod_ide_cli      = v_ide_cli
                 and fo.num_matricula    = apaga.num_matricula
                 and fo.cod_ide_rel_func = apaga.cod_ide_rel_func
                 and fo.cod_entidade     = apaga.cod_entidade
                 and tip_processo = PAR_TIP_PRO
                 and seq_pagamento = vi_seq_pagamento;



                    commit;

           END IF;

          END LOOP;
        END LOOP;
        END IF;
      END LOOP;
    END IF;

  END SP_VERIFICA_REPROCESSAMENTO;
  -------------------------------------------------------------------------------------
  PROCEDURE SP_INICIA_VAR AS
  BEGIN
    vi_condicao              := FALSE;
    RAT_PERCENTUAL_RATEIO    := 100;
    RAT_COD_BENEFICIO_ANT    := 0;
    ANT_COD_BENEFICIO        := 0;
    vi_sem_condicao          := TRUE;
    APLICAR_PROP_BEN         := TRUE;
    APLICAR_PROP_SAIDA       := TRUE;
    APLICAR_RATEIO_BENEFICIO := FALSE;
    APLICAR_DEC_TERCEIRO     := FALSE;
    VI_DOENCA                := FALSE;
    VI_ORD_JUD               := FALSE;
    VI_PROP_SAIDA            := 1;
    VI_PROP_BEN              := 1;
    VI_PERC_PECUNIA          := 1;
    mon_calculo              := 0;
    vi_sal_base_total        := 0;
    COM_NUM_FUNCAO           := 0;
    V_DED_IR_PA              := 0;
    V_DED_IR_DOENCA          := 0;
    vi_val_base_13           := 0;
    HOUVE_RATEIO             := FALSE;
    VI_BASE_IR_13            := 0;
    V_VAL_IR_13              := 0;
    V_CALCULO_IR             := 'N';
    vi_val_rubrica_prev      := 0;
    COM_COL_INFORMACAO       := null;
    idx_elemento             := 0;
    if par_num_cpf is null then
      PAR_PERCENT_CORRECAO := 1;
    end if;

    COM_VAL_RUBRICA_CHEIO := 0;

    IF PAR_TIP_PRO <> 'R' THEN
      tdcn.delete;
      tdcn_pa.delete;
      tdcd.delete;
      v_sal_base.delete;
      v_base_prev.delete;
      v_base_teto.delete;
      -- v_val_ir.delete;
      vi_base_ir_arr.delete;
      vi_base_ir_arr_13.delete;
      VI_PERC_IR.delete;
      vfolha.delete;
      v_cod_beneficio.delete;
      vi_ir_ret.delete;
      cod_fcrubrica.delete;
      cod_beneficiario.delete;
      a_beneficio.delete;
      p := 0;
      cod_fcrubrica_redutor.delete;
      cod_beneficiario_redutor.delete;
      a_beneficio_redutor.delete;
      d := 0;
      v_cargo.delete; -- MVL1
    ELSE
      ret_tdcn.delete;
      ret_tdcn_ref.delete;
    END IF;

  END SP_INICIA_VAR;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_INICIALIZA_ARRAY AS
  BEGIN

    ------- Var Para Calculo 13 %
    T_Beneficiario.delete;
    -------
    tdcn.delete;
    tdcn_pa.delete;
    tdcd.delete;
    vfolha.delete;
    ret_tdcn.delete;
    ret_tdcn_ref.delete;
    ret_tval_npago.delete;
    v_sal_base.delete;
    v_base_prev.delete;
    v_base_teto.delete;
    VI_PERC_IR.delete;
    vi_base_ir_arr.delete;
    vi_base_ir_arr_13.delete;
    VI_PERC_IR.delete;
    v_cod_beneficio.delete;
    cod_fcrubrica.delete;
    cod_fcrubrica_seg.delete;
    cod_beneficiario.delete;
    a_beneficio.delete;
    v_cargo.delete; -- MVL1

    -------------
     rubricas_tipos.delete;
    --------------

    p := 0;
    D := 0;
    vi_ir_ret.delete;
    idx_caln                 := 0;
    idx_seq_detalhe          := 0;
    idx_cald                 := 0;
    idx_folha                := 0;
    idx_parcela              := 0;
    idx_ret                  := 0;
    idx_ret_ref              := 0;
    V_CONT_BENEF             := 0;
    APLICAR_DEC_TERCEIRO     := FALSE;
    vi_condicao              := FALSE;
    vi_sem_condicao          := TRUE;
    APLICAR_RATEIO_BENEFICIO := FALSE;
    HOUVE_RATEIO             := FALSE;
    V_DED_IR_PA              := 0;
    V_DED_IR_DOENCA          := 0;
    VI_DOENCA                := FALSE;
    VI_ORD_JUD               := FALSE;
    VI_BASE_IR_13            := 0;
    VI_VAL_BASE_13           := 0;
    V_BASE_ISENCAO           := 0;
    NOM_CATEGORIA            := NULL;
    NOM_SUBCATEGORIA         := NULL;
    NOM_TIPO_PROVIMENTO      := NULL;
    NOM_REGIME_JUR           := NULL;
    NOM_VINCULO              := NULL;
    NUM_DEP_IR_MIL           := 0;
    VI_IDADE                 := 0;
    V_CALCULO_IR             := 'N';
    vi_val_rubrica_prev      := 0;
    COM_COL_INFORMACAO       := null;
    idx_elemento             := 0;
    vi_cod_ref_pad_venc      := null;
    vrubexc.delete;

    --- JTS 29092010 JTS
     VI_PERCENTUAL_RATEIO    :=1;

    if par_num_cpf is null then
      PAR_PERCENT_CORRECAO := 1;
    end if;
     p_sub_proc_erro := null;
     p_coderro       := null;
     P_MSGERRO       := null;
  END SP_INICIALIZA_ARRAY;

 PROCEDURE SP_PROCESSA_RUBRICA(CALC_RUB OUT BOOLEAN) AS
    V_RUBRICA_FILHA NUMBER(8);
    V_RUBRICA_PAI   NUMBER(8);
    rdcn2           TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
    cont            NUMBER(3);
    I               NUMBER(3);

  BEGIN

    CALC_RUB := TRUE;

    for x in (SELECT /*+ RULE */
               COD_RUBRICA_A, COD_RUBRICA_B
                FROM TB_RUBRICAS_EXC
               WHERE COD_RUBRICA_B = COM_COD_FCRUBRICA
                 AND COD_ENTIDADE_B = COM_ENTIDADE) loop

      cont := tdcn.count;
      IF cont > 0 then
        FOR I IN 1 .. cont LOOP
          rdcn2 := tdcn(I);

          IF (rdcn2.COD_FCRUBRICA    = x.cod_RUBRICA_a) AND
             (rdcn2.COD_IDE_CLI      = ANT_IDE_CLI    ) AND
             (rdcn2.NUM_MATRICULA    = ANT_MATRICULA  ) AND
             (rdcn2.cod_ide_rel_func = ANT_COM_COD_IDE_REL_FUNC ) AND
             (rdcn2.cod_entidade     = ANT_ENTIDADE)
             THEN
            CALC_RUB := FALSE;
            exit;

          END IF;
        END LOOP;
      ELSE
        CALC_RUB := TRUE;
      END IF;
      --      END IF;
    end loop;

  END SP_PROCESSA_RUBRICA;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_EVOLU_REL_FUNCIONAL AS
  begin
    begin
    -- JTS24
      SELECT EF.COD_REFERENCIA,
             EF.COD_PCCS      ,
             EF.COD_JORNADA   ,
             EF.COD_QUADRO    ,

             EF.COD_REFERENCIA_2,
             EF.COD_REFERENCIA_3,
             EF.COD_JORNADA_2   ,
             EF.COD_JORNADA_3   ,
             EF.QTD_MES_2       ,
             EF.QTD_MES_3       ,
             EF.QTD_MES
        INTO BEN_COD_REFERENCIA,
             COM_PCCS,
             COM_COD_JORNADA,
             COM_QUADRO,

             COM_REFERENCIA_2,
             COM_REFERENCIA_3,
             COM_JORNADA_2   ,
             COM_JORNADA_3   ,
             COM_QTD_MES_2   ,
             COM_QTD_MES_3   ,
             COM_QTD_MES

        FROM TB_EVOLUCAO_FUNCIONAL  EF
       WHERE EF.COD_INS          = par_cod_ins
         AND EF.COD_IDE_CLI      = BEN_IDE_CLI
         AND EF.COD_ENTIDADE     = COM_ENTIDADE
         AND EF.NUM_MATRICULA    = COM_MATRICULA
         AND EF.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         AND (PAR_PER_PRO >=
             TO_DATE('01/' || TO_CHAR(EF.DAT_INI_EFEITO, 'MM/YYYY'),
                      'DD/MM/YYYY') -- FFRANCO - 06052009
             AND
             PAR_PER_PRO <=
             NVL(EF.DAT_FIM_EFEITO, TO_DATE('01/01/2045', 'DD/MM/YYYY')))
         AND EF.FLG_STATUS = 'V';

    exception
      WHEN NO_DATA_FOUND THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_FOLHA_CALCULADA - Evol. Func';
        p_msgerro       := 'N?o foi encontrada Evolucao_funcional -> 2319';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              0);
      WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_FOLHA_CALCULADA - Evol. Func';
        p_msgerro       := 'Erro ao obter Evolucao Funcional --> 2319';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              0);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_OBTEM_EVOLU_REL_FUNCIONAL;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_VALOR_RUBRICA AS

    valor13 number(18, 4) := 0;
    valor_temp number(18, 4) := 0;
  BEGIN

    mon_calculo := 0;

    --ROD8
    --  29092010
    -- IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
     -- VI_PERCENTUAL_RATEIO := 1;
    -- END IF;

    --Novo modelo de rubricas
    IF BEN_TIPO_PESSOA = 'T' THEN
      sp_ins_detcalculado(SP_OBTEM_VALOR_OJ); --valor igual ao desconto do instituidor
    ELSE

      SP_CARREGA_FORMULA;

      SP_VERIFICA_VAR_RUBRICA;

      IF vi_condicao or vi_sem_condicao THEN
        SP_OBTEM_VALOR_FORMULA;



        -- guarda valor cheio
        IF COM_IND_COMP_RUB = 'S' AND COM_TIP_BENEFICIO = 'PENSIONISTA' THEN
          --ROD10
          IF VI_PERCENTUAL_RATEIO = 0 OR VI_PERCENTUAL_RATEIO is null THEN
             SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                ANT_IDE_CLI,
                                valor_temp,
                                valor_temp,
                                VI_PERCENTUAL_RATEIO); -- salario base com rateio
          END IF;
          --ROD10

          BEGIN
            IF VI_PERCENTUAL_RATEIO >0 THEN
            COM_VAL_RUBRICA_CHEIO := mon_calculo / (VI_PERCENTUAL_RATEIO *
                                     VI_PERC_PECUNIA);

            ELSE
               COM_VAL_RUBRICA_CHEIO := 0;
            END IF;
          EXCEPTION
            when others then
              p_sub_proc_erro := 'SP_CALCULA_VALOR_RUBRICA';
              p_coderro       := SQLCODE;
              P_MSGERRO       := 'Erro ao calcular valor rubrica - provavel Percentual rateio zerado';
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                    p_coderro,
                                    'Calcula Folha',
                                    sysdate,
                                    p_msgerro,
                                    p_sub_proc_erro,
                                    ANT_IDE_CLI,
                                    COM_COD_FCRUBRICA);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              IF VI_PERCENTUAL_RATEIO =0 or VI_PERCENTUAL_RATEIO is null THEN
                 VI_PERCENTUAL_RATEIO := 0.01;
              END IF;
          END;

        ELSE
          --IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA),7,0),6,2) in ('01','02','03','04','05') then       ---- FFRANCO 18052009

          ----------------- INCLUIDO ROD 11.DEZ.09
          SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                  ANT_IDE_CLI,
                                  valor_temp,
                                  valor_temp,
                                  VI_PERCENTUAL_RATEIO);
          ---
          --ROD20
          IF COM_TIP_BENEFICIO = 'PENSIONISTA' THEN
            IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) in ('01','03','05','55','56') then
            COM_VAL_RUBRICA_CHEIO := mon_calculo * VI_PERC_PECUNIA;
            ELSE
            COM_VAL_RUBRICA_CHEIO := mon_calculo * VI_PERC_PECUNIA *  vi_prop_ben;
            END IF;
          ELSE
            IF COM_IND_COMP_RUB = 'S' OR COM_COD_FCRUBRICA=7000600  OR COM_COD_FCRUBRICA IN (200405) THEN ---25-07-2012 fagero contro 200405
              COM_IND_COMP_RUB := 'S' ;

               --- SOLUCIONA PROBLEMA DE FORMULA ESTA PROPROCIONALIZANDO POR FATOR MES
                 IF  APLICAR_ENTRADA AND COM_TIP_BENEFICIO = 'APOSENTADO' AND
                     /*  COM_COD_FCRUBRICA IN (300704,302304,500104)  AND*/
                       V_QTD_DIAS <V_DIAS_MES AND   V_QTD_DIAS >0
                     THEN
                            COM_VAL_RUBRICA_CHEIO := mon_calculo/ (V_QTD_DIAS / V_DIAS_MES);
                     ELSE
                             COM_VAL_RUBRICA_CHEIO := mon_calculo ; ---- FFRANCO 18052009
                  END IF;


            ELSE
              ----------------------
              IF (COM_COD_BENEFICIO >=40000000 AND  COM_COD_BENEFICIO <=41000000 )
                AND (SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) IN ('01')
                     OR COM_COD_FCRUBRICA IN (200403,200407,200405)
                    ) THEN
                    ---25-07-2012 fagero contro 200405

                COM_VAL_RUBRICA_CHEIO := mon_calculo  ;
              ELSE
              -----------------------
                COM_VAL_RUBRICA_CHEIO := mon_calculo * vi_prop_ben; ---- FFRANCO 18052009
             END IF;
            END IF;
          END IF;
          --ROD20


        END IF;

        -- guardar rubrica de pens?o

        IF COM_TIPO_EVENTO_ESPECIAL = 'P' THEN
          p := nvl(p, 0) + 1;
          cod_fcrubrica.extend;
          cod_fcrubrica_seg.extend;
          cod_beneficiario.extend;

          a_beneficio.extend;
          cod_fcrubrica(p)     := COM_COD_FCRUBRICA;
          cod_fcrubrica_seg(p) :=  COM_SEQ_VIG;
          cod_beneficiario(p)  := COM_COD_IDE_CLI_BEN;
          a_beneficio(p)       := COM_COD_BENEFICIO;
          -- Agregada 26-01-2011
          rubricas_tipos.extend;
          rubricas_tipos(p)  :=COM_RUBRICA_TIPO;
        END IF;

        -- guardar rubrica de redutor
        IF (COM_TIPO_EVENTO_ESPECIAL = 'D' AND COM_TIP_BENEFICIO <> 'APOSENTADO')
           OR (COM_TIPO_EVENTO_ESPECIAL = 'G' AND COM_TIP_BENEFICIO = 'APOSENTADO') THEN
          d := nvl(d, 0) + 1;
          cod_fcrubrica_redutor.extend;
          cod_beneficiario_redutor.extend;
          a_beneficio_redutor.extend;
          cod_fcrubrica_redutor(d) := COM_COD_FCRUBRICA;
          cod_beneficiario_redutor(d) := ANT_IDE_CLI;
          a_beneficio_redutor(d) := COM_COD_BENEFICIO;
        END IF;
        --ROD20 incluido abaixo -- Modificados parentesis de agrupac?o JTS
        IF     (COM_TIP_BENEFICIO = 'APOSENTADO' AND COM_TIPO_EVENTO_ESPECIAL = 'D')
           OR (COM_TIP_BENEFICIO <> 'APOSENTADO' AND COM_TIPO_EVENTO_ESPECIAL = 'G') THEN
           COM_FLG_PROCESSA := 'N';
        END IF;

        IF (COM_NAT_RUB = 'C' AND COM_FLG_PROCESSA = 'S') THEN

          IF PAR_TIP_PRO = 'T' AND COM_TIP_BENEFICIO = 'PENSIONISTA' AND
             HOUVE_RATEIO = TRUE AND COM_COD_FCRUBRICA = 15000 THEN
            HOUVE_RATEIO := FALSE;
            valor13      := SP_OBTEM_ADIANTAMENTO_13;
            HOUVE_RATEIO := TRUE;
          END IF;

          IF APLICAR_RATEIO_BENEFICIO = TRUE THEN
            -- Calculo do valor da rubrica com Rateio e mudanca no percentual
            -- do rateio no mesmo mes do periodo
            -- o Fator traz somado a proporc?o do mes
            -- IF  SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA),7,0),6,2) in ('01','02','03','04','05') then
            IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) in
               ('01','03', '05','55','56') then
              -- ROD4 removido '02'-04 (09/06/09)-22-09-2010
              mon_calculo := (mon_calculo * VI_PROP_SAIDA * VI_PERC_PECUNIA);
            ELSE
              mon_calculo := (mon_calculo * VI_PROP_BEN * VI_PROP_SAIDA *
                             VI_PERC_PECUNIA);
            END IF;
            IF VI_PROP_BEN = 1 and VI_PROP_SAIDA = 1 THEN
              HOUVE_RATEIO := FALSE;
            ELSE
              HOUVE_RATEIO := TRUE; --efv pensao 20060918
            END IF;

            IF APLICAR_ENTRADA THEN
              mon_calculo := mon_calculo;
            ELSE
              IF HOUVE_RATEIO = FALSE AND VI_TEM_SAIDA = FALSE AND
                 PAR_TIP_PRO = 'T' THEN
                HOUVE_RATEIO := TRUE;
                SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                    ANT_IDE_CLI,
                                    mon_calculo,
                                    mon_calculo,
                                    VI_PERCENTUAL_RATEIO); -- salario base com rateio
              ELSE
                IF (APLICAR_DEC_TERCEIRO = TRUE OR APLICAR_RATEIO_BENEFICIO) AND
                   PAR_TIP_PRO = 'T' AND HOUVE_RATEIO = FALSE THEN
                  SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                      ANT_IDE_CLI,
                                      mon_calculo,
                                      mon_calculo,
                                      VI_PERCENTUAL_RATEIO); -- salario base com rateio
                ELSIF (APLICAR_DEC_TERCEIRO = TRUE OR
                      APLICAR_RATEIO_BENEFICIO) AND
                      COM_TIP_BENEFICIO = 'PENSIONISTA' AND
                      HOUVE_RATEIO = FALSE THEN
                  SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                      ANT_IDE_CLI,
                                      mon_calculo,
                                      mon_calculo,
                                      VI_PERCENTUAL_RATEIO); -- salario base com rateio
                END IF;
              END IF;
            END IF;
          ELSIF APLICAR_DEC_TERCEIRO AND COM_TIP_BENEFICIO = 'APOSENTADO' AND
                APLICAR_ENTRADA = FALSE AND COM_IND_COMP_RUB = 'N' AND
                COM_TIPO_EVENTO_ESPECIAL <> 'S' THEN
            -- aplicar proporcao somente para o salario base
            --IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA),7,0),6,2) not in ('01','02','03','04','05') THEN
            IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in
               ('01','03', '05','55','56') THEN
              --ROD4
              mon_calculo := (mon_calculo * VI_PROP_BEN * NVL(VI_PROP_SAIDA,1) *
                             VI_PERC_PECUNIA);
            else
               --- NVL agregado  9-9-2013
              mon_calculo := (mon_calculo * nvl(VI_PROP_SAIDA,1) * VI_PERC_PECUNIA);
            END IF;
          ELSIF APLICAR_ENTRADA AND COM_TIP_BENEFICIO = 'APOSENTADO' AND
                COM_IND_COMP_RUB = 'N' AND COM_TIPO_EVENTO_ESPECIAL <> 'S' THEN
                IF V_QTD_DIAS > V_DIAS_MES THEN
                   V_QTD_DIAS := V_DIAS_MES;
                END IF;
                 -- Cod Novo
                             -- Codigo Gerado por JTS 24-05-2010 agregamos criterio de por% 22-09
                  IF     SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in  ('50' ,'51')
                    and  SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in
                     ('01','03', '05','55','56')
                   THEN
                          mon_calculo := ((mon_calculo * (V_QTD_DIAS / V_DIAS_MES)) *
                           ROUND(COM_PERCENT_BEN / 100,4));
                   ELSE
                     mon_calculo := ((mon_calculo * (V_QTD_DIAS / V_DIAS_MES)));
                  END IF;

         ELSIF APLICAR_ENTRADA = FALSE AND
                COM_TIP_BENEFICIO = 'APOSENTADO' AND COM_IND_COMP_RUB = 'N' AND
                COM_NAT_VAL <> 'L' AND COM_TIPO_EVENTO_ESPECIAL <> 'S' AND
                COM_TIPO_EVENTO_ESPECIAL <> 'F' THEN
            -- Aplicar somente o percentual proporcional para os pensionistas
              --Cod Novo
                 ----- ajuste 30092010
                 IF NOT (COM_COD_BENEFICIO >=80000000 AND  COM_COD_BENEFICIO <=81000000 ) THEN
                      -- Codigo Gerado por JTS 24-05-2010 agregamos criterio de por% 22-09
                       IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in  ('50' ,'51','55','56')
                       THEN
                          IF (COM_COD_BENEFICIO >=40000000 AND  COM_COD_BENEFICIO <=41000000 )
                               AND (SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) IN ('01')
                               OR COM_COD_FCRUBRICA IN (200403,200407,200405)
                            ) THEN
                                ---25-07-2012 fagero contro 200405
                            mon_calculo := mon_calculo * VI_PROP_COMPOSICAO;
                          ELSE
                            mon_calculo := mon_calculo * ROUND(COM_PERCENT_BEN / 100,4) *
                                           VI_PROP_COMPOSICAO;
                          END IF;
                       ELSE
                                     mon_calculo := mon_calculo * VI_PROP_COMPOSICAO;
                      END IF;
                  ELSE
                      IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in  ('50' ,'51')
                         and  SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in
                         ('01','03', '05','55','56') THEN
                            mon_calculo := mon_calculo * ROUND(COM_PERCENT_BEN / 100,4) *
                                           VI_PROP_COMPOSICAO;
                       ELSE
                                     mon_calculo := mon_calculo * VI_PROP_COMPOSICAO;
                      END IF;

                 END IF;

          ELSIF COM_NAT_VAL = 'L' AND COM_IND_COMP_RUB = 'S' AND
                COM_NAT_RUB = 'C' AND COM_TIPO_EVENTO_ESPECIAL <> 'S' AND
                (PAR_TIP_PRO = 'T' or APLICAR_DEC_TERCEIRO) THEN
            IF APLICAR_RATEIO_BENEFICIO THEN
              SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                  ANT_IDE_CLI,
                                  mon_calculo,
                                  mon_calculo,
                                  VI_PERCENTUAL_RATEIO); -- salario base com rateio
            END IF;
            IF APLICAR_DEC_TERCEIRO AND PAR_TIP_PRO = 'T' THEN
              -- VI_FATOR_DIAS + VI_PROP_SAIDA +
              mon_calculo := ((mon_calculo * (QTD_MESES_13)) * VI_PROP_BEN *
                             VI_PERC_PECUNIA) / 12;
            ELSIF PAR_TIP_PRO <> 'T' THEN
              --IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA),7,0),6,2) not  in ('01','02','03','04','05') THEN
              IF SUBSTR(LPAD(TO_CHAR(COM_COD_FCRUBRICA), 7, 0), 6, 2) not in
                 ('01','03','04','05','55','56') THEN
                mon_calculo := (mon_calculo * VI_PROP_BEN * VI_PERC_PECUNIA *
                               VI_PROP_SAIDA * V_FATOR_13_SAIDA);
              ELSE
                mon_calculo := (mon_calculo * VI_PROP_SAIDA *
                               V_FATOR_13_SAIDA * VI_PERC_PECUNIA);
              END IF;
            END IF;
          ELSIF COM_TIPO_EVENTO_ESPECIAL = 'T' AND PAR_TIP_PRO = 'N' THEN
            mon_calculo := 0;
          ELSIF PAR_TIP_PRO = 'R' AND to_char(PAR_PER_PRO, 'MM') = '02' AND
                COM_COD_FCRUBRICA = 13800 THEN
            mon_calculo           := mon_calculo * VI_FATOR_DIAS_RET;
            IF VI_PERCENTUAL_RATEIO = 0 OR VI_PERCENTUAL_RATEIO IS NULL THEN --ROD incluido 27.out.09
              SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                  ANT_IDE_CLI,
                                  valor_temp,
                                  valor_temp,
                                  VI_PERCENTUAL_RATEIO);
            END IF;                                                          --fim

            COM_VAL_RUBRICA_CHEIO := mon_calculo / VI_PERCENTUAL_RATEIO;
          ELSIF VI_PROP_COMPOSICAO <> 1 THEN
            mon_calculo           := mon_calculo * VI_PROP_COMPOSICAO;
            IF VI_PERCENTUAL_RATEIO = 0 OR VI_PERCENTUAL_RATEIO IS NULL THEN --ROD incluido 27.out.09
              SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                  ANT_IDE_CLI,
                                  valor_temp,
                                  valor_temp,
                                  VI_PERCENTUAL_RATEIO);
            END IF;                                                          --fim
            COM_VAL_RUBRICA_CHEIO := mon_calculo / VI_PERCENTUAL_RATEIO;
          ELSIF COM_IND_COMP_RUB = 'N'  THEN
            IF VI_PERCENTUAL_RATEIO = 0 OR VI_PERCENTUAL_RATEIO IS NULL THEN --ROD incluido 27.out.09
              SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                  ANT_IDE_CLI,
                                  valor_temp,
                                  valor_temp,
                                  VI_PERCENTUAL_RATEIO);
            END IF;                                                          --fim
            COM_VAL_RUBRICA_CHEIO := mon_calculo / VI_PERCENTUAL_RATEIO;
          END IF;

  /*      ELSIF APLICAR_DEC_TERCEIRO THEN


          null; */
        ELSIF COM_NAT_RUB = 'D' AND COM_FLG_PROCESSA = 'S' AND
              COM_IND_QTAS = 'S' AND COM_NAT_VAL = 'C' AND
              (COM_NAT_COMP = 'I' OR COM_NAT_COMP = 'C') THEN
          -- Acumula Desconto para verificar percentual Pagamento
          IF PAR_TIP_PRO <> 'R' THEN
            SP_INS_ARRAY_DESCONTO(mon_calculo);
            mon_calculo := 0;
          END IF;
        ELSIF COM_NAT_RUB = 'D' AND COM_FLG_PROCESSA = 'S' THEN
          IF APLICAR_RATEIO_BENEFICIO THEN
            SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO,
                                BEN_IDE_CLI,
                                mon_calculo,
                                mon_calculo,
                                VI_PERCENTUAL_RATEIO); -- salario base com rateio
          END IF;
        ELSIF COM_FLG_PROCESSA = 'N' THEN
          mon_calculo := 0;
        END IF;
      ELSE
        mon_calculo := 0;
        IF COM_NAT_COMP <> 'G' THEN
          p_sub_proc_erro := 'SP_CALCULA_VALOR_RUBRICA';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Aviso - Rubrica n?o calculada por n?o se enquadrar nas condicoes';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

        END IF;
      END IF;
    END IF;

  END;

  ---------------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_VAR_RUBRICA AS

  BEGIN
    IF COM_COL_INFORMACAO is not null THEN

      FOR i IN 1 .. nom_variavel.count LOOP
        IF COM_COL_INFORMACAO = 'VAL_PERC_BENEFICIO' OR
           COM_COL_INFORMACAO = 'PERC_SAL_MIN_PENSAO' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
            IF COM_VAL_PORC_IND IS NULL AND IDX_ELEMENTO > 0 THEN
              begin
                select case
                         when to_number(translate(vas_elemento(idx_elemento),
                                                  '.',
                                                  ','),
                                        '9999999D9999') > 1 then
                          to_number(translate(vas_elemento(idx_elemento),
                                              '.',
                                              ','),
                                    '9999999D9999')
                         else
                          to_number(translate(vas_elemento(idx_elemento),
                                              '.',
                                              ','),
                                    '9999999D9999') * 100
                       end
                  into val_variavel(i)
                  from dual;
              exception
                when others then
                  p_sub_proc_erro := 'SP_VERIFICA_VAR_RUBRICA';
                  p_coderro       := SQLCODE;
                  P_MSGERRO       := 'Erro ao obter as variaveis de percentuais as rubricas';
                  INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                        p_coderro,
                                        'Calcula Folha',
                                        sysdate,
                                        p_msgerro,
                                        p_sub_proc_erro,
                                        BEN_IDE_CLI,
                                        COM_COD_FCRUBRICA);
                  VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

              end;
              IF val_variavel(i) < 1 THEN
                val_variavel(i) := val_variavel(i) * 100;
              END IF;
              --                 val_variavel(i) := to_number(vas_elemento(idx_elemento),NLS_NUMERIC_CHARACTERS = ".,") * 100;
              v_val_percentual := val_variavel(i);
            ELSE
              val_variavel(i) := nvl(COM_VAL_PORC_IND, 0);
              v_val_percentual := nvl(COM_VAL_PORC_IND, 0);
              exit;
            END IF;
            if idx_elemento = 3 then
              exit;
            end if;
          END IF;
        ELSIF COM_COL_INFORMACAO = 'QTD_BENEFICIO' OR
              COM_COL_INFORMACAO = 'QTD_SAL_MIN_PENSAO' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
            val_variavel(i) := nvl(COM_QTY_UNID_IND, 0);
            v_qtd_horas := nvl(COM_QTY_UNID_IND, 0);
          END IF;
        ELSIF COM_COL_INFORMACAO = 'PERC_VAL_PENSAO' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
            val_variavel(i) := nvl(COM_VAL_PORC_IND, 0);
            v_val_percentual := nvl(COM_VAL_PORC_IND, 0);
          END IF;
        ELSIF COM_COL_INFORMACAO = 'VAL_PERC_FIXO' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
             val_variavel(i) := COM_VAL_PORC_IND;
          END IF;
        ELSIF COM_COL_INFORMACAO = 'QTD_COTAS' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
            val_variavel(i) := nvl(COM_VAL_PORC_IND, 0);
          END IF;
        ELSIF COM_COL_INFORMACAO = 'PERC_RATEIO_PECUNIA' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
            val_variavel(i) := nvl(VI_PERC_PECUNIA, 0);
          END IF;
        ELSIF COM_COL_INFORMACAO = 'ANOS_ATS' THEN
          IF nom_variavel(i) = COM_COL_INFORMACAO THEN
            val_variavel(i) := NVL(FC_ANOS_ATS (
                                      PAR_COD_INS,
                                      COM_COD_IDE_CLI,
                                      COM_NUM_MATRICULA,
                                      COM_COD_IDE_REL_FUNC,
                                      COM_ENTIDADE,
                                      LAST_DAY(PAR_PER_PRO)
                                      ),0)/*||'%'*/;
          END IF;

        END IF;

      END LOOP;
    END IF;

  END SP_VERIFICA_VAR_RUBRICA;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_BENEFICIO_ARRAY AS

  BEGIN

    vfolha.extend;
    idx_folha := nvl(idx_folha, 0) + 1;

    rfol.COD_INS          := PAR_COD_INS;
    rfol.TIP_PROCESSO     := PAR_TIP_PRO;
    rfol.PER_PROCESSO     := PAR_PER_PRO;
    rfol.SEQ_PAGAMENTO    := vi_seq_pagamento;
    rfol.COD_IDE_CLI      := ANT_COM_COD_IDE_CLI;
    rfol.cod_entidade     := ANT_ENTIDADE ;
    rfol.num_matricula    := ANT_MATRICULA;
    rfol.cod_ide_rel_func := ANT_COM_COD_IDE_REL_FUNC;




    rfol.NUM_GRP       := ANT_NUM_GRUPO_PAG ; --eliminar del modelo
    rfol.COD_ENTIDADE  := ANT_ENTIDADE ; --eliminar del modelo




    SP_OBTEM_DADOS_PF( ANT_COM_COD_IDE_CLI, 'S', rfol.num_cpf, rfol.nome);
    rfol.dat_processo := PAR_PER_PRO;

    rfol.ded_ir_oj          := 0; --V_DED_IR_OJ;
    rfol.ded_ir_doenca      := V_DED_IR_DOENCA;
    rfol.ded_ir_pa          := V_DED_IR_PA;
    rfol.flg_pag            := 'S';
    rfol.flg_ind_pago       := 'N';
    rfol.flg_ind_ultimo_pag := 'N';

    --#DECTER2016 TONY CARAVANA 2016-12-15
    BEGIN
       --- rfol.val_sal_base := V_SAL_BASE(ANT_COD_BENEFICIO) (1);   --#TONY2016 TONY CARAVANA2016-08-24 / 24-08-2016
       rfol.val_sal_base := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia);
    EXCEPTION
        WHEN OTHERS THEN
           rfol.val_sal_base := 0;
    END;



    rfol.tot_cred_pag       := 0;
    rfol.tot_deb_pag        := 0;
    rfol.val_liquido_pag    := 0;

    rfol.dat_ingresso       :=sysdate;
    rfol.flg_pag            :=ANT_FLG_STATUS;
    rfol.cod_dissociacao    :=ANT_BEN_DISSOCIACAO;
    rfol.ind_processo := 'S';

    vfolha(idx_folha) := rfol;

      --- Carrega Dados do Beneficiario para 13
    R_Beneficiario.cod_beneficio  :=ANT_COD_BENEFICIO;
    R_Beneficiario.cod_ide_cli_ben:=ANT_IDE_CLI;
    R_Beneficiario.DAT_INI_BEN    := ANT_DAT_INI_BEN;--   := BEN_DAT_INICIO;BEN_DAT_INICIO;
    T_Beneficiario.extend;
    T_Beneficiario(idx_folha):=R_Beneficiario;


  END SP_INCLUI_BENEFICIO_ARRAY;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_FORMULA AS

    vi_num_formula  number;
    c_elem          curform;
    c_cond          curform;
    c_dcond         curform;
    vi_cod_elemento varchar2(30);
    vi_tip_elemento varchar2(10);
    vi_num_funcao   number;
    vi_variavel     varchar2(30);
    i               number;

    XX             VARCHAR(5);
  BEGIN

    i               := 0;
    vi_sem_condicao := TRUE;
    cod_elemento.delete;
    tip_elemento.delete;
    val_elemento.delete;
    vas_elemento.delete;
    num_funcao.delete;
   ----------------- Memoria de Calculo -------------- 2024-02  
   --- colocando valor  nulo as variaveis para calcular 
   
     mc_cod_formula_cond    := null; 
     mc_cod_formula_rubrica := null;  
     mc_des_condicao        := null;
     mc_des_formula         := null;


    -- obtem formula
    -- Valida condicao
    OPEN c_cond for
      SELECT distinct CF.COD_FORMULA
        FROM TB_CONDICAO_FORMULA CF
       WHERE CF.COD_INS = PAR_COD_INS
         AND CF.COD_FCRUBRICA = COM_COD_FCRUBRICA
         AND CF.COD_ENTIDADE  = COM_ENTIDADE
         AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
             to_char(CF.DAT_INI_VIG, 'YYYYMM') and
             to_char(PAR_PER_PRO, 'YYYYMM') <=
             to_char(nvl(CF.DAT_FIM_VIG,
                          to_date('01/01/2045', 'dd/mm/yyyy')),
                      'YYYYMM'));

    FETCH c_cond
      INTO VI_NUM_FORMULA;

    lim_funcao := 0;

    IF C_COND%FOUND THEN
      vi_sem_condicao := FALSE;
      WHILE C_COND%FOUND LOOP
        OPEN c_dcond FOR
          SELECT DC.COD_ELEMENTO,
                 DC.TIP_ELEMENTO,
                 fv.num_funcao,
                 fv.cod_variavel
            FROM TB_DCONDICAO_FORMULA DC, TB_VARIAVEIS FV
           WHERE DC.COD_INS = PAR_COD_INS
             AND DC.COD_FCRUBRICA = COM_COD_FCRUBRICA
             AND DC.COD_FORMULA = vi_num_formula
             AND DC.COD_ENTIDADE = COM_ENTIDADE
             AND FV.COD_VARIAVEL(+) = DC.COD_ELEMENTO
             AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
                 to_char(DC.DAT_INI_VIG, 'YYYYMM') and
                 to_char(PAR_PER_PRO, 'YYYYMM') <=
                 to_char(nvl(DC.DAT_FIM_VIG,
                              to_date('01/01/2045', 'dd/mm/yyyy')),
                          'YYYYMM'))
           ORDER BY DC.NUM_CONDICAO, DC.NUM_SEQ_COND;

        FETCH C_DCOND
          INTO VI_COD_ELEMENTO, VI_TIP_ELEMENTO, VI_NUM_FUNCAO, VI_VARIAVEL;
        WHILE C_DCOND%FOUND LOOP
          i := i + 1;
          cod_elemento.extend(1);
          tip_elemento.extend(1);
          val_elemento.extend(1);
          vas_elemento.extend(1);
          num_funcao.extend(1);
          cod_elemento(i) := vi_cod_elemento;
          tip_elemento(i) := vi_tip_elemento;

          IF vi_tip_elemento = 'VAR' THEN
            vas_elemento(i) := sp_obtem_valor_var(vi_num_funcao,
                                                  vi_variavel,
                                                  1);
          ELSIF vi_tip_elemento = 'VAL' THEN
            vas_elemento(i) := vi_cod_elemento;
          ELSIF vi_tip_elemento = 'STR' THEN
            vas_elemento(i) := vi_cod_elemento;
          ELSE
            val_elemento(i) := 0;
            vas_elemento(i) := NULL;
          END IF;
          FETCH C_DCOND
            INTO VI_COD_ELEMENTO, VI_TIP_ELEMENTO, VI_NUM_FUNCAO, VI_VARIAVEL;
        END LOOP;
        CLOSE C_DCOND;
        lim_funcao  := i;
        
        ----------------- Memoria de Calculo -------------
        mc_cod_formula_cond:= vi_num_formula; 
        
        vi_condicao := SP_VALIDA_CONDICAO;
        IF vi_condicao THEN
          EXIT;
        ELSE
          --- Limpa Variaveis -- Memoria de Calculo --
           mc_cod_formula_cond    := null;
           mc_des_condicao        := null;         
        END IF;
        
        FETCH C_COND
          INTO VI_NUM_FORMULA;
        i := 0;
        --      vi_sem_condicao:=FALSE;
        cod_elemento.delete;
        tip_elemento.delete;
        val_elemento.delete;
        vas_elemento.delete;
        num_funcao.delete;
      END LOOP;
      CLOSE C_COND;
    ELSE
      BEGIN
        -- Formula
        SELECT FF.COD_FORMULA
          INTO vi_num_formula
          FROM TB_FORMULA FF
         WHERE FF.COD_INS = PAR_COD_INS
           AND FF.COD_FCRUBRICA = COM_COD_FCRUBRICA
           AND FF.SEQ_VIG_FC = COM_SEQ_VIG_FC
           AND FF.COD_ENTIDADE = COM_ENTIDADE
           AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
               to_char(FF.DAT_INI_VIG, 'YYYYMM') and
               to_char(PAR_PER_PRO, 'YYYYMM') <=
               to_char(nvl(FF.DAT_FIM_VIG,
                            to_date('01/01/2045', 'dd/mm/yyyy')),
                        'YYYYMM'));

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          vi_num_formula := 0;
        WHEN OTHERS THEN
          p_sub_proc_erro := 'SP_CARREGA_FORMULA';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter o numero da Formula';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);

          --       RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
      END;

    END IF;
    cod_elemento.delete;
    tip_elemento.delete;
    val_elemento.delete;
    vas_elemento.delete;
    num_funcao.delete;
    idx_elemento := 0;
    IF vi_condicao or vi_sem_condicao THEN
      -- obtem elementos
      OPEN c_elem FOR
        SELECT FE.COD_ELEMENTO,
               FE.TIP_ELEMENTO,
               FV.NUM_FUNCAO,
               FV.COD_VARIAVEL
          FROM TB_ELEMENTOS FE, TB_VARIAVEIS FV
         WHERE FE.COD_INS = PAR_COD_INS
           AND FE.COD_FCRUBRICA = COM_COD_FCRUBRICA
           AND FE.COD_FORMULA = vi_num_formula
           AND FE.COD_ENTIDADE = COM_ENTIDADE
           AND FV.COD_VARIAVEL(+) = FE.COD_ELEMENTO
           AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
               to_char(FE.DAT_INI_VIG, 'YYYYMM') and
               to_char(PAR_PER_PRO, 'YYYYMM') <=
               to_char(nvl(FE.DAT_FIM_VIG,
                            to_date('01/01/2045', 'dd/mm/yyyy')),
                        'YYYYMM'))
         ORDER BY FE.NUM_SEQ_EXEC;

      IF C_ELEM%ISOPEN THEN
        FETCH C_ELEM
          INTO VI_COD_ELEMENTO, VI_TIP_ELEMENTO, VI_NUM_FUNCAO, VI_VARIAVEL;
      END IF;
      i := 0;
      WHILE C_ELEM%FOUND LOOP
        i := i + 1;
        cod_elemento.EXTEND(1);
        tip_elemento.extend(1);
        val_elemento.extend(1);
        vas_elemento.extend(1);
        num_funcao.extend(1);

        cod_elemento(i) := vi_cod_elemento;
        tip_elemento(i) := vi_tip_elemento;

        IF vi_tip_elemento = 'VAR' THEN
          vas_elemento(i) := sp_obtem_valor_var(vi_num_funcao,
                                                vi_variavel,
                                                2);
        ELSIF vi_tip_elemento = 'VAL' THEN
          vas_elemento(i) := vi_cod_elemento;
          IF vi_cod_elemento < '100' THEN
            idx_elemento := i;
          END IF;
        ELSE
          vas_elemento(i) := NULL;
        END IF;
        FETCH C_ELEM
          INTO VI_COD_ELEMENTO, VI_TIP_ELEMENTO, VI_NUM_FUNCAO, VI_VARIAVEL;
      END LOOP;
      lim_funcao := i;
      CLOSE c_elem;
      ----------------- Memoria de Calculo ------------
      mc_cod_formula_rubrica := vi_num_formula;
      
    END IF;
  END SP_CARREGA_FORMULA;

  --------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_VALOR_VAR(i_num_funcao   in number,
                              i_cod_variavel in varchar2,
                              i_ordem        in number) return varchar2 IS
    o_valor          number(18, 5) := 0;
    o_str            varchar2(30) := null;
    vi_valor         number(18, 5);
    o_valor_13       number(18, 4) := 0;
    cont_ben         number := 0;
    cod_ref          number(8) := 0;
    v_val_base_liqui number(18, 4) := 0;
    o_data           date := null;
    o_padrao         varchar2(15) := null;
    v_referencia     number := 0;

  BEGIN

    o_str    := null;
    vi_valor := 0;
    Global_num_funcao             :=i_num_funcao;
  BEGIN
    IF i_num_funcao = 3 THEN
      -- Descricao Categoria
      IF NOM_CATEGORIA is null then
        SP_OBTEM_CATEGORIA(O_STR);
      END IF;
      o_str := '''' || NOM_CATEGORIA || '''';
    ELSIF i_num_funcao = 4 THEN
      -- Descricao Sub Categoria
      IF NOM_SUBCATEGORIA is null then
        SP_OBTEM_SUBCATEGORIA(O_STR);
      END IF;
      o_str := '''' || NOM_SUBCATEGORIA || '''';
    ELSIF i_num_funcao = 5 THEN
      -- Proporcionalidade Jornada
      SP_OBTEM_PROPORCAO_JORNADA(i_num_funcao, o_valor);
    ELSIF i_num_funcao = 6 THEN
      --SALARIO DO CARGO
      o_valor := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia);
      --           o_valor := round(o_valor * PAR_PERCENT_CORRECAO,2);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_FUNCAO in ( 1, 2,1002,1003) THEN
      -- Descricao, Opcao cargo, Regime juridico, Tipo Vinculo
         SP_OBTEM_RELACAO_FUNCIONAL(i_num_funcao, o_str, o_valor);

    ELSIF i_num_FUNCAO in (7, 12) THEN
      SP_OBTEM_VENC_CCOMI_GRATIF(i_num_funcao, o_valor);
      --           o_valor := round(o_valor * PAR_PERCENT_CORRECAO,2);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_FUNCAO = 09 THEN
      -- Percentual Representacao por Graduacao
      SP_CALCULA_PORC_GRADUACAO(o_valor);

    ELSIF i_num_funcao in (10,10007) THEN

      --COMPOSICAO DE RUBRICAS
      sp_composicao(COM_COD_FCRUBRICA,
                    i_cod_variavel,
                    COM_NUM_MATRICULA   ,
                    COM_COD_IDE_REL_FUNC,
                    COM_ENTIDADE,
                    'N',
                    o_valor);

    ELSIF I_NUM_FUNCAO = 10009 THEN
          O_VALOR := SP_OBTEM_QTD_DIAS_AFAST;

    ELSIF i_num_funcao in (11,516) THEN
      -- Valor Referencia Representac?o
        O_VALOR:=0;
     -- o_valor := SP_OBTEM_SALARIO_REFER_REP;
    ELSIF i_num_funcao = 13 THEN
      --COMPLEMENTO SALARIO MINIMO
      /*           IF COM_TIPO_APLICACAO = 'I' THEN
                    HOUVE_RATEIO := FALSE;
                    o_valor:=V_VAL_SAL_MIN;
                 ELSIF  APLICAR_ENTRADA OR
                        VI_TEM_SAIDA and
                        i_ordem = 2 THEN
                        IF  COM_TIP_BENEFICIO = 'APOSENTADO' THEN
                            o_valor:=V_VAL_SAL_MIN * (V_QTD_DIAS / V_DIAS_MES)*VI_PROP_BEN;
                        else
                            o_valor:=V_VAL_SAL_MIN * (V_QTD_DIAS / V_DIAS_MES)*VI_PROP_BEN*VI_PROP_SAIDA;
                        end if;
                 ELSIF  APLICAR_RATEIO_BENEFICIO = TRUE THEN
                       o_valor := V_VAL_SAL_MIN * VI_PROP_BEN;
                       o_valor:=(o_valor*VI_PROP_BEN*VI_PROP_SAIDA);
      --                 SP_RATEIO_BENEFICIO(COM_COD_BENEFICIO, BEN_IDE_CLI, o_valor, o_valor, VI_PERCENTUAL_RATEIO); -- salario base com rateio
                       IF i_ordem = 2 THEN
                          APLICAR_RATEIO_BENEFICIO := FALSE;
                       END IF;
                  ELSE */
      o_valor := V_VAL_SAL_MIN;
      --           END IF;
    ELSIF i_num_FUNCAO = 14 THEN
      -- Percentual de Graduac?o
      SP_OBTEM_PERCENTUAL_CARGO(o_valor);
      --- JTS --ISENTA DE ADIANTAMENTO
    ELSIF i_num_FUNCAO in (15, 29, 33, 34, 35, 36, 37, 70, 78, 414) THEN
      -- Tipos Atributos
      SP_OBTEM_TIPOS_ATRIBUTOS(i_num_funcao,
                               replace(com_matricula, '-', ''),
                               com_entidade,
                               com_cargo,
                               o_str); --FFranco 21/11/2006
      if i_num_funcao = 37 then
        if o_str = 'S' then
          SP_OBTEM_PARVAL_FOLHA2('TASCO', 2000, 'DESC_CONTR', o_valor);
          if o_valor is null then
            o_valor := 0;
          end if;
        else
          o_valor := 0;
        end if;
      end if;
      o_str := '''' || o_str || '''';
    ELSIF i_num_FUNCAO = 16 THEN
      -- Tipos Vencimento
      SP_OBTEM_IND_DJ(o_str);
      o_str := '''' || o_str || '''';
    ELSIF i_num_FUNCAO = 17 THEN
      -- Qtd. Horas
      SP_OBTEM_QTD_HORAS(i_num_funcao, O_VALOR);
    ELSIF i_num_FUNCAO = 18 THEN
      -- Parametro UPF
      SP_OBTEM_PARVAL_FOLHA2('UPF', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 19 THEN
      -- Tipo aposentadoria
      IF COM_PERCENT_BEN = 100 THEN
        o_str := 'INTEGRAL';
      ELSE
        o_str := 'PROPORCIONAL';
      END IF;
      o_str := '''' || o_str || '''';
    ELSIF i_num_FUNCAO = 20 THEN
      SP_OBTEM_PARVAL_FOLHA2('REFER', 1000, i_cod_variavel, o_valor);
      cod_ref := o_valor;
      SP_OBTEM_VENCIMENTO(COD_REF, O_VALOR);
    ELSIF i_num_FUNCAO = 21 THEN
      --Composic?o Percentual
      o_valor := COM_VAL_PORC_IND;
    ELSIF i_num_FUNCAO = 22 THEN
      --Composic?o Beneficio
      o_valor := COM_VAL_PORC2;
    ELSIF i_num_FUNCAO = 23 THEN
      SP_OBTEM_RELGRUPO(o_valor);
    ELSIF i_num_FUNCAO = 24 THEN
      -- Limite Redu. Const
      SP_OBTEM_PARVAL_FOLHA2('REDUT', 2000, i_cod_variavel, o_valor);
      VI_REDUC := o_valor;
    ELSIF i_num_FUNCAO = 25 THEN
      -- Obtem Tab Vencimento
      SP_OBTEM_ORIG_TAB_VENC(o_str);
      o_str := '''' || o_str || '''';
    ELSIF i_num_FUNCAO = 26 THEN
      -- Salario Familia
      SP_OBTEM_PARVAL_FOLHA2('SALFAMIL', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 27 THEN
      -- Composicao Individual
      SP_OBTEM_PARVAL_FOLHA2('CONSIG', 1000, i_cod_variavel, o_valor);
      FOR i IN 1 .. nom_variavel.count LOOP

        IF nom_variavel(i) = COM_COL_INFORMACAO THEN
          val_variavel(i) := o_valor;
          v_val_percentual := o_valor;
          exit;
        END IF;

      END LOOP;
    ELSIF i_num_FUNCAO = 28 THEN
      -- Valor Individual das composicoes
      o_valor := COM_VAL_UNID;
    ELSIF i_num_funcao = 31 THEN
      --Composicao Individual - Valor Fixo
      o_valor := COM_VAL_FIXO_IND;
      IF COM_NAT_COMP <> 'C' THEN
        APLICAR_PROP_SAIDA := TRUE;
      ELSE
        APLICAR_PROP_SAIDA := FALSE;
      END IF;
      --           o_valor := round(o_valor * PAR_PERCENT_CORRECAO , 2);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_FUNCAO = 32 THEN
      SP_OBTEM_PARVAL_FOLHA2('', 1000, COM_VAL_STR2, o_valor);
    ELSIF i_num_FUNCAO = 39 THEN
      SP_OBTEM_NOME_CARGO(o_str);
    ELSIF i_num_FUNCAO = 40 THEN
      SP_OBTEM_PARVAL_FOLHA2('PROCUR', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 41 THEN
      --Composicao Individual - Unidade
      o_valor := COM_QTY_UNID_IND;
    ELSIF i_num_FUNCAO = 42 THEN
      --Composicao Pensao
      SP_OBTEM_SOMA_PENSAO(o_valor);
      o_valor := o_valor * -1; -- obter o valor positivo para gravar o valor da rubrica correto
    ELSIF i_num_FUNCAO = 43 THEN
      --Composicao Sal. Familia
      SP_OBTEM_SOMA_SALFA(o_valor);
    ELSIF i_num_FUNCAO = 44 THEN
      --Composicao Vencimento
      SP_OBTEM_SOMA_VENCIMENTO(com_cod_beneficio,
                               com_cod_entidade,
                               'N',
                               o_valor);
    ELSIF i_num_FUNCAO = 45 THEN
      -- Obtem cod grupo abono cargo
      SP_OBTEM_CODGRUPO_ABONO(o_valor);
      V_COD_GRUPO_45 := o_valor;
    ELSIF i_num_FUNCAO = 46 THEN
      -- Obtem valor do abono
      SP_OBTEM_VALOR_ABONO(o_valor);
    ELSIF i_num_FUNCAO = 47 THEN
      -- Obtem tipo do abono
      SP_OBTEM_TIPO_ABONO(o_str);
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 48 THEN
      -- Categoria Opcao
      SP_OBTEM_CATEGORIA_OPCAO(O_STR);
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 49 THEN
      -- Percentual do Beneficio
      o_valor := COM_PERCENT_BEN;
    ELSIF i_num_FUNCAO = 50 THEN
      -- Percentual Representacao por Graduacao Evolucao funcional
      SP_CALC_PORC_GRADUACAO_EVOLU(o_valor);
    ELSIF i_num_FUNCAO = 51 THEN
      o_str := COM_VAL_STR1;
      o_str := '''' || o_str || '''';
    ELSIF i_num_FUNCAO = 53 THEN
      SP_OBTEM_PARVAL_FOLHA2('ETAPA', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 54 THEN
      -- obtem_gratificacao_escolar
      null;
    ELSIF i_num_FUNCAO = 55 THEN
      -- Base IR
      SP_OBTEM_BASE_IR(IDX_CALN,'N', o_valor, o_valor_13);
      IF PAR_TIP_PRO = 'T' THEN
        o_valor := o_valor_13;
      END IF;
    ELSIF i_num_FUNCAO = 56 THEN
      -- Percentual IR
      SP_OBTEM_BASE_IR(IDX_CALN,'N',o_valor, o_valor_13);
      IF PAR_TIP_PRO = 'T' THEN
        o_valor := o_valor_13;
      END IF;
      v_val_base_liqui := nvl(o_valor, 0);
      SP_OBTEM_DEDUCOES(ben_ide_cli, o_valor);
      v_val_base_liqui := v_val_base_liqui - nvl(o_valor, 0);
      SP_OBTEM_PERCEN_CALC_IR(ben_ide_cli,v_val_base_liqui, o_valor, o_valor_13);
      o_valor := o_valor / 100;
    ELSIF i_num_FUNCAO = 57 THEN
      -- Deducoes IR
      SP_OBTEM_DEDUCOES(ben_ide_cli, o_valor);
    ELSIF i_num_FUNCAO = 58 THEN
      -- Retorna Redutor IR
      SP_OBTEM_BASE_IR(IDX_CALN,'N', o_valor, o_valor_13);
      IF PAR_TIP_PRO = 'T' THEN
        o_valor := o_valor_13;
      END IF;
      v_val_base_liqui := nvl(o_valor, 0);
      SP_OBTEM_DEDUCOES(ben_ide_cli, o_valor);
      v_val_base_liqui := v_val_base_liqui - nvl(o_valor, 0);
      SP_OBTEM_PERCEN_CALC_IR(ben_ide_cli,v_val_base_liqui, o_valor_13, o_valor);
    ELSIF i_num_funcao = 59 THEN
      --CONTRIBUIC?O PREV BASE
      SP_OBTEM_PARVAL_FOLHA2('TASCO', 2000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 60 THEN
      -- Complemento Salario Fmilia Faixa1
      SP_OBTEM_PARVAL_FOLHA2('SALFA', 2000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 61 THEN
      --
      SP_OBTEM_PARVAL_FOLHA2('VMAR', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 62 THEN
      -- Numero de dependentes CIVIL
      SP_OBTEM_PARVAL_FOLHA2('SALFA', 2000, i_cod_variavel, VI_IDADE);
      SP_OBTEM_QTD_DEPENDENTES(BEN_IDE_CLI, o_valor);
    ELSIF i_num_funcao = 63 THEN
      -- Numero de dependentes MILITAR
      SP_OBTEM_QTD_DEPENDENTES_MIL(BEN_IDE_CLI, o_valor);
    ELSIF i_num_funcao = 65 THEN
      -- Valor Referencia Representac?o
      o_valor := SP_OBTEM_SALARIO_REFERENCIA;
    ELSIF i_num_FUNCAO = 66 THEN
      SP_OBTEM_VENC_CCOMI_GRATIF_REP(i_num_funcao, o_valor);
      --           o_valor := round(o_valor * PAR_PERCENT_CORRECAO , 2);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_FUNCAO = 67 THEN
      SP_OBTEM_ORIG_TAB_VENC_CCOMI(o_str);
      o_str := '''' || o_str || '''';
    ELSIF i_num_FUNCAO = 68 THEN
      SP_OBTEM_VENC_CCOMI_GRATIF_RF(i_num_funcao, o_valor); --RAO: 20060115
      --           SP_OBTEM_VENC_CCOMI_GRATIF_REP( i_num_funcao, o_valor );
      --           o_valor := round(o_valor * PAR_PERCENT_CORRECAO , 2);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_FUNCAO = 69 THEN
      o_valor := COM_VAL_FIXO_IND;
      --           o_valor := round(o_valor * PAR_PERCENT_CORRECAO , 2);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_funcao = 71 THEN
      -- Salario Esposa
      SP_OBTEM_PARVAL_FOLHA2('SALESP', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 72 THEN
      -- CODIGO DE REFERENCIA DO VENCIMENTO -- FFRANCO 07/12/2006
      SP_OBTEM_COD_REFERENCIA(o_str);
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 73 THEN
      -- Piso Min. Operacional -- FFRANCO 06/02/2007
      SP_OBTEM_PARVAL_FOLHA2('PISO_MINIMO_OPER',
                             1000,
                             i_cod_variavel,
                             o_valor);
    ELSIF i_num_funcao = 74 THEN
      -- Piso Min. Medio -- FFRANCO 06/02/2007
      SP_OBTEM_PARVAL_FOLHA2('PISO_MINIMO_MEDIO',
                             1000,
                             i_cod_variavel,
                             o_valor);
    ELSIF i_num_funcao = 75 THEN
      -- limite regime geral -- FFRANCO 03/2007
      SP_OBTEM_LIMITE_REGIME_GERAL(V_DAT_OBITO);
      SP_OBTEM_PARVAL_FOLHA3('LIMREGER', 1000, I_cod_variavel, o_data);
      if V_DAT_OBITO >= o_data then
        SP_OBTEM_PARVAL_FOLHA2('LIMREGER', 1000, I_cod_variavel, o_valor);
      else
        o_valor := 0;
      end if;
    ELSIF i_num_funcao = 76 THEN
      -- Teto Ministro Supremo -- FFRANCO 03/2007
      SP_OBTEM_PARVAL_FOLHA2('TETO_MIN', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 77 THEN
      -- Teto Prefeito -- FFRANCO 03/2007
      SP_OBTEM_PARVAL_FOLHA2('TETO_PREF', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 79 THEN
      --Vantagens excludentes base do Teto ---> ffranco 03/2007
      sp_composicao_teto(COM_COD_FCRUBRICA, i_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 80 THEN
      -- % reajuste ordem judicial --->> FFRANCO 03/2007
      v_cod_beneficio_oj := 0;
      SP_OBTEM_ENQUADRAMENTO(3, v_cod_ref_oj, v_cod_beneficio_oj, o_valor);
      if v_cod_beneficio_oj <> com_cod_beneficio then
        o_valor := 0;
      end if;
    ELSIF i_num_FUNCAO = 81 THEN
      --Enquadramento - Codigo referencia ordem judicial  --->> FFRANCO 03/2007
      v_cod_ref_oj       := null;
      v_cod_beneficio_oj := 0;
      o_valor            := 0;
      SP_OBTEM_ENQUADRAMENTO(4, v_cod_ref_oj, v_cod_beneficio_oj, o_valor);
      if v_cod_ref_oj <> 0 and v_cod_beneficio_oj = com_cod_beneficio then
        o_valor := SP_OBTEM_SALARIO_BASE_CARGO_OJ;
        if PAR_IND_PROC_ENQUADRAMENTO = 1 then
          o_valor := o_valor * PAR_PERCENT_CORRECAO;
        end if;
        v_sal_base(com_cod_beneficio)(1) := o_valor;
      else
        o_valor := 0;
      end if;
    ELSIF i_num_FUNCAO = 82 THEN
      -- quantidade dias do beneficio no mes
      o_valor := SP_OBTEM_DIAS_BENEFICIO;
    ELSIF i_num_FUNCAO = 83 THEN
      -- quantidade dias no mes
      begin
        SELECT to_number(to_char(LAST_DAY(PAR_PER_PRO), 'DD'))
          INTO o_valor
          FROM dual;
      end;
    ELSIF i_num_FUNCAO = 84 THEN
      -- SUBSIDIO DEPUTADO ESTADUAL
      SP_OBTEM_PARVAL_FOLHA2('SUBDEPEST', 1000, I_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 87 THEN
      SP_OBTEM_PARVAL_FOLHA2('', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 88 THEN
      SP_OBTEM_PARVAL_FOLHA2('PERCDEC', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 94 THEN
      -- Data do Obito efv
      SP_OBTEM_DATA_OBITO(com_cod_beneficio, v_date_obito_char);
      o_str := '''' || v_date_obito_char || '''';
    ELSIF i_num_FUNCAO = 95 THEN
      -- Valor do teto INSS efv
      SP_OBTEM_PARVAL_FOLHA2('TETOPM', 2000, I_cod_variavel, o_valor);
    ELSIF i_num_FUNCAO = 96 THEN
      -- Valor de adiantamento 13 efv
      o_valor := SP_OBTEM_ADIANTAMENTO_13;
    ELSIF i_num_FUNCAO = 97 THEN
      -- Valor de rateio do beneficio de pensao por morte (efv 20060823)
      o_valor := VI_PERCENTUAL_RATEIO;
      --           SP_RATEIO_BENEFICIO (com_cod_beneficio, BEN_IDE_CLI, 1, o_valor_13, o_valor);
    ELSIF i_num_FUNCAO = 98 THEN
      --IRRF
      SP_OBTEM_IRRF(ant_ide_cli, IDX_CALN, 'N', o_valor, o_valor_13);
    ELSIF i_num_funcao = 99 THEN
      o_str          := '''' || COM_TIP_BENEFICIO || '''';
      COM_NUM_FUNCAO := i_num_funcao;
    ELSIF i_num_funcao = 101 THEN
      IF vi_cod_ref_pad_venc is not null then
        o_str := vi_cod_ref_pad_venc;
      ELSE
        o_str := SP_OBTEM_PADRAO_VENCIMENTO;
      END IF;
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 102 THEN
      o_valor := SP_OBTEM_SALARIO_PADRAO_INI;
    ELSIF i_num_funcao = 103 THEN
      o_valor := COM_PCCS;
    ELSIF i_num_funcao = 104 THEN
      o_valor := COM_QUADRO;
    ELSIF i_num_funcao = 105 THEN
      o_str := SP_OBTEM_DESC_NIVEL;
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 106 THEN
      o_valor := VI_META_GLOBAL;
    ELSIF i_num_funcao = 107 THEN
      o_valor := COM_QTY_UNID_IND;
    ELSIF i_num_funcao = 108 THEN
      select DECODE(COM_QUADRO,
                    0,
                    'NAOOPTANTE',
                    1,
                    'NAOOPTANTE',
                    2,
                    'NAOOPTANTE',
                    3,
                    'NAOOPTANTE',
                    4,
                    'NAOOPTANTE',
                    5,
                    'NAOOPTANTE',
                    6,
                    'NAOOPTANTE',
                    7,
                    'NAOOPTANTE',
                    'OPTANTE')
        into o_str
        from dual;
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 109 THEN
      SP_OBTEM_DATA_OBITO_INV(com_cod_beneficio, v_date_obito_char);
      o_str := '''' || v_date_obito_char || '''';
    ELSIF i_num_funcao = 110 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_0168', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 111 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_0168A', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 112 THEN
      o_valor := SP_OBTEM_SALARIO_PADRAO_INI_A;
    ELSIF i_num_funcao = 113 THEN
      o_str := '''' || BEN_COD_TIPO_CALCULO || '''';
    ELSIF i_num_funcao = 115 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_VH0', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 116 THEN
      o_valor := VI_PERCENTUAL_RATEIO * VI_PERC_PECUNIA;
    ELSIF i_num_funcao = 117 THEN
      o_padrao := substr(i_cod_variavel, 9, length(i_cod_variavel) - 9 + 1);
      sp_obtem_referencia(o_padrao, v_referencia);
      o_valor := SP_OBTEM_SALARIO_BASE_CARGO(v_referencia);
    ELSIF i_num_funcao = 118 THEN
      o_str := SP_OBTEM_DESC_PISO;
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 119 THEN
      o_valor := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia); --ROD10
      v_sal_base(com_cod_beneficio)(1) := o_valor; --ROD10

      o_valor := COM_CARGO;
    ELSIF i_num_funcao = 120 THEN
      SP_OBTEM_VAL_JORN_PISO(o_valor);
    ELSIF i_num_funcao = 122 THEN
      SP_OBTEM_VENC_BASE_CCOMIG(i_num_funcao, o_valor);
    ELSIF i_num_funcao = 123 THEN
      o_valor := V_DIAS_MES;
    ELSIF i_num_funcao = 125 THEN
      o_valor := PAR_PERCENT_CORRECAO;
    ELSIF i_num_funcao = 126 THEN
      SP_OBTEM_PARVAL_FOLHA2('COT_1059', 1000, i_cod_variavel, o_valor);
      v_sal_base(com_cod_beneficio)(1) := o_valor;
    ELSIF i_num_funcao = 127 THEN
      SP_OBTEM_PARVAL_FOLHA2('COT_GEXE', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 128 THEN
      SP_OBTEM_PARVAL_FOLHA2('COT_GJUD', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 129 THEN
      SP_OBTEM_PARVAL_FOLHA2('COT_HADV', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 130 THEN
      SP_OBTEM_PARVAL_FOLHA2('VALOR_GEA', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 131 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_GGER', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao in (132, 133, 134, 135, 136,137) THEN
      IF vi_cod_ref_pad_venc <> ' ' then
         o_str := SP_OBTEM_PADRAO_VENCIMENTO;
         if o_str is null then
          o_str := '0000000000000000000000000';
        end if;
      ELSE
        o_str := SP_OBTEM_PADRAO_VENCIMENTO;
        if o_str is null then
          o_str := '0000000000000000000000000';
        end if;
      END IF;
      IF i_num_funcao = 132 THEN
        o_valor := to_number(substr(vi_cod_ref_pad_venc, 10, 3));
      ELSIF i_num_funcao = 133 THEN
        o_valor := to_number(substr(vi_cod_ref_pad_venc, 21, 2));
      ELSIF i_num_funcao = 134 THEN
        o_valor := to_number(substr(vi_cod_ref_pad_venc, 24, 2));
      ELSIF i_num_funcao = 135 THEN
        BEGIN
           o_str := to_number(substr(vi_cod_ref_pad_venc, 16, 2));
        EXCEPTION
            when others then
            o_str :=  substr(vi_cod_ref_pad_venc, 16, 2);
        END;
      ELSIF i_num_funcao = 136 THEN
        o_str := substr(vi_cod_ref_pad_venc, 19, 1);
        o_str := '''' || o_str || '''';
       ELSIF i_num_funcao = 137 THEN
         SP_OBTEM_PARVAL_FOLHA2('VAL_PISO_F', 1000, i_cod_variavel, o_valor);
      END IF;
    ELSIF i_num_funcao = 201 THEN
      o_str := SP_OBTEM_PODER(com_cod_entidade);
      --o_str := SP_OBTEM_PODER;                      --ROD8
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 202 THEN
      o_valor := COM_COD_JORNADA;
    ELSIF i_num_funcao = 203 THEN
      -- FFRANCO - 01052009
      o_valor := VI_VAL_APIPREM;
    ELSIF i_num_funcao = 210 THEN
      --          o_str := BEN_FLG_OPCAO_13;
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 211 THEN
      o_str := to_char(BEN_DTA_NASC, 'MM');
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 212 THEN
      o_str := to_char(add_months(PAR_PER_PRO, 1), 'MM');
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 213 THEN
      o_str := BEN_FLG_OPCAO_IAMSP;
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 214 THEN
      SP_VERIFICA_ORDEM_JUDICIAL(i_num_funcao, o_valor); -- verifica ordem judicial para correc?o no calculo
    ELSIF i_num_funcao = 215 THEN
      --pega valor de salario minimo insalubridade
      o_valor := V_VAL_SAL_MIN_2;
    ELSIF i_num_funcao = 301 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_5709', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 302 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_5001', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 303 THEN
      SP_OBTEM_PARVAL_FOLHA2('COT_4817', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 304 THEN
      SP_OBTEM_PARVAL_FOLHA2('COT_4088', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 306 THEN
      SP_OBTEM_PARVAL_FOLHA2('UBV', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 307 THEN
      SP_OBTEM_PARVAL_FOLHA2('RF_CETPS', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 308 THEN
      SP_OBTEM_PARVAL_FOLHA2('VAL_5710', 1000, i_cod_variavel, o_valor);

    ELSIF i_num_funcao = 312 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_6A', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 313 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_6B', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 314 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_6C', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 315 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_6D', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 316 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_6E', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 317 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_3A', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 318 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_3B', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 319 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_3C', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 320 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_3D', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 321 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_3E', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 322 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_6A', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 323 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_6B', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 324 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_6C', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 325 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_6D', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 326 THEN
      SP_OBTEM_PARVAL_FOLHA2('6409_6E', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 327 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_3A', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 328 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_3B', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 329 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_3C', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 330 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_3D', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 331 THEN
      SP_OBTEM_PARVAL_FOLHA2('6407_3E', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 332 THEN
      SP_OBTEM_PARVAL_FOLHA2('VLR_4830', 1000, i_cod_variavel, o_valor);
    ELSIF i_num_funcao = 401 THEN
      --PAULO MIRANDA
      SP_OBTEM_PARVAL_FOLHA2('NIVEL_PM', 1000, i_cod_variavel, o_valor);
   ELSIF i_num_funcao = 402 THEN
      sp_composicao(COM_COD_FCRUBRICA,
                    'BASE_IAMSP',
                    COM_NUM_MATRICULA   ,
                    COM_COD_IDE_REL_FUNC,
                    COM_ENTIDADE,
                    'N',
                    o_valor);

    ELSIF i_num_funcao = 403 THEN
      o_str := to_char( PAR_PER_REAL , 'yyyy');
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 404 THEN
      o_str := to_char( PAR_PER_PRO , 'yyyy');
      o_str := '''' || o_str || '''';
    ELSIF i_num_funcao = 405 THEN
      o_valor := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia); --JTS24
       o_valor:=NVL( o_valor ,0);
    ELSIF i_num_funcao = 406 THEN
      o_valor := SP_OBTEM_SALARIO_BASE_CARGO(COM_REFERENCIA_2); --JTS24
      o_valor:=NVL( o_valor ,0);
   ELSIF i_num_funcao = 407 THEN
      o_valor := SP_OBTEM_SALARIO_BASE_CARGO(COM_REFERENCIA_3); --JTS24
      o_valor:=NVL( o_valor ,0);
   ELSIF i_num_funcao = 408 THEN
      o_valor := nvl(COM_QTD_MES,0);
   ELSIF i_num_funcao = 409 THEN
       o_valor := nvl(COM_QTD_MES_2,0);
   ELSIF i_num_funcao = 410 THEN
      o_valor :=nvl(COM_QTD_MES_3,0);
   ELSIF i_num_funcao = 411 THEN
      o_str := to_char( PAR_PER_REAL , 'mm');
      o_str := '''' || o_str || '''';
   ELSIF i_num_funcao = 412 THEN
      o_str := to_char( PAR_PER_PRO , 'mm');
      o_str := '''' || o_str || '''';
  ELSIF i_num_FUNCAO = 413 THEN
      -- Deducoes IR JTS-23-07-2010
     SP_OBTEM_DEDUCOES_BASICAS(ben_ide_cli, o_valor);
  ELSIF  i_num_FUNCAO = 415 THEN
  -- Deducoes IR JTS-01-08-2010
          ---- o_valor:=VI_PROP_SAIDA;

   --- novo Calculo de proporcionalidade 18102010 JTS
       SP_OBTEM_FATOR_MES_PRO(BEN_DAT_INICIO ,o_valor );
 --------------------------------------------------------------
   ELSIF i_num_FUNCAO = 416 THEN
      -- Parametro UPF
      SP_OBTEM_PARVAL_FOLHA2('SAL_MIN_EST_SP', 1000, i_cod_variavel, o_valor);

   ELSIF i_num_FUNCAO = 418 THEN
      -- Parametro UPF
        o_valor:=COM_COD_CONVENIO;
   ELSIF i_num_FUNCAO = 419 THEN

        BEGIN
          SELECT  SUM(NVL(CC.PERC_PENS,0) )/100
           INTO O_VALOR
          FROM TB_CONCESSAO_BENEFICIO CC
          WHERE CC.COD_INS       = PAR_COD_INS
             AND CC.COD_BENEFICIO= COM_COD_BENEFICIO;
         -------------------
          EXCEPTION
            when  no_data_found then
                  O_VALOR:=0;
            when others then
                   O_VALOR:=0 ;

        END;
   -------------------NOVAS FUNC?ES ---------
  ELSIF i_num_FUNCAO = 500 THEN
       COM_CARGO_DIF_VENC    := COM_COD_CARGO_RUB  ;
       -- Modifica 16-09-2013
       COM_CONCEITO_DIF_VENC := COM_COD_CONCEITO ;
       COM_ENTIDADE_DIF_VENC := COM_ENTIDADE ;
/*       SP_OBTEM_BASE_133(COM_COD_CONCEITO   ,
                         COM_ENTIDADE      ,
                         COM_CARGO_DIF_VENC ,
                         O_VALOR
                         );*/

     ELSIF i_num_FUNCAO = 501 THEN
       COM_CARGO_DIF_VENC:= COM_COD_CARGO_RUB  ;
       --SP_OBTEM_BASE_NORMAL133(COM_CARGO_DIF_VENC , O_VALOR );
    ELSIF i_num_FUNCAO = 502 THEN
        NULL;
        -------------------
        BEGIN
        select   B.VAL_UNIDADE INTO O_VALOR
                 from
                 tb_conceito_rub_dominio      a,
                 tb_conceito_rub_det_dominio  b
        where b.cod_ins=PAR_COD_INS          and
              a.cod_ins=b.cod_ins            and
              b.cod_entidade=b.cod_entidade  and
              a.cod_conceito = COM_COD_CONCEITO and
              a.cod_func     = COM_COD_FUNCAO   and
              a.cod_entidade = COM_COD_ENTIDADE and
              a.cod_conceito= b.cod_conceito and
              a.cod_func=b.cod_func          and
              a.cod_entidade=b.cod_entidade  and
              b.dat_ini_vig<=PAR_PER_PRO    and
              nvl(b.dat_fim_vig,to_date('01/01/2199','dd/mm/yyyy')  ) >PAR_PER_PRO;
            EXCEPTION
            when  no_data_found then
                  O_VALOR:=0;
            when others then
                   O_VALOR:=0 ;
            END;

   ELSIF i_num_FUNCAO = 509 THEN
           SP_OBTEM_PARVAL_FOLHA2('VAL_CNTR', 1000, i_cod_variavel, o_valor);
   ELSIF i_num_FUNCAO = 510 THEN
           SP_OBTEM_SIM_CNT(COM_COD_BENEFICIO, O_VALOR);
   ELSIF i_num_funcao = 511 THEN
      -- Valor Referencia Representac?o
        o_valor :=  SP_OBTEM_PERC_FEQ ;
   ELSIF i_num_funcao = 517 THEN
               SP_OBTEM_PARVAL_FOLHA2('REF06_PM', 1000, i_cod_variavel, o_valor);

   ELSIF i_num_funcao = 518 THEN
               SP_CALCULA_SALMIN_ANTER(o_valor);
   ELSIF i_num_FUNCAO = 519 THEN
       o_valor:= COM_COD_CARGO_RUB;
   ELSIF  i_num_FUNCAO = 521 THEN
      SP_OBTEM_TETO (ben_ide_cli      ,
                     com_cod_entidade ,
                     com_cargo        ,
                     o_valor          );

   ELSIF  i_num_FUNCAO = 522 THEN
      SP_OBTEM_TETO (ben_ide_cli      ,
                     com_cod_entidade ,
                     com_cargo        ,
                     o_valor          );
   ELSIF  i_num_FUNCAO = 523 THEN
      SP_VERIFICA_TIP_JUDICIAL (COM_COD_IDE_CLI_BEN     ,
                     COM_NUM_ORD_JUD             ,
                     o_str          );
  ELSIF  i_num_FUNCAO = 524 THEN
/*      SP_COMPOSICAO_BENEFICIO
                   (COM_COD_FCRUBRICA,
                    I_COD_VARIAVEL,
                    COM_COD_BENEFICIO,
                    COM_ENTIDADE,
                    'N',
                    O_VALOR);
                    O_VALOR:=ABS(O_VALOR);*/
                    NULL;
     ELSIF  i_num_FUNCAO = 525  THEN
      o_valor := COM_VAL_PORC_IND_133;
      BEGIN
        select   ben.val_porc
                INTO O_VALOR
                 from
                 tb_composicao_ben ben
        where ben.cod_ins       =PAR_COD_INS       and
              ben.cod_entidade  =COM_ENTIDADE      and
              ben.cod_beneficio =COM_COD_BENEFICIO and
              trunc(ben.cod_fcrubrica/100) =trunc(COM_COD_FCRUBRICA/100) and
              ben.flg_status='V'                    and
              to_date('01/'||to_char(ben.dat_ini_vig,'MM/YYYY'),'dd/mm/yyyy') <=PAR_PER_PRO        and
              nvl(ben.dat_fim_vig,to_date('01/01/2199','dd/mm/yyyy')  ) >PAR_PER_PRO;
         EXCEPTION
            when  no_data_found then
                 o_valor := COM_VAL_PORC_IND_133;
            when others then
                   O_VALOR:=0 ;
          END;
       ---------------------------------
     ELSIF  i_num_FUNCAO = 526 THEN
            O_VALOR :=0;
            BEGIN
              select  1
                      INTO  O_VALOR
              FROM tb_compoe_beneficio cd
             WHERE cd.cod_ins = PAR_COD_INS
               AND cd.cod_fcrubrica_composta =  COM_COD_FCRUBRICA
               AND cd.cod_variavel           =  'BASE_COMP_INDIV'
               AND cd.cod_entidade           =  COM_ENTIDADE
               AND cd.cod_beneficio          =  COM_COD_BENEFICIO
               AND cd.cod_fcrubrica_compoe   =  7001200
               AND to_date('01/'||to_char(cd.dat_ini_vig,'MM/YYYY'),'dd/mm/yyyy') <=PAR_PER_PRO
               AND nvl(cd.dat_fim_vig,to_date('01/01/2199','dd/mm/yyyy')  ) >PAR_PER_PRO;
               EXCEPTION
                  when  no_data_found then
                        O_VALOR :=0;
                  when others then
                       O_VALOR :=0;
                END;

       ---------------------------------

    ELSIF i_num_funcao = 527 THEN
      -- Valor % do Cargo por conceito Calculado
             o_valor :=  SP_OBTEM_PERC_CARGO ;
    ELSIF   i_num_funcao = 528 THEN
            --- Codigo de Tabela
            o_str:=COM_COD_TABELA;

    ELSIF  i_num_FUNCAO = 531 THEN
            o_valor:= SP_CALC_PORCENTUAL13(COM_COD_BENEFICIO);

    ELSIF I_NUM_FUNCAO = 550 THEN

       o_valor := SP_OBTEM_QTD_DIAS_FERIAS;

           FOR i IN 1 .. nom_variavel.count LOOP

              IF nom_variavel(i) = COM_COL_INFORMACAO THEN
                val_variavel(i) := o_valor;
                v_val_percentual := o_valor;
                exit;
              END IF;

            END LOOP;

    ELSIF I_NUM_FUNCAO = 551 THEN

       o_valor := SP_OBTEM_QTD_DIAS_RESCISAO;

           FOR i IN 1 .. nom_variavel.count LOOP

              IF nom_variavel(i) = COM_COL_INFORMACAO THEN
                val_variavel(i) := o_valor;
                v_val_percentual := o_valor;
                exit;
              END IF;

            END LOOP;

       ELSIF I_NUM_FUNCAO = 552 THEN

       o_valor := SP_CALC_AVOS13_RESCISAO;

           FOR i IN 1 .. nom_variavel.count LOOP

              IF nom_variavel(i) = COM_COL_INFORMACAO THEN
                val_variavel(i) := o_valor;
                v_val_percentual := o_valor;
                exit;
              END IF;

            END LOOP;

       ELSIF I_NUM_FUNCAO = 553 THEN

       o_valor := SP_OBTEM_DIAS_FERIAS_RESCISAO;

           FOR i IN 1 .. nom_variavel.count LOOP

              IF nom_variavel(i) = COM_COL_INFORMACAO THEN
                val_variavel(i) := o_valor;
                v_val_percentual := o_valor;
                exit;
              END IF;

            END LOOP;

       ELSIF I_NUM_FUNCAO = 554 THEN

       O_VALOR := SP_OBTEM_DIAS_AVISO_PREVIO;

           FOR i IN 1 .. nom_variavel.count LOOP

              IF nom_variavel(i) = COM_COL_INFORMACAO THEN
                val_variavel(i) := o_valor;
                v_val_percentual := o_valor;
                exit;
              END IF;

            END LOOP;

    ELSIF I_NUM_FUNCAO = 556 THEN
            O_VALOR := SP_VERIFICA_ANTECIPA_FERIAS_13;

    ELSIF I_NUM_FUNCAO = 557 THEN
            O_VALOR := SP_VERIFICA_ANTECIPA_13;

    ELSIF I_NUM_FUNCAO = 558 THEN
          O_VALOR :=  NVL(SP_OBTEM_QTD_DIAS_FERIAS,0);
          O_VALOR := O_VALOR+NVL(SP_OBTEM_QTD_DIAS_FALTAS,0);
          O_VALOR := O_VALOR+ NVL(SP_OBTEM_QTD_DIAS_AFAST,0);
          O_VALOR := O_VALOR+ NVL(SP_OBTEM_QTD_DIAS_PENAL,0);
          O_VALOR:= 30 - O_VALOR
          ;
          IF O_VALOR < 0 THEN
            O_VALOR:=0;
          END IF;

    ELSIF I_NUM_FUNCAO = 10012 THEN
          ---retorna se tem Licenca Saude
          BEGIN
           SELECT DISTINCT  '1'
            INTO o_str
             FROM TB_AFASTAMENTO F2
              WHERE PAR_PER_PRO BETWEEN
                  TO_DATE('01/' || to_char(F2.DAT_INI_AFAST, 'MM/YYYY'),
                          'DD/MM/YYYY') AND
                  F2.DAT_RET_PREV
              AND F2.COD_IDE_CLI = COM_COD_IDE_CLI
              AND F2.COD_ENTIDADE = COM_ENTIDADE
              AND F2.NUM_MATRICULA = COM_NUM_MATRICULA
              AND F2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
              AND F2.COD_MOT_AFAST IN ('2', '39');


            EXCEPTION WHEN NO_DATA_FOUND THEN
                         o_str :='0';
                      WHEN OTHERS THEN
                          o_str:='0';
              END;
     ELSIF I_NUM_FUNCAO = 10013 THEN
            ---retorna se tem Licenca Maternidade
            BEGIN
             SELECT DISTINCT  '1'
              INTO o_str
               FROM TB_AFASTAMENTO F2
                WHERE PAR_PER_PRO BETWEEN
                    TO_DATE('01/' || to_char(F2.DAT_INI_AFAST, 'MM/YYYY'),
                            'DD/MM/YYYY') AND
                    F2.DAT_RET_EFETIVO
                AND F2.COD_IDE_CLI = COM_COD_IDE_CLI
                AND F2.COD_ENTIDADE = COM_ENTIDADE
                AND F2.NUM_MATRICULA = COM_NUM_MATRICULA
                AND F2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
                AND F2.COD_MOT_AFAST IN ('43');

              EXCEPTION WHEN NO_DATA_FOUND THEN
                           o_str :='0';
                        WHEN OTHERS THEN
                            o_str:='0';
                END;
    ELSIF I_NUM_FUNCAO = 10014 THEN
              O_VALOR:=SP_OBTEM_SAL_PRO;

    ELSIF I_NUM_FUNCAO = 10017 THEN
            ---retorna se tem algum periodo aquisitivo completo
            BEGIN
             SELECT DISTINCT  '1'
              INTO o_str
               FROM TB_FERIAS_AQUISITIVO FA,
                    TB_RELACAO_FUNCIONAL RF
                WHERE  FA.COD_INS          = PAR_COD_INS
                AND FA.COD_IDE_CLI         = COM_COD_IDE_CLI
                AND FA.COD_ENTIDADE        = COM_ENTIDADE
                AND FA.NUM_MATRICULA       = COM_NUM_MATRICULA
                AND FA.COD_IDE_REL_FUNC    = COM_COD_IDE_REL_FUNC
                AND FA.DAT_FIM IS NOT NULL
                AND RF.COD_INS             = FA.COD_INS
                AND RF.NUM_MATRICULA       = FA.NUM_MATRICULA
                AND RF.COD_IDE_CLI         = FA.COD_IDE_CLI
                AND RF.COD_IDE_REL_FUNC    = FA.COD_IDE_REL_FUNC
                AND RF.COD_ENTIDADE        = FA.COD_ENTIDADE
                AND FA.DAT_INICIO          <= RF.DAT_FIM_EXERC
                AND FA.DAT_FIM             <= RF.DAT_FIM_EXERC;

              EXCEPTION WHEN NO_DATA_FOUND THEN
                           o_str :='0';
                        WHEN OTHERS THEN
                            o_str:='0';
              END;

      ELSIF I_NUM_FUNCAO = 10018 THEN
        O_VALOR := SP_OBTEM_DIAS_FERIAS_PREV;

      ELSIF I_NUM_FUNCAO = 10046 THEN
        O_VALOR := SP_OBTEM_DIAS_FERIAS_M;

      ELSIF I_NUM_FUNCAO = 10019 THEN
        O_VALOR := SP_MEDIA_FERIAS_PREV;

      ELSIF I_NUM_FUNCAO = 10020 THEN
        O_VALOR := SP_MEDIA_FERIAS_MES;

      ELSIF I_NUM_FUNCAO = 10021 THEN
        O_VALOR := SP_VALOR_PAGO_MES_ANT;

      ELSIF I_NUM_FUNCAO = 10047 THEN
        O_VALOR := SP_VALOR_PAGO_MES_ANT_2;

      ELSIF I_NUM_FUNCAO = 10048 THEN

            o_valor := SP_OBTEM_QTD_DIAS_LICENCA;

            FOR i IN 1 .. nom_variavel.count LOOP

              IF nom_variavel(i) = COM_COL_INFORMACAO THEN
                val_variavel(i) := o_valor;
                v_val_percentual := o_valor;
                exit;
              END IF;

            END LOOP;

      ELSIF I_NUM_FUNCAO = 10022 THEN
        O_VALOR := SP_OBTEM_MEDIA_1_A_11;

      ELSIF I_NUM_FUNCAO = 10041 THEN
        O_VALOR := SP_OBTEM_MEDIA_FUNC;

      ELSIF I_NUM_FUNCAO = 10023 THEN
        O_VALOR := FC_CALCULA_AVOS_AFAST (PAR_COD_INS ,
                                    COM_ENTIDADE,
                                    COM_COD_IDE_CLI,
                                    COM_NUM_MATRICULA,
                                    COM_COD_IDE_REL_FUNC,
                                    TO_CHAR(PAR_PER_PRO, 'YYYY'),
                                    '1'
                                    );

        ELSIF I_NUM_FUNCAO = 10024 THEN

         O_VALOR := FC_CALCULA_AVOS_AFAST (PAR_COD_INS ,
                                    COM_ENTIDADE,
                                    COM_COD_IDE_CLI,
                                    COM_NUM_MATRICULA,
                                    COM_COD_IDE_REL_FUNC,
                                    TO_CHAR(PAR_PER_PRO, 'YYYY'),
                                    '2'
                                    );


        ELSIF I_NUM_FUNCAO = 10025 THEN

         O_VALOR := FC_CALCULA_AVOS_AFAST (PAR_COD_INS ,
                                    COM_ENTIDADE,
                                    COM_COD_IDE_CLI,
                                    COM_NUM_MATRICULA,
                                    COM_COD_IDE_REL_FUNC,
                                    TO_CHAR(PAR_PER_PRO, 'YYYY'),
                                    '11'
                                    );

      ELSIF I_NUM_FUNCAO = 10026 THEN
        O_VALOR := SP_RUB_VAR_FERIAS_PREV;

      ELSIF I_NUM_FUNCAO = 10027 THEN
        O_VALOR := SP_RUB_VAR_FERIAS_MES;

      ELSIF I_NUM_FUNCAO = 10028 THEN
        ---retorna se tem Licenca Saude do INSS
        BEGIN
         SELECT DISTINCT  1
          INTO o_valor
           FROM TB_AFASTAMENTO F2
            WHERE PAR_PER_PRO BETWEEN
                TO_DATE('01/' || to_char(F2.DAT_INI_AFAST, 'MM/YYYY'),
                        'DD/MM/YYYY') AND
                F2.DAT_RET_PREV
            AND F2.COD_IDE_CLI = COM_COD_IDE_CLI
            AND F2.COD_ENTIDADE = COM_ENTIDADE
            AND F2.NUM_MATRICULA = COM_NUM_MATRICULA
            AND F2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
            AND F2.COD_MOT_AFAST = '11';


          EXCEPTION WHEN NO_DATA_FOUND THEN
                       o_valor :=0;
                    WHEN OTHERS THEN
                        o_valor:=0;
            END;

      ELSIF I_NUM_FUNCAO = 10029 THEN
        O_VALOR:= SP_ANTECIPA_FERIAS_13_PROX;

      ELSIF I_NUM_FUNCAO = 10031 THEN
        O_VALOR:= SP_OBTEM_DIAS_FERIAS_PROP_RESC;



      ELSIF I_NUM_FUNCAO = 10032 THEN
        O_VALOR:= FC_ANOS_ATS (       PAR_COD_INS,
                                      COM_COD_IDE_CLI,
                                      COM_NUM_MATRICULA,
                                      COM_COD_IDE_REL_FUNC,
                                      COM_ENTIDADE,
                                      LAST_DAY(PAR_PER_PRO)
                                      ) ;

      ELSIF I_NUM_FUNCAO = 10033 THEN
            O_VALOR := SP_OBTEM_DIAS_FERIAS_MES;


             ELSIF I_NUM_FUNCAO = 10035 THEN
                  ---retorna se tem Licenca Sem Vencimentos
                  BEGIN
                   SELECT DISTINCT  '1'
                    INTO o_valor
                     FROM TB_AFASTAMENTO F2
                      WHERE PAR_PER_PRO BETWEEN
                          TO_DATE('01/' || to_char(F2.DAT_INI_AFAST, 'MM/YYYY'),
                                  'DD/MM/YYYY') AND
                          F2.DAT_RET_EFETIVO
                      AND F2.COD_IDE_CLI = COM_COD_IDE_CLI
                      AND F2.COD_ENTIDADE = COM_ENTIDADE
                      AND F2.NUM_MATRICULA = COM_NUM_MATRICULA
                      AND F2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
                      AND F2.COD_MOT_AFAST IN ('18','15');

                    EXCEPTION WHEN NO_DATA_FOUND THEN
                                 o_valor :='0';
                              WHEN OTHERS THEN
                                  o_valor:='0';
                      END;

             ELSIF I_NUM_FUNCAO = 10036 THEN

         O_VALOR := FC_CALCULA_AVOS_AFAST (PAR_COD_INS ,
                                    COM_ENTIDADE,
                                    COM_COD_IDE_CLI,
                                    COM_NUM_MATRICULA,
                                    COM_COD_IDE_REL_FUNC,
                                    TO_CHAR(PAR_PER_PRO, 'YYYY'),
                                    '18'
                                    );

      ELSIF I_NUM_FUNCAO = 10038 THEN
            O_VALOR := SP_OBTEM_DIAS_LIC_SEM_REMUN;

      ELSIF I_NUM_FUNCAO = 10039 THEN

         O_VALOR := FC_CALCULA_AVOS_AFAST (PAR_COD_INS ,
                                    COM_ENTIDADE,
                                    COM_COD_IDE_CLI,
                                    COM_NUM_MATRICULA,
                                    COM_COD_IDE_REL_FUNC,
                                    TO_CHAR(PAR_PER_PRO, 'YYYY'),
                                    '39'
                                    );

      ELSIF I_NUM_FUNCAO = 10040 THEN

          O_VALOR := FC_CALCULA_AVOS_AFAST (PAR_COD_INS ,
                                    COM_ENTIDADE,
                                    COM_COD_IDE_CLI,
                                    COM_NUM_MATRICULA,
                                    COM_COD_IDE_REL_FUNC,
                                    TO_CHAR(PAR_PER_PRO, 'YYYY'),
                                    '13'
                                    );

            ELSIF I_NUM_FUNCAO = 10043 THEN
            O_VALOR := SP_VALOR_PAGO_FOL;

            ELSIF I_NUM_FUNCAO = 10044 THEN
            O_VALOR := SP_AQUISITIVO_COMPLETO;

            ELSIF I_NUM_FUNCAO = 10049 THEN
            O_VALOR := SP_DIAS_AQUISITIVO_COMPLETO;

            ELSIF I_NUM_FUNCAO = 10050 THEN
            O_VALOR := SP_QTDE_AQUISITIVO_COMPLETO;

            ELSIF I_NUM_FUNCAO = 10045 THEN
            O_VALOR := SP_OBTEM_DIAS_EVO_COMI;

            ELSIF i_num_FUNCAO = 10051 THEN
            SP_OBTEM_VENC_CCOMI_GRATIF_COR(i_num_funcao, o_valor);
            v_sal_base(com_cod_beneficio)(1) := o_valor;

            ELSIF I_NUM_FUNCAO = 10052 THEN
            O_VALOR := SP_OBTEM_DIAS_EVO_COMI_COR;
 
            ELSIF I_NUM_FUNCAO = 10053 THEN
            O_VALOR := SP_OBTER_VALOR_BAR;           
            
            

   ------ Novo Set de func?es geradas para CAMPREV
   --   ANT_COD_IDE_CLI_BEN
       ELSIF  i_num_FUNCAO = 10001 THEN
             BEGIN
               select 1
                 INTO o_valor
                 FROM tb_atributos_PF cd
                WHERE cd.cod_ins       = PAR_COD_INS
                  AND cd.cod_atributo  = 10001
                  AND to_date('01/' || to_char(cd.dat_ini_vig, 'MM/YYYY'),
                              'dd/mm/yyyy') <= PAR_PER_PRO
                  AND nvl(cd.dat_fim_vig,
                          to_date('01/01/2199', 'dd/mm/yyyy')) >
                      PAR_PER_PRO;
             EXCEPTION
               when no_data_found then
                 o_valor := 0;
               when others then
                 o_valor := 0;
             END;
       ELSIF I_NUM_FUNCAO = 10002 THEN
         o_str := SP_OBTEM_DAT_INI_EXERC(COM_NUM_MATRICULA,
                                         COM_COD_IDE_REL_FUNC,
                                         COM_ENTIDADE);
       



   END IF;

      EXCEPTION
      WHEN OTHERS THEN

          p_coderro       := sqlcode;
          p_sub_proc_erro := 'SP_OBTEM_VALOR_FORMULA';
          p_msgerro       := 'Erro formula' ||sqlerrm || ' - '|| TO_CHAR(i_num_FUNCAO ) ;

          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);

          --       RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          o_valor:=0;
          o_str:=' ';
     END;

    IF i_num_funcao in
       ( 99,   3, 4, 8, 16, 19, 25, 15, 29, 48, 51, 33, 34, 35, 36, 37, 38, 39, 47, 67, 70, 72, 78, 94, 101, 105, 108, 109, 113, 114, 118, 135,136, 201, 210, 211, 212,403,404,411,412,414,523,528,10002 ) THEN
      return(o_str);
    ELSE
      return(to_char(o_valor, '0000000.99999'));
    END IF;




  END SP_OBTEM_VALOR_VAR;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VALOR_FORMULA AS

    i          number;
    vi_formula varchar2(500);
    vi_valor   number(18, 4);
    vi_str     varchar2(600);
    cur_form   curesp;

  BEGIN

    vi_valor := 0;
  
    ----------------- Memoria de Calculo -------------
    mc_des_formula:=null;

    FOR i IN 1 .. lim_funcao LOOP
      IF tip_elemento(i) = 'OPER' or tip_elemento(i) = 'SIMB' THEN
        vi_formula := concat(vi_formula, cod_elemento(i));
      ELSE
        --         vi_formula:=concat(vi_formula,to_char(val_elemento(i),'0000000.9999'));
        vi_formula := concat(vi_formula, vas_elemento(i));
        IF tip_elemento(i) = 'VAR' THEN
          idx_elemento := i;
        END IF;
      END IF;
    END LOOP;
    vi_str := 'select ' || vi_formula || ' from dual';
    ----------------- Memoria de Calculo -------------
    mc_des_formula:=vi_str; 
    
    BEGIN
      OPEN cur_form FOR vi_str;
      FETCH cur_form
        INTO vi_valor;
      CLOSE cur_form;
    EXCEPTION
      WHEN OTHERS THEN
        IF SQLCODE = -936 THEN
          vi_valor := 0;
        ELSE
          p_coderro       := sqlcode;
          p_sub_proc_erro := 'SP_OBTEM_VALOR_FORMULA';
          p_msgerro       := 'Erro ao obter o valor da formula' || ' - ' ||
                             vi_str;
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);

          --       RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END IF;
    END;

    IF trunc(com_cod_fcrubrica / 100, 000) <> 119 THEN
      mon_calculo := vi_valor * COM_PORC_VIG; --RAO 20060321
    else
      mon_calculo := vi_valor;
    end if;

  END SP_OBTEM_VALOR_FORMULA;
  ------------------------------------------------------------------------------
  FUNCTION SP_VALIDA_CONDICAO RETURN BOOLEAN AS

    i          number;
    vi_formula varchar2(700);
    vi_str     varchar2(700);
    cur_form   curesp;
    o_condicao boolean;
    vi_res     number;

  BEGIN
    vi_res     := 0;
    o_condicao := FALSE;
    ----------------- Memoria de Calculo -------------- 
    mc_des_condicao:=null;
       
    FOR i IN 1 .. lim_funcao LOOP
      IF tip_elemento(i) = 'OPER' OR tip_elemento(i) = 'SIMB' THEN
        vi_formula := concat(vi_formula, cod_elemento(i));
      ELSE
        vi_formula := concat(vi_formula, vas_elemento(i));
        --         vi_formula:=concat(vi_formula,to_char(val_elemento(i),'0000000.9999'));
      END IF;
    END LOOP;
    vi_str := 'select case when ' || vi_formula ||
              ' then 1 else 0 end from dual';
   
  ----------------- Memoria de Calculo -----------
    mc_des_condicao:=vi_str;              
              
              
    begin
      OPEN cur_form FOR vi_str;
      -- fetch cur_form into o_condicao;
      FETCH cur_form
        INTO vi_res;
      CLOSE cur_form;
    exception
      when others then
        IF SQLCODE = -936 THEN
          vi_res := 0;
        ELSE
          p_coderro       := sqlcode;
          p_sub_proc_erro := 'SP_VALIDA_CONDICAO';
          p_msgerro       := 'Erro ao validar a condicao da formula' || '  ' ||
                             vi_str;
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);

          --       RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END IF;
    end;
    IF vi_res = 1 THEN
      o_condicao := TRUE;
    ELSE
      o_condicao := FALSE;
    END IF;
    RETURN(o_condicao);

  END SP_VALIDA_CONDICAO;
  ------------------------------------------------------------------------------
	FUNCTION SP_OBTEM_DAT_INI_EXERC( I_num_matricula VARCHAR2,
                                I_cod_ide_rel_func NUMBER,
                                I_cod_entidade  NUMBER   
                               ) RETURN VARCHAR IS
 V_INI_EXERC    VARCHAR(10);                           
  BEGIN
		BEGIN
				SELECT CASE WHEN F.DAT_INI_EXERC <= '01/07/2023' THEN 0
																												 ELSE 1 END  INTO V_INI_EXERC 
				from tb_relacao_funcional F
				WHERE F.NUM_MATRICULA     = I_num_matricula
				AND   F.COD_IDE_REL_FUNC  = I_cod_ide_rel_func
				AND   F.COD_ENTIDADE     = I_cod_entidade;
		EXCEPTION WHEN no_data_found THEN
					 NULL;
			END;

   RETURN(V_INI_EXERC);
   
END SP_OBTEM_DAT_INI_EXERC; 
	
	
  ------------------------------------------------------------------------------
  PROCEDURE SP_COMPOSICAO(I_COD_RUBRICA   in number,
                          I_VARIAVEL      in varchar2,
                          i_num_matricula    IN VARCHAR2 ,
                          i_cod_ide_rel_func IN NUMBER,
                          I_COD_ENTIDADE  IN NUMBER,
                          i_ind_val_cheio in varchar2,
                          I_VALOR         OUT NUMBER) AS
    c_comp     curform;
    vi_valor   number(18, 5);
    VI_RUBRICA NUMBER;
    m          number := 0;
    v_soma     char(1) := 'S';

  BEGIN

    m := nvl(vrubexc.count, 0);

    I_VALOR  := 0;
    VI_VALOR := 0;
    --- Obtem rubricas da composic?o
    OPEN c_comp FOR
      SELECT cd.cod_fcrubrica_compoe
        FROM tb_compoe_det cd
       WHERE cd.cod_ins = PAR_COD_INS
         AND cd.cod_fcrubrica_composta = I_COD_RUBRICA
         AND cd.cod_variavel = I_VARIAVEL
         AND cd.cod_entidade_composta = I_COD_ENTIDADE
         AND (PAR_PER_PRO >= cd.dat_ini_vig AND
             PAR_PER_PRO <=
             nvl(cd.dat_fim_vig, to_date('01/01/2045', 'dd/mm/yyyy')));
    FETCH c_comp
      INTO vi_rubrica;
    WHILE C_COMP%FOUND LOOP
      IF VI_RUBRICA IN (490004) THEN
        NULL;
      END IF;
      IF m = 0 then
        sp_valor_calculado(VI_RUBRICA,
                           i_num_matricula   ,
                           i_cod_ide_rel_func,
                           I_VARIAVEL,
                           I_COD_ENTIDADE,
                           i_ind_val_cheio,
                           vi_valor);
        I_VALOR := I_VALOR + VI_VALOR;
      ELSE
        FOR m IN 1 .. vrubexc.count LOOP

          IF vrubexc(m).cod_fcrubrica = VI_RUBRICA then
            v_soma := 'N';
            exit;
          END IF;

        END LOOP;

        IF v_soma = 'S' THEN
        sp_valor_calculado(VI_RUBRICA,
                           i_num_matricula   ,
                           i_cod_ide_rel_func,
                           I_VARIAVEL,
                           I_COD_ENTIDADE,
                           i_ind_val_cheio,
                           vi_valor);
          I_VALOR := I_VALOR + VI_VALOR;
        ELSE
          v_soma := 'S';
        END IF;
      END IF;

      FETCH c_comp
        INTO vi_rubrica;
    END LOOP;
    CLOSE C_COMP;

  END SP_COMPOSICAO;
  ------------------------------------------------------------------------------
    PROCEDURE SP_VALOR_CALCULADO(I_RUBRICA        IN NUMBER,
                                i_num_matricula    IN VARCHAR2 ,
                                i_cod_ide_rel_func IN NUMBER,
                                I_COD_VARIAVEL     IN VARCHAR2,
                                I_COD_ENTIDADE    IN NUMBER,
                                I_IND_VAL_CHEIO   IN VARCHAR2,
                                O_VALOR          OUT NUMBER) AS
    i       integer;
    cont_sp number := 0;
  BEGIN
    O_VALOR := 0;
    cont_sp := tdcn.count;
    FOR i IN 1 .. tdcn.count LOOP
      rdcn := tdcn(i);
      IF I_COD_VARIAVEL = 'BASE_PREV' THEN
        IF rdcn.cod_fcrubrica   = i_rubrica          AND
           rdcn.num_matricula   = i_num_matricula    AND
           rdcn.cod_ide_rel_func= i_cod_ide_rel_func AND
           rdcn.cod_entidade    = i_cod_entidade     AND

           rdcn.per_processo = PAR_PER_PRO AND
           rdcn.dat_ini_ref <= PAR_PER_PRO THEN
           
           --- Memoria de Calculo -----
           IF  mc_des_composicao IS NULL  THEN  
                  mc_des_composicao:= rdcn.cod_fcrubrica ;
           ELSE
                  mc_des_composicao:=mc_des_composicao ||', '||rdcn.cod_fcrubrica ;
           END  IF;          
           
          IF rdcn.flg_natureza = 'D' then
            IF i_ind_val_cheio = 'N' THEN
              O_VALOR := nvl(O_VALOR, 0) - TRUNC(rdcn.val_rubrica,2);
            ELSE
              O_VALOR := nvl(O_VALOR, 0) - TRUNC(rdcn.val_rubrica_cheio,2);
            END IF;
            --                 exit;
          ELSE
            IF i_ind_val_cheio = 'N' THEN
              O_VALOR := nvl(O_VALOR, 0) + TRUNC(rdcn.val_rubrica,2);
            ELSE
              O_VALOR := nvl(O_VALOR, 0) + TRUNC(rdcn.val_rubrica_cheio,2);
            END IF;
            --                 exit;
          END IF;
        END IF;
      ELSE
        IF rdcn.cod_fcrubrica = i_rubrica AND
           rdcn.num_matricula   = i_num_matricula    AND
           rdcn.cod_ide_rel_func= i_cod_ide_rel_func AND
           rdcn.cod_entidade    = i_cod_entidade     AND
           rdcn.per_processo = PAR_PER_PRO 
           THEN
           --- Memoria de Calculo -----
           IF  mc_des_composicao IS NULL  THEN  
                  mc_des_composicao:= rdcn.cod_fcrubrica ;
           ELSE
                  mc_des_composicao:=mc_des_composicao ||', '||rdcn.cod_fcrubrica ;
           END  IF;                 
           
             
          IF rdcn.flg_natureza = 'D' then
            IF i_ind_val_cheio = 'N' THEN
              o_valor := o_valor - TRUNC(rdcn.val_rubrica,2);
            ELSE
              o_valor := o_valor - TRUNC(rdcn.val_rubrica_cheio,2);
            END IF;
            --                 exit;
          ELSE
            IF i_ind_val_cheio = 'N' THEN
              o_valor := o_valor + TRUNC(rdcn.val_rubrica,2);
            ELSE
              o_valor := o_valor + TRUNC(rdcn.val_rubrica_cheio,2);
            END IF;
            --                 exit;
          END IF;
        END IF;
      END IF;
    END LOOP;
    FOR i IN 1 .. tdcd.count LOOP
      rdcn := tdcd(i);
      IF rdcn.cod_fcrubrica = i_rubrica AND
           rdcn.num_matricula   = i_num_matricula    AND
           rdcn.cod_ide_rel_func= i_cod_ide_rel_func AND
           rdcn.cod_entidade    = i_cod_entidade     AND
         rdcn.per_processo = PAR_PER_PRO THEN
        IF rdcn.flg_natureza = 'D' then
          IF i_ind_val_cheio = 'N' THEN
            o_valor := o_valor - TRUNC(rdcn.val_rubrica,2);
          ELSE
            o_valor := o_valor - TRUNC(rdcn.val_rubrica_cheio,2);
          END IF;
          --                 exit;
        ELSE
          IF i_ind_val_cheio = 'N' THEN
            o_valor := o_valor + TRUNC(rdcn.val_rubrica,2);
          ELSE
            o_valor := o_valor + TRUNC(rdcn.val_rubrica_cheio,2);
          END IF;
          --                 exit;
        END IF;
                --- Para Controle de Magem 18-09-2013
           IF  INSTRB(NVL(tdcd(i).des_complemento,' '),'- S/CM') =0  THEN
              tdcd(i).des_complemento:= tdcd(i).des_complemento||'- S/CM';
           END IF;
      END IF;
    END LOOP;

  END SP_VALOR_CALCULADO;
  ------------------------------------------------------------------------------
  PROCEDURE SP_COMPOSICAO_TETO(I_COD_RUBRICA in number,
                               I_VARIAVEL    in varchar2,
                               I_VALOR       OUT NUMBER) AS
    c_comp     curform;
    vi_valor   number(18, 5);
    VI_RUBRICA NUMBER;

  BEGIN
    I_VALOR  := 0;
    VI_VALOR := 0;
    --- Obtem rubricas da composic?o
    OPEN c_comp FOR
      SELECT cbe.cod_fcrubrica
        FROM tb_composicao_ben cbe
       WHERE cbe.cod_ins = PAR_COD_INS
         AND CBE.COD_BENEFICIO = COM_COD_BENEFICIO
         AND CBE.VAL_STR2 = 'S'
         AND (to_char(PAR_PER_PRO, 'YYYYMM') >=
             to_char(CBE.DAT_INI_VIG, 'YYYYMM') AND
             to_char(PAR_PER_PRO, 'YYYYMM') <=
             to_char(nvl(CBE.DAT_FIM_VIG,
                          to_date('01/01/2045', 'dd/mm/yyyy')),
                      'YYYYMM'));
    FETCH c_comp
      INTO vi_rubrica;
    WHILE C_COMP%FOUND LOOP
      sp_valor_calculado(VI_RUBRICA,
                         COM_NUM_MATRICULA   ,
                         COM_COD_IDE_REL_FUNC,
                         I_VARIAVEL,
                         COM_COD_ENTIDADE,
                         'N',
                         vi_valor);
      I_VALOR := I_VALOR + VI_VALOR;
      FETCH c_comp
        INTO vi_rubrica;
    END LOOP;
    CLOSE C_COMP;

  END SP_COMPOSICAO_TETO;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_CONTRIB(i_variavel IN VARCHAR,
                       i_valbase  number,
                       o_valor    OUT NUMBER) AS
  BEGIN

    FOR i IN 1 .. 2 LOOP
      IF i_valbase < lim_taxa_prev(i) THEN
        IF i_variavel = 'DESC_CONTR' THEN
          o_valor := dsc_taxa_prev(i);
        ELSIF i_variavel = 'PORC_CONTR' THEN
          o_valor := val_taxa_prev(i) / 100;
        END IF;
        EXIT;
      END IF;
    END LOOP;

  END SP_CONTRIB;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SOMA_PENSAO(o_valor out number) AS

    i       number := 0;
    i_valor number(18, 4) := 0;

  BEGIN

    o_valor := 0;

    FOR i IN 1 .. cod_con.count LOOP
      IF tip_evento_especial(i) = 'P' THEN
        sp_valor_calculado(cod_rub(i),
                          COM_NUM_MATRICULA   ,
                          COM_COD_IDE_REL_FUNC,
                           ' ',
                           cod_entidade(i),
                           'N',
                           i_valor);
        o_valor := o_valor + i_valor;
      END IF;
    END LOOP;

  END SP_OBTEM_SOMA_PENSAO;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SOMA_SALFA(o_valor out number) AS

    i       number := 0;
    i_valor number(18, 4) := 0;

  BEGIN

    o_valor := 0;

    FOR i IN 1 .. cod_con.count LOOP
      IF tip_evento_especial(i) = 'F' THEN
        sp_valor_calculado(cod_rub(i),
                           COM_NUM_MATRICULA   ,
                           COM_COD_IDE_REL_FUNC,
                           '',
                           cod_entidade(i),
                           'N',
                           i_valor);
        o_valor := o_valor + i_valor;
      END IF;
    END LOOP;

  END SP_OBTEM_SOMA_SALFA;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SOMA_VENCIMENTO(i_cod_beneficio in number,
                                     i_cod_entidade  in number,
                                     i_ind_val_cheio in varchar2,
                                     o_valor         out number) AS

    i       number := 0;
    i_valor number(18, 4) := 0;
    m       number := 0;
    v_soma  char(1) := 'S';
    e       number := 0;

  BEGIN
    o_valor := 0;

    m := nvl(vrubexc.count, 0);
    --  e := nvl(vrubexcesso.count,0);

    FOR i IN 1 .. cod_con.count LOOP
      IF (tip_evento_especial(i) = 'V' OR tip_evento_especial(i) = 'L' OR
         tip_evento_especial(i) = 'E') AND cod_entidade(i) = i_cod_entidade THEN
        IF m = 0 then
          sp_valor_calculado(cod_rub(i),
                             COM_NUM_MATRICULA   ,
                             COM_COD_IDE_REL_FUNC,
                             '',
                             cod_entidade(i),
                             i_ind_val_cheio,
                             i_valor);
          o_valor := o_valor + i_valor;
        ELSE
          FOR m IN 1 .. vrubexc.count LOOP

            IF vrubexc(m).cod_fcrubrica = cod_rub(i) then
              v_soma := 'N';
              exit;
            END IF;

          END LOOP;

          IF v_soma = 'S' THEN
            sp_valor_calculado(cod_rub(i),
                              COM_NUM_MATRICULA   ,
                              COM_COD_IDE_REL_FUNC,
                               '',
                               cod_entidade(i),
                               i_ind_val_cheio,
                               i_valor);
            o_valor := o_valor + i_valor;
          ELSE
            v_soma := 'S';
          END IF;
        END IF;

      END IF;
    END LOOP;

  END SP_OBTEM_SOMA_VENCIMENTO;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_DEPENDENTES(P_COD_IDE_CLI IN VARCHAR2,
                                     O_VALOR       OUT NUMBER) AS

    num_dependentes number := 0;

  BEGIN

    num_dependentes := 0;

    /*
    select count(1)
      into o_valor
     from tb_dependente d,
          tb_pessoa_fisica pf
    where d.cod_ins = PAR_COD_INS
      and d.cod_ins = pf.cod_ins
      and d.cod_ide_cli_serv = P_COD_IDE_CLI
      and d.cod_ide_cli_dep = pf.cod_ide_cli
      and ( to_char(PAR_PER_PRO,'YYYYMM') >=  to_char(d.DAT_INI_DEP,'YYYYMM')
          and to_char(PAR_PER_PRO,'YYYYMM') <=  to_char(nvl(D.DAT_FIM_DEP,to_date('01/01/2045','dd/mm/yyyy')),'YYYYMM'))
      and (( to_number(to_char(PAR_PER_PRO,'YYYYMMDD'))
          - to_number(to_char(pf.dat_nasc,'YYYYMMDD')) ) / 10000 < VI_IDADE
          or exists (select 1
                       from tb_situacao_dep sd
                      where d.cod_ins = sd.cod_ins
                        and d.cod_ide_cli_serv = sd.cod_ide_cli_serv
                        and d.cod_ide_cli_dep = sd.cod_ide_cli_dep
                        and ( PAR_PER_PRO >= sd.dat_ini_dep
                             and PAR_PER_PRO <= nvl(sd.dat_fim_dep,to_date('01/01/2045','DD/MM/YYYY')))));
    */

--...................... Comentado por ROD em 20Set09
/*    select count(1)
      into o_valor
      from tb_dependencia_economica de
     where de.cod_ins = par_cod_ins
       and de.flg_dep_ir = 'S'
       and par_per_pro >= de.dat_ini_dep_eco
       and par_per_pro <= nvl(de.dat_fim_dep_eco, '01/01/2200')
       and de.cod_ide_cli_ben = BEN_IDE_CLI;*/

    select pf.num_dep_ir
     into  o_valor
     from  tb_pessoa_fisica pf
     where pf.cod_ins = par_cod_ins
     and   pf.cod_ide_cli = BEN_IDE_CLI;
    if o_valor is null then
       o_valor := 0;
    end if;

    FOR i IN 1 .. nom_variavel.count LOOP

      IF nom_variavel(i) = COM_COL_INFORMACAO THEN
        val_variavel(i) := o_valor;
        v_qtd_horas := o_valor;
        exit;
      END IF;

    END LOOP;

  END SP_OBTEM_QTD_DEPENDENTES;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_DEPENDENTES_MIL(P_COD_IDE_CLI IN VARCHAR2,
                                         O_VALOR       OUT NUMBER) AS
  BEGIN
    begin
      select s.num_dep_sf_mil, s.num_dep_ir
        into o_valor, num_dep_ir_mil
        from tb_servidor s
       where s.cod_ins = PAR_COD_INS
         and s.cod_ide_cli = BEN_IDE_CLI;
      begin
        select count(1)
          into o_valor
          from tb_dependencia_economica de
         where de.cod_ins = par_cod_ins
           and de.flg_dep_ir = 'S'
           and par_per_pro >= de.dat_ini_dep_eco
           and par_per_pro <= nvl(de.dat_fim_dep_eco, '01/01/2200')
           and de.cod_ide_cli_ben = BEN_IDE_CLI;

        num_dep_ir_mil := o_valor;

      exception
        when others then

          o_valor := 0;

      end;
      FOR i IN 1 .. nom_variavel.count LOOP

        IF nom_variavel(i) = COM_COL_INFORMACAO THEN
          val_variavel(i) := o_valor;
          v_qtd_horas := o_valor;
          exit;
        END IF;

      END LOOP;

    EXCEPTION
      WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_OBTEM_QTD_DEPENDENTES_MIL';
        p_msgerro       := 'Erro ao obter a quantidades de dependentes';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --       RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_OBTEM_QTD_DEPENDENTES_MIL;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RELACAO_FUNCIONAL(I_NUM_FUNCAO IN NUMBER,
                                       O_STR        OUT VARCHAR2,
                                       O_NUM        OUT NUMBER) AS

  cod_regime_jur         NUMBER(8) ;
  tip_provimento         VARCHAR2(5);
  cod_tipo_hist_ini      VARCHAR2(5);
  cod_vinculo            NUMBER(8);
  BEGIN
    BEGIN

      select distinct
             RF.COD_REGIME_JUR    ,
             RF.TIP_PROVIMENTO    ,
             RF.COD_TIPO_HIST_INI ,
             RF.COD_VINCULO
         into  cod_regime_jur   ,
              tip_provimento    ,
              cod_tipo_hist_ini ,
              cod_vinculo
        from tb_relacao_funcional      rf
        where rf.cod_ins          = PAR_COD_INS
         and rf.num_matricula    = COM_NUM_MATRICULA
         and rf.cod_ide_rel_func = COM_COD_IDE_REL_FUNC
         and rf.cod_entidade     = COM_ENTIDADE;

        CASE
          WHEN  I_NUM_FUNCAO=1 THEN
             O_NUM   := cod_regime_jur;
          WHEN  I_NUM_FUNCAO=2 THEN
                O_NUM   := TO_NUMBER(cod_vinculo) ;
          WHEN  I_NUM_FUNCAO=1002 THEN
              O_NUM   := TO_NUMBER(tip_provimento) ;
          WHEN  I_NUM_FUNCAO=1003 THEN
              O_NUM   := TO_NUMBER(cod_tipo_hist_ini);
             ELSE O_NUM   :=0;
         END CASE;


    EXCEPTION
      WHEN NO_DATA_FOUND THEN
          O_STR   :=' ';
          O_NUM   := 0;
      WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_OBTEM_RELACAO_FUNCIONAL';
        p_msgerro       := 'Erro ao obter a Relacao Funcional';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --       RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_OBTEM_RELACAO_FUNCIONAL;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_CATEGORIA(O_VALOR OUT VARCHAR2) AS

  BEGIN

    BEGIN

      select sc.nom_categoria, sbc.nom_subcategoria
        into NOM_CATEGORIA, NOM_SUBCATEGORIA
        from tb_cargo ca, tb_categoria sc, tb_subcategoria sbc
       where CA.COD_CARGO = COM_CARGO
         AND CA.COD_INS = PAR_COD_INS
         AND CA.COD_ENTIDADE = COM_ENTIDADE
         AND CA.COD_PCCS = COM_PCCS
         and sc.cod_categoria = ca.cod_categoria
         and sbc.cod_categoria = ca.cod_categoria
         and sbc.cod_subcategoria = ca.cod_subcategoria;

      o_valor := '''' || o_valor || '''';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        o_valor := null;
        o_valor := '''' || o_valor || '''';
      WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_OBTEM_CATEGORIA';
        p_msgerro       := 'Erro ao obter a Categoria';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_OBTEM_CATEGORIA;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_SUBCATEGORIA(O_VALOR OUT VARCHAR2) AS

  BEGIN

    BEGIN
      select sc.nom_categoria, sbc.nom_subcategoria
        into NOM_CATEGORIA, NOM_SUBCATEGORIA
        from tb_cargo ca, tb_categoria sc, tb_subcategoria sbc
       where CA.COD_CARGO = COM_CARGO
         AND CA.COD_INS = PAR_COD_INS
         AND CA.COD_ENTIDADE = COM_ENTIDADE
         AND CA.COD_PCCS = COM_PCCS
         and sc.cod_categoria = ca.cod_categoria
         and sbc.cod_categoria = ca.cod_categoria
         and sbc.cod_subcategoria = ca.cod_subcategoria;

      o_valor := '''' || o_valor || '''';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        o_valor := null;
        o_valor := '''' || o_valor || '''';
      WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_OBTEM_SUBCATEGORIA';
        p_msgerro       := 'Erro ao obter a subcategoria';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_SUBCATEGORIA;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_CATEGORIA_OPCAO(O_STR OUT VARCHAR2) AS

    cargo_aux number(8) := 0;

  BEGIN

    begin

      select /*+ RULE */
       ecg.cod_cargo_comp, sc.nom_categoria
        into cargo_aux, O_STR
        from tb_evolu_ccomi_gfuncional ecg, tb_cargo ca, tb_categoria sc
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli = BEN_IDE_CLI_SERV
         and ecg.cod_entidade = COM_ENTIDADE
         and ecg.num_matricula = COM_MATRICULA
         and (PAR_PER_PRO >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.cod_cargo_comp = ca.cod_cargo
         and ecg.cod_ins = ca.cod_ins
         and ecg.cod_entidade = ca.cod_entidade
         and ecg.cod_pccs = ca.cod_pccs
         and sc.cod_categoria = ca.cod_categoria;

    exception
      when no_data_found then
        cargo_aux     := null;
        nom_categoria := null;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_CATEGORIA_OPCAO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o cargo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    end;

  END SP_OBTEM_CATEGORIA_OPCAO;
  ---------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_PADRAO_VENCIMENTO RETURN VARCHAR2 IS

  BEGIN
    begin
      select rr.cod_ref_pad_venc
        into vi_cod_ref_pad_venc
        from tb_referencia rr
       where rr.cod_entidade = COM_ENTIDADE
         and rr.cod_ins = PAR_COD_INS
         and rr.cod_pccs = COM_PCCS
         and rr.cod_quadro = COM_QUADRO
         and rr.cod_referencia = BEN_COD_REFERENCIA
         and (PAR_PER_PRO >= rr.dat_ini_vig and
             PAR_PER_PRO <=
             nvl(rr.dat_fim_vig, to_date('01/01/2045', 'dd/mm/yyyy')));
    exception
      when others then
        vi_cod_ref_pad_venc := ' ';
    end;

    return vi_cod_ref_pad_venc;

  END SP_OBTEM_PADRAO_VENCIMENTO;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PERCENTUAL_CARGO(O_VALOR OUT NUMBER) AS

  BEGIN
    BEGIN
      select rmc.val_percentual
        into o_valor
        from tb_rep_mil_cargo rmc
       where rmc.cod_ins = PAR_COD_INS
         and rmc.cod_entidade = COM_ENTIDADE
            --   and rmc.cod_cargo = COM_CARGO
         and rmc.cod_cargo = COM_CARGO_APOS
         and (PAR_PER_PRO >= rmc.dat_ini and
             PAR_PER_PRO <=
             nvl(rmc.dat_fim, to_date('01/01/2045', 'dd/mm/yyyy')));
    exception
      when others then
        o_valor := 0;
    end;

    idx_elemento := 3;

  END SP_OBTEM_PERCENTUAL_CARGO;
  ---------------------------------------------------------------------------------

FUNCTION SP_OBTEM_QTD_DIAS_AFAST
    RETURN NUMBER IS
    V_DIAS_TRAB  NUMBER;

    BEGIN

         SELECT  FNC_GET_DIAS_MENOR_30(NVL((SUM(QTD_DIAS)),0))
           INTO V_DIAS_TRAB
           FROM (

           SELECT
          ((CASE WHEN (F2.DAT_INI_AFAST <= PAR_PER_PRO)
           AND (F2.DAT_RET_PREV <= ADD_MONTHS(PAR_PER_PRO,1)-1)
            THEN (TO_DATE(F2.DAT_RET_PREV) - TO_DATE(PAR_PER_PRO))

       WHEN (F2.DAT_INI_AFAST <= PAR_PER_PRO) AND
            ((F2.DAT_RET_PREV > ADD_MONTHS(PAR_PER_PRO,1)-1))
        THEN
        ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
             29
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((F2.DAT_INI_AFAST > PAR_PER_PRO) AND
            (F2.DAT_RET_PREV > ADD_MONTHS(PAR_PER_PRO,1)-1))
                      THEN
        ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
              30 - TO_CHAR(F2.DAT_INI_AFAST, 'DD')
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - F2.DAT_INI_AFAST


       WHEN (F2.DAT_INI_AFAST <= PAR_PER_PRO) AND
            (
            ((F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1)
                AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('30','31')) OR

            (F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1
                AND (TO_CHAR(F2.DAT_RET_PREV, 'MM') = '02' AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('28', '29')))
             )

                      THEN
         ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
               29
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((F2.DAT_INI_AFAST > PAR_PER_PRO) AND
            (((F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1) AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('30','31')) OR
            (F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(F2.DAT_RET_PREV, 'MM') = '02' AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('28', '29'))))
                      THEN
           ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
              30 - TO_CHAR(F2.DAT_INI_AFAST, 'DD')
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - F2.DAT_INI_AFAST


      ELSE  (F2.DAT_RET_PREV - F2.DAT_INI_AFAST) END)+1) AS QTD_DIAS
              FROM TB_AFASTAMENTO F2,
                   TB_PARAM_MOTIVO_AFAST F3
             WHERE PAR_PER_PRO BETWEEN
               TO_DATE('01/'||to_char( F2.DAT_INI_AFAST,'MM/YYYY'),'DD/MM/YYYY')
               AND F2.DAT_RET_PREV
               AND F2.COD_IDE_CLI      = COM_COD_IDE_CLI
               AND F2.COD_ENTIDADE     = COM_ENTIDADE
               AND F2.NUM_MATRICULA    = COM_NUM_MATRICULA
               AND F2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
               AND F3.COD_MOT_AFAST = F2.COD_MOT_AFAST
               AND F3.FLG_DESCONTA_FOLHA = 'S'
                ---Yumi em 20/08/2018: colocado para n?o confundir com as faltas injustificadadas
               AND F2.COD_MOT_AFAST   not in (85)
               ) TB1
            ;
      IF V_DIAS_TRAB < 0 THEN
        V_DIAS_TRAB:=0;

      END IF;
      RETURN (V_DIAS_TRAB);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);
              WHEN OTHERS THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);

  END SP_OBTEM_QTD_DIAS_AFAST;

  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PROPORCAO_JORNADA(i_num_funcao in number,
                                       O_VALOR      OUT NUMBER) AS

  BEGIN

    QTD_HORAS_JORNADA := 0;

    BEGIN
      select jo.val_valor_percentual, jo.num_horas_mes
        into o_valor, QTD_HORAS_JORNADA
        from tb_jornada jo
       where jo.cod_ins = PAR_COD_INS
         and jo.cod_jornada = COM_COD_JORNADA;

      FOR i IN 1 .. nom_variavel.count LOOP

        IF nom_variavel(i) = COM_COL_INFORMACAO THEN
          val_variavel(i) := QTD_HORAS_JORNADA;
          v_qtd_horas := QTD_HORAS_JORNADA;
          exit;
        END IF;

      END LOOP;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        o_valor := 1;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_PROPORCAO_JORNADA';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter a proporcao da jornada';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_OBTEM_PROPORCAO_JORNADA;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_QTD_HORAS(i_num_funcao in number, O_VALOR OUT NUMBER) AS
  BEGIN
    begin
    select DECODE(I_NUM_FUNCAO, 17, j.num_horas_mes)
      into o_valor
      from tb_jornada j
     where j.cod_jornada = COM_COD_JORNADA
       and j.cod_ins = PAR_COD_INS;

    exception
      when no_data_found then
        o_valor := 0;
        p_sub_proc_erro := 'SP_OBTEM_QTD_HORAS';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter qtd horas no mes-valor zerado';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
      when others then
        p_sub_proc_erro := 'SP_OBTEM_QTD_HORAS';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter qtd horas no mes';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    end;




  END SP_OBTEM_QTD_HORAS;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPOS_ATRIBUTOS(num_funcao      in number,
                                     i_num_matricula in number,
                                     i_entidade      in number,
                                     i_cargo         in number,
                                     O_STR           OUT VARCHAR2) AS

  BEGIN
    begin
      select distinct 'S'
        into o_str
        from tb_atributos_pf    ats, --tb_atributos_serv ats,
             tb_tipos_atributos ta
       where --ats.cod_beneficio = com_cod_beneficio --RAO 20060207 Atributos por pessoa
      -- and
       ats.cod_ins = par_cod_ins
       and (ats.cod_ide_cli = ben_ide_cli_serv or ats.cod_ide_cli = ant_ide_cli) --RAO 20060216
       and ats.cod_atributo = ta.cod_atributo
       and decode(num_funcao,
              15,
              1000,
              29,
              2000,
              33,
              3000,
              34,
              4000,
              35,
              5000,
              36,
              6000,
              37,
              7000,
              70,
              9000,
              78,
              10000,
              414,
              11000) = ta.cod_atributo
       and (PAR_PER_PRO >= ats.dat_ini_vig and
       PAR_PER_PRO <=
       nvl(ats.dat_fim_vig, to_date('01/01/2045', 'DD/MM/YYYY')));
    exception
      when no_data_found then
        o_str := 'N';
      when others then
        p_sub_proc_erro := 'SP_OBTEM_TIPOS_ATRIBUTOS';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter atributos do servidor';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    end;

  END SP_OBTEM_TIPOS_ATRIBUTOS;

  ----------------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPOS_ATRIBUTOS_prev(num_funcao      in number,
                                          i_num_matricula in number,
                                          i_entidade      in number,
                                          i_cargo         in number,
                                          O_STR           OUT VARCHAR2) AS

  BEGIN
    begin
      select distinct 'S'
        into o_str
        from tb_atributos_pf    ats, --tb_atributos_serv ats,
             tb_tipos_atributos ta
       where --ats.cod_beneficio = com_cod_beneficio --RAO 20060207 Atributos por pessoa
      -- and
       ats.cod_ins = par_cod_ins
       and (ats.cod_ide_cli = prev_ide_cli) --RAO 20060216
       and ats.cod_atributo = ta.cod_atributo
       and
         (
         decode(num_funcao,
              15, 1000,
              29, 2000,
              33, 3000,
              34, 4000,
              35, 5000,
              36, 6000,
              37, 7000,
              70, 9000,
              78, 10000,
              500,12000,
              13 ,13000) = ta.cod_atributo --  JTS AGREGA CODIGO 6000 7-2010
            OR
           decode(num_funcao,
               35,
              6000,
               371,
               7001,
               372,
               7002,
               500,
               12001
            ) = ta.cod_atributo
           OR
           decode(num_funcao,
                500,
               12002
            ) = ta.cod_atributo
        )
       and (PAR_PER_PRO >= ats.dat_ini_vig
       and ats.flg_status <> 'C'
       and PAR_PER_PRO <=
       nvl(ats.dat_fim_vig, to_date('01/01/2045', 'DD/MM/YYYY')));
    exception
      when no_data_found then
        o_str := 'N';
      when others then
        p_sub_proc_erro := 'SP_OBTEM_TIPOS_ATRIBUTOS';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter os tipos de atributos do servidor';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    end;

  END SP_OBTEM_TIPOS_ATRIBUTOS_prev;

  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_BASE_CCOMIG(i_num_funcao in number,
                                      o_valor      out number) AS

    v_val_vencimento     number(18, 4) := 0;
    v_val_vencimento_rep number(18, 4) := 0;

  BEGIN
    BEGIN
      select /*+ RULE */
      -- RAO : 20060322
      --    v.val_vencimento,
       sum(v.val_vencimento * (case
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
              and to_number(to_char(v.dat_fim_vig, 'dd')) < 31 then
              to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                  30
             when v.dat_fim_vig is null and v.dat_ini_vig < PAR_PER_PRO then
             --to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd'))  --ROD13 comentado
              30 --ROD13 incluido
             when to_char(v.dat_ini_vig, 'YYYYMM') <
                  to_char(PAR_PER_PRO, 'YYYYMM') then
             --31                                                        --ROD13 comentado
              30 --ROD13 incluido
             else
             -- to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')) -  --ROD13 comentado
              30 - --ROD13 incluido
              to_number(to_char(v.dat_ini_vig, 'dd')) + 1
           end) / 30), --ROD13 incluido divisao por 30
       -- / to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')),
       -- RAO : 20060322
       v.val_vencimento_rep
        into v_val_vencimento, v_val_vencimento_rep
        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli = BEN_IDE_CLI_SERV -- efv 02032007
         and (PAR_PER_PRO >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.num_matricula = COM_MATRICULA
         and ecg.cod_ide_rel_func = BEN_IDE_REL_FUNC
         and ecg.cod_entidade = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V'
       group by v.val_vencimento_rep
      --RAO : 20060322
      ;
      IF v_val_vencimento > v_sal_base(com_cod_beneficio) (1) THEN
        O_VALOR := v_val_vencimento * VI_PROP_BEN;
      ELSIF v_val_vencimento < v_sal_base(com_cod_beneficio) (1) then
        O_VALOR := v_sal_base(com_cod_beneficio) (1) * VI_PROP_BEN;
      ELSE
        O_VALOR := v_val_vencimento * VI_PROP_BEN;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia);
        O_VALOR := O_VALOR * VI_PROP_BEN;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VENC_CCOMI_GRATIF';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter vencimento comissao gratificada';
    end;

  END SP_OBTEM_VENC_BASE_CCOMIG;
  ---------------------------------------------------------------------------------

  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF(i_num_funcao in number,
                                       o_valor      out number) AS

    v_val_vencimento     number(18, 4) := 0;
    v_val_vencimento_rep number(18, 4) := 0;

  BEGIN
    BEGIN
      select /*+ RULE */
      -- RAO : 20060322
      --    v.val_vencimento,
       sum(v.val_vencimento * (case
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
              and to_number(to_char(v.dat_fim_vig, 'dd')) < 31 then
              to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                  30
             when v.dat_fim_vig is null and v.dat_ini_vig < PAR_PER_PRO then
             --to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd'))      --Rod13 coment
              30
             when to_char(v.dat_ini_vig, 'YYYYMM') <
                  to_char(PAR_PER_PRO, 'YYYYMM') then
             --31                                                            --Rod13 coment
              30 --Rod13 incluido
             else
             -- to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')) -   --Rod13 coment
              30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
           end) / 30), --Rod13 incluido
       -- to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')),          --Rod13 coment
       -- RAO : 20060322
       v.val_vencimento_rep
        into v_val_vencimento, v_val_vencimento_rep
        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli = BEN_IDE_CLI_SERV -- efv 02032007
         and (PAR_PER_PRO >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.num_matricula = COM_MATRICULA
         and ecg.cod_entidade = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V'
       group by v.val_vencimento_rep
      --RAO : 20060322
      ;
      IF v_val_vencimento > v_val_vencimento_rep THEN
        O_VALOR := v_val_vencimento;
      ELSIF v_val_vencimento < v_val_vencimento_rep then
        O_VALOR := v_val_vencimento_rep;
      ELSE
        O_VALOR := v_val_vencimento;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia);

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VENC_CCOMI_GRATIF';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter vencimento comissao gratificada';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_VENC_CCOMI_GRATIF;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF_RF(i_num_funcao in number,
                                          o_valor      out number) AS

    v_val_vencimento     number(18, 4) := 0;
    v_val_vencimento_rep number(18, 4) := 0;

  BEGIN
    BEGIN
      SELECT
      -- RAO : 20060322
      --  V.VAL_VENCIMENTO,
       sum(v.val_vencimento * (case
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
              and to_number(to_char(v.dat_fim_vig, 'dd')) < 31 then
              to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                  30
             when v.dat_fim_vig is null and v.dat_ini_vig < PAR_PER_PRO then
             --to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd'))
              30
             when to_char(v.dat_ini_vig, 'YYYYMM') <
                  to_char(PAR_PER_PRO, 'YYYYMM') then
             --31                                                            --Rod13 coment
              30
             else
             -- to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')) -   --Rod13 coment
              30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
           end) / 30),
       -- to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')),                  --Rod13 coment
       -- RAO : 20060322
       V.VAL_VENCIMENTO_REP
        into v_val_vencimento, v_val_vencimento_rep
        FROM TB_RELACAO_FUNCIONAL RF, TB_VENCIMENTO V
       WHERE RF.COD_INS = PAR_COD_INS
         AND RF.NUM_MATRICULA = COM_MATRICULA
         AND RF.COD_IDE_CLI = BEN_IDE_CLI_SERV -- efv 02032007
         AND RF.COD_ENTIDADE = COM_ENTIDADE
         AND RF.COD_CARGO = COM_CARGO
         AND RF.COD_PCCS = COM_PCCS
         AND V.COD_ENTIDADE = RF.COD_ENTIDADE
         AND V.COD_REFERENCIA = BEN_COD_REFERENCIA
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V'
       group by v.val_vencimento_rep
      --RAO : 20060322
      ;
      --   and tip_provimento = 3;  RAO 20060113 erro em rubrica 1400

      IF v_val_vencimento > v_val_vencimento_rep THEN
        O_VALOR := v_val_vencimento;
      ELSIF v_val_vencimento < v_val_vencimento_rep then
        O_VALOR := v_val_vencimento_rep;
      ELSE
        O_VALOR := v_val_vencimento;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VENC_CCOMI_GRATIF_RF';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter vencimento comissao gratificada RF';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_VENC_CCOMI_GRATIF_RF;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF_REP(i_num_funcao in number,
                                           o_valor      out number) AS

    v_val_vencimento     number(18, 4) := 0;
    v_val_vencimento_rep number(18, 4) := 0;

  BEGIN
    BEGIN
      select
      -- RAO : 20060322
/*       sum(v.val_vencimento * (case
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
              and to_number(to_char(v.dat_fim_vig, 'dd')) < 31 then
              to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                  30
             when v.dat_fim_vig is null and v.dat_ini_vig < PAR_PER_PRO then
             --to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd'))  --Rod13 coment
              30
             when to_char(v.dat_ini_vig, 'YYYYMM') <
                  to_char(PAR_PER_PRO, 'YYYYMM') then
             --31 --Rod13 coment
              30
             else
             --to_number(to_char(add_months(PAR_PER_PRO, 1) - 1, 'dd')) -  --Rod13 coment
              30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
           end) / 30)*/
       ROUND (sum((v.val_vencimento / 30) *(
       CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end)),2)

        into v_val_vencimento
        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli =  COM_COD_IDE_CLI -- efv 02032007
         and (add_months(PAR_PER_PRO, 1) - 1 >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.num_matricula   = COM_MATRICULA
         and ecg.cod_ide_rel_func= COM_COD_IDE_REL_FUNC
         and ecg.cod_entidade   = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
         and ecg.cod_cargo_comp not in(204,301,10,13,14,15)
           -- MVL : 20060417
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V';

      O_VALOR := v_val_vencimento;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia);

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VENC_CCOMI_GRATIF_REP';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter comissao gratificada por representacao';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_VENC_CCOMI_GRATIF_REP;
  ---------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENC_CCOMI_GRATIF_COR(i_num_funcao in number,
                                           o_valor      out number) AS

    v_val_vencimento     number(18, 4) := 0;
    v_val_vencimento_rep number(18, 4) := 0;

  BEGIN
    BEGIN
      select
        ROUND (sum((v.val_vencimento / 30) *(
       CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end)),2)

        into v_val_vencimento
        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli =  COM_COD_IDE_CLI -- efv 02032007
         and (add_months(PAR_PER_PRO, 1) - 1 >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.num_matricula   = COM_MATRICULA
         and ecg.cod_ide_rel_func= COM_COD_IDE_REL_FUNC
         and ecg.cod_entidade   = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
         and ecg.cod_cargo_comp in (204,301)
           -- MVL : 20060417
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V';

      O_VALOR := v_val_vencimento;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := SP_OBTEM_SALARIO_BASE_CARGO(ben_cod_referencia);

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VENC_CCOMI_GRATIF_REP';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter comissao gratificada por representacao';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_VENC_CCOMI_GRATIF_COR;
  ---------------------------------------------------------------------------------


  PROCEDURE SP_OBTEM_RELGRUPO(o_valor out number) AS
  BEGIN
    BEGIN
      select rg.cod_grupo
        into o_valor
        from tb_relgrupo rg, tb_concessao_beneficio cb
       where cb.cod_ins = PAR_COD_INS
         and cb.cod_ins = rg.cod_ins
         and cb.cod_beneficio = com_cod_beneficio
         and cb.cod_ide_cli_serv = ben_ide_cli_serv
         and cb.num_matricula = com_matricula
         and cb.cod_entidade = com_entidade
         and cb.cod_cargo = com_cargo
         and cb.cod_entidade = rg.cod_entidade
         and cb.cod_cargo = rg.cod_cargo
         and (PAR_PER_PRO >= rg.dat_ini and
             PAR_PER_PRO <=
             nvl(rg.dat_fim, to_date('01/01/2045', 'dd/mm/yyyy')));

      FOR i IN 1 .. nom_variavel.count LOOP

        IF nom_variavel(i) = COM_COL_INFORMACAO THEN
          val_variavel(i) := o_valor;
          v_val_percentual := o_valor;
          exit;
        END IF;

      END LOOP;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_RELGRUPO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter a relacao de grupo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;
  END;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_NOME_CARGO(o_str out varchar2) AS
  BEGIN
    Begin
      select ca.nom_cargo
        into o_str
        from tb_cargo ca
       where ca.cod_cargo = COM_CARGO
         and ca.cod_ins = PAR_COD_INS
         and ca.cod_entidade = COM_ENTIDADE
         and ca.cod_pccs = COM_PCCS;

      o_str := '''' || o_str || '''';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        o_str := null;
        o_str := '''' || o_str || '''';
      WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_OBTEM_NOME_CARGO';
        p_msgerro       := 'Erro ao obter o nome do cargo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_CODGRUPO_ABONO(o_valor out number) AS
  BEGIN
    BEGIN
      SELECT distinct GAC.COD_GRUPO
        INTO O_VALOR
        FROM TB_GRUPO_ABONO_CARGO GAC
       WHERE GAC.COD_INS = PAR_COD_INS
         AND GAC.COD_CARGO = COM_CARGO;

      FOR i IN 1 .. nom_variavel.count LOOP

        IF nom_variavel(i) = COM_COL_INFORMACAO THEN
          val_variavel(i) := o_valor;
          exit;
        END IF;

      END LOOP;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_CODGRUPO_ABONO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o grupo abono';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VALOR_ABONO(o_valor out number) AS

    i_valor number := 0;

  BEGIN
    BEGIN
      SELECT distinct GAV.VAL_VALOR
        INTO O_VALOR
        FROM TB_GRUPO_ABONO_VALOR GAV, TB_GRUPO_ABONO_CARGO GAC
       WHERE GAV.COD_INS = PAR_COD_INS
         AND GAV.COD_GRUPO = GAC.COD_GRUPO
         AND GAC.COD_INS = GAV.COD_INS
         AND GAC.COD_CARGO = COM_CARGO
         AND (GAV.COD_SETOR is null or
             (GAV.COD_SETOR = '0211' or GAV.COD_SETOR = '0212'))
         AND (PAR_PER_PRO >= GAC.DAT_INI AND
             PAR_PER_PRO <=
             nvl(GAC.DAT_FIM, to_date('01/01/2045', 'dd/mm/yyyy')))
         AND (PAR_PER_PRO >= GAV.DAT_INI AND
             PAR_PER_PRO <=
             nvl(GAV.DAT_FIM, to_date('01/01/2045', 'dd/mm/yyyy')));

      FOR i IN 1 .. nom_variavel.count LOOP

        IF nom_variavel(i) = COM_COL_INFORMACAO THEN
          BEGIN
            SELECT distinct GAC.COD_GRUPO
              INTO I_VALOR
              FROM TB_GRUPO_ABONO_CARGO GAC
             WHERE GAC.COD_INS = PAR_COD_INS
               AND GAC.COD_CARGO = COM_CARGO
               AND (PAR_PER_PRO >= GAC.DAT_INI AND
                   PAR_PER_PRO <=
                   nvl(GAC.DAT_FIM, to_date('01/01/2045', 'dd/mm/yyyy')));

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              I_VALOR := 0;
          END;
          val_variavel(i) := i_valor;
          v_val_percentual := i_valor;
          exit;
        END IF;

      END LOOP;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VALOR_ABONO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o valor do abono';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPO_ABONO(o_str out varchar2) AS
  BEGIN
    BEGIN
      SELECT distinct GAV.COD_TIPO
        INTO O_STR
        FROM TB_GRUPO_ABONO_VALOR GAV, TB_GRUPO_ABONO_CARGO GAC
       WHERE GAV.COD_INS = PAR_COD_INS
         AND GAV.COD_GRUPO = GAC.COD_GRUPO
         AND GAC.COD_INS = GAV.COD_INS
         AND GAC.COD_CARGO = COM_CARGO
         AND (PAR_PER_PRO >= GAC.DAT_INI AND
             PAR_PER_PRO <=
             nvl(GAC.DAT_FIM, to_date('01/01/2045', 'dd/mm/yyyy')))
         AND (PAR_PER_PRO >= GAV.DAT_INI AND
             PAR_PER_PRO <=
             nvl(GAV.DAT_FIM, to_date('01/01/2045', 'dd/mm/yyyy')));

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_STR := '';

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_TIPO_ABONO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o Tipo de Abono';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VENCIMENTO(cod_refer in number, o_valor out number) AS
  BEGIN
    BEGIN
      SELECT case
               when V.VAL_VENCIMENTO_REP > V.VAL_VENCIMENTO then
                V.VAL_VENCIMENTO_REP
               when V.VAL_VENCIMENTO >= V.VAL_VENCIMENTO_REP then
                V.VAL_VENCIMENTO
             end
        INTO O_VALOR
        FROM TB_VENCIMENTO V
       WHERE V.COD_INS = PAR_COD_INS
         AND V.COD_ENTIDADE = COM_ENTIDADE
         AND V.COD_REFERENCIA = COD_REFER
         AND (PAR_PER_PRO >= V.DAT_INI_VIG
             -- MVL
             AND PAR_PER_PRO <=
             nvl(V.DAT_FIM_VIG, to_date('01/01/2045', 'dd/mm/yyyy')))
         AND V.FLG_STATUS = 'V'
      --     and nvl(v.dat_fim_vig,COM_DAT_VIG_RUBRICA) <= COM_DAT_VIG_RUBRICA )  -- MVL 20060417
      ;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VENCIMENTO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o valor do vencimento';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_VENCIMENTO;
  ---------------------------------------------------------------------------------
      PROCEDURE SP_OBTEM_IRRF(ide_cli    in varchar2,
                          idx_val    in number,
                          FLG_PA     IN VARCHAR2,
                          O_VALOR    OUT NUMBER,
                          O_VALOR_13 OUT NUMBER) AS

    VI_VAL_PAGOS        NUMBER(18, 4) := 0;
    VI_VAL_DED_LEGAIS   NUMBER(18, 4) := 0;

    VI_ISENTO           boolean := TRUE;
    nEdad               number;
    nIni                number;
    nFin                number;
    vi_rubrica          number := 0;
    vi_val_rubrica      number := 0;
    vi_seq_vig          number := 0;
    valor_proc_especial NUMBER(18, 4) := 0;
    DAT_PERIODO_PAG     date;
    PARAMETRO_IR        CHAR(1);
  BEGIN

    vi_val_pagos := 0;

    nEdad   := 0;
    nIni    := 0;
    nFin    := 0;
    o_valor := 0;

    IF  FLG_PA  ='A' THEN
       PARAMETRO_IR:='A';
    ELSIF FLG_PA ='D' THEN
      PARAMETRO_IR:='D';
    ELSIF FLG_PA ='E' THEN
      PARAMETRO_IR:='E';
    ELSE
     PARAMETRO_IR:='A';
     END IF;

    IF FLG_PA = 'S' THEN
      vi_base_ir    := v_valor_total_pa;
      vi_base_ir_13 := v_valor_total_pa;
    ELSE
      SP_OBTEM_BASE_IR(idx_val,PARAMETRO_IR, vi_base_ir, vi_base_ir_13);
    END IF;

    vi_base_bruta    := vi_base_ir;
    vi_base_bruta_13 := vi_base_ir_13;

    VI_TOT_DED         := 0;
    VI_TOT_DED_RUB     :=0;
    VI_TOT_DED_RUB_REAL:=0;
    --- Obtem valores deduc?es
    -- Enfermidade grave
    -- judicial (isenc?o)
    IF sp_isenta_irrf(ide_cli) <> VI_ISENTO THEN
       IF NOT VI_IR_EXTERIOR THEN
              -- Maior 65
             --- Verifica Grupo de Pagamento e Data de Pagamento.
                FOR I IN 1 ..  tgrup.COUNT LOOP
                 IF  VFOLHA.COUNT  >0 THEN
                  IF tgrup(i).NUM_GRP_PAG =VFOLHA(1).NUM_GRP THEN
                     DAT_PERIODO_PAG :=tgrup(i).DAT_PAGAMENTO;
                     EXIT;
                   END IF;
                 END IF;
                 END LOOP;
                 IF   DAT_PERIODO_PAG IS NULL OR
                      DAT_PERIODO_PAG < PAR_PER_PRO THEN
                      DAT_PERIODO_PAG:=PAR_PER_PRO;
                 END IF;

              nFin  := to_char(ANT_DTA_NASC, 'yyyymmdd');
              nIni  := to_char(last_day(DAT_PERIODO_PAG), 'yyyymmdd');
              nEdad := (nIni - nFin) / 10000;
              IF nEdad >= 65 THEN
                VI_TOT_DED := V_DED_IR_65;
              END IF;

              -- Dependentes
              VI_NUM_DEP_ECO := 0;
              IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
                VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(IDE_CLI, 'A');
              ELSE
                VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(IDE_CLI, 'P');
              END IF;

              IF VI_NUM_DEP_ECO > 0 THEN
                VI_TOT_DED := nvl(VI_TOT_DED, 0) + (V_DED_IR_DEP * VI_NUM_DEP_ECO);
              END IF;
       END IF;
			 
		 IF NOT  SP_IRRF_SIMPLIFICADO(ide_cli) THEN
		 			 
      IF FLG_PA = 'S' THEN
        vi_val_pagos       := 0;
         vi_val_ded_legais :=0;
      else
        -- Rubricas que deduzem no IR
        vi_val_pagos := SP_OBTEM_DED_PAGOS_IRRF(PARAMETRO_IR);--SP_OBTEM_DED_PAGOS;
      --Soma valores de deducoes legais
        vi_val_ded_legais := SP_OBTEM_DED_LEGAIS_IRRF(PARAMETRO_IR);
      end if;

     -- VERIFICA SE A SOMA DE DEDUCOES LEGAIS + 65 Anos + DEP ?enor que O VALOR DE DESCONTO SIMPLIFICADO
        -- em caso positivo somanos a diferen?nos valores pagos

        IF (NVL(VI_TOT_DED, 0) + NVL(VI_VAL_DED_LEGAIS,0)) < NVL(V_DESC_SIMP_IR,0) THEN
            VI_TOT_DED_RUB_REAL := vi_val_pagos;
             IF ((VI_VAL_PAGOS - NVL(VI_VAL_DED_LEGAIS,0))) >0  THEN
                 VI_TOT_DED          :=  NVL(V_DESC_SIMP_IR,0) +(VI_VAL_PAGOS - NVL(VI_VAL_DED_LEGAIS,0));
                 VI_TOT_DED_RUB      := VI_TOT_DED;
	 --				 ELSIF NOT   SP_IRRF_SIMPLIFICADO(ide_cli) THEN
             ELSE
                 VI_TOT_DED          :=  NVL(V_DESC_SIMP_IR,0);
                 VI_TOT_DED_RUB      := VI_TOT_DED;
             END IF;
            IF VI_TOT_DED  < 0 THEN
               VI_TOT_DED_RUB_REAL :=0;
                VI_TOT_DED    :=0;
                VI_TOT_DED_RUB:=VI_TOT_DED;
            END IF;
        ELSE
               IF vi_val_pagos > 0 THEN
                VI_TOT_DED_RUB_REAL := vi_val_pagos;
                VI_TOT_DED          := VI_TOT_DED + vi_val_pagos;
                VI_TOT_DED_RUB      :=VI_TOT_DED;
              END IF;
        END IF;
	      ELSE
            vi_val_pagos := SP_OBTEM_DED_PAGOS_IRRF(PARAMETRO_IR);--SP_OBTEM_DED_PAGOS;
            
            
             IF FLG_PA = 'S' THEN
                vi_val_pagos       := 0;
                vi_val_ded_legais  :=0;
             END IF;
             IF vi_val_pagos > 0 THEN
                      VI_TOT_DED_RUB_REAL := vi_val_pagos;
                      VI_TOT_DED          := VI_TOT_DED + vi_val_pagos;
                      VI_TOT_DED_RUB      := VI_TOT_DED;
             END IF;   			
				END IF;						
      --- Obtem Base IRRF
      --     sp_composicao ('BASE_IRRF', VI_BASE_IR);
      IF VI_BASE_IR > VI_TOT_DED THEN
        VI_BASE_IR := nvl(VI_BASE_IR, 0) - VI_TOT_DED;
        --- Obtem valor IR
        SP_CALCULA_IMPOSTO2(vi_base_ir, o_valor);
      END IF;

      IF VI_BASE_IR_13 > VI_TOT_DED THEN
        vi_base_ir_13 := vi_base_ir_13 - VI_TOT_DED;
        IF VI_TEM_SAIDA OR PAR_TIP_PRO = 'T' or  PARAMETRO_IR='D' THEN
          SP_CALCULA_IMPOSTO2(vi_base_ir_13, o_valor_13);
        END IF;
      END IF;
  
	
	   ELSE
      IF VI_DOENCA THEN
        V_DED_IR_DOENCA := VI_BASE_IR;
        VI_BASE_IR      := 0;
      ELSE
        V_BASE_ISENCAO  := VI_BASE_IR;
        V_DED_IR_DOENCA := 0;
        VI_BASE_IR      := 0;
      END IF;
    END IF;
    -- Agregado para Calculo de IR


  END SP_OBTEM_IRRF;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_BASE_IR(idx        in number,
                             tipo_irr   in varchar,
                             vi_base_ir out number,
                             base_ir_13 out number
                              ) as

    i           number := 0;
    j           number := 0;
    iver        number := 0;
    cod_ben_ant number := 0;
    cod_ben_atu number := 0;
    v_inicio    char(1) := 'S';
    DAT_INICIO_IRRF DATE:=NULL;
    DAT_TERMINO_IRRF DATE:=NULL;


  BEGIN
    BEGIN
      FOR i IN 1 .. cod_con2.count LOOP
        iver :=cod_con2.count;
        IF PAR_TIP_PRO <> 'E' THEN
          IF (par_tip_pro = 'T' OR   tipo_irr='D') AND flag_base2(i) = 'S' THEN
            FOR j IN 1 .. idx LOOP

                 irdcn := case
                               when tipo_irr ='A' then  tdcn_irrf(j)
                               when tipo_irr ='R' then  tdcn_irrf_RETRO(j)
                               when tipo_irr ='D' then  tdcn_irrf_RETRO13(j)

                              else tdcn(j) end;
              IF irdcn.per_processo = PAR_PER_PRO THEN
                IF cod_rub2(i) = irdcn.cod_fcrubrica  /*AND
                   cod_entidade(i) = irdcn.cod_entidade */ THEN -- ANT_ENTIDADE THEN
                  IF ( tip_evento2(i) = 'T' or tipo_irr='D') AND irdcn.flg_natureza = 'C' THEN
                    base_ir_13 := nvl(base_ir_13, 0) + irdcn.val_rubrica;
                    IF V_CALCULO_IR = 'S' THEN
                      VI_BASE_IR_ARR_13(irdcn.cod_ide_rel_func)(1) := VI_BASE_IR_ARR_13(irdcn.cod_ide_rel_func)
                                                                   (1) +
                                                                   irdcn.val_rubrica;

                    END IF;
                  ELSIF ( tip_evento2(i) = 'T' or tipo_irr='D') AND irdcn.flg_natureza = 'D' THEN
                    IF irdcn.cod_fcrubrica<>1860702 THEN  ---- incluido por ROD DEZ09
                      base_ir_13 := nvl(base_ir_13, 0) - irdcn.val_rubrica;
                      IF V_CALCULO_IR = 'S' THEN
                        VI_BASE_IR_ARR_13(irdcn.cod_ide_rel_func)(1) := VI_BASE_IR_ARR_13(irdcn.cod_ide_rel_func)
                                                                     (1) -
                                                                     irdcn.val_rubrica;


                      END IF;
                    END IF;                                ---- incluido por ROD DEZ09
                  END IF;
                END IF;
              END IF;
            END LOOP;
          ELSIF flag_base2(i) = 'S' THEN
            FOR j IN 1 .. idx LOOP
              irdcn := case
                               when tipo_irr ='A' then  tdcn_irrf(j)
                               when tipo_irr ='R' then  tdcn_irrf_RETRO(j)
                               when tipo_irr ='D' then  tdcn_irrf_RETRO13(j)

                               else tdcn(j) end;
              IF irdcn.per_processo = PAR_PER_PRO THEN
                IF cod_rub2(i) = irdcn.cod_fcrubrica /* AND
                   cod_entidade(i) = irdcn.cod_entidade */ THEN --ANT_ENTIDADE THEN
                  IF irdcn.flg_natureza = 'C'
                     -- Modificado por IR ACUMULADO
                     AND tip_evento_especial2(i) <> 'T' AND par_tip_pro <> 'T'
                    THEN
                    vi_base_ir := nvl(vi_base_ir, 0) + irdcn.val_rubrica;
                    IF V_CALCULO_IR = 'S' THEN
                      begin
                        VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)(1) := VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)
                                                                  (1) +
                                                                  irdcn.val_rubrica;



                         IF DAT_INICIO_IRRF IS NULL OR irdcn.dat_ini_ref <DAT_INICIO_IRRF THEN
                             DAT_INICIO_IRRF :=irdcn.dat_ini_ref ;
                          END IF;
                          IF DAT_TERMINO_IRRF   IS NULL OR irdcn.dat_fim_ref >DAT_TERMINO_IRRF   THEN
                           DAT_TERMINO_IRRF  :=irdcn.dat_FIM_ref ;
                          END IF;
                          IF  tipo_irr ='R' THEN
                            tdcn_irrf_RETRO(j).FLG_IR_ACUMULADO :='S';
                            tdcn(j).FLG_IR_ACUMULADO            :='S';
                          END IF;
                       exception
                        when others then
                          p_sub_proc_erro := 'SP_OBTEM_BASE_IR';
                          p_coderro       := SQLCODE;
                          P_MSGERRO       := SQLERRM ||' : Erro na inclusao do array da base de IR';
                          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'Calcula Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                irdcn.cod_ide_cli,
                                                irdcn.cod_fcrubrica);

                          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

                      end;
                    END IF;
                  ELSIF tip_evento_especial2(i) <> 'T' AND
                        irdcn.flg_natureza = 'D' AND par_tip_pro <> 'T' THEN
                    vi_base_ir := nvl(vi_base_ir, 0) - irdcn.val_rubrica;
                    IF V_CALCULO_IR = 'S' THEN
                      begin
                        VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)(1) := VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)
                                                                  (1) -
                                                                  irdcn.val_rubrica;
                         IF DAT_INICIO_IRRF IS NULL OR irdcn.dat_ini_ref <DAT_INICIO_IRRF THEN
                             DAT_INICIO_IRRF :=irdcn.dat_ini_ref ;
                          END IF;
                          IF DAT_TERMINO_IRRF   IS NULL OR irdcn.dat_fim_ref >DAT_TERMINO_IRRF   THEN
                           DAT_TERMINO_IRRF  :=irdcn.dat_FIM_ref ;
                          END IF;
                          IF  tipo_irr ='R' THEN
                            tdcn_irrf_RETRO(j).FLG_IR_ACUMULADO :='S';
                            tdcn(j).FLG_IR_ACUMULADO            :='S';
                           END IF;
                     exception
                        when others then
                          p_sub_proc_erro := 'SP_OBTEM_BASE_IR';
                          p_coderro       := SQLCODE;
                          P_MSGERRO       := 'Erro na inclusao do array da base de IR';
                          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'Calcula Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                irdcn.cod_ide_cli,
                                                irdcn.cod_fcrubrica);

                          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                      end;
                    END IF;
                  ELSE
                    base_ir_13 := nvl(base_ir_13, 0) + irdcn.val_rubrica;
                  END IF;
                END IF;
              END IF;
            END LOOP;
          ELSIF flag_base2(i) = 'N' AND tip_evento_especial2(i) = 'T' AND
                par_tip_pro <> 'T' THEN
            FOR j IN 1 .. idx LOOP
              irdcn := case
                               when tipo_irr ='A' then  tdcn_irrf(j)
                               when tipo_irr ='R' then  tdcn_irrf_RETRO(j)
                               when tipo_irr ='D' then  tdcn_irrf_RETRO13(j)

                                else tdcn(j) end;
              IF irdcn.per_processo = PAR_PER_PRO THEN
                IF cod_rub2(i) = irdcn.cod_fcrubrica  /* AND
                   cod_entidade(i) = irdcn.cod_entidade */ THEN --ANT_ENTIDADE THEN
                  base_ir_13 := nvl(base_ir_13, 0) + irdcn.val_rubrica;
                  VI_BASE_IR_ARR_13(irdcn.cod_ide_rel_func)(1) := VI_BASE_IR_ARR_13(irdcn.cod_ide_rel_func)
                                                               (1) +
                                                               irdcn.val_rubrica;
                END IF;
              END IF;
            END LOOP;
          END IF;
        ELSE
          IF flag_base2(i) = 'S' THEN
            FOR j IN 1 .. idx LOOP
               irdcn := case
                               when tipo_irr ='A' then  tdcn_irrf(j)
                               when tipo_irr ='R' then  tdcn_irrf_RETRO(j)
                               when tipo_irr ='D' then  tdcn_irrf_RETRO13(j)
                             else tdcn(j) end;
              IF irdcn.per_processo = PAR_PER_PRO THEN
                IF cod_rub2(i) = irdcn.cod_fcrubrica /* AND
                   cod_entidade(i) = irdcn.cod_entidade*/  THEN --ANT_ENTIDADE THEN
                  IF irdcn.flg_natureza = 'C' AND
                     tip_evento_especial2(i) <> 'T' THEN
                    vi_base_ir := nvl(vi_base_ir, 0) + irdcn.val_rubrica;
                    IF V_CALCULO_IR = 'S' THEN
                      IF v_inicio = 'S' THEN
                        VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)(1) := irdcn.val_rubrica;
                        v_inicio := 'N';
                      ELSE
                        VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)(1) := VI_BASE_IR_ARR(irdcn.cod_ide_rel_func)
                                                                  (1) +
                                                                  irdcn.val_rubrica;
                      END IF;
                      IF DAT_INICIO_IRRF IS NULL OR irdcn.dat_ini_ref <DAT_INICIO_IRRF THEN
                         DAT_INICIO_IRRF :=irdcn.dat_ini_ref ;
                      END IF;
                      IF DAT_TERMINO_IRRF   IS NULL OR irdcn.dat_fim_ref >DAT_TERMINO_IRRF   THEN
                       DAT_TERMINO_IRRF  :=irdcn.dat_FIM_ref ;
                      END IF;

                    END IF;
                  ELSE
                    base_ir_13 := nvl(base_ir_13, 0) + irdcn.val_rubrica;
                  END IF;
                END IF;
              END IF;
            END LOOP;
          END IF;
        END IF;
      END LOOP;



      IF tipo_irr ='R' THEN
         DAT_INI_IRRF_RETRO  :=DAT_INICIO_IRRF;
         DAT_FIM_IRRF_RETRO  :=DAT_TERMINO_IRRF ;
      END IF;

       exception
        when others then
          p_sub_proc_erro := 'SP_OBTEM_BASE_IR';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro no  IR Novo';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                irdcn.cod_ide_cli,
                                irdcn.cod_fcrubrica);

       end;
   END sp_obtem_base_ir;
  ----------------------------------------------------------------------------------

  FUNCTION SP_OBTEM_DED_PAGOS RETURN NUMBER IS
    O_VALOR NUMBER(18, 4);
    i       number := 0;
  BEGIN
    O_VALOR := 0;

    FOR i IN 1 .. tdcn.count LOOP
      rdcn := tdcn(i);
      ant_entidade:=RDCN.COD_ENTIDADE;
      IF SP_DED_IR(rdcn.cod_fcrubrica) and rdcn.per_processo = PAR_PER_PRO THEN
        o_valor := o_valor + rdcn.val_rubrica;
        IF rdcn.NUM_ORD_JUD IS NOT NULL THEN
          IF SP_DED_IR_PA(rdcn.cod_fcrubrica, rdcn.NUM_ORD_JUD) THEN
            V_DED_IR_PA := V_DED_IR_PA + rdcn.val_rubrica;
          END IF;
        END IF;
      END IF;
    END LOOP;

    RETURN(O_VALOR);
  END SP_OBTEM_DED_PAGOS;
  -----------------------------

  FUNCTION SP_OBTEM_DED_PAGOS_SEMPA RETURN NUMBER IS
    O_VALOR NUMBER(18, 4);
    i       number := 0;
  BEGIN
    O_VALOR := 0;

    FOR i IN 1 .. tdcn.count LOOP
      rdcn := tdcn(i);
      ant_entidade:=RDCN.COD_ENTIDADE;
      IF SP_DED_IR(rdcn.cod_fcrubrica) and rdcn.per_processo = PAR_PER_PRO
         AND rdcn.cod_fcrubrica NOT IN (7800115,2200156)
         AND TRUNC(rdcn.cod_fcrubrica/100) NOT IN (78006,78007,78008,78009,78010,78030,78001)
         THEN
        o_valor := o_valor + rdcn.val_rubrica;
        IF rdcn.NUM_ORD_JUD IS NOT NULL THEN
          IF SP_DED_IR_PA(rdcn.cod_fcrubrica, rdcn.NUM_ORD_JUD) THEN
            V_DED_IR_PA := V_DED_IR_PA + rdcn.val_rubrica;
          END IF;
        END IF;
      END IF;
    END LOOP;

    RETURN(O_VALOR);
  END SP_OBTEM_DED_PAGOS_SEMPA ;
  ----------------------------------------------------------------------------------
  FUNCTION SP_DED_IR(I_NUM_FCRUBRICA NUMBER) RETURN BOOLEAN IS
    O_DED_IR BOOLEAN;

    i number := 0;

  BEGIN
    o_ded_ir := FALSE;

    FOR i IN 1 .. cod_con2.count LOOP
      IF cod_rub2(i) = i_num_fcrubrica /* AND
         cod_entidade(i)= ant_entidade */ THEN
        IF flag_ded2(i) = 'S' THEN
          O_DED_IR := TRUE;
        END IF;
      END IF;
    END LOOP;

    RETURN(o_ded_ir);
  END SP_DED_IR;
  ----------------------------------------------------------------------------------
  FUNCTION SP_DED_IR_PA(I_NUM_FCRUBRICA NUMBER, I_NUM_ORD_JUD NUMBER)
    RETURN BOOLEAN IS
    O_DED_IR BOOLEAN;

    i number := 0;

  BEGIN
    O_DED_IR := FALSE;

    BEGIN
      SELECT COUNT(1)
        INTO I
        FROM TB_COMPOSICAO_OJ CO, TB_ORDEM_JUDICIAL OJ
       WHERE CO.COD_INS = PAR_COD_INS
         AND CO.NUM_ORD_JUD = I_NUM_ORD_JUD
         AND CO.COD_FCRUBRICA = i_num_fcrubrica
         AND OJ.COD_INS = CO.COD_INS
         AND OJ.NUM_ORD_JUD = CO.NUM_ORD_JUD;

      IF I > 0 THEN
        O_DED_IR := TRUE;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_DED_IR := FALSE;
    END;

    RETURN(O_DED_IR);
  END SP_DED_IR_PA;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_PORC(I_VALOR out number) AS

  BEGIN

    BEGIN

      IF COM_QTY_UNID_IND = 0 THEN
        COM_QTY_UNID_IND := 1;
      END IF;
      IF COM_VAL_PORC_IND > 0 THEN
        I_VALOR := (COM_VAL_PORC_IND * nvl(COM_QTY_UNID_IND, 1)) / 100;
      ELSE
        I_VALOR := (COM_VAL_UNID * nvl(COM_QTY_UNID_IND, 1)) / 100;
      END IF;

    EXCEPTION
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_CALCULA_PORC';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro no calculo do Percentual';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_CALCULA_PORC;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_PORC_GRADUACAO(i_valor out number) AS
  BEGIN
    BEGIN
      SELECT /*+ RULE */
       rm.val_percentual
        into i_valor
        from tb_rel_refs               rr,
             tb_rep_militar_tbref      rm,
             tb_evolu_ccomi_gfuncional ecg
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli = ben_ide_cli_serv
         and ecg.cod_referencia = rr.cod_referencia
         and ecg.cod_entidade = com_entidade
         and ecg.cod_cargo_rel = com_cargo
         and ecg.num_matricula = num_matricula
         and rr.cod_ins = ecg.cod_ins
         and rr.cod_ins = rm.cod_ins
         and rr.cod_tabela_venc = rm.cod_tabela_venc
         and rr.cod_ref_ativos = rm.cod_ref_ativos
         and (PAR_PER_PRO >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')));

    EXCEPTION
      WHEN OTHERS THEN
        i_valor := 0;
    end;

  END SP_CALCULA_PORC_GRADUACAO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CALC_PORC_GRADUACAO_EVOLU(i_valor out number) AS
  BEGIN
    BEGIN
      SELECT rm.val_percentual
        into i_valor
        from tb_rel_refs rr, tb_rep_militar_tbref rm
       where rr.cod_referencia = BEN_COD_REFERENCIA
         and rr.cod_ins = PAR_COD_INS
         and rr.cod_ins = rm.cod_ins
         and rr.cod_tabela_venc = rm.cod_tabela_venc
         and rr.cod_ref_ativos = rm.cod_ref_ativos;

    EXCEPTION
      WHEN OTHERS THEN
        i_valor := 0;
    end;

  END SP_CALC_PORC_GRADUACAO_EVOLU;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ORIG_TAB_VENC(o_str out varchar2) AS
  BEGIN

    begin
      select v.cod_orig_tab_venc
        into o_str
        from tb_rel_refs rr, tb_tabela_vencimento v
       where rr.cod_referencia = BEN_COD_REFERENCIA
         and rr.cod_ins = PAR_COD_INS
         and rr.cod_tabela_venc = v.cod_tabela_venc
         and rr.cod_ins = v.cod_ins;

    exception
      when others then
        o_str := null;
    end;
  END SP_OBTEM_ORIG_TAB_VENC;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_COD_REFERENCIA(o_str out varchar2) AS
  BEGIN

    begin
      select venc.cod_referencia
        into o_str
        from tb_vencimento venc, tb_evolucao_funcional_ben ef
       where ef.cod_ins = PAR_COD_INS
         and venc.cod_referencia = ef.cod_referencia
         and venc.cod_ins = ef.cod_ins
         and venc.cod_pccs = ef.cod_pccs
         and venc.cod_entidade = ef.cod_entidade
         and venc.dat_fim_vig is null
         and ef.cod_ide_cli_ben = COM_IDE_CLI_INSTITUIDOR
         and ef.cod_ide_rel_func = BEN_IDE_REL_FUNC;

    exception
      when others then
        o_str := null;
    end;
  END SP_OBTEM_COD_REFERENCIA;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ORIG_TAB_VENC_CCOMI(o_str out varchar2) AS
  BEGIN

    begin
      select distinct v.cod_orig_tab_venc
        into o_str
        from tb_rel_refs               rr,
             tb_tabela_vencimento      v,
             tb_evolu_ccomi_gfuncional ecg
       where rr.cod_referencia = ecg.cod_referencia
         and rr.cod_ins = PAR_COD_INS
         and rr.cod_tabela_venc = v.cod_tabela_venc
         and rr.cod_ins = v.cod_ins
         and rr.cod_ins = ecg.cod_ins
         and rr.cod_jornada = ecg.cod_jornada
         and ecg.cod_ide_cli = ben_ide_cli_serv
         and ecg.cod_entidade = COM_ENTIDADE
         and ecg.num_matricula = COM_MATRICULA
         and ecg.cod_cargo_rel = com_cargo
         and (PAR_PER_PRO >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')));

    exception
      when others then
        o_str := null;
    end;
  END SP_OBTEM_ORIG_TAB_VENC_CCOMI;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_IND_DJ(o_str out varchar2) AS
  BEGIN
    BEGIN
      select rr.flg_ind_d
        into o_str
        from tb_referencia rr
       where rr.cod_referencia = BEN_COD_REFERENCIA
         and rr.cod_ins = PAR_COD_INS
         and rr.cod_entidade = COM_ENTIDADE;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN

        o_str := 'N';

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_IND_DJ';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o Indicador DJ';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END SP_OBTEM_IND_DJ;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_INS_DETCALCULADO(i_valor in number) AS
  BEGIN

      SP_INS_DETCAL_NORMAL(i_valor);


  END SP_INS_DETCALCULADO;
  ----------------------------------------------------------------------------------
  -- Agrega rubrica en array que sera inserido na tabela de detalhe calculado
  --
  PROCEDURE SP_INS_DETCAL_NORMAL(i_valor in number) AS
    cur_form         curesp;
    vs_str           varchar2(100);
    vs_inf           varchar2(10);
    vs_valor_val     number(18, 4);
    val_rubrica_supl number(18, 4) := 0;
    vi_valor_det     number(18, 4) := 0;
    vc_nao_parcela   varchar2(1) := null;
    vs_valor_novo    number(18, 4);
    vs_valor_novo2   number(18, 4);
    vs_tem_ajuste    char(1) := 'S';
    ENCONTRO_BENEFICIO NUMBER:=0;
    -- vi_valor_det number(18,4) := 0;
    -- vc_nao_parcela varchar2(1) := null;
  BEGIN

          vi_valor_det := i_valor;
          IF COM_NUM_ORD_JUD IS NOT NULL THEN
          BEGIN
            select co.cod_ide_cli
              into rdcn.cod_ide_cli_ben
              from tb_composicao_oj co
             where co.cod_ins = PAR_COD_INS
               and co.num_ord_jud = COM_NUM_ORD_JUD
               AND co.cod_fcrubrica = com_cod_fcrubrica;
          EXCEPTION
            when no_data_found then
              rdcn.cod_ide_cli_ben := null;
          END;
        ELSE
          rdcn.cod_ide_cli_ben := COM_COD_IDE_CLI_BEN;
        END IF;

       vc_nao_parcela := 'N';


        idx_caln        := nvl(idx_caln, 0) + 1;
        idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
    ----- Prenche valores de Calculo da Rubrica

       -------------> Prenche Chave de Calculo----------
        rdcn.cod_ins         := PAR_COD_INS;
        rdcn.tip_processo    := PAR_TIP_PRO;
        rdcn.per_processo    := PAR_PER_PRO;
        rdcn.seq_pagamento   := vi_seq_pagamento;
        rdcn.cod_ide_cli     := BEN_IDE_CLI;
        rdcn.num_matricula   := ANT_MATRICULA  ;
        rdcn.cod_ide_rel_func:= ANT_COM_COD_IDE_REL_FUNC;
        rdcn.cod_entidade    := ANT_ENTIDADE ;
        rdcn.seq_detalhe     := idx_seq_detalhe;
      ------------------------<> ------------------------

        rdcn.cod_fcrubrica := COM_COD_FCRUBRICA;
        rdcn.seq_vig       := COM_SEQ_VIG;
        rdcn.val_rubrica   := trunc(round(vi_valor_det,2), 2);
        rdcn.num_quota     := COM_NUM_QTAS_PAG + 1;
        rdcn.flg_natureza  := COM_NAT_RUB;
        rdcn.tot_quota     := COM_TOT_QTAS_PAG;
        rdcn.dat_ini_ref   := nvl(COM_INI_REF, PAR_PER_PRO);
        rdcn.dat_fim_ref   := COM_FIM_REF;
        rdcn.tip_evento_especial :=COM_TIPO_EVENTO_ESPECIAL;
        rdcn.val_unidade         := COM_QTY_UNID_IND;

        IF  (V_QTD_DIAS / V_DIAS_MES)  =1 THEN
            rdcn.val_porc     := COM_VAL_PORC_IND;
        ELSE
            rdcn.val_porc     := (V_QTD_DIAS / V_DIAS_MES) ;
        END  IF;

        IF COM_NAT_COMP <> 'I' THEN
            rdcn.dat_ini_ref := PAR_PER_PRO;
          rdcn.dat_fim_ref := null;
        END IF;

        rdcn.num_ord_jud       := COM_NUM_ORD_JUD;
        rdcn.dat_ing           := sysdate;
        rdcn.dat_ult_atu       := sysdate;
        rdcn.nom_usu_ult_atu   := PAR_COD_USU;
        rdcn.nom_pro_ult_atu   := 'FOLHA ATIVO';
        rdcn.des_informacao    := null;
        rdcn.val_rubrica_cheio := trunc(round(COM_VAL_RUBRICA_CHEIO,2), 2);

        IF PAR_TIP_PRO IN ( 'N','S','D') AND --2020-02-25 --TONYCARAVANA #RESCISAO
           SUBSTR(LPAD(TO_CHAR(rdcn.cod_fcrubrica), 7, 0), 6, 2) in
            ( '55','56') THEN
             rdcn.des_complemento := 'Ret.M';
        ELSIF PAR_TIP_PRO = 'R' AND rdcn.des_complemento IS NULL THEN
          rdcn.des_complemento := 'Ret.';
        ELSIF rdcn.des_complemento not like 'Parc%' Then
          rdcn.des_complemento := null;
        END IF;

        rdcn.cod_ide_cli_ben       := null;
        rdcn.cod_ide_cli_ben       := COM_COD_IDE_CLI_BEN;
        rdcn.num_carga             := com_num_carga;
        rdcn.num_seq_controle_carga:=com_num_seq_controle_carga;
        vs_valor_val               := 0;

        IF COM_MSC_INFORMACAO is not null OR
           COM_COL_INFORMACAO is not null THEN

          FOR i IN 1 .. nom_variavel.count LOOP

            IF nom_variavel(i) = COM_COL_INFORMACAO THEN
              vs_valor_val     := val_variavel(i);
              v_val_percentual := vs_valor_val;
              exit;
            END IF;

          END LOOP;

         vs_str := 'select ' || 'to_char(' || '''' || vs_valor_val || '''' || ')' || ' from dual';

          BEGIN
            OPEN cur_form FOR vs_str;
            FETCH cur_form
              INTO vs_inf;
            CLOSE cur_form;
          END;

          IF COM_COL_INFORMACAO = 'VAL_PERC_BENEFICIO' OR
             COM_COL_INFORMACAO = 'VAL_PAR_CONS' OR
             COM_COL_INFORMACAO = 'PERC_VAL_PENSAO' OR
             COM_COL_INFORMACAO = 'VAL_PERC_FIXO' OR
             COM_COL_INFORMACAO = 'ANOS_ATS' THEN
            rdcn.des_informacao := vs_inf || '%';
          ELSIF COM_COL_INFORMACAO = 'PERC_RATEIO_PECUNIA' THEN
            rdcn.des_informacao := TO_CHAR(VI_PERC_PECUNIA,
                                           COM_MSC_INFORMACAO);
          ELSIF COM_COL_INFORMACAO = 'NUM_DEPENDENTES' THEN
            rdcn.des_informacao := vs_inf || ' Dep.';
          ELSIF COM_COL_INFORMACAO = 'GRP_ABONO_SALARIAL' THEN
            rdcn.des_informacao := 'GRP=' || vs_inf;
          ELSIF COM_COL_INFORMACAO = 'NUM_PARCELAS' THEN
            rdcn.des_informacao := lpad(to_char(COM_NUM_QTAS_PAG, '999'),
                                        3,
                                        0) || '/' ||
                                   lpad(to_char(COM_TOT_QTAS_PAG, '999'),
                                        3,
                                        0);
          ELSIF COM_COL_INFORMACAO = 'VAL_PENSAO' THEN
            rdcn.des_informacao := 'VAL. FIXO';
          ELSIF COM_COL_INFORMACAO = 'QTD_SAL_MIN_PENSAO' THEN
            rdcn.des_informacao := vs_inf || 'S.M.';
          ELSIF COM_COL_INFORMACAO = 'PERC_SAL_MIN_PENSAO' THEN
            rdcn.des_informacao := ltrim(vs_inf) || '% SM';
          ELSIF COM_COL_INFORMACAO = 'QTD_COTAS' THEN
            rdcn.des_informacao := ltrim(vs_inf);
          ELSE
            rdcn.des_informacao := vs_inf;
          END IF;
        END IF;
       --------- Momoria de Calculo -------------
        rdcn.flg_log_calc         :=  'S';
        rdcn.cod_formula_cond     :=  mc_cod_formula_cond;  
        rdcn.des_condicao         :=  SP_TRADUCAO_FORMULA (mc_des_condicao);  
        rdcn.cod_formula_rubrica  :=  mc_cod_formula_rubrica;   
        rdcn.des_formula          :=  SP_TRADUCAO_FORMULA (mc_des_formula); 
        rdcn.des_composicao       :=  mc_des_composicao;   


        tdcn.extend;
        tdcn(idx_caln) := rdcn;

      -------- Memoria de Calculo -------------
        rdcn.flg_log_calc         :=  NULL;
        rdcn.cod_formula_cond     :=  NULL;
        rdcn.des_condicao         :=  NULL;
        rdcn.cod_formula_rubrica  :=  NULL;
        rdcn.des_formula          :=  NULL;
        rdcn.des_composicao       :=  NULL;
  
        mc_cod_formula_cond       :=  NULL;  
        mc_des_condicao           :=  NULL;
        mc_cod_formula_rubrica    :=  NULL;
        mc_des_formula            :=  NULL;
        mc_des_composicao         :=  NULL;



  END SP_INS_DETCAL_NORMAL;
  ----------------------------------------------------------------------------------
  -- Agrega rubrica em array que sera inserido na tabela de detalhe calculado
  --
  PROCEDURE SP_INS_ARRAY_DESCONTO(i_valor in number) AS
  BEGIN
    BEGIN
      tdcd.extend;
    EXCEPTION
      when others then
        p_sub_proc_erro := 'SP_INS_ARRAY_DESCONTO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro na inclusao do array de desconto';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --     RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

    idx_cald := nvl(idx_cald, 0) + 1;

    rdcd.cod_ins         := PAR_COD_INS;
    rdcd.tip_processo    := PAR_TIP_PRO;
    rdcd.per_processo    := PAR_PER_PRO;
    rdcd.cod_ide_cli     := BEN_IDE_CLI;
    rdcn.num_matricula   := ANT_MATRICULA  ;
    rdcn.cod_ide_rel_func:= ANT_COM_COD_IDE_REL_FUNC;
    rdcn.cod_entidade    := ANT_ENTIDADE ;
    rdcd.seq_pagamento   := vi_seq_pagamento;
    rdcd.seq_detalhe     := idx_cald;
    rdcd.cod_fcrubrica   := COM_COD_FCRUBRICA;
    rdcd.seq_vig         := COM_SEQ_VIG_FC;
    rdcd.val_rubrica     := i_valor;
    rdcd.num_quota       := COM_NUM_QTAS_PAG + 1;
    rdcd.flg_natureza    := COM_NAT_RUB;
    rdcd.tot_quota       := COM_TOT_QTAS_PAG;
    rdcd.dat_ini_ref     := COM_INI_REF;
    rdcd.dat_fim_ref     := COM_FIM_REF;
    rdcd.num_ord_jud     := COM_NUM_ORD_JUD;
    rdcd.dat_ing         := sysdate;
    rdcd.dat_ult_atu     := sysdate;
    rdcd.nom_usu_ult_atu := PAR_COD_USU;
    rdcd.nom_pro_ult_atu := 'FOLHA CALCULADA';
    if  COM_COD_CONVENIO > 0 then
      rdcd.des_complemento := com_cod_convenio;
    else
       rdcd.des_complemento:=' ';
    end if;
    rdcd.num_carga       := COM_NUM_CARGA;
    rdcd.num_seq_controle_carga:=COM_NUM_SEQ_CONTROLE_CARGA;

    tdcd(idx_cald) := rdcd;

  END SP_INS_ARRAY_DESCONTO;
  ---------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_VALOR_OJ RETURN NUMBER IS
    O_VALOR NUMBER(18, 4);
  BEGIN
    O_VALOR := 0;
    BEGIN
      SELECT DC.VAL_RUBRICA
        INTO O_VALOR
        FROM TB_DET_CALCULADO DC
       WHERE DC.COD_INS = PAR_COD_INS
         AND DC.PER_PROCESSO = PAR_PER_PRO
         AND DC.COD_IDE_CLI_BEN = BEN_IDE_CLI
         AND DC.NUM_ORD_JUD = COM_NUM_ORD_JUD;
    EXCEPTION
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VALOR_OJ';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o valor OJ';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --      RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

    RETURN(O_VALOR);

  END SP_OBTEM_VALOR_OJ;
  ---------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_PROP_COMPOSICAO RETURN NUMBER IS
    O_VALOR NUMBER(18, 6);
    dia_ini NUMBER;
    dia_fim NUMBER;

  BEGIN
    O_VALOR := 1;

    IF COM_IND_COMP_RUB = 'N' OR
       (
          COM_COD_FCRUBRICA IN (900102,1000102, 808702, 805102,6500402,6500502,6500702,6500802)
         AND COM_COD_ENTIDADE=5
         AND TO_CHAR(BEN_DAT_INICIO,'YYYYMM') <
             TO_CHAR(NVL(COM_DAT_INI_VIG,TO_DATE('01/01/2999','DD/MM/YYYY')),'YYYYMM')
       )
       THEN

     dia_fim:=30;
     dia_ini:=1;
     IF  COM_DAT_FIM_VIG is not null AND
         TO_CHAR(COM_DAT_FIM_VIG,'YYYYMM')=
         TO_CHAR(PAR_PER_PRO,'YYYYMM')
          THEN
        dia_fim := to_number(to_char(COM_DAT_FIM_VIG, 'dd'));
        IF COM_DAT_FIM_VIG = add_months(PAR_PER_PRO, 1) - 1 THEN
           dia_fim := 30;
        ELSE
           dia_fim := to_number(to_char(COM_DAT_FIM_VIG, 'dd'));
        END IF;
     END IF;
     IF COM_DAT_INI_VIG <= PAR_PER_PRO THEN
        dia_ini :=1;
     ELSE
        IF to_char(COM_DAT_INI_VIG,'MMYYYY')=to_char(PAR_PER_PRO,'MMYYYY')
           THEN
           dia_ini := to_number(to_char(COM_DAT_INI_VIG,'dd'));
        END IF;
     END IF;
     IF dia_fim >30 THEN
       dia_fim:=30;
     END IF;
     o_valor := (dia_fim - dia_ini + 1) / 30 ;

   END IF;

   RETURN(O_VALOR);
  END SP_OBTEM_PROP_COMPOSICAO;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_BASE_CARGO(o_cod_referencia in number)
    RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    w_data_enquadramento date;

  BEGIN

    IF PAR_IND_PROC_ENQUADRAMENTO = 1 THEN

      w_data_enquadramento := VI_DATA_ENQUADRAMENTO;

    ELSE
      w_data_enquadramento := PAR_PER_PRO;

    END IF;

    BEGIN
      SELECT
      -- ROD fev2010
       sum(v.val_vencimento *
          (case
             when v.dat_fim_vig is null and v.dat_ini_vig < w_data_enquadramento then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig <= PAR_PER_PRO AND
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig > PAR_PER_PRO and v.dat_ini_vig <= add_months(w_data_enquadramento, 1) - 1 and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd')) - to_number(to_char(v.dat_ini_vig, 'dd'))
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig < add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null and
                  v.dat_fim_vig <= add_months(PAR_PER_PRO, 1) - 1
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                    30
             when to_char(v.dat_ini_vig, 'YYYYMM') <
                  to_char(PAR_PER_PRO, 'YYYYMM') then
                    30
             else
              30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
          end) / 30)
      -- to_char(add_months(w_data_enquadramento, 1) - 1, 'dd'))    --Rod13 coment
        INTO O_VALOR
        FROM TB_VENCIMENTO V
       WHERE V.COD_ENTIDADE = COM_ENTIDADE
         AND V.COD_REFERENCIA = o_cod_referencia -- BEN_COD_REFERENCIA
            -- MVL 20060417
         AND (to_char(w_data_enquadramento, 'YYYYMM') >=
             to_char(v.dat_ini_vig, 'YYYYMM') AND
             (w_data_enquadramento <= V.DAT_FIM_VIG OR
             V.DAT_FIM_VIG is null))
         and V.FLG_STATUS = 'V';

      -- RAO 20060321
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_SALARIO_BASE_CARGO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o salario base cargo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --          RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_SALARIO_BASE_CARGO;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_BASE_CARGO_OJ ---->> ffranco 03/2007
   RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    w_data_enquadramento date;

  BEGIN

    IF PAR_IND_PROC_ENQUADRAMENTO = 1 THEN

      w_data_enquadramento := VI_DATA_ENQUADRAMENTO;

    ELSE
      w_data_enquadramento := PAR_PER_PRO;

    END IF;

    BEGIN
      SELECT
      -- ROD fev2010
       sum(v.val_vencimento * (case
             when v.dat_fim_vig is null and v.dat_ini_vig <= w_data_enquadramento then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig <= PAR_PER_PRO and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig > PAR_PER_PRO and v.dat_ini_vig <= add_months(w_data_enquadramento, 1) - 1 and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd')) - to_number(to_char(v.dat_ini_vig, 'dd'))
             when v.dat_fim_vig is not null and v.dat_ini_vig <= PAR_PER_PRO and
                  v.dat_fim_vig < add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                    30
             when to_char(v.dat_ini_vig, 'YYYYMM') < to_char(PAR_PER_PRO, 'YYYYMM') then
                    30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
             else
                    30
           end) / 30)
        INTO O_VALOR
        FROM TB_VENCIMENTO V
       WHERE V.COD_ENTIDADE = COM_ENTIDADE
         AND V.COD_REFERENCIA = v_cod_ref_oj
         and (v.dat_fim_vig is null or
             v.dat_fim_vig >= w_data_enquadramento)
         and add_months(w_data_enquadramento, 1) - 1 >= v.dat_ini_vig
         and V.FLG_STATUS = 'V';
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_SALARIO_BASE_CARGO_OJ';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o salario base OJ';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_SALARIO_BASE_CARGO_OJ;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_PADRAO_INI RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    w_data_enquadramento date;
  BEGIN

    vi_cod_ref_pad_venc := SP_OBTEM_PADRAO_VENCIMENTO;

    IF PAR_IND_PROC_ENQUADRAMENTO = 1 THEN

      w_data_enquadramento := VI_DATA_ENQUADRAMENTO;

    ELSE
      w_data_enquadramento := PAR_PER_PRO;

    END IF;

    BEGIN
      SELECT
      -- ROD fev2010
       sum(v.val_vencimento * (case
             when v.dat_fim_vig is null and v.dat_ini_vig <= w_data_enquadramento then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig <= w_data_enquadramento and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig > w_data_enquadramento and v.dat_ini_vig <= add_months(w_data_enquadramento, 1) - 1 and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd')) - to_number(to_char(v.dat_ini_vig, 'dd'))
             when v.dat_fim_vig is not null and v.dat_ini_vig <= w_data_enquadramento and
                  v.dat_fim_vig < add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                    30
             when to_char(v.dat_ini_vig, 'YYYYMM') < to_char(PAR_PER_PRO, 'YYYYMM') then
                    30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
             else
                    30
           end) / 30)
        INTO O_VALOR
        FROM TB_VENCIMENTO V,
             (select distinct re1.cod_ref_pad_ini_serv
                from tb_referencia re1
               where re1.cod_ins = PAR_COD_INS
                 and re1.cod_entidade = COM_ENTIDADE
                 and re1.cod_pccs = COM_PCCS
                 and re1.cod_quadro = COM_QUADRO
                 AND RE1.COD_REFERENCIA = ben_cod_referencia
                 and re1.cod_ref_pad_venc = vi_cod_ref_pad_venc
                 and (re1.dat_fim_vig is null or
                     re1.dat_fim_vig >= w_data_enquadramento)
                 and add_months(w_data_enquadramento, 1) - 1 >=
                     re1.dat_ini_vig) ree,
             tb_referencia re
       WHERE V.COD_INS = PAR_COD_INS
         AND V.COD_ENTIDADE = COM_ENTIDADE
         AND V.COD_REFERENCIA = RE.COD_REFERENCIA
         and (v.dat_fim_vig is null or
             v.dat_fim_vig >= w_data_enquadramento)
         and add_months(w_data_enquadramento, 1) - 1 >= v.dat_ini_vig
         and V.FLG_STATUS = 'V'
         and re.cod_ref_pad_venc = ree.cod_ref_pad_ini_serv
         AND re.cod_ins = v.cod_ins
         and re.cod_entidade = v.cod_entidade
         and re.cod_pccs = COM_PCCS
         and re.cod_quadro = COM_QUADRO
         and (re.dat_fim_vig is null or
             re.dat_fim_vig >= w_data_enquadramento)
         and add_months(w_data_enquadramento, 1) - 1 >= re.dat_ini_vig;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SB_OBTEM_SALARIO_PADRAO_INI';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o salario base padr?o';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_SALARIO_PADRAO_INI;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_PADRAO_INI_A RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    w_data_enquadramento date;
  BEGIN

    vi_cod_ref_pad_venc := SP_OBTEM_PADRAO_VENCIMENTO;

    IF PAR_IND_PROC_ENQUADRAMENTO = 1 THEN

      w_data_enquadramento := VI_DATA_ENQUADRAMENTO;

    ELSE
      w_data_enquadramento := PAR_PER_PRO;

    END IF;

    BEGIN
      SELECT
      -- ROD fev2010
       sum(v.val_vencimento *
          (case
             when v.dat_fim_vig is null and v.dat_ini_vig <= w_data_enquadramento then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig <= w_data_enquadramento and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig > w_data_enquadramento and v.dat_ini_vig <= add_months(w_data_enquadramento, 1) - 1 and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd')) - to_number(to_char(v.dat_ini_vig, 'dd'))
             when v.dat_fim_vig is not null and v.dat_ini_vig <= w_data_enquadramento and
                  v.dat_fim_vig < add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                    30
             when to_char(v.dat_ini_vig, 'YYYYMM') < to_char(PAR_PER_PRO, 'YYYYMM') then
                    30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
             else
                    30
           end) / 30)
        INTO O_VALOR
        FROM TB_VENCIMENTO V,
             (select distinct re1.cod_ref_pad_ini_carg
                from tb_referencia re1
               where re1.cod_ins = PAR_COD_INS
                 and re1.cod_entidade = COM_ENTIDADE
                 and re1.cod_pccs = COM_PCCS
                 and re1.cod_quadro = COM_QUADRO
                 AND RE1.COD_REFERENCIA = ben_cod_referencia
                 and re1.cod_ref_pad_venc = vi_cod_ref_pad_venc
                 and (re1.dat_fim_vig is null or
                     re1.dat_fim_vig >= w_data_enquadramento)
                 and add_months(w_data_enquadramento, 1) - 1 >=
                     re1.dat_ini_vig) ree,
             tb_referencia re
       WHERE V.COD_INS = PAR_COD_INS
         AND V.COD_ENTIDADE = COM_ENTIDADE
         AND V.COD_REFERENCIA = RE.COD_REFERENCIA
         and (v.dat_fim_vig is null or
             v.dat_fim_vig >= w_data_enquadramento)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and V.FLG_STATUS = 'V'
         and re.cod_ref_pad_venc = ree.cod_ref_pad_ini_carg
         AND re.cod_ins = v.cod_ins
         and re.cod_entidade = v.cod_entidade
         and re.cod_pccs = COM_PCCS
         and re.cod_quadro = COM_QUADRO
         and (re.dat_fim_vig is null or
             re.dat_fim_vig >= w_data_enquadramento)
         and add_months(w_data_enquadramento, 1) - 1 >= re.dat_ini_vig;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SB_OBTEM_SALARIO_PADRAO_INI';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o salario base padr?o';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_SALARIO_PADRAO_INI_A;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_SALARIO_REFERENCIA RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    v_val_vencimento     number(18, 4) := 0;
    v_val_vencimento_rep number(18, 4) := 0;
    w_data_enquadramento date;
  BEGIN

    IF PAR_IND_PROC_ENQUADRAMENTO = 1 THEN

      w_data_enquadramento := VI_DATA_ENQUADRAMENTO;

    ELSE
      w_data_enquadramento := PAR_PER_PRO;

    END IF;

    BEGIN

      select
       sum(v.val_vencimento *
          (case
             when v.dat_fim_vig is null and v.dat_ini_vig <= w_data_enquadramento then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig <= w_data_enquadramento and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    30
             when v.dat_fim_vig is not null and v.dat_ini_vig > w_data_enquadramento and v.dat_ini_vig <= add_months(w_data_enquadramento, 1) - 1 and
                  v.dat_fim_vig = add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd')) - to_number(to_char(v.dat_ini_vig, 'dd'))
             when v.dat_fim_vig is not null and v.dat_ini_vig <= w_data_enquadramento and
                  v.dat_fim_vig < add_months(w_data_enquadramento, 1) - 1 then
                    to_number(to_char(v.dat_fim_vig, 'dd'))
             when v.dat_fim_vig is not null
                  and to_number(to_char(v.dat_fim_vig, 'dd')) = 31 then
                    30
             when to_char(v.dat_ini_vig, 'YYYYMM') < to_char(PAR_PER_PRO, 'YYYYMM') then
                    30 - to_number(to_char(v.dat_ini_vig, 'dd')) + 1
             else
                    30
          end) / 30),
       v.val_vencimento_rep
        INTO v_val_vencimento, v_val_vencimento_rep
        from tb_vencimento v, tb_composicao_ben cb
       where v.cod_referencia = cb.cod_referencia
         and cb.cod_ins = PAR_COD_INS
         and cb.cod_beneficio = COM_COD_BENEFICIO
         and cb.cod_fcrubrica = COM_COD_FCRUBRICA
         and cb.cod_ins = v.cod_ins
         and v.cod_entidade = COM_ENTIDADE
         AND cb.flg_status = 'V'
         AND (to_char(w_data_enquadramento, 'YYYYMM') >=
             to_char(cb.dat_ini_vig, 'YYYYMM') AND
             to_char(w_data_enquadramento, 'YYYYMM') <=
             to_char(nvl(CB.DAT_FIM_VIG,
                          to_date('01/01/2045', 'dd/mm/yyyy')),
                      'YYYYMM'))
         and (v.dat_fim_vig is null or
             v.dat_fim_vig >= w_data_enquadramento)
         and add_months(w_data_enquadramento, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V'
         and cb.dat_ini_vig = COM_DAT_INI_VIG -- MVL 20/07/2006 -- duplicidade no retroativo
       group by v.val_vencimento_rep;

      IF v_val_vencimento > v_val_vencimento_rep THEN
        O_VALOR := v_val_vencimento;
      ELSIF v_val_vencimento < v_val_vencimento_rep then
        O_VALOR := v_val_vencimento_rep;
      ELSE
        O_VALOR := v_val_vencimento;
      END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR              := 0;
        v_val_vencimento     := 0;
        v_val_vencimento_rep := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_SALARIO_REFERENCIA';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o salario base de referencia';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --          RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_SALARIO_REFERENCIA;
  ---------------------------------------------------------------------------------
  FUNCTION SP_ISENTA_IRRF(ide_cli in varchar2) return boolean is
    vi_isenta      boolean;
    vi_count       number;
    vi_ind_doe     varchar(1);
    vi_ind_atb     varchar(1);
    w_cod_atributo number;
  Begin
    vi_isenta  := false;
    vi_ind_doe := 'N';

    vi_count := 0;

    --- Valida se tem isencao por doenca
    -- Valida se tem doenca
    BEGIN
      SELECT CASE
               WHEN (SELECT DC.FLG_ISE_IR
                       FROM TB_CID10_COMPORT DC
                      WHERE DC.COD_INS = LC.COD_INS
                        AND DC.COD_DOENCA = LC.COD_DOENCA
                        AND DC.DAT_INI_VIG <= PAR_PER_PRO
                        AND nvl(DC.DAT_FIM_VIG, PAR_PER_PRO) >= PAR_PER_PRO) = 'S' THEN
                'S'
               ELSE
                'N'
             END
        INTO VI_IND_DOE
        FROM TB_LAUDO_MEDICO LM, TB_LAUDO_MEDICO_CID10 LC
       WHERE LM.COD_INS = PAR_COD_INS
         AND LM.COD_IDE_CLI = ANT_IDE_CLI
         AND LM.DAT_INI_VIG <= PAR_PER_PRO
         AND nvl(LM.DAT_FIM_VIG, par_per_pro) >= PAR_PER_PRO
         AND LC.COD_INS = LM.COD_INS
         AND LC.COD_IDE_CLI = LM.COD_IDE_CLI
         AND LC.COD_ENTIDADE = LM.COD_ENTIDADE
         AND LC.NUM_LAUDO_MEDICO = LM.NUM_LAUDO_MEDICO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VI_IND_DOE := 'N';
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_ISENTA_IRRF';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao buscar isencao de IR - Laudo Medico';
        RAISE ERRO;
    END;

    IF VI_IND_DOE = 'S' THEN
      VI_ISENTA := TRUE;
      VI_DOENCA := TRUE;
    ELSE
      -- Valida se tem isenc?o por ordem judicial
      VI_COUNT := 0;
      SELECT COUNT(1)
        INTO VI_COUNT
        FROM TB_ORD_JUD_PESSOA_FISICA JP,
             TB_ORDEM_JUD_TIPO_EFEITO TE,
             TB_TIPO_EFEITO_ORDEM_JUD EE
       WHERE JP.COD_INS = PAR_COD_INS
         AND JP.COD_IDE_CLI = ANT_IDE_CLI
         AND JP.DAT_INI_VIG <= PAR_PER_PRO
         AND (JP.DAT_FIM_VIG >= PAR_PER_PRO or JP.DAT_FIM_VIG is null)
         AND TE.COD_INS = JP.COD_INS
         AND TE.NUM_ORD_JUD = JP.NUM_ORD_JUD
         AND EE.TIP_EFEITO = 'I'
         AND EE.COD_TIP_EFEITO = TE.COD_TIP_EFEITO;
      IF VI_COUNT > 0 THEN
        VI_ISENTA  := TRUE;
        VI_ORD_JUD := TRUE;
      END IF;
    END IF;

    IF NVL(vfolha.COUNT,0) >=1 THEN
      case
          when nvl(vfolha(1).cod_dissociacao,0) = 0 then
              w_cod_atributo :=8000;
          when nvl(vfolha(1).cod_dissociacao,0) = 1 then
              w_cod_atributo :=8001;
          when nvl(vfolha(1).cod_dissociacao,0) = 2 then
              w_cod_atributo :=8002;
          else
              w_cod_atributo :=8000;
      end case;
    ELSE
        case
          when nvl(BEN_DISSOCIACAO,0) = 0 then
              w_cod_atributo :=8000;
          when nvl(BEN_DISSOCIACAO,0) = 1 then
              w_cod_atributo :=8001;
          when nvl(BEN_DISSOCIACAO,0) = 2 then
              w_cod_atributo :=8002;
          else
              w_cod_atributo :=8000;
      end case;

    END IF;

    begin
      select distinct 'S' into vi_ind_atb from tb_atributos_pf b
      where exists (
      select 1
        from tb_atributos_pf    ats, --tb_atributos_serv ats,
             tb_tipos_atributos ta
       where --ats.cod_beneficio = ant_cod_beneficio
      --and
       ats.cod_ins = par_cod_ins
       and b.cod_ide_cli = ats.cod_ide_cli
       and ats.cod_ide_cli = ant_ide_cli
       and ats.cod_atributo = ta.cod_atributo
       and nvl(ats.flg_status,'V')='V'
       and ats.dat_ini_vig <=PAR_PER_PRO
       and (ats.dat_fim_vig is null or ats.dat_fim_vig >= PAR_PER_PRO) --incluido FFranco 20/11/2006
       and  ( ta.cod_atributo=w_cod_atributo OR
              TA.cod_atributo=8000 )
              );
    exception
      when no_data_found then
        vi_ind_atb := 'N';
    end;

    IF vi_ind_atb = 'S' THEN
      VI_ISENTA := TRUE;

    END IF;

    return(vi_isenta);
  END SP_ISENTA_IRRF;

  -------------------------------------------------------------------------------------
  --Falta alterar para procurar dependentes por Beneficiario efv 20060823
  FUNCTION SP_OBTEM_DEP_DED_IR(IDE_CLI IN VARCHAR2, I_TIPO_BEN CHAR)
    RETURN NUMBER IS
    O_QTY NUMBER;
  BEGIN
    O_QTY := 0;

    IF I_TIPO_BEN = 'A' THEN
      begin
/*       select s.num_dep_ir
          into o_qty
          from tb_servidor s
          where s.cod_ins = PAR_COD_INS
            and s.cod_ide_cli = IDE_CLI;*/
         select pf.num_dep_ir
          into  o_qty
          from  tb_pessoa_fisica pf
          where pf.cod_ins = par_cod_ins
            and   pf.cod_ide_cli = IDE_CLI;
      exception
        when others then
          o_qty := 0;
      end;
    ELSE
      begin
/*        select count(1)
          into o_qty
          from tb_dependencia_economica de
         where de.cod_ins = par_cod_ins
           and de.flg_dep_ir = 'S'
           and par_per_pro >= de.dat_ini_dep_eco
           and par_per_pro <= nvl(de.dat_fim_dep_eco, '01/01/2200')
           and de.cod_ide_cli_ben = IDE_CLI;*/
         select pf.num_dep_ir
          into  o_qty
          from  tb_pessoa_fisica pf
          where pf.cod_ins = par_cod_ins
          and   pf.cod_ide_cli = IDE_CLI;
      exception
        when others then
          o_qty := 0;
      end;

    END IF;

    IF NUM_DEP_IR_MIL > 0 then
      O_QTY := NUM_DEP_IR_MIL;
    END IF;

    RETURN(O_QTY);
  END SP_OBTEM_DEP_DED_IR;
  -------------------------------------------------------------------------------------

  FUNCTION SP_OBTEM_RUBRICA_SUPL(I_FCRUBRICA NUMBER) RETURN NUMBER AS
    O_FCRUBRICA NUMBER(8);
  BEGIN
    BEGIN
      SELECT FC.COD_FCRUBRICA
        INTO O_FCRUBRICA
        FROM TB_RUBRICAS RR, TB_FORMULA_CALCULO FC
       WHERE RR.COD_INS = PAR_COD_INS
         AND RR.TIP_EVENTO_ESPECIAL = 'S'
         AND FC.COD_INS = RR.COD_INS
         AND FC.COD_RUBRICA = RR.COD_RUBRICA
         AND FC.COD_ENTIDADE = RR.COD_ENTIDADE
         AND FC.COD_ENTIDADE = COM_ENTIDADE
         AND FC.DAT_INI_VIG <= PAR_PER_PRO
         AND (FC.DAT_FIM_VIG >= PAR_PER_PRO or FC.DAT_FIM_VIG is null)
         AND EXISTS (SELECT 1
                FROM TB_FORMULA_CALCULO CF
               WHERE CF.COD_INS = FC.COD_INS
                 AND CF.COD_FCRUBRICA = I_FCRUBRICA
                 AND CF.COD_RUBRICA = FC.COD_RUBRICA
                 AND CF.COD_ENTIDADE = FC.COD_ENTIDADE
                 AND CF.DAT_INI_VIG <= PAR_PER_PRO
                 AND (CF.DAT_FIM_VIG <= PAR_PER_PRO or
                     CF.DAT_FIM_VIG is null));
    EXCEPTION
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_RUBRICA_SUPL';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter s rubrica suplementar';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --      RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

    RETURN(O_FCRUBRICA);

  END SP_OBTEM_RUBRICA_SUPL;

  ----------------------------------------------------------------------------------
  PROCEDURE SP_RATEIO_BENEFICIO(P_COD_BENEFICIO IN NUMBER,
                                COD_CLI         IN VARCHAR2,
                                MON_VALOR       IN NUMBER,
                                I_VALOR         OUT NUMBER,
                                I_PERC_RATEIO   OUT NUMBER) AS

    v_percent_rateio number(7, 4) := 0;

  BEGIN

    IF COM_TIP_BENEFICIO = 'PENSIONISTA' THEN

      IF (RAT_COD_BENEFICIO_ANT = P_COD_BENEFICIO AND
         RAT_IDE_CLI_ANT = COD_CLI) AND VI_PERCENTUAL_RATEIO IS NOT NULL THEN
        VI_PERCENTUAL_RATEIO := RAT_PERCENTUAL_RATEIO / 100;
        I_PERC_RATEIO        := VI_PERCENTUAL_RATEIO;
        I_VALOR              := (MON_VALOR * RAT_PERCENTUAL_RATEIO) / 100;
      ELSE
        BEGIN

          SELECT trunc(sum(val_percent_rateio * (case
                             when dat_fim_vig is not null and
                                  dat_fim_vig = dat_ini_vig then
                              1
                             when dat_fim_vig is not null and
                                  dat_fim_vig <= add_months(par_per_pro, 1) - 1
                                --  AND to_number(to_char(dat_fim_vig, 'dd'))< 31 then
                                  AND to_number(to_char(dat_fim_vig, 'dd'))< to_number(to_char(last_day(par_per_pro),'dd')) then

                              to_number(to_char(dat_fim_vig, 'dd'))
                             when dat_fim_vig is null and dat_ini_vig < par_per_pro then
                              30
                             when to_char(dat_ini_vig, 'YYYYMM') <
                                  to_char(PAR_PER_PRO, 'YYYYMM') then
                              30
                             when to_number(to_char(dat_ini_vig, 'dd'))=31
                               and to_number(to_char(dat_ini_vig, 'mm'))= to_number(to_char(par_per_pro, 'mm')) then
                              1
                             else
                              30 - to_number(to_char(dat_ini_vig, 'dd')) + 1
                           end) / 30),
                       4)
            INTO v_percent_rateio
            FROM tb_rateio_beneficio
           WHERE cod_ins = PAR_COD_INS
             AND cod_beneficio = P_COD_BENEFICIO
             AND cod_ide_cli_ben = COD_CLI
                --           AND flg_reg_ativ = 'S'  --efv 09022007
             AND (to_char(par_per_pro, 'YYYYMM') >=
                 to_char(DAT_INI_VIG, 'YYYYMM') AND
                 (par_per_pro <= DAT_FIM_VIG OR DAT_FIM_VIG is null));

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_percent_rateio := 100;
          WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_RATEIO_BENEFICIO';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao obter o valor do percentual de rateio';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  COD_CLI,
                                  COM_COD_FCRUBRICA);

            --            RAISE ERRO;
            v_percent_rateio := 100;
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END;

        RAT_COD_BENEFICIO_ANT := P_COD_BENEFICIO;
        RAT_IDE_CLI_ANT       := COD_CLI;
        RAT_PERCENTUAL_RATEIO := v_percent_rateio;

        VI_PERCENTUAL_RATEIO := v_percent_rateio / 100;
        I_PERC_RATEIO        := VI_PERCENTUAL_RATEIO;
        I_VALOR              := (MON_VALOR * v_percent_rateio) / 100;
      END IF;

    ELSE
      IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN

          ---I_PERC_RATEIO := 1;   -- jts 29-092010 jts
          -- jts 29-092010 jts

          --comente agora 30092010 antes do termino
           IF (V_QTD_DIAS / V_DIAS_MES)<1 THEN
              I_PERC_RATEIO := (V_QTD_DIAS / V_DIAS_MES);
           ELSE
             I_PERC_RATEIO := 1;
          END IF;

      END IF;
    END IF;

  END SP_RATEIO_BENEFICIO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_MASTER_PAG AS

    i                number := 0;
    j                number := 0;
    valor            number := 0;
    variavel         VARCHAR2(30) := null;
    val_rubrica_supl number(18, 4) := 0;
    v_fol            number;
    v_resumo         Varchar2(50) := '';

    ----- Acumula Rubricas
    V_VAL_RUBRICA          NUMBER(18, 4) := 0;
    dat_ini_ref_ant        date;
    dat_fim_ref_ant        date;
    chave_ant              VARCHAR2(50);
    RUBRICA_ANT            NUMBER;
    COD_IDE_CLI_BEN_ANT    TB_DET_CALCUlADO_ESTRUC.COD_IDE_CLI_BEN%type;
    ind                    NUMBER := 0;
    k                      number := 0;
    m                      number := 0;
    conta                  number(4) := 0;
  BEGIN

    vi_suplementar:=FALSE;
    IF vi_suplementar THEN
      --IF SUPL_OK = 'N' THEN
    -----------INICIO DE ACUMULAC?O--------------

         j:=0;
          TDCT.delete;
          V_VAL_RUBRICA := 0;

           FOR I IN 1 .. TDCN.COUNT LOOP
            IF (TDCN(i).val_rubrica > 0 or TDCN(i).val_rubrica is not null )/* and
               TDCN(i).cod_fcrubrica  not in (1860150,1860151,1860155,1860156)*/
               -- Comentado a solic. de Caroline Yumie 11-10-2013
               then
              IF I = 1 THEN
                dat_ini_ref_ant:=TDCN(i).dat_ini_ref;
                dat_fim_ref_ant:=TDCN(i).dat_fim_ref;
                chave_ant           := lpad(ltrim(to_char(TDCN(i).COD_IDE_REL_FUNC)),
                                            8,
                                            0) ||
                                       lpad(ltrim(to_char(TDCN(i).cod_fcrubrica)),
                                            7,
                                            0) ||  nvl(TDCN(i).cod_ide_cli_ben, '')
                                               ||  nvl(TDCN(i).dat_ini_ref,PAR_PER_PRO);
                RUBRICA_ANT         := TDCN(i).cod_fcrubrica;
                COD_IDE_CLI_BEN_ANT := TDCN(i).cod_ide_cli_ben;
                V_VAL_RUBRICA       := TDCN(i).val_rubrica;
                TDCT.extend;
                j := j + 1;
                TDCT(i) := TDCN(i);
                ind := i;
              ELSE
                IF chave_ant <>
                   lpad(ltrim(to_char(nvl(TDCN(i).COD_IDE_REL_FUNC , 0))), 8, 0) ||
                   lpad(ltrim(to_char(nvl(TDCN(i).cod_fcrubrica, 0))), 7, 0) ||
                   nvl(TDCN(i).cod_ide_cli_ben, '')                          ||
                   nvl(TDCN(i).dat_ini_ref,PAR_PER_PRO)
                  then
                  dat_ini_ref_ant:=TDCN(i).dat_ini_ref;
                  dat_fim_ref_ant:=TDCN(i).dat_fim_ref;
                  chave_ant := lpad(ltrim(to_char(TDCN(i).COD_IDE_REL_FUNC )), 8, 0) ||
                               lpad(ltrim(to_char(TDCN(i).cod_fcrubrica)), 7, 0) ||
                               TDCN(i).cod_ide_cli_ben  ||
                               nvl(TDCN(i).dat_ini_ref,PAR_PER_PRO);
                  RUBRICA_ANT := TDCN(i).cod_fcrubrica;
                  COD_IDE_CLI_BEN_ANT := TDCN(i).cod_ide_cli_ben;
                  j := j + 1;
                  TDCT(j - 1).val_rubrica := V_VAL_RUBRICA;
                  --TDCT(j - 1).dat_ini_ref := PAR_PER_PRO;
                  V_VAL_RUBRICA := trunc(TDCN(i).val_rubrica,2);
                  TDCT.extend;
                  TDCT(j) := TDCN(i);
                  ind := i;
                ELSE  --  trunc(rdcn.val_rubrica_cheio, 2
                  V_VAL_RUBRICA := V_VAL_RUBRICA + trunc(nvl(TDCN(i).val_rubrica, 0),2);
                  TDCT(j).val_rubrica := V_VAL_RUBRICA;
                END IF;
              END IF;
            END IF;
          END LOOP;

          conta := tdcn.count;

          TDCN.delete;
          FOR I IN 1 .. TDCT.COUNT LOOP
            TDCN.extend;
            TDCN(I) := TDCT(I);
          END LOOP;

          ------------------------------------------------------
          --Tony Caravana Campos, em : 2019-04-23
          ------------------------------------------------------
          --SP_PROCESSA_RUBRICAS_EXCL;

          j:=0;
    -----------FIM DE ACUMULAC?O--------------
       FOR i in 1 .. tdcn.count LOOP
          rdcn := tdcn(i);

          if rdcn.cod_fcrubrica is not null
           -- Modificac?o Temporal 28-12-2012 para tirar e trata as rubrica
           -- com + de lancamento
           --  and rdcn.cod_fcrubrica not  in (300704,302304)
           then

            val_rubrica_supl := sp_valor_suplementar(rdcn.cod_ide_cli,
                                                     rdcn.num_matricula    ,
                                                     rdcn.cod_ide_rel_func ,
                                                     rdcn.cod_entidade     ,
                                                     rdcn.cod_fcrubrica,
                                                     rdcn.flg_natureza,
                                                     rdcn.val_rubrica,
                                                     rdcn.dat_ini_ref,
                                                     rdcn.cod_ide_cli_ben);

            IF val_rubrica_supl < 0 THEN
              RDCN.val_rubrica := RDCN.val_rubrica * -1;
              val_rubrica_supl := val_rubrica_supl * -1;
              IF RDCN.FLG_NATUREZA = 'C' THEN
                RDCN.FLG_NATUREZA := 'D';
              ELSE
                RDCN.FLG_NATUREZA := 'C';
              END IF;
            END IF;

            IF trunc(val_rubrica_supl,2) > 0 THEN
              begin


                SELECT COD_RUBRICA
                  INTO RDCN.COD_FCRUBRICA
                  FROM TB_RUBRICAS
                 WHERE COD_CONCEITO = trunc(RDCN.COD_FCRUBRICA / 100, 000)
                   AND FLG_NATUREZA = RDCN.FLG_NATUREZA
                   AND COD_ENTIDADE = COM_COD_ENTIDADE
                      --  AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)),5,0),4,2) <> '00';
                      --  AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)),6,0),5,2) <> '00'; -- alt ffranco 5/12/2006
                   AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)), 7, 0), 6, 2) IN ('50', '51');

              exception
                when no_data_found then
                  p_sub_proc_erro := 'SP_GRAVA_MASTER_PAG A1';
                  p_coderro       := SQLCODE;
                  P_MSGERRO       := 'Erro ao obter a rubrica para gravar o resumo';
                  INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                        p_coderro,
                                        'Calcula Folha',
                                        sysdate,
                                        p_msgerro,
                                        p_sub_proc_erro,
                                        RDCN.COD_IDE_CLI,
                                        RDCN.COD_FCRUBRICA);
                  VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                when others then
                  p_sub_proc_erro := 'SP_GRAVA_DETALHE_RET ERRO';
                  p_coderro       := SQLCODE;
                  P_MSGERRO       := SQLERRM;
                  INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                        p_coderro,
                                        'Calcula Folha',
                                        sysdate,
                                        p_msgerro,
                                        p_sub_proc_erro,
                                        RDCN.COD_IDE_CLI,
                                        RDCN.COD_FCRUBRICA);

                  VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              end;
            END IF;
            tdcn(i).COD_FCRUBRICA := RDCN.COD_FCRUBRICA;
            tdcn(i).val_rubrica := val_rubrica_supl;
            tdcn(i).flg_natureza := RDCN.FLG_NATUREZA;
          ELSE
            tdcn(i).val_rubrica := 0;
          END IF;
        END LOOP;
        --- Calculo de IR Da Suplementar ---
        --- Aqui Verificiar tipo de Ir
         VI_IR_EXTERIOR:=FALSE;
         VI_IR_EXTERIOR:=SP_IRRF_EXT(ANT_IDE_CLI);
         IF  NOT VI_IR_EXTERIOR  THEN

                BEGIN
                  SP_SEPARA_IRRF_SUP(IDX_IRRF,IDX_IRRF_RETRO ,IDX_IRRF_HISTO) ;
                  SP_OBTEM_IRRF(ant_ide_cli,
                                        IDX_IRRF,
                                        'N',
                                        V_VAL_IR,
                                        V_VAL_IR_13);
                   IF V_VAL_IR > 0 OR V_VAL_IR_13 > 0 THEN
                            COM_TIPO_EVENTO_ESPECIAL:='I';
                              Idx_caln  :=tdcn.COUNT;
                              tdcn.extend;
                              idx_caln        := nvl(idx_caln, 0) + 1;
                              idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;

                            SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'N');
                            -- SP_OBTEM_DETALHE_PAG13(ANT_IDE_CLI, 'D', 'K', 'N');
                   ELSE
                          vi_ir_ret.extend;
                          -- Inicializacao da variavel do ir retido, recebendo o valor do ir calculado
                          vi_ir_ret(1) := V_VAL_IR;
                          -- nao existindo IR , o valor da variavel ir retido ficara com zero.
                  END IF;
                 V_VAL_IR:=V_VAL_IR_RETRO;
                 SP_OBTEM_IRRF_RETRO(ant_ide_cli   ,
                               IDX_IRRF_RETRO      , -- IDX_CALN, -- Novo Calculo
                               'R'                 ,
                               V_VAL_IR_RETRO      ,
                               V_VAL_IR_13         ,
                               V_BASE_BRUTA_IRRF   ,
                               V_BASE_BRUTA_13_IRRF,
                               QTA_MESES);

                  V_VAL_IR:=V_VAL_IR_RETRO;
                  IF V_VAL_IR_RETRO > 0 OR V_VAL_IR_13 > 0 THEN
                      Idx_caln  :=tdcn.COUNT;
                      tdcn.extend;
                      idx_caln        := nvl(idx_caln, 0) + 1;
                      idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
                     COM_TIPO_EVENTO_ESPECIAL:='J';

                     SP_OBTEM_DETALHE_PAG_IRRF(ANT_IDE_CLI, 'R', 'J', 'N','R',V_BASE_BRUTA_IRRF,V_BASE_BRUTA_13_IRRF);
                  ELSE
                            vi_ir_ret.extend;
                            vi_ir_ret(1) := V_VAL_IR_RETRO;
                  END IF;
                  EXCEPTION
                  WHEN others then
                          p_sub_proc_erro := 'SP_GRAVA_DETALHE_RET IR';
                          p_coderro       := SQLCODE;
                          P_MSGERRO       := SQLERRM;
                          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'ERRO Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                RDCN.COD_IDE_CLI,
                                                RDCN.COD_FCRUBRICA);

                          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                   END;
         ELSE --- Calculo de IR Exterior --
            BEGIN
                IDX_IRRF:=0;
                V_VAL_IR:=0;
                IDX_IRRF:=0;
                V_VAL_IR_13 :=0;
                SP_SEPARA_IRRF_SUP(IDX_IRRF,IDX_IRRF_RETRO ,IDX_IRRF_HISTO) ;
                IDX_CALN    :=tdcn.count;
                              SP_OBTEM_IRRF(ant_ide_cli,
                              IDX_IRRF,
                              'N',
                              V_VAL_IR,
                              V_VAL_IR_13);
                  IF V_VAL_IR > 0 OR V_VAL_IR_13 > 0 THEN
                    COM_TIPO_EVENTO_ESPECIAL:='I';
                    IF PAR_TIP_PRO = 'T' THEN
                      -- Incluir a Rubrica do IR no ARRAY
                      SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'T');
                    ELSE
                      SP_OBTEM_DETALHE_PAG(ANT_IDE_CLI, 'N', 'I', 'N');
                    END IF;
                  ELSE
                    vi_ir_ret.extend;
                    -- Inicializacao da variavel do ir retido, recebendo o valor do ir calculado
                    vi_ir_ret(1) := V_VAL_IR;
                    -- nao existindo IR , o valor da variavel ir retido ficara com zero.
                  END IF;
               EXCEPTION
               WHEN OTHERS THEN
                         p_coderro       := sqlcode;
                         p_sub_proc_erro := 'SP_FOLHA_CALCULADA -Calculo IR';
                         p_msgerro       := sqlerrm;
                         INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'Calcula Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                ant_ide_cli,
                                                0);

                          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
               END;

         END IF;

          FOR i in 1 .. tdcn.count LOOP
          rdcn := tdcn(i);

          if rdcn.cod_fcrubrica is not null and
            (rdcn.tip_evento_especial in ('I','J') /*and  NOT VI_IR_EXTERIOR*/ ) then

            val_rubrica_supl := sp_valor_suplementar(rdcn.cod_ide_cli,
                                                      rdcn.num_matricula    ,
                                                     rdcn.cod_ide_rel_func ,
                                                     rdcn.cod_entidade     ,
                                                     rdcn.cod_fcrubrica,
                                                     rdcn.flg_natureza,
                                                     rdcn.val_rubrica,
                                                     rdcn.dat_ini_ref,
                                                     rdcn.cod_ide_cli_ben);

            IF val_rubrica_supl < 0 THEN
              RDCN.val_rubrica := RDCN.val_rubrica * -1;
              val_rubrica_supl := val_rubrica_supl * -1;
              IF RDCN.FLG_NATUREZA = 'C' THEN
                RDCN.FLG_NATUREZA := 'D';
              ELSE
                RDCN.FLG_NATUREZA := 'C';
              END IF;
            END IF;

            IF trunc(val_rubrica_supl,2) > 0 THEN
              begin
                SELECT COD_RUBRICA
                  INTO RDCN.COD_FCRUBRICA
                  FROM TB_RUBRICAS
                 WHERE COD_CONCEITO = trunc(RDCN.COD_FCRUBRICA / 100, 000)
                   AND FLG_NATUREZA = RDCN.FLG_NATUREZA
                   AND COD_ENTIDADE = COM_COD_ENTIDADE
                      --  AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)),5,0),4,2) <> '00';
                      --  AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)),6,0),5,2) <> '00'; -- alt ffranco 5/12/2006
                   AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)), 7, 0), 6, 2) IN ('50', '51');

              exception
                when no_data_found then
                  p_sub_proc_erro := 'SP_GRAVA_MASTER_PAG A1';
                  p_coderro       := SQLCODE;
                  P_MSGERRO       := 'Erro ao obter a rubrica para gravar o resumo';
                  INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                        p_coderro,
                                        'Calcula Folha',
                                        sysdate,
                                        p_msgerro,
                                        p_sub_proc_erro,
                                        RDCN.COD_IDE_CLI,
                                        RDCN.COD_FCRUBRICA);
                  VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                when others then
                  p_sub_proc_erro := 'SP_GRAVA_DETALHE_RET ERRO';
                  p_coderro       := SQLCODE;
                  P_MSGERRO       := SQLERRM;
                  INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                        p_coderro,
                                        'Calcula Folha',
                                        sysdate,
                                        p_msgerro,
                                        p_sub_proc_erro,
                                        RDCN.COD_IDE_CLI,
                                        RDCN.COD_FCRUBRICA);

                  VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              end;
            END IF;
            tdcn(i).COD_FCRUBRICA := RDCN.COD_FCRUBRICA;
            tdcn(i).val_rubrica := val_rubrica_supl;
            tdcn(i).flg_natureza := RDCN.FLG_NATUREZA;
          END IF;
        END LOOP;
        --------------- Fim de Calculo ---------
     --   SP_VERIF_RUBRICA_NPAGA_MES_SUP;  --continuar em retroativo comentado ROD em 5.out
     -- END IF;
    END IF;

    --SUPL_OK := 'S';

    if par_tip_pro = 'T' and vi_seq_pagamento > 1 THEN

      FOR i in 1 .. tdcn.count LOOP
        rdcn := tdcn(i);

        if rdcn.cod_fcrubrica is not null then

          val_rubrica_supl := sp_valor_suplementar_decimo(rdcn.cod_ide_cli,
                                                         rdcn.num_matricula    ,
                                                         rdcn.cod_ide_rel_func ,
                                                         rdcn.cod_entidade     ,
                                                         rdcn.cod_fcrubrica,
                                                         rdcn.flg_natureza,
                                                         rdcn.val_rubrica );

          IF RDCN.val_rubrica < 0 THEN
            RDCN.val_rubrica := RDCN.val_rubrica * -1;
            IF RDCN.FLG_NATUREZA = 'C' THEN
              RDCN.FLG_NATUREZA := 'D';
            ELSE
              RDCN.FLG_NATUREZA := 'C';
            END IF;
          END IF;

          begin
            SELECT COD_RUBRICA
              INTO RDCN.COD_FCRUBRICA
              FROM TB_RUBRICAS
             WHERE COD_CONCEITO = trunc(RDCN.COD_FCRUBRICA / 100, 000)
               AND FLG_NATUREZA = RDCN.FLG_NATUREZA
               AND COD_ENTIDADE = COM_COD_ENTIDADE
               AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)), 7, 0), 6, 2) <> '00';
          exception
            when no_data_found then
              p_sub_proc_erro := 'SP_GRAVA_MASTER_PAG A1';
              p_coderro       := SQLCODE;
              P_MSGERRO       := 'Erro ao obter a rubrica para gravar o resumo';
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                    p_coderro,
                                    'Calcula Folha',
                                    sysdate,
                                    p_msgerro,
                                    p_sub_proc_erro,
                                    RDCN.COD_IDE_CLI,
                                    RDCN.COD_FCRUBRICA);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            when others then
              p_sub_proc_erro := 'SP_GRAVA_DETALHE_RET ERRO2';
              p_coderro       := SQLCODE;
              P_MSGERRO       := SQLERRM;
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                    p_coderro,
                                    'Calcula Folha',
                                    sysdate,
                                    p_msgerro,
                                    p_sub_proc_erro,
                                    RDCN.COD_IDE_CLI,
                                    RDCN.COD_FCRUBRICA);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

          end;
          tdcn(i).COD_FCRUBRICA := RDCN.COD_FCRUBRICA;
          tdcn(i).val_rubrica := val_rubrica_supl;
          tdcn(i).flg_natureza := RDCN.FLG_NATUREZA;
        END IF;
      END LOOP;

    end if;

    v_fol := vfolha.count;

    FOR i IN 1 .. vfolha.count LOOP

      rfol := vfolha(i);

      IF rfol.TIP_PROCESSO = PAR_TIP_PRO THEN

/*        rfol.val_base_ir            := (VI_BASE_IR *
                                       VI_PERC_IR(rfol.cod_beneficio) (1)) / 100;
        rfol.val_base_ir_pag        := rfol.val_base_ir;
        rfol.val_base_ir_13         := (VI_BASE_IR_13 *
                                       VI_PERC_IR13(rfol.cod_beneficio) (1)) / 100;
        rfol.val_ir_13_ret          := V_VAL_IR_13;
        rfol.val_base_ir_13_pag     := (rfol.val_base_ir_13 *
                                       VI_PERC_IR13(rfol.cod_beneficio) (1)) / 100;
        rfol.val_base_ir_13_ret_pag := V_VAL_IR_13 *
                                       VI_PERC_IR13(rfol.cod_beneficio) (1);*/
        -- SP_OBTEM_VALORES_TOTAIS
        -- obtem valor total de credito


                  rfol.tot_cred := 0;
                  SP_OBTEM_VALORES_TOTAIS('TOT_CRED_A',
                                            RFOL.NUM_MATRICULA    ,
                                            RFOL.COD_IDE_REL_FUNC ,
                                            RFOL.COD_ENTIDADE     ,
                                        0,
                                        'N',
                                        rfol.tot_cred);
                     rfol.tot_deb := 0;
                    SP_OBTEM_VALORES_TOTAIS('TOT_DEBIT_A',
                                            RFOL.NUM_MATRICULA    ,
                                            RFOL.COD_IDE_REL_FUNC ,
                                            RFOL.COD_ENTIDADE     ,
                                            0,
                                            'N',
                                            rfol.tot_deb);

        --Agregado em 20102010 JTS
        IF rfol.val_base_prev <0 THEN
           rfol.val_base_prev:=0;
        END IF;

        if rfol.tot_deb < 0 then
          rfol.tot_deb := rfol.tot_deb * -1;
        end if;
        rfol.val_liquido := 0;
         -- trunc(rdcn.val_rubrica, 2)
         rfol.val_liquido := Round( rfol.tot_cred - rfol.tot_deb,2);

        IF v_cod_beneficio.count > 1 THEN
          IF rfol.tot_deb > 0 AND rfol.val_base_ir > 0 THEN
            begin
              rfol.val_ir_ret := vi_ir_ret(1);
            EXCEPTION
              WHEN OTHERS THEN
                p_sub_proc_erro := 'SP_GRAVA_MASTER_PAG';
                p_coderro       := SQLCODE;
                P_MSGERRO       := 'Erro ao obter o valor de IR retido no resumo';
                INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                      p_coderro,
                                      'Calcula Folha',
                                      sysdate,
                                      p_msgerro,
                                      p_sub_proc_erro,
                                      BEN_IDE_CLI,
                                      COM_COD_FCRUBRICA);

                --            RAISE ERRO;
                VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            END;

          ELSE
            rfol.val_ir_ret := 0;
          END IF;
        ELSIF V_VAL_IR > 0 THEN
          IF rfol.tot_deb > 0 THEN
            rfol.val_ir_ret := vi_ir_ret(i);
          ELSE
            rfol.val_ir_ret := 0;
          END IF;
        ELSE
          rfol.val_ir_ret := 0;
        END IF;

        --TONY CARAVANA CAMPOS - 28/11/2016 18:08
        BEGIN
          rfol.ded_base_ir      := VI_BASE_IR_ARR(rfol.cod_ide_rel_func) (1);--VI_TOT_DED;
        EXCEPTION
             WHEN OTHERS THEN
                  rfol.ded_base_ir      := 0;
        END;

        rfol.val_ir_ret_pag   := rfol.val_ir_ret;
        rfol.ded_ir_pa        := V_DED_IR_PA;
        rfol.ded_ir_doenca    := V_DED_IR_DOENCA;
        rfol.val_base_isencao := V_BASE_ISENCAO;
				
  -- ticket - 91568  21/05/2024 - Roberto        
      rfol.val_base_prev          :=  vi_base_prev; 
       rfol.val_base_ir            :=  VI_BASE_IR	;		 
       SP_OBTEM_QTD_DEPENDENTES_IR(RFOL.COD_IDE_CLI,O_VALOR => RFOL.NUM_DEP_IR);

       IF RFOL.NUM_DEP_IR IS NULL THEN
			  RFOL.NUM_DEP_IR := 0;
			 END IF;	
	
	    BEGIN

               BEGIN
               v_resumo := 'TB_Folha';
                 INSERT INTO TB_FOLHA_PAGAMENTO (
                  cod_ins ,
                  tip_processo  ,
                  per_processo  ,
                  seq_pagamento ,
                  cod_ide_cli ,
                  num_cpf ,
                  cod_entidade  ,
                  num_matricula ,
                  cod_ide_rel_func  ,
                  num_grp ,
                  nome  ,
                  cod_ide_tutor ,
                  nom_tutor ,
                  dat_processo  ,
                  val_sal_base  ,
                  tot_cred  ,
                  tot_deb ,
                  val_liquido ,
                  val_base_ir ,
                  val_ir_ret  ,
                  ded_base_ir ,
                  ded_ir_oj ,
                  ded_ir_doenca ,
                  ded_ir_pa ,
                  flg_pag ,
                  flg_ind_pago  ,
                  flg_ind_ultimo_pag  ,
                  tot_cred_pag  ,
                  tot_deb_pag ,
                  val_liquido_pag ,
                  val_base_ir_pag ,
                  val_ir_ret_pag  ,
                  val_base_ir_13  ,
                  val_ir_13_ret ,
                  val_base_ir_13_pag  ,
                  val_base_ir_13_ret_pag  ,
                  val_base_isencao  ,
                  ind_processo  ,
                  cod_banco ,
                  num_agencia ,
                  num_dv_agencia  ,
                  num_conta ,
                  num_dv_conta  ,
                  cod_tipo_conta  ,
                  val_base_prev ,
                  flg_ind_cheq  ,
                  flg_ind_analise ,
                  margem_consig ,
                  dat_pagamento ,
                  dat_ingresso  ,
                  val_base_ir_acum  ,
                  cod_dissociacao ,
                  dat_ing ,
                  dat_ult_atu ,
                  nom_usu_ult_atu ,
                  nom_pro_ult_atu,
                  nom_cargo,
                  cod_cargo,
									Num_Dep_Ir
                 ) VALUES
                 (
                  rfol.cod_ins  ,
                  rfol.tip_processo ,
                  rfol.per_processo ,
                  rfol.seq_pagamento  ,
                  rfol.cod_ide_cli  ,
                  rfol.num_cpf  ,
                  rfol.cod_entidade ,
                  rfol.num_matricula  ,
                  rfol.cod_ide_rel_func ,
                  rfol.num_grp  ,
                  rfol.nome ,
                  rfol.cod_ide_tutor  ,
                  rfol.nom_tutor  ,
                  rfol.dat_processo ,
                  rfol.val_sal_base ,
                  rfol.tot_cred ,
                  rfol.tot_deb  ,
                  rfol.val_liquido  ,
                  rfol.val_base_ir  ,
                  rfol.val_ir_ret ,
                  rfol.ded_base_ir  ,
                  rfol.ded_ir_oj  ,
                  rfol.ded_ir_doenca  ,
                  rfol.ded_ir_pa  ,
                  rfol.flg_pag  ,
                  rfol.flg_ind_pago ,
                  rfol.flg_ind_ultimo_pag ,
                  rfol.tot_cred_pag ,
                  rfol.tot_deb_pag  ,
                  rfol.val_liquido_pag  ,
                  rfol.val_base_ir_pag  ,
                  rfol.val_ir_ret_pag ,
                  rfol.val_base_ir_13 ,
                  rfol.val_ir_13_ret  ,
                  rfol.val_base_ir_13_pag ,
                  rfol.val_base_ir_13_ret_pag ,
                  rfol.val_base_isencao ,
                  rfol.ind_processo ,
                  rfol.cod_banco  ,
                  lpad(to_number(rfol.num_agencia),4,0)  , --ticket 90258 | adiconado dia 18/12/2023
                  rfol.num_dv_agencia ,
                  rfol.num_conta  ,
                  rfol.num_dv_conta ,
                  rfol.cod_tipo_conta ,
                  rfol.val_base_prev  ,
                  rfol.flg_ind_cheq ,
                  rfol.flg_ind_analise  ,
                  rfol.margem_consig  ,
                  rfol.dat_pagamento  ,
                  rfol.dat_ingresso ,
                  rfol.val_base_ir_acum ,
                  rfol.cod_dissociacao  ,
                  rfol.dat_ing  ,
                  rfol.dat_ult_atu  ,
                  rfol.nom_usu_ult_atu  ,
                  rfol.nom_pro_ult_atu ,
                  (SELECT FNC_RETORNA_NOME_CARGO (rfol.COD_INS,rfol.COD_IDE_CLI, rfol.NUM_MATRICULA, rfol.COD_IDE_REL_FUNC, rfol.PER_PROCESSO) FROM DUAL),
                  (SELECT FNC_RETORNA_COD_CARGO(rfol.COD_INS,rfol.COD_IDE_CLI, rfol.NUM_MATRICULA, rfol.COD_IDE_REL_FUNC, rfol.PER_PROCESSO) FROM DUAL),
                  nvl(rfol.num_dep_ir,0)
			            );
                  EXCEPTION
                    WHEN OTHERS THEN
                      p_sub_proc_erro := 'SP_GRAVA_MASTER_PAG';
                      p_coderro       := SQLCODE;
                      p_msgerro       := sqlerrm;
                      P_MSGERRO       := 'Erro do resumo:' ||
                                         sqlerrm;
                      INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                            p_coderro,
                                            'Calcula Folha',
                                            sysdate,
                                            p_msgerro,
                                            p_sub_proc_erro,
                                            rfol.COD_IDE_CLI,
                                            NULL);
                      VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                   END;



        EXCEPTION
          WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_GRAVA_MASTER_PAG';
            p_coderro       := SQLCODE;
            p_msgerro       := sqlerrm;
            P_MSGERRO       := 'Erro do resumo:' ||
                               sqlerrm;
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  rfol.COD_IDE_CLI,
                                  NULL);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END;
        valor := rfol.val_base_ir + rfol.ded_base_ir + rfol.ded_ir_oj +
                 rfol.ded_ir_pa + rfol.ded_ir_doenca;
        -- gravar os totais do IR
        --         SP_GRAVA_TOTAIS_FOLHA(rfol.COD_BENEFICIO,
        --                               rfol.COD_IDE_CLI,
        --                               variavel,
        --                              rfol.val_base_isencao,
        --                               rfol.ded_base_ir+rfol.ded_ir_oj + rfol.ded_ir_pa+rfol.ded_ir_doenca,
        --                               valor,
        --                               rfol.val_base_ir);

      END IF;

    END LOOP;
    COMMIT;
  END SP_GRAVA_MASTER_PAG;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DADOS_PF(IDE_CLI IN VARCHAR2,
                              I_TIPO  IN CHAR,
                              I_CPF   OUT VARCHAR2,
                              I_NOME  OUT VARCHAR2) AS
    --V_COUNT NUMBER;
  BEGIN
    IF I_TIPO = 'S' THEN
      BEGIN
        /*          SELECT PF.NUM_CPF, substr(PF.NOM_PESSOA_FISICA,1,50)
                    INTO  I_CPF, I_NOME
                    FROM TB_PESSOA_FISICA PF,
                         TB_CONCESSAO_BENEFICIO CB
                   WHERE PF.COD_INS = PAR_COD_INS
                     AND CB.COD_INS = PAR_COD_INS
                     AND CB.COD_IDE_CLI_SERV = PF.COD_IDE_CLI
                     AND CB.COD_BENEFICIO = ANT_COD_BENEFICIO;
        */
        SELECT PF.NUM_CPF, substr(PF.NOM_PESSOA_FISICA, 1, 50)
          INTO I_CPF, I_NOME
          from tb_pessoa_fisica pf
         where pf.cod_ide_cli =IDE_CLI
            and pf.cod_ins = PAR_COD_INS;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          I_CPF  := null;
          I_NOME := null;
        WHEN OTHERS THEN
          p_sub_proc_erro := 'SP_OBTEM_DADOS_PF';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter dados da pessoa fisica servidor';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                IDE_CLI,
                                0);

          --          RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
      END;
    ELSIF I_TIPO = 'T' THEN
      -- Quem recebe e o representante
      BEGIN

        SELECT PF.NUM_CPF, substr(PF.NOM_PESSOA_FISICA, 1, 50)
          INTO I_CPF, I_NOME
          FROM TB_PESSOA_FISICA PF
         WHERE PF.COD_INS = PAR_COD_INS
           AND PF.COD_IDE_CLI =
               (select RL.COD_IDE_CLI_REP
                  from TB_REPRESENTACAO_LEGAL RL
                 where rl.cod_ins = PAR_COD_INS
                   AND RL.COD_IDE_CLI = IDE_CLI
                   AND RL.DAT_INI_VIG <= PAR_PER_PRO
                   AND nvl(RL.DAT_FIM_VIG, '01/01/2055') >= PAR_PER_PRO);


      exception
        when no_data_found then
          I_CPF  := null;
          I_NOME := null;
        when too_many_rows then
          p_sub_proc_erro := 'SP_OBTEM_DADOS_PF';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Aviso - Mais de uma pessoa fisica com o mesmo CPF';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                IDE_CLI,
                                0);

          --          RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

        when others then
          p_sub_proc_erro := 'SP_OBTEM_DADOS_PF';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter dados da pessoa fisica';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                IDE_CLI,
                                0);

          --          RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
      end;
      -- MVL 8
    ELSIF I_TIPO = 'B' THEN
      -- Pensao Alimenticia
       BEGIN
        SELECT DISTINCT PF.NUM_CPF, substr(PF.NOM_PESSOA_FISICA, 1, 50)
          INTO I_CPF, I_NOME
          FROM TB_PESSOA_FISICA PF
         WHERE PF.COD_INS = PAR_COD_INS
         AND PF.COD_IDE_CLI = IDE_CLI;
       exception
        when no_data_found then
          I_CPF  := null;
          I_NOME := null;
       when others then
          p_sub_proc_erro := 'SP_OBTEM_DADOS_PF';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter dados da pessoa fisica';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                IDE_CLI,
                                0);

          --          RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
       END ;
      -- MVL 8

    END IF;

  END SP_OBTEM_DADOS_PF;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_DETALHE_PAG AS
    V_RUBRICA_SUPL   NUMBER(8) := 0;
    val_rubrica_supl number(18, 4) := 0;
    cont_detalhe     number := 0;
    i                integer := 0;
    PER_PRO_RET      date;
    i3               integer :=0;
    o number := 0;

  BEGIN

    cont_detalhe := 0;

    -- Retirar rubricas calculadas com indicador de N?o Grava detalhe de Pagamemto
    -- ind_grava_detalhe = 'N'

    FOR i in 1 .. tdcn.count LOOP

      rdcn := tdcn(i);

       FOR j in 1 .. cod_rub.count LOOP

        IF cod_rub(j) = rdcn.cod_fcrubrica AND ind_grava_detalhe(J) = 'N' AND
           cod_entidade(j) = rdcn.cod_entidade THEN

          tdcn(i).val_rubrica := 0;

        END IF;

      END LOOP;
    END LOOP;

    o := tdcn.count;

    -- Folha Normal
    FOR i in 1 .. tdcn.count LOOP
      rdcn := tdcn(i);

      IF rdcn.tip_processo = PAR_TIP_PRO THEN
         IF rdcn.des_complemento != 'Ret.M' THEN
            IF rdcn.dat_ini_ref = rdcn.per_processo and
              rdcn.nom_pro_ult_atu!='FOLHA CONSIG' then
             rdcn.des_complemento := null;
           end if;
         END IF;

        IF rdcn.per_processo = PAR_PER_PRO THEN

          IF rdcn.val_rubrica > 0 THEN
            IF rdcn.val_rubrica_cheio is null THEN --solucao temporaria para casos com val_cheio nulo ... continuar
              rdcn.val_rubrica_cheio := rdcn.val_rubrica;
            END IF;
            cont_detalhe := cont_detalhe + 1;
          BEGIN
              INSERT /*+ append */
                  INTO TB_FOLHA_PAGAMENTO_DET (
                    cod_ins           ,
                    tip_processo      ,
                    per_processo      ,
                    cod_ide_cli       ,
                    cod_ide_cli_ben   ,
                    cod_entidade      ,
                    num_matricula     ,
                    cod_ide_rel_func  ,
                    seq_pagamento     ,
                    cod_fcrubrica     ,
                    seq_vig           ,
                    val_rubrica       ,
                    num_quota         ,
                    tot_quota         ,
                    val_rubrica_cheio ,
                    val_unidade       ,
                    val_porc          ,
                    dat_ini_ref       ,
                    dat_fim_ref       ,
                    flg_natureza      ,
                    num_ord_jud       ,
                    seq_detalhe       ,
                    des_informacao    ,
                    des_complemento   ,
                    flg_ir_acumulado  ,
                    num_carga               ,
                    num_seq_controle_carga  ,
                    dat_ing                 ,
                    dat_ult_atu             ,
                    nom_usu_ult_atu         , 
                   ------- Memoria de Calculo ----
                   flg_log_calc             ,
                   cod_formula_cond         ,
                   des_condicao             ,
                   cod_formula_rubrica      ,
                   des_formula              ,
                   des_composicao                                    

                  )
                  VALUES
                    (
                    rdcn.cod_ins            ,
                    rdcn.tip_processo       ,
                    rdcn.per_processo       ,
                    rdcn.cod_ide_cli        ,
                    rdcn.cod_ide_cli_ben    ,
                    rdcn.cod_entidade       ,
                    rdcn.num_matricula      ,
                    rdcn.cod_ide_rel_func   ,
                    rdcn.seq_pagamento      ,
                    rdcn.cod_fcrubrica      ,
                    rdcn.seq_vig            ,
                    rdcn.val_rubrica        ,
                    rdcn.num_quota          ,
                    rdcn.tot_quota          ,
                    rdcn.val_rubrica_cheio  ,
                    rdcn.val_unidade        ,
                    rdcn.val_porc           ,
                    rdcn.dat_ini_ref        ,
                    rdcn.dat_fim_ref        ,
                    rdcn.flg_natureza       ,
                    rdcn.num_ord_jud        ,
                    rdcn.seq_detalhe        ,
                    rdcn.des_informacao     ,
                    rdcn.des_complemento    ,
                    rdcn.flg_ir_acumulado   ,
                    rdcn.num_carga          ,
                    rdcn.num_seq_controle_carga ,
                    rdcn.dat_ing                ,
                    rdcn.dat_ult_atu            ,
                    rdcn.nom_usu_ult_atu        ,
                    ------------Memoria de Calculo ------
                    rdcn.flg_log_calc           ,
                    rdcn.cod_formula_cond       ,
                    rdcn.des_condicao           ,
                    rdcn.cod_formula_rubrica    ,
                    rdcn.des_formula            ,
                    rdcn.des_composicao                        
                   );
           EXCEPTION
              WHEN OTHERS THEN
                p_sub_proc_erro := 'SP_GRAVA_DETALHE_PAG';
                p_coderro       := SQLCODE;
                P_MSGERRO       :=  ' Erro na gravacao: '||sqlerrm;
                INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                      p_coderro,
                                      'Calcula Folha',
                                      sysdate,
                                      p_msgerro,
                                      p_sub_proc_erro,
                                      rdcn.cod_ide_cli,
                                      --                         rdcn.cod_fcrubrica);
                                      NVL(rdcn.cod_fcrubrica, 0)); -- FFRANCO - 06052009
                VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                --       RAISE ERRO;
            END; 

          END IF;
        ELSE

              NULL;

          END IF;

        END IF;



    END LOOP;

    if cont_detalhe = 0 then
      -- utilizando rolback para que nao grave o registro da folha --
      rollback;
    end if;

    -- Folha Terceiros

  END SP_GRAVA_DETALHE_PAG;
  ----------------------------------------------------------------------------------


  FUNCTION SP_VALOR_SUPLEMENTAR(I_COD_IDE_CLI   VARCHAR2,
                                I_num_matricula VARCHAR2,
                                I_cod_ide_rel_func NUMBER,
                                I_cod_entidade  NUMBER   ,
                                I_COD_FCRUBRICA NUMBER   ,
                                I_FLG_NATUREZA  VARCHAR2,
                                I_VAL_RUBRICA   NUMBER  ,
                                I_DAT_INI_REF   DATE   ,
                                I_IDE_CLI_BEN   VARCHAR2) RETURN NUMBER IS

    -- vi_agrega_sup_true boolean := true;
    vi_existe_normal number;
    vi_valor_n       number(18, 4);
    vi_valor_rub     number(18, 4);
    V_VAL_SUPL       NUMBER(18, 4);
  BEGIN
    vi_valor_n       := 0;
    vi_existe_normal := 0;
    V_VAL_SUPL       := 0;

    IF cont_benef = 1 AND VI_SUPLEMENTAR AND
       I_COD_FCRUBRICA in (65800, 65100, 38500, 47201, 35800, 49900) THEN
      begin
        SELECT nvl(sum(DECODE(FLG_NATUREZA,
                              'C',
                              DC.VAL_RUBRICA,
                              DC.VAL_RUBRICA)),
                   0)
          INTO vi_valor_n
          FROM tb_hdet_calculado DC
         WHERE DC.COD_INS = PAR_COD_INS
           AND DC.COD_IDE_CLI = I_COD_IDE_CLI
           AND DC.TIP_PROCESSO = 'N'
           AND DC.PER_PROCESSO = PAR_PER_PRO
           AND DC.COD_FCRUBRICA = I_COD_FCRUBRICA
           AND DC.DAT_INI_REF = I_DAT_INI_REF
           AND NVL(DC.COD_IDE_CLI_BEN,0)=NVL(I_IDE_CLI_BEN,0)
        --       ACODND DC.DAT_INI_REF  = PAR_PER_PRO;   --RAO:20060504
        ;
      exception
        when no_data_found then
          vi_valor_n := 0;
          --          I_VAL_RUBRICA := 0;
        when others then
          p_sub_proc_erro := 'SP_VALOR_SUPLEMENTAR';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter o valor suplementar';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                I_COD_IDE_CLI,
                                I_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          --           RAISE ERRO;
      end;

    ELSE

      begin
        SELECT sum(DECODE(FLG_NATUREZA, 'C', DC.VAL_RUBRICA, DC.VAL_RUBRICA))
          INTO vi_valor_n
          FROM TB_FOLHA_PAGAMENTO_DET DC
         WHERE DC.COD_INS               = PAR_COD_INS
           AND DC.COD_IDE_CLI           = I_COD_IDE_CLI
           AND DC.TIP_PROCESSO          = 'N'
           AND DC.NUM_MATRICULA         = I_num_matricula
           AND DC.COD_IDE_REL_FUNC      = I_cod_ide_rel_func
           AND DC.COD_ENTIDADE          = I_cod_entidade
           AND DC.PER_PROCESSO          = PAR_PER_PRO
           AND DC.COD_FCRUBRICA         = I_COD_FCRUBRICA
           AND DC.DAT_INI_REF           = I_DAT_INI_REF
           AND NVL(DC.COD_IDE_CLI_BEN,0)=NVL(I_IDE_CLI_BEN,0)
        --       AND DC.DAT_INI_REF  = PAR_PER_PRO;   --RAO:20060504
        ;
      exception
        when no_data_found then
          vi_valor_n := 0;
          --          I_VAL_RUBRICA := 0;
        when others then
          p_sub_proc_erro := 'SP_VALOR_SUPLEMENTAR';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Aviso valor suplementar n?o encontrado';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                I_COD_IDE_CLI,
                                I_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          vi_valor_n := 0;
          --           RAISE ERRO;
      end;
    END IF;

    IF vi_valor_n is null THEN
       vi_valor_n :=0;
    END IF;
    IF trunc(I_VAL_RUBRICA,2) <> vi_valor_n THEN

      V_VAL_SUPL := I_VAL_RUBRICA - vi_valor_n;

      --         IF V_VAL_SUPL < 0 THEN
      --            V_VAL_SUPL := V_VAL_SUPL * -1;
      --         END IF;
    ELSE
      V_VAL_SUPL := 0;
    END IF;

    RETURN(V_VAL_SUPL);

  END SP_VALOR_SUPLEMENTAR;
  ----------------------------------------------------------------------------------
  FUNCTION SP_VALOR_SUPLEMENTAR_DECIMO(I_COD_IDE_CLI   VARCHAR2,
                                       I_num_matricula VARCHAR2,
                                       I_cod_ide_rel_func NUMBER,
                                       I_cod_entidade  NUMBER   ,
                                       I_COD_FCRUBRICA NUMBER,
                                       I_FLG_NATUREZA  VARCHAR2,
                                       I_VAL_RUBRICA   NUMBER) RETURN NUMBER IS

    -- vi_agrega_sup_true boolean := true;
    vi_existe_normal number;
    vi_valor_n       number(18, 4);
    vi_valor_rub     number(18, 4);
    V_VAL_SUPL       NUMBER(18, 4);
  BEGIN

    vi_existe_normal := 0;
    V_VAL_SUPL       := 0;

    IF cont_benef = 1 then
      --       VI_SUPLEMENTAR AND -- 65800, , 49900
      --       I_COD_FCRUBRICA in (  65800, 65100, 38500, 47201, 35800, 49900) THEN
      begin
        SELECT nvl(sum(DECODE(FLG_NATUREZA,
                              'C',
                              DC.VAL_RUBRICA,
                              DC.VAL_RUBRICA)),
                   0)
          INTO vi_valor_n
          FROM TB_FOLHA_PAGAMENTO_DET DC
         WHERE DC.COD_INS = PAR_COD_INS
           AND DC.COD_IDE_CLI = I_COD_IDE_CLI
           AND DC.TIP_PROCESSO = 'T'
           AND DC.PER_PROCESSO = PAR_PER_PRO
           AND DC.COD_FCRUBRICA = I_COD_FCRUBRICA
           AND DC.DAT_INI_REF = PAR_PER_PRO
        --       AND DC.DAT_INI_REF  = PAR_PER_PRO;   --RAO:20060504
        ;
      exception
        when no_data_found then
          vi_valor_n := 0;
          --          I_VAL_RUBRICA := 0;
        when others then
          p_sub_proc_erro := 'SP_VALOR_SUPLEMENTAR';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter o valor suplementar do 13?';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          --           RAISE ERRO;
      end;

    ELSE

      begin
        SELECT DECODE(FLG_NATUREZA, 'C', DC.VAL_RUBRICA, DC.VAL_RUBRICA)
          INTO vi_valor_n
          FROM TB_FOLHA_PAGAMENTO_DET DC
         WHERE DC.COD_INS               = PAR_COD_INS
           AND DC.COD_IDE_CLI           = I_COD_IDE_CLI
           AND DC.TIP_PROCESSO          = 'T'
           AND DC.NUM_MATRICULA         = I_num_matricula
           AND DC.COD_IDE_REL_FUNC      = I_cod_ide_rel_func
           AND DC.COD_ENTIDADE          = I_cod_entidade
           AND DC.PER_PROCESSO          = PAR_PER_PRO
           AND DC.COD_FCRUBRICA         = I_COD_FCRUBRICA
           AND DC.DAT_INI_REF           = PAR_PER_PRO;
      exception
        when no_data_found then
          vi_valor_n := 0;
          --          I_VAL_RUBRICA := 0;
        when others then
          p_sub_proc_erro := 'SP_VALOR_SUPLEMENTAR';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter o valor suplementar do 13?';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          --           RAISE ERRO;
      end;
    END IF;

    IF I_VAL_RUBRICA <> vi_valor_n THEN

      V_VAL_SUPL := I_VAL_RUBRICA - vi_valor_n;

      --         IF V_VAL_SUPL < 0 THEN
      --            V_VAL_SUPL := V_VAL_SUPL * -1;
      --         END IF;
    ELSE
      V_VAL_SUPL := 0;
    END IF;

    /*    IF I_VAL_RUBRICA <> vi_valor_n THEN
           IF I_FLG_NATUREZA = 'D' THEN
              vi_valor_rub := I_VAL_RUBRICA * -1;
           ELSE
              vi_valor_rub := I_VAL_RUBRICA;
           END IF;

           V_VAL_SUPL := I_VAL_RUBRICA - vi_valor_n;

           IF V_VAL_SUPL < 0 THEN
              V_VAL_SUPL := V_VAL_SUPL * -1;
           END IF;

        ELSE
           V_VAL_SUPL:=0;
        END IF;
    */
    /*
          IF I_VAL_RUBRICA <> vi_valor_n
            and vi_valor_n < I_VAL_RUBRICA then
    --        and vi_valor_n <> 0 THEN
             V_VAL_SUPL := I_VAL_RUBRICA - vi_valor_n;
    --         vi_agrega_sup := vi_agrega_sup_true;
          ELSE
              V_VAL_SUPL:=0;                -- RAO 20060504
              --  V_VAL_SUPL:= I_VAL_RUBRICA;  RAO 20060504
          END IF;
    */
    RETURN(V_VAL_SUPL);

  END SP_VALOR_SUPLEMENTAR_DECIMO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VALORES_TOTAIS(I_COD_VARIAVEL     IN  VARCHAR2,
                                    I_NUM_MATRICULA    IN VARCHAR2 ,
                                    I_COD_IDE_REL_FUNC IN NUMBER   ,
                                    I_COD_ENTIDADE     IN NUMBER   ,
                                    I_COD_RUBRICA      IN    NUMBER,
                                    i_ind_val_cheio    IN varchar2,
                                    I_VALOR            OUT NUMBER) AS
    c_comp     curform;
    vi_valor   number(18, 5);
    VI_RUBRICA NUMBER;
    NF_RUBRICA number;
    valor_temp number(18,4);

  BEGIN
    I_VALOR  := 0;
    VI_VALOR := 0;
    valor_temp :=0;

    SP_OBTEM_PARVAL_FOLHA2('TASCO', 2000, 'DESC_CONTR', desc_prev); --$3218,90

    IF PAR_TIP_PRO = 'T' THEN
      begin
        SELECT cd.cod_fcrubrica_composta
          INTO NF_RUBRICA
          FROM tb_composicao_rub cd
         WHERE cd.cod_variavel = I_COD_VARIAVEL
           AND cd.cod_ins = PAR_COD_INS
           AND cd.cod_entidade = I_COD_ENTIDADE
           AND cd.cod_fcrubrica_composta =
               DECODE(I_COD_RUBRICA,
                      0,
                      cod_fcrubrica_composta,
                      I_COD_RUBRICA)
           AND cd.dat_ini_vig <= PAR_PER_PRO
           AND (cd.dat_fim_vig >= PAR_PER_PRO or cd.dat_fim_vig is null);
      exception
        when others then
          nf_rubrica      := null;
          p_sub_proc_erro := 'SP_OBTEM_VALORES_TOTAIS';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter a rubrica composta para o 13?';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                I_COD_RUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
      end;
    ELSE
      begin
        SELECT cd.cod_fcrubrica_composta
          INTO NF_RUBRICA
          FROM tb_composicao_rub cd, tb_rubricas rp, tb_formula_calculo fc
         WHERE cd.cod_variavel = I_COD_VARIAVEL
           AND cd.cod_ins = PAR_COD_INS
           AND cd.dat_ini_vig <= PAR_PER_PRO
           AND (cd.dat_fim_vig >= PAR_PER_PRO or cd.dat_fim_vig is null)
           and rp.cod_ins = cd.cod_ins
              --        and rp.cod_rubrica = cd.cod_fcrubrica_composta
           AND cd.cod_entidade = I_COD_ENTIDADE
           AND rp.cod_entidade = cd.cod_entidade
           and fc.cod_entidade = cd.cod_entidade
           and rp.tip_evento <> 'T'
           and fc.cod_ins = rp.cod_ins
           and fc.cod_rubrica = rp.cod_rubrica
           and cd.cod_fcrubrica_composta = fc.cod_fcrubrica
           --- agregado por PEP 26012011
           ---======= CODIGO ALTERADO PARA CAMPREV RUBRICA 55400 POR 7060300
           AND ( (cd.cod_variavel  = 'BASE_PREV'
            and RP.COD_RUBRICA=55400)
            OR   (cd.cod_variavel != 'BASE_PREV')
                );
      exception
        when others then
          nf_rubrica      := null;
          p_sub_proc_erro := 'SP_OBTEM_VALORES_TOTAIS';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao obter a rubrica composta para totalizacao';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                I_COD_RUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
      end;
    END IF;

    --- Obtem rubricas da composicao
    Open c_comp for
      select cd.cod_fcrubrica_compoe
        from tb_compoe_det cd
       where cd.cod_ins = PAR_COD_INS
         and cd.cod_fcrubrica_composta = nf_rubrica
         and cd.cod_entidade_composta = I_COD_ENTIDADE
         and cd.dat_ini_vig <= PAR_PER_PRO
         and (cd.dat_fim_vig >= PAR_PER_PRO or cd.dat_fim_vig is null);
    FETCH c_comp
      into vi_rubrica;
    WHILE C_COMP%FOUND LOOP

      SP_VALOR_CALCULADO(VI_RUBRICA        ,
                         I_NUM_MATRICULA   ,
                         I_COD_IDE_REL_FUNC,
                         I_COD_VARIAVEL    ,
                         I_COD_ENTIDADE    ,
                         i_ind_val_cheio   ,
                         vi_valor);
      IF   vi_valor <> 0 THEN
              IF I_COD_VARIAVEL = 'BASE_PREV' THEN
                           I_VALOR := I_VALOR + (VI_VALOR);
                  --END IF;
              ELSE
                I_VALOR := I_VALOR + VI_VALOR;
              END IF;
       END IF;
      FETCH c_comp
        into vi_rubrica;
    END LOOP;
    CLOSE C_COMP;

  END SP_OBTEM_VALORES_TOTAIS;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DETALHE_PAG(IDE_CLI            IN VARCHAR2,
                                 FLG_PA             IN VARCHAR2,
                                 TP_EVENTO_ESPECIAL IN VARCHAR2,
                                 TP_EVENTO          IN VARCHAR2) as

    vi_rubrica      number := 0;
    vi_val_rubrica  number(18, 2) := 0;
    vi_seq_vig      number := 0;
    i_perc          number(18, 6) := 0;
    i               number := 0;
    cod_benef       number := 0;
    vi_flg_natureza varchar2(1) := null;
    val_13          number(18, 2) := 0;
    v_erro          varchar2(500) := null;
    -- variavel para diferenca havendo pagamento especial
    v_val_rub_dif number(18, 4) := 0;
    -- variavel para obter o ir do pagamento normal
    v_val_rub_pgto_normal number(18, 4) := 0;
    -- utilizar o processo para inclus?o de mais rubricas, 13?
   AA NUMBER;
   BB NUMBER;
  BEGIN

    IF (PAR_TIP_PRO = 'N' OR PAR_TIP_PRO = 'S' OR PAR_TIP_PRO = 'D' OR PAR_TIP_PRO = 'A' OR PAR_TIP_PRO = 'E') AND --ACRESCENTADO: 'D' E 'A' - 2020-02-25 #TONYCARAVANA #RESCISAO
       ((TP_EVENTO_ESPECIAL = 'I' AND TP_EVENTO = 'N') OR
       TP_EVENTO_ESPECIAL = 'S') THEN

      SELECT rr.cod_rubrica, rr.seq_vig
        INTO vi_rubrica, vi_seq_vig
        FROM tb_rubricas rr
       WHERE rr.cod_ins = PAR_COD_INS
         AND rr.tip_evento_especial = TP_EVENTO_ESPECIAL --Fixo
         AND rr.cod_entidade = COM_ENTIDADE
         AND rr.tip_evento = decode(par_tip_pro, 'S', 'N', 'D', 'N', tp_evento) --Tip_processo --ACRESCENTADO: 'D' E 'A' - 2020-02-25 #TONYCARAVANA #RESCISAO
         AND RR.DAT_INI_VIG <= PAR_PER_PRO
         AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL);
    ELSIF (TP_EVENTO_ESPECIAL = 'I' AND TP_EVENTO = 'T') THEN
      BEGIN
        SELECT rr.cod_rubrica, rr.seq_vig
          INTO vi_rubrica, vi_seq_vig
          FROM tb_rubricas rr
         WHERE rr.cod_ins = PAR_COD_INS
           AND rr.tip_evento_especial = TP_EVENTO_ESPECIAL --Fixo
           AND rr.tip_evento = decode(par_tip_pro, 'S', 'N', 'D', 'N', tp_evento) --Tip_processo --ACRESCENTADO: 'D' E 'A' - 2020-02-25 #TONYCARAVANA #RESCISAO
           AND rr.cod_entidade = COM_ENTIDADE
           AND RR.DAT_INI_VIG <= PAR_PER_PRO
           AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL);
      EXCEPTION
        WHEN OTHERS THEN

          return;

      END;
    END IF;

    IF TP_EVENTO_ESPECIAL = 'I' OR TP_EVENTO_ESPECIAL = 'A' OR
       TP_EVENTO_ESPECIAL = 'T' OR TP_EVENTO_ESPECIAL = 'S' THEN
      vi_flg_natureza := 'D';
    ELSE
      vi_flg_natureza := 'C';
    END IF;

    COM_VAL_RUBRICA_CHEIO := 0;

    FOR i IN 1 .. vfolha.count LOOP
      rfol:=vfolha(i);
      IF FLG_PA = 'S' THEN
        tdcn_pa.extend;
        vi_ir_ret.extend;
        idx_caln_pa     := nvl(idx_caln_pa, 0) + 1;
        idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;

      ELSE
        tdcn.extend;
        vi_ir_ret.extend;

        idx_caln        := nvl(idx_caln, 0) + 1;
        idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
      END IF;
      -- Inicializacao da variavel do ir retido, recebendo o valor do ir calculado
      vi_ir_ret(i) := V_VAL_IR;
      -- n?o existindo IR , o valor da variavel ir retido ficara com zero.

      cod_benef :=  vfolha(i).cod_ide_rel_func;

      IF TP_EVENTO_ESPECIAL = 'I' AND TP_EVENTO = 'T' THEN
        --          VI_BASE_BRUTA := V_VAL_IR_13;
        val_13 := VI_BASE_IR_ARR_13(cod_benef) (1);

        IF nvl(VI_BASE_BRUTA_13,0)=0 AND PAR_TIP_PRO = 'T' THEN
           i_perc := 100;
        ELSE
           i_perc := (VI_BASE_IR_ARR_13(cod_benef) (1) / VI_BASE_BRUTA_13) * 100;
        END IF;

        VI_PERC_IR(cod_benef)(1) := i_perc;
        rdcn.val_rubrica := (V_VAL_IR_13 * i_perc) / 100;
        vi_val_rubrica := rdcn.val_rubrica;
        --          vi_val_rubrica := V_VAL_IR_13;
      ELSIF TP_EVENTO_ESPECIAL = 'I' then
        if flg_pa = 'S' then
          i_perc := 100;
          VI_PERC_IR(cod_benef)(1) := i_perc;
        else
          AA:=VI_BASE_IR_ARR(cod_benef)(1) ;
          BB:=VI_BASE_IR_ARR_DED(cod_benef) (1) ;
          i_perc := ((VI_BASE_IR_ARR(cod_benef) (1)-VI_BASE_IR_ARR_DED(cod_benef) (1)  )/ ( VI_BASE_BRUTA- VI_TOT_DED_RUB_REAL)) * 100 ;
          VI_PERC_IR(cod_benef)(1) := i_perc;
        end if;
        IF VI_BASE_IR_ARR(cod_benef) (1) <> 0 THEN
          IF VI_SUPLEMENTAR AND cont_benef > 1 THEN
            i_perc := ((VI_BASE_IR_ARR(cod_benef) (1)-VI_BASE_IR_ARR_DED(cod_benef) (1)  )/ ( VI_BASE_BRUTA- VI_TOT_DED_RUB_REAL)) * 100 ;
            VI_PERC_IR(cod_benef)(1) := i_perc;
          ELSE
            IF cont_benef = 1 AND VI_SUPLEMENTAR THEN
              i_perc := 100;
              VI_PERC_IR(cod_benef)(1) := 100;
            ELSE
              i_perc := ((VI_BASE_IR_ARR(cod_benef) (1)-VI_BASE_IR_ARR_DED(cod_benef) (1)  )/ ( VI_BASE_BRUTA- VI_TOT_DED_RUB_REAL)) * 100 ;
              VI_PERC_IR(cod_benef)(1) := i_perc;
            END IF;
          END IF;
          rdcn.val_rubrica := (V_VAL_IR * i_perc) / 100;
          vi_ir_ret(i) := rdcn.val_rubrica;
          vi_val_rubrica := rdcn.val_rubrica;
          COM_VAL_RUBRICA_CHEIO := COM_VAL_RUBRICA_CHEIO + vi_val_rubrica;
        ELSE
          vi_val_rubrica := 0;
        END IF;
      ELSIF TP_EVENTO_ESPECIAL = 'A' AND TP_EVENTO = 'T' THEN
        SP_OBTEM_ANTECIPACAO(cod_benef,
                             tp_evento_especial,
                             vi_rubrica,
                             vi_val_rubrica,
                             vi_seq_vig);

        rdcn.val_rubrica := vi_val_rubrica;

      ELSIF (TP_EVENTO_ESPECIAL = 'S' OR TP_EVENTO_ESPECIAL = 'A') AND
            TP_EVENTO = 'N' THEN
        SP_OBTEM_ANTECIPACAO(cod_benef,
                             tp_evento_especial,
                             vi_rubrica,
                             vi_val_rubrica,
                             vi_seq_vig);
        IF HOUVE_RATEIO = TRUE then
          SP_RATEIO_BENEFICIO(cod_benef,
                              ANT_IDE_CLI,
                              vi_val_rubrica,
                              vi_val_rubrica,
                              VI_PERCENTUAL_RATEIO);
        END IF;
        rdcn.val_rubrica := vi_val_rubrica;
      END IF;

      IF vi_rubrica > 0 THEN
        IF FLG_PA <> 'S' THEN
          begin
            IF VI_SUPLEMENTAR and tp_evento_especial <> 'I' THEN
              IF v_base_prev(cod_benef) (1) = 0 THEN
                null;
              ELSE
                COM_VAL_RUBRICA_CHEIO := vi_val_rubrica;
                SP_INCLUI_DETALHE_PAG(rfol.num_matricula,
                                      rfol.cod_ide_rel_func,
                                      rfol.cod_entidade    ,
                                      vi_rubrica,
                                      vi_val_rubrica,
                                      vi_seq_vig,
                                      vi_flg_natureza);
              END IF;
            ELSE
              COM_VAL_RUBRICA_CHEIO := vi_val_rubrica;
                SP_INCLUI_DETALHE_PAG(rfol.num_matricula,
                                      rfol.cod_ide_rel_func,
                                      rfol.cod_entidade    ,
                                      vi_rubrica,
                                      vi_val_rubrica,
                                      vi_seq_vig,
                                      vi_flg_natureza);
            END IF;

          exception
            when no_data_found then
              v_erro := sqlerrm;
          end;

        ELSE
          COM_VAL_RUBRICA_CHEIO := vi_val_rubrica;
          SP_INCLUI_DETALHE_PAG_PA(ide_cli,
                                   cod_benef,
                                   vi_rubrica,
                                   vi_val_rubrica,
                                   vi_seq_vig,
                                   vi_flg_natureza);
        END IF;
      END IF;

    END LOOP;

    --  verifica se houve pagamento especial e efetua a diferenca do IR

    For w in 1 .. tdcn.count LOOP

      rdcn := tdcn(w);

      if rdcn.cod_fcrubrica = vi_rubrica and rdcn.tip_processo = 'E' then
        v_val_rub_dif := rdcn.val_rubrica;
      elsif rdcn.cod_fcrubrica = vi_rubrica and rdcn.tip_processo = 'N' then
        v_val_rub_pgto_normal := rdcn.val_rubrica;

        IF v_val_rub_dif > 0 and v_val_rub_pgto_normal > 0 then
          rdcn.val_rubrica := v_val_rub_pgto_normal - v_val_rub_dif;
          tdcn(w).val_rubrica := rdcn.val_rubrica;
          exit;
        END IF;

      end if;

    End Loop;

  END SP_OBTEM_DETALHE_PAG;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_DETALHE_PAG(
                                  TB_NUM_MATRICULA    IN VARCHAR2,
                                  TP_COD_IDE_REL_FUNC IN NUMBER  ,
                                  TP_COD_ENTIDADE     IN NUMBER  ,
                                  TP_RUBRICA          IN NUMBER  ,
                                  TP_VAL_RUBRICA      IN NUMBER  ,
                                  TP_SEQ_VIG          IN NUMBER  ,
                                  TP_FLG_NATUREZA     IN VARCHAR2) as

  BEGIN

    rdcn.cod_ins         := PAR_COD_INS;
    rdcn.tip_processo    := PAR_TIP_PRO;
    rdcn.per_processo    := PAR_PER_PRO;
    rdcn.cod_ide_cli     := ANT_IDE_CLI;
    rdcn.num_matricula   :=TB_NUM_MATRICULA;
    rdcn.cod_ide_rel_func:= TP_COD_IDE_REL_FUNC;
    rdcn.cod_entidade    := TP_COD_ENTIDADE;
    rdcn.seq_pagamento   := vi_seq_pagamento;
    rdcn.seq_detalhe     := idx_seq_detalhe;
    rdcn.cod_fcrubrica   := tp_rubrica;
    rdcn.val_rubrica     := tp_val_rubrica;
    rdcn.seq_vig         := tp_seq_vig;
    rdcn.num_quota       := 0;
    rdcn.flg_natureza    := tp_flg_natureza;
    rdcn.tot_quota       := 0;
    rdcn.dat_ini_ref     := PAR_PER_PRO;
    rdcn.dat_fim_ref     := NULL;
    rdcn.cod_ide_cli_ben := NULL; --verificar
    rdcn.num_ord_jud     := NULL; --varificar
    rdcn.dat_ing         := sysdate;
    rdcn.dat_ult_atu     := sysdate;
    rdcn.nom_usu_ult_atu := PAR_COD_USU;
    rdcn.nom_pro_ult_atu := 'FOLHA CALCULADA';
    rdcn.des_informacao  :=null;


    rdcn.des_complemento := null;

    rdcn.val_rubrica_cheio := COM_VAL_RUBRICA_CHEIO;

    IF trunc(tp_rubrica / 100, 000) in (70012,70014) THEN
      IF  VI_NUM_DEP_ECO > 0  THEN
         rdcn.des_informacao := to_char(VI_NUM_DEP_ECO, '09') || ' Dep.';
      ELSE
        IF  VI_IR_EXTERIOR    THEN
           rdcn.des_informacao :=  'Res. Ext.';
        END IF;
     END IF;
    END IF;
    --- Controle de Carga de consignataria 20-01-2011
    rdcn.num_carga              :=COM_NUM_CARGA;
    rdcn.num_seq_controle_carga :=COM_NUM_SEQ_CONTROLE_CARGA;  --NUM_SEQ_CONTROLE_CARGA
    rdcn.TIP_EVENTO_ESPECIAL    :=COM_TIPO_EVENTO_ESPECIAL;
    tdcn(idx_caln) := rdcn;

  END SP_INCLUI_DETALHE_PAG;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_QTD_DIAS_FALTAS
    RETURN NUMBER IS
    V_DIAS_TRAB  NUMBER;

    BEGIN

         SELECT  SUM(QTD_DIAS)
           INTO V_DIAS_TRAB
           FROM (
            SELECT ((CASE WHEN (F1.DAT_INI_FALTA <= PAR_PER_PRO) THEN FNC_GET_DIAS_MENOR_30(F1.DAT_FIM_FALTA - PAR_PER_PRO) ELSE  FNC_GET_DIAS_MENOR_30(F1.DAT_FIM_FALTA - F1.DAT_INI_FALTA) END)+1) AS QTD_DIAS
              FROM TB_FALTA F1
             WHERE PAR_PER_PRO BETWEEN

                TO_DATE('01/'||to_char(F1.DAT_INI_FALTA,'MM/YYYY'),'DD/MM/YYYY') AND F1.DAT_FIM_FALTA


               AND F1.COD_IDE_CLI      = COM_COD_IDE_CLI
               AND F1.COD_ENTIDADE     = COM_ENTIDADE
               AND F1.NUM_MATRICULA    = COM_NUM_MATRICULA
               AND F1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
               AND F1.FLG_DESCONTA     = 'S'
             ) TB1
            ;
      IF V_DIAS_TRAB < 0 THEN
        V_DIAS_TRAB:=0;
      END IF;
      RETURN (V_DIAS_TRAB);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);
              WHEN OTHERS THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);

  END SP_OBTEM_QTD_DIAS_FALTAS;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ANTECIPACAO(V_COD_BENEF           IN NUMBER,
                                 V_TIP_EVENTO_ESPECIAL IN VARCHAR2,
                                 V_COD_RUBRICA         OUT NUMBER,
                                 V_VAL_RUBRICA         OUT NUMBER,
                                 V_SEQ_VIG             OUT NUMBER) AS

  BEGIN

    v_val_rubrica := 0;
    v_cod_rubrica := 0;
    v_seq_vig     := 0;

    --   BEGIN
    --     SELECT /*+ RULE */ sum(dc.val_rubrica), RU.COD_RUBRICA_CONTRARIA, 1 -- RU.SEQ_VIG
    --       INTO v_val_rubrica, v_cod_rubrica, v_seq_vig
    --       FROM tb_det_calculado dc,
    --            tb_rubricas ru
    --      WHERE DC.COD_INS =  PAR_COD_INS
    --        AND DC.COD_BENEFICIO = V_COD_BENEF
    --        AND DC.FLG_NATUREZA = 'C'
    --        AND DC.TIP_PROCESSO = 'N'
    --        AND DC.COD_INS = RU.COD_INS
    --        AND DC.COD_FCRUBRICA = RU.COD_RUBRICA
    --        AND RU.COD_RUBRICA_CONTRARIA IS NOT NULL
    --        AND RU.TIP_EVENTO = 'N'
    --        AND DC.SEQ_VIG = RU.SEQ_VIG
    --        AND RU.TIP_EVENTO_ESPECIAL = V_TIP_EVENTO_ESPECIAL
    --        AND RU.DAT_INI_VIG <= PAR_PER_PRO
    --        AND to_char(RU.DAT_INI_VIG,'YYYY') = to_char(PAR_PER_PRO,'YYYY')
    --        AND DC.PER_PROCESSO between to_date('0101'||to_char(par_per_pro,'YYYY'),'ddmmyyyy') and add_months(par_per_pro,-1)
    --        GROUP BY RU.COD_RUBRICA_CONTRARIA, 1;
    --    EXCEPTION
    --       WHEN NO_DATA_FOUND THEN
    --         v_val_rubrica := 0;
    --         v_cod_rubrica := 0;
    --         v_seq_vig := 0;
    --       WHEN OTHERS THEN
    --        p_sub_proc_erro:= 'SP_OBTEM_ANTECIPACAO';
    --        p_coderro := SQLCODE;
    --        P_MSGERRO := SQLERRM;
    --                         INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
    --                           p_coderro,
    --                          'Calcula Folha',
    --                           sysdate,
    --                           p_msgerro,
    --                           p_sub_proc_erro,
    --                           BEN_IDE_CLI,
    --                           COM_COD_FCRUBRICA);

    --    RAISE ERRO;
    --    END;

  END SP_OBTEM_ANTECIPACAO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_13_SAIDA(V_COD_BENEFICIO IN NUMBER,
                              V_COD_RUBRICA   OUT NUMBER,
                              V_VAL_RUBRICA   OUT NUMBER,
                              V_SEQ_VIG       OUT NUMBER) AS
  BEGIN
    BEGIN
      select /*+ RULE */
       sum(dc.val_rubrica), r.cod_rubrica_contraria, r.seq_vig
        into V_VAL_RUBRICA, V_COD_RUBRICA, V_SEQ_VIG
        from tb_det_calculado dc, tb_rateio_beneficio rb, tb_rubricas r
       where dc.cod_ins = rb.cod_ins
         and rb.cod_ins = PAR_COD_INS
         and rb.cod_beneficio = V_COD_BENEFICIO
         and dc.cod_beneficio = rb.cod_beneficio
         and dc.cod_ide_cli = rb.cod_ide_cli_ben
         and dc.cod_fcrubrica = r.cod_rubrica
         and r.cod_entidade = COM_ENTIDADE
         and rb.cod_ins = r.cod_ins
         and r.cod_rubrica_contraria is not null
         and r.tip_evento_especial <> 'P' --ROD incluido em ago09
         and rb.dat_fim_vig is not null
            --   and rb.flg_reg_ativ = 'S' --efv 09022007
         and rb.dat_ini_vig <= PAR_PER_PRO --efv 11112007
         and to_char(rb.dat_fim_vig, 'YYYYMM') <>
             to_char(PAR_PER_PRO, 'YYYYMM')
         and not exists
       (select 'S'
                from tb_rateio_beneficio rbe
               where rbe.cod_ins = rb.cod_ins
                 and rbe.cod_beneficio = rb.cod_beneficio
                 and dat_fim_vig is null
                    --         and rbe.flg_reg_ativ = 'S' --efv 09022007
                 and rbe.cod_ide_cli_ben = rb.cod_ide_cli_ben)
       group by r.cod_rubrica_contraria, r.seq_vig;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_val_rubrica := 0;
        v_cod_rubrica := 0;
        v_seq_vig     := 0;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_13_SAIDA';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o 13? saida';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        --    RAISE ERRO;
    END;

  END SP_OBTEM_13_SAIDA;

  ----------------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_DET_SUSPENSO AS

    v_seq_rubrica      number := 0;
    v_des_motivo       varchar2(200) := null;
    v_val_credito      number(18, 4) := 0;
    v_val_debito       number(18, 4) := 0;
    v_val_dif          number(18, 4) := 0;
    v_ant_cod_benef    number := 0;
    v_val_rubrica_desc number(18, 4) := 0;

    -------------------------------------------

     v_val_rubrica_TESTE number(18, 4) := 0;
  BEGIN

    --
    -- Processo para inclus?o dos descontos suspensos
    --


    FOR i in 1 .. tdcd.count LOOP
      rdcd := tdcd(i);

        -- obtem valor total de credito
        v_val_credito := 0;

        v_val_dif  :=0;
                SP_OBTEM_VALORES_TOTAIS('TOT_CRED_CA',
                                      rdcd.NUM_MATRICULA   ,
                                      rdcd.COD_IDE_REL_FUNC,
                                      rdcd.COD_ENTIDADE    ,
                                      0,
                                      'N',
                                      v_val_credito);
              -- obtem valor total de debito
              v_val_debito := 0;
              SP_OBTEM_VALORES_TOTAIS('TOT_DEBIT_CA',
                                      rdcd.NUM_MATRICULA   ,
                                      rdcd.COD_IDE_REL_FUNC,
                                      rdcd.COD_ENTIDADE    ,
                                      0,
                                      'N',
                                      v_val_debito);
               -- v_val_dif := v_val_credito - abs(v_val_debito);
               -- v_val_dif := (v_val_credito - abs(v_val_debito)) * (V_ISMAX);
                v_val_dif       :=  ( v_val_credito*  V_ISMAX ) - abs(v_val_debito);



        IF v_val_debito < 0 then
          v_val_debito := v_val_debito * -1;
        END IF;


      IF rdcd.val_rubrica > 0 THEN

        IF v_val_dif >= rdcd.val_rubrica
          OR
          INSTRB(NVL(rdcd.des_complemento,' '),'- S/CM') >0
        THEN
          IF NOT INSTRB(NVL(rdcd.des_complemento,' '),'- S/CM') >0 THEN
              v_val_dif          := v_val_dif - rdcd.val_rubrica;
          END IF;
         --v_val_dif          := v_val_dif - rdcd.val_rubrica;
          rdcd.dat_ini_ref   := nvl(rdcd.dat_ini_ref  ,PAR_PER_PRO);
          v_val_rubrica_desc := rdcd.val_rubrica;


          IF PAR_TIP_PRO = 'S' THEN
            v_val_rubrica_desc := sp_valor_suplementar(rdcd.cod_ide_cli,
                                                       rdcd.num_matricula     ,
                                                       rdcd.cod_ide_rel_func  ,
                                                       rdcd.cod_entidade      ,
                                                       rdcd.cod_fcrubrica   ,
                                                       rdcd.flg_natureza    ,
                                                       rdcd.val_rubrica     ,
                                                       rdcd.dat_ini_ref     ,
                                                       rdcd.cod_ide_cli_ben);

            IF v_val_rubrica_desc < 0 THEN
              v_val_rubrica_desc := v_val_rubrica_desc * -1;
            END IF;

          END IF;

          IF v_val_rubrica_desc > 0 THEN
            RDCD.VAL_RUBRICA := v_val_rubrica_desc;
            tdcn.extend;
            idx_caln := nvl(idx_caln, 0) + 1;
            idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
            tdcd(i).val_rubrica := 0;
            COM_VAL_RUBRICA_CHEIO     := rdcd.val_rubrica;
            COM_NUM_CARGA             :=rdcd.num_carga;
            COM_NUM_SEQ_CONTROLE_CARGA:= rdcd.num_seq_controle_carga;
            SP_INCLUI_DETALHE_PAG_CONSIG(v_ant_cod_benef,
                                  rdcd.cod_fcrubrica,
                                  rdcd.val_rubrica,
                                  rdcd.seq_vig,
                                  rdcd.flg_natureza,
                                  rdcd.dat_ini_ref,
                                  rdcd.dat_fim_ref,
                                  rdcd.des_complemento);

          ELSE
            tdcd(i).val_rubrica := 0;
          END IF;


        END IF;
      else
        v_val_dif          := v_val_dif - rdcd.val_rubrica;
        rdcd.dat_ini_ref   := PAR_PER_PRO;
        v_val_rubrica_desc := rdcd.val_rubrica;
        IF v_val_rubrica_desc > 0 THEN
          RDCD.VAL_RUBRICA := v_val_rubrica_desc;
          tdcn.extend;
          idx_caln := nvl(idx_caln, 0) + 1;
          idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
          tdcd(i).val_rubrica := 0;
          COM_VAL_RUBRICA_CHEIO := rdcd.val_rubrica;
/*          SP_INCLUI_DETALHE_PAG (v_ant_cod_benef,
                                rdcd.cod_fcrubrica,
                                rdcd.val_rubrica,
                                rdcd.seq_vig,
                                rdcd.flg_natureza);*/
        ELSE
          tdcd(i).val_rubrica := 0;
        END IF;

      end if;
      --    END IF;
    END LOOP;

  END SP_INCLUI_DET_SUSPENSO;

  ----------------------------------------------------------------------------------
  PROCEDURE SP_CALC_DATAS_PROPORCIONAL AS
    qtd_dias_inicio number := 0;
    qtd_mes_inicio  number := 0;
    qtd_dias_13     number := 0;
    qtd_mes_13      number := 0;
  BEGIN

    APLICAR_ENTRADA := FALSE;
    VI_TEM_SAIDA    := FALSE;
    vi_fator_dias   := 1;
    qtd_meses_13    := 1;
    v_qtd_dias      := 30;

    IF to_char(BEN_DAT_INICIO, 'YYYYMM') = to_char(PAR_PER_PRO, 'YYYYMM') THEN
      APLICAR_ENTRADA := TRUE;
      v_dias_mes      := 30;

      --       to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD'));
      IF to_number(to_char(BEN_DAT_INICIO, 'DD')) <> 01 THEN
        v_dias_mes := 30;
        --          to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD'));

        IF to_char(BEN_DAT_FIM, 'YYYYMM') = to_char(PAR_PER_PRO, 'YYYYMM') THEN

           v_qtd_dias := to_number(to_char(BEN_DAT_FIM, 'DD')) - to_number(to_char(BEN_DAT_INICIO, 'DD')) + 1;
        ELSE
           v_qtd_dias := 30 - to_number(to_char(BEN_DAT_INICIO, 'DD')) + 1;
        END IF;
       -- AGREGADO POR JTS 04-12-2010 PARA CONTORNAR PROBLEMA DO DIA 31.
        if v_qtd_dias =0  then
           v_qtd_dias:=1;
        end if;
        --           to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD')) - to_number(to_char(BEN_DAT_INICIO,'DD')) + 1;
        IF to_char(BEN_DAT_INICIO, 'YYYY') = to_char(PAR_PER_PRO, 'YYYY') THEN
          qtd_mes_inicio := 12 - to_number(to_char(BEN_DAT_INICIO, 'MM'));
        ELSE
          qtd_mes_inicio := 12;
        END IF;
        VI_PROP_SAIDA     := (V_QTD_DIAS / V_DIAS_MES);
        --         to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD'));
       ELSE
           VI_PROP_SAIDA     := 1;

        --         to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD'));
      END IF;
    ELSIF to_char(BEN_DAT_INICIO, 'YYYYMM') < to_char(PAR_PER_PRO, 'YYYYMM') THEN
      v_dias_mes := 30;
      IF to_char(BEN_DAT_INICIO, 'YYYY') < to_char(PAR_PER_PRO, 'YYYY') THEN
        qtd_mes_13 := 12;
      ELSE
        --            qtd_dias_inicio :=  to_number(to_char(LAST_DAY(BEN_DAT_INICIO),'DD')) - to_number(to_char(BEN_DAT_INICIO,'DD')) + 1;
        qtd_dias_inicio := to_number(to_char(BEN_DAT_INICIO, 'DD')); -- + 1;
        --to_number(to_char(LAST_DAY(BEN_DAT_INICIO),'DD')) -- SUBSTITUIDO PELO 30
        --            qtd_meses_13 := to_number(to_char(BEN_DAT_FIM,'MM')) - to_number(to_char(BEN_DAT_INICIO,'MM')) -1;
        qtd_meses_13 := to_number(to_char(PAR_PER_PRO, 'MM')) -
                        to_number(to_char(BEN_DAT_INICIO, 'MM')); -- -1;
        if par_tip_pro = 'T' then
          IF qtd_dias_inicio < 15 then
            qtd_meses_13 := qtd_meses_13 + 1;
          ELSE
            VI_FATOR_DIAS := 0;
          END IF;
        else
          IF qtd_dias_inicio >30 THEN
             qtd_dias_inicio := 30;
          END IF;
          VI_FATOR_DIAS := (qtd_dias_inicio / 30);
        end if;
        APLICAR_DEC_TERCEIRO := TRUE;
        --verificar proporcao do 13
      END IF;
      IF BEN_DAT_FIM IS NOT NULL THEN
        V_FATOR_13_SAIDA := to_number(to_char(BEN_DAT_FIM, 'MM')) /
                            qtd_meses_13;
        IF to_char(BEN_DAT_FIM, 'YYYYMM') = to_char(PAR_PER_PRO, 'YYYYMM') THEN
          v_qtd_dias := to_number(to_char(BEN_DAT_FIM, 'DD'));
          IF to_number(to_char(BEN_DAT_FIM, 'DD')) = to_char(LAST_DAY(PAR_PER_PRO), 'DD') THEN
             v_qtd_dias := 30;
          END IF;
          v_dias_mes := 30;
          --                to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD'));
          v_qtd_meses  := to_number(to_char(BEN_DAT_FIM, 'MM')) -
                          to_number(to_char(BEN_DAT_INICIO, 'MM')) + 1;
          qtd_meses_13 := to_number(to_char(BEN_DAT_FIM, 'MM')) -
                          to_number(to_char(BEN_DAT_INICIO, 'MM')) - 1;
          IF v_qtd_dias > v_dias_mes THEN
               v_qtd_dias := v_dias_mes;
          END IF;
          IF to_char(BEN_DAT_INICIO, 'YYYYMM') =
             to_char(PAR_PER_PRO, 'YYYYMM') THEN
               VI_FATOR_DIAS := (v_qtd_dias / v_dias_mes);
          ELSE
               VI_FATOR_DIAS_SAIDA := (v_qtd_dias / v_dias_mes);
          END IF;
          VI_PROP_SAIDA        := (V_QTD_DIAS / V_DIAS_MES);
          APLICAR_DEC_TERCEIRO := TRUE;
          VI_TEM_SAIDA         := TRUE;
        END IF;
      END IF;
    ELSIF BEN_DAT_FIM IS NOT NULL THEN
      APLICAR_ENTRADA := TRUE;
      IF to_char(BEN_DAT_FIM, 'YYYYMM') = to_char(PAR_PER_PRO, 'YYYYMM') THEN
        v_qtd_dias := to_number(to_char(BEN_DAT_FIM, 'DD'));
        IF to_number(to_char(BEN_DAT_FIM, 'DD')) = to_char(LAST_DAY(PAR_PER_PRO), 'DD') THEN
           v_qtd_dias := 30;
        END IF;
        v_dias_mes := 30;
        --          to_number(to_char(LAST_DAY(PAR_PER_PRO),'DD'));
        v_qtd_meses          := to_number(to_char(LAST_DAY(PAR_PER_PRO), 'MM'));
        APLICAR_DEC_TERCEIRO := TRUE;
        VI_TEM_SAIDA         := TRUE;
        IF V_QTD_DIAS > V_DIAS_MES THEN
           V_QTD_DIAS := V_DIAS_MES;
        END IF;
        VI_PROP_SAIDA        := (V_QTD_DIAS / V_DIAS_MES);
      END IF;
    ELSE
      APLICAR_DEC_TERCEIRO := FALSE;
    END IF;
    -- MVL
    IF PAR_TIP_PRO = 'R' AND PAR_PER_PRO <> PAR_DATA_PRIMEIRO THEN
      IF to_number(to_char(BEN_DAT_INICIO, 'DD')) <> 01 THEN
        v_qtd_dias := 30 - to_number(to_char(BEN_DAT_INICIO, 'DD')) + 1;
      ELSE
        v_qtd_dias := to_number(to_char(PAR_DATA_PRIMEIRO, 'DD'));
      END IF;
      v_dias_mes := 30;
      --      to_number(to_char(LAST_DAY(PAR_DATA_PRIMEIRO),'DD'));
      IF V_QTD_DIAS > V_DIAS_MES THEN
         V_QTD_DIAS := V_DIAS_MES;
      END IF;
      ----- VERIFICAR JTS 30092010 OJO PEPE
      iF PAR_PER_PRO >= BEN_DAT_INICIO THEN
        V_QTD_DIAS:=30;
      END IF;
      VI_PROP_SAIDA     := (V_QTD_DIAS / V_DIAS_MES);
      VI_FATOR_DIAS     := (V_QTD_DIAS / V_DIAS_MES);
      VI_FATOR_DIAS_RET := (((v_dias_mes - v_qtd_dias) + 1) / v_dias_mes);
      PAR_DATA_PRIMEIRO := PAR_PER_PRO;
    END IF;

  END SP_CALC_DATAS_PROPORCIONAL;
  ----------------------------------------------------------------------------------
      PROCEDURE SP_INS_DETCAL_RET AS

    NVEZES NUMBER := 0;

    V_DUAS_VEZES BOOLEAN;

    dat_aux date;

    rec_parc tb_det_calculado_parc%rowtype;
    i        number;
    cont_ret number;

    nvezes_credito  number := 0;
    nvezes_debito   number := 0;
    v_fato_correcao char(1) := 'N';

    v_percentual_desc      number(18, 4) := 0;
    v_valor_benef          number(18, 4) := 0;
    v_valor_bruto          number(18, 4) := 0;
    v_valor_descontos      number(18, 4) := 0;
    v_valor_total_desconto number(18, 4) := 0;

    ----- ffranco 02/2007******************************
    v_val_credito   number(18, 4) := 0;
    v_val_debito    number(18, 4) := 0;
    v_val_dif       number(18, 4) := 0;
    v_ant_cod_benef number := 0;
    --- ffranco 02/2007
    INDEX_BEN         NUMBER ;
    COD_BENEFICIO_RET NUMBER;
   --- DEFINIC?O DE VARIAVEIS
  RET_cod_ins                NUMBER(8);
  RET_tip_processo           CHAR(1);
  RET_per_processo           DATE ;
  RET_cod_ide_cli            VARCHAR2(20);
  RET_cod_ide_cli_ben        VARCHAR2(20);
  RET_cod_entidade           NUMBER(8);
  RET_num_matricula          VARCHAR2(20);
  RET_cod_ide_rel_func       NUMBER(20) ;
  RET_seq_pagamento          NUMBER(8) ;
  RET_cod_fcrubrica          NUMBER(8);
  RET_seq_vig                NUMBER;
  RET_val_rubrica            NUMBER(12,4);
  RET_num_quota              NUMBER;
  RET_tot_quota              NUMBER;
  RET_val_rubrica_cheio      NUMBER(12,4) ;
  RET_val_unidade            NUMBER(12,4);
  RET_val_porc               NUMBER(12,4);
  RET_dat_ini_ref            DATE;
  RET_dat_fim_ref            DATE;
  RET_flg_natureza           CHAR(1) ;
  RET_num_ord_jud            NUMBER(8);
  RET_flg_ir_acumulado       CHAR(1);
  RET_seq_detalhe            NUMBER(8);
  RET_des_informacao         VARCHAR2(10);
  RET_des_complemento        VARCHAR2(15);
  RET_ind_inclui_folha       CHAR(1);
  RET_ind_processo           CHAR(1);
  RET_dat_ing                DATE;
  RET_dat_ult_atu            DATE;
  RET_nom_usu_ult_atu        VARCHAR2(20);
  RET_nom_pro_ult_atu        VARCHAR2(20);
  RET_RET_SUP                CHAR(1);
  RET_TIP_EVENTO_ESPECIAL    CHAR(1);
  val_rubrica_supl    number(18, 4) := 0;
  TOT_VAL_RUB_RET     number;
  PER_PRO_RET         date;
  CUR_COMPATIV_RET     curform;
  CUR_COMPARC_RET     curparc;
  PCOD_IDE_CLI        VARCHAR2(20);


    VAL_PARC_CRED  NUMBER(18, 4);
    VAL_PARC_DEBIT NUMBER(18, 4);
    VAL_PARC       NUMBER(18, 4) := 0;
  begin
    PARCELA := NULL;
    parc.delete;
    idx_parcela    := 0;
    VAL_PARC_CRED  := 0;
    VAL_PARC_DEBIT := 0;
    cont_ret       := 0;

    BEGIN

      FOR  INDEX_BEN   IN 1 .. vfolha.count LOOP
         RFOL                     := vfolha( INDEX_BEN  );
         RET_COD_IDE_CLI          := rfol.COD_IDE_CLI;
         RET_COD_ENTIDADE         := rfol.cod_entidade;
         RET_NUM_MATRICULA        := rfol.num_matricula;
         RET_COD_IDE_REL_FUNC     := rfol.cod_ide_rel_func;

                --  verifica quantidades para parcelamento
                begin
                  select fator_correcao,
                         nvl(qtd_parc_credito, 0),
                         nvl(qtd_parc_debito, 1)
                    into v_fato_correcao, nvezes_credito, nvezes_debito
                    from tb_casos_ret_folha
                   where cod_ide_cli = ant_ide_cli
                     and dat_periodo_comp = PAR_PER_REAL
                     and rownum < 2;
                exception
                  when others then
                    v_fato_correcao := 'N';
                    nvezes_credito  := 1;
                    nvezes_debito   := 1;
                end;

                SUPL_OK := 'N';
                -- MVL
                OPEN CUR_COMPATIV_RET FOR


                   SELECT       cod_ins,
                                tip_processo,
                                per_processo,
                                cod_ide_cli,
                                cod_ide_cli_ben,
                                cod_entidade,
                                NUM_MATRICULA,
                                cod_ide_rel_func,
                                1 AS SEQ_PAGAMENTO,
                                TRUNC(   cod_fcrubrica/100),
                                seq_vig,
                                val_rubrica,
                                num_quota,
                                tot_quota,
                                val_rubrica_cheio ,
                                val_unidade ,
                                val_porc    ,
                                dat_ini_ref,
                                dat_fim_ref,
                                flg_natureza,
                                num_ord_jud,
                                flg_ir_acumulado ,
                                'R',
                                DES_INFORMACAO,
                                DES_COMPLEMENTO,
                                ind_inclui_folha,
                                ind_processo,
                                TIP_EVENTO_ESPECIAL
                     INTO
                                RET_cod_ins,
                                RET_tip_processo,
                                RET_per_processo,
                                RET_cod_ide_cli,
                                RET_cod_ide_cli_ben,
                                RET_cod_entidade,
                                RET_NUM_MATRICULA,
                                RET_cod_ide_rel_func,
                                RET_SEQ_PAGAMENTO,
                                RET_cod_fcrubrica ,
                                RET_seq_vig,
                                RET_val_rubrica,
                                RET_num_quota,
                                RET_tot_quota,
                                RET_val_rubrica_cheio ,
                                RET_val_unidade ,
                                RET_val_porc,
                                RET_dat_ini_ref,
                                RET_dat_fim_ref,
                                RET_flg_natureza,
                                RET_num_ord_jud,
                                RET_flg_ir_acumulado,
                                RET_RET_SUP,
                                RET_DES_INFORMACAO,
                                RET_DES_COMPLEMENTO,
                                RET_ind_inclui_folha,
                                RET_ind_processo,
                                RET_TIP_EVENTO_ESPECIAL


                     FROM (

                          SELECT
                                RET.cod_ins,
                                tip_processo,
                                per_processo,
                                RET.cod_ide_cli,
                                RET.cod_ide_cli_ben,
                                RET.cod_entidade,
                                RET.NUM_MATRICULA,
                                RET.cod_ide_rel_func,
                                1 AS SEQ_PAGAMENTO,
                                RET.cod_fcrubrica  ,
                                RET.seq_vig,
                                RET.val_rubrica,
                                RET.num_quota,
                                RET.tot_quota,
                                RET.val_rubrica_cheio,
                                RET.val_unidade ,
                                RET.val_porc  ,
                                RET.dat_ini_ref,
                                RET.dat_fim_ref,
                                RET.flg_natureza,
                                RET.num_ord_jud,
                                RET.flg_ir_acumulado,
                                'R',
                                RET.DES_INFORMACAO,
                                RET. DES_COMPLEMENTO,
                                RET.ind_inclui_folha,
                                RET.ind_processo,
                                RU.TIP_EVENTO_ESPECIAL
                             FROM tb_valor_npago_ret_ativo    RET,
                                  TB_RUBRICAS RU
                            WHERE RET.cod_ins          = PAR_COD_INS
                              AND cod_ide_cli          = RET_COD_IDE_CLI
                              AND ret.num_matricula    = RET_NUM_MATRICULA
                              AND ret.cod_ide_rel_func  = RET_COD_IDE_REL_FUNC
                              AND  ret.cod_entidade    = RET_COD_ENTIDADE
                              AND per_processo = PAR_PER_PRO
                              AND (dat_ini_ref < PAR_PER_PRO or
                                  (dat_ini_ref <= PAR_PER_PRO and
                                  PAR_TIP_PRO IN ( 'S','N', 'D')))
                              AND tip_processo IN ('R', 'T')
                              AND ind_processo = 'S'
                              AND ind_inclui_folha = 'S'
                              AND RU.COD_INS       = RET.COD_INS
                              AND RU.COD_ENTIDADE  = RET.COD_ENTIDADE
                              AND RU.COD_RUBRICA   = RET.COD_FCRUBRICA

-- 19072022 adicionar aqui inicio
                              AND not (RU.COD_RUBRICA IN (95350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('06')
                              AND RET.VAL_RUBRICA = '1574,37'
                              and ret.num_matricula in (14))

                              AND not (RU.COD_RUBRICA IN (95350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('06')
                              AND RET.VAL_RUBRICA = '452,80'
                              and ret.num_matricula in (28))

                              AND not (RU.COD_RUBRICA IN (95350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('06')
                              AND RET.VAL_RUBRICA = '1131,32'
                              and ret.num_matricula in (31))

                              AND not (RU.COD_RUBRICA IN (4750)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('05')
                              AND RET.VAL_RUBRICA = '1794,78'
                              and ret.num_matricula in (31))

                              AND not (RU.COD_RUBRICA IN (95350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('06')
                              AND RET.VAL_RUBRICA = '2984,87'
                              and ret.num_matricula in (1))

                              AND not (RU.COD_RUBRICA IN (151)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('05')
                              AND RET.VAL_RUBRICA = '10535,58'
                              and ret.num_matricula in (1))

                              AND not (RU.COD_RUBRICA IN (12350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('06')
                              AND RET.VAL_RUBRICA = '111,96'
                              and ret.num_matricula in (12))

                              AND not (RU.COD_RUBRICA IN (150)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('12')
                              AND RET.VAL_RUBRICA = '8668,21'
                              and ret.num_matricula in (47))

                              AND not (RU.COD_RUBRICA IN (150)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('12')
                              AND RET.VAL_RUBRICA = '24,99'
                              and ret.num_matricula in (47))

                              AND not (RU.COD_RUBRICA IN (3050)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('12')
                              AND RET.VAL_RUBRICA = '565,32'
                              and ret.num_matricula in (47))

                              AND not (RU.COD_RUBRICA IN (95350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('12')
                              AND RET.VAL_RUBRICA = '1010,11'
                              and ret.num_matricula in (65))

                              AND not (RU.COD_RUBRICA IN (7350)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('12')
                              AND RET.VAL_RUBRICA = '868,45'
                              and ret.num_matricula in (379166))

                              AND not (RU.COD_RUBRICA IN (11351)
                              AND TO_NUMBER(TO_CHAR(ret.dat_ini_ref, 'MM')) in ('12')
                              AND RET.VAL_RUBRICA = '644,55'
                              and ret.num_matricula in (58))


-- 19072022 adicionar aqui fim
                            )
                    GROUP BY    cod_ins,
                                tip_processo,
                                per_processo,
                                cod_ide_cli,
                                cod_ide_cli_ben,
                                cod_entidade,
                                NUM_MATRICULA,
                                cod_ide_rel_func,
                                1  ,
                                TRUNC(  cod_fcrubrica/100),
                                seq_vig,
                                val_rubrica,
                                num_quota,
                                tot_quota,
                                val_rubrica_cheio ,
                                val_unidade ,
                                val_porc ,
                                dat_ini_ref,
                                dat_fim_ref,
                                flg_natureza,
                                num_ord_jud,
                                flg_ir_acumulado ,
                                'R',
                                DES_INFORMACAO,
                                DES_COMPLEMENTO,
                                ind_inclui_folha,
                                ind_processo,
                                TIP_EVENTO_ESPECIAL
                   HAVING ABS(SUM(DECODE(FLG_NATUREZA, 'C', val_rubrica, val_rubrica * -1))) > 0;

                FETCH CUR_COMPATIV_RET
                  INTO     RET_cod_ins,
                                RET_tip_processo,
                                RET_per_processo,
                                RET_cod_ide_cli,
                                RET_cod_ide_cli_ben,
                                RET_cod_entidade,
                                RET_NUM_MATRICULA,
                                RET_cod_ide_rel_func,
                                RET_SEQ_PAGAMENTO,
                                RET_cod_fcrubrica ,
                                RET_seq_vig,
                                RET_val_rubrica,
                                RET_num_quota,
                                RET_tot_quota,
                                RET_val_rubrica_cheio ,
                                RET_val_unidade ,
                                RET_val_porc ,
                                RET_dat_ini_ref,
                                RET_dat_fim_ref,
                                RET_flg_natureza,
                                RET_num_ord_jud,
                                RET_flg_ir_acumulado ,
                                RET_RET_SUP,
                                RET_DES_INFORMACAO,
                                RET_DES_COMPLEMENTO,
                                RET_ind_inclui_folha,
                                RET_ind_processo,
                                RET_TIP_EVENTO_ESPECIAL  ;

                WHILE CUR_COMPATIV_RET%FOUND LOOP
                  BEGIN
     -------------------------- NOVA AGRUPAC?O ------ 08-08-2012
                     IF RET_FLG_NATUREZA = 'C' THEN
                       RET_COD_FCRUBRICA :=RET_COD_FCRUBRICA||'51';
                       RET_FLG_NATUREZA  :='C';
                    ELSE
                       RET_COD_FCRUBRICA := RET_COD_FCRUBRICA||'50';
                       RET_VAL_RUBRICA   := ABS(RET_VAL_RUBRICA) ;
                       RET_FLG_NATUREZA  :='D';
                    END IF;

     --------------------------------------------------------
                    IF RET_RET_SUP <> 'S' THEN
                      IF vi_suplementar THEN
                        SUPL_OK := 'N';
                      END IF;
                    ELSE
                      SUPL_OK := 'S';
                    END IF;

                    BEGIN

                      IF RET_FLG_NATUREZA = 'C' THEN
                        VAL_PARC_CRED := VAL_PARC_CRED + RET_val_rubrica;
                      ELSE
                        VAL_PARC_DEBIT := VAL_PARC_DEBIT + RET_val_rubrica;
                      END IF;

                      idx_parcela := idx_parcela + 1;

                      idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;

                      parc.extend;

                      rdcn.cod_ins            := RET_COD_INS;
                      rdcn.tip_processo       := PAR_TIP_PRO;
                      rdcn.per_processo       := PAR_PER_PRO;
                      rdcn.cod_ide_cli        := RET_COD_IDE_CLI;
                      rdcn.num_matricula      := RET_num_matricula;
                      rdcn.cod_ide_rel_func   := RET_cod_ide_rel_func;
                      rdcn.cod_entidade       := RET_cod_entidade;
                      rdcn.seq_pagamento      := vi_seq_pagamento;
                      rdcn.seq_detalhe        := idx_seq_detalhe;
                      rdcn.cod_fcrubrica      := RET_COD_FCRUBRICA;
                      rdcn.seq_vig            := RET_SEQ_VIG;
                      rdcn.val_rubrica        := RET_VAL_RUBRICA;
                      rdcn.val_rubrica_cheio  := RET_VAL_RUBRICA;
                      rdcn.num_quota          := RET_NUM_QUOTA;
                      rdcn.flg_natureza       := RET_flg_natureza;
                      rdcn.tot_quota          := RET_tot_quota;
                      rdcn.dat_ini_ref        := nvl(RET_DAT_INI_REF, PER_PRO_RET);
                      rdcn.dat_fim_ref        := RET_dat_fim_ref;
                      rdcn.num_ord_jud        := RET_NUM_ORD_JUD;
                      rdcn.cod_ide_cli_ben    := RET_COD_IDE_CLI_BEN;
                      rdcn.dat_ing            := sysdate;
                      rdcn.dat_ult_atu        := sysdate;
                      rdcn.nom_usu_ult_atu    := RET_nom_usu_ult_atu;
                      rdcn.nom_pro_ult_atu    := 'FOLHA CALCULADA';
                      rdcn.des_informacao     := RET_DES_INFORMACAO;
                      rdcn.des_complemento    := ret_DES_complemento;
                      rdcn.cod_entidade       := ret_cod_entidade;
                      rdcn.tip_evento_especial:= RET_TIP_EVENTO_ESPECIAL;
                      rdcn.tip_processo_real  := RET_TIP_PROCESSO;

                       ------------- Memoria de Calculo -------------- 14-09-201
                      rdcn.flg_log_calc         :=  null;
                      rdcn.cod_formula_cond     :=  null;
                      rdcn.des_condicao         :=  null;
                      rdcn.cod_formula_rubrica  :=  null;
                      rdcn.des_formula          :=  null;
                      rdcn.des_composicao       :=  null;
        ---------------------------------------------------------


                      parc(idx_parcela)       := rdcn;

                    END;

                  END;
                  FETCH CUR_COMPATIV_RET
                    INTO        RET_cod_ins,
                                RET_tip_processo,
                                RET_per_processo,
                                RET_cod_ide_cli,
                                RET_cod_ide_cli_ben,
                                RET_cod_entidade,
                                RET_NUM_MATRICULA,
                                RET_cod_ide_rel_func,
                                RET_SEQ_PAGAMENTO,
                                RET_cod_fcrubrica ,
                                RET_seq_vig,
                                RET_val_rubrica,
                                RET_num_quota,
                                RET_tot_quota,
                                RET_val_rubrica_cheio ,
                                RET_val_unidade ,
                                RET_val_porc  ,
                                RET_dat_ini_ref,
                                RET_dat_fim_ref,
                                RET_flg_natureza,
                                RET_num_ord_jud,
                                RET_flg_ir_acumulado ,
                                RET_RET_SUP,
                                RET_DES_INFORMACAO,
                                RET_DES_COMPLEMENTO,
                                RET_ind_inclui_folha,
                                RET_ind_processo,
                                RET_TIP_EVENTO_ESPECIAL ;
               END LOOP;
                close CUR_COMPATIV_RET;
         END LOOP;
                --    - VAL_PARC_DEBIT obedecer de acordo com a quantidade na tb_casos_ret_folha
                --    - caso n?o esteja cadastrado utilizar o default das faixas
                IF nvezes_credito = 0 THEN
                  IF (VAL_PARC_CRED) > 5000 AND (VAL_PARC_CRED) <= 10000 THEN
                    NVEZES       := 1; -- ERA 2
                    V_DUAS_VEZES := TRUE;
                  ELSIF (VAL_PARC_CRED) > 10000 AND (VAL_PARC_CRED) <= 20000 THEN
                    NVEZES       := 1; -- ERA 3
                    V_DUAS_VEZES := TRUE;
                  ELSIF (VAL_PARC_CRED) > 20000 AND (VAL_PARC_CRED) <= 30000 THEN
                    NVEZES       := 1; -- ERA 4
                    V_DUAS_VEZES := TRUE;
                  ELSIF (VAL_PARC_CRED) > 30000 AND (VAL_PARC_CRED) <= 500000 THEN
                    NVEZES       := 1; -- ERA 5
                    V_DUAS_VEZES := TRUE;
                  ELSIF (VAL_PARC_CRED) > 500000 THEN
                    V_DUAS_VEZES := null;
                    NVEZES       := 1; -- ERA 0
                    FOR I IN 1 .. PARC.COUNT LOOP

                      RDCN := NULL;
                      RDCN := PARC(I);
                     END LOOP;
                    return;
                  ELSE
                    V_DUAS_VEZES := FALSE;
                    NVEZES       := 1;
                  END IF;
                ELSIF nvezes_credito = 1 THEN
                  V_DUAS_VEZES := FALSE;
                  NVEZES       := nvezes_credito;
                ELSE
                  V_DUAS_VEZES := TRUE;
                  NVEZES       := nvezes_credito;
                END IF;

                -- tb_valor_acima_ret

                FOR I IN 1 .. PARC.COUNT LOOP

                  IF parc(i).flg_natureza = 'C' THEN

                    IF parc(i).VAL_RUBRICA > 0 THEN
                      --x.VAL_RUBRICA>0 then
                      tdcn.extend;
                      idx_caln        := nvl(idx_caln, 0) + 1;
                      idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
                      val_parc        := parc(i).VAL_RUBRICA;
                      FOR J IN 1 .. NVEZES LOOP

                        IF V_DUAS_VEZES THEN
                          parc(i).VAL_RUBRICA := (val_parc / NVEZES);
                          parc(i).tot_quota := NVEZES;
                          IF J > 1 THEN
                            dat_aux := ADD_MONTHS(PAR_PER_PRO, (J - 1));
                            parc(i).PER_PROCESSO := ADD_MONTHS(PAR_PER_PRO, (J - 1));
                            idx_caln := nvl(idx_caln, 0) + 1;
                            idx_seq_detalhe := idx_seq_detalhe + 1;
                            tdcn.extend;
                            parc(i).seq_detalhe := idx_seq_detalhe;
                            IF NVEZES > 1 THEN
                              parc(i).des_complemento := 'Parc ' || j || '/' || NVEZES;
                            END IF;
                            parc(i).num_quota := J;
                          ELSE
                            parc(i).num_quota := 1;
                            IF NVEZES > 1 THEN
                              parc(i).des_complemento := 'Parc ' || j || '/' || NVEZES;
                            END IF;
                          END IF;
                          tdcn(idx_caln) := parc(i);
                        ELSE
                          parc(i).num_quota := 1;
                          parc(i).tot_quota := 1;
                          parc(i).seq_detalhe := idx_caln;
                          tdcn(idx_caln) := parc(i);
                          parc(i).des_complemento := 'Ret.';
                          exit;
                        END IF;
                      END LOOP;
                    END IF;
                  END IF;
                END LOOP;

                -- Parcelamento para debito

                NVEZES :=1;-- nvezes_debito;

                FOR I IN 1 .. PARC.COUNT LOOP

                  IF PARC(i).COD_FCRUBRICA NOT IN (65100, 65151) THEN
                    -- n?o parcelar desconto de FUNPREV

                    IF parc(i).flg_natureza = 'D' THEN

                      IF parc(i).VAL_RUBRICA > 0 THEN
                        --x.VAL_RUBRICA>0 then
                        tdcn.extend;
                        idx_caln := nvl(idx_caln, 0) + 1;
                        idx_seq_detalhe := idx_seq_detalhe + 1;
                        val_parc := parc(i).VAL_RUBRICA;
                        parc(i).VAL_RUBRICA := (val_parc / NVEZES);
                        parc(i).tot_quota := NVEZES;

                        FOR J IN 1 .. NVEZES LOOP

                          IF J > 1 THEN
                            dat_aux := ADD_MONTHS(PAR_PER_PRO, (J - 1));
                            parc(i).PER_PROCESSO := ADD_MONTHS(PAR_PER_PRO, (J - 1));
                            idx_caln := nvl(idx_caln, 0) + 1;
                            idx_seq_detalhe := idx_seq_detalhe + 1;
                            tdcn.extend;
                            parc(i).seq_detalhe := idx_seq_detalhe;
                            IF nvezes > 1 THEN
                              parc(i).des_complemento := 'Parc ' || j || '/' || NVEZES;
                            END IF;
                            parc(i).num_quota := J;
                          ELSE
                            parc(i).num_quota := 1;
                            parc(i).seq_detalhe := idx_seq_detalhe;
                            IF NVEZES > 1 THEN
                              parc(i).des_complemento := 'Parc ' || j || '/' || NVEZES;
                            END IF;
                          END IF;
                          tdcn(idx_caln) := parc(i);
                        END LOOP;
                      END IF;
                    END IF;
                  ELSE
                    tdcn.extend;
                    idx_caln := nvl(idx_caln, 0) + 1;
                    idx_seq_detalhe := idx_seq_detalhe + 1;
                    parc(i).seq_detalhe := idx_seq_detalhe;
                    tdcn(idx_caln) := parc(i);

                  END IF;
                END LOOP;
      exception
        when others then
          p_sub_proc_erro := 'SP_OBTEM_RETROATIVO';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'ERRO AO OBTER  RETROATIVO';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                ANT_IDE_CLI,
                                NULL);

       end;
  END SP_INS_DETCAL_RET;
    ----------------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_MASTER_RET AS

    RFOL_TEMP          TB_FOLHA_RET%ROWTYPE;
    I                  NUMBER;
    VPER_PROCESSO_REAL DATE;
  BEGIN
    FOR I IN 1 .. VFOLHA.COUNT LOOP
      RFOL := VFOLHA(I);
      SELECT ADD_MONTHS(LAST_DAY(SYSDATE) + 1, -1)
        INTO VPER_PROCESSO_REAL
        FROM DUAL;
      BEGIN
         null;
        EXCEPTION
        WHEN OTHERS THEN
          p_sub_proc_erro := 'SP_GRAVA_MASTER_RET';
          p_coderro       := SQLCODE;
          P_MSGERRO       := 'Erro ao incluir no resumo do retroativo';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          --         RAISE ERRO;
      END;

    END LOOP;

  END SP_GRAVA_MASTER_RET;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_DETALHE_RET AS

    RDCN                   TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
    RDCD                   TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
    RDCN_CON               TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- conceito
    RUBRICA_ANT            NUMBER;
    COD_IDE_CLI_BEN_ANT    TB_DET_CALCULADO_ATIV_ESTRUC.COD_IDE_CLI_BEN%type;
    CONT_DETALHE_TDCN      number := 0;
    CONT_DETALHE_TVAL      number := 0;
    I                      NUMBER;
    CUR_COMPL_RET          curform;
    CRET_COD_INS           NUMBER;
    CRET_TIP_PROCESSO      VARCHAR2(1);
    CRET_COD_IDE_CLI       VARCHAR2(20);
    CRET_NUM_MATRICULA     NUMBER;
    CRET_COD_IDE_REL_FUNC  NUMBER;
    CRET_COD_ENTIDADE      NUMBER;
    CRET_SEQ_PAGAMENTO     NUMBER;
    CRET_COD_FCRUBRICA     NUMBER;
    CRET_SEQ_VIG           NUMBER;
    CRET_VAL_RUBRICA       NUMBER;
    CRET_FLG_NATUREZA      VARCHAR2(1);
    CRET_COD_IDE_CLI_BEN   VARCHAR2(20);
    CRET_NUM_ORD_JUD       NUMBER;
    CRET_DAT_INI_REF       DATE;
    CRET_VAL_RUBRICA_CHEIO NUMBER;
    V_EXIST                BOOLEAN;
    V_EVENTO_ESPEC         VARCHAR2(1);
    V_VAL_RUBRICA          NUMBER(18, 4) := 0;
    V_VAL_RUBRICA_CORRECAO NUMBER(18, 4) := 0;
    ind                    NUMBER := 0;
    j                      number := 0;
    k                      number := 0;
    m                      number := 0;
    chave_ant              VARCHAR2(33);
    vc_nao_parcela         varchar2(1) := 'N';
    conta                  number(4) := 0;

    vi_rubrica               number;
    vi_seq_vig               number;
    val_valor_correcao       number(18, 4) := 0;
    w_qtd_mes_fator_correcao number(3) := 0;
    w_data_fator_correcao    date := null;
    w_calcula_correcao       BOOLEAN;

    dat_ini_ref_ant           date;
    dat_fim_ref_ant           date;

    type con_ret is table of number index by binary_integer;

    conceito_ret con_ret;

  BEGIN
    conta := tdcn.count;

    TDCA.delete;
    idx_ret13 := 0;



    FOR I IN 1 .. TDCN.COUNT LOOP
      IF (TDCN(i).val_rubrica > 0 or TDCN(i).val_rubrica is not null ) and
         TDCN(i).cod_fcrubrica  not in (1860150,1860151,1860155,1860156)  then
        IF I = 1 THEN
          dat_ini_ref_ant:=TDCN(i).dat_ini_ref;
          dat_fim_ref_ant:=TDCN(i).dat_fim_ref;
          chave_ant           := lpad(ltrim(to_char(TDCN(i).cod_ide_rel_func)),
                                      8,
                                      0) ||
                                 lpad(ltrim(to_char(TDCN(i).cod_fcrubrica)),
                                      7,
                                      0) ||   nvl(TDCN(i).cod_ide_cli_ben, '');
                                       --  ||  nvl(TDCN(i).dat_ini_ref,to_date('01/01/1901','dd/mm/yyyy'));
          RUBRICA_ANT         := TDCN(i).cod_fcrubrica;
          COD_IDE_CLI_BEN_ANT := TDCN(i).cod_ide_cli_ben;
          V_VAL_RUBRICA       := TDCN(i).val_rubrica;
          TDCT.extend;
          j := j + 1;
          TDCT(i) := TDCN(i);
          ind := i;
        ELSE
          IF chave_ant <>
             lpad(ltrim(to_char(nvl(TDCN(i).cod_ide_rel_func, 0))), 8, 0) ||
             lpad(ltrim(to_char(nvl(TDCN(i).cod_fcrubrica, 0))), 7, 0) ||
             nvl(TDCN(i).cod_ide_cli_ben, '') or not (
             dat_ini_ref_ant=TDCN(i).dat_ini_ref and
             dat_fim_ref_ant=TDCN(i).dat_fim_ref)
              then
            dat_ini_ref_ant:=TDCN(i).dat_ini_ref;
            dat_fim_ref_ant:=TDCN(i).dat_fim_ref;
            chave_ant := lpad(ltrim(to_char(TDCN(i).cod_ide_rel_func)), 8, 0) ||
                         lpad(ltrim(to_char(TDCN(i).cod_fcrubrica)), 7, 0) ||
                         TDCN(i).cod_ide_cli_ben ;--||

            RUBRICA_ANT := TDCN(i).cod_fcrubrica;
            COD_IDE_CLI_BEN_ANT := TDCN(i).cod_ide_cli_ben;
            j := j + 1;
            TDCT(j - 1).val_rubrica := V_VAL_RUBRICA;

            V_VAL_RUBRICA := trunc(TDCN(i).val_rubrica,2);
            TDCT.extend;
            TDCT(j) := TDCN(i);
            ind := i;
          ELSE
            ---- 29=0-02-2018 IF incluido por Caroline Yumi
            IF nvl(j,0) >0 then
               V_VAL_RUBRICA := V_VAL_RUBRICA + trunc(nvl(TDCN(i).val_rubrica, 0),2);
              TDCT(j).val_rubrica := V_VAL_RUBRICA;
            END IF;
          END IF;
        END IF;
      END IF;
    END LOOP;

    conta := tdcn.count;

    TDCN.delete;
    FOR I IN 1 .. TDCT.COUNT LOOP
      TDCN.extend;
      TDCN(I) := TDCT(I);
    END LOOP;

   SP_PROCESSA_RUBRICAS_EXCL;

    -- retirar rubrica com indicador de gravacao = 'N'
    FOR i in 1 .. tdcn.count LOOP
      rdcn := tdcn(i);




      FOR j in 1 .. cod_rub.count LOOP

        IF cod_rub(j) = rdcn.cod_fcrubrica AND ind_grava_detalhe(J) = 'N' AND
           cod_entidade(j) = ANT_ENTIDADE THEN

          tdcn(i).val_rubrica := null;
          tdcn(i).cod_ins := null;

        END IF;

      END LOOP;
    END LOOP;

    conta := tdcn.count;

    FOR I IN 1 .. TDCN.COUNT LOOP
      RDCN := NULL;
      RDCN := TDCN(I);

      --   grava  tabela dos valores calculados para conferencia no retroativo
      --
      IF RDCN.COD_INS IS NOT NULL AND RDCN.COD_FCRUBRICA IS NOT NULL THEN

        SP_INCLUI_RESULTADO_CALC_RET(rdcn);

      END IF;

      FOR i2 IN 1 .. vfolha.count LOOP
        rfol := vfolha(i2);
                        EXIT
                         WHEN
                                  RFOL.COD_IDE_REL_FUNC=rdcn.COD_IDE_REL_FUNC AND
                                  RFOL.NUM_MATRICULA   =rdcn.NUM_MATRICULA    AND
                                  RFOL.COD_ENTIDADE    =rdcn.COD_ENTIDADE   ;


     END LOOP;
        ANT_ENTIDADE:=rfol.cod_entidade;
        IF RDCN.TIP_EVENTO_ESPECIAL ='P' THEN
           RDCN.DAT_INI_REF:=PAR_PER_PRO;
        END IF;

        BEGIN
          IF RDCN.cod_fcrubrica is not null then
            IF conceito_ret(TRUNC(RDCN.cod_fcrubrica / 100)) <>
               RDCN.cod_fcrubrica THEN
              SP_OBTER_DIF_RET (RDCN.num_matricula   ,
                                RDCN.cod_ide_rel_func,
                                RDCN.cod_entidade    ,
                                RDCN.cod_fcrubrica   ,
                                RDCN.val_rubrica     ,
                                RDCN.COD_IDE_CLI     ,
                                RDCN.COD_IDE_CLI_BEN ,
                                RDCN.FLG_NATUREZA    ,
                                RDCN.DAT_INI_REF     ,
                                RDCN.val_rubrica     ,
                                V_EVENTO_ESPEC);
            ELSE
              rdcn.val_rubrica := 0;
            END IF;
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            SP_OBTER_DIF_RET( RDCN.num_matricula   ,
                               RDCN.cod_ide_rel_func,
                               RDCN.cod_entidade    ,
                               RDCN.cod_fcrubrica   ,
                               RDCN.val_rubrica     ,
                               RDCN.COD_IDE_CLI     ,
                               RDCN.COD_IDE_CLI_BEN ,
                               RDCN.FLG_NATUREZA    ,
                               RDCN.DAT_INI_REF     ,
                               RDCN.val_rubrica     ,
                               V_EVENTO_ESPEC);
        END;

        vi_pagar := false; -- Rod jan10

        IF VI_PAGAR THEN



          IF RDCN.val_rubrica < 0 THEN
            RDCN.val_rubrica  := RDCN.val_rubrica * -1;
            RDCN.FLG_NATUREZA := 'D';
          ELSE
            RDCN.FLG_NATUREZA := 'C';
          END IF;

          IF RDCN.val_rubrica <> 0 THEN
               FOR i2 IN 1 .. vfolha.count LOOP
                      rfol := vfolha(i2);
                        EXIT
                         WHEN
                                  RFOL.COD_IDE_REL_FUNC=rdcn.COD_IDE_REL_FUNC AND
                                  RFOL.NUM_MATRICULA   =rdcn.NUM_MATRICULA    AND
                                  RFOL.COD_ENTIDADE    =rdcn.COD_ENTIDADE   ;
               END LOOP;
                IF rfol.cod_entidade IS NOT NULL THEN
                   ANT_ENTIDADE:=rfol.cod_entidade;
                ELSE
                   ANT_ENTIDADE:=rdcn.COD_ENTIDADE ;
                END IF;
            SP_OBTEM_RUBRICA(RDCN.COD_FCRUBRICA,
                             RDCN.FLG_NATUREZA,
                             RDCN.COD_FCRUBRICA);

          END IF;
          --
          CRET_VAL_RUBRICA   := RDCN.VAL_RUBRICA;
          CRET_FLG_NATUREZA  := RDCN.FLG_NATUREZA;
          CRET_COD_FCRUBRICA := RDCN.COD_FCRUBRICA;
          --
          --  gravar rubricas da diferenca no array do retroativo
          --
          IF RDCN.val_rubrica >= 0.01 THEN

            RDCN.des_complemento  := 'Ret.';
            ret_rdcn              := rdcn;
            ret_rdcn.per_processo := PAR_PER_REAL;
            ret_rdcn.dat_ini_ref  := PAR_PER_PRO;

            ret_tdcn.extend;

            cont_detalhe_tdcn := cont_detalhe_tdcn + 1;
            ret_tdcn(cont_detalhe_tdcn) := ret_rdcn;


          END IF;
        ELSE
          IF RDCN.val_rubrica is not null then

            --           CONT_DETALHE := CONT_DETALHE + 1;

            IF RDCN.val_rubrica < 0 THEN
              RDCN.val_rubrica  := RDCN.val_rubrica * -1;
              RDCN.FLG_NATUREZA := 'D';
            ELSE
              RDCN.FLG_NATUREZA := 'C';
            END IF;

            RDCN.des_complemento := 'Ret.';

            IF RDCN.cod_ins is not null then

              -- Fator de correcao efv
              --          RDCN.val_rubrica := round(RDCN.val_rubrica * VI_FATOR_MES, 2);

              IF RDCN.val_rubrica <> 0 THEN
                    FOR i2 IN 1 .. vfolha.count LOOP
                      rfol := vfolha(i2);
                                                 EXIT
                         WHEN
                                  RFOL.COD_IDE_REL_FUNC=rdcn.COD_IDE_REL_FUNC AND
                                  RFOL.NUM_MATRICULA   =rdcn.NUM_MATRICULA    AND
                                  RFOL.COD_ENTIDADE    =rdcn.COD_ENTIDADE   ;
                    END LOOP;
                    IF rfol.cod_entidade IS NOT NULL THEN
                       ANT_ENTIDADE:=rfol.cod_entidade;
                    ELSE
                       ANT_ENTIDADE:=rdcn.COD_ENTIDADE ;
                    END IF;
                SP_OBTEM_RUBRICA(RDCN.COD_FCRUBRICA,
                                 RDCN.FLG_NATUREZA,
                                 RDCN.COD_FCRUBRICA);
              END IF;


              RDCN.des_complemento  := 'Ret.';
              ret_rdcn.per_processo := PAR_PER_PRO;-- mODIFICADO PAR_PER_REAL 28-11-2011

              ret_vnpago_rdcn.cod_ins           := rdcn.cod_ins;
              ret_vnpago_rdcn.tip_processo      := rdcn.tip_processo;
              ret_vnpago_rdcn.per_processo      := PAR_PER_REAL;
              ret_vnpago_rdcn.cod_ide_cli       := rdcn.cod_ide_cli;
              ret_vnpago_rdcn.num_matricula     := rdcn.num_matricula;
              ret_vnpago_rdcn.cod_ide_rel_func  := rdcn.cod_ide_rel_func;
              ret_vnpago_rdcn.cod_entidade      := rdcn.cod_entidade ;


              ret_vnpago_rdcn.seq_pagamento     := rdcn.seq_pagamento;
              ret_vnpago_rdcn.cod_fcrubrica     := rdcn.cod_fcrubrica;
              ret_vnpago_rdcn.seq_vig           := rdcn.seq_vig;
              ret_vnpago_rdcn.val_rubrica       := rdcn.val_rubrica;
              ret_vnpago_rdcn.num_quota         := rdcn.num_quota;
              ret_vnpago_rdcn.flg_natureza      := rdcn.flg_natureza;
              ret_vnpago_rdcn.tot_quota         := rdcn.tot_quota;
              ret_vnpago_rdcn.dat_ini_ref       := PAR_PER_PRO;
              ret_vnpago_rdcn.dat_fim_ref       := rdcn.dat_fim_ref;
              ret_vnpago_rdcn.cod_ide_cli_ben   := rdcn.cod_ide_cli_ben;
              ret_vnpago_rdcn.num_ord_jud       := rdcn.num_ord_jud;
              ret_vnpago_rdcn.dat_ing           := rdcn.dat_ing;
              ret_vnpago_rdcn.dat_ult_atu       := rdcn.dat_ult_atu;
              ret_vnpago_rdcn.nom_usu_ult_atu   := rdcn.nom_usu_ult_atu;
              ret_vnpago_rdcn.nom_pro_ult_atu   := rdcn.nom_pro_ult_atu;
              ret_vnpago_rdcn.seq_detalhe       := rdcn.seq_detalhe * 10;
              ret_vnpago_rdcn.des_informacao    := rdcn.des_informacao;
              ret_vnpago_rdcn.des_complemento   := rdcn.des_complemento;
              ret_vnpago_rdcn.val_rubrica_cheio := rdcn.val_rubrica_cheio;
              ret_vnpago_rdcn.ind_inclui_folha  := 'N';
              ret_vnpago_rdcn.ind_processo      := 'N';

              ret_tval_npago.extend;

              cont_detalhe_tval                 := cont_detalhe_tval + 1;
              ret_tval_npago(cont_detalhe_tval) := ret_vnpago_rdcn;

            END IF;
          END IF;
        END IF;
      --END IF;
    END LOOP;

   --- Aqui devera ser Mudado para N?o aparecer muita rubrica
    FOR i2 IN 1 .. vfolha.count LOOP
           rfol := vfolha(i2);

            IF  PAR_TIP_PRO  <> 'T' THEN
                  OPEN CUR_COMPL_RET FOR
                    SELECT DC.COD_INS          ,
                           DC.COD_IDE_CLI      ,
                           DC.NUM_MATRICULA    ,
                           DC.COD_IDE_REL_FUNC ,
                           DC.COD_ENTIDADE     ,
                           DC.SEQ_PAGAMENTO,
                           DC.SEQ_VIG,
                           ' ' FLG_NATUREZA,
                           NVL(DC.COD_IDE_CLI_BEN,0) COD_IDE_CLI_BEN ,
                           NVL(DC.NUM_ORD_JUD,0),
                           DC.DAT_INI_REF,
                           sum(decode(flg_natureza,
                                      'D',
                                      DC.VAL_RUBRICA * -1,
                                      DC.VAL_RUBRICA)) val_rubrica,
                       --  dc.cod_fcrubrica
                          TO_NUMBER(TO_CHAR(TRUNC( dc.cod_fcrubrica/100)) ||'00') cod_fcrubrica
                      INTO CRET_COD_INS          ,
                           CRET_COD_IDE_CLI      ,
                           CRET_NUM_MATRICULA    ,
                           CRET_COD_IDE_REL_FUNC ,
                           CRET_COD_ENTIDADE     ,
                           CRET_SEQ_PAGAMENTO    ,
                           CRET_SEQ_VIG          ,
                           CRET_FLG_NATUREZA     ,
                           CRET_COD_IDE_CLI_BEN  ,
                           CRET_NUM_ORD_JUD      ,
                           CRET_DAT_INI_REF      ,
                           CRET_VAL_RUBRICA      ,
                           CRET_COD_FCRUBRICA
                      FROM TB_HFOLHA_PAGAMENTO_DET DC,
                           TB_RUBRICAS_PROCESSO    RP,
                           tb_formula_calculo      fc
                     WHERE DC.COD_INS = PAR_COD_INS
                        AND (DC.PER_PROCESSO = PAR_PER_PRO and
                             DC.DAT_INI_REF = PAR_PER_PRO or
                             (DC.PER_PROCESSO <> PAR_PER_REAL and
                             DC.DAT_INI_REF = PAR_PER_PRO)
                            ) -- RAO 20060411
                       AND ((RP.TIP_PROCESSO in ('N'/*, 'S'*/) and PAR_TIP_PRO = 'R') or
                           (RP.TIP_PROCESSO = 'T' and PAR_TIP_PRO = 'T'))
                       AND DC.TIP_PROCESSO = DC.TIP_PROCESSO

                       AND DC.COD_IDE_CLI      = RFOL.COD_IDE_CLI
                       AND DC.NUM_MATRICULA    = RFOL.NUM_MATRICULA
                       AND DC.COD_IDE_REL_FUNC  =RFOL.COD_IDE_REL_FUNC
                       AND DC.COD_ENTIDADE     = RFOL.COD_ENTIDADE

                       AND dc.cod_ins = rp.cod_ins
                       and rp.flg_processa = 'S'
                       and fc.cod_rubrica = rp.cod_rubrica
                       and fc.cod_fcrubrica = dc.cod_fcrubrica
                       and fc.cod_entidade = rp.cod_entidade
                       and fc.cod_entidade = ANT_ENTIDADE
                       and fc.dat_ini_vig<=PAR_PER_PRO
                       and nvl(fc.dat_fim_vig,par_per_pro) >=PAR_PER_PRO
                       and fc.cod_ins = dc.cod_ins
                       and fc.seq_vig > 0
                       and rp.cod_rubrica in
                           (select rpc.cod_rubrica
                              from tb_rubricas_processo rpc
                             where rpc.flg_processa = 'S'
                               and rpc.tip_processo in ('R','E')
                               and rpc.cod_ins = par_cod_ins
                               and rpc.cod_entidade =ANT_ENTIDADE)


                     group by DC.COD_INS           ,
                               DC.COD_IDE_CLI      ,
                               DC.NUM_MATRICULA    ,
                               DC.COD_IDE_REL_FUNC ,
                               DC.COD_ENTIDADE     ,
                               DC.SEQ_PAGAMENTO,
                               DC.SEQ_VIG,
                              ' ',
                              NVL(DC.COD_IDE_CLI_BEN,0) ,--DC.COD_IDE_CLI_BEN,
                               NVL(DC.NUM_ORD_JUD,0),--DC.NUM_ORD_JUD,
                              DC.DAT_INI_REF,
                             --dc.cod_fcrubrica
                              TRUNC( dc.cod_fcrubrica/100)
                    union all -- Obtem rubricas do lancamento manual
                     SELECT DC.COD_INS         ,
                           DC.COD_IDE_CLI      ,
                           DC.NUM_MATRICULA    ,
                           DC.COD_IDE_REL_FUNC ,
                           DC.COD_ENTIDADE     ,
                           DC.SEQ_PAGAMENTO,
                           DC.SEQ_VIG,
                           ' ' FLG_NATUREZA,
                           DC.COD_IDE_CLI_BEN,
                           DC.NUM_ORD_JUD,
                           DC.DAT_INI_REF,
                           sum(decode(flg_natureza,
                                      'D',
                                      DC.VAL_RUBRICA * -1,
                                      DC.VAL_RUBRICA)) val_rubrica,
                         dc.cod_fcrubrica
                      FROM TB_HFOLHA_PAGAMENTO_DET DC,
                           TB_RUBRICAS_PROCESSO    RP,
                           tb_formula_calculo      fc
                     WHERE DC.COD_INS = PAR_COD_INS
                       AND ( DC.PER_PROCESSO > PAR_PER_PRO and
                             DC.DAT_INI_REF = PAR_PER_PRO

                           )
                       AND ((RP.TIP_PROCESSO in ('N', 'S') and PAR_TIP_PRO = 'R') or
                           (RP.TIP_PROCESSO = 'T' and PAR_TIP_PRO = 'T'))
                       AND DC.TIP_PROCESSO = RP.TIP_PROCESSO

                       AND DC.COD_IDE_CLI      = RFOL.COD_IDE_CLI
                       AND DC.NUM_MATRICULA    = RFOL.NUM_MATRICULA
                       AND DC.COD_IDE_REL_FUNC  =RFOL.COD_IDE_REL_FUNC
                       AND DC.COD_ENTIDADE     = RFOL.COD_ENTIDADE

                       AND dc.cod_ins = rp.cod_ins
                       and rp.flg_processa = 'S'
                       and fc.cod_rubrica = rp.cod_rubrica
                       and fc.cod_fcrubrica = dc.cod_fcrubrica
                       and fc.cod_entidade = rp.cod_entidade
                       and fc.cod_entidade = ANT_ENTIDADE
                       and fc.dat_ini_vig<=PAR_PER_PRO
                       and nvl(fc.dat_fim_vig,par_per_pro) >=PAR_PER_PRO
                       and fc.cod_ins = dc.cod_ins
                       and fc.seq_vig > 0
                       ---- Condic?o Nla reativada 09-08-2013
                       AND 1=2
                       and rp.cod_rubrica in
                           (select rpc.cod_rubrica
                              from tb_rubricas_processo rpc
                             where rpc.flg_processa = 'S'
                               and rpc.tip_processo = 'R'
                               and rpc.cod_ins = par_cod_ins
                               and rpc.cod_entidade =ANT_ENTIDADE)

                     group by DC.COD_INS          ,
                              DC.COD_IDE_CLI      ,
                              DC.NUM_MATRICULA    ,
                              DC.COD_IDE_REL_FUNC ,
                              DC.COD_ENTIDADE     ,
                              DC.SEQ_PAGAMENTO    ,
                              DC.SEQ_VIG          ,
                              ' '                 ,
                              DC.COD_IDE_CLI_BEN  ,
                              DC.NUM_ORD_JUD      ,
                              DC.DAT_INI_REF,
                             dc.cod_fcrubrica     ;
             ELSE
                  OPEN CUR_COMPL_RET FOR
                    SELECT DC.COD_INS          ,
                           DC.COD_IDE_CLI      ,
                           DC.NUM_MATRICULA    ,
                           DC.COD_IDE_REL_FUNC ,
                           DC.COD_ENTIDADE     ,
                           DC.SEQ_PAGAMENTO,
                           DC.SEQ_VIG,
                           ' ' FLG_NATUREZA,
                           NVL(DC.COD_IDE_CLI_BEN,0) COD_IDE_CLI_BEN ,
                           NVL(DC.NUM_ORD_JUD,0),
                           DC.DAT_INI_REF,
                           sum(decode(flg_natureza,
                                      'D',
                                      DC.VAL_RUBRICA * -1,
                                      DC.VAL_RUBRICA)) val_rubrica,
                       --  dc.cod_fcrubrica
                          TO_NUMBER(TO_CHAR(TRUNC( dc.cod_fcrubrica/100)) ||'00') cod_fcrubrica
                      INTO CRET_COD_INS          ,
                           CRET_COD_IDE_CLI      ,
                           CRET_NUM_MATRICULA    ,
                           CRET_COD_IDE_REL_FUNC ,
                           CRET_COD_ENTIDADE     ,
                           CRET_SEQ_PAGAMENTO    ,
                           CRET_SEQ_VIG          ,
                           CRET_FLG_NATUREZA     ,
                           CRET_COD_IDE_CLI_BEN  ,
                           CRET_NUM_ORD_JUD      ,
                           CRET_DAT_INI_REF      ,
                           CRET_VAL_RUBRICA      ,
                           CRET_COD_FCRUBRICA
                      FROM TB_HFOLHA_PAGAMENTO_DET DC,
                           TB_RUBRICAS_PROCESSO    RP,
                           tb_formula_calculo      fc
                     WHERE DC.COD_INS = PAR_COD_INS
                        AND (DC.PER_PROCESSO = PAR_PER_PRO and
                             DC.DAT_INI_REF = PAR_PER_PRO or
                             (DC.PER_PROCESSO <> PAR_PER_REAL and
                             DC.DAT_INI_REF = PAR_PER_PRO)
                            ) -- RAO 20060411
                       AND ((RP.TIP_PROCESSO in ('N'/*, 'S'*/) and PAR_TIP_PRO = 'R') or
                           (RP.TIP_PROCESSO = 'T' and PAR_TIP_PRO = 'T'))
                       AND DC.TIP_PROCESSO = DC.TIP_PROCESSO

                       AND DC.COD_IDE_CLI      = RFOL.COD_IDE_CLI
                       AND DC.NUM_MATRICULA    = RFOL.NUM_MATRICULA
                       AND DC.COD_IDE_REL_FUNC  =RFOL.COD_IDE_REL_FUNC
                       AND DC.COD_ENTIDADE     = RFOL.COD_ENTIDADE

                       AND dc.cod_ins = rp.cod_ins
                       and rp.flg_processa = 'S'
                       and fc.cod_rubrica = rp.cod_rubrica
                       and fc.cod_fcrubrica = dc.cod_fcrubrica
                       and fc.cod_entidade = rp.cod_entidade
                       and fc.cod_entidade = ANT_ENTIDADE
                       and fc.dat_ini_vig<=PAR_PER_PRO
                       and nvl(fc.dat_fim_vig,par_per_pro) >=PAR_PER_PRO
                       and fc.cod_ins = dc.cod_ins
                       and fc.seq_vig > 0
                       and rp.cod_rubrica in
                           (select rpc.cod_rubrica
                              from tb_rubricas_processo rpc
                             where rpc.flg_processa = 'S'
                               and rpc.tip_processo in ('T')
                               and rpc.cod_ins = par_cod_ins
                               and rpc.cod_entidade =ANT_ENTIDADE)
                       and trunc(dc.cod_fcrubrica/100) in (37,113,580,581,582,583,656)


                     group by DC.COD_INS           ,
                               DC.COD_IDE_CLI      ,
                               DC.NUM_MATRICULA    ,
                               DC.COD_IDE_REL_FUNC ,
                               DC.COD_ENTIDADE     ,
                               DC.SEQ_PAGAMENTO,
                               DC.SEQ_VIG,
                              ' ',
                              NVL(DC.COD_IDE_CLI_BEN,0) ,--DC.COD_IDE_CLI_BEN,
                               NVL(DC.NUM_ORD_JUD,0),--DC.NUM_ORD_JUD,
                              DC.DAT_INI_REF,
                             --dc.cod_fcrubrica
                              TRUNC( dc.cod_fcrubrica/100);

             END IF;



                  FETCH CUR_COMPL_RET
                    INTO CRET_COD_INS,
                         CRET_COD_IDE_CLI      ,
                         CRET_NUM_MATRICULA    ,
                         CRET_COD_IDE_REL_FUNC ,
                         CRET_COD_ENTIDADE     ,
                         CRET_SEQ_PAGAMENTO,
                         CRET_SEQ_VIG,
                         CRET_FLG_NATUREZA,
                         CRET_COD_IDE_CLI_BEN,
                         CRET_NUM_ORD_JUD,
                         CRET_DAT_INI_REF,
                         CRET_VAL_RUBRICA,
                         CRET_COD_FCRUBRICA;

                  WHILE CUR_COMPL_RET%FOUND LOOP
                    BEGIN
                      V_EXIST := FALSE;

                      FOR I IN 1 .. TDCN.COUNT LOOP
                        RDCN := NULL;
                        RDCN := TDCN(I);

                        IF TRUNC(CRET_COD_FCRUBRICA/100) = trunc(RDCN.cod_fcrubrica / 100, 000) and
                            CRET_COD_IDE_REL_FUNC =rdcn.COD_IDE_REL_FUNC AND
                            CRET_NUM_MATRICULA   =rdcn.NUM_MATRICULA     AND
                            CRET_COD_ENTIDADE    =rdcn.COD_ENTIDADE      AND
                            CRET_DAT_INI_REF = RDCN.DAT_INI_REF THEN
                          V_EXIST := TRUE;
                          exit;
                        END IF;
                      END LOOP;

                      IF NOT V_EXIST THEN
                        --INLUIR COMO RETRATIVO CONTRARIO

                        --            cont_detalhe := cont_detalhe + 1;

                        IF CRET_VAL_RUBRICA < 0 THEN
                          CRET_VAL_RUBRICA  := CRET_VAL_RUBRICA * -1;
                          CRET_FLG_NATUREZA := 'C';
                        ELSE
                          CRET_FLG_NATUREZA := 'D';
                        END IF;
                         FOR i2 IN 1 .. vfolha.count LOOP
                             rfol := vfolha(i2);
                               EXIT
                                 WHEN
                                  RFOL.COD_IDE_REL_FUNC=rdcn.COD_IDE_REL_FUNC AND
                                  RFOL.NUM_MATRICULA   =rdcn.NUM_MATRICULA    AND
                                  RFOL.COD_ENTIDADE    =rdcn.COD_ENTIDADE   ;
                         END LOOP;
                          IF rfol.cod_entidade IS NOT NULL THEN
                             ANT_ENTIDADE:=rfol.cod_entidade;
                          ELSE
                             ANT_ENTIDADE:=rdcn.COD_ENTIDADE ;
                          END IF;

                        SP_OBTEM_RUBRICA(CRET_COD_FCRUBRICA,
                                         CRET_FLG_NATUREZA,
                                         CRET_COD_FCRUBRICA);

                        IF CRET_COD_FCRUBRICA = 320200 THEN
                          --- FFRANCO 02/2007
                          CRET_COD_FCRUBRICA := 320251;
                        END IF; --- FFRANCO 02/2007

                        ---- TEPORAL --09-11-2011
                        IF TRUNC( CRET_cod_fcrubrica/100) IN (78001) AND
                         CRET_flg_natureza='C' THEN
                         CRET_VAL_RUBRICA :=0;
                        END IF;
                        IF CRET_VAL_RUBRICA > 0 THEN

                          -- incluir no array para efetuar o calculo da correc?o

                          rdcn.cod_ins           := CRET_cod_ins;
                          rdcn.tip_processo      := par_tip_pro; -- 'R';
                          rdcn.per_processo      := PAR_PER_REAL;
                          rdcn.cod_ide_cli       := CRET_COD_IDE_CLI;

                          rdcn.num_matricula     :=CRET_num_matricula ;
                          rdcn.cod_ide_rel_func  :=CRET_cod_ide_rel_func;
                           rdcn.cod_entidade     :=CRET_cod_entidade;
                          rdcn.seq_pagamento     := CRET_seq_pagamento;
                          rdcn.cod_fcrubrica     := CRET_cod_fcrubrica;
                          rdcn.seq_vig           := CRET_seq_vig;
                          rdcn.val_rubrica       := CRET_val_rubrica;
                          rdcn.num_quota         := 1;
                          rdcn.flg_natureza      := CRET_flg_natureza;
                          rdcn.tot_quota         := 1;
                          rdcn.dat_ini_ref       := PAR_PER_PRO;
                          rdcn.dat_fim_ref       := null;
                          rdcn.cod_ide_cli_ben   := CRET_COD_IDE_CLI_BEN;
                          rdcn.num_ord_jud       := CRET_NUM_ORD_JUD;
                          rdcn.dat_ing           := sysdate;
                          rdcn.dat_ult_atu       := sysdate;
                          rdcn.nom_usu_ult_atu   := 'RET -212';
                          rdcn.nom_pro_ult_atu   := 'FOLHA RET';
                          rdcn.seq_detalhe       := cont_detalhe_tdcn;
                          rdcn.des_informacao    := null;
                          rdcn.des_complemento   := 'Ret';
                          rdcn.val_rubrica_cheio := 0;


                          ret_rdcn := rdcn;
                          ret_tdcn.extend;

                          cont_detalhe_tdcn := cont_detalhe_tdcn + 1;
                          ret_tdcn(cont_detalhe_tdcn) := ret_rdcn;

                          SP_INCLUI_RESULTADO_CALC_RET(rdcn);

                        END IF;
                      END IF;


                    FETCH CUR_COMPL_RET
                    INTO CRET_COD_INS,
                         CRET_COD_IDE_CLI      ,
                         CRET_NUM_MATRICULA    ,
                         CRET_COD_IDE_REL_FUNC ,
                         CRET_COD_ENTIDADE     ,
                         CRET_SEQ_PAGAMENTO,
                         CRET_SEQ_VIG,
                         CRET_FLG_NATUREZA,
                         CRET_COD_IDE_CLI_BEN,
                         CRET_NUM_ORD_JUD,
                         CRET_DAT_INI_REF,
                         CRET_VAL_RUBRICA,
                         CRET_COD_FCRUBRICA;

                    END;

                  END LOOP;
                  CLOSE CUR_COMPL_RET;

    END LOOP;
    --
    -- Tratamento correc?o monetaria.
    --
    --  obter as diferencas das rubricas pagas

    -- verificar se tem correc?o para o pensionista ou aposentado

     --SP_VERIFICA_CORRECAO_MONETARIA(ANT_IDE_CLI, w_calcula_correcao);
    w_calcula_correcao:=FALSE;
    IF w_calcula_correcao THEN

      val_valor_correcao := 0;

      -- Calcular Correc?o Monetaria para as Rubricas no array

      W_COD_PARAM_GERAL_CORRECAO := 'FIPE';

      w_qtd_mes_fator_correcao := (trunc((PAR_PER_REAL - PAR_PER_PRO) / 30) + 1);

      w_data_fator_correcao := par_per_pro;

      FOR i IN 1 .. ret_tdcn.count LOOP

        rdcn.cod_fcrubrica    := ret_tdcn(i).cod_fcrubrica;
        rdcn.val_rubrica      := ret_tdcn(i).val_rubrica;
        w_data_fator_correcao := par_per_pro;
        rdcn.flg_natureza     := ret_tdcn(i).flg_natureza;

        IF rdcn.flg_natureza = 'C' THEN

          FOR p IN 1 .. w_qtd_mes_fator_correcao LOOP

            SP_OBTEM_FATOR_CORRECAO('',
                                    w_data_fator_correcao,
                                    VI_FATOR_MES);

            val_valor_correcao := val_valor_correcao +
                                  ((RDCN.val_rubrica * (VI_FATOR_MES)) -
                                  RDCN.val_rubrica);

            w_data_fator_correcao := add_months(par_per_pro, p);

          END LOOP;

        END IF;

      END LOOP;

      w_data_fator_correcao := par_per_pro;

      FOR i IN 1 .. ret_tval_npago.count LOOP

        rdcn.cod_fcrubrica    := ret_tval_npago(i).cod_fcrubrica;
        rdcn.val_rubrica      := ret_tval_npago(i).val_rubrica;
        w_data_fator_correcao := par_per_pro;
        rdcn.flg_natureza     := ret_tval_npago(i).flg_natureza;

        IF rdcn.flg_natureza = 'C' THEN

          FOR p IN 1 .. w_qtd_mes_fator_correcao LOOP

            SP_OBTEM_FATOR_CORRECAO('',
                                    w_data_fator_correcao,
                                    VI_FATOR_MES);

            val_valor_correcao := val_valor_correcao +
                                  ((RDCN.val_rubrica * (VI_FATOR_MES)) -
                                  RDCN.val_rubrica);

            w_data_fator_correcao := add_months(par_per_pro, p);

          END LOOP;

        END IF;

      END LOOP;

      RDCN.des_informacao := 'Ret.Cor. ';
      RDCN.val_rubrica    := val_valor_correcao;
      RDCN.COD_INS        := PAR_COD_INS;
      RDCN.TIP_PROCESSO   := PAR_TIP_PRO;
      RDCN.PER_PROCESSO   := PAR_PER_REAL;
      RDCN.COD_IDE_CLI    := ANT_IDE_CLI;
      RDCN.FLG_NATUREZA   := 'C';
      RDCN.DAT_INI_REf    := PAR_PER_PRO;
      RDCN.Seq_Vig        := 1;

      SP_OBTEM_RUBRICA_EVENTO_ESPEC('C',
                                    ANT_ENTIDADE,
                                    '',
                                    vi_rubrica,
                                    vi_seq_vig);
      RDCN.cod_fcrubrica := vi_rubrica;

      ret_rdcn := rdcn;

      ret_tdcn.extend;

      cont_detalhe_tdcn := cont_detalhe_tdcn + 1;
      ret_tdcn(cont_detalhe_tdcn) := ret_rdcn;

    END IF;

    FOR i IN 1 .. ret_tdcn.count LOOP

      RDCN := RET_TDCN(i);

     --- SP_INCLUI_TB_DET_RET(RDCN);
        SP_INCLUI_VALOR_NPAGO_RET(RDCN);
    END LOOP;

    FOR i IN 1 .. ret_tval_npago.count LOOP
      IF ret_tval_npago(i).val_rubrica > 0 THEN
      rdcn.cod_ins           := ret_tval_npago(i).cod_ins;
      rdcn.tip_processo      := ret_tval_npago(i).tip_processo;
      rdcn.per_processo      := ret_tval_npago(i).per_processo;
      rdcn.cod_ide_cli       := ret_tval_npago(i).cod_ide_cli;
      rdcn.num_matricula     := ret_tval_npago(i).num_matricula;
      rdcn.cod_ide_rel_func  := ret_tval_npago(i).cod_ide_rel_func;
      rdcn.cod_entidade      := ret_tval_npago(i).cod_entidade ;
      rdcn.seq_pagamento     := ret_tval_npago(i).seq_pagamento;
      rdcn.cod_fcrubrica     := ret_tval_npago(i).cod_fcrubrica;
      rdcn.seq_vig           := nvl(ret_tval_npago(i).seq_vig,1);
      rdcn.val_rubrica       := ret_tval_npago(i).val_rubrica;
      rdcn.num_quota         := ret_tval_npago(i).num_quota;
      rdcn.flg_natureza      := ret_tval_npago(i).flg_natureza;
      rdcn.tot_quota         := ret_tval_npago(i).tot_quota;
      rdcn.dat_ini_ref       := ret_tval_npago(i).dat_ini_ref;
      rdcn.dat_fim_ref       := ret_tval_npago(i).dat_fim_ref;
      rdcn.cod_ide_cli_ben   := ret_tval_npago(i).cod_ide_cli_ben;
      rdcn.num_ord_jud       := ret_tval_npago(i).num_ord_jud;
      rdcn.dat_ing           := ret_tval_npago(i).dat_ing;
      rdcn.dat_ult_atu       := ret_tval_npago(i).dat_ult_atu;
      rdcn.nom_usu_ult_atu   := ret_tval_npago(i).nom_usu_ult_atu;
      rdcn.nom_pro_ult_atu   := ret_tval_npago(i).nom_pro_ult_atu;
      rdcn.seq_detalhe       := ret_tval_npago(i).seq_detalhe;
      rdcn.des_informacao    := ret_tval_npago(i).des_informacao;
      rdcn.des_complemento   := ret_tval_npago(i).des_complemento;
      rdcn.val_rubrica_cheio := ret_tval_npago(i).val_rubrica_cheio;

      SP_INCLUI_VALOR_NPAGO_RET(RDCN);
      END IF;
    END LOOP;


  END SP_GRAVA_DETALHE_RET;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------
  PROCEDURE SP_MONTAR_ARRAY_RET(P_COD_BENEFICIO IN NUMBER) IS
    --RETURN  number IS

  BEGIN

    idx_ret     := 0;
    idx_ret_ref := 0;

    FOR X in (SELECT cod_ide_cli,
                     cod_beneficio,
                     trunc(DC.COD_FCRUBRICA / 100, 000),
                     per_processo,
                     dat_ini_ref,
                     COD_IDE_CLI_BEN,
                     sum(decode(flg_natureza,
                                'C',
                                val_rubrica,
                                val_rubrica * -1))
                FROM tb_ficha_financeira_ret DC
               WHERE COD_INS = PAR_COD_INS
                 AND PER_PROCESSO =
                     to_date('01' || to_char(PAR_PER_PRO, 'MMYYYY'),
                             'DDMMYYYY') --RAO: isto deve ser revisto
                 AND TIP_PROCESSO in ('N', 'S', 'T')
                 AND COD_IDE_CLI = BEN_IDE_CLI
                 AND COD_BENEFICIO = P_COD_BENEFICIO
                 AND DC.DAT_INI_REF =
                     to_date('01' || to_char(PAR_PER_PRO, 'MMYYYY'),
                             'DDMMYYYY')
               group by cod_ide_cli,
                        cod_beneficio,
                        trunc(DC.COD_FCRUBRICA / 100, 000),
                        per_processo,
                        dat_ini_ref,
                        COD_IDE_CLI_BEN) LOOP

      null;

    END LOOP;

    FOR Z in (SELECT cod_ide_cli,
                     cod_beneficio,
                     trunc(DC.COD_FCRUBRICA / 100, 000),
                     per_processo,
                     COD_IDE_CLI_BEN,
                     nvl(sum(decode(flg_natureza,
                                    'C',
                                    val_rubrica,
                                    val_rubrica * -1)),
                         0)
                FROM tb_ficha_financeira_ret DC
               WHERE DC.COD_INS = PAR_COD_INS
                 AND (DC.DAT_INI_REF = PAR_PER_PRO)
                 AND DC.TIP_PROCESSO in ('N', 'S', 'T')
                 AND DC.COD_IDE_CLI = BEN_IDE_CLI
                 AND DC.COD_BENEFICIO = P_COD_BENEFICIO
                 AND DC.PER_PROCESSO <> PAR_PER_PRO ---RAO 20060410
                 and DC.PER_PROCESSO <> PAR_PER_REAL
               group by cod_ide_cli,
                        cod_beneficio,
                        trunc(DC.COD_FCRUBRICA / 100, 000),
                        per_processo,
                        COD_IDE_CLI_BEN) LOOP

      null;
    END LOOP;

  END SP_MONTAR_ARRAY_RET;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_VERIF_RUBRICA_NPAGA_MES_SUP AS

    RDCN                  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
    RDCD                  TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
    RUBRICA_ANT          NUMBER;
    COD_IDE_CLI_BEN_ANT  TB_DET_CALCUlADO_ESTRUC.COD_IDE_CLI_BEN%type;
    CONT_DETALHE         number := 0;
    I                    NUMBER;
    CUR_COMPL_RET        curform;
    CRET_COD_INS         NUMBER;
    CRET_TIP_PROCESSO    VARCHAR2(1);
    CRET_COD_IDE_CLI     VARCHAR2(20);
    CRET_COD_BENEFICIO   NUMBER;
    CRET_SEQ_PAGAMENTO   NUMBER;
    CRET_COD_FCRUBRICA   NUMBER;
    CRET_SEQ_VIG         NUMBER;
    CRET_VAL_RUBRICA     NUMBER;
    CRET_FLG_NATUREZA    VARCHAR2(1);
    CRET_COD_IDE_CLI_BEN VARCHAR2(20);
    CRET_NUM_ORD_JUD     NUMBER;
    CRET_DAT_INI_REF     DATE;
    V_EXIST              BOOLEAN;
    V_EVENTO_ESPEC       VARCHAR2(1);
    V_VAL_RUBRICA        NUMBER(18, 4) := 0;
    ind                  NUMBER := 0;
    j                    number := 0;
    k                    number := 0;
    chave_ant            VARCHAR2(33);
    vc_nao_parcela       varchar2(1) := 'N';
    conta                number(4) := 0;




  BEGIN

    OPEN CUR_COMPL_RET FOR
      SELECT DC.COD_INS,
             DC.TIP_PROCESSO,
             DC.COD_IDE_CLI,
             DC.COD_BENEFICIO,
             DC.SEQ_PAGAMENTO,
             DC.SEQ_VIG,
             ' ' FLG_NATUREZA,
             DC.COD_IDE_CLI_BEN,
             DC.NUM_ORD_JUD,
             DC.DAT_INI_REF,
             sum(decode(flg_natureza,
                        'D',
                        DC.VAL_RUBRICA * -1,
                        DC.VAL_RUBRICA)) val_rubrica,
             trunc(dc.cod_fcrubrica / 100, 000) cod_fcrubrica
        INTO CRET_COD_INS,
             CRET_TIP_PROCESSO,
             CRET_COD_IDE_CLI,
             CRET_COD_BENEFICIO,
             CRET_SEQ_PAGAMENTO,
             CRET_SEQ_VIG,
             CRET_FLG_NATUREZA,
             CRET_COD_IDE_CLI_BEN,
             CRET_NUM_ORD_JUD,
             CRET_DAT_INI_REF,
             CRET_VAL_RUBRICA,
             CRET_COD_FCRUBRICA
        FROM tb_ficha_financeira_ret DC, -- tabela temporaria 24/06/2008 mvl
             TB_RUBRICAS_PROCESSO    RP,
             tb_formula_calculo      fc
       WHERE DC.COD_INS = PAR_COD_INS
         AND (DC.PER_PROCESSO = PAR_PER_PRO and
             DC.DAT_INI_REF = PAR_PER_PRO)
         AND (RP.TIP_PROCESSO = 'N')
         AND DC.TIP_PROCESSO = RP.TIP_PROCESSO
         AND DC.COD_IDE_CLI = ANT_IDE_CLI
         AND dc.cod_ins = rp.cod_ins
         and rp.flg_processa = 'S'
         and fc.cod_rubrica = rp.cod_rubrica
         and fc.cod_fcrubrica = dc.cod_fcrubrica
         and trunc(fc.cod_fcrubrica / 100) <> 658
         and fc.seq_vig > 0
         and fc.cod_ins = dc.cod_ins
         and rp.cod_rubrica in
             (select rpc.cod_rubrica
                from tb_rubricas_processo rpc
               where rpc.flg_processa = 'S'
                 and rpc.tip_processo = 'S'
                 and rpc.cod_ins = PAR_COD_INS)
       group by DC.COD_INS,
                DC.TIP_PROCESSO,
                DC.COD_IDE_CLI,
                DC.COD_BENEFICIO,
                DC.SEQ_PAGAMENTO,
                DC.SEQ_VIG,
                ' ',
                DC.COD_IDE_CLI_BEN,
                DC.NUM_ORD_JUD,
                DC.DAT_INI_REF,
                trunc(dc.cod_fcrubrica / 100, 000)
      union all -- Obtem rubricas do lancamento manual
      SELECT DC.COD_INS,
             DC.TIP_PROCESSO,
             DC.COD_IDE_CLI,
             DC.COD_BENEFICIO,
             DC.SEQ_PAGAMENTO,
             DC.SEQ_VIG,
             ' ' FLG_NATUREZA,
             DC.COD_IDE_CLI_BEN,
             DC.NUM_ORD_JUD,
             DC.DAT_INI_REF,
             sum(decode(flg_natureza,
                        'D',
                        DC.VAL_RUBRICA * -1,
                        DC.VAL_RUBRICA)) val_rubrica,
             trunc(dc.cod_fcrubrica / 100, 000) cod_fcrubrica
        FROM tb_ficha_financeira_ret DC, -- tabela temporaria 24/06/2008 mvl
             TB_RUBRICAS_PROCESSO    RP,
             tb_formula_calculo      fc
       WHERE DC.COD_INS = PAR_COD_INS
         AND (DC.PER_PROCESSO = PAR_PER_PRO and
             DC.DAT_INI_REF = PAR_PER_PRO)
         AND (RP.TIP_PROCESSO = 'N')
         AND DC.TIP_PROCESSO = RP.TIP_PROCESSO
         AND DC.COD_IDE_CLI = ANT_IDE_CLI
         AND dc.cod_ins = rp.cod_ins
         and rp.flg_processa = 'S'
         and fc.cod_rubrica = rp.cod_rubrica
         and fc.cod_fcrubrica = dc.cod_fcrubrica
         and trunc(fc.cod_fcrubrica / 100) <> 658
         and fc.seq_vig > 0
         and fc.cod_ins = dc.cod_ins
         and rp.cod_rubrica in
             (select rpc.cod_rubrica
                from tb_rubricas_processo rpc
               where rpc.flg_processa = 'N'
                 and rpc.tip_processo = 'S'
                 and rpc.cod_rubrica < 30000
                 and rpc.cod_ins = PAR_COD_INS)
       group by DC.COD_INS,
                DC.TIP_PROCESSO,
                DC.COD_IDE_CLI,
                DC.COD_BENEFICIO,
                DC.SEQ_PAGAMENTO,
                DC.SEQ_VIG,
                ' ',
                DC.COD_IDE_CLI_BEN,
                DC.NUM_ORD_JUD,
                DC.DAT_INI_REF,
                trunc(dc.cod_fcrubrica / 100, 000);

    FETCH CUR_COMPL_RET
      INTO CRET_COD_INS, CRET_TIP_PROCESSO, CRET_COD_IDE_CLI, CRET_COD_BENEFICIO, CRET_SEQ_PAGAMENTO, CRET_SEQ_VIG, CRET_FLG_NATUREZA, CRET_COD_IDE_CLI_BEN, CRET_NUM_ORD_JUD, CRET_VAL_RUBRICA, CRET_COD_FCRUBRICA;

    WHILE CUR_COMPL_RET%FOUND LOOP
      BEGIN
        V_EXIST := FALSE;

        -- Para os descontos 31/05/2007

        FOR i in 1 .. tdcd.count LOOP
          rdcd := null;
          rdcd := tdcd(i);
          IF CRET_COD_FCRUBRICA = trunc(RDCD.cod_fcrubrica / 100, 000) and
             CRET_COD_BENEFICIO = RDCD.COD_IDE_REL_FUNC AND
             CRET_DAT_INI_REF = RDCN.DAT_INI_REF THEN
            V_EXIST := TRUE;
            exit; -- MVL - 31/03/2006
          END IF;
        END LOOP;

        -- Para as vantagens

        FOR I IN 1 .. TDCN.COUNT LOOP
          RDCN := NULL;
          RDCN := TDCN(I);

          IF CRET_COD_FCRUBRICA = trunc(RDCN.cod_fcrubrica / 100, 000) and
             CRET_COD_BENEFICIO = RDCN.COD_IDE_REL_FUNC AND
             CRET_DAT_INI_REF = RDCN.DAT_INI_REF         THEN
            V_EXIST := TRUE;
            exit; -- MVL - 31/03/2006
          END IF;
        END LOOP;

        IF NOT V_EXIST THEN
          --INLUIR COMO RETRATIVO CONTRARIO
          BEGIN
            cont_detalhe := cont_detalhe + 1;

            IF CRET_VAL_RUBRICA < 0 THEN
              CRET_VAL_RUBRICA  := CRET_VAL_RUBRICA * -1;
              CRET_FLG_NATUREZA := 'C';
            ELSE
              CRET_FLG_NATUREZA := 'D';
            END IF;

            begin
              SELECT COD_RUBRICA
                INTO CRET_COD_FCRUBRICA
                FROM TB_RUBRICAS
               WHERE COD_CONCEITO = CRET_COD_FCRUBRICA
                 AND FLG_NATUREZA = CRET_FLG_NATUREZA
                 AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)), 7, 0), 6, 2) <> '00';

              IF CRET_VAL_RUBRICA > 0 THEN
                --                  inserir no array

                tdcn.extend;

                idx_caln        := nvl(idx_caln, 0) + 1;
                idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;

                rdcn.cod_ins       := PAR_COD_INS;
                rdcn.tip_processo  := PAR_TIP_PRO;
                rdcn.per_processo  := PAR_PER_PRO;
                rdcn.cod_ide_cli   := CRET_COD_IDE_CLI;
--                rdcn.cod_beneficio := CRET_COD_BENEFICIO;
                rdcn.seq_pagamento := vi_seq_pagamento;
                rdcn.seq_detalhe   := idx_seq_detalhe;
                rdcn.cod_fcrubrica := CRET_COD_FCRUBRICA;
                rdcn.seq_vig       := CRET_SEQ_VIG;
                rdcn.val_rubrica   := CRET_VAL_RUBRICA;
                rdcn.num_quota     := 0;
                rdcn.flg_natureza  := CRET_FLG_NATUREZA;
                rdcn.tot_quota     := 0;
                IF PAR_TIP_PRO = 'R' THEN
                  rdcn.dat_ini_ref := CRET_DAT_INI_REF;
                ELSE
                  rdcn.dat_ini_ref := PAR_PER_PRO;
                END IF;
                rdcn.dat_fim_ref     := null;
                rdcn.num_ord_jud     := CRET_NUM_ORD_JUD;
                rdcn.dat_ing         := sysdate;
                rdcn.dat_ult_atu     := sysdate;
                rdcn.nom_usu_ult_atu := PAR_COD_USU;
                rdcn.nom_pro_ult_atu := 'FOLHA CALCULADA';
                rdcn.des_informacao  := null;

                tdcn(idx_caln) := rdcn;

              END IF;
            exception
              when no_data_found then
                p_sub_proc_erro := 'SP_VERIFICA_RUBRICA_NPAGA_MES_SUP';
                p_coderro       := SQLCODE;
                P_MSGERRO       := 'Erro ao obter a rubrica nao paga na suplementar';
                INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                      p_coderro,
                                      'Calcula Folha',
                                      sysdate,
                                      p_msgerro,
                                      p_sub_proc_erro,
                                      CRET_cod_ide_cli,
                                      CRET_COD_FCRUBRICA);
                VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            end;
          end;
        END IF;
      END;

      FETCH CUR_COMPL_RET
        INTO CRET_COD_INS, CRET_TIP_PROCESSO, CRET_COD_IDE_CLI, CRET_COD_BENEFICIO, CRET_SEQ_PAGAMENTO, CRET_SEQ_VIG, CRET_FLG_NATUREZA, CRET_COD_IDE_CLI_BEN, CRET_NUM_ORD_JUD, CRET_VAL_RUBRICA, CRET_COD_FCRUBRICA;
    END LOOP;
    CLOSE CUR_COMPL_RET;

  END SP_VERIF_RUBRICA_NPAGA_MES_SUP;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_PARVAL_FOLHA(p_per_pro in date) AS

    oval_elemento number;

    par_cod_param       varchar(10);
    par_cod_estrutura   varchar(10);
    par_cod_elemento    varchar(30);
    par_num_seq         number(8);
    par_val_elemento    number(18, 5);
    par_ini_vig         date;
    par_fim_vig         date;
    par_dat_ult_atu     date;
    par_nom_usu_ult_atu varchar(20);
    par_nom_pro_ult_atu varchar(40);
    par_num_faixa       number;


    CURSOR CUR_PARAM IS
      SELECT cod_param,
             cod_estrutura,
             cod_elemento,
             num_seq,
             val_elemento,
             ini_vig,
             fim_vig,
             dat_ult_atu,
             nom_usu_ult_atu,
             nom_pro_ult_atu,
             num_faixa
        FROM tb_det_param_estrutura
       WHERE (to_char(p_per_pro, 'YYYYMM') >= to_char(ini_vig, 'YYYYMM') AND
             (p_per_pro <=
             nvl(fim_vig, to_date('01/01/2045', 'dd/mm/yyyy'))))
       order by cod_param, cod_estrutura, cod_elemento, num_seq, num_faixa;

  BEGIN

    OPEN CUR_PARAM;
    FETCH CUR_PARAM
      INTO par_cod_param, par_cod_estrutura, par_cod_elemento, par_num_seq, par_val_elemento, par_ini_vig, par_fim_vig, par_dat_ult_atu, par_nom_usu_ult_atu, par_nom_pro_ult_atu, par_num_faixa;

    WHILE CUR_PARAM%found LOOP
      BEGIN
        vparam.extend;
        idx_param := nvl(idx_param, 0) + 1;
        rpval.cod_param := par_cod_param;
        rpval.cod_estrutura := par_cod_estrutura;
        rpval.cod_elemento := par_cod_elemento;
        rpval.num_seq := par_num_seq;
        rpval.val_elemento := par_val_elemento;
        rpval.ini_vig := par_ini_vig;
        rpval.fim_vig := par_fim_vig;
        rpval.dat_ult_atu := par_dat_ult_atu;
        rpval.nom_usu_ult_atu := par_nom_usu_ult_atu;
        rpval.nom_pro_ult_atu := par_nom_pro_ult_atu;
        rpval.num_faixa := par_num_faixa;
        vparam(idx_param) := rpval;

        FETCH CUR_PARAM
          INTO par_cod_param, par_cod_estrutura, par_cod_elemento, par_num_seq, par_val_elemento, par_ini_vig, par_fim_vig, par_dat_ult_atu, par_nom_usu_ult_atu, par_nom_pro_ult_atu, par_num_faixa;

      EXCEPTION
        WHEN OTHERS THEN
          p_sub_proc_erro := 'SP_CARREGA_PARVAL_FOLHA';
          p_coderro       := sqlcode;
          p_msgerro       := 'Erro ao carregar os parametros de folha';
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
          --       RAISE erro;
      END;
    END LOOP;
    close CUR_PARAM;
  END SP_CARREGA_PARVAL_FOLHA;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PARVAL_FOLHA2(P_COD_PARAM     in varchar,
                                   P_COD_ESTRUTURA in varchar,
                                   P_COD_ELEMENTO  in varchar,
                                   P_VADI01        out number) AS
    c     number;
    contp number;

  BEGIN
    contp := vparam.count;
    FOR c IN 1 .. contp LOOP
      rpval := vparam(c);
      IF rpval.cod_estrutura = p_cod_estrutura AND
         rpval.cod_elemento = p_cod_elemento THEN
        P_VADI01 := rpval.val_elemento;
        EXIT;
      END IF;
    END LOOP;

  END SP_OBTEM_PARVAL_FOLHA2;
  ----------------------------------------------------------------------------------
  ---> ffranco 03/2007
  PROCEDURE SP_OBTEM_PARVAL_FOLHA3(P_COD_PARAM     in varchar,
                                   P_COD_ESTRUTURA in varchar,
                                   P_COD_ELEMENTO  in varchar,
                                   P_DADI01        out date) AS
    c     number;
    contp number;

  BEGIN

    BEGIN

      select min(dpe.ini_vig)
        into P_DADI01
        from tb_det_param_estrutura dpe
       where dpe.cod_estrutura = p_cod_estrutura
         and dpe.cod_elemento = p_cod_elemento
         and dpe.cod_param = p_cod_param;
    exception
      when no_data_found then

        P_DADI01 := to_date('01/02/2004', 'dd/mm/yyyy');

    end;

    /*
      contp:=vparam.count;
      FOR c IN 1..contp LOOP
          rpval:=vparam(c);
           IF  rpval.cod_estrutura = p_cod_estrutura AND
              rpval.cod_elemento=p_cod_elemento and
              rpval.fim_vig is null THEN
              P_DADI01:=rpval.ini_vig;
              EXIT;
          END IF;
      END LOOP;
    */

  END SP_OBTEM_PARVAL_FOLHA3;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBT_FAIXA_IRRF_SALFA_TASCO(P_COD_PARAM     in varchar2,
                                          P_COD_ESTRUTURA in varchar2,
                                          P_VADI01        out number,
                                          P_VADI02        out number,
                                          P_VADI03        out number,
                                          P_VADI04        out number,
                                          P_VADI05        out number,
                                          P_VADI06        out number,
                                          P_VADI07        out number,
                                          P_VADI08        out number,
                                          P_VADI09        out number,
                                          P_MSGERRO       out varchar2) AS

  BEGIN

    IF p_cod_param = 'TRAM' THEN
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRLIM_SUP1',
                             P_VADI01);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRVAL_IMP1',
                             P_VADI02);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRVAL_AJUS1',
                             P_VADI03);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRLIM_SUP2',
                             P_VADI04);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRVAL_IMP2',
                             P_VADI05);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRVAL_AJUS2',
                             P_VADI06);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRLIM_SUP3',
                             P_VADI07);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRVAL_IMP3',
                             P_VADI08);
      SP_OBTEM_PARVAL_FOLHA2('TRAM',
                             P_COD_ESTRUTURA,
                             'IRVAL_AJUS3',
                             P_VADI09);
    END IF;

    IF p_cod_param = 'SALFA' THEN
      SP_OBTEM_PARVAL_FOLHA2('SALFA',
                             P_COD_ESTRUTURA,
                             'FAIXA1_SF',
                             P_VADI01);
      SP_OBTEM_PARVAL_FOLHA2('SALFA', P_COD_ESTRUTURA, 'VAL1SF', P_VADI02);
      SP_OBTEM_PARVAL_FOLHA2('SALFA',
                             P_COD_ESTRUTURA,
                             'FAIXA2_SF',
                             P_VADI03);
      SP_OBTEM_PARVAL_FOLHA2('SALFA', P_COD_ESTRUTURA, 'VAL2SF', P_VADI04);
      SP_OBTEM_PARVAL_FOLHA2('SALFA',
                             P_COD_ESTRUTURA,
                             'FAIXA3_SF',
                             P_VADI05);
      SP_OBTEM_PARVAL_FOLHA2('SALFA', P_COD_ESTRUTURA, 'VAL3SF', P_VADI06);
      P_VADI07 := 0;
      P_VADI08 := 0;
      P_VADI09 := 0;
    END IF;

    IF p_cod_param = 'TASCO' THEN
      SP_OBTEM_PARVAL_FOLHA2('TASCO',
                             P_COD_ESTRUTURA,
                             'BASE_PREV',
                             P_VADI01);
      SP_OBTEM_PARVAL_FOLHA2('TASCO',
                             P_COD_ESTRUTURA,
                             'DED_PREV',
                             P_VADI02);
      P_VADI03 := 0;
      P_VADI04 := 0;
      P_VADI05 := 0;
      P_VADI06 := 0;
      P_VADI07 := 0;
      P_VADI08 := 0;
      P_VADI09 := 0;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      P_MSGERRO := sqlcode || sqlerrm;

  END SP_OBT_FAIXA_IRRF_SALFA_TASCO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CARREGA_VAR_TOTAIS_FOLHA AS

    CURSOR CUR_VAR IS
      SELECT COD_VARIAVEL, DES_VARIAVEL
        FROM TB_VARIAVEIS
       WHERE FLG_GRAVA_TOTAIS = 'S';

    VCOD_VARIAVEL VARCHAR2(30);
    VDES_VARIAVEL VARCHAR2(100);
    J             number := 0;

  BEGIN

    OPEN CUR_VAR;

    FETCH CUR_VAR
      INTO VCOD_VARIAVEL, VDES_VARIAVEL;
    WHILE CUR_VAR%FOUND LOOP
      vtotvar.extend;
      idx_totvar := nvl(idx_totvar, 0) + 1;
      rvar.COD_VARIAVEL := VCOD_VARIAVEL;
      rvar.DES_VARIAVEL := VDES_VARIAVEL;
      vtotvar(idx_totvar) := rvar;
      FETCH CUR_VAR
        INTO VCOD_VARIAVEL, VDES_VARIAVEL;
    END LOOP;

    for j in 1 .. 4 loop
      vtotvar.extend;
      idx_totvar := nvl(idx_totvar, 0) + 1;
      IF J = 1 THEN
        VCOD_VARIAVEL := 'TOT_ISENCAO_IR';
        VDES_VARIAVEL := 'TOTAIS DE ISENCAO IR';
        --                valor := rfol.val_base_isencao;
      ELSIF J = 2 THEN
        VCOD_VARIAVEL := 'TOT_DED_IR';
        VDES_VARIAVEL := 'TOTAIS DE DEDUCOES IR';
        --                valor := rfol.ded_base_ir+rfol.ded_ir_oj + rfol.ded_ir_pa+rfol.ded_ir_doenca;
      ELSIF J = 3 THEN
        VCOD_VARIAVEL := 'TOT_BASE_BRUTA_IR';
        VDES_VARIAVEL := 'TOTAIS DA BASE BRUTA IR';
        --                valor := rfol.val_base_ir;
      ELSIF J = 4 THEN
        VCOD_VARIAVEL := 'TOT_BASE_LIQ_IR';
        VDES_VARIAVEL := 'TOTAIS DA BASE LIQUIDA IR';
        --                valor := rfol.val_ir_ret_pag;
      END IF;

      rvar.COD_VARIAVEL := VCOD_VARIAVEL;
      rvar.DES_VARIAVEL := VDES_VARIAVEL;
      vtotvar(idx_totvar) := rvar;
    end loop;
    close CUR_VAR;

  END SP_CARREGA_VAR_TOTAIS_FOLHA;
  ----------------------------------------------------------------------------------

  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PERCEN_CALC_IR(ide_cli  in varchar2,
                                    TotBru   in number,
                                    PERC_IR  out number,
                                    REDUT_IR out number) AS

    idx_ir number;
    contir number;

    LIM_SUP1 number;
    VAL_IMP1 number;
    AJUS1    number;
    LIM_SUP2 number;
    VAL_IMP2 number;
    AJUS2    number;
    LIM_SUP3 number;
    VAL_IMP3 number;
    AJUS3    number;
    MonImp   number;

    PorImp  number;
    Redutor number;

    var1 number := 1;
    var2 number := 2;
    var3 number := 3;
    -- JTS 07-22-2010
    VI_ISENTO2 boolean := TRUE;
  BEGIN
    PorImp  := 0;
    Redutor := 0;
    MonImp  := 0;
  IF sp_isenta_irrf(ide_cli) <> VI_ISENTO2 THEN
    BEGIN
      BEGIN
        IF reg_ttypir(1) (1).val_elemento <= 0 THEN
          NULL;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN

          reg_ttypir.delete;
          contir := vparam.count;
          FOR c IN 1 .. contir LOOP
            rpval := vparam(c);
            IF rpval.cod_param = 'TRAM' AND rpval.cod_estrutura = 2000 THEN
              IF rpval.cod_elemento = 'IRLIM_SUP' THEN
                reg_ttypir(var1)(rpval.num_faixa) := rpval;
              ELSIF rpval.cod_elemento = 'IRVAL_AJUS' THEN
                reg_ttypir(var2)(rpval.num_faixa) := rpval;
              ELSIF rpval.cod_elemento = 'IRVAL_IMP' THEN
                reg_ttypir(var3)(rpval.num_faixa) := rpval;
              END IF;
              --              reg_ttypir.extend;
              --              idx_ir:= nvl(idx_ir,0) + 1;
              --              typir(idx_ir) := rpval;
            END IF;
          END LOOP;

      END;

      FOR c IN 1 .. 5 loop
        --reg_ttypir.count LOOP

        IF TotBru <= reg_ttypir(var1) (c).val_elemento THEN
          --LIM_SUP1 THEN
          Redutor := reg_ttypir(var2) (c).val_elemento; --AJUS1;
          PorImp  := reg_ttypir(var3) (c).val_elemento; --VAL_IMP1;
          EXIT;
        END IF;

      END LOOP;

      MonImp := (TotBru * PorImp / 100);
      MonImp := MonImp - Redutor;

      PERC_IR  := PorImp;
      REDUT_IR := Redutor;

    END;
   ELSE
      PERC_IR  := 0;
      REDUT_IR := 0;
   END IF;

  END SP_OBTEM_PERCEN_CALC_IR;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DEDUCOES(ide_cli in varchar2, deducao_ir out number) AS
    VI_VAL_PAGOS   NUMBER(18, 4) := 0;
    VI_ISENTO      boolean := TRUE;
    nEdad          number;
    nIni           number;
    nFin           number;
    vi_rubrica     number := 0;
    vi_val_rubrica number := 0;
    vi_seq_vig     number := 0;

  BEGIN

    --- Obtem valores deduc?es
    -- Enfermidade grave
    -- judicial (isenc?o)
    IF sp_isenta_irrf(ide_cli) <> VI_ISENTO THEN
      -- Maior 65
      deducao_ir := 0;
      nFin       := to_char(ANT_DTA_NASC, 'yyyymmdd');
      nIni       := to_char(PAR_PER_PRO, 'yyyymmdd');
      nEdad      := (nIni - nFin) / 10000;
      IF nEdad >= 65 THEN
        deducao_ir := V_DED_IR_65;
      END IF;

      -- Dependentes
      VI_NUM_DEP_ECO := 0;
      IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
        VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(ide_cli, 'A');
      ELSE
        VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(ide_cli, 'P');
      END IF;

      IF VI_NUM_DEP_ECO > 0 THEN
        deducao_ir := nvl(deducao_ir, 0) + (V_DED_IR_DEP * VI_NUM_DEP_ECO);
      END IF;

      -- Rubricas que deduzem no IR

      vi_val_pagos := SP_OBTEM_DED_PAGOS_SEMPA;

      IF vi_val_pagos > 0 THEN
        deducao_ir := deducao_ir + vi_val_pagos;
      END IF;
    else
      deducao_ir := 0;
    end if;

    select nvl(deducao_ir, 0) into deducao_ir from dual;

  END SP_OBTEM_DEDUCOES;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_CALCULA_IMPOSTO2(TotBru in number, MonImp out number) AS

    idx_ir number;
    contir number;
    valor_proc_especial number(18,4) :=0;
    LIM_SUP1 number;
    VAL_IMP1 number;
    AJUS1    number;
    LIM_SUP2 number;
    VAL_IMP2 number;
    AJUS2    number;
    LIM_SUP3 number;
    VAL_IMP3 number;
    AJUS3    number;

    PorImp  number;
    Redutor number;

    var1 number := 1;
    var2 number := 2;
    var3 number := 3;

    VALD  number(10,2) :=0;
  BEGIN
    PorImp  := 0;
    Redutor := 0;
    MonImp  := 0;

    BEGIN
      BEGIN
        IF reg_ttypir(1) (1).val_elemento <= 0 THEN
          NULL;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN

          reg_ttypir.delete;
          contir := vparam.count;

          IF  NOT VI_IR_EXTERIOR  THEN
                  FOR c IN 1 .. contir LOOP
                    rpval := vparam(c);
                    IF rpval.cod_param = 'TRAM' AND rpval.cod_estrutura = 2000 THEN
                      IF rpval.cod_elemento = 'IRLIM_SUP' THEN
                        reg_ttypir(var1)(rpval.num_faixa) := rpval;
                      ELSIF rpval.cod_elemento = 'IRVAL_AJUS' THEN
                        reg_ttypir(var2)(rpval.num_faixa) := rpval;
                      ELSIF rpval.cod_elemento = 'IRVAL_IMP' THEN
                        reg_ttypir(var3)(rpval.num_faixa) := rpval;
                      END IF;
                      --              reg_ttypir.extend;
                      --              idx_ir:= nvl(idx_ir,0) + 1;
                      --              typir(idx_ir) := rpval;
                    END IF;
                  END LOOP;
          ELSE
                  FOR c IN 1 .. contir LOOP
                    rpval := vparam(c);
                    IF rpval.cod_param = 'IREXT' AND rpval.cod_estrutura = 2000 THEN
                      IF rpval.cod_elemento = 'IRLIM_SUP' THEN
                        reg_ttypir(var1)(rpval.num_faixa) := rpval;
                      ELSIF rpval.cod_elemento = 'IRVAL_AJUS' THEN
                        reg_ttypir(var2)(rpval.num_faixa) := rpval;
                      ELSIF rpval.cod_elemento = 'IRVAL_IMP' THEN
                        reg_ttypir(var3)(rpval.num_faixa) := rpval;
                      END IF;
                      --              reg_ttypir.extend;
                      --              idx_ir:= nvl(idx_ir,0) + 1;
                      --              typir(idx_ir) := rpval;
                    END IF;
                  END LOOP;
          END IF;
      END;

      FOR c IN 1 .. 5 loop
        --reg_ttypir.count LOOP
           VALD := reg_ttypir(var1) (c).val_elemento;
        IF TotBru <= reg_ttypir(var1) (c).val_elemento THEN

          --LIM_SUP1 THEN
          Redutor := reg_ttypir(var2) (c).val_elemento; --AJUS1;
          PorImp  := reg_ttypir(var3) (c).val_elemento; --VAL_IMP1;
          EXIT;
        END IF;

      END LOOP;

      MonImp := (TotBru * PorImp / 100);
      MonImp := MonImp - Redutor;
    END;

    --Verifica se possui Processamento Especial ocorrido neste mes se sim deduz o IR processado
    valor_proc_especial :=0;

    IF valor_proc_especial >0 AND valor_proc_especial IS NOT NULL THEN
       MonImp := MonImp - valor_proc_especial;
    END IF;
  END SP_CALCULA_IMPOSTO2;

  ---------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RUBRICA(i_cod_fcrubrica in number,
                             i_flg_natureza  in varchar2,
                             o_cod_rubrica   out number) as

  begin

    SELECT COD_RUBRICA
      INTO o_cod_rubrica
      FROM TB_RUBRICAS
     WHERE COD_CONCEITO = trunc(i_cod_fcrubrica / 100, 000)
       AND FLG_NATUREZA = i_flg_natureza
       AND COD_ENTIDADE = ANT_ENTIDADE
       AND SUBSTR(lpad(ltrim(to_char(COD_RUBRICA)), 7, 0), 6, 2) IN
           ('50', '51'); -- alt ffranco 03/2007
  exception
    when no_data_found then
      p_sub_proc_erro := 'SP_GRAVA_DETALHE_RET A1';
      p_coderro       := SQLCODE;
      P_MSGERRO       := 'Erro ao obter o codigo da rubrica';
      INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                            p_coderro,
                            'Calcula Folha',
                            sysdate,
                            p_msgerro,
                            p_sub_proc_erro,
                            rdcn.cod_ide_cli,
                            i_COD_FCRUBRICA);
      VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    when others then
      p_sub_proc_erro := 'SP_GRAVA_DETALHE_RET A1';
      p_coderro       := SQLCODE;
      P_MSGERRO       := SQLERRM;
      INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                            p_coderro,
                            'Calcula Folha',
                            sysdate,
                            p_msgerro,
                            p_sub_proc_erro,
                            rdcn.cod_ide_cli,
                            i_COD_FCRUBRICA);
      VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    --   end;

  END SP_OBTEM_RUBRICA;
  -------------------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_CORRECAO_MONETARIA(I_COD_IDE_CLI  IN VARCHAR2,
                                           O_ANO_INICIO   OUT NUMBER ,
                                           O_FLG_CORRECAO OUT BOOLEAN) AS

    O_FLG_TEM_CORRECAO CHAR(1);

  BEGIN
       O_FLG_CORRECAO := TRUE;
    Begin
      SELECT RET.FATOR_CORRECAO,
             TO_NUMBER(TO_CHAR(RET.DAT_PERIODO_PROC,'YYYY'))
        INTO O_FLG_TEM_CORRECAO,
             O_ANO_INICIO
        FROM TB_CASOS_RET_FOLHA RET
       where RET.COD_INS          = PAR_COD_INS
         and RET.COD_IDE_CLI      = I_COD_IDE_CLI
         and RET.DAT_PERIODO_COMP = PAR_PER_REAL;

       IF O_FLG_TEM_CORRECAO ='N' THEN
           O_FLG_CORRECAO := FALSE;
       END IF;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_FLG_TEM_CORRECAO := 'N';
        O_FLG_CORRECAO     := FALSE;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_FATOR_CORRECAO1';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o fator de correcao';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              0,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    end;

  END SP_VERIFICA_CORRECAO_MONETARIA;
  -------------------------------------------------------------------------------------
  -- SP_OBTEM_FATOR_CORRECAO: Obtem fator de correc?o nos casos de retroativo
  --efv
  PROCEDURE SP_OBTEM_FATOR_CORRECAO(I_COD_IDE_CLI    IN VARCHAR2,
                                    i_data_param     in date,
                                    O_FATOR_CORRECAO OUT NUMBER) AS
    O_FATOR_MES NUMBER(18, 4);

  BEGIN
    O_FATOR_MES := 1;

    begin
      /*
      SELECT cod.cod_porcen
      INTO O_FATOR_MES
      FROM PARCOD COD
      WHERE COD.COD_CODNUM = 2355
      AND   COD.COD_CUEN01 = (SELECT MAX(COD2.COD_CUEN01)
                              FROM  PARCOD COD2
                              WHERE COD2.COD_CODNUM = 2355
                              AND   COD2.COD_CUEN01 <= to_char(PAR_PER_REAL, 'MMYYYY'))
      AND   TO_DATE(TO_CHAR(COD.COD_NUME01, '00')||COD.COD_NUME02,'MMYYYY') = PAR_PER_PRO;
      */

      SELECT dpe.val_elemento
         INTO O_FATOR_MES
        FROM tb_det_param_estrutura dpe
       WHERE dpe.cod_param = W_COD_PARAM_GERAL_CORRECAO
         and dpe.cod_estrutura = 1000
         AND to_char(dpe.ini_vig, 'YYYYMM') >=
             to_char(i_data_param, 'YYYYMM')
         and to_char(dpe.fim_vig, 'YYYYMM') <=
             to_char(i_data_param, 'YYYYMM');

      O_FATOR_CORRECAO := O_FATOR_MES;
      /*
      SELECT cod.cod_porcen
      INTO O_FATOR_MES
      FROM PARCOD COD
      WHERE COD.COD_CODNUM = 2355
      AND   to_date(COD.COD_CUEN01, 'MMYYYY') =
                             (SELECT max(to_date(COD2.COD_CUEN01, 'MMYYYY'))
                              FROM  PARCOD COD2
                              WHERE COD2.COD_CODNUM = 2355
                              AND   to_date(COD2.COD_CUEN01, 'MMYYYY') <= PAR_PER_REAL)
      AND   TO_DATE(TO_CHAR(COD.COD_NUME01, '00')||COD.COD_NUME02,'MMYYYY') = PAR_PER_PRO; */
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_FATOR_MES      := 1;  -- Era 1 passei para zero em.10.11.09
        O_FATOR_CORRECAO := 1;  -- Era 1 passei para zero em.10.11.09
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_FATOR_CORRECAO2';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o fator de correcao mes';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              0,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    end;

    RETURN;

  END SP_OBTEM_FATOR_CORRECAO;
  -------------------------------------------------------------------------------------
  -- SP_OBTEM_ADIANTAMENTO_13: Obtem o valor total de adiantamentos de 13 no ano
  -- efv
  FUNCTION SP_OBTEM_ADIANTAMENTO_13 RETURN NUMBER AS
    O_VAL_ADIANTA      NUMBER(18, 4);
    O_VAL_ADIANTA_13   NUMBER(18, 4);
    O_QTD_AVOS_INST    number(18, 4);
    O_NUM_MESES_INST   number(18, 4);
    O_QTD_AVOS_BENEF   number(18, 4);
    vcod_fcrubrica_ant tb_det_calculado_ESTRUC.cod_fcrubrica%type;
    vCOM_NAT_RUB       varchar2(2) := '';
  BEGIN
    O_VAL_ADIANTA := 0;

    IF PAR_TIP_PRO = 'T' THEN
      IF HOUVE_RATEIO = FALSE THEN
        Begin
          SELECT NVL(SUM(CAL.VAL_RUBRICA), 0) -->  ffranco 07/12/2006
            INTO O_VAL_ADIANTA
            FROM TB_DET_CALCULADO CAL
           WHERE CAL.COD_INS = PAR_COD_INS
             AND CAL.TIP_PROCESSO IN
                 (SELECT PRO.TIP_PROCESSO FROM TB_TIPO_PROCESSO PRO)
             AND TRUNC(CAL.DAT_INI_REF, 'YEAR') =
                 TRUNC(to_date(PAR_PER_PRO), 'YEAR')
             AND CAL.COD_BENEFICIO = COM_COD_BENEFICIO
             AND CAL.COD_IDE_CLI = BEN_IDE_CLI ---> ffranco 07/12/2006
             AND CAL.COD_FCRUBRICA in (14900, 14901, 14951, 14902);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            O_VAL_ADIANTA := 0;
          WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_OBTEM_ADIANTAMENTO_13';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao obter o adiantamento do 13?';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  BEN_IDE_CLI,
                                  0);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        end;

        IF O_VAL_ADIANTA > 0 THEN
          -- armazena em array
          vcod_fcrubrica_ant := com_cod_fcrubrica;
          vCOM_NAT_RUB       := COM_NAT_RUB;
          com_cod_fcrubrica  := 14950;
          COM_NAT_RUB        := 'D';
          SP_INS_DETCALCULADO(O_VAL_ADIANTA);
          COM_NAT_RUB       := vCOM_NAT_RUB;
          com_cod_fcrubrica := vcod_fcrubrica_ant;
          O_VAL_ADIANTA     := 0;
        END IF;
      END IF;
      IF HOUVE_RATEIO = FALSE THEN
        Begin
          SELECT NVL(SUM(CAL.VAL_RUBRICA), 0) -->  ffranco 07/12/2006
            INTO O_VAL_ADIANTA_13
            FROM TB_DET_CALCULADO CAL
           WHERE CAL.COD_INS = PAR_COD_INS
             AND CAL.TIP_PROCESSO IN
                 (SELECT PRO.TIP_PROCESSO FROM TB_TIPO_PROCESSO PRO)
             AND TRUNC(CAL.DAT_INI_REF, 'YEAR') =
                 TRUNC(to_date(PAR_PER_PRO), 'YEAR')
             AND CAL.COD_BENEFICIO = COM_COD_BENEFICIO
             AND CAL.COD_IDE_CLI <> BEN_IDE_CLI ---> ffranco 02/2007
             AND CAL.COD_FCRUBRICA = 15000;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            O_VAL_ADIANTA := 0;
          WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_OBTEM_ADIANTAMENTO_13';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao obter o adiantamento do 13?';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  BEN_IDE_CLI,
                                  0);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        end;

        IF O_VAL_ADIANTA_13 > 0 THEN
          -- armazena em array
          vcod_fcrubrica_ant := com_cod_fcrubrica;
          vCOM_NAT_RUB       := COM_NAT_RUB;
          com_cod_fcrubrica  := 15050;
          COM_NAT_RUB        := 'D';
          o_val_adianta_13   := o_val_adianta_13 * (VI_PERCENTUAL_RATEIO);
          SP_INS_DETCALCULADO(O_VAL_ADIANTA_13);
          COM_NAT_RUB       := vCOM_NAT_RUB;
          com_cod_fcrubrica := vcod_fcrubrica_ant;
          O_VAL_ADIANTA     := 0;
        END IF;
      END IF;

    ELSE

      --------  por ffranco em 02/2007 --- adiantamento 13 salario de aposentado em pensionista
      IF (PAR_TIP_PRO = 'T' and COM_TIP_BENEFICIO = 'PENSIONISTA') OR
         (VI_TEM_SAIDA and COM_TIP_BENEFICIO = 'PENSIONISTA') THEN

        Begin
          SELECT NVL(SUM(CAL.VAL_RUBRICA), 0) -->  ffranco 07/12/2006
            INTO O_VAL_ADIANTA
            FROM TB_DET_CALCULADO CAL
           WHERE CAL.COD_INS = PAR_COD_INS
             AND CAL.TIP_PROCESSO IN
                 (SELECT PRO.TIP_PROCESSO FROM TB_TIPO_PROCESSO PRO)
             AND TRUNC(CAL.DAT_INI_REF, 'YEAR') =
                 TRUNC(to_date(PAR_PER_PRO), 'YEAR')
                --   AND   CAL.COD_BENEFICIO = ant_COD_BENEFICIO
             AND CAL.COD_IDE_CLI = DECODE(PAR_TIP_PRO,
                                          'T',
                                          COM_IDE_CLI_INSTITUIDOR,
                                          BEN_IDE_CLI) ---> ffranco 02/2007
             AND CAL.COD_FCRUBRICA in (14900, 14901, 14951, 14902);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            O_VAL_ADIANTA := 0;
          WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_OBTEM_ADIANTAMENTO_13';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao obter o valor do adiantamento do 13?';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  BEN_IDE_CLI,
                                  0);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        end;
        ---> levanta a data de falecimento do instituidor
        ---> e compara com quantidade de avos de 13 sal adiantado que ele recebeu
        /*   begin
          select cindiv.val_unidade
           into O_QTD_AVOS_INST
          from tb_composicao_indiv cindiv
          where cindiv.cod_ins = PAR_COD_INS
            and cindiv.cod_ide_cli = COM_IDE_CLI_INSTITUIDOR
            and TRUNC(Cindiv.Dat_Ini_VIG, 'YEAR') = TRUNC(to_date(PAR_PER_PRO), 'YEAR')
            and cindiv.cod_fcrubrica in  (14900,14901,14951);
        EXCEPTION WHEN NO_DATA_FOUND THEN
        O_QTD_AVOS_INST := 0;
        WHEN OTHERS THEN
           p_sub_proc_erro:= 'SP_OBTEM_ADIANTAMENTO_13';
           p_coderro := SQLCODE;
           P_MSGERRO := SQLERRM;
                INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                               p_coderro,
                                'Calcula Folha',
                                sysdate,
                               p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                0);
        END; */
        Begin
          SELECT TO_NUMBER(TO_CHAR(BEN.DAT_FIM_BEN, 'MM'))
            INTO O_NUM_MESES_INST
            FROM TB_BENEFICIARIO BEN
           WHERE BEN.COD_INS = PAR_COD_INS
             AND BEN.COD_IDE_CLI_BEN = BEN_IDE_CLI; --COM_IDE_CLI_INSTITUIDOR;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            O_NUM_MESES_INST := 0;
          WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_OBTEM_ADIANTAMENTO_13';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao obter o numero de meses do final do beneficio';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  BEN_IDE_CLI,
                                  0);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        end;
        /*
        IF O_NUM_MESES_INST > 0 and O_QTD_AVOS_INST > 0 THEN
           O_VAL_ADIANTA := O_VAL_ADIANTA / O_QTD_AVOS_INST * 12;
           O_VAL_ADIANTA := O_VAL_ADIANTA / 12 * (O_QTD_AVOS_INST - O_NUM_MESES_INST) * VI_PERCENTUAL_RATEIO;
           V_NUM_AVOS_13_ADI := O_QTD_AVOS_INST - O_NUM_MESES_INST;
        END IF; */

        IF O_VAL_ADIANTA > 0 AND COM_DAT_FIM_VIG IS NULL THEN
          -- armazena em array
          vcod_fcrubrica_ant := com_cod_fcrubrica;
          vCOM_NAT_RUB       := COM_NAT_RUB;
          com_cod_fcrubrica  := 14952;
          COM_NAT_RUB        := 'D';
          SP_INS_DETCALCULADO(O_VAL_ADIANTA);
          COM_NAT_RUB       := vCOM_NAT_RUB;
          com_cod_fcrubrica := vcod_fcrubrica_ant;
          O_VAL_ADIANTA     := 0;
        END IF;
      end if;
    END IF;
    -----------
    IF PAR_TIP_PRO = 'T' AND COM_TIP_BENEFICIO = 'PENSIONISTA' AND
       O_VAL_ADIANTA_13 > 0 THEN
      O_VAL_ADIANTA := O_VAL_ADIANTA_13;
    ELSE
      O_VAL_ADIANTA := 0;
    END IF;

    RETURN(O_VAL_ADIANTA);

  END SP_OBTEM_ADIANTAMENTO_13;
  -------------------------------------------------------------------------------------
  -- SP_OBTEM_TETO_PENSAO: Obtem o valor total de adiantamentos de 13 no ano
  -- efv
  FUNCTION SP_OBTEM_TETO_PENSAO RETURN NUMBER AS
    o_val_teto_pensao NUMBER(18, 4);
  BEGIN
    o_val_teto_pensao := 0;
    Begin
      SELECT cod.cod_valo01 --, cod.cod_porcen
        into o_val_teto_pensao --, v_porc_teto_pensao
        FROM PARCOD cod
       WHERE COD_CODNUM = 2304
         and cod.cod_codsou = 'TETOPM'
         and cod.cod_fech01 <= PAR_PER_PRO
         and (cod.cod_fech02 is null or cod.cod_fech02 >= PAR_PER_PRO);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        o_val_teto_pensao := 1000000;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_TETO_PENSAO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o teto de pensao';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              null,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    end;

    RETURN(o_val_teto_pensao);

  END SP_OBTEM_TETO_PENSAO;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DESC_NIVEL RETURN VARCHAR2 IS

    v_des_nivel tb_valores_fatores.des_val_fat%type;

  BEGIN

    v_des_nivel := ' ';

    BEGIN
      select vf.des_val_fat --, mf.des_sigla
        into v_des_nivel
        from tb_valores_fatores    vf,
             tb_valores_referencia vr,
             tb_mestre_fatores     mf
       where vf.cod_ins = PAR_COD_INS
         and vf.cod_ins = vr.cod_ins
         and vf.cod_entidade = vr.cod_entidade
         and vf.cod_pccs = vr.cod_pccs
         and vf.cod_mes_fat = vr.cod_mes_fat
         and vf.cod_val_fat = vr.cod_val_fat
         and vr.cod_referencia = BEN_COD_REFERENCIA
         and vr.cod_quadro = COM_QUADRO
         and vr.cod_pccs = COM_PCCS
         and vr.cod_entidade = COM_ENTIDADE
         and mf.cod_ins = vf.cod_ins
         and mf.cod_entidade = vr.cod_entidade
         and mf.cod_pccs = vf.cod_pccs
         and mf.cod_mes_fat = vr.cod_mes_fat
         and mf.cod_mes_fat = 3;

    exception
      when others then
        v_des_nivel := ' ';
    end;

    return v_des_nivel;

  END SP_OBTEM_DESC_NIVEL;
  ----------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DESC_PISO RETURN VARCHAR2 IS

    v_des_nivel tb_valores_fatores.des_val_fat%type;

  BEGIN

    v_des_nivel := ' ';

    BEGIN
      select vf.des_val_fat --, mf.des_sigla
        into v_des_nivel
        from tb_valores_fatores    vf,
             tb_valores_referencia vr,
             tb_mestre_fatores     mf
       where vf.cod_ins = PAR_COD_INS
         and vf.cod_ins = vr.cod_ins
         and vf.cod_entidade = vr.cod_entidade
         and vf.cod_pccs = vr.cod_pccs
         and vf.cod_mes_fat = vr.cod_mes_fat
         and vf.cod_val_fat = vr.cod_val_fat
         and vr.cod_referencia = BEN_COD_REFERENCIA
         and vr.cod_quadro = COM_QUADRO
         and vr.cod_pccs = COM_PCCS
         and vr.cod_entidade = COM_ENTIDADE
         and mf.cod_ins = vf.cod_ins
         and mf.cod_entidade = vr.cod_entidade
         and mf.cod_pccs = vf.cod_pccs
         and mf.cod_mes_fat = vr.cod_mes_fat
         and mf.cod_mes_fat = 4;

    exception
      when others then
        v_des_nivel := ' ';
    end;

    return v_des_nivel;

  END SP_OBTEM_DESC_PISO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_VAL_JORN_PISO(o_valor out number) AS

  BEGIN
    BEGIN
      select jor.val_valor_percentual
        into o_valor
        from tb_valores_fatores    vf,
             tb_valores_referencia vr,
             tb_mestre_fatores     mf,
             tb_jornada            jor
       where vf.cod_ins = PAR_COD_INS
         and vf.cod_ins = vr.cod_ins
         and vf.cod_entidade = vr.cod_entidade
         and vf.cod_pccs = vr.cod_pccs
         and vf.cod_mes_fat = vr.cod_mes_fat
         and vf.cod_val_fat = vr.cod_val_fat
         and vr.cod_referencia = BEN_COD_REFERENCIA
         and vr.cod_quadro = COM_QUADRO
         and vr.cod_pccs = COM_PCCS
         and vr.cod_entidade = COM_ENTIDADE
         and mf.cod_ins = vf.cod_ins
         and mf.cod_entidade = vr.cod_entidade
         and mf.cod_pccs = vf.cod_pccs
         and mf.cod_mes_fat = vr.cod_mes_fat
         and mf.cod_mes_fat = 4
         and vf.cod_ins = jor.cod_ins
         and vf.des_val_fat = jor.des_jornada;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_VAL_JORN_PISO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o valor do percentual do piso minimo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    END;

  END;
  ----------------------------------------------------------------------------------

  -- Agrega rubrica en array que sera inserido na tabela de detalhe calculado
  --
  ----------------------------------------------------------------------------------
  PROCEDURE SP_INS_DETCAL_PA(ide_cli in varchar2, i_valor in number) AS
    cur_form         curesp;
    vs_str           varchar2(100);
    vs_inf           varchar2(10);
    vs_valor_val     number(18, 4);
    val_rubrica_supl number(18, 4) := 0;
    vi_valor_det     number(18, 4) := 0;
    vc_nao_parcela   varchar2(1) := null;

  BEGIN

    vi_valor_det := i_valor;
    -- incluir informacao do beneficiario por ordem judicial PA

    IF COM_NUM_ORD_JUD IS NOT NULL THEN
      BEGIN
        select co.cod_ide_cli
          into rdcn.cod_ide_cli_ben
          from tb_composicao_oj co
         where co.cod_ins = PAR_COD_INS
           and co.num_ord_jud = COM_NUM_ORD_JUD
           AND co.cod_fcrubrica = com_cod_fcrubrica;
      EXCEPTION
        when no_data_found then
          rdcn.cod_ide_cli_ben := null;
      END;
    ELSE
      rdcn.cod_ide_cli_ben := null;
    END IF;

    vc_nao_parcela := 'N';

    --  testa se houve parcelamento --

    IF PAR_TIP_PRO = 'R' THEN
      IF BEN_IDE_CLI <> 2527500 THEN
        BEGIN
          SELECT distinct 'S'
            INTO vc_nao_parcela
            FROM TB_DET_CALCULADO_PARC
           WHERE COD_INS = PAR_COD_INS
             AND TIP_PROCESSO = 'N'
             AND DAT_INI_REF = PAR_PER_PRO
             AND trunc(cod_fcrubrica / 100, 000) =
                 trunc(COM_COD_FCRUBRICA / 100, 000)
             AND COD_IDE_CLI = BEN_IDE_CLI
             AND COD_BENEFICIO = COM_COD_BENEFICIO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            vc_nao_parcela := 'N';
        END;
      ELSE
        vc_nao_parcela := 'N';
      END IF;
    ELSE
      vc_nao_parcela := 'N';
    END IF;

    IF vc_nao_parcela = 'N' THEN

      IF vi_valor_det > 0 THEN
        BEGIN
          tdcn_pa.extend;
        EXCEPTION
          when others then
            p_sub_proc_erro := 'SP_INS_DETCAL_NORMAL';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro na criacao do array para Pensao Alimenticia';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  BEN_IDE_CLI,
                                  COM_COD_FCRUBRICA);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END;

        idx_caln_pa := nvl(idx_caln_pa, 0) + 1;
        --    idx_seq_detalhe := nvl(idx_seq_detalhe,0) + 1;

        --    Inverte a natureza da rubrica para gravar
        --    o registro como credito e calcular o IR da PA

        IF COM_NAT_RUB = 'C' then
          COM_NAT_RUB := 'D';
        ELSE
          COM_NAT_RUB := 'C';
        END IF;

        ---

        rdcn.flg_natureza := COM_NAT_RUB;

        rdcn.cod_ins       := PAR_COD_INS;
        rdcn.tip_processo  := PAR_TIP_PRO;
        rdcn.per_processo  := PAR_PER_PRO;
        rdcn.cod_ide_cli   := BEN_IDE_CLI ;
 --       rdcn.cod_beneficio := COM_COD_BENEFICIO;
        rdcn.seq_pagamento := vi_seq_pagamento;
        rdcn.seq_detalhe   := idx_caln_pa;
        rdcn.cod_fcrubrica := COM_COD_FCRUBRICA;
        rdcn.seq_vig       := COM_SEQ_VIG_FC;
        rdcn.val_rubrica   := vi_valor_det;
        rdcn.num_quota     := COM_NUM_QTAS_PAG + 1;

        rdcn.tot_quota       := COM_TOT_QTAS_PAG;
        rdcn.dat_ini_ref     := PAR_PER_PRO;
        rdcn.dat_fim_ref     := COM_FIM_REF;
        rdcn.num_ord_jud     := COM_NUM_ORD_JUD;
        rdcn.dat_ing         := sysdate;
        rdcn.dat_ult_atu     := sysdate;
        rdcn.nom_usu_ult_atu := PAR_COD_USU;
        rdcn.nom_pro_ult_atu := 'FOLHA CALCULADA';
        rdcn.des_informacao  := null;

        rdcn.val_rubrica_cheio := rdcn.val_rubrica;

        IF PAR_TIP_PRO = 'R' AND rdcn.des_complemento IS NULL THEN
          rdcn.des_complemento := 'Ret.';
        ELSIF rdcn.des_complemento not like 'Parc%' Then
          rdcn.des_complemento := null;
        END IF;

        rdcn.cod_ide_cli_ben := null;
        rdcn.cod_ide_cli_ben := COM_COD_IDE_CLI_BEN;

        vs_valor_val := 0;

        IF COM_MSC_INFORMACAO is not null AND
           COM_COL_INFORMACAO is not null THEN

          FOR i IN 1 .. nom_variavel.count LOOP

            IF nom_variavel(i) = COM_COL_INFORMACAO THEN
              vs_valor_val     := val_variavel(i);
              v_val_percentual := vs_valor_val;
              exit;
            END IF;

          END LOOP;

          vs_str := 'select ' || 'to_char(' || '''' || vs_valor_val || '''' || ',' || '''' ||
                    COM_MSC_INFORMACAO || '''' || ',' || '''' ||
                    'NLS_NUMERIC_CHARACTERS = ' || '".,"' || '''' || ')' ||
                    ' from dual';

          BEGIN
            OPEN cur_form FOR vs_str;
            FETCH cur_form
              INTO vs_inf;
            CLOSE cur_form;
          END;

          IF COM_COL_INFORMACAO = 'VAL_PERC_BENEFICIO' OR
             COM_COL_INFORMACAO = 'VAL_PAR_CONS' OR
             COM_COL_INFORMACAO = 'PERC_VAL_PENSAO' OR
             COM_COL_INFORMACAO = 'VAL_PERC_FIXO' THEN
            rdcn.des_informacao := vs_inf || '%';
          ELSIF COM_COL_INFORMACAO = 'PERC_RATEIO_PECUNIA' THEN
            rdcn.des_informacao := TO_CHAR(VI_PERC_PECUNIA,
                                           COM_MSC_INFORMACAO);
          ELSIF COM_COL_INFORMACAO = 'NUM_DEPENDENTES' THEN
            rdcn.des_informacao := vs_inf || ' Dep.';
          ELSIF COM_COL_INFORMACAO = 'GRP_ABONO_SALARIAL' THEN
            rdcn.des_informacao := 'GRP=' || vs_inf;
          ELSIF COM_COL_INFORMACAO = 'NUM_PARCELAS' THEN
            rdcn.des_informacao := lpad(to_char(COM_NUM_QTAS_PAG, '999'),
                                        3,
                                        0) || '/' ||
                                   lpad(to_char(COM_TOT_QTAS_PAG, '999'),
                                        3,
                                        0);
          ELSIF COM_COL_INFORMACAO = 'VAL_PENSAO' THEN
            rdcn.des_informacao := 'VAL. FIXO';
          ELSIF COM_COL_INFORMACAO = 'QTD_SAL_MIN_PENSAO' THEN
            rdcn.des_informacao := vs_inf || 'S.M.';
          ELSIF COM_COL_INFORMACAO = 'PERC_SAL_MIN_PENSAO' THEN
            rdcn.des_informacao := ltrim(vs_inf) || '% SM';
          ELSIF COM_COL_INFORMACAO = 'QTD_COTAS' THEN
            rdcn.des_informacao := ltrim(vs_inf);
          ELSE
            rdcn.des_informacao := vs_inf;
          END IF;
        END IF;

        tdcn_pa(idx_caln_pa) := rdcn;

      END IF;
    END IF;
    --EXCEPTION
    --     when errpro then
    --          null;
    --     when others then
    --          par_err  := sqlcode;
    --          par_men  := 'SP_INS_DETCAL_NORMAL: ' || sqlerrm;
  END SP_INS_DETCAL_PA;
  ----------------------------------------------------------------------------------


  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DATA_OBITO(I_BENEFICIO  IN NUMBER,
                                O_DATA_OBITO OUT date) AS
    --V_COUNT NUMBER;
  v_cod_entidade number := 0;
  BEGIN
    BEGIN

      select pf.dat_obito
        into O_DATA_OBITO
        from tb_pessoa_fisica pf
       where pf.cod_ide_cli =
             (select cod_ide_cli_serv
                from tb_concessao_beneficio
               where cod_beneficio = I_BENEFICIO
                 and cod_ins = PAR_COD_INS)
                 --and cod_entidade = COM_COD_ENTIDADE)
         and pf.cod_ins = PAR_COD_INS;

      --         SELECT --DECODE(PF.DAT_OBITO, null, to_char(PAR_PER_PRO,'YYYYMMDD'), to_char(PF.DAT_OBITO,'YYYYMMDD'))
      --                 pf.dat_obito
      --           into O_DATA_OBITO
      --           FROM TB_PESSOA_FISICA PF,
      --                TB_CONCESSAO_BENEFICIO CB
      --          WHERE PF.COD_INS = 1
      --            AND CB.COD_IDE_CLI_SERV = PF.COD_IDE_CLI
      --           AND CB.COD_BENEFICIO = I_BENEFICIO
      --           and cb.cod_entidade = COM_COD_ENTIDADE
      --           and pf.cod_ins = cb.cod_ins;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_DATA_OBITO := par_per_pro; --to_char(PAR_PER_PRO,'YYYYMMDD');
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_DATA_OBITO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter a data do obito';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        --          RAISE ERRO;
    END;

  END SP_OBTEM_DATA_OBITO;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_DATA_OBITO_INV(I_BENEFICIO  IN NUMBER,
                                    O_DATA_OBITO OUT VARCHAR2) AS
    --V_COUNT NUMBER;
  BEGIN
    BEGIN
      SELECT --DECODE(PF.DAT_OBITO, null, to_char(PAR_PER_PRO,'YYYYMMDD'), to_char(PF.DAT_OBITO,'YYYYMMDD'))
       to_char(pf.dat_obito, 'YYYYMMDD')
        into O_DATA_OBITO
        FROM TB_PESSOA_FISICA PF, TB_CONCESSAO_BENEFICIO CB
       WHERE PF.COD_INS = 1
         AND CB.COD_IDE_CLI_SERV = PF.COD_IDE_CLI
         AND CB.COD_BENEFICIO = I_BENEFICIO
         and cb.cod_entidade = COM_COD_ENTIDADE
         and pf.cod_ins = cb.cod_ins;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_DATA_OBITO := to_char(par_per_pro, 'yyyymmdd'); --to_char(PAR_PER_PRO,'YYYYMMDD');
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_DATA_OBITO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter a data do obito inv.';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        --          RAISE ERRO;
    END;

  END SP_OBTEM_DATA_OBITO_INV;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_DETALHE_PAG_PA(ide_cli          in varchar2,
                                     TP_COD_BENEFICIO IN NUMBER,
                                     TP_RUBRICA       IN NUMBER,
                                     TP_VAL_RUBRICA   IN NUMBER,
                                     TP_SEQ_VIG       IN NUMBER,
                                     TP_FLG_NATUREZA  IN VARCHAR2) as

  BEGIN

    /* obter a rubrica de credito para PA */

    rdcn.cod_ins         := PAR_COD_INS;
    rdcn.tip_processo    := PAR_TIP_PRO;
    rdcn.per_processo    := PAR_PER_PRO;
    rdcn.cod_ide_cli     := ide_cli;
--    rdcn.cod_beneficio   := TP_COD_BENEFICIO;
    rdcn.seq_pagamento   := vi_seq_pagamento;
    rdcn.seq_detalhe     := idx_seq_detalhe;
    rdcn.cod_fcrubrica   := 2200100; --tp_rubrica;
    rdcn.val_rubrica     := tp_val_rubrica;
    rdcn.seq_vig         := tp_seq_vig;
    rdcn.num_quota       := 0;
    rdcn.flg_natureza    := tp_flg_natureza;
    rdcn.tot_quota       := 0;
    rdcn.dat_ini_ref     := PAR_PER_PRO;
    rdcn.dat_fim_ref     := NULL;
    rdcn.cod_ide_cli_ben := NULL; --verificar
    rdcn.num_ord_jud     := NULL; --varificar
    rdcn.dat_ing         := sysdate;
    rdcn.dat_ult_atu     := sysdate;
    rdcn.nom_usu_ult_atu := PAR_COD_USU;
    rdcn.nom_pro_ult_atu := 'FOLHA CALCULADA';


    rdcn.des_complemento := null;

    IF VI_NUM_DEP_ECO > 0 AND trunc(tp_rubrica / 100, 000) = 3902 THEN
      rdcn.des_informacao := to_char(VI_NUM_DEP_ECO, '09') || ' Dep.';
    END IF;

    tdcn_pa(idx_caln_pa) := rdcn;

  END SP_INCLUI_DETALHE_PAG_PA;

  ----------------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_DET_PAG_PA (IDE_CLI IN VARCHAR2, COD_BEN IN NUMBER) AS    --  GRAVA DETALHE DE PENSAO ALIMENTICEA
    V_RUBRICA_SUPL      NUMBER(8) := 0;
    val_rubrica_supl    number(18, 4) := 0;
    cont_detalhe        number := 0;
    i                   integer := 0;
    PER_PRO_RET         date;
    v_rubrica_contraria NUMBER(8) := 0;

  BEGIN

    cont_detalhe := 0;

    -- Folha Normal
    FOR i in 1 .. tdcn_pa.count LOOP

      rdcn := tdcn_pa(i);
      IF rdcn.cod_ide_cli_ben = IDE_CLI THEN

      IF rdcn.dat_ini_ref = rdcn.per_processo then
        rdcn.des_complemento := null;
      end if;
      IF rdcn.per_processo = PAR_PER_PRO THEN
        IF rdcn.val_rubrica > 0 THEN
          cont_detalhe := cont_detalhe + 1;
          BEGIN
            --pega rubrica contraria ao invez da principal ROD.18.ago.09
            select cod_rubrica_contraria
              into v_rubrica_contraria
              from tb_rubricas
             where cod_rubrica = rdcn.cod_fcrubrica
               and cod_entidade = ANT_ENTIDADE
               and (dat_fim_vig is null or dat_fim_vig > PAR_PER_PRO);
            IF v_rubrica_contraria is null then
              v_rubrica_contraria := rdcn.cod_fcrubrica;
            END IF;
              NULL;
          EXCEPTION
            WHEN OTHERS THEN
              p_sub_proc_erro := 'SP_GRAVA_DET_PAG_PA';
              p_coderro       := SQLCODE;
              P_MSGERRO       := 'Erro ao gravar o detalhe da rubricas de pensao alimenticia';
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                    p_coderro,
                                    'Calcula Folha',
                                    sysdate,
                                    p_msgerro,
                                    p_sub_proc_erro,
                                    rdcn.cod_ide_cli,
                                    rdcn.cod_fcrubrica);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              --       RAISE ERRO;
          END;

        END IF;
      END IF;
      END IF;

    END LOOP;

    commit;

    -- Folha Terceiros

  END SP_GRAVA_DET_PAG_PA;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_PAGAMENTO_ESPECIAL(o_pagto_especial out number) AS

    v_cod_bene tb_beneficiario.cod_beneficio%type;

  BEGIN

    begin
      SELECT 1
        into o_pagto_especial
        from tb_casos_ret_folha crf
       where crf.cod_ins = par_cod_ins
         and crf.cod_ide_cli = ant_ide_cli
         and crf.dat_periodo_comp = PAR_PER_REAL
         and exists (select 1
                from tb_folha ff
               where ff.cod_ins = crf.cod_ins
                 and ff.tip_processo = 'E'
                 and ff.per_processo = PAR_PER_PRO
                 and ff.cod_ide_cli = crf.cod_ide_cli
                 and ff.seq_pagamento > 0);

      select distinct cod_beneficio, cod_entidade
        into ant_cod_beneficio, ant_entidade
        from tb_beneficio_cargo
       where cod_ins = PAR_COD_INS
         and cod_ide_cli_ben = ant_ide_cli
         and flg_status = 'V'
         and dat_fim_vig is null;

      for g in (select dc1.cod_beneficio,
                       dc1.cod_fcrubrica,
                       dc1.val_rubrica,
                       dc1.flg_natureza,
                       dc1.dat_ini_ref,
                       dc1.seq_pagamento,
                       dc1.seq_vig,
                       dc1.des_complemento,
                       dc1.des_informacao
                  from tb_det_calculado dc1
                 where dc1.cod_ins = PAR_COD_INS
                   and dc1.tip_processo = 'E'
                   and dc1.per_processo = PAR_PER_PRO
                   and dc1.cod_ide_cli = ant_ide_cli
                   and dc1.cod_beneficio > 0
                   and dc1.seq_pagamento > 0) loop

        tdcn.extend;
        idx_caln        := nvl(idx_caln, 0) + 1;
        idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;

        rdcn.cod_ins       := PAR_COD_INS;
        rdcn.tip_processo  := 'E';
        rdcn.per_processo  := PAR_PER_PRO;
        rdcn.cod_ide_cli   := ANT_IDE_CLI;
--        rdcn.cod_beneficio := g.cod_beneficio;
        rdcn.seq_pagamento := g.seq_pagamento;
        rdcn.seq_detalhe   := idx_seq_detalhe;
        rdcn.cod_fcrubrica := g.cod_fcrubrica;
        rdcn.val_rubrica   := g.val_rubrica;
        rdcn.seq_vig       := g.seq_vig;
        rdcn.num_quota     := 0;
        rdcn.flg_natureza  := g.flg_natureza;
        rdcn.tot_quota     := 0;
        rdcn.dat_ini_ref   := g.dat_ini_ref;
        rdcn.dat_fim_ref   := NULL;
        --             rdcn.cod_ide_cli_ben:= NULL;        --verificar
        --          rdcn.num_ord_jud    := NULL;        --varificar
        rdcn.dat_ing         := sysdate;
        rdcn.dat_ult_atu     := sysdate;
        rdcn.nom_usu_ult_atu := PAR_COD_USU;
        rdcn.nom_pro_ult_atu := 'FOLHA CALCULADA';

        rdcn.des_complemento := g.des_complemento;
        rdcn.des_informacao  := g.des_informacao;

        tdcn(idx_caln) := rdcn;

      end loop;

    exception
      when others then
        o_pagto_especial := 0;
    end;
  END SP_OBTEM_PAGAMENTO_ESPECIAL;
  ----------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_ENQUADRAMENTO(o_tipo_efeito      in number,
                                   o_cod_ref_oj       out number,
                                   o_cod_beneficio_oj out number,
                                   o_val_porc_efe     out number) is -- MVL 26/08/2008
  BEGIN
    begin

      select OJP.COD_REFER, ojp.cod_beneficio, ij.percentual
      --            OJP.VAL_PORC_EFE
        into o_cod_ref_oj, o_cod_beneficio_oj, o_val_porc_efe
        from tb_ord_jud_pessoa_fisica ojp,
             TB_ORDEM_JUD_TIPO_EFEITO OJ,
             TB_ORDEM_JUDICIAL        OJU,
             Tb_Indice_Jud            IJ
       where OJ.COD_INS = PAR_COD_INS
         AND OJ.COD_INS = ojp.cod_ins
         and OJ.NUM_ORD_JUD = OJP.NUM_ORD_JUD
         AND OJU.COD_INS = OJ.COD_INS
         AND OJU.NUM_ORD_JUD = OJ.NUM_ORD_JUD
         AND ojp.cod_ide_cli = BEN_IDE_CLI
         AND OJU.DAT_FIM_EFEITO IS NULL
         AND oj.cod_tip_efeito = o_tipo_efeito
         AND ij.tab_ind_jud = OJP.TAB_IND_JUD
         AND ij.cod_ins = oj.cod_ins;

    exception
      when no_data_found then
        o_cod_ref_oj       := 0;
        o_cod_beneficio_oj := 0;
        o_val_porc_efe     := 0;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'FUNCAO 81';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o enquadramento';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
  END SP_OBTEM_ENQUADRAMENTO;
  ----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_LIMITE_REGIME_GERAL(o_dat_obito out date) is
  BEGIN
    SELECT PEF.DAT_OBITO
      INTO O_DAT_obito
      FROM TB_PESSOA_FISICA PEF
     WHERE PEF.COD_INS = PAR_COD_INS
       AND PEF.COD_IDE_CLI = COM_IDE_CLI_INSTITUIDOR;

  END SP_OBTEM_LIMITE_REGIME_GERAL;
  ----------------------------------------------------------------------------
  FUNCTION SP_OBTEM_DIAS_BENEFICIO RETURN NUMBER as

    v_qtd_d number;

  BEGIN
    BEGIN
      SELECT TO_NUMBER(to_char(RB.DAT_INI_BEN, 'DD'))
        INTO v_qtd_d
        FROM tb_BENEFICIARIO rb
       WHERE RB.COD_INS = PAR_COD_INS
         AND RB.COD_IDE_CLI_BEN = BEN_IDE_CLI
         AND RB.COD_BENEFICIO = COM_COD_BENEFICIO;
    EXCEPTION
      WHEN OTHERS THEN
        v_qtd_d := 0;
    END;

    RETURN(v_qtd_d);

  END SP_OBTEM_DIAS_BENEFICIO;
  --------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_TIPO_BENEFICIO(cod_benef in number) AS
  BEGIN
     SELECT DECODE(trim(C.COD_TIPO_BENEFICIO),
                  'M',
                  'PENSIONISTA',
                  'APOSENTADO') AS COM_TIP_BENEFICIO
          into COM_TIP_BENEFICIO
          from tb_concessao_beneficio c
          where c.cod_beneficio= cod_benef ;

  END SP_OBTEM_TIPO_BENEFICIO;
  -----------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_REFERENCIA(o_var_padrao in varchar2,
                                o_referencia out number) AS

  BEGIN

    select max(re.cod_referencia)
      into o_referencia
      from tb_referencia re
     where re.cod_ins = PAR_COD_INS
       and re.cod_pccs = COM_PCCS
       and re.cod_ref_pad_venc = o_var_padrao
       and (PAR_PER_PRO >= re.dat_ini_vig and
           PAR_PER_PRO <=
           nvl(re.dat_fim_vig, to_date('01/01/2045', 'dd/mm/yyyy')));

  exception
    when others then

      o_referencia := 0;

  END SP_OBTEM_REFERENCIA;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_ORDEM_JUDICIAL(i_num_funcao  in number,
                                       o_val_percent out number) is
    -- MVL 26/08/2008

    w_val_percent number(12, 6) := 0;

  BEGIN
    begin

      select decode(i_num_funcao,
                    0,
                    decode(ojp.ind_calculo,
                           'C',
                           (inj.percentual / 100) + 1,
                           nvl(PAR_PERCENT_CORRECAO, 1)),
                    (inj.percentual / 100) + 1),
             ojp.ind_calculo
        into w_val_percent, COM_IND_CALCULO
        from tb_ord_jud_pessoa_fisica ojp,
             TB_ORDEM_JUD_TIPO_EFEITO OJ,
             TB_ORDEM_JUDICIAL        OJU,
             TB_INDICE_JUD            INJ
       where OJ.COD_INS = PAR_COD_INS
         AND OJ.COD_INS = ojp.cod_ins
         and OJ.NUM_ORD_JUD = OJP.NUM_ORD_JUD
         AND OJU.COD_INS = OJ.COD_INS
         AND OJU.NUM_ORD_JUD = OJ.NUM_ORD_JUD
         AND ojp.cod_ide_cli = BEN_IDE_CLI
         AND OJU.DAT_FIM_EFEITO IS NULL
         AND oj.cod_tip_efeito = 3
         AND INJ.TAB_IND_JUD = OJP.TAB_IND_JUD
         AND INJ.COD_INS = OJ.COD_INS
         AND OJU.DAT_EFEITO<=PAR_PER_PRO
         AND NVL(OJU.DAT_FIM_EFEITO,TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO;

      IF i_num_funcao = 214 then

        o_val_percent := w_val_percent;

      ELSE
        o_val_percent        := w_val_percent;
        PAR_PERCENT_CORRECAO := w_val_percent;

      END IF;

    exception
      when no_data_found then
        if PAR_IND_PROC_ENQUADRAMENTO <> 1 then
          PAR_PERCENT_CORRECAO := 1;
          o_val_percent        := 1;
        end if;
      WHEN TOO_MANY_ROWS THEN
        PAR_PERCENT_CORRECAO := 1;
        o_val_percent        := 1;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_VERIFICA_ORDEM_JUDICIAL';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o ordem judicial';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              1);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
  END SP_VERIFICA_ORDEM_JUDICIAL;
  --------------------------------------------------------------------------------

  ---------------------------------------------------------------------------------
  PROCEDURE SP_VERIFICA_TETO_FIXO(i_cod_benef in NUMBER,
                                  o_teto_fixo out number) as
  v_teto_fixo       number(18, 4) := 0;
  BEGIN
      select cb.teto_fixo
       into v_teto_fixo
      from tb_concessao_beneficio cb
       where cb.cod_beneficio = i_cod_benef ;

      o_teto_fixo := v_teto_fixo;

  END SP_VERIFICA_TETO_FIXO;
  ---------------------------------------------------------------------------------
  PROCEDURE SP_OBTEM_RUBRICA_EVENTO_ESPEC(itip_evento_especial in varchar2,
                                          i_cod_entidade       in number,
                                          i_flg_natureza       in varchar2,
                                          o_cod_rubrica        out number,
                                          o_seq_vig            out number) as
  BEGIN
    BEGIN
      SELECT rr.cod_rubrica, rr.seq_vig
        INTO o_cod_rubrica, o_seq_vig
        FROM tb_rubricas rr, tb_rubricas_processo rp
       WHERE rr.cod_ins = PAR_COD_INS
         AND rr.tip_evento_especial = itip_evento_especial
         AND rr.tip_evento = decode(PAR_TIP_PRO,
                                    'N','N',
                                    'S','N',
                                    'R','N',
                                    'T','T',
                                    'E','N') -- 'N' --Tip_processo MVL
         AND rr.cod_entidade = rp.cod_entidade
         and rr.cod_entidade = i_cod_entidade
         AND RR.DAT_INI_VIG <= PAR_PER_PRO
         AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL)
         AND RP.FLG_PROCESSA = 'S'
         AND rr.cod_ins = rp.cod_ins
         AND rr.cod_rubrica = rp.cod_rubrica
         AND rp.tip_processo = decode(PAR_TIP_PRO,
                                    'N','N',
                                    'S','N',
                                    'R','N',
                                    'T','T',
                                    'E','N') --PAR_TIP_PRO  --continuar alterar tabela criando as rubricas 'S'
         AND rp.dat_ini_vig <= PAR_PER_PRO
         AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL);

    exception
      when no_data_found then
      BEGIN
         SELECT rr.cod_rubrica, rr.seq_vig
           INTO o_cod_rubrica, o_seq_vig
         FROM tb_rubricas rr, tb_rubricas_processo rp
         WHERE rr.cod_ins = PAR_COD_INS
           AND rr.tip_evento_especial = itip_evento_especial
           AND rr.tip_evento = decode(PAR_TIP_PRO,
                                      'N','N',
                                      'S','N',
                                      'R','N',
                                      'T','N',
                                      'E','N') -- 'N' --Tip_processo MVL
           AND rr.cod_entidade = rp.cod_entidade
           and rr.cod_entidade = i_cod_entidade
           AND RR.DAT_INI_VIG <= PAR_PER_PRO
           AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL)
           AND RP.FLG_PROCESSA = 'S'
           AND rr.cod_ins = rp.cod_ins
           AND rr.cod_rubrica = rp.cod_rubrica
           AND rp.tip_processo = decode(PAR_TIP_PRO,
                                      'N','N',
                                      'S','N',
                                      'R','N',
                                      'T','T',
                                      'E','N') --PAR_TIP_PRO  --continuar alterar tabela criando as rubricas 'S'
           AND rp.dat_ini_vig <= PAR_PER_PRO
           AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL);
      exception
            when others then
            p_sub_proc_erro := 'SP_OBTEM_RUBRICA_EVENTO_ESPECIAL';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao obter a rubrica evento especial' ||
                               ' Entidade : ' || ant_entidade ||
                               'Evento Especial' || itip_evento_especial;
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  ant_ide_cli,
                                  0);
             VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        end;
      -----------------------
      when others then
        p_sub_proc_erro := 'SP_OBTEM_RUBRICA_EVENTO_ESPECIAL';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter a rubrica evento especial' ||
                           ' Entidade : ' || ant_entidade ||
                           'Evento Especial' || itip_evento_especial;
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              ant_ide_cli,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;

    end;

  END SP_OBTEM_RUBRICA_EVENTO_ESPEC;
  ---------------------------------------------------------------------------------
  FUNCTION SP_OBTEM_PODER(o_cod_entidade in number) RETURN VARCHAR2 as

    v_desc_curta tb_codigo.des_descricao_curta%type;

  BEGIN
    BEGIN
      select en.cod_poder
        into v_desc_curta
        from --tb_codigo cc,
             tb_entidade en
       where --cc.cod_num = 2021
      -- and cc.cod_par = en.cod_poder
       en.cod_ins = PAR_COD_INS
       and en.cod_entidade = o_cod_entidade;

    EXCEPTION
      WHEN OTHERS THEN
        v_desc_curta := ' ';
    END;

    RETURN(v_desc_curta);

  END SP_OBTEM_PODER;
  --------------------------------------------------------------------------------
PROCEDURE SP_INCLUI_RESULTADO_CALC_RET(i_rdcn in TB_DET_CALCULADO_ATIV_ESTRUC%rowtype) as --tb_det_calculado%rowtype  ) AS

  BEGIN

    BEGIN

                INSERT /*+ append */
                INTO TB_RESULTADO_CALC_RET_ATIVO (
                    cod_ins           ,
                    tip_processo      ,
                    per_processo      ,
                    cod_ide_cli       ,
                    cod_ide_cli_ben   ,
                    cod_entidade      ,
                    num_matricula     ,
                    cod_ide_rel_func  ,
                    seq_pagamento     ,
                    cod_fcrubrica     ,
                    seq_vig           ,
                    val_rubrica       ,
                    num_quota         ,
                    tot_quota         ,
                    val_rubrica_cheio ,
                    val_unidade       ,
                    val_porc          ,
                    dat_ini_ref       ,
                    dat_fim_ref       ,
                    flg_natureza      ,
                    num_ord_jud       ,
                    seq_detalhe       ,
                    des_informacao    ,
                    des_complemento   ,
                    ind_inclui_folha  ,
                    ind_processo      ,
                    dat_ing           ,
                    dat_ult_atu       ,
                    nom_usu_ult_atu   ,
                    nom_pro_ult_atu    ,
                    ------- Memoria de Calculo ----------------
                    flg_log_calc        ,
                    cod_formula_cond    ,
                    des_condicao        ,
                    cod_formula_rubrica ,
                    des_formula         ,
                    des_composicao

                  )
                  VALUES
                    (
                    i_rdcn.cod_ins     ,
                    i_rdcn.tip_processo ,
                    PAR_PER_REAL        ,
                    i_rdcn.cod_ide_cli  ,
                    i_rdcn.cod_ide_cli_ben,
                    i_rdcn.cod_entidade ,
                    i_rdcn.num_matricula  ,
                    i_rdcn.cod_ide_rel_func ,
                    i_rdcn.seq_pagamento  ,
                    i_rdcn.cod_fcrubrica  ,
                    i_rdcn.seq_vig  ,
                    i_rdcn.val_rubrica  ,
                    i_rdcn.num_quota  ,
                    i_rdcn.tot_quota  ,
                    i_rdcn.val_rubrica_cheio  ,
                    i_rdcn.val_unidade  ,
                    i_rdcn.val_porc ,
                    i_rdcn.dat_ini_ref  ,
                    i_rdcn.dat_fim_ref  ,
                    i_rdcn.flg_natureza ,
                    i_rdcn.num_ord_jud  ,
                    i_rdcn.seq_detalhe  ,
                    i_rdcn.des_informacao ,
                    i_rdcn.des_complemento  ,
                    i_rdcn.ind_inclui_folha ,
                    i_rdcn.ind_processo     ,
                    i_rdcn.dat_ing          ,
                    i_rdcn.dat_ult_atu      ,
                    i_rdcn.nom_usu_ult_atu  ,
                    i_rdcn.nom_pro_ult_atu  ,
                    ----------------- Memoria de Calculo ----------------
                    i_rdcn.flg_log_calc        ,
                    i_rdcn.cod_formula_cond    ,
                    i_rdcn.des_condicao        ,
                    i_rdcn.cod_formula_rubrica ,
                    i_rdcn.des_formula         ,
                    i_rdcn.des_composicao
                   );

    EXCEPTION
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_GRAVA_RESULTADO_RET A';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao incluir o resultado do calculo retroativo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              i_RDCN.COD_IDE_CLI,
                              i_RDCN.COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_INCLUI_RESULTADO_CALC_RET;
  --------------------------------------------------------------------------------
  PROCEDURE SP_INCLUI_TB_DET_RET(i_rdcn in    TB_DET_CALCULADO_ATIV_ESTRUC%rowtype) as

  BEGIN

    BEGIN
      NULL;
    EXCEPTION
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_GRAVA_TB_DET_RET A';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao incluir o detalhe retroativo';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              i_RDCN.COD_IDE_CLI,
                              i_RDCN.COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

  END SP_INCLUI_TB_DET_RET;
  --------------------------------------------------------------------------------
 PROCEDURE SP_INCLUI_VALOR_NPAGO_RET(i_rdcn in TB_DET_CALCULADO_ATIV_ESTRUC%rowtype) as


  BEGIN

  BEGIN
      INSERT /*+ append */
      INTO TB_VALOR_NPAGO_RET_ATIVO
        (
                    cod_ins        ,
                    tip_processo   ,
                    per_processo   ,
                    cod_ide_cli    ,
                    cod_ide_cli_ben,
                    cod_entidade   ,
                    num_matricula  ,
                    cod_ide_rel_func  ,
                    seq_pagamento ,
                    cod_fcrubrica ,
                    seq_vig       ,
                    val_rubrica   ,
                    num_quota     ,
                    tot_quota     ,
                    val_rubrica_cheio ,
                    val_unidade  ,
                    val_porc     ,
                    dat_ini_ref  ,
                    dat_fim_ref  ,
                    flg_natureza ,
                    num_ord_jud  ,
                    seq_detalhe  ,
                    des_informacao  ,
                    des_complemento ,
                    ind_inclui_folha,
                    ind_processo    ,
                    dat_ing         ,
                    dat_ult_atu     ,
                    nom_usu_ult_atu ,
                    nom_pro_ult_atu

                  )
                  VALUES
                    (
                    i_rdcn.cod_ins      ,
                    i_rdcn.tip_processo ,
                     PAR_PER_REAL       ,
                    i_rdcn.cod_ide_cli  ,
                    i_rdcn.cod_ide_cli_ben,
                    i_rdcn.cod_entidade ,
                    i_rdcn.num_matricula    ,
                    i_rdcn.cod_ide_rel_func ,
                    i_rdcn.seq_pagamento  ,
                    i_rdcn.cod_fcrubrica  ,
                    i_rdcn.seq_vig        ,
                    i_rdcn.val_rubrica    ,
                    i_rdcn.num_quota  ,
                    i_rdcn.tot_quota  ,
                    i_rdcn.val_rubrica  ,-- Repite valor Rubrica no valor cheio
                    i_rdcn.val_unidade  ,
                    i_rdcn.val_porc ,
                    i_rdcn.dat_ini_ref  ,
                    i_rdcn.dat_fim_ref  ,
                    i_rdcn.flg_natureza ,
                    i_rdcn.num_ord_jud  ,
                    i_rdcn.seq_detalhe  ,
                    i_rdcn.des_informacao ,
                    i_rdcn.des_complemento,
                    'S'                   ,
                    'S'                   ,
                    i_rdcn.dat_ing        ,
                    i_rdcn.dat_ult_atu    ,
                    i_rdcn.nom_usu_ult_atu,
                    i_rdcn.nom_pro_ult_atu
                   );

    EXCEPTION
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_GRAVA_TB_VALOR_NPAGO_RET A';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro :'||sqlerrm;
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              i_RDCN.COD_IDE_CLI,
                              i_RDCN.COD_FCRUBRICA);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    commit;

  END SP_INCLUI_VALOR_NPAGO_RET;
  -----------------------------------------------------------------------------------------------------------------------------
  PROCEDURE SP_ATUALIZA_DECIMOTERC(
                                   i_cod_ins                in number,
                                   i_per_pro                in date, -- Periodo a processar
                                   i_cod_usu                in varchar2,
                                   i_tip_pro                in varchar2, -- TIPO DE PROCESSO: N (normal), S (Suplementar), T (13 Salario)
                                   i_par_per_real           in date,
                                   i_des_tipos_benef        in varchar2,
                                   i_cod_tipo_ben           in varchar2,
                                   i_num_processo           in number, --ROD6 :: Indica o grupo a ser processado
                                   i_num_grp                in number, --ROD7 :: numero do grupo de pagamento a processar
                                   i_seq_pag                in number,
                                   i_num_cpf                in varchar2,
                                   i_num_seq_proc           in number,
                                   i_flg_retorno            out varchar2) AS

   --CARREGA VARIAVEIS INICIAIS:
   v_cod_proc_grp_pag      char(2);
   cod_benef               number := 0;
   v_rubantecip13          number;
   vi_seq_vig              number;
   conta                   number := 0;
   v_tipo_beneficio        varchar2(1);
   v_cod_entidade          number(8);
   v_val_rubrica           number(18,4);
   v_val_rubrica_c         number(18,4);
   v_val_rubrica_d         number(18,4);
   v_val_rubrica_AGRUPADA  number(18,4);
   v_conta_ok              number(18) :=0;
   v_conta_nok             number(18) :=0;
   v_soma1                 number(18,4) :=0;
   v_soma2                 number(18,4) :=0;
   v_max_seq_det           number :=0;
   DAT_INICIO_BENEFICIO    date;
   v_dat_ini_p13           date;
   v_qtddias_13prop        number := 0;
   FATORP13                number(18, 4) := 0;
   v_seq_detalhe           number :=0;
   v_cod_variavel          varchar2(20);
   v_soma_valantecip13     number(18, 4) := 0;
   v_flag_natureza         char(1);
   v_desc_prev             number(18, 4) := 0;
   v_valor_incapacidade    number(18, 4) := 0;
   v_cargo                 tb_concessao_beneficio.cod_cargo%type;
   v_entidade              tb_concessao_beneficio.cod_entidade%type;
   v_matricula             tb_concessao_beneficio.num_matricula%type;
   v_perc_prev             number(10, 4) := 0;
   vi_rubrica_prev         tb_det_calculado_ESTRUC.cod_fcrubrica%type;
   V_VAL_RUBRICA_PREV      tb_det_calculado_ESTRUC.val_rubrica%type;
   V_VAL_RUBRICA_PREV_C    tb_det_calculado_ESTRUC.val_rubrica%type;
   V_VAL_RUBRICA_PREV_D    tb_det_calculado_ESTRUC.val_rubrica%type;
   o_str                   char(1);
   vi_val_rubrica          tb_det_calculado_ESTRUC.val_rubrica%type;
   --v_desc_prev             tb_det_calculado.val_rubrica%type;
   V_NOVO_BENEF            boolean := false;

  BEGIN

  PAR_COD_INS := i_cod_ins;
  PAR_PER_PRO := i_per_pro;
  PAR_TIP_PRO := i_tip_pro;

  -- IDENTIFICA O GRUPO DE PAGAMENTO
   select cod_proc_grp_pago into v_cod_proc_grp_pag
         from tb_grupo_pagamento where num_grp_pag= i_num_grp;

  -- Identifica o valor de Descinto do calculo de previdencia
   SP_OBTEM_PARVAL_FOLHA2('TASCO', 2000, 'DESC_CONTR', v_desc_prev);
   SP_OBTEM_PARVAL_FOLHA2('TASCO', 2000, 'PERC_CONTR', v_perc_prev); --  0,11


  -------------------------------- FOLHA NORMAL OU SUPLEMENTAR
  IF PAR_TIP_PRO = 'N' OR PAR_TIP_PRO = 'S' THEN
     -- SELECIONA O GRUPO DE BENEFICIARIOS A ATUALIZAR
     -- LACO LENDO E CALCULANDO PARA CADA UM A ANTECIPAC?O
     FOR zsel IN (SELECT DISTINCT D.COD_IDE_CLI, D.COD_BENEFICIO
                    FROM TB_DET_CALCULADO D, TB_PESSOA_FISICA P,
                         TB_BENEFICIARIO B , TB_CONTROLE_PROCESSAMENTO CP
                   WHERE D.COD_INS = i_cod_ins
                     AND D.TIP_PROCESSO = i_tip_pro
                     AND D.PER_PROCESSO = i_per_pro
                     AND D.COD_IDE_CLI=P.COD_IDE_CLI
                     and B.Cod_Proc_Grp_Pag = v_cod_proc_grp_pag
                     and p.num_cpf = nvl(i_num_cpf, p.num_cpf )
                     and B.cod_beneficio=d.cod_beneficio and b.cod_ide_cli_ben=d.cod_ide_cli
                     AND to_number(to_char(P.DAT_NASC,'MM'))=to_number(to_char( i_per_pro,'MM'))+1
                     AND cp.seq_processamento=i_num_seq_proc
                     AND p.num_cpf>=cp.num_cpf_inicial and p.num_cpf<cp.num_cpf_final
                     ) loop

        conta:=conta+1;
     -- CARREGA VALOR NA VAR cod_benef com o codigo de beneficio atual
        cod_benef := zsel.cod_beneficio;

     -- PEGA COD_ENTIDADE E TIPO_BENEFICIO deste IDE_CLI
        select cb.cod_tipo_beneficio,cb.cod_entidade, cb.cod_cargo,cb.num_matricula
               into v_tipo_beneficio, v_cod_entidade, v_cargo, v_matricula
               from tb_concessao_beneficio cb
               where cb.cod_beneficio=cod_benef;

     -- (VERIFICAR SE JA RECEBEU ANTECIPAC?O ESTE ANO)
     -- IDENTIFICA VALOR DE COM_TIP_BENEFICIO PARA CADA UM LIDO NO LACO
        SP_OBTEM_TIPO_BENEFICIO(cod_benef);
     -- IDENTIFICA A RUBRICA A UTILIZAR (PENS?O OU APOSENTADO)
        IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
                          SP_OBTEM_RUBRICA_EVENTO_ESPEC('G',
                                                v_cod_entidade,
                                                'C',
                                                v_rubantecip13,
                                                vi_seq_vig);
                          v_cod_variavel:='BASE_COMP';
        ELSE
                          SP_OBTEM_RUBRICA_EVENTO_ESPEC('D',
                                                v_cod_entidade,
                                                'C',
                                                v_rubantecip13,
                                                vi_seq_vig);
                          IF v_cod_entidade <> 5 THEN
                             v_cod_variavel:='BASE_DEC13_PENCIV';
                          ELSE
                             v_cod_variavel:='BASE_DEC13_PENMIL';
                          END IF;
        END IF;


     -- IDENTIFICA SEQUENCIA
     BEGIN
        v_seq_detalhe := 0 ;
        SELECT d.seq_detalhe
            INTO v_seq_detalhe
            FROM TB_DET_CALCULADO d
            where            D.cod_fcrubrica=v_rubantecip13
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio;

      -- APAGA RUBRICAS DE 13o NA TB_DET_CALCULADO
        DELETE tb_det_calculado d where d.cod_fcrubrica=v_rubantecip13
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.FLG_NATUREZA = 'C'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio;
        commit;
        EXCEPTION
            WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Aviso N?o localizada rubrica antecip.13o';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha Pos',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                zsel.cod_ide_cli,
                                null);
            commit;
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            v_seq_detalhe :=0;
            SELECT max(d.seq_detalhe)
              INTO v_seq_detalhe
              FROM TB_DET_CALCULADO d
              where          D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
        END;

     -- SOMA RUBRICAS PAGAS - DEFINE VALOR A PAGAR
        SELECT DISTINCT sum(VAL_RUBRICA)
                        INTO V_VAL_RUBRICA_C
                        FROM TB_DET_CALCULADO D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.FLG_NATUREZA = 'C'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=v_rubantecip13
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = v_cod_variavel
                                       and cd.cod_entidade_composta=v_cod_entidade);

        SELECT DISTINCT sum(VAL_RUBRICA)
                        INTO V_VAL_RUBRICA_D
                        FROM TB_DET_CALCULADO D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.FLG_NATUREZA = 'D'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=v_rubantecip13
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = v_cod_variavel
                                       and cd.cod_entidade_composta=v_cod_entidade);

      --Calcula Proporcionalidade inicial do adiantamento de 13o -ROD12 em:050809
        select cb.dat_ini_ben
          into v_dat_ini_p13
          from tb_beneficiario cb
         where cod_beneficio = zsel.cod_beneficio and cb.cod_ins=PAR_COD_INS
               AND CB.COD_IDE_CLI_BEN=zsel.cod_ide_cli;


        /*     -- comentado por JTS 14-05-2010
            if (v_dat_ini_p13 >= to_date('01/01/'||to_char( PAR_PER_PRO,'YYYY'),'dd/mm/yyyy')) then
                select par_per_pro - v_dat_ini_p13
                  into v_qtddias_13prop
                  from dual;
                FATORP13 := v_qtddias_13prop / (30 * 12);
              else
                FATORP13 := 0.5;
              end if;
        */
         ----- Codigo Novo JTS 24-05-2010 ---
          FATORP13 :=1;
          IF v_dat_ini_p13 <= TO_DATE('01/01/2009','DD/MM/YYYY') THEN
              FATORP13 :=1;
           ELSE
              IF to_char(v_dat_ini_p13,'dd') > 15   THEN
                 FATORP13 :=  (12 - to_char(v_dat_ini_p13,'mm') ) /12  ;

               ELSE
                       FATORP13 :=  (12 - (to_char(v_dat_ini_p13 ,'mm')-1) ) /12 ;


              END IF;
           END IF;


        V_VAL_RUBRICA := ((nvl(V_VAL_RUBRICA_C,0) - nvl(V_VAL_RUBRICA_D,0)) * FATORP13)/2 ;

        SELECT DISTINCT max(SEQ_DETALHE)
                        INTO V_MAX_SEQ_DET
                        FROM TB_DET_CALCULADO D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
         IF nvl(V_seq_detalhe,0) <> 0 THEN
            V_MAX_SEQ_DET := V_seq_detalhe;
         ELSE
            V_MAX_SEQ_DET := V_MAX_SEQ_DET + 1;
         END IF;

       IF V_VAL_RUBRICA > 0  THEN

       -- (GRAVA NOVA RUBRICA NA TB_DET_CALCULADO)
        BEGIN
            INSERT /*+ append */
                  INTO TB_DET_CALCULADO ---> FFRANCO 03/2007
                  VALUES
                    (PAR_cod_ins,
                     PAR_TIP_PRO,
                     PAR_PER_PRO,
                     zsel.cod_ide_cli,
                     zsel.cod_beneficio,
                     i_seq_pag,
                     v_rubantecip13,
                     1,
                     trunc(V_VAL_RUBRICA, 2),
                     1,
                     'C',
                     0,
                     PAR_PER_PRO,
                     null,
                     null, --rdcn.cod_ide_cli_ben
                     null,
                     sysdate,
                     sysdate,
                     'FOLHA',
                     'FOLHA_POS',
                     nvl(V_MAX_SEQ_DET,0),
                     null,
                     null,
                     trunc(V_VAL_RUBRICA, 2),
                     0,
                     0,
                     0,
                     0,
                     null -- IR_ACUMULADO
                     );
                     commit;
        EXCEPTION
            WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao incluir o decimo terceiro';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha Pos',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                zsel.cod_ide_cli,
                                null);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            commit;
        END;

        -----------------------------------------------------------------------
        --GERA PREVIDENCIA DA ANTECIPAC?O DO 13o SE APOSENTADO
         BEGIN
          IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN

            SP_OBTEM_RUBRICA_EVENTO_ESPEC('O',
                                         v_cod_entidade,
                                         '',
                                         vi_rubrica_prev,
                                         vi_seq_vig);

            -- SOMA RUBRICAS - DEFINE VALOR A DEDUZIR
            SELECT DISTINCT sum(VAL_RUBRICA)
                        INTO V_VAL_RUBRICA_PREV_C
                        FROM TB_DET_CALCULADO D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.FLG_NATUREZA = 'C'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=v_rubantecip13
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = v_cod_variavel
                                       and cd.cod_entidade_composta=v_cod_entidade)
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=7005600
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = 'BASE_PREV'
                                       and cd.cod_entidade_composta=v_cod_entidade);

            SELECT DISTINCT sum(VAL_RUBRICA)
                        INTO V_VAL_RUBRICA_PREV_D
                        FROM TB_DET_CALCULADO D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = i_per_pro
                         AND D.FLG_NATUREZA = 'D'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=v_rubantecip13
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = v_cod_variavel
                                       and cd.cod_entidade_composta=v_cod_entidade)
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=7005600
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = 'BASE_PREV'
                                       and cd.cod_entidade_composta=v_cod_entidade);

            V_VAL_RUBRICA_PREV := (nvl(V_VAL_RUBRICA_PREV_C,0) - nvl(V_VAL_RUBRICA_PREV_D,0)) * FATORP13;

            --Verifica se possui Atributo de Incapacidade
            SP_OBTEM_TIPOS_ATRIBUTOS_prev(37,
                                        v_matricula,
                                        v_entidade,
                                        v_cargo,
                                        o_str);
            if o_str = 'S' then
               SP_OBTEM_PARVAL_FOLHA2('TASCO',
                                   2000,
                                   'DESC_CONTR',
                                   v_valor_incapacidade); --$3218,90
               if v_valor_incapacidade is null then
                  v_valor_incapacidade := 0;
               end if;
            else
               v_valor_incapacidade := 0;
            end if;
            ----------------------------------------------
            v_val_rubrica := (V_VAL_RUBRICA_PREV  - (v_DESC_PREV + v_VALOR_INCAPACIDADE )) * v_perc_prev;

            --vi_val_rubrica := (((valor_prev_tot * i_perc / 100) -
            --                   ((DESC_PREV + VALOR_INCAPACIDADE ) )))
            --                     * perc_prev * VI_FATOR_MES * VI_PERCENTUAL_RATEIO  ;
            --             valor_prev_calc := valor_prev_calc + vi_val_rubrica;
            --             v_base_prev(cod_benef)(1) := ((valor_prev_tot) * i_perc / 100);

            --valor_prev_calc := valor_prev_calc + vi_val_rubrica;
            --v_base_prev(cod_benef)(1) := ((valor_prev_tot) * i_perc / 100);

            IF v_val_rubrica >= 0 THEN
               SELECT DISTINCT max(SEQ_DETALHE)
                 INTO V_MAX_SEQ_DET
                 FROM TB_DET_CALCULADO D
                WHERE D.COD_INS = i_cod_ins
                  AND D.TIP_PROCESSO = i_tip_pro
                  AND D.PER_PROCESSO = i_per_pro
                  AND D.COD_IDE_CLI=zsel.cod_ide_cli
                  AND D.cod_beneficio=zsel.cod_beneficio;
                IF nvl(V_seq_detalhe,0) <> 0 THEN
                   V_MAX_SEQ_DET := V_seq_detalhe + 1;
                ELSE
                   V_MAX_SEQ_DET := V_MAX_SEQ_DET + 1;
                END IF;

                INSERT /*+ append */
                  INTO TB_DET_CALCULADO
                  VALUES
                    (PAR_cod_ins,
                     PAR_TIP_PRO,
                     PAR_PER_PRO,
                     zsel.cod_ide_cli,
                     zsel.cod_beneficio,
                     i_seq_pag,
                     vi_rubrica_prev,
                     1,
                     trunc(V_VAL_RUBRICA, 2),
                     1,
                     'D',
                     0,
                     PAR_PER_PRO,
                     null,
                     null,
                     null,
                     sysdate,
                     sysdate,
                     'FOLHA',
                     'FOLHA_POS',
                     nvl(V_MAX_SEQ_DET,0),
                     null,
                     null,
                     trunc(V_VAL_RUBRICA,2),
                     0,
                     0,
                     0,
                     0,
                     null -- IR_ACUMULADO
                     );
                     commit;

            END IF;
          END IF;

          EXCEPTION
            WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao criar Prev.Antecip 13o';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha Pos',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                zsel.cod_ide_cli,
                                null);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            commit;
          END;

       END IF;

     END LOOP;
   ELSE
   ------------------------------- SE RETROATIVO -------------------------------
     IF PAR_TIP_PRO = 'R' THEN
     -- SELECIONA O GRUPO DE BENEFICIARIOS A ATUALIZAR
     -- LACO LENDO E CALCULANDO PARA CADA UM A ANTECIPAC?O
     FOR zsel IN (SELECT DISTINCT D.COD_IDE_CLI, D.COD_BENEFICIO
                        FROM TB_RESULTADO_CALC_RET D, TB_PESSOA_FISICA P,TB_BENEFICIARIO B ,TB_CONTROLE_PROCESSAMENTO CP
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF  = PAR_PER_PRO
                         AND D.COD_IDE_CLI=P.COD_IDE_CLI
                         and B.Cod_Proc_Grp_Pag = v_cod_proc_grp_pag
                         and p.num_cpf = nvl(i_num_cpf, p.num_cpf )
                         and B.cod_beneficio=d.cod_beneficio and b.cod_ide_cli_ben=d.cod_ide_cli
                         AND to_number(to_char(P.DAT_NASC,'MM'))=to_number(to_char( i_per_pro,'MM'))+1
                         AND cp.seq_processamento=i_num_seq_proc
                         AND p.num_cpf>=cp.num_cpf_inicial and p.num_cpf<cp.num_cpf_final
                         ) loop

             conta:=conta+1;
     -- CARREGA VALOR NA VAR cod_benef com o codigo de beneficio atual
             cod_benef := zsel.cod_beneficio;

     -- PEGA COD_ENTIDADE E TIPO_BENEFICIO deste IDE_CLI
             select cb.cod_tipo_beneficio,cb.cod_entidade
                      into v_tipo_beneficio, v_cod_entidade
                      from tb_concessao_beneficio cb
                      where cb.cod_beneficio=cod_benef;

     -- (VERIFICAR SE JA RECEBEU ANTECIPAC?O ESTE ANO)
     -- IDENTIFICA VALOR DE COM_TIP_BENEFICIO PARA CADA UM LIDO NO LACO
        SP_OBTEM_TIPO_BENEFICIO(cod_benef);
     -- IDENTIFICA A RUBRICA A UTILIZAR (PENS?O OU APOSENTADO)
        IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
                          SP_OBTEM_RUBRICA_EVENTO_ESPEC('G',
                                                v_cod_entidade,
                                                'C',
                                                v_rubantecip13,
                                                vi_seq_vig);
                          v_cod_variavel:='BASE_DEC13_APOCIV';
        ELSE
                          SP_OBTEM_RUBRICA_EVENTO_ESPEC('D',
                                                v_cod_entidade,
                                                'C',
                                                v_rubantecip13,
                                                vi_seq_vig);
                          IF v_cod_entidade <> 5 THEN
                             v_cod_variavel:='BASE_DEC13_PENCIV';
                          ELSE
                             v_cod_variavel:='BASE_DEC13_PENMIL';
                          END IF;
        END IF;

     -- IDENTIFICA SEQUENCIA
     BEGIN
        v_seq_detalhe := 0 ;
        SELECT d.seq_detalhe
            INTO v_seq_detalhe
            FROM TB_RESULTADO_CALC_RET d
            where            d.cod_fcrubrica=v_rubantecip13
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio;

      -- APAGA RUBRICAS DE 13o NA TB_RESULTADO_CALC_RET e na TB_VALOR_NPAGO_RET
        DELETE tb_resultado_calc_ret d where d.cod_fcrubrica=v_rubantecip13
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.FLG_NATUREZA = 'C'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio;
        DELETE tb_valor_npago_ret d where d.cod_fcrubrica=v_rubantecip13
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.FLG_NATUREZA = 'C'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio;
        COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Aviso N?o localizada rubrica antecip.13o';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha Pos',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                zsel.cod_ide_cli,
                                null);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            v_seq_detalhe :=0;
            SELECT max(d.seq_detalhe)
              INTO v_seq_detalhe
              FROM TB_RESULTADO_CALC_RET d
              where          D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
        END;

     -- SOMA RUBRICAS PAGAS - DEFINE VALOR A PAGAR
        SELECT DISTINCT sum(VAL_RUBRICA)
                        INTO V_VAL_RUBRICA_C
                        FROM TB_RESULTADO_CALC_RET D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.FLG_NATUREZA = 'C'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=v_rubantecip13
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = v_cod_variavel
                                       and cd.cod_entidade_composta=v_cod_entidade);
        SELECT DISTINCT sum(VAL_RUBRICA)
                        INTO V_VAL_RUBRICA_D
                        FROM TB_RESULTADO_CALC_RET D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.FLG_NATUREZA = 'D'
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli and D.cod_beneficio=zsel.cod_beneficio
                         AND exists(select * from tb_compoe_det cd
                                     where cd.cod_fcrubrica_composta=v_rubantecip13
                                       and cd.cod_fcrubrica_compoe=d.cod_fcrubrica
                                       and cd.cod_variavel = v_cod_variavel
                                       and cd.cod_entidade_composta=v_cod_entidade);

     --Calcula Proporcionalidade inicial do adiantamento de 13o -ROD12 em:050809
        select cb.dat_concessao
          into v_dat_ini_p13
          from tb_concessao_beneficio cb
         where cod_beneficio = zsel.cod_beneficio and cb.cod_ins=PAR_COD_INS;
        if (v_dat_ini_p13 >= to_date('01/01/'||to_char( PAR_PER_PRO,'YYYY'),'dd/mm/yyyy')) then
          select par_per_pro - v_dat_ini_p13
            into v_qtddias_13prop
            from dual;
          FATORP13 := v_qtddias_13prop / (30 * 12);
        else
          FATORP13 := 0.5;
        end if;

        V_VAL_RUBRICA := (nvl(V_VAL_RUBRICA_C,0) - nvl(V_VAL_RUBRICA_D,0)) * FATORP13 ;

        SELECT DISTINCT max(SEQ_DETALHE)
                        INTO V_MAX_SEQ_DET
                        FROM TB_RESULTADO_CALC_RET D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
         IF nvl(V_seq_detalhe,0) <> 0 THEN
            V_MAX_SEQ_DET := V_seq_detalhe + 1;
         ELSE
            V_MAX_SEQ_DET := V_MAX_SEQ_DET + 1;
         END IF;

       --VERIFICA SE E O PRIMEIRO RECEBIMENTO SE SIM N?O GERA ADIANTAMENTO
    --   BEGIN
    --      select * from tb_folha f
    --       where f.cod_beneficio = zsel.cod_beneficio
    --         and f.cod_ide_cli   = zsel.cod_ide_cli
    --         and f.num_conta is not null
    --         and f.num_banco is not null;


    --   EXCEPTION
    --        WHEN OTHERS THEN

    --   END

       -- controle temporario para n?o gerar antecipac?o para novos .. continuar
       IF   v_cod_proc_grp_pag in ('05','07') THEN
          V_NOVO_BENEF := TRUE;
       ELSE
          V_NOVO_BENEF := FALSE;
       END IF;

       IF V_VAL_RUBRICA > 0  THEN
       -- (GRAVA NOVA RUBRICA NA TB_DET_CALCULADO)
        BEGIN

          IF V_NOVO_BENEF THEN
            INSERT /*+ append */
                  INTO TB_RESULTADO_CALC_RET ---> FFRANCO 03/2007
                  VALUES
                    (PAR_cod_ins,
                     PAR_TIP_PRO,
                     PAR_PER_REAL,
                     zsel.cod_ide_cli,
                     zsel.cod_beneficio,
                     i_seq_pag,
                     v_rubantecip13,
                     1,
                     trunc(V_VAL_RUBRICA, 2),
                     1,
                     'C',
                     0,
                     PAR_PER_PRO,
                     null,
                     null, --rdcn.cod_ide_cli_ben
                     null,
                     sysdate,
                     sysdate,
                     'FOLHA',
                     'FOLHA_POS',
                     nvl(V_MAX_SEQ_DET,0),
                     null,
                     null,
                     0,
                     0,
                     0,
                     trunc(V_VAL_RUBRICA, 2)
                     );
                     commit;
          END IF;
        EXCEPTION
            WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Erro ao incluir o decimo terceiro';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha Pos',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                zsel.cod_ide_cli,
                                null);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END;

        --Atualiza diferenca
     BEGIN
        v_seq_detalhe := 0 ;
        SELECT d.seq_detalhe
            INTO v_seq_detalhe
            FROM TB_VALOR_NPAGO_RET d
            where            D.cod_fcrubrica=v_rubantecip13
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;

      -- APAGA RUBRICAS DE 13o NA TB_RESULTADO_CALC_RET e na TB_VALOR_NPAGO_RET
        DELETE tb_valor_npago_ret d
                       WHERE trunc(d.cod_fcrubrica/100)=trunc(v_rubantecip13/100)
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
        COMMIT;
        EXCEPTION
            WHEN OTHERS THEN
            p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
            p_coderro       := SQLCODE;
            P_MSGERRO       := 'Aviso N?o localizada rubrica antecip.13o';
            INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha Pos',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                zsel.cod_ide_cli,
                                null);
            VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
            v_seq_detalhe :=0;
            SELECT max(d.seq_detalhe)
              INTO v_seq_detalhe
              FROM TB_VALOR_NPAGO_RET d
              where          D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
             DELETE tb_valor_npago_ret d
                       WHERE trunc(d.cod_fcrubrica/100)=trunc(v_rubantecip13/100)
                         AND D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.DAT_INI_REF = PAR_PER_PRO
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
             COMMIT;


        END;

        -- IDENTIFICA VALOR PAGO ORIGINAL
        SELECT sum(dd.val_rubrica)
          INTO v_soma_valantecip13
          FROM TB_DET_CALCULADO DD
          WHERE dd.cod_ins = PAR_COD_INS
            AND dd.tip_processo = 'N'
            AND dd.dat_ini_ref = PAR_PER_PRO
            AND dd.cod_fcrubrica = v_rubantecip13
            AND dd.COD_IDE_CLI=zsel.cod_ide_cli
            AND dd.cod_beneficio=zsel.cod_beneficio;

        V_VAL_RUBRICA := nvl(V_VAL_RUBRICA,0) - v_soma_valantecip13 ;
        IF V_VAL_RUBRICA < 0 THEN
           v_rubantecip13 := trunc(v_rubantecip13/100) || '50';
           V_VAL_RUBRICA := abs(V_VAL_RUBRICA);
           v_flag_natureza := 'D';
        ELSE
           v_rubantecip13 := trunc(v_rubantecip13/100) || '51';
           v_flag_natureza := 'C';
        END IF;

        SELECT DISTINCT max(SEQ_DETALHE)
                        INTO V_MAX_SEQ_DET
                        FROM TB_VALOR_NPAGO_RET D
                       WHERE D.COD_INS = i_cod_ins
                         AND D.TIP_PROCESSO = i_tip_pro
                         AND D.PER_PROCESSO = PAR_PER_REAL
                         AND D.COD_IDE_CLI=zsel.cod_ide_cli
                         AND D.cod_beneficio=zsel.cod_beneficio;
         IF nvl(V_seq_detalhe,0) <> 0 THEN
            V_MAX_SEQ_DET := V_seq_detalhe + 1;
         ELSE
            V_MAX_SEQ_DET := V_MAX_SEQ_DET + 1;
         END IF;

         IF V_VAL_RUBRICA > 0 AND NOT V_NOVO_BENEF THEN
            BEGIN
                INSERT /*+ append */
                      INTO TB_VALOR_NPAGO_RET
                      VALUES
                        (PAR_cod_ins,
                         PAR_TIP_PRO,
                         PAR_PER_REAL,
                         zsel.cod_ide_cli,
                         zsel.cod_beneficio,
                         i_seq_pag,
                         v_rubantecip13,
                         1,
                         trunc(V_VAL_RUBRICA, 2),
                         1,
                         v_flag_natureza,
                         0,
                         PAR_PER_PRO,
                         null,
                         null, --rdcn.cod_ide_cli_ben
                         null,
                         sysdate,
                         sysdate,
                         'FOLHA',
                         'FOLHA_POS',
                         nvl(V_MAX_SEQ_DET,0),
                         null,
                         'Ret.',
                         'S',
                         'S',
                         trunc(V_VAL_RUBRICA, 2)
                         );
                         commit;
            EXCEPTION
                WHEN OTHERS THEN
                p_sub_proc_erro := 'SP_ATUALIZA_DECIMOTERC';
                p_coderro       := SQLCODE;
                P_MSGERRO       := 'Erro ao incluir o 13o RETROAT';
                INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                    p_coderro,
                                    'Calcula Folha Pos',
                                    sysdate,
                                    p_msgerro,
                                    p_sub_proc_erro,
                                    zsel.cod_ide_cli,
                                    null);
                VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
                commit;
            END;
         END IF;

       END IF;
     END LOOP;
    END IF;
   END IF;

  END SP_ATUALIZA_DECIMOTERC;
  --------------------------------------------------------------------------------------
  PROCEDURE SP_ATUALIZA_PENSAOALIMENTICIA(
                                   i_cod_ins                in number,
                                   i_per_pro                in date, -- Periodo a processar
                                   i_cod_usu                in varchar2,
                                   i_tip_pro                in varchar2, -- TIPO DE PROCESSO: N (normal), S (Suplementar), T (13 Salario)
                                   i_par_per_real           in date,
                                   i_des_tipos_benef        in varchar2,
                                   i_cod_tipo_ben           in varchar2,
                                   i_num_processo           in number, --ROD6 :: Indica o grupo a ser processado
                                   i_num_grp                in number, --ROD7 :: numero do grupo de pagamento a processar
                                   i_seq_pag                in number,
                                   i_num_cpf                in varchar2,
                                   i_num_seq_proc           in number,
                                   i_flg_retorno            out varchar2) AS
      --DECLARAC?O DE VARIAVEIS
      v_nom_serv              TB_PESSOA_FISICA.NOM_PESSOA_FISICA%TYPE;
      v_cod_ide_serv          TB_PESSOA_FISICA.COD_IDE_CLI%TYPE;
      v_nom_ben               TB_PESSOA_FISICA.NOM_PESSOA_FISICA%TYPE;
      v_cod_ide_ben           TB_PESSOA_FISICA.COD_IDE_CLI%TYPE;
      v_cod_proc_grp_pag      char(2);
      v_rubrica               number := 0 ;
      cod_benef               number := 0;
      vi_seq_vig              number;
      conta                   number := 0;
      v_tipo_beneficio        varchar2(1);
      v_cod_entidade          number(8);
      v_val_rubrica           number(18,4);
      v_val_rubrica_c         number(18,4);
      v_val_rubrica_d         number(18,4);
      v_val_rubrica_AGRUPADA  number(18,4);
      v_conta_ok              number(18) :=0;
      v_conta_nok             number(18) :=0;
      v_soma1                 number(18,4) :=0;
      v_soma2                 number(18,4) :=0;
      v_max_seq_det           number :=0;
      DAT_INICIO_BENEFICIO    date;
      v_dat_ini_p13           date;
      v_qtddias_13prop        number := 0;
      FATORP13                number(18, 4) := 0;
      v_seq_detalhe           number :=0;
      v_cod_variavel          varchar2(20);
      v_soma_valantecip13     number(18, 4) := 0;
      v_flag_natureza         char(1);
      v_rubrica_contraria     number;
      v_val_tot_cred          number(18, 4) := 0;
      v_val_tot_deb           number(18, 4) := 0;
      v_conta_ben             number;
      v_num_cpf               varchar2(11);
      v_num_cpf_serv          varchar2(11);

      BEGIN
      PAR_COD_INS := i_cod_ins;
      PAR_PER_PRO := i_per_pro;
      PAR_TIP_PRO := i_tip_pro;

      -- IDENTIFICA O GRUPO DE PAGAMENTO
       select cod_proc_grp_pago into v_cod_proc_grp_pag
             from tb_grupo_pagamento where num_grp_pag= i_num_grp;

      -------------------------------- FOLHA NORMAL
      IF PAR_TIP_PRO = 'N' THEN
         -- SELECIONA O GRUPO DE BENEFICIARIOS A ATUALIZAR
         -- LACO LENDO E CALCULANDO PARA CADA UM A ANTECIPAC?O

        FOR zsel IN (SELECT DISTINCT D.COD_IDE_CLI, D.COD_BENEFICIO, D.COD_IDE_CLI_BEN
                            FROM TB_DET_CALCULADO D, TB_PESSOA_FISICA P,TB_BENEFICIARIO B, TB_CONTROLE_PROCESSAMENTO CP
                           WHERE D.COD_INS = i_cod_ins
                             AND D.TIP_PROCESSO = i_tip_pro
                             AND D.PER_PROCESSO = i_per_pro
                             AND D.COD_IDE_CLI=P.COD_IDE_CLI
                             and B.Cod_Proc_Grp_Pag = v_cod_proc_grp_pag
                             and p.num_cpf = nvl(i_num_cpf, p.num_cpf )
                             and B.cod_beneficio=d.cod_beneficio and
                             b.cod_ide_cli_ben=d.cod_ide_cli
                             AND trunc(D.cod_fcrubrica/100) = 78001 --trunc(v_rubrica/100)
                             AND cp.seq_processamento=i_num_seq_proc
                             AND p.num_cpf>=cp.num_cpf_inicial and p.num_cpf<cp.num_cpf_final
                             ) loop

                 conta:=conta+1;
         -- CARREGA VALOR NA VAR cod_benef com o codigo de beneficio atual
          cod_benef := zsel.cod_beneficio;

         -- PEGA COD_ENTIDADE E TIPO_BENEFICIO deste IDE_CLI
         select cb.cod_tipo_beneficio,cb.cod_entidade
                into  v_tipo_beneficio, v_cod_entidade
                from  tb_concessao_beneficio cb
                where cb.cod_beneficio=cod_benef;

         -- OBTEM RUBRICA DE PA
         SP_OBTEM_RUBRICA_EVENTO_ESPEC('P',
                                     v_cod_entidade,
                                     'C',
                                     v_rubrica,
                                     vi_seq_vig);


         -- (VERIFICAR SE JA RECEBEU ANTECIPAC?O ESTE ANO)
         -- IDENTIFICA VALOR DE COM_TIP_BENEFICIO PARA CADA UM LIDO NO LACO
          SP_OBTEM_TIPO_BENEFICIO(cod_benef);

          -- LIMPA TABELAS
          DELETE TB_DET_CALCULADO_PA dpa
                   WHERE dpa.cod_ins        = i_cod_ins
                     AND Dpa.TIP_PROCESSO   = i_tip_pro
                     AND Dpa.PER_PROCESSO   = i_per_pro
                     AND Dpa.COD_IDE_CLI    =zsel.COD_IDE_CLI
                     AND DPA.COD_IDE_CLI_BEN=zsel.cod_ide_cli_ben
                     AND Dpa.COD_BENEFICIO  =zsel.cod_beneficio ;
          DELETE TB_FOLHA_PA dpa
                   WHERE dpa.cod_ins        = i_cod_ins
                     AND Dpa.TIP_PROCESSO   = i_tip_pro
                     AND Dpa.PER_PROCESSO   = i_per_pro
                     AND Dpa.COD_IDE_CLI    =zsel.COD_IDE_CLI
                     AND DPA.COD_IDE_CLI_BEN=zsel.cod_ide_cli_ben
                     AND Dpa.COD_BENEFICIO  =zsel.cod_beneficio ;
          COMMIT;

             v_val_tot_cred := 0;
             v_val_tot_deb  := 0;
             v_conta_ben := 0;
             v_conta_ben := v_conta_ben + 1;
             FOR y IN ( SELECT df.cod_fcrubrica,df.val_rubrica,df.val_rubrica_cheio,
                                 df.flg_natureza,df.dat_ini_ref,df.dat_fim_ref,df.cod_ide_cli_ben
                            FROM  TB_DET_CALCULADO Df
                            WHERE Df.COD_INS = i_cod_ins
                                AND Df.TIP_PROCESSO = i_tip_pro
                                AND Df.PER_PROCESSO = i_per_pro
                                AND Df.COD_IDE_CLI=zsel.COD_IDE_CLI
                                AND Df.COD_BENEFICIO=zsel.cod_beneficio
                                AND zsel.COD_IDE_CLI_BEN = df.cod_ide_cli_ben
                                AND trunc(Df.COD_FCRUBRICA/100)= trunc(v_rubrica/100)
                                ) loop

                   SELECT RU.COD_RUBRICA_CONTRARIA
                            INTO v_rubrica_contraria
                            FROM TB_RUBRICAS RU
                            WHERE RU.COD_RUBRICA = y.COD_FCRUBRICA
                              AND RU.Cod_Entidade = v_cod_entidade
                              AND (RU.DAT_FIM_VIG IS NULL
                                   OR (RU.DAT_FIM_VIG >= i_per_pro AND RU.DAT_FIM_VIG < i_per_pro));

               BEGIN
                   INSERT
                         INTO TB_DET_CALCULADO_PA PA
                         (COD_INS, TIP_PROCESSO, PER_PROCESSO, COD_IDE_CLI, COD_BENEFICIO,SEQ_PAGAMENTO,
                          COD_FCRUBRICA,  SEQ_VIG,  VAL_RUBRICA,  NUM_QUOTA,  FLG_NATUREZA,  TOT_QUOTA,
                          DAT_INI_REF, DAT_FIM_REF, COD_IDE_CLI_BEN, NUM_ORD_JUD, DAT_ING, DAT_ULT_ATU,
                          NOM_USU_ULT_ATU, NOM_PRO_ULT_ATU,  SEQ_DETALHE,  DES_INFORMACAO, DES_COMPLEMENTO)
                         VALUES
                           (PAR_cod_ins,
                            PAR_TIP_PRO,
                            PAR_PER_REAL,
                            zsel.cod_ide_cli,
                            zsel.cod_beneficio,
                            i_seq_pag,
                            nvl(v_rubrica_contraria,y.cod_fcrubrica),
                            1,
                            trunc(y.VAL_RUBRICA, 2),
                            1,
                            'C',
                            0,
                            PAR_PER_PRO,
                            null,
                            zsel.cod_ide_cli_ben, --rdcn.cod_ide_cli_ben
                            '10',
                            sysdate,
                            sysdate,
                            'FOLHA_POS',
                            'FOLHA_POS',
                            nvl(v_conta_ben,0),
                            null,
                            null
                            );
                            commit;
               EXCEPTION
                   WHEN OTHERS THEN
                   p_sub_proc_erro := 'SP_ATUALIZA_PENSAOALIMENTICIA';
                   p_coderro       := SQLCODE;
                   P_MSGERRO       := 'Erro ao incluir o DET_CALCULADO_PA';
                   INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                       p_coderro,
                                       'Calcula Folha Pos',
                                       sysdate,
                                       p_msgerro,
                                       p_sub_proc_erro,
                                       zsel.cod_ide_cli,
                                       null);
                   VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
               END;

                  v_val_tot_cred := v_val_tot_cred + trunc(y.VAL_RUBRICA, 2);
                  v_val_tot_deb := 0;

             END LOOP; -- y

             select p.nom_pessoa_fisica,p.cod_ide_cli, p.num_cpf
                    into v_nom_serv, v_cod_ide_serv, v_num_cpf_serv
                    from tb_concessao_beneficio cb, tb_pessoa_fisica p
                    where cb.cod_beneficio=zsel.cod_beneficio
                    and p.cod_ide_cli=cb.cod_ide_cli_serv
                    and rownum =1;

             select p.nom_pessoa_fisica, p.cod_ide_cli, p.num_cpf
                    into v_nom_ben, v_cod_ide_ben, v_num_cpf
                    from tb_pessoa_fisica p
                    where p.cod_ide_cli=zsel.cod_ide_cli_ben
                    and rownum =1;

          --SP_OBTEM_DADOS_PF(IDE_CLI, 'S', rfol.cod_ide_serv, v_nom_serv);
          --SP_OBTEM_DADOS_PF(IDE_CLI, 'B', zsel.cod_ide_ben, v_nom_ben);
          --SP_OBTEM_DADOS_PF(IDE_CLI, 'T', rfol.cod_ide_tut, v_nom_tut);

          BEGIN
              INSERT
                    INTO TB_FOLHA_PA PA
                    (COD_INS, TIP_PROCESSO, PER_PROCESSO, SEQ_PAGAMENTO, COD_IDE_CLI, COD_BENEFICIO,
                     NUM_GRP, NUM_SEQ_BENEF, COD_IDE_CLI_BEN, COD_IDE_SERV, NOM_SERV, COD_IDE_BEN,
                     NOM_BEN, COD_IDE_TUT, NOM_TUT, DAT_PROCESSO,VAL_SAL_BASE,TOT_CRED,TOT_DEB,VAL_LIQUIDO,
                     VAL_BASE_IR, VAL_IR_RET, DED_BASE_IR,DED_IR_OJ, DED_IR_DOENCA, DED_IR_PA, FLG_PAG,
                     FLG_IND_PAGO, FLG_IND_ULTIMO_PAG, TOT_CRED_PAG, TOT_DEB_PAG, VAL_LIQUIDO_PAG,
                     VAL_BASE_IR_PAG, VAL_IR_RET_PAG, VAL_BASE_IR_13, VAL_IR_13_RET, VAL_BASE_IR_13_PAG,
                     VAL_BASE_IR_13_RET_PAG,VAL_BASE_ISENCAO,IND_PROCESSO,COD_BANCO,NUM_AGENCIA,
                     NUM_DV_AGENCIA,NUM_CONTA,NUM_DV_CONTA,COD_TIPO_CONTA,VAL_BASE_PREV,FLG_IND_CHEQ,
                     FLG_IND_ANALISE,MARGEN_CONSIG)
                    VALUES
                      (PAR_cod_ins,
                       PAR_TIP_PRO,
                       PAR_PER_REAL,
                       i_seq_pag,
                       zsel.cod_ide_cli,
                       zsel.cod_beneficio,
                       to_number(v_cod_proc_grp_pag),
                       v_conta_ben,
                       zsel.cod_ide_cli_ben,
                       v_num_cpf_serv,
                       v_nom_serv,
                       v_num_cpf,
                       v_nom_ben,
                       null,
                       null,
                       PAR_PER_PRO,
                       null,  --val_sal_base
                       v_val_tot_cred,
                       v_val_tot_deb,
                       v_val_tot_cred-v_val_tot_deb,
                       null,
                       null,
                       null,
                       null,
                       null,
                       null,
                       'S', -- flag_PAG
                       'N',
                       'N',
                       0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                       'S', -- ind_processo
                       null,null,null,null,null,null,
                       0,
                       'R',
                       'R',
                       null);
                       commit;
          EXCEPTION
              WHEN OTHERS THEN
              p_sub_proc_erro := 'SP_ATUALIZA_PENSAOALIMENTICIA';
              p_coderro       := SQLCODE;
              P_MSGERRO       := 'Erro ao incluir o DET_CALCULADO_PA';
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha Pos',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  zsel.cod_ide_cli,
                                  null);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              commit;
          END;
        END LOOP;
      END IF;
  END SP_ATUALIZA_PENSAOALIMENTICIA;
------------------------------------------------------------------------------------------------------
  PROCEDURE SP_ATUALIZA_TOTAIS_FOLHA(
                                   i_cod_ins                in number,
                                   i_per_pro                in date,     -- Periodo a processar
                                   i_cod_usu                in varchar2,
                                   i_tip_pro                in varchar2, -- TIPO DE PROCESSO: N (normal), S (Suplementar), T (13 Salario)
                                   i_par_per_real           in date,
                                   i_des_tipos_benef        in varchar2,
                                   i_cod_tipo_ben           in varchar2,
                                   i_num_processo           in number,   --ROD6 :: Indica o grupo a ser processado
                                   i_num_grp                in number,   --ROD7 :: numero do grupo de pagamento a processar
                                   i_seq_pag                in number,
                                   i_num_cpf                in varchar2,
                                   i_num_seq_proc           in number,
                                   i_flg_retorno            out varchar2) AS

      v_cod_beneficio         TB_BENEFICIARIO.COD_BENEFICIO%TYPE;
      v_cod_ide_cli           TB_BENEFICIARIO.COD_IDE_CLI_BEN%TYPE;
      v_per_processo          date;
      v_vlr_cred              number(18,4);
      v_vlr_deb               number(18,4);
      v_vlr_liq               number(18,4);
      v_cod_proc_grp_pag      char(2);
      v_tipo_beneficio        TB_CONCESSAO_BENEFICIO.COD_TIPO_BENEFICIO%TYPE;
      v_cod_entidade          TB_CONCESSAO_BENEFICIO.COD_ENTIDADE%TYPE;

   BEGIN

     -- IDENTIFICA O GRUPO DE PAGAMENTO
     select cod_proc_grp_pago into v_cod_proc_grp_pag
             from tb_grupo_pagamento where num_grp_pag= i_num_grp;

     FOR zsel IN (SELECT DISTINCT D.COD_IDE_CLI, D.COD_BENEFICIO
                    FROM TB_DET_CALCULADO D, TB_PESSOA_FISICA P,TB_BENEFICIARIO B , TB_CONTROLE_PROCESSAMENTO CP
                   WHERE D.COD_INS = i_cod_ins
                     AND D.TIP_PROCESSO = i_tip_pro
                     AND D.PER_PROCESSO = i_per_pro
                     AND D.COD_IDE_CLI=P.COD_IDE_CLI
                     and B.Cod_Proc_Grp_Pag = v_cod_proc_grp_pag
                     and p.num_cpf = nvl(i_num_cpf, p.num_cpf )
                     and B.cod_beneficio=d.cod_beneficio and b.cod_ide_cli_ben=d.cod_ide_cli
                     AND cp.seq_processamento=i_num_seq_proc
                     AND p.num_cpf>=cp.num_cpf_inicial and p.num_cpf<cp.num_cpf_final
                     ) loop

        BEGIN

         v_cod_ide_cli   := zsel.cod_ide_cli;
         v_cod_beneficio := zsel.cod_beneficio;

         -- PEGA COD_ENTIDADE E TIPO_BENEFICIO deste IDE_CLI
         select cb.cod_tipo_beneficio,cb.cod_entidade
                into  v_tipo_beneficio, v_cod_entidade
                from  tb_concessao_beneficio cb
                where cb.cod_beneficio=v_cod_beneficio
                and   rownum = 1;

         IF i_tip_pro in('N','S') THEN
           IF v_tipo_beneficio = 'M' THEN
             IF v_cod_entidade <> '05' THEN
              SELECT DISTINCT
                  cod_beneficio,
                  cod_ide_cli,
                  per_processo,
                  sum(decode(flg_natureza,'C',val_rubrica,0)) valor_credito,
                  sum(decode(flg_natureza,'D',val_rubrica,0)) valor_debito,
                  sum(decode(flg_natureza,'C',val_rubrica,0)) - sum(decode(flg_natureza,'D',val_rubrica,0)) valor_liquido
                  into v_cod_beneficio, v_cod_ide_cli, v_per_processo, v_vlr_cred, v_vlr_deb, v_vlr_liq
               from tb_det_calculado ff
               where ff.cod_ins    = i_cod_ins
               and ff.cod_ide_cli= zsel.cod_ide_cli and ff.cod_beneficio = zsel.cod_beneficio
               and ff.per_processo = i_per_pro
               and ff.tip_processo = i_tip_pro
               and ff.seq_pagamento = 1
               and exists (select 1 from tb_impresao_rub  ir
                       where ir.cod_rubrica  = ff.cod_fcrubrica
                         and ir.cod_entidade = 1
                         and ir.flg_imprime  = 'S')
           --    and ff.cod_fcrubrica not in (6507400, 6507451, 6510600, 6510651, 602400, 1860751, 1863003,7001203)--, 1863003,7060303,7000603,7001203)
               and exists (select 1 from tb_beneficiario bb
                      where bb.cod_ins         = ff.cod_ins
                      and bb.cod_beneficio     = ff.cod_beneficio
                      and bb.cod_ide_cli_ben   = ff.cod_ide_cli
                      and bb.flg_status in ('A', 'X'))
               AND EXISTS (SELECT 1 FROM TB_CONCESSAO_BENEFICIO CB  WHERE FF.COD_BENEFICIO = CB.COD_BENEFICIO
                            AND CB.COD_TIPO_BENEFICIO = 'M')
               group by cod_beneficio, cod_ide_cli, per_processo;
             ELSE
               select DISTINCT
                   cod_beneficio,
                   cod_ide_cli,
                   per_processo,
                   sum(decode(flg_natureza,'C',val_rubrica,0)) valor_credito,
                   sum(decode(flg_natureza,'D',val_rubrica,0)) valor_debito,
                   sum(decode(flg_natureza,'C',val_rubrica,0)) - sum(decode(flg_natureza,'D',val_rubrica,0)) valor_liquido
                  into v_cod_beneficio, v_cod_ide_cli, v_per_processo, v_vlr_cred, v_vlr_deb, v_vlr_liq
                from tb_det_calculado ff
                where cod_ins    = i_cod_ins
                   and ff.cod_ide_cli= zsel.cod_ide_cli and ff.cod_beneficio = zsel.cod_beneficio
                   and ff.per_processo = i_per_pro
                   and tip_processo = i_tip_pro
          --         and cod_fcrubrica not in (6500102,6500150, 6500202,6500302, 6500402, 6500502, 1860100, 1861151, 1861150, 1861102)
                   and exists (select 1 from tb_impresao_rub  ir
                               where ir.cod_rubrica  = ff.cod_fcrubrica
                                 and ir.cod_entidade = 5
                                 and ir.flg_imprime  in ('A','S'))
                   and exists (select 1 from tb_beneficiario bb
                               where bb.cod_ins         = ff.cod_ins
                                 and bb.cod_beneficio     = ff.cod_beneficio
                                 and bb.cod_ide_cli_ben   = ff.cod_ide_cli
                                 --and bb.cod_proc_grp_pag in ('03', '07')
                                 and bb.flg_status in ('A', 'X'))
                   group by cod_beneficio, cod_ide_cli, per_processo;
             END IF;
           ELSE
             IF i_cod_tipo_ben = 'G' THEN
               select DISTINCT
                   cod_beneficio,
                   cod_ide_cli,
                   per_processo,
                   sum(decode(flg_natureza,'C',val_rubrica,0)) valor_credito,
                   sum(decode(flg_natureza,'D',val_rubrica,0)) valor_debito,
                   sum(decode(flg_natureza,'C',val_rubrica,0)) - sum(decode(flg_natureza,'D',val_rubrica,0)) valor_liquido
                  into v_cod_beneficio, v_cod_ide_cli, v_per_processo, v_vlr_cred, v_vlr_deb, v_vlr_liq
                from tb_det_calculado ff
                where cod_ins    = 1
                   and ff.cod_ide_cli= zsel.cod_ide_cli and ff.cod_beneficio = zsel.cod_beneficio
                   and ff.per_processo = i_per_pro
                   and tip_processo = i_tip_pro
             --      and cod_fcrubrica not in (6500102,6500150, 6500202,6500302, 6500402, 6500502, 1860100, 1861151, 1861150, 1861102)
                   and exists (select 1 from tb_beneficiario bb
                               where bb.cod_ins         = ff.cod_ins
                                 and bb.cod_beneficio     = ff.cod_beneficio
                                 and bb.cod_ide_cli_ben   = ff.cod_ide_cli
                                 and bb.flg_status in ('A', 'X'))
                   group by cod_beneficio, cod_ide_cli, per_processo;

             END IF;
           END IF;
         END IF;

         UPDATE TB_FOLHA F SET F.TOT_CRED     = v_vlr_cred,
                               F.TOT_DEB      = v_vlr_deb,
                               F.VAL_LIQUIDO  = v_vlr_liq
                       WHERE F.COD_INS       = i_cod_ins
                         AND F.TIP_PROCESSO  = i_tip_pro
                         AND F.PER_PROCESSO  = i_per_pro
                         AND F.COD_BENEFICIO = zsel.cod_beneficio
                         AND F.COD_IDE_CLI   = zsel.cod_ide_cli;
         COMMIT;
       EXCEPTION
              WHEN OTHERS THEN
              p_sub_proc_erro := 'SP_ATUALIZA_TOTAIS_FOLHA';
              p_coderro       := SQLCODE;
              P_MSGERRO       := 'Erro ao incluir o DET_CALCULADO';
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'Calcula Folha Pos',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  v_cod_ide_cli,
                                  null);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
              commit;
       END;

     END LOOP;

  END SP_ATUALIZA_TOTAIS_FOLHA;

  FUNCTION  SP_VALOR_PORCENTUAL13(

                       I_COD_BENEFICIO VARCHAR2
                       ) Return number IS
  por_13   number(18,10) :=0;
  I_DAT_INI_REF   DATE;
  BEGIN
      I_DAT_INI_REF :=NULL;
      FOR indice_i IN 1 .. T_BENEFICIARIO.count LOOP
        R_BENEFICIARIO:=T_BENEFICIARIO(indice_i);
        IF R_BENEFICIARIO.COD_BENEFICIO=I_COD_BENEFICIO THEN
           I_DAT_INI_REF :=R_BENEFICIARIO.DAT_INI_BEN;
        END IF;
      END LOOP;
      por_13:=1;
      IF TO_CHAR(I_DAT_INI_REF,'YYYY') != TO_CHAR(PAR_PER_PRO,'YYYY') THEN
            return(1);
      ELSE
         IF TO_CHAR(PAR_PER_PRO,'MM') !='12' THEN
            IF to_char(I_DAT_INI_REF  ,'dd') > 15   THEN
                por_13:=  (12 - to_char(I_DAT_INI_REF,'mm') ) /12  ;

             ELSE
                     por_13:=  (12 - (to_char(I_DAT_INI_REF ,'mm')-1) ) /12 ;
            END IF;
         ELSE
            return(1);
         END IF;
       END IF;

  RETURN (por_13);

  END SP_VALOR_PORCENTUAL13;
------------------------------------------------------------------------------------------------------
  PROCEDURE SP_GRAVA_FOLHA_PARAM(ind in number) AS

      v_ini_ben               date;
      v_fim_ben               date;
      v_flg_status            char(1);
      v_val_perc              number(8,5) :=0;

     BEGIN
       BEGIN
         IF PAR_TIP_PRO = 'N' THEN
           IF ind = 1 THEN
              INSERT INTO TB_FOLHA_PARAM
              (cod_ins,tip_processo,per_processo,seq_pagamento,cod_ide_cli,cod_beneficio,
               cod_proc_grp_pag,num_seq_benef,cod_ide_cli_ben,dta_nasc,dta_ini_ben,dta_fim_ben,
               flg_status_ben,val_percentual_ben,perc_rateio,perc_saida,perc_beneficio,
               qtd_dependentes,perc_pecunia,flg_composicao,cod_entidade,cod_cargo,cod_referencia,
               cod_jornada,cod_tipo_beneficio,tot_cred,tot_deb,proc_erros,vlr_externo,desc_prev,
               vlr_incapacidade,fator_mes,vlr_base_redut,cod_poder,par_per_real,flg_rubrica_excl,
               data_obito, base_teto, redutor_ir, perc_ir,qtd_dep_ir, DTA_ING
               ) VALUES (
               PAR_COD_INS, PAR_TIP_PRO, PAR_PER_PRO, 1,BEN_IDE_CLI,COM_COD_BENEFICIO,
               PAR_NUM_GRP_PAG,null,null,BEN_DTA_NASC,null,null,
               BEN_FLG_STATUS,null,null,null,null,
               null,null,null,null,null,null,
               null,null,null,null,null,null,null,
               null,null,null,null,PAR_PER_REAL,null,
               null,null,null,null,null,sysdate
               );
               commit;
               select b.dat_ini_ben, b.dat_fim_ben, b.flg_status, b.val_percentual
                into v_ini_ben, v_fim_ben, v_flg_status, v_val_perc
                from tb_beneficiario b
                where b.cod_beneficio = COM_COD_BENEFICIO and
                      b.cod_ide_cli_ben = BEN_IDE_CLI and
                      (b.dat_fim_ben is null or b.dat_fim_ben>=PAR_PER_PRO);

               UPDATE TB_FOLHA_PARAM F SET f.dta_ini_ben=v_ini_ben,
                                           f.dta_fim_ben=v_fim_ben,
                                           f.flg_status_ben=v_flg_status,
                                           f.perc_beneficio=v_val_perc,
                                           f.val_percentual_ben=v_val_perc
                WHERE f.cod_beneficio=COM_COD_BENEFICIO and f.cod_ide_cli=BEN_IDE_CLI
                  AND f.cod_ins=PAR_COD_INS and f.tip_processo=PAR_TIP_PRO
                  AND f.per_processo=PAR_PER_PRO;
                commit;
           END IF;
         END IF;
       EXCEPTION
              WHEN OTHERS THEN
              p_sub_proc_erro := 'SP_GRAVA_FOLHA_PARAM';
              p_coderro       := SQLCODE;
              P_MSGERRO       := 'Erro ao gravar TB_FOLHA_PARAM';
              INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                  p_coderro,
                                  'PARAM FOLHA',
                                  sysdate,
                                  p_msgerro,
                                  p_sub_proc_erro,
                                  BEN_IDE_CLI,
                                  null);
              VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
       END;

  END SP_GRAVA_FOLHA_PARAM;


    PROCEDURE SP_OBTEM_DEDUCOES_BASICAS(ide_cli in varchar2, deducao_ir out number) AS
    VI_VAL_PAGOS   NUMBER(18, 4) := 0;
    VI_ISENTO      boolean := TRUE;
    nEdad          number;
    nIni           number;
    nFin           number;
    vi_rubrica     number := 0;
    vi_val_rubrica number := 0;
    vi_seq_vig     number := 0;

  BEGIN

    --- Obtem valores deduc?es
    -- Enfermidade grave
    -- judicial (isenc?o)
    IF sp_isenta_irrf(ide_cli) <> VI_ISENTO THEN
      -- Maior 65
      deducao_ir := 0;
      nFin       := to_char(ANT_DTA_NASC, 'yyyymmdd');
      nIni       := to_char(PAR_PER_PRO, 'yyyymmdd');
      nEdad      := (nIni - nFin) / 10000;
      IF nEdad >= 65 THEN
        deducao_ir := V_DED_IR_65;
      END IF;

      -- Dependentes
      VI_NUM_DEP_ECO := 0;
      IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
        VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(ide_cli, 'A');
      ELSE
        VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(ide_cli, 'P');
      END IF;

      IF VI_NUM_DEP_ECO > 0 THEN
        deducao_ir := nvl(deducao_ir, 0) + (V_DED_IR_DEP * VI_NUM_DEP_ECO);
      END IF;


    else
      deducao_ir := 0;
    end if;

    select nvl(deducao_ir, 0) into deducao_ir from dual;

  END SP_OBTEM_DEDUCOES_BASICAS;

-------------------------------------------------------------
  PROCEDURE SP_VERIFICA_TOTAIS IS

  LCOMPOE_CUR     curform;
  cod_rubrica_tot number;
  cod_entidade_tot number;
  qtd_rubrucas     number(3);
  jind             number(3);
  TOTAL_CREDITO    NUMBER(10,2);
  TOTAL_DEBITOS    NUMBER(10,2);
 BEGIN

  /*   --- ALT JTS25
    LCOMPOE_DET       TB_COMPOE_DET%ROWTYPE;           --- Linha de Tipo Compoe DET
    type COMPOE_DET is table of TB_COMPOE_DET%ROWTYPE; --- TABELA EM MEMRIA DE TIPO TB_COMPOE_DET
    vCOMPOE_DET        COMPOE_DET :=COMPOE_DET();
    idx_COMPOE_DET     number(3);
  */

 ------------ Calcula Creditos -------
    Open  LCOMPOE_CUR for

         SELECT cd.cod_fcrubrica_compoe,
                cd.cod_entidade_composta
        FROM tb_compoe_det cd
       WHERE cd.cod_ins = 1
         AND cd.cod_fcrubrica_composta = 99700
         AND cd.cod_variavel = 'TOT_CRED'
         AND cd.cod_entidade_composta = 1
         AND (PAR_PER_PRO >= cd.dat_ini_vig AND
             PAR_PER_PRO <=
             nvl(cd.dat_fim_vig, to_date('01/01/2045', 'dd/mm/yyyy')));

    FETCH LCOMPOE_CUR
      into cod_rubrica_tot,cod_entidade_tot ;
    WHILE LCOMPOE_CUR%FOUND LOOP
          vCOMPOE_DET.extend;
          idx_COMPOE_DET := nvl( idx_COMPOE_DET , 0) + 1;
          LCOMPOE_DET.COD_FCRUBRICA_COMPOE:=cod_rubrica_tot;
          LCOMPOE_DET.COD_ENTIDADE_COMPOSTA:=cod_entidade_tot;
          vCOMPOE_DET (idx_COMPOE_DET) := LCOMPOE_DET ;

         FETCH LCOMPOE_CUR
         into cod_rubrica_tot,cod_entidade_tot ;

    END LOOP;

   FOR jind in 1 .. tdcn.count LOOP
    rdcn := tdcn(jind);

      qtd_rubrucas   :=vCOMPOE_DET.count;
       FOR I IN 1..qtd_rubrucas LOOP
            LCOMPOE_DET:= vCOMPOE_DET(I);
            IF LCOMPOE_DET.COD_FCRUBRICA_COMPOE=RDCN.COD_FCRUBRICA  AND
               RDCN.FLG_NATUREZA='C' THEN
             TOTAL_CREDITO:=NVL(TOTAL_CREDITO,0)+RDCN.VAL_RUBRICA;

            END IF;

       END LOOP;
   END LOOP;

 ------------ Calcula Debitos -------

   Open  LCOMPOE_CUR for

         SELECT cd.cod_fcrubrica_compoe,
                cd.cod_entidade_composta
        FROM tb_compoe_det cd
       WHERE cd.cod_ins = 1
         AND cd.cod_fcrubrica_composta = 99800
         AND cd.cod_variavel = 'TOT_DEBIT'
         AND cd.cod_entidade_composta = 1
         AND (PAR_PER_PRO >= cd.dat_ini_vig AND
             PAR_PER_PRO <=
             nvl(cd.dat_fim_vig, to_date('01/01/2045', 'dd/mm/yyyy')));

    FETCH LCOMPOE_CUR
      into cod_rubrica_tot,cod_entidade_tot ;
    WHILE LCOMPOE_CUR%FOUND LOOP
          vCOMPOE_DET.extend;
          idx_COMPOE_DET := nvl( idx_COMPOE_DET , 0) + 1;
          LCOMPOE_DET.COD_FCRUBRICA_COMPOE:=cod_rubrica_tot;
          LCOMPOE_DET.COD_ENTIDADE_COMPOSTA:=cod_entidade_tot;
          vCOMPOE_DET (idx_COMPOE_DET) := LCOMPOE_DET ;

         FETCH LCOMPOE_CUR
         into cod_rubrica_tot,cod_entidade_tot ;

    END LOOP;

   FOR jind in 1 .. tdcn.count LOOP
    rdcn := tdcn(jind);

      qtd_rubrucas   :=vCOMPOE_DET.count;
       FOR I IN 1..qtd_rubrucas LOOP
            LCOMPOE_DET:= vCOMPOE_DET(I);
            IF LCOMPOE_DET.COD_FCRUBRICA_COMPOE=RDCN.COD_FCRUBRICA  AND
               RDCN.FLG_NATUREZA='D' THEN
             TOTAL_DEBITOS:=NVL(TOTAL_DEBITOS,0)+RDCN.VAL_RUBRICA;

            END IF;

       END LOOP;
   END LOOP;







  END SP_VERIFICA_TOTAIS;

  PROCEDURE SP_OBTEM_ESENCAOEC40 ( VI_COD_IDE_CLI IN  VARCHAR2 ,
                                   vi_ind_atb out CHAR         ) AS

  BEGIN
    -- Agregado para Excluir Acumulac?o dos Beneficios para o
    -- Calculo do Teto
    vi_ind_atb:='N';
      begin
      select distinct 'S' into vi_ind_atb from tb_atributos_pf b
      where exists (
      select 1
        from tb_atributos_pf    ats,
             tb_tipos_atributos ta
       where

           ats.cod_ins = par_cod_ins
       and b.cod_ide_cli = ats.cod_ide_cli
       and ats.cod_ide_cli = VI_COD_IDE_CLI
       and ats.cod_atributo = ta.cod_atributo
       and nvl(ats.flg_status,'V')='V'
       and ats.dat_ini_vig <=PAR_PER_PRO
       and (ats.dat_fim_vig is null or ats.dat_fim_vig >= PAR_PER_PRO)
       and TA.COD_ATRIBUTO=9000);
        vi_ind_atb:='S';
    exception
      when no_data_found then
        vi_ind_atb := 'N';
    end;
   END SP_OBTEM_ESENCAOEC40 ;

  PROCEDURE SP_OBTEM_FATOR_MES_PRO (VI_BEN_DAT_INICIO  IN   DATE  ,
                                    VI_DIA_MES         OUT  CHAR    ) AS

  BEGIN

      VI_DIA_MES:=1;
    BEGIN
     SELECT
        CASE
            --- Quando proporc?o no mes 16-08-2013
            WHEN TO_CHAR(VI_BEN_DAT_INICIO  ,'YYYYMM')= TO_CHAR(PAR_PER_PRO,'YYYYMM') AND
                   BEN_DAT_FIM IS NULL AND TO_CHAR(VI_BEN_DAT_INICIO  ,'DD')!='31' THEN
                         trunc((31 - TO_NUMBER(TO_CHAR(TO_DATE(VI_BEN_DAT_INICIO ,'DD/MM/YYYY'),'DD')))/30,4)

            WHEN TO_CHAR(VI_BEN_DAT_INICIO  ,'YYYYMM')< TO_CHAR(PAR_PER_PRO,'YYYYMM') AND
                   BEN_DAT_FIM IS NOT NULL  THEN
                  trunc((TO_NUMBER(TO_CHAR(TO_DATE(BEN_DAT_FIM ,'DD/MM/YYYY'),'DD') - 1))/30,4)

            WHEN TO_CHAR(VI_BEN_DAT_INICIO  ,'YYYYMM')= TO_CHAR(PAR_PER_PRO,'YYYYMM') AND
                   BEN_DAT_FIM IS NULL  AND TO_CHAR(VI_BEN_DAT_INICIO  ,'DD')='31'  THEN
                        trunc(1/30,4)

            ELSE
                  1
         END
         into  VI_DIA_MES
       FROM DUAL;

    exception
      when no_data_found then
        VI_DIA_MES:= 1;
    end;
   END SP_OBTEM_FATOR_MES_PRO  ;


 PROCEDURE SP_SEPARA_IRRF (    IDX_IRRF2       OUT NUMBER,
                               IDX_IRRF2_RETRO OUT NUMBER,
                               IDX_IRRF2_HISTO OUT NUMBER
                            ) AS

   IDX_IRRF             NUMBER;
   IDX_IRRF_RETRO       NUMBER;
   IDX_IRRF_HISTO       NUMBER;

  BEGIN

   --- EM esta rotina se separam os Valores Lancados por periodo
    -- Periodo Atual
    -- Periodo Anteriol


      tdcn_IRRF.DELETE;
      tdcn_IRRF_RETRO.DELETE;
      tdcn_IRRF_RETRO13.DELETE;

      IDX_IRRF            :=0;
      IDX_IRRF_RETRO      :=0;
      IDX_IRRF_RETRO13    :=0;
      IDX_IRRF_HISTO      :=0;

      DAT_INI_IRRF_RETRO  :=NULL;
      DAT_FIM_IRRF_RETRO  :=NULL;


      PER_ANTERIOR        := ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(PAR_PER_REAL,'YYYY'),'DD/MM/YYYY'),-1);
      PER_HANTERIOR       := ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(PER_ANTERIOR,'YYYY'),'DD/MM/YYYY'),-1);

      FOR i in 1 .. tdcn.count LOOP
         rdcn := tdcn(i);


             IDX_IRRF:=IDX_IRRF+1;
             tdcn_IRRF.extend;

             IDX_IRRF_RETRO:=IDX_IRRF_RETRO+1;
             tdcn_IRRF_RETRO.extend;
             tdcn_ACUMULADO_13.extend;

             IDX_IRRF_RETRO13:=IDX_IRRF_RETRO13+1;
             tdcn_IRRF_RETRO13.extend;

          -- N?o separa as rubricas geradas pelo processo 13
         IF NVL(RDCN.TIP_PROCESSO_REAL,'N') <> 'T'  AND NVL(RDCN.TIP_EVENTO_ESPECIAL,' ')<>'3' THEN
               IF (
                     ( TO_CHAR(PAR_PER_REAL,'YYYY')= TO_CHAR(rdcn.PER_PROCESSO,'YYYY')
                     ) AND
                     (
                       TO_CHAR(PAR_PER_REAL,'YYYY')= TO_CHAR(rdcn.dat_ini_ref,'YYYY')
                      )
                   ) OR

                   (  nvl(rdcn.tip_evento_especial,'0') IN ('H' ) AND
                      TO_CHAR(rdcn.dat_ini_ref,'YYYY')=TO_CHAR(PER_ANTERIOR ,'YYYY')

                   )
                  OR -- AGREGADO PARA ATENDER TASK 1768 CONSIDERAR DEC ANO ANTERIOR COM
                      -- IR DO PERIODO -06-08-2913 JTS
                    (
                      TO_CHAR(rdcn.dat_ini_ref,'YYYY')=TO_CHAR(PER_ANTERIOR ,'YYYY')
                         AND
                       (TO_CHAR(rdcn.dat_ini_ref,'MM')='12' )
                     )

               THEN
                  tdcn_IRRF(IDX_IRRF):= rdcn;
                 ELSE
                       IF DAT_INI_IRRF_RETRO  IS NULL OR rdcn.dat_ini_ref <DAT_INI_IRRF_RETRO  THEN
                          DAT_INI_IRRF_RETRO :=rdcn.dat_ini_ref ;
                       END IF;
                       IF DAT_FIM_IRRF_RETRO  IS NULL OR rdcn.dat_fim_ref >DAT_fim_IRRF_RETRO  THEN
                          DAT_FIM_IRRF_RETRO :=case when rdcn.dat_FIM_ref is null then
                                                          rdcn.dat_ini_ref else
                                                          rdcn.dat_FIM_ref end;
                       END IF;
                       tdcn_IRRF_RETRO(IDX_IRRF_RETRO):=rdcn;

              END IF;
         ELSE
            --- Bloco agregado para atender  ir 13

             tdcn_IRRF_RETRO13(IDX_IRRF_RETRO13):=rdcn;
         END IF;
      END LOOP;
      IDX_IRRF2:=IDX_IRRF;
      IDX_IRRF2_RETRO:=IDX_IRRF_RETRO;
      tdcn_IRRF.extend;
      tdcn_IRRF_RETRO.extend;

    --- Bloco agregado para atender  ir 13
      tdcn_IRRF_RETRO13.extend;
      IDX_IRRF2_HISTO:=IDX_IRRF_RETRO13;


  END SP_SEPARA_IRRF;

  PROCEDURE SP_OBTEM_IRRF_RETRO(ide_cli         IN  varchar2,
                          idx_val               IN  number,
                          FLG_PA                IN  varchar2,
                          O_VALOR               OUT number,
                          O_VALOR_13            OUT number,
                          O_BASE_BRUTA_IRRF     OUT number,
                          O_BASE_BRUTA_13_IRRF  OUT number,
                          O_QTA_MES             OUT number
                               ) AS

    VI_VAL_PAGOS        NUMBER(18, 4) := 0;
    VI_ISENTO           boolean := TRUE;
    nEdad               number;
    nIni                number;
    nFin                number;
    vi_rubrica          number := 0;
    vi_val_rubrica      number := 0;
    vi_seq_vig          number := 0;
    valor_proc_especial NUMBER(18, 4) := 0;

    vi_base_ir_IRRF       NUMBER:=0;
    vi_base_ir_13_IRRF    NUMBER:=0;
    vi_base_bruta_irrf    NUMBER:=0;
    vi_base_bruta_13_irrf NUMBER:=0;
    VI_BASE_IR_ACUMULADA  NUMBER:=0;
    GLS_ERR  VARCHAR(1000):=NULL;
    PARAMETRO_IR          CHAR(1);
  BEGIN

    vi_val_pagos := 0;

    nEdad    := 0;
    nIni     := 0;
    nFin     := 0;
    o_valor  := 0;
    o_QTA_MES:=0;

      FOR  x  in 1 ..v_cod_beneficio.COUNT LOOP
        VI_BASE_IR_ARR(v_cod_beneficio(x))(1):=0;
        VI_BASE_IR_ARR_13(v_cod_beneficio(x))(1):=0;
      END LOOP;
      IF  FLG_PA  ='A' THEN
          PARAMETRO_IR:='A';
       ELSIF FLG_PA ='D' THEN
          PARAMETRO_IR:='D';
        ELSE
         PARAMETRO_IR:='R';
      END IF;


     SP_OBTEM_BASE_IR(idx_val, PARAMETRO_IR , vi_base_ir_irrf, vi_base_ir_13_irrf);

      vi_base_bruta_irrf    := vi_base_ir_irrf;
      V_BASE_IR_IRRF        := vi_base_ir_irrf;

      vi_base_bruta_13_irrf := vi_base_ir_13_irrf;
      O_BASE_BRUTA_13_IRRF  :=vi_base_ir_13_irrf;

      O_BASE_BRUTA_IRRF     :=vi_base_ir_irrf;
       VI_TOT_DED            := 0;
       VI_TOT_DED_RUB        := 0;

    IF sp_isenta_irrf(ide_cli) <> VI_ISENTO THEN
      ---- Valida 65 Anos. N?o Aplica 65 em IRRF ANOS ANTERIORES
    /*  nFin  := to_char(ANT_DTA_NASC, 'yyyymmdd');
      nIni  := to_char(last_day(PAR_PER_REAL), 'yyyymmdd');
      nEdad := (nIni - nFin) / 10000;
      IF nEdad >= 65 THEN
        VI_TOT_DED := V_DED_IR_65;
      END IF;*/

      VI_NUM_DEP_ECO := 0;
       ---- Valida Dep IR. N?o Aplica Dep Ir em IRRF ANOS ANTERIORES
/*      IF COM_TIP_BENEFICIO = 'APOSENTADO' THEN
        VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(IDE_CLI, 'A');
      ELSE
        VI_NUM_DEP_ECO := SP_OBTEM_DEP_DED_IR(IDE_CLI, 'P');
      END IF;
      IF VI_NUM_DEP_ECO > 0 THEN
        VI_TOT_DED := nvl(VI_TOT_DED, 0) + (V_DED_IR_DEP * VI_NUM_DEP_ECO);
      END IF;*/

       -- Rubricas que deduzem no IR
      vi_val_pagos := SP_OBTEM_DED_PAGOS_IRRF(PARAMETRO_IR) ;

      IF vi_val_pagos > 0 THEN
        VI_TOT_DED_RUB  :=vi_val_pagos;
        VI_TOT_DED := VI_TOT_DED + vi_val_pagos;
      END IF;
      VI_BASE_IR_ACUMULADA:=0;

     IF PARAMETRO_IR <> 'D' THEN
       SP_OBTEM_BASE_IR_ACUM(FLG_PA,VI_BASE_IR_ACUMULADA );

       SP_OBTEM_IR_ACUM     (FLG_PA,
                             VI_IR_ACUMULADA ,
                             VI_DAT_INI_IR   ,
                             VI_DAT_TER_IR );

      END IF;
      --- Obtem Base IRRF
        IF PARAMETRO_IR <> 'D' THEN
              IF V_BASE_IR_IRRF > VI_TOT_DED THEN
                V_BASE_IR_irrf := nvl(V_BASE_IR_IRRF, 0)+ (nvl(VI_BASE_IR_ACUMULADA, 0)- VI_TOT_DED);
               --- Obtem valor IR
               --BEGIN
                O_QTA_MES:=SP_OBTEM_MESES_PAG_IRRF( PARAMETRO_IR);
              -- exception
               --   when OTHERS then
                --    GLS_ERR:= SQLERRM;
                --end;
               SP_CALCULA_IMPOSTO2_RETRO(v_base_ir_irrf,O_QTA_MES, o_valor);
                o_valor :=o_valor-VI_IR_ACUMULADA ;

              END IF;
        ELSE
               IF vi_base_ir_13_irrf  > VI_TOT_DED THEN
                vi_base_ir_13_irrf    := nvl(vi_base_ir_13_irrf, 0)  - VI_TOT_DED ;
                V_BASE_BRUTA_13_IRRF :=vi_base_ir_13_irrf ;
               --- Obtem valor IR
               --BEGIN
                O_QTA_MES:=SP_OBTEM_MESES_PAG_IRRF( PARAMETRO_IR);
              -- exception
               --   when OTHERS then
                --    GLS_ERR:= SQLERRM;
                --end;
                SP_CALCULA_IMPOSTO2_RETRO(vi_base_ir_13_irrf,O_QTA_MES,  O_VALOR_13);
               END IF;
        END IF;

    ELSE
      IF VI_DOENCA THEN
        V_DED_IR_DOENCA := V_BASE_IR_irrf;
        VI_BASE_IR      := 0;
      ELSE
        V_BASE_ISENCAO  := V_BASE_IR_irrf;
        V_DED_IR_DOENCA := 0;
        VI_BASE_IR      := 0;
      END IF;
    END IF;

  END SP_OBTEM_IRRF_RETRO;

  PROCEDURE SP_OBTEM_DETALHE_PAG_IRRF(IDE_CLI         IN VARCHAR2,
                                 FLG_PA               IN VARCHAR2,
                                 TP_EVENTO_ESPECIAL   IN VARCHAR2,
                                 TP_EVENTO            IN VARCHAR2,
                                 TP_IRRF              IN VARCHAR,
                                 V_BASE_BRUTA_IRRF    IN NUMBER ,
                                 V_BASE_BRUTA_13_IRRF IN NUMBER) as

    vi_rubrica      number := 0;
    vi_val_rubrica  number(18, 2) := 0;
    vi_seq_vig      number := 0;
    i_perc          number(18, 6) := 0;
    i               number := 0;
    cod_benef       number := 0;
    vi_flg_natureza varchar2(1) := null;
    val_13          number(18, 2) := 0;
    v_erro          varchar2(500) := null;
    -- variavel para diferenca havendo pagamento especial
    v_val_rub_dif number(18, 4) := 0;
    -- variavel para obter o ir do pagamento normal
    v_val_rub_pgto_normal number(18, 4) := 0;
    -- utilizar o processo para inclus?o de mais rubricas, 13?
   VAR_APOIO NUMBER;
  BEGIN

    IF (PAR_TIP_PRO = 'N' OR PAR_TIP_PRO = 'S' OR PAR_TIP_PRO = 'E') AND
       ((TP_EVENTO_ESPECIAL IN ('J', 'I')  AND TP_EVENTO = 'N') OR
       TP_EVENTO_ESPECIAL = 'S') THEN

      SELECT rr.cod_rubrica, rr.seq_vig
        INTO vi_rubrica, vi_seq_vig
        FROM tb_rubricas rr
       WHERE rr.cod_ins = PAR_COD_INS
         AND rr.tip_evento_especial = TP_EVENTO_ESPECIAL --Fixo
         AND rr.cod_entidade = COM_ENTIDADE
         AND rr.tip_evento = decode(par_tip_pro, 'S', 'N', tp_evento) --Tip_processo
         AND RR.DAT_INI_VIG <= PAR_PER_PRO
         AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL);
    ELSIF (TP_EVENTO_ESPECIAL IN ('J', 'I','B')  AND TP_EVENTO = 'T') THEN
      BEGIN
        SELECT rr.cod_rubrica, rr.seq_vig
          INTO vi_rubrica, vi_seq_vig
          FROM tb_rubricas rr
         WHERE rr.cod_ins = PAR_COD_INS
           AND rr.tip_evento_especial = TP_EVENTO_ESPECIAL --Fixo
           AND rr.tip_evento = decode(par_tip_pro, 'S', 'N', tp_evento) --Tip_processo
           AND rr.cod_entidade = COM_ENTIDADE
           AND RR.DAT_INI_VIG <= PAR_PER_PRO
           AND (RR.DAT_FIM_VIG >= PAR_PER_PRO OR RR.DAT_FIM_VIG IS NULL);
      EXCEPTION
        WHEN OTHERS THEN

          return;

      END;
    END IF;

    IF TP_EVENTO_ESPECIAL IN ('J', 'I','B')  OR TP_EVENTO_ESPECIAL = 'A' OR
       TP_EVENTO_ESPECIAL = 'T' OR TP_EVENTO_ESPECIAL = 'S' THEN
      vi_flg_natureza := 'D';
    ELSE
      vi_flg_natureza := 'C';
    END IF;

    COM_VAL_RUBRICA_CHEIO := 0;

    FOR i IN 1 .. vfolha.count LOOP

      IF FLG_PA = 'S' THEN
        tdcn_pa.extend;
        vi_ir_ret.extend;
        idx_caln_pa     := nvl(idx_caln_pa, 0) + 1;
        idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;

      ELSE
        tdcn.extend;
        vi_ir_ret.extend;

        idx_caln        := nvl(idx_caln, 0) + 1;
        idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
      END IF;
      -- Inicializacao da variavel do ir retido, recebendo o valor do ir calculado
      vi_ir_ret(i) := V_VAL_IR;
      -- n?o existindo IR , o valor da variavel ir retido ficara com zero.

      cod_benef := v_cod_beneficio(i);
       VAR_APOIO:=VI_BASE_IR_ARR(cod_benef) (1);

      IF TP_EVENTO_ESPECIAL IN ('J', 'I','B')   THEN
          i_perc := (VI_BASE_IR_ARR(cod_benef) (1) / V_BASE_BRUTA_IRRF  ) * 100;
          VI_PERC_IR(cod_benef)(1) := i_perc;
          VAR_APOIO:=VI_BASE_IR_ARR(cod_benef) (1);
           CASE
            WHEN  FLG_PA  = 'R'  THEN  vfolha(i).VAL_BASE_IR_ACUM:=(v_base_ir_irrf * i_perc/100);
            ELSE null;
           END CASE;

        IF VI_BASE_IR_ARR(cod_benef) (1) <> 0 THEN
          IF VI_SUPLEMENTAR AND cont_benef > 1 THEN
            i_perc := (VI_BASE_IR_ARR(cod_benef) (1) / V_BASE_BRUTA_IRRF  ) * 100;
            VI_PERC_IR(cod_benef)(1) := i_perc;
          ELSE
            IF cont_benef = 1 AND VI_SUPLEMENTAR THEN
              i_perc := 100;
              VI_PERC_IR(cod_benef)(1) := 100;
            ELSE
              i_perc := (VI_BASE_IR_ARR(cod_benef) (1) / V_BASE_BRUTA_IRRF  ) * 100;
              VI_PERC_IR(cod_benef)(1) := i_perc;
            END IF;
          END IF;
          rdcn.val_rubrica := (V_VAL_IR * i_perc) / 100;
          vi_ir_ret(i)   := rdcn.val_rubrica;
          vi_val_rubrica := rdcn.val_rubrica;
          COM_VAL_RUBRICA_CHEIO := COM_VAL_RUBRICA_CHEIO + vi_val_rubrica;
        ELSE
          vi_val_rubrica := 0;
        END IF;

      END IF;

      IF vi_rubrica > 0 THEN
        IF FLG_PA <> 'S' THEN
          begin
            IF VI_SUPLEMENTAR and tp_evento_especial NOT IN    ('J', 'I')  THEN
              IF v_base_prev(cod_benef) (1) = 0 THEN
                null;
              ELSE
                COM_VAL_RUBRICA_CHEIO := vi_val_rubrica;
                SP_INCLUI_DETALHE_PAG_IRRF(cod_benef,
                                      vi_rubrica,
                                      vi_val_rubrica,
                                      vi_seq_vig,
                                      vi_flg_natureza,
                                      TP_IRRF );

              END IF;
            ELSE
              COM_VAL_RUBRICA_CHEIO := vi_val_rubrica;
              SP_INCLUI_DETALHE_PAG_IRRF(cod_benef,
                                    vi_rubrica,
                                    vi_val_rubrica,
                                    vi_seq_vig,
                                    vi_flg_natureza,
                                    TP_IRRF );
            END IF;

          exception
            when no_data_found then
              v_erro := sqlerrm;
          end;

        ELSE
          COM_VAL_RUBRICA_CHEIO := vi_val_rubrica;
          SP_INCLUI_DETALHE_PAG_PA(ide_cli,
                                   cod_benef,
                                   vi_rubrica,
                                   vi_val_rubrica,
                                   vi_seq_vig,
                                   vi_flg_natureza);
        END IF;
      END IF;

    END LOOP;

    --  verifica se houve pagamento especial e efetua a diferenca do IR

    For w in 1 .. tdcn.count LOOP

      rdcn := tdcn(w);

      if rdcn.cod_fcrubrica = vi_rubrica and rdcn.tip_processo = 'E' then
        v_val_rub_dif := rdcn.val_rubrica;
      elsif rdcn.cod_fcrubrica = vi_rubrica and rdcn.tip_processo = 'N' then
        v_val_rub_pgto_normal := rdcn.val_rubrica;

        IF v_val_rub_dif > 0 and v_val_rub_pgto_normal > 0 then
          rdcn.val_rubrica := v_val_rub_pgto_normal - v_val_rub_dif;
          tdcn(w).val_rubrica := rdcn.val_rubrica;
          exit;
        END IF;

      end if;

    End Loop;

  END SP_OBTEM_DETALHE_PAG_IRRF;

  FUNCTION SP_OBTEM_DED_PAGOS_IRRF(tipo_irr IN VARCHAR)   RETURN NUMBER IS
    O_VALOR NUMBER(18, 4);
    i       number := 0;
    limit_dedu number:=0;
  --  tipo_irr varchar (1);
  BEGIN
    O_VALOR := 0;

     limit_dedu := case
                             when tipo_irr ='A' then  tdcn_irrf.count
                             when tipo_irr ='R' then  tdcn_irrf_RETRO.count
                             when tipo_irr ='D' then  tdcn_irrf_RETRO13.count
                             else  tdcn.count  end;


    FOR i IN 1 .. limit_dedu  LOOP
      rdcn := case           when tipo_irr ='A' then  tdcn_irrf(i)
                             when tipo_irr ='R' then  tdcn_irrf_RETRO(i)
                             when tipo_irr ='D' then  tdcn_irrf_RETRO13(i)

                             else  tdcn(i)  end;

      ant_entidade:=RDCN.COD_ENTIDADE;
      IF SP_DED_IR(rdcn.cod_fcrubrica) and rdcn.per_processo = PAR_PER_PRO THEN
        o_valor := o_valor + rdcn.val_rubrica;
        VI_BASE_IR_ARR_DED(rdcn.COD_IDE_REL_FUNC)(1):=VI_BASE_IR_ARR_DED(rdcn.COD_IDE_REL_FUNC)(1)+rdcn.val_rubrica;
         IF  tipo_irr ='R' THEN
             tdcn_irrf_RETRO(I).flg_ir_acumulado:='S';
             tdcn(I).flg_ir_acumulado           :='S';
          END IF;

      END IF;
    END LOOP;

    RETURN(O_VALOR);
  END SP_OBTEM_DED_PAGOS_IRRF;


  PROCEDURE SP_OBTEM_BASE_IR_ACUM (tipo_irr IN VARCHAR , V_BASE_IR_ACUMULADA OUT NUMBER)  AS
  CUR_COMPATIV_ACUM     curform;

   ------- VARIAVEIS ------
   IR_ACUM_cod_ins       NUMBER;
   IR_ACUM_tip_processo  CHAR(1);
   IR_ACUM_per_processo  DATE;
   IR_ACUM_cod_ide_cli   VARCHAR2(20);
   IR_ACUM_cod_beneficio NUMBER(8);
   IR_ACUM_seq_pagamento NUMBER(8);
   IR_ACUM_cod_fcrubrica NUMBER(8);
   IR_ACUM_seq_vig       NUMBER;
   IR_ACUM_val_rubrica   NUMBER(12,4);
   IR_ACUM_num_quota     NUMBER;
   IR_ACUM_flg_natureza  CHAR(1);
   IR_ACUM_dat_ini_ref   DATE;
   IR_ACUM_dat_fim_ref   DATE;
   idx_acum              NUMBER:=0;
   PERIODO_ACUMULADO     NUMBER:=0;

  BEGIN

   --- EM esta rotina se separam os Valores Lancados por periodo
    -- Ano Atual
    -- Ano Anteriol
    -- Outros Anos.
   tdcn_acumulado.delete;
   rdcn:=null;
   V_BASE_IR_ACUMULADA:=0;
 IF tipo_irr = 'R' THEN
  OPEN  CUR_COMPATIV_ACUM FOR

      SELECT
             IR_ACUM.cod_ins,
             IR_ACUM.tip_processo,
             IR_ACUM.per_processo,
             IR_ACUM.cod_ide_cli,
             IR_ACUM.cod_beneficio,
             IR_ACUM.seq_pagamento,
             IR_ACUM.cod_fcrubrica,
             IR_ACUM.seq_vig,
             IR_ACUM.val_rubrica,
             IR_ACUM.num_quota,
             IR_ACUM.flg_natureza,
             IR_ACUM.dat_ini_ref,
             IR_ACUM.dat_fim_ref

            INTO
             IR_ACUM_cod_ins,
             IR_ACUM_tip_processo,
             IR_ACUM_per_processo,
             IR_ACUM_cod_ide_cli,
             IR_ACUM_cod_beneficio,
             IR_ACUM_seq_pagamento,
             IR_ACUM_cod_fcrubrica,
             IR_ACUM_seq_vig,
             IR_ACUM_val_rubrica,
             IR_ACUM_num_quota,
             IR_ACUM_flg_natureza,
             IR_ACUM_dat_ini_ref,
             IR_ACUM_dat_fim_ref

       FROM tb_det_Calculado IR_ACUM
       WHERE IR_ACUM.cod_ins    = PAR_COD_INS
         AND IR_ACUM.PER_PROCESSO <  TO_DATE('01/01/'||TO_CHAR(PAR_PER_REAL,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.PER_PROCESSO >= TO_DATE('01/01/'||TO_CHAR(PER_ANTERIOR,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.cod_ide_cli = ANT_IDE_CLI
         AND IR_ACUM.FLG_IR_ACUMULADO='S'
         -- Agregado 03-06-2012
         AND 1=2
         AND  NOT  EXISTS (
         SELECT 1 FROM TB_RUBRICAS RU
         WHERE RU.COD_INS=PAR_COD_INS                 AND
               RU.COD_RUBRICA =IR_ACUM.COD_FCRUBRICA  AND
               RU.TIP_EVENTO_ESPECIAL='J'             AND
               RU.DAT_INI_VIG<=PAR_PER_PRO  AND
               NVL(RU.DAT_FIM_VIG,TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO
         );
   ELSE
      OPEN  CUR_COMPATIV_ACUM FOR
           SELECT
             IR_ACUM.cod_ins,
             IR_ACUM.tip_processo,
             IR_ACUM.per_processo,
             IR_ACUM.cod_ide_cli,
             IR_ACUM.cod_beneficio,
             IR_ACUM.seq_pagamento,
             IR_ACUM.cod_fcrubrica,
             IR_ACUM.seq_vig,
             IR_ACUM.val_rubrica,
             IR_ACUM.num_quota,
             IR_ACUM.flg_natureza,
             IR_ACUM.dat_ini_ref,
             IR_ACUM.dat_fim_ref

            INTO
             IR_ACUM_cod_ins,
             IR_ACUM_tip_processo,
             IR_ACUM_per_processo,
             IR_ACUM_cod_ide_cli,
             IR_ACUM_cod_beneficio,
             IR_ACUM_seq_pagamento,
             IR_ACUM_cod_fcrubrica,
             IR_ACUM_seq_vig,
             IR_ACUM_val_rubrica,
             IR_ACUM_num_quota,
             IR_ACUM_flg_natureza,
             IR_ACUM_dat_ini_ref,
             IR_ACUM_dat_fim_ref

       FROM tb_det_Calculado IR_ACUM
       WHERE IR_ACUM.cod_ins    = PAR_COD_INS
         AND IR_ACUM.PER_PROCESSO < TO_DATE('01/01/'||TO_CHAR(PAR_PER_REAL,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.PER_PROCESSO >= TO_DATE('01/01/'||TO_CHAR(PER_ANTERIOR,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.cod_ide_cli = ANT_IDE_CLI
         AND IR_ACUM.FLG_IR_ACUMULADO='S'
          -- Agregado 03-06-2012
         AND 1=2
         AND    EXISTS (
         SELECT 1 FROM TB_RUBRICAS RU
         WHERE RU.COD_INS=PAR_COD_INS                 AND
               RU.COD_RUBRICA =IR_ACUM.COD_FCRUBRICA  AND
               RU.TIP_EVENTO ='T'                     AND
               RU.TIP_EVENTO_ESPECIAL NOT IN ('J','I','T') AND   -- VER ADIANTAMENTO 13
               RU.DAT_INI_VIG<=PAR_PER_PRO  AND
               NVL(RU.DAT_FIM_VIG,TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO
         );
   END IF;

      FETCH CUR_COMPATIV_ACUM
      INTO
             IR_ACUM_cod_ins,
             IR_ACUM_tip_processo,
             IR_ACUM_per_processo,
             IR_ACUM_cod_ide_cli,
             IR_ACUM_cod_beneficio,
             IR_ACUM_seq_pagamento,
             IR_ACUM_cod_fcrubrica,
             IR_ACUM_seq_vig,
             IR_ACUM_val_rubrica,
             IR_ACUM_num_quota,
             IR_ACUM_flg_natureza,
             IR_ACUM_dat_ini_ref,
             IR_ACUM_dat_fim_ref;




    WHILE CUR_COMPATIV_ACUM%FOUND LOOP
      BEGIN
         PERIODO_ACUMULADO:=0;
         FOR I IN 1.. tdcn_IRRF_RETRO.COUNT LOOP
            rdcn:=case when tipo_irr ='R' then  tdcn_IRRF_RETRO(I)
                       else  tdcn_ACUMULADO_13(I)  end;
          IF (
                  (
                    RDCN.DAT_INI_REF<= IR_ACUM_dat_ini_ref AND
                    RDCN.DAT_FIM_REF>= IR_ACUM_dat_ini_ref
                   ) OR
                   (
                    RDCN.DAT_INI_REF<= IR_ACUM_dat_FIM_ref AND
                    RDCN.DAT_FIM_REF>= IR_ACUM_dat_FIM_ref
                   )
             )
             AND
                 RDCN.FLG_IR_ACUMULADO='S' THEN
                 PERIODO_ACUMULADO:=1;
          END IF;


        END LOOP;
        IF PERIODO_ACUMULADO=1 THEN

                  idx_acum := idx_acum + 1;


                  tdcn_acumulado.extend;

                  rdcn.cod_ins           := IR_ACUM_cod_ins;
                  rdcn.tip_processo      := IR_ACUM_tip_processo ;
                  rdcn.per_processo      := IR_ACUM_per_processo ;
                  rdcn.cod_ide_cli       := IR_ACUM_cod_ide_cli ;
              --    rdcn.cod_beneficio     := IR_ACUM_cod_beneficio;
                  rdcn.seq_pagamento     := IR_ACUM_seq_pagamento ;

                  rdcn.cod_fcrubrica     := IR_ACUM_cod_fcrubrica ;
                  rdcn.seq_vig           := IR_ACUM_seq_vig ;
                  rdcn.val_rubrica       := IR_ACUM_val_rubrica ;
                  rdcn.flg_natureza      := IR_ACUM_flg_natureza ;
                  rdcn.dat_ini_ref       := IR_ACUM_dat_ini_ref ;
                  rdcn.dat_fim_ref       := IR_ACUM_dat_fim_ref ;
                  IF  rdcn.flg_natureza ='C' THEN
                    V_BASE_IR_ACUMULADA := V_BASE_IR_ACUMULADA +rdcn.val_rubrica;
                  ELSE
                     V_BASE_IR_ACUMULADA := V_BASE_IR_ACUMULADA +(rdcn.val_rubrica*-1);
                  END IF;
                   tdcn_acumulado(idx_acum)   := rdcn;
          END IF;
      END;

      FETCH CUR_COMPATIV_ACUM
      INTO
             IR_ACUM_cod_ins,
             IR_ACUM_tip_processo,
             IR_ACUM_per_processo,
             IR_ACUM_cod_ide_cli,
             IR_ACUM_cod_beneficio,
             IR_ACUM_seq_pagamento,
             IR_ACUM_cod_fcrubrica,
             IR_ACUM_seq_vig,
             IR_ACUM_val_rubrica,
             IR_ACUM_num_quota,
             IR_ACUM_flg_natureza,
             IR_ACUM_dat_ini_ref,
             IR_ACUM_dat_fim_ref;
   END LOOP;


  END SP_OBTEM_BASE_IR_ACUM;

  PROCEDURE SP_OBTEM_IR_ACUM (tipo_irr      IN VARCHAR,
                             V_IR_ACUMULADA OUT NUMBER,
                             V_DAT_INI_IR   OUT DATE  ,
                             V_DAT_TER_IR   OUT DATE)  AS


   ------- VARIAVEIS ------
    IR_ACUM_val_rubrica   NUMBER(12,4);
    IR_ACUM_FLG_NATUREZA  CHAR(1);
    IR_ACUM_dat_ini_ref   DATE;
    IR_ACUM_dat_fim_ref   DATE;
    CUR_COMPATIV_IR_ACUM   curform;
  BEGIN

   --- EM esta rotina se separam os Valores Lancados por periodo
    -- Ano Atual
    -- Ano Anteriol
    -- Outros Anos.

   V_IR_ACUMULADA:=0;

 IF tipo_irr  ='R' THEN
  OPEN  CUR_COMPATIV_IR_ACUM FOR
      SELECT
             IR_ACUM.FLG_NATUREZA,
             IR_ACUM.VAL_RUBRICA ,
             IR_ACUM.dat_ini_ref ,
             IR_ACUM.dat_fim_ref

            INTO
             IR_ACUM_FLG_NATUREZA,
             IR_ACUM_VAL_RUBRICA ,
             IR_ACUM_dat_ini_ref ,
             IR_ACUM_dat_fim_ref

       FROM tb_det_Calculado IR_ACUM
       WHERE IR_ACUM.cod_ins    = PAR_COD_INS
         AND IR_ACUM.PER_PROCESSO < TO_DATE('01/01/'||TO_CHAR(PAR_PER_REAL,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.PER_PROCESSO > TO_DATE('01/01/'||TO_CHAR(PER_ANTERIOR,'YYYY'),'DD/MM/YYYY')

         AND IR_ACUM.cod_ide_cli = ANT_IDE_CLI
          -- Agregado 03-06-2012
         AND 1=2
         AND EXISTS (
         SELECT 1 FROM TB_RUBRICAS RU
         WHERE RU.COD_INS=PAR_COD_INS                 AND
               RU.COD_RUBRICA =IR_ACUM.COD_FCRUBRICA  AND
               RU.TIP_EVENTO_ESPECIAL='J'             AND
               RU.DAT_INI_VIG<=PAR_PER_PRO  AND
               NVL(RU.DAT_FIM_VIG,TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO
         );
  ELSE
      OPEN  CUR_COMPATIV_IR_ACUM FOR
      SELECT
             IR_ACUM.FLG_NATUREZA,
             IR_ACUM.VAL_RUBRICA ,
             IR_ACUM.dat_ini_ref ,
             IR_ACUM.dat_fim_ref

            INTO
             IR_ACUM_FLG_NATUREZA,
             IR_ACUM_VAL_RUBRICA ,
             IR_ACUM_dat_ini_ref ,
             IR_ACUM_dat_fim_ref

       FROM tb_det_Calculado IR_ACUM
       WHERE IR_ACUM.cod_ins    = PAR_COD_INS
         AND IR_ACUM.PER_PROCESSO < TO_DATE('01/01/'||TO_CHAR(PAR_PER_REAL,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.PER_PROCESSO > TO_DATE('01/01/'||TO_CHAR(PER_ANTERIOR,'YYYY'),'DD/MM/YYYY')
         AND IR_ACUM.cod_ide_cli = ANT_IDE_CLI
         -- Agregado 03-06-2012
         AND 1=2
         AND EXISTS (
         SELECT 1 FROM TB_RUBRICAS RU
         WHERE RU.COD_INS=PAR_COD_INS                 AND
               RU.COD_RUBRICA =IR_ACUM.COD_FCRUBRICA  AND
               RU.TIP_EVENTO_ESPECIAL='B'             AND
               RU.DAT_INI_VIG<=PAR_PER_PRO  AND
               NVL(RU.DAT_FIM_VIG,TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO
         );
  END IF;

      FETCH CUR_COMPATIV_IR_ACUM
      INTO
             IR_ACUM_FLG_NATUREZA,
             IR_ACUM_VAL_RUBRICA ,
             IR_ACUM_dat_ini_ref ,
             IR_ACUM_dat_fim_ref;


    WHILE CUR_COMPATIV_IR_ACUM%FOUND LOOP
    BEGIN
         FOR I IN 1.. tdcn_IRRF_RETRO.COUNT LOOP
              rdcn:=case when tipo_irr ='R' then  tdcn_IRRF_RETRO(I)
                       else  tdcn_ACUMULADO_13(I)  end;
          IF (
                  (
                    RDCN.DAT_INI_REF<= IR_ACUM_dat_ini_ref AND
                    RDCN.DAT_FIM_REF>= IR_ACUM_dat_ini_ref
                   ) OR
                   (
                    RDCN.DAT_INI_REF<= IR_ACUM_dat_FIM_ref AND
                    RDCN.DAT_FIM_REF>= IR_ACUM_dat_FIM_ref
                   )
             )
             AND
                 RDCN.FLG_IR_ACUMULADO='S' THEN
                IF IR_ACUM_FLG_NATUREZA ='D' THEN
                   V_IR_ACUMULADA :=V_IR_ACUMULADA+IR_ACUM_val_rubrica;
                ELSE
                  V_IR_ACUMULADA :=V_IR_ACUMULADA-IR_ACUM_val_rubrica;
                END IF;

                V_DAT_INI_IR   :=IR_ACUM_dat_ini_ref;
                V_DAT_TER_IR   := IR_ACUM_dat_fim_ref;
           END IF;
         END LOOP;
        FETCH CUR_COMPATIV_IR_ACUM
        INTO
             IR_ACUM_FLG_NATUREZA,
             IR_ACUM_VAL_RUBRICA ,
             IR_ACUM_dat_ini_ref ,
             IR_ACUM_dat_fim_ref;



     END;
   END LOOP;
  END SP_OBTEM_IR_ACUM;

 FUNCTION  SP_OBTEM_MESES_PAG_IRRF (TP_IRRF    IN VARCHAR
                                     ) RETURN NUMBER IS
       limit_dedu       NUMBER;
     MES_INICIO       NUMBER;
     MES_TERMINO      NUMBER;
     DAT_ANO_INICIO   DATE;
     DAT_ANO_TERMINO  DATE;
     ANO_INICIO       NUMBER;
     ANO_TERMINO      NUMBER;
     PERIODO          NUMBER;
     MES_IRRF         NUMBER;
     TOTAL_MESES      NUMBER;
     II               NUMBER;
     DET_MESES_IRRF   CHAR(13);
  BEGIN
        II:=0;
        limit_dedu := case
                             when tp_irrf ='A' then  tdcn_irrf.count
                             when tp_irrf ='R' then  tdcn_irrf_RETRO.count
                             when tp_irrf ='H' then  tdcn_ACUMULADO_13.count
                             when tp_irrf ='D' then  tdcn_irrf_RETRO13.count

                             else tdcn.count end;

       FOR i IN 1 .. limit_dedu  LOOP
          rdcn :=  case
                       when tp_irrf ='A' then  tdcn_irrf (I)
                       when tp_irrf ='R' then  tdcn_irrf_RETRO(I)
                       when tp_irrf ='H' then  tdcn_ACUMULADO_13(I)
                       when tp_irrf ='D' then  tdcn_irrf_RETRO13(I)

                       else tdcn(I)  end;

          IF (rdcn.flg_IR_ACUMULADO ='S' OR tp_irrf='D' ) and rdcn.FLG_NATUREZA ='C'   THEN

            IF TO_CHAR(RDCN.DAT_INI_REF,'YYYYMM')< TO_CHAR(DAT_ANO_INICIO,'YYYYMM')
              OR DAT_ANO_INICIO IS NULL  THEN
                 DAT_ANO_INICIO := RDCN.DAT_INI_REF ;
            END IF;
            IF RDCN.DAT_FIM_REF IS NULL THEN
               RDCN.DAT_FIM_REF:=RDCN.DAT_INI_REF;
            END IF;
            IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYYMM')>TO_CHAR(DAT_ANO_TERMINO,'YYYYMM') OR
              DAT_ANO_TERMINO IS NULL THEN
                 DAT_ANO_TERMINO := RDCN.DAT_FIM_REF;
            END IF;

          END IF;

       END LOOP;

       FOR i IN 1 .. tdcn_acumuladO.count  LOOP
          rdcn := tdcn_acumulado(i);
            IF rdcn.flg_IR_ACUMULADO ='S' and rdcn.FLG_NATUREZA ='C' THEN
            IF TO_CHAR(RDCN.DAT_INI_REF,'YYYYMM')< TO_CHAR(DAT_ANO_INICIO,'YYYYMM')
              OR DAT_ANO_INICIO IS NULL  THEN
                 DAT_ANO_INICIO := RDCN.DAT_INI_REF ;
            END IF;
            IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYYMM')>TO_CHAR(DAT_ANO_TERMINO,'YYYYMM') OR
              DAT_ANO_TERMINO IS NULL THEN
                 DAT_ANO_TERMINO := RDCN.DAT_FIM_REF;
            END IF;
           END IF;
       END LOOP;

        ANO_INICIO  :=TO_CHAR(DAT_ANO_INICIO,'YYYY');
        ANO_TERMINO :=TO_CHAR(DAT_ANO_TERMINO,'YYYY');
         TOTAL_MESES:=0;
       IF ANO_INICIO IS NOT NULL AND   ANO_TERMINO IS NOT NULL THEN
           FOR  PERIODO IN  ANO_INICIO  .. ANO_TERMINO  LOOP
                    MESES_IRRF:=VETOR_MES (0,0,0,0,0,0,0,0,0,0,0,0,0);
                    FOR i IN 1 .. limit_dedu  LOOP
                            rdcn :=  case
                                     when tp_irrf ='A' then  tdcn_irrf (I)
                                     when tp_irrf ='R' then  tdcn_irrf_RETRO(I)
                                     when tp_irrf ='H' then  tdcn_ACUMULADO_13(I)
                                     when tp_irrf ='D' then  tdcn_irrf_RETRO13(I)
                                     else tdcn(I)  end;

                        IF  RDCN.FLG_NATUREZA IN ('C','D') THEN
                            IF rdcn.flg_IR_ACUMULADO ='S' OR  tp_irrf ='D' THEN

                              IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')= PERIODO OR
                                 TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')= PERIODO THEN
                                 IF    rdcn.cod_fcrubrica !=1860159  THEN
                                       IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')=PERIODO
                                       THEN
                                          MES_INICIO:=TO_CHAR(RDCN.DAT_INI_REF,'MM');
                                       ELSE
                                          MES_INICIO:=1;
                                       END IF;
                                       IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')=PERIODO
                                        THEN
                                          MES_TERMINO:=TO_CHAR(RDCN.DAT_FIM_REF,'MM');
                                       ELSE
                                         IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYY') IS NOT NULL THEN
                                            MES_TERMINO:=12;
                                         ELSE
                                            MES_TERMINO:=TO_CHAR(RDCN.DAT_INI_REF,'MM');
                                         END IF;
                                       END IF;
                                 END IF;
                                 IF    MES_INICIO IS NOT NULL AND
                                       MES_TERMINO IS NOT NULL THEN
                                         FOR MES_IRRF  IN MES_INICIO .. MES_TERMINO LOOP
                                            MESES_IRRF(MES_IRRF):=1;
                                         END LOOP;
                                 END IF;
                                   ---- Comentado por existir calculo automatico de IR 13 atrasado

                                --  IF  RDCN.COD_FCRUBRICA IN (2300155,2302000,1860159,2302051) THEN
                                --    MESES_IRRF(13):=1;
                                --  END IF;
                              ELSE
                                 IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')< PERIODO AND
                                    TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')> PERIODO THEN
                                       IF    rdcn.cod_fcrubrica !=1860159  THEN
                                          IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')=PERIODO
                                             THEN
                                              MES_INICIO:=TO_CHAR(RDCN.DAT_INI_REF,'MM');
                                           ELSE
                                              MES_INICIO:=1;
                                           END IF;
                                           IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')=PERIODO
                                              THEN
                                              MES_TERMINO:=TO_CHAR(RDCN.DAT_FIM_REF,'MM');
                                           ELSE
                                              MES_TERMINO:=12;
                                           END IF;
                                           IF MES_INICIO IS NOT NULL AND
                                              MES_TERMINO IS NOT NULL THEN
                                               FOR MES_IRRF  IN MES_INICIO .. MES_TERMINO LOOP
                                                  MESES_IRRF(MES_IRRF):=1;
                                               END LOOP;
                                           END IF;
                                       END IF;
                                       ---- Comentado por existir calculo automatico de IR 13 atrasado

                                       --IF  RDCN.COD_FCRUBRICA IN(2300155,2302000,1860159,2302051)  THEN
                                        --    MESES_IRRF(13):=1;
                                       --END IF;
                                  END IF;

                              END IF;
                             END IF;
                           END IF;
                      END LOOP;
                      FOR i IN 1 .. tdcn_acumuladO.count  LOOP
                        rdcn := tdcn_acumulado(i);
                           IF RDCN.FLG_NATUREZA ='C' THEN
                              IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')= PERIODO OR
                                 TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')= PERIODO THEN
                                  IF    rdcn.cod_fcrubrica !=1860159  THEN
                                     IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')=PERIODO THEN
                                        MES_INICIO:=TO_CHAR(RDCN.DAT_INI_REF,'MM');
                                     ELSE
                                        MES_INICIO:=1;
                                     END IF;
                                     IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')=PERIODO THEN
                                        MES_TERMINO:=TO_CHAR(RDCN.DAT_FIM_REF,'MM');
                                     ELSE
                                        MES_TERMINO:=12;
                                     END IF;
                                     IF MES_INICIO IS NOT NULL AND
                                        MES_TERMINO IS NOT NULL THEN
                                       FOR MES_IRRF  IN MES_INICIO .. MES_TERMINO LOOP
                                          MESES_IRRF(MES_IRRF):=1;
                                       END LOOP;
                                     END IF;
                                 END IF;
                              ---- Comentado por existir calculo automatico de IR 13 atrasado
                              --   IF  RDCN.COD_FCRUBRICA IN (2300155,2302000,1860159,2302051)  THEN
                              --             MESES_IRRF(13):=1;
                              --   END IF;
                              ELSE

                                 IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')< PERIODO AND
                                    TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')> PERIODO THEN
                                        IF    rdcn.cod_fcrubrica !=1860159  THEN
                                            IF TO_CHAR(RDCN.DAT_INI_REF,'YYYY')=PERIODO THEN
                                                MES_INICIO:=TO_CHAR(RDCN.DAT_INI_REF,'MM');
                                             ELSE
                                                MES_INICIO:=1;
                                             END IF;
                                             IF TO_CHAR(RDCN.DAT_FIM_REF,'YYYY')=PERIODO THEN
                                                MES_TERMINO:=TO_CHAR(RDCN.DAT_FIM_REF,'MM');
                                             ELSE
                                                MES_TERMINO:=12;
                                             END IF;
                                             IF MES_INICIO IS NOT NULL AND
                                                MES_TERMINO IS NOT NULL THEN
                                                FOR MES_IRRF  IN MES_INICIO .. MES_TERMINO LOOP
                                                  MESES_IRRF(MES_IRRF):=1;
                                                END LOOP;
                                             END IF;
                                         END IF;
                                         ---- Comentado por existir calculo automatico de IR 13 atrasado
                                        -- IF  RDCN.COD_FCRUBRICA IN (2300155,2302000,1860159,2302051) THEN
                                        --    MESES_IRRF(13):=1;
                                        -- END IF;
                                  END IF;


                              END IF;
                            END IF;
                     END LOOP;


                      FOR ii in 1..12 LOOP
                         TOTAL_MESES:= TOTAL_MESES+ MESES_IRRF(II);
                      END LOOP;

                       TOTAL_MESES:=TOTAL_MESES+MESES_IRRF(13);

           END LOOP;
       END IF;
        IF  tp_irrf ='R' THEN
          DAT_INI_IRRF_RETRO:=DAT_ANO_INICIO;
          DAT_FIM_IRRF_RETRO:=DAT_ANO_TERMINO;
        ELSE
          DAT_INI_IRRF_HIST:=DAT_ANO_INICIO;
          DAT_FIM_IRRF_HIST:=DAT_ANO_TERMINO;
        END IF;


       RETURN TOTAL_MESES;
     ---- Obter Ano Minimo e Ano Maximo  --OK
     ---- Iterar desde Ano Minimo a Ano Maximo
     ------> Para cada registro de lancamento contar os meses no ano
     ------> Ao final dos registro de lancamento contar os meses do Ano
     --- Ao Final da Iterac?o contar o total de meses.

  END    SP_OBTEM_MESES_PAG_IRRF;

PROCEDURE SP_CALCULA_IMPOSTO2_RETRO(TotBru in number,qta_meses in number , MonImp out number) AS

    idx_ir number;
    contir number;
    valor_proc_especial number(18,4) :=0;
    LIM_SUP1 number;
    VAL_IMP1 number;
    AJUS1    number;
    LIM_SUP2 number;
    VAL_IMP2 number;
    AJUS2    number;
    LIM_SUP3 number;
    VAL_IMP3 number;
    AJUS3    number;

    PorImp  number;
    Redutor number;

    var1 number := 1;
    var2 number := 2;
    var3 number := 3;
    faixa number:=0;
    valorxx number:=null;
  BEGIN
    PorImp  := 0;
    Redutor := 0;
    MonImp  := 0;


    BEGIN
      BEGIN
        IF reg_ttypir(1) (1).val_elemento <= 0 THEN
          NULL;
        END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN

          reg_ttypir.delete;
          contir := vparam.count;
          FOR c IN 1 .. contir LOOP
            rpval := vparam(c);
            IF rpval.cod_param = 'TRAM' AND rpval.cod_estrutura = 2000 THEN
              IF rpval.cod_elemento = 'IRLIM_SUP' THEN
                reg_ttypir(var1)(rpval.num_faixa) := rpval;
              ELSIF rpval.cod_elemento = 'IRVAL_AJUS' THEN
                reg_ttypir(var2)(rpval.num_faixa) := rpval;
              ELSIF rpval.cod_elemento = 'IRVAL_IMP' THEN
                reg_ttypir(var3)(rpval.num_faixa) := rpval;
              END IF;
              --              reg_ttypir.extend;
              --              idx_ir:= nvl(idx_ir,0) + 1;
              --              typir(idx_ir) := rpval;
            END IF;
          END LOOP;

      END;

      FOR c IN 1 .. 5 loop
        --reg_ttypir.count LOOP
        faixa:=reg_ttypir(var1) (c).val_elemento;
        IF TotBru <= ( reg_ttypir(var1) (c).val_elemento * qta_meses)  THEN
          --LIM_SUP1 THEN
          Redutor := reg_ttypir(var2) (c).val_elemento; --AJUS1;
          PorImp  := reg_ttypir(var3) (c).val_elemento; --VAL_IMP1;
          EXIT;
        END IF;

      END LOOP;

      MonImp := (TotBru  * (PorImp) / 100);
      MonImp := MonImp - (Redutor * qta_meses);
    END;

    --Verifica se possui Processamento Especial ocorrido neste mes se sim deduz o IR processado
    valor_proc_especial :=0;

    IF valor_proc_especial >0 AND valor_proc_especial IS NOT NULL THEN
       MonImp := MonImp - valor_proc_especial;
    END IF;
  END SP_CALCULA_IMPOSTO2_RETRO;

  PROCEDURE SP_INCLUI_DETALHE_PAG_IRRF(TP_COD_BENEFICIO IN NUMBER,
                                  TP_RUBRICA       IN NUMBER,
                                  TP_VAL_RUBRICA   IN NUMBER,
                                  TP_SEQ_VIG       IN NUMBER,
                                  TP_FLG_NATUREZA  IN VARCHAR2,
                                  TP_IRRF          IN VARCHAR) as

  BEGIN

    rdcn.cod_ins         := PAR_COD_INS;
    rdcn.tip_processo    := PAR_TIP_PRO;
    rdcn.per_processo    := PAR_PER_PRO;
    rdcn.cod_ide_cli     := ANT_IDE_CLI;
   -- rdcn.cod_beneficio   := TP_COD_BENEFICIO;
    rdcn.seq_pagamento   := vi_seq_pagamento;
    rdcn.seq_detalhe     := idx_seq_detalhe;
    rdcn.cod_fcrubrica   := tp_rubrica;
    rdcn.val_rubrica     := tp_val_rubrica;
    rdcn.seq_vig         := tp_seq_vig;
    rdcn.num_quota       := 0;
    rdcn.flg_natureza    := tp_flg_natureza;
    rdcn.tot_quota       := 0;

    IF TP_IRRF ='R' THEN
       rdcn.dat_ini_ref     := DAT_INI_IRRF_RETRO;
       rdcn.dat_fim_ref     := DAT_FIM_IRRF_RETRO;
    ELSE
      rdcn.dat_ini_ref     := DAT_INI_IRRF_HIST;
      rdcn.dat_fim_ref     := DAT_INI_IRRF_HIST;
    END IF;


    rdcn.cod_ide_cli_ben := NULL; --verificar
    rdcn.num_ord_jud     := NULL; --varificar
    rdcn.dat_ing         := sysdate;
    rdcn.dat_ult_atu     := sysdate;
    rdcn.nom_usu_ult_atu := PAR_COD_USU;
    rdcn.nom_pro_ult_atu := 'FOLHA CALCULADA';
    rdcn.des_informacao  :=null;
    rdcn.des_complemento := null;

    rdcn.val_rubrica_cheio := COM_VAL_RUBRICA_CHEIO;

    CASE
      WHEN  QTA_MESES = 1                        THEN rdcn.des_informacao := rpad(to_char(QTA_MESES),3,' ') || '   Mes';
      WHEN  QTA_MESES < 10  AND  QTA_MESES != 1  THEN rdcn.des_informacao := rpad(to_char(QTA_MESES),3,' ') || '  Meses';
      WHEN  QTA_MESES < 100 AND  QTA_MESES > 10  THEN rdcn.des_informacao := rpad(to_char(QTA_MESES),3,' ') || ' Meses';
      ELSE  rdcn.des_informacao := to_char(QTA_MESES)  || ' Meses';
    END CASE;
    rdcn.flg_ir_acumulado:='S';

    --- Controle de Carga de consignataria 20-01-2011
    rdcn.num_carga              :=COM_NUM_CARGA;
    rdcn.num_seq_controle_carga :=COM_NUM_SEQ_CONTROLE_CARGA;  --NUM_SEQ_CONTROLE_CARGA

    tdcn(idx_caln) := rdcn;

  END SP_INCLUI_DETALHE_PAG_IRRF;

  PROCEDURE   SP_CARREGA_DAT_PAGAMENTO AS
    NUM_PAG      NUMBER;
    c_grupo_pag  curform;
  BEGIN


       tgrup.delete;
       NUM_PAG:=1;
       OPEN c_grupo_pag FOR
          SELECT  pag.NUM_GRP_PAG ,pag.DAT_PAGAMENTO
          FROM    TB_GRUPO_PAGAMENTO  pag;

        FETCH c_grupo_pag
          INTO PAG_NUM_GRP_PAG , PAG_DAT_PAGAMENTO ;

        WHILE c_grupo_pag%FOUND LOOP

           tgrup.extend;
            tgrup(NUM_PAG).NUM_GRP_PAG   :=PAG_NUM_GRP_PAG ;
            tgrup(NUM_PAG).DAT_PAGAMENTO :=PAG_DAT_PAGAMENTO;
          FETCH c_grupo_pag
           INTO PAG_NUM_GRP_PAG , PAG_DAT_PAGAMENTO  ;
           NUM_PAG:=NUM_PAG+1;
       END LOOP;
       CLOSE c_grupo_pag;
  END  SP_CARREGA_DAT_PAGAMENTO;
 ------------------------------------------------------------
 PROCEDURE SP_INCLUI_DETALHE_PAG_CONSIG(TP_COD_BENEFICIO IN NUMBER,
                                  TP_RUBRICA       IN NUMBER,
                                  TP_VAL_RUBRICA   IN NUMBER,
                                  TP_SEQ_VIG       IN NUMBER,
                                  TP_FLG_NATUREZA  IN VARCHAR2,
                                  TP_INI_REF       IN DATE,
                                  TP_FIM_REF       IN DATE,
                                  TP_DES_COMPLEMENTO IN VARCHAR) as

  BEGIN

    rdcn.cod_ins         := PAR_COD_INS;
    rdcn.tip_processo    := PAR_TIP_PRO;
    rdcn.per_processo    := PAR_PER_PRO;
    rdcn.cod_ide_cli     := ANT_IDE_CLI;
--    rdcn.cod_beneficio   := TP_COD_BENEFICIO;
    rdcn.seq_pagamento   := vi_seq_pagamento;
    rdcn.seq_detalhe     := idx_seq_detalhe;
    rdcn.cod_fcrubrica   := tp_rubrica;
    rdcn.val_rubrica     := tp_val_rubrica;
    rdcn.seq_vig         := tp_seq_vig;
    rdcn.num_quota       := 0;
    rdcn.flg_natureza    := tp_flg_natureza;
    rdcn.tot_quota       := 0;
    rdcn.dat_ini_ref     := TP_INI_REF;
    rdcn.dat_fim_ref     := TP_FIM_REF;
    rdcn.cod_ide_cli_ben := NULL; --verificar
    rdcn.num_ord_jud     := NULL; --varificar
    rdcn.dat_ing         := sysdate;
    rdcn.dat_ult_atu     := sysdate;
    rdcn.nom_usu_ult_atu := PAR_COD_USU;
    rdcn.nom_pro_ult_atu := 'FOLHA CONSIG';
    rdcn.des_complemento :=TP_DES_COMPLEMENTO;
    rdcn.des_informacao  :=null;


    rdcn.val_rubrica_cheio := COM_VAL_RUBRICA_CHEIO;

    IF VI_NUM_DEP_ECO > 0 AND trunc(tp_rubrica / 100, 000) in (70012,70014) THEN
      rdcn.des_informacao := to_char(VI_NUM_DEP_ECO, '09') || ' Dep.';
    END IF;
    --- Controle de Carga de consignataria 20-01-2011
    rdcn.num_carga              :=COM_NUM_CARGA;
    rdcn.num_seq_controle_carga :=COM_NUM_SEQ_CONTROLE_CARGA;  --NUM_SEQ_CONTROLE_CARGA

    tdcn(idx_caln) := rdcn;

  END SP_INCLUI_DETALHE_PAG_CONSIG;


PROCEDURE SP_SEPARA_IRRF_SUP ( IDX_IRRF2       OUT NUMBER,
                               IDX_IRRF2_RETRO OUT NUMBER,
                               IDX_IRRF2_HISTO OUT NUMBER
                            ) AS

   IDX_IRRF             NUMBER;
   IDX_IRRF_RETRO       NUMBER;
   IDX_IRRF_HISTO       NUMBER;
   CUR_COMPATIV_RET      curform;
   RFOL_SUP             TB_FOLHA_pagamento%ROWTYPE;
       ----- suplemetar do MES
    SUP_COD_INS         NUMBER;
     SUP_TIP_PROCESSO   VARCHAR2(1);
    SUP_PER_PROCESSO    DATE;
    SUP_COD_IDE_CLI     VARCHAR2(20);
    SUP_COD_BENEFICIO   NUMBER;
    SUP_SEQ_PAGAMENTO   NUMBER;
    SUP_COD_FCRUBRICA   NUMBER;
    SUP_COD_ENTIDADE    NUMBER(8);
    SUP_TIP_EVENTO_ESPECIAL CHAR(1);
    SUP_SEQ_VIG         NUMBER;
    SUP_VAL_RUBRICA     NUMBER;
    SUP_NUM_QUOTA       NUMBER;
    SUP_FLG_NATUREZA    VARCHAR2(1);
    SUP_TOT_QUOTA       NUMBER;
    SUP_DAT_INI_REF     DATE;
    SUP_DAT_FIM_REF     DATE;
    SUP_COD_IDE_CLI_BEN VARCHAR2(20);
    SUP_NUM_ORD_JUD     NUMBER;
    SUP_DAT_ING         DATE;
    SUP_DAT_ULT_ATU     DATE;
    SUP_NOM_USU_ULT_ATU VARCHAR2(20);
    SUP_NOM_PRO_ULT_ATU VARCHAR2(20);
    SUP_RET_SUP         CHAR(1);
    SUP_COMPLEMENTO     VARCHAR2(15);
    SUP_INFORMACAO      VARCHAR2(10);
    PAR_REAL_TEM        DATE;

  BEGIN

   --- EM esta rotina se separam os Valores Lancados por periodo
    -- Periodo Atual
    -- Periodo Anteriol


      tdcn_IRRF.DELETE;
      tdcn_IRRF_RETRO.DELETE;


      IDX_IRRF            :=0;
      IDX_IRRF_RETRO      :=0;
      IDX_IRRF_HISTO      :=0;

      DAT_INI_IRRF_RETRO  :=NULL;
      DAT_FIM_IRRF_RETRO  :=NULL;

    -------------------------
/*     PAR_REAL_TEM :=PAR_PER_REAL;
     IF PAR_TIP_PRO ='S' AND TO_CHAR(PAR_PER_REAL,'MM') =12 THEN
       PAR_PER_REAL :=ADD_MONTHS(PAR_PER_REAL,1);
     END IF; */

      PER_ANTERIOR        := ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(PAR_PER_REAL,'YYYY'),'DD/MM/YYYY'),-1);
      PER_HANTERIOR       := ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(PER_ANTERIOR,'YYYY'),'DD/MM/YYYY'),-1);

      FOR i in 1 .. tdcn.count LOOP
         rdcn := tdcn(i);

         IDX_IRRF:=IDX_IRRF+1;
         tdcn_IRRF.extend;

         IDX_IRRF_RETRO:=IDX_IRRF_RETRO+1;
         tdcn_IRRF_RETRO.extend;
         tdcn_ACUMULADO_13.extend;
           IF (
                 ( TO_CHAR(PAR_PER_REAL,'YYYY')= TO_CHAR(rdcn.PER_PROCESSO,'YYYY')
                 ) AND
                 (
                   TO_CHAR(PAR_PER_REAL,'YYYY')= TO_CHAR(rdcn.dat_ini_ref,'YYYY')
                  )
               ) OR
                --- 20130312 AGREGADO EVENTO '1' ANTES -- ='H
               ( nvl(rdcn.tip_evento_especial,'0') IN ('H','1')  AND
                  TO_CHAR(rdcn.dat_ini_ref,'YYYY')=TO_CHAR(PER_ANTERIOR ,'YYYY')

               )
               --
               OR (  ---- O Residente no Extrangeiro n?o calcula RRA
                     VI_IR_EXTERIOR
                   )
           THEN
              tdcn_IRRF(IDX_IRRF):= rdcn;

             ELSE
                   IF DAT_INI_IRRF_RETRO  IS NULL OR rdcn.dat_ini_ref <DAT_INI_IRRF_RETRO  THEN
                      DAT_INI_IRRF_RETRO :=rdcn.dat_ini_ref ;
                   END IF;
                   IF DAT_FIM_IRRF_RETRO  IS NULL OR rdcn.dat_fim_ref >DAT_fim_IRRF_RETRO  THEN
                      DAT_FIM_IRRF_RETRO :=case when rdcn.dat_FIM_ref is null then
                                                      rdcn.dat_ini_ref else
                                                      rdcn.dat_FIM_ref end;
                   END IF;
                   tdcn_IRRF_RETRO(IDX_IRRF_RETRO):=rdcn;

          END IF;
      END LOOP;

      ------------- carrega Valores Do Mes ------
/*
       FOR  INDEX_BEN   IN 1 .. vfolha.count LOOP
       RFOL_SUP := vFOLHA( INDEX_BEN  );

           OPEN CUR_COMPATIV_RET FOR

                        SELECT RET.cod_ins,
                               tip_processo,
                               per_processo,
                               RET.cod_ide_cli,
                               RET.cod_beneficio,
                               seq_pagamento,
                               RET.cod_fcrubrica,
                               RET.seq_vig,
                               RET.val_rubrica,
                               RET.num_quota,
                               RET.flg_natureza,
                               RET.tot_quota,
                               RET.dat_ini_ref,
                               RET.dat_fim_ref,
                               RET.cod_ide_cli_ben,
                               RET.num_ord_jud,
                               RET.dat_ing,
                               RET.dat_ult_atu,
                               RET.nom_usu_ult_atu,
                               RET.nom_pro_ult_atu,
                               'R',
                               DES_INFORMACAO,
                               DES_COMPLEMENTO,
                               CC.COD_ENTIDADE,
                               RR. TIP_EVENTO_ESPECIAL
                          INTO SUP_COD_INS,
                               SUP_TIP_PROCESSO,
                               SUP_PER_PROCESSO,
                               SUP_COD_IDE_CLI,
                               SUP_COD_BENEFICIO,
                               SUP_SEQ_PAGAMENTO,
                               SUP_COD_FCRUBRICA,
                               SUP_SEQ_VIG,
                               SUP_VAL_RUBRICA,
                               SUP_NUM_QUOTA,
                               SUP_FLG_NATUREZA,
                               SUP_TOT_QUOTA,
                               SUP_DAT_INI_REF,
                               SUP_DAT_FIM_REF,
                               SUP_COD_IDE_CLI_BEN,
                               SUP_NUM_ORD_JUD,
                               SUP_DAT_ING,
                               SUP_DAT_ULT_ATU,
                               SUP_NOM_USU_ULT_ATU,
                               SUP_NOM_PRO_ULT_ATU,
                               SUP_RET_SUP,
                               SUP_INFORMACAO,
                               SUP_COMPLEMENTO,
                               SUP_COD_ENTIDADE,
                               SUP_TIP_EVENTO_ESPECIAL

                          FROM tb_hdet_calculado RET, TB_CONCESSAO_BENEFICIO CC
                               , tb_rubricas rr
                         WHERE RET.cod_ins = PAR_COD_INS
                           AND cod_ide_cli =RFOL_SUP.COD_IDE_CLI
                           AND per_processo = PAR_PER_PRO
                           AND tip_processo IN ('N', 'S')
                           AND RET.cod_beneficio > 0
                           AND CC.COD_INS       = PAR_COD_INS
                           AND CC.COD_BENEFICIO = RFOL_SUP.COD_BENEFICIO
                           AND CC.COD_BENEFICIO =RET.COD_BENEFICIO
                           AND RR.COD_INS =CC.COD_INS
                           AND RR.COD_RUBRICA=RET.COD_FCRUBRICA
                           AND RR.COD_ENTIDADE=RFOL_SUP.COD_ENTIDADE;


                      FETCH  CUR_COMPATIV_RET
                        INTO  SUP_COD_INS,
                               SUP_TIP_PROCESSO,
                               SUP_PER_PROCESSO,
                               SUP_COD_IDE_CLI,
                               SUP_COD_BENEFICIO,
                               SUP_SEQ_PAGAMENTO,
                               SUP_COD_FCRUBRICA,
                               SUP_SEQ_VIG,
                               SUP_VAL_RUBRICA,
                               SUP_NUM_QUOTA,
                               SUP_FLG_NATUREZA,
                               SUP_TOT_QUOTA,
                               SUP_DAT_INI_REF,
                               SUP_DAT_FIM_REF,
                               SUP_COD_IDE_CLI_BEN,
                               SUP_NUM_ORD_JUD,
                               SUP_DAT_ING,
                               SUP_DAT_ULT_ATU,
                               SUP_NOM_USU_ULT_ATU,
                               SUP_NOM_PRO_ULT_ATU,
                               SUP_RET_SUP,
                               SUP_INFORMACAO,
                               SUP_COMPLEMENTO,
                               SUP_COD_ENTIDADE,
                               SUP_TIP_EVENTO_ESPECIAL;

                      WHILE CUR_COMPATIV_RET%FOUND LOOP
                        BEGIN
                             rdcn.cod_ins            := SUP_COD_INS;
                            rdcn.tip_processo       := PAR_TIP_PRO;
                            rdcn.per_processo       := PAR_PER_PRO;
                            rdcn.cod_ide_cli        := SUP_COD_IDE_CLI;

                            rdcn.seq_pagamento      := SUP_seq_pagamento;
                            rdcn.seq_detalhe        := 1;--SUP_seq_detalhe;
                            rdcn.cod_fcrubrica      := SUP_COD_FCRUBRICA;
                            rdcn.seq_vig            := SUP_SEQ_VIG;
                            rdcn.val_rubrica        := SUP_VAL_RUBRICA;
                            rdcn.val_rubrica_cheio  := SUP_VAL_RUBRICA;
                            rdcn.num_quota          := SUP_NUM_QUOTA;
                            rdcn.flg_natureza       := SUP_flg_natureza;
                            rdcn.tot_quota          := SUP_tot_quota;
                            rdcn.dat_ini_ref        := SUP_DAT_INI_REF;
                            rdcn.dat_fim_ref        := SUP_dat_fim_ref;
                            rdcn.num_ord_jud        := SUP_NUM_ORD_JUD;
                            rdcn.cod_ide_cli_ben    := SUP_COD_IDE_CLI_BEN;
                            rdcn.dat_ing            := sysdate;
                            rdcn.dat_ult_atu        := sysdate;
                            rdcn.nom_usu_ult_atu    := SUP_nom_usu_ult_atu;
                            rdcn.nom_pro_ult_atu    := 'FOLHA CALCULADA';
                            rdcn.des_informacao     := SUP_informacao;
                            rdcn.des_complemento    := SUP_complemento;
                            rdcn.cod_entidade       := SUP_cod_entidade;
                            rdcn.tip_evento_especial:= SUP_TIP_EVENTO_ESPECIAL;


                             IDX_IRRF:=IDX_IRRF+1;
                             tdcn_IRRF.extend;

                             IDX_IRRF_RETRO:=IDX_IRRF_RETRO+1;
                             tdcn_IRRF_RETRO.extend;
                             tdcn_ACUMULADO_13.extend;
                             IF (
                                   ( TO_CHAR(PAR_PER_REAL,'YYYY')= TO_CHAR(rdcn.PER_PROCESSO,'YYYY')
                                   ) AND
                                   (
                                     TO_CHAR(PAR_PER_REAL,'YYYY')= TO_CHAR(rdcn.dat_ini_ref,'YYYY')
                                    )
                                 ) OR
                                 (  nvl(rdcn.tip_evento_especial,'0') ='H' AND
                                    TO_CHAR(rdcn.dat_ini_ref,'YYYY')=TO_CHAR(PER_ANTERIOR ,'YYYY')

                                 )
                                 OR (  ---- O Residente no Extrangeiro n?o calcula RRA
                                      VI_IR_EXTERIOR
                                    )
                             THEN
                                tdcn_IRRF(IDX_IRRF):= rdcn;
                               ELSE
                                     IF DAT_INI_IRRF_RETRO  IS NULL OR rdcn.dat_ini_ref <DAT_INI_IRRF_RETRO  THEN
                                        DAT_INI_IRRF_RETRO :=rdcn.dat_ini_ref ;
                                     END IF;
                                     IF DAT_FIM_IRRF_RETRO  IS NULL OR rdcn.dat_fim_ref >DAT_fim_IRRF_RETRO  THEN
                                        DAT_FIM_IRRF_RETRO :=case when rdcn.dat_FIM_ref is null then
                                                                        rdcn.dat_ini_ref else
                                                                        rdcn.dat_FIM_ref end;
                                     END IF;
                                     tdcn_IRRF_RETRO(IDX_IRRF_RETRO):=rdcn;

                            END IF;

                          END;
                        ----> FETCH
                        FETCH  CUR_COMPATIV_RET
                        INTO  SUP_COD_INS,
                               SUP_TIP_PROCESSO,
                               SUP_PER_PROCESSO,
                               SUP_COD_IDE_CLI,
                               SUP_COD_BENEFICIO,
                               SUP_SEQ_PAGAMENTO,
                               SUP_COD_FCRUBRICA,
                               SUP_SEQ_VIG,
                               SUP_VAL_RUBRICA,
                               SUP_NUM_QUOTA,
                               SUP_FLG_NATUREZA,
                               SUP_TOT_QUOTA,
                               SUP_DAT_INI_REF,
                               SUP_DAT_FIM_REF,
                               SUP_COD_IDE_CLI_BEN,
                               SUP_NUM_ORD_JUD,
                               SUP_DAT_ING,
                               SUP_DAT_ULT_ATU,
                               SUP_NOM_USU_ULT_ATU,
                               SUP_NOM_PRO_ULT_ATU,
                               SUP_RET_SUP,
                               SUP_INFORMACAO,
                               SUP_COMPLEMENTO,
                               SUP_COD_ENTIDADE,
                               SUP_TIP_EVENTO_ESPECIAL;
                       END LOOP;
                close CUR_COMPATIV_RET;
      END LOOP;
*/
      --------------------------------------------


      IDX_IRRF2:=IDX_IRRF;
      IDX_IRRF2_RETRO:=IDX_IRRF_RETRO;
      tdcn_IRRF.extend;
      tdcn_IRRF_RETRO.extend;
     -- PAR_PER_REAL   :=PAR_REAL_TEM;
  END SP_SEPARA_IRRF_SUP;

  ----------------CORRECAO MONETARIA ---
    -- SP_OBTEM_FATOR_CORRECAO: Obtem fator de correc?o nos casos de retroativo
  PROCEDURE SP_OBTEM_FATOR_CORRECAO_UFESP(
                                    ANO_ATUAL in NUMBER,
                                    ANO_RETRO in NUMBER,
                                    O_FATOR_CORRECAO OUT NUMBER) AS
    O_FATOR_MES_ATUAL NUMBER(18, 4);
    O_FATOR_MES_RETRO NUMBER(18, 4);
  BEGIN


    BEGIN
        SELECT op.val_fator
          INTO O_FATOR_MES_ATUAL
          FROM  tb_ufesp_aposentado op
         WHERE op.ano_ufesp = ANO_ATUAL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_FATOR_MES_ATUAL  := 0;
        O_FATOR_CORRECAO   := 0;
      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_FATOR_CORRECAOATUAL';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o fator de correcao mes';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              0,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

    BEGIN
        SELECT
                     op.val_fator
                INTO O_FATOR_MES_RETRO
                FROM  tb_ufesp_aposentado op
                WHERE op.ano_ufesp=ANO_RETRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_FATOR_MES_RETRO := 0;
        O_FATOR_CORRECAO  := 0;
       WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_FATOR_CORRECAOATUAL';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o fator de correcao mes';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              0,
                              0);
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;

        O_FATOR_CORRECAO :=0;

   IF O_FATOR_MES_RETRO <>0  AND
      O_FATOR_MES_ATUAL <> 0 THEN
      O_FATOR_CORRECAO :=round((O_FATOR_MES_ATUAL-O_FATOR_MES_RETRO )/O_FATOR_MES_RETRO,6);
   END IF;

    RETURN;

  END SP_OBTEM_FATOR_CORRECAO_UFESP ;

  FUNCTION SP_OBTEM_PERC_FEQ  RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    v_val_porcentual     number(18, 4) := 0;
   BEGIN

    BEGIN

        SELECT
             VAL_PORCENTUAL
        INTO v_val_porcentual
           from tb_conceito_rub_det_dominio  cf
        WHERE cf.cod_ins      = PAR_COD_INS       AND
              cf.cod_entidade = COM_ENTIDADE      AND
              cf.cod_conceito = COM_COD_CONCEITO  AND
              cf.cod_func     = COM_COD_FUNCAO    AND
              (to_char(PAR_PER_PRO, 'YYYYMM') >=
                     to_char(cf.dat_ini_vig, 'YYYYMM') AND
                     to_char(PAR_PER_PRO, 'YYYYMM') <=
                     to_char(nvl(cf.DAT_FIM_VIG,
                                  to_date('01/01/2045', 'dd/mm/yyyy')),
                              'YYYYMM'))          AND
                              ROWNUM <2;
      O_VALOR := v_val_porcentual;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR              := 0;
        v_val_porcentual     := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_PERC_FEQ';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o  PERC_FEQ';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --          RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_PERC_FEQ;

PROCEDURE SP_OBTEM_SIM_CNT(COM_COD_BENEFICIO IN NUMBER ,   O_VALOR OUT NUMBER) AS
 BEGIN
    IF COM_COD_BENEFICIO >=40000000 AND
       COM_COD_BENEFICIO <=41000000 AND
       ANT_BEN_ENVIO_CORREIO='S'    AND
       PAR_PER_PRO =PAR_PER_REAL THEN
         O_VALOR :=1 ;
         IF O_VALOR=1 THEN
           BEGIN
             SELECT 1
             INTO O_VALOR
               FROM  TB_ENVIO_CORREIO_HIST A
              WHERE A.COD_INS = PAR_COD_INS
                AND A.COD_IDE_CLI = ANT_IDE_CLI
                AND A.FLG_ENVIO_CORREIO = 'S'
                AND A.DAT_ULT_ATU IN (

                                      SELECT MAX(B.DAT_ULT_ATU)
                                        FROM  TB_ENVIO_CORREIO_HIST B
                                       WHERE A.COD_INS =  PAR_COD_INS
                                         AND B.COD_INS =  PAR_COD_INS
                                         AND B.COD_IDE_CLI = A.COD_IDE_CLI);
                   O_VALOR   :=1;
             EXCEPTION
              WHEN no_data_found THEN
                      O_VALOR   :=0;

            END;
         END IF;
    ELSE
          O_VALOR:= 0 ;
    END IF;
 END;
 ------ Artigo 133 Novo procedimentos ---
 ---------------- DESENVOLVIMENTO ART 133 -----






  PROCEDURE SP_OBTEM_ORIG_TAB_VENC_CCOMI(val_referencia_cc out number) AS
  BEGIN

    begin
        select ecg.cod_referencia
         into val_referencia_cc
          from tb_evolu_ccomi_gfuncional ecg,
               tb_concessao_beneficio    cc,
               tb_referencia             rr
         where ecg.cod_ins = PAR_COD_INS
           and ecg.cod_ins = cc.cod_ins
           and ecg.cod_entidade = cc.cod_entidade
           and ecg.num_matricula = cc.num_matricula
           and ecg.cod_ide_rel_func = cc.cod_ide_rel_func
           and ecg.cod_ide_cli = cc.cod_ide_cli_serv
           and rr.cod_ins = cc.cod_ins
           and rr.cod_entidade = cc.cod_entidade
           and rr.cod_referencia = ecg.cod_referencia
           and ecg.cod_cargo_comp =COM_CARGO_DIF_VENC
           and ecg.dat_fim_efeito is null
           and ecg.cod_entidade=COM_COD_ENTIDADE
           and cc.cod_beneficio=COM_COD_BENEFICIO
           and ecg.cod_ide_cli=COM_IDE_CLI_INSTITUIDOR
           and rownum<2;

    exception
      when others then
        val_referencia_cc := 0;
    end;
  END SP_OBTEM_ORIG_TAB_VENC_CCOMI;
  ------------------------
 FUNCTION SP_OBTEM_PADRAO_VENCIMENTO_DIF RETURN VARCHAR2 IS

  BEGIN
    begin
      select rr.cod_ref_pad_venc
        into vi_cod_ref_pad_venc
        from tb_referencia rr
       where rr.cod_entidade = COM_ENTIDADE
         and rr.cod_ins = PAR_COD_INS
         and rr.cod_pccs = COM_PCCS
         and rr.cod_quadro = COM_QUADRO
         and rr.cod_referencia =COM_COD_REFERENCIA_DIF
         and (PAR_PER_PRO >= rr.dat_ini_vig and
             PAR_PER_PRO <=
             nvl(rr.dat_fim_vig, to_date('01/01/2045', 'dd/mm/yyyy')));
    exception
      when others then
        vi_cod_ref_pad_venc := ' ';
    end;

    return vi_cod_ref_pad_venc;

  END SP_OBTEM_PADRAO_VENCIMENTO_DIF;
   FUNCTION SP_VALIDA_CONDICAO_RECUR RETURN BOOLEAN AS

    i          number;
    vi_formula varchar2(700);
    vi_str     varchar2(700);
    cur_form   curesp;
    o_condicao boolean;
    vi_res     number;

  BEGIN
    vi_res     := 0;
    o_condicao := FALSE;
    FOR i IN 1 .. lim_funcao_rec LOOP
      IF tip_elemento_rec(i) = 'OPER' OR tip_elemento_rec(i) = 'SIMB' THEN
        vi_formula := concat(vi_formula, cod_elemento_rec(i));
      ELSE
        vi_formula := concat(vi_formula, vas_elemento_rec(i));
        --         vi_formula:=concat(vi_formula,to_char(val_elemento(i),'0000000.9999'));
      END IF;
    END LOOP;
    vi_str := 'select case when ' || vi_formula ||
              ' then 1 else 0 end from dual';
    begin
      OPEN cur_form FOR vi_str;
      -- fetch cur_form into o_condicao;
      FETCH cur_form
        INTO vi_res;
      CLOSE cur_form;
    exception
      when others then
        IF SQLCODE = -936 THEN
          vi_res := 0;
        ELSE
          p_coderro       := sqlcode;
          p_sub_proc_erro := 'SP_VALIDA_CONDICAO';
          p_msgerro       := 'Erro ao validar a condicao da formula' || '  ' ||
                             vi_str;
          INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                p_coderro,
                                'Calcula Folha',
                                sysdate,
                                p_msgerro,
                                p_sub_proc_erro,
                                BEN_IDE_CLI,
                                COM_COD_FCRUBRICA);

          --       RAISE ERRO;
          VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END IF;
    end;
    IF vi_res = 1 THEN
      o_condicao := TRUE;
    ELSE
      o_condicao := FALSE;
    END IF;
    RETURN(o_condicao);

  END SP_VALIDA_CONDICAO_RECUR;
  --- Para calculo de IR 13
    ----------------------------------------------------------------------------------

PROCEDURE SP_CALCULA_SALMIN_ANTER(i_valor out number) AS
  BEGIN
    BEGIN

select   max(pmin.val_elemento)
  into  i_valor
  from tb_det_param_estrutura pmin
 where pmin.COD_PARAM = 'SALMIN'
   and pmin.cod_elemento = 'PAR_SAL_MIN'
   and not (pmin.ini_vig >=PAR_PER_PRO  and
        nvl(pmin.fim_vig,PAR_PER_PRO) >=
           PAR_PER_PRO )
   and pmin.fim_vig in
       (
          select max(pmin2.fim_vig)
          from tb_det_param_estrutura pmin2
         where pmin2.COD_PARAM = 'SALMIN'
           and pmin2.cod_elemento = 'PAR_SAL_MIN'
           and rowid not in
               (
                  select rowid
                  from tb_det_param_estrutura pmin3
                 where pmin3.COD_PARAM    = 'SALMIN'
                   and pmin3.cod_elemento = 'PAR_SAL_MIN'
                   and pmin3.ini_vig >= PAR_PER_PRO
                   and nvl(pmin3.fim_vig, PAR_PER_PRO) >=
                       PAR_PER_PRO
               )
        );

    EXCEPTION
      WHEN OTHERS THEN
        i_valor := 0;
    end;

  END SP_CALCULA_SALMIN_ANTER;

 FUNCTION SP_IRRF_EXT(ide_cli in varchar2) return boolean is
   vi_exterior    boolean;
   vi_count       number;
   vi_ind_atb     varchar(1);
   w_cod_atributo number;
 Begin
   vi_exterior := false;
   vi_count    := 0;

   BEGIN

     select distinct 'S'
       into vi_ind_atb
       from tb_atributos_pf b
      where exists (select 1
               from tb_atributos_pf ats, tb_tipos_atributos ta
              where ats.cod_ins = par_cod_ins
                and b.cod_ide_cli = ats.cod_ide_cli
                and ats.cod_ide_cli = ant_ide_cli
                and ats.cod_atributo = ta.cod_atributo
                and nvl(ats.flg_status, 'V') = 'V'
                and ats.dat_ini_vig <= PAR_PER_PRO
                and (ats.dat_fim_vig is null or
                    ats.dat_fim_vig >= PAR_PER_PRO)
                and (ta.cod_atributo = w_cod_atributo OR
                    ta.cod_atributo = 8005));
   exception
     when no_data_found then
       vi_ind_atb := 'N';
   end;

   IF vi_ind_atb = 'S' THEN
     vi_exterior := TRUE;

   END IF;

   return(vi_exterior);

 END SP_IRRF_EXT;

  ----------------------------------------------
  ---- BASE DE IR RECIDENTE EXTERIOR    --------
  ----------------------------------------------

 PROCEDURE SP_OBTEM_IRRF_EXT(ide_cli    in varchar2,
                          idx_val    in number,
                          FLG_PA     IN VARCHAR2,
                          O_VALOR    OUT NUMBER,
                          O_VALOR_13 OUT NUMBER) AS

    VI_VAL_PAGOS        NUMBER(18, 4) := 0;
    VI_ISENTO           boolean := TRUE;
    nEdad               number;
    nIni                number;
    nFin                number;
    vi_rubrica          number := 0;
    vi_val_rubrica      number := 0;
    vi_seq_vig          number := 0;
    valor_proc_especial NUMBER(18, 4) := 0;
    DAT_PERIODO_PAG     date;
    PARAMETRO_IR        CHAR(1);
  BEGIN

    vi_val_pagos := 0;
    nEdad   := 0;
    nIni    := 0;
    nFin    := 0;
    o_valor := 0;
   SP_OBTEM_BASE_IR(idx_val,PARAMETRO_IR, vi_base_ir, vi_base_ir_13);
    vi_base_bruta    := vi_base_ir;
    vi_base_bruta_13 := vi_base_ir_13;

    VI_TOT_DED := 0;
    VI_TOT_DED_RUB:=0;
    IF sp_isenta_irrf(ide_cli) <> VI_ISENTO THEN
      IF FLG_PA = 'S' THEN
        vi_val_pagos := 0;
      else
        -- Rubricas que deduzem no IR
        vi_val_pagos := SP_OBTEM_DED_PAGOS_IRRF(PARAMETRO_IR);--SP_OBTEM_DED_PAGOS;
      end if;
      IF vi_val_pagos > 0 THEN
        VI_TOT_DED_RUB  :=vi_val_pagos;
        VI_TOT_DED := VI_TOT_DED + vi_val_pagos;
      END IF;

      --- Obtem Base IRRF

      IF VI_BASE_IR > VI_TOT_DED THEN
        VI_BASE_IR := nvl(VI_BASE_IR, 0) - VI_TOT_DED;
        --- Obtem valor IR
        SP_CALCULA_IMPOSTO2(vi_base_ir, o_valor);
      END IF;

      IF VI_BASE_IR_13 > VI_TOT_DED THEN
        vi_base_ir_13 := vi_base_ir_13 - VI_TOT_DED;
        IF VI_TEM_SAIDA OR PAR_TIP_PRO = 'T' or  PARAMETRO_IR='D' THEN
          SP_CALCULA_IMPOSTO2(vi_base_ir_13, o_valor_13);
        END IF;
      END IF;
    ELSE
      IF VI_DOENCA THEN
        V_DED_IR_DOENCA := VI_BASE_IR;
        VI_BASE_IR      := 0;
      ELSE
        V_BASE_ISENCAO  := VI_BASE_IR;
        V_DED_IR_DOENCA := 0;
        VI_BASE_IR      := 0;
      END IF;
    END IF;

  END  SP_OBTEM_IRRF_EXT;
----------- Obtem Teto Calculado ----------
PROCEDURE SP_OBTEM_TETO (ide_cli         in varchar2,
                         i_cod_entidade  in number  ,
                         i_cargo         in number  ,
                         o_valor         out number ) AS

 w_poder      char(1)       := 0;
 i_valor      number(18, 4) := 0;
 w_teto_fixo  number(18, 4) := 0;
 w_teto_poder number(18, 4) := 0;
 BEGIN
    o_valor := 0;


        w_poder:='0';
        IF ((i_cargo >= 7866  AND i_cargo  <= 7878)  OR
            (i_cargo  >= 3639 AND i_cargo  <= 3653) OR
             i_cargo  = 7889 OR i_cargo  = 4318     OR
             i_cargo = 3997  OR i_cargo  = 7894     OR
             i_cargo  = 4336 OR i_cargo  = 4474     OR
             i_cargo  = 4758 OR i_cargo  = 4769     OR
             i_cargo  = 4481 OR i_cargo  = 4482     OR
             i_cargo  = 4532 OR i_cargo  = 5031     OR
             i_cargo =  4982 OR i_cargo  = 4983     OR
             i_cargo  = 3623 OR i_cargo  = 5036     OR
             i_cargo  = 4990 OR i_cargo  = 5029     OR
             i_cargo =  5030 OR i_cargo  = 5032     OR
             i_cargo  = 5035 OR i_cargo  = 5037     OR
             i_cargo  = 5038 OR i_cargo  = 5034     OR
             i_cargo  = 5033 OR i_cargo  = 4474     OR
             i_cargo  = 4532 OR i_cargo  = 4758     OR
             i_cargo  = 4769 OR i_cargo  = 4474
             ) AND i_cod_entidade  <> 5 THEN
              w_poder:='3';
            END IF;
       BEGIN
           IF  W_PODER='0' THEN
            select max(nvl(conc.teto_fixo,0)), max(nvl(para.val_elemento,0))
            into w_teto_fixo,w_teto_poder
             from  tb_concessao_beneficio conc,
                   tb_beneficiario        bene,
                   tb_det_param_estrutura para,
                   tb_entidade            enti
            where
                  bene.cod_ins         = par_cod_ins
              and bene.cod_ide_cli_ben = ide_cli
              and bene.cod_ins         = conc.cod_ins
              and bene.cod_beneficio   = conc.cod_beneficio
              and enti.cod_ins         = conc.cod_ins
              and enti.cod_entidade    = conc.cod_entidade
              and para.cod_estrutura   = 1000
              and decode(enti.cod_poder, '1', 'TETO_GOV', '2', 'SUB_DEPUT_EST', '3', 'TETO_MIN') =para.cod_param
              and para.ini_vig         <=PAR_PER_PRO
              and PAR_PER_PRO          <=nvl(para.fim_vig,PAR_PER_PRO);

          ELSE
            select max(nvl(conc.teto_fixo,0)), max(nvl(para.val_elemento,0))
            into w_teto_fixo,w_teto_poder
             from  tb_concessao_beneficio conc,
                   tb_beneficiario        bene,
                   tb_det_param_estrutura para
            where
                  bene.cod_ins         = par_cod_ins
              and bene.cod_ide_cli_ben = ide_cli
              and bene.cod_ins         = conc.cod_ins
              and bene.cod_beneficio   = conc.cod_beneficio
              and para.cod_estrutura   = 1000
              and decode(w_poder, '1', 'TETO_GOV', '2', 'SUB_DEPUT_EST', '3', 'TETO_MIN') =para.cod_param
              and para.ini_vig         <= PAR_PER_PRO
              and PAR_PER_PRO          <=nvl(para.fim_vig,PAR_PER_PRO);
          END IF;

       EXCEPTION
        WHEN OTHERS THEN
        p_coderro       := sqlcode;
        p_sub_proc_erro := 'SP_OBTEM_teto';
        p_msgerro       :=  sqlerrm;
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --       RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
        END;
      IF w_teto_poder > w_teto_fixo then
         o_valor:=  w_teto_poder;
      ELSE
         o_valor:=  w_teto_fixo;
      END IF;


 END SP_OBTEM_TETO;
-------------------------------------------
  PROCEDURE SP_VERIFICA_TIP_JUDICIAL (I_DE_CLI         IN VARCHAR2  ,
                                      I_NUM_ORD_JUD    IN NUMBER,
                                      O_TIP_ORDEM_JUD OUT VARCHAR) IS

  -- VERIFICA O TIPO DA ORDEM JUDICIAL
  BEGIN
    BEGIN
        SELECT
                TE.COD_TIP_EFEITO
                INTO O_TIP_ORDEM_JUD
                FROM TB_ORDEM_JUDICIAL        OJ ,
                     TB_ORD_JUD_PESSOA_FISICA PJ ,
                     TB_ORDEM_JUD_TIPO_EFEITO TE
        WHERE OJ.COD_INS           = PAR_COD_INS      AND
                    OJ.COD_INS     = PJ.COD_INS       AND
                    OJ.NUM_ORD_JUD = PJ.NUM_ORD_JUD   AND
                    OJ.NUM_ORD_JUD = I_NUM_ORD_JUD    AND
                  --  PJ.COD_IDE_CLI = I_DE_CLI         AND
                    OJ.COD_INS     = TE.COD_INS       AND
                    OJ.NUM_ORD_JUD = TE.NUM_ORD_JUD   AND
                    TO_DATE('01'||TO_CHAR(OJ.DAT_EFEITO,'/MM/RRRR'),'DD/MM/RRRR')<=PAR_PER_PRO  AND
                    NVL(OJ.DAT_FIM_EFEITO,TO_DATE('01/01/2099','DD/MM/YYYY'))>=PAR_PER_PRO
                    AND rownum <2;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
           O_TIP_ORDEM_JUD:='00';
      WHEN TOO_MANY_ROWS THEN
            O_TIP_ORDEM_JUD:='00';
      WHEN OTHERS THEN
        P_SUB_PROC_ERRO := 'SP_VERIFICA_ORDEM_JUDICIAL';
        P_CODERRO       := SQLCODE;
        P_MSGERRO       := 'ERRO AO OBTER O ORDEM JUDICIAL INDIV';
        INCLUI_LOG_ERRO_FOLHA(PAR_COD_INS,
                              P_CODERRO,
                              'CALCULA FOLHA',
                              SYSDATE,
                              P_MSGERRO,
                              P_SUB_PROC_ERRO,
                              I_DE_CLI  ,
                              1);
        VI_QTD_ERROS := NVL(VI_QTD_ERROS, 0) + 1;
    END;
  END SP_VERIFICA_TIP_JUDICIAL;

  FUNCTION SP_OBTEM_PERC_CARGO  RETURN NUMBER IS
    O_VALOR              NUMBER(18, 4);
    v_val_porcentual     number(18, 4) := 0;
   BEGIN

    BEGIN

        SELECT
             VAL_PORCENTUAL
        INTO v_val_porcentual
           from tb_conceito_rub_det_dominio  cf
        WHERE cf.cod_ins      = PAR_COD_INS       AND
              cf.cod_entidade = COM_ENTIDADE      AND
              cf.cod_conceito = COM_COD_CONCEITO  AND
              cf.cod_func     = COM_CARGO        AND
              (to_char(PAR_PER_PRO, 'YYYYMM') >=
                     to_char(cf.dat_ini_vig, 'YYYYMM') AND
                     to_char(PAR_PER_PRO, 'YYYYMM') <=
                     to_char(nvl(cf.DAT_FIM_VIG,
                                  to_date('01/01/2045', 'dd/mm/yyyy')),
                              'YYYYMM'))          AND
                              ROWNUM <2;
      O_VALOR := v_val_porcentual;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        O_VALOR              := 0;
        v_val_porcentual     := 0;

      WHEN OTHERS THEN
        p_sub_proc_erro := 'SP_OBTEM_PERC_CARGO';
        p_coderro       := SQLCODE;
        P_MSGERRO       := 'Erro ao obter o  PERC_CARGO';
        INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                              p_coderro,
                              'Calcula Folha',
                              sysdate,
                              p_msgerro,
                              p_sub_proc_erro,
                              BEN_IDE_CLI,
                              COM_COD_FCRUBRICA);

        --          RAISE ERRO;
        VI_QTD_ERROS := nvl(VI_QTD_ERROS, 0) + 1;
    END;
    RETURN(O_VALOR);
  END SP_OBTEM_PERC_CARGO;

 FUNCTION  SP_CALC_PORCENTUAL13(

                       I_COD_BENEFICIO VARCHAR2
                       ) Return number IS
  por_13   number(18,6) :=0;
  I_DAT_INI_REF   DATE;
  BEGIN

      I_DAT_INI_REF :=BEN_DAT_INICIO;

      /* ADICIONADO POR TONY */
      IF TO_CHAR(I_DAT_INI_REF,'YYYY') < TO_CHAR(PAR_PER_PRO,'YYYY') THEN
            I_DAT_INI_REF :=TO_DATE('01/01/' ||  TO_CHAR(PAR_PER_PRO,'YYYY'),'DD/MM/YYYY');
      END IF;

      por_13:=1;

--    IF COM_TIP_BENEFICIO!='PENSIONISTA' THEN
--        return(por_13);
--    END IF;

--    IF TO_CHAR(I_DAT_INI_REF,'YYYY') != TO_CHAR(PAR_PER_PRO,'YYYY') THEN
--          return(1);
--    ELSE
         IF TO_CHAR(I_DAT_INI_REF,'MM') != '12' THEN
            IF to_char(I_DAT_INI_REF  ,'dd') > 15   THEN
                     por_13:=  (12 - to_char(I_DAT_INI_REF,'mm') ) /*/12  */;

             ELSE
                     por_13:=  (12 - (to_char(I_DAT_INI_REF ,'mm')-1) )/* /12*/ ;
            END IF;
         ELSE
            IF to_char(I_DAT_INI_REF  ,'dd') <= 15   THEN
                por_13:=  (1/*/12*/);
            ELSE
               por_13:=0;
            END IF;
            return(por_13);
         END IF;
--     END IF;

  RETURN (por_13);


  END SP_CALC_PORCENTUAL13;

  --//NOVAS FUNCOES - 2019-03-12 - FERIAS E ATS
  FUNCTION SP_VERIFICA_ANTECIPA_FERIAS_13 Return number IS

    V_FLG_RECEBEU         number :=0;

  BEGIN

        SELECT 1
        INTO V_FLG_RECEBEU
        FROM TB_FERIAS_GOZO       G1
           , TB_FERIAS_AQUISITIVO A1
       WHERE
       PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE     = COM_ENTIDADE
         AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         AND G1.FLG_ANTECIPACAO  = 'S';
         --AND G1.FLG_ABONO        = 'S';


       IF V_FLG_RECEBEU IS NULL THEN
           V_FLG_RECEBEU:=0;
           END IF;

       RETURN (V_FLG_RECEBEU);


    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_FLG_RECEBEU := 0;
                  RETURN (V_FLG_RECEBEU);
              WHEN OTHERS THEN
                  V_FLG_RECEBEU := 0;
                  RETURN (V_FLG_RECEBEU);

  END SP_VERIFICA_ANTECIPA_FERIAS_13;

  --INI [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
  PROCEDURE SP_LIMPA_DETALHE_RET13  AS

         RDCN                   TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
        RDCD                   TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
        RDCN_CON               TB_DET_CALCULADO_ATIV_ESTRUC%rowtype; -- conceito
        RUBRICA_ANT            NUMBER;
        COD_IDE_CLI_BEN_ANT    TB_DET_CALCULADO_ATIV_ESTRUC.COD_IDE_CLI_BEN%type;
        CONT_DETALHE_TDCN      number := 0;
        CONT_DETALHE_TVAL      number := 0;
        I                      NUMBER;
        V_VAL_RUBRICA          NUMBER(18, 4) := 0;
        CONTA                  NUMBER(4) := 0;
        ind                    NUMBER := 0;


        type con_ret is table of number index by binary_integer;

        conceito_ret con_ret;

      BEGIN

        conta := tdcn.count;

        TDCA.delete;
        idx_ret13 := 0;


        FOR I IN 1 .. TDCN.COUNT LOOP

          IF TDCN(I).TIP_PROCESSO = 'T' THEN

              FOR i2 IN 1 .. vfolha.count LOOP
                rfol := vfolha(i2);
                                EXIT
                                 WHEN
                                          RFOL.COD_IDE_REL_FUNC=rdcn.COD_IDE_REL_FUNC AND
                                          RFOL.NUM_MATRICULA   =rdcn.NUM_MATRICULA    AND
                                          RFOL.COD_ENTIDADE    =rdcn.COD_ENTIDADE   ;


             END LOOP;
             ANT_ENTIDADE:=RFOL.COD_ENTIDADE;

            FOR k IN 1 .. cod_con.count LOOP

              IF tip_evento_especial(k) in ('T','A','R','L','D','G','U','P','W','B','E','H','F','N','S','5','4','7' ) THEN
                IF cod_rub(k) = TDCN(I).cod_fcrubrica THEN
                    IF cod_entidade(k) = ANT_ENTIDADE THEN
                      TDCA.extend;
                      idx_ret13 := idx_ret13 + 1;
                      TDCA(idx_ret13) := TDCN(I);
                      EXIT;
                    END IF;
                END IF;
              END IF;
            END LOOP;
          ELSE
            IF TDCN(I).TIP_PROCESSO is not null then
              TDCA.extend;
              idx_ret13 := idx_ret13 + 1;
              TDCA(idx_ret13) := TDCN(I);
            END IF;
          END IF;

        END LOOP;

        TDCN.delete;
        FOR I IN 1 .. TDCA.COUNT LOOP
          TDCN.extend;
          TDCN(I) := TDCA(I);
        END LOOP;
         idx_caln:=idx_ret13;
        TDCT.delete;
        V_VAL_RUBRICA := 0;

        -- retirar rubrica com indicador de gravacao = 'N'

        FOR i in 1 .. tdcn.count LOOP

          rdcn := tdcn(i);

          FOR j in 1 .. cod_rub.count LOOP

            IF cod_rub(j) = rdcn.cod_fcrubrica AND ind_grava_detalhe(J) = 'N' AND
               cod_entidade(j) = ANT_ENTIDADE THEN

              tdcn(i).val_rubrica := null;
              tdcn(i).cod_ins := null;

            END IF;

          END LOOP;
        END LOOP;

    END SP_LIMPA_DETALHE_RET13;
    --FIM [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO


    FUNCTION SP_VERIFICA_ANTECIPA_13 Return number IS

    V_FLG_RECEBEU         number :=0;

  BEGIN

      SELECT count(*)
        INTO V_FLG_RECEBEU
        FROM TB_HFOLHA_PAGAMENTO_DET D
      WHERE D.COD_INS           = PAR_COD_INS
        -- AND D.TIP_PROCESSO     = PAR_TIP_PRO
         AND D.PER_PROCESSO     >= TO_DATE('01/01/'||TO_CHAR(PAR_PER_PRO, 'YYYY'), 'DD/MM/YYYY')
         AND D.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND D.COD_ENTIDADE     = COM_ENTIDADE
         AND D.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND D.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         AND D.COD_FCRUBRICA IN (
             SELECT FC.COD_RUBRICA
               FROM TB_RUBRICAS        RB
                  , TB_FORMULA_CALCULO FC
              WHERE RB.COD_CONCEITO = 112
                    --RB.TIP_EVENTO_ESPECIAL IN ('D', 'G') --RUBRICA DE ANTECIPAC?O DE FERIAS
                AND FC.COD_INS      = D.COD_INS
                AND FC.COD_ENTIDADE = D.COD_ENTIDADE
                AND FC.COD_INS      = RB.COD_INS
                AND FC.COD_ENTIDADE = RB.COD_ENTIDADE
                AND FC.COD_RUBRICA  = RB.COD_RUBRICA
         );

       IF V_FLG_RECEBEU IS NULL THEN
           V_FLG_RECEBEU:=0;
           END IF;

       RETURN (V_FLG_RECEBEU);


    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_FLG_RECEBEU := 0;
                  RETURN (V_FLG_RECEBEU);
              WHEN OTHERS THEN
                  V_FLG_RECEBEU := 0;
                  RETURN (V_FLG_RECEBEU);



  END SP_VERIFICA_ANTECIPA_13;

  --INI [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO
  PROCEDURE SP_GERA_DEBITO_AD_13 AS

    vi_rubrica         number := 0;
    vi_val_rubrica     number(18, 2) := 0;

    vi_seq_vig         number := 0;
    i_perc             number(18, 6) := 0;
    i                  number := 0;
    cod_benef          number := 0;
    v_processa_rubrica boolean;
    v_data_ini_ref     date;
    rdcn_temp          TB_DET_CALCULADO_ESTRUC%rowtype;
    DAT_INICIO_PERIODO13  DATE;
    DAT_TERMIN_PERIODO13  DATE;
    EXISTE_PA             CHAR(1);
    vi_seq_vi             NUMBER;
    vi_flg_natureza       char(1);
  BEGIN



      DAT_INICIO_PERIODO13 :=add_months(to_date('01/01/'||TO_CHAR( PAR_PER_PRO,'YYYY'),'dd/mm/yyyy'),-1);
      DAT_TERMIN_PERIODO13 :=add_months(to_date('01/'||TO_CHAR( PAR_PER_PRO,'MM')||'/'||TO_CHAR( PAR_PER_PRO,'YYYY'),'dd/mm/yyyy'),-1);

      FOR i IN 1 .. vfolha.count LOOP
      rfol := vfolha(i);
         -----                                 --------

            COM_COD_IDE_CLI      :=rfol.cod_ide_cli     ;
            COM_COD_IDE_REL_FUNC :=rfol.cod_ide_rel_func;
            COM_ENTIDADE         :=rfol.cod_entidade    ;
            COM_NUM_MATRICULA    :=rfol.num_matricula   ;

            ---------- OBTEM ADIANTAMENTO 13 PAGO NO ANO.---------
                v_data_ini_ref:=NULL;
               BEGIN
                    SELECT
                     MIN(DET.DAT_INI_REF),
                     NVL(sum(

                         DECODE(DET.FLG_NATUREZA,
                                'C',
                                DET.VAL_RUBRICA,
                                DET.VAL_RUBRICA * -1)

                         ) ,0
                         )
                       INTO  v_data_ini_ref ,
                             vi_val_rubrica
                       FROM  Tb_Hfolha_Pagamento_Det det
                     WHERE DET.COD_INS = 1
                       AND DET.TIP_PROCESSO IN ('N', 'S')
                       AND DET.DAT_PAGAMENTO   >=DAT_INICIO_PERIODO13
                       AND DET.DAT_INI_REF     >= DAT_INICIO_PERIODO13
                       AND DET.DAT_INI_REF     <= DAT_TERMIN_PERIODO13
                       AND DET.COD_IDE_REL_FUNC =rfol.cod_ide_rel_func
                       AND DET.NUM_MATRICULA    =rfol.num_matricula
                       AND DET.COD_IDE_CLI      =rfol.cod_ide_cli

                       AND EXISTS
                     (SELECT 1
                              FROM  TB_RUBRICAS RR
                             WHERE RR.COD_INS     = PAR_COD_INS
                               AND RR.COD_CONCEITO =
                                   TRUNC(DET.COD_FCRUBRICA / 100)
                               AND RR.TIP_EVENTO_ESPECIAL IN ('G')
                               AND RR.COD_ENTIDADE =rfol.cod_entidade
                      );
              EXCEPTION
              WHEN   no_data_found   THEN
                     vi_rubrica        :=NULL;
                     vi_val_rubrica    :=0;
              WHEN OTHERS THEN
                p_sub_proc_erro := 'SP_ADIANTAMENTO 13';
                p_coderro       := SQLCODE;
                P_MSGERRO       := 'Erro ao obter ADIANTAMENTO 13';

            END;


            IF vi_val_rubrica > 0 THEN
             ---- Obtem Rubrica de Adiantamento ----
               BEGIN
                  SELECT COD_RUBRICA,
                         RUB.FLG_NATUREZA
                    INTO  vi_rubrica,
                          vi_flg_natureza
                    FROM TB_RUBRICAS RUB
                   WHERE RUB.COD_INS              = PAR_COD_INS
                      AND COD_ENTIDADE            =  COM_ENTIDADE
                     AND  RUB.TIP_EVENTO_ESPECIAL = 'F';
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    P_SUB_PROC_ERRO := 'SP_GRAVA_MASTER_PAG';
                    P_CODERRO       := SQLCODE;
                    P_MSGERRO       := 'ERRO AO OBTER A RUBRICA PARA GRAVAR O RESUMO';
                    vi_val_rubrica  :=0;

                  WHEN OTHERS THEN
                    P_SUB_PROC_ERRO := 'SP_GRAVA_DETALHE_RET ERRO2';
                    P_CODERRO       := SQLCODE;
                    P_MSGERRO       := SQLERRM;
                    vi_val_rubrica  :=0;
                  END;
                IF vi_val_rubrica > 0 THEN
                   tdcn.extend;
                   idx_caln        := nvl(idx_caln, 0) + 1;
                   idx_seq_detalhe := nvl(idx_seq_detalhe, 0) + 1;
                   vi_seq_vi       :=1;
                   vi_seq_vig      :=1;

                    SP_INCLUI_DETALHE_PAG(rfol.num_matricula    ,
                                          rfol.cod_ide_rel_func ,
                                          rfol.cod_entidade     ,
                                          vi_rubrica            ,
                                          vi_val_rubrica        ,
                                          vi_seq_vig            ,
                                          vi_flg_natureza
                                          );
               END IF;
               rfol := vfolha(i);
            END IF;
      END LOOP;
 END;
 --FIM [TONY] 2019-12-11 #DECIMOTERCEIROSALARIO

  FUNCTION SP_OBTEM_DIAS_FERIAS_PREV
    RETURN NUMBER IS
    V_DIAS_FERIAS_PREV  NUMBER;

    BEGIN

--    SELECT NUM_DIAS
        SELECT
        sum(G1.NUM_DIAS)
        INTO V_DIAS_FERIAS_PREV
        FROM TB_FERIAS_GOZO       G1
           , TB_FERIAS_AQUISITIVO A1
       WHERE
       (ADD_MONTHS(PAR_PER_PRO,1) BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         OR ADD_MONTHS(PAR_PER_PRO,2) BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY'))
         AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE     = COM_ENTIDADE
         AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         ---PARA N?O GERAR 2 VEZES A ANTECIPAC?O DO ABONO PARA QUEM INICIA NUM MES E TERMINA NO OUTRO
         AND G1.DAT_INICIO > = ADD_MONTHS(PAR_PER_PRO,1)
         AND G1.FLG_STATUS                 <> 'C'
         AND A1.COD_IDE_REL_FUNC IN (
         SELECT
             A2.COD_IDE_REL_FUNC
        FROM TB_FERIAS_GOZO       G2
           , TB_FERIAS_AQUISITIVO A2
       WHERE
       ADD_MONTHS(PAR_PER_PRO,1) BETWEEN TO_DATE('01/'||TO_CHAR(G2.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A2.ID_AQUISITIVO    = G2.ID_AQUISITIVO
         AND A2.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A2.COD_ENTIDADE     = COM_ENTIDADE
         AND A2.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         ---PARA N?O GERAR 2 VEZES A ANTECIPAC?O DO ABONO PARA QUEM INICIA NUM MES E TERMINA NO OUTRO
         AND G2.DAT_INICIO > = ADD_MONTHS(PAR_PER_PRO,1)
         AND G2.FLG_STATUS                 <> 'C')

         AND NOT EXISTS (
         SELECT
             1
        FROM TB_FERIAS_GOZO       G2
           , TB_FERIAS_AQUISITIVO A2
       WHERE
             G1.DAT_INICIO       = G2.DAT_FIM + 1
         AND G2.DAT_INICIO       BETWEEN PAR_PER_PRO AND LAST_DAY(PAR_PER_PRO)
         AND A2.ID_AQUISITIVO    = G2.ID_AQUISITIVO
         AND A2.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A2.COD_ENTIDADE     = COM_ENTIDADE
         AND A2.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         ---PARA N?O GERAR 2 VEZES A ANTECIPAC?O DO ABONO PARA QUEM INICIA NUM MES E TERMINA NO OUTRO
         AND G2.FLG_STATUS                 <> 'C')
         ;

      RETURN (V_DIAS_FERIAS_PREV);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_FERIAS_PREV := 0;
                  RETURN (V_DIAS_FERIAS_PREV);
              WHEN OTHERS THEN
                  V_DIAS_FERIAS_PREV := 0;
                  RETURN (V_DIAS_FERIAS_PREV);

  END SP_OBTEM_DIAS_FERIAS_PREV;


FUNCTION SP_OBTEM_DIAS_FERIAS_M
    RETURN NUMBER IS
    V_DIAS_FERIAS_MES  NUMBER;

    BEGIN

--    SELECT NUM_DIAS
        SELECT
        NVL(sum(G1.NUM_DIAS),0)
        INTO V_DIAS_FERIAS_MES
        FROM TB_FERIAS_GOZO       G1
           , TB_FERIAS_AQUISITIVO A1
       WHERE
       (PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         OR ADD_MONTHS(PAR_PER_PRO,-1) BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY'))
         AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE     = COM_ENTIDADE
         AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         ---PARA N?O GERAR 2 VEZES A ANTECIPAC?O DO ABONO PARA QUEM INICIA NUM MES E TERMINA NO OUTRO
         AND (G1.DAT_INICIO > = PAR_PER_PRO
         OR   G1.DAT_INICIO > = ADD_MONTHS(PAR_PER_PRO,-1))
         AND G1.FLG_STATUS                 <> 'C'
         AND A1.COD_IDE_REL_FUNC IN (
         SELECT
             A2.COD_IDE_REL_FUNC
        FROM TB_FERIAS_GOZO       G2
           , TB_FERIAS_AQUISITIVO A2
       WHERE
       PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G2.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A2.ID_AQUISITIVO    = G2.ID_AQUISITIVO
         AND A2.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A2.COD_ENTIDADE     = COM_ENTIDADE
         AND A2.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         ---PARA N?O GERAR 2 VEZES A ANTECIPAC?O DO ABONO PARA QUEM INICIA NUM MES E TERMINA NO OUTRO
         AND G2.DAT_INICIO > = PAR_PER_PRO
         AND G2.FLG_STATUS                 <> 'C');

      RETURN (V_DIAS_FERIAS_MES);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_FERIAS_MES := 0;
                  RETURN (V_DIAS_FERIAS_MES);
              WHEN OTHERS THEN
                  V_DIAS_FERIAS_MES := 0;
                  RETURN (V_DIAS_FERIAS_MES);

  END SP_OBTEM_DIAS_FERIAS_M;



   FUNCTION SP_MEDIA_FERIAS_PREV
    RETURN NUMBER IS
    V_MEDIA_FERIAS_PREV  NUMBER;

    BEGIN

  SELECT CASE WHEN (COUNT (DISTINCT DAT_INI_REF) < 12 OR
          COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) > 1)

         THEN
          ROUND(SUM(MM.VAL_TOT_REF)/12, 2)
         ELSE 0
           END MEDIA
         INTO V_MEDIA_FERIAS_PREV
  FROM
  (
 SELECT MONTHS_BETWEEN(TO_DATE(TO_CHAR(A1.DAT_FIM, 'MM/YYYY'), 'MM/YYYY'), TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')) as QTD_PERIODO ,
   HFD.COD_FCRUBRICA,
      CASE WHEN (TO_CHAR(G1.DAT_INICIO, 'DD')) < 16
     THEN
   HFD.DAT_INI_REF
     ELSE
       (ADD_MONTHS(HFD.DAT_INI_REF,1))
    END DAT_INI_REF,
   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VAL_TOT_REF
      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
    , TB_FERIAS_GOZO           G1
    , TB_FERIAS_AQUISITIVO A1
       WHERE
       ADD_MONTHS(PAR_PER_PRO,1) BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A1.ID_AQUISITIVO                        = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI                          = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE                         = COM_ENTIDADE
         AND A1.NUM_MATRICULA                        = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC                     = COM_COD_IDE_REL_FUNC
         AND HFD.COD_INS                             = 1
         AND HFD.COD_IDE_CLI                         = A1.COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = A1.COD_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = A1.COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = A1.NUM_MATRICULA
         AND
         (
         (TO_CHAR(A1.DAT_INICIO, 'DD') <= '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY'))
         OR
         (TO_CHAR(A1.DAT_INICIO, 'DD') > '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,1), 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,12), 'MM/YYYY'), 'MM/YYYY'))
         )

         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))
                               )
           OR HFD.COD_FCRUBRICA = 0)
         AND NOT EXISTS
             (
             SELECT 1 FROM TB_FERIAS_GOZO       G11
             WHERE G11.ID_AQUISITIVO            = G1.ID_AQUISITIVO
             AND G11.ID_GOZO                    <> G1.ID_GOZO
             AND G11.DAT_INICIO                 < G1.DAT_INICIO
             )

     GROUP BY A1.DAT_FIM, A1.DAT_INICIO,  HFD.COD_FCRUBRICA, HFD.DAT_INI_REF, G1.DAT_INICIO
     )MM GROUP BY QTD_PERIODO;

     IF V_MEDIA_FERIAS_PREV IS NULL THEN
           V_MEDIA_FERIAS_PREV:=0;
           END IF;


      RETURN (V_MEDIA_FERIAS_PREV);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_MEDIA_FERIAS_PREV := 0;
                  RETURN (V_MEDIA_FERIAS_PREV);
              WHEN OTHERS THEN
                  V_MEDIA_FERIAS_PREV := 0;
                  RETURN (V_MEDIA_FERIAS_PREV);

  END SP_MEDIA_FERIAS_PREV;


     ----PARA RETORNAR O VALOR DA MEDIA DO PERIODO AQUISITIVO PAGTO FERIAS NO MES
FUNCTION SP_MEDIA_FERIAS_MES
    RETURN NUMBER IS
    V_MEDIA_FERIAS_MES  NUMBER;

    BEGIN

  SELECT CASE WHEN (COUNT (DISTINCT DAT_INI_REF) < 12 OR
          COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) > 1)

         THEN
          ROUND(SUM(MM.VAL_TOT_REF)/QTD_PERIODO, 2)
         ELSE 0
           END MEDIA
         INTO V_MEDIA_FERIAS_MES
  FROM
  (
  SELECT MONTHS_BETWEEN(TO_DATE(TO_CHAR(A1.DAT_FIM, 'MM/YYYY'), 'MM/YYYY'), TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')) as QTD_PERIODO ,
   HFD.COD_FCRUBRICA, HFD.DAT_INI_REF,
   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VAL_TOT_REF
      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
    , TB_FERIAS_GOZO           G1
    , TB_FERIAS_AQUISITIVO A1
       WHERE
       PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A1.ID_AQUISITIVO                        = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI                          = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE                         = COM_ENTIDADE
         AND A1.NUM_MATRICULA                        = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC                     = COM_COD_IDE_REL_FUNC
         AND HFD.COD_INS                             = 1
         AND HFD.COD_IDE_CLI                         = A1.COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = A1.COD_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = A1.COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = A1.NUM_MATRICULA
         AND
         (
         (TO_CHAR(A1.DAT_INICIO, 'DD') <= '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY'))
         OR
         (TO_CHAR(A1.DAT_INICIO, 'DD') > '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,1), 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,12), 'MM/YYYY'), 'MM/YYYY'))
         )


        /* AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY')*/
         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_MES'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
          OR HFD.COD_FCRUBRICA = 0)
         AND NOT EXISTS
             (
             SELECT 1 FROM TB_FERIAS_GOZO       G11
             WHERE G11.ID_AQUISITIVO            = G1.ID_AQUISITIVO
             AND G11.ID_GOZO                    <> G1.ID_GOZO
             AND G11.DAT_INICIO                 < G1.DAT_INICIO
             )

     GROUP BY A1.DAT_FIM, A1.DAT_INICIO,  HFD.COD_FCRUBRICA, HFD.DAT_INI_REF
     )MM GROUP BY QTD_PERIODO;

     IF V_MEDIA_FERIAS_MES IS NULL THEN
           V_MEDIA_FERIAS_MES:=0;
           END IF;

      RETURN (V_MEDIA_FERIAS_MES);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_MEDIA_FERIAS_MES := 0;
                  RETURN (V_MEDIA_FERIAS_MES);
              WHEN OTHERS THEN
                  V_MEDIA_FERIAS_MES := 0;
                  RETURN (V_MEDIA_FERIAS_MES);

  END SP_MEDIA_FERIAS_MES;



  FUNCTION SP_RUB_VAR_FERIAS_PREV
    RETURN NUMBER IS
    V_RUB_VAR_FERIAS_PREV  NUMBER;

    BEGIN

    SELECT
          --SUM(YY.COD_FG) AS COD_FG
          YY.COD_FG
          INTO V_RUB_VAR_FERIAS_PREV
    FROM
    (

  SELECT
         CASE WHEN (COUNT (DISTINCT DAT_INI_REF) = 12 AND COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) = 1
                 AND
                     (
                     (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) = TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >= PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     ) = TRUNC(MM.COD_FCRUBRICA/100)

                     OR
                     (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) != TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >= PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     ) IS NULL
                     )
                     )


         THEN  TRUNC(MM.COD_FCRUBRICA/100)

         WHEN (COUNT (DISTINCT DAT_INI_REF) = 12 AND COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) = 1
                 AND
                     (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >=PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     ) != TRUNC(MM.COD_FCRUBRICA/100)

                     AND (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100)!=TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >=PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     )IS NOT NULL)


         THEN
                 NVL((
                     SELECT TRUNC(MIN(CPAG.COD_FCRUBRICA)/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) != TRUNC(MM.COD_FCRUBRICA/100)
                     AND COD_FCRUBRICA IN
                                         (
                                         SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                         WHERE CD.COD_INS = 1
                                         AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                         AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                         AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                         AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                         AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                         AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                         )
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >=PAR_PER_PRO)
                     ), '0')

         --Yumi em 19/07/2018: Ajustado para considerar como mes 12, cheio, casos que tiveram a rubrica por todo o periodo
         ---e sair?o de ferias no mesmo mes que vence o periodo aquisitivo ou no mes seguinte.
         WHEN (COUNT (DISTINCT DAT_INI_REF) ) in (10, 11)  AND COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) = 1
           AND
           (
           (TO_CHAR(DAT_FIM, 'DD') > 15
           AND (MONTHS_BETWEEN (TO_DATE('01/'||to_CHAR(DAT_FIM , 'MM/YYYY'), 'DD/MM/YYYY') ,  PAR_PER_PRO) +1)  = (12 - (COUNT (DISTINCT DAT_INI_REF)))
           )
           OR
           (TO_CHAR(DAT_FIM, 'DD') <= 15
           AND (MONTHS_BETWEEN (TO_DATE('01/'||to_CHAR(ADD_MONTHS(DAT_FIM, -1) , 'MM/YYYY'), 'DD/MM/YYYY') ,  PAR_PER_PRO) +1)  = (12- (COUNT (DISTINCT DAT_INI_REF)))
           )
           )
           AND
           (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) = TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= to_DATE('01/07/2018', 'dd/mm/yyyy')
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >= to_DATE('01/07/2018', 'dd/mm/yyyy'))
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = 4500
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(to_DATE('01/07/2018', 'dd/mm/yyyy'),1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(to_DATE('01/07/2018', 'dd/mm/yyyy'),1))

                                             )
                     ) = TRUNC(MM.COD_FCRUBRICA/100)

         THEN  TRUNC(MM.COD_FCRUBRICA/100)


         ELSE 0
           END COD_FG



  FROM
  (
 SELECT
   HFD.COD_ENTIDADE, HFD.COD_IDE_CLI, HFD.COD_IDE_REL_FUNC, HFD.NUM_MATRICULA, A1.DAT_INICIO, A1.DAT_FIM,
   MONTHS_BETWEEN(TO_DATE(TO_CHAR(A1.DAT_FIM, 'MM/YYYY'), 'MM/YYYY'), TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')) as QTD_PERIODO ,
   HFD.COD_FCRUBRICA, HFD.DAT_INI_REF,
   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VAL_TOT_REF
      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
    , TB_FERIAS_GOZO           G1
    , TB_FERIAS_AQUISITIVO A1
       WHERE
       ADD_MONTHS(PAR_PER_PRO,1) BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A1.ID_AQUISITIVO                        = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI                          = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE                         = COM_ENTIDADE
         AND A1.NUM_MATRICULA                        = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC                     = COM_COD_IDE_REL_FUNC
         AND HFD.COD_INS                             = 1
         AND HFD.COD_IDE_CLI                         = A1.COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = A1.COD_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = A1.COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = A1.NUM_MATRICULA
         ---Yumi em 19/07/2018: Ajustado para considerar os periodos de referencia de acordo com a regra do dia 15
         /*AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY')*/
         AND
         (
         (TO_CHAR(A1.DAT_INICIO, 'DD') <= '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY'))
         OR
         (TO_CHAR(A1.DAT_INICIO, 'DD') > '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,1), 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,12), 'MM/YYYY'), 'MM/YYYY'))
         )

         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))
                               )
           OR HFD.COD_FCRUBRICA = 0)
         AND NOT EXISTS
             (
             SELECT 1 FROM TB_FERIAS_GOZO       G11
             WHERE G11.ID_AQUISITIVO            = G1.ID_AQUISITIVO
             AND G11.ID_GOZO                    <> G1.ID_GOZO
             AND G11.DAT_INICIO                 < G1.DAT_INICIO
             )

     GROUP BY
     HFD.COD_ENTIDADE, HFD.COD_IDE_CLI, HFD.COD_IDE_REL_FUNC, HFD.NUM_MATRICULA,
     A1.DAT_FIM, A1.DAT_INICIO,  HFD.COD_FCRUBRICA, HFD.DAT_INI_REF
     )MM
     GROUP BY MM.COD_ENTIDADE, MM.COD_IDE_CLI, MM.COD_IDE_REL_FUNC, MM.NUM_MATRICULA, MM.DAT_FIM, TRUNC(MM.COD_FCRUBRICA/100)
     )YY;

     IF V_RUB_VAR_FERIAS_PREV IS NULL THEN
           V_RUB_VAR_FERIAS_PREV:=0;
           END IF;


      RETURN (V_RUB_VAR_FERIAS_PREV);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_RUB_VAR_FERIAS_PREV := 0;
                  RETURN (V_RUB_VAR_FERIAS_PREV);
              WHEN OTHERS THEN
                  V_RUB_VAR_FERIAS_PREV := 0;
                  RETURN (V_RUB_VAR_FERIAS_PREV);

  END SP_RUB_VAR_FERIAS_PREV;


    FUNCTION SP_RUB_VAR_FERIAS_MES
    RETURN NUMBER IS
    V_RUB_VAR_FERIAS_MES  NUMBER;

    BEGIN

  SELECT
         CASE WHEN (COUNT (DISTINCT DAT_INI_REF) = 12 AND COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) = 1
                 AND
                     (
                     (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) = TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >= PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     ) = TRUNC(MM.COD_FCRUBRICA/100)

                     OR
                     (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) != TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >= PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     ) IS NULL
                     )
                     )


         THEN  TRUNC(MM.COD_FCRUBRICA/100)

         WHEN (COUNT (DISTINCT DAT_INI_REF) = 12 AND COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) = 1
                 AND
                     (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >=PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     ) != TRUNC(MM.COD_FCRUBRICA/100)

                     AND (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100)!=TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >=PAR_PER_PRO)
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                             )
                     )IS NOT NULL)


         THEN
                 NVL((
                     SELECT TRUNC(MIN(CPAG.COD_FCRUBRICA)/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) != TRUNC(MM.COD_FCRUBRICA/100)
                     AND COD_FCRUBRICA IN
                                         (
                                         SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                         WHERE CD.COD_INS = 1
                                         AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                         AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                         AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                         AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                                         AND CD.DAT_INI_VIG < = ADD_MONTHS(PAR_PER_PRO,1)
                                         AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(PAR_PER_PRO,1))

                                         )
                     AND CPAG.DAT_INI_VIG <= PAR_PER_PRO
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >=PAR_PER_PRO)
                     ), '0')
         --Yumi em 19/07/2018: Ajustado para considerar como mes 12, cheio, casos que tiveram a rubrica por todo o periodo
         ---e sair?o de ferias no mesmo mes que vence o periodo aquisitivo ou no mes seguinte.
         WHEN (COUNT (DISTINCT DAT_INI_REF) ) = 10  AND COUNT(DISTINCT TRUNC(COD_FCRUBRICA/100)) = 1
           AND
           (
           (TO_CHAR(DAT_FIM, 'DD') > 15
           AND (MONTHS_BETWEEN (TO_DATE('01/'||to_CHAR(DAT_FIM , 'MM/YYYY'), 'DD/MM/YYYY') ,  PAR_PER_PRO) +1)  = (12 - (COUNT (DISTINCT DAT_INI_REF)))
           )
           OR
           (TO_CHAR(DAT_FIM, 'DD') <= 15
           AND (MONTHS_BETWEEN (TO_DATE('01/'||to_CHAR(ADD_MONTHS(DAT_FIM, -1) , 'MM/YYYY'), 'DD/MM/YYYY') ,  PAR_PER_PRO) +1)  = (12- (COUNT (DISTINCT DAT_INI_REF)))
           )
           )
           AND
           (
                     SELECT TRUNC(CPAG.COD_FCRUBRICA/100) FROM TB_COMPOSICAO_PAG CPAG
                     WHERE CPAG.COD_INS                = 1
                     AND CPAG.COD_ENTIDADE             = MM.COD_ENTIDADE
                     AND CPAG.COD_IDE_CLI              = MM.COD_IDE_CLI
                     AND CPAG.COD_IDE_REL_FUNC         = MM.COD_IDE_REL_FUNC
                     AND CPAG.NUM_MATRICULA            = MM.NUM_MATRICULA
                     AND TRUNC(CPAG.COD_FCRUBRICA/100) = TRUNC(MM.COD_FCRUBRICA/100)
                     AND CPAG.DAT_INI_VIG <= to_DATE('01/07/2018', 'dd/mm/yyyy')
                     AND (CPAG.DAT_FIM_VIG IS NULL OR CPAG.DAT_FIM_VIG >= to_DATE('01/07/2018', 'dd/mm/yyyy'))
                     AND CPAG.COD_FCRUBRICA IN
                                            (
                                             SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                                             WHERE CD.COD_INS = 1
                                             AND CD.COD_ENTIDADE_COMPOSTA  = CPAG.COD_ENTIDADE
                                             AND CD.COD_ENTIDADE_COMPOE    = CPAG.COD_ENTIDADE
                                             AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_PREV'
                                             AND CD.COD_FCRUBRICA_COMPOSTA = 4500
                                             AND CD.DAT_INI_VIG < = ADD_MONTHS(to_DATE('01/07/2018', 'dd/mm/yyyy'),1)
                                             AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= ADD_MONTHS(to_DATE('01/07/2018', 'dd/mm/yyyy'),1))

                                             )
                     ) = TRUNC(MM.COD_FCRUBRICA/100)

         THEN  TRUNC(MM.COD_FCRUBRICA/100)

         ELSE 0
           END COD_FG


         INTO V_RUB_VAR_FERIAS_MES
  FROM
  (
 SELECT
   HFD.COD_ENTIDADE, HFD.COD_IDE_CLI, HFD.COD_IDE_REL_FUNC, HFD.NUM_MATRICULA, A1.DAT_INICIO, A1.DAT_FIM,
   MONTHS_BETWEEN(TO_DATE(TO_CHAR(A1.DAT_FIM, 'MM/YYYY'), 'MM/YYYY'), TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')) as QTD_PERIODO ,
   HFD.COD_FCRUBRICA, HFD.DAT_INI_REF,
   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VAL_TOT_REF
      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
    , TB_FERIAS_GOZO           G1
    , TB_FERIAS_AQUISITIVO A1
       WHERE
       PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A1.ID_AQUISITIVO                        = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI                          = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE                         = COM_ENTIDADE
         AND A1.NUM_MATRICULA                        = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC                     = COM_COD_IDE_REL_FUNC
         AND HFD.COD_INS                             = 1
         AND HFD.COD_IDE_CLI                         = A1.COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = A1.COD_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = A1.COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = A1.NUM_MATRICULA

          ---Yumi em 19/07/2018: Ajustado para considerar os periodos de referencia de acordo com a regra do dia 15
         /*AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY')*/
         AND
         (
         (TO_CHAR(A1.DAT_INICIO, 'DD') <= '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(A1.DAT_INICIO, 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,11), 'MM/YYYY'), 'MM/YYYY'))
         OR
         (TO_CHAR(A1.DAT_INICIO, 'DD') > '15'
         AND TO_DATE(TO_CHAR(HFD.DAT_INI_REF, 'MM/YYYY'), 'MM/YYYY') BETWEEN TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,1), 'MM/YYYY'), 'MM/YYYY')
                                                     AND TO_DATE(TO_CHAR(ADD_MONTHS(A1.DAT_INICIO,12), 'MM/YYYY'), 'MM/YYYY'))
         )

         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'MEDIA_FERIAS_MES'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
           OR HFD.COD_FCRUBRICA = 0)
         AND NOT EXISTS
             (
             SELECT 1 FROM TB_FERIAS_GOZO       G11
             WHERE G11.ID_AQUISITIVO            = G1.ID_AQUISITIVO
             AND G11.ID_GOZO                    <> G1.ID_GOZO
             AND G11.DAT_INICIO                 < G1.DAT_INICIO
             )

     GROUP BY
     HFD.COD_ENTIDADE, HFD.COD_IDE_CLI, HFD.COD_IDE_REL_FUNC, HFD.NUM_MATRICULA,
     A1.DAT_FIM, A1.DAT_INICIO,  HFD.COD_FCRUBRICA, HFD.DAT_INI_REF
     )MM
     GROUP BY MM.COD_ENTIDADE, MM.COD_IDE_CLI, MM.COD_IDE_REL_FUNC, MM.NUM_MATRICULA, MM.DAT_FIM, TRUNC(MM.COD_FCRUBRICA/100)
     ;

     IF V_RUB_VAR_FERIAS_MES IS NULL THEN
           V_RUB_VAR_FERIAS_MES:=0;
           END IF;


      RETURN (V_RUB_VAR_FERIAS_MES);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_RUB_VAR_FERIAS_MES := 0;
                  RETURN (V_RUB_VAR_FERIAS_MES);
              WHEN OTHERS THEN
                  V_RUB_VAR_FERIAS_MES := 0;
                  RETURN (V_RUB_VAR_FERIAS_MES);

  END SP_RUB_VAR_FERIAS_MES;



 FUNCTION SP_ANTECIPA_FERIAS_13_PROX Return number IS

    V_POSSUI_ANT        number ;

    BEGIN

    SELECT 1
    INTO V_POSSUI_ANT
    FROM TB_FERIAS_GOZO       G1
       , TB_FERIAS_AQUISITIVO A1
   WHERE
   ADD_MONTHS(PAR_PER_PRO,1)  BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
   TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
     AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
     AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
     AND A1.COD_ENTIDADE     = COM_ENTIDADE
     AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
     AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
     AND G1.FLG_ANTECIPACAO  = 'S';
     --AND G1.FLG_ABONO = 'S';
     IF V_POSSUI_ANT IS NULL THEN
       V_POSSUI_ANT:=0;
       END IF;

   RETURN (V_POSSUI_ANT);


EXCEPTION WHEN NO_DATA_FOUND THEN
              V_POSSUI_ANT := 0;
              RETURN (V_POSSUI_ANT);
          WHEN OTHERS THEN
              V_POSSUI_ANT := 0;
              RETURN (V_POSSUI_ANT);

END SP_ANTECIPA_FERIAS_13_PROX;


FUNCTION SP_OBTEM_DIAS_FERIAS_PROP_RESC
    RETURN NUMBER IS
    V_DIAS_FERIAS_PROP_RESC  NUMBER;
  -- alterado 22/05/2023 para considerar o ultimo periodo aquisitivos n?completo
    BEGIN


             SELECT (TE.DIAS_FERIAS *  (TE.MESES/12)) AS DIAS_FERIAS_PROPORCIONAIS
              INTO V_DIAS_FERIAS_PROP_RESC

             FROM
             (
              SELECT YU.DIAS_PER_AQUI,
                      (MONTHS_BETWEEN(YU.DAT_FIM, YU.DAT_INICIO))+1 AS MESES ,

                     --YU.MESES,
                     YU.DIAS_FALTAS,
                  CASE WHEN DIAS_FALTAS <=
                                          (
                                          SELECT MAX(MAX_FALTAS) FROM TB_PARAM_FERIAS_FALTA PFF1
                                          WHERE PFF1.COD_INS = 1
                                          AND PFF1.DAT_FIM_VIG IS NULL
                                          AND PFF1.FLG_STATUS = 'V'
                                          )

                      THEN
                          (
                          SELECT PFF.DIAS_FERIAS
                          FROM TB_PARAM_FERIAS_FALTA PFF
                          WHERE PFF.COD_INS = 1
                          AND YU.DIAS_FALTAS > = PFF.MIN_FALTAS
                          AND YU.DIAS_FALTAS <= PFF.MAX_FALTAS
                          AND PFF.DAT_FIM_VIG IS NULL
                          AND PFF.FLG_STATUS = 'V'
                          )

                          ELSE 0
                            END AS DIAS_FERIAS



              FROM
              (
              SELECT
                  ((RF.DAT_FIM_EXERC - FA.DAT_INICIO)+1) AS DIAS_PER_AQUI,

                  CASE WHEN
                    TO_CHAR(FA.DAT_INICIO, 'DD') <= 15 THEN
                    TO_DATE ('01/'||TO_CHAR(FA.DAT_INICIO,'MM/YYYY'), 'DD/MM/YYYY')
                    ELSE TO_DATE ('01/'||TO_CHAR(ADD_MONTHS(FA.DAT_INICIO, 1),'MM/YYYY'), 'DD/MM/YYYY')
                      END DAT_INICIO,

                  CASE WHEN
                    TO_CHAR(RF.DAT_FIM_EXERC, 'DD') >= 16 THEN
                    TO_DATE ('01/'||TO_CHAR(RF.DAT_FIM_EXERC,'MM/YYYY'), 'DD/MM/YYYY')
                    ELSE TO_DATE ('01/'||TO_CHAR(ADD_MONTHS(RF.DAT_FIM_EXERC, -1),'MM/YYYY'), 'DD/MM/YYYY')
                      END DAT_FIM,

                  /*TRUNC(((RF.DAT_FIM_EXERC - FA.DAT_INICIO)+1)/30) AS MESES,*/

                  NVL((
                  SELECT
                  SUM(CASE
                  WHEN
                    AFA.DAT_INI_AFAST < FA.DAT_INICIO
                AND AFA.DAT_RET_PREV <= RF.DAT_FIM_EXERC
                  THEN
                    (AFA.DAT_RET_PREV - FA.DAT_INICIO)+1

                  WHEN
                    AFA.DAT_INI_AFAST < FA.DAT_INICIO
                AND AFA.DAT_RET_PREV > RF.DAT_FIM_EXERC
                  THEN
                    (RF.DAT_FIM_EXERC - FA.DAT_INICIO)+1

                  WHEN
                    AFA.DAT_INI_AFAST >= FA.DAT_INICIO
                AND AFA.DAT_RET_PREV > RF.DAT_FIM_EXERC
                  THEN
                    (RF.DAT_FIM_EXERC - AFA.DAT_INI_AFAST)+1

                  WHEN
                    AFA.DAT_INI_AFAST >= FA.DAT_INICIO
                AND AFA.DAT_RET_PREV <= RF.DAT_FIM_EXERC
                  THEN
                    (AFA.DAT_RET_PREV - AFA.DAT_INI_AFAST)+1

                   END) DIAS_AFAST

                  FROM TB_AFASTAMENTO AFA,
                       TB_MOTIVO_AFASTAMENTO MA
                  WHERE AFA.COD_INS         = 1
                  AND AFA.COD_IDE_CLI       = FA.COD_IDE_CLI
                  AND AFA.COD_ENTIDADE      = FA.COD_ENTIDADE
                  AND AFA.COD_IDE_REL_FUNC  = FA.COD_IDE_REL_FUNC
                  AND AFA.NUM_MATRICULA     = FA.NUM_MATRICULA
                  AND AFA.COD_MOT_AFAST     = MA.COD_MOT_AFAST
                  AND MA.PERD_DIREITO_FERIAS = 'S'
                  AND (
                      (AFA.DAT_INI_AFAST <= FA.DAT_INICIO AND
                         AFA.DAT_RET_PREV >= FA.DAT_INICIO) OR

                      (AFA.DAT_INI_AFAST >= FA.DAT_INICIO AND
                         AFA.DAT_INI_AFAST <= RF.DAT_FIM_EXERC )
                       )
                  ),0)AS DIAS_FALTAS

             FROM TB_FERIAS_AQUISITIVO FA,
                  TB_RELACAO_FUNCIONAL RF
            WHERE FA.COD_INS          = PAR_COD_INS
              AND FA.COD_IDE_CLI      = COM_COD_IDE_CLI
              AND FA.COD_ENTIDADE     = COM_ENTIDADE
              AND FA.NUM_MATRICULA    = COM_NUM_MATRICULA
              AND FA.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
              --Yumi em 10/08/2018: acrescentado a data de fim futura: chamado 49053
              AND (FA.DAT_FIM IS NULL OR FA.DAT_FIM >=RF.DAT_FIM_EXERC)
              AND FA.DAT_INICIO       <= RF.DAT_FIM_EXERC
              AND RF.COD_INS          = FA.COD_INS
              AND RF.COD_ENTIDADE     = FA.COD_ENTIDADE
              AND RF.COD_IDE_REL_FUNC = FA.COD_IDE_REL_FUNC
              AND RF.NUM_MATRICULA    = FA.NUM_MATRICULA
              AND RF.COD_IDE_CLI      = FA.COD_IDE_CLI
              ) YU
              )TE;



      RETURN (V_DIAS_FERIAS_PROP_RESC);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_FERIAS_PROP_RESC := 0;
                  RETURN (V_DIAS_FERIAS_PROP_RESC );
              WHEN OTHERS THEN
                  V_DIAS_FERIAS_PROP_RESC  := 0;
                  RETURN (V_DIAS_FERIAS_PROP_RESC );

  END SP_OBTEM_DIAS_FERIAS_PROP_RESC;

FUNCTION SP_OBTEM_QTD_DIAS_FERIAS
    RETURN NUMBER IS
    V_DIAS_FERIAS  NUMBER;

    BEGIN

--    SELECT NUM_DIAS
       SELECT NVL(SUM
((CASE WHEN (G1.DAT_INICIO <= PAR_PER_PRO)
           AND (G1.DAT_FIM <= ADD_MONTHS(PAR_PER_PRO,1)-1)
            THEN (G1.DAT_FIM - PAR_PER_PRO)

       WHEN (G1.DAT_INICIO <= PAR_PER_PRO) AND
            ((G1.DAT_FIM > ADD_MONTHS(PAR_PER_PRO,1)-1)) AND (TO_CHAR(G1.DAT_INICIO, 'MM') != '02' )
                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (G1.DAT_FIM > ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_INICIO, 'MM') != '02'))
                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - G1.DAT_INICIO

      WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (G1.DAT_FIM > ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_INICIO, 'MM') = '02'))
                      THEN
      LAST_DAY(PAR_PER_PRO) - G1.DAT_INICIO


       WHEN (G1.DAT_INICIO <= PAR_PER_PRO) AND
            (
            ((G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1)
                AND TO_CHAR(G1.DAT_FIM,'DD') IN ('30','31')) OR

            (G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1
                AND (TO_CHAR(G1.DAT_FIM, 'MM') = '02' AND TO_CHAR(G1.DAT_FIM,'DD') IN ('28', '29')))
             )

                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (((G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1) AND TO_CHAR(G1.DAT_FIM,'DD') IN ('30','31')) OR
            (G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_FIM, 'MM') != '02' AND TO_CHAR(G1.DAT_FIM,'DD') IN ('28', '29'))))
                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - G1.DAT_INICIO

      WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (((G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1) AND TO_CHAR(G1.DAT_FIM,'DD') IN ('30','31')) OR
            (G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_FIM, 'MM') = '02' AND TO_CHAR(G1.DAT_FIM,'DD') IN ('28', '29'))))
                      THEN
      LAST_DAY(PAR_PER_PRO) - G1.DAT_INICIO

      ELSE  (G1.DAT_FIM - G1.DAT_INICIO) END)+1),0)
        INTO V_DIAS_FERIAS
        FROM TB_FERIAS_GOZO       G1
           , TB_FERIAS_AQUISITIVO A1
       WHERE
       PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
       ---PAR_PER_PRO BETWEEN G1.DAT_INICIO AND G1.DAT_FIM
         AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE     = COM_ENTIDADE
         AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         AND G1.FLG_STATUS       != 'C';

      IF V_DIAS_FERIAS IS NULL THEN
           V_DIAS_FERIAS:=0;
           END IF;

      RETURN (V_DIAS_FERIAS);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_FERIAS := 0;
                  RETURN (V_DIAS_FERIAS);
              WHEN OTHERS THEN
                  V_DIAS_FERIAS := 0;
                  RETURN (V_DIAS_FERIAS);

  END SP_OBTEM_QTD_DIAS_FERIAS;

FUNCTION SP_VALOR_PAGO_FOL
    RETURN NUMBER IS
    V_VALOR_PAGO_FOL  NUMBER;

    BEGIN

  SELECT

   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VALOR_PAGO

      INTO V_VALOR_PAGO_FOL

      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
       WHERE
         HFD.PER_PROCESSO >= TO_DATE('01/01/'||to_char( PAR_PER_PRO ,'YYYY'),'DD/MM/YYYY')
         AND HFD.COD_INS                             = PAR_COD_INS
         AND HFD.COD_IDE_CLI                         = COM_COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = COM_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = COM_COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = COM_NUM_MATRICULA
         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'VALOR_PAGO_FOLHA'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
        OR HFD.COD_FCRUBRICA = 0)
                               ;

       IF V_VALOR_PAGO_FOL IS NULL THEN
           V_VALOR_PAGO_FOL:=0;
           END IF;

      RETURN (V_VALOR_PAGO_FOL);

     EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_VALOR_PAGO_FOL := 0;
                  RETURN (V_VALOR_PAGO_FOL);
              WHEN OTHERS THEN
                  V_VALOR_PAGO_FOL := 0;
                  RETURN (V_VALOR_PAGO_FOL);

  END SP_VALOR_PAGO_FOL;


FUNCTION SP_AQUISITIVO_COMPLETO
    RETURN NUMBER IS
    V_AQUISITIVO_COMPLETO  NUMBER;

    BEGIN

  SELECT DISTINCT  '1'

      INTO V_AQUISITIVO_COMPLETO

                     FROM TB_FERIAS_AQUISITIVO FA,
                          TB_RELACAO_FUNCIONAL RF
                      WHERE  FA.COD_INS          = PAR_COD_INS
                      AND FA.COD_IDE_CLI         = COM_COD_IDE_CLI
                      AND FA.COD_ENTIDADE        = COM_ENTIDADE
                      AND FA.NUM_MATRICULA       = COM_NUM_MATRICULA
                      AND FA.COD_IDE_REL_FUNC    = COM_COD_IDE_REL_FUNC
                      AND FA.DAT_FIM             IS NOT NULL
                      AND RF.COD_INS             = FA.COD_INS
                      AND RF.NUM_MATRICULA       = FA.NUM_MATRICULA
                      AND RF.COD_IDE_CLI         = FA.COD_IDE_CLI
                      AND RF.COD_IDE_REL_FUNC    = FA.COD_IDE_REL_FUNC
                      AND RF.COD_ENTIDADE        = FA.COD_ENTIDADE
                      AND FA.DAT_INICIO          <= RF.DAT_FIM_EXERC
                      AND FA.DAT_FIM             <= RF.DAT_FIM_EXERC
                      AND FA.DAT_FIM             < RF.DAT_FIM_EXERC
                      AND FA.NUM_SALDO           > 0;

       IF V_AQUISITIVO_COMPLETO IS NULL THEN
           V_AQUISITIVO_COMPLETO:=0;
           END IF;

      RETURN (V_AQUISITIVO_COMPLETO);

     EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_AQUISITIVO_COMPLETO := 0;
                  RETURN (V_AQUISITIVO_COMPLETO);
              WHEN OTHERS THEN
                  V_AQUISITIVO_COMPLETO := 0;
                  RETURN (V_AQUISITIVO_COMPLETO);

  END SP_AQUISITIVO_COMPLETO;

  FUNCTION SP_QTDE_AQUISITIVO_COMPLETO
    RETURN NUMBER IS
    V_AQUISITIVO_COMPLETO  NUMBER;

    BEGIN

  SELECT COUNT(*)

      INTO V_AQUISITIVO_COMPLETO

                     FROM TB_FERIAS_AQUISITIVO FA,
                          TB_RELACAO_FUNCIONAL RF
                      WHERE  FA.COD_INS          = PAR_COD_INS
                      AND FA.COD_IDE_CLI         = COM_COD_IDE_CLI
                      AND FA.COD_ENTIDADE        = COM_ENTIDADE
                      AND FA.NUM_MATRICULA       = COM_NUM_MATRICULA
                      AND FA.COD_IDE_REL_FUNC    = COM_COD_IDE_REL_FUNC
                      AND FA.DAT_FIM             IS NOT NULL
                      AND RF.COD_INS             = FA.COD_INS
                      AND RF.NUM_MATRICULA       = FA.NUM_MATRICULA
                      AND RF.COD_IDE_CLI         = FA.COD_IDE_CLI
                      AND RF.COD_IDE_REL_FUNC    = FA.COD_IDE_REL_FUNC
                      AND RF.COD_ENTIDADE        = FA.COD_ENTIDADE
                      AND FA.DAT_INICIO          <= RF.DAT_FIM_EXERC
                      AND FA.DAT_FIM             <= RF.DAT_FIM_EXERC
                      AND FA.DAT_FIM             < RF.DAT_FIM_EXERC
                      AND FA.NUM_SALDO           > 0;

       IF V_AQUISITIVO_COMPLETO IS NULL THEN
           V_AQUISITIVO_COMPLETO:=0;
           END IF;

      RETURN (V_AQUISITIVO_COMPLETO);

     EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_AQUISITIVO_COMPLETO := 0;
                  RETURN (V_AQUISITIVO_COMPLETO);
              WHEN OTHERS THEN
                  V_AQUISITIVO_COMPLETO := 0;
                  RETURN (V_AQUISITIVO_COMPLETO);

  END SP_QTDE_AQUISITIVO_COMPLETO;

  FUNCTION SP_DIAS_AQUISITIVO_COMPLETO
    RETURN NUMBER IS
    V_AQUISITIVO_COMPLETO  NUMBER;

    BEGIN

  SELECT SUM(FA.NUM_SALDO)

         INTO V_AQUISITIVO_COMPLETO

                     FROM TB_FERIAS_AQUISITIVO FA,
                          TB_RELACAO_FUNCIONAL RF
                      WHERE  FA.COD_INS          = PAR_COD_INS
                      AND FA.COD_IDE_CLI         = COM_COD_IDE_CLI
                      AND FA.COD_ENTIDADE        = COM_ENTIDADE
                      AND FA.NUM_MATRICULA       = COM_NUM_MATRICULA
                      AND FA.COD_IDE_REL_FUNC    = COM_COD_IDE_REL_FUNC
                      AND FA.DAT_FIM             IS NOT NULL
                      AND RF.COD_INS             = FA.COD_INS
                      AND RF.NUM_MATRICULA       = FA.NUM_MATRICULA
                      AND RF.COD_IDE_CLI         = FA.COD_IDE_CLI
                      AND RF.COD_IDE_REL_FUNC    = FA.COD_IDE_REL_FUNC
                      AND RF.COD_ENTIDADE        = FA.COD_ENTIDADE
                      AND FA.DAT_INICIO          <= RF.DAT_FIM_EXERC
                      AND FA.DAT_FIM             <= RF.DAT_FIM_EXERC
                      AND FA.DAT_FIM             < RF.DAT_FIM_EXERC
                      AND FA.NUM_SALDO           > 0;

       IF V_AQUISITIVO_COMPLETO IS NULL THEN
           V_AQUISITIVO_COMPLETO:=0;
           END IF;

      RETURN (V_AQUISITIVO_COMPLETO);

     EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_AQUISITIVO_COMPLETO := 0;
                  RETURN (V_AQUISITIVO_COMPLETO);
              WHEN OTHERS THEN
                  V_AQUISITIVO_COMPLETO := 0;
                  RETURN (V_AQUISITIVO_COMPLETO);

  END SP_DIAS_AQUISITIVO_COMPLETO;

FUNCTION SP_OBTEM_DIAS_EVO_COMI
    RETURN NUMBER IS
    v_dias_evo_com  NUMBER;

    BEGIN

/*       select
       (
       CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end)

        into v_dias_evo_com

        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli =  COM_COD_IDE_CLI  -- efv 02032007
         and (PAR_PER_PRO BETWEEN ECG.DAT_INI_EFEITO AND NVL(ECG.DAT_FIM_EFEITO,TO_dATE('31/12/2099','DD/MM/YYYY'))
         OR  PAR_PER_PRO BETWEEN ECG.DAT_INI_EFEITO AND LAST_DAY(ECG.DAT_INI_EFEITO))
         and ecg.num_matricula   = COM_MATRICULA
         and ecg.cod_ide_rel_func= COM_COD_IDE_REL_FUNC
         and ecg.cod_entidade   = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
            -- MVL : 20060417
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V';*/

select
      /* (
       CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end)
*/
        SUM(CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end )

        into v_dias_evo_com

        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli =  COM_COD_IDE_CLI  -- efv 02032007
         /*and (PAR_PER_PRO BETWEEN ECG.DAT_INI_EFEITO AND NVL(ECG.DAT_FIM_EFEITO,TO_dATE('31/12/2099','DD/MM/YYYY'))
         OR  PAR_PER_PRO BETWEEN ECG.DAT_INI_EFEITO AND LAST_DAY(ECG.DAT_INI_EFEITO))*/
         and (add_months(PAR_PER_PRO, 1) - 1 >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.num_matricula   = COM_MATRICULA
         and ecg.cod_ide_rel_func= COM_COD_IDE_REL_FUNC
         and ecg.cod_entidade   = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
         and ecg.cod_cargo_comp not in(204,301,10,13,14,15)
            -- MVL : 20060417
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V';

      RETURN (v_dias_evo_com);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_dias_evo_com := 0;
                  RETURN (v_dias_evo_com);
              WHEN OTHERS THEN
                  v_dias_evo_com := 0;
                  RETURN (v_dias_evo_com);

  END SP_OBTEM_DIAS_EVO_COMI;


FUNCTION SP_OBTEM_DIAS_EVO_COMI_COR
    RETURN NUMBER IS
    v_dias_evo_com  NUMBER;

    BEGIN

select
      /* (
       CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end)
*/
        SUM(CASE when ECG.DAT_FIM_EFEITO <  (add_months(PAR_PER_PRO, 1) - 1) and ecg.cod_referencia = v.cod_referencia then
             (to_number(to_char(ECG.DAT_FIM_EFEITO, 'dd')))
             when ECG.DAT_INI_EFEITO > PAR_PER_PRO THEN (30 - to_number(to_char(ECG.DAT_INI_EFEITO, 'dd'))+1) else 30 end )

        into v_dias_evo_com

        from tb_evolu_ccomi_gfuncional ecg, tb_vencimento v
       where ecg.cod_ins = PAR_COD_INS
         and ecg.cod_ide_cli =  COM_COD_IDE_CLI  -- efv 02032007
         /*and (PAR_PER_PRO BETWEEN ECG.DAT_INI_EFEITO AND NVL(ECG.DAT_FIM_EFEITO,TO_dATE('31/12/2099','DD/MM/YYYY'))
         OR  PAR_PER_PRO BETWEEN ECG.DAT_INI_EFEITO AND LAST_DAY(ECG.DAT_INI_EFEITO))*/
         and (add_months(PAR_PER_PRO, 1) - 1 >= ecg.dat_ini_efeito and
             PAR_PER_PRO <=
             nvl(ecg.dat_fim_efeito, to_date('01/01/2045', 'dd/mm/yyyy')))
         and ecg.num_matricula   = COM_MATRICULA
         and ecg.cod_ide_rel_func= COM_COD_IDE_REL_FUNC
         and ecg.cod_entidade   = COM_ENTIDADE
         and ecg.cod_referencia = v.cod_referencia
         and v.cod_ins = ecg.cod_ins
         and v.cod_entidade = ecg.cod_entidade
         and v.cod_entidade = COM_ENTIDADE
         and ecg.cod_cargo_comp in(204,301)
            -- MVL : 20060417
         and (v.dat_fim_vig is null or v.dat_fim_vig >= PAR_PER_PRO)
         and add_months(PAR_PER_PRO, 1) - 1 >= v.dat_ini_vig
         and v.flg_status = 'V';

      RETURN (v_dias_evo_com);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  v_dias_evo_com := 0;
                  RETURN (v_dias_evo_com);
              WHEN OTHERS THEN
                  v_dias_evo_com := 0;
                  RETURN (v_dias_evo_com);

  END SP_OBTEM_DIAS_EVO_COMI_COR;

  FUNCTION SP_OBTEM_DIAS_FERIAS_MES
    RETURN NUMBER IS
    V_DIAS_FERIAS_MES  NUMBER;

    BEGIN

      SELECT
        SUM (G1.NUM_DIAS) AS DIAS
        INTO V_DIAS_FERIAS_MES
        FROM TB_FERIAS_GOZO       G1
           , TB_FERIAS_AQUISITIVO A1
       WHERE G1.DAT_INICIO >= PAR_PER_PRO
         AND G1.DAT_FIM    < ADD_MONTHS(PAR_PER_PRO,2)
         AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE     = COM_ENTIDADE
         AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
         AND G1.DAT_INICIO > = PAR_PER_PRO
         AND G1.FLG_STATUS                 <> 'C';

      RETURN (V_DIAS_FERIAS_MES);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_FERIAS_MES := 0;
                  RETURN (V_DIAS_FERIAS_MES);
              WHEN OTHERS THEN
                  V_DIAS_FERIAS_MES := 0;
                  RETURN (V_DIAS_FERIAS_MES);

  END SP_OBTEM_DIAS_FERIAS_MES;

 FUNCTION SP_OBTEM_QTD_DIAS_RESCISAO
    RETURN NUMBER IS
    V_DIAS_RESCISAO  NUMBER;

    BEGIN


 SELECT TO_CHAR(NVL(RF.DAT_FIM_EXERC, '01/01/2299'), 'DD')
        INTO V_DIAS_RESCISAO
        FROM TB_RELACAO_FUNCIONAL RF
       WHERE
       --Yumi em 04/07/2018: Ajustanto problema da rescisao no ultimo dia do mes anterior
       ----PAR_PER_PRO = TO_DATE('01/'||to_char(NVL(RF.DAT_FIM_EXERC, '01/01/2299'),'MM/YYYY'),'DD/MM/YYYY')
        (
        PAR_PER_PRO = TO_DATE('01/'||to_char(NVL(RF.DAT_FIM_EXERC, '01/01/2299'),'MM/YYYY'),'DD/MM/YYYY')
        OR
        ADD_MONTHS(PAR_PER_PRO,-1) = TO_DATE('01/'||to_char(NVL(RF.DAT_FIM_EXERC, '01/01/2299'),'MM/YYYY'),'DD/MM/YYYY')
        )
        AND RF.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND RF.COD_ENTIDADE     = COM_ENTIDADE
         AND RF.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND RF.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
   ;

   IF V_DIAS_RESCISAO =31 THEN
           V_DIAS_RESCISAO:=30;
           END IF;

      RETURN (V_DIAS_RESCISAO);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_RESCISAO := 0;
                  RETURN (V_DIAS_RESCISAO);
              WHEN OTHERS THEN
                  V_DIAS_RESCISAO := 0;
                  RETURN (V_DIAS_RESCISAO);

  END SP_OBTEM_QTD_DIAS_RESCISAO;

FUNCTION SP_CALC_AVOS13_RESCISAO Return number IS

  QTD_AVOS_13     number(18,6) :=0;
  I_DAT_INI_REF   DATE;
  I_DAT_FIM_REF   DATE;
  I_MESES         NUMBER;

  BEGIN

      I_DAT_INI_REF :=BEN_DAT_INICIO;
      I_DAT_FIM_REF :=BEN_DAT_FIM;

      /* TONY CARAVANA 2017-06-25 */
      IF TO_CHAR(I_DAT_INI_REF,'YYYY') < TO_CHAR(PAR_PER_PRO,'YYYY')
        THEN
            I_DAT_INI_REF := TO_DATE('01/01/' ||  TO_CHAR(PAR_PER_PRO,'YYYY'),'DD/MM/YYYY');

     END IF;

      I_MESES := TO_NUMBER(TO_CHAR(BEN_DAT_FIM, 'MM')) - TO_NUMBER(TO_CHAR(I_DAT_INI_REF, 'MM')) + 1;

      IF to_char(I_DAT_FIM_REF  ,'dd') > '15'  AND TO_CHAR(I_DAT_INI_REF,'DD') <= '15'
        THEN
          QTD_AVOS_13 :=  I_MESES;
          --END IF;

     ELSE IF to_char(I_DAT_FIM_REF  ,'dd') < '15'  AND TO_CHAR(I_DAT_INI_REF,'DD') > '15'
        THEN
          QTD_AVOS_13 :=  I_MESES - 2;


       ELSE
          QTD_AVOS_13 :=  I_MESES - 1;
      END IF;
    END IF;
  RETURN (QTD_AVOS_13);

  END SP_CALC_AVOS13_RESCISAO;

  FUNCTION SP_OBTEM_DIAS_FERIAS_RESCISAO Return number IS

  DIAS_FERIAS_GOZADAS number :=0;
  SALDO_FERIAS_GOZADAS number :=0;
  FERIAS_GOZADAS number :=0;
  I_DAT_INI_REF       DATE;
  I_DAT_FIM_REF       DATE;
  I_MESES             NUMBER;

  BEGIN
  -- alterado 22/05/2023 para considerar 2 periodos aquisitivos completos
/*       SELECT (30 - NVL(SUM(FG.NUM_DIAS),0))
         INTO DIAS_FERIAS_GOZADAS
         FROM TB_FERIAS_GOZO FG
        WHERE FG.DAT_FIM < ADD_MONTHS(PAR_PER_PRO,1)
          AND FG.ID_AQUISITIVO IN (
           SELECT MAX(FA.ID_AQUISITIVO)
             FROM TB_FERIAS_AQUISITIVO FA,
                  TB_RELACAO_FUNCIONAL RF
            WHERE FA.COD_INS          = PAR_COD_INS
              AND FA.COD_IDE_CLI      = COM_COD_IDE_CLI
              AND FA.COD_ENTIDADE     = COM_ENTIDADE
              AND FA.NUM_MATRICULA    = COM_NUM_MATRICULA
              AND FA.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
              AND RF.COD_INS          = FA.COD_INS
              AND RF.COD_ENTIDADE     = FA.COD_ENTIDADE
              AND RF.NUM_MATRICULA    = FA.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC = FA.COD_IDE_REL_FUNC
              AND RF.COD_IDE_CLI      = FA.COD_IDE_CLI
              AND FA.DAT_INICIO       < RF.DAT_FIM_EXERC
              AND FA.DAT_FIM IS NOT NULL
              AND FA.DAT_FIM          <  RF.DAT_FIM_EXERC
        );*/

        SELECT       SUM(FA.NUM_SALDO)
            INTO SALDO_FERIAS_GOZADAS
             FROM TB_FERIAS_AQUISITIVO FA,
                  TB_RELACAO_FUNCIONAL RF
            WHERE FA.COD_INS          = PAR_COD_INS
              AND FA.COD_IDE_CLI      = COM_COD_IDE_CLI
              AND FA.COD_ENTIDADE     = COM_ENTIDADE
              AND FA.NUM_MATRICULA    = 2
              AND FA.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
              AND RF.COD_INS          = FA.COD_INS
              AND RF.COD_ENTIDADE     = FA.COD_ENTIDADE
              AND RF.NUM_MATRICULA    = FA.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC = FA.COD_IDE_REL_FUNC
              AND RF.COD_IDE_CLI      = FA.COD_IDE_CLI
              AND FA.DAT_INICIO       < RF.DAT_FIM_EXERC
              AND FA.DAT_FIM IS NOT NULL
              AND FA.DAT_FIM          <  RF.DAT_FIM_EXERC
              AND FA.COD_STATUS       IN ('V','A');



       SELECT   NVL(SUM(FG.NUM_DIAS),0)
                INTO FERIAS_GOZADAS
         FROM TB_FERIAS_GOZO FG
        WHERE FG.DAT_FIM < ADD_MONTHS(To_date('01/05/2023','dd/mm/yyyy'),1)
          AND FG.ID_AQUISITIVO IN (
           SELECT FA.ID_AQUISITIVO
             FROM TB_FERIAS_AQUISITIVO FA,
                  TB_RELACAO_FUNCIONAL RF
            WHERE FA.COD_INS          = PAR_COD_INS
              AND FA.COD_IDE_CLI      = COM_COD_IDE_CLI
              AND FA.COD_ENTIDADE     = COM_ENTIDADE
              AND FA.NUM_MATRICULA    = COM_NUM_MATRICULA
              AND FA.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
              AND RF.COD_INS          = FA.COD_INS
              AND RF.COD_ENTIDADE     = FA.COD_ENTIDADE
              AND RF.NUM_MATRICULA    = FA.NUM_MATRICULA
              AND RF.COD_IDE_REL_FUNC = FA.COD_IDE_REL_FUNC
              AND RF.COD_IDE_CLI      = FA.COD_IDE_CLI
              AND FA.DAT_INICIO       < RF.DAT_FIM_EXERC
              AND FA.DAT_FIM IS NOT NULL
              AND FA.DAT_FIM          <  RF.DAT_FIM_EXERC
              AND FA.COD_STATUS       IN ('V','A')
              );

    DIAS_FERIAS_GOZADAS :=  SALDO_FERIAS_GOZADAS - FERIAS_GOZADAS;
  -- alterado 22/05/2023 para considerar 2 periodos aquisitivos completos
  RETURN (DIAS_FERIAS_GOZADAS);

  END SP_OBTEM_DIAS_FERIAS_RESCISAO;

  FUNCTION SP_OBTEM_MEDIA_1_A_11
    RETURN NUMBER IS
    V_VALOR_MEDIA_1_A_11  NUMBER;

    BEGIN

  SELECT

   NVL(ROUND(SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) /12, 2),0) AS MEDIA

      INTO V_VALOR_MEDIA_1_A_11

      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
       WHERE
         HFD.PER_PROCESSO BETWEEN ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(PAR_PER_PRO, 'YYYY'), 'DD/MM/YYYY'),-1)
                            AND TO_DATE('01/11/'||TO_CHAR(PAR_PER_PRO, 'YYYY'), 'DD/MM/YYYY')
         AND HFD.COD_INS                             = PAR_COD_INS
         AND HFD.COD_IDE_CLI                         = COM_COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = COM_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = COM_COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = COM_NUM_MATRICULA
         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'MEDIA_1_A_11'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
           OR HFD.COD_FCRUBRICA = 0)
           ;

         IF V_VALOR_MEDIA_1_A_11 IS NULL THEN
           V_VALOR_MEDIA_1_A_11:=0;
           END IF;

      RETURN (V_VALOR_MEDIA_1_A_11);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_VALOR_MEDIA_1_A_11 := 0;
                  RETURN (V_VALOR_MEDIA_1_A_11);
              WHEN OTHERS THEN
                  V_VALOR_MEDIA_1_A_11 := 0;
                  RETURN (V_VALOR_MEDIA_1_A_11);

  END SP_OBTEM_MEDIA_1_A_11;

FUNCTION SP_OBTEM_MEDIA_FUNC
    RETURN NUMBER IS
    V_VALOR_MEDIA_FUNC  NUMBER;

    BEGIN

  SELECT

   NVL(ROUND(SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) /12, 2),0) AS MEDIA

      INTO V_VALOR_MEDIA_FUNC

      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
       WHERE
         HFD.PER_PROCESSO BETWEEN ADD_MONTHS(TO_DATE('01/01/'||TO_CHAR(PAR_PER_PRO, 'YYYY'), 'DD/MM/YYYY'),-1)
                            AND TO_DATE('01/11/'||TO_CHAR(PAR_PER_PRO, 'YYYY'), 'DD/MM/YYYY')
         AND HFD.COD_INS                             = PAR_COD_INS
         AND HFD.COD_IDE_CLI                         = COM_COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = COM_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = COM_COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = COM_NUM_MATRICULA
         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'MEDIA_FUNC'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
           OR HFD.COD_FCRUBRICA = 0)
           ;

         IF V_VALOR_MEDIA_FUNC IS NULL THEN
           V_VALOR_MEDIA_FUNC:=0;
           END IF;

      RETURN (V_VALOR_MEDIA_FUNC);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_VALOR_MEDIA_FUNC := 0;
                  RETURN (V_VALOR_MEDIA_FUNC);
              WHEN OTHERS THEN
                  V_VALOR_MEDIA_FUNC := 0;
                  RETURN (V_VALOR_MEDIA_FUNC);

  END SP_OBTEM_MEDIA_FUNC;

    FUNCTION FC_CALCULA_AVOS_AFAST    (P_COD_INS         IN NUMBER,
                                    P_COD_ENTIDADE     IN NUMBER,
                                    P_COD_IDE_CLI      IN VARCHAR2,
                                    P_NUM_MATRICULA    IN VARCHAR2,
                                    P_COD_IDE_REL_FUNC IN NUMBER,
                                    P_ANO              IN VARCHAR2,
                                    P_COD_MOT_AFAST    IN VARCHAR2
                                    )

 RETURN NUMBER AS
 ---- Definic?o de Variaveis para Calculo
   TYPE t_list_percentual IS RECORD (
     dias   number,
     percentual number(18,6)
   );

   TYPE table_list_percentual IS TABLE OF t_list_percentual INDEX BY BINARY_INTEGER;
   v_list_percentual   table_list_percentual;


   TYPE t_perc IS RECORD (
     dias   number,
     percentual number(18,6)
   );

   TYPE table_perc IS TABLE OF t_perc INDEX BY BINARY_INTEGER;
   v_perc table_perc;


  i number;
  V_DIA_PERC       NUMBER;
  V_NUM_PERCENTUAL NUMBER;
  VAL_PROPORCAO    NUMBER(18,6);
  V_PERCENTUAL     NUMBER(18,6);
  V_QTD_REG        NUMBER;
  V_DIAS           NUMBER;
  V_DIAS_COMP      NUMBER;
  V_DIA_INI        NUMBER;
  V_DIA_FIM        NUMBER;
  V_AVOS           NUMBER;
  V_DAT_FIM_ANT    VARCHAR(6);
  V_DAT_INI_VIG    VARCHAR(8);
  V_DAT_FIM_VIG    VARCHAR(8);
  V_DAT_FIM_CONTROLE VARCHAR(8);
  V_FEVEREIRO      BOOLEAN;
  V_MESMO_MES      BOOLEAN;

  --- Sub Procedimento utilizado pelo Rateio
/*  PROCEDURE CALCULA_PERCENTUAL IS

  BEGIN
   FOR num IN 1 .. v_list_percentual.count LOOP

     IF NOT v_perc.EXISTS(v_list_percentual(num).percentual) THEN
       v_perc(v_list_percentual(num).percentual).dias := 0;
     END IF;

     v_perc(v_list_percentual(num).percentual).dias :=
     v_perc(v_list_percentual(num).percentual).dias + v_list_percentual(num).dias;
     v_perc(v_list_percentual(num).percentual).percentual := v_list_percentual(num).percentual;

     END LOOP;

   V_DIA_PERC := NULL;
   i          := v_perc.FIRST;
   WHILE i IS NOT NULL LOOP

      IF V_DIA_PERC IS NULL THEN
         V_DIA_PERC   := v_perc(i).dias;
         V_PERCENTUAL := v_perc(i).percentual;
      ELSE
         IF V_DIA_PERC < v_perc(i).dias THEN
            V_PERCENTUAL := v_perc(i).percentual;
         ELSIF V_DIA_PERC = v_perc(i).dias THEN
            IF V_PERCENTUAL > v_perc(i).percentual THEN
               V_PERCENTUAL := v_perc(i).percentual;
            END IF;
         END IF;
      END IF;

      i := v_perc.NEXT(i);

   END LOOP;
  END CALCULA_PERCENTUAL;*/

BEGIN

  VAL_PROPORCAO      := 0;
  V_QTD_REG          := 0;
  V_PERCENTUAL       := 0;
  V_AVOS             := 0;
  V_DAT_FIM_ANT      := NULL;
  V_FEVEREIRO        := FALSE;
  v_num_percentual   := 1;
  i                  := 0;

  --BUSCA QUANTIDADE DE REGISTRO DE RATEIO -----

  SELECT COUNT(*)
    INTO V_QTD_REG
    FROM TB_AFASTAMENTO AFA
         WHERE AFA.COD_INS = P_COD_INS
          AND TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY')    <= P_ANO
          AND (TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY') >= P_ANO OR
                   AFA.DAT_RET_EFETIVO IS NULL)
          AND AFA.COD_ENTIDADE        = P_COD_ENTIDADE
          AND AFA.COD_IDE_CLI         = P_COD_IDE_CLI
          AND AFA.COD_IDE_REL_FUNC    = P_COD_IDE_REL_FUNC
          AND AFA.NUM_MATRICULA       = P_NUM_MATRICULA
          AND AFA.COD_MOT_AFAST       = P_COD_MOT_AFAST;

  --VERIFICAR SE UM REGISTRO DE RATEIO TEM QUEBRA DE DIAS
  IF V_QTD_REG = 1 THEN
  SELECT DECODE(TO_CHAR(DECODE(TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY'),
                             P_ANO,
                             AFA.DAT_INI_AFAST,
                             TO_DATE('01/01/' || P_ANO, 'DD/MM/YYYY')),'DD'),1,1,2) DIA_INI
        ,DECODE(TO_CHAR(DECODE(TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY'),
                             P_ANO,
                             AFA.DAT_RET_EFETIVO,
                             TO_DATE('30/12/' || P_ANO, 'DD/MM/YYYY')),'DD'),30,1,31,1,2) DIA_FIM
    INTO V_DIA_INI, V_DIA_FIM
    FROM TB_AFASTAMENTO AFA
         WHERE AFA.COD_INS = 1
          AND TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY')    <= P_ANO
          AND (TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY') >= P_ANO OR
                   AFA.DAT_RET_EFETIVO IS NULL)
          AND AFA.COD_ENTIDADE        = P_COD_ENTIDADE
          AND AFA.COD_IDE_CLI         = P_COD_IDE_CLI
          AND AFA.COD_IDE_REL_FUNC    = P_COD_IDE_REL_FUNC
          AND AFA.NUM_MATRICULA       = P_NUM_MATRICULA
          AND AFA.COD_MOT_AFAST       = P_COD_MOT_AFAST;
  END IF;

  --TRATAR QUANTIDADE MAIOR QUE UM REGISTRO DE RATEIO
  IF V_QTD_REG > 1 OR (V_DIA_INI > 1 OR V_DIA_FIM > 1) THEN

    V_DIAS       := 0;
    V_MESMO_MES  := FALSE;
    FOR C1 in (SELECT 1,
                      DECODE(TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY'),
                             P_ANO,
                             AFA.DAT_INI_AFAST,
                             TO_DATE('01/01/' || P_ANO, 'DD/MM/YYYY')) AS DAT_INI_VIG,
                      DECODE(TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY'),
                             P_ANO,
                             AFA.DAT_RET_EFETIVO,
                             TO_DATE('30/12/' || P_ANO, 'DD/MM/YYYY')) AS DAT_FIM_VIG
                 FROM TB_AFASTAMENTO AFA
        WHERE AFA.COD_INS = 1
            AND TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY')    <= P_ANO
        AND (TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY') >= P_ANO OR
                   AFA.DAT_RET_EFETIVO IS NULL)
        AND AFA.COD_ENTIDADE        = P_COD_ENTIDADE
          AND AFA.COD_IDE_CLI         = P_COD_IDE_CLI
          AND AFA.COD_IDE_REL_FUNC    = P_COD_IDE_REL_FUNC
          AND AFA.NUM_MATRICULA       = P_NUM_MATRICULA
          AND AFA.COD_MOT_AFAST       = P_COD_MOT_AFAST
                ORDER BY AFA.DAT_INI_AFAST) LOOP

  V_DAT_INI_VIG   := to_char(c1.dat_ini_vig,'yyyymmdd');
  V_DAT_FIM_VIG   := to_char(c1.dat_fim_vig,'yyyymmdd');
  V_DAT_FIM_CONTROLE := NULL;

      FOR X IN SUBSTR(V_DAT_INI_VIG,1,6) .. SUBSTR(V_DAT_FIM_VIG,1,6) LOOP

        IF SUBSTR(V_DAT_INI_VIG,1,6) != SUBSTR(V_DAT_FIM_VIG,1,6) THEN
         V_DAT_FIM_CONTROLE   := SUBSTR(V_DAT_INI_VIG,1,6)||30;
        ELSE
         IF TO_NUMBER(SUBSTR(V_DAT_FIM_VIG, 7,2)) = 31 THEN
           V_DAT_FIM_CONTROLE := SUBSTR(V_DAT_FIM_VIG,1,6)||30;
         ELSE
           V_DAT_FIM_CONTROLE   := V_DAT_FIM_VIG;
         END IF;
        END IF;

      --SE MES DE FEVEREIRO
      IF SUBSTR(V_DAT_FIM_CONTROLE, 5,2) = '02' THEN
        V_FEVEREIRO := TRUE;
      ELSE
        V_FEVEREIRO := FALSE;
      END IF;

      IF V_DAT_FIM_ANT = SUBSTR(V_DAT_INI_VIG, 1,6) THEN
        --SOMAR PERCENTUAL DO MES ANTERIOR
        V_DIAS_COMP := 1 + (TO_NUMBER(SUBSTR(V_DAT_FIM_CONTROLE, 7,2)) -
                                  TO_NUMBER(SUBSTR(V_DAT_INI_VIG, 7,2)));

        V_DIAS := V_DIAS + V_DIAS_COMP;

        v_list_percentual(v_num_percentual).dias := V_DIAS_COMP;
        v_list_percentual(v_num_percentual).percentual := 1; --C1.VAL_PERCENT_RATEIO;
        v_num_percentual := v_num_percentual + 1;

        V_MESMO_MES := TRUE;
      ELSE
        --VERIFICAR DIREITO AO AVO
        IF V_DIAS >= 16
          THEN
            ---1 ;

          --CALCULA PERCENTUAL NO MES
          --CALCULA_PERCENTUAL;

          VAL_PROPORCAO := VAL_PROPORCAO + 1; ---((1 / 12)); ---* V_PERCENTUAL);
          v_list_percentual.delete;
          v_perc.delete;
          v_num_percentual   := 1;
        END IF;

        V_DIAS := 0;
        V_PERCENTUAL := 0;
        V_MESMO_MES := FALSE;

        V_DIAS_COMP :=  1 + (TO_NUMBER(SUBSTR(V_DAT_FIM_CONTROLE, 7,2)) -
                                  TO_NUMBER(SUBSTR(V_DAT_INI_VIG, 7,2)));

        V_DIAS := V_DIAS + V_DIAS_COMP;
      END IF;

        --ARREDONDAR PARA 30, MES DE FEVEREIRO.
        IF V_FEVEREIRO AND V_DIAS IN (28,29) THEN
          V_DIAS := 30;
        END IF;

       IF V_DIAS >= 16 THEN
         --APLICAR PERCENTUAL
         IF NOT V_MESMO_MES THEN
           v_list_percentual(v_num_percentual).dias := V_DIAS_COMP;
           v_list_percentual(v_num_percentual).percentual := 1; ---C1.VAL_PERCENT_RATEIO;
           v_num_percentual := v_num_percentual + 1;
         END IF;
         V_DIAS_COMP  := 0;
       ELSE
         IF NOT V_MESMO_MES THEN
           v_list_percentual(v_num_percentual).dias := V_DIAS_COMP;
           v_list_percentual(v_num_percentual).percentual := 1; --C1.VAL_PERCENT_RATEIO;
           v_num_percentual := v_num_percentual + 1;
         END IF;
       END IF;

       V_DAT_FIM_ANT := SUBSTR(V_DAT_FIM_CONTROLE, 1,6);

       V_DAT_INI_VIG   := TO_CHAR(ADD_MONTHS(TO_DATE(V_DAT_INI_VIG,'YYYYMMDD'), 1),'YYYYMM') || '01';

      END LOOP;

    END LOOP;

    --CALCULA PROPORCAO DO ULTIMO MES
    IF V_DIAS >= 16 AND SUBSTR(V_DAT_FIM_VIG, 1,6) != SUBSTR(V_DAT_INI_VIG, 1,6) THEN

    ---CALCULA_PERCENTUAL;
      VAL_PROPORCAO := VAL_PROPORCAO + 1 ;--(1 / 12) ; ---* V_PERCENTUAL);
    END IF;

    VAL_PROPORCAO := (VAL_PROPORCAO);

  ELSE

    BEGIN
    SELECT 1, ROUND(ROUND(MOD(MONTHS_BETWEEN(DECODE(TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY'),
                             P_ANO,
                             AFA.DAT_RET_EFETIVO,
                             TO_DATE('30/12/' || P_ANO, 'DD/MM/YYYY')),DECODE(TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY'),
                             P_ANO,
                             AFA.DAT_INI_AFAST,
                             TO_DATE('01/01/' || P_ANO, 'DD/MM/YYYY'))),12),1)) MESES
        INTO V_PERCENTUAL, V_AVOS
        FROM TB_AFASTAMENTO AFA
        WHERE AFA.COD_INS = 1
            AND TO_CHAR(AFA.DAT_INI_AFAST, 'YYYY')    <= P_ANO
        AND (TO_CHAR(AFA.DAT_RET_EFETIVO, 'YYYY') >= P_ANO OR
                   AFA.DAT_RET_EFETIVO IS NULL)
          AND AFA.COD_ENTIDADE        = P_COD_ENTIDADE
          AND AFA.COD_IDE_CLI         = P_COD_IDE_CLI
          AND AFA.COD_IDE_REL_FUNC    = P_COD_IDE_REL_FUNC
          AND AFA.NUM_MATRICULA       = P_NUM_MATRICULA
          AND AFA.COD_MOT_AFAST       = P_COD_MOT_AFAST;
    EXCEPTION
      WHEN OTHERS THEN
        V_PERCENTUAL := 0;
    END;

    VAL_PROPORCAO := VAL_PROPORCAO + V_AVOS ;--(V_AVOS / 12); ---* V_PERCENTUAL);

  END IF;

  RETURN VAL_PROPORCAO;

   EXCEPTION WHEN NO_DATA_FOUND THEN
                  VAL_PROPORCAO := 0;
                  RETURN (VAL_PROPORCAO);
              WHEN OTHERS THEN
                  VAL_PROPORCAO := 0;
                  RETURN (VAL_PROPORCAO);

END FC_CALCULA_AVOS_AFAST;

     ----PARA RETORNAR O VALOR NO M? ANTERIOR PAGO DE DETERMINADAS RUBRICAS DEFINIDAS NA TB_COMPOE_DET
FUNCTION SP_VALOR_PAGO_MES_ANT
    RETURN NUMBER IS
    V_VALOR_PAGO  NUMBER;

    BEGIN

  SELECT

   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VALOR_PAGO

      INTO V_VALOR_PAGO

      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
       WHERE
         ADD_MONTHS(PAR_PER_PRO, -1)                 = HFD.PER_PROCESSO
         AND HFD.COD_INS                             = PAR_COD_INS
         AND HFD.COD_IDE_CLI                         = COM_COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = COM_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = COM_COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = COM_NUM_MATRICULA
         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'VALOR_PAGO'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
        OR HFD.COD_FCRUBRICA = 0)
                               ;

       IF V_VALOR_PAGO IS NULL THEN
           V_VALOR_PAGO:=0;
           END IF;

      RETURN (V_VALOR_PAGO);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_VALOR_PAGO := 0;
                  RETURN (V_VALOR_PAGO);
              WHEN OTHERS THEN
                  V_VALOR_PAGO := 0;
                  RETURN (V_VALOR_PAGO);

  END SP_VALOR_PAGO_MES_ANT;


  FUNCTION SP_VALOR_PAGO_MES_ANT_2
    RETURN NUMBER IS
    V_VALOR_PAGO  NUMBER;

    BEGIN

  SELECT

   SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA *-1)) AS VALOR_PAGO

      INTO V_VALOR_PAGO

      FROM  TB_HFOLHA_PAGAMENTO_DET HFD
       WHERE
         ADD_MONTHS(PAR_PER_PRO, -2)                 = HFD.PER_PROCESSO
         AND HFD.COD_INS                             = PAR_COD_INS
         AND HFD.COD_IDE_CLI                         = COM_COD_IDE_CLI
         AND HFD.COD_ENTIDADE                        = COM_ENTIDADE
         AND HFD.COD_IDE_REL_FUNC                    = COM_COD_IDE_REL_FUNC
         AND HFD.NUM_MATRICULA                       = COM_NUM_MATRICULA
         AND (HFD.COD_FCRUBRICA IN
                               (
                               SELECT CD.COD_FCRUBRICA_COMPOE FROM TB_COMPOE_DET CD
                               WHERE CD.COD_INS = 1
                               AND CD.COD_ENTIDADE_COMPOSTA  = HFD.COD_ENTIDADE
                               AND CD.COD_ENTIDADE_COMPOE    = CD.COD_ENTIDADE_COMPOSTA
                               AND CD.COD_VARIAVEL           = 'VALOR_PAGO'
                               AND CD.COD_FCRUBRICA_COMPOSTA = COM_COD_FCRUBRICA
                               AND CD.DAT_INI_VIG < = PAR_PER_PRO
                               AND (CD.DAT_FIM_VIG IS NULL OR CD.DAT_FIM_VIG >= PAR_PER_PRO)
                               )
        OR HFD.COD_FCRUBRICA = 0)
                               ;

       IF V_VALOR_PAGO IS NULL THEN
           V_VALOR_PAGO:=0;
           END IF;

      RETURN (V_VALOR_PAGO);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_VALOR_PAGO := 0;
                  RETURN (V_VALOR_PAGO);
              WHEN OTHERS THEN
                  V_VALOR_PAGO := 0;
                  RETURN (V_VALOR_PAGO);

  END SP_VALOR_PAGO_MES_ANT_2;

  FUNCTION SP_OBTEM_QTD_DIAS_LICENCA
    RETURN NUMBER IS
    V_DIAS_LICENCA  NUMBER;

    BEGIN

--    SELECT NUM_DIAS
       SELECT NVL(SUM
((CASE WHEN (G1.DAT_INICIO <= PAR_PER_PRO)
           AND (G1.DAT_FIM <= ADD_MONTHS(PAR_PER_PRO,1)-1)
            THEN (G1.DAT_FIM - PAR_PER_PRO)

       WHEN (G1.DAT_INICIO <= PAR_PER_PRO) AND
            ((G1.DAT_FIM > ADD_MONTHS(PAR_PER_PRO,1)-1)) AND (TO_CHAR(G1.DAT_INICIO, 'MM') != '02' )
                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (G1.DAT_FIM > ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_INICIO, 'MM') != '02'))
                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - G1.DAT_INICIO

      WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (G1.DAT_FIM > ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_INICIO, 'MM') = '02'))
                      THEN
      LAST_DAY(PAR_PER_PRO) - G1.DAT_INICIO


       WHEN (G1.DAT_INICIO <= PAR_PER_PRO) AND
            (
            ((G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1)
                AND TO_CHAR(G1.DAT_FIM,'DD') IN ('30','31')) OR

            (G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1
                AND (TO_CHAR(G1.DAT_FIM, 'MM') = '02' AND TO_CHAR(G1.DAT_FIM,'DD') IN ('28', '29')))
             )

                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((G1.DAT_INICIO > PAR_PER_PRO) AND
            (((G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1) AND TO_CHAR(G1.DAT_FIM,'DD') IN ('30','31')) OR
            (G1.DAT_FIM = ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(G1.DAT_FIM, 'MM') = '02' AND TO_CHAR(G1.DAT_FIM,'DD') IN ('28', '29'))))
                      THEN
      TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - G1.DAT_INICIO

      ELSE  (G1.DAT_FIM - G1.DAT_INICIO) END)+1),0)
        INTO V_DIAS_LICENCA
        FROM TB_LICENCA_GOZO       G1
           , TB_LICENCA_AQUISITIVO A1
       WHERE
       PAR_PER_PRO BETWEEN TO_DATE('01/'||TO_CHAR(G1.DAT_INICIO, 'MM/YYYY'), 'DD/MM/YYYY') AND
       TO_DATE('01/'||TO_CHAR(G1.DAT_FIM, 'MM/YYYY'), 'DD/MM/YYYY')
         AND A1.ID_AQUISITIVO    = G1.ID_AQUISITIVO
         AND A1.COD_IDE_CLI      = COM_COD_IDE_CLI
         AND A1.COD_ENTIDADE     = COM_ENTIDADE
         AND A1.NUM_MATRICULA    = COM_NUM_MATRICULA
         AND A1.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC;

      IF V_DIAS_LICENCA IS NULL THEN
           V_DIAS_LICENCA:=0;
           END IF;

      RETURN (V_DIAS_LICENCA);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_LICENCA := 0;
                  RETURN (V_DIAS_LICENCA);
              WHEN OTHERS THEN
                  V_DIAS_LICENCA := 0;
                  RETURN (V_DIAS_LICENCA);

  END SP_OBTEM_QTD_DIAS_LICENCA;

   FUNCTION SP_OBTEM_DIAS_LIC_SEM_REMUN
    RETURN NUMBER IS
    V_DIAS_TRAB  NUMBER;

    BEGIN

         SELECT  FNC_GET_DIAS_MENOR_30(SUM(QTD_DIAS))
           INTO V_DIAS_TRAB
           FROM (

           SELECT
          ((CASE WHEN (F2.DAT_INI_AFAST <= PAR_PER_PRO)
           AND (F2.DAT_RET_PREV <= ADD_MONTHS(PAR_PER_PRO,1)-1)
            THEN (TO_DATE(F2.DAT_RET_PREV) - TO_DATE(PAR_PER_PRO))

       WHEN (F2.DAT_INI_AFAST <= PAR_PER_PRO) AND
            ((F2.DAT_RET_PREV > ADD_MONTHS(PAR_PER_PRO,1)-1))
        THEN
        ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
             29
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((F2.DAT_INI_AFAST > PAR_PER_PRO) AND
            (F2.DAT_RET_PREV > ADD_MONTHS(PAR_PER_PRO,1)-1))
                      THEN
        ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
              30 - TO_CHAR(F2.DAT_INI_AFAST, 'DD')
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - F2.DAT_INI_AFAST


       WHEN (F2.DAT_INI_AFAST <= PAR_PER_PRO) AND
            (
            ((F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1)
                AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('30','31')) OR

            (F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1
                AND (TO_CHAR(F2.DAT_RET_PREV, 'MM') = '02' AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('28', '29')))
             )

                      THEN
         ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
               29
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - PAR_PER_PRO

       WHEN ((F2.DAT_INI_AFAST > PAR_PER_PRO) AND
            (((F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1) AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('30','31')) OR
            (F2.DAT_RET_PREV = ADD_MONTHS(PAR_PER_PRO,1)-1) AND (TO_CHAR(F2.DAT_RET_PREV, 'MM') = '02' AND TO_CHAR(F2.DAT_RET_PREV,'DD') IN ('28', '29'))))
                      THEN
           ---Yumi em 06/02/2018: ajustado pois estava retornando uma data invalida (30/02/2018)
              30 - TO_CHAR(F2.DAT_INI_AFAST, 'DD')
      ---TO_DATE('30/'||TO_CHAR(PAR_PER_PRO, 'MM/YYYY'), 'DD/MM/YYYY') - F2.DAT_INI_AFAST


      ELSE  (F2.DAT_RET_PREV - F2.DAT_INI_AFAST) END)+1) AS QTD_DIAS
              FROM TB_AFASTAMENTO F2,
                   TB_PARAM_MOTIVO_AFAST F3
             WHERE PAR_PER_PRO BETWEEN
               TO_DATE('01/'||to_char( F2.DAT_INI_AFAST,'MM/YYYY'),'DD/MM/YYYY')
               AND F2.DAT_RET_PREV
               AND F2.COD_IDE_CLI      = COM_COD_IDE_CLI
               AND F2.COD_ENTIDADE     = COM_ENTIDADE
               AND F2.NUM_MATRICULA    = COM_NUM_MATRICULA
               AND F2.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
               AND F3.COD_MOT_AFAST = F2.COD_MOT_AFAST
               AND F3.FLG_DESCONTA_FOLHA = 'S'
                ---Yumi em 20/08/2018: colocado para n?o confundir com as faltas injustificadadas
               AND F2.COD_MOT_AFAST    in (18)
               ) TB1
            ;
      IF V_DIAS_TRAB < 0 THEN
        V_DIAS_TRAB:=0;

      END IF;

      IF V_DIAS_TRAB is null THEN
        V_DIAS_TRAB:=0;

      END IF;
      RETURN (V_DIAS_TRAB);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);
              WHEN OTHERS THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);

  END SP_OBTEM_DIAS_LIC_SEM_REMUN;

    FUNCTION SP_OBTEM_SAL_PRO Return number IS
    V_PADRAO NUMBER ;
    Dias           Number;
    Dias_periodo   Number;
    Total_mes      Number;
    Dias_faltantes Number;
    valor_ven      number(10, 4);
    Valor_padrao   number(10, 4);
    BEGIN
    Total_mes    := 0;
    Valor_padrao := 0;
    FOR TER IN
               (
               select inicio,
                       termino,
                       dat_ini_efeito,
                       dat_fim_efeito,
                       cod_referencia,
                       cod_entidade,
                       case
                         when dat_fim_efeito is null then
                          termino - inicio
                         else
                          termino - inicio
                       end diferiencia
                  from (select case
                                 when ev.dat_ini_efeito <= PAR_PER_PRO then
                                  PAR_PER_PRO
                                 else
                                  ev.dat_ini_efeito
                               end inicio,
                               case
                                 when ev.dat_fim_efeito <=
                                      add_months(PAR_PER_PRO, 1) then
                                  ev.dat_fim_efeito
                                 else
                                  add_months(PAR_PER_PRO, 1) - 1
                               end termino,
                               ev.dat_ini_efeito,
                               ev.dat_fim_efeito,
                               ev.cod_referencia,
                               ev.cod_entidade
                         from tb_evolucao_funcional ev,
                              tb_relacao_funcional rf
                         where
                             ev.cod_ins          = PAR_COD_INS      and
                             ev.cod_ide_cli      = COM_COD_IDE_CLI  and
                             ev.num_matricula    = COM_NUM_MATRICULA and
                             ev.cod_ide_rel_func = COM_COD_IDE_REL_FUNC and
                             ev.cod_entidade     = COM_ENTIDADE and
                             rf.cod_ins          = ev.cod_ins and
                             rf.cod_ide_cli      = ev.cod_ide_cli and
                             rf.cod_ide_rel_func = ev.cod_ide_rel_func and
                             rf.cod_entidade     = ev.cod_entidade  and
                             rf.num_matricula    = ev.num_matricula  and
                            (ev.dat_ini_efeito <= PAR_PER_PRO or
                               (
                               ev.dat_ini_efeito >= PAR_PER_PRO
                               and ev.dat_ini_efeito <=last_day(PAR_PER_PRO))
                               )
                           and (nvl(ev.dat_fim_efeito, rf.dat_fim_exerc) is null or
                               nvl(ev.dat_fim_efeito, rf.dat_fim_exerc) >= PAR_PER_PRO)
                         order by nvl(ev.dat_ini_efeito, rf.dat_fim_exerc))

               )LOOP

               ---Yumi em 04/07/2018: Ajustado para considerar o valor correto quando ha fim de exercicio
               /*(select inicio,
                       termino,
                       dat_ini_efeito,
                       dat_fim_efeito,
                       cod_referencia,
                       cod_entidade,
                       case
                         when dat_fim_efeito is null then
                          termino - inicio
                         else
                          termino - inicio
                       end diferiencia
                  from (select case
                                 when ev.dat_ini_efeito <= PAR_PER_PRO then
                                  PAR_PER_PRO
                                 else
                                  ev.dat_ini_efeito
                               end inicio,
                               case
                                 when ev.dat_fim_efeito <=
                                      add_months(PAR_PER_PRO, 1) then
                                  ev.dat_fim_efeito
                                 else
                                  add_months(PAR_PER_PRO, 1) - 1
                               end termino,
                               ev.dat_ini_efeito,
                               ev.dat_fim_efeito,
                               ev.cod_referencia,
                               ev.cod_entidade
                         from tb_evolucao_funcional ev
                         where
                             ev.cod_ins          = PAR_COD_INS      and
                             ev.cod_ide_cli      = COM_COD_IDE_CLI  and
                             ev.num_matricula    = COM_NUM_MATRICULA and
                             ev.cod_ide_rel_func = COM_COD_IDE_REL_FUNC and
                             ev.cod_entidade     = COM_ENTIDADE and
                            (ev.dat_ini_efeito <= PAR_PER_PRO or
                               (
                               ev.dat_ini_efeito >= PAR_PER_PRO
                               and ev.dat_ini_efeito <=last_day(PAR_PER_PRO))
                               )
                           and (ev.dat_fim_efeito is null or
                               ev.dat_fim_efeito >= PAR_PER_PRO)
                         order by ev.dat_ini_efeito))*/
      Dias := ter.diferiencia+1;

      Begin
        Select ve.val_vencimento
          into valor_ven
          from tb_vencimento ve
         where ve.cod_ins = 1
           and ve.cod_entidade = ter.cod_entidade
           and ve.dat_ini_vig <= PAR_PER_PRO
           and nvl(ve.dat_fim_vig, PAR_PER_PRO) >=PAR_PER_PRO
           and ve.cod_referencia = ter.cod_referencia;
      EXCEPTION
        WHEN OTHERS THEN
          valor_ven := 0;
      end;
      Valor_padrao := Valor_padrao + (valor_ven * (Dias / 30));
      Total_mes    := Total_mes + Dias;
    END LOOP;
    Dias_faltantes := 30 - Total_mes;
    IF  (abs(Dias_faltantes) > 0 )  Then
      Valor_padrao := Valor_padrao + (valor_ven * (Dias_faltantes / 30));
    End IF;
    V_PADRAO:=Valor_padrao;
    RETURN V_PADRAO;
    END SP_OBTEM_SAL_PRO;

PROCEDURE SP_PROCESSA_RUBRICAS_EXCL AS
  V_RUBRICA_FILHA NUMBER(8);
  V_RUBRICA_PAI   NUMBER(8);
  rdcn1           TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
  rdcn2           TB_DET_CALCULADO_ATIV_ESTRUC%rowtype;
  cont            NUMBER(3);
  vinculo         NUMBER(2);
  I               NUMBER(3);
  Y               NUMBER(3);
  Base_exclue     BOOLEAN;
BEGIN
  FOR vinculo IN 1 .. vfolha.count LOOP
    rfol := vfolha(vinculo);
    FOR RUBRICAS_FINAIS IN (SELECT DISTINCT BE.COD_FCRUBRICA_COMPOSTA,
                                            BE.COD_ENTIDADE_COMPOSTA
                              FROM TB_COMPOE_DET BE
                             WHERE BE.cod_ins = PAR_COD_INS
                               AND BE.cod_entidade_composta =
                                   RFOL.COD_ENTIDADE
                               AND BE.COD_VARIAVEL = 'BASE_CALC_EXC') LOOP
              ----- Cursor para Eliminar rubricas excluintes associadas.
             Base_exclue:=FALSE;
             cont := tdcn.count;
             FOR Y IN 1 .. cont LOOP
                    rdcn1 := tdcn(Y);
                    IF (rdcn1.COD_FCRUBRICA = RUBRICAS_FINAIS.COD_FCRUBRICA_COMPOSTA)
                      AND
                      (rdcn1.NUM_MATRICULA    =rfol.num_matricula   AND
                       rdcn1.COD_IDE_REL_FUNC =rfol.COD_IDE_REL_FUNC )
                     THEN
                       Base_exclue:=TRUE;
                       exit;
                    END IF;
             END LOOP;
         IF  Base_exclue THEN
               FOR X IN (SELECT /*+ RULE */
                           COD_RUBRICA_B
                          FROM TB_RUBRICAS_EXC
                         WHERE COD_RUBRICA_A =
                               RUBRICAS_FINAIS.COD_FCRUBRICA_COMPOSTA
                           AND COD_ENTIDADE_A =
                               RUBRICAS_FINAIS.COD_ENTIDADE_COMPOSTA) LOOP
                cont := tdcn.count;
                IF cont > 0 then
                  FOR I IN 1 .. cont LOOP
                    rdcn2 := tdcn(I);
                    IF (rdcn2.COD_FCRUBRICA = x.cod_RUBRICA_B)
                      AND
                      (rdcn2.NUM_MATRICULA    =rfol.num_matricula   AND
                       rdcn2.COD_IDE_REL_FUNC =rfol.COD_IDE_REL_FUNC )
                     THEN
                      tdcn(I).val_rubrica := 0;
                    END IF;
                  END LOOP;
                END IF;
              END LOOP;
        END IF;
    END LOOP;
  END LOOP; ----- Loop Principal




END SP_PROCESSA_RUBRICAS_EXCL;

 ---- Processo de Gerac?o de Folha de PA
PROCEDURE  SP_GERA_FOLHA_PA as
 Vinculos_calculados number;

begin

  ---- PROCEDIMENTO DE ATUALIZAC?O DE FOLHA DE PA  ---

 FOR  Vinculos_calculados  IN 1 .. vfolha.count LOOP
    rfol:=vfolha(idx_folha);

   BEGIN
      DELETE TB_FOLHA_PAGAMENTO_PA  PA
      WHERE PA.cod_ins        =  PAR_COD_INS                          AND
            PA.tip_processo   =  PAR_TIP_PRO                          AND
            PA.per_processo   =  PAR_PER_PRO                          AND
            PA.seq_pagamento  =  PAR_SEQ_PAGAMENTO                AND
            cod_ide_cli       =  rfol.COD_IDE_CLI                     AND
            num_matricula     =  rfol.num_matricula                   AND
            cod_ide_rel_func  =  rfol.cod_ide_rel_func                ;



      INSERT INTO  TB_FOLHA_PAGAMENTO_PA
      (
          cod_ins ,
          tip_processo  ,
          per_processo  ,
          seq_pagamento ,
          cod_ide_cli ,
          num_matricula ,
          cod_ide_rel_func  ,
          cod_entidade  ,
          cod_proc_grp_pag  ,
          num_depend  ,
          cod_ide_cli_ben ,
          cpf_servidor  ,
          nome_servidor ,
          cpf_alimentado  ,
          nome_alimentado ,
          cod_ide_tut ,
          nom_tut ,
          dat_processo  ,
          val_sal_base  ,
          tot_cred  ,
          tot_deb ,
          val_liquido ,
          val_base_ir ,
          val_ir_ret  ,
          ded_base_ir ,
          ded_ir_oj ,
          ded_ir_doenca ,
          ded_ir_pa ,
          flg_pag ,
          flg_ind_pago  ,
          flg_ind_ultimo_pag  ,
          tot_cred_pag  ,
          tot_deb_pag ,
          va_liquido_pag  ,
          val_base_ir_pag ,
          val_ir_ret_pag  ,
          val_base_ir_13  ,
          val_ir_13_ret ,
          val_base_ir_13_pag  ,
          val_base_ir_13_ret_pag  ,
          val_base_isencao  ,
          ind_processo  ,
          cod_banco ,
          num_agencia ,
          num_dv_agencia  ,
          num_conta ,
          num_dv_conta  ,
          cod_tipo_conta  ,
          val_base_prev ,
          flg_ind_cheq  ,
          flg_ind_analise ,
          dat_pagamento ,
          per_rateio  ,
          dat_ingresso  ,
          val_base_ir_acum  ,
          cod_dissociacao ,
          val_base_redutor

      )
                   SELECT
                   ------ Campos indicadore da Folha ------
                     p1.cod_ins           ,
                     p1.tip_processo      ,
                     p1.per_processo      ,
                     p1.seq_pagamento     ,
                  -----------------------------------------
                     P1.COD_IDE_CLI                     ,  --  Identificado do Servidor Gerador de pens?o
                     P1.num_matricula                   ,  --  Matricula do Servidor
                     P1.cod_ide_rel_func                ,  --  Codigo de Vinculo do Servidor
                     rf.cod_entidade                    ,  --  Entidade do Servidor
                     rf.cod_proc_grp_pag                ,  --  Grupo de Pagamento do Servidor
                     dp.num_depend                      ,  --  Numero do Dependente
                     P1.COD_IDE_CLI_BEN                 ,
                     F1.NUM_CPF            CPF_SERVIDOR    ,
                     F1.NOM_PESSOA_FISICA  NOME_SERVIDOR   ,
                     F2.NUM_CPF            CPF_ALIMENTADO  ,
                     F2.NOM_PESSOA_FISICA  NOME_ALIMENTADO ,
                     P1.COD_IDE_CLI        COD_IDE_TUT     ,
                     F1.NOM_PESSOA_FISICA  NOM_TUT         ,
                     TO_DATE(sysdate) AS     DAT_PROCESSAO  ,  -- TO_DATE( P_PERIODO,'DD/MM/YYYY')     DAT_PROCESSAO,
                     TO_NUMBER(0000000000.00000 ) VAL_SAL_BASE                     ,
                     sum(DECODE(p1.flg_natureza, 'D', P1.VAL_RUBRICA, 0)) TOT_CRED,
                     sum(DECODE(p1.flg_natureza, 'C', P1.VAL_RUBRICA, 0)) TOT_DEB ,
                     sum(DECODE(p1.flg_natureza,
                                'D',
                                P1.VAL_RUBRICA,
                                P1.VAL_RUBRICA * -1)) VAl_LIQUIDO,
                     TO_NUMBER(0000000000.00000 )     VAL_BASE_IR        ,
                     TO_NUMBER(0000000000.00000 )     VAL_IR_RET         ,
                     TO_NUMBER(0000000000.00000 )     DED_BASE_IR        ,
                     TO_NUMBER(0000000000.00000 )     DED_IR_OJ          ,
                     TO_NUMBER(0000000000.00000 )     DED_IR_DOENCA      ,
                     TO_NUMBER(0000000000.00000 )     DED_IR_PA          ,
                     'S' FLG_PAG             ,
                     'N' FLG_IND_PAGO        ,
                     'N' FLG_IND_ULTIMO_PAG  ,
                     0 TOT_CRED_PAG          ,
                     0 TOT_DEB_PAG           ,
                     0 va_LIQUIDO_PAG        ,
                     0 VAL_BASE_IR_PAG       ,
                     0 VAL_IR_RET_PAG        ,
                     0 VAL_BASE_IR_13        ,
                     0 VAL_IR_13_RET         ,
                     0 VAL_BASE_IR_13_PAG    ,
                     0 VAL_BASE_IR_13_RET_PAG,
                     0 VAL_BASE_ISENCAO      ,
                     'S' IND_PROCESSO        ,
                     TO_CHAR('     ')     COD_BANCO         ,
                     TO_CHAR('        ')  NUM_AGENCIA       ,
                     TO_CHAR('        ')  NUM_DV_AGENCIA    ,
                     TO_CHAR('             ') NUM_CONTA     ,
                     TO_CHAR('        ')  NUM_DV_CONTA       ,
                     TO_CHAR('        ')  COD_TIPO_CONTA    ,

                     0 VAL_BASE_PREV         ,
                     'R' FLG_IND_CHEQ        ,
                     'R' FLG_IND_ANALISE     ,
                     NULL /*I_DATA_PAGAMENTO  */     DAT_PAGAMENTO    ,
                     TO_NUMBER(0000000000.00000 )    PER_RATEIO       ,
                     SYSDATE                         DAT_INGRESSO     ,
                     TO_NUMBER(0000000000.00000 )    VAL_BASE_IR_ACUM ,
                     TO_NUMBER(0000000000.00000 )    COD_DISSOCIACAO  ,
                     TO_NUMBER(0000000000.00000 )     VAL_BASE_REDUTOR

                 FROM
                       TB_FOLHA_PAGAMENTO_DET P1 ,
                       TB_RELACAO_FUNCIONAL RF   ,
                       TB_DEPENDENTE        DP   ,
                       TB_PESSOA_FISICA F1       ,
                       TB_PESSOA_FISICA F2
                WHERE
                  ----------------- Nova Join ------------------------------
                  P1.cod_ins          = PAR_COD_INS                      and
                  p1.cod_ins          = RF.cod_ins                       and
                  p1.num_matricula    = RF.num_matricula                 and
                  p1.cod_ide_rel_func = RF.cod_ide_rel_func              and
                  p1.tip_processo     = PAR_TIP_PRO                      and
                  p1.per_processo     = PAR_PER_PRO                      and
                  p1.seq_pagamento    = PAR_SEQ_PAGAMENTO                and
                  f1.cod_ins          = RF.COD_INS                       and
                  f1.cod_ide_cli      = p1.cod_ide_cli                   and
                  f2.cod_ins          = RF.COD_INS                       and
                  f2.cod_ide_cli      = p1.cod_ide_cli_ben               and
                  dp.cod_ins          = RF.cod_ins                       and
                  dp.cod_ide_cli_serv = f1.cod_ide_cli                   and
                  dp.cod_ide_cli_dep  = f2.cod_ide_cli                   and
                  --------------  Vinculo da PA -------------------------------
                  P1.COD_IDE_CLI      =RFOL.COD_IDE_CLI                  and
                  P1.NUM_MATRICULA    =RFOL.NUM_MATRICULA                and
                  P1.COD_IDE_REL_FUNC =RFOL.COD_IDE_REL_FUNC             and
                  rf.cod_entidade     = NVL( rfol.COD_ENTIDADE,RF.cod_entidade)      and
                  rf.cod_proc_grp_pag = NVL( rfol.NUM_GRP   , RF.cod_proc_grp_pag)   and
                  ----------------------------------------------------------

                EXISTS
                 (
                      SELECT 1
                        FROM  TB_RUBRICAS P
                       WHERE P.COD_INS               =  PAR_COD_INS
                         AND P1.COD_FCRUBRICA        =  P.COD_RUBRICA
                         AND P.TIP_EVENTO_ESPECIAL   = 'P'
                         AND P.COD_ENTIDADE          = rfol.COD_ENTIDADE
                 )
               group by
                     -------------------------------------
                     p1.cod_ins                         ,
                     p1.tip_processo                    ,
                     p1.per_processo                    ,
                     p1.seq_pagamento                   ,
                     P1.COD_IDE_CLI                     ,  --  Identificado do Servidor Gerador de pens?o
                     P1.num_matricula                   ,  --  Matricula do Servidor
                     P1.cod_ide_rel_func                ,  --  Codigo de Vinculo do Servidor
                     rf.cod_entidade                    ,  --  Entidade do Servidor
                     rf.cod_proc_grp_pag                ,  --  Grupo de Pagamento do Servidor
                     dp.num_depend                      ,  --  Numero do Dependente
                     P1.COD_IDE_CLI_BEN                 ,
                     F1.NUM_CPF                         ,
                     F1.NOM_PESSOA_FISICA               ,
                     F2.NUM_CPF                         ,
                     F2.NOM_PESSOA_FISICA               ,
                     p1.cod_ins                         ,
                     p1.tip_processo                    ,
                     p1.per_processo                    ,
                     p1.seq_pagamento                   ,
                     ------------------------------------
                     p1.cod_ide_cli                     ,
                     p1.num_matricula                   ,
                     p1.cod_ide_rel_func                ,
                     dp.num_depend                      ,
                     rf.cod_proc_grp_pag                ,
                     p1.cod_ide_cli_ben                 ,
                     f1.num_cpf                         ,
                     f1.nom_pessoa_fisica               ,
                     f2.num_cpf                         ,
                     f2.nom_pessoa_fisica               ;

    EXCEPTION
     WHEN OTHERS THEN
                         p_coderro       := sqlcode;
                         p_sub_proc_erro := 'SP_FOLHA_CALCULADA -FOLHA PA';
                         p_msgerro       := sqlerrm;
                         INCLUI_LOG_ERRO_FOLHA(par_cod_ins,
                                                p_coderro,
                                                'Calcula Folha',
                                                sysdate,
                                                p_msgerro,
                                                p_sub_proc_erro,
                                                rfol.COD_IDE_CLI ,
                                                0);


   END;

  END LOOP;
  COMMIT;


END  SP_GERA_FOLHA_PA;

FUNCTION SP_OBTEM_DIAS_AVISO_PREVIO Return number IS

  DIAS_AVISO          number :=0;
  I_DAT_INI_REF       DATE;
  I_DAT_FIM_REF       DATE;
  I_MESES             NUMBER;

  BEGIN

      SELECT TRUNC(RF.DAT_AVISO_PREVIO) - TRUNC(RF.DAT_FIM_EXERC)
      INTO DIAS_AVISO
      FROM TB_RELACAO_FUNCIONAL RF
     WHERE RF.COD_INS              = PAR_COD_INS
       AND RF.COD_IDE_CLI          = COM_COD_IDE_CLI
       AND RF.COD_ENTIDADE         = COM_ENTIDADE
       AND RF.NUM_MATRICULA        = COM_NUM_MATRICULA
       AND RF.COD_IDE_REL_FUNC     = COM_COD_IDE_REL_FUNC
       AND PAR_PER_PRO BETWEEN RF.DAT_INI_EXERC AND RF.DAT_FIM_EXERC
       AND RF.COD_TIP_AVISO_PREVIO = '02'
         ;

  RETURN (DIAS_AVISO);

  END SP_OBTEM_DIAS_AVISO_PREVIO;


FUNCTION SP_OBTEM_QTD_DIAS_PENAL
    RETURN NUMBER IS
    V_DIAS_TRAB  NUMBER;

    BEGIN

         SELECT  SUM(QTD_DIAS)
           INTO V_DIAS_TRAB
           FROM (
        SELECT ((CASE WHEN (F3.DAT_INI_PEN <= PAR_PER_PRO) THEN FNC_GET_DIAS_MENOR_30(F3.DAT_FIM_PEN - PAR_PER_PRO) ELSE  FNC_GET_DIAS_MENOR_30(F3.DAT_FIM_PEN - F3.DAT_INI_PEN) END)+1) AS QTD_DIAS
              FROM TB_PENALIDADE  F3
             WHERE PAR_PER_PRO BETWEEN
                   TO_DATE('01/'||to_char(  F3.DAT_INI_PEN,'MM/YYYY'),'DD/MM/YYYY')  AND F3.DAT_FIM_PEN
               AND F3.COD_IDE_CLI      = COM_COD_IDE_CLI
               AND F3.COD_ENTIDADE     = COM_ENTIDADE
               AND F3.NUM_MATRICULA    = COM_NUM_MATRICULA
               AND F3.COD_IDE_REL_FUNC = COM_COD_IDE_REL_FUNC
               AND F3.FLG_DESCONTA     ='S' ) TB1
            ;
      IF V_DIAS_TRAB < 0 THEN
        V_DIAS_TRAB:=0;
      END IF;
      RETURN (V_DIAS_TRAB);

    EXCEPTION WHEN NO_DATA_FOUND THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);
              WHEN OTHERS THEN
                  V_DIAS_TRAB := 0;
                  RETURN (V_DIAS_TRAB);

  END SP_OBTEM_QTD_DIAS_PENAL;


  PROCEDURE SP_GRAVA_INFO_REF AS

  BEGIN

      UPDATE TB_FOLHA_PAGAMENTO D
         SET D.COD_BANCO      = (SELECT COD_BANCO      FROM TB_INFORMACAO_BANCARIA IB WHERE IB.COD_INS = D.COD_INS AND IB.COD_IDE_CLI = D.COD_IDE_CLI AND ROWNUM < 2)
         , D.NUM_AGENCIA      = (SELECT NUM_AGENCIA    FROM TB_INFORMACAO_BANCARIA IB WHERE IB.COD_INS = D.COD_INS AND IB.COD_IDE_CLI = D.COD_IDE_CLI AND ROWNUM < 2)
         , D.NUM_DV_AGENCIA   = (SELECT NUM_DV_AGENCIA FROM TB_INFORMACAO_BANCARIA IB WHERE IB.COD_INS = D.COD_INS AND IB.COD_IDE_CLI = D.COD_IDE_CLI AND ROWNUM < 2)
         , D.NUM_CONTA        = (SELECT NUM_CONTA      FROM TB_INFORMACAO_BANCARIA IB WHERE IB.COD_INS = D.COD_INS AND IB.COD_IDE_CLI = D.COD_IDE_CLI AND ROWNUM < 2)
         , D.NUM_DV_CONTA     = (SELECT NUM_DV_CONTA   FROM TB_INFORMACAO_BANCARIA IB WHERE IB.COD_INS = D.COD_INS AND IB.COD_IDE_CLI = D.COD_IDE_CLI AND ROWNUM < 2)
         , D.COD_TIPO_CONTA   = (SELECT COD_TIPO_CONTA FROM TB_INFORMACAO_BANCARIA IB WHERE IB.COD_INS = D.COD_INS AND IB.COD_IDE_CLI = D.COD_IDE_CLI AND ROWNUM < 2)
         , D.NUM_DEP_IR       = (SELECT PF.NUM_DEP_IR  FROM TB_PESSOA_FISICA       PF WHERE PF.COD_IDE_CLI = D.COD_IDE_CLI)
       WHERE D.COD_INS        = PAR_COD_INS
         AND D.TIP_PROCESSO   = PAR_TIP_PRO
         AND D.COD_IDE_CLI    = COM_COD_IDE_CLI
         AND D.PER_PROCESSO   = PAR_PER_PRO;

  EXCEPTION
      WHEN OTHERS THEN
         NULL;
  END SP_GRAVA_INFO_REF;

PROCEDURE SP_OBTER_DIF_RET(P_num_matricula     IN NUMBER,
                             P_cod_ide_rel_func  IN NUMBER,
                             P_cod_entidade      IN NUMBER,
                             P_COD_RUBRICA       IN NUMBER,
                             VAL_RET             IN NUMBER,
                             P_IDE_CLI           IN VARCHAR2,
                             P_COD_IDE_CLI_BEN   IN VARCHAR2,
                             P_FLG_NATUREZA      IN VARCHAR2,
                             P_INI_REF           IN DATE,
                             VALOR               OUT NUMBER,
                             EVENTO_ESPECIAL     OUT VARCHAR2) IS


    V_EVENTO_ESPECIAL TB_RUBRICAS.TIP_EVENTO_ESPECIAL%TYPE;
    VALOR_O           number;
    VALOR_1           number;
    VALOR_CALC        NUMBER := 0;

  BEGIN

      IF TO_CHAR(P_INI_REF,'MMYYYY') =to_char(PAR_PER_PRO, 'MMYYYY') THEN
       begin
        VI_PAGAR := TRUE;

        SELECT sum(decode(flg_natureza, 'C', val_rubrica, val_rubrica * -1))
          INTO VALOR_O
          FROM tb_hfolha_pagamento_det DC
         WHERE DC.COD_INS = PAR_COD_INS
           AND PER_PROCESSO =
               to_date('01' || to_char(PAR_PER_PRO, 'MMYYYY'), 'DDMMYYYY')
           AND DC.TIP_PROCESSO in ('N', 'S', 'T' )
           AND COD_IDE_CLI       = P_IDE_CLI
           AND NUM_MATRICULA    = P_NUM_MATRICULA
           AND COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
           AND COD_ENTIDADE     = P_COD_ENTIDADE

           AND trunc(COD_FCRUBRICA/100) =
               trunc(P_COD_RUBRICA / 100, 000)

           AND DC.DAT_INI_REF =
              to_date('01' || to_char(PAR_PER_PRO, 'MMYYYY'), 'DDMMYYYY')
         AND nvl(DC.COD_IDE_CLI_BEN, 0) = nvl(P_COD_IDE_CLI_BEN, 0);

      exception
        when no_data_found then
          valor_o  := 0;
          VI_PAGAR := FALSE;
      end;
    ELSE
      begin
       VI_PAGAR := TRUE;

        SELECT sum(decode(flg_natureza, 'C', val_rubrica, val_rubrica * -1))
          INTO VALOR_O

          FROM  tb_hfolha_pagamento_det DC
         WHERE DC.COD_INS = PAR_COD_INS
           AND PER_PROCESSO =
               to_date('01' || to_char(PAR_PER_PRO, 'MMYYYY'), 'DDMMYYYY')
           AND DC.TIP_PROCESSO in ('N', 'S'/*, 'T'*/)
           AND COD_IDE_CLI      = P_IDE_CLI
            AND NUM_MATRICULA    = P_NUM_MATRICULA
           AND COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
           AND COD_ENTIDADE     = P_COD_ENTIDADE
           AND trunc(COD_FCRUBRICA/100) =
               trunc(P_COD_RUBRICA / 100, 000)

           AND to_date('01' || to_char(DC.DAT_INI_REF ,'MMYYYY'), 'DDMMYYYY')  =
               to_date('01' || to_char(P_INI_REF, 'MMYYYY'), 'DDMMYYYY')

          AND nvl(DC.COD_IDE_CLI_BEN, 0) = nvl(P_COD_IDE_CLI_BEN, 0);

      exception
        when no_data_found then
          valor_o  := 0;
          VI_PAGAR := FALSE;
      end;
    END IF;
      --- Alterac?o de Codigo Para Teste de Retroativo.----02-08-2010
      begin
        SELECT nvl(sum(decode(flg_natureza,
                              'C',
                              val_rubrica,
                              val_rubrica * -1)),
                   0)
          INTO VALOR_1

          FROM tb_hfolha_pagamento_det DC
         WHERE DC.COD_INS = PAR_COD_INS
           AND (DC.DAT_INI_REF = PAR_PER_PRO)
           AND DC.TIP_PROCESSO in ('N', 'S'/*, 'T'*/)
           AND COD_IDE_CLI       = P_IDE_CLI
           AND NUM_MATRICULA    = P_NUM_MATRICULA
           AND COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
           AND COD_ENTIDADE     = P_COD_ENTIDADE

           AND DC.PER_PROCESSO <> PAR_PER_PRO ---RAO 20060410
           AND trunc(COD_FCRUBRICA/100) =
               trunc(P_COD_RUBRICA / 100, 000)
           AND nvl(DC.COD_IDE_CLI_BEN, 0) = nvl(P_COD_IDE_CLI_BEN, 0)
          ;

      exception
        when no_data_found then
          valor_1 := 0;
          IF NOT VI_PAGAR THEN
            VI_PAGAR := FALSE;
          END IF;
      end;

      IF VALOR_O IS NULL AND VALOR_1 = 0 THEN
        VALOR_O  := 0;
        VI_PAGAR := FALSE;
      ELSIF VALOR_O IS NULL AND (VALOR_1 > 0 or VALOR_1 < 0) THEN
        VALOR_O := 0;
      END IF;

      IF P_FLG_NATUREZA = 'D' THEN
        VALOR_CALC := VAL_RET * -1;
      ELSE
        VALOR_CALC := VAL_RET;
      END IF;

     VALOR_O := VALOR_CALC - (VALOR_O + VALOR_1);

      VALOR := VALOR_O;


  END SP_OBTER_DIF_RET;

FUNCTION SP_OBTEM_DED_LEGAIS_IRRF(tipo_irr IN VARCHAR)   RETURN NUMBER IS
    O_VALOR NUMBER(18, 4);
    i       number := 0;
    limit_dedu number:=0;
    v_calculo  NUMBER(18, 4):=0;

  BEGIN
    O_VALOR := 0;

     limit_dedu := case
                             when tipo_irr ='A' then  tdcn_irrf.count
                             when tipo_irr ='R' then  tdcn_irrf_RETRO.count
                             when tipo_irr ='D' then  tdcn_irrf_RETRO13.count
                             else  tdcn.count  end;


    FOR i IN 1 .. limit_dedu  LOOP
      rdcn := case           when tipo_irr ='A' then  tdcn_irrf(i)
                             when tipo_irr ='R' then  tdcn_irrf_RETRO(i)
                             when tipo_irr ='D' then  tdcn_irrf_RETRO13(i)

                             else  tdcn(i)  end;

      ant_entidade:=RDCN.COD_ENTIDADE;
      IF SP_DED_IR_LEGAL(rdcn.cod_fcrubrica) and rdcn.per_processo = PAR_PER_PRO THEN
        o_valor := o_valor + rdcn.val_rubrica;
      END IF;

    END LOOP;

    RETURN(O_VALOR);
  END SP_OBTEM_DED_LEGAIS_IRRF;


  FUNCTION SP_DED_IR_LEGAL(I_NUM_FCRUBRICA NUMBER) RETURN BOOLEAN IS  -- Roberto - 25/05/2023
    O_DED_IR BOOLEAN;
    i number := 0;

  BEGIN
    o_ded_ir := FALSE;

    FOR i IN 1 .. cod_con2.count LOOP

        IF cod_rub2(i) = i_num_fcrubrica THEN

            -- LJUNIOR TT86944 em 22/05/2023
            IF NOT  VI_IR_EXTERIOR THEN
               IF flag_ded_Legal(i) = 'S' THEN
                  O_DED_IR := TRUE;
                END IF;
            END IF;

        END IF;
    END LOOP;

    RETURN(o_ded_ir);
  END SP_DED_IR_LEGAL;

  
  FUNCTION SP_TRADUCAO_FORMULA (V_FORMULA  IN VARCHAR2 ) 
  RETURN VARCHAR2   IS V_FORMULA_TRADUCAO  VARCHAR2(1000);
  BEGIN
    V_FORMULA_TRADUCAO:= V_FORMULA;
     IF V_FORMULA_TRADUCAO is not null THEN
 
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'then 1 else 0',' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'select'    ,' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'from dual' ,' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'case'      ,' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'end from dual',' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'when',' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'if'  ,' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'then',' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'else',' ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'AND',' E ') ;
     V_FORMULA_TRADUCAO:=REPLACE (V_FORMULA_TRADUCAO,'end','  ') ;
      NULL;
   ELSE
    V_FORMULA_TRADUCAO:=NULL;
   END IF;
     RETURN V_FORMULA_TRADUCAO;
  END SP_TRADUCAO_FORMULA;  
	
	
	 FUNCTION SP_IRRF_SIMPLIFICADO(ide_cli in varchar2) return boolean is
 
  cod_regime_jur         NUMBER(8) ;
  tip_provimento         VARCHAR2(5);
  cod_tipo_hist_ini      VARCHAR2(5);
  cod_vinculo            NUMBER(8);

  Begin
  

        select distinct
             RF.COD_REGIME_JUR    ,
             RF.TIP_PROVIMENTO    ,
             RF.COD_TIPO_HIST_INI ,
             RF.COD_VINCULO
         into cod_regime_jur   ,
              tip_provimento    ,
              cod_tipo_hist_ini ,
              cod_vinculo
        from tb_relacao_funcional      rf
        where rf.cod_ins          = PAR_COD_INS
         and rf.num_matricula    = COM_NUM_MATRICULA
         and rf.cod_ide_rel_func = COM_COD_IDE_REL_FUNC
         and rf.cod_entidade     = COM_ENTIDADE
         AND rf.cod_ide_cli      = ide_cli;
         
         if COD_VINCULO = 4 then  
                 
            RETURN TRUE;           
          ELSE
             RETURN FALSE ;
        END IF;    
  End SP_IRRF_SIMPLIFICADO;
	-- Ticket 91568 - Roberto
	PROCEDURE SP_OBTEM_QTD_DEPENDENTES_IR(P_COD_IDE_CLI IN VARCHAR2,
                                     O_VALOR       OUT NUMBER) AS

    num_dependentes number := 0;

  BEGIN

    num_dependentes := 0;
		
    BEGIN
    select pf.num_dep_ir
     into  o_valor
     from  tb_pessoa_fisica pf
     where pf.cod_ins = par_cod_ins
     and   pf.cod_ide_cli = P_COD_IDE_CLI;
    EXCEPTION 
		   WHEN NO_DATA_FOUND THEN
       o_valor := 0;
    end;

  END SP_OBTEM_QTD_DEPENDENTES_IR;
	
	
	 ------- Incluido 21-05-2024 ---- Roberto
 PROCEDURE SP_AJUSTA_TOTAIS AS

  vi_rubrica           number;
  BEGIN


          vi_rubrica:=99200;
          FOR X IN 1 .. tdcn.COUNT LOOP
            rdcn  := tdcn(X);
            IF rdcn.COD_FCRUBRICA = vi_rubrica
               THEN

              COM_COD_RUBRICA    := vi_rubrica;
              COM_COD_FCRUBRICA  := vi_rubrica;
              COM_NUM_MATRICULA  := rdcn.num_matricula;
              COM_COD_ENTIDADE   := COM_ENTIDADE;
              ben_ide_cli        := rdcn.cod_ide_cli;
              --v_processa_rubrica := true;
              COM_FLG_PROCESSA:='S';
              COM_NAT_RUB     :='C';
             ---- Agregado para controle de consig--
              COM_IND_QTAS    :='N';

             -- SP_PROCESSA_RUBRICA(v_processa_rubrica);
              SP_CALCULA_VALOR_RUBRICA;
              rdcn := tdcn(x);
              --Yumi em 22/08/2018: Folha 08/2018: Ajustado para n?o proporcionalizar estas bases
              --rdcn.val_rubrica := mon_calculo;
              rdcn.val_rubrica := COM_VAL_RUBRICA_CHEIO;
              rdcn.val_rubrica_cheio := COM_VAL_RUBRICA_CHEIO;
              tdcn(x) := rdcn;
             END IF;
          END LOOP;

          vi_rubrica:=99000;
          FOR X IN 1 .. tdcn.COUNT LOOP
            rdcn  := tdcn(X);
            IF rdcn.COD_FCRUBRICA = vi_rubrica
               THEN

              COM_COD_RUBRICA    := vi_rubrica;
              COM_COD_FCRUBRICA  := vi_rubrica;
              COM_NUM_MATRICULA  := rdcn.num_matricula;
              COM_COD_ENTIDADE   :=COM_ENTIDADE;
              ben_ide_cli        :=rdcn.cod_ide_cli;
              --v_processa_rubrica := true;
              COM_FLG_PROCESSA:='S';
              COM_NAT_RUB     :='C';
             ---- Agregado para controle de consig--
              COM_IND_QTAS    :='N';

             -- SP_PROCESSA_RUBRICA(v_processa_rubrica);
              SP_CALCULA_VALOR_RUBRICA;
              rdcn := tdcn(x);
              --Yumi em 22/08/2018: Folha 08/2018: Ajustado para n?o proporcionalizar estas bases
              --rdcn.val_rubrica := mon_calculo;
              rdcn.val_rubrica := COM_VAL_RUBRICA_CHEIO;
              rdcn.val_rubrica_cheio := COM_VAL_RUBRICA_CHEIO;
              tdcn(x) := rdcn; 
							vi_base_prev := COM_VAL_RUBRICA_CHEIO;
             END IF;
          END LOOP;


  END SP_AJUSTA_TOTAIS;
  

  
  FUNCTION SP_OBTER_VALOR_BAR return NUMBER is
    v_val_multa number;
  BEGIN
     select val_multa 
      into   v_val_multa
     from tb_penalidade g
     where  g.NUM_MATRICULA    = COM_NUM_MATRICULA
     and    dat_lancamento_folha = PAR_PER_PRO
     and    g.cod_ide_rel_func = COM_COD_IDE_REL_FUNC;
     
     return v_val_multa;
      
  END;
  
end  PAC_FOLHA_CALCULADA_ATIVO;
/
