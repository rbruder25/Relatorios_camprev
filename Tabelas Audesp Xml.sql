/*  
1
   <foap:Descritor>'         || CHR(10) ||
                  '        <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '        <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '        <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '        <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '        <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '        <gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                  '    </foap:Descritor>'        || CHR(10);   

-------------------------------------------------------------------------------------------------
/*
2
'<gen:Numero>'                            || REC.NUM_CPF      ||'</gen:Numero>'                          || CHR(10) ||
  '<ap:Nome>'                               || REC.NOM_BEN      ||' </ap:Nome>'                            || CHR(10) ||
'<ap:MunicipioLotacao>'                     || V_MUNICIPIO      ||'</ap:MunicipioLotacao>'                 || CHR(10) ||
'<ap:EntidadeLotacao>'                      || V_ENTIDADE |     |'</ap:EntidadeLotacao>'                  || CHR(10) ||
'<ap:CargoPolitico>'                        || V_CARGO_POLITICO ||'</ap:CargoPolitico>'                    || CHR(10) ||
'<ap:FuncaoGoverno>'                        || '99'             ||'</ap:FuncaoGoverno>'                    || CHR(10) ||
--                                  '<ap:Estagiario>'                           || '2'            ||'</ap:Estagiario>'                       || CHR(10) ||
'<ap:CodigoCargo>'                          || REC.COD_CARGO    ||'</ap:CodigoCargo>'                      || CHR(10) ||

'<ap:Situacao>'                             || V_COD_SITUACAO   ||'</ap:Situacao>'                         || CHR(10) ||
'<ap:RegimeJuridico>'                       || V_COD_REGIME_JUR ||'</ap:RegimeJuridico>'                   || CHR(10) ||
'<ap:PossuiAutorizRecebAcimaTeto>'          || '2'              ||'</ap:PossuiAutorizRecebAcimaTeto>'      || CHR(10) ||
 '<foap:Valores>'                            || CHR(10) ||
    '<foap:totalGeralDaRemuneracaoBruta>'   || REC.TOT_CRED     ||'</foap:totalGeralDaRemuneracaoBruta>'   || CHR(10) ||
    '<foap:totalGeralDeDescontos>'          || REC.TOT_DEB      ||'</foap:totalGeralDeDescontos>'          || CHR(10) ||
'</foap:Valores>'                           || CHR(10) ||
    '<foap:totalGeralDaRemuneracaoLiquida>' || REC.VAL_LIQUIDO  ||'</foap:totalGeralDaRemuneracaoLiquida>' || CHR(10) ||
     V_TAG_VERBAS                           || CHR(10) ||
'</foap:IdentificacaoAgentePublico>'  */

 /*   V_TAG_VERBAS_NEW   := '<foap:Verbas>' || CHR(10) ||
                            '<foap:MunicipioVerbaRemuneratoria>'        || V_MUNICIPIO                      ||'</foap:MunicipioVerbaRemuneratoria>'  || CHR(10) ||
                            '<foap:EntidadeVerbaRemuneratoria>'         || V_ENTIDADE                 ||'</foap:EntidadeVerbaRemuneratoria>'   || CHR(10) ||
                            '<foap:CodigoVerbaRemuneratoria>'           || V_COD_VERBA                      ||'</foap:CodigoVerbaRemuneratoria>'     || CHR(10) ||
                            '<foap:Valor>'                              || NVL(REC2.PROVENTO,REC2.DESCONTO) ||'</foap:Valor>'                        || CHR(10) ||
                            '<foap:Natureza>'                           || REC2.NATUREZA                    ||'</foap:Natureza>'                     || CHR(10) ||
                            '<foap:Especie>'                            || REC2.ESPECIE                     ||'</foap:Especie>'                      || CHR(10) ||
                            '<foap:TipoVerbaRemuneratoria>'             || CHR(10) ||
                                  '<foap:CodigoTipoVerbaRemuneratoria>' || V_COD_VERBA                        ||'</foap:CodigoTipoVerbaRemuneratoria>' || CHR(10) ||
                            '</foap:TipoVerbaRemuneratoria>'            || CHR(10) ||
                            '</foap:Verbas>'  ;

         V_TAG_VERBAS   :=  V_TAG_VERBAS || V_TAG_VERBAS_NEW;
*/


