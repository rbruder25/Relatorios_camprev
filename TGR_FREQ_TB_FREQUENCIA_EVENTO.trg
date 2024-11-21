CREATE OR REPLACE TRIGGER TGR_FREQ_TB_FREQUENCIA_EVENTO
  FOR INSERT OR UPDATE OR DELETE ON TB_FREQUENCIA_EVENTO
  
  COMPOUND TRIGGER
    
  --CURSOR PRINCIPAL - INICIO
    type rec_vinc is record
      (num_seq                      NUMBER,
       cod_ins                      NUMBER(8),
       cod_ide_cli                  VARCHAR2(20),
       cod_entidade                 NUMBER(8),
       num_matricula                VARCHAR2(20),
       cod_ide_rel_func             NUMBER(20),
       num_pis                      VARCHAR2(20),
       data_ponto                   DATE,
       cod_evento                   VARCHAR2(2),
       cod_justificativa            VARCHAR2(2),
       dat_ing                      DATE,
       dat_ult_atu                  DATE,
       nom_usu_ult_atu              VARCHAR2(40),
       nom_pro_ult_atu              VARCHAR2(40),
       compl_justificativa          VARCHAR2(4000),
       hora_inicial                 VARCHAR2(5),
       hora_final                   VARCHAR2(5),
       num_seq_afast                NUMBER(8),
       id_gozo_ferias               NUMBER,
       id_feriado                   NUMBER,
       id_gozo_lp                   NUMBER,
       id_gozo_recesso              NUMBER,
       flg_meio_periodo             CHAR(1),
       tipo_evento                  VARCHAR2(20),
       origem                       VARCHAR2(20),
       podeDeletar                  boolean,
       num_seq_anterior             NUMBER,
       cod_ins_anterior             NUMBER(8),
       cod_ide_cli_anterior         VARCHAR2(20),
       cod_entidade_anterior        NUMBER(8),
       num_matricula_anterior       VARCHAR2(20),
       cod_ide_rel_func_anterior    NUMBER(20),
       data_ponto_anterior          DATE,
       Num_reg_delete               number 
      );
    
      type typ_vinc is table of rec_vinc;
      v_typ_vinc typ_vinc := typ_vinc();
      
    -------
    --
    -------


  --CURSORES DE DELETE - INICIO
    type rec_reg_2 is record
      (cod_pccs        tb_relacao_funcional.cod_pccs%type,
       cod_cargo       tb_relacao_funcional.cod_cargo%type,
       num_matricula   tb_afastamento.num_matricula%type,
       dat_ini_afast   tb_afastamento.dat_ini_afast%type,
       dat_ret_prev    tb_afastamento.dat_ret_prev%type,
       dat_ret_efeito  tb_afastamento.dat_ret_efetivo%type,
       flg_integral    tb_motivo_afastamento.flg_integral%type,
       Num_reg_delete  number 
    );
    type typ_reg_2 is table of rec_reg_2;
    v_typ_reg_2 typ_reg_2 := typ_reg_2();    
    
    -------
    --
    -------
    
    type rec_reg_3 is record
      (cod_pccs        tb_relacao_funcional.cod_pccs%type,
       cod_cargo       tb_relacao_funcional.cod_cargo%type,
       num_matricula   tb_afastamento.num_matricula%type,
       dat_ini_afast   tb_afastamento.dat_ini_afast%type,
       dat_ret_prev    tb_afastamento.dat_ret_prev%type,
       dat_ret_efeito  tb_afastamento.dat_ret_efetivo%type,
       flg_integral    tb_motivo_afastamento.flg_integral%type,
       Num_reg_delete  number 
    );
    type typ_reg_3 is table of rec_reg_3;
    v_typ_reg_3 typ_reg_3 := typ_reg_3();   
    
    -------
    --
    -------
    
    type rec_reg_4 is record
    (cod_pccs        tb_relacao_funcional.cod_pccs%type,
     cod_cargo       tb_relacao_funcional.cod_cargo%type,
     num_matricula   tb_afastamento.num_matricula%type,
     dat_ini_afast   tb_afastamento.dat_ini_afast%type,
     dat_ret_prev    tb_afastamento.dat_ret_prev%type,
     dat_ret_efeito  tb_afastamento.dat_ret_efetivo%type,
     flg_integral    tb_motivo_afastamento.flg_integral%type,
     Num_reg_delete  number 
    );
    type typ_reg_4 is table of rec_reg_4;
    v_typ_reg_4 typ_reg_4 := typ_reg_4(); 
    
    -------
    --
    -------  
    
    type rec_reg_5 is record
    (cod_pccs        tb_relacao_funcional.cod_pccs%type,
     cod_cargo       tb_relacao_funcional.cod_cargo%type,
     num_matricula   tb_afastamento.num_matricula%type,
     dat_ini_afast   tb_afastamento.dat_ini_afast%type,
     dat_ret_prev    tb_afastamento.dat_ret_prev%type,
     dat_ret_efeito  tb_afastamento.dat_ret_efetivo%type,
     flg_integral    tb_motivo_afastamento.flg_integral%type,
     Num_reg_delete  number 
    );
    type typ_reg_5 is table of rec_reg_5;
    v_typ_reg_5 typ_reg_5 := typ_reg_5();   
    
    v_Num_reg_delete  NUMBER:=0;
    v_processo_delete boolean;
    
  BEFORE EACH ROW IS
     i NUMBER; --indice da collection

