CREATE OR REPLACE PACKAGE "PAC_FERIAS" IS



FUNCTION FNC_RET_STATUS_PER_AQUIS(I_ID_AQUISITIVO   IN NUMBER,
                                  I_DAT_FIM_VINCULO IN DATE DEFAULT NULL) RETURN CHAR;


PROCEDURE SP_CALC_PER_AQUISITIVO
(
 P_COD_INS               IN  NUMBER,
 P_COD_IDE_CLI           IN  NUMBER,
 P_COD_IDE_REL_FUNC      IN  NUMBER,
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
);

PROCEDURE SP_INSERE_FERIAS_GOZO
(
 P_ID_AQUISITIVO         IN  NUMBER,
 P_FLG_ABONO             IN  VARCHAR2,
 P_FLG_ANTECIPACAO       IN  VARCHAR2,
 P_DAT_INICIO            IN  VARCHAR2,
 P_DAT_FIM               IN  VARCHAR2,
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
);


PROCEDURE SP_DELETE_FERIAS_GOZO
(
 P_ID_AQUISITIVO         IN  NUMBER,
 P_ID_GOZO               IN  NUMBER,
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
);

FUNCTION GET_SALDO_PERMITIDO(P_ID_AQUISITIVO IN NUMBER,
                             P_QTD_DIAS_FALTA IN NUMBER) RETURN NUMBER;

FUNCTION GET_SALDO_ATUAL 
(
 P_ID_AQUISITIVO  IN NUMBER,
 P_QTD_DIAS_FALTA IN NUMBER
) RETURN NUMBER;

FUNCTION GET_MSG_ERRO
(
 P_ID    IN NUMBER
) RETURN VARCHAR2;

PROCEDURE SP_CALC_FERIAS_TODOS
(
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
);

PROCEDURE SP_CALC_FERIAS_TODOS_FUNC
(
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
);



PROCEDURE SP_CALC_DATAS_FERIAS(I_COD_INS                 IN VARCHAR2,
                               I_ID_AQUISITIVO           IN NUMBER,
                               I_DAT_INI_FERIAS          IN DATE,
                               I_QTD_DIAS_FERIAS         IN NUMBER,
                               O_DAT_FIM_FERIAS          OUT DATE,
                               O_DAT_RET_FERIAS          OUT DATE,
                               O_COD_ERRO                OUT NUMBER,
                               O_MSG_ERRO                OUT VARCHAR2);

PROCEDURE SP_RET_NOM_CARGO_2(I_COD_ENTIDADE IN NUMBER, 
                           I_COD_PCCS     IN NUMBER, 
                           I_COD_CARGO    IN NUMBER,
                           I_NUM_ORGAO    IN NUMBER,
                           O_NOW         OUT VARCHAR2,
                           O_NOM_CARGO   OUT VARCHAR2,
                           O_NOM_LOTACAO OUT VARCHAR2); 
                           

PROCEDURE SP_RET_NOM_CARGO(I_COD_INS          IN NUMBER, 
                             I_COD_IDE_CLI      IN NUMBER,
                             I_COD_ENTIDADE     IN NUMBER,                             
                             I_NUM_MATRICULA    IN VARCHAR2, 
                             I_COD_IDE_REL_FUNC IN NUMBER,
                             I_NUM_ORGAO        IN NUMBER,
                             O_NOW             OUT VARCHAR2,
                             O_NOM_CARGO       OUT VARCHAR2,
                             O_NOM_LOTACAO     OUT VARCHAR2,
                             O_COD_ERRO        OUT NUMBER, 
                             O_MSG_ERRO        OUT VARCHAR2,
                             I_COD_PCCS         IN NUMBER DEFAULT NULL, 
                             I_COD_CARGO        IN NUMBER DEFAULT NULL);   
                             

FUNCTION FNC_RET_BLOQ_CMP_13(I_COD_INS          TB_FERIAS_AQUISITIVO.COD_INS%TYPE, 
                             I_COD_ENTIDADE     TB_FERIAS_AQUISITIVO.COD_ENTIDADE%TYPE, 
                             I_COD_IDE_CLI      TB_FERIAS_AQUISITIVO.COD_IDE_CLI%TYPE,
                             I_NUM_MATRICULA    TB_FERIAS_AQUISITIVO.NUM_MATRICULA%TYPE,
                             I_COD_IDE_REL_FUNC TB_FERIAS_AQUISITIVO.COD_IDE_REL_FUNC%TYPE,
                             I_DAT_INI_GOZO     DATE
                             ) RETURN CHAR;                                                                                        


------ Variaveis -----
   type  ESTRUC_RETORNO is record  
    (
      cod_retorno  varchar2(5),
      desc_retorno varchar2(80) 
     );
type t_col_retorno Is Table Of ESTRUC_RETORNO;
function sp_controle_resp_frequencia_pipe(
  -- p_cod_ins           in number ,
   p_cod_entidade      in number , 
   p_num_matricula     in  number,
   p_cod_ide_rel_func  in number ,
   p_cod_ide_cli       in  number,
   p_login             in varchar
    
) Return t_col_retorno Pipelined;


-- Assinatura pendencias de assinatura 
type T_dados_documento_pend_ass is record 
  (   
   v_data_ponto            date, 
   v_cod_ide_cli           varchar(20),
   v_Nome_servidor         varchar(200),
   v_cpf                   varchar(12) ,   
   v_num_matricula         varchar(20),
   v_data_assinatura       date  ,
   v_flg_ass_responsavel   char(5),
   v_ID_DOCUMENTO_GED      varchar(10));

  type t_col_dados_documento_pend_ass  is table of T_dados_documento_pend_ass;

  function sp_documento_pend_ass( p_cod_ide_cli   in tb_relacao_funcional.cod_ide_cli%type)
  Return t_col_dados_documento_pend_ass Pipelined;


-- Assinatura pendencias de assinatura 
type T_dados_documento_pend_ass_2 is record 
  (   
   v_data_ponto            date, 
   v_cod_ide_cli           varchar(20),
   v_Nome_servidor         varchar(200),
   v_cpf                   varchar(12) ,   
   v_num_matricula         varchar(20),
   v_data_assinatura       date  ,
   v_flg_ass_responsavel   char(5),
   v_ID_DOCUMENTO_GED      varchar(10));

  type t_col_dados_documento_pend_ass_2  is table of T_dados_documento_pend_ass_2;

  function sp_documento_pend_ass_2( p_cod_ide_cli   in tb_relacao_funcional.cod_ide_cli%type)
  Return t_col_dados_documento_pend_ass_2 Pipelined;


END PAC_FERIAS;
/
CREATE OR REPLACE PACKAGE BODY "PAC_FERIAS" IS

  v_dados_documento_pend_ass           T_dados_documento_pend_ass;
  v_dados_documento_pend_ass_2         T_dados_documento_pend_ass_2;

FUNCTION FNC_RET_STATUS_PER_AQUIS(I_ID_AQUISITIVO   IN NUMBER,
                                  I_DAT_FIM_VINCULO IN DATE DEFAULT NULL) RETURN CHAR
