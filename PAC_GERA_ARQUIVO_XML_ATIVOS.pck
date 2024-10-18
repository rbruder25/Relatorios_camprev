CREATE OR REPLACE PACKAGE "PAC_GERA_ARQUIVO_XML_ATIVOS" IS




 V_AUDESP INTEGER :=1;


PROCEDURE SP_GERA_FOLHA_ORDINARIA
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_GERA_FOLHA_SUPLEMENTAR
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_CRIA_CADASTRO
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_CRIA_AGENTE_PUBLICO
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_LOTACAO_AGENTE_PUBLICO
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_RESUMO_MENSAL
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_VERBA_REMUNERATORIAS
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_PAGAMENTO_FOLHA_ORDINARIA
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_EXECUTA_XML
(
 P_TIPO_GERACAO      IN NUMBER,
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
);

PROCEDURE SP_ATOS_QUADRO_PESSOAL
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE
);

PROCEDURE SP_CLOB_TO_FILE
( P_FILE_NAME       IN VARCHAR2,
  P_DIR             IN VARCHAR2,
  P_CLOB            IN CLOB );

FUNCTION FNC_GET_DES_DESCRICAO(P_COD_INS IN TB_CODIGO.COD_INS%TYPE,
                               P_COD_NUM IN TB_CODIGO.COD_NUM%TYPE,
                               P_COD_PAR IN TB_CODIGO.COD_PAR%TYPE)

 RETURN TB_CODIGO.DES_DESCRICAO%TYPE;

PROCEDURE SP_REMUN_AGENTE_POLITICO
(P_ANO_REF   NUMBER);




END PAC_GERA_ARQUIVO_XML_ATIVOS;
/
CREATE OR REPLACE PACKAGE BODY "PAC_GERA_ARQUIVO_XML_ATIVOS" IS



PROCEDURE SP_GERA_FOLHA_ORDINARIA_B
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)
  
  
IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_ID_AGENT_PUBLICO          CLOB;
  V_TAG_ID_PENSIONISTA            CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_VERBAS_NEW                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Folha Ordinária';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA_AUDESP              NUMBER;
  V_COD_VERBA                     NUMBER;
  V_COD_SITUACAO                  NUMBER;
  V_COD_REGIME_JUR                NUMBER;
  V_CARGO_POLITICO                NUMBER;
  V_ESTAGIARIO                    NUMBER;

  CURSOR GET_HEADER_AGENT IS
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
       ,FNC_DEPARA_NOME(V_AUDESP,'e.COD_PARENTESCO-L.69',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 


   FROM TB_HFOLHA_PAGAMENTO      A, 
        TB_PESSOA_FISICA         B,
        TB_DEPENDENTE            E
  WHERE A.COD_ENTIDADE         =  A.COD_ENTIDADE
    AND A.PER_PROCESSO         = P_PERPROCESSO
    AND A.TIP_PROCESSO         = 'N' 
    AND A.COD_ENTIDADE         = '1' 
    AND A.COD_IDE_CLI          = B.COD_IDE_CLI
    AND A.COD_INS              = E.COD_INS          (+)
    AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
    AND A.NUM_GRP              <> 3
    AND A.TOT_CRED             != 0
    AND A.TOT_DEB              != 0
    ORDER BY B.NOM_PESSOA_FISICA;


  CURSOR GET_LINES_AGENT
  (
  P_NUM_CPF              IN VARCHAR2
  )
  IS


      SELECT 

          REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'C',VAL_RUBRICA, NULL))),',','.')   AS PROVENTO
         ,REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'D', VAL_RUBRICA, NULL))),',','.')  AS DESCONTO
         ,DECODE(R1.TIP_EVENTO,'N','2','1')                                                 AS NATUREZA
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')                                          AS ESPECIE
         ,R1.COD_CONCEITO                                                                   AS RUBRICAS
         ,R1.COD_VERBA                                                                      AS TIPO_AUDESP
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_vinculo-L.116',RF.COD_VINCULO) AS CARGO_POLITICO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_sit_prev-L.121',RF.COD_SIT_PREV) AS COD_SITUACAO 


         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.128',RF.COD_REGIME_JUR) AS ESTAGIARIO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.133',RF.COD_REGIME_JUR) AS COD_REGIME_JURIDICO



    FROM TB_HFOLHA_PAGAMENTO_DET         D1,
         TB_HFOLHA_PAGAMENTO             F1,
         TB_RUBRICA_VERBA_AUDESP         R1,
         TB_PESSOA_FISICA                PF,
         TB_RELACAO_FUNCIONAL RF
   WHERE D1.COD_INS              = 1
     AND D1.PER_PROCESSO         = P_PERPROCESSO
     AND D1.TIP_PROCESSO         = 'N'
     AND D1.SEQ_PAGAMENTO        = 1
     AND D1.COD_IDE_CLI          = PF.COD_IDE_CLI
     AND PF.NUM_CPF              = P_NUM_CPF
     AND D1.COD_INS              = F1.COD_INS
     AND D1.PER_PROCESSO         = F1.PER_PROCESSO
     AND D1.TIP_PROCESSO         = F1.TIP_PROCESSO
     AND D1.SEQ_PAGAMENTO        = F1.SEQ_PAGAMENTO
     AND D1.COD_IDE_CLI          = F1.COD_IDE_CLI
     AND R1.COD_INS              = D1.COD_INS
     AND D1.TIP_PROCESSO         = 'N'
     AND R1.COD_ENTIDADE         = F1.COD_ENTIDADE
     AND R1.COD_RUBRICA          = D1.COD_FCRUBRICA

     AND RF.COD_IDE_CLI          = D1.COD_IDE_CLI
     AND RF.COD_IDE_CLI          = F1.COD_IDE_CLI     
     AND RF.COD_IDE_CLI          = PF.COD_IDE_CLI      
     AND F1.NUM_GRP              <> 3


    AND RF.COD_ENTIDADE          = D1.COD_ENTIDADE
    AND RF.NUM_MATRICULA         = D1.NUM_MATRICULA
    AND RF.COD_IDE_REL_FUNC      = D1.COD_IDE_REL_FUNC

    AND D1.COD_ENTIDADE          = F1.COD_ENTIDADE
    AND D1.NUM_MATRICULA         = F1.NUM_MATRICULA
    AND D1.COD_IDE_REL_FUNC      = F1.COD_IDE_REL_FUNC

GROUP BY  DECODE(R1.TIP_EVENTO,'N','2','1')
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')
         ,R1.COD_VERBA

         ,R1.COD_VERBA
         ,R1.COD_CONCEITO
         ,RF.COD_VINCULO
         ,RF.COD_SIT_PREV
         ,RF.COD_REGIME_JUR;



  CURSOR GET_VERBA
  (
  P_COD_ENTIDADE IN TB_RUBRICA_VERBA_AUDESP.COD_ENTIDADE%TYPE,
  P_COD_RUBRICA  IN TB_RUBRICA_VERBA_AUDESP.COD_RUBRICA%TYPE
  )
  IS


  SELECT A.COD_VERBA, B.COD_CONCEITO
    FROM TB_TIPO_VERBA_AUDESP     A,
         TB_RUBRICA_VERBA_AUDESP  B
   WHERE A.COD_INS      = B.COD_INS
     AND A.COD_VERBA    = B.COD_VERBA
     AND B.COD_RUBRICA  = P_COD_RUBRICA;



BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoal_FolhaOrdinaria_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<foap:FolhaOrdinariaAgentePublico'         || CHR(10) ;


  V_TAG_DEFINICOES :=
                  ' xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'     || CHR(10) ||
                  '                 xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'     || CHR(10) ||
                  '                 xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'   || CHR(10) ||
                  '                 xmlns:foap="http://www.tce.sp.gov.br/audesp/xml/remuneracao"' || CHR(10) ||
                  '                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'        || CHR(10) ||

                  '                 xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ./folhaOrdinaria/AUDESP_FOLHA_ORDINARIA_AGENTE_PUBLICO_'||V_ANO||'_A.XSD"> '
                        || CHR(10);

  V_TAG_DESCRITOR :=
                  '    <foap:Descritor>'         || CHR(10) ||
                  '        <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '        <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '        <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '        <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '        <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '        <gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                  '    </foap:Descritor>'        || CHR(10);


  FOR REC IN  GET_HEADER_AGENT LOOP


      V_TAG_VERBAS_NEW := NULL;
      V_TAG_VERBAS     := NULL;

      FOR REC2 IN GET_LINES_AGENT(REC.NUM_CPF) LOOP

         V_COD_VERBA := REC2.RUBRICAS;
         V_COD_VERBA_AUDESP := REC2.TIPO_AUDESP;  

  V_TAG_VERBAS_NEW :=
                  '           <foap:Verbas>' || CHR(10) ||
                  '               <foap:MunicipioVerbaRemuneratoria>'        || V_MUNICIPIO                      ||'</foap:MunicipioVerbaRemuneratoria>'  || CHR(10) ||
                  '               <foap:EntidadeVerbaRemuneratoria>'         || V_ENTIDADE                       ||'</foap:EntidadeVerbaRemuneratoria>'   || CHR(10) ||
                  '               <foap:CodigoVerbaRemuneratoria>'           || V_COD_VERBA                      ||'</foap:CodigoVerbaRemuneratoria>'     || CHR(10) ||
                  '               <foap:Valor>'                              || NVL(REC2.PROVENTO,REC2.DESCONTO) ||'</foap:Valor>'                        || CHR(10) ||
                  '               <foap:Natureza>'                           || REC2.NATUREZA                    ||'</foap:Natureza>'                     || CHR(10) ||
                  '               <foap:Especie>'                            || REC2.ESPECIE                     ||'</foap:Especie>'                      || CHR(10) ||
                  '               <foap:TipoVerbaRemuneratoria>'             || CHR(10) ||
                  '                  <foap:CodigoTipoVerbaRemuneratoria>'    || V_COD_VERBA_AUDESP               ||'</foap:CodigoTipoVerbaRemuneratoria>' || CHR(10) ||
                  '               </foap:TipoVerbaRemuneratoria>'            || CHR(10) ||
                  '           </foap:Verbas>' || CHR(10);

         V_TAG_VERBAS   :=  V_TAG_VERBAS || V_TAG_VERBAS_NEW;

         V_COD_SITUACAO     := REC2.COD_SITUACAO;
         V_COD_REGIME_JUR   := REC2.COD_REGIME_JURIDICO;
         V_CARGO_POLITICO   := REC2.CARGO_POLITICO;
         V_ESTAGIARIO       := REC2.ESTAGIARIO;
      END LOOP;


        V_TAG_ID_AGENT_PUBLICO :=
                  '   <foap:IdentificacaoAgentePublico>'            || CHR(10) ||
                  '      <ap:CPF Tipo="02">'                        || CHR(10) ||
                  '           <gen:Numero>'                         || REC.NUM_CPF      ||'</gen:Numero>'                          || CHR(10) ||
                  '      </ap:CPF>'                                 || CHR(10) ||
                  '      <ap:Nome>'                                 || REC.NOM_BEN      ||'</ap:Nome>'                            || CHR(10) ||
                  '      <ap:MunicipioLotacao>'                     || V_MUNICIPIO      ||'</ap:MunicipioLotacao>'                 || CHR(10) ||
                  '      <ap:EntidadeLotacao>'                      || V_ENTIDADE       ||'</ap:EntidadeLotacao>'                  || CHR(10) ||
                  '      <ap:CargoPolitico>'                        || V_CARGO_POLITICO ||'</ap:CargoPolitico>'                    || CHR(10) ||
                  '      <ap:FuncaoGoverno>'                        || '01'             ||'</ap:FuncaoGoverno>'                    || CHR(10) ||
  --                '      <ap:Estagiario>'                           || V_ESTAGIARIO     ||'</ap:Estagiario>'                       || CHR(10) || 
                  '      <ap:CodigoCargo>'                          || REC.COD_CARGO    ||'</ap:CodigoCargo>'                      || CHR(10) ||

                  '      <ap:Situacao>'                             || V_COD_SITUACAO   ||'</ap:Situacao>'                         || CHR(10) ||
                  '      <ap:RegimeJuridico>'                       || V_COD_REGIME_JUR ||'</ap:RegimeJuridico>'                   || CHR(10) ||
                  '      <ap:PossuiAutorizRecebAcimaTeto>'          || '2'              ||'</ap:PossuiAutorizRecebAcimaTeto>'      || CHR(10) ||

                  '      <foap:Valores>'                            || CHR(10) ||
                  '          <foap:totalGeralDaRemuneracaoBruta>'   || REC.TOT_CRED     ||'</foap:totalGeralDaRemuneracaoBruta>'   || CHR(10) ||
                  '          <foap:totalGeralDeDescontos>'          || REC.TOT_DEB      ||'</foap:totalGeralDeDescontos>'          || CHR(10) ||
                  '          <foap:totalGeralDaRemuneracaoLiquida>' || REC.VAL_LIQUIDO  ||'</foap:totalGeralDaRemuneracaoLiquida>' || CHR(10) ||
                             V_TAG_VERBAS                           || CHR(10) ||
                  '      </foap:Valores>'                           || CHR(10) ||
                  '   </foap:IdentificacaoAgentePublico>'           || CHR(10) ;
        V_FILE :=  V_FILE  || V_TAG_ID_AGENT_PUBLICO;

  END LOOP;


  V_TAG_FIM :=  CHR(10) ||'</foap:FolhaOrdinariaAgentePublico>';

  V_FILE :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR ||   V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_GERA_FOLHA_ORDINARIA_B;

PROCEDURE SP_GERA_FOLHA_ORDINARIA
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)

IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_ID_AGENT_PUBLICO          CLOB;
  V_TAG_ID_PENSIONISTA            CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_VERBAS_NEW                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Folha Ordinária';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='0007';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_COD_SITUACAO                  NUMBER;
  V_COD_REGIME_JUR                NUMBER;
  V_CARGO_POLITICO                NUMBER;
  V_PROVENTOS                     VARCHAR(20);
  V_NATUREZA                      VARCHAR(10);
  V_ESPECIE                       VARCHAR(10);
  

  CURSOR GET_HEADER_AGENT IS
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
       ,FNC_DEPARA_NOME(V_AUDESP,'e.COD_PARENTESCO-L.69',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 



   FROM TB_HFOLHA_PAGAMENTO      A, 
        TB_PESSOA_FISICA         B,
        TB_DEPENDENTE            E
  WHERE A.COD_ENTIDADE         =  A.COD_ENTIDADE
    AND A.PER_PROCESSO         = P_PERPROCESSO
    AND A.TIP_PROCESSO         = 'N' 
    AND A.COD_ENTIDADE         = '1' 
    AND A.COD_IDE_CLI          = B.COD_IDE_CLI
    AND A.COD_INS              = E.COD_INS          (+)
    AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
    ORDER BY B.NOM_PESSOA_FISICA;


  CURSOR GET_LINES_AGENT
  (
  P_NUM_CPF              IN VARCHAR2
  )
  IS
  SELECT

          REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'C',VAL_RUBRICA, NULL))),',','.')    AS PROVENTO
         , REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'D', VAL_RUBRICA, NULL))),',','.')  AS DESCONTO
         ,DECODE(R1.TIP_EVENTO,'N','2','1')                                                  AS NATUREZA
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')                                           AS ESPECIE
         ,R1.COD_VERBA                                                                       AS TIPO
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_vinculo-L.116',RF.COD_VINCULO) AS CARGO_POLITICO 


        ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_sit_prev-L.121',RF.COD_SIT_PREV) AS COD_SITUACAO 



        ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.133',RF.COD_REGIME_JUR) AS COD_REGIME_JURIDICO 


    FROM TB_HFOLHA_PAGAMENTO_DET         D1,
         TB_HFOLHA_PAGAMENTO             F1,
         TB_RUBRICA_VERBA_AUDESP         R1,
         TB_PESSOA_FISICA                PF,
         TB_RELACAO_FUNCIONAL            RF
   WHERE D1.COD_INS              = 1
     AND D1.PER_PROCESSO         = P_PERPROCESSO
     AND D1.TIP_PROCESSO         = 'N'
     AND D1.SEQ_PAGAMENTO        = 1
     AND D1.COD_IDE_CLI          = PF.COD_IDE_CLI
     AND PF.NUM_CPF              = P_NUM_CPF
     AND D1.COD_INS              = F1.COD_INS
     AND D1.PER_PROCESSO         = F1.PER_PROCESSO
     AND D1.TIP_PROCESSO         = F1.TIP_PROCESSO
     AND D1.SEQ_PAGAMENTO        = F1.SEQ_PAGAMENTO
     AND D1.COD_IDE_CLI          = F1.COD_IDE_CLI
     AND R1.COD_INS              = D1.COD_INS
     AND D1.TIP_PROCESSO         = 'N'
     AND R1.COD_ENTIDADE         = F1.COD_ENTIDADE
     AND R1.COD_RUBRICA          = D1.COD_FCRUBRICA
     AND F1.COD_INS              = RF.COD_INS
     AND F1.COD_IDE_CLI          = RF.COD_IDE_CLI
     AND F1.COD_ENTIDADE         = RF.COD_ENTIDADE
     AND F1.NUM_MATRICULA        = RF.NUM_MATRICULA
     AND F1.COD_IDE_REL_FUNC     = RF.COD_IDE_REL_FUNC
GROUP BY  DECODE(R1.TIP_EVENTO,'N','2','1')
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')
         ,R1.COD_VERBA
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_vinculo-L.116',RF.COD_VINCULO)
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_sit_prev-L.121',RF.COD_SIT_PREV)
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.133',RF.COD_REGIME_JUR);


  CURSOR GET_VERBA
  (
  P_COD_ENTIDADE IN TB_RUBRICA_VERBA_AUDESP.COD_ENTIDADE%TYPE,
  P_COD_RUBRICA  IN TB_RUBRICA_VERBA_AUDESP.COD_RUBRICA%TYPE
  )
  IS
  SELECT A.COD_VERBA
    FROM TB_TIPO_VERBA_AUDESP     A,
         TB_RUBRICA_VERBA_AUDESP  B
   WHERE A.COD_INS      = B.COD_INS
     AND A.COD_VERBA    = B.COD_VERBA
     AND B.COD_ENTIDADE = P_COD_ENTIDADE
     AND B.COD_RUBRICA  = P_COD_RUBRICA;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'FolhaOrdinaria_Ativos_' || V_ANO || V_MES || V_NOME_EXTENSAO;

  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';

  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<foap:FolhaOrdinariaAgentePublico '         || CHR(10) ;


  V_TAG_DEFINICOES :=   'xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'     || CHR(10) ||
                        'xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'     || CHR(10) ||
                        'xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'   || CHR(10) ||
                        'xmlns:foap="http://www.tce.sp.gov.br/audesp/xml/remuneracao"' || CHR(10) ||
                        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'        || CHR(10) ||
                        ' xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ./folhaOrdinaria/AUDESP_FOLHA_ORDINARIA_AGENTE_PUBLICO_'||V_ANO||'_A.XSD"> '
                        || CHR(10);

  V_TAG_DESCRITOR   := '<foap:Descritor>'           || CHR(10) ||
                           '<gen:AnoExercicio>'     || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'    || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'         || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'        || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>'   || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                           '<gen:MesExercicio>'     || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                        '</foap:Descritor>'         || CHR(10);


  FOR REC IN  GET_HEADER_AGENT LOOP


      V_TAG_VERBAS_NEW := NULL;
      V_TAG_VERBAS     := NULL;

      FOR REC2 IN GET_LINES_AGENT(REC.NUM_CPF)
     
       LOOP

         V_COD_VERBA := REC2.TIPO;

          V_TAG_VERBAS_NEW   := '<foap:Verbas>' || CHR(10) ||
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

         V_COD_SITUACAO     := REC2.COD_SITUACAO;
         V_COD_REGIME_JUR   := REC2.COD_REGIME_JURIDICO;
         V_CARGO_POLITICO   := REC2.CARGO_POLITICO;
         V_NATUREZA         := REC2.NATUREZA;            
         V_ESPECIE          := REC2.ESPECIE;         
         V_PROVENTOS := NVL(REC2.PROVENTO,REC2.DESCONTO);
      

      END LOOP;


        V_TAG_ID_AGENT_PUBLICO := '<foap:IdentificacaoAgentePublico>'                 || CHR(10) ||
                                          '<ap:CPF Tipo="02">'                        || CHR(10) ||
                                              '<gen:Numero>'                          || REC.NUM_CPF      ||'</gen:Numero>'                          || CHR(10) ||
                                          '</ap:CPF>'                                 || CHR(10) ||
                                          '<ap:Nome>'                                 || REC.NOM_BEN      ||' </ap:Nome>'                            || CHR(10) ||
                                          '<ap:MunicipioLotacao>'                     || V_MUNICIPIO      ||'</ap:MunicipioLotacao>'                 || CHR(10) ||
                                          '<ap:EntidadeLotacao>'                      || V_ENTIDADE ||'</ap:EntidadeLotacao>'                  || CHR(10) ||
                                          '      <ap:CargoPolitico>'                  || V_CARGO_POLITICO ||'</ap:CargoPolitico>'                    || CHR(10) ||
                                          '      <ap:FuncaoGoverno>'                  || '01'             ||'</ap:FuncaoGoverno>'                    || CHR(10) ||
  --                                       '<ap:Estagiario>'                           || '2'              ||'</ap:Estagiario>'                       || CHR(10) ||
                                          '<ap:CodigoCargo>'                          || REC.COD_CARGO    ||'</ap:CodigoCargo>'                      || CHR(10) ||

                                          '<ap:Situacao>'                             || V_COD_SITUACAO   ||'</ap:Situacao>'                         || CHR(10) ||
                                          '<ap:RegimeJuridico>'                       || V_COD_REGIME_JUR ||'</ap:RegimeJuridico>'                   || CHR(10) ||
                                          '<ap:PossuiAutorizRecebAcimaTeto>'          || '2'              ||'</ap:PossuiAutorizRecebAcimaTeto>'      || CHR(10) ||

                                          '<foap:Valores>'                            || CHR(10) ||
                                              '<foap:totalGeralDaRemuneracaoBruta>'   || REC.TOT_CRED     ||'</foap:totalGeralDaRemuneracaoBruta>'   || CHR(10) ||
                                              '<foap:totalGeralDeDescontos>'          || REC.TOT_DEB      ||'</foap:totalGeralDeDescontos>'          || CHR(10) ||
                                              '<foap:totalGeralDaRemuneracaoLiquida>' || REC.VAL_LIQUIDO  ||'</foap:totalGeralDaRemuneracaoLiquida>' || CHR(10) ||
                                               V_TAG_VERBAS                           || CHR(10) ||
                                          '</foap:Valores>'                           || CHR(10) ||
                                  '</foap:IdentificacaoAgentePublico>'
                                                  || CHR(10) ;
                                                     
                                                   
        V_FILE :=  V_FILE  || V_TAG_ID_AGENT_PUBLICO;
      
      DELETE   TB_AUDESP_FOLHA_ORDINARIA P      
      WHERE 01||'/'||P.MES||'/'||P.ANO = P_PERPROCESSO;
        
      INSERT INTO TB_AUDESP_FOLHA_ORDINARIA
       VALUES (
          V_ANO                         ,
          V_MES                         ,
          C_TIPO_DOCUMENTO              ,
          TRUNC(SYSDATE)                ,
          REC.NUM_CPF                   ,
          REC.NOM_BEN                   ,
          V_MUNICIPIO                   ,
          V_ENTIDADE                    ,
          V_CARGO_POLITICO              ,
          99                            ,
          REC.COD_CARGO                 ,
          V_COD_SITUACAO                ,
          V_COD_REGIME_JUR              ,
          V_PROVENTOS                   ,
          2                             ,
          REC.TOT_CRED                  ,
          REC.TOT_DEB                   ,
          REC.VAL_LIQUIDO               ,                 
          V_COD_VERBA                   ,
          V_NATUREZA                    ,
          V_ESPECIE                     ,
          SYSDATE 
        );
        

  END LOOP;
  COMMIT;
    V_TAG_FIM :=  CHR(10) ||'</foap:FolhaOrdinariaAgentePublico>';

  V_FILE :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR ||   V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_GERA_FOLHA_ORDINARIA;

