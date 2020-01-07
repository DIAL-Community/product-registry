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
-- Name: agg_capabilities; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.agg_capabilities AS ENUM (
    'Transfer to Subscribers',
    'Transfer to Business',
    'Balance Check',
    'Delivery Notification',
    'Reporting',
    'SMPP',
    'HTTP',
    'HTTPS',
    'XML-RPC',
    'FTP',
    'GUI-Self Service',
    'Data Integrity',
    'VPN',
    'Other API Support',
    'Content Management',
    'Subscription Management',
    'Campaign Management',
    'Portal Management',
    'Recommendation Engine',
    'Advertisement Platform',
    'Analytics and Reporting',
    'URL-IP Configuration',
    'Standard Billing',
    'Zero Rated',
    'Reverse Billing',
    'Private APN Provisioning',
    'Business to Subscriber',
    'Subscriber to Business',
    'Bulk Transfer',
    'Alarm Support',
    'Consolidated Reports',
    'Automated realtime alerts',
    'Configure & Monitor Message length',
    'Threshold Monitoring',
    'Spam Control',
    'WhatsApp',
    'Facebook Messenger',
    'Media Streaming',
    'Reliability percent',
    'High Availability',
    'Redundancy',
    'Support',
    'Security Policies',
    'One Way',
    'Two Way',
    'Bulk SMS',
    'Delivery Reports',
    'Sender ID Configuration',
    'Number Masking',
    'Premium Billing',
    'Zero Rating',
    'Dedicated Short Code Provisioning',
    'Shared Short Code',
    'Long Code Provisioning',
    'SMS Spam filter',
    'Automated regulatory compliance',
    'Traffic-Capacity-Bandwidth',
    'Graphical User Interface',
    'Customized User Creation',
    'Session Reports',
    'Hosted Menu',
    'IVR Inbound',
    'IVR Outbound',
    'Leased Lines',
    'VOIP',
    'Hosted IVR Menu',
    'Short Code Provisioning'
);


--
-- Name: digisquare_maturity_level; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.digisquare_maturity_level AS ENUM (
    'low',
    'medium',
    'high'
);


--
-- Name: location_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.location_type AS ENUM (
    'country',
    'point'
);


--
-- Name: mobile_services; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mobile_services AS ENUM (
    'Airtime',
    'API',
    'HS',
    'Mobile-Internet',
    'Mobile-Money',
    'Ops-Maintenance',
    'OTT',
    'SLA',
    'SMS',
    'User-Interface',
    'USSD',
    'Voice'
);


--
-- Name: relationship_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_type AS ENUM (
    'composed',
    'interoperates'
);


--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.user_role AS ENUM (
    'admin',
    'ict4sdg',
    'principle',
    'user',
    'org_user',
    'org_product_user',
    'product_user'
);


SET default_tablespace = '';

--
-- Name: aggregator_capabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aggregator_capabilities (
    id bigint NOT NULL,
    aggregator_id bigint,
    operator_services_id bigint,
    service public.mobile_services,
    capability public.agg_capabilities,
    country_name character varying
);


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aggregator_capabilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aggregator_capabilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aggregator_capabilities_id_seq OWNED BY public.aggregator_capabilities.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: audits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audits (
    id bigint NOT NULL,
    associated_id character varying,
    associated_type character varying,
    user_id integer,
    user_role character varying,
    username character varying,
    action character varying,
    audit_changes jsonb,
    version integer DEFAULT 0,
    comment character varying,
    created_at timestamp without time zone
);


--
-- Name: audits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audits_id_seq OWNED BY public.audits.id;