AS
  V_ID_GOZO_FER    NUMBER;
  V_DAT_LIMITE_PER DATE;
  V_DAT_INICIO_PER DATE;
  V_DAT_FIM_PER    DATE;
  V_DAT_FIM_FER    DATE;
  V_DAT_INI_FER    DATE;
  V_SALDO          NUMBER;
  V_NUM_DIAS       NUMBER;
  V_NUM_FERIAS     NUMBER;
  V_NUM_FERIAS_EXCLUIDAS NUMBER;
  V_DAT_MIN_GOZO DATE;

   V_COD_INS             TB_FERIAS_AQUISITIVO.COD_INS%TYPE; 
   V_COD_IDE_CLI         TB_FERIAS_AQUISITIVO.COD_IDE_CLI%TYPE;
   V_COD_ENTIDADE        TB_FERIAS_AQUISITIVO.COD_ENTIDADE%TYPE;
   V_NUM_MATRICULA       TB_FERIAS_AQUISITIVO.NUM_MATRICULA%TYPE; 
   V_COD_IDE_REL_FUNC    TB_FERIAS_AQUISITIVO.COD_IDE_REL_FUNC%TYPE;  

 BEGIN

  SELECT COD_INS, 
         COD_IDE_CLI, 
         COD_ENTIDADE,
         NUM_MATRICULA, 
         COD_IDE_REL_FUNC,
         DAT_LIMITE_PER,
         DAT_INICIO_PER,
         DAT_FIM_PER,
         MAX(ID_GOZO_FERIAS),
         MAX(DAT_FIM),
         MIN(DAT_INICIO),
         SUM(NUM_DIAS)
    INTO V_COD_INS, 
         V_COD_IDE_CLI, 
         V_COD_ENTIDADE,
         V_NUM_MATRICULA, 
         V_COD_IDE_REL_FUNC,                
         V_DAT_LIMITE_PER, 
         V_DAT_INICIO_PER, 
         V_DAT_FIM_PER, 
         V_ID_GOZO_FER, 
         V_DAT_FIM_FER,
         V_DAT_INI_FER, 
         V_NUM_DIAS
    FROM (
    SELECT A.COD_INS        AS COD_INS,
           A.COD_IDE_CLI    AS COD_IDE_CLI, 
           A.COD_ENTIDADE   AS COD_ENTIDADE,
           A.NUM_MATRICULA  AS NUM_MATRICULA,
           A.COD_IDE_REL_FUNC AS COD_IDE_REL_FUNC,           
           A.DAT_LIMITE      AS DAT_LIMITE_PER,
           A.DAT_INICIO      AS DAT_INICIO_PER,
           A.DAT_FIM         AS DAT_FIM_PER,
           A.NUM_SALDO       AS SALDO,
           G.ID_GOZO         AS ID_GOZO_FERIAS,
           G.DAT_INICIO      AS DAT_INICIO,
           G.DAT_FIM         AS DAT_FIM,
           G.FLG_STATUS      AS FLG_STATUS,
           CASE WHEN G.DAT_INICIO >  SYSDATE  THEN 0 
                ELSE G.NUM_DIAS END AS NUM_DIAS
      FROM TB_FERIAS_AQUISITIVO A LEFT OUTER JOIN TB_FERIAS_GOZO G ON G.ID_AQUISITIVO = A.ID_AQUISITIVO 
                                                                               AND G.FLG_STATUS NOT IN ('C','T')
      WHERE A.ID_AQUISITIVO = I_ID_AQUISITIVO        
    ) A
    GROUP BY COD_INS, 
         COD_IDE_CLI, 
         COD_ENTIDADE,
         NUM_MATRICULA, 
         COD_IDE_REL_FUNC,
         DAT_LIMITE_PER,
         DAT_INICIO_PER, 
         DAT_FIM_PER;


  IF I_DAT_FIM_VINCULO IS NOT NULL AND I_DAT_FIM_VINCULO BETWEEN V_DAT_INICIO_PER AND V_DAT_FIM_PER THEN
    RETURN 'X';
  END IF;   



  IF V_ID_GOZO_FER IS NULL THEN

    IF SYSDATE BETWEEN V_DAT_INICIO_PER AND V_DAT_FIM_PER THEN
      RETURN 'E'; 
    ELSE
      IF SYSDATE > V_DAT_LIMITE_PER THEN

        SELECT MIN(FG.DAT_INICIO) AS DAT_INI
          INTO V_DAT_MIN_GOZO
          FROM TB_FERIAS_AQUISITIVO FA JOIN TB_FERIAS_GOZO FG ON FA.ID_AQUISITIVO = FG.ID_AQUISITIVO
         WHERE FA.COD_INS = V_COD_INS
          AND  FA.COD_IDE_CLI = V_COD_IDE_CLI
          AND  FA.COD_ENTIDADE = V_COD_ENTIDADE
          AND  FA.NUM_MATRICULA =  V_NUM_MATRICULA
          AND  FA.COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
          AND FA.ID_AQUISITIVO <> I_ID_AQUISITIVO
          AND FA.DAT_INICIO > V_DAT_INICIO_PER
          AND NVL(FG.FLG_STATUS,'Y') NOT IN ('C','T');

        IF V_DAT_MIN_GOZO IS NOT NULL AND V_DAT_MIN_GOZO < SYSDATE THEN 
          RETURN 'U';
        ELSE                   
          RETURN 'V'; 
        END IF;                
      ELSE
        RETURN 'A'; 
      END IF;
    END IF;

  ELSE        
    IF SYSDATE < V_DAT_INI_FER THEN
      RETURN 'L'; 
    ELSE

      V_SALDO := GET_SALDO_PERMITIDO(I_ID_AQUISITIVO, NULL);

      IF V_NUM_DIAS < V_SALDO THEN
        RETURN 'P'; 
      ELSE
        RETURN 'U'; 
      END IF;
    END IF;
  END IF;
END FNC_RET_STATUS_PER_AQUIS;


PROCEDURE SP_CALC_PER_AQUISITIVO
(
 P_COD_INS               IN  NUMBER,
 P_COD_IDE_CLI           IN  NUMBER,
 P_COD_IDE_REL_FUNC      IN  NUMBER,
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
)
IS





  V_USER_BD                           VARCHAR2(20);
  V_ID_AQUISITIVO                     NUMBER;
  V_NOM_USU_ULT_ATU                   VARCHAR2(40);


  V_DAT_ANO        NUMBER;
  V_DAT_ANO_ATUAL  NUMBER;
  V_DAT_FIM        DATE;
  V_DAT_LIMITE     DATE;
  V_DAT_INICIO     DATE;
  V_SALDO          NUMBER;
  V_COD_STATUS     VARCHAR2(1);
  V_COD_STATUS_FER CHAR;
  V_QTD_DIAS_LIC NUMBER;
  V_ULT_DAT_LIC DATE;
  V_PRIMEIRA_ITERACAO BOOLEAN := TRUE;
  V_QTD_DIAS_FALTA NUMBER;
  V_ULT_DAT_FALTA DATE;
  V_QTD_FERIAS_GOZO NUMBER;
  V_SALDO_GOZO NUMBER;
  V_DATE_NVL DATE := TO_DATE('01/01/1900','dd/mm/yyyy');
  V_DATA_INI_REGR_AFAST DATE := TO_DATE('04/03/2020','dd/mm/yyyy');
  V_DAT_INI_ALT_AQUIS DATE;
  V_DAT_FIM_ALT_AQUIS DATE;
  V_ORDEM NUMBER;

  CURSOR CUR_REGRA_AFAST ( P_DAT_INICIO DATE, P_DAT_FIM DATE,P_ID_AQUISITIVO NUMBER, P_ID_GRUPO NUMBER) IS
  SELECT NVL(SUM(LEAST(AF.DAT_RET_PREV,V_DAT_FIM) - GREATEST(AF.DAT_INI_AFAST,V_DAT_INICIO)),0),
         MAX(AF.DAT_RET_PREV)
    FROM TB_AFASTAMENTO AF
   WHERE AF.COD_INS = 1
     AND AF.COD_IDE_CLI = P_COD_IDE_CLI
     AND AF.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
     AND AF.COD_MOT_AFAST IN (SELECT COD_MOT_AFAST FROM TB_REL_MOT_AFAST_GRUPO WHERE ID_GRUPO =P_ID_GRUPO)
     AND (AF.DAT_RET_PREV BETWEEN V_DAT_INICIO AND V_DAT_FIM OR
          AF.DAT_INI_AFAST BETWEEN V_DAT_INICIO AND V_DAT_FIM OR
          (AF.DAT_INI_AFAST < V_DAT_INICIO AND AF.DAT_RET_PREV > V_DAT_FIM));

  CURSOR CHECK_EXIST(P_DAT_INICIO VARCHAR2, P_DAT_FIM VARCHAR2) IS
  SELECT X.ID_AQUISITIVO
  FROM TB_FERIAS_AQUISITIVO X
  WHERE X.COD_INS           = P_COD_INS
    AND X.COD_IDE_CLI       = P_COD_IDE_CLI
    AND X.COD_IDE_REL_FUNC  = P_COD_IDE_REL_FUNC
    AND X.DAT_INICIO = P_DAT_INICIO 
    AND X.DAT_FIM = P_DAT_FIM 
    AND NVL(X.COD_STATUS,'X') <> 'C';    

  CURSOR GET_DATA IS
  SELECT B.*
    FROM TB_PESSOA_FISICA       A ,
         TB_RELACAO_FUNCIONAL   B
  WHERE A.COD_INS             = B.COD_INS
    AND A.COD_IDE_CLI         = B.COD_IDE_CLI
    AND B.COD_IDE_REL_FUNC    = P_COD_IDE_REL_FUNC
    AND A.COD_INS             = P_COD_INS
    AND A.COD_IDE_CLI         = P_COD_IDE_CLI;  