PROCEDURE SP_GERA_FOLHA_SUPLEMENTAR_B
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)


IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_DATA_PAG                  CLOB;
  V_TAG_ID_AGENT_PUBLICO          CLOB;
  V_TAG_ID_PENSIONISTA            CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_VERBAS_NEW                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Folha Suplementar';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA_AUDESP              NUMBER;
  V_COD_VERBA                     NUMBER;
  V_COD_SITUACAO                  NUMBER;
  V_COD_REGIME_JUR                NUMBER;
  V_CARGO_POLITICO                NUMBER;
  V_ESTAGIARIO                    NUMBER;

  CURSOR GET_HEADER_AGENT IS
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
       ,FNC_DEPARA_NOME(V_AUDESP,'e.COD_PARENTESCO.381',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 



        ,1 AS TIPO_CONTA 
        ,F.COD_BANCO
        ,F.NUM_AGENCIA            ||'-'||F.NUM_DV_AGENCIA   AS AGENCIA
        ,F.NUM_CONTA              ||'-'||F.NUM_DV_CONTA     AS CONTA
        ,A.DAT_PAGAMENTO                                    AS DATA_PAGAMENTO

    FROM TB_HFOLHA_PAGAMENTO      A, 
         TB_PESSOA_FISICA         B,
         TB_DEPENDENTE            E,
         TB_INFORMACAO_BANCARIA   F
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_ENTIDADE         = '1'
   AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'S'
     AND A.COD_INS              = E.COD_INS          (+)
     AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
     AND A.COD_INS              = F.COD_INS          (+)
     AND A.COD_IDE_CLI          = F.COD_IDE_CLI      (+)
     AND A.NUM_GRP              <> 3   
     ORDER BY B.NOM_PESSOA_FISICA;

  CURSOR GET_LINES_AGENT
  (
  P_NUM_CPF              IN VARCHAR2
  )
  IS
       SELECT 

          REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'C',VAL_RUBRICA, NULL))),',','.')   AS PROVENTO
         ,REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'D', VAL_RUBRICA, NULL))),',','.')  AS DESCONTO
         ,DECODE(R1.TIP_EVENTO,'N','2','1')                                                 AS NATUREZA
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')                                          AS ESPECIE
         ,R1.COD_CONCEITO                                                                   AS RUBRICAS
         ,R1.COD_VERBA                                                                      AS TIPO_AUDESP
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_vinculo-L.432',RF.COD_VINCULO) AS CARGO_POLITICO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_sit_prev-L.437',RF.COD_SIT_PREV) AS COD_SITUACAO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.444',RF.COD_REGIME_JUR) AS ESTAGIARIO 


         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.449',RF.COD_REGIME_JUR) AS COD_REGIME_JURIDICO 


    FROM TB_HFOLHA_PAGAMENTO_DET         D1,
         TB_HFOLHA_PAGAMENTO             F1,
         TB_RUBRICA_VERBA_AUDESP         R1,
         TB_PESSOA_FISICA                PF,
         TB_RELACAO_FUNCIONAL RF
   WHERE D1.COD_INS              = 1
     AND D1.PER_PROCESSO         = P_PERPROCESSO
     AND D1.TIP_PROCESSO         = 'S'

     AND D1.COD_IDE_CLI          = PF.COD_IDE_CLI
     AND PF.NUM_CPF              = P_NUM_CPF
     AND D1.COD_INS              = F1.COD_INS
     AND D1.PER_PROCESSO         = F1.PER_PROCESSO
     AND D1.TIP_PROCESSO         = F1.TIP_PROCESSO
     AND D1.SEQ_PAGAMENTO        = F1.SEQ_PAGAMENTO
     AND D1.COD_IDE_CLI          = F1.COD_IDE_CLI
     AND R1.COD_INS              = D1.COD_INS
     AND D1.TIP_PROCESSO         = 'S'
     AND R1.COD_ENTIDADE         = F1.COD_ENTIDADE

     AND R1.COD_CONCEITO         = (TRUNC(D1.COD_FCRUBRICA/100))
     AND RF.COD_IDE_CLI          = D1.COD_IDE_CLI
     AND RF.COD_IDE_CLI          = F1.COD_IDE_CLI     
     AND RF.COD_IDE_CLI          = PF.COD_IDE_CLI      
     AND F1.NUM_GRP              <> 3

    AND RF.COD_ENTIDADE          = D1.COD_ENTIDADE
    AND RF.NUM_MATRICULA         = D1.NUM_MATRICULA
    AND RF.COD_IDE_REL_FUNC      = D1.COD_IDE_REL_FUNC

    AND D1.COD_ENTIDADE          = F1.COD_ENTIDADE
    AND D1.NUM_MATRICULA         = F1.NUM_MATRICULA
    AND D1.COD_IDE_REL_FUNC      = F1.COD_IDE_REL_FUNC

GROUP BY  DECODE(R1.TIP_EVENTO,'N','2','1')
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')
         ,R1.COD_VERBA
         ,R1.COD_VERBA
         ,R1.COD_CONCEITO
         ,RF.COD_VINCULO
         ,RF.COD_SIT_PREV
         ,RF.COD_REGIME_JUR;


  CURSOR GET_VERBA
  (
  P_COD_ENTIDADE IN TB_RUBRICA_VERBA_AUDESP.COD_ENTIDADE%TYPE,
  P_COD_RUBRICA  IN TB_RUBRICA_VERBA_AUDESP.COD_RUBRICA%TYPE
  )
  IS
   SELECT A.COD_VERBA, B.COD_CONCEITO
    FROM TB_TIPO_VERBA_AUDESP     A,
         TB_RUBRICA_VERBA_AUDESP  B
   WHERE A.COD_INS      = B.COD_INS
     AND A.COD_VERBA    = B.COD_VERBA
     AND B.COD_CONCEITO = (TRUNC(P_COD_RUBRICA/100));

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoal_FolhaSuplementar_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<fsap:FolhaSuplementarAgentePublico '       || CHR(10) ;


  V_TAG_DEFINICOES :=
                  '  xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'      || CHR(10) ||
                  '                  xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'      || CHR(10) ||
                  '                  xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'    || CHR(10) ||
                  '                  xmlns:fsap="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'  || CHR(10) ||
                  '                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'         || CHR(10) ||

                  '                  xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ./folhaSuplementar/AUDESP_FOLHA_SUPLEMENTAR_AGENTE_PUBLICO_'||V_ANO||'_A.XSD">'
                         || CHR(10);


  V_TAG_DESCRITOR :=
                  '     <fsap:Descritor>'         || CHR(10) ||
                  '         <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '         <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '         <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '         <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '         <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '         <gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                  '     </fsap:Descritor>'        || CHR(10);

  V_TAG_DATA_PAG :=   '<fsap:DataPagamento>' || TO_CHAR(P_PERPROCESSO,'YYYY-MM')||'-30' ||'</fsap:DataPagamento>' || CHR(10);

  FOR REC IN  GET_HEADER_AGENT LOOP


      V_TAG_VERBAS_NEW := NULL;
      V_TAG_VERBAS     := NULL;

      FOR REC2 IN GET_LINES_AGENT(REC.NUM_CPF) LOOP

         V_COD_VERBA := REC2.RUBRICAS;
         V_COD_VERBA_AUDESP := REC2.TIPO_AUDESP;  

  V_TAG_VERBAS_NEW := 
                  '           <fsap:Verbas>' || CHR(10) ||
                  '               <fsap:MunicipioVerbaRemuneratoria>'        || V_MUNICIPIO                      ||'</fsap:MunicipioVerbaRemuneratoria>' || CHR(10) ||
                  '               <fsap:EntidadeVerbaRemuneratoria>'         || V_ENTIDADE                       ||'</fsap:EntidadeVerbaRemuneratoria>'  || CHR(10) ||
                  '               <fsap:CodigoVerbaRemuneratoria>'           || V_COD_VERBA                      ||'</fsap:CodigoVerbaRemuneratoria>'    || CHR(10) ||
                  '               <fsap:Valor>'                              || NVL(REC2.PROVENTO,REC2.DESCONTO) ||'</fsap:Valor>'                       || CHR(10) ||
                  '               <fsap:Natureza>'                           || REC2.NATUREZA                    ||'</fsap:Natureza>'                    || CHR(10) ||
                  '               <fsap:Especie>'                            || REC2.ESPECIE                     ||'</fsap:Especie>'                     || CHR(10) ||
                  '               <fsap:TipoVerbaRemuneratoria>'             || CHR(10) ||
                  '                  <fsap:CodigoTipoVerbaRemuneratoria>'    || V_COD_VERBA_AUDESP               ||'</fsap:CodigoTipoVerbaRemuneratoria>'|| CHR(10) ||
                  '               </fsap:TipoVerbaRemuneratoria>'            || CHR(10)||
                  '           </fsap:Verbas>' || CHR(10);

         V_TAG_VERBAS       := V_TAG_VERBAS || V_TAG_VERBAS_NEW;
         V_COD_SITUACAO     := REC2.COD_SITUACAO;
         V_COD_REGIME_JUR   := REC2.COD_REGIME_JURIDICO;
         V_CARGO_POLITICO   := REC2.CARGO_POLITICO;
         V_ESTAGIARIO       := REC2.ESTAGIARIO;

 END LOOP;

   V_TAG_ID_AGENT_PUBLICO :=
             '    <fsap:IdentificacaoAgentePublico>'            || CHR(10) ||
             '       <ap:CPF Tipo="02">'                        || CHR(10) ||
             '             <gen:Numero>'                        || REC.NUM_CPF      ||'</gen:Numero>'                          || CHR(10) ||
             '       </ap:CPF>'                                 || CHR(10) ||
             '       <ap:Nome>'                                 || REC.NOM_BEN      ||'</ap:Nome>'                             || CHR(10) ||
             '       <ap:MunicipioLotacao>'                     || V_MUNICIPIO      ||'</ap:MunicipioLotacao>'                 || CHR(10) ||
             '       <ap:EntidadeLotacao>'                      || V_ENTIDADE       ||'</ap:EntidadeLotacao>'                  || CHR(10) ||
             '       <ap:CargoPolitico>'                        || V_CARGO_POLITICO ||'</ap:CargoPolitico>'                    || CHR(10) ||
             '       <ap:FuncaoGoverno>'                        || '01'             ||'</ap:FuncaoGoverno>'                    || CHR(10) ||
      --       '       <ap:Estagiario>'                           || V_ESTAGIARIO     ||'</ap:Estagiario>'                       || CHR(10) ||
             '       <ap:CodigoCargo>'                          || REC.COD_CARGO    ||'</ap:CodigoCargo>'                      || CHR(10) ||

             '       <ap:Situacao>'                             || V_COD_SITUACAO   ||'</ap:Situacao>'                         || CHR(10) ||
             '       <ap:RegimeJuridico>'                       || V_COD_REGIME_JUR ||'</ap:RegimeJuridico>'                   || CHR(10) ||
             '       <ap:PossuiAutorizRecebAcimaTeto>'          || '2'              ||'</ap:PossuiAutorizRecebAcimaTeto>'      || CHR(10) ||

             '       <fsap:formaPagamento>'                     || REC.TIPO_CONTA   ||'</fsap:formaPagamento>'                 || CHR(10) ||
             '       <fsap:numeroBanco>'                        || REC.COD_BANCO    ||'</fsap:numeroBanco>'                    || CHR(10) ||
             '       <fsap:agencia>'                            || REC.AGENCIA      ||'</fsap:agencia>'                        || CHR(10) ||
             '       <fsap:ContaCorrente>'                      || REC.CONTA        ||'</fsap:ContaCorrente>'                  || CHR(10) ||
             '       <fsap:Valores>'                            || CHR(10) ||
             '          <fsap:totalGeralDaRemuneracaoBruta>'    || REC.TOT_CRED     ||'</fsap:totalGeralDaRemuneracaoBruta>'   || CHR(10) ||
             '          <fsap:totalGeralDeDescontos>'           || REC.TOT_DEB      ||'</fsap:totalGeralDeDescontos>'          || CHR(10) ||
             '          <fsap:totalGeralDaRemuneracaoLiquida>'  || REC.VAL_LIQUIDO  ||'</fsap:totalGeralDaRemuneracaoLiquida>' || CHR(10) ||
             '          <fsap:valorPagoContaCorrente>'          || REC.VAL_LIQUIDO  ||'</fsap:valorPagoContaCorrente>'          || CHR(10) ||
             '          <fsap:valorPagoOutrasFormas>'           || '0'              ||'</fsap:valorPagoOutrasFormas>'           || CHR(10) ||
                        V_TAG_VERBAS                            || CHR(10) ||
             '       </fsap:Valores>'                           || CHR(10) ||
             '     </fsap:IdentificacaoAgentePublico>'          || CHR(10) ;
        V_FILE :=  V_FILE   || V_TAG_ID_AGENT_PUBLICO;

  END LOOP;


  V_TAG_FIM :=  CHR(10) ||'</fsap:FolhaSuplementarAgentePublico>';

  V_FILE :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR ||V_TAG_DATA_PAG || V_FILE || V_TAG_FIM;
  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_GERA_FOLHA_SUPLEMENTAR_B;

PROCEDURE SP_GERA_FOLHA_SUPLEMENTAR
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)

IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_DATA_PAG                  CLOB;
  V_TAG_ID_AGENT_PUBLICO          CLOB;
  V_TAG_ID_PENSIONISTA            CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_VERBAS_NEW                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Folha Suplementar';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='0007';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_COD_SITUACAO                  NUMBER;
  V_COD_REGIME_JUR                NUMBER;
  V_CARGO_POLITICO                NUMBER;


  CURSOR GET_HEADER_AGENT IS
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
        ,NVL((SELECT T3.DES_DESCRICAO
               FROM TB_CODIGO T3
              WHERE T3.COD_INS = 0
                AND T3.COD_NUM = 2015
                AND T3.COD_PAR = E.COD_PARENTESCO),
             '-')                  AS NOM_PARENTESCO
        ,E.COD_PARENTESCO          AS COD_PARENTESCO
        ,B.COD_SEXO
       ,FNC_DEPARA_NOME(V_AUDESP,'e.COD_PARENTESCO.381',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 



        ,1 AS TIPO_CONTA 
        ,F.COD_BANCO
        ,F.NUM_AGENCIA            ||F.NUM_DV_AGENCIA   AS AGENCIA
        ,F.NUM_CONTA              ||F.NUM_DV_CONTA     AS CONTA


    FROM TB_HFOLHA_PAGAMENTO      A, 
         TB_PESSOA_FISICA         B,
         TB_DEPENDENTE            E,
         TB_INFORMACAO_BANCARIA   F
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'T'
     AND A.COD_ENTIDADE         = '1' 
     AND A.COD_INS              = E.COD_INS          (+)
     AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
     AND A.COD_INS              = F.COD_INS          (+)
     AND A.COD_IDE_CLI          = F.COD_IDE_CLI      (+)
     ORDER BY B.NOM_PESSOA_FISICA;

  CURSOR GET_LINES_AGENT
  (
  P_NUM_CPF              IN VARCHAR2
  )
  IS
  SELECT

          REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'C',VAL_RUBRICA, NULL))),',','.')   AS PROVENTO
         ,REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'D', VAL_RUBRICA, NULL))),',','.')  AS DESCONTO
         ,DECODE(R1.TIP_EVENTO,'N','2','1')                                                 AS NATUREZA
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')                                          AS ESPECIE
         ,R1.COD_VERBA                                                                      AS TIPO
         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_vinculo-L.432',RF.COD_VINCULO) AS CARGO_POLITICO 



       ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_sit_prev-L.437',RF.COD_SIT_PREV) AS COD_SITUACAO 



         ,FNC_DEPARA_NOME(V_AUDESP,'rf.cod_regime_jur-L.449',RF.COD_REGIME_JUR) AS COD_REGIME_JURIDICO 



     FROM TB_HFOLHA_PAGAMENTO_DET        D1,
         TB_HFOLHA_PAGAMENTO             F1,
         TB_RUBRICA_VERBA_AUDESP         R1,
         TB_PESSOA_FISICA                PF,
         TB_RELACAO_FUNCIONAL            RF
   WHERE D1.COD_INS              = 1
     AND D1.PER_PROCESSO         = P_PERPROCESSO
     AND D1.TIP_PROCESSO         = 'T'
     AND D1.SEQ_PAGAMENTO        = 1
     AND D1.COD_IDE_CLI          = PF.COD_IDE_CLI
     AND PF.NUM_CPF              = P_NUM_CPF
     AND D1.COD_INS              = F1.COD_INS
     AND D1.PER_PROCESSO         = F1.PER_PROCESSO
     AND D1.TIP_PROCESSO         = F1.TIP_PROCESSO
     AND D1.SEQ_PAGAMENTO        = F1.SEQ_PAGAMENTO
     AND D1.COD_IDE_CLI          = F1.COD_IDE_CLI
     AND R1.COD_INS              = D1.COD_INS
     AND D1.TIP_PROCESSO         = 'T'
     AND R1.COD_ENTIDADE         = F1.COD_ENTIDADE
     AND R1.COD_RUBRICA          = D1.COD_FCRUBRICA
     AND F1.COD_INS              = RF.COD_INS
     AND F1.COD_IDE_CLI          = RF.COD_IDE_CLI
     AND F1.COD_ENTIDADE         = RF.COD_ENTIDADE
     AND F1.NUM_MATRICULA        = RF.NUM_MATRICULA
     AND F1.COD_IDE_REL_FUNC     = RF.COD_IDE_REL_FUNC
GROUP BY  DECODE(R1.TIP_EVENTO,'N','2','1')
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')
         ,R1.COD_VERBA
         ,R1.COD_VERBA
         ,R1.COD_CONCEITO
         ,RF.COD_VINCULO
         ,RF.COD_SIT_PREV
         ,RF.COD_REGIME_JUR;

  CURSOR GET_VERBA
  (
  P_COD_ENTIDADE IN TB_RUBRICA_VERBA_AUDESP.COD_ENTIDADE%TYPE,
  P_COD_RUBRICA  IN TB_RUBRICA_VERBA_AUDESP.COD_RUBRICA%TYPE
  )
  IS
  SELECT A.COD_VERBA
    FROM TB_TIPO_VERBA_AUDESP     A,
         TB_RUBRICA_VERBA_AUDESP  B
   WHERE A.COD_INS      = B.COD_INS
     AND A.COD_VERBA    = B.COD_VERBA
     AND B.COD_ENTIDADE = P_COD_ENTIDADE
     AND B.COD_RUBRICA  = P_COD_RUBRICA;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'FolhaSuplementar_Ativos_' || V_ANO || V_MES || V_NOME_EXTENSAO;

  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';




  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<fsap:FolhaSuplementarAgentePublico '       || CHR(10) ;


  V_TAG_DEFINICOES :=   'xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'      || CHR(10) ||
                        'xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'      || CHR(10) ||
                        'xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'    || CHR(10) ||
                        'xmlns:fsap="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'  || CHR(10) ||
                        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'         || CHR(10) ||
                        'xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ./folhaSuplementar/AUDESP_FOLHA_SUPLEMENTAR_AGENTE_PUBLICO_2018_A.XSD">' || CHR(10);


  V_TAG_DESCRITOR   := '<fsap:Descritor>'         || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                           '<gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'     || CHR(10) ||
                        '</fsap:Descritor>'       || CHR(10);

   V_TAG_DATA_PAG :=   '<fsap:DataPagamento>' || TO_CHAR(P_PERPROCESSO,'YYYY-MM')||'-30' ||  '</fsap:DataPagamento>' || CHR(10);

  FOR REC IN  GET_HEADER_AGENT LOOP


      V_TAG_VERBAS_NEW := NULL;
      V_TAG_VERBAS     := NULL;

      FOR REC2 IN GET_LINES_AGENT(REC.NUM_CPF) LOOP

      V_COD_VERBA := REC2.TIPO;

          V_TAG_VERBAS_NEW  := '<fsap:Verbas>' || CHR(10) ||
                            '<fsap:MunicipioVerbaRemuneratoria>'        || V_MUNICIPIO                      ||'</fsap:MunicipioVerbaRemuneratoria>' || CHR(10) ||
                            '<fsap:EntidadeVerbaRemuneratoria>'         || V_ENTIDADE                       ||'</fsap:EntidadeVerbaRemuneratoria>'  || CHR(10) ||
                            '<fsap:CodigoVerbaRemuneratoria>'           || V_COD_VERBA                      ||'</fsap:CodigoVerbaRemuneratoria>'    || CHR(10) ||
                            '<fsap:Valor>'                              || NVL(REC2.PROVENTO,REC2.DESCONTO) ||'</fsap:Valor>'                       || CHR(10) ||
                            '<fsap:Natureza>'                           || REC2.NATUREZA                    ||'</fsap:Natureza>'                    || CHR(10) ||
                            '<fsap:Especie>'                            || REC2.ESPECIE                     ||'</fsap:Especie>'                     || CHR(10) ||
                            '<fsap:TipoVerbaRemuneratoria>'             || CHR(10) ||
                                  '<fsap:CodigoTipoVerbaRemuneratoria>' || REC2.TIPO                        ||'</fsap:CodigoTipoVerbaRemuneratoria>'|| CHR(10) ||
                            '</fsap:TipoVerbaRemuneratoria>'            || CHR(10)||
                            '</fsap:Verbas>'                              ;

          V_TAG_VERBAS   :=  V_TAG_VERBAS || V_TAG_VERBAS_NEW;
          V_COD_SITUACAO     := REC2.COD_SITUACAO;
          V_COD_REGIME_JUR   := REC2.COD_REGIME_JURIDICO;
          V_CARGO_POLITICO   := REC2.CARGO_POLITICO;

      END LOOP;


       V_TAG_ID_AGENT_PUBLICO := '<fsap:IdentificacaoAgentePublico>'                 || CHR(10) ||
                                          '<ap:CPF Tipo="02">'                        || CHR(10) ||
                                              '<gen:Numero>'                          || REC.NUM_CPF      ||'</gen:Numero>'                          || CHR(10) ||
                                          '</ap:CPF>'                                 || CHR(10) ||
                                          '<ap:Nome>'                                 || REC.NOM_BEN      ||'</ap:Nome>'                             || CHR(10) ||
                                          '<ap:MunicipioLotacao>'                     || V_MUNICIPIO      ||'</ap:MunicipioLotacao>'                 || CHR(10) ||
                                          '<ap:EntidadeLotacao>'                      || V_ENTIDADE       ||'</ap:EntidadeLotacao>'                  || CHR(10) ||
                                          '<ap:CargoPolitico>'                        || V_CARGO_POLITICO ||'</ap:CargoPolitico>'                    || CHR(10) ||
                                          '<ap:FuncaoGoverno>'                        || '99'             ||'</ap:FuncaoGoverno>'                    || CHR(10) ||
 --                                         '<ap:Estagiario>'                           || '2'              ||'</ap:Estagiario>'                       || CHR(10) ||
                                          '<ap:CodigoCargo>'                          || REC.COD_CARGO    ||'</ap:CodigoCargo>'                      || CHR(10) ||

                                          '<ap:Situacao>'                             || V_COD_SITUACAO   ||'</ap:Situacao>'                         || CHR(10) ||
                                          '<ap:RegimeJuridico>'                       || V_COD_REGIME_JUR ||'</ap:RegimeJuridico>'                   || CHR(10) ||
                                          '<ap:PossuiAutorizRecebAcimaTeto>'          || '2'              ||'</ap:PossuiAutorizRecebAcimaTeto>'      || CHR(10) ||

                                          '<fsap:formaPagamento>'                     || REC.TIPO_CONTA   ||'</fsap:formaPagamento>'                 || CHR(10) ||
                                          '<fsap:numeroBanco>'                        || REC.COD_BANCO    ||'</fsap:numeroBanco>'                    || CHR(10) ||
                                          '<fsap:agencia>'                            || REC.AGENCIA      ||'</fsap:agencia>'                        || CHR(10) ||
                                          '<fsap:ContaCorrente>'                      || REC.CONTA        ||'</fsap:ContaCorrente>'                  || CHR(10) ||
                                          '<fsap:Valores>'                            || CHR(10) ||
                                              '<fsap:totalGeralDaRemuneracaoBruta>'   || REC.TOT_CRED     ||'</fsap:totalGeralDaRemuneracaoBruta>'   || CHR(10) ||
                                              '<fsap:totalGeralDeDescontos>'          || REC.TOT_DEB      ||'</fsap:totalGeralDeDescontos>'          || CHR(10) ||
                                              '<fsap:totalGeralDaRemuneracaoLiquida>' || REC.VAL_LIQUIDO  ||'</fsap:totalGeralDaRemuneracaoLiquida>' || CHR(10) ||
                                              '<fsap:valorPagoContaCorrente>'         || REC.VAL_LIQUIDO   ||'</fsap:valorPagoContaCorrente>'          || CHR(10) ||
                                              '<fsap:valorPagoOutrasFormas>'          || '0'                ||'</fsap:valorPagoOutrasFormas>'           || CHR(10) ||
                                            V_TAG_VERBAS                              || CHR(10) ||
                                          '</fsap:Valores>'                           || CHR(10) ||
                                  '</fsap:IdentificacaoAgentePublico>'                || CHR(10) ;
        V_FILE :=  V_FILE   || V_TAG_ID_AGENT_PUBLICO;

  END LOOP;


  V_TAG_FIM :=  CHR(10) ||'</fsap:FolhaSuplementarAgentePublico>';

  V_FILE :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR ||V_TAG_DATA_PAG || V_FILE || V_TAG_FIM;
  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_GERA_FOLHA_SUPLEMENTAR;