--
-- Name: building_block_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.building_block_descriptions (
    id bigint NOT NULL,
    building_block_id bigint,
    locale character varying NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.building_block_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_block_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.building_block_descriptions_id_seq OWNED BY public.building_block_descriptions.id;


--
-- Name: building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.building_blocks (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: building_blocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.building_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: building_blocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.building_blocks_id_seq OWNED BY public.building_blocks.id;


--
-- Name: candidate_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website text,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_organizations_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_organizations_contacts (
    candidate_organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone
);


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_organizations_id_seq OWNED BY public.candidate_organizations.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    name character varying,
    slug character varying NOT NULL,
    email character varying,
    title character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contacts_id_seq OWNED BY public.contacts.id;


--
-- Name: deploys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deploys (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    provider character varying,
    instance_name character varying,
    auth_token character varying,
    status character varying,
    message character varying,
    url character varying,
    suite character varying,
    job_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: deploys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deploys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deploys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deploys_id_seq OWNED BY public.deploys.id;


--
-- Name: glossaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.glossaries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: glossaries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.glossaries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: glossaries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.glossaries_id_seq OWNED BY public.glossaries.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id bigint NOT NULL,
    name character varying,
    slug character varying NOT NULL,
    points point[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    location_type public.location_type NOT NULL
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: operator_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operator_services (
    id bigint NOT NULL,
    name character varying,
    locations_id bigint,
    service public.mobile_services
);


--
-- Name: operator_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.operator_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: operator_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.operator_services_id_seq OWNED BY public.operator_services.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying,
    slug character varying NOT NULL,
    when_endorsed timestamp without time zone,
    website character varying,
    is_endorser boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_mni boolean DEFAULT false
);


--
-- Name: organizations_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_contacts (
    organization_id bigint NOT NULL,
    contact_id bigint NOT NULL,
    started_at timestamp without time zone,
    ended_at timestamp without time zone,
    id bigint NOT NULL
);


--
-- Name: organizations_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_contacts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_contacts_id_seq OWNED BY public.organizations_contacts.id;


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: organizations_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_locations (
    location_id bigint NOT NULL,
    organization_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: organizations_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_locations_id_seq OWNED BY public.organizations_locations.id;


--
-- Name: organizations_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_products (
    organization_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: organizations_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_sectors (
    sector_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.origins (
    id bigint NOT NULL,
    organization_id bigint,
    name character varying,
    slug character varying,
    description character varying,
    last_synced timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: origins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.origins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: origins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.origins_id_seq OWNED BY public.origins.id;


--
-- Name: product_assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_assessments (
    id bigint NOT NULL,
    product_id bigint,
    has_osc boolean,
    has_digisquare boolean,
    osc_cd10 boolean,
    osc_cd20 boolean,
    osc_cd21 boolean,
    osc_cd30 boolean,
    osc_cd31 boolean,
    osc_cd40 boolean,
    osc_cd50 boolean,
    osc_cd60 boolean,
    osc_cd61 boolean,
    osc_lc10 boolean,
    osc_lc20 boolean,
    osc_lc30 boolean,
    osc_lc40 boolean,
    osc_lc50 boolean,
    osc_lc60 boolean,
    osc_re10 boolean,
    osc_re30 boolean,
    osc_re40 boolean,
    osc_re50 boolean,
    osc_re60 boolean,
    osc_re70 boolean,
    osc_re80 boolean,
    osc_qu10 boolean,
    osc_qu11 boolean,
    osc_qu12 boolean,
    osc_qu20 boolean,
    osc_qu30 boolean,
    osc_qu40 boolean,
    osc_qu50 boolean,
    osc_qu51 boolean,
    osc_qu52 boolean,
    osc_qu60 boolean,
    osc_qu70 boolean,
    osc_qu71 boolean,
    osc_qu80 boolean,
    osc_qu90 boolean,
    osc_qu100 boolean,
    osc_co10 boolean,
    osc_co20 boolean,
    osc_co30 boolean,
    osc_co40 boolean,
    osc_co50 boolean,
    osc_co60 boolean,
    osc_co70 boolean,
    osc_co71 boolean,
    osc_co72 boolean,
    osc_co73 boolean,
    osc_co80 boolean,
    osc_cs10 boolean,
    osc_cs20 boolean,
    osc_cs30 boolean,
    osc_cs40 boolean,
    osc_cs50 boolean,
    osc_in10 boolean,
    osc_in20 boolean,
    osc_in30 boolean,
    osc_im10 boolean,
    osc_im20 boolean,
    digisquare_country_utilization public.digisquare_maturity_level,
    digisquare_country_strategy public.digisquare_maturity_level,
    digisquare_digital_health_interventions public.digisquare_maturity_level,
    digisquare_source_code_accessibility public.digisquare_maturity_level,
    digisquare_funding_and_revenue public.digisquare_maturity_level,
    digisquare_developer_contributor_and_implementor_community_enga public.digisquare_maturity_level,
    digisquare_community_governance public.digisquare_maturity_level,
    digisquare_software_roadmap public.digisquare_maturity_level,
    digisquare_user_documentation public.digisquare_maturity_level,
    digisquare_multilingual_support public.digisquare_maturity_level,
    digisquare_technical_documentation public.digisquare_maturity_level,
    digisquare_software_productization public.digisquare_maturity_level,
    digisquare_interoperability_and_data_accessibility public.digisquare_maturity_level,
    digisquare_security public.digisquare_maturity_level,
    digisquare_scalability public.digisquare_maturity_level,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_assessments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_assessments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_assessments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_assessments_id_seq OWNED BY public.product_assessments.id;


--
-- Name: product_product_relationships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_product_relationships (
    id bigint NOT NULL,
    from_product_id bigint NOT NULL,
    to_product_id bigint NOT NULL,
    relationship_type public.relationship_type NOT NULL
);


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_product_relationships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_product_relationships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_product_relationships_id_seq OWNED BY public.product_product_relationships.id;


--
-- Name: product_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_versions (
    id bigint NOT NULL,
    product_id bigint,
    version character varying NOT NULL,
    version_order integer NOT NULL
);


--
-- Name: product_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_versions_id_seq OWNED BY public.product_versions.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying,
    slug character varying NOT NULL,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_launchable boolean DEFAULT false,
    start_assessment boolean,
    default_url character varying DEFAULT 'http://<host_ip>'::character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    repository character varying,
    license character varying,
    license_analysis character varying
);


--
-- Name: products_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_building_blocks (
    building_block_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: products_origins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_origins (
    product_id bigint NOT NULL,
    origin_id bigint NOT NULL
);


--
-- Name: products_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_sectors (
    product_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: products_sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products_sustainable_development_goals (
    product_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL
);


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    origin_id bigint,
    start_date date,
    end_date date,
    budget numeric(12,2),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying NOT NULL,
    description character varying NOT NULL,
    slug character varying NOT NULL
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: projects_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_locations (
    project_id bigint NOT NULL,
    location_id bigint NOT NULL
);


--
-- Name: projects_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_organizations (
    project_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: projects_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_products (
    project_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: projects_sdgs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_sdgs (
    project_id bigint NOT NULL,
    sdg_id bigint NOT NULL
);


--
-- Name: projects_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_sectors (
    project_id bigint NOT NULL,
    sector_id bigint NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sdg_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sdg_targets (
    id bigint NOT NULL,
    name character varying,
    target_number character varying,
    slug character varying,
    sdg_number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sdg_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sdg_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sdg_targets_id_seq OWNED BY public.sdg_targets.id;


--
-- Name: sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sectors (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_displayable boolean
);


--
-- Name: sectors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sectors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sectors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sectors_id_seq OWNED BY public.sectors.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    value text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sustainable_development_goals (
    id bigint NOT NULL,
    slug character varying,
    name character varying,
    long_title character varying,
    number integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sustainable_development_goals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sustainable_development_goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sustainable_development_goals_id_seq OWNED BY public.sustainable_development_goals.id;


--
-- Name: use_case_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_descriptions (
    id bigint NOT NULL,
    use_case_id bigint,
    locale character varying NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_descriptions_id_seq OWNED BY public.use_case_descriptions.id;


--
-- Name: use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_cases (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    sector_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: use_cases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_cases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_cases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_cases_id_seq OWNED BY public.use_cases.id;


--
-- Name: use_cases_sdg_targets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_cases_sdg_targets (
    use_case_id bigint NOT NULL,
    sdg_target_id bigint NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role public.user_role DEFAULT 'user'::public.user_role NOT NULL,
    receive_backup boolean DEFAULT false,
    organization_id bigint,
    expired boolean,
    expired_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_products (
    user_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: workflow_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_descriptions (
    id bigint NOT NULL,
    workflow_id bigint,
    locale character varying NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflow_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflow_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflow_descriptions_id_seq OWNED BY public.workflow_descriptions.id;


--
-- Name: workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows (
    id bigint NOT NULL,
    name character varying,
    slug character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '"{}"'::jsonb NOT NULL
);


--
-- Name: workflows_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows_building_blocks (
    workflow_id bigint NOT NULL,
    building_block_id bigint NOT NULL
);


--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workflows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;


--
-- Name: workflows_use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflows_use_cases (
    workflow_id bigint NOT NULL,
    use_case_id bigint NOT NULL
);


--
-- Name: aggregator_capabilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities ALTER COLUMN id SET DEFAULT nextval('public.aggregator_capabilities_id_seq'::regclass);


--
-- Name: audits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits ALTER COLUMN id SET DEFAULT nextval('public.audits_id_seq'::regclass);


--
-- Name: building_block_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_block_descriptions ALTER COLUMN id SET DEFAULT nextval('public.building_block_descriptions_id_seq'::regclass);


--
-- Name: building_blocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_blocks ALTER COLUMN id SET DEFAULT nextval('public.building_blocks_id_seq'::regclass);


--
-- Name: candidate_organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations ALTER COLUMN id SET DEFAULT nextval('public.candidate_organizations_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: deploys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys ALTER COLUMN id SET DEFAULT nextval('public.deploys_id_seq'::regclass);


--
-- Name: glossaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossaries ALTER COLUMN id SET DEFAULT nextval('public.glossaries_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: operator_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services ALTER COLUMN id SET DEFAULT nextval('public.operator_services_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: organizations_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_contacts ALTER COLUMN id SET DEFAULT nextval('public.organizations_contacts_id_seq'::regclass);


--
-- Name: organizations_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_locations ALTER COLUMN id SET DEFAULT nextval('public.organizations_locations_id_seq'::regclass);


--
-- Name: origins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.origins ALTER COLUMN id SET DEFAULT nextval('public.origins_id_seq'::regclass);


--
-- Name: product_assessments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_assessments ALTER COLUMN id SET DEFAULT nextval('public.product_assessments_id_seq'::regclass);


--
-- Name: product_product_relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships ALTER COLUMN id SET DEFAULT nextval('public.product_product_relationships_id_seq'::regclass);


--
-- Name: product_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_versions ALTER COLUMN id SET DEFAULT nextval('public.product_versions_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: sdg_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sdg_targets ALTER COLUMN id SET DEFAULT nextval('public.sdg_targets_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors ALTER COLUMN id SET DEFAULT nextval('public.sectors_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: sustainable_development_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('public.sustainable_development_goals_id_seq'::regclass);


--
-- Name: use_case_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions ALTER COLUMN id SET DEFAULT nextval('public.use_case_descriptions_id_seq'::regclass);


--
-- Name: use_cases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases ALTER COLUMN id SET DEFAULT nextval('public.use_cases_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workflow_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions ALTER COLUMN id SET DEFAULT nextval('public.workflow_descriptions_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- Name: aggregator_capabilities aggregator_capabilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT aggregator_capabilities_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: audits audits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audits
    ADD CONSTRAINT audits_pkey PRIMARY KEY (id);


--
-- Name: building_block_descriptions building_block_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_block_descriptions
    ADD CONSTRAINT building_block_descriptions_pkey PRIMARY KEY (id);


--
-- Name: building_blocks building_blocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_blocks
    ADD CONSTRAINT building_blocks_pkey PRIMARY KEY (id);


--
-- Name: candidate_organizations candidate_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations
    ADD CONSTRAINT candidate_organizations_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: deploys deploys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT deploys_pkey PRIMARY KEY (id);


--
-- Name: glossaries glossaries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossaries
    ADD CONSTRAINT glossaries_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: operator_services operator_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT operator_services_pkey PRIMARY KEY (id);


--
-- Name: organizations_contacts organizations_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_contacts
    ADD CONSTRAINT organizations_contacts_pkey PRIMARY KEY (id);


--
-- Name: organizations_locations organizations_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_locations
    ADD CONSTRAINT organizations_locations_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: origins origins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.origins
    ADD CONSTRAINT origins_pkey PRIMARY KEY (id);


--
-- Name: product_assessments product_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_assessments
    ADD CONSTRAINT product_assessments_pkey PRIMARY KEY (id);


--
-- Name: product_product_relationships product_product_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT product_product_relationships_pkey PRIMARY KEY (id);


--
-- Name: product_versions product_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_versions
    ADD CONSTRAINT product_versions_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sdg_targets sdg_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sdg_targets
    ADD CONSTRAINT sdg_targets_pkey PRIMARY KEY (id);


--
-- Name: sectors sectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors
    ADD CONSTRAINT sectors_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: sustainable_development_goals sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sustainable_development_goals
    ADD CONSTRAINT sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: use_case_descriptions use_case_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions
    ADD CONSTRAINT use_case_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_cases use_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT use_cases_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workflow_descriptions workflow_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions
    ADD CONSTRAINT workflow_descriptions_pkey PRIMARY KEY (id);


--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows
    ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);


--
-- Name: agg_cap_operator_capability_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX agg_cap_operator_capability_index ON public.aggregator_capabilities USING btree (aggregator_id, operator_services_id, capability);


--
-- Name: associated_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX associated_index ON public.audits USING btree (associated_type, associated_id);


--
-- Name: auditable_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX auditable_index ON public.audits USING btree (action, id, version);


--
-- Name: bbs_workflows; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX bbs_workflows ON public.workflows_building_blocks USING btree (building_block_id, workflow_id);


--
-- Name: block_prods; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX block_prods ON public.products_building_blocks USING btree (building_block_id, product_id);


--
-- Name: index_aggregator_capabilities_on_aggregator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_aggregator_id ON public.aggregator_capabilities USING btree (aggregator_id);


--
-- Name: index_aggregator_capabilities_on_operator_services_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_operator_services_id ON public.aggregator_capabilities USING btree (operator_services_id);


--
-- Name: index_audits_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audits_on_created_at ON public.audits USING btree (created_at);


--
-- Name: index_building_block_descriptions_on_building_block_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_building_block_descriptions_on_building_block_id ON public.building_block_descriptions USING btree (building_block_id);


--
-- Name: index_building_blocks_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_building_blocks_on_slug ON public.building_blocks USING btree (slug);


--
-- Name: index_candidate_contacts_on_candidate_id_and_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_contacts_on_candidate_id_and_contact_id ON public.candidate_organizations_contacts USING btree (candidate_organization_id, contact_id);


--
-- Name: index_candidate_contacts_on_contact_id_and_candidate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_contacts_on_contact_id_and_candidate_id ON public.candidate_organizations_contacts USING btree (contact_id, candidate_organization_id);


--
-- Name: index_candidate_organizations_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_organizations_on_approved_by_id ON public.candidate_organizations USING btree (approved_by_id);


--
-- Name: index_candidate_organizations_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_organizations_on_rejected_by_id ON public.candidate_organizations USING btree (rejected_by_id);


--
-- Name: index_contacts_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_contacts_on_slug ON public.contacts USING btree (slug);


--
-- Name: index_deploys_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deploys_on_product_id ON public.deploys USING btree (product_id);


--
-- Name: index_deploys_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_deploys_on_user_id ON public.deploys USING btree (user_id);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_slug ON public.locations USING btree (slug);


--
-- Name: index_operator_services_on_locations_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_operator_services_on_locations_id ON public.operator_services USING btree (locations_id);


--
-- Name: index_operator_services_on_name_and_locations_id_and_service; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_operator_services_on_name_and_locations_id_and_service ON public.operator_services USING btree (name, locations_id, service);


--
-- Name: index_organizations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_on_slug ON public.organizations USING btree (slug);


--
-- Name: index_organizations_products_on_organization_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_products_on_organization_id_and_product_id ON public.organizations_products USING btree (organization_id, product_id);


--
-- Name: index_organizations_products_on_product_id_and_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organizations_products_on_product_id_and_organization_id ON public.organizations_products USING btree (product_id, organization_id);


--
-- Name: index_origins_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_origins_on_organization_id ON public.origins USING btree (organization_id);


--
-- Name: index_product_assessments_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_assessments_on_product_id ON public.product_assessments USING btree (product_id);


--
-- Name: index_product_versions_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_versions_on_product_id ON public.product_versions USING btree (product_id);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_products_on_slug ON public.products USING btree (slug);


--
-- Name: index_products_sectors_on_product_id_and_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_sectors_on_product_id_and_sector_id ON public.products_sectors USING btree (product_id, sector_id);


--
-- Name: index_products_sectors_on_sector_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_sectors_on_sector_id_and_product_id ON public.products_sectors USING btree (sector_id, product_id);


--
-- Name: index_projects_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_origin_id ON public.projects USING btree (origin_id);


--
-- Name: index_sdgs_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sdgs_on_slug ON public.sustainable_development_goals USING btree (slug);


--
-- Name: index_sectors_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sectors_on_slug ON public.sectors USING btree (slug);


--
-- Name: index_use_case_descriptions_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_descriptions_on_use_case_id ON public.use_case_descriptions USING btree (use_case_id);


--
-- Name: index_use_cases_on_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_cases_on_sector_id ON public.use_cases USING btree (sector_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_workflow_descriptions_on_workflow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_workflow_descriptions_on_workflow_id ON public.workflow_descriptions USING btree (workflow_id);


--
-- Name: loc_orcs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX loc_orcs ON public.organizations_locations USING btree (location_id, organization_id);


--
-- Name: locations_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX locations_projects_idx ON public.projects_locations USING btree (location_id, project_id);


--
-- Name: org_locs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX org_locs ON public.organizations_locations USING btree (organization_id, location_id);


--
-- Name: org_sectors; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX org_sectors ON public.organizations_sectors USING btree (organization_id, sector_id);


--
-- Name: organizations_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_projects_idx ON public.projects_organizations USING btree (organization_id, project_id);


--
-- Name: origins_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX origins_products_idx ON public.products_origins USING btree (origin_id, product_id);


--
-- Name: prod_blocks; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX prod_blocks ON public.products_building_blocks USING btree (product_id, building_block_id);


--
-- Name: prod_sdgs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX prod_sdgs ON public.products_sustainable_development_goals USING btree (product_id, sustainable_development_goal_id);


--
-- Name: product_rel_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX product_rel_index ON public.product_product_relationships USING btree (from_product_id, to_product_id);


--
-- Name: products_origins_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_origins_idx ON public.products_origins USING btree (product_id, origin_id);


--
-- Name: products_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_projects_idx ON public.projects_products USING btree (product_id, project_id);


--
-- Name: products_users_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_users_idx ON public.users_products USING btree (product_id, user_id);


--
-- Name: projects_locations_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_locations_idx ON public.projects_locations USING btree (project_id, location_id);


--
-- Name: projects_organizations_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_organizations_idx ON public.projects_organizations USING btree (project_id, organization_id);


--
-- Name: projects_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_products_idx ON public.projects_products USING btree (project_id, product_id);


--
-- Name: projects_sdgs_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_sdgs_idx ON public.projects_sdgs USING btree (project_id, sdg_id);


--
-- Name: projects_sectors_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX projects_sectors_idx ON public.projects_sectors USING btree (project_id, sector_id);


--
-- Name: sdgs_prods; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sdgs_prods ON public.products_sustainable_development_goals USING btree (sustainable_development_goal_id, product_id);


--
-- Name: sdgs_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sdgs_projects_idx ON public.projects_sdgs USING btree (sdg_id, project_id);


--
-- Name: sdgs_usecases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sdgs_usecases ON public.use_cases_sdg_targets USING btree (sdg_target_id, use_case_id);


--
-- Name: sector_orcs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sector_orcs ON public.organizations_sectors USING btree (sector_id, organization_id);


--
-- Name: sectors_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX sectors_projects_idx ON public.projects_sectors USING btree (sector_id, project_id);


--
-- Name: usecases_sdgs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX usecases_sdgs ON public.use_cases_sdg_targets USING btree (use_case_id, sdg_target_id);


--
-- Name: usecases_workflows; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX usecases_workflows ON public.workflows_use_cases USING btree (use_case_id, workflow_id);


--
-- Name: user_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX user_index ON public.audits USING btree (user_id, user_role);


--
-- Name: users_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_products_idx ON public.users_products USING btree (user_id, product_id);


--
-- Name: workflows_bbs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_bbs ON public.workflows_building_blocks USING btree (workflow_id, building_block_id);


--
-- Name: workflows_usecases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_usecases ON public.workflows_use_cases USING btree (workflow_id, use_case_id);


--
-- Name: building_block_descriptions fk_rails_1e30d5f2cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.building_block_descriptions
    ADD CONSTRAINT fk_rails_1e30d5f2cb FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: deploys fk_rails_1ffce4bab2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT fk_rails_1ffce4bab2 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: candidate_organizations fk_rails_246998b230; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations
    ADD CONSTRAINT fk_rails_246998b230 FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: projects fk_rails_45a5b9baa8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_rails_45a5b9baa8 FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: product_versions fk_rails_496b84c2bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_versions
    ADD CONSTRAINT fk_rails_496b84c2bc FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: workflow_descriptions fk_rails_69d7772842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions
    ADD CONSTRAINT fk_rails_69d7772842 FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- Name: deploys fk_rails_7995634207; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT fk_rails_7995634207 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: use_case_descriptions fk_rails_94ea5f52ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions
    ADD CONSTRAINT fk_rails_94ea5f52ff FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: aggregator_capabilities fk_rails_9fcd7b6d41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_9fcd7b6d41 FOREIGN KEY (aggregator_id) REFERENCES public.organizations(id);


--
-- Name: aggregator_capabilities fk_rails_aa5b2f5e59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_aa5b2f5e59 FOREIGN KEY (operator_services_id) REFERENCES public.operator_services(id);


--
-- Name: product_assessments fk_rails_c1059f487a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_assessments
    ADD CONSTRAINT fk_rails_c1059f487a FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: candidate_organizations fk_rails_d0cf117a92; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_organizations
    ADD CONSTRAINT fk_rails_d0cf117a92 FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


--
-- Name: use_cases fk_rails_d2fed50240; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT fk_rails_d2fed50240 FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: operator_services fk_rails_e7154c9b46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT fk_rails_e7154c9b46 FOREIGN KEY (locations_id) REFERENCES public.locations(id);


--
-- Name: product_product_relationships from_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT from_product_fk FOREIGN KEY (from_product_id) REFERENCES public.products(id);


--
-- Name: organizations_contacts organizations_contacts_contact_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_contacts
    ADD CONSTRAINT organizations_contacts_contact_fk FOREIGN KEY (contact_id) REFERENCES public.contacts(id);


--
-- Name: organizations_contacts organizations_contacts_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_contacts
    ADD CONSTRAINT organizations_contacts_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organizations_locations organizations_locations_location_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_locations
    ADD CONSTRAINT organizations_locations_location_fk FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: organizations_locations organizations_locations_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_locations
    ADD CONSTRAINT organizations_locations_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organizations_products organizations_products_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_products
    ADD CONSTRAINT organizations_products_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organizations_products organizations_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_products
    ADD CONSTRAINT organizations_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: organizations_sectors organizations_sectors_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_sectors
    ADD CONSTRAINT organizations_sectors_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organizations_sectors organizations_sectors_sector_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_sectors
    ADD CONSTRAINT organizations_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: products_building_blocks products_building_blocks_building_block_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_building_blocks
    ADD CONSTRAINT products_building_blocks_building_block_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: products_building_blocks products_building_blocks_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_building_blocks
    ADD CONSTRAINT products_building_blocks_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products_origins products_origins_origin_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_origins
    ADD CONSTRAINT products_origins_origin_fk FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: products_origins products_origins_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_origins
    ADD CONSTRAINT products_origins_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products_sustainable_development_goals products_sdgs_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: products_sustainable_development_goals products_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_sdg_fk FOREIGN KEY (sustainable_development_goal_id) REFERENCES public.sustainable_development_goals(id);


--
-- Name: projects_locations projects_locations_location_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_locations
    ADD CONSTRAINT projects_locations_location_fk FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: projects_locations projects_locations_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_locations
    ADD CONSTRAINT projects_locations_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_organizations projects_organizations_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_organizations
    ADD CONSTRAINT projects_organizations_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: projects_organizations projects_organizations_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_organizations
    ADD CONSTRAINT projects_organizations_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_products projects_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_products
    ADD CONSTRAINT projects_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: projects_products projects_products_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_products
    ADD CONSTRAINT projects_products_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_sdgs projects_sdgs_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sdgs
    ADD CONSTRAINT projects_sdgs_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_sdgs projects_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sdgs
    ADD CONSTRAINT projects_sdgs_sdg_fk FOREIGN KEY (sdg_id) REFERENCES public.sustainable_development_goals(id);


--
-- Name: projects_sectors projects_sectors_project_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sectors
    ADD CONSTRAINT projects_sectors_project_fk FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: projects_sectors projects_sectors_sector_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_sectors
    ADD CONSTRAINT projects_sectors_sector_fk FOREIGN KEY (sector_id) REFERENCES public.sectors(id);


--
-- Name: product_product_relationships to_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT to_product_fk FOREIGN KEY (to_product_id) REFERENCES public.products(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_sdg_fk FOREIGN KEY (sdg_target_id) REFERENCES public.sdg_targets(id);


--
-- Name: use_cases_sdg_targets usecases_sdgs_usecase_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases_sdg_targets
    ADD CONSTRAINT usecases_sdgs_usecase_fk FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: users user_organization_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT user_organization_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: users_products users_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_products
    ADD CONSTRAINT users_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: users_products users_products_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_products
    ADD CONSTRAINT users_products_user_fk FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: workflows_building_blocks workflows_bbs_bb_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_bb_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: workflows_building_blocks workflows_bbs_workflow_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows_building_blocks
    ADD CONSTRAINT workflows_bbs_workflow_fk FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- Name: workflows_use_cases workflows_usecases_usecase_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows_use_cases
    ADD CONSTRAINT workflows_usecases_usecase_fk FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: workflows_use_cases workflows_usecases_workflow_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows_use_cases
    ADD CONSTRAINT workflows_usecases_workflow_fk FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181113155844'),
('20181116184335'),
('20190122191834'),
('20190122193631'),
('20190128214040'),
('20190329164159'),
('20190405161615'),
('20190408152727'),
('20190410153048'),
('20190413143731'),
('20190413162159'),
('20190515140930'),
('20190521161155'),
('20190521173413'),
('20190531134352'),
('20190531152352'),
('20190531152718'),
('20190531152933'),
('20190619211133'),
('20190621203306'),
('20190628163911'),
('20190709135659'),
('20190717173408'),
('20190718180634'),
('20190723183059'),
('20190724230850'),
('20190725134908'),
('20190725134957'),
('20190729131806'),
('20190730143658'),
('20190730154937'),
('20190730155346'),
('20190731195112'),
('20190801194208'),
('20190801200432'),
('20190805145805'),
('20190805161659'),
('20190909152506'),
('20190909191546'),
('20190909195732'),
('20190911150425'),
('20190911194639'),
('20190913164128'),
('20190916175633'),
('20191022134914'),
('20191028211046'),
('20191030125538'),
('20191030153507'),
('20191104191625'),
('20191111123008'),
('20191114192918'),
('20191206145611'),
('20191206150613'),
('20191210210550');