BEGIN
  V_USER_BD            := SUBSTR(REPLACE(REPLACE(SYS_CONTEXT('USERENV', 'SESSION_USER'),'IPESP','NOVAPREV'), 'SPPREV','NOVAPREV'),1,40);
  V_NOM_USU_ULT_ATU    := 'PAC_FERIAS.SP_CALC_PER_AQUISITIVO';

  FOR REC IN GET_DATA LOOP

     V_DAT_ANO       := TO_CHAR(REC.DAT_INI_EXERC,'RRRR');
     V_DAT_ANO_ATUAL := TO_CHAR(SYSDATE,'RRRR');
     V_DAT_FIM  := REC.DAT_INI_EXERC-1 ; 

     FOR I IN V_DAT_ANO..V_DAT_ANO_ATUAL LOOP

        V_DAT_INICIO  := V_DAT_FIM +1;
        V_DAT_FIM     := ADD_MONTHS( V_DAT_INICIO, 12)-1;   
        V_ID_AQUISITIVO := NULL;



        IF V_PRIMEIRA_ITERACAO THEN 
         DELETE  TB_FERIAS_AQUISITIVO FA
           WHERE FA.COD_INS = 1
             AND FA.COD_IDE_CLI = P_COD_IDE_CLI
             AND FA.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
             AND FA.DAT_INICIO < V_DAT_INICIO
             AND FA.COD_STATUS <> 'C'
             AND NOT EXISTS(SELECT '1' 
                              FROM TB_FERIAS_GOZO FG
                             WHERE FG.ID_AQUISITIVO = FA.ID_AQUISITIVO
                               AND FG.FLG_STATUS NOT IN ('C','T'));                                                                         

          V_PRIMEIRA_ITERACAO := FALSE;
        END IF;    



        OPEN CHECK_EXIST(V_DAT_INICIO,V_DAT_FIM);
        FETCH CHECK_EXIST INTO V_ID_AQUISITIVO;
        CLOSE CHECK_EXIST;      


        BEGIN 
          SELECT A.DAT_INI_AQUIS, A.DAT_FIM_AQUIS
            INTO V_DAT_INI_ALT_AQUIS, V_DAT_FIM_ALT_AQUIS
            FROM TB_FERIAS_ALT_INI_AQUISITIVO A
           WHERE A.COD_INS = '1'
             AND A.COD_IDE_CLI = P_COD_IDE_CLI
             AND A.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
             AND A.ANO = EXTRACT (YEAR FROM V_DAT_INICIO)
             AND A.ORDEM = V_ORDEM;

          V_ORDEM := V_ORDEM+1;     
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN 
            V_DAT_INI_ALT_AQUIS := NULL;
            V_ORDEM := 1;
        END;             

        IF  V_DAT_INI_ALT_AQUIS IS NOT NULL THEN
          V_DAT_INICIO:= V_DAT_INI_ALT_AQUIS;
          IF V_DAT_FIM_ALT_AQUIS IS NULL THEN 
            V_DAT_FIM     := ADD_MONTHS( V_DAT_INICIO, 12)-1;   
          ELSE 
            V_DAT_FIM     := V_DAT_FIM_ALT_AQUIS;
          END IF;

          V_ID_AQUISITIVO := NULL;

          OPEN CHECK_EXIST(V_DAT_INICIO,V_DAT_FIM);
          FETCH CHECK_EXIST INTO V_ID_AQUISITIVO;
          CLOSE CHECK_EXIST;
        END IF;


        IF V_DAT_FIM > V_DATA_INI_REGR_AFAST THEN 


          OPEN CUR_REGRA_AFAST (V_DAT_INICIO,V_DAT_FIM,V_ID_AQUISITIVO,1);
          FETCH CUR_REGRA_AFAST INTO V_QTD_DIAS_LIC, V_ULT_DAT_LIC;
          CLOSE CUR_REGRA_AFAST;     



          OPEN CUR_REGRA_AFAST (V_DAT_INICIO,V_DAT_FIM,V_ID_AQUISITIVO,2);
          FETCH CUR_REGRA_AFAST INTO V_QTD_DIAS_FALTA, V_ULT_DAT_FALTA;
          CLOSE CUR_REGRA_AFAST;    
        ELSE
          V_QTD_DIAS_LIC := 0;          
          V_QTD_DIAS_FALTA := 0;
          V_ULT_DAT_LIC := NULL;
          V_ULT_DAT_FALTA := NULL;          
        END IF;            

        IF V_QTD_DIAS_LIC >= 180 OR V_QTD_DIAS_FALTA >= 33 THEN            
          V_DAT_FIM     := GREATEST(NVL(V_ULT_DAT_LIC, V_DATE_NVL),NVL(V_ULT_DAT_FALTA,V_DATE_NVL)); 
          V_DAT_LIMITE  := NULL;
          V_SALDO       := 0;   
          V_COD_STATUS  := 'D'; 

          V_ID_AQUISITIVO := NULL;

          OPEN CHECK_EXIST(V_DAT_INICIO,V_DAT_FIM);
          FETCH CHECK_EXIST INTO V_ID_AQUISITIVO;
          CLOSE CHECK_EXIST; 
        ELSE
          V_DAT_LIMITE  := ADD_MONTHS( V_DAT_INICIO, 23);

          V_SALDO := GET_SALDO_ATUAL(V_ID_AQUISITIVO,V_QTD_DIAS_FALTA);

        END IF;


        IF TRUNC(V_DAT_INICIO) > TRUNC(SYSDATE) THEN
          EXIT;
        END IF;              



        IF REC.DAT_FIM_EXERC IS NOT NULL AND V_DAT_INICIO > REC.DAT_FIM_EXERC THEN
          DELETE TB_FERIAS_AQUISITIVO FA
           WHERE COD_INS =  P_COD_INS
             AND COD_IDE_CLI =  P_COD_IDE_CLI 
             AND COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
             AND DAT_INICIO > REC.DAT_FIM_EXERC 
             AND NOT EXISTS (SELECT '1'
                               FROM TB_FERIAS_GOZO FG
                              WHERE FG.ID_AQUISITIVO = FA.ID_AQUISITIVO);

          EXIT;                                                            
        END IF;

        IF V_ID_AQUISITIVO IS NULL THEN  

           V_ID_AQUISITIVO := SEQ_TB_FERIAS_A.NEXTVAL;

           INSERT INTO TB_FERIAS_AQUISITIVO
                                            (
                                            ID_AQUISITIVO,
                                            COD_INS,
                                            COD_IDE_CLI,
                                            COD_ENTIDADE,
                                            NUM_MATRICULA,
                                            COD_IDE_REL_FUNC,
                                            DAT_INICIO,
                                            DAT_FIM,
                                            DAT_LIMITE,
                                            DAT_ING,
                                            DAT_ULT_ATU,
                                            NOM_USU_ULT_ATU,
                                            NOM_PRO_ULT_ATU,
                                            NUM_SALDO,
                                            COD_STATUS
                                            )
                                            VALUES
                                            (
                                            V_ID_AQUISITIVO,
                                            REC.COD_INS,
                                            REC.COD_IDE_CLI,
                                            REC.COD_ENTIDADE,
                                            REC.NUM_MATRICULA,
                                            REC.COD_IDE_REL_FUNC,
                                            V_DAT_INICIO,
                                            V_DAT_FIM,   
                                            V_DAT_LIMITE,
                                            SYSDATE,
                                            SYSDATE,
                                            V_USER_BD,
                                            V_NOM_USU_ULT_ATU,
                                            V_SALDO,
                                            V_COD_STATUS
                                            );                                 

          END IF;

          DELETE  TB_FERIAS_AQUISITIVO X
           WHERE X.COD_INS           = P_COD_INS
             AND X.COD_IDE_CLI       = P_COD_IDE_CLI
             AND X.COD_IDE_REL_FUNC  = P_COD_IDE_REL_FUNC
             AND X.ID_AQUISITIVO     <> V_ID_AQUISITIVO
             AND (X.DAT_INICIO BETWEEN V_DAT_INICIO AND V_DAT_FIM OR
                  X.DAT_FIM BETWEEN V_DAT_INICIO AND V_DAT_FIM OR
                  (X.DAT_INICIO < V_DAT_INICIO AND X.DAT_FIM >V_DAT_FIM))        
             AND X.COD_STATUS <> 'C'
             AND NOT EXISTS (SELECT '1'
                               FROM TB_FERIAS_ALT_INI_AQUISITIVO A
                              WHERE A.COD_INS = '1'
                                AND A.COD_IDE_CLI = P_COD_IDE_CLI
                                AND A.COD_IDE_REL_FUNC = P_COD_IDE_REL_FUNC
                                AND A.DAT_INI_AQUIS = X.DAT_INICIO
                                AND NVL(A.DAT_FIM_AQUIS,X.DAT_FIM) = X.DAT_FIM
                              )
             AND NOT EXISTS(SELECT '1' 
                             FROM TB_FERIAS_GOZO FG 
                            WHERE FG.ID_AQUISITIVO = X.ID_AQUISITIVO
                              AND FG.FLG_STATUS NOT IN ('C','T')); 


          IF NVL(V_COD_STATUS,'!') <> 'D' THEN 
            V_COD_STATUS := FNC_RET_STATUS_PER_AQUIS(V_ID_AQUISITIVO, REC.DAT_FIM_EXERC);

            UPDATE TB_FERIAS_AQUISITIVO
               SET COD_STATUS = V_COD_STATUS, NUM_SALDO = V_SALDO
             WHERE ID_AQUISITIVO = V_ID_AQUISITIVO;             
          END IF;


          FOR A IN (SELECT ROWID AS LINHA, DAT_INICIO AS DAT_INI_GOZO
                      FROM TB_FERIAS_GOZO  FG
                     WHERE ID_AQUISITIVO = V_ID_AQUISITIVO
                       AND FG.FLG_STATUS NOT IN ('C','T') 
                     ORDER BY DAT_INICIO)

          LOOP
            V_COD_STATUS_FER := V_COD_STATUS;

            IF V_COD_STATUS = 'P' THEN 
              IF TRUNC(A.DAT_INI_GOZO) < TRUNC(SYSDATE) THEN
                IF V_SALDO = 0 THEN 
                   V_COD_STATUS_FER := 'U';                  
                ELSE
                   IF SYSDATE > V_DAT_LIMITE THEN 
                     V_COD_STATUS_FER := 'V';
                   ELSE
                     V_COD_STATUS_FER := 'A';
                   END IF;
                END IF;
              ELSE
                V_COD_STATUS_FER := 'L';
              END IF;
            END IF;


            UPDATE TB_FERIAS_GOZO FG
               SET FLG_STATUS = V_COD_STATUS_FER
             WHERE FG.ROWID = A.LINHA;          
          END LOOP;                                                              

          V_COD_STATUS := NULL;                     
     END LOOP;
   END LOOP;              
   P_COD_ERRO := 0;
   P_MSG_ERRO := NULL;

EXCEPTION
  WHEN OTHERS THEN
   P_COD_ERRO := SUBSTR(SQLCODE, 1, 32000);
   P_MSG_ERRO := SUBSTR(SQLERRM, 1, 32000);
END SP_CALC_PER_AQUISITIVO;