PROCEDURE SP_CRIA_CADASTRO
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)

IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_APOSENTADORIASPENSOES     CLOB;
  V_TAG_APOS_PENSAO               CLOB;
  V_TAG_APOS_PENSAO_2             CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Cadastro de Aposentados e Pensionistas';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='0002';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;


  CURSOR GET_HEADER_AGENT IS
    SELECT
         A.NOME                               AS NOM_BEN
        ,B.NUM_CPF
        ,TO_CHAR(B.DAT_NASC,'YYYY-MM-DD')     AS DAT_NASC
    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B

   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'N'

     AND A.NUM_GRP              IN (5,6)  
     AND 
         NOT EXISTS (SELECT 1 FROM TB_HFOLHA_PAGAMENTO TF WHERE TF.PER_PROCESSO = ADD_MONTHS(P_PERPROCESSO,-1)
                     AND TF.COD_IDE_CLI = A.COD_IDE_CLI)

     GROUP BY  A.NOME
        ,B.NUM_CPF
        ,TO_CHAR(B.DAT_NASC,'YYYY-MM-DD')
     ORDER BY A.NOME;

  CURSOR GET_PENSOES_APOSENT 
  (
  P_NUM_CPF   IN VARCHAR2
  )
  IS
  SELECT
         A.PER_PROCESSO
        ,A.COD_ENTIDADE
        ,B.NUM_CPF
        ,A.COD_IDE_CLI                        AS COD_IDE_SERV
        ,A.COD_IDE_CLI                        AS COD_IDE_CLI_BEN
        ,A.NOME                               AS NOME_BEN
        ,LPAD(A.COD_CARGO,5,'0')              AS COD_CARGO
        ,TO_CHAR(A.PER_PROCESSO,'YYYY')       AS ANO_EXERCIO
        ,TO_CHAR(A.PER_PROCESSO,'MM')         AS MES_EXERCIO
        ,A.NUM_MATRICULA                      AS COD_BENEFICIO
        ,A.NOM_CARGO                          AS NOM_TIPO_BENEFICIO 
        ,DECODE (A.NUM_GRP,05,'V',06,'M') AS COD_TIPO_BENEFICIO
        ,TO_CHAR(B.DAT_NASC,'YYYY-MM-DD')     AS DAT_NASC
        ,A.TOT_CRED                           AS TOT_CRED
        ,A.TOT_DEB                            AS TOT_DEB
        ,TO_CHAR(C.DAT_INI_EXERC,'YYYY-MM-DD')AS DAT_CONCESSAO
    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_RELACAO_FUNCIONAL     C

   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'N'
     AND B.NUM_CPF              = P_NUM_CPF
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_IDE_REL_FUNC     = C.COD_IDE_REL_FUNC
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.NUM_GRP              IN (05,06)
     ORDER BY B.NOM_PESSOA_FISICA;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'CadastroAposentadosPensionistas_Ativos_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<cap:CadastroAposentadosPensionistas '                    ||
                  'xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"' || CHR(10) ;

  V_TAG_DEFINICOES :=
                        'xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'  || CHR(10) ||
                        'xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'    || CHR(10) ||
                        'xmlns:cap="http://www.tce.sp.gov.br/audesp/xml/remuneracao"' || CHR(10) ||
                        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'       || CHR(10) ||

                        'xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../cadastroaposentados/AUDESP_CADASTRO_APOSENTADOS_PENSIONISTAS_'||V_ANO||'_A.XSD">'
                         || CHR(10);



  V_TAG_DESCRITOR   := '<cap:Descritor>'   || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                        '</cap:Descritor>' || CHR(10) ;

  FOR REC IN  GET_HEADER_AGENT LOOP

    V_TAG_APOSENTADORIASPENSOES := '<cap:ListaAposentadoriasPensoes>' || CHR(10) ||
                                   '<cap:Nome> '                   || UPPER(REC.NOM_BEN)                 ||'</cap:Nome>'                || CHR(10) ||
                                   '<cap:CPF Tipo="02">'           || CHR(10) ||
                                       '<gen:Numero>'              || REC.NUM_CPF                        ||'</gen:Numero>'              || CHR(10) ||
                                   '</cap:CPF>'                    || CHR(10) ||
                                   '<cap:DataNascimento>'          || REC.DAT_NASC                       ||'</cap:DataNascimento>'      || CHR(10) ;

                                   V_TAG_APOS_PENSAO_2   := NULL;

                                   FOR REC2 IN  GET_PENSOES_APOSENT(REC.NUM_CPF)
                                   LOOP

                                      V_TAG_APOS_PENSAO   := '<cap:DadosAposentadoriaPensao>'  || CHR(10) ||
                                                             '<cap:MunicipioEntidade>'         || CHR(10) ||
                                                             '<gen:codigoMunicipio>'           || V_MUNICIPIO          ||'</gen:codigoMunicipio>'         || CHR(10) ||
                                                             '<gen:codigoEntidade>'            || V_ENTIDADE           ||'</gen:codigoEntidade>'          || CHR(10) ||
                                                             '</cap:MunicipioEntidade>'        || CHR(10)              ||
                                                             '<cap:CargoOrigem>'               || REC2.COD_CARGO       ||'</cap:CargoOrigem>'             || CHR(10) ||
                                                             '<cap:DataAposentadoriaPensao>'   || REC2.DAT_CONCESSAO   ||'</cap:DataAposentadoriaPensao>' || CHR(10) ||
                                                             '</cap:DadosAposentadoriaPensao>' || CHR(10) ;

                                      V_TAG_APOS_PENSAO_2   := V_TAG_APOS_PENSAO_2 || V_TAG_APOS_PENSAO;

                                   END LOOP;

    V_TAG_APOSENTADORIASPENSOES  :=  V_TAG_APOSENTADORIASPENSOES || V_TAG_APOS_PENSAO_2;
    V_TAG_APOSENTADORIASPENSOES  :=  V_TAG_APOSENTADORIASPENSOES || '</cap:ListaAposentadoriasPensoes>'|| CHR(10) ;

    V_FILE :=  V_FILE  || V_TAG_APOSENTADORIASPENSOES;

  END LOOP;


  V_TAG_FIM :=  CHR(10)      ||'</cap:CadastroAposentadosPensionistas>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_CRIA_CADASTRO;


PROCEDURE SP_CRIA_AGENTE_PUBLICO
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_AGENT_PUBLICO             CLOB;
  V_TAG_AGENT_LISTA               CLOB;
  V_TAG_APOS_PENSAO               CLOB;
  V_TAG_APOS_PENSAO_2             CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Agente Público';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;


  CURSOR GET_HEADER IS

   SELECT
        DISTINCT (B.COD_IDE_CLI)
        ,A.PER_PROCESSO                                    AS MÊS_FOLHA
        ,A.NOME                                            AS NOM_BEN
        ,LPAD(B.NUM_CPF,11,'0')                            AS NUM_CPF
        ,C.NUM_PIS                                         AS NUM_PIS
        ,TO_CHAR(B.DAT_NASC,'YYYY-MM-DD')                  AS DAT_NASC
        ,CASE WHEN B.COD_SEXO = 'M' THEN '1' ELSE '2' END  AS COD_SEXO
        ,B.COD_SEXO                                        AS DESC_SEXO               
        ,B.COD_NACIO                                       AS COD_NACIO                    
        ,PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2007', B.COD_NACIO)  
                                                           AS DES_NACIO

        ,FNC_DEPARA_NOME(V_AUDESP,'b.cod_escola-L.865',B.COD_ESCOLA) AS ESCOLARIDADE_AUDESP 



        ,PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2006', B.COD_ESCOLA) AS DESC_ESCOLARIDADE

        , CASE 
             WHEN B.COD_ESCOLA IN ('3','7','10') 
               AND NVL((SELECT DISTINCT 1 FROM TB_PESSOA_FISICA_PROF E, TB_PROFISSAO F
                                                        WHERE E.COD_IDE_CLI = D.COD_IDE_CLI
                                                          AND E.COD_PROFISSAO = F.COD_PROFISSAO
                                                          AND E.COD_PROFISSAO IN
                                                      (SELECT MAX (G.COD_PROFISSAO)FROM TB_PESSOA_FISICA_PROF G
                                                        WHERE G.COD_IDE_CLI = E.COD_IDE_CLI)),0) = 1

               THEN (SELECT F.NOM_PROFISSAO FROM TB_PESSOA_FISICA_PROF E, TB_PROFISSAO F
                                                        WHERE E.COD_IDE_CLI = D.COD_IDE_CLI
                                                          AND E.COD_PROFISSAO = F.COD_PROFISSAO
                                                          AND E.COD_PROFISSAO IN
                                                      (SELECT MAX (G.COD_PROFISSAO)FROM TB_PESSOA_FISICA_PROF G
                                                        WHERE G.COD_IDE_CLI = E.COD_IDE_CLI))



               WHEN B.COD_ESCOLA IN ('3','7','10') 
               AND NVL((SELECT DISTINCT 1 FROM TB_PESSOA_FISICA_PROF E, TB_PROFISSAO F
                                                        WHERE E.COD_IDE_CLI = D.COD_IDE_CLI
                                                          AND E.COD_PROFISSAO = F.COD_PROFISSAO
                                                          AND E.COD_PROFISSAO IN
                                                      (SELECT MAX (G.COD_PROFISSAO)FROM TB_PESSOA_FISICA_PROF G
                                                        WHERE G.COD_IDE_CLI = E.COD_IDE_CLI)),0) = 0

               THEN CASE WHEN (SELECT C.DES_DESCRICAO FROM TB_ESCOLARIDADE ES, TB_CODIGO C
                                                        WHERE ES.COD_IDE_CLI = D.COD_IDE_CLI
                                                        AND C.COD_INS = 0
                                                        AND C.COD_NUM = 10062
                                                        AND C.COD_PAR = ES.COD_CURSO
                                                        AND ES.COD_GRAU IN ('3','7','10')
                                                          AND NVL(ES.ANO_CONCLUSAO, 1) IN
                                                      NVL((SELECT MAX (ES1.ANO_CONCLUSAO)FROM TB_ESCOLARIDADE ES1
                                                        WHERE ES1.COD_IDE_CLI = ES.COD_IDE_CLI),1))  IS NOT NULL
                         THEN (SELECT C.DES_DESCRICAO FROM TB_ESCOLARIDADE ES, TB_CODIGO C
                                                        WHERE ES.COD_IDE_CLI = D.COD_IDE_CLI
                                                        AND C.COD_INS = 0
                                                        AND C.COD_NUM = 10062
                                                        AND C.COD_PAR = ES.COD_CURSO
                                                        AND ES.COD_GRAU IN ('3','7','10')
                                                          AND NVL(ES.ANO_CONCLUSAO, 1) IN
                                                      NVL((SELECT MAX (ES1.ANO_CONCLUSAO)FROM TB_ESCOLARIDADE ES1
                                                        WHERE ES1.COD_IDE_CLI = ES.COD_IDE_CLI),1)) 
                        ELSE (SELECT ES.DES_CURSO_OUTRO FROM TB_ESCOLARIDADE ES
                                                        WHERE ES.COD_IDE_CLI = D.COD_IDE_CLI
                                                          AND ES.COD_GRAU IN ('3','7','10')
                                                          AND NVL(ES.ANO_CONCLUSAO, 1) IN
                                                      NVL((SELECT MAX (ES1.ANO_CONCLUSAO)FROM TB_ESCOLARIDADE ES1
                                                        WHERE ES1.COD_IDE_CLI = ES.COD_IDE_CLI),1))  END 
                       END AS  PROFISSAO                                 
    FROM TB_HFOLHA_PAGAMENTO      A, 
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO        IN ('N','S')
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND B.COD_IDE_CLI          = C.COD_IDE_CLI
     AND B.COD_IDE_CLI          = D.COD_IDE_CLI
     AND C.COD_IDE_CLI          = D.COD_IDE_CLI
     AND D.COD_CARGO NOT IN(500,600,700)  

     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND NOT EXISTS (SELECT 1 FROM TB_HFOLHA_PAGAMENTO A1
                 WHERE A1.COD_IDE_CLI  = A.COD_IDE_CLI
                   AND A1.TIP_PROCESSO IN ('N','S')
                   AND A1.PER_PROCESSO < P_PERPROCESSO
                   AND A1.PER_PROCESSO >= '01/01/2015'
                   )

     AND NOT EXISTS (SELECT 1 FROM TB_RELACAO_FUNCIONAL A2
                 WHERE A2.COD_IDE_CLI  = A.COD_IDE_CLI
                   AND A2.COD_IDE_REL_FUNC = A.COD_IDE_REL_FUNC
                   AND A2.NUM_MATRICULA = A.NUM_MATRICULA                 
                   AND A2.DAT_INI_EXERC >= '01/01/2015' 
                   AND A2.DAT_RESCISAO <= LAST_DAY ( P_PERPROCESSO)
                   )
     ORDER BY A.NOME;    

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoal_AgentePublico_' || V_ANO || V_MES || V_NOME_EXTENSAO;  
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<ag:AgentesPublicos '||'xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"' || CHR(10);

  V_TAG_DEFINICOES :=
                  '                    xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'  || CHR(10) ||
                  '                    xmlns:ag="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-agentepublico"' || CHR(10) ||
                  '                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'       || CHR(10) ||

                  '                    xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-agentepublico ../quadrofuncional/AUDESP_AGENTEPUBLICO_'||V_ANO||'_A.XSD">' || CHR(10);


  V_TAG_DESCRITOR := 
                  '     <ag:Descritor>'   || CHR(10) ||
                  '            <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '            <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '            <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '            <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '            <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '     </ag:Descritor>' || CHR(10) ;

  FOR REC IN  GET_HEADER LOOP

  V_TAG_AGENT_PUBLICO :=
                  '            <ag:AgentePublico>'         || CHR(10) ||
                  '                   <ag:nome>'           || TRIM(UPPER(REC.NOM_BEN))  ||'</ag:nome>'           || CHR(10) ||
                  '                   <ag:cpf Tipo="02">'  || CHR(10)                   ||
                  '                          <gen:Numero>' || UPPER(TRIM(REC.NUM_CPF))  ||'</gen:Numero>'        || CHR(10) ||
                  '                   </ag:cpf>'           || CHR(10)                   ||
                  '                   <ag:pis_pasep>'      || REC.NUM_PIS               ||'</ag:pis_pasep>'      || CHR(10) ||
                  '                   <ag:dataNascimento>' || REC.DAT_NASC              ||'</ag:dataNascimento>' || CHR(10) ||
                  '                   <ag:sexo>'           || REC.COD_SEXO              ||'</ag:sexo>'           || CHR(10) ||
                  '                   <ag:nacionalidade>'  || REC.COD_NACIO             ||'</ag:nacionalidade>'  || CHR(10) ||
                  '                   <ag:escolaridade>'   || REC.ESCOLARIDADE_AUDESP   ||'</ag:escolaridade>'   || CHR(10) ||
                  '                   <ag:especialidade>'  || REC.PROFISSAO             ||'</ag:especialidade>'  || CHR(10) ||
                  '            </ag:AgentePublico>'        || CHR(10) ;

     V_FILE :=  V_FILE  || V_TAG_AGENT_PUBLICO;

  END LOOP;

  V_TAG_AGENT_LISTA :=
                  '      <ag:ListaAgentePublico>'  || CHR(10) || V_FILE || '      </ag:ListaAgentePublico>'|| CHR(10) ;


  V_TAG_FIM :=  '</ag:AgentesPublicos>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_TAG_AGENT_LISTA || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_CRIA_AGENTE_PUBLICO;

PROCEDURE SP_LOTACAO_AGENTE_PUBLICO
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)


IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_AGENT_PUBLICO             CLOB;
  V_TAG_AGENT_LISTA               CLOB;
  V_TAG_AGENT_HIST                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Lotação Agente Público';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='0007';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;


  CURSOR GET_HEADER IS
    SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,LPAD(B.NUM_CPF,11,'0')             AS NUM_CPF
        ,A.NOME                             AS NOM_BEN
        ,A.COD_CARGO
        ,D.COD_SIT_FUNC                     AS COD_SIT_FUNC
        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')                    AS DAT_INI_EXERC
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)  
                                                          AS DES_VINCULO      
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'NAO_PARAMETRIZADO',D.COD_VINCULO) AS TIPO_VINCULO 


        ,PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)  
                                                          AS DES_PROVIMENTO       
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'NAO_PARAMETRIZADO',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 

  ,E.NOM_ENTIDADE
    FROM TB_HFOLHA_PAGAMENTO      A, 
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO        IN ('N', 'S')
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS 
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS 
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE

     ORDER BY B.NOM_PESSOA_FISICA;


BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'LotacaoAgentePublico_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<LotacaoAgentePublico  '                    ;

  V_TAG_DEFINICOES :=
                        'xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico" xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'  || CHR(10) ||
                        'xmlns:qpla="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-lotacaoagentepublico" ' || CHR(10) ||
                        'xmlns="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-lotacaoagentepublico" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '       || CHR(10) ||

                        'xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-lotacaoagentepublico ../quadrofuncional/AUDESP_LOTACAOAGENTEPUBLICO_'||V_ANO||'_A.XSD">'
                         || CHR(10);


  V_TAG_DESCRITOR   := '<Descritor>'   || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                        '</Descritor>' || CHR(10) ;


  FOR REC IN  GET_HEADER LOOP

    V_TAG_AGENT_PUBLICO :=      '<LotacaoAgentePublico>'         || CHR(10) ||
                                   '<cpf Tipo="02">'             || CHR(10)                         ||
                                      '<gen:Numero>'             || UPPER(TRIM(REC.NUM_CPF))        ||'</gen:Numero>'                 || CHR(10) ||
                                    '</cpf>'                     || CHR(10)                         ||
                                     '<dataLotacao>'             || REC.DAT_INI_EXERC                   ||'</dataLotacao>'                || CHR(10) ||
                                     '<exercicioAtividade>'      || REC.TIPO_VINCULO                ||'</exercicioAtividade>'         || CHR(10) ||
                                     '<codigoMunicipioFuncao>'   || V_MUNICIPIO                     ||'</codigoMunicipioFuncao>'       || CHR(10) ||
                                     '<codigoEntidadeFuncao>'    || V_ENTIDADE                      ||'</codigoEntidadeFuncao>'        || CHR(10) ||

                                     '<codigoFuncao>'             || REC.COD_CARGO                   ||'</codigoFuncao>'                || CHR(10) ||
                                     '<cargoRemunerado>'         || ''                             ||'</cargoRemunerado>'            || CHR(10) ||
                                     '<unidadeLotacao>'          || SUBSTR(REC.NOM_ENTIDADE,1,100)  ||'</unidadeLotacao>'             || CHR(10) ||
                                     '<funcaoGoverno>'           || '22'                            ||'</funcaoGoverno>'              || CHR(10) ||
                                     '<formaProvimento>'         || REC.FORMA_PROVIMENTO            ||'</formaProvimento>'            || CHR(10) ||
                                     '<dataExercicio>'           || REC.DAT_INI_EXERC       ||'</dataExercicio>'              || CHR(10) ||
                                 '</LotacaoAgentePublico>' || CHR(10) ;
     V_FILE :=  V_FILE  || V_TAG_AGENT_PUBLICO;



  END LOOP;

  V_TAG_AGENT_LISTA := '<ListaLotacaoAgentePublico>'  || CHR(10) || V_FILE || '</ListaLotacaoAgentePublico>'|| CHR(10) ;


  V_TAG_FIM :=  '</LotacaoAgentePublico>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_TAG_AGENT_LISTA || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_LOTACAO_AGENTE_PUBLICO;


