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
-- Name: category_indicator_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.category_indicator_type AS ENUM (
    'boolean',
    'scale',
    'numeric'
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
-- Name: entity_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.entity_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED'
);


--
-- Name: filter_nav; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.filter_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'locations',
    'sectors',
    'organizations'
);


--
-- Name: location_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.location_type AS ENUM (
    'country',
    'point'
);


--
-- Name: mapping_status_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.mapping_status_type AS ENUM (
    'BETA',
    'MATURE',
    'SELF-REPORTED',
    'VALIDATED'
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
-- Name: org_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.org_type AS ENUM (
    'owner',
    'maintainer',
    'funder'
);


--
-- Name: org_type_orig; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.org_type_orig AS ENUM (
    'owner',
    'maintainer'
);


--
-- Name: product_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.product_type AS ENUM (
    'product',
    'dataset'
);


--
-- Name: relationship_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.relationship_type AS ENUM (
    'composed',
    'interoperates'
);


--
-- Name: top_nav; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.top_nav AS ENUM (
    'sdgs',
    'use_cases',
    'workflows',
    'building_blocks',
    'products',
    'projects',
    'organizations'
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
    'product_user',
    'mni',
    'content_writer',
    'content_editor'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities (
    id bigint NOT NULL,
    playbook_id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    phase character varying,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    playbook_questions_id bigint,
    "order" integer,
    media_url character varying
);


--
-- Name: activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_id_seq OWNED BY public.activities.id;


--
-- Name: activities_principles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities_principles (
    id bigint NOT NULL,
    activity_id bigint NOT NULL,
    digital_principle_id bigint NOT NULL
);


--
-- Name: activities_principles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_principles_id_seq OWNED BY public.activities_principles.id;


--
-- Name: activities_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activities_tasks (
    id bigint NOT NULL,
    activity_id bigint NOT NULL,
    task_id bigint NOT NULL
);


--
-- Name: activities_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activities_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activities_tasks_id_seq OWNED BY public.activities_tasks.id;


--
-- Name: aggregator_capabilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aggregator_capabilities (
    id bigint NOT NULL,
    aggregator_id bigint,
    operator_services_id bigint,
    service public.mobile_services,
    capability public.agg_capabilities,
    country_name character varying,
    country_id bigint
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
    building_block_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
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
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity public.entity_status_type NOT NULL
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
-- Name: candidate_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.candidate_roles (
    id bigint NOT NULL,
    email character varying NOT NULL,
    roles public.user_role[] DEFAULT '{}'::public.user_role[],
    description character varying NOT NULL,
    rejected boolean,
    rejected_date timestamp without time zone,
    rejected_by_id bigint,
    approved_date timestamp without time zone,
    approved_by_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.candidate_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: candidate_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.candidate_roles_id_seq OWNED BY public.candidate_roles.id;


--
-- Name: category_indicator_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_indicator_descriptions (
    id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    description_html character varying
);


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_indicator_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicator_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_indicator_descriptions_id_seq OWNED BY public.category_indicator_descriptions.id;


--
-- Name: category_indicators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.category_indicators (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    indicator_type public.category_indicator_type,
    weight numeric DEFAULT 0 NOT NULL,
    rubric_category_id bigint,
    data_source character varying,
    source_indicator character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: category_indicators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.category_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.category_indicators_id_seq OWNED BY public.category_indicators.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cities (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    region_id bigint,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: classifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.classifications (
    id bigint NOT NULL,
    name character varying,
    indicator character varying,
    description character varying,
    source character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: classifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.classifications_id_seq OWNED BY public.classifications.id;


--
-- Name: commontator_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commontator_comments (
    id bigint NOT NULL,
    thread_id bigint NOT NULL,
    creator_type character varying NOT NULL,
    creator_id bigint NOT NULL,
    editor_type character varying,
    editor_id bigint,
    body text NOT NULL,
    deleted_at timestamp without time zone,
    cached_votes_up integer DEFAULT 0,
    cached_votes_down integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    parent_id bigint
);


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commontator_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commontator_comments_id_seq OWNED BY public.commontator_comments.id;


--
-- Name: commontator_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commontator_subscriptions (
    id bigint NOT NULL,
    thread_id bigint NOT NULL,
    subscriber_type character varying NOT NULL,
    subscriber_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commontator_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commontator_subscriptions_id_seq OWNED BY public.commontator_subscriptions.id;


--
-- Name: commontator_threads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commontator_threads (
    id bigint NOT NULL,
    commontable_type character varying,
    commontable_id bigint,
    closer_type character varying,
    closer_id bigint,
    closed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commontator_threads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commontator_threads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commontator_threads_id_seq OWNED BY public.commontator_threads.id;


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contacts (
    id bigint NOT NULL,
    name character varying NOT NULL,
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
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    code character varying NOT NULL,
    code_longer character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


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
-- Name: digital_principles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.digital_principles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    url character varying NOT NULL
);


--
-- Name: digital_principles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.digital_principles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: digital_principles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.digital_principles_id_seq OWNED BY public.digital_principles.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.districts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    region_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.districts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- Name: glossaries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.glossaries (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
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
    location_type public.location_type NOT NULL,
    country character varying,
    city character varying,
    state character varying,
    aliases character varying[] DEFAULT '{}'::character varying[]
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
-- Name: maturity_rubric_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.maturity_rubric_descriptions (
    id bigint NOT NULL,
    maturity_rubric_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    description_html character varying
);


--
-- Name: maturity_rubric_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.maturity_rubric_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: maturity_rubric_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.maturity_rubric_descriptions_id_seq OWNED BY public.maturity_rubric_descriptions.id;


--
-- Name: maturity_rubrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.maturity_rubrics (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: maturity_rubrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.maturity_rubrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: maturity_rubrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.maturity_rubrics_id_seq OWNED BY public.maturity_rubrics.id;


--
-- Name: offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.offices (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    city character varying NOT NULL,
    organization_id bigint NOT NULL,
    region_id bigint,
    country_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: offices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.offices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: offices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.offices_id_seq OWNED BY public.offices.id;


--
-- Name: operator_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.operator_services (
    id bigint NOT NULL,
    name character varying,
    locations_id bigint,
    service public.mobile_services,
    country_id bigint,
    country_name character varying
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
-- Name: organization_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_descriptions (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_descriptions_id_seq OWNED BY public.organization_descriptions.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    when_endorsed timestamp without time zone,
    website character varying,
    is_endorser boolean DEFAULT false,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_mni boolean DEFAULT false,
    aliases character varying[] DEFAULT '{}'::character varying[]
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
-- Name: organizations_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_countries (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_countries_id_seq OWNED BY public.organizations_countries.id;


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
    id bigint NOT NULL,
    migrated boolean,
    migrated_date timestamp without time zone
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
    product_id bigint NOT NULL,
    org_type public.org_type_orig DEFAULT 'owner'::public.org_type_orig
);


--
-- Name: organizations_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_sectors (
    sector_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: organizations_states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations_states (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    region_id bigint NOT NULL
);


--
-- Name: organizations_states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_states_id_seq OWNED BY public.organizations_states.id;


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
-- Name: playbook_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbook_answers (
    id bigint NOT NULL,
    playbook_questions_id bigint,
    answer_text character varying NOT NULL,
    action character varying NOT NULL,
    object_id integer
);


--
-- Name: playbook_answers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbook_answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_answers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbook_answers_id_seq OWNED BY public.playbook_answers.id;


--
-- Name: playbook_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbook_descriptions (
    id bigint NOT NULL,
    playbook_id bigint,
    locale character varying NOT NULL,
    overview jsonb DEFAULT '{}'::jsonb NOT NULL,
    audience jsonb DEFAULT '{}'::jsonb NOT NULL,
    outcomes jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbook_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbook_descriptions_id_seq OWNED BY public.playbook_descriptions.id;


--
-- Name: playbook_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbook_questions (
    id bigint NOT NULL,
    question_text character varying NOT NULL
);


--
-- Name: playbook_questions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbook_questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbook_questions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbook_questions_id_seq OWNED BY public.playbook_questions.id;


--
-- Name: playbooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.playbooks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    phases jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    maturity character varying DEFAULT 'Beta'::character varying
);


--
-- Name: playbooks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.playbooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: playbooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.playbooks_id_seq OWNED BY public.playbooks.id;


--
-- Name: plays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    author character varying,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    version character varying DEFAULT '1.0'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: plays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_id_seq OWNED BY public.plays.id;


--
-- Name: plays_subplays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays_subplays (
    id bigint NOT NULL,
    parent_play_id bigint NOT NULL,
    child_play_id bigint NOT NULL
);


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_subplays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_subplays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_subplays_id_seq OWNED BY public.plays_subplays.id;


--
-- Name: plays_tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plays_tasks (
    id bigint NOT NULL,
    play_id bigint NOT NULL,
    task_id bigint NOT NULL
);


--
-- Name: plays_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plays_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plays_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plays_tasks_id_seq OWNED BY public.plays_tasks.id;


--
-- Name: portal_views; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.portal_views (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying NOT NULL,
    top_navs character varying[] DEFAULT '{}'::character varying[],
    filter_navs character varying[] DEFAULT '{}'::character varying[],
    user_roles character varying[] DEFAULT '{}'::character varying[],
    product_views character varying[] DEFAULT '{}'::character varying[],
    organization_views character varying[] DEFAULT '{}'::character varying[],
    subdomain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portal_views_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.portal_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portal_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.portal_views_id_seq OWNED BY public.portal_views.id;


--
-- Name: principle_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.principle_descriptions (
    id bigint NOT NULL,
    digital_principle_id bigint,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.principle_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: principle_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.principle_descriptions_id_seq OWNED BY public.principle_descriptions.id;


--
-- Name: product_building_blocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_building_blocks (
    building_block_id bigint NOT NULL,
    product_id bigint NOT NULL,
    link_type character varying DEFAULT 'Beta'::character varying,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL
);


--
-- Name: product_classifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_classifications (
    id bigint NOT NULL,
    product_id bigint,
    classification_id bigint
);


--
-- Name: product_classifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_classifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_classifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_classifications_id_seq OWNED BY public.product_classifications.id;


--
-- Name: product_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_descriptions (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_descriptions_id_seq OWNED BY public.product_descriptions.id;


--
-- Name: product_indicators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_indicators (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    category_indicator_id bigint NOT NULL,
    indicator_value character varying NOT NULL
);


--
-- Name: product_indicators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_indicators_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_indicators_id_seq OWNED BY public.product_indicators.id;


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
-- Name: product_sectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sectors (
    product_id bigint NOT NULL,
    sector_id bigint NOT NULL,
    mapping_status public.mapping_status_type DEFAULT 'BETA'::public.mapping_status_type NOT NULL
);


--
-- Name: product_suites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_suites (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: product_suites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_suites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_suites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_suites_id_seq OWNED BY public.product_suites.id;


--
-- Name: product_suites_product_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_suites_product_versions (
    product_suite_id bigint NOT NULL,
    product_version_id bigint NOT NULL
);


--
-- Name: product_sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_sustainable_development_goals (
    product_id bigint NOT NULL,
    sustainable_development_goal_id bigint NOT NULL,
    mapping_status public.mapping_status_type NOT NULL
);


--
-- Name: product_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_versions (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
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
    name character varying NOT NULL,
    slug character varying NOT NULL,
    website character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    is_launchable boolean DEFAULT false,
    start_assessment boolean DEFAULT false,
    default_url character varying DEFAULT 'http://<host_ip>'::character varying NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    repository character varying,
    license character varying,
    license_analysis character varying,
    statistics jsonb DEFAULT '{}'::jsonb NOT NULL,
    is_child boolean DEFAULT false,
    parent_product_id integer,
    tags character varying[] DEFAULT '{}'::character varying[],
    code_lines integer,
    cocomo integer,
    est_hosting integer,
    est_invested integer,
    maturity_score integer,
    product_type public.product_type DEFAULT 'product'::public.product_type,
    status character varying
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
-- Name: project_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.project_descriptions (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.project_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: project_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.project_descriptions_id_seq OWNED BY public.project_descriptions.id;


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
    slug character varying NOT NULL
);


--
-- Name: projects_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects_countries (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    country_id bigint NOT NULL
);


--
-- Name: projects_countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_countries_id_seq OWNED BY public.projects_countries.id;


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
    location_id bigint NOT NULL,
    id bigint NOT NULL,
    migrated boolean,
    migrated_date timestamp without time zone
);


--
-- Name: projects_locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_locations_id_seq OWNED BY public.projects_locations.id;


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
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    country_id bigint NOT NULL,
    latitude numeric NOT NULL,
    longitude numeric NOT NULL,
    aliases character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- Name: rubric_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rubric_categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    weight numeric DEFAULT 0 NOT NULL,
    maturity_rubric_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rubric_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rubric_categories_id_seq OWNED BY public.rubric_categories.id;


--
-- Name: rubric_category_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rubric_category_descriptions (
    id bigint NOT NULL,
    rubric_category_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    description_html character varying
);


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.rubric_category_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rubric_category_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.rubric_category_descriptions_id_seq OWNED BY public.rubric_category_descriptions.id;


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
    name character varying NOT NULL,
    target_number character varying NOT NULL,
    slug character varying,
    sdg_number integer NOT NULL,
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
    name character varying NOT NULL,
    slug character varying NOT NULL,
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
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    data text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


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
-- Name: stylesheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.stylesheets (
    id bigint NOT NULL,
    portal character varying,
    background_color character varying,
    about_page jsonb DEFAULT '{}'::jsonb NOT NULL,
    footer_content jsonb DEFAULT '{}'::jsonb NOT NULL,
    header_logo character varying
);


--
-- Name: stylesheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.stylesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stylesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.stylesheets_id_seq OWNED BY public.stylesheets.id;


--
-- Name: sustainable_development_goals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sustainable_development_goals (
    id bigint NOT NULL,
    slug character varying NOT NULL,
    name character varying NOT NULL,
    long_title character varying NOT NULL,
    number integer NOT NULL,
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
-- Name: tag_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_descriptions (
    id bigint NOT NULL,
    tag_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_descriptions_id_seq OWNED BY public.tag_descriptions.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: task_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_descriptions (
    id bigint NOT NULL,
    task_id bigint,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    prerequisites jsonb DEFAULT '{}'::jsonb NOT NULL,
    outcomes jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: task_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_descriptions_id_seq OWNED BY public.task_descriptions.id;


--
-- Name: task_tracker_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_tracker_descriptions (
    id bigint NOT NULL,
    task_tracker_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_tracker_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_tracker_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_tracker_descriptions_id_seq OWNED BY public.task_tracker_descriptions.id;


--
-- Name: task_trackers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.task_trackers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    last_run timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    message character varying NOT NULL
);


--
-- Name: task_trackers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.task_trackers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_trackers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.task_trackers_id_seq OWNED BY public.task_trackers.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description character varying,
    complete boolean DEFAULT false,
    due_date date,
    resources jsonb DEFAULT '[]'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    playbook_questions_id bigint,
    "order" integer,
    media_url character varying
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;


--
-- Name: tasks_organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks_organizations (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    organization_id bigint NOT NULL
);


--
-- Name: tasks_organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_organizations_id_seq OWNED BY public.tasks_organizations.id;


--
-- Name: tasks_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tasks_products (
    id bigint NOT NULL,
    task_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: tasks_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tasks_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tasks_products_id_seq OWNED BY public.tasks_products.id;


--
-- Name: use_case_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_descriptions (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
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
-- Name: use_case_headers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_headers (
    id bigint NOT NULL,
    use_case_id bigint NOT NULL,
    locale character varying NOT NULL,
    header jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_headers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_headers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_headers_id_seq OWNED BY public.use_case_headers.id;


--
-- Name: use_case_step_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_step_descriptions (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
);


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_step_descriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_step_descriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_step_descriptions_id_seq OWNED BY public.use_case_step_descriptions.id;


--
-- Name: use_case_steps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    step_number integer NOT NULL,
    use_case_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_steps_id_seq OWNED BY public.use_case_steps.id;


--
-- Name: use_case_steps_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps_products (
    id bigint NOT NULL,
    use_case_step_id bigint NOT NULL,
    product_id bigint NOT NULL
);


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.use_case_steps_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: use_case_steps_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.use_case_steps_products_id_seq OWNED BY public.use_case_steps_products.id;


--
-- Name: use_case_steps_workflows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_case_steps_workflows (
    use_case_step_id bigint NOT NULL,
    workflow_id bigint NOT NULL
);


--
-- Name: use_cases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.use_cases (
    id bigint NOT NULL,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    sector_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL,
    maturity public.entity_status_type NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[]
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
-- Name: user_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_events (
    id bigint NOT NULL,
    identifier character varying NOT NULL,
    email character varying,
    event_datetime timestamp without time zone NOT NULL,
    event_type character varying NOT NULL,
    extended_data jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_events_id_seq OWNED BY public.user_events.id;


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
    role public.user_role DEFAULT 'user'::public.user_role,
    receive_backup boolean DEFAULT false,
    organization_id bigint,
    expired boolean,
    expired_at timestamp without time zone,
    saved_products bigint[] DEFAULT '{}'::bigint[],
    saved_use_cases bigint[] DEFAULT '{}'::bigint[],
    saved_projects bigint[] DEFAULT '{}'::bigint[],
    saved_urls character varying[] DEFAULT '{}'::character varying[],
    roles public.user_role[] DEFAULT '{}'::public.user_role[]
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
-- Name: votes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.votes (
    id bigint NOT NULL,
    votable_type character varying,
    votable_id bigint,
    voter_type character varying,
    voter_id bigint,
    vote_flag boolean,
    vote_scope character varying,
    vote_weight integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: votes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.votes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: votes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.votes_id_seq OWNED BY public.votes.id;


--
-- Name: workflow_descriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workflow_descriptions (
    id bigint NOT NULL,
    workflow_id bigint NOT NULL,
    locale character varying NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
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
    name character varying NOT NULL,
    slug character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    description jsonb DEFAULT '{}'::jsonb NOT NULL
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
-- Name: activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities ALTER COLUMN id SET DEFAULT nextval('public.activities_id_seq'::regclass);


--
-- Name: activities_principles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_principles ALTER COLUMN id SET DEFAULT nextval('public.activities_principles_id_seq'::regclass);


--
-- Name: activities_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_tasks ALTER COLUMN id SET DEFAULT nextval('public.activities_tasks_id_seq'::regclass);


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
-- Name: candidate_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles ALTER COLUMN id SET DEFAULT nextval('public.candidate_roles_id_seq'::regclass);


--
-- Name: category_indicator_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicator_descriptions ALTER COLUMN id SET DEFAULT nextval('public.category_indicator_descriptions_id_seq'::regclass);


--
-- Name: category_indicators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicators ALTER COLUMN id SET DEFAULT nextval('public.category_indicators_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: classifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classifications ALTER COLUMN id SET DEFAULT nextval('public.classifications_id_seq'::regclass);


--
-- Name: commontator_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_comments ALTER COLUMN id SET DEFAULT nextval('public.commontator_comments_id_seq'::regclass);


--
-- Name: commontator_subscriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_subscriptions ALTER COLUMN id SET DEFAULT nextval('public.commontator_subscriptions_id_seq'::regclass);


--
-- Name: commontator_threads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_threads ALTER COLUMN id SET DEFAULT nextval('public.commontator_threads_id_seq'::regclass);


--
-- Name: contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts ALTER COLUMN id SET DEFAULT nextval('public.contacts_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: deploys id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys ALTER COLUMN id SET DEFAULT nextval('public.deploys_id_seq'::regclass);


--
-- Name: digital_principles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.digital_principles ALTER COLUMN id SET DEFAULT nextval('public.digital_principles_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- Name: glossaries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.glossaries ALTER COLUMN id SET DEFAULT nextval('public.glossaries_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: maturity_rubric_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.maturity_rubric_descriptions ALTER COLUMN id SET DEFAULT nextval('public.maturity_rubric_descriptions_id_seq'::regclass);


--
-- Name: maturity_rubrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.maturity_rubrics ALTER COLUMN id SET DEFAULT nextval('public.maturity_rubrics_id_seq'::regclass);


--
-- Name: offices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices ALTER COLUMN id SET DEFAULT nextval('public.offices_id_seq'::regclass);


--
-- Name: operator_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services ALTER COLUMN id SET DEFAULT nextval('public.operator_services_id_seq'::regclass);


--
-- Name: organization_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_descriptions ALTER COLUMN id SET DEFAULT nextval('public.organization_descriptions_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: organizations_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_contacts ALTER COLUMN id SET DEFAULT nextval('public.organizations_contacts_id_seq'::regclass);


--
-- Name: organizations_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries ALTER COLUMN id SET DEFAULT nextval('public.organizations_countries_id_seq'::regclass);


--
-- Name: organizations_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_locations ALTER COLUMN id SET DEFAULT nextval('public.organizations_locations_id_seq'::regclass);


--
-- Name: organizations_states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_states ALTER COLUMN id SET DEFAULT nextval('public.organizations_states_id_seq'::regclass);


--
-- Name: origins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.origins ALTER COLUMN id SET DEFAULT nextval('public.origins_id_seq'::regclass);


--
-- Name: playbook_answers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_answers ALTER COLUMN id SET DEFAULT nextval('public.playbook_answers_id_seq'::regclass);


--
-- Name: playbook_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_descriptions ALTER COLUMN id SET DEFAULT nextval('public.playbook_descriptions_id_seq'::regclass);


--
-- Name: playbook_questions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_questions ALTER COLUMN id SET DEFAULT nextval('public.playbook_questions_id_seq'::regclass);


--
-- Name: playbooks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbooks ALTER COLUMN id SET DEFAULT nextval('public.playbooks_id_seq'::regclass);


--
-- Name: plays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays ALTER COLUMN id SET DEFAULT nextval('public.plays_id_seq'::regclass);


--
-- Name: plays_subplays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays ALTER COLUMN id SET DEFAULT nextval('public.plays_subplays_id_seq'::regclass);


--
-- Name: plays_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_tasks ALTER COLUMN id SET DEFAULT nextval('public.plays_tasks_id_seq'::regclass);


--
-- Name: portal_views id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portal_views ALTER COLUMN id SET DEFAULT nextval('public.portal_views_id_seq'::regclass);


--
-- Name: principle_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principle_descriptions ALTER COLUMN id SET DEFAULT nextval('public.principle_descriptions_id_seq'::regclass);


--
-- Name: product_classifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications ALTER COLUMN id SET DEFAULT nextval('public.product_classifications_id_seq'::regclass);


--
-- Name: product_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_descriptions ALTER COLUMN id SET DEFAULT nextval('public.product_descriptions_id_seq'::regclass);


--
-- Name: product_indicators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators ALTER COLUMN id SET DEFAULT nextval('public.product_indicators_id_seq'::regclass);


--
-- Name: product_product_relationships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships ALTER COLUMN id SET DEFAULT nextval('public.product_product_relationships_id_seq'::regclass);


--
-- Name: product_suites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_suites ALTER COLUMN id SET DEFAULT nextval('public.product_suites_id_seq'::regclass);


--
-- Name: product_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_versions ALTER COLUMN id SET DEFAULT nextval('public.product_versions_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: project_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_descriptions ALTER COLUMN id SET DEFAULT nextval('public.project_descriptions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: projects_countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries ALTER COLUMN id SET DEFAULT nextval('public.projects_countries_id_seq'::regclass);


--
-- Name: projects_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_locations ALTER COLUMN id SET DEFAULT nextval('public.projects_locations_id_seq'::regclass);


--
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- Name: rubric_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_categories ALTER COLUMN id SET DEFAULT nextval('public.rubric_categories_id_seq'::regclass);


--
-- Name: rubric_category_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_category_descriptions ALTER COLUMN id SET DEFAULT nextval('public.rubric_category_descriptions_id_seq'::regclass);


--
-- Name: sdg_targets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sdg_targets ALTER COLUMN id SET DEFAULT nextval('public.sdg_targets_id_seq'::regclass);


--
-- Name: sectors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sectors ALTER COLUMN id SET DEFAULT nextval('public.sectors_id_seq'::regclass);


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: stylesheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stylesheets ALTER COLUMN id SET DEFAULT nextval('public.stylesheets_id_seq'::regclass);


--
-- Name: sustainable_development_goals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sustainable_development_goals ALTER COLUMN id SET DEFAULT nextval('public.sustainable_development_goals_id_seq'::regclass);


--
-- Name: tag_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_descriptions ALTER COLUMN id SET DEFAULT nextval('public.tag_descriptions_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: task_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_descriptions ALTER COLUMN id SET DEFAULT nextval('public.task_descriptions_id_seq'::regclass);


--
-- Name: task_tracker_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_tracker_descriptions ALTER COLUMN id SET DEFAULT nextval('public.task_tracker_descriptions_id_seq'::regclass);


--
-- Name: task_trackers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_trackers ALTER COLUMN id SET DEFAULT nextval('public.task_trackers_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);


--
-- Name: tasks_organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_organizations ALTER COLUMN id SET DEFAULT nextval('public.tasks_organizations_id_seq'::regclass);


--
-- Name: tasks_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_products ALTER COLUMN id SET DEFAULT nextval('public.tasks_products_id_seq'::regclass);


--
-- Name: use_case_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions ALTER COLUMN id SET DEFAULT nextval('public.use_case_descriptions_id_seq'::regclass);


--
-- Name: use_case_headers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_headers ALTER COLUMN id SET DEFAULT nextval('public.use_case_headers_id_seq'::regclass);


--
-- Name: use_case_step_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_step_descriptions ALTER COLUMN id SET DEFAULT nextval('public.use_case_step_descriptions_id_seq'::regclass);


--
-- Name: use_case_steps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps ALTER COLUMN id SET DEFAULT nextval('public.use_case_steps_id_seq'::regclass);


--
-- Name: use_case_steps_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products ALTER COLUMN id SET DEFAULT nextval('public.use_case_steps_products_id_seq'::regclass);


--
-- Name: use_cases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases ALTER COLUMN id SET DEFAULT nextval('public.use_cases_id_seq'::regclass);


--
-- Name: user_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events ALTER COLUMN id SET DEFAULT nextval('public.user_events_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: votes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes ALTER COLUMN id SET DEFAULT nextval('public.votes_id_seq'::regclass);


--
-- Name: workflow_descriptions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions ALTER COLUMN id SET DEFAULT nextval('public.workflow_descriptions_id_seq'::regclass);


--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflows ALTER COLUMN id SET DEFAULT nextval('public.workflows_id_seq'::regclass);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: activities_principles activities_principles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_principles
    ADD CONSTRAINT activities_principles_pkey PRIMARY KEY (id);


--
-- Name: activities_tasks activities_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_tasks
    ADD CONSTRAINT activities_tasks_pkey PRIMARY KEY (id);


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
-- Name: candidate_roles candidate_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT candidate_roles_pkey PRIMARY KEY (id);


--
-- Name: category_indicator_descriptions category_indicator_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicator_descriptions
    ADD CONSTRAINT category_indicator_descriptions_pkey PRIMARY KEY (id);


--
-- Name: category_indicators category_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicators
    ADD CONSTRAINT category_indicators_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: classifications classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.classifications
    ADD CONSTRAINT classifications_pkey PRIMARY KEY (id);


--
-- Name: commontator_comments commontator_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_comments
    ADD CONSTRAINT commontator_comments_pkey PRIMARY KEY (id);


--
-- Name: commontator_subscriptions commontator_subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_subscriptions
    ADD CONSTRAINT commontator_subscriptions_pkey PRIMARY KEY (id);


--
-- Name: commontator_threads commontator_threads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_threads
    ADD CONSTRAINT commontator_threads_pkey PRIMARY KEY (id);


--
-- Name: contacts contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contacts
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: deploys deploys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT deploys_pkey PRIMARY KEY (id);


--
-- Name: digital_principles digital_principles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.digital_principles
    ADD CONSTRAINT digital_principles_pkey PRIMARY KEY (id);


--
-- Name: districts districts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_pkey PRIMARY KEY (id);


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
-- Name: maturity_rubric_descriptions maturity_rubric_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.maturity_rubric_descriptions
    ADD CONSTRAINT maturity_rubric_descriptions_pkey PRIMARY KEY (id);


--
-- Name: maturity_rubrics maturity_rubrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.maturity_rubrics
    ADD CONSTRAINT maturity_rubrics_pkey PRIMARY KEY (id);


--
-- Name: offices offices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT offices_pkey PRIMARY KEY (id);


--
-- Name: operator_services operator_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT operator_services_pkey PRIMARY KEY (id);


--
-- Name: organization_descriptions organization_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_descriptions
    ADD CONSTRAINT organization_descriptions_pkey PRIMARY KEY (id);


--
-- Name: organizations_contacts organizations_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_contacts
    ADD CONSTRAINT organizations_contacts_pkey PRIMARY KEY (id);


--
-- Name: organizations_countries organizations_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries
    ADD CONSTRAINT organizations_countries_pkey PRIMARY KEY (id);


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
-- Name: organizations_states organizations_states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_states
    ADD CONSTRAINT organizations_states_pkey PRIMARY KEY (id);


--
-- Name: origins origins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.origins
    ADD CONSTRAINT origins_pkey PRIMARY KEY (id);


--
-- Name: playbook_answers playbook_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_answers
    ADD CONSTRAINT playbook_answers_pkey PRIMARY KEY (id);


--
-- Name: playbook_descriptions playbook_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_descriptions
    ADD CONSTRAINT playbook_descriptions_pkey PRIMARY KEY (id);


--
-- Name: playbook_questions playbook_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_questions
    ADD CONSTRAINT playbook_questions_pkey PRIMARY KEY (id);


--
-- Name: playbooks playbooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbooks
    ADD CONSTRAINT playbooks_pkey PRIMARY KEY (id);


--
-- Name: plays plays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays
    ADD CONSTRAINT plays_pkey PRIMARY KEY (id);


--
-- Name: plays_subplays plays_subplays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays
    ADD CONSTRAINT plays_subplays_pkey PRIMARY KEY (id);


--
-- Name: plays_tasks plays_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_tasks
    ADD CONSTRAINT plays_tasks_pkey PRIMARY KEY (id);


--
-- Name: portal_views portal_views_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portal_views
    ADD CONSTRAINT portal_views_pkey PRIMARY KEY (id);


--
-- Name: principle_descriptions principle_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principle_descriptions
    ADD CONSTRAINT principle_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_classifications product_classifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT product_classifications_pkey PRIMARY KEY (id);


--
-- Name: product_descriptions product_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_descriptions
    ADD CONSTRAINT product_descriptions_pkey PRIMARY KEY (id);


--
-- Name: product_indicators product_indicators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators
    ADD CONSTRAINT product_indicators_pkey PRIMARY KEY (id);


--
-- Name: product_product_relationships product_product_relationships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT product_product_relationships_pkey PRIMARY KEY (id);


--
-- Name: product_suites product_suites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_suites
    ADD CONSTRAINT product_suites_pkey PRIMARY KEY (id);


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
-- Name: project_descriptions project_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_descriptions
    ADD CONSTRAINT project_descriptions_pkey PRIMARY KEY (id);


--
-- Name: projects_countries projects_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries
    ADD CONSTRAINT projects_countries_pkey PRIMARY KEY (id);


--
-- Name: projects_locations projects_locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_locations
    ADD CONSTRAINT projects_locations_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: rubric_categories rubric_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_categories
    ADD CONSTRAINT rubric_categories_pkey PRIMARY KEY (id);


--
-- Name: rubric_category_descriptions rubric_category_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_category_descriptions
    ADD CONSTRAINT rubric_category_descriptions_pkey PRIMARY KEY (id);


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
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: stylesheets stylesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.stylesheets
    ADD CONSTRAINT stylesheets_pkey PRIMARY KEY (id);


--
-- Name: sustainable_development_goals sustainable_development_goals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sustainable_development_goals
    ADD CONSTRAINT sustainable_development_goals_pkey PRIMARY KEY (id);


--
-- Name: tag_descriptions tag_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_descriptions
    ADD CONSTRAINT tag_descriptions_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: task_descriptions task_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_descriptions
    ADD CONSTRAINT task_descriptions_pkey PRIMARY KEY (id);


--
-- Name: task_tracker_descriptions task_tracker_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_tracker_descriptions
    ADD CONSTRAINT task_tracker_descriptions_pkey PRIMARY KEY (id);


--
-- Name: task_trackers task_trackers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_trackers
    ADD CONSTRAINT task_trackers_pkey PRIMARY KEY (id);


--
-- Name: tasks_organizations tasks_organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_organizations
    ADD CONSTRAINT tasks_organizations_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: tasks_products tasks_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_products
    ADD CONSTRAINT tasks_products_pkey PRIMARY KEY (id);


--
-- Name: use_case_descriptions use_case_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions
    ADD CONSTRAINT use_case_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_headers use_case_headers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_headers
    ADD CONSTRAINT use_case_headers_pkey PRIMARY KEY (id);


--
-- Name: use_case_step_descriptions use_case_step_descriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_step_descriptions
    ADD CONSTRAINT use_case_step_descriptions_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps use_case_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps
    ADD CONSTRAINT use_case_steps_pkey PRIMARY KEY (id);


--
-- Name: use_case_steps_products use_case_steps_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_pkey PRIMARY KEY (id);


--
-- Name: use_cases use_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_cases
    ADD CONSTRAINT use_cases_pkey PRIMARY KEY (id);


--
-- Name: user_events user_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_events
    ADD CONSTRAINT user_events_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: votes votes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.votes
    ADD CONSTRAINT votes_pkey PRIMARY KEY (id);


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
-- Name: activities_principles_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX activities_principles_idx ON public.activities_principles USING btree (activity_id, digital_principle_id);


--
-- Name: activities_tasks_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX activities_tasks_idx ON public.activities_tasks USING btree (activity_id, task_id);


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

CREATE UNIQUE INDEX block_prods ON public.product_building_blocks USING btree (building_block_id, product_id);


--
-- Name: classifications_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX classifications_products_idx ON public.product_classifications USING btree (classification_id, product_id);


--
-- Name: index_activities_on_playbook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_playbook_id ON public.activities USING btree (playbook_id);


--
-- Name: index_activities_on_playbook_questions_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_activities_on_playbook_questions_id ON public.activities USING btree (playbook_questions_id);


--
-- Name: index_aggregator_capabilities_on_aggregator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_aggregator_id ON public.aggregator_capabilities USING btree (aggregator_id);


--
-- Name: index_aggregator_capabilities_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregator_capabilities_on_country_id ON public.aggregator_capabilities USING btree (country_id);


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
-- Name: index_candidate_roles_on_approved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_roles_on_approved_by_id ON public.candidate_roles USING btree (approved_by_id);


--
-- Name: index_candidate_roles_on_rejected_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_candidate_roles_on_rejected_by_id ON public.candidate_roles USING btree (rejected_by_id);


--
-- Name: index_category_indicator_descriptions_on_category_indicator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_indicator_descriptions_on_category_indicator_id ON public.category_indicator_descriptions USING btree (category_indicator_id);


--
-- Name: index_category_indicators_on_rubric_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_indicators_on_rubric_category_id ON public.category_indicators USING btree (rubric_category_id);


--
-- Name: index_cities_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_cities_on_region_id ON public.cities USING btree (region_id);


--
-- Name: index_commontator_comments_on_c_id_and_c_type_and_t_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_c_id_and_c_type_and_t_id ON public.commontator_comments USING btree (creator_id, creator_type, thread_id);


--
-- Name: index_commontator_comments_on_cached_votes_down; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_cached_votes_down ON public.commontator_comments USING btree (cached_votes_down);


--
-- Name: index_commontator_comments_on_cached_votes_up; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_cached_votes_up ON public.commontator_comments USING btree (cached_votes_up);


--
-- Name: index_commontator_comments_on_editor_type_and_editor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_editor_type_and_editor_id ON public.commontator_comments USING btree (editor_type, editor_id);


--
-- Name: index_commontator_comments_on_parent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_parent_id ON public.commontator_comments USING btree (parent_id);


--
-- Name: index_commontator_comments_on_thread_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_comments_on_thread_id_and_created_at ON public.commontator_comments USING btree (thread_id, created_at);


--
-- Name: index_commontator_subscriptions_on_s_id_and_s_type_and_t_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_commontator_subscriptions_on_s_id_and_s_type_and_t_id ON public.commontator_subscriptions USING btree (subscriber_id, subscriber_type, thread_id);


--
-- Name: index_commontator_subscriptions_on_thread_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_subscriptions_on_thread_id ON public.commontator_subscriptions USING btree (thread_id);


--
-- Name: index_commontator_threads_on_c_id_and_c_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_commontator_threads_on_c_id_and_c_type ON public.commontator_threads USING btree (commontable_type, commontable_id);


--
-- Name: index_commontator_threads_on_closer_type_and_closer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commontator_threads_on_closer_type_and_closer_id ON public.commontator_threads USING btree (closer_type, closer_id);


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
-- Name: index_districts_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_districts_on_region_id ON public.districts USING btree (region_id);


--
-- Name: index_locations_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_locations_on_slug ON public.locations USING btree (slug);


--
-- Name: index_maturity_rubric_descriptions_on_maturity_rubric_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_maturity_rubric_descriptions_on_maturity_rubric_id ON public.maturity_rubric_descriptions USING btree (maturity_rubric_id);


--
-- Name: index_offices_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offices_on_country_id ON public.offices USING btree (country_id);


--
-- Name: index_offices_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offices_on_organization_id ON public.offices USING btree (organization_id);


--
-- Name: index_offices_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_offices_on_region_id ON public.offices USING btree (region_id);


--
-- Name: index_operator_services_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_operator_services_on_country_id ON public.operator_services USING btree (country_id);


--
-- Name: index_operator_services_on_locations_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_operator_services_on_locations_id ON public.operator_services USING btree (locations_id);


--
-- Name: index_operator_services_on_name_and_locations_id_and_service; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_operator_services_on_name_and_locations_id_and_service ON public.operator_services USING btree (name, locations_id, service);


--
-- Name: index_organization_descriptions_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_descriptions_on_organization_id ON public.organization_descriptions USING btree (organization_id);


--
-- Name: index_organizations_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_countries_on_country_id ON public.organizations_countries USING btree (country_id);


--
-- Name: index_organizations_countries_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_countries_on_organization_id ON public.organizations_countries USING btree (organization_id);


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
-- Name: index_organizations_states_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_states_on_organization_id ON public.organizations_states USING btree (organization_id);


--
-- Name: index_organizations_states_on_region_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_states_on_region_id ON public.organizations_states USING btree (region_id);


--
-- Name: index_origins_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_origins_on_organization_id ON public.origins USING btree (organization_id);


--
-- Name: index_playbook_answers_on_playbook_questions_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playbook_answers_on_playbook_questions_id ON public.playbook_answers USING btree (playbook_questions_id);


--
-- Name: index_playbook_descriptions_on_playbook_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_playbook_descriptions_on_playbook_id ON public.playbook_descriptions USING btree (playbook_id);


--
-- Name: index_principle_descriptions_on_digital_principle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_principle_descriptions_on_digital_principle_id ON public.principle_descriptions USING btree (digital_principle_id);


--
-- Name: index_product_classifications_on_classification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_classifications_on_classification_id ON public.product_classifications USING btree (classification_id);


--
-- Name: index_product_classifications_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_classifications_on_product_id ON public.product_classifications USING btree (product_id);


--
-- Name: index_product_descriptions_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_descriptions_on_product_id ON public.product_descriptions USING btree (product_id);


--
-- Name: index_product_indicators_on_category_indicator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_indicators_on_category_indicator_id ON public.product_indicators USING btree (category_indicator_id);


--
-- Name: index_product_indicators_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_indicators_on_product_id ON public.product_indicators USING btree (product_id);


--
-- Name: index_product_sectors_on_product_id_and_sector_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_sectors_on_product_id_and_sector_id ON public.product_sectors USING btree (product_id, sector_id);


--
-- Name: index_product_sectors_on_sector_id_and_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_sectors_on_sector_id_and_product_id ON public.product_sectors USING btree (sector_id, product_id);


--
-- Name: index_product_versions_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_product_versions_on_product_id ON public.product_versions USING btree (product_id);


--
-- Name: index_products_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_products_on_slug ON public.products USING btree (slug);


--
-- Name: index_project_descriptions_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_project_descriptions_on_project_id ON public.project_descriptions USING btree (project_id);


--
-- Name: index_projects_countries_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_countries_on_country_id ON public.projects_countries USING btree (country_id);


--
-- Name: index_projects_countries_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_countries_on_project_id ON public.projects_countries USING btree (project_id);


--
-- Name: index_projects_on_origin_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_projects_on_origin_id ON public.projects USING btree (origin_id);


--
-- Name: index_regions_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_regions_on_country_id ON public.regions USING btree (country_id);


--
-- Name: index_rubric_categories_on_maturity_rubric_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rubric_categories_on_maturity_rubric_id ON public.rubric_categories USING btree (maturity_rubric_id);


--
-- Name: index_rubric_category_descriptions_on_rubric_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_rubric_category_descriptions_on_rubric_category_id ON public.rubric_category_descriptions USING btree (rubric_category_id);


--
-- Name: index_sdgs_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sdgs_on_slug ON public.sustainable_development_goals USING btree (slug);


--
-- Name: index_sectors_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sectors_on_slug ON public.sectors USING btree (slug);


--
-- Name: index_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sessions_on_session_id ON public.sessions USING btree (session_id);


--
-- Name: index_sessions_on_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sessions_on_updated_at ON public.sessions USING btree (updated_at);


--
-- Name: index_tag_descriptions_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_descriptions_on_tag_id ON public.tag_descriptions USING btree (tag_id);


--
-- Name: index_task_descriptions_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_task_descriptions_on_task_id ON public.task_descriptions USING btree (task_id);


--
-- Name: index_task_tracker_descriptions_on_task_tracker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_task_tracker_descriptions_on_task_tracker_id ON public.task_tracker_descriptions USING btree (task_tracker_id);


--
-- Name: index_tasks_on_playbook_questions_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_playbook_questions_id ON public.tasks USING btree (playbook_questions_id);


--
-- Name: index_use_case_descriptions_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_descriptions_on_use_case_id ON public.use_case_descriptions USING btree (use_case_id);


--
-- Name: index_use_case_headers_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_headers_on_use_case_id ON public.use_case_headers USING btree (use_case_id);


--
-- Name: index_use_case_step_descriptions_on_use_case_step_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_step_descriptions_on_use_case_step_id ON public.use_case_step_descriptions USING btree (use_case_step_id);


--
-- Name: index_use_case_steps_on_use_case_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_use_case_steps_on_use_case_id ON public.use_case_steps USING btree (use_case_id);


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
-- Name: index_votes_on_votable_id_and_votable_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_votable_id_and_votable_type_and_vote_scope ON public.votes USING btree (votable_id, votable_type, vote_scope);


--
-- Name: index_votes_on_votable_type_and_votable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_votable_type_and_votable_id ON public.votes USING btree (votable_type, votable_id);


--
-- Name: index_votes_on_voter_id_and_voter_type_and_vote_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_voter_id_and_voter_type_and_vote_scope ON public.votes USING btree (voter_id, voter_type, vote_scope);


--
-- Name: index_votes_on_voter_type_and_voter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_votes_on_voter_type_and_voter_id ON public.votes USING btree (voter_type, voter_id);


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
-- Name: organizations_plays_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_plays_idx ON public.tasks_organizations USING btree (organization_id, task_id);


--
-- Name: organizations_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_projects_idx ON public.projects_organizations USING btree (organization_id, project_id);


--
-- Name: origins_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX origins_products_idx ON public.products_origins USING btree (origin_id, product_id);


--
-- Name: play_rel_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX play_rel_index ON public.plays_subplays USING btree (parent_play_id, child_play_id);


--
-- Name: plays_organizations_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX plays_organizations_idx ON public.tasks_organizations USING btree (task_id, organization_id);


--
-- Name: plays_tasks_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX plays_tasks_idx ON public.plays_tasks USING btree (play_id, task_id);


--
-- Name: principles_activities_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX principles_activities_idx ON public.activities_principles USING btree (digital_principle_id, activity_id);


--
-- Name: prod_blocks; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX prod_blocks ON public.product_building_blocks USING btree (product_id, building_block_id);


--
-- Name: prod_sdgs; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX prod_sdgs ON public.product_sustainable_development_goals USING btree (product_id, sustainable_development_goal_id);


--
-- Name: product_rel_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX product_rel_index ON public.product_product_relationships USING btree (from_product_id, to_product_id);


--
-- Name: product_suites_products_versions; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_suites_products_versions ON public.product_suites_product_versions USING btree (product_suite_id, product_version_id);


--
-- Name: products_classifications_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_classifications_idx ON public.product_classifications USING btree (product_id, classification_id);


--
-- Name: products_origins_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_origins_idx ON public.products_origins USING btree (product_id, origin_id);


--
-- Name: products_projects_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_projects_idx ON public.projects_products USING btree (product_id, project_id);


--
-- Name: products_tasks_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_tasks_idx ON public.tasks_products USING btree (product_id, task_id);


--
-- Name: products_use_case_steps_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_use_case_steps_idx ON public.use_case_steps_products USING btree (product_id, use_case_step_id);


--
-- Name: products_users_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_users_idx ON public.users_products USING btree (product_id, user_id);


--
-- Name: products_versions_product_suites; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_versions_product_suites ON public.product_suites_product_versions USING btree (product_version_id, product_suite_id);


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

CREATE UNIQUE INDEX sdgs_prods ON public.product_sustainable_development_goals USING btree (sustainable_development_goal_id, product_id);


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
-- Name: tasks_activities_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tasks_activities_idx ON public.activities_tasks USING btree (task_id, activity_id);


--
-- Name: tasks_plays_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tasks_plays_idx ON public.plays_tasks USING btree (task_id, play_id);


--
-- Name: tasks_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tasks_products_idx ON public.tasks_products USING btree (task_id, product_id);


--
-- Name: use_case_steps_products_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_products_idx ON public.use_case_steps_products USING btree (use_case_step_id, product_id);


--
-- Name: use_case_steps_workflows_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX use_case_steps_workflows_idx ON public.use_case_steps_workflows USING btree (use_case_step_id, workflow_id);


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
-- Name: workflows_use_case_steps_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_use_case_steps_idx ON public.use_case_steps_workflows USING btree (workflow_id, use_case_step_id);


--
-- Name: workflows_usecases; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX workflows_usecases ON public.workflows_use_cases USING btree (workflow_id, use_case_id);


--
-- Name: activities_tasks activities_tasks_activity_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_tasks
    ADD CONSTRAINT activities_tasks_activity_fk FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: activities_tasks activities_tasks_task_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_tasks
    ADD CONSTRAINT activities_tasks_task_fk FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: plays_subplays child_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays
    ADD CONSTRAINT child_play_fk FOREIGN KEY (child_play_id) REFERENCES public.plays(id);


--
-- Name: districts fk_rails_002fc30497; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT fk_rails_002fc30497 FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: organizations_states fk_rails_059564ad33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_states
    ADD CONSTRAINT fk_rails_059564ad33 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: offices fk_rails_0722c0e4f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT fk_rails_0722c0e4f7 FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: playbook_descriptions fk_rails_08320ee34e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_descriptions
    ADD CONSTRAINT fk_rails_08320ee34e FOREIGN KEY (playbook_id) REFERENCES public.playbooks(id);


--
-- Name: offices fk_rails_08e10b87a1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT fk_rails_08e10b87a1 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: product_classifications fk_rails_16035b6309; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT fk_rails_16035b6309 FOREIGN KEY (classification_id) REFERENCES public.classifications(id);


--
-- Name: use_case_steps fk_rails_1ab85a3bb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps
    ADD CONSTRAINT fk_rails_1ab85a3bb6 FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: maturity_rubric_descriptions fk_rails_1c75e9f6a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.maturity_rubric_descriptions
    ADD CONSTRAINT fk_rails_1c75e9f6a4 FOREIGN KEY (maturity_rubric_id) REFERENCES public.maturity_rubrics(id);


--
-- Name: candidate_roles fk_rails_1c91ae1dbd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_1c91ae1dbd FOREIGN KEY (approved_by_id) REFERENCES public.users(id);


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
-- Name: product_indicators fk_rails_2c154e19b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators
    ADD CONSTRAINT fk_rails_2c154e19b9 FOREIGN KEY (category_indicator_id) REFERENCES public.category_indicators(id);


--
-- Name: organization_descriptions fk_rails_3a6b8edce9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_descriptions
    ADD CONSTRAINT fk_rails_3a6b8edce9 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: projects fk_rails_45a5b9baa8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT fk_rails_45a5b9baa8 FOREIGN KEY (origin_id) REFERENCES public.origins(id);


--
-- Name: tag_descriptions fk_rails_46e6dc893e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_descriptions
    ADD CONSTRAINT fk_rails_46e6dc893e FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: product_versions fk_rails_496b84c2bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_versions
    ADD CONSTRAINT fk_rails_496b84c2bc FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: rubric_categories fk_rails_49a0635e83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_categories
    ADD CONSTRAINT fk_rails_49a0635e83 FOREIGN KEY (maturity_rubric_id) REFERENCES public.maturity_rubrics(id);


--
-- Name: commontator_comments fk_rails_558e599d00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_comments
    ADD CONSTRAINT fk_rails_558e599d00 FOREIGN KEY (parent_id) REFERENCES public.commontator_comments(id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: operator_services fk_rails_5c31270ff7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT fk_rails_5c31270ff7 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: organizations_countries fk_rails_61354fe2dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries
    ADD CONSTRAINT fk_rails_61354fe2dd FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: offices fk_rails_63e101f453; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.offices
    ADD CONSTRAINT fk_rails_63e101f453 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: activities fk_rails_640012801c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT fk_rails_640012801c FOREIGN KEY (playbook_questions_id) REFERENCES public.playbook_questions(id);


--
-- Name: task_tracker_descriptions fk_rails_64d4c2c34c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_tracker_descriptions
    ADD CONSTRAINT fk_rails_64d4c2c34c FOREIGN KEY (task_tracker_id) REFERENCES public.task_trackers(id);


--
-- Name: category_indicator_descriptions fk_rails_664858eff1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicator_descriptions
    ADD CONSTRAINT fk_rails_664858eff1 FOREIGN KEY (category_indicator_id) REFERENCES public.category_indicators(id);


--
-- Name: playbook_answers fk_rails_67580b7df5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.playbook_answers
    ADD CONSTRAINT fk_rails_67580b7df5 FOREIGN KEY (playbook_questions_id) REFERENCES public.playbook_questions(id);


--
-- Name: commontator_subscriptions fk_rails_68cc24d064; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_subscriptions
    ADD CONSTRAINT fk_rails_68cc24d064 FOREIGN KEY (thread_id) REFERENCES public.commontator_threads(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: workflow_descriptions fk_rails_69d7772842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workflow_descriptions
    ADD CONSTRAINT fk_rails_69d7772842 FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


--
-- Name: activities fk_rails_71e8ecd19b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT fk_rails_71e8ecd19b FOREIGN KEY (playbook_id) REFERENCES public.playbooks(id);


--
-- Name: product_indicators fk_rails_721e0e4ba1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_indicators
    ADD CONSTRAINT fk_rails_721e0e4ba1 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: category_indicators fk_rails_72ff36837c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.category_indicators
    ADD CONSTRAINT fk_rails_72ff36837c FOREIGN KEY (rubric_category_id) REFERENCES public.rubric_categories(id);


--
-- Name: projects_countries fk_rails_7940afe1fe; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries
    ADD CONSTRAINT fk_rails_7940afe1fe FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: deploys fk_rails_7995634207; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deploys
    ADD CONSTRAINT fk_rails_7995634207 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: use_case_step_descriptions fk_rails_7c6b0affba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_step_descriptions
    ADD CONSTRAINT fk_rails_7c6b0affba FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: rubric_category_descriptions fk_rails_7f79ec6842; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rubric_category_descriptions
    ADD CONSTRAINT fk_rails_7f79ec6842 FOREIGN KEY (rubric_category_id) REFERENCES public.rubric_categories(id);


--
-- Name: candidate_roles fk_rails_80a7b4e918; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.candidate_roles
    ADD CONSTRAINT fk_rails_80a7b4e918 FOREIGN KEY (rejected_by_id) REFERENCES public.users(id);


--
-- Name: projects_countries fk_rails_8fcd9cd60b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects_countries
    ADD CONSTRAINT fk_rails_8fcd9cd60b FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: project_descriptions fk_rails_94cabf0709; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.project_descriptions
    ADD CONSTRAINT fk_rails_94cabf0709 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: use_case_descriptions fk_rails_94ea5f52ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_descriptions
    ADD CONSTRAINT fk_rails_94ea5f52ff FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: commontator_comments fk_rails_96666eb19a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commontator_comments
    ADD CONSTRAINT fk_rails_96666eb19a FOREIGN KEY (thread_id) REFERENCES public.commontator_threads(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: aggregator_capabilities fk_rails_9fcd7b6d41; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_9fcd7b6d41 FOREIGN KEY (aggregator_id) REFERENCES public.organizations(id);


--
-- Name: organizations_countries fk_rails_a044fbacef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_countries
    ADD CONSTRAINT fk_rails_a044fbacef FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: aggregator_capabilities fk_rails_aa5b2f5e59; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_aa5b2f5e59 FOREIGN KEY (operator_services_id) REFERENCES public.operator_services(id);


--
-- Name: organizations_states fk_rails_bea3577035; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations_states
    ADD CONSTRAINT fk_rails_bea3577035 FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: product_descriptions fk_rails_c0bc9f9c8a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_descriptions
    ADD CONSTRAINT fk_rails_c0bc9f9c8a FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: task_descriptions fk_rails_c4ba71a3ee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.task_descriptions
    ADD CONSTRAINT fk_rails_c4ba71a3ee FOREIGN KEY (task_id) REFERENCES public.tasks(id);


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
-- Name: product_classifications fk_rails_d5306b6dc7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT fk_rails_d5306b6dc7 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: use_case_headers fk_rails_de4b7a8ac2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_headers
    ADD CONSTRAINT fk_rails_de4b7a8ac2 FOREIGN KEY (use_case_id) REFERENCES public.use_cases(id);


--
-- Name: cities fk_rails_e0ef2914ca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT fk_rails_e0ef2914ca FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- Name: operator_services fk_rails_e7154c9b46; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.operator_services
    ADD CONSTRAINT fk_rails_e7154c9b46 FOREIGN KEY (locations_id) REFERENCES public.locations(id);


--
-- Name: aggregator_capabilities fk_rails_ee0ee7b8e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aggregator_capabilities
    ADD CONSTRAINT fk_rails_ee0ee7b8e7 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: principle_descriptions fk_rails_f1497d5d96; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.principle_descriptions
    ADD CONSTRAINT fk_rails_f1497d5d96 FOREIGN KEY (digital_principle_id) REFERENCES public.digital_principles(id);


--
-- Name: regions fk_rails_f2ba72ccee; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT fk_rails_f2ba72ccee FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: tasks fk_rails_f4d905c069; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT fk_rails_f4d905c069 FOREIGN KEY (playbook_questions_id) REFERENCES public.playbook_questions(id);


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
-- Name: tasks_organizations organizations_tasks_org_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_organizations
    ADD CONSTRAINT organizations_tasks_org_fk FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: tasks_organizations organizations_tasks_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_organizations
    ADD CONSTRAINT organizations_tasks_play_fk FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: plays_subplays parent_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_subplays
    ADD CONSTRAINT parent_play_fk FOREIGN KEY (parent_play_id) REFERENCES public.plays(id);


--
-- Name: activities_principles principles_activities_phase_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_principles
    ADD CONSTRAINT principles_activities_phase_fk FOREIGN KEY (activity_id) REFERENCES public.activities(id);


--
-- Name: activities_principles principles_activities_principle_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activities_principles
    ADD CONSTRAINT principles_activities_principle_fk FOREIGN KEY (digital_principle_id) REFERENCES public.digital_principles(id);


--
-- Name: product_classifications product_classifications_classification_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT product_classifications_classification_fk FOREIGN KEY (classification_id) REFERENCES public.classifications(id);


--
-- Name: product_classifications product_classifications_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_classifications
    ADD CONSTRAINT product_classifications_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_building_blocks products_building_blocks_building_block_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_building_blocks
    ADD CONSTRAINT products_building_blocks_building_block_fk FOREIGN KEY (building_block_id) REFERENCES public.building_blocks(id);


--
-- Name: product_building_blocks products_building_blocks_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_building_blocks
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
-- Name: product_sustainable_development_goals products_sdgs_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: product_sustainable_development_goals products_sdgs_sdg_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_sustainable_development_goals
    ADD CONSTRAINT products_sdgs_sdg_fk FOREIGN KEY (sustainable_development_goal_id) REFERENCES public.sustainable_development_goals(id);


--
-- Name: tasks_products products_tasks_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_products
    ADD CONSTRAINT products_tasks_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: tasks_products products_tasks_task_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tasks_products
    ADD CONSTRAINT products_tasks_task_fk FOREIGN KEY (task_id) REFERENCES public.tasks(id);


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
-- Name: product_suites_product_versions pspv_product_suites_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_suites_product_versions
    ADD CONSTRAINT pspv_product_suites_fk FOREIGN KEY (product_suite_id) REFERENCES public.product_suites(id);


--
-- Name: product_suites_product_versions pspv_product_versions_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_suites_product_versions
    ADD CONSTRAINT pspv_product_versions_fk FOREIGN KEY (product_version_id) REFERENCES public.product_versions(id);


--
-- Name: plays_tasks tasks_plays_play_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_tasks
    ADD CONSTRAINT tasks_plays_play_fk FOREIGN KEY (play_id) REFERENCES public.plays(id);


--
-- Name: plays_tasks tasks_plays_task_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plays_tasks
    ADD CONSTRAINT tasks_plays_task_fk FOREIGN KEY (task_id) REFERENCES public.tasks(id);


--
-- Name: product_product_relationships to_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_product_relationships
    ADD CONSTRAINT to_product_fk FOREIGN KEY (to_product_id) REFERENCES public.products(id);


--
-- Name: use_case_steps_products use_case_steps_products_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_product_fk FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: use_case_steps_products use_case_steps_products_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_products
    ADD CONSTRAINT use_case_steps_products_step_fk FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_step_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_step_fk FOREIGN KEY (use_case_step_id) REFERENCES public.use_case_steps(id);


--
-- Name: use_case_steps_workflows use_case_steps_workflows_workflow_fk; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.use_case_steps_workflows
    ADD CONSTRAINT use_case_steps_workflows_workflow_fk FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);


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
('20191210210550'),
('20200105125805'),
('20200107135217'),
('20200110151548'),
('20200128154358'),
('20200128204056'),
('20200130220904'),
('20200130221126'),
('20200205210606'),
('20200218150006'),
('20200220202959'),
('20200220203026'),
('20200224225410'),
('20200224225415'),
('20200303191546'),
('20200318153113'),
('20200403183400'),
('20200408151430'),
('20200409175231'),
('20200410181908'),
('20200413175913'),
('20200413181640'),
('20200415182207'),
('20200415182431'),
('20200416142235'),
('20200428155300'),
('20200428234311'),
('20200429220626'),
('20200501143924'),
('20200503141314'),
('20200506174132'),
('20200506174133'),
('20200506175410'),
('20200506193433'),
('20200506193935'),
('20200506194951'),
('20200506195001'),
('20200515185037'),
('20200515191241'),
('20200515191251'),
('20200520192948'),
('20200521210943'),
('20200522192632'),
('20200522194438'),
('20200526195946'),
('20200526203504'),
('20200603140902'),
('20200608194733'),
('20200609130507'),
('20200617174313'),
('20200617174358'),
('20200617174412'),
('20200619171341'),
('20200619172658'),
('20200619172716'),
('20200623203503'),
('20200624170721'),
('20200624212546'),
('20200624212630'),
('20200707130426'),
('20200707130945'),
('20200708180807'),
('20200708181616'),
('20200710205315'),
('20200710205316'),
('20200710210144'),
('20200727155410'),
('20200729150759'),
('20200729202732'),
('20200730195836'),
('20200804184953'),
('20200811135839'),
('20200811142114'),
('20200811143421'),
('20200811150942'),
('20200811181245'),
('20200812012621'),
('20200812012757'),
('20200812014644'),
('20200812014739'),
('20200812015747'),
('20200812155025'),
('20200814184009'),
('20200818202930'),
('20200818203509');