PROCEDURE SP_INSERE_FERIAS_GOZO
(
 P_ID_AQUISITIVO         IN  NUMBER,
 P_FLG_ABONO             IN  VARCHAR2,
 P_FLG_ANTECIPACAO       IN  VARCHAR2,
 P_DAT_INICIO            IN  VARCHAR2,
 P_DAT_FIM               IN  VARCHAR2,
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
)
IS





  V_USER_BD                           VARCHAR2(20);
  V_ID_GOZO                           NUMBER;
  V_NOM_USU_ULT_ATU                   VARCHAR2(40);
  V_STATUS_FERIAS                     CHAR;


  V_SALDO_ATUAL    NUMBER;
  V_NUMERO_DIAS    NUMBER;

  V_DAT_FIM_AQUI   NUMBER;
  V_DAT_FIM_ULT    NUMBER;
  V_DAT_FIM_FERIAS NUMBER;  
  V_CONCOMITANTE   NUMBER;

  CURSOR CHEK_DAT_FIM_ULT IS
  SELECT 1
    FROM TB_FERIAS_GOZO
   WHERE ID_AQUISITIVO   = P_ID_AQUISITIVO
     AND FLG_STATUS      NOT IN ('C','T')
  HAVING MAX(DAT_FIM)    >= P_DAT_INICIO;

  CURSOR CHEK_DAT_FIM_FERIAS IS
  SELECT 1
    FROM TB_FERIAS_AQUISITIVO
   WHERE ID_AQUISITIVO   = P_ID_AQUISITIVO
     AND DAT_FIM         > P_DAT_INICIO;

 CURSOR CHEK_CONCOMITANTE IS
  SELECT 1
    FROM TB_FERIAS_GOZO FG JOIN TB_FERIAS_AQUISITIVO FA ON FA.ID_AQUISITIVO = FG.ID_AQUISITIVO
   WHERE (FA.COD_INS,FA.COD_IDE_CLI, FA.COD_ENTIDADE, FA.NUM_MATRICULA, FA.COD_IDE_REL_FUNC) IN
         (SELECT FA2.COD_INS,
                 FA2.COD_IDE_CLI,
                 FA2.COD_ENTIDADE,
                 FA2.NUM_MATRICULA,
                 FA2.COD_IDE_REL_FUNC
            FROM TB_FERIAS_AQUISITIVO FA2
           WHERE FA2.ID_AQUISITIVO = P_ID_AQUISITIVO)
     AND FLG_STATUS NOT IN ('C','T')     
     AND (P_DAT_INICIO BETWEEN FG.DAT_INICIO AND FG.DAT_FIM OR
          P_DAT_FIM BETWEEN FG.DAT_INICIO AND FG.DAT_FIM OR
          (P_DAT_INICIO < FG.DAT_INICIO  AND P_DAT_FIM > FG.DAT_FIM));



BEGIN
  V_USER_BD            := SUBSTR(REPLACE(REPLACE(SYS_CONTEXT('USERENV', 'SESSION_USER'),'IPESP','NOVAPREV'), 'SPPREV','NOVAPREV'),1,40);
  V_NOM_USU_ULT_ATU    := 'PAC_FERIAS.SP_INSERE_FERIAS_GOZO';
  V_NUMERO_DIAS        := TO_DATE(P_DAT_FIM,'DD/MM/RRRR') - TO_DATE(P_DAT_INICIO,'DD/MM/RRRR') + 1;  

  V_SALDO_ATUAL := GET_SALDO_ATUAL(P_ID_AQUISITIVO,NULL);


  OPEN CHEK_DAT_FIM_ULT;
  FETCH CHEK_DAT_FIM_ULT INTO V_DAT_FIM_ULT;
  CLOSE CHEK_DAT_FIM_ULT;

  IF V_DAT_FIM_ULT IS NOT NULL THEN
       P_COD_ERRO := 102;
       P_MSG_ERRO := P_MSG_ERRO || ','||  PAC_FERIAS.GET_MSG_ERRO('102');
  END IF;

  OPEN CHEK_DAT_FIM_FERIAS;
  FETCH CHEK_DAT_FIM_FERIAS INTO V_DAT_FIM_FERIAS;
  CLOSE CHEK_DAT_FIM_FERIAS;

  IF V_DAT_FIM_FERIAS IS NOT NULL THEN
    P_COD_ERRO := 103;
    P_MSG_ERRO := P_MSG_ERRO || ','||  PAC_FERIAS.GET_MSG_ERRO('103');
  END IF;


  OPEN CHEK_CONCOMITANTE;
  FETCH CHEK_CONCOMITANTE INTO V_CONCOMITANTE;
  CLOSE CHEK_CONCOMITANTE;

  IF V_CONCOMITANTE IS NOT NULL THEN
       P_COD_ERRO := 110;
       P_MSG_ERRO := P_MSG_ERRO || ','||  PAC_FERIAS.GET_MSG_ERRO('110');
  END IF;


  IF V_NUMERO_DIAS >  V_SALDO_ATUAL THEN
       P_COD_ERRO := 100;
       P_MSG_ERRO := P_MSG_ERRO || ','||  PAC_FERIAS.GET_MSG_ERRO('100');
  END IF;


  IF V_DAT_FIM_AQUI IS NOT NULL THEN
       P_COD_ERRO := 101;
       P_MSG_ERRO := P_MSG_ERRO || ','||  PAC_FERIAS.GET_MSG_ERRO('101');
  END IF;


  IF V_NUMERO_DIAS NOT IN  ('10','12','15','18','20','24','30')  THEN
       P_COD_ERRO := 104;
       P_MSG_ERRO := P_MSG_ERRO || ','||  PAC_FERIAS.GET_MSG_ERRO('104') ;
  END IF;

  IF P_MSG_ERRO IS NULL THEN
      V_ID_GOZO := SEQ_TB_FERIAS_GOZO.NEXTVAL;

      IF TRUNC(TO_DATE(P_DAT_INICIO,'DD/MM/RRRR')) > TRUNC(SYSDATE) THEN         
        V_STATUS_FERIAS := 'L'; 
      ELSE
        V_STATUS_FERIAS := 'U'; 
      END IF;  

      INSERT INTO TB_FERIAS_GOZO
                 (
                  ID_GOZO,
                  ID_AQUISITIVO,
                  FLG_ABONO,
                  FLG_ANTECIPACAO,
                  DAT_INICIO,
                  DAT_FIM,
                  FLG_STATUS,
                  DAT_ING,
                  DAT_ULT_ATU,
                  NOM_USU_ULT_ATU,
                  NOM_PRO_ULT_ATU,
                  NUM_DIAS
                  )
                  VALUES
                  (
                  V_ID_GOZO,
                  P_ID_AQUISITIVO,
                  P_FLG_ABONO,
                  P_FLG_ANTECIPACAO,
                  TO_DATE(P_DAT_INICIO,'DD/MM/RRRR'),
                  TO_DATE(P_DAT_FIM,'DD/MM/RRRR'),
                  V_STATUS_FERIAS,
                  SYSDATE,
                  SYSDATE,
                  V_USER_BD,
                  V_NOM_USU_ULT_ATU,
                  V_NUMERO_DIAS
                  );

       V_SALDO_ATUAL := V_SALDO_ATUAL - V_NUMERO_DIAS;

       UPDATE TB_FERIAS_AQUISITIVO
          SET NUM_SALDO    = V_SALDO_ATUAL
       WHERE ID_AQUISITIVO = P_ID_AQUISITIVO;

       P_COD_ERRO := 0;
       P_MSG_ERRO := NULL;
  END IF;

  IF P_MSG_ERRO IS NOT NULL AND SUBSTR(P_MSG_ERRO,1,1) = ',' THEN
     P_MSG_ERRO  := SUBSTR(P_MSG_ERRO,2,LENGTH(P_MSG_ERRO));
  END IF;

EXCEPTION
  WHEN OTHERS THEN
   P_COD_ERRO := SUBSTR(SQLCODE, 1, 32000);
   P_MSG_ERRO := SUBSTR(SQLERRM, 1, 32000);
END SP_INSERE_FERIAS_GOZO;

PROCEDURE SP_DELETE_FERIAS_GOZO
(
 P_ID_AQUISITIVO         IN  NUMBER,
 P_ID_GOZO               IN  NUMBER,
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
)
IS





  V_SALDO_ATUAL        NUMBER:=0;
  V_COD_IDE_REL_FUNC   VARCHAR2(20);
  V_DAT_INICIO         DATE;
  V_DAT_INI_GOZO       DATE;