PROCEDURE SP_LOTACAO_AGENTE_PUBLICO_NEW
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_AGENT_PUBLICO             CLOB;
  V_TAG_AGENT_LISTA               CLOB;
  V_TAG_AGENT_LISTA_2             CLOB;
  V_TAG_AGENT_HIST                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_FILE_2                        CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Lotação Agente Público';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;


  CURSOR GET_LOTACAO IS


SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_LOTACAO

       ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.1293',D.COD_VINCULO) AS TIPO_VINCULO 








































        ,EF.COD_CARGO                               AS COD_CARGO
        ,(
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )||'-'||(
                   SELECT ORGA.NOM_ORGAO
                   FROM TB_LOTACAO LO,
                        TB_ORGAO ORGA
                   WHERE LO.COD_INS           = 1
                   AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
                   AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
                   AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
                   AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
                   AND ORGA.COD_INS           = 1
                   AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
                   AND ORGA.COD_ORGAO         = LO.COD_ORGAO
                   AND LO.DAT_INI =  
                                  (
                                  SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                                  WHERE LO1.COD_INS = LO.COD_INS
                                  AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                                  AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                                  AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                                  AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                                  )
                   )AS NOME_ORGAO 

        , '01'                                     AS FUNCAO_GOVERNO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.1373',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 



        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO

        ,E.NOM_ENTIDADE 

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )
     AND D.DAT_INI_EXERC BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)

    UNION





SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_LOTACAO

       ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.1469',D.COD_VINCULO) AS TIPO_VINCULO 



        ,EF.COD_CARGO                               AS COD_CARGO
        ,(
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND LO.DAT_FIM           IS NULL
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )||'-'||(
                   SELECT ORGA.NOM_ORGAO
                   FROM TB_LOTACAO LO,
                        TB_ORGAO ORGA
                   WHERE LO.COD_INS           = 1
                   AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
                   AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
                   AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
                   AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
                   AND ORGA.COD_INS           = 1
                   AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
                   AND ORGA.COD_ORGAO         = LO.COD_ORGAO
                   AND LO.DAT_FIM             IS NULL
                   AND LO.DAT_INI =  
                                  (
                                  SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                                  WHERE LO1.COD_INS = LO.COD_INS
                                  AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                                  AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                                  AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                                  AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                                  )
                   )AS NOME_ORGAO 

        , '01'                                     AS FUNCAO_GOVERNO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.1551',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 


        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO

        ,E.NOM_ENTIDADE 

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS= 'V'
     AND D.DAT_INI_EXERC < P_PERPROCESSO
     AND EF.DAT_INI_EFEITO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)                       
     AND EXISTS
               (
               SELECT 1 FROM FOLHA_PAR.TB_EVOLUCAO_FUNCIONAL EFE
               WHERE EFE.COD_INS          = 1
               AND EFE.COD_IDE_CLI        = EF.COD_IDE_CLI
               AND EFE.COD_ENTIDADE       = EF.COD_ENTIDADE
               AND EFE.COD_IDE_REL_FUNC   = EF.COD_IDE_REL_FUNC
               AND EFE.NUM_MATRICULA      = EF.NUM_MATRICULA
               AND EFE.DAT_FIM_EFEITO     = EF.DAT_INI_EFEITO - 1
               AND EF.COD_CARGO          != EFE.COD_CARGO
               AND EFE.FLG_STATUS         = 'V'
               )   
  UNION


SELECT
         P_PERPROCESSO                              AS PER_PROCESSO
        ,C.COD_INS
        ,B.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_LOTACAO

        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.1659',D.COD_VINCULO) AS TIPO_VINCULO 


        ,EF.COD_CARGO                               AS COD_CARGO
        ,(
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )||'-'||(
                   SELECT ORGA.NOM_ORGAO
                   FROM TB_LOTACAO LO,
                        TB_ORGAO ORGA
                   WHERE LO.COD_INS           = 1
                   AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
                   AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
                   AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
                   AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
                   AND ORGA.COD_INS           = 1
                   AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
                   AND ORGA.COD_ORGAO         = LO.COD_ORGAO
                   AND LO.DAT_INI =  
                                  (
                                  SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                                  WHERE LO1.COD_INS = LO.COD_INS
                                  AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                                  AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                                  AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                                  AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                                  )
                   )AS NOME_ORGAO 

        , '01'                                     AS FUNCAO_GOVERNO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.1722',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 



        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,D.NUM_MATRICULA                    AS MATRICULA
        ,B.NOM_PESSOA_FISICA                AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO

        ,E.NOM_ENTIDADE 




    FROM 
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE B.COD_IDE_CLI          = C.COD_IDE_CLI
     AND B.COD_IDE_CLI          = D.COD_IDE_CLI
     AND B.COD_IDE_CLI          = EF.COD_IDE_CLI
     AND C.COD_IDE_CLI          = D.COD_IDE_CLI
     AND C.COD_IDE_CLI          = EF.COD_IDE_CLI
     AND D.COD_IDE_CLI          = EF.COD_IDE_CLI


     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS          = 'V'
     AND EF.COD_CARGO           = 9999
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )
     AND D.DAT_INI_EXERC BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)   


   UNION



SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EFG.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_LOTACAO

       ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.1813',D.COD_VINCULO) AS TIPO_VINCULO 


        ,EFG.COD_CARGO_COMP                               AS COD_CARGO
        ,(
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = D.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = D.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = D.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = D.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )||'-'||(
                   SELECT ORGA.NOM_ORGAO
                   FROM TB_LOTACAO LO,
                        TB_ORGAO ORGA
                   WHERE LO.COD_INS           = 1
                   AND LO.COD_ENTIDADE        = D.COD_ENTIDADE
                   AND LO.NUM_MATRICULA       = D.NUM_MATRICULA
                   AND LO.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC
                   AND LO.COD_IDE_CLI         = D.COD_IDE_CLI
                   AND ORGA.COD_INS           = 1
                   AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
                   AND ORGA.COD_ORGAO         = LO.COD_ORGAO
                   AND LO.DAT_INI =  
                                  (
                                  SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                                  WHERE LO1.COD_INS = LO.COD_INS
                                  AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                                  AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                                  AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                                  AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                                  )
                   )AS NOME_ORGAO 

        , '01'                                     AS FUNCAO_GOVERNO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.1893',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 



        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EFG.COD_ENTIDADE
        AND CAR.COD_CARGO = EFG.COD_CARGO_COMP
        )AS NOME_CARGO
        ,PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO

        ,E.NOM_ENTIDADE 

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLU_CCOMI_GFUNCIONAL EFG
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EFG.COD_INS             = 1
     AND EFG.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EFG.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EFG.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EFG.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC  
     AND D.DAT_INI_EXERC <   P_PERPROCESSO
     AND EFG.DAT_INI_EFEITO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)       

ORDER BY NUM_CPF
   ;



 CURSOR GET_HISTORICO_DEMITIDOS IS


      SELECT 
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(D.DAT_RESCISAO,'YYYY-MM-DD')       AS DAT_SIT_LOTACAO

        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_mot_deslig-L.1976',D.COD_MOT_DESLIG) AS COD_SITUACAO_LOTACAO 


        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2021',D.COD_VINCULO) AS TIPO_VINCULO 


        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2042',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 

        , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         = 'D'
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND D.DAT_RESCISAO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )

     UNION



    SELECT 
         P_PERPROCESSO
        ,B.COD_INS
        ,B.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(D.DAT_RESCISAO,'YYYY-MM-DD')       AS DAT_SIT_LOTACAO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_mot_deslig-L.2148',D.COD_MOT_DESLIG) AS COD_SITUACAO_LOTACAO 


        ,EF.NUM_MATRICULA                    AS MATRICULA
        ,B.NOM_PESSOA_FISICA                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2193',D.COD_VINCULO) AS TIPO_VINCULO 

        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2214',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 
        ,  E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE B.COD_INS               = 1
     AND B.COD_IDE_CLI           = D.COD_IDE_CLI
     AND C.COD_INS               = B.COD_INS
     AND C.COD_IDE_CLI           = B.COD_IDE_CLI     
     AND E.COD_ENTIDADE          = D.COD_ENTIDADE
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND D.DAT_RESCISAO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)

     AND D.NUM_MATRICULA != 20127 
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )


   UNION

SELECT 
         P_PERPROCESSO                              AS PER_PROCESSO
        ,D.COD_INS
        ,B.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(D.DAT_RESCISAO,'YYYY-MM-DD')       AS DAT_SIT_LOTACAO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_mot_deslig-L.2312',D.COD_MOT_DESLIG) AS COD_SITUACAO_LOTACAO 




























        ,D.NUM_MATRICULA                    AS MATRICULA
        ,B.NOM_PESSOA_FISICA                AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2357',D.COD_VINCULO) AS TIPO_VINCULO 




















        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2378',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 












           , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM 
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE B.COD_IDE_CLI          = C.COD_IDE_CLI
     AND B.COD_IDE_CLI          = D.COD_IDE_CLI
     AND B.COD_IDE_CLI          = EF.COD_IDE_CLI
     AND C.COD_IDE_CLI          = D.COD_IDE_CLI
     AND C.COD_IDE_CLI          = EF.COD_IDE_CLI
     AND D.COD_IDE_CLI          = EF.COD_IDE_CLI

     AND D.COD_CARGO            = 9999


     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND D.DAT_RESCISAO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )        
       ORDER BY NUM_CPF   
     ;

CURSOR GET_HISTORICO_ADMITIDOS IS



SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT DISTINCT F.NOM_CARGO FROM TB_FOLHA_PAGAMENTO F 
        WHERE F.PER_PROCESSO = P_PERPROCESSO 
        AND F.COD_ENTIDADE = EF.COD_ENTIDADE
        AND F.TIP_PROCESSO = 'N' 
        AND EF.COD_IDE_REL_FUNC = F.COD_IDE_REL_FUNC 
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2505',D.COD_VINCULO) AS TIPO_VINCULO 




















        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2526',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 












           , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )
     AND D.DAT_INI_EXERC BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)

  UNION

  SELECT
         P_PERPROCESSO
        ,D.COD_INS
        ,B.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,D.NUM_MATRICULA                    AS MATRICULA
        ,B.NOM_PESSOA_FISICA                            AS NOM_BEN        
        ,(
        SELECT DISTINCT C.NOM_CARGO FROM TB_CARGO C 
        WHERE C.COD_CARGO = D.COD_CARGO )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2648',D.COD_VINCULO) AS TIPO_VINCULO 




















        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2669',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 












           , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM 
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE B.COD_IDE_CLI          = C.COD_IDE_CLI
     AND B.COD_IDE_CLI          = D.COD_IDE_CLI
     AND B.COD_IDE_CLI          = EF.COD_IDE_CLI
     AND C.COD_IDE_CLI          = D.COD_IDE_CLI
     AND C.COD_IDE_CLI          = EF.COD_IDE_CLI
     AND D.COD_IDE_CLI          = EF.COD_IDE_CLI

     AND D.COD_CARGO            = 9999


     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_INI_EFEITO = 
                            (
                            SELECT MAX(EF1.DAT_INI_EFEITO)
                            FROM TB_EVOLUCAO_FUNCIONAL EF1
                            WHERE EF1.COD_INS = EF.COD_INS 
                            AND EF1.COD_IDE_CLI = EF.COD_IDE_CLI
                            AND EF1.COD_ENTIDADE = EF.COD_ENTIDADE
                            AND EF1.NUM_MATRICULA = EF.NUM_MATRICULA
                            AND EF1.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
                            AND EF1.FLG_STATUS = EF.FLG_STATUS
                            )
     AND D.DAT_INI_EXERC BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)   
    ORDER BY NUM_CPF   
;

CURSOR GET_HISTORICO_ALT_CARGO_EFE IS





SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(EF.DAT_FIM_EFEITO,'YYYY-MM-DD')    AS DAT_SIT_LOTACAO
        ,'6' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2797',D.COD_VINCULO) AS TIPO_VINCULO 




















        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2818',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 












           , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND LO.DAT_FIM           IS NULL
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_FIM             IS NULL
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS= 'V'
     AND EF.DAT_FIM_EFEITO BETWEEN LAST_DAY(ADD_MONTHS(P_PERPROCESSO,-1))  AND LAST_DAY(P_PERPROCESSO)                       

     AND D.NUM_MATRICULA != 20127 
     AND EXISTS
               (
               SELECT 1 FROM FOLHA_PAR.TB_EVOLUCAO_FUNCIONAL EFE
               WHERE EFE.COD_INS          = 1
               AND EFE.COD_IDE_CLI        = EF.COD_IDE_CLI
               AND EFE.COD_ENTIDADE       = EF.COD_ENTIDADE
               AND EFE.COD_IDE_REL_FUNC   = EF.COD_IDE_REL_FUNC
               AND EFE.NUM_MATRICULA      = EF.NUM_MATRICULA

               AND EFE.DAT_INI_EFEITO     = EF.DAT_FIM_EFEITO + 1
               AND EF.COD_CARGO          != EFE.COD_CARGO
               AND EFE.FLG_STATUS         = 'V'
               )    
     ORDER BY NUM_CPF            
     ;


CURSOR GET_HISTORICO_ALT_CARGO_FG IS





SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EFG.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EFG.COD_CARGO_COMP                              AS COD_CARGO
        ,TO_CHAR(EFG.DAT_FIM_EFEITO,'YYYY-MM-DD')    AS DAT_SIT_LOTACAO
        ,'6' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EFG.COD_ENTIDADE
        AND CAR.COD_CARGO = EFG.COD_CARGO_COMP
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.2956',D.COD_VINCULO) AS TIPO_VINCULO 


        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.2977',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 



           , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = D.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = D.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = D.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = D.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = D.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = D.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = D.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLU_CCOMI_GFUNCIONAL EFG
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EFG.COD_INS             = 1
     AND EFG.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EFG.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EFG.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EFG.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC    



     AND EFG.NUM_MATRICULA != 365

     AND D.NUM_MATRICULA != 20127 
     AND EFG.DAT_FIM_EFEITO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)                       
    ORDER BY NUM_CPF   
   ;        

CURSOR GET_HISTORICO_INCL_CARGO_EFE IS





SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EF.COD_CARGO                               AS COD_CARGO
        ,TO_CHAR(EF.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EF.COD_ENTIDADE
        AND CAR.COD_CARGO = EF.COD_CARGO
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.3102',D.COD_VINCULO) AS TIPO_VINCULO 

        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.3123',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 

          , E.NOM_ENTIDADE ,
           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = EF.COD_IDE_CLI
           AND LO.DAT_FIM           IS NULL
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = EF.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = EF.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = EF.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = EF.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_FIM             IS NULL
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLUCAO_FUNCIONAL    EF
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EF.COD_INS             = 1
     AND EF.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EF.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EF.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EF.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC     
     AND EF.FLG_STATUS= 'V'
     AND D.DAT_INI_EXERC < P_PERPROCESSO
     AND EF.DAT_INI_EFEITO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)                       
     AND EXISTS
               (
               SELECT 1 FROM FOLHA_PAR.TB_EVOLUCAO_FUNCIONAL EFE
               WHERE EFE.COD_INS          = 1
               AND EFE.COD_IDE_CLI        = EF.COD_IDE_CLI
               AND EFE.COD_ENTIDADE       = EF.COD_ENTIDADE
               AND EFE.COD_IDE_REL_FUNC   = EF.COD_IDE_REL_FUNC
               AND EFE.NUM_MATRICULA      = EF.NUM_MATRICULA
               AND EFE.DAT_FIM_EFEITO     = EF.DAT_INI_EFEITO - 1
               AND EF.COD_CARGO          != EFE.COD_CARGO
               AND EFE.FLG_STATUS         = 'V'
               )   
     ORDER BY NUM_CPF                 

;

CURSOR GET_HISTORICO_INCL_CARGO_FG IS