BEGIN
         -- Carrega Cursos de Linhas modificada e incluidas 
    
         v_typ_vinc.extend();
         i := v_typ_vinc.last;
         v_typ_vinc(i).num_seq              :=:NEW.num_seq;
         v_typ_vinc(i).cod_ins              :=:NEW.cod_ins;
         v_typ_vinc(i).cod_ide_cli          :=:NEW.cod_ide_cli;
         v_typ_vinc(i).cod_entidade         :=:NEW.cod_entidade;
         v_typ_vinc(i).num_matricula        :=:NEW.num_matricula;
         v_typ_vinc(i).cod_ide_rel_func     :=:NEW.cod_ide_rel_func;
         v_typ_vinc(i).num_pis              :=:NEW.num_pis;
         v_typ_vinc(i).data_ponto           :=:NEW.data_ponto;
         v_typ_vinc(i).cod_evento           :=:NEW.cod_evento;
         v_typ_vinc(i).cod_justificativa    :=:NEW.cod_justificativa;
         v_typ_vinc(i).dat_ing              :=:NEW.dat_ing;
         v_typ_vinc(i).dat_ult_atu          :=:NEW.dat_ult_atu;
         v_typ_vinc(i).nom_usu_ult_atu      :=:NEW.nom_usu_ult_atu;
         v_typ_vinc(i).nom_pro_ult_atu      :=:NEW.nom_pro_ult_atu;
         v_typ_vinc(i).compl_justificativa  :=:NEW.compl_justificativa;
         v_typ_vinc(i).hora_inicial         :=:NEW.hora_inicial;
         v_typ_vinc(i).hora_final           :=:NEW.hora_final;
         v_typ_vinc(i).num_seq_afast        :=:NEW.num_seq_afast;
         v_typ_vinc(i).id_gozo_ferias       :=:NEW.id_gozo_ferias;
         v_typ_vinc(i).id_feriado           :=:NEW.id_feriado;
         v_typ_vinc(i).id_gozo_lp           :=:NEW.id_gozo_lp;
         v_typ_vinc(i).id_gozo_recesso      :=:NEW.id_gozo_recesso;
         v_typ_vinc(i).flg_meio_periodo     :=:NEW.flg_meio_periodo;
             
         if(inserting) then
          v_typ_vinc(i).tipo_evento          := 1;
         end if;
         if(updating) then
          v_typ_vinc(i).tipo_evento          := 2;
          v_typ_vinc(i).data_ponto_anterior  :=:OLD.data_ponto;
         end if;
         if(deleting AND :OLD.NOM_PRO_ULT_ATU <> 'TRIGGER') then
          v_typ_vinc(i).tipo_evento          := 3;
          v_Num_reg_delete                   :=v_Num_reg_delete   +1;
          v_typ_vinc(i).data_ponto_anterior  :=:OLD.data_ponto;
          v_typ_vinc(i).num_seq_anterior     :=:OLD.NUM_SEQ_AFAST;
         end if;
             
         IF :NEW.NOM_PRO_ULT_ATU = 'ManutencaoFrequenciaService' THEN
            v_typ_vinc(i).origem             := 1;
         ELSE
           v_typ_vinc(i).origem              := 2;
         END IF;
       
        ----
       IF(DELETING) THEN
             for reg_2 in (
                    
                      select R.COD_PCCS,
                             R.COD_CARGO,
                             AFA.NUM_MATRICULA,
                             AFA.DAT_INI_AFAST,
                             AFA.DAT_RET_PREV,
                             AFA.DAT_RET_EFETIVO,
                             MA.FLG_INTEGRAL
                        from tb_relacao_funcional  r,
                             TB_AFASTAMENTO        AFA,
                             TB_MOTIVO_AFASTAMENTO MA
                       where R.COD_INS             =:OLD.COD_INS
                         and r.cod_ide_cli         =:OLD.COD_IDE_CLI
                         and r.num_matricula       =:OLD.NUM_MATRICULA
                         and r.cod_ide_rel_func    =:OLD.COD_IDE_REL_FUNC
                         and r.cod_entidade        =:OLD.COD_ENTIDADE
                         AND AFA.COD_INS           = R.COD_INS
                         AND AFA.NUM_MATRICULA     = R.NUM_MATRICULA
                         AND AFA.COD_IDE_CLI       = R.COD_IDE_CLI
                         AND AFA.COD_IDE_REL_FUNC  = R.COD_IDE_REL_FUNC
                         AND AFA.COD_ENTIDADE      = R.COD_ENTIDADE
                         AND AFA.NUM_SEQ_AFAST     =:OLD.NUM_SEQ_AFAST
                         AND AFA.COD_MOT_AFAST     = MA.COD_MOT_AFAST
                         AND AFA.DAT_INI_AFAST     < =:OLD.data_ponto
                         AND AFA.DAT_RET_PREV      > =:OLD.data_ponto
                         AND AFA.NOM_PRO_ULT_ATU   != 'TRIGGER'
             )
             loop
                       v_typ_reg_2.extend();
                       i := v_typ_reg_2.last;
                       v_typ_reg_2(i).cod_pccs        := reg_2.COD_PCCS;
                       v_typ_reg_2(i).COD_CARGO       := reg_2.COD_CARGO;
                       v_typ_reg_2(i).num_matricula   := reg_2.num_matricula;
                       v_typ_reg_2(i).dat_ini_afast   := reg_2.dat_ini_afast;
                       v_typ_reg_2(i).dat_ret_prev    := reg_2.dat_ret_prev;
                       v_typ_reg_2(i).dat_ret_efeito  := reg_2.dat_ret_efetivo;
                       v_typ_reg_2(i).flg_integral    := reg_2.flg_integral;
                       v_typ_reg_2(i).Num_reg_delete  := v_Num_reg_delete;
             end loop; 
      
             for reg_3 in (
                    
                          select R.COD_PCCS,
                                 R.COD_CARGO,
                                 AFA.NUM_MATRICULA,
                                 AFA.DAT_INI_AFAST,
                                 AFA.DAT_RET_PREV,
                                 AFA.DAT_RET_EFETIVO,
                                 MA.FLG_INTEGRAL
                            from tb_relacao_funcional  r,
                                 TB_AFASTAMENTO        AFA,
                                 TB_MOTIVO_AFASTAMENTO MA
                           where R.COD_INS             =:OLD.COD_INS
                             and r.cod_ide_cli         =:OLD.COD_IDE_CLI
                             and r.num_matricula       =:OLD.NUM_MATRICULA
                             and r.cod_ide_rel_func    =:OLD.COD_IDE_REL_FUNC 
                             and r.cod_entidade        =:OLD.COD_ENTIDADE
                             AND AFA.COD_INS           = R.COD_INS
                             AND AFA.NUM_MATRICULA     = R.NUM_MATRICULA
                             AND AFA.COD_IDE_CLI       = R.COD_IDE_CLI
                             AND AFA.COD_IDE_REL_FUNC  = R.COD_IDE_REL_FUNC
                             AND AFA.COD_ENTIDADE      = R.COD_ENTIDADE
                             AND AFA.NUM_SEQ_AFAST     =:OLD.NUM_SEQ_AFAST
                             AND AFA.COD_MOT_AFAST     = MA.COD_MOT_AFAST
                             AND AFA.DAT_INI_AFAST     =:OLD.data_ponto
                             AND AFA.DAT_RET_PREV    > =:OLD.data_ponto
                             AND AFA.NOM_PRO_ULT_ATU   != 'TRIGGER'
             )
             loop
                       v_typ_reg_3.extend();
                       i := v_typ_reg_3.last;
                       v_typ_reg_3(i).cod_pccs        := reg_3.COD_PCCS;
                       v_typ_reg_3(i).COD_CARGO       := reg_3.COD_CARGO;
                       v_typ_reg_3(i).num_matricula   := reg_3.num_matricula;
                       v_typ_reg_3(i).dat_ini_afast   := reg_3.dat_ini_afast;
                       v_typ_reg_3(i).dat_ret_prev    := reg_3.dat_ret_prev;
                       v_typ_reg_3(i).dat_ret_efeito  := reg_3.dat_ret_efetivo;
                       v_typ_reg_3(i).flg_integral    := reg_3.flg_integral;
                       v_typ_reg_3(i).Num_reg_delete  := v_Num_reg_delete;
             end loop; 
             
             
             for reg_4 in (
                    
                            select R.COD_PCCS,
                                   R.COD_CARGO,
                                   AFA.NUM_MATRICULA,
                                   AFA.DAT_INI_AFAST,
                                   AFA.DAT_RET_PREV,
                                   AFA.DAT_RET_EFETIVO,
                                   MA.FLG_INTEGRAL
                              from tb_relacao_funcional  r,
                                   TB_AFASTAMENTO        AFA,
                                   TB_MOTIVO_AFASTAMENTO MA
                             where R.COD_INS             =:OLD.COD_INS
                               and r.cod_ide_cli         =:OLD.COD_IDE_CLI
                               and r.num_matricula       =:OLD.NUM_MATRICULA
                               and r.cod_ide_rel_func    =:OLD.COD_IDE_REL_FUNC 
                               and r.cod_entidade        =:OLD.COD_ENTIDADE
                               AND AFA.COD_INS           = R.COD_INS
                               AND AFA.NUM_MATRICULA     = R.NUM_MATRICULA
                               AND AFA.COD_IDE_CLI       = R.COD_IDE_CLI
                               AND AFA.COD_IDE_REL_FUNC  = R.COD_IDE_REL_FUNC
                               AND AFA.COD_ENTIDADE      = R.COD_ENTIDADE
                               AND AFA.NUM_SEQ_AFAST     =:OLD.NUM_SEQ_AFAST
                               AND AFA.COD_MOT_AFAST     = MA.COD_MOT_AFAST
                               AND AFA.DAT_INI_AFAST   < =:OLD.data_ponto
                               AND AFA.DAT_RET_PREV      =:OLD.data_ponto
                               AND AFA.NOM_PRO_ULT_ATU   != 'TRIGGER'
             )
             loop
                       v_typ_reg_4.extend();
                       i := v_typ_reg_4.last;
                       v_typ_reg_4(i).cod_pccs        := reg_4.COD_PCCS;
                       v_typ_reg_4(i).COD_CARGO       := reg_4.COD_CARGO;
                       v_typ_reg_4(i).num_matricula   := reg_4.num_matricula;
                       v_typ_reg_4(i).dat_ini_afast   := reg_4.dat_ini_afast;
                       v_typ_reg_4(i).dat_ret_prev    := reg_4.dat_ret_prev;
                       v_typ_reg_4(i).dat_ret_efeito  := reg_4.dat_ret_efetivo;
                       v_typ_reg_4(i).flg_integral    := reg_4.flg_integral;
                       v_typ_reg_4(i).Num_reg_delete  := v_Num_reg_delete;
             end loop; 
             
             
             for reg_5 in (
                    
                            select R.COD_PCCS,
                                   R.COD_CARGO,
                                   AFA.NUM_MATRICULA,
                                   AFA.DAT_INI_AFAST,
                                   AFA.DAT_RET_PREV,
                                   AFA.DAT_RET_EFETIVO,
                                   MA.FLG_INTEGRAL
                              from tb_relacao_funcional  r,
                                   TB_AFASTAMENTO        AFA,
                                   TB_MOTIVO_AFASTAMENTO MA
                             where R.COD_INS             =:OLD.COD_INS
                               and r.cod_ide_cli         =:OLD.COD_IDE_CLI 
                               and r.num_matricula       =:OLD.NUM_MATRICULA
                               and r.cod_ide_rel_func    =:OLD.COD_IDE_REL_FUNC 
                               and r.cod_entidade        =:OLD.COD_ENTIDADE
                               AND AFA.COD_INS           = R.COD_INS
                               AND AFA.NUM_MATRICULA     = R.NUM_MATRICULA
                               AND AFA.COD_IDE_CLI       = R.COD_IDE_CLI
                               AND AFA.COD_IDE_REL_FUNC  = R.COD_IDE_REL_FUNC
                               AND AFA.COD_ENTIDADE      = R.COD_ENTIDADE
                               AND AFA.NUM_SEQ_AFAST     =:OLD.NUM_SEQ_AFAST
                               AND AFA.COD_MOT_AFAST     = MA.COD_MOT_AFAST
                               AND AFA.DAT_INI_AFAST     =:OLD.data_ponto
                               AND AFA.DAT_RET_PREV      =:OLD.data_ponto
                               AND AFA.NOM_PRO_ULT_ATU   != 'TRIGGER'
             )
             loop
                       v_typ_reg_5.extend();
                       i := v_typ_reg_5.last;
                       v_typ_reg_5(i).cod_pccs        := reg_5.COD_PCCS;
                       v_typ_reg_5(i).COD_CARGO       := reg_5.COD_CARGO;
                       v_typ_reg_5(i).num_matricula   := reg_5.num_matricula;
                       v_typ_reg_5(i).dat_ini_afast   := reg_5.dat_ini_afast;
                       v_typ_reg_5(i).dat_ret_prev    := reg_5.dat_ret_prev;
                       v_typ_reg_5(i).dat_ret_efeito  := reg_5.dat_ret_efetivo;
                       v_typ_reg_5(i).flg_integral    := reg_5.flg_integral;
                       v_typ_reg_5(i).Num_reg_delete  := v_Num_reg_delete;
             end loop; 
    END IF;   
 
     
   END BEFORE EACH ROW;
  
  AFTER STATEMENT IS
     v_cod_pccs   NUMBER;
     v_cod_cargo  NUMBER;
     NumTeste     NUMBER := 0;
  
  BEGIN
  
  
    for i in v_typ_vinc.first ..v_typ_vinc.last loop  
         v_processo_delete:=false;
       if not (v_typ_vinc(i).tipo_evento in (1,2) and  nvl(v_typ_vinc(i).cod_evento,0) in (16,96,97, 95)) then  
          
          IF (v_typ_vinc(i).tipo_evento = 1 and v_typ_vinc(i).origem = 1) THEN 
       
                 select R.COD_PCCS, R.COD_CARGO
                    into v_cod_pccs, v_cod_cargo
                    from tb_relacao_funcional r
                 where r.cod_ins          = v_typ_vinc(i).cod_ins
                   and r.cod_ide_cli      = v_typ_vinc(i).COD_IDE_CLI
                   and r.num_matricula    = v_typ_vinc(i).NUM_MATRICULA
                   and r.cod_ide_rel_func = v_typ_vinc(i).COD_IDE_REL_FUNC
                   and r.cod_entidade     = v_typ_vinc(i).COD_ENTIDADE;

       
                   INSERT INTO TB_AFASTAMENTO
                      (COD_INS,
                       COD_IDE_CLI,
                       COD_ENTIDADE,
                       COD_PCCS,
                       COD_CARGO,
                       NUM_MATRICULA,
                       COD_IDE_REL_FUNC,
                       NUM_SEQ_AFAST,
                       COD_MOT_AFAST,
                       DAT_INI_AFAST,
                       DAT_RET_PREV,
                       DAT_RET_EFETIVO,
                       COD_RET_AFAST,
                       DAT_ING,
                       DAT_ULT_ATU,
                       NOM_USU_ULT_ATU,
                       NOM_PRO_ULT_ATU,
                       DES_MOTIVO_AUDIT,
                       HORA_INICIAL,
                       HORA_FINAL,
                       COD_JUSTIFICATIVA
                       )

                    VALUES
                      (v_typ_vinc(i).COD_INS,
                       v_typ_vinc(i).cod_ide_cli,
                       v_typ_vinc(i).COD_ENTIDADE,
                       v_cod_pccs,
                       v_cod_cargo,
                       v_typ_vinc(i).NUM_MATRICULA,
                       v_typ_vinc(i).COD_IDE_REL_FUNC,
                       v_typ_vinc(i).NUM_SEQ_AFAST,
                       v_typ_vinc(i).COD_EVENTO,
                       v_typ_vinc(i).DATA_PONTO,
                       v_typ_vinc(i).DATA_PONTO,
                       CASE
                         WHEN (SELECT MA.FLG_INTEGRAL
                                 FROM TB_MOTIVO_AFASTAMENTO MA
                                WHERE MA.COD_MOT_AFAST = v_typ_vinc(i).COD_EVENTO) = 'S' THEN
                          v_typ_vinc(i).DATA_PONTO + 1

                         ELSE
                          v_typ_vinc(i).DATA_PONTO
                       END,
                       '1', -- MOTIVO RETORNO - PORTARIA | AGUARDANDO CLIENTE
                       SYSDATE,
                       SYSDATE,
                       USER,
                       'TRIGGER',
                       (select co.des_descricao
                          from tb_codigo co
                         where co.cod_ins = 0
                           and co.cod_num = 10095
                           and co.cod_par = v_typ_vinc(i).cod_justificativa) || '; ' ||
                       v_typ_vinc(i).compl_justificativa,
                       v_typ_vinc(i).HORA_INICIAL,
                       v_typ_vinc(i).HORA_FINAL,
                       v_typ_vinc(i).COD_JUSTIFICATIVA
                       );
                       
                 elsif (v_typ_vinc(i).tipo_evento = 2 and v_typ_vinc(i).origem = 1) THEN 
                    
                       IF v_typ_vinc(i).DATA_PONTO = v_typ_vinc(i).data_ponto_anterior  

                         THEN

                          UPDATE TB_AFASTAMENTO AFA
                             SET AFA.COD_MOT_AFAST    =  v_typ_vinc(i).COD_EVENTO,
                                 AFA.DES_MOTIVO_AUDIT =  v_typ_vinc(i).COMPL_JUSTIFICATIVA,
                                 AFA.HORA_INICIAL     =  v_typ_vinc(i).HORA_INICIAL,
                                 AFA.HORA_FINAL       =  v_typ_vinc(i).HORA_FINAL,
                                 AFA.DAT_ULT_ATU      =  SYSDATE,
                                 AFA.NOM_USU_ULT_ATU  =  v_typ_vinc(i).NOM_USU_ULT_ATU,
                                 AFA.NOM_PRO_ULT_ATU  =  'ManutencaoFrequenciaService',
                                 AFA.COD_JUSTIFICATIVA = v_typ_vinc(i).COD_JUSTIFICATIVA

                           WHERE AFA.NUM_SEQ_AFAST = v_typ_vinc(i).NUM_SEQ_AFAST;

                        END IF;
             end if;
             
             IF v_typ_vinc(i).tipo_evento = 3 THEN
               begin
                  NumTeste := NumTeste+1;
                 for x in v_typ_reg_2.first ..v_typ_reg_2.last loop  
                      IF (v_typ_reg_2(x).num_matricula IS NOT NULL) AND v_typ_reg_2(x).Num_reg_delete = v_typ_vinc(i).Num_reg_delete then
                        raise_application_error(-20000,'sistema Nao permite registros do meio');
                       END IF;
                End loop;
                EXCEPTION
                WHEN OTHERS THEN
                  
                Raise_application_error(-20323,'ERRO NO PRIMEIRO DELETE - '||sqlerrm);
                end;
                
                
                
                
                if not v_processo_delete then
                  BEGIN
                  for x in v_typ_reg_3.first ..v_typ_reg_3.last loop  
                    IF (v_typ_reg_3(x).num_matricula IS NOT NULL) AND v_typ_reg_3(x).Num_reg_delete = v_typ_vinc(i).Num_reg_delete then
                      
                        UPDATE TB_AFASTAMENTO AFA
                           SET AFA.DAT_INI_AFAST   = v_typ_vinc(i).data_ponto_anterior + 1,
                               AFA.DAT_ULT_ATU     = SYSDATE,
                               AFA.NOM_USU_ULT_ATU = user,
                               AFA.NOM_PRO_ULT_ATU = 'ManutencaoFrequenciaService'
                         WHERE AFA.NUM_SEQ_AFAST   = v_typ_vinc(i).num_seq_anterior;
                    
                    end if;
                    v_processo_delete := true;
                  END LOOP;
                  
                  
                                  EXCEPTION
                WHEN OTHERS THEN
                  
                Raise_application_error(-20323,'ERRO NO PRIMEIRO DELETE - '||sqlerrm);
                end;
                end if;
                

                
                
                
                if not v_processo_delete then
                  BEGIN
                  for x in v_typ_reg_4.first ..v_typ_reg_4.last loop 
                    IF (v_typ_reg_4(x).num_matricula IS NOT NULL) AND v_typ_reg_4(x).Num_reg_delete = v_typ_vinc(i).Num_reg_delete then
                      NumTeste := NumTeste+1;
                      
                      UPDATE TB_AFASTAMENTO AFA
                         SET AFA.DAT_RET_PREV    = v_typ_vinc(i).data_ponto_anterior - 1,
                             AFA.DAT_RET_EFETIVO = CASE
                                                     WHEN v_typ_reg_4(x).FLG_INTEGRAL = 'S' THEN
                                                       v_typ_vinc(i).data_ponto_anterior
                                                     ELSE
                                                      v_typ_vinc(i).data_ponto_anterior - 1
                                                   END,
                             AFA.DAT_ULT_ATU     = SYSDATE,
                             AFA.NOM_USU_ULT_ATU = user,
                             AFA.NOM_PRO_ULT_ATU = 'ManutencaoFrequenciaService'
                       WHERE AFA.NUM_SEQ_AFAST   = v_typ_vinc(i).NUM_SEQ_AFAST;                      
                      
                    end if;
                    v_processo_delete := true;
                  END LOOP;
                                 EXCEPTION
                WHEN OTHERS THEN
                  
                Raise_application_error(-20323,'ERRO NO SEGUNDO DELETE - '||sqlerrm);
                end;
                end if;
                

                
                if not v_processo_delete then
                  BEGIN
                  for x in v_typ_reg_5.first ..v_typ_reg_5.last loop 
                     IF (v_typ_reg_5(x).num_matricula IS NOT NULL) AND v_typ_reg_5(x).Num_reg_delete = v_typ_vinc(i).Num_reg_delete then
                        --
                        NumTeste := NumTeste+1;

                        UPDATE TB_AFASTAMENTO AFA
                           SET AFA.NOM_PRO_ULT_ATU = 'TRIGGER'
                         WHERE AFA.NUM_SEQ_AFAST   = v_typ_vinc(i).NUM_SEQ_AFAST;

                        DELETE TB_AFASTAMENTO AFA
                         WHERE AFA.NUM_SEQ_AFAST   = v_typ_vinc(i).NUM_SEQ_AFAST;
                     end if;
                  END LOOP;
                                 EXCEPTION
                WHEN OTHERS THEN
                  
                Raise_application_error(-20323,'ERRO NO TERCEIRO DELETE - '||sqlerrm);
                end;
                end if;
             end if;
           end if;
        end loop;
        
       EXCEPTION
        
     WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20322,'INVALIDA ATUALIZAÇÃO NA TABELA TB_FREQUENCIA_EVENTO - '||sqlerrm);
    WHEN OTHERS THEN
      Raise_application_error(-20323,'INVALIDA ATUALIZAÇÃO NA TABELA TB_FREQUENCIA_EVENTO - '||sqlerrm);
   

  END AFTER STATEMENT;  
END;
/
