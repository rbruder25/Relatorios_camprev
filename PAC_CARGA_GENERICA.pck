CREATE OR REPLACE PACKAGE PAC_CARGA_GENERICA is

    -----------------------------------------------------------------------------------------------
    -- Descricao: Package de rotinas utilizadas na carga de dados de acordo com
    -- Protocolo de Informac?es Cadastrais (CAMPREV)
    --

    -- Constantes
    COD_GRU_AFAST            constant number := 1;     -- Grupo de Motivo de Afastamento maior que 15
    ID_INSCRICAO_PERITO      constant number := 37118; -- Perito padrão responsável


    erro_grava_status EXCEPTION;
    row_locked        EXCEPTION;

    TYPE R_ENT IS RECORD
        (cod_ins               tb_carga_gen_ent.cod_ins%type,
         cod_entidade          tb_carga_gen_ent.cod_entidade%type,
         num_cnpj              tb_carga_gen_ent.num_cnpj%type,
         nom_entidade          tb_carga_gen_ent.nom_entidade%type,
         des_sigla             tb_carga_gen_ent.des_sigla%type,
         cod_poder             tb_carga_gen_ent.cod_poder%type,
         cod_poder_int         tb_codigo_ext.cod_par%type,
         cod_esfera            tb_carga_gen_ent.cod_esfera%type,
         cod_esfera_int        tb_codigo_ext.cod_par%type,
         cod_tipo_entidade     tb_carga_gen_ent.cod_tipo_entidade%type,
         cod_tipo_entidade_int tb_codigo_ext.cod_par%type,
         id                    tb_carga_gen_ent.id%type,
         num_linha_header      tb_carga_gen_ent.num_linha_header%type,
         id_processo           tb_carga_gen_ent.id_processo%type);

    TYPE R_ORG IS RECORD
        (cod_ins                    tb_carga_gen_org.cod_ins%type,
         cod_entidade               tb_carga_gen_org.cod_entidade%type,
         cod_orgao_ext              tb_carga_gen_org.cod_orgao_ext%type,
         des_sigla                  tb_carga_gen_org.des_sigla%type,
         nom_orgao                  tb_carga_gen_org.nom_orgao%type,
         cod_orgao_nivel_sup        tb_carga_gen_org.cod_orgao_nivel_sup%type,
         des_sigla_orgao_nivel_sup  tb_carga_gen_org.des_sigla_orgao_nivel_sup%type,
         flg_uni_orc                tb_carga_gen_org.flg_uni_orc%type,
         cod_tipo_orgao             tb_carga_gen_org.cod_tipo_orgao%type,
         cod_tipo_orgao_int         tb_codigo_ext.cod_par%type,
         cod_nju_cri                tb_carga_gen_org.cod_nju_cri%type,
         cod_nju_ext                tb_carga_gen_org.cod_nju_ext%type,
         num_cnpj                   tb_carga_gen_org.num_cnpj%type,
         num_insc_est               tb_carga_gen_org.num_insc_est%type,
         num_insc_mun               tb_carga_gen_org.num_insc_mun%type,
         dat_ini_vig                tb_carga_gen_org.dat_ini_vig%type,
         dat_fim_vig                tb_carga_gen_org.dat_fim_vig%type,
         cod_status_orgao           tb_carga_gen_org.cod_status_orgao%type,
         cod_status_orgao_int       tb_codigo_ext.cod_par%type,
         nom_contato                tb_carga_gen_org.nom_contato%type,
         des_cargo_contato          tb_carga_gen_org.des_cargo_contato%type,
         num_tel_1                  tb_carga_gen_org.num_tel_1%type,
         num_ramal_tel_1            tb_carga_gen_org.num_ramal_tel_1%type,
         num_tel_2                  tb_carga_gen_org.num_tel_2%type,
         num_ramal_tel_2            tb_carga_gen_org.num_ramal_tel_2%type,
         num_tel_3                  tb_carga_gen_org.num_tel_3%type,
         num_ramal_tel_3            tb_carga_gen_org.num_ramal_tel_3%type,
         cod_nat_jur                tb_carga_gen_org.cod_nat_jur%type,
         cod_nat_jur_int            tb_codigo_ext.cod_par%type,
         id                         tb_carga_gen_org.id%type,
         num_linha_header           tb_carga_gen_org.num_linha_header%type,
         id_processo                tb_carga_gen_org.id_processo%type,
         cod_orgao_nivel_sup_org    tb_orgao.cod_orgao%type);

    TYPE R_IFS IS RECORD
        (cod_ins                        tb_carga_gen_ifs.cod_ins%type,
         id_header                      tb_carga_gen_ifs.id_header%type,
         cod_entidade                   tb_carga_gen_ifs.cod_entidade%type,
         id_servidor                    tb_carga_gen_ifs.id_servidor%type,
         dat_nasc                       tb_carga_gen_ifs.dat_nasc%type,
         cod_sexo                       tb_carga_gen_ifs.cod_sexo%type,
         cod_nacio                      tb_carga_gen_ifs.cod_nacio%type,
         cod_nacio_int                  tb_codigo_ext.cod_par%type,
         cod_uf_nasc                    tb_carga_gen_ifs.cod_uf_nasc%type,
         des_natural                    tb_carga_gen_ifs.des_natural%type,
         cod_raca                       tb_carga_gen_ifs.cod_raca%type,
         cod_raca_int                   tb_codigo_ext.cod_par%type,
         cod_profissao                  tb_carga_gen_ifs.cod_profissao%type,
         nom_servidor                   tb_carga_gen_ifs.nom_servidor%type,
         dat_obito                      tb_carga_gen_ifs.dat_obito%type,
         dat_emi_atest_obito            tb_carga_gen_ifs.dat_emi_atest_obito%type,
         nom_resp_obito                 tb_carga_gen_ifs.nom_resp_obito%type,
         cod_tipo_atest_obito           tb_carga_gen_ifs.cod_tipo_atest_obito%type,
         cod_tipo_atest_obito_int       tb_codigo_ext.cod_par%type,
         num_crm_obito                  tb_carga_gen_ifs.num_crm_obito%type,
         nom_mae                        tb_carga_gen_ifs.nom_mae%type,
         nom_pai                        tb_carga_gen_ifs.nom_pai%type,
         num_cpf_mae                    tb_carga_gen_ifs.num_cpf_mae%type,
         num_cpf_pai                    tb_carga_gen_ifs.num_cpf_pai%type,
         cod_est_civ                    tb_carga_gen_ifs.cod_est_civ%type,
         cod_est_civ_int                tb_codigo_ext.cod_par%type,
         num_cert_reserv                tb_carga_gen_ifs.num_cert_reserv%type,
         dat_emi_cert_reserv            tb_carga_gen_ifs.dat_emi_cert_reserv%type,
         num_cert_alist_milit           tb_carga_gen_ifs.num_cert_alist_milit%type,
         dat_emi_cert_alist_milit       tb_carga_gen_ifs.dat_emi_cert_alist_milit%type,
         cod_situ_milit                 tb_carga_gen_ifs.cod_situ_milit%type,
         cod_situ_milit_int             tb_codigo_ext.cod_par%type,
         cod_escolaridade               tb_carga_gen_ifs.cod_escolaridade%type,
         cod_escolaridade_int           tb_codigo_ext.cod_par%type,
         cod_reg_casamento              tb_carga_gen_ifs.cod_reg_casamento%type,
         cod_reg_casamento_int          tb_codigo_ext.cod_par%type,
         ano_cheg_pais                  tb_carga_gen_ifs.ano_cheg_pais%type,
         num_tel_residencial            tb_carga_gen_ifs.num_tel_residencial%type,
         tip_num_tel_1                  tb_pessoa_fisica.tip_num_tel_1%type,
         num_ramal_residencial          tb_carga_gen_ifs.num_ramal_residencial%type,
         num_tel_comercial              tb_carga_gen_ifs.num_tel_comercial%type,
         tip_num_tel_2                  tb_pessoa_fisica.tip_num_tel_2%type,
         num_ramal_comercial            tb_carga_gen_ifs.num_ramal_comercial%type,
         num_tel_contato                tb_carga_gen_ifs.num_tel_contato%type,
         tip_num_tel_3                  tb_pessoa_fisica.tip_num_tel_3%type,
         num_ramal_contato              tb_carga_gen_ifs.num_ramal_contato%type,
         des_email                      tb_carga_gen_ifs.des_email%type,
         num_rg                         tb_carga_gen_ifs.num_rg%type,
         sig_org_emi_rg                 tb_carga_gen_ifs.sig_org_emi_rg%type,
         nom_org_emi_rg                 tb_carga_gen_ifs.nom_org_emi_rg%type,
         cod_uf_emi_rg                  tb_carga_gen_ifs.cod_uf_emi_rg%type,
         dat_emi_rg                     tb_carga_gen_ifs.dat_emi_rg%type,
         num_tit_ele                    tb_carga_gen_ifs.num_tit_ele%type,
         num_zon_tit_ele                tb_carga_gen_ifs.num_zon_tit_ele%type,
         num_sec_ele                    tb_carga_gen_ifs.num_sec_ele%type,
         num_nit_inss                   tb_carga_gen_ifs.num_nit_inss%type,
         num_pis                        tb_carga_gen_ifs.num_pis%type,
         num_ctps                       tb_carga_gen_ifs.num_ctps%type,
         num_serie_ctps                 tb_carga_gen_ifs.num_serie_ctps%type,
         dat_emi_ctps                   tb_carga_gen_ifs.dat_emi_ctps%type,
         cod_uf_emi_ctps                tb_carga_gen_ifs.cod_uf_emi_ctps%type,
         num_cpf                        tb_carga_gen_ifs.num_cpf%type,
         nom_social                     tb_carga_gen_ifs.nom_social%type,
         cod_pais_nasc                  tb_carga_gen_ifs.cod_pais_nasc%type,
         cod_pais_nasc_int              tb_codigo_ext.cod_par%type,
         num_dni                        tb_carga_gen_ifs.num_dni%type,
         nom_org_emi_dni                tb_carga_gen_ifs.nom_org_emi_dni%type,
         dat_emi_dni                    tb_carga_gen_ifs.dat_emi_dni%type,
         num_rne                        tb_carga_gen_ifs.num_rne%type,
         nom_org_emi_rne                tb_carga_gen_ifs.nom_org_emi_rne%type,
         dat_emi_rne                    tb_carga_gen_ifs.dat_emi_rne%type,
         num_reg_cons_classe            tb_carga_gen_ifs.num_reg_cons_classe%type,
         nom_org_emi_reg_cons_classe    tb_carga_gen_ifs.nom_org_emi_reg_cons_classe%type,
         dat_emi_reg_cons_classe        tb_carga_gen_ifs.dat_emi_reg_cons_classe%type,
         dat_val_reg_cons_classe        tb_carga_gen_ifs.dat_val_reg_cons_classe%type,
         cod_cla_condtrab               tb_carga_gen_ifs.cod_cla_condtrab_estrangeiro%type,
         cod_cla_condtrab_int           tb_codigo_ext.cod_par%type,
         flg_conjuge_brasileiro         tb_carga_gen_ifs.flg_conjuge_brasileiro%type,
         flg_conjuge_brasileiro_int     tb_carga_gen_ifs.flg_conjuge_brasileiro%type,
         flg_filho_com_brasileiro       tb_carga_gen_ifs.flg_filho_com_brasileiro%type,
         flg_filho_com_brasileiro_int   tb_carga_gen_ifs.flg_filho_com_brasileiro%type,
         num_cnh                        tb_carga_gen_ifs.num_cnh%type,
         dat_emi_cnh                    tb_carga_gen_ifs.dat_emi_cnh%type,
         cod_uf_emi_cnh                 tb_carga_gen_ifs.cod_uf_emi_cnh%type,
         dat_val_cnh                    tb_carga_gen_ifs.dat_val_cnh%type,
         dat_first_cnh                  tb_carga_gen_ifs.dat_first_cnh%type,
         cat_cnh                        tb_carga_gen_ifs.cat_cnh%type,
         flg_def_fisica                 tb_carga_gen_ifs.flg_def_fisica%type,
         flg_def_fisica_int             tb_carga_gen_ifs.flg_def_fisica%type,
         flg_def_visual                 tb_carga_gen_ifs.flg_def_visual%type,
         flg_def_visual_int             tb_carga_gen_ifs.flg_def_visual%type,
         flg_def_auditiva               tb_carga_gen_ifs.flg_def_auditiva%type,
         flg_def_auditiva_int           tb_carga_gen_ifs.flg_def_auditiva%type,
         flg_def_mental                 tb_carga_gen_ifs.flg_def_mental%type,
         flg_def_mental_int             tb_carga_gen_ifs.flg_def_mental%type,
         flg_def_intelectual            tb_carga_gen_ifs.flg_def_intelectual%type,
         flg_def_intelectual_int        tb_carga_gen_ifs.flg_def_intelectual%type,
         flg_readaptado                 tb_carga_gen_ifs.flg_readaptado%type,
         flg_readaptado_int             tb_carga_gen_ifs.flg_readaptado%type,
         flg_cota_deficiencia           tb_carga_gen_ifs.flg_cota_deficiencia%type,
         flg_cota_deficiencia_int       tb_carga_gen_ifs.flg_cota_deficiencia%type,
         id                             tb_carga_gen_ifs.id%type,
         num_linha_header               tb_carga_gen_ifs.num_linha_header%type,
         id_processo                    tb_carga_gen_ifs.id_processo%type);

    TYPE R_IFD IS RECORD
        (cod_ins                        tb_carga_gen_ifd.cod_ins%type,
         id_header                      tb_carga_gen_ifd.id_header%type,
         cod_entidade                   tb_carga_gen_ifd.cod_entidade%type,
         id_servidor                    tb_carga_gen_ifd.id_servidor%type,
         num_seq_grupo_familiar         tb_carga_gen_ifd.num_seq_grupo_familiar%type,
         num_seq_dependente             tb_carga_gen_ifd.num_seq_dependente%type,
         cod_tipo_dependencia           tb_carga_gen_ifd.cod_tipo_dependencia%type,
         cod_tipo_dependencia_int       tb_codigo_ext.cod_par%type,
         dat_ini_dependencia            tb_carga_gen_ifd.dat_ini_dependencia%type,
         cod_moti_ini_dependencia       tb_carga_gen_ifd.cod_moti_ini_dependencia%type,
         cod_moti_ini_dependencia_int   tb_codigo_ext.cod_par%type,
         dat_fim_dependencia            tb_carga_gen_ifd.dat_fim_dependencia%type,
         cod_moti_fim_dependencia       tb_carga_gen_ifd.cod_moti_fim_dependencia%type,
         cod_moti_fim_dependencia_int   tb_codigo_ext.cod_par%type,
         flg_dep_salario_familia        tb_carga_gen_ifd.flg_dep_salario_familia%type,
         flg_dep_salario_familia_int    tb_carga_gen_ifd.flg_dep_salario_familia%type,
         flg_incap_fis_ment_trabalho    tb_carga_gen_ifd.flg_incap_fis_ment_trabalho%type,
         flg_incap_fis_ment_trab_int    tb_carga_gen_ifd.flg_incap_fis_ment_trabalho%type,
         flg_dep_imp_renda              tb_carga_gen_ifd.flg_dep_imp_renda%type,
         flg_dep_imp_renda_int          tb_carga_gen_ifd.flg_dep_imp_renda%type,
         num_cpf                        tb_carga_gen_ifd.num_cpf%type,
         dat_nasc                       tb_carga_gen_ifd.dat_nasc%type,
         cod_sexo                       tb_carga_gen_ifd.cod_sexo%type,
         cod_nacio                      tb_carga_gen_ifd.cod_nacio%type,
         cod_nacio_int                  tb_codigo_ext.cod_par%type,
         num_cartorio_nasc              tb_carga_gen_ifd.num_cartorio_nasc%type,
         num_livro_nasc                 tb_carga_gen_ifd.num_livro_nasc%type,
         num_folha_nasc                 tb_carga_gen_ifd.num_folha_nasc%type,
         cod_uf_nasc                    tb_carga_gen_ifd.cod_uf_nasc%type,
         des_natural                    tb_carga_gen_ifd.des_natural%type,
         cod_raca                       tb_carga_gen_ifd.cod_raca%type,
         cod_raca_int                   tb_codigo_ext.cod_par%type,
         cod_profissao                  tb_carga_gen_ifd.cod_profissao%type,
         nom_dep_beneficiario           tb_carga_gen_ifd.nom_dep_beneficiario%type,
         dat_obito                      tb_carga_gen_ifd.dat_obito%type,
         dat_emi_atest_obito            tb_carga_gen_ifd.dat_emi_atest_obito%type,
         nom_resp_obito                 tb_carga_gen_ifd.nom_resp_obito%type,
         cod_tipo_atest_obito           tb_carga_gen_ifd.cod_tipo_atest_obito%type,
         cod_tipo_atest_obito_int       tb_codigo_ext.cod_par%type,
         num_crm_obito                  tb_carga_gen_ifd.num_crm_obito%type,
         nom_mae                        tb_carga_gen_ifd.nom_mae%type,
         nom_pai                        tb_carga_gen_ifd.nom_pai%type,
         num_cpf_mae                    tb_carga_gen_ifd.num_cpf_mae%type,
         num_cpf_pai                    tb_carga_gen_ifd.num_cpf_pai%type,
         cod_est_civ                    tb_carga_gen_ifd.cod_est_civ%type,
         cod_est_civ_int                tb_codigo_ext.cod_par%type,
         num_cert_reserv                tb_carga_gen_ifd.num_cert_reserv%type,
         dat_emi_cert_reserv            tb_carga_gen_ifd.dat_emi_cert_reserv%type,
         num_cert_alist_milit           tb_carga_gen_ifd.num_cert_alist_milit%type,
         dat_emi_cert_alist_milit       tb_carga_gen_ifd.dat_emi_cert_alist_milit%type,
         cod_situ_milit                 tb_carga_gen_ifd.cod_situ_milit%type,
         cod_situ_milit_int             tb_codigo_ext.cod_par%type,
         cod_escolaridade               tb_carga_gen_ifd.cod_escolaridade%type,
         cod_escolaridade_int           tb_codigo_ext.cod_par%type,
         cod_reg_casamento              tb_carga_gen_ifd.cod_reg_casamento%type,
         cod_reg_casamento_int          tb_codigo_ext.cod_par%type,
         ano_cheg_pais                  tb_carga_gen_ifd.ano_cheg_pais%type,
         num_tel_residencial            tb_carga_gen_ifd.num_tel_residencial%type,
         tip_num_tel_1                  tb_pessoa_fisica.tip_num_tel_1%type,
         num_ramal_residencial          tb_carga_gen_ifd.num_ramal_residencial%type,
         num_tel_comercial              tb_carga_gen_ifd.num_tel_comercial%type,
         tip_num_tel_2                  tb_pessoa_fisica.tip_num_tel_2%type,
         num_ramal_comercial            tb_carga_gen_ifd.num_ramal_comercial%type,
         num_tel_contato                tb_carga_gen_ifd.num_tel_contato%type,
         tip_num_tel_3                  tb_pessoa_fisica.tip_num_tel_3%type,
         num_ramal_contato              tb_carga_gen_ifd.num_ramal_contato%type,
         des_email                      tb_carga_gen_ifd.des_email%type,
         num_rg                         tb_carga_gen_ifd.num_rg%type,
         sig_org_emi_rg                 tb_carga_gen_ifd.sig_org_emi_rg%type,
         nom_org_emi_rg                 tb_carga_gen_ifd.nom_org_emi_rg%type,
         cod_uf_emi_rg                  tb_carga_gen_ifd.cod_uf_emi_rg%type,
         dat_emi_rg                     tb_carga_gen_ifd.dat_emi_rg%type,
         num_tit_ele                    tb_carga_gen_ifd.num_tit_ele%type,
         num_zon_tit_ele                tb_carga_gen_ifd.num_zon_tit_ele%type,
         num_sec_ele                    tb_carga_gen_ifd.num_sec_ele%type,
         id                             tb_carga_gen_ifd.id%type,
         num_linha_header               tb_carga_gen_ifd.num_linha_header%type,
         id_processo                    tb_carga_gen_ifd.id_processo%type);

    TYPE R_END IS RECORD
        (cod_ins                 tb_carga_gen_end.cod_ins%type,
         id_header               tb_carga_gen_end.id_header%type,
         cod_entidade            tb_carga_gen_end.cod_entidade%type,
         id_servidor             tb_carga_gen_end.id_servidor%type,
         num_seq_grupo_familiar  tb_carga_gen_end.num_seq_grupo_familiar%type,
         num_seq_dependente      tb_carga_gen_end.num_seq_dependente%type,
         sig_uf                  tb_carga_gen_end.sig_uf%type,
         nom_municipio           tb_carga_gen_end.nom_municipio%type,
         nom_bairro              tb_carga_gen_end.nom_bairro%type,
         nom_logradouro          tb_carga_gen_end.nom_logradouro%type,
         cod_tipo_logradouro_int tb_codigo_ext.cod_par%type,
         cod_tipo_logradouro     tb_carga_gen_end.cod_tipo_logradouro%type,
         num_imovel              tb_carga_gen_end.num_imovel%type,
         des_complemento         tb_carga_gen_end.des_complemento%type,
         cep                     tb_carga_gen_end.cep%type,
         cod_tipo_endereco       tb_carga_gen_end.cod_tipo_endereco%type,
         cod_tipo_endereco_int   tb_codigo_ext.cod_par%type,
         cod_pais                tb_carga_gen_end.cod_pais%type,
         cod_pais_int            tb_codigo_ext.cod_par%type,
         nom_cidade              tb_carga_gen_end.nom_cidade%type,
         id                      tb_carga_gen_end.id%type,
         num_linha_header        tb_carga_gen_end.num_linha_header%type,
         id_processo             tb_carga_gen_end.id_processo%type);

    TYPE R_CAR IS RECORD
        (cod_ins                 tb_carga_gen_car.cod_ins%type,
         cod_entidade            tb_carga_gen_car.cod_entidade%type,
         cod_cargo               tb_carga_gen_car.cod_cargo%type,
         nom_cargo               tb_carga_gen_car.nom_cargo%type,
         cod_nju_cri             tb_carga_gen_car.cod_nju_cri%type,
         cod_nju_ext             tb_carga_gen_car.cod_nju_ext%type,
         flg_comissao            tb_carga_gen_car.flg_comissao%type,
         cod_ide_cbo             tb_carga_gen_car.cod_ide_cbo%type,
         flg_isol_carreira       tb_carga_gen_car.flg_isol_carreira%type,
         cod_sit_cargo           tb_carga_gen_car.cod_sit_cargo%type,
         cod_sit_cargo_int       tb_codigo_ext.cod_par%type,
         qtd_tot_prev_lei        tb_carga_gen_car.qtd_tot_prev_lei%type,
         qtd_ocup                tb_carga_gen_car.qtd_ocup%type,
         flg_professor           tb_carga_gen_car.flg_professor%type,
         cod_escolaridade        tb_carga_gen_car.cod_escolaridade%type,
         cod_escolaridade_int    tb_codigo_ext.cod_par%type,
         flg_acumulo             tb_carga_gen_car.flg_acumulo%type,
         nom_carreira            tb_carga_gen_car.nom_carreira%type,
         nom_quadro_profissional tb_carga_gen_car.nom_quadro_profissional%type,
         id_tab_venc             tb_codigo_ext.cod_par%type,
         id_tab_venc_int         tb_carga_gen_car.id_tab_venc%type,
         cod_referencia          tb_carga_gen_car.cod_referencia%type,
         flg_possui_grau         tb_carga_gen_car.flg_possui_grau%type,
         des_jornada_basica      tb_carga_gen_car.des_jornada_basica%type,
         dat_ini_val_cargo       tb_carga_gen_car.dat_ini_val_cargo%type,
         dat_fim_val_cargo       tb_carga_gen_car.dat_fim_val_cargo%type,
         des_atribuicoes         tb_carga_gen_car.des_atribuicoes%type,
         des_provimento          tb_carga_gen_car.des_provimento%type,
         id                      tb_carga_gen_car.id%type,
         num_linha_header        tb_carga_gen_car.num_linha_header%type,
         id_processo             tb_carga_gen_car.id_processo%type);

    TYPE R_CPA IS RECORD
        (cod_ins                 tb_carga_gen_cpa.cod_ins%type,
         cod_entidade            tb_carga_gen_cpa.cod_entidade%type,
         cod_cargo               tb_carga_gen_cpa.cod_cargo%type,
         id_tab_venc             tb_carga_gen_cpa.id_tab_venc%type,
         cod_referencia          tb_carga_gen_cpa.cod_referencia%type,
         cod_grau_nivel          tb_carga_gen_cpa.cod_grau_nivel%type,
         des_jornada             tb_carga_gen_cpa.des_jornada%type,
         val_padrao_venc         tb_carga_gen_cpa.val_padrao_venc%type,
         dat_ini_val_padrao      tb_carga_gen_cpa.dat_ini_val_padrao%type,
         dat_fim_val_padrao      tb_carga_gen_cpa.dat_fim_val_padrao%type,
         cod_ref_ini_padrao      tb_carga_gen_cpa.cod_ref_ini_padrao%type,
         cod_grau_niv_ini_padrao tb_carga_gen_cpa.cod_grau_niv_ini_padrao%type,
         cod_ref_fim_padrao      tb_carga_gen_cpa.cod_ref_fim_padrao%type,
         cod_grau_niv_fim_padrao tb_carga_gen_cpa.cod_grau_niv_fim_padrao%type,
         id                      tb_carga_gen_cpa.id%type,
         num_linha_header        tb_carga_gen_cpa.num_linha_header%type,
         id_processo             tb_carga_gen_cpa.id_processo%type);

    TYPE R_HFE IS RECORD
        (cod_ins                        tb_carga_gen_hfe.cod_ins%type,
         id_header                      number,
         cod_entidade                   tb_carga_gen_hfe.cod_entidade%type,
         cod_entidade_ant               tb_carga_gen_hfe.cod_entidade%type,
         id_servidor                    tb_carga_gen_hfe.id_servidor%type,
         id_servidor_ant                tb_carga_gen_hfe.id_servidor%type,
         id_vinculo                     tb_carga_gen_hfe.id_vinculo%type,
         id_vinculo_ant                 tb_carga_gen_hfe.id_vinculo%type,
         cod_cargo                      tb_carga_gen_hfe.cod_cargo%type,
         dat_nomeacao                   tb_carga_gen_hfe.dat_nomeacao%type,
         dat_posse                      tb_carga_gen_hfe.dat_posse%type,
         dat_ini_exerc                  tb_carga_gen_hfe.dat_ini_exerc%type,
         dat_ini_exerc_prox             tb_carga_gen_hfe.dat_ini_exerc%type,
         cod_orgao_lotacao              tb_carga_gen_hfe.cod_orgao_lotacao%type,
         cod_regime_jur                 tb_carga_gen_hfe.cod_regime_jur%type,
         cod_regime_jur_int             tb_codigo_ext.cod_par%type,
         cod_tipo_provimento            tb_carga_gen_hfe.cod_tipo_provimento%type,
         cod_tipo_provimento_int        tb_codigo_ext.cod_par%type,
         cod_tipo_doc_ini_vinculo       tb_carga_gen_hfe.cod_tipo_doc_ini_vinculo%type,
         cod_tipo_doc_ini_vinculo_int   tb_codigo_ext.cod_par%type,
         num_doc_ini_vinculo            tb_carga_gen_hfe.num_doc_ini_vinculo%type,
         cod_tipo_vinculo               tb_carga_gen_hfe.cod_tipo_vinculo%type,
         cod_tipo_vinculo_int           tb_codigo_ext.cod_par%type,
         dat_fim_exerc                  tb_carga_gen_hfe.dat_fim_exerc%type,
         dat_fim_exerc_vinc             tb_carga_gen_hfe.dat_fim_exerc%type,
         cod_motivo_desligamento        tb_carga_gen_hfe.cod_motivo_desligamento%type,
         cod_motivo_desligamento_int    tb_codigo_ext.cod_par%type,
         cod_tipo_doc_fim_vinculo       tb_carga_gen_hfe.cod_tipo_doc_fim_vinculo%type,
         cod_tipo_doc_fim_vinculo_int   tb_codigo_ext.cod_par%type,
         num_doc_fim_vinculo            tb_carga_gen_hfe.num_doc_fim_vinculo%type,
         cod_situ_funcional             tb_carga_gen_hfe.cod_situ_funcional%type,
         cod_situ_funcional_int         tb_codigo_ext.cod_par%type,
         cod_regime_previd              tb_carga_gen_hfe.cod_regime_previd%type,
         cod_regime_previd_int          tb_codigo_ext.cod_par%type,
         cod_plan_previd                tb_carga_gen_hfe.cod_plan_previd%type,
         cod_plan_previd_int            tb_codigo_ext.cod_par%type,
         cod_tipo_historico             tb_carga_gen_hfe.cod_tipo_historico%type,
         cod_tipo_historico_int         tb_codigo_ext.cod_par%type,
         des_observacao                 tb_carga_gen_hfe.des_observacao%type,
         id                             tb_carga_gen_hfe.id%type,
         num_linha_header               tb_carga_gen_hfe.num_linha_header%type,
         id_processo                    tb_carga_gen_hfe.id_processo%type );

    TYPE R_EVF IS RECORD
        (cod_ins                        tb_carga_gen_evf.cod_ins%type,
         id_header                      tb_carga_gen_evf.id_header%type,
         cod_entidade                   tb_carga_gen_evf.cod_entidade%type,
         id_servidor                    tb_carga_gen_evf.id_servidor%type,
         id_vinculo                     tb_carga_gen_evf.id_vinculo%type,
         cod_cargo                      tb_carga_gen_evf.cod_cargo%type,
         cod_moti_evol_even_func        tb_carga_gen_evf.cod_moti_evol_even_func%type,
         cod_moti_evol_even_func_int    tb_codigo_ext.cod_par%type,
         dat_ini_even_func              tb_carga_gen_evf.dat_ini_even_func%type,
         cod_tipo_doc_ini_even_func     tb_carga_gen_evf.cod_tipo_doc_ini_even_func%type,
         cod_tipo_doc_ini_even_func_int tb_codigo_ext.cod_par%type,
         num_doc_ini_even_func          tb_carga_gen_evf.num_doc_ini_even_func%type,
         dat_fim_even_func              tb_carga_gen_evf.dat_fim_even_func%type,
         cod_tipo_doc_fim_even_func_int tb_codigo_ext.cod_par%type,
         cod_tipo_doc_fim_even_func     tb_carga_gen_evf.cod_tipo_doc_fim_even_func%type,
         num_doc_fim_even_func          tb_carga_gen_evf.num_doc_fim_even_func%type,
         cod_referencia                 tb_carga_gen_evf.cod_referencia%type,
         cod_grau_nivel                 tb_carga_gen_evf.cod_grau_nivel%type,
         des_jornada                    tb_carga_gen_evf.des_jornada%type,
         des_observacao                 tb_carga_gen_evf.des_observacao%type,
         num_faixa_nivel                tb_carga_gen_evf.num_faixa_nivel%type,
         id                             tb_carga_gen_evf.id%type,
         num_linha_header               tb_carga_gen_evf.num_linha_header%type,
         id_processo                    tb_carga_gen_evf.id_processo%type);

    TYPE R_EFC IS RECORD
        (cod_ins                        tb_carga_gen_efc.cod_ins%type,
         id_header                      number,
         cod_entidade                   tb_carga_gen_efc.cod_entidade%type,
         id_servidor                    tb_carga_gen_efc.id_servidor%type,
         id_vinculo                     tb_carga_gen_efc.id_vinculo%type,
         cod_cargo                      tb_carga_gen_efc.cod_cargo%type,
         cod_moti_evol_even_func        tb_carga_gen_efc.cod_moti_evol_even_func%type,
         cod_moti_evol_even_func_int    tb_codigo_ext.cod_par%type,
         dat_ini_even_func              tb_carga_gen_efc.dat_ini_even_func%type,
         cod_tipo_doc_ini_even_func     tb_carga_gen_efc.cod_tipo_doc_ini_even_func%type,
         cod_tipo_doc_ini_even_func_int tb_codigo_ext.cod_par%type,
         num_doc_ini_even_func          tb_carga_gen_efc.num_doc_ini_even_func%type,
         dat_fim_even_func              tb_carga_gen_efc.dat_fim_even_func%type,
         cod_tipo_doc_fim_even_func     tb_carga_gen_efc.cod_tipo_doc_fim_even_func%type,
         cod_tipo_doc_fim_even_func_int tb_codigo_ext.cod_par%type,
         num_doc_fim_even_func          tb_carga_gen_efc.num_doc_fim_even_func%type,
         cod_referencia                 tb_carga_gen_efc.cod_referencia%type,
         cod_grau_nivel                 tb_carga_gen_efc.cod_grau_nivel%type,
         des_jornada                    tb_carga_gen_efc.des_jornada%type,
         des_observacao                 tb_carga_gen_efc.des_observacao%type,
         id                             tb_carga_gen_efc.id%type,
         num_linha_header               tb_carga_gen_efc.num_linha_header%type,
         id_processo                    tb_carga_gen_efc.id_processo%type);

     TYPE R_FNA IS RECORD
        (cod_ins                    tb_carga_gen_fna.cod_ins%type,
         id_header                  number,
         cod_entidade               tb_carga_gen_fna.cod_entidade%type,
         id_servidor                tb_carga_gen_fna.id_servidor%type,
         id_vinculo                 tb_carga_gen_fna.id_vinculo%type,
         cod_verba                  tb_carga_gen_fna.cod_verba%type,
         val_verba                  tb_carga_gen_fna.val_verba%type,
         dat_competencia_pgto       tb_carga_gen_fna.dat_competencia_pgto%type,
         dat_referencia_folha_pgto  tb_carga_gen_fna.dat_referencia_folha_pgto%type,
         cod_tipo_folha_pgto        tb_carga_gen_fna.cod_tipo_folha_pgto%type,
         cod_tipo_folha_pgto_int    tb_codigo_ext.cod_par%type,
         des_info_complementar      tb_carga_gen_fna.des_info_complementar%type,
         val_percent_calc_verba     tb_carga_gen_fna.val_percent_calc_verba%type,
         val_unit_calc_verba        tb_carga_gen_fna.val_unit_calc_verba%type,
         id                         tb_carga_gen_fna.id%type,
         num_linha_header           tb_carga_gen_fna.num_linha_header%type,
         id_processo                tb_carga_gen_fna.id_processo%type,
         cod_ide_cli                tb_ident_ext_servidor.cod_ide_cli%type,
         folha_prox                 varchar2(30));

    TYPE R_FLF IS RECORD
        (cod_ins                tb_carga_gen_flf.cod_ins%type,
         cod_entidade           tb_carga_gen_flf.cod_entidade%type,
         id_servidor            tb_carga_gen_flf.id_servidor%type,
         id_vinculo             tb_carga_gen_flf.id_vinculo%type,
         cod_tipo_doc_ini       tb_carga_gen_flf.cod_tipo_doc_ini%type,
         cod_tipo_doc_ini_int   tb_codigo_ext.cod_par%type,
         num_doc_ini            tb_carga_gen_flf.num_doc_ini%type,
         dat_publicacao_doc     tb_carga_gen_flf.dat_publicacao_doc%type,
         cod_moti_afast         tb_carga_gen_flf.cod_moti_afast%type,
         cod_moti_afast_int     tb_codigo_ext.cod_par%type,
         dat_ini_afast          tb_carga_gen_flf.dat_ini_afast%type,
         dat_fim_afast_prevista tb_carga_gen_flf.dat_fim_afast_prevista%type,
         dat_fim_afast_efetiva  tb_carga_gen_flf.dat_fim_afast_efetiva%type,
         cod_moti_fim_afast     tb_carga_gen_flf.cod_moti_fim_afast%type,
         cod_moti_fim_afast_int tb_codigo_ext.cod_par%type,
         num_laudo_pericia      tb_carga_gen_flf.num_laudo_pericia%type,
         ano_exerc_ferias       tb_carga_gen_flf.ano_exerc_ferias%type,
         cod_situ_ferias        tb_carga_gen_flf.cod_situ_ferias%type,
         cod_situ_ferias_int    tb_codigo_ext.cod_par%type,
         id                     tb_carga_gen_flf.id%type,
         num_linha_header       tb_carga_gen_flf.num_linha_header%type,
         id_processo            tb_carga_gen_flf.id_processo%type);

    TYPE R_FAT IS RECORD
        (cod_ins                tb_carga_gen_fat.cod_ins%type,
         cod_entidade           tb_carga_gen_fat.cod_entidade%type,
         id_servidor            tb_carga_gen_fat.id_servidor%type,
         id_vinculo             tb_carga_gen_fat.id_vinculo%type,
         per_falta              tb_carga_gen_fat.per_falta%type,
         cod_tipo_falta         tb_carga_gen_fat.cod_tipo_falta%type,
         cod_tipo_falta_int     tb_codigo_ext.cod_par%type,
         qtd_falta              tb_carga_gen_fat.qtd_falta%type,
         id                     tb_carga_gen_fat.id%type,
         num_linha_header       tb_carga_gen_fat.num_linha_header%type,
         id_processo            tb_carga_gen_fat.id_processo%type );

    TYPE R_TEA IS RECORD
        (cod_ins                tb_carga_gen_tea.cod_ins%type,
         cod_entidade           tb_carga_gen_tea.cod_entidade%type,
         id_servidor            tb_carga_gen_tea.id_servidor%type,
         num_cnpj_emp_entidade  tb_carga_gen_tea.num_cnpj_emp_entidade%type,
         nom_empregador         tb_carga_gen_tea.nom_empregador%type,
         dat_admissao           tb_carga_gen_tea.dat_admissao%type,
         dat_desligamento       tb_carga_gen_tea.dat_desligamento%type,
         dat_emi_certidao       tb_carga_gen_tea.dat_emi_certidao%type,
         num_certidao           tb_carga_gen_tea.num_certidao%type,
         nom_org_emi_certidao   tb_carga_gen_tea.nom_org_emi_certidao%type,
         cod_regime_proprio     tb_carga_gen_tea.cod_regime_proprio%type,
         flg_exc_sala_aula      tb_carga_gen_tea.flg_exc_sala_aula%type,
         qtd_tempo_liq_ano      tb_carga_gen_tea.qtd_tempo_liq_ano%type,
         qtd_tempo_liq_mes      tb_carga_gen_tea.qtd_tempo_liq_mes%type,
         qtd_tempo_liq_dia      tb_carga_gen_tea.qtd_tempo_liq_dia%type,
         qtd_tempo_averb_ano    tb_carga_gen_tea.qtd_tempo_averb_ano%type,
         qtd_tempo_averb_mes    tb_carga_gen_tea.qtd_tempo_averb_mes%type,
         qtd_tempo_averb_dia    tb_carga_gen_tea.qtd_tempo_averb_dia%type,
         id                     tb_carga_gen_tea.id%type,
         num_linha_header       tb_carga_gen_tea.num_linha_header%type,
         id_processo            tb_carga_gen_tea.id_processo%type,
         cod_ide_cli            tb_ident_ext_servidor.cod_ide_cli%type);

    TYPE R_FPE IS RECORD
        (cod_ins                 tb_carga_gen_fpe.cod_ins%type,
         cod_entidade            tb_carga_gen_fpe.cod_entidade%type,
         id_servidor             tb_carga_gen_fpe.id_servidor%type,
         id_vinculo              tb_carga_gen_fpe.id_vinculo%type,
         cod_tipo_doc            tb_carga_gen_fpe.cod_tipo_doc%type,
         cod_tipo_doc_int        tb_codigo_ext.cod_par%type,
         num_doc                 tb_carga_gen_fpe.num_doc%type,
         dat_publicacao          tb_carga_gen_fpe.dat_publicacao%type,
         dat_ini_efeito          tb_carga_gen_fpe.dat_ini_efeito%type,
         dat_fim_efeito          tb_carga_gen_fpe.dat_fim_efeito%type,
         flg_convertida_multa    tb_carga_gen_fpe.flg_convertida_multa%type,
         flg_suspende_pgto       tb_carga_gen_fpe.flg_suspende_pgto%type,
         flg_absolvido           tb_carga_gen_fpe.flg_absolvido%type,
         vlr_multa               tb_carga_gen_fpe.vlr_multa%type,
         cod_tipo_penalidade     tb_carga_gen_fpe.cod_tipo_penalidade%type,
         cod_tipo_penalidade_int tb_codigo_ext.cod_par%type,
         des_penalidade          tb_carga_gen_fpe.des_penalidade%type,
         id                      tb_carga_gen_fpe.id%type,
         num_linha_header        tb_carga_gen_fpe.num_linha_header%type,
         id_processo             tb_carga_gen_fpe.id_processo%type,
         cod_ide_cli             tb_ident_ext_servidor.cod_ide_cli%type);

    TYPE R_CES IS RECORD
        (cod_ins                 tb_carga_gen_ces.cod_ins%type,
         cod_entidade            tb_carga_gen_ces.cod_entidade%type,
         id_servidor             tb_carga_gen_ces.id_servidor%type,
         id_vinculo              tb_carga_gen_ces.id_vinculo%type,
         cod_tipo_doc            tb_carga_gen_ces.cod_tipo_doc%type,
         cod_tipo_doc_int        tb_codigo_ext.cod_par%type,
         num_doc                 tb_carga_gen_ces.num_doc%type,
         dat_publicacao_doc      tb_carga_gen_ces.dat_publicacao_doc%type,
         cod_tipo_cessao         tb_carga_gen_ces.cod_tipo_cessao%type,
         cod_tipo_cessao_int     tb_codigo_ext.cod_par%type,
         cod_natureza_cessao     tb_carga_gen_ces.cod_natureza_cessao%type,
         cod_natureza_cessao_int tb_codigo_ext.cod_par%type,
         cod_entidade_destino    tb_carga_gen_ces.cod_entidade_destino%type,
         nom_entidade_destino    tb_carga_gen_ces.nom_entidade_destino%type,
         dat_ini_cessao          tb_carga_gen_ces.dat_ini_cessao%type,
         dat_fim_cessao          tb_carga_gen_ces.dat_fim_cessao%type,
         id                      tb_carga_gen_ces.id%type,
         num_linha_header        tb_carga_gen_ces.num_linha_header%type,
         id_processo             tb_carga_gen_ces.id_processo%type,
         cod_ide_cli             tb_ident_ext_servidor.cod_ide_cli%type);

    TYPE R_FME IS RECORD
        (cod_ins                tb_carga_gen_fme.cod_ins%type,
         cod_entidade           tb_carga_gen_fme.cod_entidade%type,
         id_servidor            tb_carga_gen_fme.id_servidor%type,
         cod_doenca             tb_carga_gen_fme.cod_doenca%type,
         dat_ini_licenca_medica tb_carga_gen_fme.dat_ini_licenca_medica%type,
         dat_fim_licenca_medica tb_carga_gen_fme.dat_fim_licenca_medica%type,
         num_laudo_pericia      tb_carga_gen_fme.num_laudo_pericia%type,
         dat_emi_laudo_pericia  tb_carga_gen_fme.dat_emi_laudo_pericia%type,
         num_inscricao_conselho tb_carga_gen_fme.num_inscricao_conselho%type,
         nom_medico             tb_carga_gen_fme.nom_medico%type,
         des_observacao_pericia tb_carga_gen_fme.des_observacao_pericia%type,
         id                     tb_carga_gen_fme.id%type,
         num_linha_header       tb_carga_gen_fme.num_linha_header%type,
         id_processo            tb_carga_gen_fme.id_processo%type,
         cod_ide_cli            tb_ident_ext_servidor.cod_ide_cli%type);

    TYPE R_ARC IS RECORD
        (cod_ins                        tb_carga_gen_arc.cod_ins%type,
         cod_entidade                   tb_carga_gen_arc.cod_entidade%type,
         id_servidor                    tb_carga_gen_arc.id_servidor%type,
         id_vinculo                     tb_carga_gen_arc.id_vinculo%type,
         dat_competencia                tb_carga_gen_arc.dat_competencia%type,
         dat_arrecadacao                tb_carga_gen_arc.dat_arrecadacao%type,
         val_contrib_servidor_arrec     tb_carga_gen_arc.val_contrib_servidor_arrec%type,
         val_percent_contrib_servidor   tb_carga_gen_arc.val_percent_contrib_servidor%type,
         val_contrib_servidor           tb_carga_gen_arc.val_contrib_servidor%type,
         val_percent_contrib_patronal   tb_carga_gen_arc.val_percent_contrib_patronal%type,
         val_contrib_patronal           tb_carga_gen_arc.val_contrib_patronal%type,
         cod_tipo_arrecadacao           tb_carga_gen_arc.cod_tipo_arrecadacao%type,
         cod_tipo_arrecadacao_int       tb_codigo_ext.cod_par%type,
         id                             tb_carga_gen_arc.id%type,
         num_linha_header               tb_carga_gen_arc.num_linha_header%type,
         id_processo                    tb_carga_gen_arc.id_processo%type);

    TYPE R_FGR IS RECORD
        (cod_ins                    tb_carga_gen_fgr.cod_ins%type,
         cod_entidade               tb_carga_gen_fgr.cod_entidade%type,
         id_servidor                tb_carga_gen_fgr.id_servidor%type,
         id_vinculo                 tb_carga_gen_fgr.id_vinculo%type,
         cod_gratificacao           tb_carga_gen_fgr.cod_gratificacao%type,
         cod_natureza_gratificacao  tb_carga_gen_fgr.cod_natureza_gratificacao%type,
         vlr_pct_gratificacao       tb_carga_gen_fgr.vlr_pct_gratificacao%type,
         dat_publicacao             tb_carga_gen_fgr.dat_publicacao%type,
         cod_tipo_doc               tb_carga_gen_fgr.cod_tipo_doc%type,
         cod_tipo_doc_int           tb_codigo_ext.cod_par%type,
         num_doc                    tb_carga_gen_fgr.num_doc%type,
         dat_incorporacao           tb_carga_gen_fgr.dat_incorporacao%type,
         dat_inicio_gratificacao    tb_carga_gen_fgr.dat_inicio_gratificacao%type,
         dat_fim_gratificacao       tb_carga_gen_fgr.dat_fim_gratificacao%type,
         id                         tb_carga_gen_fgr.id%type,
         num_linha_header           tb_carga_gen_fgr.num_linha_header%type,
         id_processo                tb_carga_gen_fgr.id_processo%type,
         cod_ide_cli                tb_ident_ext_servidor.cod_ide_cli%type);

    TYPE R_VALIDAR IS RECORD
        (NOME       varchar2(30),
         VALOR      varchar2(4000),
         VALOR_ORIG varchar2(4000),
         DES_COLUNA varchar2(100),
         DES_CHAVE  varchar2(1000),
         DES_ERRO   varchar2(4000));

    TYPE T_VALIDAR IS TABLE OF R_VALIDAR INDEX BY BINARY_INTEGER;

    TYPE R_LOG IS RECORD
        (NOM_COLUNA                    VARCHAR2(30),
         DES_CONTEUDO_ANT              VARCHAR2(4000),
         DES_CONTEUDO_ATU              VARCHAR2(4000));

    TYPE T_LOG IS TABLE OF R_LOG INDEX BY BINARY_INTEGER;

    PRAGMA EXCEPTION_INIT(row_locked, -54);

    PROCEDURE SP_BUSCA_DADOS_PROCESSO(i_id_header           in     tb_carga_gen_erro.id_header%type,
                                      o_flg_acao_postergada in out tb_carga_gen_processo.flg_acao_postergada%type,
                                      o_cod_situ_ocorrencia in out tb_carga_gen_log.cod_situ_ocorrencia%type,
                                      v_result              in out varchar2);

    PROCEDURE SP_INCLUI_ERRO_VALIDACAO(o_a_validar  in out t_validar,
                                       i_nome       in varchar2,
                                       i_des_erro   in varchar2,
                                       i_des_coluna in varchar2 default null);

    PROCEDURE SP_INCLUI_LOG(o_a_log            in out t_log,
                            i_nom_coluna       in varchar2,
                            i_des_conteudo_ant in varchar2,
                            i_des_conteudo_atu in varchar2 default null);

    FUNCTION FNC_GRAVA_STATUS_PROCESSAMENTO (i_nom_tabela in varchar2,
                                             i_id_registro in number,
                                             i_cod_status_processamento in varchar2,
                                             i_obs_processamento in varchar2,
                                             i_nom_pro_ult_atu in varchar2) RETURN VARCHAR2;

    PROCEDURE SP_GRAVA_ERRO_DIRETO(i_id_header       in tb_carga_gen_erro.id_header%type,
                                   i_id_processo     in tb_carga_gen_header.id_processo%type,
                                   i_num_linha       in tb_carga_gen_erro.num_linha_header%type,
                                   i_nom_pro_ult_atu in tb_carga_gen_erro.nom_pro_ult_atu%type,
                                   i_des_erro        in tb_carga_gen_erro.des_erro%type default null,
                                   i_des_chave       in tb_carga_gen_erro.des_chave%type default null);

    PROCEDURE SP_GRAVA_ERRO(i_id_header       in tb_carga_gen_erro.id_header%type,
                            i_id_processo     in tb_carga_gen_header.id_processo%type,
                            i_num_linha       in tb_carga_gen_erro.num_linha_header%type,
                            i_nom_pro_ult_atu in tb_carga_gen_erro.nom_pro_ult_atu%type,
                            i_a_validar       in t_validar,
                            i_des_erro        in tb_carga_gen_erro.des_erro%type default null,
                            i_des_chave       in tb_carga_gen_erro.des_chave%type default null);

    PROCEDURE SP_GRAVA_AVISO(i_id_header       in tb_carga_gen_erro.id_header%type,
                             i_id_processo     in tb_carga_gen_header.id_processo%type,
                             i_num_linha       in tb_carga_gen_erro.num_linha_header%type,
                             i_nom_pro_ult_atu in tb_carga_gen_erro.nom_pro_ult_atu%type,
                             i_des_aviso       in tb_carga_gen_erro.des_erro%type,
                             i_des_chave       in tb_carga_gen_erro.des_chave%type default null);

    PROCEDURE SP_GRAVA_LOG(i_id_header           in tb_carga_gen_log.id_header%type,
                           i_id_processo         in tb_carga_gen_header.id_processo%type,
                           i_num_linha           in tb_carga_gen_log.num_linha_header%type,
                           i_cod_tipo_ocorrencia in tb_carga_gen_log.cod_tipo_ocorrencia%type,
                           i_cod_situ_ocorrencia in tb_carga_gen_log.cod_situ_ocorrencia%type,
                           i_nom_schema          in tb_carga_gen_log.nom_schema_ocorrencia%type,
                           i_nom_tabela          in tb_carga_gen_log.nom_tabela_ocorrencia%type,
                           i_nom_pro_ult_atu     in tb_carga_gen_log.nom_pro_ult_atu%type,
                           i_a_log               in t_log);

    PROCEDURE SP_ATUALIZA_HEADER (i_nom_tabela      in varchar2,
                                  i_id_header       in number,
                                  i_nom_pro_ult_atu in varchar2,
                                  i_des_Erro_geral  in varchar2 default null);

    PROCEDURE SP_CARREGA_ENT (i_id_header in number);

    FUNCTION FNC_VALIDA_ENT (i_ent       in     r_ent,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_ORG (i_id_header in number);

    FUNCTION FNC_VALIDA_ORG (i_org       in     r_org,
                             o_a_validar in out t_validar)
            return varchar2;

    FUNCTION FNC_VALIDA_ORG_NIVEL_SUP (i_cod_ins                   in number,
                                       i_cod_entidade              in number,
                                       i_cod_orgao_nivel_sup       in varchar2,
                                       i_des_sigla_orgao_nivel_sup in varchar2) RETURN VARCHAR2;

    PROCEDURE SP_CARREGA_IFS (i_id_header in number);

    FUNCTION FNC_VALIDA_IFS (i_ifs       in out r_ifs,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_IFD (i_id_header in number);

    FUNCTION FNC_VALIDA_IFD (i_ifd       in     r_ifd,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_END (i_id_header in number);

    PROCEDURE SP_CARREGA_CAR (i_id_header in number);

    FUNCTION FNC_VALIDA_CAR (i_car       in     r_car,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_CPA (i_id_header in number);

    FUNCTION FNC_VALIDA_CPA (i_cpa       in     r_cpa,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_HFE (i_id_header in number);

    PROCEDURE SP_CARREGA_EVF (i_id_header in number);

    FUNCTION FNC_VALIDA_EVF (i_evf       in     r_evf,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_EFC (i_id_header in number);

    FUNCTION FNC_VALIDA_EFC (i_efc       in     r_efc,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_FNA (i_id_header in number);

    PROCEDURE SP_CARREGA_FLF (i_id_header in number);

    FUNCTION FNC_VALIDA_FLF (i_flf        in     r_flf,
                             o_a_validar  in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_FAT (i_id_header in number);

    FUNCTION FNC_VALIDA_FAT (i_fat       in     r_fat,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_TEA (i_id_header in number);

    FUNCTION FNC_VALIDA_TEA (i_tea       in     r_tea,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_FPE (i_id_header in number);

    FUNCTION FNC_VALIDA_FPE (i_fpe       in     r_fpe,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_CES (i_id_header in number);

    FUNCTION FNC_VALIDA_CES (i_ces       in     r_ces,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_FME (i_id_header in number);

    FUNCTION FNC_VALIDA_FME (i_fme       in     r_fme,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_ARC (i_id_header in number);

    FUNCTION FNC_VALIDA_ARC (i_arc       in     r_arc,
                             o_a_validar in out t_validar)
            return varchar2;

    PROCEDURE SP_CARREGA_FGR (i_id_header in number);

    FUNCTION FNC_VALIDA_FGR (i_fgr       in     r_fgr,
                             o_a_validar in out t_validar)
            return varchar2;


    FUNCTION FNC_BUSCA_IDE_CLI_DEP(i_cod_ins                in tb_pessoa_fisica.cod_ins%type,
                                   i_cod_ide_cli_serv       in tb_pessoa_fisica.cod_ide_cli%type,
                                   i_num_seq_grupo_familiar in tb_dependente.num_gru_fam%type,
                                   i_num_seq_dependente     in tb_dependente.num_depend%type,
                                   i_num_cpf                in tb_pessoa_fisica.num_cpf%type,
                                   i_dat_nasc               in tb_pessoa_fisica.dat_nasc%type,
                                   i_cod_sexo               in tb_pessoa_fisica.cod_sexo%type,
                                   i_nom_dep_beneficiario   in tb_pessoa_fisica.nom_pessoa_fisica%type,
                                   i_nom_mae                in tb_pessoa_fisica.nom_mae%type,
                                   i_num_cpf_mae            in tb_pessoa_fisica.num_cpf_mae%type)
            return varchar2;


    FUNCTION FNC_VALIDA_DATA (i_data    in varchar2,
                              i_formato in varchar2 default 'AAAAMMDD')
            RETURN DATE;

    FUNCTION FNC_VALIDA_NUMERO(i_numero    in varchar2)
            RETURN NUMBER;

    FUNCTION FNC_VALIDA_COD_ENTIDADE (i_cod_ins      in tb_pessoa_fisica.cod_ins%type,
                                      i_cod_entidade in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_PCCS (i_cod_ins      in tb_entidade.cod_ins%type,
                                 i_cod_entidade in varchar2,
                                 i_sig_pccs     in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_QUADRO (i_cod_ins      in tb_entidade.cod_ins%type,
                                   i_cod_entidade in varchar2,
                                   i_nom_quadro   in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_CARREIRA (i_cod_ins      in tb_entidade.cod_ins%type,
                                     i_cod_entidade in varchar2,
                                     i_nom_carreira in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_CLASSE (i_cod_ins      in tb_entidade.cod_ins%type,
                                   i_cod_entidade in varchar2,
                                   i_sig_classe   in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_JORNADA (i_cod_ins     in tb_entidade.cod_ins%type,
                                    i_des_jornada  in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_NIVEL (i_des_grau_nivel in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_GRAU (i_des_grau_nivel in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_COD_RUBRICA (i_cod_ins      in tb_entidade.cod_ins%type,
                                    i_cod_entidade in varchar2,
                                    i_cod_verba    in varchar2)
            RETURN VARCHAR2;

    FUNCTION FNC_BUSCA_DOMINIOS_PADRAO (i_cod_ins      in tb_dominios_padrao.cod_ins%type,
                                        i_cod_entidade in tb_dominios_padrao.cod_entidade%type,
                                        i_cod_pccs     in tb_dominios_padrao.cod_pccs%type,
                                        i_cod_cargo    in tb_dominios_padrao.cod_cargo%type,
                                        i_cod_tipo     in tb_dominios_padrao.cod_tipo%type)
            RETURN VARCHAR2;



    PROCEDURE sp_busca_id_insc_perito (i_cod_ins                 in tb_carga_gen_fme.cod_ins%type,
                                       i_num_inscricao_conselho  in tb_carga_gen_fme.num_inscricao_conselho%type,
                                       i_nom_medico              in tb_carga_gen_fme.nom_medico%type,
                                       i_tipo_medico             in char,  -- 'I': PErito Interno 'E' Externo
                                       o_id_num_insc_conselho    out tb_inscricao_conselho.id%type);


    FUNCTION CHECK_VALID_SERV (P_NUM_CPF        IN NUMBER,
                               P_MATRICULA      IN NUMBER,
                               P_COD_ENTIDADE   IN NUMBER)
            RETURN NUMBER;

    FUNCTION TIRAACENTO (PSTRING IN VARCHAR2)
            RETURN VARCHAR2;

    FUNCTION TIRAESPACOS (PSTRING IN VARCHAR2)
            RETURN VARCHAR2;

    function TIRAPONTUACAO (pString in varchar2)
            return VARCHAR2;
    procedure sp_executa_processo(i_id_header  in number,
                                   o_des_erro out varchar2);


END PAC_CARGA_GENERICA;
/
CREATE OR REPLACE PACKAGE BODY "PAC_CARGA_GENERICA" is
     v_cliente varchar2(10);
     --
     --
     -----------------------------------------------------------------------------------------------
    function FNC_VALIDA_PESSOA_FISICA (i_cod_ins   in tb_pessoa_fisica.cod_ins%type,
                                       i_ide_cli   in tb_pessoa_fisica.cod_ide_cli%type) return char
    as
      v_qtd_beneficios number;
      v_retorno  varchar2(2000) := null;
    begin
      -- Se pessoa fisica tiver uma aposentadoria ou for legador de aposentadoria não deve efetuar
      -- carga
      SELECT count(1)
        into v_qtd_beneficios
        FROM TB_CONCESSAO_BENEFICIO CB
       WHERE CB.COD_INS = i_cod_ins
         AND CB.COD_IDE_CLI_SERV = i_ide_cli;
        -- AND CB.COD_TIPO_BENEFICIO NOT IN ('LS2');
      if v_qtd_beneficios > 0 then
         v_retorno := 'BENEFICIO';
      else
        SELECT count(1)
          into v_qtd_beneficios
          FROM TB_BENEFICIARIO BEN
         WHERE BEN.COD_INS = i_cod_ins
           AND BEN.COD_IDE_CLI_BEN = i_ide_cli;

         if v_qtd_beneficios > 0 then
           v_retorno := 'BENEFICIO';
         end if;
      end if;
      --
      return (v_retorno);
     exception
      when others then
        return (substr(sqlerrm, 1, 2000));
     end;

     function fnc_ret_cod_ide_cli(i_cod_ins     in tb_carga_gen_ident_ext.cod_ins%type,
                                  i_id_Servidor in tb_carga_gen_ident_ext.cod_ide_cli_ext%type
                                  ) return varchar2
     as
       v_Cod_ide_cli tb_pessoa_fisica.cod_ide_cli%type;
     begin
          select cod_ide_cli
          into v_Cod_ide_cli
          from tb_carga_gen_ident_ext
          where cod_ins         = i_cod_ins
            and cod_ide_cli_ext = i_id_Servidor;

          return v_Cod_ide_cli;
     exception
          when no_data_found then
            raise_application_error(-20000, 'Não foi possivel identificar o codigo externo para o servidor');
     end fnc_ret_cod_ide_cli;
     --
     --
     PROCEDURE SP_REGISTRA_PESSOA (i_cod_ins      in varchar2,
                                   i_cod_entidade in number,
                                   i_cpf          in varchar2,
                                   i_id_servidor  in varchar2)
     AS
       v_existe_ident boolean  := true;
       v_cod_ide_cli  varchar2(20);
       v_id_Servidor  number;
     begin
       if i_cod_entidade is null then
         raise_application_error(-20000,'Erro. Entidade Nula');
       end if;

       v_id_Servidor :=   i_id_servidor;

       begin
         select cod_ide_cli
           into v_cod_ide_cli
           from tb_carga_gen_ident_ext
          where cod_ins = i_cod_ins
            and cod_ide_cli_ext = v_id_Servidor;
       exception
         when no_data_found then
           v_cod_ide_cli := null;
           v_existe_ident := false;
       end;
       --
       --
       if  not v_existe_ident then
         begin
           select cod_ide_cli
             into v_cod_ide_cli
             from tb_pessoa_fisica pf
            where pf.cod_ins = i_cod_ins
              and pf.num_cpf = i_cpf;
          exception
           when no_data_found then
             v_cod_ide_cli := null;
           when too_many_rows then
             raise_application_error(-20001,'Erro. CPF Duplicado');
          end;

         if v_cod_ide_cli is null then
           begin
             select cod_ide_cli
              into v_cod_ide_cli
              from tb_relacao_funcional rf
             where rf.cod_ins = i_cod_ins
               and rf.cod_entidade = i_cod_entidade
               and rf.num_matricula = v_id_Servidor;
           exception
             when no_data_found then
               v_cod_ide_cli := null;
             when too_many_rows then
               v_cod_ide_cli := null;
           end;
         end if;

         if v_cod_ide_cli is null then
           v_cod_ide_cli := seq_cod_ide_cli.nextval;
         end if;

         if fnc_valida_pessoa_fisica(i_cod_ins, v_cod_ide_cli) is not null then
           raise_application_Error(-20000,'Servidor possui beneficio ativo');
         end if;

         insert into tb_carga_gen_ident_ext
              (id,
               cod_ins,           -- 1
               cod_ide_cli,       -- 2
               cod_entidade,      -- 3
               cod_ide_cli_ext,   -- 4
               dat_ing,
               dat_ult_atu,
               nom_usu_ult_atu,   -- 5
               nom_pro_ult_atu)   -- 6
         values
              (seq_carga_Gen_ident_ext.nextval,
               i_cod_ins,          -- 1 - cod_ins
               v_cod_ide_cli,     -- 2 - cod_ide_cli
               i_cod_entidade,    -- 3 - cod_entidade
               v_id_Servidor,     -- 4 - cod_ide_cli_ext
               sysdate,
               sysdate,
               user,              -- 5 - nom_usu_ult_atu
               'SP_REGISTRA_PESSO');     -- 6 - nom_pro_ult_atu
       end if;

     end SP_REGISTRA_PESSOA;

     procedure PRE_PROCESSAMENTO_IFS(i_id_header in number) AS
       v_id_Servidor  number;
       v_cod_entidade number;
     begin
       for ifs in (select cod_ins, cod_entidade, num_cpf, id_servidor, num_linha_header
                  from tb_Carga_gen_ifs ifs
                 where ifs.id_header = i_id_header
                   and cod_status_processamento = 1
                   )
       loop
         begin
           v_id_Servidor := pac_Carga_generica_cliente.fnc_Ret_id_servidor( ifs.id_servidor);
           v_cod_entidade := pac_Carga_generica_cliente.fnc_ret_cod_entidade(ifs.cod_entidade, ifs.id_servidor);

           if v_cod_entidade is null then
             raise_application_Error(-20000,'Entidade nula.');
           end if;

           SP_REGISTRA_PESSOA(ifs.cod_ins,
                              v_cod_entidade,
                              ifs.num_cpf,
                              v_id_Servidor);
         exception
           when others then
            SP_GRAVA_ERRO_DIRETO(i_id_header       => i_id_header,
                                 i_id_processo     => 5,
                                 i_num_linha       => ifs.num_linha_header,
                                 i_nom_pro_ult_atu => 'PRE_PROCESSAMENTO_IFS',
                                 i_des_erro        => 'PRE_PROCESSAMENTO_IFS - '||sqlerrm,
                                 i_des_chave       => null);

             update tb_Carga_gen_ifs
                set cod_status_processamento = 4, Obs_Processamento = 'Erro no pré processamento de identificação do Servidor.'
               where id_header =  i_id_header
                 and num_linha_header = ifs.num_linha_header;
         end;
       end loop;
     end PRE_PROCESSAMENTO_IFS;



    FUNCTION fnc_ret_cod_ide_rel_func(i_id_Servidor in tb_carga_gen_hfe.id_servidor%type,
                                      i_id_vinculo  in tb_carga_gen_hfe.id_vinculo%type)
    return number
    AS
      v_cod_ide_rel_func number;
      v_id_Servidor      tb_carga_gen_hfe.id_servidor%type;
    BEGIN
      v_id_Servidor := to_char(to_number( i_id_Servidor)); -- tirando zeros a esuqerda

      if to_number(nvl(i_id_vinculo,0)) = 0 then
        v_cod_ide_rel_func := v_id_Servidor||'01';
      else
        v_cod_ide_rel_func := v_id_Servidor||rpad(i_id_vinculo,2,'0');
      end if;

      return(v_cod_ide_rel_func);
    END;



    PROCEDURE SP_BUSCA_DADOS_PROCESSO(i_id_header           in     tb_carga_gen_erro.id_header%type,
                                      o_flg_acao_postergada in out tb_carga_gen_processo.flg_acao_postergada%type,
                                      o_cod_situ_ocorrencia in out tb_carga_gen_log.cod_situ_ocorrencia%type,
                                      v_result              in out varchar2) IS

        v_id_processo tb_carga_gen_header.id_processo%type;
        v_erro_tmp varchar2(100);

    BEGIN

        v_erro_tmp := 'Erro ao acessar dados do header';

        select id_processo
        into v_id_processo
        from tb_carga_gen_header
        where id = i_id_header;

        v_erro_tmp := 'Erro ao acessar dados do processo';

        select flg_acao_postergada
        into o_flg_acao_postergada
        from tb_carga_gen_processo
        where id = v_id_processo;

        v_erro_tmp := 'Erro ao definir cod_situ_ocorrencia';

        select decode(nvl(o_flg_acao_postergada, '1'), '0', 'R', 'S')
        into o_cod_situ_ocorrencia
        from dual;

    EXCEPTION
        WHEN OTHERS THEN
            v_result := substr(v_erro_tmp||': '||sqlerrm, 1, 2000);

    END SP_BUSCA_DADOS_PROCESSO;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_INCLUI_ERRO_VALIDACAO(o_a_validar in out t_validar,
                                       i_nome       in varchar2,
                                       i_des_erro   in varchar2,
                                       i_des_coluna in varchar2 default null) IS

    BEGIN
      --
      o_a_validar(nvl(o_a_validar.last, 0) + 1).nome := substr(i_nome, 1, 30);
      o_a_validar(o_a_validar.last).des_erro         := substr(i_des_erro, 1, 4000);
      if (i_des_coluna is not null) then
        o_a_validar(o_a_validar.last).des_coluna     := substr(i_des_coluna, 1, 100);
      end if;
        --
    END SP_INCLUI_ERRO_VALIDACAO;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_INCLUI_LOG(o_a_log            in out t_log,
                            i_nom_coluna       in varchar2,
                            i_des_conteudo_ant in varchar2,
                            i_des_conteudo_atu in varchar2 default null) IS

    BEGIN
        --
        o_a_log(nvl(o_a_log.last, 0) + 1).nom_coluna := substr(i_nom_coluna, 1, 30);
        o_a_log(o_a_log.last).des_conteudo_ant       := substr(i_des_conteudo_ant, 1, 4000);
        o_a_log(o_a_log.last).des_conteudo_atu       := substr(i_des_conteudo_atu, 1, 4000);
        --
    END SP_INCLUI_LOG;
    ----------------------------------------------------------------------------------------------
    -- função retorna nulo caso string contenha valores apenas com zeros
    FUNCTION FNC_RET_NULO_STRING_C_ZEROS(i_val_entrada in varchar2) return varchar2
    as
      v_val_entrada varchar2(1000);
      v_val_saida varchar2(1000);
    begin
      v_val_entrada := trim(replace(i_val_entrada,'0',null));

      if v_val_entrada is null then
        v_val_saida := null;
      else
        v_val_saida := i_val_entrada;
      end if;

      return v_val_saida;

    end FNC_RET_NULO_STRING_C_ZEROS;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_GRAVA_STATUS_PROCESSAMENTO (i_nom_tabela in varchar2,
                                             i_id_registro in number,
                                             i_cod_status_processamento in varchar2,
                                             i_obs_processamento in varchar2,
                                             i_nom_pro_ult_atu in varchar2) RETURN VARCHAR2 IS

    v_id_log_erro number;

    BEGIN

        execute immediate 'update ' || i_nom_tabela ||
                          ' set COD_STATUS_PROCESSAMENTO = '''||i_cod_status_processamento||''','||
                              ' DAT_PROCESSAMENTO = sysdate,'||
                              ' OBS_PROCESSAMENTO = substr('''||i_obs_processamento||''', 1, 2000),'||
                              ' NOM_USU_ULT_ATU = user,'||
                              ' NOM_PRO_ULT_ATU = '''||i_nom_pro_ult_atu||''''||
                          ' where id = '||i_id_registro;

        return 'TRUE';

    EXCEPTION
        WHEN OTHERS THEN
            sp_registra_log_bd('PAC_CARGA_GENERICA.FNC_GRAVA_STATUS_PROCESSAMENTO',
                                          'NOM_TABELA: '||i_nom_tabela||', '||
                                                'REGISTRO: '||i_id_registro||', '||
                                                'STATUS: '||i_cod_status_processamento||', '||
                                                'OBS: '||i_obs_processamento||', '||
                                                'NOM_PRO_ULT_ATU: '||i_nom_pro_ult_atu,
                                          sqlerrm,
                                          v_id_log_erro);
            return 'FALSE';

    END FNC_GRAVA_STATUS_PROCESSAMENTO;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_ATUALIZA_HEADER (i_nom_tabela      in varchar2,
                                  i_id_header       in number,
                                  i_nom_pro_ult_atu in varchar2,
                                  i_des_Erro_geral  in varchar2 default null) IS

        v_qtd_aguardando        number := 0;
        v_qtd_processando       number := 0;
        v_qtd_processado_ok     number := 0;
        v_qtd_processado_erro   number := 0;
        v_max_dat_processamento date;
        v_status_header         number := 0;
        v_query                 varchar2(4000);
        v_id_log_erro number;


    BEGIN

    -- se traz valor de i_des_Erro_geral, se trata de erro geral, e não de erro de linha
      if i_des_Erro_geral is not null then
           update tb_carga_gen_header
            set dat_processamento        = sysdate,
                cod_status_processamento = 4,
                dat_ult_atu              = sysdate,
                nom_usu_ult_atu          = user,
                nom_pro_ult_atu          = i_nom_pro_ult_atu,
                des_observacao           = i_des_Erro_geral
            where id = i_id_header;

            commit;
      else

        -- verificando se processou todos os registros para atualizar o header

        v_query := 'select count(case'||
                                  ' when cod_status_processamento = 1 then 1'||
                               ' end) qtd_aguardando,'||
                         ' count(case'||
                                  ' when cod_status_processamento = 2 then 1'||
                               ' end) qtd_processando,'||
                         ' count(case'||
                                  ' when cod_status_processamento = 3 then 1'||
                               ' end) qtd_processado_ok,'||
                         ' count(case'||
                                  ' when cod_status_processamento = 4 then 1'||
                               ' end) qtd_processado_erro,'||
                         ' max(dat_processamento) max_dat_processamento'||
                  ' from '||i_nom_tabela||
                  ' where id_header = '||i_id_header;


        execute immediate v_query into v_qtd_aguardando, v_qtd_processando, v_qtd_processado_ok,
                                       v_qtd_processado_erro, v_max_dat_processamento;


        if (    v_qtd_aguardando  = 0 and v_qtd_processando = 0
            and (v_qtd_processado_ok > 0 or v_qtd_processado_erro > 0)) then
            -- processou todos os registros, nada mais a ser processado

            update tb_carga_gen_header
            set dat_processamento        = v_max_dat_processamento,
                cod_status_processamento = 3,
                dat_ult_atu              = sysdate,
                nom_usu_ult_atu          = user,
                nom_pro_ult_atu          = i_nom_pro_ult_atu,
                des_observacao           = null
            where id = i_id_header
              and dat_processamento is null
              and cod_status_processamento in (1, 2);

            commit;

        end if;
     end if;
    EXCEPTION
        WHEN OTHERS THEN
            sp_registra_log_bd('PAC_CARGA_GENERICA.SP_ATUALIZA_HEADER',
                                          'NOM_TABELA: '||i_nom_tabela||', '||'HEADER: '||i_id_header,
                                          sqlerrm,
                                          v_id_log_erro);

    END SP_ATUALIZA_HEADER;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_GRAVA_ERRO_DIRETO(i_id_header       in tb_carga_gen_erro.id_header%type,
                                   i_id_processo     in tb_carga_gen_header.id_processo%type,
                                   i_num_linha       in tb_carga_gen_erro.num_linha_header%type,
                                   i_nom_pro_ult_atu in tb_carga_gen_erro.nom_pro_ult_atu%type,
                                   i_des_erro        in tb_carga_gen_erro.des_erro%type default null,
                                   i_des_chave       in tb_carga_gen_erro.des_chave%type default null) IS

        pragma autonomous_transaction;
        v_des_campo_inter tb_carga_gen_depara_arquivo.des_campo_inter%type;
        v_nom_campo_inter tb_carga_gen_depara_arquivo.des_campo_inter%type;
        v_des_erro        varchar2(4000);
        v_id_log_erro number;

    BEGIN

            insert into tb_carga_gen_erro
                (id,
                 id_header,         -- 1
                 num_linha_header,  -- 2
                 nom_campo_erro,    -- 3
                 cod_fase_processo, -- 4
                 des_erro,          -- 5
                 dat_processamento, -- 6
                 nom_usu_ult_atu,   -- 7
                 nom_pro_ult_atu,
                 des_chave,
                 dat_ing,
                 dat_ult_Atu)   -- 8
            values
                (seq_Carga_Gen_erro.nextval,
                 i_id_header,                 -- 1 - id_header
                 i_num_linha,                 -- 2 - num_linha_header
                 null,                        -- 3 - nom_campo_erro
                 '2',                         -- 4 - cod_fase_processo
                 substr(i_des_erro, 1, 4000), -- 5 - des_erro
                 sysdate,                     -- 6 - dat_processamento
                 user,                        -- 7 - nom_usu_ult_atu
                 i_nom_pro_ult_atu,           -- 8 - nom_pro_ult_atu
                 i_des_chave,
                 sysdate,
                 sysdate );
       commit;
    EXCEPTION
        WHEN OTHERS THEN
            rollback;
            sp_registra_log_bd('PAC_CARGA_GENERICA.SP_GRAVA_ERRO_DIRETO',
                                          'ID_HEADER: '||i_id_header||', '||
                                                'I_ID_PROCESSO: '||i_id_processo||', '||
                                                'NUM_LINHA: '||i_num_linha||', '||
                                                'I_NOM_PRO_ULT_ATU: '||i_nom_pro_ult_atu||', '||
                                                'CAMPO: '||v_nom_campo_inter||', '||
                                                'ERRO: '||v_des_erro,
                                          sqlerrm,
                                          v_id_log_erro);

    END SP_GRAVA_ERRO_DIRETO;

    PROCEDURE SP_GRAVA_ERRO(i_id_header       in tb_carga_gen_erro.id_header%type,
                            i_id_processo     in tb_carga_gen_header.id_processo%type,
                            i_num_linha       in tb_carga_gen_erro.num_linha_header%type,
                            i_nom_pro_ult_atu in tb_carga_gen_erro.nom_pro_ult_atu%type,
                            i_a_validar       in t_validar,
                            i_des_erro        in tb_carga_gen_erro.des_erro%type default null,
                            i_des_chave       in tb_carga_gen_erro.des_chave%type default null) IS


        v_des_campo_inter tb_carga_gen_depara_arquivo.des_campo_inter%type;
        v_nom_campo_inter tb_carga_gen_depara_arquivo.des_campo_inter%type;
        v_des_erro        varchar2(4000);
        v_id_log_erro number;

    BEGIN

        if (i_des_erro is not null) then

            insert into tb_carga_gen_erro
                (id,
                 id_header,         -- 1
                 num_linha_header,  -- 2
                 nom_campo_erro,    -- 3
                 cod_fase_processo, -- 4
                 des_erro,          -- 5
                 dat_processamento, -- 6
                 nom_usu_ult_atu,   -- 7
                 nom_pro_ult_atu,
                 des_chave,
                 dat_ing,
                 dat_ult_atu )   -- 8
            values
                (seq_Carga_Gen_erro.nextval,
                 i_id_header,                 -- 1 - id_header
                 i_num_linha,                 -- 2 - num_linha_header
                 null,                        -- 3 - nom_campo_erro
                 '2',                         -- 4 - cod_fase_processo
                 substr(i_des_erro, 1, 4000), -- 5 - des_erro
                 sysdate,                     -- 6 - dat_processamento
                 user,                        -- 7 - nom_usu_ult_atu
                 i_nom_pro_ult_atu,           -- 8 - nom_pro_ult_atu
                 i_des_chave,
                 sysdate,
                 sysdate  );
        else

            for j in i_a_validar.FIRST..i_a_validar.LAST loop

                v_nom_campo_inter := i_a_validar(j).nome;
                v_des_erro        := i_a_validar(j).des_erro;
                v_des_campo_inter := i_a_validar(j).des_coluna;

                if (i_a_validar(j).des_erro is not null) then

                    --v_des_campo_inter := i_a_validar(j).des_coluna;

                    if (v_des_campo_inter is null) then

                        begin
                            select substr(des_campo_inter, 1, 100)
                            into v_des_campo_inter
                            from tb_carga_gen_depara_arquivo
                            where id_processo = i_id_processo
                              and nom_campo_inter = v_nom_campo_inter;
                        exception
                            when others then
                                null;
                        end;

                    end if;
                    --
                    insert into tb_carga_gen_erro
                        (id,
                         id_header,         -- 1
                         num_linha_header,  -- 2
                         nom_campo_erro,    -- 3
                         cod_fase_processo, -- 4
                         des_erro,          -- 5
                         dat_processamento, -- 6
                         nom_usu_ult_atu,   -- 7
                         nom_pro_ult_atu,   -- 8
                         des_chave,
                         dat_ing,
                         dat_ult_atu)
                    values
                        (seq_carga_Gen_erro.nextval,
                         i_id_header,           -- 1 - id_header
                         i_num_linha,           -- 2 - num_linha_header
                         v_des_campo_inter,     -- 3 - nom_campo_erro
                         '2',                   -- 4 - cod_fase_processo
                         v_des_erro,            -- 5 - des_erro
                         sysdate,               -- 6 - dat_processamento
                         user,                  -- 7 - nom_usu_ult_atu
                         i_nom_pro_ult_atu,     -- 8 - nom_pro_ult_atu
                         i_des_chave,
                         sysdate,
                         sysdate);
                end if;

            end loop;

        end if;

    EXCEPTION
        WHEN OTHERS THEN
             sp_registra_log_bd('PAC_CARGA_GENERICA.SP_GRAVA_ERRO',
                                          'ID_HEADER: '||i_id_header||', '||
                                                'I_ID_PROCESSO: '||i_id_processo||', '||
                                                'NUM_LINHA: '||i_num_linha||', '||
                                                'I_NOM_PRO_ULT_ATU: '||i_nom_pro_ult_atu||', '||
                                                'CAMPO: '||v_nom_campo_inter||', '||
                                                'ERRO: '||v_des_erro,
                                          sqlerrm,
                                          v_id_log_erro);

    END SP_GRAVA_ERRO;
    --
    --
    PROCEDURE SP_GRAVA_AVISO(i_id_header       in tb_carga_gen_erro.id_header%type,
                             i_id_processo     in tb_carga_gen_header.id_processo%type,
                             i_num_linha       in tb_carga_gen_erro.num_linha_header%type,
                             i_nom_pro_ult_atu in tb_carga_gen_erro.nom_pro_ult_atu%type,
                             i_des_aviso       in tb_carga_gen_erro.des_erro%type,
                             i_Des_chave       in tb_carga_gen_erro.des_chave%type default null) IS

        v_des_campo_inter tb_carga_gen_depara_arquivo.des_campo_inter%type;
        v_nom_campo_inter tb_carga_gen_depara_arquivo.des_campo_inter%type;
        v_des_erro        varchar2(4000);
        v_id_log_erro number;

    BEGIN
      insert into tb_carga_gen_erro
          (id,
           id_header,         -- 1
           num_linha_header,  -- 2
           nom_campo_erro,    -- 3
           cod_fase_processo, -- 4
           des_erro,          -- 5
           dat_processamento, -- 6
           nom_usu_ult_atu,   -- 7
           nom_pro_ult_atu,   -- 8
           flg_aviso,
           des_chave,
           dat_ing,
           dat_ult_Atu)
      values
          (seq_Carga_Gen_erro.nextval,
           i_id_header,                 -- 1 - id_header
           i_num_linha,                 -- 2 - num_linha_header
           null,                        -- 3 - nom_campo_erro
           '2',                         -- 4 - cod_fase_processo
           substr(i_des_aviso, 1, 4000), -- 5 - des_erro
           sysdate,                     -- 6 - dat_processamento
           user,                        -- 7 - nom_usu_ult_atu
           i_nom_pro_ult_atu,            -- 8 - nom_pro_ult_atu
           'S',
           i_Des_chave,
           sysdate,
           sysdate);

    EXCEPTION
        WHEN OTHERS THEN
            sp_registra_log_bd('PAC_CARGA_GENERICA.SP_GRAVA_ERRO',
                                          'ID_HEADER: '||i_id_header||', '||
                                                'I_ID_PROCESSO: '||i_id_processo||', '||
                                                'NUM_LINHA: '||i_num_linha||', '||
                                                'I_NOM_PRO_ULT_ATU: '||i_nom_pro_ult_atu||', '||
                                                'CAMPO: '||v_nom_campo_inter||', '||
                                                'ERRO: '||v_des_erro,
                                          sqlerrm,
                                          v_id_log_erro);

    END SP_GRAVA_AVISO;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_GRAVA_LOG(i_id_header           in tb_carga_gen_log.id_header%type,
                           i_id_processo         in tb_carga_gen_header.id_processo%type,
                           i_num_linha           in tb_carga_gen_log.num_linha_header%type,
                           i_cod_tipo_ocorrencia in tb_carga_gen_log.cod_tipo_ocorrencia%type,
                           i_cod_situ_ocorrencia in tb_carga_gen_log.cod_situ_ocorrencia%type,
                           i_nom_schema          in tb_carga_gen_log.nom_schema_ocorrencia%type,
                           i_nom_tabela          in tb_carga_gen_log.nom_tabela_ocorrencia%type,
                           i_nom_pro_ult_atu     in tb_carga_gen_log.nom_pro_ult_atu%type,
                           i_a_log               in t_log) IS

        v_id_log_erro number;

    BEGIN

        for j in i_a_log.FIRST..i_a_log.LAST loop

            insert into tb_carga_gen_log
                (id,
                 id_header,             --  1
                 num_linha_header,      --  2
                 cod_tipo_ocorrencia,   --  3
                 cod_situ_ocorrencia,   --  4
                 nom_schema_ocorrencia, --  5
                 nom_tabela_ocorrencia, --  6
                 nom_coluna_ocorrencia, --  7
                 des_conteudo_ant,      --  8
                 des_conteudo_atu,      --  9
                 dat_processamento,     -- 10
                 dat_ing,
                 dat_ult_Atu,
                 nom_usu_ult_atu,       -- 11
                 nom_pro_ult_atu)       -- 12
            values
                (seq_carga_Gen_log.nextval,
                 i_id_header,                   --  1 - id_header,
                 i_num_linha,                   --  2 - num_linha_header,
                 i_cod_tipo_ocorrencia,         --  3 - cod_tipo_ocorrencia,
                 i_cod_situ_ocorrencia,         --  4 - cod_situ_ocorrencia,
                 i_nom_schema,                  --  5 - nom_schema_ocorrencia,
                 i_nom_tabela,                  --  6 - nom_tabela_ocorrencia,
                 i_a_log(j).nom_coluna,         --  7 - nom_coluna_ocorrencia,
                 i_a_log(j).des_conteudo_ant,   --  8 - des_conteudo_ant,
                 i_a_log(j).des_conteudo_atu,   --  9 - des_conteudo_atu,
                 sysdate,                       -- 10 - dat_processamento,
                 sysdate,
                 sysdate,
                 user,                          -- 11 - nom_usu_ult_atu,
                 i_nom_pro_ult_atu);            -- 12 - nom_pro_ult_atu

        end loop;

    EXCEPTION
        WHEN OTHERS THEN
            sp_registra_log_bd('PAC_CARGA_GENERICA.SP_GRAVA_LOG',
                                          'ID_HEADER: '||i_id_header||', '||
                                                'I_ID_PROCESSO: '||i_id_processo||', '||
                                                'NUM_LINHA: '||i_num_linha||', '||
                                                'TIPO_OCORRENCIA: '||i_cod_tipo_ocorrencia||', '||
                                                'SITU_OCORRENCIA: '||i_cod_situ_ocorrencia||', '||
                                                'I_NOM_PRO_ULT_ATU: '||i_nom_pro_ult_atu,
                                          sqlerrm,
                                          v_id_log_erro);

    END SP_GRAVA_LOG;



    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_ENT (i_id_header in number) IS

        v_result            varchar2(2000);
        v_cur_id                tb_carga_gen_ent.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_ENT';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_ENT';
        v_tb_entidade           tb_entidade%rowtype;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for ent in (select a.cod_ins,
                                   trim(a.cod_entidade)      cod_entidade,
                                   trim(a.num_cnpj)          num_cnpj,
                                   trim(a.nom_entidade)      nom_entidade,
                                   trim(a.des_sigla)         des_sigla,
                                   trim(a.cod_poder)         cod_poder,
                                   fnc_codigo_ext(a.cod_ins, 2021, trim(a.cod_poder), null, 'COD_PAR') cod_poder_int,
                                   trim(a.cod_esfera)        cod_esfera,
                                   fnc_codigo_ext(a.cod_ins, 2022, trim(a.cod_esfera), null, 'COD_PAR') cod_esfera_int,
                                   trim(a.cod_tipo_entidade) cod_tipo_entidade,
                                   fnc_codigo_ext(a.cod_ins, 2023, trim(a.cod_tipo_entidade), null, 'COD_PAR') cod_tipo_entidade_int,
                                   a.id, a.num_linha_header, a.id_processo
                            from tb_carga_gen_ent a
                            where id_header = i_id_header
                              and cod_status_processamento = '1'
                              and rownum <= 100
                            order by id_header, num_linha_header
                            for update nowait) loop

                    v_cur_id            := ent.id;

                    BEGIN

                        savepoint sp1;

                        v_result := FNC_VALIDA_ENT(ent, a_validar);

                        if (v_result is null) then

                            v_tb_entidade := null;

                            begin
                                select *
                                into v_tb_entidade
                                from tb_entidade
                                where cod_ins      = ent.cod_ins
                                  and cod_entidade = ent.cod_entidade;
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_entidade.cod_ins is not null) then -- registro ja existe, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_entidade
                                    set num_cnpj          = nvl(ent.num_cnpj, num_cnpj),
                                        nom_entidade      = ent.nom_entidade,
                                        des_sigla         = substr(ent.des_sigla, 1, 20),
                                        cod_poder         = ent.cod_poder_int,
                                        cod_esfera        = ent.cod_esfera_int,
                                        cod_tipo_entidade = ent.cod_tipo_entidade_int,
                                        dat_ult_atu       = sysdate,
                                        nom_usu_ult_atu   = user,
                                        nom_pro_ult_atu   = v_nom_rotina
                                    where cod_ins      = ent.cod_ins
                                      and cod_entidade = ent.cod_entidade;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_entidade
                                        (cod_ins,           -- 1
                                         cod_entidade,      -- 2
                                         num_cnpj,          -- 3
                                         nom_entidade,      -- 4
                                         des_sigla,         -- 5
                                         cod_poder,         -- 6
                                         cod_esfera,        -- 7
                                         cod_tipo_entidade, -- 8
                                         dat_ing,           -- 9
                                         dat_ult_atu,       -- 10
                                         nom_usu_ult_atu,   -- 11
                                         nom_pro_ult_atu)   -- 12
                                    values
                                        (ent.cod_ins,                   -- 1 cod_ins
                                         ent.cod_entidade,              -- 2 cod_entidade
                                         ent.num_cnpj,                  -- 3 num_cnpj
                                         ent.nom_entidade,              -- 4 nom_entidade
                                         substr(ent.des_sigla, 1, 20),  -- 5 des_sigla
                                         ent.cod_poder_int,             -- 6 cod_poder
                                         ent.cod_esfera_int,            -- 7 cod_esfera
                                         ent.cod_tipo_entidade_int,     -- 8 cod_tipo_entidade
                                         sysdate,                       -- 9 dat_ing
                                         sysdate,                       -- 10 dat_ult_atu
                                         user,                          -- 11 nom_usu_ult_atu
                                         v_nom_rotina);                 -- 12 nom_pro_ult_atu

                                end if;

                            end if;

                            a_log.delete;

                            SP_INCLUI_LOG(a_log, 'COD_INS',           v_tb_entidade.cod_ins,           ent.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',      v_tb_entidade.cod_entidade,      ent.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'NUM_CNPJ',          v_tb_entidade.num_cnpj,          nvl(trim(ent.num_cnpj), v_tb_entidade.num_cnpj));
                            SP_INCLUI_LOG(a_log, 'NOM_ENTIDADE',      v_tb_entidade.nom_entidade,      trim(ent.nom_entidade));
                            SP_INCLUI_LOG(a_log, 'DES_SIGLA',         v_tb_entidade.des_sigla,         substr(trim(ent.des_sigla), 1, 20));
                            SP_INCLUI_LOG(a_log, 'COD_PODER',         v_tb_entidade.cod_poder,         ent.cod_poder_int);
                            SP_INCLUI_LOG(a_log, 'COD_ESFERA',        v_tb_entidade.cod_esfera,        ent.cod_esfera_int);
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_ENTIDADE', v_tb_entidade.cod_tipo_entidade, ent.cod_tipo_entidade_int);

                            SP_GRAVA_LOG(i_id_header, ent.id_processo, ent.num_linha_header,  v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_ENTIDADE', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ent.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, ent.id_processo, ent.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ent.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, ent.id_processo, ent.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ent.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (v_cur_id is null) then
                sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, sqlerrm, v_id_log_erro);
            else
                if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                    rollback;
                else
                    commit;
                end if;
            end if;

    END SP_CARREGA_ENT;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_ENT (i_ent       in     r_ent,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno  varchar2(2000);

    BEGIN

        o_a_validar.delete;

        if (i_ent.cod_entidade is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', 'Codigo da entidade não foi informado');
        end if;

        if (i_ent.nom_entidade is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'NOM_ENTIDADE', 'Nome da entidade não foi informado');
        end if;

        if (i_ent.des_sigla is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DES_SIGLA', 'Sigla da entidade não foi informada');
        end if;

        if (i_ent.cod_poder is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_PODER', 'Codigo do poder não foi informado');
        elsif (i_ent.cod_poder_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_PODER', 'Codigo do poder ('||i_ent.cod_poder||') não previsto');
        end if;

        if (i_ent.cod_esfera is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ESFERA', 'Codigo da esfera do poder não foi informado');
        elsif (i_ent.cod_esfera_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ESFERA', 'Codigo da esfera do poder ('||i_ent.cod_esfera||') não previsto');
        end if;

        if (i_ent.cod_tipo_entidade is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_ENTIDADE', 'Codigo do tipo de entidade não foi informado');
        elsif (i_ent.cod_tipo_entidade_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_ENTIDADE', 'Codigo do tipo de entidade ('||i_ent.cod_tipo_entidade||') não previsto');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION

        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_ENT;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_ORG (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_org.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_ORG';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_ORG';
        v_cod_orgao             tb_orgao.cod_orgao%type;
        v_cod_orgao_pai         tb_orgao.cod_orgao_pai%type;
        v_tb_orgao              tb_orgao%rowtype;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for org in (select a.cod_ins,
                                   trim(a.cod_entidade)              cod_entidade,
                                   trim(a.cod_orgao_ext)             cod_orgao_ext,
                                   trim(a.des_sigla)                 des_sigla,
                                   trim(a.nom_orgao)                 nom_orgao,
                                   trim(a.cod_orgao_nivel_sup)       cod_orgao_nivel_sup,
                                   trim(a.des_sigla_orgao_nivel_sup) des_sigla_orgao_nivel_sup,
                                   trim(a.flg_uni_orc)               flg_uni_orc,
                                   trim(a.cod_tipo_orgao)            cod_tipo_orgao,
                                   fnc_codigo_ext(a.cod_ins, 2024, trim(a.cod_tipo_orgao), null, 'COD_PAR') cod_tipo_orgao_int,
                                   trim(a.cod_nju_cri)               cod_nju_cri,
                                   trim(a.cod_nju_ext)               cod_nju_ext,
                                   trim(a.num_cnpj)                  num_cnpj,
                                   trim(a.num_insc_est)              num_insc_est,
                                   trim(a.num_insc_mun)              num_insc_mun,
                                   decode(fnc_valida_numero(trim(a.dat_ini_vig)),
                                            0, null,
                                            trim(a.dat_ini_vig))     dat_ini_vig,
                                   decode(fnc_valida_numero(trim(a.dat_fim_vig)),
                                            0, null,
                                            trim(a.dat_fim_vig))     dat_fim_vig,
                                   trim(a.cod_status_orgao)          cod_status_orgao,
                                   fnc_codigo_ext(a.cod_ins, 10118, trim(a.cod_status_orgao), null, 'COD_PAR') cod_status_orgao_int,
                                   trim(a.nom_contato)               nom_contato,
                                   trim(a.des_cargo_contato)         des_cargo_contato,
                                   trim(a.num_tel_1)                 num_tel_1,
                                   trim(a.num_ramal_tel_1)           num_ramal_tel_1,
                                   trim(a.num_tel_2)                 num_tel_2,
                                   trim(a.num_ramal_tel_2)           num_ramal_tel_2,
                                   trim(a.num_tel_3)                 num_tel_3,
                                   trim(a.num_ramal_tel_3)           num_ramal_tel_3,
                                   trim(a.cod_nat_jur)               cod_nat_jur,
                                   fnc_codigo_ext(a.cod_ins, 2049, trim(a.cod_nat_jur), null, 'COD_PAR') cod_nat_jur_int,
                                   a.id, a.num_linha_header, a.id_processo,
                                   c.cod_orgao                       cod_orgao_nivel_sup_org
                            from tb_carga_gen_org a
                                left outer join tb_orgao c
                                    on      a.cod_ins             = c.cod_ins
                                        and a.cod_entidade        = c.cod_entidade
                                        and a.cod_orgao_nivel_sup = c.cod_orgao_ext
                            where id_header = i_id_header
                              and cod_status_processamento = '1'
                              and rownum <= 100
                            order by id_header, num_linha_header
                            for update nowait) loop

                    v_cur_id := org.id;

                    BEGIN

                        savepoint sp1;

                        if (v_result is null) then

                            v_cod_orgao := null;
                            v_tb_orgao := null;

                            begin
                                select *
                                into v_tb_orgao
                                from tb_orgao
                                where cod_ins       = org.cod_ins
                                  and cod_entidade  = org.cod_entidade
                                  and cod_orgao_ext = org.cod_orgao_ext;
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_orgao.cod_orgao is not null) then -- registro ja existe, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_orgao
                                    set des_sigla       = org.des_sigla,
                                        nom_orgao       = org.nom_orgao,
                                        cod_orgao_pai   = org.cod_orgao_nivel_sup_org,
                                        flg_uni_orc     = nvl(upper(org.flg_uni_orc), flg_uni_orc),
                                        cod_tipo_org    = nvl(org.cod_tipo_orgao_int, cod_tipo_org),
                                        cod_nju_cri     = nvl(org.cod_nju_cri, cod_nju_cri),
                                        cod_nju_ext     = nvl(org.cod_nju_ext, cod_nju_ext),
                                        num_cnpj        = nvl(org.num_cnpj, num_cnpj),
                                        num_insc_est    = nvl(org.num_insc_est, num_insc_est),
                                        num_inst_mun    = nvl(org.num_insc_mun, num_inst_mun),
                                        dat_ini_vig     = nvl(fnc_valida_data(org.dat_ini_vig, 'YYYYMMDD'), dat_ini_vig),
                                        dat_fim_vig     = nvl(fnc_valida_data(org.dat_fim_vig, 'YYYYMMDD'), dat_fim_vig),
                                        cod_status_org  = nvl(org.cod_status_orgao_int, cod_status_org),
                                        nom_contato     = nvl(org.nom_contato, nom_contato),
                                        des_cargo_cont  = nvl(org.des_cargo_contato, des_cargo_cont),
                                        num_tel_1       = nvl(org.num_tel_1, num_tel_1),
                                        num_ramal_tel1  = nvl(org.num_ramal_tel_1, num_ramal_tel1),
                                        num_tel_2       = nvl(org.num_tel_2, num_tel_2),
                                        num_ramal_tel2  = nvl(org.num_ramal_tel_2, num_ramal_tel2),
                                        num_tel_3       = nvl(org.num_tel_3, num_tel_3),
                                        num_ramal_tel3  = nvl(org.num_ramal_tel_3, num_ramal_tel3),
                                        cod_nat_jur     = nvl(org.cod_nat_jur_int, cod_nat_jur),
                                        dat_ult_atu     = sysdate,
                                        nom_usu_ult_atu = user,
                                        nom_pro_ult_atu = v_nom_rotina
                                    where cod_ins      = v_tb_orgao.cod_ins
                                      and cod_entidade = v_tb_orgao.cod_entidade
                                      and cod_orgao    = v_tb_orgao.cod_orgao;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                SELECT max(t.cod_orgao)+1
                                INTO v_cod_orgao
                                from tb_orgao t;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_orgao
                                        (cod_ins,               -- 1
                                         cod_entidade,          -- 2
                                         cod_orgao,             -- 3
                                         cod_orgao_pai,         -- 4
                                         cod_nju_cri,           -- 5
                                         cod_nju_ext,           -- 6
                                         cod_tipo_org,          -- 7
                                         cod_nat_jur,           -- 8
                                         num_cnpj,              -- 9
                                         num_insc_est,          -- 10
                                         num_inst_mun,          -- 11
                                         nom_orgao,             -- 12
                                         nom_raz_soc,           -- 13
                                         des_sigla,             -- 14
                                         nom_contato,           -- 15
                                         des_cargo_cont,        -- 16
                                         num_tel_1,             -- 17
                                         num_tel_2,             -- 18
                                         num_tel_3,             -- 19
                                         dat_ini_vig,           -- 20
                                         dat_fim_vig,           -- 21
                                         flg_ativo,             -- 22
                                         cod_enderecamento,     -- 23
                                         flg_uni_orc,           -- 24
                                         dat_ing,               -- 25
                                         dat_ult_atu,           -- 26
                                         nom_usu_ult_atu,       -- 27
                                         nom_pro_ult_atu,       -- 28
                                         num_ramal_tel1,        -- 29
                                         num_ramal_tel2,        -- 30
                                         num_ramal_tel3,        -- 31
                                         cod_status_org,        -- 32
                                         cod_orgao_ext)         -- 33
                                    values
                                        (org.cod_ins,                           -- 1 cod_ins
                                         org.cod_entidade,                      -- 2 cod_entidade
                                         v_cod_orgao,                           -- 3 cod_orgao
                                         org.cod_orgao_nivel_sup_org,           -- 4 cod_orgao_pai
                                         nvl(org.cod_nju_cri, 0),               -- 5 cod_nju_cri
                                         org.cod_nju_ext,                       -- 6 cod_nju_ext
                                         nvl(org.cod_tipo_orgao_int, '0'),      -- 7 cod_tipo_org
                                         nvl(org.cod_nat_jur_int, '0'),         -- 8 cod_nat_jur
                                         org.num_cnpj,                          -- 9 num_cnpj
                                         org.num_insc_est,                      -- 10 num_insc_est,
                                         org.num_insc_mun,                      -- 11 num_inst_mun,
                                         org.nom_orgao,                         -- 12 nom_orgao,
                                         'CAMPREV',                             -- 13 nom_raz_soc,
                                         org.des_sigla,                         -- 14 des_sigla,
                                         org.nom_contato,                       -- 15 nom_contato,
                                         org.des_cargo_contato,                 -- 16 des_cargo_cont,
                                         org.num_tel_1,                         -- 17 num_tel_1,
                                         org.num_tel_2,                         -- 18 num_tel_2,
                                         org.num_tel_3,                         -- 19 num_tel_3,
                                         nvl(fnc_valida_data(org.dat_ini_vig, 'YYYYMMDD'), trunc(sysdate, 'DD')),  -- 20 dat_ini_vig,
                                         fnc_valida_data(org.dat_fim_vig, 'YYYYMMDD'),                             -- 21 dat_fim_vig,
                                         'S',                                   -- 22 flg_ativo,
                                         0,                                     -- 23 cod_enderecamento,
                                         upper(nvl(org.flg_uni_orc, 'N')),      -- 24 flg_uni_orc,
                                         sysdate,                               -- 25 dat_ing,
                                         sysdate,                               -- 26 dat_ult_atu,
                                         user,                                  -- 27 nom_usu_ult_atu,
                                         v_nom_rotina,                          -- 28 nom_pro_ult_atu,
                                         org.num_ramal_tel_1,                   -- 29 num_ramal_tel1,
                                         org.num_ramal_tel_2,                   -- 30 num_ramal_tel2,
                                         org.num_ramal_tel_3,                   -- 31 num_ramal_tel3,
                                         org.cod_status_orgao_int,              -- 32 cod_status_org,
                                         org.cod_orgao_ext);                    -- 33 cod_orgao_ext

                                end if;

                            end if;

                            a_log.delete;

                            SP_INCLUI_LOG(a_log, 'COD_INS',           v_tb_orgao.cod_ins,           org.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',      v_tb_orgao.cod_entidade,      org.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_ORGAO',         v_tb_orgao.cod_orgao,         nvl(v_cod_orgao, v_tb_orgao.cod_orgao));
                            SP_INCLUI_LOG(a_log, 'DES_SIGLA',         v_tb_orgao.des_sigla,         org.des_sigla);
                            SP_INCLUI_LOG(a_log, 'NOM_ORGAO',         v_tb_orgao.nom_orgao,         org.nom_orgao);
                            SP_INCLUI_LOG(a_log, 'COD_ORGAO_PAI',     v_tb_orgao.cod_orgao_pai,     org.cod_orgao_nivel_sup_org);
                            SP_INCLUI_LOG(a_log, 'FLG_UNI_ORC',       v_tb_orgao.flg_uni_orc,       nvl(nvl(upper(org.flg_uni_orc), v_tb_orgao.flg_uni_orc), 'N'));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_ORG',      v_tb_orgao.cod_tipo_org,      nvl(nvl(org.cod_tipo_orgao_int, v_tb_orgao.cod_tipo_org), '0'));
                            SP_INCLUI_LOG(a_log, 'COD_NJU_CRI',       v_tb_orgao.cod_nju_cri,       nvl(nvl(org.cod_nju_cri, v_tb_orgao.cod_nju_cri), 0));
                            SP_INCLUI_LOG(a_log, 'COD_NJU_EXT',       v_tb_orgao.cod_nju_ext,       nvl(org.cod_nju_ext, v_tb_orgao.cod_nju_ext));
                            SP_INCLUI_LOG(a_log, 'NUM_CNPJ',          v_tb_orgao.num_cnpj,          nvl(org.num_cnpj, v_tb_orgao.num_cnpj));
                            SP_INCLUI_LOG(a_log, 'NUM_INSC_EST',      v_tb_orgao.num_insc_est,      nvl(org.num_insc_est, v_tb_orgao.num_insc_est));
                            SP_INCLUI_LOG(a_log, 'NUM_INST_MUN',      v_tb_orgao.num_inst_mun,      nvl(org.num_insc_mun, v_tb_orgao.num_inst_mun));
                            SP_INCLUI_LOG(a_log, 'DAT_INI_VIG',       to_char(v_tb_orgao.dat_ini_vig, 'dd/mm/yyyy hh24:mi'), to_char(nvl(nvl(fnc_valida_data(org.dat_ini_vig, 'YYYYMMDD'), v_tb_orgao.dat_ini_vig), trunc(sysdate, 'DD')), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_VIG',       to_char(v_tb_orgao.dat_fim_vig, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(org.dat_fim_vig, 'YYYYMMDD'), v_tb_orgao.dat_fim_vig), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_STATUS_ORG',    v_tb_orgao.cod_status_org,    nvl(org.cod_status_orgao_int, v_tb_orgao.cod_status_org));
                            SP_INCLUI_LOG(a_log, 'NOM_CONTATO',       v_tb_orgao.nom_contato,       nvl(org.nom_contato, v_tb_orgao.nom_contato));
                            SP_INCLUI_LOG(a_log, 'DES_CARGO_CONT',    v_tb_orgao.des_cargo_cont,    nvl(org.des_cargo_contato, v_tb_orgao.des_cargo_cont));
                            SP_INCLUI_LOG(a_log, 'NUM_TEL_1',         v_tb_orgao.num_tel_1,         nvl(org.num_tel_1, v_tb_orgao.num_tel_1));
                            SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL1',    v_tb_orgao.num_ramal_tel1,    nvl(org.num_ramal_tel_1, v_tb_orgao.num_ramal_tel1));
                            SP_INCLUI_LOG(a_log, 'NUM_TEL_2',         v_tb_orgao.num_tel_2,         nvl(org.num_tel_2, v_tb_orgao.num_tel_2));
                            SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL2',    v_tb_orgao.num_ramal_tel2,    nvl(org.num_ramal_tel_2, v_tb_orgao.num_ramal_tel2));
                            SP_INCLUI_LOG(a_log, 'NUM_TEL_3',         v_tb_orgao.num_tel_3,         nvl(org.num_tel_3, v_tb_orgao.num_tel_3));
                            SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL3',    v_tb_orgao.num_ramal_tel3,    nvl(org.num_ramal_tel_3, v_tb_orgao.num_ramal_tel3));
                            SP_INCLUI_LOG(a_log, 'COD_NAT_JUR',       v_tb_orgao.cod_nat_jur,       nvl(nvl(org.cod_nat_jur_int, v_tb_orgao.cod_nat_jur), '0'));
                            SP_INCLUI_LOG(a_log, 'NOM_RAZ_SOC',       v_tb_orgao.nom_raz_soc,       nvl(v_tb_orgao.nom_raz_soc, 'CAMPREV'));
                            SP_INCLUI_LOG(a_log, 'FLG_ATIVO',         v_tb_orgao.flg_ativo,         nvl(v_tb_orgao.flg_ativo, 'S'));
                            SP_INCLUI_LOG(a_log, 'COD_ENDERECAMENTO', v_tb_orgao.cod_enderecamento, nvl(v_tb_orgao.cod_enderecamento, '0'));

                            SP_GRAVA_LOG(i_id_header, org.id_processo, org.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_ORGAO', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, org.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, org.id_processo, org.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, org.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, org.id_processo, org.num_linha_header,  v_nom_rotina, a_validar, substr(sqlerrm, 1, 4000));

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, org.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_ORG;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_ORG (i_org       in     r_org,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                   varchar2(2000);
        v_des_result                varchar2(4000);
        v_dat_ini                   date;
        v_dat_fim                   date;
        v_valida_orgao_nivel_sup    varchar2(2000);

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_org.cod_ins, i_org.cod_entidade);

        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_org.cod_orgao_ext is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ORGAO_EXT', 'Codigo do org?o não foi informado');
        end if;

        if (i_org.des_sigla is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DES_SIGLA', 'Sigla do org?o não foi informada');
        end if;

        if (i_org.nom_orgao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'NOM_ORGAO', 'Nome do org?o não foi informado');
        end if;

        if (i_org.flg_uni_orc is not null and upper(i_org.flg_uni_orc) not in ('S', 'N')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_UNI_ORC', 'Indicador de unidade orcamentaria ('||i_org.flg_uni_orc||') não previsto. Esperado ''S'' ou ''N''');
        end if;

        if (i_org.cod_tipo_orgao is not null and i_org.cod_tipo_orgao_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_ORG', 'Tipo do org?o ('||i_org.cod_tipo_orgao||') não previsto');
        end if;

        if (i_org.cod_status_orgao is not null and i_org.cod_status_orgao_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_STATUS_ORGAO', 'Status do org?o ('||i_org.cod_status_orgao||') não previsto');
        end if;

        if (i_org.cod_nat_jur is not null and i_org.cod_nat_jur_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_NAT_JUR', 'Natureza juridica do org?o ('||i_org.cod_nat_jur||') não prevista');
        end if;

        if (i_org.dat_ini_vig is not null) then
            v_dat_ini := fnc_valida_data(i_org.dat_ini_vig, 'RRRRMMDD');
            if (   (length(i_org.dat_ini_vig) < 8) or ( v_dat_ini is null)) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_VIG', 'Data de inicio de vigencia do org?o ('||i_org.dat_ini_vig||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if (i_org.dat_fim_vig is not null) then
            v_dat_fim := fnc_valida_data(i_org.dat_fim_vig, 'RRRRMMDD');
            if ((length(i_org.dat_fim_vig) < 8) or (fnc_valida_data(i_org.dat_fim_vig, 'RRRRMMDD') is null)) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_VIG', 'Data de inicio de vigencia do org?o ('||i_org.dat_fim_vig||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if (v_dat_ini is not null and v_dat_fim is not null and v_dat_ini > v_dat_fim) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_VIG', 'Data de inicio de vigencia do org?o ('||i_org.dat_ini_vig||') e posterior a de fim de vigencia ('||i_org.dat_fim_vig||')');
        end if;

        v_valida_orgao_nivel_sup := FNC_VALIDA_ORG_NIVEL_SUP(i_org.cod_ins,
                                                             i_org.cod_entidade,
                                                             i_org.cod_orgao_nivel_sup,
                                                             i_org.des_sigla_orgao_nivel_sup);

        if (v_valida_orgao_nivel_sup is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ORGAO_NIVEL_SUP', v_valida_orgao_nivel_sup);
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr('FNC_VALIDA_ORG: '||sqlerrm, 1, 2000));

    END FNC_VALIDA_ORG;

    ----------------------------------------------------------------------------------------------
    FUNCTION FNC_BUSCA_IDE_CLI_SERV(i_cod_ins                in tb_pessoa_fisica.cod_ins%type,
                                    i_num_cpf                in tb_pessoa_fisica.num_cpf%type,
                                    i_cod_entidade           in tb_relacao_funcional.cod_entidade%type default null,
                                    i_cod_ide_rel_func       in tb_relacao_funcional.cod_ide_rel_func%type default null)
     return varchar2 IS

        v_retorno             tb_pessoa_fisica.cod_ide_cli%type := null;
        v_qtd_rec             number := 0;
        v_linha_pessoa_fisica tb_pessoa_fisica%rowtype;

    BEGIN

        if (i_num_cpf is not null and fnc_valida_numero(i_num_cpf) != 0) then
            begin
                select cod_ide_cli
                  into v_retorno
                  from tb_pessoa_fisica
                 where cod_ins = i_cod_ins
                   and num_cpf = i_num_cpf;

             exception
                when no_data_found then
                    v_retorno := null;
             end;
        elsif i_cod_entidade is not null and i_cod_ide_rel_func is not null then
            begin
                select cod_ide_cli
                  into v_retorno
                  from tb_relacao_funcional rf
                 where rf.cod_ins = i_cod_ins
                   and rf.cod_entidade = i_cod_entidade
                   and rf.cod_ide_rel_func = i_cod_ide_rel_func;
            exception
                when no_data_found then
                    v_retorno := null;
            end;
        end if;
        --
        return(v_retorno);
    END FNC_BUSCA_IDE_CLI_SERV;

    -----------------------------------------------------------------------------------------------
    PROCEDURE SP_CARREGA_IFS (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_ifs.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_IFS';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_IFS';
        v_cod_ide_cli           tb_pessoa_fisica.cod_ide_cli%type;
        v_tb_pessoa_fisica      tb_pessoa_fisica%rowtype;
        v_tb_servidor           tb_servidor%rowtype;
        v_tb_carga_gen_ident_ext tb_carga_gen_ident_ext%rowtype;
        v_qtd_prof              number;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);
        v_cod_erro              number;
        v_cod_entidade          tb_carga_gen_ifs.cod_entidade%type;
        v_id_Servidor           tb_carga_gen_ifs.id_servidor%type;
        v_vlr_iteracao          number := 100;

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);
        --
        --
        -- Inicia prop_processamento para atualizar tabela de código externo (tb_Carga_Gen_ident_ext)
        if v_result is null then
          PRE_PROCESSAMENTO_IFS(i_id_header);
        end if;
        --
        if (v_result is null) then
            loop
              v_result := null;
              v_cur_id := null;
              v_cod_erro := null;
                              --
              --
              for ifs in (select a.cod_ins,
                                 a.id_header,
                                 trim(a.cod_entidade)                 cod_entidade,
                                 trim(a.id_servidor)                  id_servidor,
                                 a.dat_nasc                           dat_nasc,
                                 trim(a.cod_sexo)                     cod_sexo,
                                 trim(a.cod_nacio)                    cod_nacio,
                                 fnc_codigo_ext(a.cod_ins, 2007, trim(to_number(a.cod_nacio)), null, 'COD_PAR') cod_nacio_int,
                                 trim(a.cod_uf_nasc)                  cod_uf_nasc,
                                 trim(a.des_natural)                  des_natural,
                                 trim(a.cod_raca)                     cod_raca,
                                 fnc_codigo_ext(a.cod_ins, 2004, trim(a.cod_raca), null, 'COD_PAR') cod_raca_int,
                                 trim(a.cod_profissao)                cod_profissao,
                                 trim(a.nom_servidor)                 nom_servidor,
                                 decode(fnc_valida_numero(trim(a.dat_obito)),
                                          0, null,
                                          trim(a.dat_obito))          dat_obito,
                                 decode(fnc_valida_numero(trim(a.dat_emi_atest_obito)),
                                         0, null,
                                         trim(a.dat_emi_atest_obito)) dat_emi_atest_obito,
                                 trim(a.nom_resp_obito)               nom_resp_obito,
                                 trim(a.cod_tipo_atest_obito)         cod_tipo_atest_obito,
                                 fnc_codigo_ext(a.cod_ins, 2073, trim(a.cod_tipo_atest_obito), null, 'COD_PAR') cod_tipo_atest_obito_int,
                                 trim(a.num_crm_obito)                num_crm_obito,
                                 trim(a.nom_mae)                      nom_mae,
                                 trim(a.nom_pai)                      nom_pai,
                                 trim(a.num_cpf_mae)                  num_cpf_mae,
                                 trim(a.num_cpf_pai)                  num_cpf_pai,
                                 trim(a.cod_est_civ)                  cod_est_civ,
                                 fnc_codigo_ext(a.cod_ins, 2005, trim(a.cod_est_civ), null, 'COD_PAR') cod_est_civ_int,
                                 trim(a.num_cert_reserv)              num_cert_reserv,
                                 decode(fnc_valida_numero(trim(a.dat_emi_cert_reserv)),
                                         0, null,
                                         trim(a.dat_emi_cert_reserv)) dat_emi_cert_reserv,
                                 trim(a.num_cert_alist_milit)         num_cert_alist_milit,
                                 decode(fnc_valida_numero(trim(a.dat_emi_cert_alist_milit)),
                                          0, null,
                                          trim(a.dat_emi_cert_alist_milit)) dat_emi_cert_alist_milit,
                                 trim(a.cod_situ_milit)               cod_situ_milit,
                                 fnc_codigo_ext(a.cod_ins, 2012, trim(a.cod_situ_milit), null, 'COD_PAR') cod_situ_milit_int,
                                 trim(a.cod_escolaridade)             cod_escolaridade,
                                 fnc_codigo_ext(a.cod_ins, 2006, trim(to_number(a.cod_escolaridade)), null, 'COD_PAR') cod_escolaridade_int,
                                 trim(a.cod_reg_casamento)            cod_reg_casamento,
                                 fnc_codigo_ext(a.cod_ins, 2028, trim(a.cod_reg_casamento), null, 'COD_PAR') cod_reg_casamento_int,
                                 decode(fnc_valida_numero(trim(a.ano_cheg_pais)),
                                 0, null,
                                 trim(a.ano_cheg_pais))      ano_cheg_pais,
                                 trim(ltrim(a.num_tel_residencial,'0'))          num_tel_residencial,
                                 decode(trim(ltrim(a.num_tel_residencial,'0')), null, null, '0') tip_num_tel_1,
                                 trim(ltrim(a.num_ramal_residencial,'0'))        num_ramal_residencial,
                                 trim(ltrim(a.num_tel_comercial,'0'))            num_tel_comercial,
                                 decode(trim(ltrim(a.num_tel_comercial,'0')), null, null, '1')   tip_num_tel_2,
                                 trim(ltrim(a.num_ramal_comercial,'0'))          num_ramal_comercial,
                                 trim(ltrim(a.num_tel_contato,'0'))              num_tel_contato,
                                 decode(trim(a.num_tel_contato), null, null, '3')     tip_num_tel_3,
                                 trim(ltrim(a.num_ramal_contato,'0'))            num_ramal_contato,
                                 trim(a.des_email)                    des_email,
                                 trim(ltrim(a.num_rg,'0'))            num_rg,
                                 trim(a.sig_org_emi_rg)               sig_org_emi_rg,
                                 trim(a.nom_org_emi_rg)               nom_org_emi_rg,
                                 trim(a.cod_uf_emi_rg)                cod_uf_emi_rg,
                                 decode(fnc_valida_numero(trim(a.dat_emi_rg)),
                                          0, null,
                                          trim(a.dat_emi_rg))         dat_emi_rg,
                                 trim(a.num_tit_ele)                  num_tit_ele,
                                 trim(a.num_zon_tit_ele)              num_zon_tit_ele,
                                 trim(a.num_sec_ele)                  num_sec_ele,
                                 trim(a.num_nit_inss)                 num_nit_inss,
                                 trim(ltrim(a.num_pis,'0'))           num_pis,
                                 trim(ltrim(a.num_ctps,'0'))                     num_ctps,
                                 trim(ltrim(a.num_serie_ctps,'0'))               num_serie_ctps,
                                 decode(fnc_valida_numero(trim(a.dat_emi_ctps)),
                                          0, null,
                                          trim(a.dat_emi_ctps))       dat_emi_ctps,
                                 trim(a.cod_uf_emi_ctps)              cod_uf_emi_ctps,
                                 trim(a.num_cpf)                      num_cpf,
                                 trim(a.nom_social)                   nom_social,
                                 trim(a.cod_pais_nasc)                cod_pais_nasc,
                                 fnc_codigo_ext(a.cod_ins, 2009, trim(a.cod_pais_nasc), null, 'COD_PAR') cod_pais_nasc_int,
                                 trim(a.num_dni)                      num_dni,
                                 trim(a.nom_org_emi_dni)              nom_org_emi_dni,
                                 decode(fnc_valida_numero(trim(a.dat_emi_dni)),
                                          0, null,
                                          trim(a.dat_emi_dni))        dat_emi_dni,
                                 trim(a.num_rne)                      num_rne,
                                 trim(a.nom_org_emi_rne)              nom_org_emi_rne,
                                 decode(fnc_valida_numero(trim(a.dat_emi_rne)),
                                          0, null,
                                          trim(a.dat_emi_rne))        dat_emi_rne,
                                 trim(a.num_reg_cons_classe)          num_reg_cons_classe,
                                 trim(a.nom_org_emi_reg_cons_classe)  nom_org_emi_reg_cons_classe,
                                 decode(fnc_valida_numero(trim(a.dat_emi_reg_cons_classe)),
                                          0, null,
                                          trim(a.dat_emi_reg_cons_classe)) dat_emi_reg_cons_classe,
                                 decode(fnc_valida_numero(trim(a.dat_val_reg_cons_classe)),
                                          0, null,
                                          trim(a.dat_val_reg_cons_classe)) dat_val_reg_cons_classe,
                                 trim(a.cod_cla_condtrab_estrangeiro) cod_cla_condtrab,
                                 fnc_codigo_ext(a.cod_ins, 10123, trim(a.cod_cla_condtrab_estrangeiro), null, 'COD_PAR') cod_cla_condtrab_int,
                                 trim(a.flg_conjuge_brasileiro)       flg_conjuge_brasileiro,
                                 decode(upper(trim(a.flg_conjuge_brasileiro)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_conjuge_brasileiro_int,
                                 trim(a.flg_filho_com_brasileiro)     flg_filho_com_brasileiro,
                                 decode(upper(trim(a.flg_filho_com_brasileiro)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_filho_com_brasileiro_int,
                                 trim(a.num_cnh)                      num_cnh,
                                 decode(fnc_valida_numero(trim(a.dat_emi_cnh)),
                                          0, null,
                                          trim(a.dat_emi_cnh))        dat_emi_cnh,
                                 trim(a.cod_uf_emi_cnh)               cod_uf_emi_cnh,
                                 decode(fnc_valida_numero(trim(a.dat_val_cnh)),
                                          0, null,
                                          trim(a.dat_val_cnh))        dat_val_cnh,
                                 decode(fnc_valida_numero(trim(a.dat_first_cnh)),
                                          0, null,
                                          trim(a.dat_first_cnh))      dat_first_cnh,
                                 trim(a.cat_cnh)                      cat_cnh,
                                 trim(a.flg_def_fisica)               flg_def_fisica,
                                 decode(upper(trim(a.flg_def_fisica)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_def_fisica_int,
                                 trim(a.flg_def_visual)               flg_def_visual,
                                 decode(upper(trim(a.flg_def_visual)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_def_visual_int,
                                 trim(a.flg_def_auditiva)             flg_def_auditiva,
                                 decode(upper(trim(a.flg_def_auditiva)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_def_auditiva_int,
                                 trim(a.flg_def_mental)               flg_def_mental,
                                 decode(upper(trim(a.flg_def_mental)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_def_mental_int,
                                 trim(a.flg_def_intelectual)          flg_def_intelectual,
                                 decode(upper(trim(a.flg_def_intelectual)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_def_intelectual_int,
                                 trim(a.flg_readaptado)               flg_readaptado,
                                 decode(upper(trim(a.flg_readaptado)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_readaptado_int,
                                 trim(a.flg_cota_deficiencia)         flg_cota_deficiencia,
                                 decode(upper(trim(a.flg_cota_deficiencia)),
                                          'S', '1',
                                          'N', '0',
                                          null)                       flg_cota_deficiencia_int,
                                 a.id, a.num_linha_header, a.id_processo
                          from tb_carga_gen_ifs a
                          where id_header = i_id_header
                            and cod_status_processamento = '1'
                            and rownum <= v_vlr_iteracao
                          order by id_header, num_linha_header
                          for update nowait)
                 loop
                   BEGIN
                      savepoint sp1;
                      v_cur_id := ifs.id;
                      v_result := null;
                      a_validar.delete;
                      --
                      --
                      v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(ifs.id_servidor);
                      v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(ifs.cod_entidade,ifs.id_servidor);
                      --
                      if v_id_servidor is null then
                        v_result := 'Número de Servidor nulo.';
                      end if;
                      --
                      if v_result is null and v_cod_entidade is null then
                        v_result := 'Código da Entidade nulo.';
                      end if;
                      if v_result is null then
                        -- VALIDAÇÂO
                         PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                                 i_num_linha        => ifs.num_linha_header,
                                                                                 o_result           => v_result,
                                                                                 o_cod_erro         => v_cod_erro,
                                                                                 o_des_erro         => v_msg_erro);

                        --
                        if v_cod_erro is not null then
                          v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||' - '||v_msg_erro;
                        end if;
                      end if;
                      --
                      if v_result is null then
                        v_result := FNC_VALIDA_IFS(ifs, a_validar);
                      end if;

                      if (v_result is null) then

                          v_tb_carga_gen_ident_ext := null;
                          v_tb_pessoa_fisica      := null;
                          v_tb_servidor           := null;
                          v_cod_ide_cli           := null;
                          --
                          --
                          v_cod_ide_cli := fnc_ret_cod_ide_cli( ifs.cod_ins, v_id_Servidor);

                          if FNC_VALIDA_PESSOA_FISICA(ifs.cod_ins, v_cod_ide_cli) is not null then
                             raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                          end if;
                          --
                          begin
                              select *
                              into v_tb_pessoa_fisica
                              from tb_pessoa_fisica p
                              where cod_ins     = v_tb_carga_gen_ident_ext.cod_ins
                                and p.num_cpf = ifs.num_cpf;
                          exception
                              when others then
                                  null;
                          end;
                          --
                          if (v_tb_pessoa_fisica.cod_ins is null) then

                              begin

                                  select *
                                  into v_tb_pessoa_fisica
                                  from tb_pessoa_fisica
                                  where cod_ide_cli = v_cod_ide_cli;
                              exception
                                  when others then
                                      null;
                              end;

                          end if;
                          --
                          --
                          begin
                              select *
                              into v_tb_servidor
                              from tb_servidor
                              where cod_ins     = v_tb_pessoa_fisica.cod_ins
                                and cod_ide_cli = v_cod_ide_cli;
                          exception
                              when others then
                                  null;
                          end;


                          if (v_tb_pessoa_fisica.cod_ins is not null) then -- registro ja existe em tb_pessoa_fisica, atualiza os demais dados

                              v_cod_tipo_ocorrencia := 'A';



                              if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                  update tb_pessoa_fisica
                                  set nom_pessoa_fisica    = ifs.nom_servidor,
                                      num_rg               = nvl(ltrim(ifs.num_rg,'0'), num_rg),
                                      dat_emi_rg           = nvl(fnc_valida_data(ifs.dat_emi_rg, 'YYYYMMDD'), dat_emi_rg),
                                      cod_uf_emi_rg        = nvl(ifs.cod_uf_emi_rg, cod_uf_emi_rg),
                                      cod_org_emi_rg       = nvl(substr(ifs.sig_org_emi_rg, 1, 6), cod_org_emi_rg),
                                      dat_nasc             = fnc_valida_data(ifs.dat_nasc, 'YYYYMMDD'),
                                      dat_obito            = nvl(fnc_valida_data(ifs.dat_obito, 'YYYYMMDD'), dat_obito),
                                      dat_emi_atest_obito  = nvl(fnc_valida_data(ifs.dat_emi_atest_obito, 'YYYYMMDD'), dat_emi_atest_obito),
                                      nom_resp_obito       = nvl(ifs.nom_resp_obito, nom_resp_obito),
                                      cod_tipo_atest_obito = nvl(ifs.cod_tipo_atest_obito_int, cod_tipo_atest_obito),
                                      num_crm_obito        = nvl(ifs.num_crm_obito, num_crm_obito),
                                      cod_sexo             = upper(ifs.cod_sexo),
                                      cod_raca             = nvl(ifs.cod_raca_int, cod_raca),
                                      cod_est_civ          = nvl(ifs.cod_est_civ_int, cod_est_civ),
                                      cod_escola           = nvl(ifs.cod_escolaridade_int, cod_escola),
                                      cod_nacio            = nvl(ifs.cod_nacio_int, cod_nacio),
                                      dat_cheg_pais        = nvl(trunc(to_date(ifs.ano_cheg_pais, 'YYYY'), 'Y'), dat_cheg_pais),
                                      des_natural          = nvl(ifs.des_natural, des_natural),
                                      nom_mae              = ifs.nom_mae,
                                      num_cpf_mae          = nvl(ifs.num_cpf_mae, num_cpf_mae),
                                      nom_pai              = nvl(ifs.nom_pai, nom_pai),
                                      num_cpf_pai          = nvl(ifs.num_cpf_pai, num_cpf_pai),
                                      num_tel_1            = nvl(ifs.num_tel_residencial, num_tel_1),
                                      num_tel_2            = nvl(ifs.num_tel_comercial, num_tel_2),
                                      num_tel_3            = nvl(ifs.num_tel_contato, num_tel_3),
                                      des_email            = nvl(ifs.des_email, des_email),
                                      cod_uf_nasc          = nvl(upper(ifs.cod_uf_nasc), cod_uf_nasc),
                                      cod_reg_casamento    = nvl(ifs.cod_reg_casamento_int, cod_reg_casamento),
                                      num_ramal_tel_1      = nvl(ifs.num_ramal_residencial, num_ramal_tel_1),
                                      num_ramal_tel_2      = nvl(ifs.num_ramal_comercial, num_ramal_tel_2),
                                      num_ramal_tel_3      = nvl(ifs.num_ramal_contato, num_ramal_tel_3),
                                      num_tit_ele          = nvl(ifs.num_tit_ele, num_tit_ele),
                                      num_zon_ele          = nvl(ifs.num_zon_tit_ele, num_zon_ele),
                                      num_sec_ele          = nvl(ifs.num_sec_ele, num_sec_ele),
                                      num_cer_res          = nvl(ifs.num_cert_reserv, num_cer_res),
                                      dat_cam              = nvl(fnc_valida_data(ifs.dat_emi_cert_alist_milit, 'YYYYMMDD'), dat_cam),
                                      cod_sit_mil          = nvl(ifs.cod_situ_milit_int, cod_sit_mil),
                                      tip_num_tel_1        = nvl(ifs.tip_num_tel_1, tip_num_tel_1),
                                      tip_num_tel_2        = nvl(ifs.tip_num_tel_2, tip_num_tel_2),
                                      tip_num_tel_3        = nvl(ifs.tip_num_tel_3, tip_num_tel_3),
                                      nom_social           = nvl(ifs.nom_social, nom_social),
                                      cod_pais_nasc        = nvl(ifs.cod_pais_nasc_int, cod_pais_nasc),
                                      num_dni              = nvl(ifs.num_dni, num_dni),
                                      nom_org_emi_dni      = nvl(ifs.nom_org_emi_dni, nom_org_emi_dni),
                                      dat_emi_dni          = nvl(fnc_valida_data(ifs.dat_emi_dni, 'YYYYMMDD'), dat_emi_dni),
                                      num_ins_reg_nac_est  = nvl(ifs.num_rne, num_ins_reg_nac_est),
                                      nom_org_emi_est      = nvl(ifs.nom_org_emi_rne, nom_org_emi_est),
                                      dat_emi_rne          = nvl(fnc_valida_data(ifs.dat_emi_rne, 'YYYYMMDD'), dat_emi_rne),
                                      cod_cla_condtrab     = nvl(ifs.cod_cla_condtrab_int, cod_cla_condtrab),
                                      flg_cas_bra          = nvl(ifs.flg_conjuge_brasileiro_int, flg_cas_bra),
                                      flg_fil_bra          = nvl(ifs.flg_filho_com_brasileiro_int, flg_fil_bra),
                                      num_cnh              = nvl(ifs.num_cnh, num_cnh),
                                      dat_emi_cnh          = nvl(fnc_valida_data(ifs.dat_emi_cnh, 'YYYYMMDD'), dat_emi_cnh),
                                      cod_uf_emi_cnh       = nvl(upper(ifs.cod_uf_emi_cnh), cod_uf_emi_cnh),
                                      dat_val_cnh          = nvl(fnc_valida_data(ifs.dat_val_cnh, 'YYYYMMDD'), dat_val_cnh),
                                      dat_first_cnh        = nvl(fnc_valida_data(ifs.dat_first_cnh, 'YYYYMMDD'), dat_first_cnh),
                                      cat_cnh              = nvl(ifs.cat_cnh, cat_cnh),
                                      flg_def_fisica       = nvl(ifs.flg_def_fisica_int, flg_def_fisica),
                                      flg_def_visual       = nvl(ifs.flg_def_visual_int, flg_def_visual),
                                      flg_def_auditiva     = nvl(ifs.flg_def_auditiva_int, flg_def_auditiva),
                                      flg_def_mental       = nvl(ifs.flg_def_mental_int, flg_def_mental),
                                      flg_def_intelectual  = nvl(ifs.flg_def_intelectual_int, flg_def_intelectual),
                                      flg_readaptado       = nvl(ifs.flg_readaptado_int, flg_readaptado),
                                      flg_cota_deficiencia = nvl(ifs.flg_cota_deficiencia_int, flg_cota_deficiencia),
                                      dat_ult_atu          = sysdate,
                                      nom_usu_ult_atu      = user
                                   where cod_ins     = ifs.cod_ins
                                    and cod_ide_cli = v_cod_ide_cli
                                    and nom_pro_ult_atu =  v_nom_rotina;

                              end if;

                          else                        -- registro não existe, inclui

                              v_cod_tipo_ocorrencia := 'I';

                              if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                  insert into tb_pessoa_fisica
                                      (cod_ins,               -- 1
                                       cod_ide_cli,           -- 2
                                       num_cpf,               -- 3
                                       nom_pessoa_fisica,     -- 4
                                       num_rg,                -- 5
                                       dat_emi_rg,            -- 6
                                       cod_uf_emi_rg,         -- 7
                                       cod_org_emi_rg,        -- 8
                                       dat_nasc,              -- 9
                                       dat_obito,             -- 10
                                       dat_emi_atest_obito,   -- 11
                                       nom_resp_obito,        -- 12
                                       num_crm_obito,         -- 13
                                       cod_sexo,              -- 14
                                       cod_raca,              -- 15
                                       cod_est_civ,           -- 16
                                       cod_escola,            -- 17
                                       cod_nacio,             -- 18
                                       dat_cheg_pais,         -- 19
                                       des_natural,           -- 20
                                       nom_mae,               -- 21
                                       num_cpf_mae,           -- 22
                                       nom_pai,               -- 23
                                       num_cpf_pai,           -- 24
                                       num_tel_1,             -- 25
                                       num_tel_2,             -- 26
                                       num_tel_3,             -- 27
                                       des_email,             -- 28
                                       dat_ing,               -- 29
                                       dat_ult_atu,           -- 30
                                       nom_usu_ult_atu,       -- 31
                                       nom_pro_ult_atu,       -- 32
                                       cod_uf_nasc,           -- 33
                                       cod_reg_casamento,     -- 34
                                       num_ramal_tel_1,       -- 35
                                       num_ramal_tel_2,       -- 36
                                       num_ramal_tel_3,       -- 37
                                       num_tit_ele,           -- 38
                                       num_zon_ele,           -- 39
                                       num_sec_ele,           -- 40
                                       num_cer_res,           -- 41
                                       dat_cam,               -- 42
                                       cod_sit_mil,           -- 43
                                       tip_num_tel_1,         -- 44
                                       tip_num_tel_2,         -- 45
                                       tip_num_tel_3,         -- 46
                                       cod_tipo_atest_obito,  -- 47
                                       nom_social,            -- 48
                                       cod_pais_nasc,         -- 49
                                       num_dni,               -- 50
                                       nom_org_emi_dni,       -- 51
                                       dat_emi_dni,           -- 52
                                       num_ins_reg_nac_est,   -- 53
                                       nom_org_emi_est,       -- 54
                                       dat_emi_rne,           -- 55
                                       cod_cla_condtrab,      -- 56
                                       flg_cas_bra,           -- 57
                                       flg_fil_bra,           -- 58
                                       num_cnh,               -- 59
                                       dat_emi_cnh,           -- 60
                                       cod_uf_emi_cnh,        -- 61
                                       dat_val_cnh,           -- 62
                                       dat_first_cnh,         -- 63
                                       cat_cnh,               -- 64
                                       flg_def_fisica,        -- 65
                                       flg_def_visual,        -- 66
                                       flg_def_auditiva,      -- 67
                                       flg_def_mental,        -- 68
                                       flg_def_intelectual,   -- 69
                                       flg_readaptado,        -- 70
                                       flg_cota_deficiencia) -- 71
                                  values
                                      (ifs.cod_ins,                                           -- 1 cod_ins
                                       v_cod_ide_cli,                                         -- 2 cod_ide_cli
                                       ifs.num_cpf,                                           -- 3 num_cpf
                                       ifs.nom_servidor,                                      -- 4 nom_pessoa_fisica
                                       ltrim(ifs.num_rg,0),                                            -- 5 num_rg
                                       fnc_valida_data(ifs.dat_emi_rg, 'YYYYMMDD'),           -- 6 dat_emi_rg
                                       ifs.cod_uf_emi_rg,                                     -- 7 cod_uf_emi_rg
                                       substr(ifs.sig_org_emi_rg, 1, 6),                      -- 8 cod_org_emi_rg
                                       fnc_valida_data(ifs.dat_nasc, 'YYYYMMDD'),             -- 9 dat_nasc
                                       fnc_valida_data(ifs.dat_obito, 'YYYYMMDD'),            -- 10 dat_obito
                                       fnc_valida_data(ifs.dat_emi_atest_obito, 'YYYYMMDD'),  -- 11 dat_emi_atest_obito
                                       ifs.nom_resp_obito,                                    -- 12 nom_resp_obito
                                       ifs.num_crm_obito,                                     -- 13 num_crm_obito
                                       upper(ifs.cod_sexo),                                   -- 14 cod_sexo
                                       ifs.cod_raca_int,                                      -- 15 cod_raca
                                       ifs.cod_est_civ_int,                                   -- 16 cod_est_civ
                                       ifs.cod_escolaridade_int,                              -- 17 cod_escola
                                       ifs.cod_nacio_int,                                     -- 18 cod_nacio
                                       trunc(to_date(ifs.ano_cheg_pais, 'YYYY'), 'Y'),        -- 19 dat_cheg_pais
                                       ifs.des_natural,                                       -- 20 des_natural
                                       ifs.nom_mae,                                           -- 21 nom_mae
                                       ifs.num_cpf_mae,                                       -- 22 num_cpf_mae
                                       ifs.nom_pai,                                           -- 23 nom_pai
                                       ifs.num_cpf_pai,                                       -- 24 num_cpf_pai
                                       ifs.num_tel_residencial,                               -- 25 num_tel_1
                                       ifs.num_tel_comercial,                                 -- 26 num_tel_2
                                       ifs.num_tel_contato,                                   -- 27 num_tel_3
                                       ifs.des_email,                                         -- 28 des_email
                                       sysdate,                                               -- 29 dat_ing
                                       sysdate,                                               -- 30 dat_ult_atu
                                       user,                                                  -- 31 nom_usu_ult_atu
                                       v_nom_rotina,                                          -- 32 nom_pro_ult_atu
                                       upper(ifs.cod_uf_nasc),                                -- 33 cod_uf_nasc
                                       ifs.cod_reg_casamento_int,                             -- 34 cod_reg_casamento
                                       ifs.num_ramal_residencial,                             -- 35 num_ramal_tel_1
                                       ifs.num_ramal_comercial,                               -- 36 num_ramal_tel_2
                                       ifs.num_ramal_contato,                                 -- 37 num_ramal_tel_3
                                       ifs.num_tit_ele,                                       -- 38 num_tit_ele
                                       ifs.num_zon_tit_ele,                                   -- 39 num_zon_ele
                                       ifs.num_sec_ele,                                       -- 40 num_sec_ele
                                       ifs.num_cert_reserv,                                   -- 41 num_cer_res
                                       fnc_valida_data(ifs.dat_emi_cert_alist_milit, 'YYYYMMDD'), -- 42 dat_cam
                                       ifs.cod_situ_milit_int,                                -- 43 cod_sit_mil
                                       ifs.tip_num_tel_1,                                     -- 44 tip_num_tel_1
                                       ifs.tip_num_tel_2,                                     -- 45 tip_num_tel_2
                                       ifs.tip_num_tel_3,                                     -- 46 tip_num_tel_3
                                       ifs.cod_tipo_atest_obito_int,                          -- 47 cod_tipo_atest_obito
                                       ifs.nom_social,                                        -- 48 nom_social
                                       ifs.cod_pais_nasc_int,                                 -- 49 cod_pais_nasc
                                       ifs.num_dni,                                           -- 50 num_dni
                                       ifs.nom_org_emi_dni,                                   -- 51 nom_org_emi_dni
                                       fnc_valida_data(ifs.dat_emi_dni, 'YYYYMMDD'),          -- 52 dat_emi_dni
                                       ifs.num_rne,                                           -- 53 num_ins_reg_nac_est
                                       ifs.nom_org_emi_rne,                                   -- 54 nom_org_emi_est
                                       fnc_valida_data(ifs.dat_emi_rne, 'YYYYMMDD'),          -- 55 dat_emi_rne
                                       ifs.cod_cla_condtrab_int,                              -- 56 cod_cla_condtrab
                                       ifs.flg_conjuge_brasileiro_int,                        -- 57 flg_cas_bra
                                       ifs.flg_filho_com_brasileiro_int,                      -- 58 flg_fil_bra
                                       ifs.num_cnh,                                           -- 59 num_cnh
                                       fnc_valida_data(ifs.dat_emi_cnh, 'YYYYMMDD'),          -- 60 dat_emi_cnh
                                       upper(ifs.cod_uf_emi_cnh),                             -- 61 cod_uf_emi_cnh
                                       fnc_valida_data(ifs.dat_val_cnh, 'YYYYMMDD'),          -- 62 dat_val_cnh
                                       fnc_valida_data(ifs.dat_first_cnh, 'YYYYMMDD'),        -- 63 dat_first_cnh
                                       ifs.cat_cnh,                                           -- 64 cat_cnh
                                       ifs.flg_def_fisica_int,                                -- 65 flg_def_fisica
                                       ifs.flg_def_visual_int,                                -- 66 flg_def_visual
                                       ifs.flg_def_auditiva_int,                              -- 67 flg_def_auditiva
                                       ifs.flg_def_mental_int,                                -- 68 flg_def_mental
                                       ifs.flg_def_intelectual_int,                           -- 69 flg_def_intelectual
                                       ifs.flg_readaptado_int,                                -- 70 flg_readaptado
                                       ifs.flg_cota_deficiencia_int);                                                  -- 72 flg_ult_atu_carga
                              end if;

                          end if;

                          a_log.delete;

                         /* if sql%rowcount > 0 then
                            SP_INCLUI_LOG(a_log, 'COD_INS',              v_tb_pessoa_fisica.cod_ins,                ifs.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',          v_tb_pessoa_fisica.cod_ide_cli,            v_cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'NOM_PESSOA_FISICA',    v_tb_pessoa_fisica.nom_pessoa_fisica,      ifs.nom_servidor);
                            SP_INCLUI_LOG(a_log, 'NUM_RG',               v_tb_pessoa_fisica.num_rg,                 nvl(ifs.num_rg, v_tb_pessoa_fisica.num_rg));
                            SP_INCLUI_LOG(a_log, 'DAT_EMI_RG',           to_char(v_tb_pessoa_fisica.dat_emi_rg, 'dd/mm/yyyy hh24:mi'),          to_char(nvl(fnc_valida_data(ifs.dat_emi_rg, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_emi_rg), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_UF_EMI_RG',        v_tb_pessoa_fisica.cod_uf_emi_rg,          nvl(ifs.cod_uf_emi_rg, v_tb_pessoa_fisica.cod_uf_emi_rg));
                            SP_INCLUI_LOG(a_log, 'COD_ORG_EMI_RG',       v_tb_pessoa_fisica.cod_org_emi_rg,         nvl(substr(ifs.sig_org_emi_rg, 1, 6), v_tb_pessoa_fisica.cod_org_emi_rg));
                            SP_INCLUI_LOG(a_log, 'DAT_NASC',             to_char(v_tb_pessoa_fisica.dat_nasc, 'dd/mm/yyyy hh24:mi'),            to_char(fnc_valida_data(ifs.dat_nasc, 'YYYYMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_OBITO',            to_char(v_tb_pessoa_fisica.dat_obito, 'dd/mm/yyyy hh24:mi'),           to_char(nvl(fnc_valida_data(ifs.dat_obito, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_obito), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_EMI_ATEST_OBITO',  to_char(v_tb_pessoa_fisica.dat_emi_atest_obito, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(ifs.dat_emi_atest_obito, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_emi_atest_obito), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'NOM_RESP_OBITO',       v_tb_pessoa_fisica.nom_resp_obito,         nvl(ifs.nom_resp_obito, v_tb_pessoa_fisica.nom_resp_obito));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_ATEST_OBITO', v_tb_pessoa_fisica.cod_tipo_atest_obito,   nvl(ifs.cod_tipo_atest_obito_int, v_tb_pessoa_fisica.cod_tipo_atest_obito));
                            SP_INCLUI_LOG(a_log, 'NUM_CRM_OBITO',        v_tb_pessoa_fisica.num_crm_obito,          nvl(ifs.num_crm_obito, v_tb_pessoa_fisica.num_crm_obito));
                            SP_INCLUI_LOG(a_log, 'COD_SEXO',             v_tb_pessoa_fisica.cod_sexo,               upper(ifs.cod_sexo));
                            SP_INCLUI_LOG(a_log, 'COD_RACA',             v_tb_pessoa_fisica.cod_raca,               nvl(ifs.cod_raca_int, v_tb_pessoa_fisica.cod_raca));
                            SP_INCLUI_LOG(a_log, 'COD_EST_CIV',          v_tb_pessoa_fisica.cod_est_civ,            nvl(ifs.cod_est_civ_int, v_tb_pessoa_fisica.cod_est_civ));
                            SP_INCLUI_LOG(a_log, 'COD_ESCOLA',           v_tb_pessoa_fisica.cod_escola,             nvl(ifs.cod_escolaridade_int, v_tb_pessoa_fisica.cod_escola));
                            SP_INCLUI_LOG(a_log, 'COD_NACIO',            v_tb_pessoa_fisica.cod_nacio,              nvl(ifs.cod_nacio_int, v_tb_pessoa_fisica.cod_nacio));
                            SP_INCLUI_LOG(a_log, 'DAT_CHEG_PAIS',        to_char(v_tb_pessoa_fisica.dat_cheg_pais, 'dd/mm/yyyy hh24:mi'),       to_char(nvl(trunc(to_date(ifs.ano_cheg_pais, 'YYYY'), 'Y'), v_tb_pessoa_fisica.dat_cheg_pais), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DES_NATURAL',          v_tb_pessoa_fisica.des_natural,            nvl(ifs.des_natural, v_tb_pessoa_fisica.des_natural));
                            SP_INCLUI_LOG(a_log, 'NOM_MAE',              v_tb_pessoa_fisica.nom_mae,                ifs.nom_mae);
                            SP_INCLUI_LOG(a_log, 'NUM_CPF_MAE',          v_tb_pessoa_fisica.num_cpf_mae,            nvl(ifs.num_cpf_mae, v_tb_pessoa_fisica.num_cpf_mae));
                            SP_INCLUI_LOG(a_log, 'NOM_PAI',              v_tb_pessoa_fisica.nom_pai,                nvl(ifs.nom_pai, v_tb_pessoa_fisica.nom_pai));
                            SP_INCLUI_LOG(a_log, 'NUM_CPF_PAI',          v_tb_pessoa_fisica.num_cpf_pai,            nvl(ifs.num_cpf_pai, v_tb_pessoa_fisica.num_cpf_pai));
                            SP_INCLUI_LOG(a_log, 'NUM_TEL_1',            v_tb_pessoa_fisica.num_tel_1,              nvl(ifs.num_tel_residencial, v_tb_pessoa_fisica.num_tel_1));
                            SP_INCLUI_LOG(a_log, 'NUM_TEL_2',            v_tb_pessoa_fisica.num_tel_2,              nvl(ifs.num_tel_comercial, v_tb_pessoa_fisica.num_tel_2));
                            SP_INCLUI_LOG(a_log, 'NUM_TEL_3',            v_tb_pessoa_fisica.num_tel_3,              nvl(ifs.num_tel_contato, v_tb_pessoa_fisica.num_tel_3));
                            SP_INCLUI_LOG(a_log, 'DES_EMAIL',            v_tb_pessoa_fisica.des_email,              nvl(ifs.des_email, v_tb_pessoa_fisica.des_email));
                            SP_INCLUI_LOG(a_log, 'COD_UF_NASC',          v_tb_pessoa_fisica.cod_uf_nasc,            nvl(upper(ifs.cod_uf_nasc), v_tb_pessoa_fisica.cod_uf_nasc));
                            SP_INCLUI_LOG(a_log, 'COD_REG_CASAMENTO',    v_tb_pessoa_fisica.cod_reg_casamento,      nvl(ifs.cod_reg_casamento_int, v_tb_pessoa_fisica.cod_reg_casamento));
                            SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL_1',      v_tb_pessoa_fisica.num_ramal_tel_1,        nvl(ifs.num_ramal_residencial, v_tb_pessoa_fisica.num_ramal_tel_1));
                            SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL_2',      v_tb_pessoa_fisica.num_ramal_tel_2,        nvl(ifs.num_ramal_comercial, v_tb_pessoa_fisica.num_ramal_tel_2));
                            SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL_3',      v_tb_pessoa_fisica.num_ramal_tel_3,        nvl(ifs.num_ramal_contato, v_tb_pessoa_fisica.num_ramal_tel_3));
                            SP_INCLUI_LOG(a_log, 'NUM_TIT_ELE',          v_tb_pessoa_fisica.num_tit_ele,            nvl(ifs.num_tit_ele, v_tb_pessoa_fisica.num_tit_ele));
                            SP_INCLUI_LOG(a_log, 'NUM_ZON_ELE',          v_tb_pessoa_fisica.num_zon_ele,            nvl(ifs.num_zon_tit_ele, v_tb_pessoa_fisica.num_zon_ele));
                            SP_INCLUI_LOG(a_log, 'NUM_SEC_ELE',          v_tb_pessoa_fisica.num_sec_ele,            nvl(ifs.num_sec_ele, v_tb_pessoa_fisica.num_sec_ele));
                            SP_INCLUI_LOG(a_log, 'NUM_CER_RES',          v_tb_pessoa_fisica.num_cer_res,            nvl(ifs.num_cert_reserv, v_tb_pessoa_fisica.num_cer_res));
                            SP_INCLUI_LOG(a_log, 'DAT_CAM',              to_char(v_tb_pessoa_fisica.dat_cam, 'dd/mm/yyyy hh24:mi'),             to_char(nvl(fnc_valida_data(ifs.dat_emi_cert_alist_milit, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_cam), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_SIT_MIL',          v_tb_pessoa_fisica.cod_sit_mil,            nvl(ifs.cod_situ_milit_int, v_tb_pessoa_fisica.cod_sit_mil));
                            SP_INCLUI_LOG(a_log, 'TIP_NUM_TEL_1',        v_tb_pessoa_fisica.tip_num_tel_1,          nvl(ifs.tip_num_tel_1, v_tb_pessoa_fisica.tip_num_tel_1));
                            SP_INCLUI_LOG(a_log, 'TIP_NUM_TEL_2',        v_tb_pessoa_fisica.tip_num_tel_2,          nvl(ifs.tip_num_tel_2, v_tb_pessoa_fisica.tip_num_tel_2));
                            SP_INCLUI_LOG(a_log, 'TIP_NUM_TEL_3',        v_tb_pessoa_fisica.tip_num_tel_3,          nvl(ifs.tip_num_tel_3, v_tb_pessoa_fisica.tip_num_tel_3));
                            SP_INCLUI_LOG(a_log, 'NOM_SOCIAL',           v_tb_pessoa_fisica.nom_social,             nvl(ifs.nom_social, v_tb_pessoa_fisica.nom_social));
                            SP_INCLUI_LOG(a_log, 'COD_PAIS_NASC',        v_tb_pessoa_fisica.cod_pais_nasc,          nvl(ifs.cod_pais_nasc_int, v_tb_pessoa_fisica.cod_pais_nasc));
                            SP_INCLUI_LOG(a_log, 'NUM_DNI',              v_tb_pessoa_fisica.num_dni,                nvl(ifs.num_dni, v_tb_pessoa_fisica.num_dni));
                            SP_INCLUI_LOG(a_log, 'NOM_ORG_EMI_DNI',      v_tb_pessoa_fisica.nom_org_emi_dni,        nvl(ifs.nom_org_emi_dni, v_tb_pessoa_fisica.nom_org_emi_dni));
                            SP_INCLUI_LOG(a_log, 'DAT_EMI_DNI',          to_char(v_tb_pessoa_fisica.dat_emi_dni, 'dd/mm/yyyy hh24:mi'),         to_char(nvl(fnc_valida_data(ifs.dat_emi_dni, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_emi_dni), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'NUM_INS_REG_NAC_EST',  v_tb_pessoa_fisica.num_ins_reg_nac_est,    nvl(ifs.num_rne, v_tb_pessoa_fisica.num_ins_reg_nac_est));
                            SP_INCLUI_LOG(a_log, 'NOM_ORG_EMI_EST',      v_tb_pessoa_fisica.nom_org_emi_est,        nvl(ifs.nom_org_emi_rne, v_tb_pessoa_fisica.nom_org_emi_est));
                            SP_INCLUI_LOG(a_log, 'DAT_EMI_RNE',          to_char(v_tb_pessoa_fisica.dat_emi_rne, 'dd/mm/yyyy hh24:mi'),         to_char(nvl(fnc_valida_data(ifs.dat_emi_rne, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_emi_rne), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_CLA_CONDTRAB',     v_tb_pessoa_fisica.cod_cla_condtrab,       nvl(ifs.cod_cla_condtrab_int, v_tb_pessoa_fisica.cod_cla_condtrab));
                            SP_INCLUI_LOG(a_log, 'FLG_CAS_BRA',          v_tb_pessoa_fisica.flg_cas_bra,            nvl(ifs.flg_conjuge_brasileiro_int, v_tb_pessoa_fisica.flg_cas_bra));
                            SP_INCLUI_LOG(a_log, 'FLG_FIL_BRA',          v_tb_pessoa_fisica.flg_fil_bra,            nvl(ifs.flg_filho_com_brasileiro_int, v_tb_pessoa_fisica.flg_fil_bra));
                            SP_INCLUI_LOG(a_log, 'NUM_CNH',              v_tb_pessoa_fisica.num_cnh,                nvl(ifs.num_cnh, v_tb_pessoa_fisica.num_cnh));
                            SP_INCLUI_LOG(a_log, 'DAT_EMI_CNH',          to_char(v_tb_pessoa_fisica.dat_emi_cnh, 'dd/mm/yyyy hh24:mi'),         to_char(nvl(fnc_valida_data(ifs.dat_emi_cnh, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_emi_cnh), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_UF_EMI_CNH',       v_tb_pessoa_fisica.cod_uf_emi_cnh,         nvl(upper(ifs.cod_uf_emi_cnh), v_tb_pessoa_fisica.cod_uf_emi_cnh));
                            SP_INCLUI_LOG(a_log, 'DAT_VAL_CNH',          to_char(v_tb_pessoa_fisica.dat_val_cnh, 'dd/mm/yyyy hh24:mi'),         to_char(nvl(fnc_valida_data(ifs.dat_val_cnh, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_val_cnh), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIRST_CNH',        to_char(v_tb_pessoa_fisica.dat_first_cnh, 'dd/mm/yyyy hh24:mi'),       to_char(nvl(fnc_valida_data(ifs.dat_first_cnh, 'YYYYMMDD'), v_tb_pessoa_fisica.dat_first_cnh), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'CAT_CNH',              v_tb_pessoa_fisica.cat_cnh,                nvl(ifs.cat_cnh, v_tb_pessoa_fisica.cat_cnh));
                            SP_INCLUI_LOG(a_log, 'FLG_DEF_FISICA',       v_tb_pessoa_fisica.flg_def_fisica,         nvl(ifs.flg_def_fisica_int, v_tb_pessoa_fisica.flg_def_fisica));
                            SP_INCLUI_LOG(a_log, 'FLG_DEF_VISUAL',       v_tb_pessoa_fisica.flg_def_visual,         nvl(ifs.flg_def_visual_int, v_tb_pessoa_fisica.flg_def_visual));
                            SP_INCLUI_LOG(a_log, 'FLG_DEF_AUDITIVA',     v_tb_pessoa_fisica.flg_def_auditiva,       nvl(ifs.flg_def_auditiva_int, v_tb_pessoa_fisica.flg_def_auditiva));
                            SP_INCLUI_LOG(a_log, 'FLG_DEF_MENTAL',       v_tb_pessoa_fisica.flg_def_mental,         nvl(ifs.flg_def_mental_int, v_tb_pessoa_fisica.flg_def_mental));
                            SP_INCLUI_LOG(a_log, 'FLG_DEF_INTELECTUAL',  v_tb_pessoa_fisica.flg_def_intelectual,    nvl(ifs.flg_def_intelectual_int, v_tb_pessoa_fisica.flg_def_intelectual));
                            SP_INCLUI_LOG(a_log, 'FLG_READAPTADO',       v_tb_pessoa_fisica.flg_readaptado,         nvl(ifs.flg_readaptado_int, v_tb_pessoa_fisica.flg_readaptado));
                            SP_INCLUI_LOG(a_log, 'FLG_COTA_DEFICIENCIA', v_tb_pessoa_fisica.flg_cota_deficiencia,   nvl(ifs.flg_cota_deficiencia_int, v_tb_pessoa_fisica.flg_cota_deficiencia));

                            SP_GRAVA_LOG(i_id_header, ifs.id_processo, ifs.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_PESSOA_FISICA', v_nom_rotina, a_log);
                          end if;*/

                          if (   ifs.dat_emi_cert_reserv is not null
                              or ifs.num_cert_alist_milit is not null
                              or ifs.num_tit_ele is not null
                              or ifs.num_nit_inss is not null
                              or ifs.num_pis is not null
                              or ifs.num_ctps is not null
                              or ifs.num_serie_ctps is not null
                              or ifs.dat_emi_ctps is not null
                              or ifs.cod_uf_emi_ctps is not null) then

                              if (v_tb_servidor.cod_ins is not null) then    -- registro ja existe, atualiza

                                  v_cod_tipo_ocorrencia := 'A';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                      update tb_servidor
                                      set num_ctps              = nvl(ifs.num_ctps, num_ctps),
                                          num_serie_ctps        = nvl(ifs.num_serie_ctps, num_serie_ctps),
                                          dat_emi_ctps          = nvl(fnc_valida_data(ifs.dat_emi_ctps, 'YYYYMMDD'), dat_emi_ctps),
                                          cod_uf_emi_ctps       = nvl(upper(ifs.cod_uf_emi_ctps), cod_uf_emi_ctps),
                                          num_pis               = nvl(ltrim(ifs.num_pis,'0'), num_pis),
                                          num_nit_inss          = nvl(ifs.num_nit_inss, num_nit_inss),
                                          dat_ult_atu           = sysdate,
                                          nom_usu_ult_atu       = user,
                                          nom_pro_ult_atu       = v_nom_rotina,
                                          dat_emiss_cert_reserv = nvl(fnc_valida_data(ifs.dat_emi_cert_reserv, 'YYYYMMDD'), dat_emiss_cert_reserv),
                                          num_cert_alist_milit  = nvl(ifs.num_cert_alist_milit, num_cert_alist_milit),
                                          num_tit_ele           = nvl(ifs.num_tit_ele, num_tit_ele)
                                      where cod_ins = ifs.cod_ins
                                        and cod_ide_cli = v_cod_ide_cli
                                        and nom_pro_ult_atu = v_nom_rotina;

                                  end if;

                              else                                -- registro não existe, inclui

                                  v_cod_tipo_ocorrencia := 'I';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                      insert into TB_SERVIDOR
                                          (cod_ins,               -- 1
                                           cod_ide_cli,           -- 2
                                           num_ctps,              -- 3
                                           num_serie_ctps,        -- 4
                                           dat_emi_ctps,          -- 5
                                           cod_uf_emi_ctps,       -- 6
                                           num_pis ,              -- 7
                                           num_nit_inss,          -- 8
                                           dat_ing,               -- 9
                                           dat_ult_atu,           -- 10
                                           nom_usu_ult_atu,       -- 11
                                           nom_pro_ult_atu,       -- 12
                                           dat_emiss_cert_reserv, -- 13
                                           num_cert_alist_milit,  -- 14
                                           num_tit_ele            -- 15                                                -- 16
                                           )
                                      values
                                          (ifs.cod_ins,                                           -- 1 cod_ins
                                           v_cod_ide_cli,                                         -- 2 cod_ide_cli
                                           ifs.num_ctps,                                          -- 3 num_ctps
                                           ifs.num_serie_ctps,                                    -- 4 num_serie_ctps
                                           fnc_valida_data(ifs.dat_emi_ctps, 'YYYYMMDD'),         -- 5 dat_emi_ctps
                                           upper(ifs.cod_uf_emi_ctps),                            -- 6 cod_uf_emi_ctps
                                           ltrim(ifs.num_pis,0),                                           -- 7 num_pis
                                           ifs.num_nit_inss,                                      -- 8 num_nit_inss
                                           sysdate,                                               -- 9 dat_ing
                                           sysdate,                                               -- 10 dat_ult_atu
                                           user,                                                  -- 11 nom_usu_ult_atu
                                           v_nom_rotina,                                          -- 12 nom_pro_ult_atu
                                           fnc_valida_data(ifs.dat_emi_cert_reserv, 'YYYYMMDD'),  -- 13 dat_emiss_cert_reserv
                                           ifs.num_cert_alist_milit,                              -- 14 num_cert_alist_milit
                                           ifs.num_tit_ele);                                      -- 16 flg_ult_atu_carga
                                  end if;

                              end if;

                             /* if sql%rowcount > 0 then
                                a_log.delete;

                                SP_INCLUI_LOG(a_log, 'COD_INS',               v_tb_servidor.cod_ins,              ifs.cod_ins);
                                SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',           v_tb_servidor.cod_ide_cli,          v_cod_ide_cli);
                                SP_INCLUI_LOG(a_log, 'NUM_CTPS',              v_tb_servidor.num_ctps,             nvl(ifs.num_ctps, v_tb_servidor.num_ctps));
                                SP_INCLUI_LOG(a_log, 'NUM_SERIE_CTPS',        v_tb_servidor.num_serie_ctps,       nvl(ifs.num_serie_ctps, v_tb_servidor.num_serie_ctps));
                                SP_INCLUI_LOG(a_log, 'DAT_EMI_CTPS',          to_char(v_tb_servidor.dat_emi_ctps, 'dd/mm/yyyy hh24:mi'),          to_char(nvl(fnc_valida_data(ifs.dat_emi_ctps, 'YYYYMMDD'), v_tb_servidor.dat_emi_ctps), 'dd/mm/yyyy hh24:mi'));
                                SP_INCLUI_LOG(a_log, 'COD_UF_EMI_CTPS',       v_tb_servidor.cod_uf_emi_ctps,      nvl(upper(ifs.cod_uf_emi_ctps), v_tb_servidor.cod_uf_emi_ctps));
                                SP_INCLUI_LOG(a_log, 'NUM_PIS',               v_tb_servidor.num_pis,              nvl(ifs.num_pis, v_tb_servidor.num_pis));
                                SP_INCLUI_LOG(a_log, 'NUM_NIT_INSS',          v_tb_servidor.num_nit_inss,         nvl(ifs.num_nit_inss, v_tb_servidor.num_nit_inss));
                                SP_INCLUI_LOG(a_log, 'DAT_EMISS_CERT_RESERV', to_char(v_tb_servidor.dat_emiss_cert_reserv, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(ifs.dat_emi_cert_reserv, 'YYYYMMDD'), v_tb_servidor.dat_emiss_cert_reserv), 'dd/mm/yyyy hh24:mi'));
                                SP_INCLUI_LOG(a_log, 'NUM_CERT_ALIST_MILIT',  v_tb_servidor.num_cert_alist_milit, nvl(ifs.num_cert_alist_milit, v_tb_servidor.num_cert_alist_milit));
                                SP_INCLUI_LOG(a_log, 'NUM_TIT_ELE',           v_tb_servidor.num_tit_ele,          nvl(ifs.num_tit_ele, v_tb_servidor.num_tit_ele));

                                SP_GRAVA_LOG(i_id_header, ifs.id_processo, ifs.num_linha_header, v_cod_tipo_ocorrencia,
                                             v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_SERVIDOR', v_nom_rotina, a_log);
                            end if;*/
                          end if;
                          --
                          if (ifs.cod_profissao is not null) then

                              v_qtd_prof  := 1;

                              begin
                                  select count(*) qtd
                                  into v_qtd_prof
                                  from tb_pessoa_fisica_prof
                                  where cod_ins       = ifs.cod_ins
                                    and cod_ide_cli   = v_cod_ide_cli
                                    and cod_profissao = ifs.cod_profissao;

                              exception
                                  when others then
                                      null;
                              end;

                              if ((ifs.cod_profissao is not null) and (nvl(v_qtd_prof, 0) = 0)) then

                                  v_cod_tipo_ocorrencia := 'I';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                      insert into tb_pessoa_fisica_prof
                                          (COD_INS,                       -- 1
                                           COD_IDE_CLI,                   -- 2
                                           COD_PROFISSAO,                 -- 3
                                           NUM_CONS_CLASSE,               -- 4
                                           DAT_EMI_REG_CONS_CLASSE,       -- 5
                                           DAT_FIM_VAL_REG_CONS_CLASSE,   -- 6
                                           DAT_ING,                       -- 7
                                           DAT_ULT_ATU,                   -- 8
                                           NOM_USU_ULT_ATU,               -- 9
                                           NOM_PRO_ULT_ATU)               -- 10
                                      values
                                          (ifs.cod_ins,                               -- 1  COD_INS
                                           v_cod_ide_cli,                             -- 2  COD_IDE_CLI
                                           ifs.cod_profissao,                         -- 3  COD_PROFISSAO
                                           ifs.num_reg_cons_classe,                   -- 4  NUM_CONS_CLASSE
                                           fnc_valida_data(ifs.dat_emi_reg_cons_classe, 'YYYYMMDD'),  -- 5  DAT_EMI_REG_CONS_CLASSE
                                           fnc_valida_data(ifs.dat_val_reg_cons_classe, 'YYYYMMDD'),  -- 6  DAT_FIM_VAL_REG_CONS_CLASSE
                                           sysdate,                                   -- 7 DAT_ING
                                           sysdate,                                   -- 8 DAT_ULT_ATU
                                           user,                                      -- 9 NOM_USU_ULT_ATU
                                           v_nom_rotina);                             -- 10 NOM_PRO_ULT_ATU

                                  end if;

                                  a_log.delete;

                               /*   SP_INCLUI_LOG(a_log, 'COD_INS',                     null, ifs.cod_ins);
                                  SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',                 null, v_cod_ide_cli);
                                  SP_INCLUI_LOG(a_log, 'COD_PROFISSAO',               null, ifs.cod_profissao);
                                  SP_INCLUI_LOG(a_log, 'NUM_CONS_CLASSE',             null, ifs.num_reg_cons_classe);
                                  SP_INCLUI_LOG(a_log, 'DAT_EMI_REG_CONS_CLASSE',     null, to_char(fnc_valida_data(ifs.dat_emi_reg_cons_classe, 'YYYYMMDD'), 'dd/mm/yyyy hh24:mi'));
                                  SP_INCLUI_LOG(a_log, 'DAT_FIM_VAL_REG_CONS_CLASSE', null, to_char(fnc_valida_data(ifs.dat_val_reg_cons_classe, 'YYYYMMDD'), 'dd/mm/yyyy hh24:mi'));

                                  SP_GRAVA_LOG(i_id_header, ifs.id_processo, ifs.num_linha_header, v_cod_tipo_ocorrencia,
                                               v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_PESSOA_FISICA_PROF', v_nom_rotina, a_log);
*/
                              end if;

                          end if;

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifs.id, '3', null, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      else

                          SP_GRAVA_ERRO(i_id_header, ifs.id_processo, ifs.num_linha_header,  v_nom_rotina, a_validar);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifs.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      end if;

                  EXCEPTION
                      WHEN OTHERS THEN

                          v_msg_erro := substr(sqlerrm, 1, 4000);

                          rollback to sp1;

                          SP_GRAVA_ERRO(i_id_header, ifs.id_processo, ifs.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifs.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;
                  END;

                end loop;
                --
                commit;
                --
                exit when v_cur_id is null;
                --
            end loop;
            --
            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
          sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina,v_msg_erro);
          commit;
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina,'não foi possivel reservar registros da tabela');

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_IFS;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_IFS (i_ifs       in out  r_ifs,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                   varchar2(2000);
        v_valida_prof               varchar2(5) := 'FALSE';
        v_dat_nasc                  date;
        v_dat_obito                 date;
        v_dat_emi_atest_obito       date;
        v_dat_emi_cert_reserv       date;
        v_dat_emi_cert_alist_milit  date;
        v_dat_emi_rg                date;
        v_dat_emi_ctps              date;
        v_dat_emi_dni               date;
        v_dat_emi_rne               date;
        v_dat_emi_reg_cons_classe   date;
        v_dat_emi_cnh               date;
        v_dat_val_cnh               date;
        v_dat_first_cnh             date;
        v_ano_cheg_pais             date;
        v_dat_val_reg_cons_classe   date;

    BEGIN
        v_dat_nasc                 := fnc_valida_data(i_ifs.dat_nasc);
        v_dat_obito                := fnc_valida_data(i_ifs.dat_obito);
        v_dat_emi_atest_obito      := fnc_valida_data(i_ifs.dat_emi_atest_obito);
        v_dat_emi_cert_reserv      := fnc_valida_data(i_ifs.dat_emi_cert_reserv);
        v_dat_emi_cert_alist_milit := fnc_valida_data(i_ifs.dat_emi_cert_alist_milit);
        v_dat_emi_rg               := fnc_valida_data(i_ifs.dat_emi_rg);
        v_dat_emi_ctps             := fnc_valida_data(i_ifs.dat_emi_ctps);
        v_dat_emi_dni              := fnc_valida_data(i_ifs.dat_emi_dni);
        v_dat_emi_rne              := fnc_valida_data(i_ifs.dat_emi_rne);
        v_dat_emi_reg_cons_classe  := fnc_valida_data(i_ifs.dat_emi_reg_cons_classe);
        v_dat_emi_cnh              := fnc_valida_data(i_ifs.dat_emi_cnh);
        v_dat_val_cnh              := fnc_valida_data(i_ifs.dat_val_cnh);
        v_dat_first_cnh            := fnc_valida_data(i_ifs.dat_first_cnh);
        v_ano_cheg_pais            := fnc_valida_data(i_ifs.ano_cheg_pais);
        v_dat_val_reg_cons_classe  := fnc_valida_data(i_ifs.dat_val_reg_cons_classe);

        -- Valores Default

        if (v_dat_nasc > nvl(v_dat_obito, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de óbito é anterior à data de nascimento','Data obito:'||i_ifs.dat_obito||' Data nasc:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_atest_obito, v_dat_nasc)) then
            SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão do atestado de óbito é anterior à data de nascimento ','Data Emi Atest Obito:'||i_ifs.dat_emi_atest_obito||' Data Nascimento:'||i_ifs.dat_nasc);
         end if;

        if (v_dat_obito is not null and v_dat_emi_atest_obito is not null and v_dat_obito > v_dat_emi_atest_obito) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão do atestado de óbito é anterior à data de óbito ','Data Emi Atest Obito:'||i_ifs.dat_emi_atest_obito||' Data Obito:'||i_ifs.dat_obito);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_cert_reserv, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão do certificado de reservista é anterior à data de nascimento ','Data Emi Cert Reservista:'||i_ifs.dat_emi_cert_reserv||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_cert_alist_milit, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão do certificado de alistamento militar é anterior à data de nascimento ','Data Emi Cert alistamento:'||v_dat_emi_cert_alist_milit||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_rg, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão do RG é anterior à data de nascimento ','Data Emi Cert alistamento:'||v_dat_emi_rg||' Data Nascimento:'||v_dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_ctps, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão da CTPS é anterior à data de nascimento ','Data Emi CTPS:'||i_ifs.dat_emi_ctps||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_dni, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão da DNI é anterior à data de nascimento ','Data Emi DNI:'||i_ifs.dat_emi_dni||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_rne, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão da RNE é anterior à data de nascimento ','Data Emi RNE:'||i_ifs.dat_emi_rne||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_reg_cons_classe, v_dat_nasc)) then
            SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão da Reg Cons Classe é anterior à data de nascimento ','Data Emi Reg Cons Classe:'||i_ifs.dat_emi_reg_cons_classe||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_emi_cnh, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de emissão CNH é anterior à data de nascimento ','Data Emi CNH:'||i_ifs.dat_emi_cnh||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_val_cnh, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de validade CNH é anterior à data de nascimento ','Data Val CNH:'||i_ifs.dat_val_cnh||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (v_dat_nasc > nvl(v_dat_first_cnh, v_dat_nasc)) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Data de primeira CNH é anterior à data de nascimento ','Data prmeira CNH:'||i_ifs.dat_first_cnh||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (trunc(v_dat_nasc, 'Y') > nvl(v_ano_cheg_pais, trunc(v_dat_nasc, 'Y'))) then
             SP_GRAVA_AVISO(i_ifs.id_header, i_ifs.id_processo, i_ifs.num_linha_header, 'MAN','Ano de chegada do servidor estrangeiro ao Brasil é anterior à data de nascimento ','Ano chegada Pais:'||i_ifs.ano_cheg_pais||' Data Nascimento:'||i_ifs.dat_nasc);
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN
            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_IFS;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_IFD (i_id_header in number) IS

        v_result                 varchar2(2000);
        v_cur_id                 tb_carga_gen_ifd.id%type;
        v_flg_acao_postergada    tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_situ_ocorrencia    tb_carga_gen_log.cod_situ_ocorrencia%type;
        v_cod_tipo_ocorrencia    tb_carga_gen_log.cod_tipo_ocorrencia%type;
        a_validar                t_validar;
        a_log                    t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_IFD';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_IFD';
        v_qtd_prof               number;
        v_ret_busca_ide_cli_dep  varchar2(2000);
        v_tb_dependente         tb_dependente%rowtype;
        v_tb_carga_gen_ifs      tb_carga_gen_ifs%rowtype;
        v_tb_carga_gen_ident_ext tb_carga_gen_ident_ext%rowtype;
        v_tb_pessoa_fisica      tb_pessoa_fisica%rowtype;
        v_tb_pessoa_fisica_dep  tb_pessoa_fisica%rowtype;
        v_cod_ide_cli_dep       tb_pessoa_fisica.cod_ide_cli%type;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);
        v_cod_erro              number;
        v_vlr_iteracao          number := 20;
        v_cod_entidade          tb_carga_gen_ident_ext.cod_entidade%type;
        v_id_servidor           tb_Carga_Gen_ifd.Id_Servidor%type;
        v_cod_ide_cli           tb_pessoa_Fisica.cod_ide_cli%type;

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop
                v_result := null;
                v_cur_id := null;

                for ifd in (select a.cod_ins,
                                   a.id_header                          id_header,
                                   trim(a.cod_entidade)                 cod_entidade,
                                   trim(a.id_servidor)                  id_servidor,
                                   trim(a.num_seq_grupo_familiar)       num_seq_grupo_familiar,
                                   trim(a.num_seq_dependente)           num_seq_dependente,
                                   trim(a.cod_tipo_dependencia)         cod_tipo_dependencia,
                                   fnc_codigo_ext(a.cod_ins, 2039, fnc_valida_numero(trim(a.cod_tipo_dependencia)), null, 'COD_PAR') cod_tipo_dependencia_int,
                                   decode(fnc_valida_numero(trim(a.dat_ini_dependencia)),
                                           0, null,
                                           trim(a.dat_ini_dependencia)) dat_ini_dependencia,
                                   trim(a.cod_moti_ini_dependencia)     cod_moti_ini_dependencia,
                                   fnc_codigo_ext(a.cod_ins, 3010, fnc_valida_numero(trim(a.cod_moti_ini_dependencia)), null, 'COD_PAR') cod_moti_ini_dependencia_int,
                                   decode(fnc_valida_numero(trim(a.dat_fim_dependencia)),
                                           0, null,
                                           trim(a.dat_fim_dependencia)) dat_fim_dependencia,
                                   trim(a.cod_moti_fim_dependencia)     cod_moti_fim_dependencia,
                                   fnc_codigo_ext(a.cod_ins, 3011, fnc_valida_numero(trim(a.cod_moti_fim_dependencia)), null, 'COD_PAR') cod_moti_fim_dependencia_int,
                                   trim(a.flg_dep_salario_familia)      flg_dep_salario_familia,
                                   decode(upper(trim(a.flg_dep_salario_familia)), 'S', '1', 'N', '0', null) flg_dep_salario_familia_int,
                                   trim(a.flg_incap_fis_ment_trabalho)  flg_incap_fis_ment_trabalho,
                                   decode(upper(trim(a.flg_incap_fis_ment_trabalho)), 'S', '1', 'N', '0', null) flg_incap_fis_ment_trab_int,
                                   trim(a.flg_dep_imp_renda)            flg_dep_imp_renda,
                                   decode(upper(trim(a.flg_dep_imp_renda)), 'S', '1', 'N', '0', null) flg_dep_imp_renda_int,
                                   trim(a.num_cpf)                      num_cpf,
                                   decode(fnc_valida_numero(trim(a.dat_nasc)),
                                           0, null,
                                           trim(a.dat_nasc)) dat_nasc,
                                   trim(a.cod_sexo)                     cod_sexo,
                                   trim(a.cod_nacio)                    cod_nacio,
                                   fnc_codigo_ext(a.cod_ins, 2007, trim(a.cod_nacio), null, 'COD_PAR') cod_nacio_int,
                                   trim(a.num_cartorio_nasc)            num_cartorio_nasc,
                                   trim(a.num_livro_nasc)               num_livro_nasc,
                                   trim(a.num_folha_nasc)               num_folha_nasc,
                                   trim(a.cod_uf_nasc)                  cod_uf_nasc,
                                   trim(a.des_natural)                  des_natural,
                                   trim(a.cod_raca)                     cod_raca,
                                   fnc_codigo_ext(a.cod_ins, 2004, trim(a.cod_raca), null, 'COD_PAR') cod_raca_int,
                                   trim(a.cod_profissao)                cod_profissao,
                                   trim(a.nom_dep_beneficiario)         nom_dep_beneficiario,
                                   decode(fnc_valida_numero(trim(a.dat_obito)),
                                          0, null,
                                           trim(a.dat_obito)) dat_obito,
                                   decode(fnc_valida_numero(trim(a.dat_emi_atest_obito)),
                                           0, null,
                                           trim(a.dat_emi_atest_obito)) dat_emi_atest_obito,
                                   trim(a.nom_resp_obito)               nom_resp_obito,
                                   trim(a.cod_tipo_atest_obito)         cod_tipo_atest_obito,
                                   fnc_codigo_ext(a.cod_ins, 2073, trim(a.cod_tipo_atest_obito), null, 'COD_PAR') cod_tipo_atest_obito_int,
                                   trim(a.num_crm_obito)                num_crm_obito,
                                   trim(a.nom_mae)                      nom_mae,
                                   trim(a.nom_pai)                      nom_pai,
                                   trim(a.num_cpf_mae)                  num_cpf_mae,
                                   trim(a.num_cpf_pai)                  num_cpf_pai,
                                   trim(a.cod_est_civ)                  cod_est_civ,
                                   fnc_codigo_ext(a.cod_ins, 2005, trim(a.cod_est_civ), null, 'COD_PAR') cod_est_civ_int,
                                   trim(a.num_cert_reserv)              num_cert_reserv,
                                   decode(fnc_valida_numero(trim(a.dat_emi_cert_reserv)),
                                           0, null,
                                           trim(a.dat_emi_cert_reserv)) dat_emi_cert_reserv,
                                   trim(a.num_cert_alist_milit)         num_cert_alist_milit,
                                   decode(fnc_valida_numero(trim(a.dat_emi_cert_alist_milit)),
                                           0, null,
                                           trim(a.dat_emi_cert_alist_milit)) dat_emi_cert_alist_milit,
                                   trim(a.cod_situ_milit)               cod_situ_milit,
                                   fnc_codigo_ext(a.cod_ins, 2012, trim(a.cod_situ_milit), null, 'COD_PAR') cod_situ_milit_int,
                                   trim(a.cod_escolaridade)             cod_escolaridade,
                                   fnc_codigo_ext(a.cod_ins, 2006, trim(a.cod_escolaridade), null, 'COD_PAR') cod_escolaridade_int,
                                   trim(a.cod_reg_casamento)            cod_reg_casamento,
                                   fnc_codigo_ext(a.cod_ins, 2028, trim(a.cod_reg_casamento), null, 'COD_PAR') cod_reg_casamento_int,
                                   decode(fnc_valida_numero(trim(a.ano_cheg_pais)),
                                           0, null,
                                           trim(a.ano_cheg_pais)) ano_cheg_pais,
                                   trim(a.num_tel_residencial)          num_tel_residencial,
                                   decode(trim(a.num_tel_residencial), null, null, '0') tip_num_tel_1,
                                   trim(a.num_ramal_residencial)        num_ramal_residencial,
                                   trim(a.num_tel_comercial)            num_tel_comercial,
                                   decode(trim(a.num_tel_comercial),   null, null, '1') tip_num_tel_2,
                                   trim(a.num_ramal_comercial)          num_ramal_comercial,
                                   trim(a.num_tel_contato)              num_tel_contato,
                                   decode(trim(a.num_tel_contato),     null, null, '3') tip_num_tel_3,
                                   trim(a.num_ramal_contato)            num_ramal_contato,
                                   trim(a.des_email)                    des_email,
                                   trim(a.num_rg)                       num_rg,
                                   trim(a.sig_org_emi_rg)               sig_org_emi_rg,
                                   trim(a.nom_org_emi_rg)               nom_org_emi_rg,
                                   trim(a.cod_uf_emi_rg)                cod_uf_emi_rg,
                                   decode(fnc_valida_numero(trim(a.dat_emi_rg)),
                                           0, null,
                                           trim(a.dat_emi_rg)) dat_emi_rg,
                                   trim(a.num_tit_ele)                  num_tit_ele,
                                   trim(a.num_zon_tit_ele)              num_zon_tit_ele,
                                   trim(a.num_sec_ele)                  num_sec_ele,
                                   a.id, a.num_linha_header, a.id_processo
                            from tb_carga_gen_ifd a
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= v_vlr_iteracao
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    BEGIN
                        savepoint sp1;
                        --
                        v_cur_id                := ifd.id;
                        v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(ifd.id_servidor);
                        v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(ifd.cod_entidade,ifd.id_servidor);
                        --
                        a_validar.delete;
                        v_result := null;
                        --
                        PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                                i_num_linha        => ifd.num_linha_header,
                                                                                o_result           => v_result,
                                                                                o_cod_erro         => v_cod_erro,
                                                                                o_des_erro         => v_msg_erro);

                        --
                        if v_cod_erro is not null then
                          v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                        end if;
                        --
                        if v_result is null then
                          v_result := FNC_VALIDA_IFD(ifd, a_validar);
                        end if;
                        --
                        if v_result is not null then
                          raise_application_error(-20000,'Erro Validação - '||v_result);
                        end if;
                        --
                        v_tb_carga_gen_ifs      := null;
                        v_cod_ide_cli           := null;
                        v_tb_pessoa_fisica      := null;
                        v_tb_pessoa_fisica_dep  := null;
                        v_tb_dependente         := null;
                        v_cod_ide_cli_dep       := null;
                        --
                        v_cod_ide_cli := fnc_ret_cod_ide_cli( ifd.cod_ins, v_id_Servidor);
                        --
                        if FNC_VALIDA_PESSOA_FISICA(ifd.cod_ins, v_cod_ide_cli) is not null then
                           raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                        end if;
                        --
                        begin
                            select *
                            into v_tb_pessoa_fisica
                            from tb_pessoa_fisica
                            where cod_ins     = v_tb_carga_gen_ident_ext.cod_ins
                              and cod_ide_cli = v_cod_ide_cli;
                        exception
                            when others then
                                null;
                        end;
                        --
                        if (v_tb_pessoa_fisica.cod_ins is null) then

                            begin
                                select *
                                into v_tb_carga_gen_ifs
                                from tb_carga_gen_ifs
                                where cod_ins      = ifd.cod_ins
                                  and cod_entidade = ifd.cod_entidade
                                  and id_servidor  = ifd.id_servidor;
                            exception
                                when others then
                                    null;
                            end;

                            begin
                                select *
                                into v_tb_pessoa_fisica
                                from tb_pessoa_fisica
                                where cod_ins = v_tb_carga_gen_ifs.cod_ins
                                  and num_cpf = v_tb_carga_gen_ifs.num_cpf;
                            exception
                                when others then
                                    null;
                            end;

                        end if;

                        if (v_tb_pessoa_fisica.cod_ide_cli is not null) then

                            v_ret_busca_ide_cli_dep  := fnc_busca_ide_cli_dep(ifd.cod_ins, v_tb_pessoa_fisica.cod_ide_cli,
                                                                              ifd.num_seq_grupo_familiar, ifd.num_seq_dependente,
                                                                              ifd.num_cpf, fnc_valida_data(ifd.dat_nasc, 'YYYYMMDD'),
                                                                              ifd.cod_sexo, ifd.nom_dep_beneficiario, ifd.nom_mae,
                                                                              ifd.num_cpf_mae);

                            if (   (v_ret_busca_ide_cli_dep is null )
                                or (substr(upper(v_ret_busca_ide_cli_dep), 1, 4) != 'ERRO')) then

                                if (v_ret_busca_ide_cli_dep is not null) then

                                    begin
                                        select *
                                        into v_tb_dependente
                                        from tb_dependente
                                        where cod_ins          = ifd.cod_ins
                                          and cod_ide_cli_dep  = v_ret_busca_ide_cli_dep
                                          and cod_ide_cli_serv = v_tb_pessoa_fisica.cod_ide_cli;
                                    exception
                                        when others then
                                            null;
                                    end;

                                    begin
                                        select * --cod_ide_cli
                                        into v_tb_pessoa_fisica_dep --v_cod_ide_cli_dep_pfi
                                        from tb_pessoa_fisica
                                        where cod_ins     = ifd.cod_ins
                                          and cod_ide_cli = v_ret_busca_ide_cli_dep;
                                    exception
                                        when others then
                                            null;
                                    end;

                                end if;

                                if v_ret_busca_ide_cli_dep is not null and FNC_VALIDA_PESSOA_FISICA(ifd.cod_ins, v_ret_busca_ide_cli_dep) is not null then
                                  raise_application_error(-20000, 'Dependente possui Benefício cadastrado');
                                end if;

                                if (v_result is null) then

                                    if (v_tb_pessoa_fisica_dep.cod_ide_cli is not null) then -- registro ja existe em tb_pessoa_fisica, atualiza os demais dados

                                        v_cod_ide_cli_dep     := v_tb_pessoa_fisica_dep.cod_ide_cli;
                                        v_cod_tipo_ocorrencia := 'A';

                                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                            update tb_pessoa_fisica
                                            set nom_pessoa_fisica    = ifd.nom_dep_beneficiario,
                                                num_rg               = nvl(LPAD(ifd.num_rg,'0'), num_rg),
                                                dat_emi_rg           = nvl(fnc_valida_data(ifd.dat_emi_rg, 'YYYYMMDD'), dat_emi_rg),
                                                cod_uf_emi_rg        = nvl(ifd.cod_uf_emi_rg, cod_uf_emi_rg),
                                                cod_org_emi_rg       = nvl(substr(ifd.sig_org_emi_rg, 1, 6), cod_org_emi_rg),
                                                dat_nasc             = fnc_valida_data(ifd.dat_nasc, 'YYYYMMDD'),
                                                dat_obito            = nvl(fnc_valida_data(ifd.dat_obito, 'YYYYMMDD'), dat_obito),
                                                dat_emi_atest_obito  = nvl(fnc_valida_data(ifd.dat_emi_atest_obito, 'YYYYMMDD'), dat_emi_atest_obito),
                                                nom_resp_obito       = nvl(ifd.nom_resp_obito, nom_resp_obito),
                                                cod_tipo_atest_obito = nvl(ifd.cod_tipo_atest_obito_int, cod_tipo_atest_obito),
                                                num_crm_obito        = nvl(ifd.num_crm_obito, num_crm_obito),
                                                cod_sexo             = upper(ifd.cod_sexo),
                                                cod_raca             = nvl(ifd.cod_raca_int, cod_raca),
                                                cod_est_civ          = nvl(ifd.cod_est_civ_int, cod_est_civ),
                                                cod_escola           = nvl(ifd.cod_escolaridade_int, cod_escola),
                                                cod_nacio            = nvl(ifd.cod_nacio_int, cod_nacio),
                                                dat_cheg_pais        = nvl(trunc(fnc_valida_data(ifd.ano_cheg_pais, 'YYYY'), 'Y'), dat_cheg_pais),
                                                des_natural          = nvl(ifd.des_natural, des_natural),
                                                nom_mae              = ifd.nom_mae,
                                                num_cpf_mae          = nvl(ifd.num_cpf_mae, num_cpf_mae),
                                                nom_pai              = nvl(ifd.nom_pai, nom_pai),
                                                num_cpf_pai          = nvl(ifd.num_cpf_pai, num_cpf_pai),
                                                num_tel_1            = nvl(ifd.num_tel_residencial, num_tel_1),
                                                num_tel_2            = nvl(ifd.num_tel_comercial, num_tel_2),
                                                num_tel_3            = nvl(ifd.num_tel_contato, num_tel_3),
                                                des_email            = nvl(ifd.des_email, des_email),
                                                cod_uf_nasc          = nvl(upper(ifd.cod_uf_nasc), cod_uf_nasc),
                                                cod_reg_casamento    = nvl(ifd.cod_reg_casamento_int, cod_reg_casamento),
                                                num_ramal_tel_1      = nvl(ifd.num_ramal_residencial, num_ramal_tel_1),
                                                num_ramal_tel_2      = nvl(ifd.num_ramal_comercial, num_ramal_tel_2),
                                                num_ramal_tel_3      = nvl(ifd.num_ramal_contato, num_ramal_tel_3),
                                                num_tit_ele          = nvl(ifd.num_tit_ele, num_tit_ele),
                                                num_zon_ele          = nvl(ifd.num_zon_tit_ele, num_zon_ele),
                                                num_sec_ele          = nvl(ifd.num_sec_ele, num_sec_ele),
                                                num_cer_res          = nvl(ifd.num_cert_reserv, num_cer_res),
                                                dat_cam              = nvl(fnc_valida_data(ifd.dat_emi_cert_alist_milit, 'YYYYMMDD'), dat_cam),
                                                cod_sit_mil          = nvl(ifd.cod_situ_milit_int, cod_sit_mil),
                                                num_cartorio_nasc    = nvl(ifd.num_cartorio_nasc, num_cartorio_nasc),
                                                num_livro_nasc       = nvl(ifd.num_livro_nasc, num_livro_nasc),
                                                num_folha_nasc       = nvl(ifd.num_folha_nasc, num_folha_nasc),
                                                tip_num_tel_1        = nvl(ifd.tip_num_tel_1, tip_num_tel_1),
                                                tip_num_tel_2        = nvl(ifd.tip_num_tel_2, tip_num_tel_2),
                                                tip_num_tel_3        = nvl(ifd.tip_num_tel_3, tip_num_tel_3),
                                                dat_ult_atu          = sysdate,
                                                nom_usu_ult_atu      = user
                                            where cod_ins     = ifd.cod_ins
                                              and cod_ide_cli = v_tb_pessoa_fisica_dep.cod_ide_cli
                                              and nom_pro_ult_atu = v_nom_rotina;

                                        end if;

                                    else                        -- registro não existe, inclui

                                        v_cod_tipo_ocorrencia := 'I';

                                        v_cod_ide_cli_dep := seq_cod_ide_cli.nextval;

                                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                            insert into tb_pessoa_fisica
                                                (cod_ins,               -- 1
                                                 cod_ide_cli,           -- 2
                                                 num_cpf,               -- 3
                                                 nom_pessoa_fisica,     -- 4
                                                 num_rg,                -- 5
                                                 dat_emi_rg,            -- 6
                                                 cod_uf_emi_rg,         -- 7
                                                 cod_org_emi_rg,        -- 8
                                                 dat_nasc,              -- 9
                                                 dat_obito,             -- 10
                                                 dat_emi_atest_obito,   -- 11
                                                 nom_resp_obito,        -- 12
                                                 num_crm_obito,         -- 13
                                                 cod_sexo,              -- 14
                                                 cod_raca,              -- 15
                                                 cod_est_civ,           -- 16
                                                 cod_escola,            -- 17
                                                 cod_nacio,             -- 18
                                                 dat_cheg_pais,         -- 19
                                                 des_natural,           -- 20
                                                 nom_mae,               -- 21
                                                 num_cpf_mae,           -- 22
                                                 nom_pai,               -- 23
                                                 num_cpf_pai,           -- 24
                                                 num_tel_1,             -- 25
                                                 num_tel_2,             -- 26
                                                 num_tel_3,             -- 27
                                                 des_email,             -- 28
                                                 dat_ing,               -- 29
                                                 dat_ult_atu,           -- 30
                                                 nom_usu_ult_atu,       -- 31
                                                 nom_pro_ult_atu,       -- 32
                                                 cod_uf_nasc,           -- 33
                                                 cod_reg_casamento,     -- 34
                                                 num_ramal_tel_1,       -- 35
                                                 num_ramal_tel_2,       -- 36
                                                 num_ramal_tel_3,       -- 37
                                                 num_cartorio_nasc,     -- 38
                                                 num_livro_nasc,        -- 39
                                                 num_folha_nasc,        -- 40
                                                 num_tit_ele,           -- 41
                                                 num_zon_ele,           -- 42
                                                 num_sec_ele,           -- 43
                                                 num_cer_res,           -- 44
                                                 dat_cam,               -- 45
                                                 cod_sit_mil,           -- 46
                                                 tip_num_tel_1,         -- 47
                                                 tip_num_tel_2,         -- 48
                                                 tip_num_tel_3,         -- 49
                                                 cod_tipo_atest_obito)  -- 50
                                            values
                                                (ifd.cod_ins,                                           -- 1 cod_ins
                                                 v_cod_ide_cli_dep,                                     -- 2 cod_ide_cli
                                                 ifd.num_cpf,                                           -- 3 num_cpf
                                                 ifd.nom_dep_beneficiario,                              -- 4 nom_pessoa_fisica
                                                 LPAD(ifd.num_rg,'0'),                                            -- 5 num_rg
                                                 fnc_valida_data(ifd.dat_emi_rg, 'YYYYMMDD'),           -- 6 dat_emi_rg
                                                 ifd.cod_uf_emi_rg,                                     -- 7 cod_uf_emi_rg
                                                 substr(ifd.sig_org_emi_rg, 1, 6),                      -- 8 cod_org_emi_rg
                                                 fnc_valida_data(ifd.dat_nasc, 'YYYYMMDD'),             -- 9 dat_nasc
                                                 fnc_valida_data(ifd.dat_obito, 'YYYYMMDD'),            -- 10 dat_obito
                                                 fnc_valida_data(ifd.dat_emi_atest_obito, 'YYYYMMDD'),  -- 11 dat_emi_atest_obito
                                                 ifd.nom_resp_obito,                                    -- 12 nom_resp_obito
                                                 ifd.num_crm_obito,                                     -- 13 num_crm_obito
                                                 upper(ifd.cod_sexo),                                   -- 14 cod_sexo
                                                 ifd.cod_raca_int,                                      -- 15 cod_raca
                                                 ifd.cod_est_civ_int,                                   -- 16 cod_est_civ
                                                 ifd.cod_escolaridade_int,                              -- 17 cod_escola
                                                 ifd.cod_nacio_int,                                     -- 18 cod_nacio
                                                 trunc(fnc_valida_data(ifd.ano_cheg_pais, 'YYYY'), 'Y'),    -- 19 dat_cheg_pais
                                                 ifd.des_natural,                                       -- 20 des_natural
                                                 ifd.nom_mae,                                           -- 21 nom_mae
                                                 ifd.num_cpf_mae,                                       -- 22 num_cpf_mae
                                                 ifd.nom_pai,                                           -- 23 nom_pai
                                                 ifd.num_cpf_pai,                                       -- 24 num_cpf_pai
                                                 ifd.num_tel_residencial,                               -- 25 num_tel_1
                                                 ifd.num_tel_comercial,                                 -- 26 num_tel_2
                                                 ifd.num_tel_contato,                                   -- 27 num_tel_3
                                                 ifd.des_email,                                         -- 28 des_email
                                                 sysdate,                                               -- 29 dat_ing
                                                 sysdate,                                               -- 30 dat_ult_atu
                                                 user,                                                  -- 31 nom_usu_ult_atu
                                                 v_nom_rotina,                                          -- 32 nom_pro_ult_atu
                                                 upper(ifd.cod_uf_nasc),                                -- 33 cod_uf_nasc
                                                 ifd.cod_reg_casamento_int,                             -- 34 cod_reg_casamento
                                                 ifd.num_ramal_residencial,                             -- 35 num_ramal_tel_1
                                                 ifd.num_ramal_comercial,                               -- 36 num_ramal_tel_2
                                                 ifd.num_ramal_contato,                                 -- 37 num_ramal_tel_3
                                                 ifd.num_cartorio_nasc,                                 -- 38 num_cartorio_nasc
                                                 ifd.num_livro_nasc,                                    -- 39 num_livro_nasc
                                                 ifd.num_folha_nasc,                                    -- 40 num_folha_nasc
                                                 ifd.num_tit_ele,                                       -- 41 num_tit_ele
                                                 ifd.num_zon_tit_ele,                                   -- 42 num_zon_ele
                                                 ifd.num_sec_ele,                                       -- 43 num_sec_ele
                                                 ifd.num_cert_reserv,                                   -- 44 num_cer_res
                                                 fnc_valida_data(ifd.dat_emi_cert_alist_milit, 'YYYYMMDD'), -- 45 dat_cam
                                                 ifd.cod_situ_milit_int,                                -- 46 cod_sit_mil
                                                 ifd.tip_num_tel_1,                                     -- 47 tip_num_tel_1
                                                 ifd.tip_num_tel_2,                                     -- 48 tip_num_tel_2
                                                 ifd.tip_num_tel_3,                                     -- 49 tip_num_tel_3
                                                 ifd.cod_tipo_atest_obito_int);                         -- 50 cod_tipo_atest_obito

                                        end if;

                                    end if;

                                 /*   a_log.delete;
                                    SP_INCLUI_LOG(a_log, 'COD_INS',              v_tb_pessoa_fisica_dep.cod_ins,                ifd.cod_ins);
                                    SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',          v_tb_pessoa_fisica_dep.cod_ide_cli,            v_cod_ide_cli_dep);
                                    SP_INCLUI_LOG(a_log, 'NOM_PESSOA_FISICA',    v_tb_pessoa_fisica_dep.nom_pessoa_fisica,      trim(ifd.nom_dep_beneficiario));
                                    SP_INCLUI_LOG(a_log, 'NUM_RG',               v_tb_pessoa_fisica_dep.num_rg,                 nvl(ifd.num_rg, v_tb_pessoa_fisica_dep.num_rg));
                                    SP_INCLUI_LOG(a_log, 'DAT_EMI_RG',           to_char(v_tb_pessoa_fisica_dep.dat_emi_rg, 'dd/mm/yyyy hh24:mi'),          to_char(nvl(fnc_valida_data(ifd.dat_emi_rg, 'YYYYMMDD'), v_tb_pessoa_fisica_dep.dat_emi_rg), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'COD_UF_EMI_RG',        v_tb_pessoa_fisica_dep.cod_uf_emi_rg,          nvl(ifd.cod_uf_emi_rg, v_tb_pessoa_fisica_dep.cod_uf_emi_rg));
                                    SP_INCLUI_LOG(a_log, 'COD_ORG_EMI_RG',       v_tb_pessoa_fisica_dep.cod_org_emi_rg,         nvl(substr(trim(ifd.sig_org_emi_rg), 1, 6), v_tb_pessoa_fisica_dep.cod_org_emi_rg));
                                    SP_INCLUI_LOG(a_log, 'DAT_NASC',             to_char(v_tb_pessoa_fisica_dep.dat_nasc, 'dd/mm/yyyy hh24:mi'),            to_char(fnc_valida_data(ifd.dat_nasc, 'YYYYMMDD'), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'DAT_OBITO',            to_char(v_tb_pessoa_fisica_dep.dat_obito, 'dd/mm/yyyy hh24:mi'),           to_char(nvl(fnc_valida_data(ifd.dat_obito, 'YYYYMMDD'), v_tb_pessoa_fisica_dep.dat_obito), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'DAT_EMI_ATEST_OBITO',  to_char(v_tb_pessoa_fisica_dep.dat_emi_atest_obito, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(ifd.dat_emi_atest_obito, 'YYYYMMDD'), v_tb_pessoa_fisica_dep.dat_emi_atest_obito), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'NOM_RESP_OBITO',       v_tb_pessoa_fisica_dep.nom_resp_obito,         nvl(trim(ifd.nom_resp_obito), v_tb_pessoa_fisica_dep.nom_resp_obito));
                                    SP_INCLUI_LOG(a_log, 'COD_TIPO_ATEST_OBITO', v_tb_pessoa_fisica_dep.cod_tipo_atest_obito,   nvl(ifd.cod_tipo_atest_obito_int, v_tb_pessoa_fisica_dep.cod_tipo_atest_obito));
                                    SP_INCLUI_LOG(a_log, 'NUM_CRM_OBITO',        v_tb_pessoa_fisica_dep.num_crm_obito,          nvl(ifd.num_crm_obito, v_tb_pessoa_fisica_dep.num_crm_obito));
                                    SP_INCLUI_LOG(a_log, 'COD_SEXO',             v_tb_pessoa_fisica_dep.cod_sexo,               upper(ifd.cod_sexo));
                                    SP_INCLUI_LOG(a_log, 'COD_RACA',             v_tb_pessoa_fisica_dep.cod_raca,               nvl(ifd.cod_raca_int, v_tb_pessoa_fisica_dep.cod_raca));
                                    SP_INCLUI_LOG(a_log, 'COD_EST_CIV',          v_tb_pessoa_fisica_dep.cod_est_civ,            nvl(ifd.cod_est_civ_int, v_tb_pessoa_fisica_dep.cod_est_civ));
                                    SP_INCLUI_LOG(a_log, 'COD_ESCOLA',           v_tb_pessoa_fisica_dep.cod_escola,             nvl(ifd.cod_escolaridade_int, v_tb_pessoa_fisica_dep.cod_escola));
                                    SP_INCLUI_LOG(a_log, 'COD_NACIO',            v_tb_pessoa_fisica_dep.cod_nacio,              nvl(ifd.cod_nacio_int, v_tb_pessoa_fisica_dep.cod_nacio));
                                    SP_INCLUI_LOG(a_log, 'DAT_CHEG_PAIS',        to_char(v_tb_pessoa_fisica_dep.dat_cheg_pais, 'dd/mm/yyyy hh24:mi'),       to_char(nvl(trunc(fnc_valida_data(ifd.ano_cheg_pais, 'YYYY'), 'Y'), v_tb_pessoa_fisica_dep.dat_cheg_pais), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'DES_NATURAL',          v_tb_pessoa_fisica_dep.des_natural,            nvl(trim(ifd.des_natural), v_tb_pessoa_fisica_dep.des_natural));
                                    SP_INCLUI_LOG(a_log, 'NOM_MAE',              v_tb_pessoa_fisica_dep.nom_mae,                trim(ifd.nom_mae));
                                    SP_INCLUI_LOG(a_log, 'NUM_CPF_MAE',          v_tb_pessoa_fisica_dep.num_cpf_mae,            nvl(ifd.num_cpf_mae, v_tb_pessoa_fisica_dep.num_cpf_mae));
                                    SP_INCLUI_LOG(a_log, 'NOM_PAI',              v_tb_pessoa_fisica_dep.nom_pai,                nvl(trim(ifd.nom_pai), v_tb_pessoa_fisica_dep.nom_pai));
                                    SP_INCLUI_LOG(a_log, 'NUM_CPF_PAI',          v_tb_pessoa_fisica_dep.num_cpf_pai,            nvl(ifd.num_cpf_pai, v_tb_pessoa_fisica_dep.num_cpf_pai));
                                    SP_INCLUI_LOG(a_log, 'NUM_TEL_1',            v_tb_pessoa_fisica_dep.num_tel_1,              nvl(ifd.num_tel_residencial, v_tb_pessoa_fisica_dep.num_tel_1));
                                    SP_INCLUI_LOG(a_log, 'NUM_TEL_2',            v_tb_pessoa_fisica_dep.num_tel_2,              nvl(ifd.num_tel_comercial, v_tb_pessoa_fisica_dep.num_tel_2));
                                    SP_INCLUI_LOG(a_log, 'NUM_TEL_3',            v_tb_pessoa_fisica_dep.num_tel_3,              nvl(ifd.num_tel_contato, v_tb_pessoa_fisica_dep.num_tel_3));
                                    SP_INCLUI_LOG(a_log, 'DES_EMAIL',            v_tb_pessoa_fisica_dep.des_email,              nvl(ifd.des_email, v_tb_pessoa_fisica_dep.des_email));
                                    SP_INCLUI_LOG(a_log, 'COD_UF_NASC',          v_tb_pessoa_fisica_dep.cod_uf_nasc,            nvl(upper(ifd.cod_uf_nasc), v_tb_pessoa_fisica_dep.cod_uf_nasc));
                                    SP_INCLUI_LOG(a_log, 'COD_REG_CASAMENTO',    v_tb_pessoa_fisica_dep.cod_reg_casamento,      nvl(ifd.cod_reg_casamento_int, v_tb_pessoa_fisica_dep.cod_reg_casamento));
                                    SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL_1',      v_tb_pessoa_fisica_dep.num_ramal_tel_1,        nvl(ifd.num_ramal_residencial, v_tb_pessoa_fisica_dep.num_ramal_tel_1));
                                    SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL_2',      v_tb_pessoa_fisica_dep.num_ramal_tel_2,        nvl(ifd.num_ramal_comercial, v_tb_pessoa_fisica_dep.num_ramal_tel_2));
                                    SP_INCLUI_LOG(a_log, 'NUM_RAMAL_TEL_3',      v_tb_pessoa_fisica_dep.num_ramal_tel_3,        nvl(ifd.num_ramal_contato, v_tb_pessoa_fisica_dep.num_ramal_tel_3));
                                    SP_INCLUI_LOG(a_log, 'NUM_TIT_ELE',          v_tb_pessoa_fisica_dep.num_tit_ele,            nvl(ifd.num_tit_ele, v_tb_pessoa_fisica_dep.num_tit_ele));
                                    SP_INCLUI_LOG(a_log, 'NUM_ZON_ELE',          v_tb_pessoa_fisica_dep.num_zon_ele,            nvl(ifd.num_zon_tit_ele, v_tb_pessoa_fisica_dep.num_zon_ele));
                                    SP_INCLUI_LOG(a_log, 'NUM_SEC_ELE',          v_tb_pessoa_fisica_dep.num_sec_ele,            nvl(ifd.num_sec_ele, v_tb_pessoa_fisica_dep.num_sec_ele));
                                    SP_INCLUI_LOG(a_log, 'NUM_CER_RES',          v_tb_pessoa_fisica_dep.num_cer_res,            nvl(ifd.num_cert_reserv, v_tb_pessoa_fisica_dep.num_cer_res));
                                    SP_INCLUI_LOG(a_log, 'DAT_CAM',              to_char(v_tb_pessoa_fisica_dep.dat_cam, 'dd/mm/yyyy hh24:mi'),             to_char(nvl(fnc_valida_data(ifd.dat_emi_cert_alist_milit, 'YYYYMMDD'), v_tb_pessoa_fisica_dep.dat_cam), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'COD_SIT_MIL',          v_tb_pessoa_fisica_dep.cod_sit_mil,            nvl(ifd.cod_situ_milit_int, v_tb_pessoa_fisica_dep.cod_sit_mil));
                                    SP_INCLUI_LOG(a_log, 'NUM_CARTORIO_NASC',    v_tb_pessoa_fisica_dep.num_cartorio_nasc,      nvl(ifd.num_cartorio_nasc, v_tb_pessoa_fisica_dep.num_cartorio_nasc));
                                    SP_INCLUI_LOG(a_log, 'NUM_LIVRO_NASC',       v_tb_pessoa_fisica_dep.num_livro_nasc,         nvl(ifd.num_livro_nasc, v_tb_pessoa_fisica_dep.num_livro_nasc));
                                    SP_INCLUI_LOG(a_log, 'NUM_FOLHA_NASC',       v_tb_pessoa_fisica_dep.num_folha_nasc,         nvl(ifd.num_folha_nasc, v_tb_pessoa_fisica_dep.num_folha_nasc));
                                    SP_INCLUI_LOG(a_log, 'TIP_NUM_TEL_1',        v_tb_pessoa_fisica_dep.tip_num_tel_1,          nvl(ifd.tip_num_tel_1, v_tb_pessoa_fisica_dep.tip_num_tel_1));
                                    SP_INCLUI_LOG(a_log, 'TIP_NUM_TEL_2',        v_tb_pessoa_fisica_dep.tip_num_tel_2,          nvl(ifd.tip_num_tel_2, v_tb_pessoa_fisica_dep.tip_num_tel_2));
                                    SP_INCLUI_LOG(a_log, 'TIP_NUM_TEL_3',        v_tb_pessoa_fisica_dep.tip_num_tel_3,          nvl(ifd.tip_num_tel_3, v_tb_pessoa_fisica_dep.tip_num_tel_3));

                                    SP_GRAVA_LOG(i_id_header, ifd.id_processo, ifd.num_linha_header, v_cod_tipo_ocorrencia,
                                                 v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_PESSOA_FISICA', v_nom_rotina, a_log);*/

                                    if (v_tb_dependente.cod_ide_cli_dep is not null) then    -- registro ja existe, atualiza

                                        v_cod_tipo_ocorrencia := 'A';

                                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                            update tb_dependente
                                            set num_gru_fam     = ifd.num_seq_grupo_familiar,
                                                num_depend      = ifd.num_seq_dependente,
                                                cod_parentesco  = ifd.cod_tipo_dependencia_int,
                                                dat_ini_dep     = nvl(fnc_valida_data(ifd.dat_ini_dependencia, 'YYYYMMDD'), dat_ini_dep),
                                                cod_mot_ini_dep = ifd.cod_moti_ini_dependencia_int,
                                                dat_fim_dep     = nvl(fnc_valida_data(ifd.dat_fim_dependencia, 'YYYYMMDD'), dat_fim_dep),
                                                cod_mot_fim_dep = nvl(ifd.cod_moti_fim_dependencia_int, cod_mot_fim_dep),
                                                flg_sal_fam     = nvl(ifd.flg_dep_salario_familia_int, flg_sal_fam),
                                                flg_dep_ir      = nvl(ifd.flg_dep_imp_renda_int, flg_dep_ir),
                                                flg_incap_fis_ment_trabalho = nvl(ifd.flg_incap_fis_ment_trab_int, flg_incap_fis_ment_trabalho),
                                                dat_ult_atu     = sysdate,
                                                nom_usu_ult_atu = user,
                                                nom_pro_ult_atu = v_nom_rotina
                                            where cod_ins          = ifd.cod_ins
                                              and cod_ide_cli_serv = v_tb_pessoa_fisica.cod_ide_cli
                                              and cod_ide_cli_dep  = v_cod_ide_cli_dep
                                              and nom_pro_ult_atu = v_nom_rotina;

                                        end if;

                                    else                                -- registro não existe, inclui

                                        v_cod_tipo_ocorrencia := 'I';

                                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                            insert into tb_dependente
                                                (cod_ins,                       -- 1
                                                 cod_ide_cli_serv,              -- 2
                                                 cod_ide_cli_dep,               -- 3
                                                 num_gru_fam,                   -- 4
                                                 num_depend,                    -- 5
                                                 cod_parentesco,                -- 6
                                                 dat_ini_dep,                   -- 7
                                                 cod_mot_ini_dep,               -- 8
                                                 dat_fim_dep,                   -- 9
                                                 cod_mot_fim_dep,               -- 10
                                                 flg_sal_fam,                   -- 11
                                                 flg_dep_ir,                    -- 12
                                                 dat_ing,                       -- 13
                                                 dat_ult_atu,                   -- 14
                                                 nom_usu_ult_atu,               -- 15
                                                 nom_pro_ult_atu,               -- 16
                                                 flg_incap_fis_ment_trabalho)   -- 17
                                            values
                                                (ifd.cod_ins,                                           -- 1  cod_ins
                                                 v_tb_pessoa_fisica.cod_ide_cli,                        -- 2  cod_ide_cli_serv
                                                 v_cod_ide_cli_dep,                                     -- 3  cod_ide_cli_dep
                                                 ifd.num_seq_grupo_familiar,                            -- 4  num_gru_fam
                                                 ifd.num_seq_dependente,                                -- 5  num_depend
                                                 ifd.cod_tipo_dependencia_int,                          -- 6  cod_parentesco
                                                 fnc_valida_data(ifd.dat_ini_dependencia, 'YYYYMMDD'),  -- 7  dat_ini_dep
                                                 ifd.cod_moti_ini_dependencia_int,                      -- 8  cod_mot_ini_dep
                                                 fnc_valida_data(ifd.dat_fim_dependencia, 'YYYYMMDD'),  -- 9  dat_fim_dep
                                                 ifd.cod_moti_fim_dependencia_int,                      -- 10 cod_mot_fim_dep
                                                 ifd.flg_dep_salario_familia_int,                       -- 11 flg_sal_fam
                                                 ifd.flg_dep_imp_renda_int,                             -- 12 flg_dep_ir
                                                 sysdate,                                               -- 13 dat_ing
                                                 sysdate,                                               -- 14 dat_ult_atu
                                                 user,                                                  -- 15 nom_usu_ult_atu
                                                 v_nom_rotina,                                          -- 16 nom_pro_ult_atu
                                                 ifd.flg_incap_fis_ment_trab_int);                      -- 17 flg_incap_fis_ment_trabalho

                                        end if;

                                    end if;

                                  /*  a_log.delete;
                                    SP_INCLUI_LOG(a_log, 'COD_INS',             v_tb_dependente.cod_ins,            ifd.cod_ins);
                                    SP_INCLUI_LOG(a_log, 'COD_IDE_CLI_SERV',    v_tb_dependente.cod_ide_cli_serv,   v_tb_pessoa_fisica.cod_ide_cli);
                                    SP_INCLUI_LOG(a_log, 'COD_IDE_CLI_DEP',     v_tb_dependente.cod_ide_cli_dep,    v_cod_ide_cli_dep);
                                    SP_INCLUI_LOG(a_log, 'NUM_GRU_FAM',         v_tb_dependente.num_gru_fam,        ifd.num_seq_grupo_familiar);
                                    SP_INCLUI_LOG(a_log, 'NUM_DEPEND',          v_tb_dependente.num_depend,         ifd.num_seq_dependente);
                                    SP_INCLUI_LOG(a_log, 'COD_PARENTESCO',      v_tb_dependente.cod_parentesco,     ifd.cod_tipo_dependencia_int);
                                    SP_INCLUI_LOG(a_log, 'DAT_INI_DEP',         to_char(v_tb_dependente.dat_ini_dep, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(ifd.dat_ini_dependencia, 'YYYYMMDD'), v_tb_dependente.dat_ini_dep), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'COD_MOT_INI_DEP',     v_tb_dependente.cod_mot_ini_dep,    ifd.cod_moti_ini_dependencia_int);
                                    SP_INCLUI_LOG(a_log, 'DAT_FIM_DEP',         to_char(v_tb_dependente.dat_fim_dep, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(ifd.dat_fim_dependencia, 'YYYYMMDD'), v_tb_dependente.dat_fim_dep), 'dd/mm/yyyy hh24:mi'));
                                    SP_INCLUI_LOG(a_log, 'COD_MOT_FIM_DEP',     v_tb_dependente.cod_mot_fim_dep,    nvl(ifd.cod_moti_fim_dependencia_int, v_tb_dependente.cod_mot_fim_dep));
                                    SP_INCLUI_LOG(a_log, 'FLG_SAL_FAM',         v_tb_dependente.flg_sal_fam,        nvl(ifd.flg_dep_salario_familia_int, v_tb_dependente.flg_sal_fam));
                                    SP_INCLUI_LOG(a_log, 'FLG_DEP_IR',          v_tb_dependente.flg_dep_ir,         nvl(ifd.flg_dep_imp_renda_int, v_tb_dependente.flg_dep_ir));
                                    SP_INCLUI_LOG(a_log, 'FLG_INCAP_FIS_MENT_TRABALHO', v_tb_dependente.flg_incap_fis_ment_trabalho,        nvl(ifd.flg_incap_fis_ment_trab_int, v_tb_dependente.flg_incap_fis_ment_trabalho));

                                    SP_GRAVA_LOG(i_id_header, ifd.id_processo, ifd.num_linha_header, v_cod_tipo_ocorrencia,
                                                 v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_DEPENDENTE', v_nom_rotina, a_log);
                                    */
                                    if (ifd.cod_profissao is not null) then

                                        v_qtd_prof  := 1;

                                        begin
                                            select count(*) qtd
                                            into v_qtd_prof
                                            from tb_pessoa_fisica_prof
                                            where cod_ins       = ifd.cod_ins
                                              and cod_ide_cli   = v_cod_ide_cli_dep
                                              and cod_profissao = ifd.cod_profissao;

                                        exception
                                            when others then
                                                null;
                                        end;

                                        if ((ifd.cod_profissao is not null) and (nvl(v_qtd_prof, 0) = 0)) then

                                            v_cod_tipo_ocorrencia := 'I';

                                            if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                                insert into tb_pessoa_fisica_prof
                                                    (COD_INS,           -- 1
                                                     COD_IDE_CLI,       -- 2
                                                     COD_PROFISSAO,     -- 3
                                                     DAT_ING,           -- 4
                                                     DAT_ULT_ATU,       -- 5
                                                     NOM_USU_ULT_ATU,   -- 6
                                                     NOM_PRO_ULT_ATU)   -- 7
                                                values
                                                    (ifd.cod_ins,       -- 1  COD_INS
                                                     v_cod_ide_cli_dep, -- 2  COD_IDE_CLI
                                                     ifd.cod_profissao, -- 3  COD_PROFISSAO
                                                     sysdate,           -- 4  DAT_ING
                                                     sysdate,           -- 5  DAT_ULT_ATU
                                                     user,              -- 6  NOM_USU_ULT_ATU
                                                     v_nom_rotina);     -- 7  NOM_PRO_ULT_ATU
                                            end if;

                                            a_log.delete;
                                            SP_INCLUI_LOG(a_log, 'COD_INS',       null, ifd.cod_ins);
                                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',   null, v_cod_ide_cli_dep);
                                            SP_INCLUI_LOG(a_log, 'COD_PROFISSAO', null, ifd.cod_profissao);

                                            SP_GRAVA_LOG(i_id_header, ifd.id_processo, ifd.num_linha_header, v_cod_tipo_ocorrencia,
                                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_PESSOA_FISICA_PROF', v_nom_rotina, a_log);

                                        end if;

                                    end if;

                                    if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifd.id, '3', null, v_nom_rotina) != 'TRUE') then
                                        raise ERRO_GRAVA_STATUS;
                                    end if;

                                else

                                    SP_GRAVA_ERRO(i_id_header, ifd.id_processo, ifd.num_linha_header, v_nom_rotina, a_validar);

                                    if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifd.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                        raise ERRO_GRAVA_STATUS;
                                    end if;

                                end if;

                            else

                                if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifd.id, '4', substr(v_ret_busca_ide_cli_dep, 6), v_nom_rotina) != 'TRUE') then
                                    raise ERRO_GRAVA_STATUS;
                                end if;

                            end if;

                        else

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifd.id, '4', 'Dados do servidor não localizados', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, ifd.id_processo, ifd.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ifd.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
          SP_ATUALIZA_HEADER (v_nom_tabela,i_id_header, v_nom_rotina, v_msg_erro);
        end if;
        --
        commit;
    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_IFD;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_IFD (i_ifd       in     r_ifd,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                   varchar2(2000);
        v_dat_nasc                  date;
        v_dat_ini_dependencia       date;
        v_dat_fim_dependencia       date;
        v_dat_obito                 date;
        v_dat_emi_atest_obito       date;
        v_dat_emi_cert_reserv       date;
        v_dat_emi_cert_alist_milit  date;
        v_ano_cheg_pais             date;
        v_dat_emi_rg                date;

    BEGIN

        o_a_validar.delete;

        v_dat_nasc                 := fnc_valida_data(i_ifd.dat_nasc);
        v_dat_obito                := fnc_valida_data(i_ifd.dat_obito);
        v_dat_emi_atest_obito      := fnc_valida_data(i_ifd.dat_emi_atest_obito);
        v_dat_emi_cert_reserv      := fnc_valida_data(i_ifd.dat_emi_cert_reserv);
        v_dat_emi_cert_alist_milit := fnc_valida_data(i_ifd.dat_emi_cert_alist_milit);
        v_dat_emi_rg               := fnc_valida_data(i_ifd.dat_emi_rg);
        v_dat_ini_dependencia      := fnc_valida_data(i_ifd.dat_ini_dependencia);
        v_dat_fim_dependencia      := fnc_valida_data(i_ifd.dat_fim_dependencia);


        if (i_ifd.ano_cheg_pais is not null) then
            v_ano_cheg_pais := fnc_valida_data(i_ifd.ano_cheg_pais, 'RRRR');
            if (length(trim(i_ifd.ano_cheg_pais)) < 4 or v_ano_cheg_pais is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ANO_CHEG_PAIS', 'Ano de chegada do servidor estrangeiro ao Brasil ('||i_ifd.ano_cheg_pais||') está em formato diferente do esperado (AAAA)');
            end if;
        end if;

        if (v_dat_nasc is not null) then

            if (nvl(v_dat_ini_dependencia, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_DEPENDENCIA', 'Data de início de dependência ('||i_ifd.dat_ini_dependencia||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_dat_fim_dependencia, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_DEPENDENCIA', 'Data de fim de dependência ('||i_ifd.dat_fim_dependencia||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_dat_obito, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_OBITO', 'Data de óbito ('||i_ifd.dat_obito||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_dat_emi_atest_obito, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_ATEST_OBITO', 'Data de emissão do atestado de óbito ('||i_ifd.dat_emi_atest_obito||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_dat_emi_cert_reserv, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_CERT_RESERV', 'Data de emissão do certificado de reservista ('||i_ifd.dat_emi_cert_reserv||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_dat_emi_cert_alist_milit, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_CERT_ALIST_MILIT', 'Data de emissão do certificado de alistamento militar ('||i_ifd.dat_emi_cert_alist_milit||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_ano_cheg_pais, trunc(v_dat_nasc, 'Y')) < trunc(v_dat_nasc, 'Y')) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ANO_CHEG_PAIS', 'Ano de chegada do servidor estrangeiro ao país ('||i_ifd.ano_cheg_pais||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

            if (nvl(v_dat_emi_rg, v_dat_nasc) < v_dat_nasc) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_RG', 'Data de emissão do RG ('||i_ifd.dat_emi_rg||') é anterior à data de nascimento ('||i_ifd.dat_nasc||')');
            end if;

        end if;

        if (nvl(v_dat_ini_dependencia, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, '', 'Data de início da dependência ('||i_ifd.dat_ini_dependencia||') é posterior à data atual');
        end if;

        if (nvl(v_dat_fim_dependencia, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, '', 'Data de fim da dependência ('||i_ifd.dat_fim_dependencia||') é posterior à data atual');
        end if;

        if (v_dat_ini_dependencia is not null and v_dat_fim_dependencia is not null and v_dat_ini_dependencia > v_dat_fim_dependencia) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_DEPENDENCIA', 'Data de início da dependência ('||i_ifd.dat_ini_dependencia||') é posterior à data de fim da dependência ('||i_ifd.dat_fim_dependencia||')');
        end if;

        if (nvl(v_dat_obito, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_OBITO', 'Data de óbito ('||i_ifd.dat_obito||') é posterior à data atual');
        end if;

        if (nvl(v_dat_emi_atest_obito, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_ATEST_OBITO', 'Data de emissão do atestado de óbito ('||i_ifd.dat_emi_atest_obito||') é posterior à data atual)');
        end if;

        if (v_dat_obito is not null and v_dat_emi_atest_obito is not null and v_dat_obito > v_dat_emi_atest_obito) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_OBITO', 'Data de óbito ('||i_ifd.dat_obito||') é posterior à data de emissão do atestado de óbito ('||i_ifd.dat_emi_atest_obito||')');
        end if;

        if (nvl(v_dat_emi_cert_reserv, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_CERT_RESERV', 'Data de emissão do certificado de reservista ('||i_ifd.dat_emi_cert_reserv||') é posterior à data atual');
        end if;

        if (nvl(v_dat_emi_cert_alist_milit, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_CERT_ALIST_MILIT', 'Data de emissão do certificado de alistamento militar ('||i_ifd.dat_emi_cert_alist_milit||') é posterior à data atual');
        end if;

        if (nvl(v_ano_cheg_pais, trunc(sysdate, 'Y')) > trunc(sysdate, 'Y')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ANO_CHEG_PAIS', 'Ano de chegada do servidor estrangeiro ao país ('||i_ifd.ano_cheg_pais||') é posterior ao ano atual');
        end if;

        if (nvl(v_dat_emi_rg, trunc(sysdate)) > trunc(sysdate)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_RG', 'Data de emissão do RG ('||i_ifd.dat_emi_rg||') é posterior à data atual');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_IFD;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_IDE_CLI_DEP(i_cod_ins                in tb_pessoa_fisica.cod_ins%type,
                                   i_cod_ide_cli_serv       in tb_pessoa_fisica.cod_ide_cli%type,
                                   i_num_seq_grupo_familiar in tb_dependente.num_gru_fam%type,
                                   i_num_seq_dependente     in tb_dependente.num_depend%type,
                                   i_num_cpf                in tb_pessoa_fisica.num_cpf%type,
                                   i_dat_nasc               in tb_pessoa_fisica.dat_nasc%type,
                                   i_cod_sexo               in tb_pessoa_fisica.cod_sexo%type,
                                   i_nom_dep_beneficiario   in tb_pessoa_fisica.nom_pessoa_fisica%type,
                                   i_nom_mae                in tb_pessoa_fisica.nom_mae%type,
                                   i_num_cpf_mae            in tb_pessoa_fisica.num_cpf_mae%type)
            return varchar2 IS

        v_retorno             tb_pessoa_fisica.cod_ide_cli%type;
        v_qtd_rec             number := 0;
        v_linha_pessoa_fisica tb_pessoa_fisica%rowtype;

    BEGIN

        if (i_num_cpf is not null and fnc_valida_numero(i_num_cpf) != 0) then

            -- pesquisando pelo cpf no dependente/beneficiario
            select count(*)
            into v_qtd_rec
            from tb_pessoa_fisica
            where cod_ins = i_cod_ins
              and num_cpf = i_num_cpf;

            if (v_qtd_rec = 1) then

                select *
                into v_linha_pessoa_fisica
                from tb_pessoa_fisica
                where cod_ins = i_cod_ins
                  and num_cpf = i_num_cpf;

                if (    (   (v_linha_pessoa_fisica.dat_nasc         is null)
                         or (v_linha_pessoa_fisica.dat_nasc         = i_dat_nasc))
                    and (v_linha_pessoa_fisica.cod_sexo             = i_cod_sexo)
                    and (upper(trim(v_linha_pessoa_fisica.nom_pessoa_fisica)) = upper(trim(i_nom_dep_beneficiario)))
                    and (   (v_linha_pessoa_fisica.nom_mae          is null)
                         or (upper(trim(v_linha_pessoa_fisica.nom_mae))          = upper(trim(i_nom_mae))))
                    and (   (v_linha_pessoa_fisica.num_cpf_mae      is null)
                         or (i_num_cpf_mae                          is null)
                         or (v_linha_pessoa_fisica.num_cpf_mae      = i_num_cpf_mae)) ) then

                    return (v_linha_pessoa_fisica.cod_ide_cli);

                end if;

            end if;

        end if;

        -- pesquisando pelo servidor + sequencia do grupo familiar + sequencia do dependente
        select count(*)
        into v_qtd_rec
        from tb_dependente a
        where a.cod_ins          = i_cod_ins
          and a.cod_ide_cli_serv = i_cod_ide_cli_serv
          and a.num_gru_fam      = i_num_seq_grupo_familiar
          and a.num_depend       = i_num_seq_dependente;

        if (v_qtd_rec = 0) then

            null;

        elsif (v_qtd_rec > 1) then

            return substr('ERRO Mais de um registro cadastrado em TB_DEPENDENTE com a mesma configuração de numero de sequencia'||
                                ' do grupo familiar ('||i_num_seq_grupo_familiar||') e numero de sequencia do dependente'||
                                ' ('||i_num_seq_dependente||') para cod_ins = '|| i_cod_ins ||
                                ' e cod_ide_cli_serv = '||i_cod_ide_cli_serv,
                           1, 2000);

        else

            select a.cod_ide_cli_dep
            into v_retorno
            from tb_dependente a
            where a.cod_ins          = i_cod_ins
              and a.cod_ide_cli_serv = i_cod_ide_cli_serv
              and a.num_gru_fam      = i_num_seq_grupo_familiar
              and a.num_depend       = i_num_seq_dependente;

            select *
            into v_linha_pessoa_fisica
            from tb_pessoa_fisica
            where cod_ins = i_cod_ins
              and cod_ide_cli = v_retorno;

            if (    (   (v_linha_pessoa_fisica.dat_nasc         is null)
                     or (v_linha_pessoa_fisica.dat_nasc         = i_dat_nasc))
                and (v_linha_pessoa_fisica.cod_sexo             = i_cod_sexo)
                and (upper(trim(v_linha_pessoa_fisica.nom_pessoa_fisica)) = upper(trim(i_nom_dep_beneficiario)))
                and (   (v_linha_pessoa_fisica.nom_mae          is null)
                     or (upper(trim(v_linha_pessoa_fisica.nom_mae))          = upper(trim(i_nom_mae))))
                and (   (v_linha_pessoa_fisica.num_cpf_mae      is null)
                     or (i_num_cpf_mae                          is null)
                     or (v_linha_pessoa_fisica.num_cpf_mae      = i_num_cpf_mae)) ) then

                return (v_retorno);

            else

                return substr('ERRO Localizado cadastro de dependente para cod_ins = '||i_cod_ins||
                                    ', cod_ide_cli_serv = '||i_cod_ide_cli_serv||', numero de sequencia'||
                                    ' do grupo familiar = '||i_num_seq_grupo_familiar||
                                    ' e numero de sequencia do dependente = '||
                                    i_num_seq_dependente||', mas apresenta divergencia no cadastro de pessoa fisica'||
                                    ' para as informac?es de data de nascimento, sexo, nome do dependente, nome da mãe ou'||
                                    ' cpf da mãe em relação ao registro de carga',
                               1, 2000);

            end if;

        end if;

        -- pesquisando por data de nascimento + sexo + nome + nome da mãe + cpf da mãe
        select count(*)
        into v_qtd_rec
        from tb_pessoa_fisica
        where cod_ins = i_cod_ins
          and (    (   (dat_nasc      is null)
                    or (dat_nasc      = i_dat_nasc))
               and (cod_sexo          = i_cod_sexo)
               and (nom_pessoa_fisica = i_nom_dep_beneficiario)
               and (   (nom_mae       is null)
                    or (nom_mae       = i_nom_mae))
               and (   (num_cpf_mae   is null)
                    or (i_num_cpf_mae is null)
                    or (num_cpf_mae   = i_num_cpf_mae)) );

        if (v_qtd_rec = 0) then

            null;

        elsif (v_qtd_rec > 1) then

                return substr('ERRO Localizado mais de um registro no cadastro de pessoa fisica com as mesmas informac?es de'||
                                    ' nome, data de nascimento, sexo, nome da mãe e/ou cpf da mãe',
                               1, 2000);

        else

            select cod_ide_cli
            into v_retorno
            from tb_pessoa_fisica
            where cod_ins = i_cod_ins
              and (    (   (dat_nasc      is null)
                        or (dat_nasc      = i_dat_nasc))
                   and (cod_sexo          = i_cod_sexo)
                   and (upper(trim(nom_pessoa_fisica)) = upper(trim(i_nom_dep_beneficiario)))
                   and (   (nom_mae       is null)
                        or (upper(trim(nom_mae))       = upper(trim(i_nom_mae))))
                   and (   (num_cpf_mae   is null)
                        or (i_num_cpf_mae is null)
                        or (num_cpf_mae   = i_num_cpf_mae)) );

            return (v_retorno);

        end if;


        return (null);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr('ERRO '||sqlerrm, 1, 2000));

    END FNC_BUSCA_IDE_CLI_DEP;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_END (i_id_header in number) IS

        v_result                     varchar2(2000);
        v_cur_id                     tb_carga_gen_end.id%type;
        v_flg_acao_postergada        tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia        tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia        tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar                    t_validar;
        a_log                        t_log;
        v_nom_rotina                 varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_END';
        v_nom_tabela                 varchar2(100) := 'TB_CARGA_GEN_END';
        v_qtd_prof                   number;
        v_ret_busca_ide_cli_dep      varchar2(2000);
        v_cod_municipio              tb_municipio.cod_municipio%type;
        v_cod_bairro                 tb_bairro.cod_bairro%type;
        v_cod_ide_cli                tb_pessoa_fisica.cod_ide_cli%type;
        v_cod_ide_cli_serv           tb_pessoa_fisica.cod_ide_cli%type;
        v_cod_ide_cli_end            tb_end_pessoa_fisica.cod_ide_cli%type;
        v_ide_cli_ifs                tb_pessoa_fisica.cod_ide_cli%type;
        v_ide_cli_ext                tb_pessoa_fisica.cod_ide_cli%type;
        v_ifd                        tb_carga_gen_ifd%rowtype;
        v_linha_tb_end_pessoa_fisica tb_end_pessoa_fisica%rowtype;
        v_id_log_erro                number;
        v_msg_erro                   varchar2(4000);
        v_cod_erro                   number;
        v_nom_logradouro             varchar2(200);
        v_nom_bairro                 varchar2(200);
        v_nom_municipio              varchar2(200);
        v_vlr_iteracao               number := 100;
        v_cod_entidade               tb_carga_gen_ident_ext.cod_entidade%type;
        v_id_Servidor                tb_carga_gen_ident_ext.cod_ide_cli_ext%type;

        --
        type t_rec_municipio is record  (cod_municipio  tb_municipio.cod_municipio%type,
                                         nom_municipio  tb_municipio.nom_municipio%type);

        type t_col_municipio is table of t_rec_municipio;

        type t_col_mun_lista is table of t_col_municipio index by tb_bairro.cod_uf%type;

        v_col_municipio t_col_mun_lista;
        --
        type t_rec_bairro is record  (cod_municipio  tb_bairro.cod_municipio%type,
                                      cod_bairro     tb_bairro.cod_bairro%type,
                                      nom_bairro     tb_bairro.nom_bairro%type);

        type t_col_bairro is table of t_rec_bairro;

        type t_col_bairro_lista is table of t_col_bairro index by binary_integer;

        v_col_bairro t_col_bairro_lista;

    BEGIN

          sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);
          --
          --
          -- ARMAZENA informações de Endereço em memória para melhor performance
          if v_result is null then
            for r in (select distinct cod_uf
                        from tb_municipio)

            loop
               select m.cod_municipio, m.nom_municipio
                 bulk collect into v_col_municipio(r.cod_uf)
                 from tb_municipio m
                where m.cod_ins = '1'
                  and m.cod_uf = r.cod_uf
                  and m.cod_municipio < 900000;
               --
            end loop;
            --
            --
            for r in (select distinct cod_municipio
                        from tb_bairro)
            loop
               select b.cod_municipio, b.cod_bairro, b.nom_bairro
                 bulk collect into v_col_bairro(r.cod_municipio)
                 from tb_bairro b
                where b.cod_ins = '1'
                  and b.cod_municipio = r.cod_municipio
                  and b.cod_municipio < 900000;
               --
            end loop;
          end if;
          --
          if (v_result is null) then
          loop
                --
                v_result := null;
                v_cur_id := null;
                --                              --
                if v_result is null then
                  for c_end in (select a.cod_ins,
                                       a.id_header,
                                       trim(a.cod_entidade)           cod_entidade,
                                       trim(a.id_servidor)            id_servidor,
                                       trim(a.num_seq_grupo_familiar) num_seq_grupo_familiar,
                                       trim(a.num_seq_dependente)     num_seq_dependente,
                                       trim(a.sig_uf)                 sig_uf,
                                       trim(a.nom_municipio)          nom_municipio,
                                       trim(a.nom_bairro)             nom_bairro,
                                       trim(a.nom_logradouro)         nom_logradouro,
                                       fnc_codigo_ext(a.cod_ins, 10124, upper(trim(a.cod_tipo_logradouro)), null, 'COD_PAR') cod_tipo_logradouro_int,
                                       trim(a.cod_tipo_logradouro)    cod_tipo_logradouro,
                                       trim(a.num_imovel)             num_imovel,
                                       trim(a.des_complemento)        des_complemento,
                                       trim(a.cep)                    cep,
                                       trim(a.cod_tipo_endereco)      cod_tipo_endereco,
                                       fnc_codigo_ext(a.cod_ins, 2010, decode(trim(a.cod_tipo_endereco),'9','0','99','0',trim(a.cod_tipo_endereco)), null, 'COD_PAR') cod_tipo_endereco_int,
                                       trim(a.cod_pais)               cod_pais,
                                       fnc_codigo_ext(a.cod_ins, 2009, trim(a.cod_pais), null, 'COD_PAR') cod_pais_int,
                                       trim(a.nom_cidade)             nom_cidade,
                                       a.id, a.num_linha_header, a.id_processo
                                from tb_carga_gen_end a
                                where a.id_header = i_id_header
                                  and a.cod_status_processamento = '1'
                                  and rownum <= v_vlr_iteracao
                                order by a.id_header, a.num_linha_header
                                for update nowait) loop

                      v_cur_id               := c_end.id;

                      BEGIN
                          v_result := null;
                          --
                          savepoint sp1;
                          --
                          v_cod_ide_cli          := null;
                          v_cod_ide_cli_serv     := null;
                          v_cod_ide_cli_end      := null;
                          v_cod_bairro           := null;
                          v_cod_municipio        := null;
                          v_ide_cli_ifs          := null;
                          v_ide_cli_ext          := null;
                          --
                          -- separando entidade de id_header
                          v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(c_end.id_servidor);
                          v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(c_end.cod_entidade,c_end.id_servidor);                                              --                                  --
                          --
                          -- pega cod_ide_cli do servidor
                          v_cod_ide_cli := fnc_ret_cod_ide_cli( c_end.cod_ins, v_id_Servidor);
                          --
                          if (c_end.num_seq_dependente != '00') then -- e endereco do dependente
                              -- identificando o dependente/beneficiario
                              select dep.cod_ide_cli_dep
                                into v_cod_ide_cli
                                from tb_Dependente dep
                               where dep.cod_ide_cli_serv = v_cod_ide_cli
                                 and dep.num_depend = c_end.num_seq_dependente;
                          end if;
                          --
                          if FNC_VALIDA_PESSOA_FISICA(c_end.cod_ins, v_cod_ide_cli) is not null then
                             raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                          end if;
                          --
                          PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                                  i_num_linha        => c_end.num_linha_header,
                                                                                  o_result           => v_result,
                                                                                  o_cod_erro         => v_cod_erro,
                                                                                  o_des_erro         => v_msg_erro);
                          --
                          if v_cod_erro is not null then
                            v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                          end if;
                          --
                          if v_result is not null then
                            raise_application_error(-20000,'Erro de Validação - '||v_Result);
                          end if;
                          --
                          -- ALEXANDRE
                          if c_end.cod_tipo_endereco_int is null then
                             c_end.cod_tipo_endereco_int := '1';
                          end if;
                          --
                          if (v_cod_ide_cli is not null) then
                            -- busca nomes do endereço baseado no CEP correios
                            begin
                              select a.log_no,
                                     b.bai_no,
                                     m.loc_no
                                into v_nom_logradouro,
                                     v_nom_bairro,
                                     v_nom_municipio
                               from tb_correios_logradouro a join tb_correios_bairro b on a.bai_nu_ini = b.bai_nu
                                                             join tb_correios_municipio m on m.loc_nu = b.loc_nu
                               where a.cep =  c_end.cep
                                 and rownum < 2;
                             exception
                               when no_data_found then
                                  v_nom_logradouro:= c_end.nom_logradouro;
                                  v_nom_bairro := c_end.nom_bairro;
                                  v_nom_municipio := c_end.nom_municipio;
                             end;
                             --
                             -- procura em memoria cod_municipio e cod_bairro de acordo com nome do correio
                             loop
                               begin
                                   for i in 1..v_col_municipio(c_end.sig_uf).last loop
                                       if fnc_tira_acento(upper(trim(v_col_municipio(c_end.sig_uf)(i).nom_municipio))) = fnc_tira_acento(upper(trim(v_nom_municipio)))
                                       then
                                         v_cod_municipio := v_col_municipio(c_end.sig_uf)(i).cod_municipio;
                                         exit;
                                       end if;
                                   end loop;
                                   --
                                   if v_cod_municipio is not null then
                                     for i in 1..v_col_bairro(v_cod_municipio).last loop
                                       if fnc_tira_acento(upper(trim(v_col_bairro(v_cod_municipio)(i).nom_bairro))) = fnc_tira_acento(upper(trim(v_nom_bairro)))
                                       then
                                         v_cod_bairro := v_col_bairro(v_cod_municipio)(i).cod_bairro;
                                         exit;
                                       end if;
                                     end loop;
                                   end if;
                                   --
                                   -- Recurso pra realizar a pesquisa
                                   -- para o caso dos nomes de bairro e mun do Correio,
                                   -- e caso não encontre, com os do arquivo em sequência.
                                   -- Sai do loop quando o ultimo nome testado são os do arquivo
                                   -- (c_end.nom_municipio e c_end.nom_municipio)
                                   if v_cod_municipio is not null and v_cod_bairro is not null then
                                     exit;
                                   elsif nvl(v_nom_bairro,'%$%') = nvl(c_end.nom_bairro,'%$%') and
                                         nvl(v_nom_municipio,'%$%') = nvl(c_end.nom_municipio,'%$%') then
                                     exit;
                                   else
                                     v_nom_bairro := c_end.nom_bairro;
                                     v_nom_municipio := c_end.nom_municipio;
                                   end if;

                                exception
                                   when no_data_found then
                                     exit;
                                end;
                              end loop;

                              if v_cod_bairro is null or v_cod_municipio is null then
                                v_result := 'Bairro e Municipio não localizados para CEP e Endereço';
                              end if;

                              if (v_result is null) then
                                  begin
                                      v_linha_tb_end_pessoa_fisica := null;
                                      select *
                                        into v_linha_tb_end_pessoa_fisica
                                        from tb_end_pessoa_fisica
                                       where cod_ins       = c_end.cod_ins
                                         and cod_ide_cli   = v_cod_ide_cli
                                         and cod_tipo_end  = c_end.cod_tipo_endereco_int;
                                  exception
                                      when no_data_found then
                                          null;
                                  end;

                                  v_cod_ide_cli_end := v_linha_tb_end_pessoa_fisica.cod_ide_cli;

                                  if (v_cod_ide_cli_end is not null) then -- registro ja existe em tb_end_pessoa_fisica, atualiza os demais dados

                                      v_cod_tipo_ocorrencia := 'A';

                                      if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                          update tb_end_pessoa_fisica
                                          set nom_logradouro          = v_nom_logradouro,
                                              num_numero              = c_end.num_imovel,
                                              des_complemento         = c_end.des_complemento,
                                              num_cep                 = c_end.cep,
                                              dat_ult_atu             = sysdate,
                                              nom_usu_ult_atu         = user,
                                              nom_pro_ult_atu         = v_nom_rotina,
                                              nom_municipio_carregado = c_end.nom_municipio,
                                              nom_bairro_carregado    = c_end.nom_bairro,
                                              cod_pais                = nvl(c_end.cod_pais_int, cod_pais),
                                              cod_tipo_logradouro     = c_end.cod_tipo_logradouro_int,
                                              nom_cidade              = c_end.nom_cidade,
                                              nom_logr_carregado      = c_end.nom_logradouro
                                          where cod_ins       = c_end.cod_ins
                                            and cod_ide_cli   = v_cod_ide_cli
                                            and cod_uf        = c_end.sig_uf
                                            and cod_municipio = v_cod_municipio
                                            and cod_bairro    = v_cod_bairro
                                            and cod_tipo_end  = c_end.cod_tipo_endereco_int
                                            and nom_pro_ult_atu = v_nom_rotina;

                                      end if;

                                  else  -- registro não existe, inclui

                                      v_cod_tipo_ocorrencia := 'I';

                                      if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                          insert into tb_end_pessoa_fisica
                                              (cod_ins,                   --  1
                                               cod_ide_cli,               --  2
                                               cod_uf,                    --  3
                                               cod_municipio,             --  4
                                               cod_bairro,                --  5
                                               num_ide_end_pf,            --  6
                                               nom_logradouro,            --  7
                                               num_numero,                --  8
                                               des_complemento,           --  9
                                               num_cep,                   -- 10
                                               cod_tipo_end,              -- 11
                                               dat_ing,                   -- 12
                                               dat_ult_atu,               -- 13
                                               nom_usu_ult_atu,           -- 14
                                               nom_pro_ult_atu,           -- 15
                                               nom_municipio_carregado,   -- 16
                                               nom_bairro_carregado,      -- 17
                                               cod_pais,                  -- 18
                                               cod_tipo_logradouro,       -- 19
                                               nom_cidade,                -- 20
                                               nom_logr_carregado         -- 21
                                               )
                                          values
                                              (c_end.cod_ins,                 --  1 cod_ins
                                               v_cod_ide_cli,                 --  2 cod_ide_cli
                                               c_end.sig_uf,                  --  3 cod_uf
                                               v_cod_municipio,               --  4 cod_municipio
                                               v_cod_bairro,                  --  5 cod_bairro
                                               1,                             --  6 num_ide_end_pf
                                               v_nom_logradouro,              --  7 nom_logradouro
                                               c_end.num_imovel,              --  8 num_numero
                                               c_end.des_complemento,         --  9 des_complemento
                                               c_end.cep,                     -- 10 num_cep
                                               c_end.cod_tipo_endereco_int,   -- 11 cod_tipo_end
                                               sysdate,                       -- 12 dat_ing
                                               sysdate,                       -- 13 dat_ult_atu
                                               user,                          -- 14 nom_usu_ult_atu
                                               v_nom_rotina,                  -- 15 nom_pro_ult_atu
                                               c_end.nom_municipio,           -- 16 nom_municipio_carregado
                                               c_end.nom_bairro,              -- 17 nom_bairro_carregado
                                               nvl(c_end.cod_pais_int, '1'),  -- 18 cod_pais
                                               c_end.cod_tipo_logradouro_int, -- 19 cod_tipo_logradouro
                                               c_end.nom_cidade,              -- 20 nom_cidade
                                               c_end.nom_logradouro);         -- 21 nom logradouro

                                      end if;

                                  end if;

                                /*  a_log.delete;
                                  SP_INCLUI_LOG(a_log, 'COD_INS',                 v_linha_tb_end_pessoa_fisica.cod_ins,                 c_end.cod_ins);
                                  SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',             v_linha_tb_end_pessoa_fisica.cod_ide_cli,             v_cod_ide_cli);
                                  SP_INCLUI_LOG(a_log, 'COD_UF',                  v_linha_tb_end_pessoa_fisica.cod_uf,                  c_end.sig_uf);
                                  SP_INCLUI_LOG(a_log, 'COD_MUNICIPIO',           v_linha_tb_end_pessoa_fisica.cod_municipio,           v_cod_municipio);
                                  SP_INCLUI_LOG(a_log, 'COD_BAIRRO',              v_linha_tb_end_pessoa_fisica.cod_bairro,              v_cod_bairro);
                                  SP_INCLUI_LOG(a_log, 'NUM_IDE_END_PF',          v_linha_tb_end_pessoa_fisica.num_ide_end_pf,          nvl(v_linha_tb_end_pessoa_fisica.num_ide_end_pf, 1));
                                  SP_INCLUI_LOG(a_log, 'COD_TIPO_END',            v_linha_tb_end_pessoa_fisica.cod_tipo_end,            c_end.cod_tipo_endereco_int);
                                  SP_INCLUI_LOG(a_log, 'NOM_LOGRADOURO',          v_linha_tb_end_pessoa_fisica.nom_logradouro,          c_end.nom_logradouro);
                                  SP_INCLUI_LOG(a_log, 'NUM_NUMERO',              v_linha_tb_end_pessoa_fisica.num_numero,              c_end.num_imovel);
                                  SP_INCLUI_LOG(a_log, 'DES_COMPLEMENTO',         v_linha_tb_end_pessoa_fisica.des_complemento,         c_end.des_complemento);
                                  SP_INCLUI_LOG(a_log, 'NUM_CEP',                 v_linha_tb_end_pessoa_fisica.num_cep,                 c_end.cep);
                                  SP_INCLUI_LOG(a_log, 'NOM_MUNICIPIO_CARREGADO', v_linha_tb_end_pessoa_fisica.nom_municipio_carregado, c_end.nom_municipio);
                                  SP_INCLUI_LOG(a_log, 'NOM_BAIRRO_CARREGADO',    v_linha_tb_end_pessoa_fisica.nom_bairro_carregado,    c_end.nom_bairro);
                                  SP_INCLUI_LOG(a_log, 'COD_PAIS',                v_linha_tb_end_pessoa_fisica.cod_pais,                nvl(c_end.cod_pais_int, nvl(v_linha_tb_end_pessoa_fisica.cod_pais, '1')));
                                  SP_INCLUI_LOG(a_log, 'COD_TIPO_LOGRADOURO',     v_linha_tb_end_pessoa_fisica.cod_tipo_logradouro,     c_end.cod_tipo_logradouro_int);
                                  SP_INCLUI_LOG(a_log, 'NOM_CIDADE',              v_linha_tb_end_pessoa_fisica.nom_cidade,              c_end.nom_cidade);

                                  SP_GRAVA_LOG(i_id_header, c_end.id_processo, c_end.num_linha_header, v_cod_tipo_ocorrencia,
                                               v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_END_PESSOA_FISICA', v_nom_rotina, a_log);
*/
                                  if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, c_end.id, '3', null, v_nom_rotina) != 'TRUE') then
                                       raise ERRO_GRAVA_STATUS;
                                  end if;

                              else

                                  if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, c_end.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                      raise ERRO_GRAVA_STATUS;
                                  end if;

                              end if;

                          else

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, c_end.id, '4', 'Dados do servidor/dependente/beneficiario não localizados', v_nom_rotina) != 'TRUE') then
                                   raise ERRO_GRAVA_STATUS;
                              end if;

                          end if;


                      EXCEPTION
                          WHEN OTHERS THEN
                              v_msg_erro := substr(sqlerrm, 1, 4000);
                              rollback to sp1;
                              SP_GRAVA_ERRO(i_id_header, c_end.id_processo, c_end.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, c_end.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;
                      END;
                  end loop;
                else
                  sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina, v_result);
                  exit;
                end if;

                exit when v_cur_id is null;

                commit;

            end loop;
            --
            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);
        else
          sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina, v_msg_Erro);
        end if;
        commit;
    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_END;

    -----------------------------------------------------------------------------------------------
    PROCEDURE SP_CARREGA_CAR (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_car.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_CAR';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_CAR';
        v_cod_cargo             tb_cargo.cod_cargo%type;
        v_linha_cargo           tb_cargo%rowtype;
        v_cod_pccs              tb_pccs.cod_pccs%type;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);
        v_cod_erro              number;
        v_vlr_iteracao          number := 20;
        v_cod_classe            tb_classe.cod_classe%type;
        v_cod_quadro            tb_quadro.cod_quadro%type;
        v_cod_carreira          tb_carreira.cod_carreira%type;
        v_cod_entidade          tb_cargo.cod_entidade%type;

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop
                v_result := null;
                v_cur_id := null;

                if v_result is null then
                  for car in (select a.cod_ins,
                                     trim(a.cod_entidade)            cod_entidade,
                                     trim(a.cod_cargo)               cod_cargo,
                                     trim(a.nom_cargo)               nom_cargo,
                                     trim(a.cod_nju_cri)             cod_nju_cri,
                                     trim(a.cod_nju_ext)             cod_nju_ext,
                                     trim(a.flg_comissao)            flg_comissao,
                                     trim(a.cod_ide_cbo)             cod_ide_cbo,
                                     trim(a.flg_isol_carreira)       flg_isol_carreira,
                                     trim(a.cod_sit_cargo)           cod_sit_cargo,
                                     fnc_codigo_ext(a.cod_ins, 2044, trim(a.cod_sit_cargo), null, 'COD_PAR') cod_sit_cargo_int,
                                     trim(a.qtd_tot_prev_lei)        qtd_tot_prev_lei,
                                     trim(a.qtd_ocup)                qtd_ocup,
                                     trim(a.flg_professor)           flg_professor,
                                     trim(a.cod_escolaridade)        cod_escolaridade,
                                     fnc_codigo_ext(a.cod_ins, 2006, trim(a.cod_escolaridade), null, 'COD_PAR') cod_escolaridade_int,
                                     trim(a.flg_acumulo)             flg_acumulo,
                                     trim(a.nom_carreira)            nom_carreira,
                                     trim(a.nom_quadro_profissional) nom_quadro_profissional,
                                     trim(a.id_tab_venc)             id_tab_venc,
                                     fnc_codigo_ext(a.cod_ins, 2074, trim(a.id_tab_venc), null, 'COD_PAR') id_tab_venc_int,
                                     trim(a.cod_referencia)          cod_referencia,
                                     trim(a.flg_possui_grau)         flg_possui_grau,
                                     trim(a.des_jornada_basica)      des_jornada_basica,
                                     trim(a.dat_ini_val_cargo)       dat_ini_val_cargo,
                                     trim(a.dat_fim_val_cargo)       dat_fim_val_cargo,
                                     trim(a.des_atribuicoes)         des_atribuicoes,
                                     trim(a.des_provimento)          des_provimento,
                                     a.id,                a.num_linha_header,  a.id_processo
                              from tb_carga_gen_car a
                              where a.id_header = i_id_header
                                and a.cod_status_processamento = '1'
                                and rownum <= v_vlr_iteracao
                              order by a.id_header, a.num_linha_header
                              for update nowait) loop

                      v_cur_id              := car.id;

                      BEGIN

                          savepoint sp1;
                          v_result := null;

                          if (car.dat_ini_val_cargo is not null and fnc_valida_numero(car.dat_ini_val_cargo) = 0) then
                              car.dat_ini_val_cargo := null;
                          end if;

                          if (car.dat_fim_val_cargo is not null and fnc_valida_numero(car.dat_fim_val_cargo) = 0) then
                              car.dat_fim_val_cargo := null;
                          end if;

                          v_result := FNC_VALIDA_CAR(car, a_validar);
                          -----
                          if (v_result is null) then
                              -- entidade
                              if car.cod_entidade = 1 then
                                v_cod_entidade := 4;
                              end if;
                              -- pccs
                              V_COD_PCCS := 5;
                              -- Cargo
                              begin
                                select *
                                into v_linha_cargo
                                from tb_cargo
                                where cod_ins      = car.cod_ins
                                  and cod_entidade = v_cod_entidade
                                  --and cod_pccs     = v_cod_pccs
                                  and cod_cargo    = car.cod_cargo;
                              exception
                                  when others then
                                     v_linha_cargo := null;
                              end;
                              -- carreira
                              v_cod_Carreira := 1;
                              v_cod_quadro := 1;
                              v_Cod_classe := 1;

                              -- Tenta achar quadro e classe a partir de quadro_Carreira_classe.
                              -- Somente se for inserir um novo cargo
                            --  if (v_linha_cargo.cod_cargo is null) then
                                -- busca quadro
                               /* begin
                                  select distinct qcc.cod_quadro
                                    into v_cod_quadro
                                    from tb_quadro_carreira_classe qcc
                                   where qcc.cod_ins = 1
                                     and qcc.cod_entidade = v_cod_entidade
                                     and qcc.cod_carreira = v_cod_Carreira
                                     and qcc.cod_pccs =V_COD_PCCS ;
                                exception
                                  when too_many_rows then
                                     v_cod_quadro := null;
                                  when no_data_found then
                                     v_cod_quadro := null;
                                end;


                                -- busca classe
                                begin
                                  select distinct qcc.cod_classe
                                    into v_cod_classe
                                    from tb_quadro_carreira_classe qcc
                                   where qcc.cod_ins = 1
                                     and qcc.cod_entidade = v_cod_entidade
                                     and qcc.cod_carreira = v_cod_Carreira
                                     and qcc.cod_pccs = V_COD_PCCS;
                                exception
                                  when too_many_rows then
                                     v_cod_classe := null;
                                  when no_data_found then
                                     v_cod_classe := null;
                                end;
                              end if;*/

                              if (v_linha_cargo.cod_cargo is not null) then -- registro ja existe em tb_cargo, atualiza os demais dados

                                  v_cod_tipo_ocorrencia := 'A';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                      raise_application_error(-20000,'Já existe esse cargo para tabela e Entidade.');    -- não faz inserção nenhuma em processo CAR
                                  end if;

                              else                        -- registro não existe, inclui

                                  v_cod_tipo_ocorrencia := 'I';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                      insert into tb_cargo
                                          (COD_INS,                       --  1
                                           COD_ENTIDADE,                  --  2
                                           COD_PCCS,                      --  3
                                           COD_CARGO,                     --  4
                                           COD_IDE_CBO,                   --  5
                                           COD_NJU_CRI,                   --  6
                                           COD_NJU_EXT,                   --  7
                                           COD_CARREIRA,                  --  8
                                           NOM_CARGO,                     --  9
                                           DES_PROVENTOS,                 -- 10
                                           DES_ATRIBUICOES,               -- 11
                                           COD_SIT_CARGO,                 -- 12
                                           FLG_ISOL_CARREIRA,             -- 13
                                           FLG_COMISSAO,                  -- 14
                                           FLG_POSSUI_GRAU,               -- 15
                                           FLG_PROFESSOR,                 -- 16
                                           FLG_ACUMULO,                   -- 17
                                           QTD_TOT_PREV_LEI,              -- 18
                                           QTD_OCUP,                      -- 19
                                           DAT_INI_VIG,                   -- 20
                                           DAT_FIM_VIG,                   -- 21
                                           DAT_ING,                       -- 22
                                           DAT_ULT_ATU,                   -- 23
                                           NOM_USU_ULT_ATU,               -- 24
                                           NOM_PRO_ULT_ATU,               -- 25
                                           COD_QUADRO,                    -- 26
                                           COD_CLASSE)                    -- 27
                                      values
                                          (car.cod_ins,                               --  1 COD_INS
                                           v_cod_entidade,                          --  2 COD_ENTIDADE
                                           v_cod_pccs,                                --  3 COD_PCCS
                                           car.cod_cargo,                             --  4 COD_CARGO
                                           car.cod_ide_cbo,                           --  5 COD_IDE_CBO
                                           car.cod_nju_cri,                           --  6 COD_NJU_CRI
                                           car.cod_nju_ext,                           --  7 COD_NJU_EXT
                                           v_cod_carreira,                            --  8 COD_CARREIRA
                                           car.nom_cargo,                             --  9 NOM_CARGO
                                           substr(car.des_provimento, 1, 500),        -- 10 DES_PROVENTOS
                                           car.des_atribuicoes,                       -- 11 DES_ATRIBUICOES
                                           car.cod_sit_cargo,                         -- 12 COD_SIT_CARGO
                                           upper(car.flg_isol_carreira),              -- 13 FLG_ISOL_CARREIRA
                                           'N',                      -- 14 FLG_COMISSAO
                                           upper(car.flg_possui_grau),                -- 15 FLG_POSSUI_GRAU
                                           upper(car.flg_professor),                  -- 16 FLG_PROFESSOR
                                           upper(car.flg_acumulo),                    -- 17 FLG_ACUMULO
                                           fnc_valida_numero(car.qtd_tot_prev_lei),   -- 18 QTD_TOT_PREV_LEI
                                           fnc_valida_numero(car.qtd_ocup),           -- 19 QTD_OCUP
                                           fnc_valida_data(car.dat_ini_val_cargo, 'YYYYMMDD'), -- 20 DAT_INI_VIG
                                           fnc_valida_data(car.dat_fim_val_cargo, 'YYYYMMDD'), -- 21 DAT_FIM_VIG
                                           sysdate,                                   -- 22 DAT_ING
                                           sysdate,                                   -- 23 DAT_ULT_ATU
                                           user,                                      -- 24 NOM_USU_ULT_ATU
                                           v_nom_rotina,                              -- 25 NOM_PRO_ULT_ATU
                                           v_cod_quadro,                              -- 26 COD_QUADRO
                                           v_cod_classe);                             -- 27 COD_CLASSE
                                  end if;

                              end if;

                              a_log.delete;
                              SP_INCLUI_LOG(a_log, 'COD_INS',           v_linha_cargo.cod_ins,           car.cod_ins);
                              SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',      v_linha_cargo.cod_entidade,      car.cod_entidade);
                              SP_INCLUI_LOG(a_log, 'COD_PCCS',          v_linha_cargo.cod_pccs,          v_cod_pccs);
                              SP_INCLUI_LOG(a_log, 'COD_CARGO',         v_linha_cargo.cod_cargo,         v_linha_cargo.cod_cargo);
                              SP_INCLUI_LOG(a_log, 'COD_IDE_CBO',       v_linha_cargo.cod_ide_cbo,       nvl(car.cod_ide_cbo, v_linha_cargo.cod_ide_cbo));
                              SP_INCLUI_LOG(a_log, 'COD_NJU_CRI',       v_linha_cargo.cod_nju_cri,       nvl(car.cod_nju_cri, v_linha_cargo.cod_nju_cri));
                              SP_INCLUI_LOG(a_log, 'COD_NJU_EXT',       v_linha_cargo.cod_nju_ext,       nvl(car.cod_nju_ext, v_linha_cargo.cod_nju_ext));
                              SP_INCLUI_LOG(a_log, 'COD_QUADRO',        v_linha_cargo.cod_quadro,        v_cod_quadro);
                              SP_INCLUI_LOG(a_log, 'COD_CARREIRA',      v_linha_cargo.cod_carreira,      v_cod_carreira);
                              SP_INCLUI_LOG(a_log, 'COD_CLASSE',        v_linha_cargo.cod_classe,        v_cod_classe);
                              SP_INCLUI_LOG(a_log, 'NOM_CARGO',         v_linha_cargo.nom_cargo,         nvl(car.nom_cargo, v_linha_cargo.nom_cargo));
                              SP_INCLUI_LOG(a_log, 'DES_PROVENTOS',     v_linha_cargo.des_proventos,     nvl(substr(car.des_provimento, 1, 500), v_linha_cargo.des_proventos));
                              SP_INCLUI_LOG(a_log, 'DES_ATRIBUICOES',   v_linha_cargo.des_atribuicoes,   nvl(car.des_atribuicoes, v_linha_cargo.des_atribuicoes));
                              SP_INCLUI_LOG(a_log, 'COD_SIT_CARGO',     v_linha_cargo.cod_sit_cargo,     nvl(car.cod_sit_cargo_int, v_linha_cargo.cod_sit_cargo));
                              SP_INCLUI_LOG(a_log, 'FLG_ISOL_CARREIRA', v_linha_cargo.flg_isol_carreira, nvl(upper(car.flg_isol_carreira), v_linha_cargo.flg_isol_carreira));
                              SP_INCLUI_LOG(a_log, 'FLG_COMISSAO',      v_linha_cargo.flg_comissao,      nvl(upper(car.flg_comissao), v_linha_cargo.flg_comissao));
                              SP_INCLUI_LOG(a_log, 'FLG_POSSUI_GRAU',   v_linha_cargo.flg_possui_grau,   nvl(upper(car.flg_possui_grau), v_linha_cargo.flg_possui_grau));
                              SP_INCLUI_LOG(a_log, 'FLG_PROFESSOR',     v_linha_cargo.flg_professor,     nvl(upper(car.flg_professor), v_linha_cargo.flg_professor));
                              SP_INCLUI_LOG(a_log, 'FLG_ACUMULO',       v_linha_cargo.flg_acumulo,       nvl(upper(car.flg_acumulo), v_linha_cargo.flg_acumulo));
                              SP_INCLUI_LOG(a_log, 'QTD_TOT_PREV_LEI',  v_linha_cargo.qtd_tot_prev_lei,  nvl(fnc_valida_numero(car.qtd_tot_prev_lei), v_linha_cargo.qtd_tot_prev_lei));
                              SP_INCLUI_LOG(a_log, 'QTD_OCUP',          v_linha_cargo.qtd_ocup,          nvl(fnc_valida_numero(car.qtd_ocup), v_linha_cargo.qtd_ocup));
                              SP_INCLUI_LOG(a_log, 'DAT_INI_VIG',       to_char(v_linha_cargo.dat_ini_vig, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(car.dat_ini_val_cargo, 'YYYYMMDD'), v_linha_cargo.dat_ini_vig), 'dd/mm/yyyy hh24:mi'));
                              SP_INCLUI_LOG(a_log, 'DAT_FIM_VIG',       to_char(v_linha_cargo.dat_fim_vig, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(car.dat_fim_val_cargo, 'YYYYMMDD'), v_linha_cargo.dat_fim_vig), 'dd/mm/yyyy hh24:mi'));

                              SP_GRAVA_LOG(i_id_header, car.id_processo, car.num_linha_header, v_cod_tipo_ocorrencia,
                                           v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_CARGO', v_nom_rotina, a_log);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, car.id, '3', null, v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;

                          else

                              SP_GRAVA_ERRO(i_id_header, car.id_processo, car.num_linha_header, v_nom_rotina, a_validar);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, car.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;

                          end if;

                      EXCEPTION
                          WHEN OTHERS THEN

                              v_msg_erro := substr(sqlerrm, 1, 4000);

                              rollback to sp1;

                              SP_GRAVA_ERRO(i_id_header, car.id_processo,  car.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, car.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;

                      END;
                  end loop;
                else
                  SP_GRAVA_ERRO_DIRETO(i_id_header, 4,  0, v_nom_rotina, v_result);
                  exit;
                end if;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
              SP_GRAVA_ERRO_DIRETO(i_id_header, 4,  0, v_nom_rotina, 'I_ID_HEADER:'||i_id_header||' não foi possivel recuperar dados do processo: '||v_result);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_CAR;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_CAR (i_car       in     r_car,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_ini_val_cargo             date;
        v_dat_fim_val_cargo             date;

    BEGIN
        v_dat_ini_val_cargo := fnc_valida_data(i_car.dat_ini_val_cargo,'RRRRMMDD');
        v_dat_fim_val_cargo := fnc_valida_data(i_car.dat_fim_val_cargo,'RRRRMMDD');


        o_a_validar.delete;

        if (nvl(upper(i_car.flg_comissao), 'X') = 'S' and nvl(upper(i_car.flg_acumulo), 'X') = 'S') then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_ACUMULO', 'Cargo comissionado não permite ser acumulado com outros cargos');
        end if;

        if (v_dat_ini_val_cargo is not null and v_dat_fim_val_cargo is not null and v_dat_ini_val_cargo > v_dat_fim_val_cargo) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_VAL_CARGO', 'Data de fim da validade do cargo ('||i_car.dat_fim_val_cargo||') e anterior a data de inicio de validade ('||i_car.dat_ini_val_cargo||')');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_CAR;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_CPA (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_cpa.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_CPA';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_CPA';
        v_cod_pccs              tb_cargo.cod_pccs%type;
        v_cod_quadro            tb_cargo.cod_quadro%type;
        v_cod_carreira          tb_cargo.cod_carreira%type;
        v_cod_classe            tb_cargo.cod_classe%type;
        v_nom_cargo             tb_cargo.nom_cargo%type;
        v_qtd_tot_prev_lei      tb_cargo.qtd_tot_prev_lei%type;
        v_qtd_ocup              tb_cargo.qtd_ocup%type;
        v_cod_jornada           tb_jornada.cod_jornada%type;
        v_cod_nivel             tb_referencia.cod_nivel%type;
        v_cod_grau              tb_referencia.cod_grau%type;
        v_cod_regime_retrib     varchar2(4000);
        v_cod_escala_venc       varchar2(4000);
        v_cod_ref_pad_venc      tb_referencia.cod_ref_pad_venc%type;
        v_cod_referencia        tb_referencia.cod_referencia%type;
        v_cod_composicao        tb_composicao.cod_composicao%type;
        v_tem_vencimento        varchar2(5);
        v_dat_ini_vig           tb_vencimento.dat_ini_vig%type;
        v_dat_fim_vig           tb_vencimento.dat_fim_vig%type;
        v_val_vencimento        tb_vencimento.val_vencimento%type;
        v_val_padrao_venc       tb_vencimento.val_vencimento%type;
        v_linha_tb_referencia   tb_referencia%rowtype;
        v_linha_tb_composicao   tb_composicao%rowtype;
        v_linha_tb_vencimento   tb_vencimento%rowtype;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for cpa in (select a.cod_ins,
                                   trim(a.cod_entidade)            cod_entidade,
                                   trim(a.cod_cargo)               cod_cargo,
                                   trim(a.id_tab_venc)             id_tab_venc,
                                   trim(a.cod_referencia)          cod_referencia,
                                   trim(a.cod_grau_nivel)          cod_grau_nivel,
                                   trim(a.des_jornada)             des_jornada,
                                   trim(a.val_padrao_venc)         val_padrao_venc,
                                   trim(a.dat_ini_val_padrao)      dat_ini_val_padrao,
                                   trim(a.dat_fim_val_padrao)      dat_fim_val_padrao,
                                   trim(a.cod_ref_ini_padrao)      cod_ref_ini_padrao,
                                   trim(a.cod_grau_niv_ini_padrao) cod_grau_niv_ini_padrao,
                                   trim(a.cod_ref_fim_padrao)      cod_ref_fim_padrao,
                                   trim(a.cod_grau_niv_fim_padrao) cod_grau_niv_fim_padrao,
                                   a.id, a.num_linha_header,   a.id_processo
                            from tb_carga_gen_cpa a
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id              := cpa.id;

                    BEGIN

                        savepoint sp1;

                        if (cpa.dat_ini_val_padrao is not null and cpa.dat_ini_val_padrao = '00000000') then
                            cpa.dat_ini_val_padrao := null;
                        end if;

                        if (cpa.dat_fim_val_padrao is not null and cpa.dat_fim_val_padrao = '00000000') then
                            cpa.dat_fim_val_padrao := null;
                        end if;

                        v_result := FNC_VALIDA_CPA(cpa, a_validar);

                        if (v_result is null) then

                            v_cod_regime_retrib := null;
                            v_cod_escala_venc   := null;

                            v_cod_pccs          := fnc_busca_cod_pccs(cpa.cod_ins, cpa.cod_entidade, cpa.id_tab_venc);
                            v_cod_regime_retrib := fnc_busca_dominios_padrao (cpa.cod_ins, cpa.cod_entidade, v_cod_pccs, cpa.cod_cargo, 'RR');
                            if (substr(v_cod_regime_retrib, 1, 5) = 'Erro:') then
                                SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_REGIME_RETRIB', substr(v_cod_regime_retrib, 6), 'Codigo do Regime');
                                v_result := 'Erro de validação';
                            end if;

                            v_cod_escala_venc := fnc_busca_dominios_padrao (cpa.cod_ins, cpa.cod_entidade, v_cod_pccs, cpa.cod_cargo, 'EV');
                            if (substr(v_cod_escala_venc, 1, 5) = 'Erro:') then
                                SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_ESCALA_VENC', substr(v_cod_escala_venc, 6), 'Codigo da escala de vencimento');
                                v_result := 'Erro de validação';
                            end if;
                        end if;

                        if (v_result is null) then

                            v_cod_jornada       := fnc_busca_cod_jornada(cpa.cod_ins, cpa.des_jornada);
                            v_cod_nivel         := fnc_busca_cod_nivel(cpa.cod_grau_nivel);
                            v_cod_grau          := fnc_busca_cod_grau(cpa.cod_grau_nivel);
                            v_val_padrao_venc   := fnc_valida_numero(cpa.val_padrao_venc) / 10000;

                            v_cod_quadro       := null;
                            v_cod_carreira     := null;
                            v_cod_classe       := null;
                            v_nom_cargo        := null;
                            v_qtd_tot_prev_lei := null;
                            v_qtd_ocup         := null;

                            begin
                                select cod_quadro, cod_carreira, cod_classe, nom_cargo,
                                       qtd_tot_prev_lei, qtd_ocup
                                into v_cod_quadro, v_cod_carreira, v_cod_classe, v_nom_cargo,
                                     v_qtd_tot_prev_lei, v_qtd_ocup
                                from tb_cargo
                                where cod_ins      = cpa.cod_ins
                                  and cod_entidade = cpa.cod_entidade
                                  and cod_pccs     = v_cod_pccs
                                  and cod_cargo    = cpa.cod_cargo;
                            exception
                                when others then
                                    null;
                            end;

                            v_cod_ref_pad_venc := substr(cpa.cod_entidade   ||'-'||cpa.cod_cargo    ||'-'||cpa.id_tab_venc||'-'||
                                                         v_cod_jornada      ||'-'||v_cod_nivel      ||'-'||v_cod_grau||'-'||
                                                         v_cod_regime_retrib||'-'||v_cod_escala_venc||'-'||'LEG', 1, 40);

                            v_cod_referencia      := null;
                            v_linha_tb_referencia := null;

                            begin
                                select * --cod_referencia
                                into v_linha_tb_referencia --v_cod_referencia
                                from tb_referencia
                                where cod_ins          = cpa.cod_ins
                                  and cod_entidade     = cpa.cod_entidade
                                  and cod_pccs         = v_cod_pccs
                                  and cod_quadro       = v_cod_quadro
                                  and cod_carreira     = v_cod_carreira
                                  and cod_classe       = v_cod_classe
                                  and cod_ref_pad_venc = v_cod_ref_pad_venc;
                            exception
                                when others then
                                    null;
                            end;

                            v_cod_referencia      := v_linha_tb_referencia.cod_referencia;

                            v_linha_tb_composicao := null;
                            v_cod_composicao      := null;

                            begin
                                select *
                                into v_linha_tb_composicao --v_cod_composicao
                                from tb_composicao
                                where cod_ins        = cpa.cod_ins
                                  and cod_entidade   = cpa.cod_entidade
                                  and cod_pccs       = v_cod_pccs
                                  and cod_quadro     = v_cod_quadro
                                  and cod_carreira   = v_cod_carreira
                                  and cod_classe     = v_cod_classe
                                  and cod_referencia = v_cod_referencia
                                  and cod_cargo      = cpa.cod_cargo
                                  and rownum        <= 1;
                            exception
                                when others then
                                    null;
                            end;

                            v_cod_composicao := v_linha_tb_composicao.cod_composicao;

                            v_dat_ini_vig    := null;
                            v_dat_fim_vig    := null;
                            v_val_vencimento := null;

                            begin
                                select * --dat_ini_vig, val_vencimento
                                into v_linha_tb_vencimento --v_dat_ini_vig, v_val_vencimento
                                from tb_vencimento
                                where cod_ins           = cpa.cod_ins
                                  and cod_entidade      = cpa.cod_entidade
                                  and cod_pccs          = v_cod_pccs
                                  and cod_quadro        = v_cod_quadro
                                  and cod_carreira      = v_cod_carreira
                                  and cod_classe        = v_cod_classe
                                  and cod_referencia    = v_cod_referencia
                                  and upper(flg_status) = 'V'
                                  and dat_fim_vig       is null;
                            exception
                                when others then
                                    null;
                            end;

                            if (v_linha_tb_vencimento.dat_ini_vig is null) then

                                begin
                                    select * --dat_ini_vig, dat_fim_vig, val_vencimento
                                    into v_linha_tb_vencimento --v_dat_ini_vig, v_dat_fim_vig, v_val_vencimento
                                    from tb_vencimento
                                    where cod_ins           = cpa.cod_ins
                                      and cod_entidade      = cpa.cod_entidade
                                      and cod_pccs          = v_cod_pccs
                                      and cod_quadro        = v_cod_quadro
                                      and cod_carreira      = v_cod_carreira
                                      and cod_classe        = v_cod_classe
                                      and cod_referencia    = v_cod_referencia
                                      and upper(flg_status) = 'V'
                                      and rownum           <= 1
                                    order by dat_fim_vig desc;
                                exception
                                    when others then
                                        null;
                                end;

                            end if;

                            v_dat_ini_vig    := v_linha_tb_vencimento.dat_ini_vig;
                            v_dat_fim_vig    := v_linha_tb_vencimento.dat_fim_vig;
                            v_val_vencimento := v_linha_tb_vencimento.val_vencimento;

                            if (v_cod_referencia is not null) then -- registro ja existe em tb_referencia, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                  null;
                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                v_cod_referencia := seq_cod_referencia.nextval;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_referencia
                                        (cod_ins,               --  1
                                         cod_entidade,          --  2
                                         cod_pccs,              --  3
                                         cod_quadro,            --  4
                                         cod_carreira,          --  5
                                         cod_classe,            --  6
                                         cod_referencia,        --  7
                                         cod_ref_pad_venc,      --  8
                                         dat_ini_vig,           --  9
                                         dat_fim_vig,           -- 10
                                         dat_ing,               -- 11
                                         dat_ult_atu,           -- 12
                                         nom_usu_ult_atu,       -- 13
                                         nom_pro_ult_atu,       -- 14
                                         cod_jornada,           -- 15
                                         cod_nivel,             -- 16
                                         cod_grau)              -- 17
                                    values
                                        (cpa.cod_ins,                                         --  1 - COD_INS
                                         cpa.cod_entidade,                                    --  2 - COD_ENTIDADE
                                         v_cod_pccs,                                          --  3 - COD_PCCS
                                         v_cod_quadro,                                        --  4 - COD_QUADRO
                                         v_cod_carreira,                                      --  5 - COD_CARREIRA
                                         v_cod_classe,                                        --  6 - COD_CLASSE
                                         v_cod_referencia,                                    --  7 - COD_REFERENCIA
                                         v_cod_ref_pad_venc,                                  --  8 - COD_REF_PAD_VENC
                                         fnc_valida_data(cpa.dat_ini_val_padrao, 'RRRRMMDD'), --  9 - DAT_INI_VIG
                                         fnc_valida_data(cpa.dat_fim_val_padrao, 'RRRRMMDD'), -- 10 - DAT_FIM_VIG
                                         sysdate,                                             -- 11 - DAT_ING
                                         sysdate,                                             -- 12 - DAT_ULT_ATU
                                         user,                                                -- 13 - NOM_USU_ULT_ATU
                                         v_nom_rotina,                                        -- 14 - NOM_PRO_ULT_ATU
                                         v_cod_jornada,                                       -- 15 - COD_JORNADA
                                         v_cod_nivel,                                         -- 16 - COD_NIVEL
                                         v_cod_grau);                                         -- 17 - COD_GRAU

                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',          v_linha_tb_referencia.cod_ins,          cpa.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',     v_linha_tb_referencia.cod_entidade,     cpa.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',         v_linha_tb_referencia.cod_pccs,         v_cod_pccs);
                            SP_INCLUI_LOG(a_log, 'COD_QUADRO',       v_linha_tb_referencia.cod_quadro,       v_cod_quadro);
                            SP_INCLUI_LOG(a_log, 'COD_CARREIRA',     v_linha_tb_referencia.cod_carreira,     v_cod_carreira);
                            SP_INCLUI_LOG(a_log, 'COD_CLASSE',       v_linha_tb_referencia.cod_classe,       v_cod_classe);
                            SP_INCLUI_LOG(a_log, 'COD_REFERENCIA',   v_linha_tb_referencia.cod_referencia,   v_cod_referencia);
                            SP_INCLUI_LOG(a_log, 'COD_REF_PAD_VENC', v_linha_tb_referencia.cod_ref_pad_venc, v_cod_ref_pad_venc);
                            SP_INCLUI_LOG(a_log, 'DAT_INI_VIG',      to_char(v_linha_tb_referencia.dat_ini_vig, 'dd/mm/yyyy hh24:mi'), to_Char(fnc_valida_data(cpa.dat_ini_val_padrao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_VIG',      to_char(v_linha_tb_referencia.dat_fim_vig, 'dd/mm/yyyy hh24:mi'), to_Char(fnc_valida_data(cpa.dat_fim_val_padrao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_JORNADA',      v_linha_tb_referencia.cod_jornada,      v_cod_jornada);
                            SP_INCLUI_LOG(a_log, 'COD_NIVEL',        v_linha_tb_referencia.cod_nivel,        v_cod_nivel);
                            SP_INCLUI_LOG(a_log, 'COD_GRAU',         v_linha_tb_referencia.cod_grau,         v_cod_grau);

                            SP_GRAVA_LOG(i_id_header, cpa.id_processo, cpa.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_REFERENCIA', v_nom_rotina, a_log);

                            if (v_cod_composicao is not null) then   -- registro ja existe em tb_composição, atualiza

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                  null;
                                end if;
                            else -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                v_cod_composicao := seq_cod_composicao.nextval;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_composicao
                                        (COD_INS,               --  1
                                         COD_ENTIDADE,          --  2
                                         COD_PCCS,              --  3
                                         COD_QUADRO,            --  4
                                         COD_CARREIRA,          --  5
                                         COD_CLASSE,            --  6
                                         COD_REFERENCIA,        --  7
                                         COD_CARGO,             --  8
                                         COD_COMPOSICAO,        --  9
                                         DES_DENOMINACAO,       -- 10
                                         QTD_VAGAS_PREV,        -- 11
                                         QTD_VAGAS_OCUP,        -- 12
                                         COD_SIT_COMP,          -- 13
                                         DAT_ING,               -- 14
                                         DAT_ULT_ATU,           -- 15
                                         NOM_USU_ULT_ATU,       -- 16
                                         NOM_PRO_ULT_ATU)       -- 17
                                    values
                                        (cpa.cod_ins,           --  1 - COD_INS
                                         cpa.cod_entidade,      --  2 - COD_ENTIDADE
                                         v_cod_pccs,            --  3 - COD_PCCS
                                         v_cod_quadro,          --  4 - COD_QUADRO
                                         v_cod_carreira,        --  5 - COD_CARREIRA
                                         v_cod_classe,          --  6 - COD_CLASSE
                                         v_cod_referencia,      --  7 - COD_REFERENCIA
                                         cpa.cod_cargo,         --  8 - COD_CARGO
                                         v_cod_composicao,      --  9 - COD_COMPOSICAO
                                         v_nom_cargo,           -- 10 - DES_DENOMINACAO
                                         v_qtd_tot_prev_lei,    -- 11 - QTD_VAGAS_PREV
                                         v_qtd_ocup,            -- 12 - QTD_VAGAS_OCUP
                                         '1',                   -- 13 - COD_SIT_COMP
                                         sysdate,               -- 14 - DAT_ING
                                         sysdate,               -- 15 - DAT_ULT_ATU
                                         user,                  -- 16 - NOM_USU_ULT_ATU
                                         v_nom_rotina);         -- 17 - NOM_PRO_ULT_ATU

                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',         v_linha_tb_composicao.cod_ins,         cpa.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',    v_linha_tb_composicao.cod_entidade,    cpa.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',        v_linha_tb_composicao.cod_pccs,        v_cod_pccs);
                            SP_INCLUI_LOG(a_log, 'COD_QUADRO',      v_linha_tb_composicao.cod_quadro,      v_cod_quadro);
                            SP_INCLUI_LOG(a_log, 'COD_CARREIRA',    v_linha_tb_composicao.cod_carreira,    v_cod_carreira);
                            SP_INCLUI_LOG(a_log, 'COD_CLASSE',      v_linha_tb_composicao.cod_classe,      v_cod_classe);
                            SP_INCLUI_LOG(a_log, 'COD_REFERENCIA',  v_linha_tb_composicao.cod_referencia,  v_cod_referencia);
                            SP_INCLUI_LOG(a_log, 'COD_CARGO',       v_linha_tb_composicao.cod_cargo,       cpa.cod_cargo);
                            SP_INCLUI_LOG(a_log, 'COD_COMPOSICAO',  v_linha_tb_composicao.cod_composicao,  v_cod_composicao);
                            SP_INCLUI_LOG(a_log, 'DES_DENOMINACAO', v_linha_tb_composicao.des_denominacao, v_nom_cargo);
                            SP_INCLUI_LOG(a_log, 'QTD_VAGAS_PREV',  v_linha_tb_composicao.qtd_vagas_prev,  v_qtd_tot_prev_lei);
                            SP_INCLUI_LOG(a_log, 'QTD_VAGAS_OCUP',  v_linha_tb_composicao.qtd_vagas_ocup,  v_qtd_ocup);
                            SP_INCLUI_LOG(a_log, 'COD_SIT_COMP',    v_linha_tb_composicao.cod_sit_comp,    nvl(v_linha_tb_composicao.cod_sit_comp, '1'));

                            SP_GRAVA_LOG(i_id_header, cpa.id_processo, cpa.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_COMPOSICAO', v_nom_rotina, a_log);

                            if (    (v_dat_ini_vig is not null)
                                and (v_dat_fim_vig is null)
                                and (cpa.dat_fim_val_padrao is null)) then
                                -- registro existe, esta vigente, e o novo registro não tem fim de vigencia: define data de fim de vigencia para o registro anterior

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                   null;
                                end if;

                                a_log.delete;
                                SP_INCLUI_LOG(a_log, 'COD_INS',        v_linha_tb_vencimento.cod_ins,       cpa.cod_ins);
                                SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',   v_linha_tb_vencimento.cod_entidade,  cpa.cod_entidade);
                                SP_INCLUI_LOG(a_log, 'COD_PCCS',       v_linha_tb_vencimento.cod_pccs,       v_cod_pccs);
                                SP_INCLUI_LOG(a_log, 'COD_QUADRO',     v_linha_tb_vencimento.cod_quadro,     v_cod_quadro);
                                SP_INCLUI_LOG(a_log, 'COD_CARREIRA',   v_linha_tb_vencimento.cod_carreira,   v_cod_carreira);
                                SP_INCLUI_LOG(a_log, 'COD_CLASSE',     v_linha_tb_vencimento.cod_classe,     v_cod_classe);
                                SP_INCLUI_LOG(a_log, 'COD_REFERENCIA', v_linha_tb_vencimento.cod_referencia, v_cod_referencia);
                                SP_INCLUI_LOG(a_log, 'DAT_FIM_VIG',    to_char(v_linha_tb_vencimento.dat_fim_vig, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(cpa.dat_ini_val_padrao, 'RRRRMMDD') - 1, 'dd/mm/yyyy hh24:mi'));

                                SP_GRAVA_LOG(i_id_header, cpa.id_processo, cpa.num_linha_header, v_cod_tipo_ocorrencia,
                                             v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_VENCIMENTO', v_nom_rotina, a_log);

                            end if;

                            v_cod_tipo_ocorrencia := 'I';

                            if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                insert into tb_vencimento
                                    (COD_INS,               --  1
                                     COD_ENTIDADE,          --  2
                                     COD_PCCS,              --  3
                                     COD_QUADRO,            --  4
                                     COD_CARREIRA,          --  5
                                     COD_CLASSE,            --  6
                                     COD_REFERENCIA,        --  7
                                     DAT_INI_VIG,           --  8
                                     DAT_FIM_VIG,           --  9
                                     VAL_VENCIMENTO,        -- 10
                                     DAT_ING,               -- 11
                                     DAT_ULT_ATU,           -- 12
                                     NOM_USU_ULT_ATU,       -- 13
                                     NOM_PRO_ULT_ATU,       -- 14
                                     FLG_STATUS)            -- 15
                                values
                                    (cpa.cod_ins,                                           --  1 - COD_INS
                                     cpa.cod_entidade,                                      --  2 - COD_ENTIDADE
                                     v_cod_pccs,                                            --  3 - COD_PCCS
                                     v_cod_quadro,                                          --  4 - COD_QUADRO
                                     v_cod_carreira,                                        --  5 - COD_CARREIRA
                                     v_cod_classe,                                          --  6 - COD_CLASSE
                                     v_cod_referencia,                                      --  7 - COD_REFERENCIA
                                     fnc_valida_data(cpa.dat_ini_val_padrao, 'RRRRMMDD'),   --  8 - DAT_INI_VIG
                                     fnc_valida_data(cpa.dat_fim_val_padrao, 'RRRRMMDD'),   --  9 - DAT_FIM_VIG
                                     v_val_padrao_venc,                                     -- 10 - VAL_VENCIMENTO
                                     sysdate,                                               -- 11 - DAT_ING
                                     sysdate,                                               -- 12 - DAT_ULT_ATU
                                     user,                                                  -- 13 - NOM_USU_ULT_ATU
                                     v_nom_rotina,                                          -- 14 - NOM_PRO_ULT_ATU
                                     'V');                                                  -- 15 - FLG_STATUS

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',        null, cpa.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',   null, cpa.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',       null, v_cod_pccs);
                            SP_INCLUI_LOG(a_log, 'COD_QUADRO',     null, v_cod_quadro);
                            SP_INCLUI_LOG(a_log, 'COD_CARREIRA',   null, v_cod_carreira);
                            SP_INCLUI_LOG(a_log, 'COD_CLASSE',     null, v_cod_classe);
                            SP_INCLUI_LOG(a_log, 'COD_REFERENCIA', null, v_cod_referencia);
                            SP_INCLUI_LOG(a_log, 'DAT_INI_VIG',    null, to_char(fnc_valida_data(cpa.dat_ini_val_padrao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_VIG',    null, to_char(fnc_valida_data(cpa.dat_fim_val_padrao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'VAL_VENCIMENTO', null, v_val_padrao_venc);
                            SP_INCLUI_LOG(a_log, 'FLG_STATUS',     null, 'V');

                            SP_GRAVA_LOG(i_id_header, cpa.id_processo, cpa.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_VENCIMENTO', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, cpa.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, cpa.id_processo, cpa.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, cpa.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, cpa.id_processo, cpa.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, cpa.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_CPA;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_CPA (i_cpa       in     r_cpa,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                   varchar2(2000);
        v_des_result                varchar2(4000);
        v_dat_ini_val_padrao        date;
        v_dat_fim_val_padrao        date;
        v_val_padrao_venc           tb_vencimento.val_vencimento%type;
        v_cod_pccs                  tb_cargo.cod_pccs%type;
        v_cod_quadro                tb_cargo.cod_quadro%type;
        v_cod_carreira              tb_cargo.cod_carreira%type;
        v_cod_classe                tb_cargo.cod_classe%type;
        v_cod_jornada               tb_jornada.cod_jornada%type;
        v_cod_nivel                 tb_referencia.cod_nivel%type;
        v_cod_grau                  tb_referencia.cod_grau%type;
        v_cod_regime_retrib         varchar2(4000);
        v_cod_escala_venc           varchar2(4000);
        v_cod_ref_pad_venc          tb_referencia.cod_ref_pad_venc%type;
        v_cod_referencia            tb_referencia.cod_referencia%type;
        v_dat_ini_vig               tb_vencimento.dat_ini_vig%type;
        v_dat_fim_vig               tb_vencimento.dat_fim_vig%type;
        v_val_vencimento            tb_vencimento.val_vencimento%type;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_cpa.cod_ins, i_cpa.cod_entidade);

        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_cpa.cod_cargo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_CARGO', 'Codigo do cargo não foi informado');
        end if;

        if (i_cpa.id_tab_venc is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_TAB_VENC', 'Identificação da tabela de vencimentos não foi informada');
        else
            v_des_result := fnc_busca_cod_pccs(i_cpa.cod_ins, i_cpa.cod_entidade, upper(i_cpa.id_tab_venc));
            if (v_des_result like 'Erro:%') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_TAB_VENC', substr(v_des_result, 6));
            else
                v_cod_pccs := v_des_result;
            end if;
        end if;

        if (i_cpa.cod_referencia is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_REFERENCIA', 'Codigo de referencia do padr?o de vencimentos não foi informado');
        else
            v_des_result := fnc_busca_cod_classe(i_cpa.cod_ins, i_cpa.cod_entidade, upper(i_cpa.cod_referencia));
            if (v_des_result like 'Erro:%') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_REFERENCIA', substr(v_des_result, 6));
            end if;
        end if;

        if (i_cpa.cod_grau_nivel is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_GRAU_NIVEL', 'Codigo do grau/nivel não foi informado');
        else
            v_cod_nivel := fnc_busca_cod_nivel(i_cpa.cod_grau_nivel);
            v_cod_grau := fnc_busca_cod_grau(i_cpa.cod_grau_nivel);
            if (v_cod_nivel is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_GRAU_NIVEL', 'Codigo do nivel ('||i_cpa.cod_grau_nivel|| ') esta invalido');
            elsif (v_cod_grau is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_GRAU_NIVEL', 'Codigo do grau ('||i_cpa.cod_grau_nivel|| ') esta invalido');
            end if;
        end if;

        if (i_cpa.des_jornada is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DES_JORNADA', 'Descrição da jornada não foi preenchida');
        else
            v_des_result := fnc_busca_cod_jornada(i_cpa.cod_ins, upper(i_cpa.des_jornada));
            if (v_des_result like 'Erro:%') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DES_JORNADA', substr(v_des_result, 6));
            else
                v_cod_jornada := v_des_result;
            end if;
        end if;

        if (i_cpa.val_padrao_venc is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PADRAO_VENC', 'Valor do padr?o de vencimento não foi informado');
        elsif (fnc_valida_numero(i_cpa.val_padrao_venc) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PADRAO_VENC', 'Valor do padr?o de vencimento , ('||i_cpa.val_padrao_venc||') esta invalido');
        else
            v_val_padrao_venc := fnc_valida_numero(i_cpa.val_padrao_venc) / 10000;
        end if;

        if (i_cpa.dat_ini_val_padrao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_VAL_PADRAO', 'Data de inicio de validade do padr?o de vencimento não foi informado');
        else
            v_dat_ini_val_padrao := fnc_valida_data(i_cpa.dat_ini_val_padrao, 'RRRRMMDD');
            if (length(i_cpa.dat_ini_val_padrao) < 8 or v_dat_ini_val_padrao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_VAL_PADRAO', 'Data de inicio de validade do padr?o de vencimento ('||i_cpa.dat_ini_val_padrao||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if (i_cpa.dat_fim_val_padrao is not null) then
            v_dat_fim_val_padrao := fnc_valida_data(i_cpa.dat_fim_val_padrao, 'RRRRMMDD');
            if (length(trim(i_cpa.dat_fim_val_padrao)) < 8 or v_dat_fim_val_padrao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_VAL_PADRAO', 'Data de fim de validade do padr?o de vencimento ('||i_cpa.dat_fim_val_padrao||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if (v_cod_pccs is not null) then
            -- valida cod_cargo
            begin
                select cod_quadro, cod_carreira, cod_classe
                into v_cod_quadro, v_cod_carreira, v_cod_classe
                from tb_cargo
                where cod_ins      = i_cpa.cod_ins
                  and cod_entidade = i_cpa.cod_entidade
                  and cod_pccs     = v_cod_pccs
                  and cod_cargo    = i_cpa.cod_cargo;
            exception
                when NO_DATA_FOUND then
                    SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_CARGO', substr('Nenhum cargo cadastrado com a chave '||
                                                                                    'COD_INS = '||i_cpa.cod_ins||
                                                                                    ', COD_ENTIDADE = '||i_cpa.cod_entidade||
                                                                                    ', COD_PCCS = '||v_cod_pccs||
                                                                                    ', COD_CARGO = '||i_cpa.cod_cargo,
                                                                                1, 4000));

                when others then
                    SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_CARGO', substr('Erro ao validar cargo com a chave '||
                                                                                    'COD_INS = '||i_cpa.cod_ins||
                                                                                    ', COD_ENTIDADE = '||i_cpa.cod_entidade||
                                                                                    ', COD_PCCS = '||v_cod_pccs||
                                                                                    ', COD_CARGO = '||i_cpa.cod_cargo||': '||sqlerrm,
                                                                                1, 4000));

            end;
        end if;

        v_cod_regime_retrib := null;
        v_cod_escala_venc := null;
        v_cod_referencia := null;

        if (v_cod_pccs is not null) then

            v_cod_regime_retrib := fnc_busca_dominios_padrao (i_cpa.cod_ins, i_cpa.cod_entidade, v_cod_pccs, i_cpa.cod_cargo, 'RR');
            if (substr(v_cod_regime_retrib, 1, 5) = 'Erro:') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_REGIME_RETRIB', substr(v_cod_regime_retrib, 6), 'Codigo do Regime');
            end if;

            v_cod_escala_venc := fnc_busca_dominios_padrao (i_cpa.cod_ins, i_cpa.cod_entidade, v_cod_pccs, i_cpa.cod_cargo, 'EV');
            if (substr(v_cod_escala_venc, 1, 5) = 'Erro:') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ESCALA_VENC', substr(v_cod_escala_venc, 6), 'Codigo da escala de vencimento');
            end if;

            v_cod_ref_pad_venc := substr(i_cpa.cod_entidade ||'-'||i_cpa.cod_cargo  ||'-'||upper(i_cpa.id_tab_venc)||'-'||
                                         v_cod_jornada      ||'-'||v_cod_nivel      ||'-'||v_cod_grau              ||'-'||
                                         v_cod_regime_retrib||'-'||v_cod_escala_venc||'-'||'LEG', 1, 40);

            begin
                select cod_referencia
                into v_cod_referencia
                from tb_referencia
                where cod_ins          = i_cpa.cod_ins
                  and cod_entidade     = i_cpa.cod_entidade
                  and cod_pccs         = v_cod_pccs
                  and cod_quadro       = v_cod_quadro
                  and cod_carreira     = v_cod_carreira
                  and cod_classe       = v_cod_classe
                  and cod_ref_pad_venc = v_cod_ref_pad_venc;
            exception
                when others then
                    null;
            end;
        end if;

        if (    (v_cod_pccs is not null)
            and (v_cod_quadro is not null)
            and (v_cod_carreira is not null)
            and (v_cod_classe is not null)
            and (v_cod_referencia is not null)) then

            begin
                select dat_ini_vig, val_vencimento
                into v_dat_ini_vig, v_val_vencimento
                from tb_vencimento
                where cod_ins           = i_cpa.cod_ins
                  and cod_entidade      = i_cpa.cod_entidade
                  and cod_pccs          = v_cod_pccs
                  and cod_quadro        = v_cod_quadro
                  and cod_carreira      = v_cod_carreira
                  and cod_classe        = v_cod_classe
                  and cod_referencia    = v_cod_referencia
                  and upper(flg_status) = 'V'
                  and dat_fim_vig       is null;
            exception
                when others then
                    null;
            end;
        end if;

        if (    (v_dat_ini_vig is null)
            and (v_cod_pccs is not null)
            and (v_cod_quadro is not null)
            and (v_cod_carreira is not null)
            and (v_cod_classe is not null)
            and (v_cod_referencia is not null)) then

            begin
                select dat_ini_vig, dat_fim_vig, val_vencimento
                into v_dat_ini_vig, v_dat_fim_vig, v_val_vencimento
                from tb_vencimento
                where cod_ins           = i_cpa.cod_ins
                  and cod_entidade      = i_cpa.cod_entidade
                  and cod_pccs          = v_cod_pccs
                  and cod_quadro        = v_cod_quadro
                  and cod_carreira      = v_cod_carreira
                  and cod_classe        = v_cod_classe
                  and cod_referencia    = v_cod_referencia
                  and upper(flg_status) = 'V'
                  and rownum           <= 1
                order by dat_fim_vig desc;
            exception
                when others then
                    null;
            end;

        end if;

        if (v_dat_ini_val_padrao is not null and v_dat_fim_val_padrao is not null and v_dat_ini_val_padrao > v_dat_fim_val_padrao) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_VAL_PADRAO', 'Data de fim da validade do padr?o ('||i_cpa.dat_fim_val_padrao||') e anterior a data de inicio de validade ('||i_cpa.dat_ini_val_padrao||')');
        end if;

        if (v_dat_ini_vig is not null and v_dat_fim_vig is null) then -- procura se existe padr?o de vencimento vigente para o cargo
            if (v_val_vencimento = v_val_padrao_venc) then -- verifica se e o mesmo valor
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PADRAO_VENC', 'Ja existe padr?o de vencimento vigente para esse cargo com o mesmo valor');
            else
                if (v_dat_ini_vig >= v_dat_ini_val_padrao) then
                    SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_VAL_PADRAO', 'Ja existe padr?o de vencimento vigente com inicio de vigencia posterior a data informada');
                end if;
            end if;
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr('Passo: '||sqlerrm, 1, 2000));

    END FNC_VALIDA_CPA;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_HFE (i_id_header in number) IS

        /* Pega o primeiro cargo de cada matricula e numero vinculo, e insere a relação baseada nesses dados.
           AS demais iterações servem apenas para inserçõa das lotações */

        v_result                        varchar2(4000);
        v_cur_id                        tb_carga_gen_hfe.id%type;
        v_flg_acao_postergada           tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia           tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia           tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar                       t_validar;
        a_log                           t_log;
        v_nom_rotina                    varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_HFE';
        v_nom_tabela                    varchar2(100) := 'TB_CARGA_GEN_HFE';
        v_linha_tb_relacao_funcional    tb_relacao_funcional%rowtype;
        v_lin_tb_rel_func_periodo_exer  tb_rel_func_periodo_exerc%rowtype;
        v_cod_pccs                      tb_pccs.cod_pccs%type;
        v_id_log_erro                   number;
        v_msg_erro                      varchar2(4000);
        v_cod_erro                      number;
        v_vlr_iteracao                  number := 20;
        v_cod_entidade                  tb_carga_Gen_hfe.Cod_Entidade%type;
        v_id_Servidor                   tb_carga_Gen_hfe.Id_Servidor%type;
        v_cod_ide_Rel_func              tb_relacao_funcional.cod_ide_rel_func%type;
        v_cod_ide_cli                   tb_relacao_funcional.cod_ide_cli%type;
        v_data_ini_exerc                date;
        v_data_fim_exerc                date;
        v_data_fim_exerc_lot            date;
        v_cod_orgao                    tb_orgao.cod_orgao%type;
        v_qtd_lotacao                  number;
        v_dat_ini_lotacao              date;
        v_dat_fim_lotacao              date;
        erro_reg                       exception;
    BEGIN
     --   return;
        --  agrupar vinculos (ignorandoa lterações de lotação) para o processo de validação automatizada.
        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if v_result is not null then
           sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina, 'Erro processo');
           return;
         end if;



        loop
            v_result                       := null;
            v_cur_id                       := null;
            v_linha_tb_relacao_funcional   := null;
            v_lin_tb_rel_func_periodo_exer := null;


            -- Marcando registros que seráo inseridos como para validar
            -- (Agurpados por id_Servidor e id_vinculo, pois é necessário selecinoar todos os registros
            --
            update tb_Carga_Gen_hfe
               set cod_status_processamento = 2
              where id_header = i_id_header
                and (id_Servidor, id_vinculo) in (select distinct id_Servidor, id_vinculo
                                                               from tb_Carga_Gen_hfe
                                                              where id_header = i_id_header
                                                                and cod_status_processamento = 1
                                                                fetch first 20 rows only);

            -- critério sair do loop
            if sql%rowcount = 0 then
              exit;
            end if;
            --
            --
            for hfe in (select a.cod_ins                                                                    as cod_ins,
                               a.id_header                                                                  as id_header,
                               trim(a.cod_entidade)                                                         as cod_entidade,
                               lag (a.cod_entidade,1) over (partition by id_servidor,id_vinculo
                                                                order by dat_ini_exerc)                     as cod_entidade_ant,
                               trim(a.id_servidor)                                                          as id_servidor,
                               lag (a.id_servidor,1) over (partition by  id_servidor,id_vinculo
                                                               order by dat_ini_exerc)                      as id_servidor_ant,
                               trim(a.id_vinculo)                                                           as id_vinculo,
                               lag (a.id_vinculo,1) over (partition by  id_servidor,id_vinculo
                                                              order by dat_ini_exerc)                       as id_vinculo_ant,
                               trim(a.cod_cargo)                                                            as cod_cargo,
                               trim(a.dat_nomeacao)                                                         as dat_nomeacao,
                               trim(a.dat_posse)                                                            as dat_posse,
                               trim(a.dat_ini_exerc)                                                        as dat_ini_exerc,
                               lead(a.dat_ini_exerc,1) over (partition by  id_servidor,id_vinculo
                                                                 order by dat_ini_exerc)                    as dat_ini_exerc_prox,                                                                                                        trim(a.cod_orgao_lotacao)        cod_orgao_lotacao,
                               trim(a.cod_regime_jur)                                                       as cod_regime_jur,
                               fnc_codigo_ext(a.cod_ins, 3020, trim(a.cod_regime_jur), null, 'COD_PAR')     as cod_regime_jur_int,
                               trim(to_number(a.cod_tipo_provimento))                                       as cod_tipo_provimento,
                               fnc_codigo_ext(a.cod_ins,
                                              2025,
                                              trim(to_number(a.cod_tipo_provimento)),
                                              null,
                                              'COD_PAR')                                                    as  cod_tipo_provimento_int,
                               trim(to_number(a.cod_tipo_doc_ini_vinculo))                                  as cod_tipo_doc_ini_vinculo,
                               fnc_codigo_ext(a.cod_ins,
                                              2019,
                                              trim(to_number(a.cod_tipo_doc_ini_vinculo)),
                                              null,
                                              'COD_PAR')                                                    as cod_tipo_doc_ini_vinculo_int,
                               trim(a.num_doc_ini_vinculo)                                                  as num_doc_ini_vinculo,
                               trim(to_number(a.cod_tipo_vinculo))                                          as cod_tipo_vinculo,
                               fnc_codigo_ext(a.cod_ins,
                                              10131,
                                              trim(to_number(a.cod_tipo_vinculo)),
                                              null,
                                              'COD_PAR')                                                    as cod_tipo_vinculo_int,
                               trim(a.dat_fim_exerc)                                                        as dat_fim_exerc,
                               max(a.dat_fim_exerc) over (partition by id_servidor,id_vinculo )             as dat_fim_exerc_prox,
                               trim(a.cod_motivo_desligamento)                                              as cod_motivo_desligamento,
                               fnc_codigo_ext(a.cod_ins,
                                              2020,
                                              trim(a.cod_motivo_desligamento),
                                              null,
                                              'COD_PAR')                                                     as cod_motivo_desligamento_int,
                               trim(to_number(a.cod_tipo_doc_fim_vinculo))                                   as cod_tipo_doc_fim_vinculo,
                               fnc_codigo_ext(a.cod_ins,
                                              2072,
                                              trim(to_number(a.cod_tipo_doc_fim_vinculo)),
                                              null,
                                              'COD_PAR')                                                     as cod_tipo_doc_fim_vinculo_int,
                               trim(a.num_doc_fim_vinculo)                                                   as num_doc_fim_vinculo,
                               trim(a.cod_situ_funcional)                                                    as cod_situ_funcional,
                               fnc_codigo_ext(a.cod_ins,
                                              2036,
                                              trim(a.cod_situ_funcional),
                                              null,
                                              'COD_PAR')                                                     as cod_situ_funcional_int,
                               trim(a.cod_regime_previd)                                                     as cod_regime_previd,
                               fnc_codigo_ext(a.cod_ins,
                                              10132,
                                              trim(a.cod_regime_previd),
                                              null,
                                              'COD_PAR')                                                     as cod_regime_previd_int,
                               trim(a.cod_plan_previd)                                                       as cod_plan_previd,
                               fnc_codigo_ext(a.cod_ins,
                                              10133,
                                              trim(a.cod_plan_previd),
                                              null,
                                              'COD_PAR')                                                     as cod_plan_previd_int,
                               trim(a.cod_tipo_historico)                                                    as cod_tipo_historico,
                               fnc_codigo_ext(a.cod_ins,
                                              2016,
                                              trim( decode(a.cod_tipo_historico,'9','99',a.cod_tipo_historico)),
                                              null,
                                              'COD_PAR')                                                     as cod_tipo_historico_int,
                               trim(a.des_observacao)                                                        as des_observacao,
                               a.id                                                                          as id,
                               a.num_linha_header                                                            as num_linha_header,
                               a.id_processo                                                                 as id_processo
                        from tb_carga_gen_hfe a
                        where a.id_header = i_id_header
                          and a.cod_status_processamento = '2'
                        order by a.id_servidor, a.id_vinculo, a.cod_entidade, a.dat_ini_exerc
                        for update nowait) loop

                v_cur_id              := hfe.id;
                v_result              := null;

                BEGIN

                    savepoint sp1;

                    v_cod_pccs := null;


                    -- separando entidade de id_header
                    v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(hfe.id_servidor);
                    v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(hfe.cod_entidade,hfe.id_servidor);


                    -- Pega rel func
                    v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,hfe.id_vinculo);
                    --
                    if hfe.dat_nomeacao = '00000000' then
                        hfe.dat_nomeacao := null;
                    end if;

                    if hfe.dat_posse = '00000000' then
                        hfe.dat_posse := null;
                    end if;

                    v_data_ini_exerc := FNC_VALIDA_DATA(hfe.dat_ini_exerc,'RRRRMMDD');

                    if v_data_ini_exerc is null then
                      v_data_ini_exerc := FNC_VALIDA_DATA(hfe.dat_posse,'RRRRMMDD');
                    end if;

                    v_data_fim_exerc  := FNC_VALIDA_DATA(hfe.dat_ini_exerc_prox,'RRRRMMDD');
                    v_data_fim_exerc  := v_data_fim_exerc -1;

                    a_validar.delete;
                    --
                    PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                            i_num_linha        => hfe.num_linha_header,
                                                                            o_Result           => v_result,
                                                                            o_cod_erro         => v_cod_erro,
                                                                            o_des_erro         => v_msg_erro);


                    if v_cod_erro is not null then
                      v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                      raise erro_reg;
                    end if;
                    --
                    --v_result := FNC_VALIDA_HFE(hfe, a_validar);

                    if v_cod_erro is not null then
                      v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                      raise erro_reg;
                    end if;
                    --

                    --
                    -- Pega cod_ide_cli da ident_ext_servidor
                    v_cod_ide_cli := fnc_ret_cod_ide_cli( hfe.cod_ins, v_id_Servidor);

                    if FNC_VALIDA_PESSOA_FISICA(hfe.cod_ins, v_cod_ide_cli) is not null then
                      v_result := 'Servidor possui Benefício cadastrado';
                      raise erro_reg;
                    end if;

                    -- PCCS
                    -- O Pccs sera genérico. no processo de evolução funcional, será atualziado o EVF

                    v_cod_pccs := 29;

                    -- LOTAÇÂO (insere apenas regisro sem concomitancia)
                    begin
                      select o.cod_orgao
                        into v_cod_orgao
                        from tb_orgao o
                       where o.cod_ins = hfe.cod_ins
                         and o.cod_entidade = v_cod_entidade
                         and o.cod_orgao = hfe.cod_entidade
                         and rownum <2;
                     exception
                       when no_data_found then
                         v_cod_orgao := null;
                     end;
                     --
                     if v_cod_orgao is not null then
                      --
                        select min(l.dat_ini), max(l.dat_fim)
                          into v_dat_ini_lotacao,v_dat_fim_lotacao
                          from tb_lotacao l
                         where l.cod_ins = hfe.cod_ins
                           and l.cod_ide_cli  = v_cod_ide_cli
                           and l.cod_entidade = v_cod_entidade
                           and l.num_matricula = v_id_Servidor
                           and l.cod_ide_rel_func = v_cod_ide_rel_func
                           and l.cod_orgao = v_cod_orgao;
                        --
                        v_dat_ini_lotacao := least(v_dat_ini_lotacao,v_data_ini_exerc);
                          v_dat_fim_lotacao := v_data_fim_exerc;

                        if v_dat_ini_lotacao is null then -- registro sem concomitancia
                          insert into tb_lotacao
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
                          values
                          (hfe.cod_ins,                      --COD_INS
                           v_cod_ide_cli,                    --COD_IDE_CLI
                           v_cod_entidade,                   --COD_ENTIDADE
                           v_cod_pccs,                       --COD_PCCS
                           hfe.cod_cargo,                    --COD_CARGO
                           v_id_Servidor,                    --NUM_MATRICULA
                           v_cod_ide_rel_func,               --COD_IDE_REL_FUN
                           v_cod_orgao,                      --COD_ORGAO
                           v_data_ini_exerc,                 --DAT_INI
                           '1',                              --COD_MOT_INI
                           v_data_fim_exerc_lot,                 --DAT_FIM
                           hfe.cod_motivo_desligamento,      --COD_MOT_FIM
                           sysdate,                          --DAT_ING
                           sysdate,                          --DAT_ULT_ATU
                           user,                             --NOM_USU_ULT_ATU
                           'PAC_CARGA_GENERICA.SP_CARREGA_HFE');
                        else
                          update tb_lotacao lot
                           set dat_ini  = v_dat_ini_lotacao,
                               dat_fim  = v_dat_fim_lotacao
                           where cod_ins = hfe.cod_ins
                             and cod_ide_cli  = v_cod_ide_cli
                             and cod_entidade = v_cod_entidade
                             and num_matricula = v_id_servidor
                             and cod_ide_rel_func = v_cod_ide_rel_func
                             and cod_orgao = v_cod_orgao
                             and rownum <2;
                        end if;
                   end if;

                   -- Aqui ignora restante do processo para alterações que não afetam os campos chave
                   if hfe.id_servidor = hfe.id_servidor_ant and
                      hfe.id_vinculo = hfe.id_vinculo_ant then

                      if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, hfe.id, '3', null, v_nom_rotina) != 'TRUE') then
                          raise ERRO_GRAVA_STATUS;
                      end if;

                      continue;

                   end if;

                   -- Seleciona linha da tb_rel_func_periodo_Exerc
                 /*  for c in (select *
                               from tb_rel_func_periodo_exerc a
                              where cod_ins          = hfe.cod_ins
                                and cod_ide_cli      = v_cod_ide_cli
                                and num_matricula    = v_id_servidor
                                and cod_ide_rel_func = v_cod_ide_rel_func
                              order by num_seq_periodo_exerc desc) loop

                       v_lin_tb_rel_func_periodo_exer := c;
                       exit;

                     end loop;
                     --
                     if (nvl(v_lin_tb_rel_func_periodo_exer.cod_ins, 1) < 0) then
                          SP_INCLUI_ERRO_VALIDACAO(a_validar, null, 'Erro ao verificar TB_REL_FUNC_PERIODO_EXERC, LOG_BD.ID = '||v_lin_tb_rel_func_periodo_exer.nom_pro_ult_atu, 'Sequencial do periodo de exercicio');
                          v_result := 'Erro de validação';
                     end if;*/

                    begin
                        select *
                        into v_linha_tb_relacao_funcional
                        from tb_relacao_funcional
                        where cod_ins = hfe.cod_ins
                          and cod_ide_cli = v_cod_ide_cli
                          and num_matricula = v_id_Servidor
                          and cod_ide_rel_func = v_cod_ide_Rel_func;
                    exception
                        when others then
                            null;
                    end;

                    if (v_linha_tb_relacao_funcional.cod_ins is not null) then -- registro ja existe em tb_relacao_funcional, atualiza os demais dados

                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                            update tb_relacao_funcional
                            set cod_pccs               = v_cod_pccs,
                                cod_cargo              = hfe.cod_cargo,
                                dat_nomea              = fnc_valida_data(hfe.dat_nomeacao, 'RRRRMMDD'),
                                dat_posse              = fnc_valida_data(hfe.dat_posse, 'RRRRMMDD'),
                                dat_ini_estag_prob     = v_data_ini_exerc,
                                cod_regime             = hfe.cod_regime_previd_int,
                                cod_plano              = nvl(hfe.cod_plan_previd_int, cod_plano),
                                des_obs                = nvl(substr(hfe.des_observacao, 1, 255), des_obs),
                                cod_vinculo            = hfe.id_vinculo,
                                cod_regime_jur         = hfe.cod_regime_jur_int,
                                tip_provimento         = hfe.cod_tipo_provimento_int,
                                cod_sit_func           = nvl(hfe.cod_situ_funcional_int, cod_sit_func),
                                dat_fim_exerc          = nvl(fnc_valida_data(hfe.dat_fim_exerc, 'RRRRMMDD'), dat_fim_exerc),
                                cod_mot_deslig         = nvl(hfe.cod_motivo_desligamento_int, cod_mot_deslig),
                                cod_tipo_doc_assoc_fim = nvl(hfe.cod_tipo_doc_fim_vinculo_int, cod_tipo_doc_assoc_fim),
                                num_doc_assoc_fim      = nvl(hfe.num_doc_fim_vinculo, num_doc_assoc_fim),
                                dat_ini_exerc          = fnc_valida_data(hfe.dat_ini_exerc, 'RRRRMMDD'),
                                cod_tipo_doc_assoc_ini = nvl(hfe.cod_tipo_doc_ini_vinculo_int, cod_tipo_doc_assoc_ini),
                                num_doc_assoc_ini      = nvl(hfe.num_doc_ini_vinculo, num_doc_assoc_ini),
                                cod_tipo_hist_ini      = hfe.cod_tipo_historico_int,
                                dat_ult_atu            = sysdate,
                                nom_usu_ult_atu        = user,
                                nom_pro_ult_atu        = v_nom_rotina
                            where cod_ins          = v_linha_tb_relacao_funcional.cod_ins
                              and cod_ide_cli      = v_linha_tb_relacao_funcional.cod_ide_cli
                              and cod_entidade     = v_linha_tb_relacao_funcional.cod_entidade
                              and num_matricula    = v_linha_tb_relacao_funcional.num_matricula
                              and cod_ide_rel_func = v_linha_tb_relacao_funcional.cod_ide_rel_func
                              and nom_pro_ult_atu = v_nom_rotina;
                        end if;

                    else                        -- registro não existe, inclui

                        v_cod_tipo_ocorrencia := 'I';

                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                            insert into tb_relacao_funcional
                                (COD_INS,                   --  1
                                 COD_IDE_CLI,               --  2
                                 COD_ENTIDADE,              --  3
                                 COD_PCCS,                  --  4
                                 COD_CARGO,                 --  5
                                 NUM_MATRICULA,             --  6
                                 COD_IDE_REL_FUNC,          --  7
                                 COD_SIT_PREV,              --  8
                                 DAT_NOMEA,                 --  9
                                 DAT_POSSE,                 -- 10
                                 DAT_INI_ESTAG_PROB,        -- 11
                                 DAT_ING,                   -- 12
                                 DAT_ULT_ATU,               -- 13
                                 NOM_USU_ULT_ATU,           -- 14
                                 NOM_PRO_ULT_ATU,           -- 15
                                 COD_REGIME,                -- 16
                                 COD_PLANO,                 -- 17
                                 DES_OBS,                   -- 18
                                 COD_VINCULO,               -- 19
                                 COD_REGIME_JUR,            -- 20
                                 TIP_PROVIMENTO,            -- 21
                                 COD_SIT_FUNC,              -- 22
                                 DAT_FIM_EXERC,             -- 23
                                 COD_MOT_DESLIG,            -- 24
                                 COD_TIPO_DOC_ASSOC_FIM,    -- 25
                                 NUM_DOC_ASSOC_FIM,         -- 26
                                 DAT_INI_EXERC,             -- 27
                                 COD_TIPO_DOC_ASSOC_INI,    -- 28
                                 NUM_DOC_ASSOC_INI,         -- 29
                                 COD_TIPO_HIST_INI)         -- 30
                            values
                                (hfe.cod_ins,                                    --  1 COD_INS
                                 v_cod_ide_cli,                                  --  2 COD_IDE_CLI
                                 v_cod_entidade,                                 --  3 COD_ENTIDADE
                                 v_cod_pccs,                                     --  4 COD_PCCS
                                 hfe.cod_cargo,                                  --  5 COD_CARGO
                                 v_id_servidor,                                  --  6 NUM_MATRICULA
                                 v_cod_ide_rel_func,                             --  7 COD_IDE_REL_FUNC
                                 '1',                                            --  8 COD_SIT_PREV
                                 fnc_valida_data(hfe.dat_nomeacao, 'RRRRMMDD'),  --  9 DAT_NOMEA
                                 fnc_valida_data(hfe.dat_posse, 'RRRRMMDD'),     -- 10 DAT_POSSE
                                 v_data_ini_exerc,                               -- 11 DAT_INI_ESTAG_PROB
                                 sysdate,                                        -- 12 DAT_ING
                                 sysdate,                                        -- 13 DAT_ULT_ATU
                                 user,                                           -- 14 NOM_USU_ULT_ATU
                                 v_nom_rotina,                                   -- 15 NOM_PRO_ULT_ATU
                                 hfe.cod_regime_previd_int,                      -- 16 COD_REGIME
                                 hfe.cod_plan_previd_int,                        -- 17 COD_PLANO
                                 substr(hfe.des_observacao, 1, 255),             -- 18 DES_OBS
                                 hfe.id_vinculo,                                 -- 19 COD_VINCULO
                                 hfe.cod_regime_jur_int,                         -- 20 COD_REGIME_JUR
                                 hfe.cod_tipo_provimento_int,                    -- 21 TIP_PROVIMENTO
                                 hfe.cod_situ_funcional_int,                     -- 22 COD_SIT_FUNC
                                 fnc_valida_data(hfe.dat_fim_exerc, 'RRRRMMDD'), -- 23 DAT_FIM_EXERC
                                 hfe.cod_motivo_desligamento_int,                -- 24 COD_MOT_DESLIG
                                 hfe.cod_tipo_doc_fim_vinculo_int,               -- 25 COD_TIPO_DOC_ASSOC_FIM
                                 hfe.num_doc_fim_vinculo,                        -- 26 NUM_DOC_ASSOC_FIM
                                 v_data_ini_exerc,                               -- 27 DAT_INI_EXERC
                                 hfe.cod_tipo_doc_ini_vinculo_int,               -- 28 COD_TIPO_DOC_ASSOC_INI
                                 hfe.num_doc_ini_vinculo,                        -- 29 NUM_DOC_ASSOC_INI
                                 hfe.cod_tipo_historico_int);                    -- 30 COD_TIPO_HIST_INI

                        end if;

                    end if;


/*                     if (v_lin_tb_rel_func_periodo_exer.cod_ins is not null) then -- registro ja existe em tb_rel_func_periodo_exerc, atualiza os demais dados

                        v_cod_tipo_ocorrencia := 'A';

                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                            update tb_rel_func_periodo_exerc
                            set cod_pccs               = v_cod_pccs,
                                cod_cargo              = hfe.cod_cargo,
                                dat_ini_exerc          = v_data_ini_exerc,
                                cod_tipo_doc_assoc_ini = nvl(hfe.cod_tipo_doc_ini_vinculo_int, cod_tipo_doc_assoc_ini),
                                num_doc_assoc_ini      = nvl(hfe.num_doc_ini_vinculo, num_doc_assoc_ini),
                                cod_tipo_hist_ini      = hfe.cod_tipo_historico_int,
                                dat_fim_exerc          = nvl(fnc_valida_data(hfe.dat_fim_exerc, 'RRRRMMDD'), dat_fim_exerc),
                                cod_tipo_doc_assoc_fim = nvl(hfe.cod_tipo_doc_fim_vinculo_int, cod_tipo_doc_assoc_fim),
                                num_doc_assoc_fim      = nvl(hfe.num_doc_fim_vinculo, num_doc_assoc_fim),
                                cod_mot_deslig         = nvl(hfe.cod_motivo_desligamento_int, cod_mot_deslig),
                                dat_ult_atu            = sysdate,
                                nom_usu_ult_atu        = user,
                                nom_pro_ult_atu        = v_nom_rotina
                            where cod_ins               = v_lin_tb_rel_func_periodo_exer.cod_ins
                              and cod_ide_cli           = v_lin_tb_rel_func_periodo_exer.cod_ide_cli
                              and cod_entidade          = v_lin_tb_rel_func_periodo_exer.cod_entidade
                              and num_matricula         = v_lin_tb_rel_func_periodo_exer.num_matricula
                              and cod_ide_rel_func      = v_lin_tb_rel_func_periodo_exer.cod_ide_rel_func
                              and num_seq_periodo_exerc = v_lin_tb_rel_func_periodo_exer.num_seq_periodo_exerc
                              and nom_pro_ult_atu       = v_nom_rotina;

                        end if;

                    else                        -- registro não existe, inclui

                        v_cod_tipo_ocorrencia := 'I';

                        if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

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
                                (hfe.cod_ins,                                    --  1 COD_INS
                                 v_cod_ide_cli,                                --  2 COD_IDE_CLI
                                 v_cod_entidade,                               --  3 COD_ENTIDADE
                                 v_cod_pccs,                                     --  4 COD_PCCS
                                 hfe.cod_cargo,                                  --  5 COD_CARGO
                                 v_id_servidor,                                --  6 NUM_MATRICULA
                                 v_Cod_ide_rel_func,                          --  7 COD_IDE_REL_FUNC
                                 '1',                                            --  8 NUM_SEQ_PERIODO_EXERC
                                 v_data_ini_exerc,                                --  9 DAT_INI_EXERC
                                 hfe.cod_tipo_doc_ini_vinculo_int,               -- 10 COD_TIPO_DOC_ASSOC_INI
                                 hfe.num_doc_ini_vinculo,                        -- 11 NUM_DOC_ASSOC_INI
                                 hfe.cod_tipo_historico_int,                     -- 12 COD_TIPO_HIST_INI
                                 fnc_valida_data(hfe.dat_fim_exerc, 'RRRRMMDD'), -- 13 DAT_FIM_EXERC
                                 hfe.cod_tipo_doc_fim_vinculo_int,               -- 14 COD_TIPO_DOC_ASSOC_FIM
                                 hfe.num_doc_fim_vinculo,                        -- 15 NUM_DOC_ASSOC_FIM
                                 hfe.cod_motivo_desligamento_int,                -- 16 COD_MOT_DESLIG
                                 sysdate,                                        -- 17 DAT_ING
                                 sysdate,                                        -- 18 DAT_ULT_ATU
                                 user,                                           -- 19 NOM_USU_ULT_ATU
                                 v_nom_rotina);                                  -- 20 NOM_PRO_ULT_ATU

                        end if;

                    end if;*/

                   if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, hfe.id, '3', null, v_nom_rotina) != 'TRUE') then
                        raise ERRO_GRAVA_STATUS;
                   end if;


                EXCEPTION
                    WHEN ERRO_REG THEN
                       rollback to sp1;

                       SP_GRAVA_ERRO_DIRETO(i_id_header,hfe.id_processo , hfe.num_linha_header,v_result);

                       if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, hfe.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                            raise ERRO_GRAVA_STATUS;
                       end if;

                       commit;

                    WHEN OTHERS THEN

                        v_msg_erro := substr(sqlerrm, 1, 4000);

                        rollback to sp1;

                        SP_GRAVA_ERRO(i_id_header, hfe.id_processo, hfe.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                        if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, hfe.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                            raise ERRO_GRAVA_STATUS;
                        end if;
                END;
            end loop;

           if v_result is null then
             sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);
           end if;

           exit when v_cur_id is null;

           commit;

        end loop;



        update tb_carga_gen_hfe
            set cod_status_processamento = '1'
            where id_header = i_id_header
              and cod_status_processamento = '0';

        commit;
    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

            update tb_carga_gen_hfe
            set cod_status_processamento = '1'
            where id_header = i_id_header
              and cod_status_processamento = '0';

            commit;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

            update tb_carga_gen_hfe
            set cod_status_processamento = '1'
            where id_header = i_id_header
              and cod_status_processamento = '0';

            commit;

        WHEN OTHERS THEN

            v_msg_erro := sqlcode||' - '||sqlerrm;

            rollback;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina,v_msg_erro );

            update tb_carga_gen_hfe
               set cod_status_processamento = '1'
             where id_header = i_id_header
               and cod_status_processamento = '0';

            commit;

    END SP_CARREGA_HFE;
    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_EVF (i_id_header in number) IS

        v_result                     varchar2(2000);
        v_cur_id                     tb_carga_gen_evf.id%type;
        v_flg_acao_postergada        tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia        tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia        tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar                    t_validar;
        a_log                        t_log;
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
    BEGIN
      return;
      if pac_Carga_Generica_cliente.fnc_des_cliente = 'CAMPREV' then
          -------------------------------- PARA CAMPREV Insere data fim da evlução de forma dinamica (Caso o arquivo venha sem data fim)
           for evf in (select a.dat_ini_even_func,
                             lead(trim(a.dat_ini_even_func),1) over (partition by id_servidor,id_vinculo order by  dat_ini_even_func) as dat_ini_even_func_prox,
                             rowid as linha
                      from tb_carga_gen_evf a
                      where a.id_header = i_id_header
                        and exists (select '1'
                                       from tb_carga_gen_evf b
                                       where a.id_header = b.id_header
                                         and a.id_servidor = b.id_servidor
                                         and nvl(a.id_vinculo,'99') = nvl(b.id_vinculo,'99')
                                         and cod_status_processamento = '1'
                                   )
          )
          loop
            if evf.dat_ini_even_func = evf.dat_ini_even_func_prox then

               SP_GRAVA_AVISO(i_id_header,209, 0, 'MAN','Registro com data inicio Duplicado - Não processado');

               update tb_carga_gen_evf
               set cod_status_processamento = '6'
              where rowid = evf.linha;
            else

              v_dat_fim := to_date(evf.dat_ini_even_func_prox,'yyyymmdd');
              --
              v_dat_fim := v_dat_fim - 1;

              update tb_carga_gen_evf
                 set dat_fim_even_func = to_char(v_dat_fim,'yyyymmdd')
                where rowid = evf.linha;
            end if;
          end loop;

          --
          commit;
        end if;
        --
        --
       -- pac_Carga_Generica_cliente.sp_ins_referencia_tmp;
        ----------------------------------

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then
            loop
                v_result := null;
                v_cur_id := null;
                v_cod_erro := null;

              for evf in (select a.cod_ins,
                                 a.id_header,
                                 trim(a.cod_entidade)               cod_entidade,
                                 trim(a.id_servidor)                id_servidor,
                                 trim(a.id_vinculo)                 id_vinculo,
                                 trim(a.cod_cargo)                  cod_cargo,
                                 trim(to_number(a.cod_moti_evol_even_func))    cod_moti_evol_even_func,
                                 fnc_codigo_ext(a.cod_ins, 10134, trim(to_number(a.cod_moti_evol_even_func)), null, 'COD_PAR') cod_moti_evol_even_func_int,
                                 trim(a.dat_ini_even_func)          dat_ini_even_func,
                                 trim(to_number(a.cod_tipo_doc_ini_even_func)) cod_tipo_doc_ini_even_func,
                                 fnc_codigo_ext(a.cod_ins, 2019, trim(to_number(a.cod_tipo_doc_ini_even_func)), null, 'COD_PAR') cod_tipo_doc_ini_even_func_int,
                                 trim(a.num_doc_ini_even_func)      num_doc_ini_even_func,
                                 trim(a.dat_fim_even_func)          dat_fim_even_func,
                                 fnc_codigo_ext(a.cod_ins, 2072, trim(to_number(a.cod_tipo_doc_fim_even_func)), null, 'COD_PAR') cod_tipo_doc_fim_even_func_int,
                                 trim(to_number(a.cod_tipo_doc_fim_even_func)) cod_tipo_doc_fim_even_func,
                                 trim(a.num_doc_fim_even_func)      num_doc_fim_even_func,
                                 trim(a.cod_referencia)             cod_referencia,
                                 trim(a.cod_grau_nivel)             cod_grau_nivel,
                                 trim(a.des_jornada)                des_jornada,
                                 trim(a.des_observacao)             des_observacao,
                                 trim(a.num_faixa_nivel)            num_faixa_nivel,
                                 a.id,
                                 a.num_linha_header,
                                 a.id_processo
                          from tb_carga_gen_evf a
                          where a.id_header = i_id_header
                            and a.cod_status_processamento = '1'
                            and rownum <= v_vlr_iteracao ) loop

                  v_result              := null;
                  v_cur_id              := evf.id;

                  BEGIN

                      savepoint sp1;
                      v_result := null;
                      v_cod_erro := null;

                      -- separando entidade de id_header
                      v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(evf.id_servidor);
                      v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(evf.cod_entidade,evf.id_servidor);
                                                                                   --
                      -- Pega cod_ide_cli da ident_ext_servidor
                      v_cod_ide_cli := fnc_ret_cod_ide_cli( evf.cod_ins, v_id_Servidor);


                      if FNC_VALIDA_PESSOA_FISICA(evf.cod_ins, v_cod_ide_cli) is not null then
                         raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                      end if;
                      --
                      --
                      v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,evf.id_vinculo);
                      --
                      -- considera entidade da relacao funcional
                      if  pac_carga_generica_cliente.fnc_des_cliente = 'CAMPREV' then
                        begin
                        select cod_entidade
                          into v_cod_entidade
                          from tb_relacao_funcional rf
                          where rf.cod_ins = evf.cod_ins
                            and rf.cod_ide_cli = v_cod_ide_cli
                            and rf.num_matricula = v_id_Servidor
                            and rf.cod_ide_rel_func =  v_cod_ide_Rel_func;
                        exception
                          when no_data_found then
                             raise_application_error(-20000, 'Não encontrado vinculo para o servidor');
                        end;

                      end if;
                      --
                      if (evf.dat_ini_even_func is not null and evf.dat_ini_even_func = '00000000') then
                          evf.dat_ini_even_func := null;
                      end if;
                      --
                      if (evf.dat_fim_even_func is not null and evf.dat_fim_even_func = '00000000') then
                          evf.dat_fim_even_func := null;
                      end if;
                      --
                      v_dat_ini_even_func := fnc_valida_data(evf.dat_ini_even_func, 'RRRRMMDD');
                      v_dat_fim_even_func := fnc_valida_data(evf.dat_fim_even_func, 'RRRRMMDD');
                      --
                      --
                      if v_dat_ini_even_func is null then
                        -- pega data inicio da relacao funcional
                        select min(rf.dat_ini_exerc)
                          into v_dat_ini_even_func
                          from tb_relacao_funcional rf
                         where rf.cod_ins = evf.cod_ins
                           and rf.cod_ide_cli = v_cod_ide_cli
                           and rf.num_matricula = v_id_Servidor
                           and rf.cod_ide_rel_func =  v_cod_ide_Rel_func;
                      end if;

                         -- determina data fim
                      if pac_carga_generica_cliente.fnc_des_cliente = 'IPREV' then
                        v_dat_fim_even_func := null;

                        select min(dat_ini_efeito)
                          into v_dat_fim_even_func
                          from tb_evolucao_funcional
                          where cod_ins = evf.cod_ins
                            and cod_Entidade = v_cod_entidade
                            and cod_ide_cli =v_cod_ide_cli
                            and num_matricula = v_id_Servidor
                            and cod_ide_rel_func = v_cod_ide_Rel_func
                            and dat_ini_efeito >= trunc( v_dat_ini_even_func+1);

                          if  v_dat_fim_even_func is not null then
                             v_dat_fim_even_func:= v_dat_fim_even_func-1;
                           end if;

                      end if;
                      --
                      a_validar.delete;
                      --
                   /*   PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                              i_num_linha        => evf.num_linha_header,
                                                                              o_result           => v_result,
                                                                              o_cod_erro         => v_cod_erro,
                                                                              o_des_erro         => v_msg_erro); */


                      if v_cod_erro is not null then
                        v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                      end if;
                      --
                      if v_result is null then
                        v_result := FNC_VALIDA_EVF(evf, a_validar);
                      end if;
                      ---

                      if (v_result is null) then

                        if (v_cod_ide_cli is null) then
                            SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
                            v_result := 'Erro de validação';
                        end if;

                      end if;


                      if (v_result is null) then
                          -- Retorna Dados Referencia
                          v_cod_pccs       := null;
                          v_cod_quadro     := null;
                          v_cod_carreira   := null;
                          v_cod_classe     := null;
                          v_cod_referencia := null;
                          v_cod_composicao := null;
                          v_cod_jornada    := null;

                          pac_carga_Generica_cliente.sp_Ret_dados_referencia (evf.cod_ins,
                                                                              evf.cod_grau_nivel,
                                                                              evf.des_jornada,
                                                                              v_cod_entidade,
                                                                              evf.cod_cargo,
                                                                              evf.cod_Referencia,
                                                                              v_cod_pccs,           -- out
                                                                              v_cod_quadro,         -- out
                                                                              v_cod_carreira,       -- out
                                                                              v_cod_classe,         -- out
                                                                              v_cod_referencia,     -- out
                                                                              v_cod_composicao,     -- out
                                                                              v_cod_jornada,        -- out
                                                                              v_cod_Erro,           -- out
                                                                              v_msg_erro);          -- out

                         if v_cod_Erro is not null then
                              SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_CLI', 'pac_carga_Generica_cliente.sp_Ret_dados_referencia - Referencia não encontrada', 'Referencia não encontrada');
                              v_result := 'Erro de validação';
                         end if;
                     end if;


                     --
                     if (v_result is null) then

                       v_lin_tb_evolucao_funcional := null;

                        begin
                           select *
                             into v_lin_tb_evolucao_funcional
                             from tb_evolucao_funcional
                            where cod_ins          = evf.cod_ins
                              and cod_ide_cli      = v_Cod_ide_cli
                              and cod_entidade     = v_cod_entidade
                              and num_matricula    = v_id_servidor
                              and cod_ide_rel_func = v_cod_ide_rel_func
                              and dat_ini_efeito =  v_dat_ini_even_func
                              and rownum <2;

                        exception
                            when others then
                                null;
                        end;


                        if (v_lin_tb_evolucao_funcional.cod_ins is not null) then -- registro ja existe em tb_evolucao_funcional, atualiza os demais dados

                              v_cod_tipo_ocorrencia := 'A';

                              if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                 null;
                                update tb_evolucao_funcional
                                  set cod_mot_evol_func       = evf.cod_moti_evol_even_func_int,
                                      cod_tipo_doc_assoc      = nvl(evf.cod_tipo_doc_ini_even_func_int, cod_tipo_doc_assoc),
                                      num_doc_assoc           = nvl(evf.num_doc_ini_even_func, num_doc_assoc),
                                      dat_pub                 = v_dat_ini_even_func,
                                      dat_fim_efeito          = v_dat_fim_even_func,
                                      cod_pccs                = v_cod_pccs,
                                      cod_jornada             = v_cod_jornada,
                                      cod_quadro              = v_cod_quadro,
                                      cod_classe              = v_cod_classe,
                                      cod_carreira            = v_Cod_carreira,
                                      cod_cargo               = evf.cod_cargo,
                                      cod_referencia          = v_Cod_referencia,
                                      cod_composicao          = v_Cod_composicao,
                                      cod_referencia_2        = v_Cod_referencia,
                                      cod_composicao_2        = v_Cod_composicao,
                                      dat_ult_atu             = sysdate,
                                      nom_usu_ult_atu         = user,
                                      nom_pro_ult_atu         = v_nom_rotina
                                  where cod_ins          = evf.cod_ins
                                    and cod_ide_cli      = v_Cod_ide_cli
                                    and cod_entidade     = v_cod_entidade
                                    and num_matricula    = v_id_servidor
                                    and cod_ide_rel_func = v_cod_ide_rel_func
                                    and dat_ini_efeito   = v_dat_ini_even_func
                                    and nom_pro_ult_atu  = v_nom_rotina;

                              end if;
                          else
                              v_cod_tipo_ocorrencia := 'I';

                              -- Verifica se tem período concomitante. Se não, não realiza ação
                              if pac_carga_generica_cliente.fnc_des_cliente = 'CAMPREV' then
                                select count(1)
                                  into v_qtd_concomitante
                                  from tb_evolucao_funcional
                                  where cod_ins          = evf.cod_ins
                                    and cod_ide_cli      = v_Cod_ide_cli
                                    and cod_entidade     = v_cod_entidade
                                    and num_matricula    = v_id_servidor
                                    and cod_ide_rel_func = v_cod_ide_rel_func
                                    and nvl(v_dat_fim_even_func,dat_ini_efeito) >= dat_ini_efeito
                                    and v_dat_ini_even_func <= nvl(dat_fim_efeito,v_dat_ini_even_func)
                                    and rownum <2;

                                if v_qtd_concomitante >0  then
                                   v_msg_erro := 'Erro - Período concomitante';
                                  raise erro;
                                end if;
                              end if;


                              if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                     null;
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
                                       COD_COMPOSICAO_2          -- 27
                                       )
                                  values
                                      (evf.cod_ins,                                        --  1 COD_INS
                                       v_cod_ide_cli,                                    --  2 COD_IDE_CLI
                                       v_cod_entidade,                                   --  3 COD_ENTIDADE
                                       v_cod_pccs,                                         --  4 COD_PCCS
                                       evf.cod_cargo,                                      --  5 COD_CARGO
                                       v_id_servidor,                                    --  6 NUM_MATRICULA
                                       v_cod_ide_rel_func,                              --  7 COD_IDE_REL_FUNC
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
                              end if;

                          end if;

                          -- atualiza a ultima evolucao funcional
                          if pac_carga_Generica_cliente.fnc_Des_cliente = 'IPREV' then
                            update tb_evolucao_funcional
                             set dat_fim_efeito = v_dat_ini_even_func-1
                            where cod_ins = evf.cod_ins
                              and cod_Entidade = v_cod_entidade
                              and cod_ide_cli =v_cod_ide_cli
                              and num_matricula = v_id_Servidor
                              and cod_ide_rel_func = v_cod_ide_Rel_func
                              and dat_ini_efeito < trunc( v_dat_ini_even_func)
                              and nvl(dat_fim_efeito,v_dat_ini_even_func+1) >  v_dat_ini_even_func
                              and nom_pro_ult_atu = v_nom_rotina;
                          end if;

                          /*a_log.delete;
                          SP_INCLUI_LOG(a_log, 'COD_INS',                v_lin_tb_evolucao_funcional.cod_ins,                evf.cod_ins);
                          SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',            v_lin_tb_evolucao_funcional.cod_ide_cli,            v_cod_ide_cli);
                          SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',           v_lin_tb_evolucao_funcional.cod_entidade,           v_cod_entidade);
                          SP_INCLUI_LOG(a_log, 'COD_PCCS',               v_lin_tb_evolucao_funcional.cod_pccs,               v_cod_pccs);
                          SP_INCLUI_LOG(a_log, 'COD_CARGO',              v_lin_tb_evolucao_funcional.cod_cargo,              evf.cod_cargo);
                          SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',          v_lin_tb_evolucao_funcional.num_matricula,          v_id_servidor);
                          SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',       v_lin_tb_evolucao_funcional.cod_ide_rel_func,       v_Cod_ide_rel_func);
                          SP_INCLUI_LOG(a_log, 'COD_REFERENCIA',         v_lin_tb_evolucao_funcional.cod_referencia,         v_cod_referencia);
                          SP_INCLUI_LOG(a_log, 'FLG_STATUS',             v_lin_tb_evolucao_funcional.flg_status,             nvl(v_lin_tb_evolucao_funcional.flg_status, 'V'));
                          SP_INCLUI_LOG(a_log, 'COD_MOT_EVOL_FUNC',      v_lin_tb_evolucao_funcional.cod_mot_evol_func,      evf.cod_moti_evol_even_func_int);
                          SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC',     v_lin_tb_evolucao_funcional.cod_tipo_doc_assoc,     nvl(evf.cod_tipo_doc_ini_even_func_int, v_lin_tb_evolucao_funcional.cod_tipo_doc_assoc));
                          SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',          v_lin_tb_evolucao_funcional.num_doc_assoc,          nvl(evf.num_doc_ini_even_func, v_lin_tb_evolucao_funcional.num_doc_assoc));
                          SP_INCLUI_LOG(a_log, 'COD_JORNADA',            v_lin_tb_evolucao_funcional.cod_jornada,            v_cod_jornada);
                          SP_INCLUI_LOG(a_log, 'COD_QUADRO',             v_lin_tb_evolucao_funcional.cod_quadro,             nvl(v_lin_tb_evolucao_funcional.cod_quadro, v_cod_quadro));
                          SP_INCLUI_LOG(a_log, 'COD_CARREIRA',           v_lin_tb_evolucao_funcional.cod_carreira,           nvl(v_lin_tb_evolucao_funcional.cod_carreira, v_cod_carreira));
                          SP_INCLUI_LOG(a_log, 'COD_CLASSE',             v_lin_tb_evolucao_funcional.cod_classe,             nvl(v_lin_tb_evolucao_funcional.cod_classe, v_cod_classe));
                          SP_INCLUI_LOG(a_log, 'COD_COMPOSICAO',         v_lin_tb_evolucao_funcional.cod_composicao,         nvl( v_lin_tb_evolucao_funcional.cod_composicao, v_cod_composicao));
                          SP_INCLUI_LOG(a_log, 'FLG_INI_VINCULO',        v_lin_tb_evolucao_funcional.flg_ini_vinculo,        nvl(v_lin_tb_evolucao_funcional.flg_ini_vinculo, 'I'));
                          SP_INCLUI_LOG(a_log, 'DAT_INI_EFEITO',         to_char(v_lin_tb_evolucao_funcional.dat_ini_efeito, 'dd/mm/yyyy hh24:mi'), v_dat_ini_even_func);
                          SP_INCLUI_LOG(a_log, 'DAT_PUB',                to_char(v_lin_tb_evolucao_funcional.dat_pub, 'dd/mm/yyyy hh24:mi'),       v_dat_ini_even_func);
                          SP_INCLUI_LOG(a_log, 'DAT_FIM_EFEITO',         to_char(v_lin_tb_evolucao_funcional.dat_fim_efeito,'dd/mm/yyyy hh24:mi'),  v_dat_fim_even_func);

                          SP_GRAVA_LOG(i_id_header, evf.id_processo, evf.num_linha_header, v_cod_tipo_ocorrencia,
                                       v_cod_situ_ocorrencia, 'NOVAPREV', 'TB_EVOLUCAO_FUNCIONAL', v_nom_rotina, a_log);
                    */
                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '3', null, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      else

                          SP_GRAVA_ERRO(i_id_header, evf.id_processo, evf.num_linha_header, v_nom_rotina, a_validar);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      end if;

                  EXCEPTION
                      WHEN ERRO THEN
                         rollback to sp1;

                          SP_GRAVA_ERRO(i_id_header, evf.id_processo, evf.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;
                      WHEN OTHERS THEN

                          v_msg_erro := substr(sqlerrm, 1, 4000);

                          rollback to sp1;

                          SP_GRAVA_ERRO(i_id_header, evf.id_processo, evf.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, evf.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                  END;
               end loop;


                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);
            commit;
        else
            SP_GRAVA_ERRO_DIRETO(i_id_header, 9, 0, v_nom_rotina, 'não foi possivel recuperar dados do processo');
            commit;
        end if;

       commit;
    EXCEPTION

        WHEN erro_grava_status THEN
                      dbms_output.put_line('erro_grava_status');

            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_EVF;

    -----------------------------------------------------------------------------------------------

       FUNCTION FNC_VALIDA_EVF (i_evf       in     r_evf,
                             o_a_validar in out t_validar) return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_ini_even_func             date;
        v_dat_fim_even_func             date;
        v_cod_nivel                     tb_referencia.cod_nivel%type;
        v_cod_grau                      tb_referencia.cod_grau%type;

    BEGIN

        o_a_validar.delete;
        v_dat_ini_even_func := FNC_VALIDA_DATA(i_evf.dat_ini_even_func,'RRRRMMDD');
        v_dat_fim_even_func := FNC_VALIDA_DATA(i_evf.dat_fim_even_func,'RRRRMMDD');

        if (v_dat_fim_even_func < v_dat_ini_even_func) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_EVEN_FUNC', 'Data de fim do evento funcional ('||
                                                                            to_char(v_dat_fim_even_func, 'dd/mm/yyyy')||
                                                                            ') é anterior à correspondente data de início ('||
                                                                            to_char(v_dat_ini_even_func, 'dd/mm/yyyy')||')');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_EVF;

    -----------------------------------------------------------------------------------------------

   /* PROCEDURE SP_CARREGA_EFC (i_id_header in number) IS

        v_result                     varchar2(2000);
        v_cur_id                     tb_carga_gen_efc.id%type;
        v_flg_acao_postergada        tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia        tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia        tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar                    t_validar;
        a_log                        t_log;
        v_nom_rotina                 varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_EFC';
        v_nom_tabela                 varchar2(100) := 'TB_CARGA_GEN_EFC';
        v_tb_evolu_ccomi_gfuncional  tb_evolu_ccomi_gfuncional%rowtype;
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
        v_cod_jornada                tb_jornada.cod_jornada%type;
        v_cod_regime_retrib          varchar2(4000);
        v_cod_escala_venc            varchar2(4000);
        v_id_log_erro                number;
        v_msg_erro                   varchar2(4000);
        v_cod_erro                   number;

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for efc in (select a.cod_ins,
                                   a.id_header                        id_header,
                                   trim(a.cod_entidade)               cod_entidade,
                                   trim(a.id_servidor)                id_servidor,
                                   trim(a.id_vinculo)                 id_vinculo,
                                   trim(a.cod_cargo)                  cod_cargo,
                                   trim(a.cod_moti_evol_even_func)    cod_moti_evol_even_func,
                                   fnc_codigo_ext(a.cod_ins, 10134, trim(a.cod_moti_evol_even_func), null, 'COD_PAR') cod_moti_evol_even_func_int,
                                   trim(a.dat_ini_even_func)          dat_ini_even_func,
                                   trim(a.cod_tipo_doc_ini_even_func) cod_tipo_doc_ini_even_func,
                                   fnc_codigo_ext(a.cod_ins, 2019, trim(a.cod_tipo_doc_ini_even_func), null, 'COD_PAR') cod_tipo_doc_ini_even_func_int,
                                   trim(a.num_doc_ini_even_func)      num_doc_ini_even_func,
                                   trim(a.dat_fim_even_func)          dat_fim_even_func,
                                   trim(a.cod_tipo_doc_fim_even_func) cod_tipo_doc_fim_even_func,
                                   fnc_codigo_ext(a.cod_ins, 2072, trim(a.cod_tipo_doc_fim_even_func), null, 'COD_PAR') cod_tipo_doc_fim_even_func_int,
                                   trim(a.num_doc_fim_even_func)      num_doc_fim_even_func,
                                   trim(a.cod_referencia)             cod_referencia,
                                   trim(a.cod_grau_nivel)             cod_grau_nivel,
                                   trim(a.des_jornada)                des_jornada,
                                   trim(a.des_observacao)             des_observacao,
                                   a.id,
                                   a.num_linha_header,
                                   a.id_processo,
                                   d.cod_ide_cli
                            from tb_carga_gen_efc a
                                left outer join tb_carga_gen_ident_ext d
                                    on      a.cod_ins      = d.cod_ins
                                        and a.id_servidor  = d.cod_ide_cli_ext
                                        and a.cod_entidade = d.cod_entidade
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id              := efc.id;

                    BEGIN

                        savepoint sp1;


                        if (efc.dat_ini_even_func is not null and efc.dat_ini_even_func = '00000000') then
                            efc.dat_ini_even_func := null;
                        end if;

                        if (efc.dat_fim_even_func is not null and efc.dat_fim_even_func = '00000000') then
                            efc.dat_fim_even_func := null;
                        end if;

                        a_validar.delete;
                         /*PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_processo      => efc.id_processo,
                                                                                i_id_header        => efc.id_header,
                                                                                i_num_linha_header => efc.num_linha_header,
                                                                                i_o_validar        => a_validar,
                                                                                o_cod_erro         => v_cod_erro,
                                                                                o_des_erro         => v_msg_erro);

                        --
                        if v_cod_erro is not null then
                          raise_application_error(-20000,'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro);
                        end if;
                        --
                        v_result := fnc_valida_efc(efc, a_validar);
                        -----
                        if (v_result is null) then
                            if (efc.cod_ide_cli is null) then
                                SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
                                v_result := 'Erro de validação';
                            end if;
                        end if;

                        if (v_result is null) then

                            v_cod_pccs       := null;
                            v_cod_quadro     := null;
                            v_cod_carreira   := null;
                            v_cod_classe     := null;
                            v_des_sigla_pccs := null;

                            begin
                                select a.cod_pccs, a.cod_quadro, a.cod_carreira, a.cod_classe, b.des_sigla
                                into   v_cod_pccs, v_cod_quadro, v_cod_carreira, v_cod_classe, v_des_sigla_pccs
                                from tb_cargo a,
                                     tb_pccs  b
                                where a.cod_ins      = efc.cod_ins
                                  and a.cod_entidade = efc.cod_entidade
                                  and a.cod_cargo    = efc.cod_cargo
                                  and a.dat_ini_vig  <= fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD')
                                  and (   a.dat_fim_vig  is null
                                       or a.dat_fim_vig >= fnc_valida_data(efc.dat_fim_even_func, 'RRRRMMDD'))
                                  and b.dat_ini_vig  <= fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD')
                                  and (   b.dat_fim_vig  is null
                                       or b.dat_fim_vig >= fnc_valida_data(efc.dat_fim_even_func, 'RRRRMMDD'))
                                  and b.cod_ins      = a.cod_ins
                                  and b.cod_entidade = a.cod_entidade
                                  and b.cod_pccs     = a.cod_pccs
                                  and rownum         <= 1;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_cod_jornada       := null;
                            v_cod_nivel         := null;
                            v_cod_grau          := null;
                            v_cod_ref_pad_venc  := null;
                            v_cod_referencia    := null;
                            v_cod_composicao    := null;
                            v_cod_regime_retrib := null;
                            v_cod_escala_venc   := null;

                            v_cod_regime_retrib := fnc_busca_dominios_padrao (efc.cod_ins, efc.cod_entidade, v_cod_pccs, efc.cod_cargo, 'RR');
                            if (substr(v_cod_regime_retrib, 1, 5) = 'Erro:') then
                                SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_REGIME_RETRIB', substr(v_cod_regime_retrib, 6), 'Codigo do Regime');
                                v_result := 'Erro de validação';
                            end if;

                            v_cod_escala_venc := fnc_busca_dominios_padrao (efc.cod_ins, efc.cod_entidade, v_cod_pccs, efc.cod_cargo, 'EV');
                            if (substr(v_cod_escala_venc, 1, 5) = 'Erro:') then
                                SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_ESCALA_VENC', substr(v_cod_escala_venc, 6), 'Codigo da escala de vencimento');
                                v_result := 'Erro de validação';
                            end if;

                            v_cod_jornada := fnc_busca_cod_jornada(efc.cod_ins, efc.des_jornada);
                            v_cod_nivel   := fnc_busca_cod_nivel(efc.cod_grau_nivel);
                            v_cod_grau    := fnc_busca_cod_grau(efc.cod_grau_nivel);

                            v_cod_ref_pad_venc := substr(efc.cod_entidade   ||'-'||efc.cod_cargo    ||'-'||v_des_sigla_pccs||'-'||
                                                         v_cod_jornada      ||'-'||v_cod_nivel      ||'-'||v_cod_grau||'-'||
                                                         v_cod_regime_retrib||'-'||v_cod_escala_venc||'-'||'LEG', 1, 40);

                            begin
                                select cod_referencia
                                into v_cod_referencia
                                from tb_referencia
                                where cod_ins          = efc.cod_ins
                                  and cod_entidade     = efc.cod_entidade
                                  and cod_pccs         = v_cod_pccs
                                  and cod_quadro       = v_cod_quadro
                                  and cod_carreira     = v_cod_carreira
                                  and cod_classe       = v_cod_classe
                                  and cod_ref_pad_venc = v_cod_ref_pad_venc;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_REFERENCIA', substr('não foi possivel localizar o codigo da Referencia para'||
                                                                                                    ' COD_INS = '||efc.cod_ins||','||
                                                                                                    ' COD_ENTIDADE = '||efc.cod_entidade||','||
                                                                                                    ' COD_PCCS = '||v_cod_pccs||','||
                                                                                                    ' COD_QUADRO = '||v_cod_quadro||','||
                                                                                                    ' COD_CARREIRA = '||v_cod_carreira||','||
                                                                                                    ' COD_CLASSE = '||v_cod_classe||','||
                                                                                                    ' COD_REF_PAD_VENC = '||v_cod_ref_pad_venc, 1, 2000),
                                                                                    'Codigo da Referencia');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_REFERENCIA', substr('Erro ao localizar o codigo da Referencia para'||
                                                                                                    ' COD_INS = '||efc.cod_ins||','||
                                                                                                    ' COD_ENTIDADE = '||efc.cod_entidade||','||
                                                                                                    ' COD_PCCS = '||v_cod_pccs||','||
                                                                                                    ' COD_QUADRO = '||v_cod_quadro||','||
                                                                                                    ' COD_CARREIRA = '||v_cod_carreira||','||
                                                                                                    ' COD_CLASSE = '||v_cod_classe||','||
                                                                                                    ' COD_REF_PAD_VENC = '||v_cod_ref_pad_venc||': '||sqlerrm, 1, 2000),
                                                                                    'Codigo da Referencia');
                                    v_result := 'Erro de validação';
                            end;

                            begin
                                select cod_composicao
                                into v_cod_composicao
                                from tb_composicao
                                where cod_ins        = efc.cod_ins
                                  and cod_entidade   = efc.cod_entidade
                                  and cod_pccs       = v_cod_pccs
                                  and cod_quadro     = v_cod_quadro
                                  and cod_carreira   = v_cod_carreira
                                  and cod_classe     = v_cod_classe
                                  and cod_referencia = v_cod_referencia
                                  and cod_cargo      = efc.cod_cargo
                                  and rownum        <= 1;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_COMPOSICAO', substr('não foi possivel localizar o codigo da Composição para'||
                                                                                                    ' COD_INS = '||efc.cod_ins||','||
                                                                                                    ' COD_ENTIDADE = '||efc.cod_entidade||','||
                                                                                                    ' COD_PCCS = '||v_cod_pccs||','||
                                                                                                    ' COD_QUADRO = '||v_cod_quadro||','||
                                                                                                    ' COD_CARREIRA = '||v_cod_carreira||','||
                                                                                                    ' COD_CLASSE = '||v_cod_classe||','||
                                                                                                    ' COD_CARGO = '||efc.cod_cargo||','||
                                                                                                    ' COD_REFERENCIA = '||v_cod_referencia, 1, 2000),
                                                                                 'Codigo da Composição');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_COMPOSICAO', substr('Erro ao localizar o codigo da Composição para'||
                                                                                                    ' COD_INS = '||efc.cod_ins||','||
                                                                                                    ' COD_ENTIDADE = '||efc.cod_entidade||','||
                                                                                                    ' COD_PCCS = '||v_cod_pccs||','||
                                                                                                    ' COD_QUADRO = '||v_cod_quadro||','||
                                                                                                    ' COD_CARREIRA = '||v_cod_carreira||','||
                                                                                                    ' COD_CLASSE = '||v_cod_classe||','||
                                                                                                    ' COD_CARGO = '||efc.cod_cargo||','||
                                                                                                    ' COD_REFERENCIA = '||v_cod_referencia||': '||sqlerrm, 1, 2000),
                                                                                    'Codigo da Composição');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            begin
                                select *
                                into v_tb_evolu_ccomi_gfuncional
                                from tb_evolu_ccomi_gfuncional
                                where cod_ins          = efc.cod_ins
                                  and cod_ide_cli      = efc.cod_ide_cli
                                  and cod_entidade     = efc.cod_entidade
                                  and cod_pccs         = v_cod_pccs
                                  and cod_cargo_comp   = efc.cod_cargo
                                  and cod_cargo_rel    = efc.cod_cargo
                                  and num_matricula    = efc.id_servidor
                                  and cod_ide_rel_func = efc.id_servidor||lpad(efc.id_vinculo,2,'0')
                                  and cod_quadro       = v_cod_quadro
                                  and cod_carreira     = v_cod_carreira
                                  and cod_classe       = v_cod_classe
                                  and cod_referencia   = v_cod_referencia
                                  and cod_composicao   = v_cod_composicao
                                  and dat_ini_efeito   = fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD');

                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_evolu_ccomi_gfuncional.cod_ins is null) then

                                begin
                                    select *
                                    into v_tb_evolu_ccomi_gfuncional
                                    from tb_evolu_ccomi_gfuncional
                                    where cod_ins          = efc.cod_ins
                                      and cod_ide_cli      = efc.cod_ide_cli
                                      and cod_entidade     = efc.cod_entidade
                                      and cod_pccs         = v_cod_pccs
                                      and cod_cargo_comp   = efc.cod_cargo
                                      and cod_cargo_rel    = efc.cod_cargo
                                      and num_matricula    = efc.id_servidor
                                      and cod_ide_rel_func = efc.id_servidor||lpad(efc.cod_entidade,2,'0')||lpad(efc.id_vinculo,2,'0')
                                      and cod_quadro       = v_cod_quadro
                                      and cod_carreira     = v_cod_carreira
                                      and cod_classe       = v_cod_classe
                                      and cod_referencia   = v_cod_referencia
                                      and cod_composicao   = v_cod_composicao
                                      and dat_ini_efeito   = fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD');

                                exception
                                    when others then
                                        null;
                                end;

                            end if;

                            if (v_tb_evolu_ccomi_gfuncional.cod_ins is not null) then -- registro ja existe em tb_evolu_ccomi_gfuncional, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_evolu_ccomi_gfuncional
                                    set cod_mot_evol_func      = efc.cod_moti_evol_even_func_int,
                                        cod_tipo_doc_assoc     = nvl(efc.cod_tipo_doc_ini_even_func_int, cod_tipo_doc_assoc),
                                        num_doc_assoc          = nvl(efc.num_doc_ini_even_func, num_doc_assoc),
                                        dat_pub                = fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD'),
                                        dat_fim_efeito         = fnc_valida_data(efc.dat_fim_even_func, 'RRRRMMDD'),
                                        cod_jornada            = v_cod_jornada,
                                        desc_perg_cargo_atual  = nvl(substr(efc.des_observacao, 1, 1000), desc_perg_cargo_atual),
                                  --ALE      cod_tipo_doc_assoc_fim = nvl(efc.cod_tipo_doc_fim_even_func_int, cod_tipo_doc_assoc_fim),
                                --ALE        num_doc_assoc_fim      = nvl(efc.num_doc_fim_even_func, num_doc_assoc_fim),
                                        dat_ult_atu            = sysdate,
                                        nom_usu_ult_atu        = user,
                                        nom_pro_ult_atu        = v_nom_rotina
                                    where cod_ins          = v_tb_evolu_ccomi_gfuncional.cod_ins
                                      and cod_ide_cli      = v_tb_evolu_ccomi_gfuncional.cod_ide_cli
                                      and cod_entidade     = v_tb_evolu_ccomi_gfuncional.cod_entidade
                                      and cod_pccs         = v_tb_evolu_ccomi_gfuncional.cod_pccs
                                      and cod_cargo_comp   = v_tb_evolu_ccomi_gfuncional.cod_cargo_comp
                                      and cod_cargo_rel    = v_tb_evolu_ccomi_gfuncional.cod_cargo_rel
                                      and num_matricula    = v_tb_evolu_ccomi_gfuncional.num_matricula
                                      and cod_ide_rel_func = v_tb_evolu_ccomi_gfuncional.cod_ide_rel_func
                                      and cod_quadro       = v_tb_evolu_ccomi_gfuncional.cod_quadro
                                      and cod_carreira     = v_tb_evolu_ccomi_gfuncional.cod_carreira
                                      and cod_classe       = v_tb_evolu_ccomi_gfuncional.cod_classe
                                      and cod_referencia   = v_tb_evolu_ccomi_gfuncional.cod_referencia
                                      and cod_composicao   = v_tb_evolu_ccomi_gfuncional.cod_composicao
                                      and dat_ini_efeito   = v_tb_evolu_ccomi_gfuncional.dat_ini_efeito;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_evolu_ccomi_gfuncional
                                        (COD_INS,                --  1
                                         COD_IDE_CLI,            --  2
                                         COD_ENTIDADE,           --  3
                                         COD_PCCS,               --  4
                                         COD_CARGO_COMP,         --  5
                                         COD_CARGO_REL,          --  6
                                         NUM_MATRICULA,          --  7
                                         COD_IDE_REL_FUNC,       --  8
                                         COD_QUADRO,             --  9
                                         COD_CARREIRA,           -- 10
                                         COD_CLASSE,             -- 11
                                         COD_REFERENCIA,         -- 12
                                         COD_COMPOSICAO,         -- 13
                                         COD_MOT_EVOL_FUNC,      -- 14
                                         COD_TIPO_DOC_ASSOC,     -- 15
                                         NUM_DOC_ASSOC,          -- 16
                                         DAT_PUB,                -- 17
                                         DAT_INI_EFEITO,         -- 18
                                         DAT_FIM_EFEITO,         -- 19
                                         DAT_ING,                -- 20
                                         DAT_ULT_ATU,            -- 21
                                         NOM_USU_ULT_ATU,        -- 22
                                         NOM_PRO_ULT_ATU,        -- 23
                                         COD_JORNADA,            -- 24
                                         DESC_PERG_CARGO_ATUAL  -- 25
                                         --ALE COD_TIPO_DOC_ASSOC_FIM -- 26
                                         --ALE NUM_DOC_ASSOC_FIM
                                         )      -- 27
                                    values
                                        (efc.cod_ins,                                        --  1 COD_INS
                                         efc.cod_ide_cli,                                    --  2 COD_IDE_CLI
                                         efc.cod_entidade,                                   --  3 COD_ENTIDADE
                                         v_cod_pccs,                                         --  4 COD_PCCS
                                         efc.cod_cargo,                                      --  5 COD_CARGO_COMP
                                         efc.cod_cargo,                                      --  6 COD_CARGO_REL
                                         efc.id_servidor,                                    --  7 NUM_MATRICULA
                                         efc.id_servidor||lpad(efc.id_vinculo,2,'0'),        --  8 COD_IDE_REL_FUNC
                                         v_cod_quadro,                                       --  9 COD_QUADRO
                                         v_cod_carreira,                                     -- 10 COD_CARREIRA
                                         v_cod_classe,                                       -- 11 COD_CLASSE
                                         v_cod_referencia,                                   -- 12 COD_REFERENCIA
                                         v_cod_composicao,                                   -- 13 COD_COMPOSICAO
                                         efc.cod_moti_evol_even_func_int,                    -- 14 COD_MOT_EVOL_FUNC
                                         efc.cod_tipo_doc_ini_even_func_int,                 -- 15 COD_TIPO_DOC_ASSOC
                                         efc.num_doc_ini_even_func,                          -- 16 NUM_DOC_ASSOC
                                         fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD'), -- 17 DAT_PUB
                                         fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD'), -- 18 DAT_INI_EFEITO
                                         fnc_valida_data(efc.dat_fim_even_func, 'RRRRMMDD'), -- 19 DAT_FIM_EFEITO
                                         sysdate,                                            -- 20 DAT_ING
                                         sysdate,                                            -- 21 DAT_ULT_ATU
                                         user,                                               -- 22 NOM_USU_ULT_ATU
                                         v_nom_rotina,                                       -- 23 NOM_PRO_ULT_ATU
                                         v_cod_jornada,                                      -- 24 COD_JORNADA
                                         substr(efc.des_observacao, 1, 1000)               -- 25 DESC_PERG_CARGO_ATUAL
                                        -- ALe efc.cod_tipo_doc_fim_even_func_int                 -- 26 COD_TIPO_DOC_ASSOC_FIM
                                         -- ALE efc.num_doc_fim_even_func
                                         );                         -- 27 NUM_DOC_ASSOC_FIM
                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',                v_tb_evolu_ccomi_gfuncional.cod_ins,                efc.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',            v_tb_evolu_ccomi_gfuncional.cod_ide_cli,            efc.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',           v_tb_evolu_ccomi_gfuncional.cod_entidade,           efc.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',               v_tb_evolu_ccomi_gfuncional.cod_pccs,               v_cod_pccs);
                            SP_INCLUI_LOG(a_log, 'COD_CARGO_COMP',         v_tb_evolu_ccomi_gfuncional.cod_cargo_comp,         efc.cod_cargo);
                            SP_INCLUI_LOG(a_log, 'COD_CARGO_REL',          v_tb_evolu_ccomi_gfuncional.cod_cargo_rel,          efc.cod_cargo);
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',          v_tb_evolu_ccomi_gfuncional.num_matricula,          efc.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',       v_tb_evolu_ccomi_gfuncional.cod_ide_rel_func,       nvl(v_tb_evolu_ccomi_gfuncional.cod_ide_rel_func, efc.id_servidor||lpad(efc.id_vinculo,2,'0')));
                            SP_INCLUI_LOG(a_log, 'COD_QUADRO',             v_tb_evolu_ccomi_gfuncional.cod_quadro,             v_cod_quadro);
                            SP_INCLUI_LOG(a_log, 'COD_CARREIRA',           v_tb_evolu_ccomi_gfuncional.cod_carreira,           v_cod_carreira);
                            SP_INCLUI_LOG(a_log, 'COD_CLASSE',             v_tb_evolu_ccomi_gfuncional.cod_classe,             v_cod_classe);
                            SP_INCLUI_LOG(a_log, 'COD_REFERENCIA',         v_tb_evolu_ccomi_gfuncional.cod_referencia,         v_cod_referencia);
                            SP_INCLUI_LOG(a_log, 'COD_COMPOSICAO',         v_tb_evolu_ccomi_gfuncional.cod_composicao,         v_cod_composicao);
                            SP_INCLUI_LOG(a_log, 'COD_MOT_EVOL_FUNC',      v_tb_evolu_ccomi_gfuncional.cod_mot_evol_func,      efc.cod_moti_evol_even_func_int);
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC',     v_tb_evolu_ccomi_gfuncional.cod_tipo_doc_assoc,     nvl(efc.cod_tipo_doc_ini_even_func_int, v_tb_evolu_ccomi_gfuncional.cod_tipo_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',          v_tb_evolu_ccomi_gfuncional.num_doc_assoc,          nvl(efc.num_doc_ini_even_func, v_tb_evolu_ccomi_gfuncional.num_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'COD_JORNADA',            v_tb_evolu_ccomi_gfuncional.cod_jornada,            v_cod_jornada);
                            SP_INCLUI_LOG(a_log, 'DESC_PERG_CARGO_ATUAL',  v_tb_evolu_ccomi_gfuncional.desc_perg_cargo_atual,  nvl(substr(efc.des_observacao, 1, 1000), v_tb_evolu_ccomi_gfuncional.desc_perg_cargo_atual));
                           --ALE  SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC_FIM', v_tb_evolu_ccomi_gfuncional.cod_tipo_doc_assoc_fim, nvl(efc.cod_tipo_doc_fim_even_func_int, v_tb_evolu_ccomi_gfuncional.cod_tipo_doc_assoc_fim));
                         --   SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC_FIM',      v_tb_evolu_ccomi_gfuncional.-- ALe num_doc_assoc_fim,      nvl(efc.num_doc_fim_even_func, v_tb_evolu_ccomi_gfuncional.num_doc_assoc_fim));
                            SP_INCLUI_LOG(a_log, 'DAT_INI_EFEITO',         to_char(v_tb_evolu_ccomi_gfuncional.dat_ini_efeito, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_PUB',                to_char(v_tb_evolu_ccomi_gfuncional.dat_pub, 'dd/mm/yyyy hh24:mi'),        to_char(fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_EFEITO',         to_char(v_tb_evolu_ccomi_gfuncional.dat_fim_efeito, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(efc.dat_fim_even_func, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));

                            SP_GRAVA_LOG(i_id_header, efc.id_processo, efc.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_EVOLU_CCOMI_GFUNCIONAL', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, efc.id_processo, efc.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, efc.id_processo, efc.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_EFC;*/

        PROCEDURE SP_CARREGA_EFC (i_id_header in number) IS

        v_result                     varchar2(2000);
        v_cur_id                     tb_carga_gen_evf.id%type;
        v_flg_acao_postergada        tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia        tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia        tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar                    t_validar;
        a_log                        t_log;
        v_nom_rotina                 varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_EFC';
        v_nom_tabela                 varchar2(100) := 'TB_CARGA_GEN_EFC';
        v_lin_tb_evolu_ccomi_gfunciona  tb_evolu_ccomi_gfuncional%rowtype;
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
    BEGIN


      if pac_Carga_Generica_cliente.fnc_des_cliente = 'CAMPREV' then
          -------------------------------- PARA CAMPREV Insere data fim da evlução de forma dinamica (Caso o arquivo venha sem data fim)
          begin
          select 'S' into v_existe_dat_fim from dual where exists (select '1'
                                                                     from tb_carga_gen_efc efc
                                                                    where id_header = i_id_header
                                                                      and efc.dat_fim_even_func is not null);
          exception
          when no_data_found then
            v_existe_dat_fim := 'N';
          end;

          if v_existe_dat_fim = 'N' then
            for evf in (select a.dat_ini_even_func,
                               lead(trim(a.dat_ini_even_func),1) over (partition by cod_entidade,id_servidor,id_vinculo order by  dat_ini_even_func) as dat_ini_even_func_prox,
                               rowid as linha
                        from tb_carga_gen_efc a
                        where a.id_header = i_id_header)
            loop
              if evf.dat_ini_even_func = evf.dat_ini_even_func_prox then

                 SP_GRAVA_AVISO(i_id_header,209, 0, 'MAN','Registro com data inicio Duplicado - Não processado');

                 update tb_carga_gen_efc
                 set cod_status_processamento = '3'
                where rowid = evf.linha;
              else

                v_dat_fim := to_date(evf.dat_ini_even_func_prox,'yyyymmdd');
                --
                v_dat_fim := v_dat_fim - 1;

                update tb_carga_gen_efc
                   set dat_fim_even_func = to_char(v_dat_fim,'yyyymmdd')
                  where rowid = evf.linha;
              end if;
            end loop;

          end if;
          --
          commit;
        end if;
        --
        ----------------------------------

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then
            loop
                v_result := null;
                v_cur_id := null;
                v_cod_erro := null;

              for efc in (select a.cod_ins,
                                 a.id_header,
                                 trim(a.cod_entidade)               cod_entidade,
                                 trim(a.id_servidor)                id_servidor,
                                 trim(a.id_vinculo)                 id_vinculo,
                                 trim(a.cod_cargo)                  cod_cargo,
                                 trim(to_number(a.cod_moti_evol_even_func))    cod_moti_evol_even_func,
                                 fnc_codigo_ext(a.cod_ins, 10134, trim(to_number(a.cod_moti_evol_even_func)), null, 'COD_PAR') cod_moti_evol_even_func_int,
                                 trim(a.dat_ini_even_func)          dat_ini_even_func,
                                 trim(to_number(a.cod_tipo_doc_ini_even_func)) cod_tipo_doc_ini_even_func,
                                 fnc_codigo_ext(a.cod_ins, 2019, trim(to_number(a.cod_tipo_doc_ini_even_func)), null, 'COD_PAR') cod_tipo_doc_ini_even_func_int,
                                 trim(a.num_doc_ini_even_func)      num_doc_ini_even_func,
                                 trim(a.dat_fim_even_func)          dat_fim_even_func,
                                 fnc_codigo_ext(a.cod_ins, 2072, trim(to_number(a.cod_tipo_doc_fim_even_func)), null, 'COD_PAR') cod_tipo_doc_fim_even_func_int,
                                 trim(to_number(a.cod_tipo_doc_fim_even_func)) cod_tipo_doc_fim_even_func,
                                 trim(a.num_doc_fim_even_func)      num_doc_fim_even_func,
                                 trim(a.cod_referencia)             cod_referencia,
                                 trim(a.cod_grau_nivel)             cod_grau_nivel,
                                 trim(a.des_jornada)                des_jornada,
                                 trim(a.des_observacao)             des_observacao,
                                -- trim(a.num_faixa_nivel)            num_faixa_nivel,
                                 a.id,
                                 a.num_linha_header,
                                 a.id_processo
                          from tb_carga_gen_efc a
                          where a.id_header = i_id_header
                            and a.cod_status_processamento = '1'
                            and rownum <= v_vlr_iteracao ) loop

                  v_result              := null;
                  v_cur_id              := efc.id;

                  BEGIN

                      savepoint sp1;

                      -- separando entidade de id_header
                      v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(efc.id_servidor);
                      v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(efc.cod_entidade,efc.id_servidor);


                      -- Pega cod_ide_cli da ident_ext_servidor
                       v_cod_ide_cli := fnc_ret_cod_ide_cli( efc.cod_ins, v_id_Servidor);

                       if FNC_VALIDA_PESSOA_FISICA(efc.cod_ins, v_cod_ide_cli) is not null then
                         raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                      end if;
                      --
                      --
                      v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,efc.id_vinculo);
                      --
                      if (efc.dat_ini_even_func is not null and efc.dat_ini_even_func = '00000000') then
                          efc.dat_ini_even_func := null;
                      end if;
                      --
                      if (efc.dat_fim_even_func is not null and efc.dat_fim_even_func = '00000000') then
                          efc.dat_fim_even_func := null;
                      end if;
                      --
                      v_dat_ini_even_func := fnc_valida_data(efc.dat_ini_even_func, 'RRRRMMDD');
                      v_dat_fim_even_func := fnc_valida_data(efc.dat_fim_even_func, 'RRRRMMDD');
                      --
                      if v_dat_ini_even_func is null then
                        -- pega data inicio da relacao funcional
                        select min(rf.dat_ini_exerc)
                          into v_dat_ini_even_func
                          from tb_relacao_funcional rf
                         where rf.cod_ins = efc.cod_ins
                           and rf.cod_entidade = v_cod_entidade
                           and rf.cod_ide_cli = v_cod_ide_cli
                           and rf.num_matricula = v_id_Servidor
                           and rf.cod_ide_rel_func =  v_cod_ide_Rel_func;
                      end if;

                         -- determina data fim
                      if pac_carga_generica_cliente.fnc_des_cliente = 'IPREV' then
                        v_dat_fim_even_func := null;

                        select min(dat_ini_efeito)
                          into v_dat_fim_even_func
                          from tb_evolu_ccomi_gfuncional
                          where cod_ins = efc.cod_ins
                            and cod_Entidade = v_cod_entidade
                            and cod_ide_cli =v_cod_ide_cli
                            and num_matricula = v_id_Servidor
                            and cod_ide_rel_func = v_cod_ide_Rel_func
                            and dat_ini_efeito >= trunc( v_dat_ini_even_func+1);

                          if  v_dat_fim_even_func is not null then
                             v_dat_fim_even_func:= v_dat_fim_even_func-1;
                           end if;

                      end if;
                      --
                      a_validar.delete;
                      --
                      PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                              i_num_linha        => efc.num_linha_header,
                                                                              o_result           => v_result,
                                                                              o_cod_erro         => v_cod_erro,
                                                                              o_des_erro         => v_msg_erro);


                      if v_cod_erro is not null then
                        v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                      end if;
                      --
                      if v_result is null then
                        v_result := FNC_VALIDA_EFC(efc, a_validar);
                      end if;
                      ---

                      if (v_result is null) then

                        if (v_cod_ide_cli is null) then
                            SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
                            v_result := 'Erro de validação';
                        end if;

                      end if;


                      if (v_result is null) then
                          -- Retorna Dados Referencia
                          v_cod_pccs       := null;
                          v_cod_quadro     := null;
                          v_cod_carreira   := null;
                          v_cod_classe     := null;
                          v_cod_referencia := null;
                          v_cod_composicao := null;
                          v_cod_jornada    := null;

                          pac_carga_Generica_cliente.sp_Ret_dados_referencia (efc.cod_ins,
                                                                              efc.cod_grau_nivel,
                                                                              efc.des_jornada,
                                                                              v_cod_entidade,
                                                                              efc.cod_cargo,
                                                                              efc.cod_Referencia,
                                                                              v_cod_pccs,           -- out
                                                                              v_cod_quadro,         -- out
                                                                              v_cod_carreira,       -- out
                                                                              v_cod_classe,         -- out
                                                                              v_cod_referencia,     -- out
                                                                              v_cod_composicao,     -- out
                                                                              v_cod_jornada,        -- out
                                                                              v_cod_Erro,           -- out
                                                                              v_msg_erro);          -- out

                         if v_cod_Erro is not null then
                              SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_CLI', 'pac_carga_Generica_cliente.sp_Ret_dados_referencia - Referencia não encontrada', 'Referencia não encontrada');
                              v_result := 'Erro de validação';
                         end if;
                     end if;


                     --
                     if (v_result is null) then

                       v_lin_tb_evolu_ccomi_gfunciona := null;

                        begin
                           select *
                             into v_lin_tb_evolu_ccomi_gfunciona
                             from tb_evolu_ccomi_gfuncional
                            where cod_ins          = efc.cod_ins
                              and cod_ide_cli      = v_Cod_ide_cli
                              and cod_entidade     = v_cod_entidade
                              and num_matricula    = v_id_servidor
                              and cod_ide_rel_func = v_cod_ide_rel_func
                              and dat_ini_efeito =  v_dat_ini_even_func
                              and rownum <2;

                        exception
                            when others then
                                null;
                        end;


                        if (v_lin_tb_evolu_ccomi_gfunciona.cod_ins is not null) then -- registro ja existe em tb_evolucao_funcional, atualiza os demais dados

                              v_cod_tipo_ocorrencia := 'A';

                              if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                update tb_evolu_ccomi_gfuncional
                                  set cod_mot_evol_func       = efc.cod_moti_evol_even_func_int,
                                      cod_tipo_doc_assoc      = nvl(efc.cod_tipo_doc_ini_even_func_int, cod_tipo_doc_assoc),
                                      num_doc_assoc           = nvl(efc.num_doc_ini_even_func, num_doc_assoc),
                                      dat_pub                 = v_dat_ini_even_func,
                                      dat_fim_efeito          = v_dat_fim_even_func,
                                      cod_jornada             = v_cod_jornada,
                                      cod_quadro              = v_cod_quadro,
                                      cod_classe              = v_cod_classe,
                                      cod_carreira            = v_Cod_carreira,
                                      cod_cargo_rel           = efc.cod_cargo,
                                      cod_cargo_comp          = efc.cod_cargo,
                                      cod_referencia          = v_Cod_referencia,
                                      cod_composicao          = v_Cod_composicao,
                                      dat_ult_atu             = sysdate,
                                      nom_usu_ult_atu         = user,
                                      nom_pro_ult_atu         = v_nom_rotina
                                  where cod_ins          = efc.cod_ins
                                    and cod_ide_cli      = v_Cod_ide_cli
                                    and cod_entidade     = v_cod_entidade
                                    and num_matricula    = v_id_servidor
                                    and cod_ide_rel_func = v_cod_ide_rel_func
                                    and dat_ini_efeito   = v_dat_ini_even_func
                                    and nom_pro_ult_atu  = v_nom_rotina;

                              end if;
                          else
                              v_cod_tipo_ocorrencia := 'I';

                              -- Verifica se tem período concomitante. Se não, não realiza ação
                              if pac_carga_generica_cliente.fnc_des_cliente = 'CAMPREV' then
                                select count(1)
                                  into v_qtd_concomitante
                                  from tb_evolu_ccomi_gfuncional
                                  where cod_ins          = efc.cod_ins
                                    and cod_ide_cli      = v_Cod_ide_cli
                                    and cod_entidade     = v_cod_entidade
                                    and num_matricula    = v_id_servidor
                                    and cod_ide_rel_func = v_cod_ide_rel_func
                                    and nvl(v_dat_fim_even_func,dat_ini_efeito) >= dat_ini_efeito
                                    and v_dat_ini_even_func <= nvl(dat_fim_efeito,v_dat_ini_even_func)
                                    and rownum <2;

                                if v_qtd_concomitante >0  then
                                   v_msg_erro := 'Erro - Período concomitante';
                                  raise erro;
                                end if;
                              end if;
                              --
                              if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                  insert into tb_evolu_ccomi_gfuncional
                                      (COD_INS,                   --  1
                                       COD_IDE_CLI,               --  2
                                       COD_ENTIDADE,              --  3
                                       COD_PCCS,                  --  4
                                       COD_CARGO_REL,                 --  5
                                       COD_CARGO_COMP,
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
                                       COD_JORNADA                -- 23
                                       )
                                  values
                                      (efc.cod_ins,                                        --  1 COD_INS
                                       v_cod_ide_cli,                                    --  2 COD_IDE_CLI
                                       v_cod_entidade,                                   --  3 COD_ENTIDADE
                                       v_cod_pccs,                                         --  4 COD_PCCS
                                       efc.cod_cargo,
                                       efc.cod_cargo,                                      --  5 COD_CARGO
                                       v_id_servidor,                                    --  6 NUM_MATRICULA
                                       v_cod_ide_rel_func,                              --  7 COD_IDE_REL_FUNC
                                       v_cod_quadro,                                       --  8 COD_QUADRO
                                       v_cod_carreira,                                     --  9 COD_CARREIRA
                                       v_cod_classe,                                       -- 10 COD_CLASSE
                                       v_cod_referencia,                                   -- 11 COD_REFERENCIA
                                       v_cod_composicao,                                   -- 12 COD_COMPOSICAO
                                       efc.cod_moti_evol_even_func_int,                    -- 13 COD_MOT_EVOL_FUNC
                                       efc.cod_tipo_doc_ini_even_func_int,                 -- 14 COD_TIPO_DOC_ASSOC
                                       efc.num_doc_ini_even_func,                          -- 15 NUM_DOC_ASSOC
                                       v_dat_ini_even_func,                                -- 16 DAT_PUB
                                       v_dat_ini_even_func,                                -- 17 DAT_INI_EFEITO
                                       v_dat_fim_even_func,                                -- 18 DAT_FIM_EFEITO
                                       sysdate,                                            -- 19 DAT_ING
                                       sysdate,                                            -- 20 DAT_ULT_ATU
                                       user,                                               -- 21 NOM_USU_ULT_ATU
                                       v_nom_rotina,                                       -- 22 NOM_PRO_ULT_ATU
                                       v_cod_jornada
                                       );
                              end if;

                          end if;

                          -- atualiza a ultima evolucao funcional
                          if pac_carga_Generica_cliente.fnc_Des_cliente = 'IPREV' then
                            update tb_evolu_ccomi_gfuncional
                             set dat_fim_efeito = v_dat_ini_even_func-1
                            where cod_ins = efc.cod_ins
                              and cod_Entidade = v_cod_entidade
                              and cod_ide_cli =v_cod_ide_cli
                              and num_matricula = v_id_Servidor
                              and cod_ide_rel_func = v_cod_ide_Rel_func
                              and dat_ini_efeito < trunc( v_dat_ini_even_func)
                              and nvl(dat_fim_efeito,v_dat_ini_even_func+1) >  v_dat_ini_even_func
                              and nom_pro_ult_atu = v_nom_rotina;
                          end if;

                          a_log.delete;
                          SP_INCLUI_LOG(a_log, 'COD_INS',                v_lin_tb_evolu_ccomi_gfunciona.cod_ins,                efc.cod_ins);
                          SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',            v_lin_tb_evolu_ccomi_gfunciona.cod_ide_cli,            v_cod_ide_cli);
                          SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',           v_lin_tb_evolu_ccomi_gfunciona.cod_entidade,           v_cod_entidade);
                          SP_INCLUI_LOG(a_log, 'COD_PCCS',               v_lin_tb_evolu_ccomi_gfunciona.cod_pccs,               v_cod_pccs);
                          SP_INCLUI_LOG(a_log, 'COD_CARGO_REL',              v_lin_tb_evolu_ccomi_gfunciona.cod_cargo_rel,      efc.cod_cargo);
                          SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',          v_lin_tb_evolu_ccomi_gfunciona.num_matricula,          v_id_servidor);
                          SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',       v_lin_tb_evolu_ccomi_gfunciona.cod_ide_rel_func,       v_Cod_ide_rel_func);
                          SP_INCLUI_LOG(a_log, 'COD_REFERENCIA',         v_lin_tb_evolu_ccomi_gfunciona.cod_referencia,         v_cod_referencia);
                 --         SP_INCLUI_LOG(a_log, 'FLG_STATUS',             v_lin_tb_evolu_ccomi_gfuncional.flg_status,             nvl(v_lin_tb_evolucao_funcional.flg_status, 'V'));
                          SP_INCLUI_LOG(a_log, 'COD_MOT_EVOL_FUNC',      v_lin_tb_evolu_ccomi_gfunciona.cod_mot_evol_func,      efc.cod_moti_evol_even_func_int);
                          SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC',     v_lin_tb_evolu_ccomi_gfunciona.cod_tipo_doc_assoc,     nvl(efc.cod_tipo_doc_ini_even_func_int, v_lin_tb_evolu_ccomi_gfunciona.cod_tipo_doc_assoc));
                          SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',          v_lin_tb_evolu_ccomi_gfunciona.num_doc_assoc,          nvl(efc.num_doc_ini_even_func, v_lin_tb_evolu_ccomi_gfunciona.num_doc_assoc));
                          SP_INCLUI_LOG(a_log, 'COD_JORNADA',            v_lin_tb_evolu_ccomi_gfunciona.cod_jornada,            v_cod_jornada);
                          SP_INCLUI_LOG(a_log, 'COD_QUADRO',             v_lin_tb_evolu_ccomi_gfunciona.cod_quadro,             nvl(v_lin_tb_evolu_ccomi_gfunciona.cod_quadro, v_cod_quadro));
                          SP_INCLUI_LOG(a_log, 'COD_CARREIRA',           v_lin_tb_evolu_ccomi_gfunciona.cod_carreira,           nvl(v_lin_tb_evolu_ccomi_gfunciona.cod_carreira, v_cod_carreira));
                          SP_INCLUI_LOG(a_log, 'COD_CLASSE',             v_lin_tb_evolu_ccomi_gfunciona.cod_classe,             nvl(v_lin_tb_evolu_ccomi_gfunciona.cod_classe, v_cod_classe));
                          SP_INCLUI_LOG(a_log, 'COD_COMPOSICAO',         v_lin_tb_evolu_ccomi_gfunciona.cod_composicao,         nvl( v_lin_tb_evolu_ccomi_gfunciona.cod_composicao, v_cod_composicao));
                     --     SP_INCLUI_LOG(a_log, 'FLG_INI_VINCULO',        v_lin_tb_evolu_ccomi_gfuncional.flg_ini_vinculo,        nvl(v_lin_tb_evolu_ccomi_gfuncional.flg_ini_vinculo, 'I'));
                          SP_INCLUI_LOG(a_log, 'DAT_INI_EFEITO',         to_char(v_lin_tb_evolu_ccomi_gfunciona.dat_ini_efeito, 'dd/mm/yyyy hh24:mi'), v_dat_ini_even_func);
                          SP_INCLUI_LOG(a_log, 'DAT_PUB',                to_char(v_lin_tb_evolu_ccomi_gfunciona.dat_pub, 'dd/mm/yyyy hh24:mi'),       v_dat_ini_even_func);
                          SP_INCLUI_LOG(a_log, 'DAT_FIM_EFEITO',         to_char(v_lin_tb_evolu_ccomi_gfunciona.dat_fim_efeito,'dd/mm/yyyy hh24:mi'),  v_dat_fim_even_func);

                          SP_GRAVA_LOG(i_id_header, efc.id_processo, efc.num_linha_header, v_cod_tipo_ocorrencia,
                                       v_cod_situ_ocorrencia, 'NOVAPREV', 'TB_EVOLUCAO_FUNCIONAL', v_nom_rotina, a_log);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '3', null, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      else

                          SP_GRAVA_ERRO(i_id_header, efc.id_processo, efc.num_linha_header, v_nom_rotina, a_validar);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                      end if;

                  EXCEPTION
                      WHEN ERRO THEN
                         rollback to sp1;

                          SP_GRAVA_ERRO(i_id_header, efc.id_processo, efc.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;
                      WHEN OTHERS THEN

                          v_msg_erro := substr(sqlerrm, 1, 4000);

                          rollback to sp1;

                          SP_GRAVA_ERRO(i_id_header, efc.id_processo, efc.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                          if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, efc.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                              raise ERRO_GRAVA_STATUS;
                          end if;

                  END;
               end loop;


                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);
            commit;
        else
            SP_GRAVA_ERRO_DIRETO(i_id_header, 9, 0, v_nom_rotina, 'não foi possivel recuperar dados do processo');
            commit;
        end if;

       commit;
    EXCEPTION

        WHEN erro_grava_status THEN
                      dbms_output.put_line('erro_grava_status');

            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN
            dbms_output.put_line(sqlerrm);
            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_EFC;

    -----------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------
    FUNCTION FNC_VALIDA_EFC (i_efc       in     r_efc,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_ini_even_func             date;
        v_dat_fim_even_func             date;
        v_cod_nivel                     tb_referencia.cod_nivel%type;
        v_cod_grau                      tb_referencia.cod_grau%type;

    BEGIN


        v_dat_fim_even_func := fnc_Valida_data(i_efc.dat_fim_even_func, 'RRRRMMDD');


        if (v_dat_fim_even_func is not null) then
            if (v_dat_fim_even_func < v_dat_ini_even_func) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_EVEN_FUNC', 'Data de fim do evento funcional ('||
                                                                                to_char(v_dat_fim_even_func, 'dd/mm/yyyy')||
                                                                                ') é anterior à correspondente data de início ('||
                                                                                to_char(v_dat_ini_even_func, 'dd/mm/yyyy')||')');
            end if;
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_EFC;

    -----------------------------------------------------------------------------------------------

      PROCEDURE SP_CARREGA_FNA (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_fna.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_tipo_ocorrencia_ff tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_FNA';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_FNA';
        v_tb_ficha_fin_rubrica  tb_ficha_fin_rubrica%rowtype;
        v_tb_ficha_financeira   tb_ficha_financeira%rowtype;
        v_cod_cargo             tb_rel_func_periodo_exerc.cod_cargo%type;
        v_cod_pccs              tb_rel_func_periodo_exerc.cod_pccs%type;
        v_cod_ide_rel_func      tb_rel_func_periodo_exerc.cod_ide_rel_func%type;
        v_val_acumulado         number;
        v_val_acumulado_con     number;
        v_val_acumulado_rem     number;
        v_existe_beneficio      varchar2(1);
        v_existe_vinculo        varchar2(1);
        v_cod_rubrica           tb_ficha_fin_rubrica.cod_rubrica%type;
        v_id_log_erro           number;
        v_cod_erro              number;
        v_msg_erro              varchar2(4000);
        v_dat_ref_folha         date;
        v_cod_ins_fna           tb_ficha_financeira.cod_ins%type;
        v_val_rubrica           number;
        v_vlr_iteracao          number := 20;
        v_cod_entidade          tb_carga_Gen_fna.Cod_Entidade%type;
        v_id_Servidor           tb_carga_Gen_fna.id_Servidor%type;
        v_cod_ide_cli           tb_ficha_financeira.cod_ide_cli%type;


    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then
            loop
                v_result := null;
                v_cur_id := null;
                --
                if v_cod_erro is not null then
                  v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                end if;
                --
                if v_result is null then
                  for fna in (select a.cod_ins,
                                     a.id_header,
                                     trim(a.cod_entidade)               cod_entidade,
                                     trim(a.id_servidor)                id_servidor,
                                     trim(a.id_vinculo)                 id_vinculo,
                                     trim(a.cod_verba)                  cod_verba,
                                     trim(a.val_verba)                  val_verba,
                                     trim(a.dat_competencia_pgto)       dat_competencia_pgto,
                                     trim(a.dat_referencia_folha_pgto)  dat_referencia_folha_pgto,
                                     trim(a.cod_tipo_folha_pgto)        cod_tipo_folha_pgto,
                                     fnc_codigo_ext(a.cod_ins, 2068, trim(a.cod_tipo_folha_pgto), null, 'COD_PAR') cod_tipo_folha_pgto_int,
                                     trim(a.des_info_complementar)      des_info_complementar,
                                     trim(a.val_percent_calc_verba)     val_percent_calc_verba,
                                     trim(a.val_unit_calc_verba)        val_unit_calc_verba,
                                     a.id, a.num_linha_header, a.id_processo
                              from tb_carga_gen_fna a
                              where a.id_header = i_id_header
                                and a.cod_status_processamento = '1'
                                and rownum < v_vlr_iteracao)
                      loop

                      v_cur_id              := fna.id;

                      BEGIN
                          v_result := null;
                          savepoint sp1;

                          -- separando entidade de id_header
                          v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(fna.id_servidor);
                          v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(fna.cod_entidade,fna.id_servidor);
                          -- Pega cod_ide_cli da ident_ext_servidor
                          v_cod_ide_cli := fnc_ret_cod_ide_cli( fna.cod_ins, v_id_Servidor);

                          if FNC_VALIDA_PESSOA_FISICA(fna.cod_ins, v_cod_ide_cli) is not null then
                             raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                          end if;

                          v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,fna.id_vinculo);

                          v_cod_rubrica      := fna.cod_verba;
                          v_val_rubrica      := fnc_valida_numero(fna.val_verba)/10000;
                          --
                          if (fna.dat_competencia_pgto is not null and fna.dat_competencia_pgto = '00000000') then
                              fna.dat_competencia_pgto := null;
                          end if;

                          if (fna.dat_referencia_folha_pgto is not null and fna.dat_referencia_folha_pgto = '00000000') then
                              fna.dat_referencia_folha_pgto := null;
                          end if;

                          a_validar.delete;

                          --Verifica se trouxe pessoa fisica
                          if (v_result is null) then
                              if (v_cod_ide_cli is null) then
                                SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_CLI', 'Código interno de identificação do servidor não localizado', 'Código interno de identificação do servidor');
                                v_result := 'Erro de validação';
                              end if;
                          end if;
                          --
                          -- Pega Cargo, PCCS e IDE_REL_FUNC da tb_relacao_funcional
                         if (v_result is null) then
                             begin
                                 v_existe_vinculo := null;
                                 v_dat_ref_folha := to_date(substr(fna.dat_referencia_folha_pgto,1,6), 'RRRRMM');

                                  select cod_entidade, cod_cargo, cod_pccs
                                  into v_cod_entidade ,v_cod_cargo, v_cod_pccs
                                  FROM tb_relacao_funcional
                                  where cod_ins          = fna.cod_ins
                                    --and cod_entidade     = v_cod_entidade
                                    and cod_ide_cli      = v_cod_ide_cli
                                    and num_matricula    = v_id_servidor
                                    and cod_ide_rel_func = v_cod_ide_rel_func
                                    and v_dat_ref_folha between dat_ini_exerc and nvl(dat_fim_exerc,v_dat_ref_folha);

                              exception
                                  when no_data_found then
                                      SP_INCLUI_ERRO_VALIDACAO(a_validar, 'EXISTE_VINCULO', 'Não foi possível confirmar a existência de vínculo', 'Existência do vínculo');
                                      v_result := 'Erro de validação';
                                  when others then
                                      SP_INCLUI_ERRO_VALIDACAO(a_validar, 'EXISTE_VINCULO', substr('Erro ao confirmar a existência de vínculo: '||sqlerrm, 1, 4000), 'Existência do benefício');
                                      v_result := 'Erro de validação';
                              end;
                          end if;
                          --
                          if (v_result is null) then
                              --
                              -- TB_FICHA_FINANCEIRA
                              begin
                               select ff.cod_ins
                                into v_cod_ins_fna
                                from tb_ficha_financeira ff
                                where cod_ins          = fna.cod_ins
                                  and cod_ide_cli      = v_cod_ide_cli
                                  and cod_entidade     = v_cod_entidade
                                  and num_matricula    = v_id_servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and cod_tip_folha    = fna.cod_tipo_folha_pgto_int
                                  and dat_mes          = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                  and dat_ano          = substr(fna.dat_referencia_folha_pgto, 1, 4);
                              exception
                                when no_data_found then
                                  v_cod_ins_fna := null;
                              end;
                              --
                              --
                              if (nvl(v_flg_acao_postergada, '1') = '0') then --
                                if v_cod_ins_fna is null then
                                   v_cod_tipo_ocorrencia_ff := 'I';

                                   insert into tb_ficha_financeira
                                        (COD_INS,             --  1
                                         COD_IDE_CLI,         --  2
                                         COD_ENTIDADE,        --  3
                                         COD_PCCS,            --  4
                                         COD_CARGO,           --  5
                                         NUM_MATRICULA,       --  6
                                         COD_IDE_REL_FUNC,    --  7
                                         DAT_MES,             --  8
                                         DAT_ANO,             --  9
                                         COD_TIP_FOLHA,       -- 10
                                         VAL_SAL_BAS,         -- 11
                                         VAL_SAL_REM,         -- 12
                                         VAL_SAL_CON,         -- 13
                                         FLG_ULT_REM,         -- 14
                                         DAT_ING,             -- 15
                                         DAT_ULT_ATU,         -- 16
                                         NOM_USU_ULT_ATU,     -- 17
                                         NOM_PRO_ULT_ATU,     -- 18
                                         DES_INFO,            -- 19
                                         COD_ENTIDADE_ORIGEM) -- 20
                                   values
                                        (fna.cod_ins,                                 --  1 COD_INS
                                         v_cod_ide_cli,                               --  2 COD_IDE_CLI
                                         v_cod_entidade,                              --  3 COD_ENTIDADE
                                         v_cod_pccs,                                  --  4 COD_PCCS
                                         v_cod_cargo,                                 --  5 COD_CARGO
                                         v_id_servidor,                               --  6 NUM_MATRICULA
                                         v_cod_ide_rel_func,                          --  7 COD_IDE_REL_FUNC
                                         substr(fna.dat_referencia_folha_pgto, 5, 2), --  8 DAT_MES
                                         substr(fna.dat_referencia_folha_pgto, 1, 4), --  9 DAT_ANO
                                         fna.cod_tipo_folha_pgto_int,                 -- 10 COD_TIP_FOLHA
                                         0,                                           -- 11 VAL_SAL_BAS
                                         0,                                           -- 12 VAL_SAL_REM
                                         0,                                           -- 13 VAL_SAL_CON
                                         'N',                                         -- 14 FLG_ULT_REM
                                         sysdate,                                     -- 15 DAT_ING
                                         sysdate,                                     -- 16 DAT_ULT_ATU
                                         user,                                        -- 17 NOM_USU_ULT_ATU
                                         v_nom_rotina,                                -- 18 NOM_PRO_ULT_ATU
                                         null,                                        -- 19 DES_INFO
                                         v_cod_entidade);                             -- 20 COD_ENTIDADE_ORIGEM
                               else
                                 v_cod_tipo_ocorrencia_ff := 'U';
                               end if;
                             end if;
                             --
                             --
                             update tb_ficha_fin_rubrica
                                set VAL_RUBRICA = v_val_rubrica,
                                    DAT_ULT_ATU = sysdate,
                                    NOM_PRO_ULT_ATU  = v_nom_rotina,
                                    DES_INFORMACAO = fna.des_info_complementar
                               where cod_ins          = fna.cod_ins
                                 and cod_ide_cli      = v_cod_ide_cli
                                 and cod_entidade     = v_cod_entidade
                                 and num_matricula    = v_id_servidor
                                 and cod_ide_rel_func = v_cod_ide_rel_func
                                 and cod_rubrica      = v_cod_rubrica
                                 and cod_tip_folha    = fna.cod_tipo_folha_pgto_int
                                 and dat_mes          = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                 and dat_ano          = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                 and NOM_PRO_ULT_ATU = v_nom_rotina;
                             if sql%rowcount >0 then
                                v_cod_tipo_ocorrencia := 'U';
                             else
                                v_cod_tipo_ocorrencia := 'I';
                                --
                                insert into tb_ficha_fin_rubrica
                                    (COD_INS,               --  1
                                     COD_IDE_CLI,           --  2
                                     COD_ENTIDADE,          --  3
                                     COD_PCCS,              --  4
                                     COD_CARGO,             --  5
                                     NUM_MATRICULA,         --  6
                                     COD_IDE_REL_FUNC,      --  7
                                     COD_RUBRICA,           --  8
                                     NUM_SEQ_VIG,           --  9
                                     DAT_MES,               -- 10
                                     DAT_ANO,               -- 11
                                     DAT_COMP,              -- 12
                                     VAL_RUBRICA,           -- 13
                                     FLG_PARTICIPA_CON,     -- 14
                                     DAT_ING,               -- 15
                                     DAT_ULT_ATU,           -- 16
                                     NOM_USU_ULT_ATU,       -- 17
                                     NOM_PRO_ULT_ATU,       -- 18
                                     VAL_POR,               -- 19
                                     COD_TIP_FOLHA,         -- 20
                                     DES_INFORMACAO,        -- 21
                                     FLG_COMPUTO_TETO,      -- 22
                                     COD_ENTIDADE_ORIGEM,   -- 23
                                     FLG_TIP_SINAL,         -- 24
                                     MES_ATRAS,             -- 25
                                     VAL_UNIT)              -- 26
                                values
                                    (fna.cod_ins,                                   --  1 COD_INS
                                     v_cod_ide_cli,                               --  2 COD_IDE_CLI
                                     v_cod_entidade,                              --  3 COD_ENTIDADE
                                     v_cod_pccs,                                    --  4 COD_PCCS
                                     v_cod_cargo,                                   --  5 COD_CARGO
                                     v_id_servidor,                               --  6 NUM_MATRICULA
                                     v_cod_ide_rel_func,                            --  7 COD_IDE_REL_FUNC
                                     v_cod_rubrica,                                 --  8 COD_RUBRICA
                                     '1',                                           --  9 NUM_SEQ_VIG
                                     substr(fna.dat_referencia_folha_pgto, 5, 2),   -- 10 DAT_MES
                                     substr(fna.dat_referencia_folha_pgto, 1, 4),   -- 11 DAT_ANO
                                     substr(fna.dat_referencia_folha_pgto, 1, 6),   -- 12 DAT_COMP
                                     v_val_rubrica,                                   -- 13 VAL_RUBRICA
                                     'S',                                           -- 14 FLG_PARTICIPA_CON
                                     sysdate,                                       -- 15 DAT_ING
                                     sysdate,                                       -- 16 DAT_ULT_ATU
                                     user,                                          -- 17 NOM_USU_ULT_ATU
                                     v_nom_rotina,                                  -- 18 NOM_PRO_ULT_ATU
                                     fnc_valida_numero(fna.val_percent_calc_verba), -- 19 VAL_POR
                                     fna.cod_tipo_folha_pgto_int,                   -- 20 COD_TIP_FOLHA
                                     fna.des_info_complementar,                     -- 21 DES_INFORMACAO
                                     'S',                                           -- 22 FLG_COMPUTO_TETO
                                     v_cod_entidade,                                -- 23 COD_ENTIDADE_ORIGEM
                                     'M',                                           -- 24 FLG_TIP_SINAL
                                     'M',                                           -- 25 MES_ATRAS
                                     fnc_valida_numero(fna.val_unit_calc_verba));   -- 26 VAL_UNIT
                              end if;
                              -- LOG TB_FICHA_FIN_RUBRICA
                          /*    a_log.delete;
                              SP_INCLUI_LOG(a_log, 'COD_INS',             null, fna.cod_ins);
                              SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',         null, v_cod_ide_cli);
                              SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',        null, v_cod_entidade);
                              SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',       null, v_id_servidor);
                              SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',    null, v_cod_ide_rel_func);
                              SP_INCLUI_LOG(a_log, 'DAT_MES',             null, substr(fna.dat_referencia_folha_pgto, 5, 2));
                              SP_INCLUI_LOG(a_log, 'DAT_ANO',             null, substr(fna.dat_referencia_folha_pgto, 1, 4));
                              SP_INCLUI_LOG(a_log, 'COD_RUBRICA',         null, v_cod_rubrica);
                              SP_INCLUI_LOG(a_log, 'NUM_SEQ_VIG',         null, '1');
                              SP_INCLUI_LOG(a_log, 'COD_TIP_FOLHA',       null, fna.cod_tipo_folha_pgto_int);
                              SP_INCLUI_LOG(a_log, 'MES_ATRAS',           null,   'M');
                              SP_INCLUI_LOG(a_log, 'COD_PCCS',            null, v_cod_pccs);
                              SP_INCLUI_LOG(a_log, 'COD_CARGO',           null, v_cod_cargo);
                              SP_INCLUI_LOG(a_log, 'VAL_RUBRICA',         null, v_val_rubrica);
                              SP_INCLUI_LOG(a_log, 'DES_INFORMACAO',      null, nvl(fna.des_info_complementar, v_tb_ficha_fin_rubrica.des_informacao));
                              SP_INCLUI_LOG(a_log, 'COD_ENTIDADE_ORIGEM', null, fna.cod_entidade);
                              SP_INCLUI_LOG(a_log, 'VAL_POR',             null, nvl(fnc_valida_numero(fna.val_percent_calc_verba), v_tb_ficha_fin_rubrica.val_por));
                              SP_INCLUI_LOG(a_log, 'VAL_UNIT',            null, nvl(fnc_valida_numero(fna.val_unit_calc_verba), v_tb_ficha_fin_rubrica.val_unit));
                              SP_INCLUI_LOG(a_log, 'FLG_PARTICIPA_CON',   null,  'S');
                              SP_INCLUI_LOG(a_log, 'FLG_COMPUTO_TETO',    null, 'S');
                              SP_INCLUI_LOG(a_log, 'FLG_TIP_SINAL',       null, 'M');
                              SP_INCLUI_LOG(a_log, 'DAT_COMP',            null, substr(fna.dat_referencia_folha_pgto, 1, 6));

                              SP_GRAVA_LOG(i_id_header, fna.id_processo, fna.num_linha_header, v_cod_tipo_ocorrencia,
                                           v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_FICHA_FIN_RUBRICA', v_nom_rotina, a_log);
                           */
                              --
                              -- realiza update na tb_ficha_financeira para atualizar valores
                               begin
                                  v_val_acumulado := null;

                                  select nvl(sum(t1.val_rubrica),0)
                                  into v_val_acumulado
                                  from tb_ficha_fin_rubrica t1
                                  where t1.cod_ins             = fna.cod_ins
                                    and t1.cod_ide_cli         = v_cod_ide_cli
                                    and t1.cod_entidade        = v_cod_entidade
                                    and t1.num_matricula       = v_id_servidor
                                    and t1.cod_ide_rel_func    = v_cod_ide_rel_func
                                    and t1.dat_ano             = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                    and t1.dat_mes             = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                    and t1.cod_tip_folha       = fna.cod_tipo_folha_pgto_int
                                    and t1.cod_rubrica         in (1,70,71,110);

                                  update tb_ficha_financeira
                                     set VAL_SAL_BAS = v_val_acumulado,
                                        -- VAL_SAL_REM = v_val_acumulado,
                                        -- VAL_SAL_CON = v_val_acumulado,
                                         dat_ult_Atu = sysdate
                                   where cod_ins          = fna.cod_ins
                                     and cod_ide_cli      = v_cod_ide_cli
                                     and cod_entidade     = v_cod_entidade
                                     and num_matricula    = v_id_servidor
                                     and cod_ide_rel_func = v_cod_ide_rel_func
                                     and cod_tip_folha    = fna.cod_tipo_folha_pgto_int
                                     and dat_mes          = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                     and dat_ano          = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                     and nom_pro_ult_atu  = v_nom_rotina;


                              exception
                                  when others then
                                      SP_INCLUI_ERRO_VALIDACAO(a_validar, 'VAL_ACUMULADO_RUBRICA', substr('Erro ao calcular o valor acumulado da rubrica: '||sqlerrm, 1, 4000), 'Valor acumulado da rubrica');
                                      v_result := 'Erro de validação';
                              end;


 ---- ERIC AJUSTE CONTRIBUIÇÃO 24/04/2023
                              -- realiza update na tb_ficha_financeira para atualizar BASE de CONTRIBUIÇÃO
                               begin
                                  v_val_acumulado_con := null;

                                  select nvl(sum(t1.val_rubrica),0)
                                  into v_val_acumulado_con
                                  from tb_ficha_fin_rubrica t1
                                  where t1.cod_ins             = fna.cod_ins
                                    and t1.cod_ide_cli         = v_cod_ide_cli
                                    and t1.cod_entidade        = v_cod_entidade
                                    and t1.num_matricula       = v_id_servidor
                                    and t1.cod_ide_rel_func    = v_cod_ide_rel_func
                                    and t1.dat_ano             = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                    and t1.dat_mes             = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                    and t1.cod_tip_folha       = fna.cod_tipo_folha_pgto_int
                                    and t1.cod_rubrica         in (902,943,972);

                                  update tb_ficha_financeira
                                     set VAL_SAL_CON = v_val_acumulado_con,
                                         dat_ult_Atu = sysdate
                                   where cod_ins          = fna.cod_ins
                                     and cod_ide_cli      = v_cod_ide_cli
                                     and cod_entidade     = v_cod_entidade
                                     and num_matricula    = v_id_servidor
                                     and cod_ide_rel_func = v_cod_ide_rel_func
                                     and cod_tip_folha    = fna.cod_tipo_folha_pgto_int
                                     and dat_mes          = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                     and dat_ano          = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                     and nom_pro_ult_atu = v_nom_rotina;

                              exception
                                  when others then
                                      SP_INCLUI_ERRO_VALIDACAO(a_validar, 'VAL_ACUMULADO_RUBRICA', substr('Erro ao calcular o valor acumulado da rubrica: '||sqlerrm, 1, 4000), 'Valor acumulado da rubrica');
                                      v_result := 'Erro de validação';
                              end;


 ---- ERIC AJUSTE CONTRIBUIÇÃO 24/04/2023
                              -- realiza update na tb_ficha_financeira para atualizar BASE de CONTRIBUIÇÃO
                               begin
                                  v_val_acumulado_rem := null;

                                  select nvl(sum(t1.val_rubrica),0)
                                  into v_val_acumulado_rem
                                  from tb_ficha_fin_rubrica t1
                                  where t1.cod_ins             = fna.cod_ins
                                    and t1.cod_ide_cli         = v_cod_ide_cli
                                    and t1.cod_entidade        = v_cod_entidade
                                    and t1.num_matricula       = v_id_servidor
                                    and t1.cod_ide_rel_func    = v_cod_ide_rel_func
                                    and t1.dat_ano             = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                    and t1.dat_mes             = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                    and t1.cod_tip_folha       = fna.cod_tipo_folha_pgto_int
                                    and t1.cod_rubrica         in (902,943,972);  -- < 400;

                                  update tb_ficha_financeira
                                     set VAL_SAL_REM = v_val_acumulado_rem,
                                         dat_ult_Atu = sysdate
                                   where cod_ins          = fna.cod_ins
                                     and cod_ide_cli      = v_cod_ide_cli
                                     and cod_entidade     = v_cod_entidade
                                     and num_matricula    = v_id_servidor
                                     and cod_ide_rel_func = v_cod_ide_rel_func
                                     and cod_tip_folha    = fna.cod_tipo_folha_pgto_int
                                     and dat_mes          = substr(fna.dat_referencia_folha_pgto, 5, 2)
                                     and dat_ano          = substr(fna.dat_referencia_folha_pgto, 1, 4)
                                     and nom_pro_ult_atu = v_nom_rotina;

                              exception
                                  when others then
                                      SP_INCLUI_ERRO_VALIDACAO(a_validar, 'VAL_ACUMULADO_RUBRICA', substr('Erro ao calcular o valor acumulado da rubrica: '||sqlerrm, 1, 4000), 'Valor acumulado da rubrica');
                                      v_result := 'Erro de validação';
                              end;

--- ERIC FIM AJUSTE 24/04/2023

                              if v_result is null then
                               /* a_log.delete;
                                SP_INCLUI_LOG(a_log, 'COD_INS',             null, fna.cod_ins);
                                SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',         null, v_cod_ide_cli);
                                SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',        null, v_cod_entidade);
                                SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',       null, v_id_servidor);
                                SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',    null, v_cod_ide_rel_func);
                                SP_INCLUI_LOG(a_log, 'DAT_MES',             null, substr(fna.dat_referencia_folha_pgto, 5, 2));
                                SP_INCLUI_LOG(a_log, 'DAT_ANO',             null, substr(fna.dat_referencia_folha_pgto, 1, 4));
                                SP_INCLUI_LOG(a_log, 'COD_TIP_FOLHA',       null, fna.cod_tipo_folha_pgto_int);
                                SP_INCLUI_LOG(a_log, 'COD_PCCS',            null, v_cod_pccs);
                                SP_INCLUI_LOG(a_log, 'COD_CARGO',           null, v_cod_cargo);
                                SP_INCLUI_LOG(a_log, 'VAL_SAL_BAS',         null, fnc_valida_numero(fna.val_verba)/10000);
                                SP_INCLUI_LOG(a_log, 'VAL_SAL_REM',         null, v_val_acumulado);
                                SP_INCLUI_LOG(a_log, 'VAL_SAL_CON',         null, v_val_acumulado);
                                SP_INCLUI_LOG(a_log, 'DES_INFO',            null, fna.des_info_complementar);
                                SP_INCLUI_LOG(a_log, 'COD_ENTIDADE_ORIGEM', null, fna.cod_entidade);
                                SP_INCLUI_LOG(a_log, 'FLG_ULT_REM',         null,  'N');

                                SP_GRAVA_LOG(i_id_header, fna.id_processo, fna.num_linha_header, v_cod_tipo_ocorrencia_ff,
                                             v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_FICHA_FINANCEIRA', v_nom_rotina, a_log);

                               */
                                if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fna.id, '3', null, v_nom_rotina) != 'TRUE') then
                                    raise ERRO_GRAVA_STATUS;
                                end if;
                              end if;
                          end if;

                          if v_result is not null then
                              rollback to sp1;

                              SP_GRAVA_ERRO(i_id_header, fna.id_processo, fna.num_linha_header, v_nom_rotina, a_validar);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fna.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;

                          end if;

                      EXCEPTION
                          WHEN OTHERS THEN

                              v_msg_erro := substr(sqlerrm, 1, 4000);

                              rollback to sp1;

                              SP_GRAVA_ERRO(i_id_header, fna.id_processo, fna.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fna.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;

                      END;

                  end loop;
                else
                  rollback;
                  SP_GRAVA_ERRO_DIRETO(i_id_header, 12, 0, v_nom_rotina, v_result);
                  commit;
                  exit;
                end if;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'Não foi possível recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'Não foi possível reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_FNA;
    -----------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_FLF (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_flf.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_FLF';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_FLF';
        v_tb_afastamento        tb_afastamento%rowtype;
        v_tb_relacao_funcional tb_relacao_funcional%rowtype;
        v_num_seq_afast         tb_afastamento.num_seq_afast%type;
        v_id_log_erro number;
        v_msg_erro              varchar2(4000);
        v_id_servidor           number;
        v_cod_entidade          varchar2(20);
        v_cod_ide_cli           varchar2(20);
        v_cod_ide_Rel_func      tb_relacao_funcional.cod_ide_rel_func%type;


    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for flf in (select a.cod_ins,
                                   trim(a.cod_entidade)           cod_entidade,
                                   trim(a.id_servidor)            id_servidor,
                                   trim(a.id_vinculo)             id_vinculo,
                                   trim(a.cod_tipo_doc_ini)       cod_tipo_doc_ini,
                                   fnc_codigo_ext(a.cod_ins, 2019, trim(a.cod_tipo_doc_ini),   null, 'COD_PAR') cod_tipo_doc_ini_int,
                                   trim(a.num_doc_ini)            num_doc_ini,
                                   trim(a.dat_publicacao_doc)     dat_publicacao_doc,
                                   trim(a.cod_moti_afast)         cod_moti_afast,
                                   fnc_codigo_ext(a.cod_ins, 2029, trim(to_number(a.cod_moti_afast)),     null, 'COD_PAR') cod_moti_afast_int,
                                   trim(a.dat_ini_afast)          dat_ini_afast,
                                   trim(a.dat_fim_afast_prevista) dat_fim_afast_prevista,
                                   trim(a.dat_fim_afast_efetiva)  dat_fim_afast_efetiva,
                                   trim(a.cod_moti_fim_afast)     cod_moti_fim_afast,
                                   fnc_codigo_ext(a.cod_ins, 2030, trim(a.cod_moti_fim_afast), null, 'COD_PAR') cod_moti_fim_afast_int,
                                   trim(a.num_laudo_pericia)      num_laudo_pericia,
                                   trim(a.ano_exerc_ferias)       ano_exerc_ferias,
                                   trim(a.cod_situ_ferias)        cod_situ_ferias,
                                   fnc_codigo_ext(a.cod_ins, 2031, trim(a.cod_situ_ferias),    null, 'COD_PAR') cod_situ_ferias_int,
                                   a.id, a.num_linha_header, a.id_processo
                            from tb_carga_gen_flf a
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id             := flf.id;

                    BEGIN

                        savepoint sp1;
                        -- separando entidade de id_header
                        v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(flf.id_servidor);
                        --v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(flf.cod_entidade,flf.id_servidor);
                        --
                        -- Pega cod_ide_cli da ident_ext_servidor
                        v_cod_ide_cli := fnc_ret_cod_ide_cli( flf.cod_ins, v_id_Servidor);

                        if FNC_VALIDA_PESSOA_FISICA(flf.cod_ins, v_cod_ide_cli) is not null then
                           raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                        end if;

                        v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,flf.id_vinculo);

                        if (flf.dat_publicacao_doc is not null and flf.dat_publicacao_doc = '00000000') then
                            flf.dat_publicacao_doc := null;
                        end if;

                        if (flf.dat_ini_afast is not null and flf.dat_ini_afast = '00000000') then
                            flf.dat_ini_afast := null;
                        end if;

                        if (flf.dat_fim_afast_prevista is not null and flf.dat_fim_afast_prevista = '00000000') then
                            flf.dat_fim_afast_prevista := null;
                        end if;

                        if (flf.dat_fim_afast_efetiva is not null and flf.dat_fim_afast_efetiva = '00000000') then
                            flf.dat_fim_afast_efetiva := null;
                        end if;

                        if (flf.ano_exerc_ferias is not null and flf.ano_exerc_ferias = '0000') then
                            flf.ano_exerc_ferias := null;
                        end if;


                        v_result := FNC_VALIDA_FLF(flf, a_validar);

                        if (v_result is null) then

                            v_tb_relacao_funcional := null;

                            begin
                                select c.*
                                into v_tb_relacao_funcional
                                from  tb_relacao_funcional  c
                                where c.cod_ins       = flf.cod_ins
                                  and c.cod_ide_cli   = v_cod_ide_cli
                                  and c.num_matricula = v_id_servidor
                                  and c.cod_ide_rel_func = v_cod_ide_Rel_func;

                                v_cod_entidade:=v_tb_relacao_funcional.cod_entidade;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_num_seq_afast  := null;
                            v_tb_afastamento := null;

                            begin
                                select *
                                into v_tb_afastamento
                                from tb_afastamento
                                where cod_ins          = flf.cod_ins
                                  and cod_ide_cli      = v_cod_ide_cli
                                  and cod_entidade     = v_cod_entidade
                                  and num_matricula    = v_id_servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and dat_ini_afast    = fnc_valida_data(flf.dat_ini_afast, 'RRRRMMDD');
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_afastamento.cod_ins is not null) then -- registro ja existe em tb_afastamento, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_afastamento
                                    set num_laudo_medico     = nvl(flf.num_laudo_pericia, v_tb_afastamento.num_laudo_medico),
                                        cod_mot_afast        = flf.cod_moti_afast_int,
                                        dat_ini_afast        = fnc_valida_data(flf.dat_ini_afast, 'RRRRMMDD'),
                                        cod_tipo_doc_assoc   = nvl(flf.cod_tipo_doc_ini_int, v_tb_afastamento.cod_tipo_doc_assoc),
                                        num_doc_assoc        = nvl(flf.num_doc_ini, v_tb_afastamento.num_doc_assoc),
                                        dat_public           = nvl(fnc_valida_data(flf.dat_publicacao_doc, 'RRRRMMDD'), v_tb_afastamento.dat_public),
                                        dat_ret_prev         = nvl(fnc_valida_data(flf.dat_fim_afast_prevista, 'RRRRMMDD'), v_tb_afastamento.dat_ret_prev),
                                        dat_ret_efetivo      = fnc_valida_data(flf.dat_fim_afast_efetiva, 'RRRRMMDD'),
                                        cod_ret_afast        = nvl(flf.cod_moti_fim_afast_int, v_tb_afastamento.cod_ret_afast),
                                        dat_ano_exerc_ferias = nvl(flf.ano_exerc_ferias, v_tb_afastamento.dat_ano_exerc_ferias),
                                        cod_sit_ferias       = nvl(flf.cod_situ_ferias_int, v_tb_afastamento.cod_sit_ferias),
                                        dat_ult_atu          = sysdate,
                                        nom_usu_ult_atu      = user,
                                        nom_pro_ult_atu      = v_nom_rotina
                                    where cod_ins          = v_tb_afastamento.cod_ins
                                      and cod_ide_cli      = v_tb_afastamento.cod_ide_cli
                                      and cod_entidade     = v_tb_afastamento.cod_entidade
                                      and num_matricula    = v_tb_afastamento.num_matricula
                                      and cod_ide_rel_func = v_tb_relacao_funcional.cod_ide_rel_func
                                      and num_seq_afast    = v_tb_afastamento.num_seq_afast;
                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                v_num_seq_afast := SEQ_NUM_SEQ_AFAST.NEXTVAL;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_afastamento
                                        (COD_INS,                --  1
                                         COD_IDE_CLI,            --  2
                                         COD_ENTIDADE,           --  3
                                         COD_PCCS,               --  4
                                         COD_CARGO,              --  5
                                         NUM_MATRICULA,          --  6
                                         COD_IDE_REL_FUNC,       --  7
                                         NUM_SEQ_AFAST,          --  8
                                         NUM_LAUDO_MEDICO,       --  9
                                         COD_MOT_AFAST,          -- 10
                                         DAT_INI_AFAST,          -- 11
                                         COD_TIPO_DOC_ASSOC,     -- 12
                                         NUM_DOC_ASSOC,          -- 13
                                         DAT_PUBLIC,             -- 14
                                         DAT_RET_PREV,           -- 15
                                         DAT_RET_EFETIVO,        -- 16
                                         COD_RET_AFAST,          -- 17
                                         DAT_ANO_EXERC_FERIAS,   -- 18
                                         COD_SIT_FERIAS,         -- 19
                                         DAT_ING,                -- 20
                                         DAT_ULT_ATU,            -- 21
                                         NOM_USU_ULT_ATU,        -- 22
                                         NOM_PRO_ULT_ATU)        -- 23
                                    values
                                        (flf.cod_ins,                                             --  1 COD_INS
                                         v_cod_ide_cli,                                         --  2 COD_IDE_CLI
                                         v_cod_entidade,                                        --  3 COD_ENTIDADE
                                         v_tb_relacao_funcional.cod_pccs,                        --  4 COD_PCCS
                                         v_tb_relacao_funcional.cod_cargo,                       --  5 COD_CARGO
                                         v_id_servidor,                                         --  6 NUM_MATRICULA
                                         v_cod_ide_rel_func,                --  7 COD_IDE_REL_FUNC
                                         v_num_seq_afast,                                         --  8 NUM_SEQ_AFAST
                                         flf.num_laudo_pericia,                                   --  9 NUM_LAUDO_MEDICO
                                         flf.cod_moti_afast_int,                                  -- 10 COD_MOT_AFAST
                                         fnc_valida_data(flf.dat_ini_afast, 'RRRRMMDD'),          -- 11 DAT_INI_AFAST
                                         nvl(flf.cod_tipo_doc_ini_int,'0'),                                -- 12 COD_TIPO_DOC_ASSOC
                                         nvl(flf.num_doc_ini,'0'),                                         -- 13 NUM_DOC_ASSOC
                                         fnc_valida_data(flf.dat_publicacao_doc, 'RRRRMMDD'),     -- 14 DAT_PUBLIC
                                         fnc_valida_data(nvl(flf.dat_fim_afast_prevista,flf.dat_fim_afast_efetiva), 'RRRRMMDD'), -- 15 DAT_RET_PREV
                                         fnc_valida_data(flf.dat_fim_afast_efetiva, 'RRRRMMDD'),  -- 16 DAT_RET_EFETIVO
                                         flf.cod_moti_fim_afast_int,                              -- 17 COD_RET_AFAST
                                         flf.ano_exerc_ferias,                                    -- 18 DAT_ANO_EXERC_FERIAS
                                         flf.cod_situ_ferias_int,                                 -- 19 COD_SIT_FERIAS
                                         sysdate,                                                 -- 20 DAT_ING
                                         sysdate,                                                 -- 21 DAT_ULT_ATU
                                         user,                                                    -- 22 NOM_USU_ULT_ATU
                                         v_nom_rotina);                                           -- 23 NOM_PRO_ULT_ATU
                                end if;

                            end if;

                           /* a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',              v_tb_afastamento.cod_ins,              flf.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',          v_tb_afastamento.cod_ide_cli,          flf.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',         v_tb_afastamento.cod_entidade,         flf.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',        v_tb_afastamento.num_matricula,        flf.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',     v_tb_afastamento.cod_ide_rel_func,     v_tb_relacao_funcional.cod_ide_rel_func);
                            SP_INCLUI_LOG(a_log, 'NUM_SEQ_AFAST',        v_tb_afastamento.num_seq_afast,        nvl(v_num_seq_afast, v_tb_afastamento.num_seq_afast));
                            SP_INCLUI_LOG(a_log, 'NUM_LAUDO_MEDICO',     v_tb_afastamento.num_laudo_medico,     nvl(flf.num_laudo_pericia, v_tb_afastamento.num_laudo_medico));
                            SP_INCLUI_LOG(a_log, 'COD_MOT_AFAST',        v_tb_afastamento.cod_mot_afast,        flf.cod_moti_afast_int);
                            SP_INCLUI_LOG(a_log, 'DAT_INI_AFAST',        to_char(v_tb_afastamento.dat_ini_afast, 'dd/mm/yyyy hh24:mi'),   to_char(fnc_valida_data(flf.dat_ini_afast, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC',   v_tb_afastamento.cod_tipo_doc_assoc,   nvl(flf.cod_tipo_doc_ini_int, v_tb_afastamento.cod_tipo_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',        v_tb_afastamento.num_doc_assoc,        nvl(flf.num_doc_ini, v_tb_afastamento.num_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'DAT_PUBLIC',           to_char(v_tb_afastamento.dat_public, 'dd/mm/yyyy hh24:mi'),      to_char(nvl(fnc_valida_data(flf.dat_publicacao_doc, 'RRRRMMDD'), v_tb_afastamento.dat_public), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_RET_PREV',         to_char(v_tb_afastamento.dat_ret_prev, 'dd/mm/yyyy hh24:mi'),    to_char(nvl(fnc_valida_data(flf.dat_fim_afast_prevista, 'RRRRMMDD'), v_tb_afastamento.dat_ret_prev), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_RET_EFETIVO',      to_char(v_tb_afastamento.dat_ret_efetivo, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(flf.dat_fim_afast_efetiva, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'COD_RET_AFAST',        v_tb_afastamento.cod_ret_afast,        nvl(flf.cod_moti_fim_afast_int, v_tb_afastamento.cod_ret_afast));
                            SP_INCLUI_LOG(a_log, 'DAT_ANO_EXERC_FERIAS', v_tb_afastamento.dat_ano_exerc_ferias, nvl(flf.ano_exerc_ferias, v_tb_afastamento.dat_ano_exerc_ferias));
                            SP_INCLUI_LOG(a_log, 'COD_SIT_FERIAS',       v_tb_afastamento.cod_sit_ferias,       nvl(flf.cod_situ_ferias_int, v_tb_afastamento.cod_sit_ferias));

                            SP_GRAVA_LOG(i_id_header, flf.id_processo, flf.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_AFASTAMENTO', v_nom_rotina, a_log);
                            */
                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, flf.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, flf.id_processo, flf.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, flf.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, flf.id_processo,  flf.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, flf.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_FLF;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_FLF (i_flf        in     r_flf,
                             o_a_validar  in out t_validar)
            return varchar2 IS

        v_retorno      varchar2(2000);
        v_des_result   varchar2(4000);
        v_dat_ini      date;
        v_dat_fim_prev date;
        v_dat_fim_efet date;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_flf.cod_ins, i_flf.cod_entidade);

        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_flf.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_flf.id_vinculo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo não foi informada');
        elsif (fnc_valida_numero(i_flf.id_vinculo) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo informada ('||i_flf.id_vinculo||') esta invalida');
        end if;

        if ((i_flf.cod_tipo_doc_ini is not null) and (i_flf.cod_tipo_doc_ini_int is null)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_DOC_INI', 'Codigo informado para o tipo de documento do inicio do afastamento ('||i_flf.cod_tipo_doc_ini||') não previsto');
        end if;

        if (    (i_flf.dat_publicacao_doc is not null)
            and (   (length(i_flf.dat_publicacao_doc) < 8)
                 or (fnc_valida_data(i_flf.dat_publicacao_doc, 'RRRRMMDD') is null))) then

            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_PUBLICACAO_DOC', 'Data de publicação do documento ('||i_flf.dat_publicacao_doc||') esta em formato diferente do esperado (AAAAMMDD)');

        end if;

        if (i_flf.cod_moti_afast is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_MOTI_AFAST', 'Codigo informado para o motivo do afastamento não foi informado');
        elsif (i_flf.cod_moti_afast_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_MOTI_AFAST', 'Codigo informado para o motivo do afastamento ('||i_flf.cod_moti_afast||') não previsto');
        end if;

        if (i_flf.dat_ini_afast is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_AFAST', 'Data de inicio do afastamento não foi informada');
        else
            v_dat_ini := fnc_valida_data(i_flf.dat_ini_afast, 'RRRRMMDD');
            if ((length(i_flf.dat_ini_afast) < 8) or (v_dat_ini is null)) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_AFAST', 'Data de inicio do afastamento informada ('||i_flf.dat_ini_afast||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if (i_flf.dat_fim_afast_prevista is not null) then
            v_dat_fim_prev := fnc_valida_data(i_flf.dat_fim_afast_prevista, 'RRRRMMDD');
            if ((length(i_flf.dat_fim_afast_prevista) < 8) or (v_dat_fim_prev is null)) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_AFAST_PREVISTA', 'Data prevista de fim de afastamento informada ('||i_flf.dat_fim_afast_prevista||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if (i_flf.dat_fim_afast_efetiva is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_AFAST_EFETIVA', 'Data de fim do afastamento não foi informada');
        else
            v_dat_fim_efet := fnc_valida_data(i_flf.dat_fim_afast_efetiva, 'RRRRMMDD');
            if ((length(i_flf.dat_fim_afast_efetiva) < 8) or (v_dat_fim_efet is null)) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_AFAST_EFETIVA', 'Data de fim do afastamento informada ('||i_flf.dat_fim_afast_efetiva||') esta em formato diferente do esperado (AAAAMMDD)');
            end if;
        end if;

        if ((i_flf.cod_moti_fim_afast is not null) and (i_flf.cod_moti_fim_afast_int is null)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_MOTI_FIM_AFAST', 'Codigo informado para o motivo do fim do afastamento ('||i_flf.cod_moti_fim_afast||') não previsto');
        end if;

        if (i_flf.cod_moti_afast_int = '9999') then -- Ferias

            if (i_flf.ano_exerc_ferias is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ANO_EXERC_FERIAS', 'Ano de exercicio das ferias não foi informado');
            elsif (   (length(i_flf.ano_exerc_ferias) < 4)
                   or (fnc_valida_data(i_flf.ano_exerc_ferias, 'YYYY') is null)) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ANO_EXERC_FERIAS', 'Ano de exercicio das ferias informado ('||i_flf.ano_exerc_ferias||') esta em formato diferente do previsto');
            end if;

            if (i_flf.cod_situ_ferias_int is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_SITU_FERIAS', 'Codigo informado para situação das ferias ('||i_flf.cod_situ_ferias||') não previsto');
            end if;

        end if;

       if (v_dat_ini > v_dat_fim_prev) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_AFAST_PREVISTA', 'Data prevista de fim de afastamento ('||i_flf.dat_fim_afast_prevista||') e anterior a de inicio do afastamento ('||i_flf.dat_ini_afast||')');
        end if;

        if (v_dat_ini > v_dat_fim_efet) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_AFAST_EFETIVA', 'Data efetiva de fim de afastamento ('||i_flf.dat_fim_afast_efetiva||') e anterior a de inicio do afastamento ('||i_flf.dat_ini_afast||')');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_FLF;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_FAT (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_fat.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_FAT';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_FAT';
        v_tb_falta              tb_falta%rowtype;
        v_tb_relacao_funcional  tb_relacao_funcional%rowtype;
        v_num_seq_falta         tb_falta.num_seq_falta%type;
        v_dat_ini_falta         tb_falta.dat_ini_falta%type;
        v_dat_fim_falta         tb_falta.dat_fim_falta%type;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);
        v_id_servidor           number;
        v_cod_entidade          varchar2(20);
        v_cod_ide_cli           varchar2(20);
        v_cod_ide_Rel_func      tb_relacao_funcional.cod_ide_rel_func%type;

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for fat in (select a.cod_ins,
                                   trim(a.cod_entidade)    cod_entidade,
                                   trim(a.id_servidor)     id_servidor,
                                   trim(a.id_vinculo)      id_vinculo,
                                   trim(a.per_falta)       per_falta,
                                   trim(a.cod_tipo_falta)  cod_tipo_falta,
                                   fnc_codigo_ext(a.cod_ins, 2032, trim(a.cod_tipo_falta),   null, 'COD_PAR') cod_tipo_falta_int,
                                   trim(a.qtd_falta)       qtd_falta,
                                   a.id,
                                   a.num_linha_header,
                                   a.id_processo
                            from tb_carga_gen_fat a

                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id              := fat.id;

                    BEGIN

                        savepoint sp1;
                        --
                        -- separando entidade de id_header
                        v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(fat.id_servidor);
                        --v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(flf.cod_entidade,flf.id_servidor);
                        -- Pega cod_ide_cli da ident_ext_servidor
                        v_cod_ide_cli := fnc_ret_cod_ide_cli( fat.cod_ins, v_id_Servidor);
                        --
                        if FNC_VALIDA_PESSOA_FISICA(fat.cod_ins, v_cod_ide_cli) is not null then
                           raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                        end if;
                        --
                        v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,fat.id_vinculo);
                        --
                        v_result := FNC_VALIDA_FAT(fat, a_validar);
                        --
                        if (v_result is null) then

                            v_tb_relacao_funcional := null;

                            begin
                                select c.*
                                into v_tb_relacao_funcional
                                from tb_relacao_funcional  c
                                where c.cod_ins       = fat.cod_ins
                                   and c.cod_ide_cli   = v_cod_ide_cli
                                  and c.num_matricula = v_id_servidor
                                  and c.cod_ide_rel_func = v_cod_ide_rel_func;

                                 v_cod_entidade :=  v_tb_relacao_funcional.cod_entidade;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_tb_falta      := null;
                            v_num_seq_falta := null;
                            v_dat_ini_falta := fnc_valida_data(fnc_valida_numero(substr(fat.per_falta,3,6)), 'RRRRMM');
                            v_dat_fim_falta := v_dat_ini_falta + fnc_valida_numero(fat.qtd_falta);


                            begin
                                select *
                                into v_tb_falta
                                from tb_falta
                                where cod_ins          = fat.cod_ins
                                  and cod_ide_cli      = v_cod_ide_cli
                                  and cod_entidade     = v_cod_entidade
                                  and num_matricula    = v_id_servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and dat_ini_falta    = v_dat_ini_falta
                                  and cod_tipo_falta   = fat.cod_tipo_falta_int;
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_falta.cod_ins is not null) then -- registro ja existe em tb_falta, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_falta
                                    set dat_fim_falta   = v_dat_fim_falta,
                                        qtd_falta       = fnc_valida_numero(fat.qtd_falta),
                                        dat_ult_atu     = sysdate,
                                        nom_usu_ult_atu = user,
                                        nom_pro_ult_atu = v_nom_rotina
                                    where cod_ins          = v_tb_falta.cod_ins
                                      and cod_ide_cli      = v_tb_falta.cod_ide_cli
                                      and cod_entidade     = v_tb_falta.cod_entidade
                                      and num_matricula    = v_tb_falta.num_matricula
                                      and cod_ide_rel_func = v_tb_falta.cod_ide_rel_func
                                      and num_seq_falta    = v_tb_falta.num_seq_falta;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                v_num_seq_falta := SEQ_NUM_SEQ_FALTA.NEXTVAL;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_falta
                                        (COD_INS,             --  1
                                         COD_IDE_CLI,         --  2
                                         COD_ENTIDADE,        --  3
                                         COD_PCCS,            --  4
                                         COD_CARGO,           --  5
                                         NUM_MATRICULA,       --  6
                                         COD_IDE_REL_FUNC,    --  7
                                         NUM_SEQ_FALTA,       --  8
                                         DAT_INI_FALTA,       --  9
                                         DAT_FIM_FALTA,       -- 10
                                         QTD_FALTA,           -- 11
                                         COD_TIPO_FALTA,      -- 12
                                         DAT_ING,             -- 13
                                         DAT_ULT_ATU,         -- 14
                                         NOM_USU_ULT_ATU,     -- 15
                                         NOM_PRO_ULT_ATU)     -- 16
                                    values
                                        (fat.cod_ins,                              --  1 COD_INS
                                         v_cod_ide_cli,                          --  2 COD_IDE_CLI
                                         v_cod_entidade,                         --  3 COD_ENTIDADE
                                         v_tb_relacao_funcional.cod_pccs,         --  4 COD_PCCS
                                         v_tb_relacao_funcional.cod_cargo,        --  5 COD_CARGO
                                         v_id_servidor,                          --  6 NUM_MATRICULA
                                         v_cod_ide_rel_func, --  7 COD_IDE_REL_FUNC
                                         v_num_seq_falta,                          --  8 NUM_SEQ_FALTA
                                         v_dat_ini_falta,                          --  9 DAT_INI_FALTA
                                         v_dat_fim_falta,                          -- 10 DAT_FIM_FALTA
                                         fnc_valida_numero(fat.qtd_falta),         -- 11 QTD_FALTA
                                         fat.cod_tipo_falta_int,                   -- 12 COD_TIPO_FALTA
                                         sysdate,                                  -- 13 DAT_ING
                                         sysdate,                                  -- 14 DAT_ULT_ATU
                                         user,                                     -- 15 NOM_USU_ULT_ATU
                                         v_nom_rotina);                            -- 16 NOM_PRO_ULT_ATU
                                end if;

                            end if;

                            /*a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',          v_tb_falta.cod_ins,          fat.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',      v_tb_falta.cod_ide_cli,      fat.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',     v_tb_falta.cod_entidade,     fat.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',    v_tb_falta.num_matricula,    fat.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC', v_tb_falta.cod_ide_rel_func, nvl(v_tb_falta.cod_ide_rel_func, v_tb_relacao_funcional.cod_ide_rel_func));
                            SP_INCLUI_LOG(a_log, 'NUM_SEQ_FALTA',    v_tb_falta.num_seq_falta,    nvl(v_tb_falta.num_seq_falta, v_num_seq_falta));
                            SP_INCLUI_LOG(a_log, 'DAT_INI_FALTA',    to_char(v_tb_falta.dat_ini_falta, 'dd/mm/yyyy'), to_char(nvl(v_tb_falta.dat_ini_falta, v_dat_ini_falta), 'dd/mm/yyyy'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_FALTA',    to_char(v_tb_falta.dat_fim_falta, 'dd/mm/yyyy'), to_char(v_dat_fim_falta, 'dd/mm/yyyy'));
                            SP_INCLUI_LOG(a_log, 'QTD_FALTA',        v_tb_falta.qtd_falta,        fat.qtd_falta);
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_FALTA',   v_tb_falta.cod_tipo_falta,   nvl(v_tb_falta.cod_tipo_falta, fat.cod_tipo_falta_int));
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',         v_tb_falta.cod_pccs,         nvl(v_tb_falta.cod_pccs, v_tb_relacao_funcional.cod_pccs));
                            SP_INCLUI_LOG(a_log, 'COD_CARGO',        v_tb_falta.cod_cargo,        nvl(v_tb_falta.cod_cargo, v_tb_relacao_funcional.cod_cargo));

                            SP_GRAVA_LOG(i_id_header, fat.id_processo, fat.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_FALTA', v_nom_rotina, a_log);

                            */
                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fat.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, fat.id_processo, fat.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fat.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, fat.id_processo, fat.num_linha_header, v_nom_rotina, a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fat.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_FAT;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_FAT (i_fat       in     r_fat,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno       varchar2(2000);
        v_des_result    varchar2(4000);
        v_qtd_falta     number;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_fat.cod_ins, i_fat.cod_entidade);

        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_fat.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_fat.id_vinculo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo não foi informada');
        elsif (fnc_valida_numero(i_fat.id_vinculo) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo informada ('||i_fat.id_vinculo||') esta invalida');
        end if;

        if (i_fat.per_falta is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'PER_FALTA', 'Periodo de falta não foi informado');
        else
            if (fnc_valida_numero(i_fat.per_falta) is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'PER_FALTA', 'Periodo de falta informado ('||i_fat.per_falta||') não e um numero valido');
            elsif (fnc_valida_data(substr(i_fat.per_falta,3,6), 'RRRRMM') is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'PER_FALTA', 'Periodo de falta informado ('||i_fat.per_falta||') não corresponde a uma data');
            end if;
        end if;

        if (i_fat.cod_tipo_falta is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_FALTA', 'Tipo de falta não foi informado');
        elsif (fnc_valida_numero(i_fat.cod_tipo_falta_int) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_FALTA', 'Tipo de falta informado ('||i_fat.cod_tipo_falta||') não previsto');
        end if;

        if (i_fat.qtd_falta is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_FALTA', 'Quantidade de faltas não foi informado');
        else
            v_qtd_falta := fnc_valida_numero(i_fat.qtd_falta);
            if (v_qtd_falta is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_FALTA', 'Quantidade de falta informado ('||i_fat.cod_tipo_falta||') esta invalido');
            elsif (v_qtd_falta = 0) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_FALTA', 'Quantidade de falta informado ('||i_fat.cod_tipo_falta||') e zero');
            end if;
        end if;



        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_FAT;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_TEA (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_tea.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_TEA';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_TEA';
        v_tb_hist_carteira_trab tb_hist_carteira_trab%rowtype;
        v_id_log_erro number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for tea in (select a.cod_ins,
                                   trim(a.cod_entidade)          cod_entidade,
                                   trim(a.id_servidor)           id_servidor,
                                   trim(a.num_cnpj_emp_entidade) num_cnpj_emp_entidade,
                                   trim(a.nom_empregador)        nom_empregador,
                                   trim(a.dat_admissao)          dat_admissao,
                                   trim(a.dat_desligamento)      dat_desligamento,
                                   trim(a.dat_emi_certidao)      dat_emi_certidao,
                                   trim(a.num_certidao)          num_certidao,
                                   trim(a.nom_org_emi_certidao)  nom_org_emi_certidao,
                                   trim(a.cod_regime_proprio)    cod_regime_proprio,
                                   trim(a.flg_exc_sala_aula)     flg_exc_sala_aula,
                                   trim(a.qtd_tempo_liq_ano)     qtd_tempo_liq_ano,
                                   trim(a.qtd_tempo_liq_mes)     qtd_tempo_liq_mes,
                                   trim(a.qtd_tempo_liq_dia)     qtd_tempo_liq_dia,
                                   trim(a.qtd_tempo_averb_ano)   qtd_tempo_averb_ano,
                                   trim(a.qtd_tempo_averb_mes)   qtd_tempo_averb_mes,
                                   trim(a.qtd_tempo_averb_dia)   qtd_tempo_averb_dia,
                                   a.id, a.num_linha_header, a.id_processo,
                                   d.cod_ide_cli
                            from tb_carga_gen_tea a
                                left outer join tb_carga_gen_ident_ext d
                                    on      a.cod_ins      = d.cod_ins
                                        and a.id_servidor  = d.cod_ide_cli_ext
                                        and a.cod_entidade = d.cod_entidade
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id              := tea.id;

                    BEGIN

                        savepoint sp1;

                        if (tea.dat_admissao is not null and fnc_valida_numero(tea.dat_admissao) = 0) then
                            tea.dat_admissao := null;
                        end if;

                        if (tea.dat_desligamento is not null and fnc_valida_numero(tea.dat_desligamento) = 0) then
                            tea.dat_desligamento := null;
                        end if;

                        if (tea.dat_emi_certidao is not null and fnc_valida_numero(tea.dat_emi_certidao) = 0) then
                            tea.dat_emi_certidao := null;
                        end if;

                        v_result := FNC_VALIDA_TEA(tea, a_validar);

                        if (v_result is null) then

                            v_tb_hist_carteira_trab := null;

                            begin
                                select *
                                into v_tb_hist_carteira_trab
                                from tb_hist_carteira_trab
                                where cod_ins          = tea.cod_ins
                                  and cod_ide_cli      = tea.cod_ide_cli
                                  and cod_entidade     = tea.cod_entidade
                                  and num_certidao     = tea.num_certidao
                                  and num_cnpj_org_emp = tea.num_cnpj_emp_entidade
                                  and dat_adm_orig     = fnc_valida_data(tea.dat_admissao, 'RRRRMMDD')
                                  and dat_desl_orig    = fnc_valida_data(tea.dat_desligamento, 'RRRRMMDD');
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_hist_carteira_trab.cod_ins is not null) then -- registro ja existe em tb_hist_carteira_trab, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_hist_carteira_trab
                                    set nom_org_emp           = nvl(tea.nom_empregador, nom_org_emp),
                                        dat_exp_cert          = nvl(fnc_valida_data(tea.dat_emi_certidao, 'RRRRMMDD'), dat_exp_cert),
                                        nom_org_exp_cert      = nvl(tea.nom_org_emi_certidao, nom_org_exp_cert),
                                        cod_reg_proprio       = nvl(upper(tea.cod_regime_proprio), cod_reg_proprio),
                                        flg_exc_sala_aula     = tea.flg_exc_sala_aula,
                                        qtd_tmp_liq_ano       = nvl(fnc_valida_numero(tea.qtd_tempo_liq_ano), qtd_tmp_liq_ano),
                                        qtd_tmp_liq_mes       = nvl(fnc_valida_numero(tea.qtd_tempo_liq_mes), qtd_tmp_liq_mes),
                                        qtd_tmp_liq_dia       = nvl(fnc_valida_numero(tea.qtd_tempo_liq_dia), qtd_tmp_liq_dia),
                                        qtd_tmp_ave_ano       = nvl(fnc_valida_numero(tea.qtd_tempo_averb_ano), qtd_tmp_ave_ano),
                                        qtd_tmp_ave_mes       = nvl(fnc_valida_numero(tea.qtd_tempo_averb_mes), qtd_tmp_ave_mes),
                                        qtd_tmp_ave_dia       = nvl(fnc_valida_numero(tea.qtd_tempo_averb_dia), qtd_tmp_ave_dia),
                                        dat_ult_atu           = sysdate,
                                        nom_usu_ult_atu       = user,
                                        nom_pro_ult_atu       = v_nom_rotina
                                    where cod_ins          = v_tb_hist_carteira_trab.cod_ins
                                      and cod_ide_cli      = v_tb_hist_carteira_trab.cod_ide_cli
                                      and cod_entidade     = v_tb_hist_carteira_trab.cod_entidade
                                      and num_certidao     = v_tb_hist_carteira_trab.num_certidao
                                      and num_cnpj_org_emp = v_tb_hist_carteira_trab.num_cnpj_org_emp
                                      and dat_adm_orig     = v_tb_hist_carteira_trab.dat_adm_orig
                                      and dat_desl_orig    = v_tb_hist_carteira_trab.dat_desl_orig;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_hist_carteira_trab
                                        (COD_INS,                    --  1
                                         COD_IDE_CLI,                --  2
                                         COD_ENTIDADE,               --  3
                                         NUM_CERTIDAO,               --  4
                                         DAT_EXP_CERT,               --  5
                                         NOM_ORG_EXP_CERT,           --  6
                                         NOM_ORG_EMP,                --  7
                                         NUM_CNPJ_ORG_EMP,           --  8
                                         DAT_ADM_ORIG,               --  9
                                         DAT_DESL_ORIG,              -- 10
                                         QTD_TMP_LIQ_ANO,            -- 11
                                         QTD_TMP_LIQ_MES,            -- 12
                                         QTD_TMP_LIQ_DIA,            -- 13
                                         QTD_TMP_AVE_ANO,            -- 14
                                         QTD_TMP_AVE_MES,            -- 15
                                         QTD_TMP_AVE_DIA,            -- 16
                                         FLG_EXC_SALA_AULA,          -- 17
                                         DAT_ING,                    -- 18
                                         DAT_ULT_ATU,                -- 19
                                         NOM_USU_ULT_ATU,            -- 20
                                         NOM_PRO_ULT_ATU,            -- 21
                                         COD_REG_PROPRIO)            -- 22
                                    values
                                        (tea.cod_ins,                   --  1 COD_INS
                                         tea.cod_ide_cli,               --  2 COD_IDE_CLI
                                         tea.cod_entidade,              --  3 COD_ENTIDADE
                                         tea.num_certidao,              --  4 NUM_CERTIDAO
                                         fnc_valida_data(tea.dat_emi_certidao, 'RRRRMMDD'),  --  5 DAT_EXP_CERT
                                         tea.nom_org_emi_certidao,      --  6 NOM_ORG_EXP_CERT
                                         tea.nom_empregador,            --  7 NOM_ORG_EMP
                                         tea.num_cnpj_emp_entidade,     --  8 NUM_CNPJ_ORG_EMP
                                         fnc_valida_data(tea.dat_admissao, 'RRRRMMDD'),      --  9 DAT_ADM_ORIG
                                         fnc_valida_data(tea.dat_desligamento, 'RRRRMMDD'),  -- 10 DAT_DESL_ORIG
                                         tea.qtd_tempo_liq_ano,         -- 11 QTD_TMP_LIQ_ANO
                                         tea.qtd_tempo_liq_mes,         -- 12 QTD_TMP_LIQ_MES
                                         tea.qtd_tempo_liq_dia,         -- 13 QTD_TMP_LIQ_DIA
                                         tea.qtd_tempo_averb_ano,       -- 14 QTD_TMP_AVE_ANO
                                         tea.qtd_tempo_averb_mes,       -- 15 QTD_TMP_AVE_MES
                                         tea.qtd_tempo_averb_dia,       -- 16 QTD_TMP_AVE_DIA
                                         tea.flg_exc_sala_aula,         -- 17 FLG_EXC_SALA_AULA
                                         sysdate,                       -- 18 DAT_ING
                                         sysdate,                       -- 19 DAT_ULT_ATU
                                         user,                          -- 20 NOM_USU_ULT_ATU
                                         v_nom_rotina,                  -- 21 NOM_PRO_ULT_ATU
                                         tea.cod_regime_proprio);       -- 22 COD_REG_PROPRIO
                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',           v_tb_hist_carteira_trab.cod_ins,           tea.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',       v_tb_hist_carteira_trab.cod_ide_cli,       tea.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',      v_tb_hist_carteira_trab.cod_entidade,      tea.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'NUM_CERTIDAO',      v_tb_hist_carteira_trab.num_certidao,      tea.num_certidao);
                            SP_INCLUI_LOG(a_log, 'DAT_EXP_CERT',      to_char(v_tb_hist_carteira_trab.dat_exp_cert, 'dd/mm/yyyy hh24:mi'),  to_char(nvl(fnc_valida_data(tea.dat_emi_certidao, 'RRRRMMDD'), v_tb_hist_carteira_trab.dat_exp_cert), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'NOM_ORG_EXP_CERT',  v_tb_hist_carteira_trab.nom_org_exp_cert,  nvl(tea.nom_org_emi_certidao, v_tb_hist_carteira_trab.nom_org_exp_cert));
                            SP_INCLUI_LOG(a_log, 'NOM_ORG_EMP',       v_tb_hist_carteira_trab.nom_org_emp,       nvl(tea.nom_empregador, v_tb_hist_carteira_trab.nom_org_emp));
                            SP_INCLUI_LOG(a_log, 'NUM_CNPJ_ORG_EMP',  v_tb_hist_carteira_trab.num_cnpj_org_emp,  tea.num_cnpj_emp_entidade);
                            SP_INCLUI_LOG(a_log, 'DAT_ADM_ORIG',      to_char(v_tb_hist_carteira_trab.dat_adm_orig, 'dd/mm/yyyy hh24:mi'),  to_char(fnc_valida_data(tea.dat_admissao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_DESL_ORIG',     to_char(v_tb_hist_carteira_trab.DAT_DESL_ORIG, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(tea.dat_desligamento, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'QTD_TMP_LIQ_ANO',   v_tb_hist_carteira_trab.qtd_tmp_liq_ano,   nvl(tea.qtd_tempo_liq_ano, v_tb_hist_carteira_trab.qtd_tmp_liq_ano));
                            SP_INCLUI_LOG(a_log, 'QTD_TMP_LIQ_MES',   v_tb_hist_carteira_trab.qtd_tmp_liq_mes,   nvl(tea.qtd_tempo_liq_mes, v_tb_hist_carteira_trab.qtd_tmp_liq_mes));
                            SP_INCLUI_LOG(a_log, 'QTD_TMP_LIQ_DIA',   v_tb_hist_carteira_trab.qtd_tmp_liq_dia,   nvl(tea.qtd_tempo_liq_dia, v_tb_hist_carteira_trab.qtd_tmp_liq_dia));
                            SP_INCLUI_LOG(a_log, 'QTD_TMP_AVE_ANO',   v_tb_hist_carteira_trab.qtd_tmp_ave_ano,   nvl(tea.qtd_tempo_averb_ano, v_tb_hist_carteira_trab.qtd_tmp_ave_ano));
                            SP_INCLUI_LOG(a_log, 'QTD_TMP_AVE_MES',   v_tb_hist_carteira_trab.qtd_tmp_ave_mes,   nvl(tea.qtd_tempo_averb_mes, v_tb_hist_carteira_trab.qtd_tmp_ave_mes));
                            SP_INCLUI_LOG(a_log, 'QTD_TMP_AVE_DIA',   v_tb_hist_carteira_trab.qtd_tmp_ave_dia,   nvl(tea.qtd_tempo_averb_dia, v_tb_hist_carteira_trab.qtd_tmp_ave_dia));
                            SP_INCLUI_LOG(a_log, 'FLG_EXC_SALA_AULA', v_tb_hist_carteira_trab.flg_exc_sala_aula, tea.flg_exc_sala_aula);
                            SP_INCLUI_LOG(a_log, 'COD_REG_PROPRIO',   v_tb_hist_carteira_trab.cod_reg_proprio,   nvl(tea.cod_regime_proprio, v_tb_hist_carteira_trab.cod_reg_proprio));

                            SP_GRAVA_LOG(i_id_header, tea.id_processo, tea.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_HIST_CARTEIRA_TRAB', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, tea.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, tea.id_processo, tea.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, tea.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, tea.id_processo, tea.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, tea.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_TEA;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_TEA (i_tea       in     r_tea,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_admissao                  date;
        v_dat_desligamento              date;
        v_dat_emi_certidao              date;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_tea.cod_ins, i_tea.cod_entidade);
        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_tea.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_tea.num_cnpj_emp_entidade is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'NUM_CNPJ_EMP_ENTIDADE', 'não foi informado o CNPJ da Empresa/Entidade a que corresponde o tempo de trabalho em quest?o');
        elsif (length(i_tea.num_cnpj_emp_entidade) < 14 or fnc_valida_numero(i_tea.num_cnpj_emp_entidade) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'NUM_CNPJ_EMP_ENTIDADE', 'O CNPJ da Empresa/Entidade a que corresponde o tempo de trabalho em quest?o ('||i_tea.num_cnpj_emp_entidade||') esta invalido');
        end if;

        if (i_tea.dat_admissao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_ADMISSAO', 'Data de admissão não foi informada');
        else
            v_dat_admissao := fnc_valida_data(i_tea.dat_admissao, 'RRRRMMDD');
            if (length(i_tea.dat_admissao) < 8 or v_dat_admissao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_ADMISSAO', 'Data de admissão informada ('||i_tea.dat_admissao||') esta invalida');
            end if;
        end if;

        if (i_tea.dat_desligamento is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_DESLIGAMENTO', 'Data de desligamento não foi informada');
        else
            v_dat_desligamento := fnc_valida_data(i_tea.dat_desligamento, 'RRRRMMDD');
            if (length(i_tea.dat_desligamento) < 8 or v_dat_desligamento is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_DESLIGAMENTO', 'Data de desligamento informada ('||i_tea.dat_desligamento||') esta invalida');
            end if;
        end if;

        if (i_tea.dat_emi_certidao is not null) then
            v_dat_emi_certidao := fnc_valida_data(i_tea.dat_emi_certidao, 'RRRRMMDD');
            if (length(i_tea.dat_emi_certidao) < 8 or v_dat_emi_certidao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_CERTIDAO', 'Data de expedição da certid?o informada ('||i_tea.dat_emi_certidao||') esta invalida');
            end if;
        end if;

        if (v_dat_admissao > v_dat_desligamento) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_DESLIGAMENTO', 'Data de desligamento ('||i_tea.dat_desligamento||') e anterior a data de admissão ('||i_tea.dat_admissao||')');
        end if;

        if (v_dat_emi_certidao is not null and v_dat_emi_certidao < v_dat_desligamento) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_EMI_CERTIDAO', 'Data de expedição da certid?o ('||i_tea.dat_emi_certidao||') e posterior a data de desligamento ('||i_tea.dat_desligamento||')');
        end if;

        if (i_tea.num_certidao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'NUM_CERTIDAO', 'Numero da certid?o não foi informado');
        end if;

        if (i_tea.cod_regime_proprio is not null and upper(i_tea.cod_regime_proprio) not in ('S', 'N', 'T')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_REGIME_PROPRIO', 'Indicação de Regime Proprio ('||i_tea.cod_regime_proprio||') esta invalida. Os valores permitidos s?o (''S'', ''N'', ''T'')');
        end if;

        if (i_tea.flg_exc_sala_aula is null ) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_EXC_SALA_AULA', 'Indicação de cargo exclusivo em sala de aula não foi informada');
        elsif (upper(i_tea.flg_exc_sala_aula) not in ('S', 'N')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_EXC_SALA_AULA', 'Indicação de cargo exclusivo em sala de aula ('||i_tea.flg_exc_sala_aula||') esta invalida. Os valores permitidos s?o (''S'', ''N'')');
        end if;

        if (i_tea.qtd_tempo_liq_ano is not null and fnc_valida_numero(i_tea.qtd_tempo_liq_ano) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_TEMPO_LIQ_ANO', 'Quantidade informada para o tempo liquido em anos ('||i_tea.qtd_tempo_liq_ano||') esta invalida');
        end if;

        if (i_tea.qtd_tempo_liq_mes is not null and fnc_valida_numero(i_tea.qtd_tempo_liq_mes) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_TEMPO_LIQ_MES', 'Quantidade informada para o tempo liquido em meses ('||i_tea.qtd_tempo_liq_mes||') esta invalida');
        end if;

        if (i_tea.qtd_tempo_liq_dia is not null and fnc_valida_numero(i_tea.qtd_tempo_liq_dia) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_TEMPO_LIQ_DIA', 'Quantidade informada para o tempo liquido em dias ('||i_tea.qtd_tempo_liq_dia||') esta invalida');
        end if;

        if (i_tea.qtd_tempo_averb_ano is not null and fnc_valida_numero(i_tea.qtd_tempo_averb_ano) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_TEMPO_AVERB_ANO', 'Quantidade informada para o tempo averbado em anos ('||i_tea.qtd_tempo_averb_ano||') esta invalida');
        end if;

        if (i_tea.qtd_tempo_averb_mes is not null and fnc_valida_numero(i_tea.qtd_tempo_averb_mes) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_TEMPO_AVERB_MES', 'Quantidade informada para o tempo averbado em meses ('||i_tea.qtd_tempo_averb_mes||') esta invalida');
        end if;

        if (i_tea.qtd_tempo_averb_dia is not null and fnc_valida_numero(i_tea.qtd_tempo_averb_dia) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'QTD_TEMPO_AVERB_DIA', 'Quantidade informada para o tempo averbado em dias ('||i_tea.qtd_tempo_averb_dia||') esta invalida');
        end if;

        if (i_tea.cod_ide_cli is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_TEA;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_FPE (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_fpe.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_FPE';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_FPE';
        v_tb_penalidade         tb_penalidade%rowtype;
        v_cod_cargo             tb_rel_func_periodo_exerc.cod_cargo%type;
        v_cod_pccs              tb_rel_func_periodo_exerc.cod_pccs%type;
        v_cod_ide_rel_func      tb_rel_func_periodo_exerc.cod_ide_rel_func%type;
        v_num_seq_pen           tb_penalidade.num_seq_pen%type;
        v_id_log_erro number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for fpe in (select a.cod_ins,
                                   trim(a.cod_entidade)                cod_entidade,
                                   trim(a.id_servidor)                 id_servidor,
                                   trim(a.id_vinculo)                  id_vinculo,
                                   trim(a.cod_tipo_doc)                cod_tipo_doc,
                                   fnc_codigo_ext(a.cod_ins, 2019, trim(a.cod_tipo_doc),   null, 'cod_par') cod_tipo_doc_int,
                                   trim(a.num_doc)                     num_doc,
                                   trim(a.dat_publicacao)              dat_publicacao,
                                   trim(a.dat_ini_efeito)              dat_ini_efeito,
                                   trim(a.dat_fim_efeito)              dat_fim_efeito,
                                   trim(upper(a.flg_convertida_multa)) flg_convertida_multa,
                                   trim(upper(a.flg_suspende_pgto))    flg_suspende_pgto,
                                   trim(upper(a.flg_absolvido))        flg_absolvido,
                                   trim(a.vlr_multa)                   vlr_multa,
                                   trim(a.cod_tipo_penalidade)         cod_tipo_penalidade,
                                   fnc_codigo_ext(a.cod_ins, 2035, trim(a.cod_tipo_penalidade),   null, 'cod_par') cod_tipo_penalidade_int,
                                   trim(a.des_penalidade)              des_penalidade,
                                   a.id, a.num_linha_header, a.id_processo,
                                   d.cod_ide_cli
                            from tb_carga_gen_fpe a
                                left outer join tb_carga_gen_ident_ext d
                                    on      a.cod_ins      = d.cod_ins
                                        and a.id_servidor  = d.cod_ide_cli_ext
                                        and a.cod_entidade = d.cod_entidade
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id := fpe.id;

                    BEGIN

                        savepoint sp1;

                        if (fpe.dat_publicacao is not null and fnc_valida_numero(fpe.dat_publicacao) = 0) then
                            fpe.dat_publicacao := null;
                        end if;

                        if (fpe.dat_ini_efeito is not null and fnc_valida_numero(fpe.dat_ini_efeito) = 0) then
                            fpe.dat_ini_efeito := null;
                        end if;

                        if (fpe.dat_fim_efeito is not null and fnc_valida_numero(fpe.dat_fim_efeito) = 0) then
                            fpe.dat_fim_efeito := null;
                        end if;

                        v_result := FNC_VALIDA_FPE(fpe, a_validar);

                        if (v_result is null) then

                            v_cod_cargo := null;
                            v_cod_pccs  := null;

                            begin
                                select cod_cargo, cod_pccs, cod_ide_rel_func
                                into   v_cod_cargo, v_cod_pccs, v_cod_ide_rel_func
                                from tb_rel_func_periodo_exerc
                                where cod_ins       = fpe.cod_ins
                                  and cod_ide_cli   = fpe.cod_ide_cli
                                  and cod_entidade  = fpe.cod_entidade
                                  and dat_ini_exerc <= fnc_valida_data(fpe.dat_ini_efeito, 'RRRRMMDD')
                                  and (   dat_fim_exerc is null
                                       or dat_fim_exerc >= fnc_valida_data(fpe.dat_ini_efeito, 'RRRRMMDD'))
                                  and rownum        <= 1;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', 'não foi possivel localizar o codigo do Cargo', 'Codigo do Cargo');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_REL_FUNC', 'não foi possivel localizar o codigo identificador da relação funcional', 'Codigo Identificador da Relação Funcional');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', substr('Erro ao verificar codigo do Cargo: '||sqlerrm, 1, 4000), 'Codigo do Cargo');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_REL_FUNC', substr('Erro ao verificar codigo identificador da relação funcional: '||sqlerrm, 1, 4000), 'Codigo Identificador da Relação Funcional');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_num_seq_pen := null;
                            v_tb_penalidade := null;

                            begin
                                select *
                                into v_tb_penalidade
                                from tb_penalidade
                                where cod_ins          = fpe.cod_ins
                                  and cod_ide_cli      = fpe.cod_ide_cli
                                  and cod_entidade     = fpe.cod_entidade
                                  and num_matricula    = fpe.id_servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and dat_ini_pen      = fnc_valida_data(fpe.dat_ini_efeito, 'RRRRMMDD');
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_penalidade.cod_ins is not null) then -- registro ja existe em tb_penalidade, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                    update tb_penalidade
                                    set cod_tipo_pen        = fpe.cod_tipo_penalidade_int,
                                        dat_fim_pen         = fnc_valida_data(fpe.dat_fim_efeito, 'RRRRMMDD'),
                                        dat_pub_pen         = nvl(fnc_valida_data(fpe.dat_publicacao, 'RRRRMMDD'), dat_pub_pen),
                                        des_pen             = nvl(substr(fpe.des_penalidade, 1, 500), des_pen),
                                        flg_convert_multa   = nvl(fpe.flg_convertida_multa, flg_convert_multa),
                                        val_multa           = nvl(fnc_valida_numero(fpe.vlr_multa)/10000, val_multa),
                                        flg_susp_pag        = nvl(fpe.flg_suspende_pgto, flg_susp_pag),
                                        flg_absolvido       = fpe.flg_absolvido,
                                        cod_tipo_doc_assoc  = nvl(fpe.cod_tipo_doc_int, cod_tipo_doc_assoc),
                                        num_doc_assoc       = nvl(fpe.num_doc, num_doc_assoc),
                                        dat_ult_atu         = sysdate,
                                        nom_usu_ult_atu     = user,
                                        nom_pro_ult_atu     = v_nom_rotina
                                    where cod_ins          = v_tb_penalidade.cod_ins
                                      and cod_ide_cli      = v_tb_penalidade.cod_ide_cli
                                      and cod_entidade     = v_tb_penalidade.cod_entidade
                                      and num_matricula    = v_tb_penalidade.num_matricula
                                      and cod_ide_rel_func = v_tb_penalidade.cod_ide_rel_func
                                      and num_seq_pen      = v_tb_penalidade.num_seq_pen
                                      and dat_ini_pen      = v_tb_penalidade.dat_ini_pen;
                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                begin
                                    select max(num_seq_pen)
                                    into v_num_seq_pen
                                    from tb_penalidade
                                    where cod_ins          = fpe.cod_ins
                                      and cod_ide_cli      = fpe.cod_ide_cli
                                      and cod_entidade     = fpe.cod_entidade
                                      and num_matricula    = fpe.id_servidor
                                      and cod_ide_rel_func = v_cod_ide_rel_func;
                                exception
                                    when others then
                                        null;
                                end;

                                v_num_seq_pen := nvl(v_num_seq_pen, 0) + 1;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_penalidade
                                        (COD_INS,            --  1
                                         COD_IDE_CLI,        --  2
                                         COD_ENTIDADE,       --  3
                                         COD_PCCS,           --  4
                                         COD_CARGO,          --  5
                                         NUM_MATRICULA,      --  6
                                         COD_IDE_REL_FUNC,   --  7
                                         NUM_SEQ_PEN,        --  8
                                         COD_TIPO_PEN,       --  9
                                         DAT_INI_PEN,        -- 10
                                         DAT_FIM_PEN,        -- 11
                                         DAT_PUB_PEN,        -- 12
                                         DES_PEN,            -- 13
                                         FLG_CONVERT_MULTA,  -- 14
                                         VAL_MULTA,          -- 15
                                         FLG_SUSP_PAG,       -- 16
                                         FLG_ABSOLVIDO,      -- 17
                                         DAT_ING,            -- 18
                                         DAT_ULT_ATU,        -- 19
                                         NOM_USU_ULT_ATU,    -- 20
                                         NOM_PRO_ULT_ATU,    -- 21
                                         FLG_DESCONTA,       -- 22
                                         QTD_PENALIDADE,     -- 23
                                         FLG_DESC_APO_ESP,   -- 24
                                         COD_TIPO_DOC_ASSOC, -- 25
                                         NUM_DOC_ASSOC)      -- 26
                                    values
                                        (fpe.cod_ins,                                     --  1 COD_INS
                                         fpe.cod_ide_cli,                                 --  2 COD_IDE_CLI
                                         fpe.cod_entidade,                                --  3 COD_ENTIDADE
                                         v_cod_pccs,                                      --  4 COD_PCCS
                                         v_cod_cargo,                                     --  5 COD_CARGO
                                         fpe.id_servidor,                                 --  6 NUM_MATRICULA
                                         v_cod_ide_rel_func,                              --  7 COD_IDE_REL_FUNC
                                         v_num_seq_pen,                                   --  8 NUM_SEQ_PEN
                                         fpe.cod_tipo_penalidade_int,                     --  9 COD_TIPO_PEN
                                         fnc_valida_data(fpe.dat_ini_efeito, 'RRRRMMDD'), -- 10 DAT_INI_PEN
                                         fnc_valida_data(fpe.dat_fim_efeito, 'RRRRMMDD'), -- 11 DAT_FIM_PEN
                                         fnc_valida_data(fpe.dat_publicacao, 'RRRRMMDD'), -- 12 DAT_PUB_PEN
                                         substr(fpe.des_penalidade, 500),                 -- 13 DES_PEN
                                         fpe.flg_convertida_multa,                        -- 14 FLG_CONVERT_MULTA
                                         fnc_valida_numero(fpe.vlr_multa)/10000,           -- 15 VAL_MULTA
                                         fpe.flg_suspende_pgto,                           -- 16 FLG_SUSP_PAG
                                         fpe.flg_absolvido,                               -- 17 FLG_ABSOLVIDO
                                         sysdate,                                         -- 18 DAT_ING
                                         sysdate,                                         -- 19 DAT_ULT_ATU
                                         user,                                            -- 20 NOM_USU_ULT_ATU
                                         v_nom_rotina,                                    -- 21 NOM_PRO_ULT_ATU
                                         null,                                            -- 22 FLG_DESCONTA
                                         null,                                            -- 23 QTD_PENALIDADE
                                         null,                                            -- 24 FLG_DESC_APO_ESP
                                         fpe.cod_tipo_doc_int,                            -- 25 COD_TIPO_DOC_ASSOC
                                         fpe.num_doc);                                    -- 26 NUM_DOC_ASSOC

                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',            v_tb_penalidade.cod_ins,            fpe.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',        v_tb_penalidade.cod_ide_cli,        fpe.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',       v_tb_penalidade.cod_entidade,       fpe.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',           v_tb_penalidade.cod_pccs,           nvl(v_cod_pccs, v_tb_penalidade.cod_pccs));
                            SP_INCLUI_LOG(a_log, 'COD_CARGO',          v_tb_penalidade.cod_cargo,          nvl(v_cod_cargo, v_tb_penalidade.cod_cargo));
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',      v_tb_penalidade.num_matricula,      fpe.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',   v_tb_penalidade.cod_ide_rel_func,   v_cod_ide_rel_func);
                            SP_INCLUI_LOG(a_log, 'NUM_SEQ_PEN',        v_tb_penalidade.num_seq_pen,        nvl(v_num_seq_pen, v_tb_penalidade.num_seq_pen));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_PEN',       v_tb_penalidade.cod_tipo_pen,       fpe.cod_tipo_penalidade_int);
                            SP_INCLUI_LOG(a_log, 'DES_PEN',            v_tb_penalidade.des_pen,            nvl(substr(fpe.des_penalidade, 1, 500), v_tb_penalidade.des_pen));
                            SP_INCLUI_LOG(a_log, 'FLG_CONVERT_MULTA',  v_tb_penalidade.flg_convert_multa,  nvl(fpe.flg_convertida_multa, v_tb_penalidade.flg_convert_multa));
                            SP_INCLUI_LOG(a_log, 'VAL_MULTA',          v_tb_penalidade.val_multa,          nvl(fnc_valida_numero(fpe.vlr_multa)/10000, v_tb_penalidade.val_multa));
                            SP_INCLUI_LOG(a_log, 'FLG_SUSP_PAG',       v_tb_penalidade.flg_susp_pag,       nvl(fpe.flg_suspende_pgto, v_tb_penalidade.flg_susp_pag));
                            SP_INCLUI_LOG(a_log, 'FLG_ABSOLVIDO',      v_tb_penalidade.flg_absolvido,      fpe.flg_absolvido);
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC', v_tb_penalidade.cod_tipo_doc_assoc, nvl(fpe.cod_tipo_doc_int, v_tb_penalidade.cod_tipo_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',      v_tb_penalidade.num_doc_assoc,      nvl(fpe.num_doc, v_tb_penalidade.num_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'DAT_INI_PEN',        to_char(v_tb_penalidade.dat_ini_pen, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(fpe.dat_ini_efeito, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_PEN',        to_char(v_tb_penalidade.dat_fim_pen, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(fpe.dat_fim_efeito, 'RRRRMMDD'), v_tb_penalidade.dat_fim_pen), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_PUB_PEN',        to_char(v_tb_penalidade.dat_pub_pen, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(fpe.dat_publicacao, 'RRRRMMDD'), v_tb_penalidade.dat_pub_pen), 'dd/mm/yyyy hh24:mi'));

                            SP_GRAVA_LOG(i_id_header, fpe.id_processo, fpe.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_PENALIDADE', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fpe.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, fpe.id_processo, fpe.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fpe.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, fpe.id_processo, fpe.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fpe.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_FPE;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_FPE (i_fpe       in     r_fpe,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_publicacao                date;
        v_dat_ini_efeito                date;
        v_dat_fim_efeito                date;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_fpe.cod_ins, i_fpe.cod_entidade);
        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_fpe.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_fpe.id_vinculo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo não foi informada');
        elsif (fnc_valida_numero(i_fpe.id_vinculo) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo informada ('||i_fpe.id_vinculo||') esta invalida');
        end if;

        if ((i_fpe.cod_tipo_doc is not null) and (i_fpe.cod_tipo_doc_int is null)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_DOC', 'Codigo informado para o tipo de documento ('||i_fpe.cod_tipo_doc||') não previsto');
        end if;

        if (i_fpe.dat_publicacao is not null) then
            v_dat_publicacao := fnc_valida_data(i_fpe.dat_publicacao, 'RRRRMMDD');
            if (length(i_fpe.dat_publicacao) < 8 or v_dat_publicacao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_PUBLICACAO', 'Data de publicação informada ('||i_fpe.dat_publicacao||') esta invalida');
            end if;
        end if;

        if (i_fpe.dat_ini_efeito is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_EFEITO', 'Data de inicio de efeito da penalidade não foi informada');
        else
            v_dat_ini_efeito := fnc_valida_data(i_fpe.dat_ini_efeito, 'RRRRMMDD');
            if (length(i_fpe.dat_ini_efeito) < 8 or v_dat_ini_efeito is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_EFEITO', 'Data de inicio de efeito da penalidade informada ('||i_fpe.dat_ini_efeito||') esta invalida');
            end if;
        end if;

        if (i_fpe.dat_fim_efeito is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_EFEITO', 'Data de fim de efeito da penalidade não foi informada');
        else
            v_dat_fim_efeito := fnc_valida_data(i_fpe.dat_fim_efeito, 'RRRRMMDD');
            if (length(i_fpe.dat_fim_efeito) < 8 or v_dat_fim_efeito is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_EFEITO', 'Data de fim de efeito da penalidade informada ('||i_fpe.dat_fim_efeito||') esta invalida');
            end if;
        end if;

        if (i_fpe.flg_convertida_multa is not null and upper(i_fpe.flg_convertida_multa) not in ('S', 'N')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_CONVERTIDA_MULTA', 'Indicador de penalidade convertida em multa ('||i_fpe.flg_convertida_multa||') não previsto. Esperado ''S'' ou ''N''');
        end if;

        if (i_fpe.flg_suspende_pgto is not null and upper(i_fpe.flg_suspende_pgto) not in ('S', 'N')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_SUSPENDE_PGTO', 'Indicador de suspens?o do pagamento ('||i_fpe.flg_suspende_pgto||') não previsto. Esperado ''S'' ou ''N''');
        end if;

        if (i_fpe.flg_absolvido is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_ABSOLVIDO', 'Indicador de absolvição não foi informado');
        elsif (upper(i_fpe.flg_absolvido) not in ('S', 'N')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'FLG_ABSOLVIDO', 'Indicador de absolvição ('||i_fpe.flg_absolvido||') não previsto. Esperado ''S'' ou ''N''');
        end if;

        if (i_fpe.vlr_multa is not null and fnc_valida_numero(i_fpe.vlr_multa) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VLR_MULTA', 'Valor da multa informado ('||i_fpe.vlr_multa||') esta invalido');
        end if;

        if (i_fpe.cod_tipo_penalidade is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_PENALIDADE', 'Codigo do tipo de penalidade não foi informado');
        elsif (i_fpe.cod_tipo_penalidade_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_PENALIDADE', 'Codigo informado para o tipo de penalidade ('||i_fpe.cod_tipo_penalidade||') não previsto');
        end if;

        if (v_dat_ini_efeito is not null and v_dat_fim_efeito is not null and v_dat_ini_efeito > v_dat_fim_efeito) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_EFEITO', 'Data de fim do efeito da penalidade ('||i_fpe.dat_fim_efeito||') e anterior a data de inicio do efeito ('||i_fpe.dat_ini_efeito||')');
        end if;

        if (i_fpe.cod_ide_cli is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_FPE;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_CES (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_ces.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_CES';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_CES';
        v_tb_cessao             tb_cessao%rowtype;
        v_cod_cargo             tb_rel_func_periodo_exerc.cod_cargo%type;
        v_cod_pccs              tb_rel_func_periodo_exerc.cod_pccs%type;
        v_cod_ide_rel_func      tb_rel_func_periodo_exerc.cod_ide_rel_func%type;
        v_nom_entidade_destino  tb_cessao.nom_entidade_externa_dest%type;
        v_num_seq_transf        tb_cessao.num_seq_transf%type;
        v_id_log_erro number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for ces in (select a.cod_ins,
                                   trim(a.cod_entidade)         cod_entidade,
                                   trim(a.id_servidor)          id_servidor,
                                   trim(a.id_vinculo)           id_vinculo,
                                   trim(a.cod_tipo_doc)         cod_tipo_doc,
                                   fnc_codigo_ext(a.cod_ins, 2019, trim(a.cod_tipo_doc),   null, 'cod_par') cod_tipo_doc_int,
                                   trim(a.num_doc)              num_doc,
                                   trim(a.dat_publicacao_doc)   dat_publicacao_doc,
                                   trim(a.cod_tipo_cessao)      cod_tipo_cessao,
                                   fnc_codigo_ext(a.cod_ins, 2125, trim(a.cod_tipo_cessao),   null, 'cod_par') cod_tipo_cessao_int,
                                   trim(a.cod_natureza_cessao)  cod_natureza_cessao,
                                   fnc_codigo_ext(a.cod_ins, 2126, trim(a.cod_natureza_cessao),   null, 'cod_par') cod_natureza_cessao_int,
                                   trim(a.cod_entidade_destino) cod_entidade_destino,
                                   trim(a.nom_entidade_destino) nom_entidade_destino,
                                   trim(a.dat_ini_cessao)       dat_ini_cessao,
                                   trim(a.dat_fim_cessao)       dat_fim_cessao,
                                   a.id, a.num_linha_header, a.id_processo,
                                   d.cod_ide_cli
                            from tb_carga_gen_ces a
                                left outer join tb_carga_gen_ident_ext d
                                    on      a.cod_ins      = d.cod_ins
                                        and a.id_servidor  = d.cod_ide_cli_ext
                                        and a.cod_entidade = d.cod_entidade
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id := ces.id;

                    BEGIN

                        savepoint sp1;

                        if (ces.dat_publicacao_doc is not null and fnc_valida_numero(ces.dat_publicacao_doc) = 0) then
                            ces.dat_publicacao_doc := null;
                        end if;

                        if (ces.dat_ini_cessao is not null and fnc_valida_numero(ces.dat_ini_cessao) = 0) then
                            ces.dat_ini_cessao := null;
                        end if;

                        if (ces.dat_fim_cessao is not null and fnc_valida_numero(ces.dat_fim_cessao) = 0) then
                            ces.dat_fim_cessao := null;
                        end if;

                        v_result := FNC_VALIDA_CES(ces, a_validar);

                        if (v_result is null) then

                            v_cod_cargo := null;
                            v_cod_pccs  := null;

                            begin
                                select cod_cargo, cod_pccs, cod_ide_rel_func
                                into   v_cod_cargo, v_cod_pccs, v_cod_ide_rel_func
                                from tb_rel_func_periodo_exerc
                                where cod_ins       = ces.cod_ins
                                  and cod_ide_cli   = ces.cod_ide_cli
                                  and cod_entidade  = ces.cod_entidade
                                  and dat_ini_exerc <= fnc_valida_data(ces.dat_ini_cessao, 'RRRRMMDD')
                                  and (   dat_fim_exerc is null
                                       or dat_fim_exerc >= fnc_valida_data(ces.dat_ini_cessao, 'RRRRMMDD'))
                                  and rownum        <= 1;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', 'não foi possivel localizar o codigo do Cargo', 'Codigo do Cargo');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', substr('Erro ao verificar codigo do Cargo: '||sqlerrm, 1, 4000), 'Codigo do Cargo');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_num_seq_transf       := null;
                            v_tb_cessao            := null;
                            v_nom_entidade_destino := null;

                            begin
                                select *
                                into v_tb_cessao
                                from tb_cessao
                                where cod_ins          = ces.cod_ins
                                  and cod_ide_cli      = ces.cod_ide_cli
                                  and cod_entidade     = ces.cod_entidade
                                  and num_matricula    = ces.id_servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and dat_ini_exerc    = fnc_valida_data(ces.dat_ini_cessao, 'RRRRMMDD');
                            exception
                                when others then
                                    null;
                            end;

                            if (ces.cod_tipo_cessao = '1') then
                                v_nom_entidade_destino := ces.nom_entidade_destino;
                            end if;

                            if (v_tb_cessao.cod_ins is not null) then -- registro ja existe em tb_cessao, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                    update tb_cessao
                                    set dat_fim_exerc             = nvl(fnc_valida_data(ces.dat_fim_cessao, 'RRRRMMDD'), dat_fim_exerc),
                                        cod_tipo_doc_assoc        = nvl(ces.cod_tipo_doc_int, cod_tipo_doc_assoc),
                                        num_doc_assoc             = nvl(ces.num_doc, num_doc_assoc),
                                        cod_entidade_dest         = nvl(ces.cod_entidade_destino, cod_entidade_dest),
                                        dat_pub_ato_cess          = nvl(fnc_valida_data(ces.dat_publicacao_doc, 'RRRRMMDD'), dat_pub_ato_cess),
                                        cod_tipo_cessao           = ces.cod_tipo_cessao_int,
                                        cod_nat_cessao            = ces.cod_natureza_cessao_int,
                                        nom_entidade_externa_dest = nvl(v_nom_entidade_destino, nom_entidade_externa_dest),
                                        dat_ult_atu               = sysdate,
                                        nom_usu_ult_atu           = user,
                                        nom_pro_ult_atu           = v_nom_rotina
                                    where cod_ins          = v_tb_cessao.cod_ins
                                      and cod_ide_cli      = v_tb_cessao.cod_ide_cli
                                      and cod_entidade     = v_tb_cessao.cod_entidade
                                      and num_matricula    = v_tb_cessao.num_matricula
                                      and cod_ide_rel_func = v_tb_cessao.cod_ide_rel_func
                                      and dat_ini_exerc    = v_tb_cessao.dat_ini_exerc;
                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                begin
                                    select max(num_seq_transf)
                                    into v_num_seq_transf
                                    from tb_cessao
                                    where cod_ins          = ces.cod_ins
                                      and cod_ide_cli      = ces.cod_ide_cli
                                      and cod_entidade     = ces.cod_entidade
                                      and num_matricula    = ces.id_servidor
                                      and cod_ide_rel_func = v_cod_ide_rel_func;
                                exception
                                    when others then
                                        null;
                                end;

                                v_num_seq_transf := nvl(v_num_seq_transf, 0) + 1;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_cessao
                                        (COD_INS,                   --  1
                                         COD_IDE_CLI,               --  2
                                         COD_ENTIDADE,              --  3
                                         NUM_MATRICULA,             --  4
                                         COD_IDE_REL_FUNC,          --  5
                                         NUM_SEQ_TRANSF,            --  6
                                         COD_PCCS,                  --  7
                                         COD_CARGO,                 --  8
                                         DAT_INI_EXERC,             --  9
                                         DAT_FIM_EXERC,             -- 10
                                         COD_TIPO_DOC_ASSOC,        -- 11
                                         NUM_DOC_ASSOC,             -- 12
                                         COD_ENTIDADE_DEST,         -- 13
                                         COD_ORGAO_DEST,            -- 14
                                         DAT_PUB_ATO_CESS,          -- 15
                                         COD_TIPO_CESSAO,           -- 16
                                         COD_NAT_CESSAO,            -- 17
                                         DAT_ING,                   -- 18
                                         DAT_ULT_ATU,               -- 19
                                         NOM_USU_ULT_ATU,           -- 20
                                         NOM_PRO_ULT_ATU,           -- 21
                                         COD_REF_ENT_CEDIDA,        -- 22
                                         VAL_SAL_CONTRIBUICAO,      -- 23
                                         COD_RET_CESSAO,            -- 24
                                         FLG_DESC_APO_ESP,          -- 25
                                         NOM_ENTIDADE_EXTERNA_DEST) -- 26
                                    values
                                        (ces.cod_ins,                   --  1 COD_INS
                                         ces.cod_ide_cli,               --  2 COD_IDE_CLI
                                         ces.cod_entidade,              --  3 COD_ENTIDADE
                                         ces.id_servidor,               --  4 NUM_MATRICULA
                                         v_cod_ide_rel_func,            --  5 COD_IDE_REL_FUNC
                                         v_num_seq_transf,              --  6 NUM_SEQ_TRANSF
                                         v_cod_pccs,                    --  7 COD_PCCS
                                         v_cod_cargo,                   --  8 COD_CARGO
                                         fnc_valida_data(ces.dat_ini_cessao, 'RRRRMMDD'),  --  9 DAT_INI_EXERC
                                         fnc_valida_data(ces.dat_fim_cessao, 'RRRRMMDD'),  -- 10 DAT_FIM_EXERC
                                         ces.cod_tipo_doc_int,          -- 11 COD_TIPO_DOC_ASSOC
                                         ces.num_doc,                   -- 12 NUM_DOC_ASSOC
                                         ces.cod_entidade_destino,      -- 13 COD_ENTIDADE_DEST
                                         null,                          -- 14 COD_ORGAO_DEST
                                         fnc_valida_data(ces.dat_publicacao_doc, 'RRRRMMDD'),  -- 15 DAT_PUB_ATO_CESS
                                         ces.cod_tipo_cessao_int,       -- 16 COD_TIPO_CESSAO
                                         ces.cod_natureza_cessao_int,   -- 17 COD_NAT_CESSAO
                                         sysdate,                       -- 18 DAT_ING
                                         sysdate,                       -- 19 DAT_ULT_ATU
                                         user,                          -- 20 NOM_USU_ULT_ATU
                                         v_nom_rotina,                  -- 21 NOM_PRO_ULT_ATU
                                         null,                          -- 22 COD_REF_ENT_CEDIDA
                                         null,                          -- 23 VAL_SAL_CONTRIBUICAO
                                         null,                          -- 24 COD_RET_CESSAO
                                         null,                          -- 25 FLG_DESC_APO_ESP
                                         v_nom_entidade_destino);       -- 26 NOM_ENTIDADE_EXTERNA_DEST

                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',                   v_tb_cessao.cod_ins,                   ces.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',               v_tb_cessao.cod_ide_cli,               ces.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',              v_tb_cessao.cod_entidade,              ces.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',             v_tb_cessao.num_matricula,             ces.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',          v_tb_cessao.cod_ide_rel_func,          v_cod_ide_rel_func);
                            SP_INCLUI_LOG(a_log, 'NUM_SEQ_TRANSF',            v_tb_cessao.num_seq_transf,            nvl(v_num_seq_transf, v_tb_cessao.num_seq_transf));
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',                  v_tb_cessao.cod_pccs,                  nvl(v_cod_pccs, v_tb_cessao.cod_pccs));
                            SP_INCLUI_LOG(a_log, 'COD_CARGO',                 v_tb_cessao.cod_cargo,                 nvl(v_cod_cargo, v_tb_cessao.cod_cargo));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC',        v_tb_cessao.cod_tipo_doc_assoc,        nvl(ces.cod_tipo_doc_int, v_tb_cessao.cod_tipo_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',             v_tb_cessao.num_doc_assoc,             nvl(ces.num_doc, v_tb_cessao.num_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE_DEST',         v_tb_cessao.cod_entidade_dest,         nvl(ces.cod_entidade_destino, v_tb_cessao.cod_entidade_dest));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_CESSAO',           v_tb_cessao.cod_tipo_cessao,           ces.cod_tipo_cessao_int);
                            SP_INCLUI_LOG(a_log, 'COD_NAT_CESSAO',            v_tb_cessao.cod_nat_cessao,            ces.cod_natureza_cessao_int);
                            SP_INCLUI_LOG(a_log, 'NOM_ENTIDADE_EXTERNA_DEST', v_tb_cessao.nom_entidade_externa_dest, nvl(v_nom_entidade_destino, v_tb_cessao.nom_entidade_externa_dest));
                            SP_INCLUI_LOG(a_log, 'DAT_INI_EXERC',             to_char(v_tb_cessao.dat_ini_exerc, 'dd/mm/yyyy hh24:mi'),    to_char(fnc_valida_data(ces.dat_ini_cessao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_EXERC',             to_char(v_tb_cessao.dat_fim_exerc, 'dd/mm/yyyy hh24:mi'),    to_char(nvl(fnc_valida_data(ces.dat_fim_cessao, 'RRRRMMDD'), v_tb_cessao.dat_fim_exerc), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_PUB_ATO_CESS',          to_char(v_tb_cessao.dat_pub_ato_cess, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(ces.dat_publicacao_doc, 'RRRRMMDD'), v_tb_cessao.dat_pub_ato_cess), 'dd/mm/yyyy hh24:mi'));

                            SP_GRAVA_LOG(i_id_header, ces.id_processo, ces.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_CESSAO', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ces.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, ces.id_processo, ces.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ces.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, ces.id_processo, ces.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, ces.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_CES;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_CES (i_ces       in     r_ces,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_publicacao_doc            date;
        v_dat_ini_cessao                date;
        v_dat_fim_cessao                date;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_ces.cod_ins, i_ces.cod_entidade);
        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_ces.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_ces.id_vinculo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo não foi informada');
        elsif (fnc_valida_numero(i_ces.id_vinculo) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo informada ('||i_ces.id_vinculo||') esta invalida');
        end if;

        if ((i_ces.cod_tipo_doc is not null) and (i_ces.cod_tipo_doc_int is null)) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_DOC', 'Codigo informado para o tipo de documento ('||i_ces.cod_tipo_doc||') não previsto');
        end if;

        if (i_ces.dat_publicacao_doc is not null) then
            v_dat_publicacao_doc := fnc_valida_data(i_ces.dat_publicacao_doc, 'RRRRMMDD');
            if (length(i_ces.dat_publicacao_doc) < 8 or v_dat_publicacao_doc is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_PUBLICACAO_DOC', 'Data de publicação informada ('||i_ces.dat_publicacao_doc||') esta invalida');
            end if;
        end if;

        if (i_ces.cod_tipo_cessao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_CESSAO', 'Codigo do tipo de cessão não foi informado');
        elsif (i_ces.cod_tipo_cessao_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_CESSAO', 'Codigo informado para o tipo de cessão ('||i_ces.cod_tipo_cessao||') não previsto');
        end if;

        if (i_ces.cod_natureza_cessao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_NATUREZA_CESSAO', 'Codigo da natureza da cessão não foi informado');
        elsif (i_ces.cod_natureza_cessao_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_NATUREZA_CESSAO', 'Codigo informado para a natureza da cessão ('||i_ces.cod_natureza_cessao||') não previsto');
        end if;

        if (i_ces.cod_entidade_destino is null) then
            if (i_ces.cod_tipo_cessao = '2') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE_DESTINO', 'Codigo da entidade de destino não foi informada (obrigatoriopara tipo de cessão 2 - Cessão interna)');
            end if;
        else
            v_des_result := fnc_valida_cod_entidade(i_ces.cod_ins, i_ces.cod_entidade_destino);
            if (v_des_result is not null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE_DESTINO', substr(v_des_result, 6));
            end if;
        end if;

        if (i_ces.nom_entidade_destino is null and i_ces.cod_tipo_cessao = '1') then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'NOM_ENTIDADE_DESTINO', 'Nome da entidade de destino não foi informada (obrigatorio para tipo de cessão 1 - Cessão externa)');
        end if;

        if (i_ces.dat_ini_cessao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_CESSAO', 'Data de inicio de cessão não foi informada');
        else
            v_dat_ini_cessao := fnc_valida_data(i_ces.dat_ini_cessao, 'RRRRMMDD');
            if (length(i_ces.dat_ini_cessao) < 8 or v_dat_ini_cessao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_CESSAO', 'Data de inicio de cessão informada ('||i_ces.dat_ini_cessao||') esta invalida');
            end if;
        end if;

        if (i_ces.dat_fim_cessao is not null) then
            v_dat_fim_cessao := fnc_valida_data(i_ces.dat_fim_cessao, 'RRRRMMDD');
            if (length(i_ces.dat_fim_cessao) < 8 or v_dat_fim_cessao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_CESSAO', 'Data de fim de cessão informada ('||i_ces.dat_fim_cessao||') esta invalida');
            end if;
        end if;

        if (v_dat_ini_cessao is not null and v_dat_fim_cessao is not null and v_dat_ini_cessao > v_dat_fim_cessao) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_CESSAO', 'Data de fim de cessao ('||i_ces.dat_fim_cessao||') e anterior a data de inicio de cessao ('||i_ces.dat_ini_cessao||')');
        end if;

        if (i_ces.cod_ide_cli is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_CES;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_FME (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_fme.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_FME';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_FME';
        v_tb_laudo_medico       tb_laudo_medico%rowtype;
        v_nom_medico            tb_laudo_medico.nom_medico%type;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);
        v_cod_erro              number;
        v_vlr_iteracao          number := 300;
        v_dat_ini_licenca_medica date;
        v_dat_fim_licenca_medica date;
        v_cod_pccs              tb_afastamento.cod_pccs%type;
        v_cod_cargo             tb_afastamento.cod_Cargo%type;
        v_qtd_afast             number;
        v_cod_ide_cli           tb_afastamento.cod_ide_cli%type;
        v_cod_entidade          tb_afastamento.cod_entidade%type;
        v_id_servidor           tb_carga_gen_fme.id_Servidor%type;
        v_cod_ide_Rel_func       tb_Afastamento.Cod_Ide_Rel_Func%type;
        v_dat_emi_laudo_pericia  date;
        v_qtd_dias_afast         number;
        v_cod_doenca            tb_cid10.cod_doenca%type;
        v_num_inscr_cons        number;
        v_id_num_insc_perito    number;
        v_id_num_insc_perito_ext number;
        v_cod_mot_afast         number;

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then
            loop
                v_cur_id := null;
                -- Validação
/*                PAC_CARGA_GENERICA_VALIDA.sp_executa_validacao_dinamica(i_id_header        => i_id_header,
                                                                        o_cod_erro         => v_cod_erro,
                                                                        o_des_erro         => v_msg_erro,
                                                                        i_qtd_reg_proc     => v_vlr_iteracao);

*/                --
                if v_cod_erro is not null then
                  v_result := 'Erro ao chamar função de validação dinamica:'||v_cod_erro||'-'||v_msg_erro;
                end if;

                if v_result is null then
                  for fme in (select a.cod_ins,
                                     trim(a.cod_entidade)           cod_entidade,
                                     trim(a.id_servidor)            id_servidor,
                                     trim(a.cod_doenca)             cod_doenca,
                                     trim(a.dat_ini_licenca_medica) dat_ini_licenca_medica,
                                     trim(a.dat_fim_licenca_medica) dat_fim_licenca_medica,
                                     trim(a.num_laudo_pericia)      num_laudo_pericia,
                                     trim(a.dat_emi_laudo_pericia)  dat_emi_laudo_pericia,
                                     trim(a.num_inscricao_conselho) num_inscricao_conselho,
                                     trim(a.nom_medico)             nom_medico,
                                     trim(a.des_observacao_pericia) des_observacao_pericia,
                                     a.id, a.num_linha_header, a.id_processo,
                                     d.cod_ide_cli
                              from tb_carga_gen_fme a
                                  left outer join tb_carga_gen_ident_ext d
                                      on      a.cod_ins      = d.cod_ins
                                          and a.id_servidor  = d.cod_ide_cli_ext
                                          and a.cod_entidade = d.cod_entidade
                              where a.id_header = i_id_header
                                and a.cod_status_processamento = '2'
                                and rownum <= v_vlr_iteracao
                              order by a.id_header, a.num_linha_header
                              for update nowait) loop

                      v_cur_id              := fme.id;

                      BEGIN

                          savepoint sp1;

                          -- separando entidade de id_header
                          v_id_servidor  := PAC_CARGA_GENERICA_CLIENTE.fnc_ret_id_Servidor (fme.id_servidor);
                          v_cod_entidade := PAC_CARGA_GENERICA_CLIENTE.fnc_ret_cod_entidade(fme.cod_entidade,fme.id_servidor);

                          --
                          -- Pega cod_ide_cli da ident_ext_servidor
                          begin
                              select cod_ide_cli
                              into v_cod_ide_cli
                              from tb_carga_gen_ident_ext
                              where cod_ins         = fme.cod_ins
                                and cod_entidade    = v_cod_entidade
                                and cod_ide_cli_ext = v_id_servidor;
                          exception
                              when no_data_found then
                                v_cod_ide_cli:=null;
                          end;

                          if (fme.dat_ini_licenca_medica is not null and fnc_valida_numero(fme.dat_ini_licenca_medica) = 0) then
                              fme.dat_ini_licenca_medica := null;
                          end if;

                          v_dat_ini_licenca_medica :=  fnc_valida_data(fme.dat_ini_licenca_medica,'RRRRMMDD');

                          if (fme.dat_fim_licenca_medica is not null and fnc_valida_numero(fme.dat_fim_licenca_medica) = 0) then
                              fme.dat_fim_licenca_medica := null;
                          end if;
                          --
                          v_dat_fim_licenca_medica :=  fnc_valida_data(fme.dat_fim_licenca_medica,'RRRRMMDD');
                          --
                          if (fme.dat_emi_laudo_pericia is not null and fnc_valida_numero(fme.dat_emi_laudo_pericia) = 0) then
                              fme.dat_emi_laudo_pericia := null;
                          end if;
                          --
                          v_dat_emi_laudo_pericia :=  fnc_valida_data(fme.dat_emi_laudo_pericia,'RRRRMMDD');
                          --
                          v_qtd_dias_afast := v_dat_fim_licenca_medica - v_dat_ini_licenca_medica;
                          --
                          --
                          -- v_cod_mot_afast := fnc_motivo_afast_grp_ret_cod(COD_GRU_AFAST);
                          --
                          --
                          v_result := FNC_VALIDA_FME(fme, a_validar);
                          --
                          if (v_result is null) then
                              v_nom_medico      := null;
                              v_tb_laudo_medico := null;

                              begin
                                  select *
                                  into v_tb_laudo_medico
                                  from tb_laudo_medico
                                  where cod_ins          = fme.cod_ins
                                    and cod_ide_cli      = v_cod_ide_cli
                                    and cod_entidade     = v_cod_entidade
                                    and num_laudo_medico = fme.num_laudo_pericia;
                              exception
                                  when others then
                                      null;
                              end;
                              -- busca peritos internos e externos
                              sp_busca_id_insc_perito(fme.cod_ins,
                                                      fme.num_inscricao_conselho,
                                                      fme.nom_medico,
                                                      'E',
                                                      v_id_num_insc_perito_ext --out
                                                      );
                              --
                              sp_busca_id_insc_perito(fme.cod_ins,
                                                      ID_INSCRICAO_PERITO,
                                                      null,
                                                      'I',
                                                      v_id_num_insc_perito --out
                                                      );

                              --
                              -- Pega cod da doença
                              begin
                                select a.cod_doenca
                                  into v_cod_doenca
                                  from tb_cid10 a
                                 where a.cod_ins = fme.cod_ins
                                   and a.cod_cid = fme.cod_doenca;
                              exception
                                when no_data_found then
                                  v_cod_doenca := null;
                                when too_many_rows then
                                  v_cod_doenca := null;
                              end;
                              --
                              if (v_tb_laudo_medico.cod_ins is not null) then -- registro ja existe em tb_laudo_medico, atualiza os demais dados

                                  v_cod_tipo_ocorrencia := 'A';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                      update tb_laudo_medico
                                      set cod_cid          = nvl(fme.cod_doenca, cod_cid),
                                          dat_ini_vig      = v_dat_ini_licenca_medica,
                                          dat_fim_vig      = nvl(v_dat_fim_licenca_medica, dat_fim_vig),
                                          dat_atest_medico = nvl(nvl(v_dat_emi_laudo_pericia,v_dat_ini_licenca_medica), dat_atest_medico),
                                          num_crm_medico   = nvl(v_num_inscr_cons, num_crm_medico),
                                          nom_medico       = nvl(v_nom_medico, nom_medico),
                                          des_resultado    = nvl(fme.des_observacao_pericia, des_resultado),
                                          dat_ult_atu      = sysdate,
                                          nom_usu_ult_atu  = user,
                                          nom_pro_ult_atu  = v_nom_rotina,
                                          nom_medico1      = nvl(v_nom_medico, nom_medico1),
                                          num_crm_medico1  = nvl(v_num_inscr_cons, num_crm_medico1),
                                          cod_mot_afast    = v_cod_mot_afast,
                                          qtd_dia_afast    = v_qtd_dias_afast,
                                          dat_pericia      = nvl(v_dat_emi_laudo_pericia,v_dat_ini_licenca_medica),
                                          cod_doenca_01    = v_cod_doenca,
                                          id_inscr_cons_perito = v_id_num_insc_perito,
                                          id_inscr_cons_perito_ext = v_id_num_insc_perito_ext,
                                          flg_status_conclusao = nvl( flg_status_conclusao, 'C')
                                      where cod_ins          = v_tb_laudo_medico.cod_ins
                                        and cod_ide_cli      = v_tb_laudo_medico.cod_ide_cli
                                        and cod_entidade     = v_tb_laudo_medico.cod_entidade
                                        and num_laudo_medico = v_tb_laudo_medico.num_laudo_medico;

                                  end if;

                              else                        -- registro não existe, inclui
                                  v_cod_tipo_ocorrencia := 'I';

                                  if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada
                                      insert into tb_laudo_medico
                                          (COD_INS,                   --  1
                                           COD_IDE_CLI,               --  2
                                           COD_ENTIDADE,              --  3
                                           NUM_LAUDO_MEDICO,          --  4
                                           DAT_ATEST_MEDICO,          --  5
                                           NOM_MEDICO,                --  6
                                           NUM_CRM_MEDICO,            --  7
                                           DES_PERICIA_MEDICA,        --  8
                                           FLG_INVALIDEZ,             --  9
                                           FLG_AUTA,                  -- 10
                                           DAT_INI_VIG,               -- 11
                                           DAT_FIM_VIG,               -- 12
                                           DAT_ING,                   -- 13
                                           DAT_ULT_ATU,               -- 14
                                           NOM_USU_ULT_ATU,           -- 15
                                           NOM_PRO_ULT_ATU,           -- 16
                                           FLG_ACIDENTE_TRABALHO,     -- 17
                                           FLG_COBERTURA_INTEGRAL,    -- 18
                                           COD_CID,                   -- 19
                                           NOM_MEDICO1,               -- 20
                                           NUM_CRM_MEDICO1,           -- 21
                                           NOM_MEDICO2,               -- 22
                                           NUM_CRM_MEDICO2,           -- 23
                                           NUM_LAUDO_MEDICO_VAR,      -- 24
                                           COD_INV_CONSEQ_DE,         -- 25
                                           NUM_PROCESSO,              -- 26
                                           ID,                        -- 27
                                           COD_IDE_CLI_ATENDENTE,     -- 28
                                           COD_MOT_AFAST,             -- 29
                                           COD_CONVENIO,              -- 30
                                           QTD_DIA_AFAST,             -- 31
                                           FLG_STATUS_CONCLUSAO,      -- 32
                                           DAT_PERICIA,               -- 33
                                           DAT_PRAZO_INFO,            -- 34
                                           COD_DOENCA_01,             -- 35
                                           COD_DOENCA_02,             -- 36
                                           ID_INSCR_CONS_PERITO,      -- 37
                                           ID_INSCR_CONS_PERITO_EXT,  -- 38
                                           DES_SOLICITACAO,           -- 39
                                           DES_RESULTADO)             -- 40
                                      values
                                          (fme.cod_ins,                   --  1 COD_INS
                                           v_cod_ide_cli,                 --  2 COD_IDE_CLI
                                           v_cod_entidade,                --  3 COD_ENTIDADE
                                           fme.num_laudo_pericia,         --  4 NUM_LAUDO_MEDICO
                                           nvl(v_dat_emi_laudo_pericia,v_dat_ini_licenca_medica),   --  5 DAT_ATEST_MEDICO
                                           fme.nom_medico,                --  6 NOM_MEDICO
                                           fme.num_inscricao_conselho,    --  7 NUM_CRM_MEDICO
                                           null,                          --  8 DES_PERICIA_MEDICA
                                           'N',                           --  9 FLG_INVALIDEZ
                                           'N',                           -- 10 FLG_AUTA
                                           v_dat_ini_licenca_medica,      -- 11 DAT_INI_VIG
                                           v_dat_fim_licenca_medica,      -- 12 DAT_FIM_VIG
                                           sysdate,                       -- 13 DAT_ING
                                           sysdate,                       -- 14 DAT_ULT_ATU
                                           user,                          -- 15 NOM_USU_ULT_ATU
                                           v_nom_rotina,                  -- 16 NOM_PRO_ULT_ATU
                                           null,                          -- 17 FLG_ACIDENTE_TRABALHO
                                           'N',                           -- 18 FLG_COBERTURA_INTEGRAL
                                           fme.cod_doenca,                -- 19 COD_CID
                                           v_nom_medico,                  -- 20 NOM_MEDICO1
                                           v_num_inscr_cons,                   -- 21 NUM_CRM_MEDICO1
                                           null,                          -- 22 NOM_MEDICO2
                                           null,                          -- 23 NUM_CRM_MEDICO2
                                           null,                          -- 24 NUM_LAUDO_MEDICO_VAR
                                           null,                          -- 25 COD_INV_CONSEQ_DE
                                           null,                          -- 26 NUM_PROCESSO
                                           null,                          -- 27 ID
                                           null,                          -- 28 COD_IDE_CLI_ATENDENTE
                                           v_cod_mot_afast,               -- 29 COD_MOT_AFAST
                                           null,                          -- 30 COD_CONVENIO
                                           v_qtd_dias_afast,              -- 31 QTD_DIA_AFAST
                                           'C',                          -- 32 FLG_STATUS_CONCLUSAO (c-Concedido)
                                           nvl(v_dat_emi_laudo_pericia,v_dat_ini_licenca_medica), -- 33 DAT_PERICIA
                                           null,                          -- 34 DAT_PRAZO_INFO
                                           v_cod_doenca,                  -- 35 COD_DOENCA_01
                                           null,                          -- 36 COD_DOENCA_02
                                           v_id_num_insc_perito,          -- 37 ID_INSCR_CONS_PERITO
                                           v_id_num_insc_perito_ext,      -- 38 ID_INSCR_CONS_PERITO_EXT
                                           null,                          -- 39 DES_SOLICITACAO
                                           fme.des_observacao_pericia);   -- 40 DES_RESULTADO
                                  end if;

                              end if;

                              a_log.delete;
                              SP_INCLUI_LOG(a_log, 'COD_INS',                v_tb_laudo_medico.cod_ins,                 fme.cod_ins);
                              SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',            v_tb_laudo_medico.cod_ide_cli,             v_cod_ide_cli);
                              SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',           v_tb_laudo_medico.cod_entidade,            v_cod_entidade);
                              SP_INCLUI_LOG(a_log, 'NUM_LAUDO_MEDICO',       v_tb_laudo_medico.num_laudo_medico,        fme.num_laudo_pericia);
                              SP_INCLUI_LOG(a_log, 'NOM_MEDICO',             v_tb_laudo_medico.nom_medico,              nvl(v_nom_medico, v_tb_laudo_medico.nom_medico));
                              SP_INCLUI_LOG(a_log, 'NUM_CRM_MEDICO',         v_tb_laudo_medico.num_crm_medico,          nvl(fme.num_inscricao_conselho, v_tb_laudo_medico.num_crm_medico));
                              SP_INCLUI_LOG(a_log, 'FLG_INVALIDEZ',          v_tb_laudo_medico.flg_invalidez,           nvl(v_tb_laudo_medico.flg_invalidez, 'N'));
                              SP_INCLUI_LOG(a_log, 'FLG_AUTA',               v_tb_laudo_medico.flg_auta,                nvl(v_tb_laudo_medico.flg_auta, 'N'));
                              SP_INCLUI_LOG(a_log, 'FLG_COBERTURA_INTEGRAL', v_tb_laudo_medico.flg_cobertura_integral,  nvl(v_tb_laudo_medico.flg_cobertura_integral, 'N'));
                              SP_INCLUI_LOG(a_log, 'COD_CID',                v_tb_laudo_medico.cod_cid,                 nvl(fme.cod_doenca, v_tb_laudo_medico.cod_cid));
                              SP_INCLUI_LOG(a_log, 'DES_RESULTADO',          v_tb_laudo_medico.des_resultado,           nvl(fme.des_observacao_pericia, v_tb_laudo_medico.des_resultado));
                              SP_INCLUI_LOG(a_log, 'DAT_INI_VIG',            to_char(v_tb_laudo_medico.dat_ini_vig, 'dd/mm/yyyy hh24:mi'),       to_char(fnc_valida_data(fme.dat_ini_licenca_medica, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                              SP_INCLUI_LOG(a_log, 'DAT_FIM_VIG',            to_char(v_tb_laudo_medico.dat_fim_vig, 'dd/mm/yyyy hh24:mi'),       to_char(nvl(fnc_valida_data(fme.dat_fim_licenca_medica, 'RRRRMMDD'), v_tb_laudo_medico.dat_fim_vig), 'dd/mm/yyyy hh24:mi'));
                              SP_INCLUI_LOG(a_log, 'DAT_ATEST_MEDICO',       to_char(v_tb_laudo_medico.dat_atest_medico, 'dd/mm/yyyy hh24:mi'),  to_char(nvl(fnc_valida_data(fme.dat_emi_laudo_pericia, 'RRRRMMDD'), v_tb_laudo_medico.dat_atest_medico), 'dd/mm/yyyy hh24:mi'));

                              SP_GRAVA_LOG(i_id_header, fme.id_processo, fme.num_linha_header, v_cod_tipo_ocorrencia,
                                           v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_LAUDO_MEDICO', v_nom_rotina, a_log);
                              --
                              --
                              v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,null);
                              --
                              begin
                                select rf.cod_pccs, rf.cod_cargo
                                  into v_cod_cargo, v_cod_pccs
                                  from tb_relacao_funcional rf
                                  where rf.cod_ins = fme.cod_ins
                                    and rf.cod_entidade = v_cod_entidade
                                    and rf.num_matricula = v_id_Servidor
                                    and rf.cod_ide_rel_func = v_cod_ide_Rel_func
                                    and v_dat_ini_licenca_medica between rf.dat_ini_exerc and nvl(rf.dat_fim_exerc,v_dat_ini_licenca_medica);
                              exception
                                when no_data_found then
                                  raise_application_error(-20000, 'Não localizado Vínculo para o servidor');
                              end;
                              --
                              select count(1)
                                into v_qtd_afast
                                from tb_afastamento af
                               where af.cod_ins = fme.cod_ins
                                 and af.cod_ide_cli = v_cod_ide_cli
                                 and af.cod_entidade = v_cod_entidade
                                 and af.num_matricula = v_id_Servidor
                                 and af.cod_ide_rel_func = v_cod_ide_Rel_func
                                 and af.cod_mot_afast = v_cod_mot_afast
                                 and af.dat_ini_afast = v_dat_ini_licenca_medica
                                 and af.dat_ret_prev = v_dat_fim_licenca_medica;
                              --
                              if v_qtd_afast = 0 then                                                          --
                                insert into tb_afastamento
                                (COD_INS,
                                 COD_IDE_CLI,
                                 COD_ENTIDADE,
                                 COD_PCCS,
                                 COD_CARGO,
                                 NUM_MATRICULA,
                                 COD_IDE_REL_FUNC,
                                 NUM_SEQ_AFAST,
                                 NUM_LAUDO_MEDICO,
                                 COD_MOT_AFAST,
                                 DAT_INI_AFAST,
                                 COD_TIPO_DOC_ASSOC,
                                 NUM_DOC_ASSOC,
                                 DAT_PUBLIC,
                                 DAT_RET_PREV,
                                 DAT_ING,
                                 DAT_ULT_ATU,
                                 NOM_USU_ULT_ATU,
                                 NOM_PRO_ULT_ATU)
                                values
                                (1,                        --COD_INS,
                                 v_cod_ide_cli,            --COD_IDE_CLI,
                                 v_cod_entidade,           --COD_ENTIDADE,
                                 v_cod_pccs,               --COD_PCCS,
                                 v_cod_cargo,              --COD_CARGO,
                                 v_id_Servidor,            --NUM_MATRICULA,
                                 v_cod_ide_rel_func,       --COD_IDE_REL_FUNC,
                                 seq_num_seq_afast.nextval,--NUM_SEQ_AFAST,
                                 fme.num_laudo_pericia,    --NUM_LAUDO_MEDICO,
                                 v_cod_mot_afast,          --COD_MOT_AFAST,
                                 v_dat_ini_licenca_medica, --DAT_INI_AFAST,
                                 0,                        --COD_TIPO_DOC_ASSOC,
                                 0,                        --NUM_DOC_ASSOC,
                                 null,                     --DAT_PUBLIC,
                                 v_dat_fim_licenca_medica, --DAT_RET_PREV,
                                 sysdate,                  --DAT_ING,
                                 sysdate,                  --DAT_ULT_ATU,
                                 user,                     --NOM_USU_ULT_ATU,
                                 'pac_carga_Generica.SP_CARREGA_FME');--NOM_PRO_ULT_ATU
                              end if;
                              --
                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fme.id, '3', null, v_nom_rotina)!= 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;
                          else
                              SP_GRAVA_ERRO(i_id_header, fme.id_processo, fme.num_linha_header, v_nom_rotina, a_validar);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fme.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;

                          end if;

                      EXCEPTION
                          WHEN OTHERS THEN

                              v_msg_erro := substr(sqlerrm, 1, 4000);

                              rollback to sp1;

                              SP_GRAVA_ERRO(i_id_header, fme.id_processo, fme.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                              if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fme.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                  raise ERRO_GRAVA_STATUS;
                              end if;
                      END;
                  end loop;
                else
                  rollback;
                  SP_GRAVA_ERRO_DIRETO(i_id_header, 26, 0, v_nom_rotina, v_result);
                  commit;
                  exit;
                end if;
                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
          rollback;
          SP_GRAVA_ERRO_DIRETO(i_id_header, 26, 0, v_nom_rotina, v_result);
          commit;
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_FME;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_FME (i_fme       in     r_fme,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);
        v_dat_ini_licenca_medica        date;
        v_dat_fim_licenca_medica        date;
        v_dat_emi_laudo_pericia         date;

    BEGIN
        --
        o_a_validar.delete;
        --

        --
        if (v_dat_ini_licenca_medica is not null and v_dat_fim_licenca_medica is not null and v_dat_ini_licenca_medica > v_dat_fim_licenca_medica) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INI_LICENCA_MEDICA', 'Data de fim da licenca medica ('||i_fme.dat_fim_licenca_medica||') e anterior a data de inicio ('||i_fme.dat_ini_licenca_medica||')');
        end if;
        --
        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;
        --
        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_FME;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_ARC (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_fme.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_ARC';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_ARC';
        v_cod_cargo             tb_rel_func_periodo_exerc.cod_cargo%type;
        v_cod_pccs              tb_rel_func_periodo_exerc.cod_pccs%type;
        v_cod_ide_rel_func      tb_rel_func_periodo_exerc.cod_ide_rel_func%type;
        v_tb_arrecadacao        tb_arrecadacao%rowtype;
        v_cod_manual            tb_arrecadacao.cod_manual%type;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);
        v_id_servidor           number;
        v_cod_entidade          varchar2(20);
        v_cod_ide_cli           varchar2(20);


    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for arc in (select a.cod_ins,
                                   trim(a.cod_entidade)                 cod_entidade,
                                   trim(a.id_servidor)                  id_servidor,
                                   trim(a.id_vinculo)                   id_vinculo,
                                   trim(a.dat_competencia)              dat_competencia,
                                   substr(trim(a.dat_arrecadacao),1,6)||'01'  dat_arrecadacao,
                                   trim(a.val_contrib_servidor_arrec)   val_contrib_servidor_arrec,
                                   trim(a.val_percent_contrib_servidor) val_percent_contrib_servidor,
                                   trim(a.val_contrib_servidor)         val_contrib_servidor,
                                   trim(a.val_percent_contrib_patronal) val_percent_contrib_patronal,
                                   trim(a.val_contrib_patronal)         val_contrib_patronal,
                                   trim(a.cod_tipo_arrecadacao)         cod_tipo_arrecadacao,
                                   fnc_codigo_ext(a.cod_ins, 2056, trim(a.cod_tipo_arrecadacao),   null, 'cod_par') cod_tipo_arrecadacao_int,
                                   a.id,
                                   a.num_linha_header,
                                   a.id_processo
                            from tb_carga_gen_arc a
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id              := arc.id;

                    BEGIN

                        savepoint sp1;

                        -- separando entidade de id_header
                        v_id_servidor := pac_carga_generica_cliente.fnc_ret_id_Servidor(arc.id_servidor);
                        -- v_cod_entidade := pac_carga_generica_cliente.fnc_ret_cod_entidade(flf.cod_entidade,flf.id_servidor);
                        -- Pega cod_ide_cli da ident_ext_servidor
                        v_cod_ide_cli := fnc_ret_cod_ide_cli( arc.cod_ins, v_id_Servidor);
                        --
                        if FNC_VALIDA_PESSOA_FISICA(arc.cod_ins, v_cod_ide_cli) is not null then
                           raise_application_error(-20000, 'Servidor possui Benefício cadastrado');
                        end if;
                        --
                        v_cod_ide_Rel_func   := fnc_ret_cod_ide_rel_func(v_id_servidor,arc.id_vinculo);
                        --
                        if (arc.dat_competencia is not null and fnc_valida_numero(arc.dat_competencia) = 0) then
                            arc.dat_competencia := null;
                        end if;

                        if (arc.dat_arrecadacao is not null and fnc_valida_numero(arc.dat_arrecadacao) = 0) then
                            arc.dat_arrecadacao := null;
                        end if;

                        v_result := FNC_VALIDA_ARC(arc, a_validar);

                        if (v_result is null) then

                            v_cod_cargo        := null;
                            v_cod_pccs         := null;
                            v_cod_entidade     := null;

                            begin
                                select cod_entidade, cod_cargo, cod_pccs
                                into   v_cod_entidade,v_cod_cargo, v_cod_pccs
                                from tb_rel_func_periodo_exerc
                                where cod_ins       = arc.cod_ins
                                  and cod_ide_cli   = v_cod_ide_cli
                                  and num_matricula = v_id_Servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and trunc(dat_ini_exerc, 'MM') <= fnc_valida_data(arc.dat_competencia, 'RRRRMMDD')
                                  and (   dat_fim_exerc is null
                                       or dat_fim_exerc >= fnc_valida_data(arc.dat_competencia, 'RRRRMMDD'))
                                  and rownum        <= 1;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', 'não foi possivel localizar o codigo do Cargo', 'Codigo do Cargo');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_REL_FUNC', 'não foi possivel localizar o codigo da relação funcional', 'Codigo da Relação Funcional');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', substr('Erro ao verificar codigo do Cargo: '||sqlerrm, 1, 4000), 'Codigo do Cargo');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_REL_FUNC', substr('Erro ao verificar o codigo da relação funcional', 1, 4000), 'Codigo da Relação Funcional');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_tb_arrecadacao := null;

                            begin
                                select *
                                into v_tb_arrecadacao
                                from tb_arrecadacao
                                where cod_ins          = arc.cod_ins
                                  and cod_entidade     = v_cod_entidade
                                  and num_matricula    = v_id_servidor
                                  and cod_ide_cli      = v_cod_ide_cli
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and dat_ano_comp     = substr(arc.dat_competencia, 1, 4)
                                  and dat_mes_comp     = substr(arc.dat_competencia, 5, 2)
                                  and cod_tipo_arrec   = arc.cod_tipo_arrecadacao_int
                                  and num_dr_lote      = '0'
                                  and cod_cobranca     = '0'
                                  and cod_operacao     = '6';
                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_arrecadacao.cod_ins is not null) then -- registro ja existe em v_tb_arrecadacao, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_arrecadacao
                                    set dat_arrec           = trunc(fnc_valida_data(arc.dat_arrecadacao, 'RRRRMMDD'), 'MM'),
                                        val_serv_arrec      = fnc_valida_numero(arc.val_contrib_servidor_arrec)/10000,
                                        val_per_serv_arrec  = fnc_valida_numero(arc.val_percent_contrib_servidor)/100,
                                        val_sal_contrib_inf = fnc_valida_numero(arc.val_contrib_servidor)/10000,
                                        val_per_emp_arrec   = fnc_valida_numero(arc.val_percent_contrib_patronal)/100,
                                        val_emp_arrec       = fnc_valida_numero(arc.val_contrib_patronal)/10000,
                                        dat_ult_atu         = sysdate,
                                        nom_usu_ult_atu     = user,
                                        nom_pro_ult_atu     = v_nom_rotina
                                    where cod_ins          = v_tb_arrecadacao.cod_ins
                                      and cod_entidade     = v_cod_entidade
                                      and num_matricula    = v_id_Servidor
                                      and cod_ide_cli      = v_cod_ide_cli
                                      and cod_ide_rel_func = v_cod_ide_rel_func
                                      and dat_ano_comp     = v_tb_arrecadacao.dat_ano_comp
                                      and dat_mes_comp     = v_tb_arrecadacao.dat_mes_comp
                                      and cod_tipo_arrec   = v_tb_arrecadacao.cod_tipo_arrec
                                      and num_dr_lote      = v_tb_arrecadacao.num_dr_lote
                                      and cod_cobranca     = v_tb_arrecadacao.cod_cobranca
                                      and cod_manual       = v_tb_arrecadacao.cod_manual
                                      and cod_operacao     = v_tb_arrecadacao.cod_operacao;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                v_cod_manual := seq_cod_manual_arrecadacao.nextval;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_arrecadacao
                                        (cod_ins,               --  1
                                         cod_ide_cli,           --  2
                                         cod_entidade,          --  3
                                         cod_pccs,              --  4
                                         cod_cargo,             --  5
                                         num_matricula,         --  6
                                         cod_ide_rel_func,      --  7
                                         dat_mes_comp,          --  8
                                         dat_ano_comp,          --  9
                                         cod_tipo_arrec,        -- 10
                                         dat_arrec,             -- 11
                                         val_serv_arrec,        -- 12
                                         val_per_serv_arrec,    -- 13
                                         val_serv_prev,         -- 14
                                         val_per_serv_prev,     -- 15
                                         val_emp_arrec,         -- 16
                                         val_per_emp_arrec,     -- 17
                                         val_emp_prev,          -- 18
                                         val_per_emp_prev,      -- 19
                                         dat_ing,               -- 20
                                         dat_ult_atu,           -- 21
                                         nom_usu_ult_atu,       -- 22
                                         nom_pro_ult_atu,       -- 23
                                         num_dr_lote,           -- 24
                                         val_sal_contrib_inf,   -- 25
                                         dat_comp_pag_benf,     -- 26
                                         val_dev_cont,          -- 27
                                         val_dif_cont,          -- 28
                                         cod_cobranca,          -- 29
                                         cod_entidade_origem,   -- 30
                                         cod_manual,            -- 31
                                         cod_operacao,          -- 32
                                         dat_ref)               -- 33
                                    values
                                        (arc.cod_ins,                           --  1 cod_ins
                                         v_cod_ide_cli,                       --  2 cod_ide_cli
                                         v_cod_entidade,                      --  3 cod_entidade
                                         v_cod_pccs,                            --  4 cod_pccs
                                         v_cod_cargo,                           --  5 cod_cargo
                                         v_id_servidor,                       --  6 num_matricula
                                         v_cod_ide_rel_func,                    --  7 cod_ide_rel_func
                                         substr(arc.dat_competencia, 5, 2),     --  8 dat_mes_comp
                                         substr(arc.dat_competencia, 1, 4),     --  9 dat_ano_comp
                                         arc.cod_tipo_arrecadacao_int,          -- 10 cod_tipo_arrec
                                         trunc(fnc_valida_data(arc.dat_arrecadacao, 'RRRRMMDD'), 'MM'), -- 11 dat_arrec
                                         fnc_valida_numero(arc.val_contrib_servidor_arrec)/10000,       -- 12 val_serv_arrec
                                         fnc_valida_numero(arc.val_percent_contrib_servidor)/100,       -- 13 val_per_serv_arrec
                                         NULL,                                  -- 14 val_serv_prev
                                         NULL,                                  -- 15 val_per_serv_prev
                                         fnc_valida_numero(arc.val_contrib_patronal)/10000,             -- 16 val_emp_arrec
                                         fnc_valida_numero(arc.val_percent_contrib_patronal)/100,       -- 17 val_per_emp_arrec
                                         NULL,                                  -- 18 val_emp_prev
                                         NULL,                                  -- 19 val_per_emp_prev
                                         sysdate,                               -- 20 dat_ing
                                         sysdate,                               -- 21 dat_ult_atu
                                         user,                                  -- 22 nom_usu_ult_atu
                                         v_nom_rotina,                          -- 23 nom_pro_ult_atu
                                         '0',                                   -- 24 num_dr_lote
                                         fnc_valida_numero(arc.val_contrib_servidor)/10000,             -- 25 val_sal_contrib_inf
                                         trunc(fnc_valida_data(arc.dat_arrecadacao, 'RRRRMMDD'), 'MM'), -- 26 dat_comp_pag_benf
                                         NULL,                                  -- 27 val_dev_cont
                                         NULL,                                  -- 28 val_dif_cont
                                         '0',                                   -- 29 cod_cobranca
                                         arc.cod_entidade,                      -- 30 cod_entidade_origem
                                         v_cod_manual,                          -- 31 cod_manual
                                         '6',                                   -- 32 cod_operacao
                                         NULL);                                 -- 33 dat_ref

                                end if;

                            end if;

                           /* a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',             v_tb_arrecadacao.cod_ins,               arc.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',         v_tb_arrecadacao.cod_ide_cli,           arc.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',        v_tb_arrecadacao.cod_entidade,          arc.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',            v_tb_arrecadacao.cod_pccs,              nvl(v_tb_arrecadacao.cod_pccs, v_cod_pccs));
                            SP_INCLUI_LOG(a_log, 'COD_CARGO',           v_tb_arrecadacao.cod_cargo,             nvl(v_tb_arrecadacao.cod_cargo, v_cod_cargo));
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',       v_tb_arrecadacao.num_matricula,         arc.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',    v_tb_arrecadacao.cod_ide_rel_func,      nvl(v_tb_arrecadacao.cod_ide_rel_func, v_cod_ide_rel_func));
                            SP_INCLUI_LOG(a_log, 'DAT_MES_COMP',        v_tb_arrecadacao.dat_mes_comp,          substr(arc.dat_competencia, 5, 2));
                            SP_INCLUI_LOG(a_log, 'DAT_ANO_COMP',        v_tb_arrecadacao.dat_ano_comp,          substr(arc.dat_competencia, 1, 4));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_ARREC',      v_tb_arrecadacao.cod_tipo_arrec,        arc.cod_tipo_arrecadacao_int);
                            SP_INCLUI_LOG(a_log, 'VAL_SERV_ARREC',      v_tb_arrecadacao.val_serv_arrec,        fnc_valida_numero(arc.val_contrib_servidor_arrec)/10000);
                            SP_INCLUI_LOG(a_log, 'VAL_PER_SERV_ARREC',  v_tb_arrecadacao.val_per_serv_arrec,    fnc_valida_numero(arc.val_percent_contrib_servidor)/100);
                            SP_INCLUI_LOG(a_log, 'VAL_EMP_ARREC',       v_tb_arrecadacao.val_emp_arrec,         fnc_valida_numero(arc.val_contrib_patronal)/10000);
                            SP_INCLUI_LOG(a_log, 'VAL_PER_EMP_ARREC',   v_tb_arrecadacao.val_per_emp_arrec,     fnc_valida_numero(arc.val_percent_contrib_patronal)/100);
                            SP_INCLUI_LOG(a_log, 'VAL_SAL_CONTRIB_INF', v_tb_arrecadacao.val_sal_contrib_inf,   fnc_valida_numero(arc.val_contrib_servidor)/10000);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE_ORIGEM', v_tb_arrecadacao.cod_entidade_origem,   arc.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_MANUAL',          v_tb_arrecadacao.cod_manual,            nvl(v_cod_manual, v_tb_arrecadacao.cod_manual));
                            SP_INCLUI_LOG(a_log, 'DAT_ARREC',           to_char(v_tb_arrecadacao.dat_arrec, 'dd/mm/yyyy hh24:mi'),         to_char(trunc(fnc_valida_data(arc.dat_arrecadacao, 'RRRRMMDD'), 'MM'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_COMP_PAG_BENF',   to_char(v_tb_arrecadacao.dat_comp_pag_benf, 'dd/mm/yyyy hh24:mi'), to_char(trunc(fnc_valida_data(arc.dat_arrecadacao, 'RRRRMMDD'), 'MM'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'NUM_DR_LOTE',         v_tb_arrecadacao.num_dr_lote,           nvl(v_tb_arrecadacao.num_dr_lote, '0'));
                            SP_INCLUI_LOG(a_log, 'COD_COBRANCA',        v_tb_arrecadacao.cod_cobranca,          nvl(v_tb_arrecadacao.cod_cobranca, '0'));
                            SP_INCLUI_LOG(a_log, 'COD_OPERACAO',        v_tb_arrecadacao.cod_operacao,          nvl(v_tb_arrecadacao.cod_operacao, '6'));

                            SP_GRAVA_LOG(i_id_header, arc.id_processo, arc.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_ARRECADACAO', v_nom_rotina, a_log);
                            */
                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, arc.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, arc.id_processo, arc.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, arc.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, arc.id_processo, arc.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, arc.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_ARC;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_ARC (i_arc       in     r_arc,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                       varchar2(2000);
        v_des_result                    varchar2(4000);

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_arc.cod_ins, i_arc.cod_entidade);
        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_arc.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_arc.id_vinculo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo do servidor não foi informada');
        end if;

        if (i_arc.dat_competencia is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_COMPETENCIA', 'Data de competencia não foi informada');
        elsif (length(i_arc.dat_competencia) < 8 or fnc_valida_data(i_arc.dat_competencia, 'RRRRMMDD') is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_COMPETENCIA', 'Data de competencia informada ('||i_arc.dat_competencia||') esta invalida');
        end if;

        if (i_arc.dat_arrecadacao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_ARRECADACAO', 'Data de arrecadação não foi informada');
        elsif (length(i_arc.dat_arrecadacao) < 8 or fnc_valida_data(i_arc.dat_arrecadacao, 'RRRRMMDD') is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_ARRECADACAO', 'Data de arrecadação informada ('||i_arc.dat_arrecadacao||') esta invalida');
        end if;

        if (i_arc.val_contrib_servidor_arrec is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_CONTRIB_SERVIDOR_ARREC', 'Valor recolhido da contribuição do servidor não foi informado');
        elsif (fnc_valida_numero(i_arc.val_contrib_servidor_arrec) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_CONTRIB_SERVIDOR_ARREC', 'Valor recolhido da contribuição do servidor que foi informado ('||i_arc.val_contrib_servidor_arrec||') esta invalido');
        end if;

        if (i_arc.val_percent_contrib_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PERCENT_CONTRIB_SERVIDOR', 'Valor percentual da contribuição do servidor não foi informado');
        elsif (fnc_valida_numero(i_arc.val_percent_contrib_servidor) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PERCENT_CONTRIB_SERVIDOR', 'Valor percentual da contribuição do servidor que foi informado ('||i_arc.val_percent_contrib_servidor||') esta invalido');
        end if;

        if (i_arc.val_contrib_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_CONTRIB_SERVIDOR', 'Valor da contribuição do servidor não foi informado');
        elsif (fnc_valida_numero(i_arc.val_contrib_servidor) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_CONTRIB_SERVIDOR', 'Valor da contribuição do servidor que foi informado ('||i_arc.val_contrib_servidor||') esta invalido');
        end if;

        if (i_arc.val_percent_contrib_patronal is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PERCENT_CONTRIB_PATRONAL', 'Valor percentual da contribuição patronal não foi informado');
        elsif (fnc_valida_numero(i_arc.val_percent_contrib_patronal) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_PERCENT_CONTRIB_PATRONAL', 'Valor percentual da contribuição patronal que foi informado ('||i_arc.val_percent_contrib_patronal||') esta invalido');
        end if;

        if (i_arc.val_contrib_patronal is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_CONTRIB_PATRONAL', 'Valor da contribuição patronal não foi informado');
        elsif (fnc_valida_numero(i_arc.val_contrib_patronal) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VAL_CONTRIB_PATRONAL', 'Valor da contribuição patronal que foi informado ('||i_arc.val_contrib_patronal||') esta invalido');
        end if;

        if (i_arc.cod_tipo_arrecadacao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_ARRECADACAO', 'Codigo do tipo de arrecadação não foi informado');
        elsif (i_arc.cod_tipo_arrecadacao_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_ARRECADACAO', 'Codigo informado para o tipo de arrecadação ('||i_arc.cod_tipo_arrecadacao||') não previsto');
        end if;


        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_ARC;

    -----------------------------------------------------------------------------------------------

    PROCEDURE SP_CARREGA_FGR (i_id_header in number) IS

        v_result                varchar2(2000);
        v_cur_id                tb_carga_gen_fgr.id%type;
        v_flg_acao_postergada   tb_carga_gen_processo.flg_acao_postergada%type;
        v_cod_tipo_ocorrencia   tb_carga_gen_log.cod_tipo_ocorrencia%type;
        v_cod_situ_ocorrencia   tb_carga_gen_log.cod_situ_ocorrencia%type;
        a_validar               t_validar;
        a_log                   t_log;
        v_nom_rotina            varchar2(100) := 'PAC_CARGA_GENERICA.SP_CARREGA_FGR';
        v_nom_tabela            varchar2(100) := 'TB_CARGA_GEN_FGR';
        v_cod_grat              tb_gratificacao.cod_grat%type;
        v_tb_gratificacao       tb_gratificacao%rowtype;
        v_cod_cargo             tb_rel_func_periodo_exerc.cod_cargo%type;
        v_cod_pccs              tb_rel_func_periodo_exerc.cod_pccs%type;
        v_cod_ide_rel_func      tb_rel_func_periodo_exerc.cod_ide_rel_func%type;
        v_val_percent_incorp    tb_gratificacao.val_percent_incorp%type;
        v_val_fixo_incorp       tb_gratificacao.val_fixo_incorp%type;
        v_num_seq_grat          tb_gratificacao.num_seq_grat%type;
        v_id_log_erro           number;
        v_msg_erro              varchar2(4000);

    BEGIN

        sp_busca_dados_processo(i_id_header, v_flg_acao_postergada, v_cod_situ_ocorrencia, v_result);

        if (v_result is null) then

            loop

                v_cur_id := null;

                for fgr in (select a.cod_ins,
                                   trim(a.cod_entidade)              cod_entidade,
                                   trim(a.id_servidor)               id_servidor,
                                   trim(a.id_vinculo)                id_vinculo,
                                   trim(a.cod_gratificacao)          cod_gratificacao,
                                   trim(a.cod_natureza_gratificacao) cod_natureza_gratificacao,
                                   trim(a.vlr_pct_gratificacao)      vlr_pct_gratificacao,
                                   trim(a.dat_publicacao)            dat_publicacao,
                                   trim(a.cod_tipo_doc)              cod_tipo_doc,
                                   fnc_codigo_ext(a.cod_ins, 2019, trim(a.cod_tipo_doc),   null, 'cod_par') cod_tipo_doc_int,
                                   trim(a.num_doc)                   num_doc,
                                   trim(a.dat_incorporacao)          dat_incorporacao,
                                   trim(a.dat_inicio_gratificacao)   dat_inicio_gratificacao,
                                   trim(a.dat_fim_gratificacao)      dat_fim_gratificacao,
                                   a.id, a.num_linha_header, a.id_processo,
                                   d.cod_ide_cli
                            from tb_carga_gen_fgr a
                                left outer join tb_carga_gen_ident_ext d
                                    on      a.cod_ins      = d.cod_ins
                                        and a.id_servidor  = d.cod_ide_cli_ext
                                        and a.cod_entidade = d.cod_entidade
                            where a.id_header = i_id_header
                              and a.cod_status_processamento = '1'
                              and rownum <= 100
                            order by a.id_header, a.num_linha_header
                            for update nowait) loop

                    v_cur_id              := fgr.id;

                    BEGIN

                        savepoint sp1;

                        if (fgr.dat_publicacao is not null and fnc_valida_numero(fgr.dat_publicacao) = 0) then
                            fgr.dat_publicacao := null;
                        end if;

                        if (fgr.dat_incorporacao is not null and fnc_valida_numero(fgr.dat_incorporacao) = 0) then
                            fgr.dat_incorporacao := null;
                        end if;

                        if (fgr.dat_inicio_gratificacao is not null and fnc_valida_numero(fgr.dat_inicio_gratificacao) = 0) then
                            fgr.dat_inicio_gratificacao := null;
                        end if;

                        if (fgr.dat_fim_gratificacao is not null and fnc_valida_numero(fgr.dat_fim_gratificacao) = 0) then
                            fgr.dat_fim_gratificacao := null;
                        end if;

                        v_result := FNC_VALIDA_FGR(fgr, a_validar);

                        if (v_result is null) then

                            v_cod_cargo        := null;
                            v_cod_pccs         := null;
                            v_cod_ide_rel_func := null;

                            begin
                                select cod_cargo, cod_pccs, cod_ide_rel_func
                                into   v_cod_cargo, v_cod_pccs, v_cod_ide_rel_func
                                from tb_rel_func_periodo_exerc
                                where cod_ins       = fgr.cod_ins
                                  and cod_ide_cli   = fgr.cod_ide_cli
                                  and cod_entidade  = fgr.cod_entidade
                                  and trunc(dat_ini_exerc, 'MM') <= fnc_valida_data(fgr.dat_inicio_gratificacao, 'RRRRMMDD')
                                  and (   dat_fim_exerc is null
                                       or dat_fim_exerc >= fnc_valida_data(fgr.dat_inicio_gratificacao, 'RRRRMMDD'))
                                  and rownum        <= 1;
                            exception
                                when no_data_found then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', 'não foi possivel localizar o codigo do PCCS', 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', 'não foi possivel localizar o codigo do Cargo', 'Codigo do Cargo');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_REL_FUNC', 'não foi possivel localizar o codigo da relação funcional', 'Codigo da Relação Funcional');
                                    v_result := 'Erro de validação';

                                when others then
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_PCCS', substr('Erro ao verificar codigo do PCCS: '||sqlerrm, 1, 4000), 'Codigo do PCCS');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_CARGO', substr('Erro ao verificar codigo do Cargo: '||sqlerrm, 1, 4000), 'Codigo do Cargo');
                                    SP_INCLUI_ERRO_VALIDACAO(a_validar, 'COD_IDE_REL_FUNC', substr('Erro ao verificar o codigo da relação funcional', 1, 4000), 'Codigo da Relação Funcional');
                                    v_result := 'Erro de validação';
                            end;

                        end if;

                        if (v_result is null) then

                            v_cod_grat           := fnc_busca_cod_rubrica(fgr.cod_ins, fgr.cod_entidade, fgr.cod_gratificacao);
                            v_val_fixo_incorp    := null;
                            v_val_percent_incorp := null;

                            if (fgr.cod_natureza_gratificacao = 1) then -- valor fixo
                                v_val_fixo_incorp := fnc_valida_numero(fgr.vlr_pct_gratificacao)/10000;
                            else
                                v_val_percent_incorp := fnc_valida_numero(fgr.vlr_pct_gratificacao)/10000;
                            end if;

                            v_tb_gratificacao := null;

                            begin
                                select *
                                into v_tb_gratificacao
                                from tb_gratificacao
                                where cod_ins          = fgr.cod_ins
                                  and cod_ide_cli      = fgr.cod_ide_cli
                                  and cod_entidade     = fgr.cod_entidade
                                  and num_matricula    = fgr.id_servidor
                                  and cod_ide_rel_func = v_cod_ide_rel_func
                                  and dat_ini_grat     = fnc_valida_data(fgr.dat_inicio_gratificacao, 'RRRRMMDD');

                            exception
                                when others then
                                    null;
                            end;

                            if (v_tb_gratificacao.cod_ins is not null) then -- registro ja existe em tb_gratificacao, atualiza os demais dados

                                v_cod_tipo_ocorrencia := 'A';

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    update tb_gratificacao
                                    set cod_grat            = v_cod_grat,
                                        val_percent_incorp  = nvl(v_val_percent_incorp, val_percent_incorp),
                                        dat_pub             = nvl(fnc_valida_data(fgr.dat_publicacao, 'RRRRMMDD'), dat_pub),
                                        dat_incorp          = nvl(fnc_valida_data(fgr.dat_incorporacao, 'RRRRMMDD'), dat_incorp),
                                        dat_fim_grat        = nvl(fnc_valida_data(fgr.dat_fim_gratificacao, 'RRRRMMDD'), dat_fim_grat),
                                        val_fixo_incorp     = nvl(v_val_fixo_incorp, val_fixo_incorp),
                                        cod_tipo_doc_assoc  = nvl(fgr.cod_tipo_doc_int, cod_tipo_doc_assoc),
                                        num_doc_assoc       = nvl(fgr.num_doc, num_doc_assoc),
                                        dat_ult_atu         = sysdate,
                                        nom_usu_ult_atu     = user,
                                        nom_pro_ult_atu     = v_nom_rotina
                                    where cod_ins          = v_tb_gratificacao.cod_ins
                                      and cod_ide_cli      = v_tb_gratificacao.cod_ide_cli
                                      and cod_entidade     = v_tb_gratificacao.cod_entidade
                                      and num_matricula    = v_tb_gratificacao.num_matricula
                                      and cod_ide_rel_func = v_tb_gratificacao.cod_ide_rel_func
                                      and num_seq_grat     = v_tb_gratificacao.num_seq_grat;

                                end if;

                            else                        -- registro não existe, inclui

                                v_cod_tipo_ocorrencia := 'I';

                                v_num_seq_grat := seq_num_seq_grat.nextval;

                                if (nvl(v_flg_acao_postergada, '1') = '0') then -- Ação imediata, não postergada

                                    insert into tb_gratificacao
                                        (cod_ins,               --  1
                                         cod_ide_cli,           --  2
                                         cod_entidade,          --  3
                                         cod_pccs,              --  4
                                         cod_cargo,             --  5
                                         num_matricula,         --  6
                                         cod_ide_rel_func,      --  7
                                         num_seq_grat,          --  8
                                         cod_grat,              --  9
                                         val_percent_incorp,    -- 10
                                         dat_pub,               -- 11
                                         dat_incorp,            -- 12
                                         dat_ini_grat,          -- 13
                                         dat_fim_grat,          -- 14
                                         dat_ing,               -- 15
                                         dat_ult_atu,           -- 16
                                         nom_usu_ult_atu,       -- 17
                                         nom_pro_ult_atu,       -- 18
                                         qtd_ats,               -- 19
                                         val_fixo_incorp,       -- 20
                                         cod_tipo_doc_assoc,    -- 21
                                         num_doc_assoc)         -- 22
                                    values
                                        (fgr.cod_ins,               --  1 cod_ins
                                         fgr.cod_ide_cli,           --  2 cod_ide_cli
                                         fgr.cod_entidade,          --  3 cod_entidade
                                         v_cod_pccs,                --  4 cod_pccs
                                         v_cod_cargo,               --  5 cod_cargo
                                         fgr.id_servidor,           --  6 num_matricula
                                         v_cod_ide_rel_func,        --  7 cod_ide_rel_func
                                         v_num_seq_grat,            --  8 num_seq_grat
                                         v_cod_grat,                --  9 cod_grat
                                         v_val_percent_incorp,      -- 10 val_percent_incorp
                                         fnc_valida_data(fgr.dat_publicacao, 'RRRRMMDD'),          -- 11 dat_pub
                                         fnc_valida_data(fgr.dat_incorporacao, 'RRRRMMDD'),        -- 12 dat_incorp
                                         fnc_valida_data(fgr.dat_inicio_gratificacao, 'RRRRMMDD'), -- 13 dat_ini_grat
                                         fnc_valida_data(fgr.dat_fim_gratificacao, 'RRRRMMDD'),    -- 14 dat_fim_grat
                                         sysdate,                   -- 15 dat_ing
                                         sysdate,                   -- 16 dat_ult_atu
                                         user,                      -- 17 nom_usu_ult_atu
                                         v_nom_rotina,              -- 18 nom_pro_ult_atu
                                         NULL,                      -- 19 qtd_ats
                                         v_val_fixo_incorp,         -- 20 val_fixo_incorp
                                         fgr.cod_tipo_doc_int,      -- 21 cod_tipo_doc_assoc
                                         fgr.num_doc);              -- 22 num_doc_assoc
                                end if;

                            end if;

                            a_log.delete;
                            SP_INCLUI_LOG(a_log, 'COD_INS',            v_tb_gratificacao.cod_ins,            fgr.cod_ins);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_CLI',        v_tb_gratificacao.cod_ide_cli,        fgr.cod_ide_cli);
                            SP_INCLUI_LOG(a_log, 'COD_ENTIDADE',       v_tb_gratificacao.cod_entidade,       fgr.cod_entidade);
                            SP_INCLUI_LOG(a_log, 'COD_PCCS',           v_tb_gratificacao.cod_pccs,           nvl(v_tb_gratificacao.cod_pccs, v_cod_pccs));
                            SP_INCLUI_LOG(a_log, 'COD_CARGO',          v_tb_gratificacao.cod_cargo,          nvl(v_tb_gratificacao.cod_cargo, v_cod_cargo));
                            SP_INCLUI_LOG(a_log, 'NUM_MATRICULA',      v_tb_gratificacao.num_matricula,      fgr.id_servidor);
                            SP_INCLUI_LOG(a_log, 'COD_IDE_REL_FUNC',   v_tb_gratificacao.cod_ide_rel_func,   v_cod_ide_rel_func);
                            SP_INCLUI_LOG(a_log, 'NUM_SEQ_GRAT',       v_tb_gratificacao.num_seq_grat,       nvl(v_num_seq_grat, v_tb_gratificacao.num_seq_grat));
                            SP_INCLUI_LOG(a_log, 'COD_GRAT',           v_tb_gratificacao.cod_grat,           v_cod_grat);
                            SP_INCLUI_LOG(a_log, 'VAL_PERCENT_INCORP', v_tb_gratificacao.val_percent_incorp, nvl(v_val_percent_incorp, v_tb_gratificacao.val_percent_incorp));
                            SP_INCLUI_LOG(a_log, 'VAL_FIXO_INCORP',    v_tb_gratificacao.val_fixo_incorp,    nvl(v_val_fixo_incorp, v_tb_gratificacao.val_fixo_incorp));
                            SP_INCLUI_LOG(a_log, 'COD_TIPO_DOC_ASSOC', v_tb_gratificacao.cod_tipo_doc_assoc, nvl(fgr.cod_tipo_doc_int, v_tb_gratificacao.cod_tipo_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'NUM_DOC_ASSOC',      v_tb_gratificacao.num_doc_assoc,      nvl(fgr.num_doc, v_tb_gratificacao.num_doc_assoc));
                            SP_INCLUI_LOG(a_log, 'DAT_PUB',            to_char(v_tb_gratificacao.dat_pub, 'dd/mm/yyyy hh24:mi'),      to_char(nvl(fnc_valida_data(fgr.dat_publicacao, 'RRRRMMDD'), v_tb_gratificacao.dat_pub), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_INCORP',         to_char(v_tb_gratificacao.dat_incorp, 'dd/mm/yyyy hh24:mi'),   to_char(nvl(fnc_valida_data(fgr.dat_incorporacao, 'RRRRMMDD'), v_tb_gratificacao.dat_incorp), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_INI_GRAT',       to_char(v_tb_gratificacao.dat_ini_grat, 'dd/mm/yyyy hh24:mi'), to_char(fnc_valida_data(fgr.dat_inicio_gratificacao, 'RRRRMMDD'), 'dd/mm/yyyy hh24:mi'));
                            SP_INCLUI_LOG(a_log, 'DAT_FIM_GRAT',       to_char(v_tb_gratificacao.dat_fim_grat, 'dd/mm/yyyy hh24:mi'), to_char(nvl(fnc_valida_data(fgr.dat_fim_gratificacao, 'RRRRMMDD'), v_tb_gratificacao.dat_fim_grat), 'dd/mm/yyyy hh24:mi'));

                            SP_GRAVA_LOG(i_id_header, fgr.id_processo, fgr.num_linha_header, v_cod_tipo_ocorrencia,
                                         v_cod_situ_ocorrencia, 'USER_IPESP', 'TB_GRATIFICACAO', v_nom_rotina, a_log);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fgr.id, '3', null, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        else

                            SP_GRAVA_ERRO(i_id_header, fgr.id_processo, fgr.num_linha_header, v_nom_rotina, a_validar);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fgr.id, '4', v_result, v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                        end if;

                    EXCEPTION
                        WHEN OTHERS THEN

                            v_msg_erro := substr(sqlerrm, 1, 4000);

                            rollback to sp1;

                            SP_GRAVA_ERRO(i_id_header, fgr.id_processo, fgr.num_linha_header, v_nom_rotina,  a_validar, v_msg_erro);

                            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, fgr.id, '4', 'Erro de processamento', v_nom_rotina) != 'TRUE') then
                                raise ERRO_GRAVA_STATUS;
                            end if;

                    END;

                end loop;

                exit when v_cur_id is null;

                commit;

            end loop;

            sp_atualiza_header(v_nom_tabela, i_id_header, v_nom_rotina);

        else
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel recuperar dados do processo: '||v_result, v_id_log_erro);
        end if;

    EXCEPTION

        WHEN erro_grava_status THEN
            rollback;

        WHEN row_locked THEN
            sp_registra_log_bd(v_nom_rotina, 'I_ID_HEADER:'||i_id_header, 'não foi possivel reservar registros da tabela '||v_nom_tabela, v_id_log_erro);

        WHEN OTHERS THEN

            if (FNC_GRAVA_STATUS_PROCESSAMENTO(v_nom_tabela, v_cur_id, '4', sqlerrm, v_nom_rotina) != 'TRUE') then
                rollback;
            else
                commit;
            end if;

    END SP_CARREGA_FGR;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_FGR (i_fgr       in     r_fgr,
                             o_a_validar in out t_validar)
            return varchar2 IS

        v_retorno                   varchar2(2000);
        v_des_result                varchar2(4000);
        v_dat_inicio_gratificacao   date;
        v_dat_fim_gratificacao      date;

    BEGIN

        o_a_validar.delete;

        v_des_result := fnc_valida_cod_entidade(i_fgr.cod_ins, i_fgr.cod_entidade);
        if (v_des_result is not null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_ENTIDADE', substr(v_des_result, 6));
        end if;

        if (i_fgr.id_servidor is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_SERVIDOR', 'Identificação do servidor não foi informada');
        end if;

        if (i_fgr.id_vinculo is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'ID_VINCULO', 'Identificação do vinculo do servidor não foi informada');
        end if;

        if (i_fgr.cod_gratificacao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_GRATIFICACAO', 'Codigo da gratificação não foi informado');
        else
            v_des_result := fnc_busca_cod_rubrica(i_fgr.cod_ins, i_fgr.cod_entidade, i_fgr.cod_gratificacao);
            if (v_des_result is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_GRATIFICACAO', 'Cogido da gratificação informado ('||i_fgr.cod_gratificacao||') não previsto');
            elsif (v_des_result like 'Erro:%') then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_GRATIFICACAO', substr(v_des_result, 6));
            end if;
        end if;

        if (i_fgr.cod_natureza_gratificacao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_NATUREZA_GRATIFICACAO', 'Natureza da gratificação não foi informada');
        elsif (i_fgr.cod_natureza_gratificacao not in ('1', '2')) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_NATUREZA_GRATIFICACAO', 'Natureza da gratificação informada ('||i_fgr.cod_natureza_gratificacao||') não prevista');
        end if;

        if (fnc_valida_numero(i_fgr.vlr_pct_gratificacao) is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'VLR_PCT_GRATIFICACAO', 'Valor/percentual da gratificação não foi informado');
        end if;

        if (    (i_fgr.dat_publicacao is not null)
            and (   (length(i_fgr.dat_publicacao) < 8)
                 or (fnc_valida_data(i_fgr.dat_publicacao, 'RRRRMMDD') is null))) then

            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_PUBLICACAO', 'Data de publicação ('||i_fgr.dat_publicacao||') esta invalida');

        end if;

        if (i_fgr.cod_tipo_doc is not null and i_fgr.cod_tipo_doc_int is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_TIPO_DOC', 'Codigo do tipo de documento associado a gratificação ('||i_fgr.cod_tipo_doc||') não previsto');
        end if;

        if (    (i_fgr.dat_incorporacao is not null)
            and (   (length(i_fgr.dat_incorporacao) < 8)
                 or (fnc_valida_data(i_fgr.dat_incorporacao, 'RRRRMMDD') is null))) then

            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INCORPORACAO', 'Data de incorporação ('||i_fgr.dat_incorporacao||') esta invalida');

        end if;

        if (i_fgr.dat_inicio_gratificacao is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INICIO_GRATIFICACAO', 'Data de inicio da gratificação não foi informada');
        else
            v_dat_inicio_gratificacao := fnc_valida_data(i_fgr.dat_inicio_gratificacao, 'RRRRMMDD');
            if (length(i_fgr.dat_inicio_gratificacao) < 8 or v_dat_inicio_gratificacao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_INICIO_GRATIFICACAO', 'Data de inicio da gratificação ('||i_fgr.dat_inicio_gratificacao||') esta invalida');
            end if;
        end if;

        if (i_fgr.dat_fim_gratificacao is not null) then
            v_dat_fim_gratificacao := fnc_valida_data(i_fgr.dat_fim_gratificacao, 'RRRRMMDD');
            if (length(i_fgr.dat_fim_gratificacao) < 8 or v_dat_fim_gratificacao is null) then
                SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_GRATIFICACAO', 'Data de fim da gratificação ('||i_fgr.dat_fim_gratificacao||') esta invalida');
            end if;
        end if;

        if (v_dat_inicio_gratificacao is not null and v_dat_fim_gratificacao is not null and v_dat_inicio_gratificacao > v_dat_fim_gratificacao) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'DAT_FIM_GRATIFICACAO', 'Data de fim da gratificação ('||i_fgr.dat_fim_gratificacao||') e anterior a data de inicio ('||i_fgr.dat_inicio_gratificacao||')');
        end if;

        if (i_fgr.cod_ide_cli is null) then
            SP_INCLUI_ERRO_VALIDACAO(o_a_validar, 'COD_IDE_CLI', 'Codigo interno de identificação do servidor não localizado', 'Codigo interno de identificação do servidor');
        end if;

        if (o_a_validar.first is not null) then
            v_retorno := 'Erro de validação';
        end if;

        return (v_retorno);

    EXCEPTION
        WHEN OTHERS THEN

            return (substr(sqlerrm, 1, 2000));

    END FNC_VALIDA_FGR;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_ORG_NIVEL_SUP (i_cod_ins                   in number,
                                       i_cod_entidade              in number,
                                       i_cod_orgao_nivel_sup       in varchar2,
                                       i_des_sigla_orgao_nivel_sup in varchar2) RETURN VARCHAR2 IS

        v_retorno       varchar2(2000);
        v_des_sigla     tb_orgao.des_sigla%type;
        v_result        varchar2(1);

    BEGIN

        if (i_cod_orgao_nivel_sup is not null) then

            begin
                select 'x'
                into v_result
                from tb_orgao
                where cod_orgao_ext = i_cod_orgao_nivel_sup;
            exception
                when others then
                    null;
            end;

            if (v_result is null) then

                v_retorno := 'Codigo do org?o de nivel superior ('||i_cod_orgao_nivel_sup||')não localizado';

            end if;
            /*
            if (i_des_sigla_orgao_nivel_sup is not null) then

                select upper(trim(des_sigla))
                into v_des_sigla
                from tb_orgao
                where cod_ins       = i_cod_ins
                  and cod_entidade  = i_cod_entidade
                  and cod_orgao_ext = i_cod_orgao_nivel_sup;

                if (v_des_sigla != upper(trim(i_des_sigla_orgao_nivel_sup))) then

                    v_retorno := 'Sigla para o org?o superior '||
                                    i_cod_ins||'-'||i_cod_entidade||'-'||i_cod_orgao_nivel_sup||
                                    ' ('||v_des_sigla||') e diferente do esperado ('||
                                    upper(trim(i_des_sigla_orgao_nivel_sup))||')';

                end if;

            else

                v_retorno := 'Sigla para o org?o superior '||
                                i_cod_ins||'-'||i_cod_entidade||'-'||i_cod_orgao_nivel_sup||
                                ' não foi informada';
            end if;
            */

        end if;

        return (v_retorno);

    EXCEPTION

        WHEN NO_DATA_FOUND THEN
            return ('Nenhum org?o cadastrado com a chave '||
                        i_cod_ins||'-'||i_cod_entidade||'-'||i_cod_orgao_nivel_sup);

        WHEN TOO_MANY_ROWS THEN
            return ('Mais de um org?o cadastrado com a chave '||
                        i_cod_ins||'-'||i_cod_entidade||'-'||i_cod_orgao_nivel_sup);

        WHEN OTHERS THEN
            return (substr('Erro ao verificar org?o de nivel superior '||
                            i_cod_ins||'-'||i_cod_entidade||'-'||i_cod_orgao_nivel_sup||
                            ': '||sqlerrm, 1, 2000));

    END FNC_VALIDA_ORG_NIVEL_SUP;

    -----------------------------------------------------------------------------------------------
    FUNCTION FNC_VALIDA_DATA (i_data    in varchar2,
                              i_formato in varchar2 default 'AAAAMMDD') RETURN DATE IS

        v_data_conv date;

    BEGIN

        v_data_conv := to_date(i_data, i_formato);

        return (v_data_conv);

    EXCEPTION

        WHEN OTHERS THEN
            return (null);

    END FNC_VALIDA_DATA;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_NUMERO (i_numero    in varchar2) RETURN NUMBER IS

        v_numero_conv number;
        v_nls_config nls_session_parameters.value%type;

    BEGIN

        select value
        into v_nls_config
        from nls_session_parameters
        where parameter = 'NLS_NUMERIC_CHARACTERS';

        if (substr(v_nls_config, 1, 1) = ',') then
            v_numero_conv := to_number(i_numero,
                                       translate(i_numero, '0123456789.,-+', '9999999999GDSS'),
                                       'nls_numeric_characters='',.''');
        else
            v_numero_conv := to_number(i_numero,
                                       translate(i_numero, '0123456789.,-+', '9999999999DGSS'),
                                       'nls_numeric_characters=''.,''');
        end if;

        return (v_numero_conv);

    EXCEPTION

        WHEN OTHERS THEN
            return (null);

    END FNC_VALIDA_NUMERO;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_VALIDA_COD_ENTIDADE (i_cod_ins      in tb_pessoa_fisica.cod_ins%type,
                                      i_cod_entidade in varchar2) RETURN VARCHAR2 IS

        v_retorno varchar2(4000);
        v_achou_entidade varchar2(5);

    BEGIN

        if (i_cod_entidade is null) then
            v_retorno := 'Erro:Codigo da entidade não foi informado';
        else
            begin
                select 'TRUE'
                into v_achou_entidade
                from tb_entidade
                where cod_ins = i_cod_ins
                  and cod_entidade = i_cod_entidade;
            exception
                when no_data_found then
                    v_retorno := 'Erro:Entidade ('||i_cod_entidade||') não esta cadastrada';
                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;
        end if;

        return (v_retorno);

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_VALIDA_COD_ENTIDADE;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_PCCS (i_cod_ins      in tb_entidade.cod_ins%type,
                                 i_cod_entidade in varchar2,
                                 i_sig_pccs     in varchar2) RETURN VARCHAR2 IS

        v_retorno  varchar2(4000);
        v_cod_pccs tb_pccs.cod_pccs%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado. Impossivel verificar o codigo do PCCS';
        elsif (i_cod_entidade is null) then
            v_retorno := 'Erro:Codigo da entidade não foi informado. Impossivel verificar o codigo do PCCS';
        elsif (i_sig_pccs is null) then
            v_retorno := 'Erro:Sigla do PCCS não foi informada';
        else
            begin
                select cod_pccs
                into v_cod_pccs
                from tb_pccs
                where cod_ins = i_cod_ins
                  and cod_entidade = i_cod_entidade
                  and upper(trim(des_sigla)) = upper(trim(i_sig_pccs));
            exception
                when no_data_found then
                    v_retorno := 'Erro:PCCS com sigla ('||i_sig_pccs||') não esta cadastrado para a Instituição ('||
                                    i_cod_ins||'), Entidade ('||i_cod_entidade||')';

                when too_many_rows then
                    v_retorno := 'Erro:Mais de um registro localizado para PCCS com sigla ('||i_sig_pccs||'),'||
                                    ' Instituição ('|| i_cod_ins||'), Entidade ('||i_cod_entidade||')';

                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;
        end if;

        return (nvl(v_retorno, to_char(v_cod_pccs)));

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_PCCS;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_QUADRO (i_cod_ins      in tb_entidade.cod_ins%type,
                                   i_cod_entidade in varchar2,
                                   i_nom_quadro   in varchar2) RETURN VARCHAR2 IS

        v_retorno    varchar2(4000);
        v_cod_quadro tb_quadro.cod_quadro%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado. Impossivel verificar o codigo do quadro profissional';
        elsif (i_cod_entidade is null) then
            v_retorno := 'Erro:Codigo da entidade não foi informado. Impossivel verificar o codigo do quadro profissional';
        elsif (i_nom_quadro is null) then
            v_retorno := 'Erro:Nome do quadro profissional não foi informado';
        else
            begin
                select cod_quadro
                into v_cod_quadro
                from tb_quadro
                where cod_ins = i_cod_ins
                  and cod_entidade = i_cod_entidade
                  and upper(trim(nom_quadro)) = upper(trim(i_nom_quadro))
                  and rownum <= 1;
            exception
                when no_data_found then
                    v_retorno := 'Erro:Quadro profissional ('||i_nom_quadro||') não esta cadastrado';
                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;
        end if;

        return (nvl(v_retorno, to_char(v_cod_quadro)));

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_QUADRO;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_CARREIRA (i_cod_ins      in tb_entidade.cod_ins%type,
                                     i_cod_entidade in varchar2,
                                     i_nom_carreira in varchar2) RETURN VARCHAR2 IS

        v_retorno      varchar2(4000);
        v_cod_carreira tb_carreira.cod_carreira%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado. Impossivel verificar o codigo da carreira';
        elsif (i_cod_entidade is null) then
            v_retorno := 'Erro:Codigo da entidade não foi informado. Impossivel verificar o codigo da carreira';
        elsif (i_nom_carreira is null) then
            v_retorno := 'Erro:Nome da carreira não foi informado';
        else
            begin
                select cod_carreira
                into v_cod_carreira
                from tb_carreira
                where cod_ins = i_cod_ins
                  and cod_entidade = i_cod_entidade
                  and upper(trim(nom_carreira)) = upper(trim(i_nom_carreira))
                  and rownum <= 1;
            exception
                when no_data_found then
                    v_retorno := 'Erro:Carreira ('||i_nom_carreira||') não esta cadastrada';
                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;
        end if;

        return (nvl(v_retorno, to_char(v_cod_carreira)));

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_CARREIRA;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_CLASSE (i_cod_ins      in tb_entidade.cod_ins%type,
                                   i_cod_entidade in varchar2,
                                   i_sig_classe   in varchar2) RETURN VARCHAR2 IS

        v_retorno     varchar2(4000);
        v_cod_classe tb_classe.cod_classe%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado. Impossivel verificar o codigo da classe';
        elsif (i_cod_entidade is null) then
            v_retorno := 'Erro:Codigo da entidade não foi informado. Impossivel verificar o codigo da classe';
        elsif (i_sig_classe is null) then
            v_retorno := 'Erro:Sigla da classe não foi informada';
        else
            begin
                select cod_classe
                into v_cod_classe
                from tb_classe
                where cod_ins = i_cod_ins
                  and cod_entidade = i_cod_entidade
                  and upper(trim(des_sigla)) = upper(trim(i_sig_classe))
                  and rownum <= 1;
            exception
                when no_data_found then
                    v_retorno := 'Erro:Classe ('||i_sig_classe||') não esta cadastrada';
                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;
        end if;

        return (nvl(v_retorno, to_char(v_cod_classe)));

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_CLASSE;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_JORNADA (i_cod_ins     in tb_entidade.cod_ins%type,
                                    i_des_jornada  in varchar2) RETURN VARCHAR2 IS

        v_retorno     varchar2(4000);
        v_cod_jornada tb_jornada.cod_jornada%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado. Impossivel verificar o codigo da jornada';
        elsif (i_des_jornada is null) then
            v_retorno := 'Erro:Descrição da jornada não foi informada';
        else
            begin
                select cod_jornada
                into v_cod_jornada
                from tb_jornada
                where cod_ins = i_cod_ins
                  and upper(trim(cod_jor_orig)) = upper(trim(i_des_jornada))
                  and rownum <= 1;
            exception
                when no_data_found then
                    v_retorno := 'Erro:Jornada ('||i_des_jornada||') não esta cadastrada';
                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;
        end if;

        return (nvl(v_retorno, to_char(v_cod_jornada)));

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_JORNADA;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_NIVEL (i_des_grau_nivel in varchar2) RETURN VARCHAR2 IS

        v_retorno     varchar2(4000);

    BEGIN

        if (fnc_valida_numero(substr(trim(i_des_grau_nivel), 1, 1)) is not null) then
            v_retorno := substr(trim(i_des_grau_nivel), 1, 1);
        end if;

        if (fnc_valida_numero(substr(trim(i_des_grau_nivel), 2, 1)) is not null) then
            v_retorno := v_retorno || substr(trim(i_des_grau_nivel), 2, 1);
        end if;

        return (v_retorno);

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_NIVEL;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_GRAU (i_des_grau_nivel in varchar2) RETURN VARCHAR2 IS

        v_retorno     varchar2(4000);

    BEGIN

        if (fnc_valida_numero(substr(trim(i_des_grau_nivel), length(trim(i_des_grau_nivel)), 1)) is null) then
            v_retorno := substr(trim(i_des_grau_nivel), length(trim(i_des_grau_nivel)), 1);
        end if;

        if (fnc_valida_numero(substr(trim(i_des_grau_nivel), length(trim(i_des_grau_nivel)) - 1, 1)) is null) then
            v_retorno := substr(trim(i_des_grau_nivel), length(trim(i_des_grau_nivel)) - 1, 1) || v_retorno;
        end if;

        return (v_retorno);

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_GRAU;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_COD_RUBRICA (i_cod_ins      in tb_entidade.cod_ins%type,
                                    i_cod_entidade in varchar2,
                                    i_cod_verba    in varchar2) RETURN VARCHAR2 IS

        v_retorno     varchar2(4000);
        v_cod_rubrica tb_ficha_fin_rubrica.cod_rubrica%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado. Impossivel verificar o codigo da rubrica';
        elsif (i_cod_verba is null) then
            v_retorno := 'Erro:Codigo da verba não foi informado';
        else
            begin
                select cod_rubrica
                into v_cod_rubrica
                from tb_rubricas_ativos
                where cod_entidade       = i_cod_entidade
                  and cod_rubrica_ativos = i_cod_verba
                  and rownum <= 1;
            exception
                when no_data_found then
                    null;
                when others then
                    v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
            end;

            if (v_cod_rubrica is null) then

                begin
                    select cod_rubrica
                    into v_cod_rubrica
                    from tb_rubricas_ativos
                    where cod_rubrica_ativos = i_cod_verba
                      and rownum <= 1;
                exception
                    when no_data_found then
                        null;
                    when others then
                        v_retorno := substr('Erro:'||sqlerrm, 1, 4000);
                end;
            end if;
        end if;

        return (nvl(v_retorno, to_char(v_cod_rubrica)));

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_COD_RUBRICA;

    -----------------------------------------------------------------------------------------------

    FUNCTION FNC_BUSCA_DOMINIOS_PADRAO (i_cod_ins      in tb_dominios_padrao.cod_ins%type,
                                        i_cod_entidade in tb_dominios_padrao.cod_entidade%type,
                                        i_cod_pccs     in tb_dominios_padrao.cod_pccs%type,
                                        i_cod_cargo    in tb_dominios_padrao.cod_cargo%type,
                                        i_cod_tipo     in tb_dominios_padrao.cod_tipo%type) RETURN VARCHAR2 IS

        v_retorno     varchar2(4000);
        v_cod_rubrica tb_ficha_fin_rubrica.cod_rubrica%type;

    BEGIN

        if (i_cod_ins is null) then
            v_retorno := 'Erro:Codigo da instituição não foi informado';
        elsif (i_cod_entidade is null) then
            v_retorno := 'Erro:Codigo da entidade não foi informado';
        elsif (i_cod_pccs is null) then
            v_retorno := 'Erro:Codigo do PCCS não foi informado';
        elsif (i_cod_cargo is null) then
            v_retorno := 'Erro:Codigo do cargo não foi informado';
        elsif (i_cod_tipo is null) then
            v_retorno := 'Erro:Codigo do tipo não foi informado';
        else
            begin
                select valor_tipo
                into v_retorno
                from tb_dominios_padrao
                where cod_ins      = i_cod_ins
                  and cod_entidade = i_cod_entidade
                  and cod_pccs     = i_cod_pccs
                  and cod_cargo    = i_cod_cargo
                  and cod_tipo     = i_cod_tipo;
            exception
                when others then
                    null;
            end;
        end if;

        return (v_retorno);

    EXCEPTION

        WHEN OTHERS THEN
            return (substr('Erro:'||sqlerrm, 1, 4000));

    END FNC_BUSCA_DOMINIOS_PADRAO;

    -----------------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------------
    PROCEDURE sp_busca_id_insc_perito (i_cod_ins                 in tb_carga_gen_fme.cod_ins%type,
                                       i_num_inscricao_conselho  in tb_carga_gen_fme.num_inscricao_conselho%type,
                                       i_nom_medico              in tb_carga_gen_fme.nom_medico%type,
                                       i_tipo_medico             in char,  -- 'I': PErito Interno 'E' Externo
                                       o_id_num_insc_conselho    out tb_inscricao_conselho.id%type)
    AS
    v_id        number;
    v_id_perito number;
    v_num_insc  number;

    BEGIN
      --
      if i_tipo_medico = 'I' then
        begin
          select a.id
            into v_id
            from tb_inscricao_conselho a
           where a.num_inscricao = i_num_inscricao_conselho;
        exception
          when others then
            v_id := null;
        end;
      elsif i_tipo_medico = 'E' then
        begin
          select b.id
            into v_id
            from tb_inscricao_conselho_externo b
           where b.nome = trim(upper(i_nom_medico));
        exception
          when others then
            v_id := null;
        end;
      end if;
      --
      ---
      o_id_num_insc_conselho :=  v_id;
    END sp_busca_id_insc_perito;
    -----------------------------------------------------------------------------------------------

   FUNCTION CHECK_VALID_SERV (P_NUM_CPF        IN NUMBER,
                              P_MATRICULA      IN NUMBER,
                              P_COD_ENTIDADE   IN NUMBER) RETURN NUMBER IS

        V_COD_IDE_CLI   NUMBER:=NULL;

        CURSOR get_data IS
            SELECT 1
            FROM tb_pessoa_fisica       a,
                 tb_relacao_funcional   b,
                 tb_concessao_beneficio C
            WHERE a.num_cpf             = P_NUM_CPF
            AND a.cod_ins               = b.cod_ins
            AND a.cod_ide_cli           = b.cod_ide_cli
            AND b.num_matricula         = P_MATRICULA
            AND b.cod_entidade          = P_COD_ENTIDADE
            AND A.COD_INS               = c.COD_INS
            AND A.COD_IDE_CLI           = c.COD_IDE_CLI_SERV;

    BEGIN

        OPEN get_data;
        FETCH get_data INTO v_cod_ide_cli;
        CLOSE get_data;

        RETURN V_COD_IDE_CLI;

    EXCEPTION

        WHEN OTHERS THEN
            RETURN NULL;

    END CHECK_VALID_SERV;

    function TiraAcento (pString in varchar2) return varchar2 is
        --
        vStringReturn varchar2(2000);
        --
    begin
        vStringReturn := translate( pString,
                                    'ACEIOUAEIOUAEIOU??EUaceiouaeiouaeiou??eu',
                                    'ACEIOUAEIOUAEIOUAOEUaceiouaeiouaeiouaoeu');
        --
        return vStringReturn;
        --
    END TiraAcento;

    function TiraEspacos (pString in varchar2) return varchar2 is
        --
        vStringReturn varchar2(2000);
        --
    begin
        vStringReturn := TRIM( REPLACE(REPLACE(pString, CHR(13), ''), CHR(32), '') );
        --
        return vStringReturn;
        --
    END TiraEspacos;


    function TiraPontuacao (pString in varchar2) return varchar2 is
        --
        vStringReturn varchar2(2000);
        --
    begin
        vStringReturn := regexp_replace(pString,'[[:punct:]]','');
        --
        return vStringReturn;
        --
    END TiraPontuacao;
    --
    --
     procedure sp_executa_processo(i_id_header  in number,
                                   o_des_erro out varchar2)
    as
      v_dat_processamento date;
      v_nom_processo      tb_carga_Gen_processo.Nom_Processo%type;
      v_nom_rotina        varchar2(120);
    begin
      -- Determina processo
      begin
        select dat_processamento, p.nom_processo
          into  v_dat_processamento, v_nom_processo
          from Tb_Carga_Gen_Header h join tb_carga_Gen_processo p on h.id_processo = p.id
         where h.id = i_id_header;
      exception
        when no_data_found then
          o_des_erro := 'Não localizado Registro de Carga';
          return;
      end;
      --
      --
      if v_dat_processamento is not null then
        o_des_erro := 'Processamento já realizado';
        return;
      end if;
      --
      if uppeR(v_nom_processo) in ('EVF','HFE') THEN
        v_nom_rotina := 'pac_carga_generica_processa.sp_carrega_'||v_nom_processo;
      else
        v_nom_rotina := 'pac_carga_generica.sp_carrega_'||v_nom_processo;
      end if;
      --
      --
      begin
        execute immediate 'begin '||v_nom_rotina||'('||i_id_header||'); end;';

      exception
        when others then
          o_des_erro := 'Erro Geral na chamada da Rotina '||v_nom_rotina||' - '||sqlerrm;
          return;
      end;
      --
      --
    end sp_executa_processo;

END PAC_CARGA_GENERICA;
/