SELECT
         A.PER_PROCESSO
        ,A.COD_INS
        ,A.COD_IDE_CLI
        ,'02'                                       AS TIPO
        ,LPAD(B.NUM_CPF,11,'0')                     AS NUM_CPF
        ,TO_CHAR(D.DAT_INI_EXERC,'YYYY-MM-DD')      AS DAT_INI_EXERC
        ,TO_CHAR(EFG.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DATA_INI_EFEITO_CARGO
        ,EFG.COD_CARGO_COMP                              AS COD_CARGO
        ,TO_CHAR(EFG.DAT_INI_EFEITO,'YYYY-MM-DD')    AS DAT_SIT_LOTACAO
        ,'1' 
                                                    AS COD_SITUACAO_LOTACAO              

        ,A.NUM_MATRICULA                    AS MATRICULA
        ,A.NOME                             AS NOM_BEN        
        ,(
        SELECT CAR.NOM_CARGO  FROM TB_CARGO CAR
        WHERE CAR.COD_INS = 1
        AND CAR.COD_ENTIDADE = EFG.COD_ENTIDADE
        AND CAR.COD_CARGO = EFG.COD_CARGO_COMP
        )AS NOME_CARGO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2036', D.COD_SIT_FUNC)
                                                          AS DES_SITUACAO

        ,D.DAT_POSSE                        AS DAT_POSSE
        ,D.DAT_NOMEA                        AS DAT_NOMEA        
        ,D.DAT_FIM_EXERC                    AS DAT_FIM_EXERC
        ,D.DAT_RESCISAO                     AS DAT_RESCISAO
        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2139', D.COD_VINCULO)
                                                          AS DES_VINCULO
        ,D.COD_VINCULO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.cod_vinculo-L.3259',D.COD_VINCULO) AS TIPO_VINCULO 


        ,FOLHA_PAR.PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','2025', D.TIP_PROVIMENTO)
                                                          AS DES_PROVIMENTO
        ,D.TIP_PROVIMENTO
        ,FNC_DEPARA_NOME(V_AUDESP,'d.TIP_PROVIMENTO-L.3280',D.TIP_PROVIMENTO) AS FORMA_PROVIMENTO 


           , E.NOM_ENTIDADE ,

           (
           SELECT LO.COD_ORGAO 
           FROM TB_LOTACAO LO
           WHERE LO.COD_INS         = 1
           AND LO.COD_ENTIDADE      = D.COD_ENTIDADE
           AND LO.NUM_MATRICULA     = D.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC  = D.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI       = D.COD_IDE_CLI
           AND TO_DATE(LO.DAT_INI, 'dd/mm/yyyy') =  
                          (
                          SELECT MAX(TO_DATE(LO1.DAT_INI, 'dd/mm/yyyy')) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS COD_ORGAO,

           (
           SELECT ORGA.NOM_ORGAO
           FROM TB_LOTACAO LO,
                TB_ORGAO ORGA
           WHERE LO.COD_INS           = 1
           AND LO.COD_ENTIDADE        = D.COD_ENTIDADE
           AND LO.NUM_MATRICULA       = D.NUM_MATRICULA
           AND LO.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC
           AND LO.COD_IDE_CLI         = D.COD_IDE_CLI
           AND ORGA.COD_INS           = 1
           AND ORGA.COD_ENTIDADE      = LO.COD_ENTIDADE
           AND ORGA.COD_ORGAO         = LO.COD_ORGAO
           AND LO.DAT_INI =  
                          (
                          SELECT MAX(LO1.DAT_INI) FROM TB_LOTACAO LO1
                          WHERE LO1.COD_INS = LO.COD_INS
                          AND LO1.COD_ENTIDADE = LO.COD_ENTIDADE
                          AND LO1.COD_IDE_CLI = LO.COD_IDE_CLI
                          AND LO1.COD_IDE_REL_FUNC = LO.COD_IDE_REL_FUNC
                          AND LO1.NUM_MATRICULA = LO.NUM_MATRICULA
                          )
           )AS NOME_ORGAO

    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_SERVIDOR              C,
         TB_RELACAO_FUNCIONAL     D,
         TB_ENTIDADE              E,
         TB_EVOLU_CCOMI_GFUNCIONAL EFG
   WHERE A.COD_ENTIDADE         = D.COD_ENTIDADE
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_ENTIDADE         = '1' 
     AND A.TIP_PROCESSO         IN ('N','S')
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.COD_INS              = C.COD_INS
     AND A.COD_IDE_CLI          = C.COD_IDE_CLI
     AND A.COD_INS              = D.COD_INS
     AND A.COD_IDE_CLI          = D.COD_IDE_CLI
     AND A.COD_ENTIDADE         = E.COD_ENTIDADE
     AND A.NUM_MATRICULA        = D.NUM_MATRICULA
     AND A.COD_IDE_REL_FUNC     = D.COD_IDE_REL_FUNC
     AND EFG.COD_INS             = 1
     AND EFG.COD_ENTIDADE        = D.COD_ENTIDADE
     AND EFG.COD_IDE_CLI         = D.COD_IDE_CLI
     AND EFG.NUM_MATRICULA       = D.NUM_MATRICULA
     AND EFG.COD_IDE_REL_FUNC    = D.COD_IDE_REL_FUNC  
     AND D.DAT_INI_EXERC <   P_PERPROCESSO
     AND EFG.DAT_INI_EFEITO BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)                       


ORDER BY B.NUM_CPF     
;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'LotacaoAgentePublico_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<LotacaoAgentePublico'                    ;

  V_TAG_DEFINICOES :=
                        '                     xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'|| CHR(10) ||
                        '                     xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'  || CHR(10) ||
                        '                     xmlns:qpla="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-lotacaoagentepublico"' || CHR(10) ||
                        '                     xmlns="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-lotacaoagentepublico"' || CHR(10)||
                        '                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'       || CHR(10) ||

                        '                     xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/quadrofuncional-lotacaoagentepublico ../quadrofuncional/AUDESP_LOTACAOAGENTEPUBLICO_'||V_ANO||'_A.xsd">'
                         || CHR(10);


  V_TAG_DESCRITOR   := '<Descritor>'   || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                        '</Descritor>' || CHR(10) ;


  FOR REC1 IN GET_LOTACAO LOOP

    V_TAG_AGENT_PUBLICO :=      '<LotacaoAgentePublico>'         || CHR(10) ||
                                   '<cpf Tipo="02">'             || CHR(10)                         ||
                                      '<gen:Numero>'             || UPPER(TRIM(REC1.NUM_CPF))        ||'</gen:Numero>'                 || CHR(10) ||
                                    '</cpf>'                     || CHR(10)                         ||
                                     '<dataLotacao>'             || REC1.DATA_LOTACAO                   ||'</dataLotacao>'                || CHR(10) ||
                                     '<exercicioAtividade>'      || REC1.TIPO_VINCULO               ||'</exercicioAtividade>'         || CHR(10) ||
                                     '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'       || CHR(10) ||
                                     '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'        || CHR(10) ||
                                     '<codigoCargo>'             || REC1.COD_CARGO                   ||'</codigoCargo>'                || CHR(10) ||

                                     '<cargoRemunerado/>' || CHR(10) ||

                                     '<unidadeLotacao>'          || REC1.NOME_ORGAO  ||'</unidadeLotacao>'             || CHR(10) ||
                                     '<funcaoGoverno>'           || '01'                            ||'</funcaoGoverno>'              || CHR(10) ||
                                     '<formaProvimento>'         || REC1.FORMA_PROVIMENTO            ||'</formaProvimento>'            || CHR(10) ||
                                     '<dataExercicio>'           || REC1.DAT_SIT_LOTACAO       ||'</dataExercicio>'              || CHR(10) ||
                                 '</LotacaoAgentePublico>' || CHR(10) ;

     V_FILE :=  V_FILE  || V_TAG_AGENT_PUBLICO;

     END LOOP;

     V_TAG_AGENT_LISTA := '<ListaLotacaoAgentePublico>'  || CHR(10) || V_FILE || '</ListaLotacaoAgentePublico>'|| CHR(10) ;

     FOR REC2 IN GET_HISTORICO_DEMITIDOS LOOP
           V_TAG_AGENT_HIST :=      '<HistoricoLotacaoAgentePublico>'       || CHR(10) ||
                                           '<cpf Tipo="02">'                || CHR(10)                         ||
                                              '<gen:Numero>'                || UPPER(TRIM(REC2.NUM_CPF))       ||'</gen:Numero>'                   || CHR(10) ||
                                            '</cpf>'                        || CHR(10)                         ||
                                             '<dataExercicio>'              || REC2.DAT_INI_EXERC              ||'</dataExercicio>'                || CHR(10) ||
                                             '<dataLotacao>'                || REC2.DATA_INI_EFEITO_CARGO      ||'</dataLotacao>'                  || CHR(10) ||
                                                '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'         || CHR(10) ||
                                                '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'          || CHR(10) ||
                                                '<codigoCargo>'             || REC2.COD_CARGO                  ||'</codigoCargo>'                  || CHR(10) ||
                                             '<dataHistoricoLotacao>'       || REC2.DAT_SIT_LOTACAO            ||'</dataHistoricoLotacao>'         || CHR(10) ||
                                             '<situacao>'                   || REC2.COD_SITUACAO_LOTACAO       ||'</situacao>'                     || CHR(10) ||
                                         '</HistoricoLotacaoAgentePublico>' || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_AGENT_HIST ;

     END LOOP; 


  FOR REC3 IN GET_HISTORICO_ADMITIDOS LOOP
           V_TAG_AGENT_HIST :=      '<HistoricoLotacaoAgentePublico>'       || CHR(10) ||
                                           '<cpf Tipo="02">'                || CHR(10)                         ||
                                              '<gen:Numero>'                || UPPER(TRIM(REC3.NUM_CPF))       ||'</gen:Numero>'                   || CHR(10) ||
                                            '</cpf>'                        || CHR(10)                         ||
                                             '<dataExercicio>'              || REC3.DAT_INI_EXERC              ||'</dataExercicio>'                || CHR(10) ||
                                             '<dataLotacao>'                || REC3.DATA_INI_EFEITO_CARGO      ||'</dataLotacao>'                  || CHR(10) ||
                                                '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'         || CHR(10) ||
                                                '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'          || CHR(10) ||
                                                '<codigoCargo>'             || REC3.COD_CARGO                  ||'</codigoCargo>'                  || CHR(10) ||
                                             '<dataHistoricoLotacao>'       || REC3.DAT_SIT_LOTACAO            ||'</dataHistoricoLotacao>'         || CHR(10) ||
                                             '<situacao>'                   || REC3.COD_SITUACAO_LOTACAO       ||'</situacao>'                     || CHR(10) ||
                                         '</HistoricoLotacaoAgentePublico>' || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_AGENT_HIST ;
     END LOOP;


  FOR REC4 IN GET_HISTORICO_ALT_CARGO_EFE LOOP
           V_TAG_AGENT_HIST :=      '<HistoricoLotacaoAgentePublico>'       || CHR(10) ||
                                           '<cpf Tipo="02">'                || CHR(10)                         ||
                                              '<gen:Numero>'                || UPPER(TRIM(REC4.NUM_CPF))       ||'</gen:Numero>'                   || CHR(10) ||
                                            '</cpf>'                        || CHR(10)                         ||
                                             '<dataExercicio>'              || REC4.DAT_INI_EXERC              ||'</dataExercicio>'                || CHR(10) ||
                                             '<dataLotacao>'                || REC4.DATA_INI_EFEITO_CARGO      ||'</dataLotacao>'                  || CHR(10) ||
                                                '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'         || CHR(10) ||
                                                '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'          || CHR(10) ||
                                                '<codigoCargo>'             || REC4.COD_CARGO                  ||'</codigoCargo>'                  || CHR(10) ||
                                             '<dataHistoricoLotacao>'       || REC4.DAT_SIT_LOTACAO            ||'</dataHistoricoLotacao>'         || CHR(10) ||
                                             '<situacao>'                   || REC4.COD_SITUACAO_LOTACAO       ||'</situacao>'                     || CHR(10) ||
                                         '</HistoricoLotacaoAgentePublico>' || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_AGENT_HIST ;

     END LOOP;


     FOR REC5 IN GET_HISTORICO_ALT_CARGO_FG LOOP
           V_TAG_AGENT_HIST :=      '<HistoricoLotacaoAgentePublico>'       || CHR(10) ||
                                           '<cpf Tipo="02">'                || CHR(10)                         ||
                                              '<gen:Numero>'                || UPPER(TRIM(REC5.NUM_CPF))       ||'</gen:Numero>'                   || CHR(10) ||
                                            '</cpf>'                        || CHR(10)                         ||
                                             '<dataExercicio>'              || REC5.DAT_INI_EXERC              ||'</dataExercicio>'                || CHR(10) ||
                                             '<dataLotacao>'                || REC5.DATA_INI_EFEITO_CARGO      ||'</dataLotacao>'                  || CHR(10) ||
                                                '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'         || CHR(10) ||
                                                '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'          || CHR(10) ||
                                                '<codigoCargo>'             || REC5.COD_CARGO                  ||'</codigoCargo>'                  || CHR(10) ||
                                             '<dataHistoricoLotacao>'       || REC5.DAT_SIT_LOTACAO            ||'</dataHistoricoLotacao>'         || CHR(10) ||
                                             '<situacao>'                   || REC5.COD_SITUACAO_LOTACAO       ||'</situacao>'                     || CHR(10) ||
                                         '</HistoricoLotacaoAgentePublico>' || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_AGENT_HIST ;

     END LOOP;

     FOR REC6 IN GET_HISTORICO_INCL_CARGO_EFE LOOP
           V_TAG_AGENT_HIST :=      '<HistoricoLotacaoAgentePublico>'       || CHR(10) ||
                                           '<cpf Tipo="02">'                || CHR(10)                         ||
                                              '<gen:Numero>'                || UPPER(TRIM(REC6.NUM_CPF))       ||'</gen:Numero>'                   || CHR(10) ||
                                            '</cpf>'                        || CHR(10)                         ||
                                             '<dataExercicio>'              || REC6.DAT_INI_EXERC              ||'</dataExercicio>'                || CHR(10) ||
                                             '<dataLotacao>'                || REC6.DATA_INI_EFEITO_CARGO      ||'</dataLotacao>'                  || CHR(10) ||
                                                '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'         || CHR(10) ||
                                                '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'          || CHR(10) ||
                                                '<codigoCargo>'             || REC6.COD_CARGO                  ||'</codigoCargo>'                  || CHR(10) ||
                                             '<dataHistoricoLotacao>'       || REC6.DAT_SIT_LOTACAO            ||'</dataHistoricoLotacao>'         || CHR(10) ||
                                             '<situacao>'                   || REC6.COD_SITUACAO_LOTACAO       ||'</situacao>'                     || CHR(10) ||
                                         '</HistoricoLotacaoAgentePublico>' || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_AGENT_HIST ;

     END LOOP;

     FOR REC7 IN GET_HISTORICO_INCL_CARGO_FG LOOP
           V_TAG_AGENT_HIST :=      '<HistoricoLotacaoAgentePublico>'       || CHR(10) ||
                                           '<cpf Tipo="02">'                || CHR(10)                         ||
                                              '<gen:Numero>'                || UPPER(TRIM(REC7.NUM_CPF))       ||'</gen:Numero>'                   || CHR(10) ||
                                            '</cpf>'                        || CHR(10)                         ||
                                             '<dataExercicio>'              || REC7.DAT_INI_EXERC              ||'</dataExercicio>'                || CHR(10) ||
                                             '<dataLotacao>'                || REC7.DATA_INI_EFEITO_CARGO      ||'</dataLotacao>'                  || CHR(10) ||
                                                '<codigoMunicipioCargo>'    || V_MUNICIPIO                     ||'</codigoMunicipioCargo>'         || CHR(10) ||
                                                '<codigoEntidadeCargo>'     || V_ENTIDADE                      ||'</codigoEntidadeCargo>'          || CHR(10) ||
                                                '<codigoCargo>'             || REC7.COD_CARGO                  ||'</codigoCargo>'                  || CHR(10) ||
                                             '<dataHistoricoLotacao>'       || REC7.DAT_SIT_LOTACAO            ||'</dataHistoricoLotacao>'         || CHR(10) ||
                                             '<situacao>'                   || REC7.COD_SITUACAO_LOTACAO       ||'</situacao>'                     || CHR(10) ||
                                         '</HistoricoLotacaoAgentePublico>' || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_AGENT_HIST ;

     END LOOP;

     V_TAG_AGENT_LISTA_2:= '<ListaHistoricoLotacaoAgentePublico>'|| CHR(10) || V_FILE_2 ||CHR(10) ||'</ListaHistoricoLotacaoAgentePublico>'|| CHR(10);




  V_TAG_FIM :=  '</LotacaoAgentePublico>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_TAG_AGENT_LISTA || V_TAG_AGENT_LISTA_2|| V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_LOTACAO_AGENTE_PUBLICO_NEW;





PROCEDURE SP_RESUMO_MENSAL_B
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_APOSENTADORIASPENSOES     CLOB;
  V_TAG_APOS_PENSAO               CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Resumo Mensal da Folha de Pagamento';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER:=0;
  V_CONTR_PREV_GERAL_POL          VARCHAR2(100):=0;
  V_CONTR_PREV_PROP_POL           VARCHAR2(100):=0;
  V_CONTR_PREV_GERAL_NAO_POL      VARCHAR2(100):=0;
  V_CONTR_PREV_PROP_NAO_POL       VARCHAR2(100):=0;

  CURSOR GET_RESUMO IS
  SELECT




         REPLACE(SUM(E.VAL_RUBRICA),',','.')   AS CONTR_PREV_PROP_POL



    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_HFOLHA_PAGAMENTO_DET  E,
         TB_RELACAO_FUNCIONAL    RF  
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.COD_ENTIDADE         = '1' 
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'N'
     AND E.COD_INS              = A.COD_INS
     AND E.PER_PROCESSO         = A.PER_PROCESSO
     AND E.TIP_PROCESSO         = A.TIP_PROCESSO
     AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
     AND E.COD_IDE_CLI          = A.COD_IDE_CLI

     AND RF.COD_IDE_CLI          = A.COD_IDE_CLI
     AND RF.COD_IDE_CLI          = B.COD_IDE_CLI     
     AND RF.COD_IDE_CLI          = E.COD_IDE_CLI     
     AND RF.COD_VINCULO = 6                      
     AND A.NUM_GRP               <> 3
     AND EXISTS (SELECT 1
                  FROM TB_RUBRICA_VERBA_AUDESP X
                  WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                    AND X.COD_CONCEITO = (TRUNC(E.COD_FCRUBRICA/100)) 

                    AND X.COD_VERBA    = '201'
                    )
   GROUP BY
         A.PER_PROCESSO
        ,A.COD_ENTIDADE;

  CURSOR GET_CONTR_PREV_GERAL_POL_1 IS
  SELECT
          REPLACE(SUM(E.VAL_RUBRICA),',','.')   AS CONTR_PREV_GERAL_POL


      FROM TB_HFOLHA_PAGAMENTO      A,
           TB_PESSOA_FISICA         B,
           TB_HFOLHA_PAGAMENTO_DET  E,
           TB_RELACAO_FUNCIONAL    RF  
     WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
       AND A.PER_PROCESSO         = P_PERPROCESSO
       AND A.COD_IDE_CLI          = B.COD_IDE_CLI
       AND A.COD_ENTIDADE         = '1'
       AND A.TIP_PROCESSO         = 'N'
       AND E.COD_INS              = A.COD_INS
       AND E.PER_PROCESSO         = A.PER_PROCESSO
       AND E.TIP_PROCESSO         = A.TIP_PROCESSO
       AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
       AND E.COD_IDE_CLI          = A.COD_IDE_CLI

      AND RF.COD_IDE_CLI          = A.COD_IDE_CLI
      AND RF.COD_IDE_CLI          = B.COD_IDE_CLI     
      AND RF.COD_IDE_CLI          = E.COD_IDE_CLI     
      AND RF.COD_VINCULO = 6                          
      AND A.NUM_GRP               <> 3
      AND EXISTS (SELECT 1
                    FROM TB_RUBRICA_VERBA_AUDESP X
                    WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                      AND X.COD_CONCEITO = (TRUNC(E.COD_FCRUBRICA/100)) 

                      AND X.COD_VERBA    = '200'
                      )
     GROUP BY
           A.PER_PROCESSO
          ,A.COD_ENTIDADE;

  CURSOR GET_PREV_GERAL_NAO_POL_3 IS
  SELECT
          REPLACE(SUM(E.VAL_RUBRICA),',','.')                    AS CONTR_PREV_GERAL_NAO_POL

   FROM TB_HFOLHA_PAGAMENTO         A,
           TB_PESSOA_FISICA         B,
           TB_HFOLHA_PAGAMENTO_DET  E,
           TB_RELACAO_FUNCIONAL    RF  
     WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
       AND A.PER_PROCESSO         = P_PERPROCESSO 
       AND A.COD_IDE_CLI          = B.COD_IDE_CLI
       AND A.COD_ENTIDADE         = '1'
       AND A.TIP_PROCESSO         = 'N'
       AND E.COD_INS              = A.COD_INS
       AND E.PER_PROCESSO         = A.PER_PROCESSO
       AND E.TIP_PROCESSO         = A.TIP_PROCESSO
       AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
       AND E.COD_IDE_CLI          = A.COD_IDE_CLI
       AND RF.COD_IDE_CLI          = A.COD_IDE_CLI
       AND RF.COD_IDE_CLI          = B.COD_IDE_CLI     
       AND RF.COD_IDE_CLI          = E.COD_IDE_CLI     
       AND RF.COD_VINCULO <> 6                          
       AND A.NUM_GRP              <> 3
       AND EXISTS (SELECT 1
                    FROM TB_RUBRICA_VERBA_AUDESP X
                    WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                      AND X.COD_CONCEITO = (TRUNC(E.COD_FCRUBRICA/100)) 

                      AND X.COD_VERBA    = '200'
                      )
     GROUP BY
           A.PER_PROCESSO
          ,A.COD_ENTIDADE;


  CURSOR GET_PROP_NAO_POL_4 IS
  SELECT
           REPLACE(SUM(E.VAL_RUBRICA),',','.')       AS CONTR_PREV_PROP_NAO_POL

      FROM TB_HFOLHA_PAGAMENTO      A,
           TB_PESSOA_FISICA         B,
           TB_HFOLHA_PAGAMENTO_DET  E,
           TB_RELACAO_FUNCIONAL    RF  
     WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
       AND A.PER_PROCESSO         = P_PERPROCESSO 
       AND A.COD_IDE_CLI          = B.COD_IDE_CLI
       AND A.COD_ENTIDADE         = '1'
       AND A.TIP_PROCESSO         = 'N'
       AND E.COD_INS              = A.COD_INS
       AND E.PER_PROCESSO         = A.PER_PROCESSO
       AND E.TIP_PROCESSO         = A.TIP_PROCESSO
       AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
       AND E.COD_IDE_CLI          = A.COD_IDE_CLI

       AND RF.COD_IDE_CLI          = A.COD_IDE_CLI
       AND RF.COD_IDE_CLI          = B.COD_IDE_CLI     
       AND RF.COD_IDE_CLI          = E.COD_IDE_CLI     
       AND RF.COD_VINCULO <> 6                          
       AND A.NUM_GRP              <> 3
       AND EXISTS (SELECT 1
                    FROM TB_RUBRICA_VERBA_AUDESP X
                    WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                      AND X.COD_CONCEITO = (TRUNC(E.COD_FCRUBRICA/100)) 

                      AND X.COD_VERBA    = '201'
                      )
     GROUP BY
           A.PER_PROCESSO
          ,A.COD_ENTIDADE;


BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoal_ResumoMensalFolhaPagamento_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<rem:ResumoMensalFolhaPagamento xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'   || CHR(10) ;


  V_TAG_DEFINICOES :=
                  '                 xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'              || CHR(10) ||
                  '                 xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'                || CHR(10) ||
                  '                 xmlns:rem="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'             || CHR(10) ||
                  '                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                   || CHR(10) ||

                  '                 xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../remuneracao/AUDESP_RESUMO_MENSAL_FOLHA_PAGAMENTO_'||V_ANO||'_A.XSD">' || CHR(10) ;

  V_TAG_DESCRITOR   :=
                  '    <rem:Descritor>'          || CHR(10) ||
                  '        <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '        <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '        <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '        <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '        <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '        <gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                  '    </rem:Descritor>'         || CHR(10) ;


  OPEN GET_RESUMO;
  FETCH GET_RESUMO INTO V_CONTR_PREV_PROP_POL;
  CLOSE GET_RESUMO;

  OPEN GET_CONTR_PREV_GERAL_POL_1;
  FETCH GET_CONTR_PREV_GERAL_POL_1 INTO V_CONTR_PREV_GERAL_POL;
  CLOSE GET_CONTR_PREV_GERAL_POL_1;

  OPEN GET_PREV_GERAL_NAO_POL_3;
  FETCH GET_PREV_GERAL_NAO_POL_3 INTO V_CONTR_PREV_GERAL_NAO_POL;
  CLOSE GET_PREV_GERAL_NAO_POL_3;

  OPEN GET_PROP_NAO_POL_4;
  FETCH GET_PROP_NAO_POL_4 INTO V_CONTR_PREV_PROP_NAO_POL;
  CLOSE GET_PROP_NAO_POL_4;



  V_TAG_APOSENTADORIASPENSOES :=
                  '    <rem:ListaResumoFolhaPagamento>'            || CHR(10) ||
                  '        <rem:MunicipioEntidadeLotacao>'         || CHR(10) ||
                  '            <gen:codigoMunicipio>'              || V_MUNICIPIO                 ||'</gen:codigoMunicipio>'                   || CHR(10) ||
                  '            <gen:codigoEntidade>'               || V_ENTIDADE                  ||'</gen:codigoEntidade>'                    || CHR(10) ||
                  '        </rem:MunicipioEntidadeLotacao>'        || CHR(10) ||
                  '        <rem:VlFGTS>'                           || 0                           ||'</rem:VlFGTS>'                            || CHR(10) ||
                  '        <rem:VlContribPrevGeralAgPolitico>'     || V_CONTR_PREV_GERAL_POL      ||'</rem:VlContribPrevGeralAgPolitico>'      || CHR(10) ||
                  '        <rem:VlContribPrevProprioAgPolitico>'   || V_CONTR_PREV_PROP_POL       ||'</rem:VlContribPrevProprioAgPolitico>'    || CHR(10) ||
                  '        <rem:VlContribPrevGeralAgNaoPolitico>'  || V_CONTR_PREV_GERAL_NAO_POL  ||'</rem:VlContribPrevGeralAgNaoPolitico>'   || CHR(10) ||
                  '        <rem:VlContribPrevProprioAgNaoPolitico>'|| V_CONTR_PREV_PROP_NAO_POL   ||'</rem:VlContribPrevProprioAgNaoPolitico>' || CHR(10) ||
                  '    </rem:ListaResumoFolhaPagamento>'           || CHR(10) ;
        V_FILE :=  V_FILE  || V_TAG_APOSENTADORIASPENSOES;




  V_TAG_FIM :=  '</rem:ResumoMensalFolhaPagamento>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_RESUMO_MENSAL_B;

PROCEDURE SP_RESUMO_MENSAL
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)

IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_APOSENTADORIASPENSOES     CLOB;
  V_TAG_APOS_PENSAO               CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Resumo Mensal da Folha de Pagamento';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='0007';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER:=0;
  V_CONTR_PREV_GERAL_POL          VARCHAR2(100):=0;
  V_CONTR_PREV_PROP_POL           VARCHAR2(100):=0;
  V_CONTR_PREV_GERAL_NAO_POL      VARCHAR2(100):=0;
  V_CONTR_PREV_PROP_NAO_POL       VARCHAR2(100):=0;

  CURSOR GET_RESUMO IS
  SELECT
         A.PER_PROCESSO
        ,A.COD_ENTIDADE
        ,0                    AS CONTR_PREV_GERAL_POL 
        ,0                    AS CONTR_PREV_PROP_POL
        ,0                    AS CONTR_PREV_GERAL_NAO_POL
        ,REPLACE(SUM(DECODE(E.VAL_RUBRICA,E.COD_IDE_CLI,'1000031893','0',E.VAL_RUBRICA) ),',','.')   AS CONTR_PREV_PROP_NAO_POL
    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_HFOLHA_PAGAMENTO_DET  E
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.COD_ENTIDADE         = '1' 
     AND A.PER_PROCESSO         = P_PERPROCESSO
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'N'
     AND E.COD_INS              = A.COD_INS
     AND E.PER_PROCESSO         = A.PER_PROCESSO
     AND E.TIP_PROCESSO         = A.TIP_PROCESSO
     AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
     AND E.COD_IDE_CLI          = A.COD_IDE_CLI
     AND E.COD_IDE_CLI          NOT IN ('')
     AND EXISTS (SELECT 1
                  FROM TB_RUBRICA_VERBA_AUDESP X
                  WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                    AND X.COD_RUBRICA  = E.COD_FCRUBRICA
                    AND X.COD_VERBA    = '201'
                    )
   GROUP BY
         A.PER_PROCESSO
        ,A.COD_ENTIDADE;

  CURSOR GET_CONTR_PREV_GERAL_POL_1 IS
  SELECT
          REPLACE(SUM(E.VAL_RUBRICA),',','.')                    AS CONTR_PREV_GERAL_NAO_POL
      FROM TB_HFOLHA_PAGAMENTO      A,
           TB_PESSOA_FISICA         B,
           TB_HFOLHA_PAGAMENTO_DET  E
     WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
       AND A.PER_PROCESSO         = P_PERPROCESSO
       AND A.COD_IDE_CLI          = B.COD_IDE_CLI
       AND A.COD_ENTIDADE         = '1'
       AND A.TIP_PROCESSO         = 'N'
       AND E.COD_INS              = A.COD_INS
       AND E.PER_PROCESSO         = A.PER_PROCESSO
       AND E.TIP_PROCESSO         = A.TIP_PROCESSO
       AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
       AND E.COD_IDE_CLI          = A.COD_IDE_CLI
       AND E.COD_IDE_CLI          IN ('1000031893','1000031965')
       AND EXISTS (SELECT 1
                    FROM TB_RUBRICA_VERBA_AUDESP X
                    WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                      AND X.COD_RUBRICA  = E.COD_FCRUBRICA
                      AND X.COD_VERBA    = '201'
                      )
     GROUP BY
           A.PER_PROCESSO
          ,A.COD_ENTIDADE;

  CURSOR GET_PREV_GERAL_NAO_POL_3 IS
  SELECT
          REPLACE(SUM(E.VAL_RUBRICA),',','.')                    AS CONTR_PREV_GERAL_NAO_POL
      FROM TB_HFOLHA_PAGAMENTO      A,
           TB_PESSOA_FISICA         B,
           TB_HFOLHA_PAGAMENTO_DET  E
     WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
       AND A.PER_PROCESSO         = P_PERPROCESSO 
       AND A.COD_IDE_CLI          = B.COD_IDE_CLI
       AND A.COD_ENTIDADE         = '1'
       AND A.TIP_PROCESSO         = 'N'
       AND E.COD_INS              = A.COD_INS
       AND E.PER_PROCESSO         = A.PER_PROCESSO
       AND E.TIP_PROCESSO         = A.TIP_PROCESSO
       AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
       AND E.COD_IDE_CLI          = A.COD_IDE_CLI
       AND EXISTS (SELECT 1
                    FROM TB_RUBRICA_VERBA_AUDESP X
                    WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                      AND X.COD_RUBRICA  = E.COD_FCRUBRICA
                      AND X.COD_VERBA    = '200'
                      )
     GROUP BY
           A.PER_PROCESSO
          ,A.COD_ENTIDADE;


  CURSOR GET_PROP_NAO_POL_4 IS
  SELECT
           REPLACE(SUM(E.VAL_RUBRICA),',','.')       AS CONTR_PREV_PROP_NAO_POL
      FROM TB_HFOLHA_PAGAMENTO      A,
           TB_PESSOA_FISICA         B,
           TB_HFOLHA_PAGAMENTO_DET  E
     WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
       AND A.PER_PROCESSO         = P_PERPROCESSO 
       AND A.COD_IDE_CLI          = B.COD_IDE_CLI
       AND A.COD_ENTIDADE         = '1'
       AND A.TIP_PROCESSO         = 'N'
       AND E.COD_INS              = A.COD_INS
       AND E.PER_PROCESSO         = A.PER_PROCESSO
       AND E.TIP_PROCESSO         = A.TIP_PROCESSO
       AND E.SEQ_PAGAMENTO        = A.SEQ_PAGAMENTO
       AND E.COD_IDE_CLI          = A.COD_IDE_CLI
       AND E.COD_IDE_CLI          NOT IN ('1000031893','1000031965')
       AND EXISTS (SELECT 1
                    FROM TB_RUBRICA_VERBA_AUDESP X
                    WHERE X.COD_ENTIDADE = A.COD_ENTIDADE
                      AND X.COD_RUBRICA  = E.COD_FCRUBRICA
                      AND X.COD_VERBA    = '201'
                      )
     GROUP BY
           A.PER_PROCESSO
          ,A.COD_ENTIDADE;

  CURSOR GET_VERBA
  (
  P_COD_ENTIDADE IN TB_RUBRICA_VERBA_AUDESP.COD_ENTIDADE%TYPE,
  P_COD_RUBRICA  IN TB_RUBRICA_VERBA_AUDESP.COD_RUBRICA%TYPE
  )
  IS
  SELECT A.COD_VERBA
    FROM TB_TIPO_VERBA_AUDESP     A,
         TB_RUBRICA_VERBA_AUDESP  B
   WHERE A.COD_INS      = B.COD_INS
     AND A.COD_VERBA    = B.COD_VERBA
     AND B.COD_ENTIDADE = P_COD_ENTIDADE
     AND B.COD_RUBRICA  = P_COD_RUBRICA;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'ResumoMensalFolhaPagamento_Ativos_' || V_ANO || V_MES || V_NOME_EXTENSAO;

  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';




  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<rem:ResumoMensalFolhaPagamento xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'   || CHR(10) ;


  V_TAG_DEFINICOES :=   'xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'              || CHR(10) ||
                        'xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'                || CHR(10) ||
                        'xmlns:rem="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'             || CHR(10) ||
                        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'                   || CHR(10) ||
                        'xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../' ||
                        'remuneracao/AUDESP_RESUMO_MENSAL_FOLHA_PAGAMENTO_'||V_ANO||'_A'                 ||
                        '.XSD">' || CHR(10) ;

  V_TAG_DESCRITOR   := '<rem:Descritor>'          || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                           '<gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                        '</rem:Descritor>'        || CHR(10) ;

  OPEN GET_CONTR_PREV_GERAL_POL_1;
  FETCH GET_CONTR_PREV_GERAL_POL_1 INTO V_CONTR_PREV_GERAL_POL;
  CLOSE GET_CONTR_PREV_GERAL_POL_1;

  OPEN GET_PREV_GERAL_NAO_POL_3;
  FETCH GET_PREV_GERAL_NAO_POL_3 INTO V_CONTR_PREV_GERAL_NAO_POL;
  CLOSE GET_PREV_GERAL_NAO_POL_3;

  OPEN GET_PROP_NAO_POL_4;
  FETCH GET_PROP_NAO_POL_4 INTO V_CONTR_PREV_PROP_NAO_POL;
  CLOSE GET_PROP_NAO_POL_4;



        V_TAG_APOSENTADORIASPENSOES := '<rem:ListaResumoFolhaPagamento>'            || CHR(10) ||
                                          '<rem:MunicipioEntidadeLotacao>'          || CHR(10) ||
                                             '<gen:codigoMunicipio>'                || V_MUNICIPIO                  ||'</gen:codigoMunicipio>'                   || CHR(10) ||
                                             '<gen:codigoEntidade>'                 || V_ENTIDADE                  ||'</gen:codigoEntidade>'                    || CHR(10) ||
                                          '</rem:MunicipioEntidadeLotacao>'         || CHR(10) ||
                                          '<rem:VlFGTS>'                            || 0                            ||'</rem:VlFGTS>'                            || CHR(10) ||
                                          '<rem:VlContribPrevGeralAgPolitico>'      || V_CONTR_PREV_GERAL_POL       ||'</rem:VlContribPrevGeralAgPolitico>'      || CHR(10) ||
                                          '<rem:VlContribPrevProprioAgPolitico>'    || V_CONTR_PREV_PROP_POL        ||'</rem:VlContribPrevProprioAgPolitico>'    || CHR(10) ||
                                          '<rem:VlContribPrevGeralAgNaoPolitico>'   || V_CONTR_PREV_GERAL_NAO_POL   ||'</rem:VlContribPrevGeralAgNaoPolitico>'   || CHR(10) ||
                                          '<rem:VlContribPrevProprioAgNaoPolitico>' || V_CONTR_PREV_PROP_NAO_POL    ||'</rem:VlContribPrevProprioAgNaoPolitico>' || CHR(10) ||
                                      '</rem:ListaResumoFolhaPagamento>'            || CHR(10) ;
        V_FILE :=  V_FILE  || V_TAG_APOSENTADORIASPENSOES;
        
      DELETE   TB_AUDESP_RESUMO_MENSAL P      
      WHERE 01||'/'||P.MES||'/'||P.ANO = P_PERPROCESSO;   
        
      INSERT INTO TB_AUDESP_RESUMO_MENSAL
       VALUES (
          V_ANO                         ,
          V_MES                         ,
          C_TIPO_DOCUMENTO              ,
          TRUNC(SYSDATE)                , 
          V_MUNICIPIO                   ,
          V_ENTIDADE                    ,  
          V_CONTR_PREV_GERAL_POL        ,
          V_CONTR_PREV_PROP_POL         ,
          V_CONTR_PREV_GERAL_NAO_POL    ,
          V_CONTR_PREV_PROP_NAO_POL     ,
          SYSDATE 
        );

   COMMIT;

  V_TAG_FIM :=  '</rem:ResumoMensalFolhaPagamento>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_RESUMO_MENSAL;

PROCEDURE SP_VERBA_REMUNERATORIAS
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Cadastro de Verbas Remuneratórias';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;

  CURSOR GET_VERBAS IS



  SELECT DISTINCT(A.COD_CONCEITO), A.NOM_RUBRICA, A.COD_AGRUPA
    FROM TB_RUBRICA_VERBA_AUDESP    A
    WHERE A.DAT_INI_VIG = P_PERPROCESSO
    ORDER BY A.COD_CONCEITO;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoal_CadastroVerbasRemuneratorias_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<cvr:CadastroVerbasRemuneratorias xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"' || CHR(10) ;


  V_TAG_DEFINICOES :=
                  '                   xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'    || CHR(10) ||
                  '                   xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'      || CHR(10) ||
                  '                   xmlns:cvr="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'   || CHR(10) ||
                  '                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'         || CHR(10) ||

                  '                   xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../verbasremuneratorias/AUDESP_VERBAS_REMUNERATORIAS_'||V_ANO||'_A.XSD">' || CHR(10) ;


  V_TAG_DESCRITOR :=
                  '    <cvr:Descritor>'          || CHR(10) ||
                  '        <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '        <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '        <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '        <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '        <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '    </cvr:Descritor>'         || CHR(10) ;

  FOR REC IN  GET_VERBAS LOOP

        V_TAG_VERBAS := 
                  '    <cvr:VerbasRemuneratorias>'                   || CHR(10) ||
                  '        <cvr:Codigo>'                             || REC.COD_CONCEITO ||'</cvr:Codigo>'                           || CHR(10) ||
                  '        <cvr:Nome>'                               || REC.NOM_RUBRICA ||'</cvr:Nome>'                              || CHR(10) ||
                  '        <cvr:EntraNoCalculoDoTetoConstitucional>' || REC.COD_AGRUPA ||'</cvr:EntraNoCalculoDoTetoConstitucional>' || CHR(10) ||
                  '    </cvr:VerbasRemuneratorias>'                  || CHR(10) ;
        V_FILE :=  V_FILE || V_TAG_VERBAS;

  END LOOP;


  V_TAG_FIM :=  CHR(10)      ||'</cvr:CadastroVerbasRemuneratorias>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES ||  V_TAG_DESCRITOR || V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_VERBA_REMUNERATORIAS;

PROCEDURE SP_PAGAMENTO_FOLHA_ORDINARIA_B
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_PERIODO                   CLOB;
  V_TAG_ID_AGENT_PUBLICO          CLOB;
  V_TAG_ID_PENSIONISTA            CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Pagamento de Folha Ordinária';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';  
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     VARCHAR2(100);
  V_PAGO_CORRENTE                 VARCHAR2(100);
  V_PAGO_OUTRAS                   VARCHAR2(100);

  CURSOR GET_HEADER_AGENT IS
  SELECT
         A.PER_PROCESSO
        ,A.COD_ENTIDADE
        ,B.NUM_CPF
        ,A.COD_IDE_CLI
        ,A.NOME
        ,A.COD_CARGO
        ,TO_CHAR(A.PER_PROCESSO,'YYYY')     AS ANO_EXERCIO
        ,TO_CHAR(A.PER_PROCESSO,'MM')       AS MES_EXERCIO
        ,TO_CHAR(B.DAT_NASC,'DD/MM/YYYY')   AS DAT_NASC
        ,REPLACE(A.TOT_CRED,',','.')                         AS TOT_CRED
        ,REPLACE(A.TOT_DEB,',','.')                          AS TOT_DEB
        ,REPLACE(A.VAL_LIQUIDO,',','.')                      AS VAL_LIQUIDO
        , NVL((SELECT T3.DES_DESCRICAO
               FROM TB_CODIGO T3
              WHERE T3.COD_INS = 0
                AND T3.COD_NUM = 2015
                AND T3.COD_PAR = E.COD_PARENTESCO),
             '-')                  AS NOM_PARENTESCO
        ,E.COD_PARENTESCO          AS COD_PARENTESCO
        ,B.COD_SEXO
        ,FNC_DEPARA_NOME(V_AUDESP,'e.COD_PARENTESCO-L.3978',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 
        ,1 AS TIPO_CONTA 
        ,NVL(F.COD_BANCO,0) AS COD_BANCO
        ,NVL(F.NUM_AGENCIA,0)            ||NVL(F.NUM_DV_AGENCIA,0)   AS AGENCIA
        ,NVL(F.NUM_CONTA,0)              ||NVL(F.NUM_DV_CONTA,0)     AS CONTA
    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_DEPENDENTE            E,
         TB_INFORMACAO_BANCARIA   F
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO 
     AND A.COD_ENTIDADE         = '1' 
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI
     AND A.TIP_PROCESSO         = 'N'
     AND A.COD_INS              = E.COD_INS          (+)
     AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
     AND A.COD_INS              = F.COD_INS          (+)
     AND A.COD_IDE_CLI          = F.COD_IDE_CLI      (+)
     AND A.NUM_GRP              <> 3
     ORDER BY B.NOM_PESSOA_FISICA;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoal_PagamentoFolhaOrdinaria_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<pfo:PagamentoFolhaOrdinariaAgentePublico ' || CHR(10) ;


  V_TAG_DEFINICOES :=
                  '                 xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'      || CHR(10) ||
                  '                 xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'      || CHR(10) ||
                  '                 xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'    || CHR(10) ||
                  '                 xmlns:pfo="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'   || CHR(10) ||
                  '                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'         || CHR(10) ||

                  '                 xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../folhaOrdinaria/AUDESP_PAGAMENTO_FOLHA_ORDINARIA_AGENTE_PUBLICO_'||V_ANO||'_A.XSD">'   || CHR(10) ;

  V_TAG_DESCRITOR :=
                  '    <pfo:Descritor>'          || CHR(10) ||
                  '        <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '        <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '        <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '        <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '        <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '        <gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                  '    </pfo:Descritor>'         || CHR(10) ;


  V_TAG_PERIODO  :=
                  '    <pfo:AnoPagamento>'  || V_ANO   ||'</pfo:AnoPagamento>'    || CHR(10) ||
                  '    <pfo:MesPagamento>'  || V_MES   ||'</pfo:MesPagamento>'    || CHR(10) ;


  FOR REC IN  GET_HEADER_AGENT LOOP

      IF REC.TIPO_CONTA = '1' THEN            
         V_PAGO_CORRENTE := REC.VAL_LIQUIDO;
         V_PAGO_OUTRAS   := 0;
      ELSE
         V_PAGO_CORRENTE := 0;
         V_PAGO_OUTRAS   := REC.VAL_LIQUIDO;
      END IF;


      V_TAG_ID_AGENT_PUBLICO :=
                  '    <pfo:IdentificacaoAgentePublico>'         || CHR(10) ||
                  '        <pfo:CPF Tipo="02">'              || CHR(10) ||
                  '            <gen:Numero>'                 || REC.NUM_CPF       ||'</gen:Numero>'                 || CHR(10) ||
                  '        </pfo:CPF>'                                                                              || CHR(10) ||
                  '        <pfo:MunicipioLotacao>'           || V_MUNICIPIO       ||'</pfo:MunicipioLotacao>'       || CHR(10) ||
                  '        <pfo:EntidadeLotacao>'            || V_ENTIDADE  ||'</pfo:EntidadeLotacao>'        || CHR(10) ||
                  '        <pfo:CodigoCargo>'                || REC.COD_CARGO     ||'</pfo:CodigoCargo>'            || CHR(10) ||
                  '        <pfo:formaPagamento>'             || REC.TIPO_CONTA    ||'</pfo:formaPagamento>'         || CHR(10) ||
                  '        <pfo:numeroBanco>'                || REC.COD_BANCO     ||'</pfo:numeroBanco>'            || CHR(10) ||
                  '        <pfo:agencia>'                    || REC.AGENCIA       ||'</pfo:agencia>'                || CHR(10) ||
                  '        <pfo:ContaCorrente>'              || REC.CONTA         ||'</pfo:ContaCorrente>'          || CHR(10) ||
                  '        <pfo:Valores>'                    || CHR(10) ||
                  '            <pfo:valorPagoContaCorrente>' || V_PAGO_CORRENTE   ||'</pfo:valorPagoContaCorrente>' || CHR(10) ||
                  '            <pfo:valorPagoOutrasFormas>'  || V_PAGO_OUTRAS     ||'</pfo:valorPagoOutrasFormas>'  || CHR(10) ||
                  '        </pfo:Valores>'                   || CHR(10) ||
                  '    </pfo:IdentificacaoAgentePublico>'    || CHR(10) ;
      V_FILE :=  V_FILE   || V_TAG_ID_AGENT_PUBLICO;

  END LOOP;

  V_TAG_FIM :=  CHR(10) ||'</pfo:PagamentoFolhaOrdinariaAgentePublico>';

  V_FILE :=  V_TAG_INICIO || V_TAG_DEFINICOES ||  V_TAG_DESCRITOR || V_TAG_PERIODO ||V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_PAGAMENTO_FOLHA_ORDINARIA_B;

PROCEDURE SP_PAGAMENTO_FOLHA_ORDINARIA
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)

IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_PERIODO                   CLOB;
  V_TAG_ID_AGENT_PUBLICO          CLOB;
  V_TAG_ID_PENSIONISTA            CLOB;
  V_TAG_VERBAS                    CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Pagamento de Folha Ordinária';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='0007';  
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     VARCHAR2(100);
  V_PAGO_CORRENTE                 VARCHAR2(100);
  V_PAGO_OUTRAS                   VARCHAR2(100);
  V_TIPO_CONTA                    VARCHAR2(30);
  V_COD_BANCO                     VARCHAR2(30);
  V_AGENCIA                       VARCHAR2(30);
  V_CONTA                         VARCHAR2(30);
  
  CURSOR GET_HEADER_AGENT IS
  SELECT
         A.PER_PROCESSO
        ,A.COD_ENTIDADE
        ,B.NUM_CPF
        ,A.COD_IDE_CLI
        ,A.NOME
        ,A.COD_CARGO
        ,TO_CHAR(A.PER_PROCESSO,'YYYY')     AS ANO_EXERCIO
        ,TO_CHAR(A.PER_PROCESSO,'MM')       AS MES_EXERCIO
        ,TO_CHAR(B.DAT_NASC,'DD/MM/YYYY')   AS DAT_NASC
        ,REPLACE(A.TOT_CRED,',','.')                         AS TOT_CRED
        ,REPLACE(A.TOT_DEB,',','.')                          AS TOT_DEB
        ,REPLACE(A.VAL_LIQUIDO,',','.')                      AS VAL_LIQUIDO
        , NVL((SELECT T3.DES_DESCRICAO
               FROM TB_CODIGO T3
              WHERE T3.COD_INS = 0
                AND T3.COD_NUM = 2015
                AND T3.COD_PAR = E.COD_PARENTESCO),
             '-')                  AS NOM_PARENTESCO
        ,E.COD_PARENTESCO          AS COD_PARENTESCO
        ,B.COD_SEXO
        ,FNC_DEPARA_NOME(V_AUDESP,'e.COD_PARENTESCO-L.3978',E.COD_PARENTESCO) AS QUALIFICACAO_PENSIONISTA 
        ,1 AS TIPO_CONTA 
        ,F.COD_BANCO
        ,F.NUM_AGENCIA               AS AGENCIA
        ,F.NUM_CONTA                   AS CONTA


    FROM TB_HFOLHA_PAGAMENTO      A,
         TB_PESSOA_FISICA         B,
         TB_DEPENDENTE            E,
         TB_INFORMACAO_BANCARIA   F
   WHERE A.COD_ENTIDADE         = A.COD_ENTIDADE
     AND A.PER_PROCESSO         = P_PERPROCESSO 
     AND A.COD_ENTIDADE         = '1' 
     AND A.COD_IDE_CLI          = B.COD_IDE_CLI

     AND A.TIP_PROCESSO         = 'N'
     AND A.COD_INS              = E.COD_INS          (+)
     AND A.COD_IDE_CLI          = E.COD_IDE_CLI_DEP  (+)
     AND A.COD_INS              = F.COD_INS          (+)
     AND A.COD_IDE_CLI          = F.COD_IDE_CLI      (+)
     ORDER BY B.NOM_PESSOA_FISICA;

  CURSOR GET_LINES_AGENT
  (
  P_NUM_CPF              IN VARCHAR2
  )
  IS
  SELECT

          REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'C',VAL_RUBRICA, NULL))),',','.')    AS PROVENTO
         , REPLACE(SUM(TO_NUMBER(DECODE(D1.FLG_NATUREZA, 'D', VAL_RUBRICA, NULL))),',','.')  AS DESCONTO
         ,DECODE(R1.TIP_EVENTO,'N','2','1')                                                  AS NATUREZA
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')                                           AS ESPECIE
         ,R1.COD_VERBA                                                                       AS TIPO
    FROM TB_HFOLHA_PAGAMENTO_DET         D1,
         TB_HFOLHA_PAGAMENTO             F1,
         TB_RUBRICA_VERBA_AUDESP         R1,
         TB_PESSOA_FISICA                PF
   WHERE D1.COD_INS              = 1
     AND D1.PER_PROCESSO         = P_PERPROCESSO
     AND D1.TIP_PROCESSO         = 'N'
     AND D1.SEQ_PAGAMENTO        = 1
     AND D1.COD_IDE_CLI          = PF.COD_IDE_CLI
     AND PF.NUM_CPF              = P_NUM_CPF
     AND D1.COD_INS              = F1.COD_INS
     AND D1.PER_PROCESSO         = F1.PER_PROCESSO
     AND D1.TIP_PROCESSO         = F1.TIP_PROCESSO
     AND D1.SEQ_PAGAMENTO        = F1.SEQ_PAGAMENTO
     AND D1.COD_IDE_CLI          = F1.COD_IDE_CLI
     AND R1.COD_INS              = D1.COD_INS
     AND D1.TIP_PROCESSO         = 'N'
     AND R1.COD_ENTIDADE         = F1.COD_ENTIDADE
     AND R1.COD_RUBRICA          = D1.COD_FCRUBRICA