CREATE TABLE TB_AUDESP_ORDINARIA
(
   ANO                  VARCHAR2(2),
   MES                  VARCHAR(2), 
   TIPO_DOCUMENTO       VARCHAR(5),
   DATA_ATUAL           DATE, 
   CPF                  VARCHAR2(12),
   NOME                 VARCHAR2(100),
   MUNICIPIO            VARCHAR2(100),
   ENTIDADE             VARCHAR(10),
   CARGO_POLITICO       VARCHAR2(100),
   FuncaoGoverno        VARCHAR(100),
   ESTAGIARIO           NUMBER,
   CARGO                NUMBER,
   SITUACAO             NUMBER,
   REGIME_JUR           NUMBER,
   AUT_ACIMA_TETO       NUMBER,
   TOT_CRED             NUMBER(10,2),
   TOT_DEB              NUMBER(10,2),
   VAL_LIQUIDO          NUMBER(10,2),                 
   COD_VERBA            NUMBER,                    
   PROVENTO             NUMBER(10,2), 
   NATUREZA             VARCHAR2(10),                 
   ESPECIE              VARCHAR2(10) 
   DAT_ULT_ATU          DATE
 );                                            
--------------------------------------------------------------------
CREATE TABLE TB_AUDESP_SUPLEMENTAR
(
   ANO              VARCHAR2(2),
   MES              VARCHAR(2), 
   TIPO_DOCUMENTO   VARCHAR(5),
   DATA_ATUAL       DATE,
   CPF              VARCHAR2(12),
   NOME             VARCHAR2(100),
   MUNICIPIO        VARCHAR2(100),
   ENTIDADE         VARCHAR(10),
   CARGO_POLITICO   VARCHAR2(100),
   FuncaoGoverno    VARCHAR(100),
   CARGO            NUMBER,
   SITUACAO         NUMBER,
   REGIME_JUR       NUMBER,
   AUT_ACIMA_TETO   NUMBER,             
   TIPO_CONTA       VARCHAR(20),
   COD_BANCO        NUMBER , 
   AGENCIA          VARCHAR2(15),  
   CONTA            NUMBER,
   TOT_CRED         NUMBER(10,2), 
   TOT_DEB          NUMBER(10,2),   
   VAL_LIQUIDO      NUMBER(10,2),  
   VAL_LIQ_CC       NUMBER(10,2),
   VALOR_FORMAS     NUMBER(10,2),
   DAT_ULT_ATU              DATE
 )          
------------------------------------------------------------------------
 CREATE TABLE TB_AUDESP_ORDINARIO
(
   ANO              VARCHAR2(2),
   MES              VARCHAR(2), 
   TIPO_DOCUMENTO   VARCHAR(5),
   DATA_ATUAL       DATE,
   CPF              VARCHAR2(12),
   MUNICIPIO        VARCHAR2(100),
   ENTIDADE         VARCHAR(10),
   CARGO            NUMBER,  
   TIPO_CONTA       VARCHAR(20),
   COD_BANCO        NUMBER , 
   AGENCIA          VARCHAR2(15),  
   CONTA            NUMBER,
   PAGO_CORRENTE    NUMBER(10,2),
   PAGO_OUTRAS      NUMBER(10,2),
   DAT_ULT_ATU      DATE
 )
--------------------------------------------------------------------
CREATE TABLE TB_AUDESP_RESUMO_MENSAL
(
   ANO                      VARCHAR2(2),
   MES                      VARCHAR(2), 
   TIPO_DOCUMENTO           VARCHAR(5),
   DATA_ATUAL               DATE,
   MUNICIPIO                VARCHAR2(100),
   ENTIDADE                 VARCHAR(10),
   CONTR_PREV_GERAL_POL     NUMBER(10,2),
   CONTR_PREV_PROP_POL      NUMBER(10,2),
   CONTR_PREV_GERAL_NAO_POL NUMBER(10,2), 
   CONTR_PREV_PROP_NAO_POL  NUMBER(10,2),
   DAT_ULT_ATU              DATE
)

 
 

 
 
 
 
 