BEGIN  

  SELECT FA.COD_IDE_REL_FUNC, FA.DAT_INICIO
    INTO V_COD_IDE_REL_FUNC, V_DAT_INICIO
    FROM TB_FERIAS_AQUISITIVO FA
   WHERE FA.ID_AQUISITIVO = P_ID_AQUISITIVO; 



  SELECT FG.DAT_INICIO
    INTO V_DAT_INI_GOZO
    FROM TB_FERIAS_GOZO FG
   WHERE FG.ID_GOZO =  P_ID_GOZO;



  FOR R IN (SELECT FA.ID_AQUISITIVO, FG.ID_GOZO 
              FROM TB_FERIAS_AQUISITIVO FA JOIN TB_FERIAS_GOZO FG ON FG.ID_AQUISITIVO = FA.ID_AQUISITIVO
             WHERE fg.flg_status= 'L'
               AND FA.ID_AQUISITIVO IN (SELECT ID_AQUISITIVO
                                          FROM TB_FERIAS_AQUISITIVO FA2
                                         WHERE FA2.COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
                                           AND FA2.DAT_INICIO >= V_DAT_INICIO)
               AND FG.DAT_INICIO >= V_DAT_INI_GOZO)
  LOOP                                              

    UPDATE TB_FERIAS_GOZO
       SET  FLG_STATUS    = 'C'
     WHERE  ID_GOZO       = R.ID_GOZO
       AND  ID_AQUISITIVO = R.ID_AQUISITIVO; 

    V_SALDO_ATUAL := GET_SALDO_ATUAL(P_ID_AQUISITIVO,NULL);       

    UPDATE TB_FERIAS_AQUISITIVO
       SET NUM_SALDO    = V_SALDO_ATUAL
    WHERE ID_AQUISITIVO = R.ID_AQUISITIVO;

    P_COD_ERRO := 0;
    P_MSG_ERRO := NULL;
  END LOOP;    

EXCEPTION
  WHEN OTHERS THEN
    P_COD_ERRO := SUBSTR(SQLCODE, 1, 32000);
    P_MSG_ERRO := SUBSTR(SQLERRM, 1, 32000);

END SP_DELETE_FERIAS_GOZO;


FUNCTION GET_SALDO_PERMITIDO(P_ID_AQUISITIVO IN NUMBER,
                             P_QTD_DIAS_FALTA IN NUMBER) RETURN NUMBER
AS
V_SALDO NUMBER;
V_QTD_DIAS_FALTA NUMBER;
V_COD_IDE_CLI NUMBER;     
V_COD_IDE_REL_FUNC NUMBER;
V_DAT_INICIO DATE;
V_DAT_FIM DATE;
BEGIN

  IF P_ID_AQUISITIVO IS NULL AND P_QTD_DIAS_FALTA IS NULL THEN 
    RETURN 0;
  END IF;

  IF P_QTD_DIAS_FALTA IS NULL THEN 

    SELECT FA.COD_IDE_CLI,
           FA.COD_IDE_REL_FUNC,
           FA.DAT_INICIO,
           FA.DAT_FIM
      INTO V_COD_IDE_CLI, V_COD_IDE_REL_FUNC,V_DAT_INICIO,V_DAT_FIM            
      FROM TB_FERIAS_AQUISITIVO FA
     WHERE FA.ID_AQUISITIVO = P_ID_AQUISITIVO;

     SELECT SUM(LEAST(AF.DAT_RET_PREV,V_DAT_FIM) - GREATEST(AF.DAT_INI_AFAST,V_DAT_INICIO))
       INTO V_QTD_DIAS_FALTA
       FROM TB_AFASTAMENTO AF
      WHERE AF.COD_INS = 1
        AND AF.COD_IDE_CLI = V_COD_IDE_CLI
        AND AF.COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
        AND AF.COD_MOT_AFAST IN (SELECT COD_MOT_AFAST FROM TB_REL_MOT_AFAST_GRUPO WHERE ID_GRUPO =2)
        AND (AF.DAT_RET_PREV BETWEEN V_DAT_INICIO AND V_DAT_FIM OR
             AF.DAT_INI_AFAST BETWEEN V_DAT_INICIO AND V_DAT_FIM OR
            (AF.DAT_INI_AFAST < V_DAT_INICIO AND AF.DAT_RET_PREV > V_DAT_FIM))
       AND NOT EXISTS (SELECT '1' 
                         FROM TB_FERIAS_GOZO 
                        WHERE ID_AQUISITIVO = NVL(P_ID_AQUISITIVO,0)
                          AND FLG_STATUS NOT IN ('C','T'));      
  ELSE
    V_QTD_DIAS_FALTA := P_QTD_DIAS_FALTA;
  END IF;

  IF NVL(V_QTD_DIAS_FALTA,0) < 6 THEN 
    V_SALDO := 30;
  ELSIF V_QTD_DIAS_FALTA BETWEEN 6 AND 14 THEN
    V_SALDO := 24;
  ELSIF V_QTD_DIAS_FALTA BETWEEN 15 AND 23 THEN
    V_SALDO := 18;            
  ELSIF V_QTD_DIAS_FALTA > 24  THEN
    V_SALDO := 12;
  END IF;   

  RETURN V_SALDO;
END;



FUNCTION GET_SALDO_ATUAL
(
 P_ID_AQUISITIVO IN NUMBER,
 P_QTD_DIAS_FALTA IN NUMBER
) RETURN NUMBER IS







 V_SALDO NUMBER;
 V_SALDO_GOZO NUMBER;

BEGIN

  V_SALDO := GET_SALDO_PERMITIDO(P_ID_AQUISITIVO,P_QTD_DIAS_FALTA);


  IF P_ID_AQUISITIVO IS NOT NULL THEN 
    SELECT SUM(NVL(FG.NUM_DIAS,0))
      INTO V_SALDO_GOZO
      FROM TB_FERIAS_GOZO FG
     WHERE FG.ID_AQUISITIVO = P_ID_AQUISITIVO
       AND FG.FLG_STATUS NOT IN ('C','T');

    V_SALDO := GREATEST(V_SALDO - NVL(V_SALDO_GOZO,0),0);
  END IF;

  RETURN V_SALDO;

EXCEPTION
  WHEN OTHERS THEN
     RETURN NULL;
END GET_SALDO_ATUAL;



FUNCTION GET_MSG_ERRO
(
 P_ID    IN NUMBER
 ) RETURN VARCHAR2
IS
 V_TEMP   TB_ERROS.DES_ERRO%TYPE;

  CURSOR GET_DATA IS
    SELECT
           A.DES_ERRO
      FROM TB_ERROS A
     WHERE COD_ERRO = P_ID;

BEGIN

  OPEN GET_DATA;
  FETCH GET_DATA INTO V_TEMP;
  CLOSE GET_DATA;

  RETURN V_TEMP;

EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END GET_MSG_ERRO;


PROCEDURE SP_CALC_FERIAS_TODOS
(
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
) IS

  CURSOR FUNCIONARIOS_CUR
      IS
  SELECT RF.COD_INS
       , RF.COD_IDE_CLI
       , RF.COD_ENTIDADE
       , RF.NUM_MATRICULA
       , RF.COD_IDE_REL_FUNC 
    FROM TB_RELACAO_FUNCIONAL RF 
   WHERE RF.COD_REGIME_JUR <> 6  
     AND RF.DAT_FIM_EXERC IS NULL;    

    L_FUNCIONARIOS_ID   FUNCIONARIOS_CUR%ROWTYPE;

BEGIN
       OPEN FUNCIONARIOS_CUR;

       LOOP
          FETCH FUNCIONARIOS_CUR INTO L_FUNCIONARIOS_ID;
          EXIT WHEN FUNCIONARIOS_CUR%NOTFOUND;

          SP_CALC_PER_AQUISITIVO(L_FUNCIONARIOS_ID.COD_INS
                                ,L_FUNCIONARIOS_ID.COD_IDE_CLI
                                ,L_FUNCIONARIOS_ID.COD_IDE_REL_FUNC
                                ,P_COD_ERRO
                                ,P_MSG_ERRO
                                );

         COMMIT;

      END LOOP;

      CLOSE FUNCIONARIOS_CUR;

EXCEPTION
  WHEN OTHERS THEN
   P_COD_ERRO := SUBSTR(SQLCODE, 1, 32000);
   P_MSG_ERRO := SUBSTR(SQLERRM, 1, 32000);
END SP_CALC_FERIAS_TODOS;

PROCEDURE SP_CALC_FERIAS_TODOS_FUNC
(
 P_COD_ERRO              OUT NUMBER,
 P_MSG_ERRO              OUT VARCHAR2
) IS

  CURSOR FUNCIONARIOS_CUR
      IS
  SELECT RF.COD_INS
       , RF.COD_IDE_CLI
       , RF.COD_ENTIDADE
       , RF.NUM_MATRICULA
       , RF.COD_IDE_REL_FUNC
    FROM TB_RELACAO_FUNCIONAL RF
    WHERE RF.COD_INS = 1


   AND RF.COD_IDE_CLI BETWEEN 1008689 AND 1011284
   AND RF.COD_IDE_REL_FUNC = RF.NUM_MATRICULA||'01'

   AND NOT EXISTS
       (
       SELECT 1 FROM TB_FERIAS_AQUISITIVO FA
       WHERE FA.COD_INS = 1
       AND FA.COD_IDE_CLI = RF.COD_IDE_CLI
       AND FA.COD_IDE_REL_FUNC = RF.COD_IDE_REL_FUNC
       AND FA.COD_ENTIDADE = RF.COD_ENTIDADE
       AND FA.NUM_MATRICULA = RF.NUM_MATRICULA
       )
   ORDER
      BY NUM_MATRICULA ASC;

 L_FUNCIONARIOS_ID   FUNCIONARIOS_CUR%ROWTYPE;

BEGIN

       OPEN FUNCIONARIOS_CUR;

       LOOP
          FETCH FUNCIONARIOS_CUR INTO L_FUNCIONARIOS_ID;
          EXIT WHEN FUNCIONARIOS_CUR%NOTFOUND;

          SP_CALC_PER_AQUISITIVO(L_FUNCIONARIOS_ID.COD_INS
                                ,L_FUNCIONARIOS_ID.COD_IDE_CLI
                                ,L_FUNCIONARIOS_ID.COD_IDE_REL_FUNC
                                ,P_COD_ERRO
                                ,P_MSG_ERRO
                                );

         COMMIT;

      END LOOP;

      CLOSE FUNCIONARIOS_CUR;