GROUP BY  DECODE(R1.TIP_EVENTO,'N','2','1')
         ,DECODE(D1.FLG_NATUREZA, 'D' , '1' , '2')
         ,R1.COD_VERBA;

  CURSOR GET_VERBA
  (
  P_COD_ENTIDADE IN TB_RUBRICA_VERBA_AUDESP.COD_ENTIDADE%TYPE,
  P_COD_RUBRICA  IN TB_RUBRICA_VERBA_AUDESP.COD_RUBRICA%TYPE
  )
  IS
  SELECT A.COD_VERBA
    FROM TB_TIPO_VERBA_AUDESP     A,
         TB_RUBRICA_VERBA_AUDESP  B
   WHERE A.COD_INS      = B.COD_INS
     AND A.COD_VERBA    = B.COD_VERBA
     AND B.COD_ENTIDADE = P_COD_ENTIDADE
     AND B.COD_RUBRICA  = P_COD_RUBRICA;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'PagamentoFolhaOrdinaria_Ativos_' || V_ANO || V_MES || V_NOME_EXTENSAO;

  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';




  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'|| CHR(10) ||
                  '<pfo:PagamentoFolhaOrdinariaAgentePublico ' || CHR(10) ;


  V_TAG_DEFINICOES :=   'xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'      || CHR(10) ||
                        'xmlns:aux="http://www.tce.sp.gov.br/audesp/xml/auxiliar"'      || CHR(10) ||
                        'xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"'    || CHR(10) ||
                        'xmlns:pfo="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'   || CHR(10) ||
                        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'         || CHR(10) ||
                        'xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../folhaOrdinaria/AUDESP_PAGAMENTO_FOLHA_ORDINARIA_AGENTE_PUBLICO_'||V_ANO||'_A.XSD">'   || CHR(10) ;

  V_TAG_DESCRITOR   := '<pfo:Descritor>'          || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                           '<gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                        '</pfo:Descritor>'        || CHR(10) ;


  V_TAG_PERIODO   :=  '<pfo:AnoPagamento>'  || V_ANO   ||'</pfo:AnoPagamento>'    || CHR(10) ||
                      '<pfo:MesPagamento>'  || V_MES   ||'</pfo:MesPagamento>'    || CHR(10) ;


  FOR REC IN  GET_HEADER_AGENT LOOP

      IF REC.TIPO_CONTA = '1' THEN            
         V_PAGO_CORRENTE := REC.VAL_LIQUIDO;
         V_PAGO_OUTRAS   := 0;
      ELSE
         V_PAGO_CORRENTE := 0;
         V_PAGO_OUTRAS   := REC.VAL_LIQUIDO;
      END IF;


  V_TIPO_CONTA                    := REC.TIPO_CONTA;
  V_COD_BANCO                     := REC.COD_BANCO;
  V_AGENCIA                       := REC.AGENCIA;
  V_CONTA                         := REC.CONTA;

      V_TAG_ID_AGENT_PUBLICO := '<pfo:IdentificacaoAgentePublico>'         || CHR(10) ||
                                          '<pfo:CPF Tipo="02">'              || CHR(10) ||
                                              '<gen:Numero>'                 || REC.NUM_CPF       ||'</gen:Numero>'                 || CHR(10) ||
                                          '</pfo:CPF>'                                                                              || CHR(10) ||
                                          '<pfo:MunicipioLotacao>'           || V_MUNICIPIO       ||'</pfo:MunicipioLotacao>'       || CHR(10) ||
                                          '<pfo:EntidadeLotacao>'            || V_ENTIDADE  ||'</pfo:EntidadeLotacao>'        || CHR(10) ||
                                          '<pfo:CodigoCargo>'                || REC.COD_CARGO     ||'</pfo:CodigoCargo>'            || CHR(10) ||
                                          '<pfo:formaPagamento>'             || REC.TIPO_CONTA    ||'</pfo:formaPagamento>'         || CHR(10) ||
                                          '<pfo:numeroBanco>'                || REC.COD_BANCO     ||'</pfo:numeroBanco>'            || CHR(10) ||
                                          '<pfo:agencia>'                    || REC.AGENCIA       ||'</pfo:agencia>'                || CHR(10) ||
                                          '<pfo:ContaCorrente>'              || REC.CONTA         ||'</pfo:ContaCorrente>'          || CHR(10) ||
                                          '<pfo:Valores>'                    || CHR(10) ||
                                              '<pfo:valorPagoContaCorrente>' || V_PAGO_CORRENTE   ||'</pfo:valorPagoContaCorrente>' || CHR(10) ||
                                              '<pfo:valorPagoOutrasFormas>'   || V_PAGO_OUTRAS     ||'</pfo:valorPagoOutrasFormas>'  || CHR(10) ||
                                          '</pfo:Valores>'                   || CHR(10) ||
                                  '</pfo:IdentificacaoAgentePublico>'       || CHR(10) ;
      V_FILE :=  V_FILE   || V_TAG_ID_AGENT_PUBLICO;
      
      DELETE   TB_AUDESP_PAGTO_FOLHA_ORDINARIA P      
      WHERE 01||'/'||P.MES||'/'||P.ANO = P_PERPROCESSO;
      
      INSERT INTO TB_AUDESP_PAGTO_FOLHA_ORDINARIA
       VALUES (
          V_ANO                         ,
          V_MES                         ,
          C_TIPO_DOCUMENTO              ,
          TRUNC(SYSDATE)                ,
          REC.NUM_CPF                   ,
          V_MUNICIPIO                   ,
          V_ENTIDADE                    ,  
          REC.COD_CARGO                 ,
          V_TIPO_CONTA                  ,
          V_COD_BANCO                   ,
          V_AGENCIA                     ,
          V_CONTA                       ,
          V_PAGO_CORRENTE               ,
          V_PAGO_OUTRAS                 ,          
          SYSDATE 
        );

  END LOOP;

