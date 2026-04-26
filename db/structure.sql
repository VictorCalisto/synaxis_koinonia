SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sch_synaxis_koinonia; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA sch_synaxis_koinonia;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admins; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.admins (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    excluido_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: admins_id_seq; Type: SEQUENCE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE SEQUENCE sch_synaxis_koinonia.admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admins_id_seq; Type: SEQUENCE OWNED BY; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER SEQUENCE sch_synaxis_koinonia.admins_id_seq OWNED BY sch_synaxis_koinonia.admins.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: convites_validadores; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.convites_validadores (
    id bigint NOT NULL,
    email character varying NOT NULL,
    token character varying NOT NULL,
    expira_em timestamp(6) without time zone NOT NULL,
    aceito_em timestamp(6) without time zone,
    admin_id bigint NOT NULL,
    excluido_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: convites_validadores_id_seq; Type: SEQUENCE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE SEQUENCE sch_synaxis_koinonia.convites_validadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: convites_validadores_id_seq; Type: SEQUENCE OWNED BY; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER SEQUENCE sch_synaxis_koinonia.convites_validadores_id_seq OWNED BY sch_synaxis_koinonia.convites_validadores.id;


--
-- Name: eventos; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.eventos (
    id bigint NOT NULL,
    titulo character varying NOT NULL,
    organizacao character varying NOT NULL,
    data_evento timestamp(6) without time zone NOT NULL,
    local character varying NOT NULL,
    cidade character varying NOT NULL,
    descricao text NOT NULL,
    perfil_divulgacao character varying NOT NULL,
    contato_publico character varying NOT NULL,
    valor character varying DEFAULT 'Entrada Franca'::character varying NOT NULL,
    email_submissor character varying,
    token_edicao character varying,
    token_expira_em timestamp(6) without time zone,
    situacao integer DEFAULT 0 NOT NULL,
    aprovado_em timestamp(6) without time zone,
    rejeitado_em timestamp(6) without time zone,
    motivo_rejeicao text,
    caminho_banner character varying NOT NULL,
    excluido_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: eventos_id_seq; Type: SEQUENCE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE SEQUENCE sch_synaxis_koinonia.eventos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: eventos_id_seq; Type: SEQUENCE OWNED BY; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER SEQUENCE sch_synaxis_koinonia.eventos_id_seq OWNED BY sch_synaxis_koinonia.eventos.id;


--
-- Name: postagens_sociais; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.postagens_sociais (
    id bigint NOT NULL,
    evento_id bigint NOT NULL,
    plataforma integer NOT NULL,
    id_externo character varying NOT NULL,
    url_externa character varying,
    publicado_em timestamp(6) without time zone NOT NULL,
    excluido_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: postagens_sociais_id_seq; Type: SEQUENCE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE SEQUENCE sch_synaxis_koinonia.postagens_sociais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postagens_sociais_id_seq; Type: SEQUENCE OWNED BY; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER SEQUENCE sch_synaxis_koinonia.postagens_sociais_id_seq OWNED BY sch_synaxis_koinonia.postagens_sociais.id;


--
-- Name: registros_acao; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.registros_acao (
    id bigint NOT NULL,
    tipo_ator character varying NOT NULL,
    ator_id bigint,
    ator_email character varying,
    evento_id bigint,
    acao character varying NOT NULL,
    detalhes jsonb DEFAULT '{}'::jsonb NOT NULL,
    excluido_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: registros_acao_id_seq; Type: SEQUENCE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE SEQUENCE sch_synaxis_koinonia.registros_acao_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: registros_acao_id_seq; Type: SEQUENCE OWNED BY; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER SEQUENCE sch_synaxis_koinonia.registros_acao_id_seq OWNED BY sch_synaxis_koinonia.registros_acao.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: validadores; Type: TABLE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE TABLE sch_synaxis_koinonia.validadores (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    excluido_em timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: validadores_id_seq; Type: SEQUENCE; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE SEQUENCE sch_synaxis_koinonia.validadores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: validadores_id_seq; Type: SEQUENCE OWNED BY; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER SEQUENCE sch_synaxis_koinonia.validadores_id_seq OWNED BY sch_synaxis_koinonia.validadores.id;


--
-- Name: admins id; Type: DEFAULT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.admins ALTER COLUMN id SET DEFAULT nextval('sch_synaxis_koinonia.admins_id_seq'::regclass);


--
-- Name: convites_validadores id; Type: DEFAULT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.convites_validadores ALTER COLUMN id SET DEFAULT nextval('sch_synaxis_koinonia.convites_validadores_id_seq'::regclass);


--
-- Name: eventos id; Type: DEFAULT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.eventos ALTER COLUMN id SET DEFAULT nextval('sch_synaxis_koinonia.eventos_id_seq'::regclass);


--
-- Name: postagens_sociais id; Type: DEFAULT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.postagens_sociais ALTER COLUMN id SET DEFAULT nextval('sch_synaxis_koinonia.postagens_sociais_id_seq'::regclass);


--
-- Name: registros_acao id; Type: DEFAULT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.registros_acao ALTER COLUMN id SET DEFAULT nextval('sch_synaxis_koinonia.registros_acao_id_seq'::regclass);


--
-- Name: validadores id; Type: DEFAULT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.validadores ALTER COLUMN id SET DEFAULT nextval('sch_synaxis_koinonia.validadores_id_seq'::regclass);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: convites_validadores convites_validadores_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.convites_validadores
    ADD CONSTRAINT convites_validadores_pkey PRIMARY KEY (id);


--
-- Name: eventos eventos_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.eventos
    ADD CONSTRAINT eventos_pkey PRIMARY KEY (id);


--
-- Name: postagens_sociais postagens_sociais_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.postagens_sociais
    ADD CONSTRAINT postagens_sociais_pkey PRIMARY KEY (id);


--
-- Name: registros_acao registros_acao_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.registros_acao
    ADD CONSTRAINT registros_acao_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: validadores validadores_pkey; Type: CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.validadores
    ADD CONSTRAINT validadores_pkey PRIMARY KEY (id);


--
-- Name: index_admins_on_email; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_email ON sch_synaxis_koinonia.admins USING btree (email);


--
-- Name: index_admins_on_excluido_em; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_admins_on_excluido_em ON sch_synaxis_koinonia.admins USING btree (excluido_em);


--
-- Name: index_admins_on_reset_password_token; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE UNIQUE INDEX index_admins_on_reset_password_token ON sch_synaxis_koinonia.admins USING btree (reset_password_token);


--
-- Name: index_convites_validadores_on_admin_id; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_convites_validadores_on_admin_id ON sch_synaxis_koinonia.convites_validadores USING btree (admin_id);


--
-- Name: index_convites_validadores_on_email; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_convites_validadores_on_email ON sch_synaxis_koinonia.convites_validadores USING btree (email);


--
-- Name: index_convites_validadores_on_excluido_em; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_convites_validadores_on_excluido_em ON sch_synaxis_koinonia.convites_validadores USING btree (excluido_em);


--
-- Name: index_convites_validadores_on_token; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE UNIQUE INDEX index_convites_validadores_on_token ON sch_synaxis_koinonia.convites_validadores USING btree (token);


--
-- Name: index_eventos_on_cidade; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_eventos_on_cidade ON sch_synaxis_koinonia.eventos USING btree (cidade);


--
-- Name: index_eventos_on_data_evento; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_eventos_on_data_evento ON sch_synaxis_koinonia.eventos USING btree (data_evento);


--
-- Name: index_eventos_on_excluido_em; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_eventos_on_excluido_em ON sch_synaxis_koinonia.eventos USING btree (excluido_em);


--
-- Name: index_eventos_on_situacao; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_eventos_on_situacao ON sch_synaxis_koinonia.eventos USING btree (situacao);


--
-- Name: index_eventos_on_token_edicao; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE UNIQUE INDEX index_eventos_on_token_edicao ON sch_synaxis_koinonia.eventos USING btree (token_edicao);


--
-- Name: index_postagens_sociais_on_evento_id; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_postagens_sociais_on_evento_id ON sch_synaxis_koinonia.postagens_sociais USING btree (evento_id);


--
-- Name: index_postagens_sociais_on_evento_id_and_plataforma; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_postagens_sociais_on_evento_id_and_plataforma ON sch_synaxis_koinonia.postagens_sociais USING btree (evento_id, plataforma);


--
-- Name: index_postagens_sociais_on_excluido_em; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_postagens_sociais_on_excluido_em ON sch_synaxis_koinonia.postagens_sociais USING btree (excluido_em);


--
-- Name: index_registros_acao_on_acao; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_registros_acao_on_acao ON sch_synaxis_koinonia.registros_acao USING btree (acao);


--
-- Name: index_registros_acao_on_evento_id; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_registros_acao_on_evento_id ON sch_synaxis_koinonia.registros_acao USING btree (evento_id);


--
-- Name: index_registros_acao_on_excluido_em; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_registros_acao_on_excluido_em ON sch_synaxis_koinonia.registros_acao USING btree (excluido_em);


--
-- Name: index_registros_acao_on_tipo_ator_and_ator_id; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_registros_acao_on_tipo_ator_and_ator_id ON sch_synaxis_koinonia.registros_acao USING btree (tipo_ator, ator_id);


--
-- Name: index_validadores_on_email; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE UNIQUE INDEX index_validadores_on_email ON sch_synaxis_koinonia.validadores USING btree (email);


--
-- Name: index_validadores_on_excluido_em; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE INDEX index_validadores_on_excluido_em ON sch_synaxis_koinonia.validadores USING btree (excluido_em);


--
-- Name: index_validadores_on_reset_password_token; Type: INDEX; Schema: sch_synaxis_koinonia; Owner: -
--

CREATE UNIQUE INDEX index_validadores_on_reset_password_token ON sch_synaxis_koinonia.validadores USING btree (reset_password_token);


--
-- Name: postagens_sociais fk_rails_2e438e9044; Type: FK CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.postagens_sociais
    ADD CONSTRAINT fk_rails_2e438e9044 FOREIGN KEY (evento_id) REFERENCES sch_synaxis_koinonia.eventos(id);


--
-- Name: convites_validadores fk_rails_f6e608557e; Type: FK CONSTRAINT; Schema: sch_synaxis_koinonia; Owner: -
--

ALTER TABLE ONLY sch_synaxis_koinonia.convites_validadores
    ADD CONSTRAINT fk_rails_f6e608557e FOREIGN KEY (admin_id) REFERENCES sch_synaxis_koinonia.admins(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO sch_synaxis_koinonia, public;

INSERT INTO "sch_synaxis_koinonia"."schema_migrations" (version) VALUES
('20260424160300'),
('20260424160200'),
('20260424160100'),
('20260424160000'),
('20260424154425'),
('20260424154417'),
('20260424000000');