EXCEPTION
  WHEN OTHERS THEN
   P_COD_ERRO := SUBSTR(SQLCODE, 1, 32000);
   P_MSG_ERRO := SUBSTR(SQLERRM, 1, 32000);
END SP_CALC_FERIAS_TODOS_FUNC;



PROCEDURE SP_CALC_DATAS_FERIAS(I_COD_INS                 IN VARCHAR2,
                               I_ID_AQUISITIVO           IN NUMBER,
                               I_DAT_INI_FERIAS          IN DATE,
                               I_QTD_DIAS_FERIAS         IN NUMBER,
                               O_DAT_FIM_FERIAS          OUT DATE,
                               O_DAT_RET_FERIAS          OUT DATE,
                               O_COD_ERRO                OUT NUMBER,
                               O_MSG_ERRO                OUT VARCHAR2)
AS
  V_COD_ERRO NUMBER;
  E_ERRO EXCEPTION;
  V_DATA_FIM DATE;
  V_DATA_RET DATE;
  V_CONTADOR NUMBER :=0;
  V_DAT_LIM_GOZO DATE;
  V_COD_STATUS CHAR;

  V_COD_IDE_CLI VARCHAR2(2000); 
  V_COD_ENTIDADE NUMBER;
  V_NUM_MATRICULA NUMBER;
  V_COD_IDE_REL_FUNC NUMBER;
  V_MAX_DAT_FIM DATE;


BEGIN  

  IF NVL(I_COD_INS,0) = 0 THEN
    O_COD_ERRO := 1000;
    O_MSG_ERRO := 'Codigo de Instituto invalido';
    RETURN; 
  END IF;

  SELECT RA.COD_IDE_CLI, RA.COD_ENTIDADE, RA.NUM_MATRICULA, RA.COD_IDE_REL_FUNC
    INTO V_COD_IDE_CLI, V_COD_ENTIDADE, V_NUM_MATRICULA, V_COD_IDE_REL_FUNC
    FROM TB_FERIAS_AQUISITIVO RA
   WHERE ID_AQUISITIVO = I_ID_AQUISITIVO;


  SELECT MAX(B.DAT_FIM)
    INTO V_MAX_DAT_FIM
    FROM TB_FERIAS_AQUISITIVO A 
      JOIN TB_FERIAS_GOZO B
        ON A.ID_AQUISITIVO = B.ID_AQUISITIVO
    WHERE A.COD_INS = 1
       AND A.COD_IDE_CLI = V_COD_IDE_CLI
       AND A.COD_ENTIDADE = V_COD_ENTIDADE
       AND A.NUM_MATRICULA = V_NUM_MATRICULA
       AND A.COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
       AND A.DAT_INICIO = (SELECT MAX(DAT_INICIO)
                             FROM TB_FERIAS_AQUISITIVO RA
                            WHERE RA.COD_INS = 1
                              AND RA.COD_IDE_CLI = V_COD_IDE_CLI
                              AND RA.COD_ENTIDADE = V_COD_ENTIDADE
                              AND RA.NUM_MATRICULA = V_NUM_MATRICULA
                              AND RA.COD_IDE_REL_FUNC = V_COD_IDE_REL_FUNC
                              AND RA.DAT_INICIO < (SELECT DAT_INICIO
                                                     FROM TB_FERIAS_AQUISITIVO RA
                                                    WHERE RA.COD_INS = 1
                                                      AND RA.ID_AQUISITIVO = I_ID_AQUISITIVO
                                                      AND RA.COD_STATUS <> 'C'
                                                   )
                              AND RA.COD_STATUS <> 'C'                                                      
                          )
      AND A.COD_STATUS <> 'C' 
      AND B.FLG_STATUS  NOT IN ('C','T');             
  IF V_MAX_DAT_FIM <> I_DAT_INI_FERIAS-1 THEN                     

    IF FNC_RET_STA_DATA_FERIADO(I_COD_INS,I_DAT_INI_FERIAS) = 'S' THEN
      V_COD_ERRO := 1;
      RAISE E_ERRO;
    END IF;


    IF TO_CHAR(I_DAT_INI_FERIAS,'d') IN (1,7) THEN
      V_COD_ERRO := 4;
      RAISE E_ERRO;
    END IF;
  END IF;


  V_DATA_FIM := I_DAT_INI_FERIAS + I_QTD_DIAS_FERIAS -1;




  SELECT FA.DAT_LIMITE , FA.COD_STATUS 
    INTO V_DAT_LIM_GOZO, V_COD_STATUS
    FROM TB_FERIAS_AQUISITIVO FA
   WHERE FA.ID_AQUISITIVO = I_ID_AQUISITIVO;









  V_DATA_RET := V_DATA_FIM + 1;



  WHILE FNC_RET_STA_DATA_FERIADO(I_COD_INS,V_DATA_RET) = 'S' OR
        TO_CHAR(V_DATA_RET,'d') IN (1,7)
  LOOP
    V_DATA_RET := V_DATA_RET +1;

    V_CONTADOR := V_CONTADOR+1;
    IF V_CONTADOR > 367 THEN
      RAISE_APPLICATION_ERROR(-20000,'Problemas no cadastro de feriados.');
    END IF;
  END LOOP;

  O_DAT_FIM_FERIAS := V_DATA_FIM;
  O_DAT_RET_FERIAS := V_DATA_RET;

EXCEPTION
  WHEN E_ERRO THEN
    O_COD_ERRO := FNC_RET_COD_ERRO(I_COD_INS,V_COD_ERRO,'FOLHA_PAR','PAC_FERIAS.SP_CALC_DATAS_FERIAS');
    O_MSG_ERRO := FNC_RET_MSG_ERRO(I_COD_INS,V_COD_ERRO,'FOLHA_PAR','PAC_FERIAS.SP_CALC_DATAS_FERIAS');
  WHEN OTHERS THEN
    O_COD_ERRO := 0;
    O_MSG_ERRO := 'Erro Geral SP_CALC_DATAS_FERIAS: '||SQLCODE||'-'||SQLERRM;
END SP_CALC_DATAS_FERIAS;


PROCEDURE SP_RET_NOM_CARGO_2(I_COD_ENTIDADE IN NUMBER, 
                           I_COD_PCCS     IN NUMBER, 
                           I_COD_CARGO    IN NUMBER,
                           I_NUM_ORGAO    IN NUMBER,
                           O_NOW         OUT VARCHAR2,
                           O_NOM_CARGO   OUT VARCHAR2,
                           O_NOM_LOTACAO OUT VARCHAR2)
AS 
BEGIN    

    O_NOW := TO_CHAR(SYSDATE, 'DD/MM/YYYY');    


    BEGIN       
      SELECT NOM_CARGO 
        INTO O_NOM_CARGO
        FROM TB_CARGO 
       WHERE COD_ENTIDADE = I_COD_ENTIDADE 
         AND COD_PCCS = I_COD_PCCS
         AND COD_CARGO = I_COD_CARGO
         AND ROWNUM < 2;                  
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      O_NOM_CARGO := NULL;               
    END;

    BEGIN 
      SELECT NOM_ORGAO 
        INTO O_NOM_LOTACAO
        FROM TB_ORGAO 
       WHERE COD_ENTIDADE = I_COD_ENTIDADE 
         AND COD_ORGAO = I_NUM_ORGAO
         AND ROWNUM < 2;    
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN 
      O_NOM_CARGO := NULL;   
    END;

END SP_RET_NOM_CARGO_2; 

PROCEDURE SP_RET_NOM_CARGO(I_COD_INS          IN NUMBER, 
                             I_COD_IDE_CLI      IN NUMBER,
                             I_COD_ENTIDADE     IN NUMBER,                             
                             I_NUM_MATRICULA    IN VARCHAR2, 
                             I_COD_IDE_REL_FUNC IN NUMBER,
                             I_NUM_ORGAO        IN NUMBER,
                             O_NOW             OUT VARCHAR2,
                             O_NOM_CARGO       OUT VARCHAR2,
                             O_NOM_LOTACAO     OUT VARCHAR2,
                             O_COD_ERRO        OUT NUMBER, 
                             O_MSG_ERRO        OUT VARCHAR2,
                             I_COD_PCCS         IN NUMBER DEFAULT NULL, 
                             I_COD_CARGO        IN NUMBER DEFAULT NULL)