COMMIT;
  V_TAG_FIM :=  CHR(10) ||'</pfo:PagamentoFolhaOrdinariaAgentePublico>';

  V_FILE :=  V_TAG_INICIO || V_TAG_DEFINICOES ||  V_TAG_DESCRITOR || V_TAG_PERIODO ||V_FILE || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_PAGAMENTO_FOLHA_ORDINARIA;


PROCEDURE SP_EXECUTA_XML
(
 P_TIPO_GERACAO      IN NUMBER,
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE,
 P_TIPPROCESSO       IN TB_HFOLHA_PAGAMENTO.TIP_PROCESSO%TYPE
)
IS
BEGIN

  IF P_TIPO_GERACAO  = 1 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_CRIA_AGENTE_PUBLICO(P_PERPROCESSO,
                                                       P_TIPPROCESSO);

  ELSIF P_TIPO_GERACAO  = 2 THEN



    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_LOTACAO_AGENTE_PUBLICO_NEW(P_PERPROCESSO
                                                              );
  ELSIF P_TIPO_GERACAO  = 3 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_GERA_FOLHA_ORDINARIA(P_PERPROCESSO,
                                                        P_TIPPROCESSO);
  ELSIF P_TIPO_GERACAO  = 4 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_RESUMO_MENSAL(P_PERPROCESSO,
                                                 P_TIPPROCESSO);
  ELSIF P_TIPO_GERACAO  = 5 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_GERA_FOLHA_SUPLEMENTAR(P_PERPROCESSO,
                                                         P_TIPPROCESSO);
  ELSIF P_TIPO_GERACAO  = 6 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_VERBA_REMUNERATORIAS(P_PERPROCESSO,
                                                        P_TIPPROCESSO);
  ELSIF P_TIPO_GERACAO  = 7 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_PAGAMENTO_FOLHA_ORDINARIA(P_PERPROCESSO,
                                                             P_TIPPROCESSO);
 ELSIF P_TIPO_GERACAO  = 8 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_ATOS_QUADRO_PESSOAL(P_PERPROCESSO);

 ELSIF P_TIPO_GERACAO  = 9 THEN

    PAC_GERA_ARQUIVO_XML_ATIVOS.SP_CRIA_CADASTRO(P_PERPROCESSO,
                                                 P_TIPPROCESSO);    

  END IF;

END;

PROCEDURE SP_CLOB_TO_FILE
( P_FILE_NAME       IN VARCHAR2,
  P_DIR             IN VARCHAR2,
  P_CLOB            IN CLOB ) IS

  C_AMOUNT         CONSTANT BINARY_INTEGER := 32767;
  L_BUFFER         VARCHAR2(32767);
  L_CHR10          PLS_INTEGER;
  L_CLOBLEN        PLS_INTEGER;
  L_FHANDLER       UTL_FILE.FILE_TYPE;
  L_POS            PLS_INTEGER    := 1;

BEGIN

  L_CLOBLEN  := DBMS_LOB.GETLENGTH(P_CLOB);
  L_FHANDLER := UTL_FILE.FOPEN(P_DIR, P_FILE_NAME,'W',C_AMOUNT);

  WHILE L_POS < L_CLOBLEN LOOP
    L_BUFFER := DBMS_LOB.SUBSTR(P_CLOB, C_AMOUNT, L_POS);
    EXIT WHEN L_BUFFER IS NULL;
    L_CHR10  := INSTR(L_BUFFER,CHR(10),-1);
    IF L_CHR10 != 0 THEN
      L_BUFFER := SUBSTR(L_BUFFER,1,L_CHR10-1);
    END IF;
    UTL_FILE.PUT_LINE(L_FHANDLER, L_BUFFER,TRUE);
    L_POS := L_POS + LEAST(LENGTH(L_BUFFER)+1,C_AMOUNT);
  END LOOP;

  UTL_FILE.FCLOSE(L_FHANDLER);

EXCEPTION
WHEN OTHERS THEN
  IF UTL_FILE.IS_OPEN(L_FHANDLER) THEN
    UTL_FILE.FCLOSE(L_FHANDLER);
  END IF;
  RAISE;

END SP_CLOB_TO_FILE;


FUNCTION FNC_GET_DES_DESCRICAO(P_COD_INS IN TB_CODIGO.COD_INS%TYPE,
                               P_COD_NUM IN TB_CODIGO.COD_NUM%TYPE,
                               P_COD_PAR IN TB_CODIGO.COD_PAR%TYPE)

 RETURN TB_CODIGO.DES_DESCRICAO%TYPE IS
  V_TEMP TB_CODIGO.DES_DESCRICAO%TYPE;

  CURSOR GET_DATA IS
    SELECT DES_DESCRICAO
      FROM TB_CODIGO
     WHERE COD_INS = P_COD_INS
       AND COD_NUM = P_COD_NUM
       AND COD_PAR = P_COD_PAR;
BEGIN

  OPEN GET_DATA;
  FETCH GET_DATA
    INTO V_TEMP;
  CLOSE GET_DATA;

  RETURN V_TEMP;

END FNC_GET_DES_DESCRICAO;


PROCEDURE SP_REMUN_AGENTE_POLITICO
(
 P_ANO_REF   NUMBER      
 )





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_REMUNERACAO               CLOB;
  V_TAG_REMUNERACAO_MES           CLOB;
  V_TAG_REMUNERACAO_MENSAL        CLOB;
  V_REMUNERACAO_LIQ               CLOB;
  V_TAG_AGENT_LISTA               CLOB;
  V_TAG_APOS_PENSAO               CLOB;
  V_TAG_APOS_PENSAO_2             CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_ANO                           VARCHAR2(4) ;
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Remuneração de Agentes Políticos';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;




  CURSOR GET_HEADER IS
   SELECT 
    TO_CHAR(SYSDATE, 'yyyy') AS ANOEXERCICIO,
    'Remuneracao de Agente Político' AS TIPODOCUMENTO,
    '2' AS ENTIDADE,
    '6191' AS MUNICIPIO,
    TRUNC(SYSDATE) AS DATACRIACAOXML,
    P_ANO_REF   AS ANOREFERENCIA,
    PF.NUM_CPF AS CPF,
    '5' AS CARGO

              FROM TB_RELACAO_FUNCIONAL RF,
                  TB_PESSOA_FISICA PF
         WHERE RF.COD_INS = 1
         AND (RF.DAT_FIM_EXERC IS NULL OR 
           RF.DAT_FIM_EXERC  >= TO_DATE('01/01/'||P_ANO_REF , 'DD/MM/YYYY'))
           AND RF.DAT_INI_EXERC <= TO_DATE('31/12/'||P_ANO_REF , 'DD/MM/YYYY')
           AND RF.COD_PROC_GRP_PAG IN (02, 12)
           AND PF.COD_INS = 1
           AND PF.COD_IDE_CLI = RF.COD_IDE_CLI
           ORDER BY PF.NUM_CPF;


    CURSOR GET_REMUNERACAO 
    (
     P_NUM_CPF              IN VARCHAR2
     )

     IS

 SELECT 
    TO_CHAR(SYSDATE, 'yyyy') AS ANOEXERCICIO,
    'Remuneracao de Agente Político' AS TIPODOCUMENTO,
    '2' AS ENTIDADE,
    '6191' AS MUNICIPIO,
    TRUNC(SYSDATE) AS DATACRIACAOXML,
    P_ANO_REF   AS ANOREFERENCIA,
    PF.NUM_CPF AS CPF,
    '5' AS CARGO,
    MES.MES AS MESREMUNERACAO,

    REPLACE(NVL((
    SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'C', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA*-1)) FROM TB_HFOLHA_PAGAMENTO_DET HFD
    WHERE HFD.COD_INS = 1
    AND TO_NUMBER(TO_CHAR(HFD.PER_PROCESSO, 'MM'))  = MES.MES
    AND TO_NUMBER(TO_CHAR(HFD.PER_PROCESSO, 'YYYY')) = P_ANO_REF 
    AND HFD.COD_ENTIDADE = RF.COD_ENTIDADE
    AND HFD.COD_IDE_CLI = RF.COD_IDE_CLI
    AND HFD.NUM_MATRICULA = RF.NUM_MATRICULA
    AND HFD.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
    AND TRUNC(HFD.COD_FCRUBRICA/100) IN (50,59)
    ),0),',' , '.')AS REMUNERACAOBRUTA,

    REPLACE(NVL((
    SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'D', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA*-1)) FROM TB_HFOLHA_PAGAMENTO_DET HFD
    WHERE HFD.COD_INS = 1
    AND TO_NUMBER(TO_CHAR(HFD.PER_PROCESSO, 'MM'))  = MES.MES
    AND TO_NUMBER(TO_CHAR(HFD.PER_PROCESSO, 'YYYY')) = P_ANO_REF 
    AND HFD.COD_ENTIDADE = RF.COD_ENTIDADE
    AND HFD.COD_IDE_CLI = RF.COD_IDE_CLI
    AND HFD.NUM_MATRICULA = RF.NUM_MATRICULA
    AND HFD.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
    AND TRUNC(HFD.COD_FCRUBRICA/100) IN (517, 518, 519, 520, 818)
    ),0),',' , '.')AS DEDUCOESFALTAS,

    REPLACE(NVL((
    SELECT SUM(DECODE(HFD.FLG_NATUREZA, 'D', HFD.VAL_RUBRICA, HFD.VAL_RUBRICA*-1)) FROM TB_HFOLHA_PAGAMENTO_DET HFD
    WHERE HFD.COD_INS = 1
    AND TO_NUMBER(TO_CHAR(HFD.PER_PROCESSO, 'MM'))  = MES.MES
    AND TO_NUMBER(TO_CHAR(HFD.PER_PROCESSO, 'YYYY')) = P_ANO_REF 
    AND HFD.COD_ENTIDADE = RF.COD_ENTIDADE
    AND HFD.COD_IDE_CLI = RF.COD_IDE_CLI
    AND HFD.NUM_MATRICULA = RF.NUM_MATRICULA
    AND HFD.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
    AND TRUNC(HFD.COD_FCRUBRICA/100) IN (502, 501)
    ),0),',' , '.') AS OUTRASDEDUCOES,

    REPLACE(NVL((
    SELECT SUM(HF.VAL_LIQUIDO) FROM TB_HFOLHA_PAGAMENTO HF
    WHERE HF.COD_INS = 1
    AND TO_NUMBER(TO_CHAR(HF.PER_PROCESSO, 'MM'))  = MES.MES
    AND TO_NUMBER(TO_CHAR(HF.PER_PROCESSO, 'YYYY')) = P_ANO_REF 
    AND HF.COD_ENTIDADE = RF.COD_ENTIDADE
    AND HF.COD_IDE_CLI = RF.COD_IDE_CLI
    AND HF.NUM_MATRICULA = RF.NUM_MATRICULA
    AND HF.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC 
    ),0),',' , '.') AS REMUNERACAOLIQUIDA,



    CASE WHEN 
            NVL((
            SELECT SUM(HF.VAL_LIQUIDO) FROM TB_HFOLHA_PAGAMENTO HF
            WHERE HF.COD_INS = 1
            AND TO_NUMBER(TO_CHAR(HF.PER_PROCESSO, 'MM'))  = MES.MES
            AND TO_NUMBER(TO_CHAR(HF.PER_PROCESSO, 'YYYY')) = P_ANO_REF  
            AND HF.COD_ENTIDADE = RF.COD_ENTIDADE
            AND HF.COD_IDE_CLI = RF.COD_IDE_CLI
            AND HF.NUM_MATRICULA = RF.NUM_MATRICULA
            AND HF.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC 
            ),0) > 0

             THEN NULL

            ELSE 

               CASE WHEN 
                      TO_CHAR(RF.DAT_FIM_EXERC, 'mm') < MES.MES
                      AND  RF.COD_MOT_DESLIG = 4 
                         THEN '2'   

                   WHEN  (TO_CHAR(RF.DAT_INI_EXERC, 'mm') >   MES.MES
                       OR (TO_CHAR(RF.DAT_FIM_EXERC, 'mm') <   MES.MES)  )
                         AND  (RF.COD_MOT_DESLIG != 4 OR RF.COD_MOT_DESLIG IS NULL)
                         THEN '3'

                   WHEN PF.NUM_CPF = '13260743855' AND MES.MES = 4 
                       THEN '3'

                           ELSE 
                 '1' END

              END AS SEMREMUNERACAO

              FROM TB_RELACAO_FUNCIONAL RF,
                   TB_PESSOA_FISICA PF,
                   VW_MESES_ANO MES
         WHERE RF.COD_INS = 1
         AND (RF.DAT_FIM_EXERC IS NULL OR 
           RF.DAT_FIM_EXERC                    >= TO_DATE('01/01/'||P_ANO_REF  , 'DD/MM/YYYY'))
           AND RF.DAT_INI_EXERC                     <= TO_DATE('31/12/'||P_ANO_REF , 'DD/MM/YYYY')
           AND RF.COD_PROC_GRP_PAG IN (02, 12)
           AND PF.COD_INS = 1
           AND PF.COD_IDE_CLI = RF.COD_IDE_CLI
           AND PF.NUM_CPF = P_NUM_CPF
           ORDER BY PF.NUM_CPF, MES.MES
           ;


BEGIN

  V_ANO := TO_CHAR(SYSDATE, 'yyyy');



  V_NOME_ARQUIVO     := 'Remuneracao_Agente_Politico_' || V_ANO || V_NOME_EXTENSAO;  
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<rem:RemuneracaoAgentesPoliticos' || CHR(10);

  V_TAG_DEFINICOES :=
                  '                    xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"' || CHR(10) ||
                  '                    xmlns:rem="http://www.tce.sp.gov.br/audesp/xml/remuneracao"'  || CHR(10) ||
                  '                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' || CHR(10) ||

                  '                    xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/remuneracao ../remuneracao/AUDESP_REMUNERACAO_AP_'||V_ANO||'_A.XSD">' || CHR(10);


  V_TAG_DESCRITOR := 
                  '     <rem:Descritor>'   || CHR(10) ||
                  '            <gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                  '            <gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                  '            <gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                  '            <gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                  '            <gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                  '            <gen:AnoReferencia>'  || P_ANO_REF                      ||'</gen:AnoReferencia>'   || CHR(10) ||
                  '     </rem:Descritor>' || CHR(10) ;

  FOR REC IN  GET_HEADER LOOP

  V_TAG_REMUNERACAO_MES:= NULL;   
  V_TAG_REMUNERACAO_MENSAL:= NULL;

   FOR REC2 IN GET_REMUNERACAO(REC.CPF) LOOP

   V_MES  := REC2.MESREMUNERACAO ;
   V_REMUNERACAO_LIQ := REC2.REMUNERACAOLIQUIDA ;

     CASE WHEN  TO_NUMBER(REPLACE(REC2.REMUNERACAOLIQUIDA, '.', ',')) > 0 

        THEN 

     V_TAG_REMUNERACAO_MENSAL :=
                  '<rem:RemuneracaoMensal>'            || CHR(10) ||
                  '  <rem:MesRemuneracao>' ||   V_MES   ||   '</rem:MesRemuneracao>'   || CHR(10)  ||
                  '    <rem:ValoresRemuneracao>'      ||  CHR(10) ||
                  '      <rem:RemuneracaoBruta>'   || REC2.REMUNERACAOBRUTA           ||'</rem:RemuneracaoBruta>'   || CHR(10) ||
                  '      <rem:DeducoesFalta>'      || REC2.DEDUCOESFALTAS              ||'</rem:DeducoesFalta>'      || CHR(10) ||
                  '      <rem:OutrasDeducoes>'     || REC2.OUTRASDEDUCOES             ||'</rem:OutrasDeducoes>'     || CHR(10) ||
                  '      <rem:RemuneracaoLiquida>' || V_REMUNERACAO_LIQ         ||'</rem:RemuneracaoLiquida>' || CHR(10) ||
                  '    </rem:ValoresRemuneracao>'     || CHR(10) ||
                  '</rem:RemuneracaoMensal>'            ||CHR(10);   



  ELSE 

     V_TAG_REMUNERACAO_MENSAL :=
                  '<rem:RemuneracaoMensal>'              || CHR(10) ||
                  '  <rem:MesRemuneracao>'  ||   V_MES  ||   '</rem:MesRemuneracao>'   || CHR(10)  ||
                  '    <rem:SemRemuneracao>' ||REC2.SEMREMUNERACAO || '</rem:SemRemuneracao>'|| CHR(10)  ||
                  '</rem:RemuneracaoMensal>'             || CHR(10) ;

    END CASE;      

    V_TAG_REMUNERACAO_MES:= V_TAG_REMUNERACAO_MES|| V_TAG_REMUNERACAO_MENSAL;

     END LOOP;


  V_TAG_REMUNERACAO :=
                  '<rem:Remuneracao>'          || CHR(10) ||
                  ' <rem:CPF>'           || REC.CPF       ||'</rem:CPF>'           || CHR(10) ||
                  ' <rem:Cargo>'         || REC.CARGO     || '</rem:Cargo>'        || CHR(10) ||
                      V_TAG_REMUNERACAO_MES ||
                  '</rem:Remuneracao>'         || CHR(10) ;

     V_FILE :=  V_FILE  || V_TAG_REMUNERACAO;

  END LOOP;




  V_TAG_FIM :=  CHR(10) ||'</rem:RemuneracaoAgentesPoliticos>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_FILE|| V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_REMUN_AGENTE_POLITICO;