AS 
V_COD_PCCS  NUMBER;
V_COD_CARGO NUMBER;
BEGIN    

    O_NOW := TO_CHAR(SYSDATE, 'DD/MM/YYYY');    


    BEGIN    
      SELECT G.COD_PCCS, G.COD_CARGO_COMP
        INTO V_COD_PCCS,V_COD_CARGO 
        FROM TB_EVOLU_CCOMI_GFUNCIONAL G
       WHERE G.COD_INS = 1
         AND G.COD_IDE_CLI = I_COD_IDE_CLI
         AND G.COD_ENTIDADE = I_COD_ENTIDADE
         AND G.NUM_MATRICULA = I_NUM_MATRICULA
         AND G.COD_IDE_REL_FUNC =  I_COD_IDE_REL_FUNC
         AND G.COD_MOT_EVOL_FUNC = 1
         AND G.DAT_FIM_EFEITO IS NULL;
    EXCEPTION 
      WHEN NO_DATA_FOUND THEN 
        V_COD_PCCS  := NULL;
        V_COD_CARGO := NULL;
      WHEN TOO_MANY_ROWS THEN 
        O_COD_ERRO := FNC_RET_COD_ERRO(0,1,'FOLHA_PAR','PAC_FERIAS.SP_RET_NOM_CARGO');
        O_MSG_ERRO := FNC_RET_MSG_ERRO(0,1,'FOLHA_PAR','PAC_FERIAS.SP_RET_NOM_CARGO');
        RETURN;                                
    END;     


    IF V_COD_PCCS IS NULL OR V_COD_CARGO IS NULL THEN 
      IF I_COD_PCCS IS NULL OR I_COD_CARGO IS NULL THEN

        BEGIN 
          SELECT EVF.COD_PCCS, EVF.COD_CARGO
            INTO V_COD_PCCS, V_COD_CARGO
            FROM TB_EVOLUCAO_FUNCIONAL EVF
           WHERE EVF.COD_INS = I_COD_INS
             AND EVF.COD_IDE_CLI = I_COD_IDE_CLI
             AND EVF.NUM_MATRICULA = I_NUM_MATRICULA
             AND EVF.COD_IDE_REL_FUNC = I_COD_IDE_REL_FUNC
             AND EVF.DAT_FIM_EFEITO IS NULL;                   
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN 
            O_COD_ERRO := FNC_RET_COD_ERRO(0,2,'FOLHA_PAR','PAC_FERIAS.SP_RET_NOM_CARGO');
            O_MSG_ERRO := FNC_RET_MSG_ERRO(0,2,'FOLHA_PAR','PAC_FERIAS.SP_RET_NOM_CARGO');   
            RETURN;     
          WHEN TOO_MANY_ROWS THEN 
            O_COD_ERRO := FNC_RET_COD_ERRO(0,3,'FOLHA_PAR','PAC_FERIAS.SP_RET_NOM_CARGO');
            O_MSG_ERRO := FNC_RET_MSG_ERRO(0,3,'FOLHA_PAR','PAC_FERIAS.SP_RET_NOM_CARGO');                        
            RETURN;
        END;             
      ELSE
        V_COD_PCCS  := I_COD_PCCS;
        V_COD_CARGO := I_COD_CARGO;

      END IF;        
    END IF;

    BEGIN       
      SELECT NOM_CARGO 
        INTO O_NOM_CARGO
        FROM TB_CARGO 
       WHERE COD_ENTIDADE = I_COD_ENTIDADE 
         AND COD_PCCS = V_COD_PCCS
         AND COD_CARGO = V_COD_CARGO
         AND ROWNUM < 2;                  
    EXCEPTION 
    WHEN OTHERS THEN 
      O_NOM_CARGO := NULL;               
    END;

    BEGIN 
      SELECT NOM_ORGAO 
        INTO O_NOM_LOTACAO
        FROM TB_ORGAO 
       WHERE COD_ENTIDADE = I_COD_ENTIDADE 
         AND COD_ORGAO = I_NUM_ORGAO
         AND ROWNUM < 2;    
    EXCEPTION 
    WHEN OTHERS THEN 
      O_NOM_LOTACAO := NULL;   
    END;

    O_COD_ERRO := NULL;
    O_MSG_ERRO := NULL;
END SP_RET_NOM_CARGO; 


FUNCTION FNC_RET_BLOQ_CMP_13(I_COD_INS          TB_FERIAS_AQUISITIVO.COD_INS%TYPE, 
                             I_COD_ENTIDADE     TB_FERIAS_AQUISITIVO.COD_ENTIDADE%TYPE, 
                             I_COD_IDE_CLI      TB_FERIAS_AQUISITIVO.COD_IDE_CLI%TYPE,
                             I_NUM_MATRICULA    TB_FERIAS_AQUISITIVO.NUM_MATRICULA%TYPE,
                             I_COD_IDE_REL_FUNC TB_FERIAS_AQUISITIVO.COD_IDE_REL_FUNC%TYPE,
                             I_DAT_INI_GOZO     DATE
                             ) RETURN CHAR
AS
 V_BLOQUEIA CHAR := 'N';
BEGIN


  IF EXTRACT(MONTH FROM I_DAT_INI_GOZO) = 12 THEN
    V_BLOQUEIA := 'S';   
  END IF;

  IF V_BLOQUEIA = 'N' THEN 

    SELECT DECODE(COUNT(*), 0, 'N', 'S') AS FLG_EXISTE
    INTO V_BLOQUEIA
    FROM TB_FERIAS_AQUISITIVO FA JOIN TB_FERIAS_GOZO FG  ON FA.ID_AQUISITIVO = FG.ID_AQUISITIVO
    WHERE FA.COD_INS = I_COD_INS
      AND FA.COD_ENTIDADE = I_COD_ENTIDADE
      AND FA.COD_IDE_CLI = I_COD_IDE_CLI
      AND FA.NUM_MATRICULA = I_NUM_MATRICULA
      AND FA.COD_IDE_REL_FUNC = I_COD_IDE_REL_FUNC
      AND EXTRACT(YEAR FROM FG.DAT_INICIO) = EXTRACT(YEAR FROM I_DAT_INI_GOZO)
      AND FA.COD_STATUS <> 'C'
      AND FG.FLG_STATUS NOT IN ('C','T')
      AND FG.FLG_ANTECIPACAO = 'S';  
  END IF;



  IF V_BLOQUEIA = 'N' THEN 

    SELECT DECODE(COUNT(*), 0, 'N', 'S') AS FLG_EXISTE
      INTO V_BLOQUEIA
      FROM TB_HFOLHA_PAGAMENTO PA, TB_HFOLHA_PAGAMENTO_DET DT
     WHERE PA.COD_INS          = I_COD_INS           AND
           PA.COD_IDE_CLI      = I_COD_IDE_CLI       AND
           PA.NUM_MATRICULA    = I_NUM_MATRICULA     AND
           PA.COD_IDE_REL_FUNC = I_COD_IDE_REL_FUNC  AND
           PA.COD_INS          = DT.COD_INS          AND
           PA.TIP_PROCESSO     = DT.TIP_PROCESSO     AND
           PA.PER_PROCESSO     = DT.PER_PROCESSO     AND
           PA.SEQ_PAGAMENTO    = DT.SEQ_PAGAMENTO    AND
           PA.COD_IDE_CLI      = DT.COD_IDE_CLI      AND
           PA.NUM_MATRICULA    = DT.NUM_MATRICULA    AND
           PA.COD_IDE_REL_FUNC = DT.COD_IDE_REL_FUNC AND
           DT.COD_FCRUBRICA  IN ( 11200 , 11201 )    AND

           TO_CHAR(DT.PER_PROCESSO,'yyyy') =  TO_CHAR(SYSDATE ,'yyyy');

  END IF;

  RETURN V_BLOQUEIA;

END FNC_RET_BLOQ_CMP_13;                            


function sp_controle_resp_frequencia_pipe(
  
   p_cod_entidade      in number , 
   p_num_matricula     in  number,
   p_cod_ide_rel_func  in number ,
   p_cod_ide_cli       in  number,
   p_login             in varchar
    
) Return t_col_retorno Pipelined    
is
   num_cpf          number;
   v_cod_orgao      number;
   v_reg_retorno    ESTRUC_RETORNO;
   v_existe_permissao boolean := false;
   p_cod_ins          number  :=1;
begin
            for regpa in (    
                 select rp.cod_orgao  
                  from paride pa
                 join tb_pessoa_fisica pf     on pf.num_cpf = pa.ide_rut
                 join tb_orgao_responsavel rp on rp.cod_ide_cli = pf.cod_ide_cli
                 where ide_codnum  = 2042
                 and pa.ide_codpar =  p_login
                 and rp.flg_status <> 'C'
                 and (rp.dat_fim_vigencia is null or  rp.dat_fim_vigencia > sysdate) 
           ) loop
              for regor in (
                     select
                     o.cod_orgao    ,
                     o.cod_orgao_pai,
                     o.nom_orgao    ,
                     level as nivel
                     from tb_orgao o
                     where o.cod_ins = 1
                     and trunc(sysdate) between o.dat_ini_vig and nvl(o.dat_fim_vig, sysdate+1)
                     start with cod_orgao         = regpa.cod_orgao
                     connect by prior o.cod_orgao = o.cod_orgao_pai 
                     order by level
                   )  loop
                 
                       for vin in 
                        (
                          select f.cod_ide_cli from tb_relacao_funcional f
                          join   tb_lotacao l on l.cod_ide_cli = f.cod_ide_cli
                          where
                                f.cod_ins          = p_cod_ins
                          and   f.cod_entidade     = p_cod_entidade
                          and   f.cod_ide_rel_func = p_cod_ide_rel_func
                          and   f.cod_ide_cli      = p_cod_ide_cli
                          and   f.num_matricula    = p_num_matricula
                          and   l.cod_ins          = f.cod_ins            
                          and   l.cod_entidade     = f.cod_entidade
                          and   l.cod_ide_rel_func = f.cod_ide_rel_func
                          and   l.cod_ide_cli      = f.cod_ide_cli
                          and   l.num_matricula    = f.num_matricula 
                          and   l.cod_orgao        = regor.cod_orgao
                          and   (l.dat_fim  is null or l.dat_fim > sysdate)
                                     
                         ) loop
                              v_existe_permissao := true;   
                           end loop;
                  end loop;
           end loop;
--

          if not v_existe_permissao then 
                   for Reg_login in (    
                       select lot.cod_orgao
                        from paride pa
                       join tb_pessoa_fisica pf     on pf.num_cpf  = pa.ide_rut
                       join tb_lotacao       lot    on   lot.cod_ins      =1 
                                                     and lot.cod_ide_cli  =pf.cod_ide_cli
                                                     and lot.cod_entidade =p_cod_entidade
                                                     and   (lot.dat_fim is null or  lot.dat_fim > sysdate) 
                       where ide_codnum  =   2042
                       and pa.ide_codpar =  p_login
                    ) loop     
                            for vin in 
                              (
                                select f.cod_ide_cli from tb_relacao_funcional f
                                join   tb_lotacao l on l.cod_ide_cli = f.cod_ide_cli
                                where
                                      f.cod_ins          = p_cod_ins
                                and   f.cod_entidade     = p_cod_entidade
                                and   f.cod_ide_rel_func = p_cod_ide_rel_func
                                and   f.cod_ide_cli      = p_cod_ide_cli
                                and   f.num_matricula    = p_num_matricula
                                and   l.cod_ins          = f.cod_ins            
                                and   l.cod_entidade     = f.cod_entidade
                                and   l.cod_ide_rel_func = f.cod_ide_rel_func
                                and   l.cod_ide_cli      = f.cod_ide_cli
                                and   l.num_matricula    = f.num_matricula 
                                and   l.cod_orgao        = Reg_login.Cod_Orgao
                                and   (l.dat_fim  is null or l.dat_fim > sysdate)
                                           
                               ) loop
                                    v_existe_permissao := true; 
                                    exit;     
                                 end loop;
                    end loop;   
         end if;  
         
---------------------------------------------------------------------------------------------
         
            if not v_existe_permissao then 
                       for Reg_login in (    
                               select  * from  seg_usuper         
                               join seg_perfil on seg_perfil.cod_perfil = seg_usuper.cod_perfil
                               where des_nome = 'P. MANUT FREQUENCIA'  
                               and ide_codpar = p_login   
                               and dat_ini_vig <= trunc(sysdate)  
                               and (dat_fim_vig is null or dat_fim_vig <= sysdate)
                        ) loop  
                              
                             v_existe_permissao := true; 
                              
                        end loop;   
            end if;        
      
 -------------------------------------------------------------------------------------------        
        IF  v_existe_permissao THEN 
                v_reg_retorno.cod_retorno   :='OK';
                v_reg_retorno.desc_retorno :='Com Permissao';
        ELSE
                v_reg_retorno.cod_retorno   :='NOK';
                v_reg_retorno.desc_retorno :='Sem Permissao';    
        END IF;     
        Pipe Row(v_reg_retorno);
  end;

   function sp_documento_pend_ass( p_cod_ide_clI   in tb_relacao_funcional.cod_ide_cli%type)
                                        
    
    return t_col_dados_documento_pend_ass
    pipelined -- Assinatura pendencias de assinatura

  as
  
        v_cod_retorno  varchar2(20); 
  begin  
 
   
    for registro in     (        
    
         select distinct
              MAX(f.DATA_PONTO) DATA_PONTO,
              P.COD_IDE_CLI, 
              P.Nom_Pessoa_Fisica,
              P.NUM_CPF,
              F.NUM_MATRICULA,
              F.DAT_ASS_SERV,
              F.FLG_ASSINATURA_RESP,
              F.ID_GED_ORIGINAL 
        from  tb_orgao_responsavel rp 
        join  tb_lotacao l on l.cod_orgao = rp.cod_orgao
        join  TB_FREQUENCIA F on f.cod_ide_cli = l.cod_ide_cli
        join  TB_PESSOA_FISICA P on P.COD_IDE_CLI = F.COD_IDE_CLI
        where rp.cod_ide_cli =   p_cod_ide_clI
        and   rp.FLG_STATUS = 'V' or  rp.FLG_STATUS is null
        and   f.flg_assinatura_serv = 'S' and (f.flg_assinatura_resp <> 'S' or f.flg_assinatura_resp is null)
        and   (l.dat_fim is null or l.dat_fim >= sysdate)   
     group by 
                P.COD_IDE_CLI, 
                P.Nom_Pessoa_Fisica,
                P.NUM_CPF,
                F.NUM_MATRICULA,
                F.DAT_ASS_SERV,
                F.FLG_ASSINATURA_RESP,
                F.ID_GED_ORIGINAL 
    
     
       )loop
              
           v_dados_documento_pend_ass.v_data_ponto         := registro.DATA_PONTO;
           v_dados_documento_pend_ass.V_COD_IDE_CLI         := registro.COD_IDE_CLI;
           v_dados_documento_pend_ass.v_Nome_servidor       := registro.Nom_Pessoa_Fisica;
           v_dados_documento_pend_ass.V_CPF                 := registro.NUM_CPF;
           v_dados_documento_pend_ass.V_NUM_MATRICULA       := registro.NUM_MATRICULA;
           v_dados_documento_pend_ass.v_data_assinatura     := registro.DAT_ASS_SERV;
           v_dados_documento_pend_ass.v_flg_ass_responsavel := registro.FLG_ASSINATURA_RESP;
           v_dados_documento_pend_ass.V_ID_DOCUMENTO_GED    := registro.ID_GED_ORIGINAL;
       
           pipe row(v_dados_documento_pend_ass);
     end loop;
    
  end;  
  
  function sp_documento_pend_ass_2( p_cod_ide_clI   in tb_relacao_funcional.cod_ide_cli%type)
                                        
    
    return t_col_dados_documento_pend_ass_2
    
   
    pipelined -- Assinatura pendencias de assinatura
  

  as
  
   v_cod_retorno  varchar(20); 
  
  
  begin  
     for resp in (
        select rp.cod_entidade,rf.num_matricula,rf.cod_ide_rel_func,rp.cod_ide_cli,pa.ide_codpar as login
                  from paride pa
                 join tb_pessoa_fisica pf     on pf.num_cpf = pa.ide_rut
                 join tb_orgao_responsavel rp on rp.cod_ide_cli = pf.cod_ide_cli
                 join tb_relacao_funcional rf on rf.cod_ide_cli = pf.cod_ide_cli
                 where ide_codnum  = 2042
                 and   rp.cod_ide_cli = p_cod_ide_cli
                 and   rp.FLG_STATUS = 'V' or  rp.FLG_STATUS is null
                 and (rp.dat_fim_vigencia is null or  rp.dat_fim_vigencia > sysdate) 
      ) loop
 
  select  cod_retorno into v_cod_retorno  from sp_controle_resp_frequencia_pipe(resp.cod_entidade,resp.num_matricula,resp.cod_ide_rel_func,resp.cod_ide_cli,resp.login) a;
  
 IF v_cod_retorno = 'OK' then

    for registro in     (        
    
          select distinct
              MAX(f.DATA_PONTO) DATA_PONTO,
              P.COD_IDE_CLI, 
              P.Nom_Pessoa_Fisica,
              P.NUM_CPF,
              F.NUM_MATRICULA,
              F.DAT_ASS_SERV,
              F.FLG_ASSINATURA_RESP,
              F.ID_GED_ORIGINAL 
        from  tb_orgao_responsavel rp 
        join  tb_lotacao l on l.cod_orgao = rp.cod_orgao
        join  TB_FREQUENCIA F on f.cod_ide_cli = l.cod_ide_cli
        join  TB_PESSOA_FISICA P on P.COD_IDE_CLI = F.COD_IDE_CLI
        where rp.cod_ide_cli =   p_cod_ide_clI
        and   rp.FLG_STATUS = 'V' or  rp.FLG_STATUS is null
        and   f.flg_assinatura_serv = 'S' and (f.flg_assinatura_resp <> 'S' or f.flg_assinatura_resp is null)
        and   (l.dat_fim is null or l.dat_fim >= sysdate)   
     group by 
                P.COD_IDE_CLI, 
                P.Nom_Pessoa_Fisica,
                P.NUM_CPF,
                F.NUM_MATRICULA,
                F.DAT_ASS_SERV,
                F.FLG_ASSINATURA_RESP,
                F.ID_GED_ORIGINAL 
     
       )loop
              
       v_dados_documento_pend_ass_2.v_data_ponto          := registro.DATA_PONTO;
       v_dados_documento_pend_ass_2.V_COD_IDE_CLI         := registro.COD_IDE_CLI;
       v_dados_documento_pend_ass_2.v_Nome_servidor       := registro.Nom_Pessoa_Fisica;
       v_dados_documento_pend_ass_2.V_CPF                 := registro.NUM_CPF;
       v_dados_documento_pend_ass_2.V_NUM_MATRICULA       := registro.NUM_MATRICULA;
       v_dados_documento_pend_ass_2.v_data_assinatura     := registro.DAT_ASS_SERV;
       v_dados_documento_pend_ass_2.v_flg_ass_responsavel := registro.FLG_ASSINATURA_RESP;
       v_dados_documento_pend_ass_2.V_ID_DOCUMENTO_GED    := registro.ID_GED_ORIGINAL;
   
       
         pipe row(v_dados_documento_pend_ass_2);       
        end loop;
      end if;
     end loop;
  end;  

END  PAC_FERIAS;
/