PROCEDURE SP_ATOS_PESSOAL_CARGOS
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_CARGO_NOVO                CLOB;
  V_TAG_CARGO_LISTA               CLOB;
  V_TAG_CARGO_LISTA_2             CLOB;
  V_TAG_VAGAS_HIST                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_FILE_2                        CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Cargos';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;


  CURSOR GET_CARGO_NOVO IS



SELECT C.COD_CARGO,
       C.NOM_CARGO,
       TO_CHAR(C.DAT_INI_VIG, 'yyyy-mm-dd') AS DAT_INI_VIG,
       '' AS TIPO_CARGO,
       C.COD_REGIME_JURIDICO,
       C.COD_ESCOLARIDADE,
       '' AS EXERCICIO_ATIVIDADE,
       C.COD_TIPO_PROVIMENTO AS FORMA_PROVIMENTO,
       (
       SELECT DP.VALOR_TIPO FROM TB_DOMINIOS_PADRAO DP
       WHERE DP.COD_INS = 1
       AND DP.COD_ENTIDADE = C.COD_ENTIDADE
       AND DP.COD_CARGO = C.COD_CARGO
       AND DP.COD_TIPO = 'JH'
       )AS JORNADA,
       TO_CHAR(CAV.DAT_INI_VIG, 'yyyy-mm-dd') AS INI_VAGA,
       CAV.QTD_VAGAS,
       CAV.COD_TIPO_VAGA,
       PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','10067', CAV.COD_TIPO_VAGA) AS DES_TIPO_VAGA,
       CAV.COD_NORMA_JURIDICA ,
       (
       SELECT NJ.NUM_NOR_JUR FROM TB_NORMA_JURIDICA NJ
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       )AS NUM_NORMA_JURIDICA,

       (
       SELECT TO_CHAR(NJ.DAT_PUB_NOR_JUR, 'YYYY') FROM TB_NORMA_JURIDICA NJ
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       )AS ANO_NORMA_JURIDICA,

       (
       SELECT NJ.COD_TIPO_NOR_JUR FROM TB_NORMA_JURIDICA NJ
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       )AS TIPO_NORMA_JURIDICA,

       (
       SELECT CO.DES_DESCRICAO
       FROM TB_NORMA_JURIDICA NJ,
            TB_CODIGO CO
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       AND CO.COD_INS = 0
       AND CO.COD_NUM= 2008
       AND CO.COD_PAR = NJ.COD_TIPO_NOR_JUR
       )AS DES_TIPO_NORMA_JURIDICA,

       CASE WHEN C.COD_TIPO_PROVIMENTO = '8' 
         THEN 'S'
           ELSE 'N'
             END AS CARGO_POLITICO,

       CASE WHEN C.COD_CARGO = '2' 
         THEN 'S'
           ELSE 'N'
             END AS RESP_ENTIDADE

FROM TB_CARGO C,
     TB_CARGO_VAGA CAV
WHERE C.COD_INS= 1
AND CAV.COD_INS = C.COD_INS
AND CAV.COD_ENTIDADE = C.COD_ENTIDADE
AND CAV.COD_CARGO = C.COD_CARGO
AND CAV.COD_TIPO_VAGA = '1' 
AND CAV.DAT_INI_VIG BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)

   ;



 CURSOR GET_HISTORICO_VAGAS IS


SELECT C.COD_CARGO,
       C.NOM_CARGO,
       TO_CHAR(C.DAT_INI_VIG, 'yyyy-mm-dd') AS DAT_INI_VIG,
       '' AS TIPO_CARGO,
       C.COD_REGIME_JURIDICO,
       C.COD_ESCOLARIDADE,
       '' AS EXERCICIO_ATIVIDADE,
       C.COD_TIPO_PROVIMENTO AS FORMA_PROVIMENTO,
       (
       SELECT DP.VALOR_TIPO FROM TB_DOMINIOS_PADRAO DP
       WHERE DP.COD_INS = 1
       AND DP.COD_ENTIDADE = C.COD_ENTIDADE
       AND DP.COD_CARGO = C.COD_CARGO
       AND DP.COD_TIPO = 'JH'
       )AS JORNADA,
       TO_CHAR(CAV.DAT_INI_VIG, 'yyyy-mm-dd') AS INI_VAGA,
       CAV.QTD_VAGAS,
       CAV.COD_TIPO_VAGA,
       CASE WHEN CAV.COD_TIPO_VAGA = '1' 
                THEN 1
            WHEN CAV.COD_TIPO_VAGA = '2'
                THEN 2
            WHEN CAV.COD_TIPO_VAGA = '3'
                THEN 3
            WHEN CAV.COD_TIPO_VAGA = '4'
                THEN 4
                  END AS TIPO_ALTERACAO,

       PAC_GERA_ARQUIVO_XML_ATIVOS.FNC_GET_DES_DESCRICAO('0','10067', CAV.COD_TIPO_VAGA) AS DES_TIPO_VAGA,
       CAV.COD_NORMA_JURIDICA ,
       (
       SELECT NJ.NUM_NOR_JUR FROM TB_NORMA_JURIDICA NJ
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       )AS NUM_NORMA_JURIDICA,

       (
       SELECT TO_CHAR(NJ.DAT_PUB_NOR_JUR, 'YYYY') FROM TB_NORMA_JURIDICA NJ
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       )AS ANO_NORMA_JURIDICA,

       (
       SELECT NJ.COD_TIPO_NOR_JUR FROM TB_NORMA_JURIDICA NJ
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       )AS TIPO_NORMA_JURIDICA,

       CASE WHEN (
                 SELECT NJ.COD_TIPO_NOR_JUR FROM TB_NORMA_JURIDICA NJ
                 WHERE NJ.COD_INS = 1
                 AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
                 ) = '9'
            THEN '9'
              ELSE '9'
            END AS TIPO_ATO,

       (
       SELECT CO.DES_DESCRICAO
       FROM TB_NORMA_JURIDICA NJ,
            TB_CODIGO CO
       WHERE NJ.COD_INS = 1
       AND NJ.COD_NOR_JUR = CAV.COD_NORMA_JURIDICA
       AND CO.COD_INS = 0
       AND CO.COD_NUM= 2008
       AND CO.COD_PAR = NJ.COD_TIPO_NOR_JUR
       )AS DES_TIPO_NORMA_JURIDICA

FROM TB_CARGO C,
     TB_CARGO_VAGA CAV
WHERE C.COD_INS= 1
AND CAV.COD_INS = C.COD_INS
AND CAV.COD_ENTIDADE = C.COD_ENTIDADE
AND CAV.COD_CARGO = C.COD_CARGO
AND CAV.DAT_INI_VIG BETWEEN P_PERPROCESSO AND LAST_DAY(P_PERPROCESSO)

;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosPessoalCargos_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<qpc:Cargos'                    ;

  V_TAG_DEFINICOES :=
                        '                     xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'|| CHR(10) ||
                        '                     xmlns:qpc="http://www.tce.sp.gov.br/audesp/xml/quadropessoal-cargos"'  || CHR(10) ||
                        '                     xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"' || CHR(10) ||
                        '                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' || CHR(10)||

                        '                     xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/quadropessoal-cargos ../quadropessoal/AUDESP_CARGO_'||V_ANO||'_A.XSD">'
                         || CHR(10);


  V_TAG_DESCRITOR   := '<Descritor>'   || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                        '</Descritor>' || CHR(10) ;


  FOR REC1 IN GET_CARGO_NOVO LOOP

    V_TAG_CARGO_NOVO :=      '<qpc:Cargo>'         || CHR(10) ||
                                   '<qpc:codigoCargo>'           || REC1.COD_CARGO                   ||'</qpc:codigoCargo>'                 || CHR(10) ||
                                   '<qpc:nomeCargo>'             || REC1.NOM_CARGO                   ||'</qpc:nomeCargo>'                || CHR(10) ||
                                   '<qpc:tipoCargo>'             || REC1.TIPO_CARGO                  ||'</qpc:tipoCargo>'         || CHR(10) ||
                                   '<qpc:regimeJuridico>'        || REC1.COD_REGIME_JURIDICO         ||'</qpc:regimeJuridico>'       || CHR(10) ||
                                   '<qpc:escolaridade>'          || REC1.COD_ESCOLARIDADE            ||'</qpc:escolaridade>'        || CHR(10) ||
                                   '<qpc:exercicioAtividade>'    || REC1.EXERCICIO_ATIVIDADE         ||'</qpc:exercicioAtividade>'                || CHR(10) ||
                                   '<qpc:formaProvimento>'       || REC1.FORMA_PROVIMENTO            || '</qpc:formaProvimento>'                || CHR(10) ||
                                   '<qpc:totalHorasTrabalho>'    || REC1.JORNADA                     ||'</qpc:totalHorasTrabalho>'            || CHR(10) ||






                                '</qpc:Cargo>'    || CHR(10) ;

     V_FILE :=  V_FILE  || V_TAG_CARGO_NOVO;

     END LOOP;

     V_TAG_CARGO_LISTA := '<qpc:ListaCargos>'  || CHR(10) || V_FILE || '</qpc:ListaCargos>'|| CHR(10) ;

     FOR REC2 IN GET_HISTORICO_VAGAS LOOP
           V_TAG_VAGAS_HIST :=      '<qpc:HistoricoVaga>'       || CHR(10) ||
                                         '<qpc:codigoCargo>'                || REC2.COD_CARGO                  ||'</qpc:codigoCargo>'              || CHR(10) ||
                                          '<qpc:tipoAlteracao>'             || REC2.TIPO_ALTERACAO             ||'</qpc:tipoAlteracao>'            || CHR(10) ||
                                          '<qpc:quantidadeVagas>'           || REC2.QTD_VAGAS                  ||'</qpc:quantidadeVagas>'          || CHR(10) ||
                                          '<qpc:data>'                     || REC2.INI_VAGA                   ||'</qpc:data>'                     || CHR(10) ||
                                          '<qpc:fundamentoLegal>'   || CHR(10) ||
                                                '<qpc:numeroDoAto>'         || REC2.NUM_NORMA_JURIDICA         ||'</qpc:numeroDoAto>'              || CHR(10) ||
                                                '<qpc:anoDoAto>'            || REC2.ANO_NORMA_JURIDICA         ||'</qpc:anoDoAto>'                 || CHR(10) ||
                                                '<qpc:tipoDeNorma>'         || REC2.TIPO_ATO                   ||'</qpc:tipoDeNorma>'              || CHR(10) ||
                                          '</qpc:fundamentoLegal>'  || CHR(10) ||
                                     '</qpc:HistoricoVaga>'     || CHR(10) ;

           V_FILE_2 :=  V_FILE_2  ||V_TAG_VAGAS_HIST ;

     END LOOP; 


     V_TAG_CARGO_LISTA_2:= '<qpc:ListaHistoricoVagas>'|| CHR(10) || V_FILE_2 ||CHR(10) ||'</qpc:ListaHistoricoVagas>'|| CHR(10);




  V_TAG_FIM :=  '</qpc:Cargos>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_TAG_CARGO_LISTA || V_TAG_CARGO_LISTA_2|| V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_ATOS_PESSOAL_CARGOS;

PROCEDURE SP_ATOS_QUADRO_PESSOAL
(
 P_PERPROCESSO       IN TB_HFOLHA_PAGAMENTO.PER_PROCESSO%TYPE
)





IS
  V_ARQUIVO_SAIDA                 UTL_FILE.FILE_TYPE;
  V_NOME_ARQUIVO                  VARCHAR2(2000);
  V_OUTPUT_LOCATION               VARCHAR2(100);
  V_TAG_INICIO                    CLOB;
  V_TAG_DEFINICOES                CLOB;
  V_TAG_DESCRITOR                 CLOB;
  V_TAG_LISTA                     CLOB;
  V_TAG_CARGO_LISTA               CLOB;
  V_TAG_CARGO_LISTA_2             CLOB;
  V_TAG_VAGAS_HIST                CLOB;
  V_TAG_FIM                       CLOB;
  V_MSG_ERRO                      VARCHAR2(32000);
  V_FILE                          CLOB;
  V_FILE_2                        CLOB;
  V_ANO                           VARCHAR2(4);
  V_MES                           VARCHAR2(2);

  C_TIPO_DOCUMENTO                VARCHAR2(100) := 'Quadro de Pessoal';
  V_MUNICIPIO                     VARCHAR2(100) :='6291';  
  V_ENTIDADE                      VARCHAR2(100) :='2';     
  V_NOME_EXTENSAO                 VARCHAR2(50)  :='.XML';
  V_COD_VERBA                     NUMBER;
  V_CONTADOR                      NUMBER:=0;


  CURSOR GET_QUADRO_PESSOAL IS

SELECT COD_CARGO, NOM_CARGO, QTD_VAGAS,  SUM(QTDE_OCUPADA) AS QTDE_OCUPADA,
       QTD_VAGAS - SUM(QTDE_OCUPADA) AS SALDO
FROM

(
SELECT  AA.COD_CARGO,AA.NOM_CARGO,AA.QTD_VAGAS, AA.QTD_TOT_PREV_LEI, AA.QTDE_OCUPADA AS QTDE_OCUPADA

       FROM
(
SELECT C.COD_ENTIDADE,
       C.COD_CARGO, C.NOM_CARGO,
       CV.QTD_VAGAS,
       C.QTD_TOT_PREV_LEI,
       (
       SELECT COUNT(*)
       FROM TB_EVOLUCAO_FUNCIONAL EF,
            TB_RELACAO_FUNCIONAL RF
       WHERE EF.COD_INS = 1
       AND EF.COD_ENTIDADE = C.COD_ENTIDADE
       AND EF.COD_CARGO = C.COD_CARGO
       AND EF.DAT_INI_EFEITO <= LAST_DAY(P_PERPROCESSO)
       AND (EF.DAT_FIM_EFEITO IS NULL OR EF.DAT_FIM_EFEITO >= LAST_DAY(P_PERPROCESSO))
       AND EF.FLG_STATUS = 'V'
       AND RF.COD_INS = EF.COD_INS
       AND RF.COD_ENTIDADE = EF.COD_ENTIDADE
       AND RF.COD_IDE_CLI = EF.COD_IDE_CLI
       AND RF.COD_IDE_REL_FUNC = EF.COD_IDE_REL_FUNC
       AND RF.NUM_MATRICULA = EF.NUM_MATRICULA
       AND (RF.DAT_FIM_EXERC IS NULL OR RF.DAT_FIM_EXERC >= LAST_DAY(P_PERPROCESSO))
       AND NOT EXISTS
                     (
                     SELECT 1 FROM TB_AFASTAMENTO AFA
                     WHERE AFA.COD_INS = 1
                     AND AFA.COD_IDE_CLI = RF.COD_IDE_CLI
                     AND AFA.COD_ENTIDADE = RF.COD_ENTIDADE
                     AND AFA.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                     AND AFA.NUM_MATRICULA = RF.NUM_MATRICULA
                     AND AFA.COD_MOT_AFAST = '15' 
                     AND AFA.DAT_INI_AFAST <= LAST_DAY(P_PERPROCESSO)
                     AND AFA.DAT_RET_PREV >= LAST_DAY(P_PERPROCESSO)
                     )
      ) AS QTDE_OCUPADA      



FROM TB_CARGO C,
     TB_CARGO_VAGA CV
WHERE C.COD_INS = 1

AND C.COD_CARGO NOT IN (700, 500, 600)
AND C.COD_SIT_CARGO = 1
AND CV.COD_INS = 1
AND CV.COD_ENTIDADE = C.COD_ENTIDADE
AND CV.COD_CARGO = C.COD_CARGO
AND CV.DAT_INI_VIG < = LAST_DAY(P_PERPROCESSO) AND 
    (CV.DAT_FIM_VIG IS NULL OR CV.DAT_FIM_VIG >= LAST_DAY(P_PERPROCESSO))

)AA 




UNION
SELECT AA."COD_CARGO",AA."NOM_CARGO", AA.QTD_VAGAS, AA."QTD_TOT_PREV_LEI",AA."QTDE_OCUPADA"

       FROM
(
SELECT C.COD_CARGO, C.NOM_CARGO,
       CV.QTD_VAGAS,
       C.QTD_TOT_PREV_LEI,
       (
       SELECT COUNT (*)
       FROM TB_EVOLU_CCOMI_GFUNCIONAL EFG,
            TB_RELACAO_FUNCIONAL RF
       WHERE EFG.COD_INS = 1
       AND EFG.COD_ENTIDADE = C.COD_ENTIDADE
       AND EFG.COD_CARGO_COMP = C.COD_CARGO
       AND EFG.DAT_INI_EFEITO <= LAST_DAY(P_PERPROCESSO)
       AND (EFG.DAT_FIM_EFEITO IS NULL OR EFG.DAT_FIM_EFEITO >= LAST_DAY(P_PERPROCESSO))
       AND RF.COD_INS = EFG.COD_INS
       AND RF.COD_ENTIDADE = EFG.COD_ENTIDADE
       AND RF.COD_IDE_CLI = EFG.COD_IDE_CLI
       AND RF.COD_IDE_REL_FUNC = EFG.COD_IDE_REL_FUNC
       AND RF.NUM_MATRICULA = EFG.NUM_MATRICULA
       AND RF.NUM_MATRICULA != 20127 

       AND (RF.DAT_FIM_EXERC IS NULL OR RF.DAT_FIM_EXERC >= LAST_DAY(P_PERPROCESSO))
       AND NOT EXISTS
                     (
                     SELECT 1 FROM TB_AFASTAMENTO AFA
                     WHERE AFA.COD_INS = 1
                     AND AFA.COD_IDE_CLI = RF.COD_IDE_CLI
                     AND AFA.COD_ENTIDADE = RF.COD_ENTIDADE
                     AND AFA.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
                     AND AFA.NUM_MATRICULA = RF.NUM_MATRICULA
                     AND AFA.COD_MOT_AFAST = '15' 
                     AND AFA.DAT_INI_AFAST <= LAST_DAY(P_PERPROCESSO)
                     AND AFA.DAT_RET_PREV >= LAST_DAY(P_PERPROCESSO)
                     )
      ) AS QTDE_OCUPADA

FROM TB_CARGO C,
     TB_CARGO_VAGA CV
WHERE C.COD_INS = 1

AND C.COD_CARGO NOT IN (700, 500, 600)
AND C.COD_SIT_CARGO = 1
AND CV.COD_INS = 1
AND CV.COD_ENTIDADE = C.COD_ENTIDADE
AND CV.COD_CARGO = C.COD_CARGO
AND CV.DAT_INI_VIG < = LAST_DAY(P_PERPROCESSO) AND 
    (CV.DAT_FIM_VIG IS NULL OR CV.DAT_FIM_VIG >= LAST_DAY(P_PERPROCESSO))
)AA
)BB GROUP BY COD_CARGO, NOM_CARGO, QTD_VAGAS, QTD_TOT_PREV_LEI
ORDER BY COD_CARGO
;

BEGIN

  V_ANO := TO_CHAR(P_PERPROCESSO,'YYYY');
  V_MES := TO_CHAR(P_PERPROCESSO,'MM');


  V_NOME_ARQUIVO     := 'AtosQuadroPessoal_' || V_ANO || V_MES || V_NOME_EXTENSAO;
  V_OUTPUT_LOCATION  := 'ARQS_PAR_XML_AUDESP';





  V_TAG_INICIO := '<?xml version="1.0" encoding="ISO-8859-1"?>'              || CHR(10) ||
                  '<qp:QuadroPessoal'                    ;

  V_TAG_DEFINICOES :=
                        '                     xmlns:gen="http://www.tce.sp.gov.br/audesp/xml/generico"'|| CHR(10) ||
                        '                     xmlns:qp="http://www.tce.sp.gov.br/audesp/xml/quadropessoal"'  || CHR(10) ||
                        '                     xmlns:ap="http://www.tce.sp.gov.br/audesp/xml/atospessoal"' || CHR(10) ||
                        '                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' || CHR(10)||

                        '                     xsi:schemaLocation="http://www.tce.sp.gov.br/audesp/xml/quadropessoal ../quadropessoal/AUDESP_QUADROPESSOAL_'||V_ANO||'_A.XSD">'
                         || CHR(10);


  V_TAG_DESCRITOR   := '<qp:Descritor>'   || CHR(10) ||
                           '<gen:AnoExercicio>'   || V_ANO                          ||'</gen:AnoExercicio>'    || CHR(10) ||
                           '<gen:TipoDocumento>'  || C_TIPO_DOCUMENTO               ||'</gen:TipoDocumento>'   || CHR(10) ||
                           '<gen:Entidade>'       || V_ENTIDADE                     ||'</gen:Entidade>'        || CHR(10) ||
                           '<gen:Municipio>'      || V_MUNICIPIO                    ||'</gen:Municipio>'       || CHR(10) ||
                           '<gen:DataCriacaoXML>' || TO_CHAR(SYSDATE,'YYYY-MM-DD')  ||'</gen:DataCriacaoXML>'  || CHR(10) ||
                           '<gen:MesExercicio>'   || V_MES                          ||'</gen:MesExercicio>'    || CHR(10) ||
                        '</qp:Descritor>' || CHR(10) ;


  FOR REC1 IN GET_QUADRO_PESSOAL LOOP

    V_TAG_LISTA :=      '<qp:QuadroPessoal>'         || CHR(10) ||
                                   '<qp:codigoMunicipioCargo>'            || V_MUNICIPIO                  ||'</qp:codigoMunicipioCargo>'                 || CHR(10) ||
                                   '<qp:codigoEntidadeCargo>'             || V_ENTIDADE                   ||'</qp:codigoEntidadeCargo>'                || CHR(10) ||
                                   '<qp:codigoCargo>'                     || REC1.COD_CARGO               ||'</qp:codigoCargo>'         || CHR(10) ||
                                   '<qp:quantidadeTotalVagas>'            || REC1.QTD_VAGAS               ||'</qp:quantidadeTotalVagas>'       || CHR(10) ||
                                   '<qp:quantidadeVagasProvidas>'         || REC1.QTDE_OCUPADA            ||'</qp:quantidadeVagasProvidas>'        || CHR(10) ||
                                   '<qp:quantidadeVagasNaoProvidas>'      || REC1.SALDO                   ||'</qp:quantidadeVagasNaoProvidas>'                || CHR(10) ||                                   
                                '</qp:QuadroPessoal>'    || CHR(10) ;

     V_FILE :=  V_FILE  || V_TAG_LISTA;

     END LOOP;

     V_TAG_CARGO_LISTA := '<qp:ListaQuadroPessoal>'  || CHR(10) || V_FILE || '</qp:ListaQuadroPessoal>'|| CHR(10) ;





  V_TAG_FIM :=  '</qp:QuadroPessoal>';
  V_FILE    :=  V_TAG_INICIO || V_TAG_DEFINICOES || V_TAG_DESCRITOR || V_TAG_CARGO_LISTA || V_TAG_FIM;

  SP_CLOB_TO_FILE(V_NOME_ARQUIVO,V_OUTPUT_LOCATION,V_FILE);

END SP_ATOS_QUADRO_PESSOAL;




END  PAC_GERA_ARQUIVO_XML_ATIVOS;
/
